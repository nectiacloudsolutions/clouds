/*********************************************************************************************************
@Author       gcabrerp@everis.com
@name         FileUploadCaseHelper
@CreateDate   01/12/2020
@Description  W-001092 - (Portabilidad Financiera)  
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
01/12/2020                    gcabrerp@everis.com                 Initial Version
**********************************************************************************************************/
public class FileUploadCaseHelper {	 
    
    private final static String PF_SOL_FIRMA = Label.PF_Opp_Sol_Firmada;
    private final static String PF_CERT_LIQ = Label.PF_Opp_Cert_Liq;
    private final static String PF_CAD = Label.PF_Opp_CAD;
    public static List<DocumentosAlfresco__c> lstDocsAlf  {get; set;}
    private static Map<String,DocumentosAlfresco__c> docsAlfMap;
    
    public static void uploadHelper(String body, String IdDocs, id idRecord, String sourceip){
        loadSettings();
        List<Object_Related_Document__c> lstDoc = [select External_Id__c,Name,  Caso_Relacionado__c, Tipo_Documento__c, Id, LastModifiedDate, LastModifiedBy.Name from Object_Related_Document__c where Id IN (: IdDocs)];
        List<Opportunity> opp = [select Sol_Firmada_PF__c, PF_Cert_Liq_Adjuntado__c, PF_CAD_recibido__c from OPPORTUNITY WHERE Caso_PF__c = : idRecord];
        boolean flag = true;
    
        for(Object_Related_Document__c objLst : lstDoc ){
            
            if(String.valueOf(objLst.Tipo_Documento__c)==PF_SOL_FIRMA || String.valueOf(objLst.Tipo_Documento__c)==PF_CERT_LIQ || String.valueOf(objLst.Tipo_Documento__c)== PF_CAD){
                
                for(Opportunity oppLst : opp){
                    updateCheck(String.valueOf(objLst.Tipo_Documento__c),oppLst.id,flag);
                }     
            }
            if(docsAlfMap.get(objLst.Tipo_Documento__c).Escritura__c == 'INTEGRACION_OUT_CUMBRES' ){
                sendCallout(idRecord, body, sourceip);
            }
        }
    }
    
    
    @Future(callout=true)
    public static void sendCallout(id idRecord,string body,String sourceip){
        
        User rutEjc = [select RUT__c from user where id=:userinfo.getuserid()];
        List<case> lstCase = [SELECT Id, Account.Rut__c, OwnerId, CaseNumber, Caso_PF_Rut_ejecutivo_referidor__c  FROM Case WHERE Id = : idRecord];
        
        FileUploadRequest psReq = (FileUploadRequest) System.JSON.deserialize(body, FileUploadRequest.class); 
        
        for(Case lstcse : lstCase){
                    psReq.idSolicitudSaleforce = lstcse.CaseNumber;
                }
        psReq.rutEjecutivo = rutEjc.RUT__c;
   
        SalesCallout sc = new SalesCallout('CUMBRES2');
        sc.sourceip = sourceip; 
        String response = sc.callServiceCumbres(JSON.serialize(psReq));
    }
    
    public class FileUploadRequest {
        
        Public String rutEjecutivo {get;set;}
        Public String idSolicitudSaleforce {get;set;}
        Public String idCasoSalesforce {get;set;}
        Public String dataDoc {get;set;}
    }
    
    
    
    public static List<DocumentosAlfresco__c> loadSettings(){
        if(lstDocsAlf == null){
            lstDocsAlf = [select  Name, NombreDocumento__c, OrigenDocumento__c, Lectura__c, Escritura__c from DocumentosAlfresco__c];
        }
        docsAlfMap = new Map<String,DocumentosAlfresco__c>();
        for(DocumentosAlfresco__c doc:lstDocsAlf){
            docsAlfMap.put(doc.NombreDocumento__c, doc);
        }
        return lstDocsAlf;
    }
    
    public static void updateCheck(String tipoDoc, id idOpp, boolean flag){
        Opportunity opp = [select Sol_Firmada_PF__c, PF_Cert_Liq_Adjuntado__c, PF_CAD_recibido__c from OPPORTUNITY WHERE id = : idOpp];

        if(tipoDoc==PF_SOL_FIRMA){
            opp.Sol_Firmada_PF__c = flag;
            update opp;
        } else if(tipoDoc==PF_CERT_LIQ){
            opp.PF_Cert_Liq_Adjuntado__c = flag;
            update opp;
        } else if(tipoDoc==PF_CAD){
            opp.PF_CAD_recibido__c = flag;
            update opp;
        }

    }
    
}