/*********************************************************************************************************
@Author       cagonzle@everis.com
@name         ObjectRelatedDocumentHelper
@CreateDate   30/09/2020
@Description  Implementation of Alfresco Integration  
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
30/09/2020                    cagonzle@everis.com          			Implementacion PF
**********************************************************************************************************/
public with sharing class ObjectRelatedDocumentHelper {

    private static final String ORIGEN_PF = 'Portabilidad Financiera Entrada';//'Portabilidad';
   
    public static Map<String, Object_Related_Document__c> objRelDocMap {get; set;}
    public static List<DocumentosAlfresco__c> docAlfresco  {get; set;}
    public static Set<String> autoLoadDocs  {get; set;}
    
    public static List<DocumentosAlfresco__c> loadSettings(String origen){
		if(docAlfresco == null){
			docAlfresco = [select NombreDocumento__c, Name, Lectura__c, Escritura__c from DocumentosAlfresco__c where OrigenDocumento__c =: origen order by OrdenListDoc__c asc ];
            autoLoadDocs = new Set<String>();
            for(DocumentosAlfresco__c da : docAlfresco){
                if(da.Escritura__c == 'INTEGRACION'){
                    autoLoadDocs.add(da.NombreDocumento__c);
                }
            }
		}
        return docAlfresco;
    }

    public static Object_Related_Document__c getRecord(String sKey){
        if(objRelDocMap.containsKey(sKey.toLowerCase())){
            return objRelDocMap.get(sKey.toLowerCase());
        }else{
        	Object_Related_Document__c newDocLog = new Object_Related_Document__c();
            objRelDocMap.put(sKey.toLowerCase(),newDocLog);
            return newDocLog;
        }
    }

    public static void matchRecords(Id idObj, String objField, String origen){

		loadSettings(origen);
        if(objRelDocMap == null){
            objRelDocMap = new Map<String,Object_Related_Document__c>();
            
            String query = 'SELECT Tipo_Documento__c, Aprobado__c, Check_Documento__c, Detalle_Documento__c, Estado_Documento__c, Id_Alfresco__c, Motivo_Rechazo__c, ' +
                'Orden_Documento__c, Fecha_Carga_Alfresco__c, ' + objField + ' ' +
                'FROM Object_Related_Document__c WHERE '+objField+' = \''+idObj+'\'';
            String sKey = '';

            List<Object_Related_Document__c> docuObj = new List<Object_Related_Document__c>();
            try{
                docuObj = database.query(query);
            }catch(Exception e){
                docuObj = new List<Object_Related_Document__c>();
            }

            for(Object_Related_Document__c obj : docuObj){
                sKey = obj.Tipo_Documento__c;
                objRelDocMap.put(sKey.toLowerCase(), obj);
            }
            
            List<Object_Related_Document__c> lstDocsLog = new List<Object_Related_Document__c>();
            Object_Related_Document__c objLog;     
            for (DocumentosAlfresco__c docum : docAlfresco){
                objLog = getRecord(docum.NombreDocumento__c);
                if(objLog.Id == null){
                	objLog.Caso_Relacionado__c = idObj;
                    objLog.Tipo_Documento__c = docum.NombreDocumento__c;
                    objLog.External_Id__c = idObj + '-' + docum.NombreDocumento__c;
                    lstDocsLog.add(objLog);
                }
            }
            
            if (!lstDocsLog.isEmpty()){
                upsert lstDocsLog; 
            }
        }
    }

    public static List<ResponseDTOAlfresco> createLogDocPF(List<Attachment> lstAtt, String sourceip){
        
        ObjectRelatedDocumentHelper.loadSettings(ORIGEN_PF);
        Set<Id> lstIds = new Set<Id>();        
        List<ResponseDTOAlfresco> lstDtoAlf = new List<ResponseDTOAlfresco>();
       
        for(Attachment att : lstAtt){
            lstIds.add(att.ParentId);
        } 
         
        if(lstIds.size() > 0){
            Map<Id, Case> mapCaseByAtt = new Map<Id, Case>();
            for(Case caso : [SELECT AccountId, Account.Rut__c FROM Case WHERE Id IN: lstIds]){
                mapCaseByAtt.put(caso.Id, caso);
            }	            
            List<Object_Related_Document__c> lstDocsLog = new List<Object_Related_Document__c>();
            Set<String> attIdSet = new Set<String>();
            
            for(Attachment att : lstAtt){
                FileUploadServiceController.sourceIp = sourceip;
                ResponseDTOAlfresco response = FileUploadServiceController.invokeUploadAlfresco(att, new List<Case>{mapCaseByAtt.get(att.ParentId)});		
                lstDtoAlf.add(response);

                Object_Related_Document__c ord = createDocsOftrigger(response, att.ParentId, 'Caso_Relacionado__c', att);
                if(ord != null){ if(ord.External_Id__c != null){ lstDocsLog.add(ord); } }                 
            }

            if(lstDocsLog.size() > 0 ){
                Upsert lstDocsLog External_Id__c;
            }           
        }
        return lstDtoAlf;
    }
    
    public static Object_Related_Document__c createDocsOftrigger(ResponseDTOAlfresco response, ID idObj, String apiObj, Attachment a){
        Date myDate = Date.today();
        Object_Related_Document__c objLog = new Object_Related_Document__c();
        
        if(response.salidaAlfresco!=null){            
            if (response.salidaAlfresco.idAlfresco!='' && response.salidaAlfresco.idAlfresco!=null) {
                objLog.put(apiObj, idObj);
                objLog.Tipo_Documento__c = a.Description;
                objLog.External_Id__c = idObj + '-' + a.Description;
                objLog.Estado_Documento__c = 'Ingresado';
                objLog.Id_Alfresco__c = response.salidaAlfresco.idAlfresco;
                objLog.Fecha_Carga_Alfresco__c = myDate;
                objlog.Id_Doc_Attachment__c = a.Id;
            }
        }
        return objLog;
    }
}