global class ReportCmfE04 implements Database.Batchable<sObject>, Database.Stateful {

    global String csvColumnHeader;
    global List<String> csvRowValues = new List<String>();

    global Database.QueryLocator start(Database.BatchableContext BC){

        String RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Casos_Banco').getRecordTypeId();
        
        String query = 'SELECT CaseNumber, Rut_del_Cliente__c, Origin, CreatedDate, ClosedDate, Clasificaci_n_SBIF_nectia__c '+
                        'FROM Case '+
                        'WHERE '+
                        '    RecordTypeId= \''+RecordTypeId+'\' AND' +
                        '    Tipo_Auxiliar__c=\'Reclamo\' AND '+
                        '    CreatedDate = LAST_MONTH';
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> listCase){
        List <Codigo_Origen_CMF__mdt> cmfCodes = [SELECT MasterLabel, value__c FROM Codigo_Origen_CMF__mdt];
        String rut;
        String clasificationCodeCmf;
        String closeDate;

        for(Case c : (List<case>) listCase){

            if(c.Rut_del_Cliente__c != null && c.Rut_del_Cliente__c.contains('-')) { 
                rut = c.Rut_del_Cliente__c.remove('-');
            } else{
                rut = c.Rut_del_Cliente__c;
            }

            List<String>  cSplit;
            if (c.Clasificaci_n_SBIF_nectia__c == null || c.Clasificaci_n_SBIF_nectia__c==''){                
                clasificationCodeCmf = c.Clasificaci_n_SBIF_nectia__c;
            }else{
                cSplit = c.Clasificaci_n_SBIF_nectia__c.split(' ');
                clasificationCodeCmf = cSplit[0];
            }

            if(String.isBlank(String.Valueof(c.ClosedDate))){
                closeDate = '00000000';
            }else{
                closeDate = c.ClosedDate.format('yyyyMMdd');
            }

            String cmfCode = UtilitiesSales.homologateCode(c.Origin, cmfCodes);
            String rowStr = '055,' + rut + ',' + c.CaseNumber  +','+ clasificationCodeCmf +',' + cmfCode + ','+ c.CreatedDate.format('yyyyMMdd')+','+ closeDate;
            csvRowValues.add(rowStr);
        }
    }

    global void finish(Database.BatchableContext BC){
        String documentName = 'ReportE04-'+ Datetime.now().format('MMM') + Datetime.now().year();
        csvColumnHeader = 'COD_INST,RUT,NUM_REC,CLAS_REC,VIA_ING,F_RECEP,F_CIERRE\n';
        String csvFile = csvColumnHeader + String.join(csvRowValues,'\n');
        
        blob csvBlob = Blob.valueOf(csvFile);

        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = documentName + '.csv';
        String ReportTitle = 'Report E04-'+ Datetime.now().month()+'-'+ Datetime.now().year();
        conVer.Title = ReportTitle;
        conVer.VersionData = csvBlob;
        insert conVer;

        UtilitiesSales.shareFileToUserProfile(conVer.Id);
    }

}