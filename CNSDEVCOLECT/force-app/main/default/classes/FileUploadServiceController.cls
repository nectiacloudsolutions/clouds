/**
* @description       : 
* @author            : eayalcor@everis.com
* @group             : 
* @last modified on  : 08-18-2020
* @last modified by  : eayalcor@everis.com
* Modifications Log 
* Ver   Date         Author                Modification
* 1.0   08-18-2020   eayalcor@everis.com   Initial Version
**/
public without sharing class FileUploadServiceController {
    
    public static String sourceIp {get;set;} // Mejora para metodos futuros;
    
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        
        insert oAttachment;
        
        return oAttachment.Id;
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        
        update a;
    }
    
    
    public static ResponseDTOAlfresco invokeUploadAlfresco(Attachment a, List<Case> lstCase) {
        
        
        RequestDTOAlfresco request = new RequestDTOAlfresco();
        ResponseDTOAlfresco response = new ResponseDTOAlfresco();
        
        
        RequestDTOAlfresco.Entrada entrada = new  RequestDTOAlfresco.Entrada();
        RequestDTOAlfresco.dtoRequestSetParametros dtoRequestSetParametros = new RequestDTOAlfresco.dtoRequestSetParametros();
        RequestDTOAlfresco.SubirArchivo subirArchivo = new RequestDTOAlfresco.SubirArchivo();
        
        entrada.codigoProducto = 'LALA';
        entrada.numeroProducto = '1';
        entrada.fecha = date.today().format();
        entrada.nombreArchivo = lstCase[0].Account.Rut__c + a.Name + String.valueof(DateTime.now().getTime());
        entrada.contentType = a.ContentType;
        entrada.rutCliente = lstCase[0].Account.Rut__c;
        entrada.bytes = EncodingUtil.base64Encode(a.Body);
        
        subirArchivo.entrada  = entrada;
        dtoRequestSetParametros.subirArchivo = subirArchivo;
        request.dtoRequestSetParametros = dtoRequestSetParametros;
        
        SalesCallout sc = new SalesCallout(CONSTANTS.ALFRESCO);
        if(sourceIp != null){ sc.sourceIp = sourceIp; } // Mejora Metodo Future
        response = sc.uploadFileAlfresco(request);
        
        
        
        System.debug('Response Alfresco ====> '+response);
        return response;
        
    }
    @AuraEnabled
    public static string validateTypeClient(id caseId){
        System.debug('Id =>>>'+caseId);
        String typeClient;
        
        List<Case> lstCase=[select Id,Account.Cliente_Banco__c,Account.Cliente_Corredora__c, Account.Cliente_Seguros__c from Case where Id =:caseId];
        if((lstCase[0].Account.Cliente_Banco__c ||lstCase[0].Account.Cliente_Corredora__c)&& !lstCase[0].Account.Cliente_Seguros__c){
            typeClient='Alfresco';
        }else if(!lstCase[0].Account.Cliente_Banco__c &&!lstCase[0].Account.Cliente_Corredora__c && lstCase[0].Account.Cliente_Seguros__c){
            typeClient='Docuware';
        }else if(!lstCase[0].Account.Cliente_Banco__c &&!lstCase[0].Account.Cliente_Corredora__c && !lstCase[0].Account.Cliente_Seguros__c){
            typeClient='Docuware';
        }else{
            typeClient='Ambos';
        }
        return typeClient;
    }
    
    @AuraEnabled
    public static ObjErrors callDocumentManager(Id caseId,Id fileId){
        System.debug('Id =>>>'+caseId);
        Boolean uploadOk = false;
        String json;
        String typeClient = validateTypeClient(caseId);
        Attachment attach = [SELECT Id, Name,Body,ContentType FROM Attachment WHERE Id =: fileId];
        List<Case> lstCase=[SELECT Id, Account.Rut__c, OwnerId,CaseNumber FROM Case WHERE Id = : caseId];
        ResponseDTOAlfresco responseAlfresco = new ResponseDTOAlfresco();
        DTODocuware.ResponseUploadDocuware responseDocuware = new DTODocuware.ResponseUploadDocuware();
        ObjErrors WrapperErrors= new ObjErrors();
        
        if(typeClient=='Alfresco'){
            responseAlfresco = invokeUploadAlfresco(attach,lstCase);
            if(responseAlfresco.salidaAlfresco == null){ 
                ResponseDTOAlfresco.SalidaAlfresco sAlfresco = new ResponseDTOAlfresco.SalidaAlfresco(); 
                sAlfresco.idAlfresco = null;
                responseAlfresco.salidaAlfresco = sAlfresco;
            }
            json='{"dwDocId": -1,"mensajeServicio": "NOK","codigoServicio": "0","mensaje": "Ha ocurrido un error, contacte su administrador","codigo": "0000"}';
            responseDocuware=(DTODocuware.ResponseUploadDocuware) System.JSON.deserialize(json, DTODocuware.ResponseUploadDocuware.class);
        }else if(typeClient=='Docuware'){
            responseDocuware = invocableUploadDocuware(attach,lstCase);
            json='{"dtoResponseCodigosEstadoHttp":{"codigo":"200","mensaje":"ERROR","descripcion":"Error Request"},"dtoResponseSetParametros":{"codigoError":"301","msjError":"Ha ocurrido un error inesperado en la ejecucion"},"salidaAlfresco":{"codigo":"400","idAlfresco":"MOCK","mensaje":"Ha ocurrido un problema - Contacte con el Administrador"}}';
            responseAlfresco=(ResponseDTOAlfresco) System.JSON.deserialize(json, ResponseDTOAlfresco.class);
        }else{
            responseDocuware = invocableUploadDocuware(attach,lstCase);
            responseAlfresco = invokeUploadAlfresco(attach,lstCase);   
            if(responseAlfresco.salidaAlfresco == null){ 
                ResponseDTOAlfresco.SalidaAlfresco sAlfresco = new ResponseDTOAlfresco.SalidaAlfresco(); 
                sAlfresco.idAlfresco = null;
                responseAlfresco.salidaAlfresco = sAlfresco;
            }
        }
        
        //Validación 

        if((responseAlfresco.salidaAlfresco.idAlfresco != null && responseAlfresco.DtoResponseCodigosEstadoHttp.codigo =='200') && 
           (responseDocuware.dwDocId != null && responseDocuware.codigoServicio =='0')){
               uploadOk = true;
               lstCase[0].id_docuware_sales__c = responseDocuware.dwDocId==-1? null : String.valueOf(responseDocuware.dwDocId);
               lstCase[0].id_alfresco_caso_sales__c = responseAlfresco.salidaAlfresco.idAlfresco== 'MOCK' ? null : responseAlfresco.salidaAlfresco.idAlfresco;
               
           }else if((responseAlfresco.salidaAlfresco.idAlfresco == null && responseAlfresco.DtoResponseCodigosEstadoHttp.codigo !='200') && 
                    (responseDocuware.dwDocId !=null && responseDocuware.codigoServicio =='0')){
                        WrapperErrors.isError=true;
                        WrapperErrors.codeError = 'ERRA01';
                        WrapperErrors.msj = 'Alfresco - Error: ' + responseAlfresco.DtoResponseCodigosEstadoHttp.mensaje;  
                        uploadOk = true;
                        lstCase[0].id_docuware_sales__c = String.valueOf(responseDocuware.dwDocId);
                        
                    }else if((responseAlfresco.salidaAlfresco.idAlfresco != null && responseAlfresco.DtoResponseCodigosEstadoHttp.codigo =='200') && 
                             (responseDocuware.dwDocId ==null && responseDocuware.codigoServicio !='0')){
                                 WrapperErrors.isError=true;
                                 WrapperErrors.codeError = 'ERRA02';
                                 WrapperErrors.msj = 'Docuware - Error: ' + responseDocuware.mensaje; 
                                 uploadOk = true;
                                 lstCase[0].id_alfresco_caso_sales__c = responseAlfresco.salidaAlfresco.idAlfresco;
                             }else{
                                 WrapperErrors.isError=true;
                                 WrapperErrors.codeError = 'ERRA03';
                                 WrapperErrors.msj= 'Docuware - Error: ' + responseDocuware.mensaje + '/ Alfresco - Error: ' + responseAlfresco.DtoResponseCodigosEstadoHttp.mensaje ;    
                             }  

        
        
        System.debug('WRAPPER ----->' + WrapperErrors);
        lstCase[0].fecha_documento__c = DateTIME.now();        
        lstCase[0].Casos_con_Documento__c= uploadOk;
        update lstCase;
        delete attach;
        
        return WrapperErrors;
        
    }
    
    
    public static DTODocuware.ResponseUploadDocuware invocableUploadDocuware(Attachment a, List<Case> lstCase){
        List<DocuwareMetadata__c> lsMetadata = [SELECT Index_Label__c,Index_value__c FROM DocuwareMetadata__c                                                
                                                WHERE Type_Index_List__c = : Constants.XML_INDICES];        
        Map<String,String> mapMetadata = new Map<String,String>();
        
        for(DocuwareMetadata__c metaData : lsMetadata){           
            if(metaData.Index_Label__c.equalsIgnoreCase(Constants.INDICE_CLIENTE)){                
                metaData.Index_value__c = lstCase[0].Account.Rut__c;// Aqui se envia el rut de la cuenta.                
            }else if(metaData.Index_Label__C.equalsIgnoreCase(Constants.INDICE_PROCESO)){
                metaData.Index_value__c = lstCase[0].CaseNumber;// Aqui se envia el numero del caso
            } 
            mapMetadata.put(metaData.Index_Label__c,metaData.Index_value__c);            
        }
        
        DTODocuware.RequestUploadDocuware request = new DTODocuware.RequestUploadDocuware();        
        request.archivador = Constants.CARPETA_DIGITAL_CLIENTE;        
        request.xmlIndices = UtilitiesSales.generateMetadataDocuware(mapMetadata);        
        request.extension = Constants.EXTENSION_PDF;
        request.contenido = EncodingUtil.base64Encode(a.Body);//AQUI SE ENVIA BASE64
        
        System.debug('Request: '+request);
        
        
        SalesCallout sc = new Salescallout(Constants.DOCUWARE);    
        DTODocuware.ResponseUploadDocuware response = sc.uploadFileDocuware(request);
        
        //lstCase[0].id_docuware_sales__c = String.valueOf(response.dwDocId);
        //update lstCase;
        
        System.debug('response DOCUWARE: '+response);
        return response;
    }
    
    
    @AuraEnabled
    public static boolean validateManagerId(){
        
        Boolean managerOk;
        List<User> lstUser= [SELECT id,managerId FROM User WHERE id=:UserInfo.getUserId()];
        if(lstUser[0].managerId!=null){
            managerOk=false;  
        }else{
            managerOk=true;
        }
        return managerOk;
    }
    
    public class ObjErrors {
        @AuraEnabled public Boolean isError = false;
        @AuraEnabled public String codeError {get;set;}
        @AuraEnabled public string msj { get;set; }
    }
}