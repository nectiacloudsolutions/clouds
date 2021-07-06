global class ReportCmfE05 implements Database.Batchable<sObject>, Database.Stateful {

    global String csvColumnHeader;
    global List<String> csvRowValuesE05 = new List<String>();

    global Database.QueryLocator start(Database.BatchableContext BC){

        MilestoneType mType = [select id FROM MilestoneType where name = 'Gestión de caso'];
        String RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Casos_Banco').getRecordTypeId();
        
        String query = 'SELECT Id, CaseNumber, Tipo_de_producto_banco__c, Subtipo_Auxiliar__c, Rut_del_Cliente__c, Origin, CreatedDate,(SELECT startDate FROM CaseMilestones where MilestoneTypeid = \''+mType.id+'\') ' +
                        'FROM Case ' +
                        'WHERE ' +
                        '    RecordTypeId= \''+RecordTypeId+'\' AND' +
                        '    Tipo_Auxiliar__c=\'Solicitud\' AND ' +
                        '    (Tipo_de_producto_banco__c=\'Tarjeta de Crédito\' OR ' +
                        '    Tipo_de_producto_banco__c=\'Tarjeta de Débito\' OR ' +
                        '    Tipo_de_producto_banco__c=\'Cuenta Corriente\' OR ' +
                        '    Tipo_de_producto_banco__c=\'Línea de crédito\' OR ' +
                        '    Tipo_de_producto_banco__c=\'Cuenta Vista\' OR ' +
                        '    Tipo_de_producto_banco__c=\'Multiproducto\') AND ' +
                        '    (Subtipo_Auxiliar__c = \'Cierre TC\' OR ' +
                        '    Subtipo_Auxiliar__c = \'Cierre de cuenta Corriente\' OR ' +
                        '    Subtipo_Auxiliar__c = \'Cierre de Línea de Crédito\' OR ' +
                        '    Subtipo_Auxiliar__c = \'Cierre de cuenta\') AND ' +
                        '    CreatedDate = LAST_MONTH';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> listCase){

        List <Codigo_Origen_CMF__mdt> cmfCodes = [SELECT MasterLabel, value__c FROM Codigo_Origen_CMF__mdt];
        String rut;
        Datetime openDate; 
        
        for(Case c : (List<case>) listCase){

            if(c.Rut_del_Cliente__c != null && c.Rut_del_Cliente__c.contains('-')) { 
                rut = c.Rut_del_Cliente__c.remove('-');
            } else{
                rut = c.Rut_del_Cliente__c;
            }

            if(c.Tipo_de_producto_banco__c == 'Cuenta Corriente' && c.Subtipo_Auxiliar__c=='Cierre de cuenta Corriente'){
                //CaseMilestone v = c.CaseMilestones;
                if ( !c.CaseMilestones.isEmpty()) {
                    system.debug(c.CaseMilestones[0].startDate);
                    openDate = c.CaseMilestones[0].startDate; 
                }else{
                    openDate = c.CreatedDate;
                }
            }else{
                openDate = c.CreatedDate;
            }
   
            String cmfCode = UtilitiesSales.homologateCode(c.Origin, cmfCodes);
            String rowStr = c.CaseNumber + ',' + rut + ',' + c.Subtipo_Auxiliar__c + ',' + cmfCode + ','+ openDate.format('yyyy-MM-dd')+','+ c.Tipo_de_producto_banco__c;
            
            csvRowValuesE05.add(rowStr);
        }
    }

    global void finish(Database.BatchableContext BC){
        String documentName = 'ReportE05-'+ Datetime.now().format('MMM') + Datetime.now().year();
        csvColumnHeader = 'Numero del caso,Rut del Cliene,Subtipo*,Origen del caso,Fecha de apertura,Tipo de productor\n';
        String csvFile = csvColumnHeader + String.join(csvRowValuesE05,'\n');
        
        blob csvBlob = Blob.valueOf(csvFile);

        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = documentName + '.csv';
        String ReportTitle = 'Report E05-'+ Datetime.now().month()+'-'+ Datetime.now().year();
        conVer.Title = ReportTitle;
        conVer.VersionData = csvBlob;
        insert conVer;

        UtilitiesSales.shareFileToUserProfile(conVer.Id);        

    }

}