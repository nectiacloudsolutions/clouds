/*********************************************************************************************************
@Author       lmunogar@everis.com
@name         PortabilidadDocsController
@CreateDate   15/09/2020
@Description  Controller que tramita los documentos de Portabilidad Financiera 
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
15/09/2020                    lmunogar@everis.com          
**********************************************************************************************************/
public without sharing class PortabilidadDocsController {
    
    /*
* 
* @description       This method return the necessary data for the doInit method 
* @param1            Id (del tipo de registro que se consultarán los documentos, puede ser Case, Oportunidad, etc.)
* @return            dataWrapper 
* @throws            NA
*/      
    private static final String sobjectCASE = 'Case';
    private static final String sobjectOPPORTUNITY = 'Opportunity'; // Corregir Nombre para que funcione en Oppty
    public static String docType;
    private static Id oppRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('RT_Portabilidad_financiera').getRecordTypeId();

    @AuraEnabled 
    public static dataWrapper getData(Id recordIdObject, String sObjectType, String CSType) {
        docType = CSType;
        dataWrapper dWrapper = new dataWrapper();

        List<Map<String, Object>> outputList = new List<Map<String, Object>>();
        Map<String, Object> mapDocum = new Map<String, Object>();
        dataWrapperDetail detDocum = new dataWrapperDetail();
        
        List<dataWrapperDetail> detDocLst = new List<dataWrapperDetail>();
        
        objectConfig objectconfig = getObjectConfig(recordIdObject, sObjectType);

        if(objectconfig == null){
            return dWrapper;
        }

        string valoresBtn='';
        // se consulta la información de los DOCUMENTOS al objeto generico.
		ObjectRelatedDocumentHelper.matchRecords(objectconfig.recordIdObject, objectconfig.retatedField, objectconfig.filterDocType);
        Map<String, Object_Related_Document__c> objRelDocMap = ObjectRelatedDocumentHelper.objRelDocMap;
		List<DocumentosAlfresco__c> docAlfresco = ObjectRelatedDocumentHelper.docAlfresco;
        Object_Related_Document__c objLog;
		String escritura = '';
        system.debug('test '+docAlfresco);
        for (DocumentosAlfresco__c docum : docAlfresco){
            
            detDocum = new dataWrapperDetail();
			valoresBtn='t,t,t';

            objLog = ObjectRelatedDocumentHelper.getRecord(docum.NombreDocumento__c);
			escritura =  docum.Escritura__c;
            detDocum.needConfirm = false;

            if (objectconfig.IsReadOnly){ 
                valoresBtn = String.isBlank(objLog.Id_Alfresco__c) ? 't,t,t' : 't,t,f';
            }else{
                if (escritura == 'NO' || escritura == 'INTEGRACION'){
                    valoresBtn = 't,t,f';
                    valoresBtn = String.isBlank(objLog.Id_Alfresco__c) ? 't,t,t' : valoresBtn;
                }else if (escritura.startsWith('INTEGRACION_OUT_') ){
                    detDocum.needConfirm = true;
                    valoresBtn = 't,t,f';
                    valoresBtn = String.isBlank(objLog.Id_Alfresco__c) ? 'f,t,t' : valoresBtn;                    
                }else{
                    valoresBtn = String.isBlank(objLog.Id_Alfresco__c) ? 'f,t,t' : 't,f,f';
                }
            }
                
            detDocum.actionBtnDoc = valoresBtn;
            detDocum.nombreDoc = docum.NombreDocumento__c;
            detDocum.nameDocCod = docum.Name;

            detDocum.idRecord = objectconfig.RecordIdObject;//////////
            detDocum.idDoc = objLog.Id;
            detDocum.idAlfresco = objLog.Id_Alfresco__c;
            detDocum.fechaCarga = objLog.Fecha_Carga_Alfresco__c;
            detDocum.estadoDoc = objLog.Estado_Documento__c;
            detDocum.sObjectType = sObjectType;

            detDocLst.add(detDocum);
        }
        
        mapDocum.put('documentsList', detDocLst);
        outputList.add(mapDocum);
        dWrapper.documentosList = outputList;

        return dWrapper;
    }
    
    /*
* @description       response class for the getData Method
* @throws            NA
*/
    public class dataWrapperDetail {
        @AuraEnabled public Id idRecord; ///////////
        @AuraEnabled public String actionBtnDoc;
        @AuraEnabled public String nombreDoc;
        @AuraEnabled public String nameDocCod;
        @AuraEnabled public String idDoc;
        @AuraEnabled public String idAlfresco;
        @AuraEnabled public Date fechaCarga;
        @AuraEnabled public String estadoDoc;
        @AuraEnabled public Boolean needConfirm;
        @AuraEnabled public String sObjectType;
        
    }   
    
    public class objectConfig {
        public Id recordIdObject;
        public String retatedField;
        public String filterDocType;
        public Boolean isReadOnly;
    }   
    public class dataWrapper {
        @AuraEnabled public List<Map<String, Object>> documentosList;
    }   

    public static objectConfig getObjectConfig(Id recordIdObject, String sObjectType){
        objectConfig objectconfig = new objectConfig();
		objectconfig.isReadOnly = false; // default 
        //IsReadOnly: Bloquea los campos para la subida y eliminanción. Si el archivo existe permite visualizar
        //RetatedField: Nombre del campo del objeto para filtrar en Object_Related_Document__c
        //FilterDocType: Filtro OrigenDocumento__c en Obj: DocumentosAlfresco__c
        //RecordIdObject: Id del registro asociado al documento

        /// validar opciones de acuerdo a object
        ///Objeto Caso
        if(sObjectType == sobjectCASE){ 
            objectconfig.isReadOnly = true; // debe quedar en false para que no se puedan subir documentos en CASE
            objectconfig.retatedField = 'Caso_Relacionado__c';
            objectconfig.recordIdObject = recordIdObject;

            Case caseQuery = [Select Subtipo__c, Status, (Select Id From Oportunidades__r Where RecordTypeId =: oppRT) from Case where id =: recordIdObject];
            objectconfig.FilterDocType =  caseQuery.Subtipo__c;
            if(caseQuery.Oportunidades__r.size() == 0){objectconfig.isReadOnly = false;}
        } 
        ///Objeto Oportunidad
        else if (sObjectType == sobjectOPPORTUNITY) {
            objectconfig.RetatedField = 'Caso_Relacionado__c';

            Opportunity opptyRelatedToCase = [select Caso_PF__c, StageName  from Opportunity where Id = :recordIdObject];
            objectconfig.recordIdObject = opptyRelatedToCase.Caso_PF__c;

            if(opptyRelatedToCase.StageName == 'Cierre Ganada' || opptyRelatedToCase.StageName == 'Cierre Perdida'){
                objectconfig.isReadOnly = true; 
            }else{
                objectconfig.isReadOnly = false; 
            }


            Case caseQuery = [Select Subtipo__c,Status from Case where id = :objectconfig.recordIdObject];
            objectconfig.filterDocType =  caseQuery.Subtipo__c;
        }
        /// sObject
        else {
            objectconfig.RetatedField = 'Caso_Relacionado__c';
            if(docType!=null && docType.equals('Documento_Formalizacion')){
            	objectconfig.recordIdObject = [SELECT Opportunity.Caso_PF__c FROM OpportunityLineItem WHERE Id =: recordIdObject].Opportunity.Caso_PF__c;
            }
        }

       	objectconfig.filterDocType = (String.isBlank(docType) ? objectconfig.filterDocType : docType );
        system.debug('test '+objectconfig.filterDocType);
        return objectconfig;
    }
}