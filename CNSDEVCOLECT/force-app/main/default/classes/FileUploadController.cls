/**
 * @description       : 
 * @author            : eayalcor@everis.com
 * @group             : 
 * @last modified on  : 07-08-2020
 * @last modified by  : eayalcor@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   07-06-2020   eayalcor@everis.com   Initial Version
 * 1.1   07-08-2020   pcelisbe@everis.com
**/
public with sharing class FileUploadController {
 
  
    /**
    * @description 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 07-08-2020 
    * @param IdOpp 
    * @param fileId 
    * @param IdDocs 
    * @return ResponseDTOAlfresco 
    **/
    @AuraEnabled
    public static ResponseDTOAlfresco invokeUploadAlfresco(Id IdOpp, Id fileId, Id IdDocs) {
        Attachment a = [
            SELECT Id, Name,Body,ContentType
            FROM Attachment
            WHERE Id =: fileId
        ];

        RequestDTOAlfresco request = new RequestDTOAlfresco();
        ResponseDTOAlfresco response = new ResponseDTOAlfresco();
        
        
        List<Opportunity> lstOpp = [SELECT Id, Account.Rut__c FROM Opportunity WHERE Id = : IdOpp];
        RequestDTOAlfresco.Entrada entrada = new  RequestDTOAlfresco.Entrada();
        RequestDTOAlfresco.dtoRequestSetParametros dtoRequestSetParametros = new RequestDTOAlfresco.dtoRequestSetParametros();
        RequestDTOAlfresco.SubirArchivo subirArchivo = new RequestDTOAlfresco.SubirArchivo();

        entrada.codigoProducto = 'LALA';
        entrada.numeroProducto = '1';
        entrada.fecha = date.today().format();
        entrada.nombreArchivo = lstOpp[0].Account.Rut__c + a.Name + String.valueof(DateTime.now().getTime());
        entrada.contentType = a.ContentType;
        entrada.rutCliente = lstOpp[0].Account.Rut__c;
        entrada.bytes = EncodingUtil.base64Encode(a.Body);

        subirArchivo.entrada  = entrada;
        dtoRequestSetParametros.subirArchivo = subirArchivo;
        request.dtoRequestSetParametros = dtoRequestSetParametros;

        SalesCallout sc = new SalesCallout(CONSTANTS.ALFRESCO);
        response = sc.uploadFileAlfresco(request);

        delete a;
        if(response.salidaAlfresco!=null){
            if (response.salidaAlfresco.idAlfresco!='' &&response.salidaAlfresco.idAlfresco!=null) {
                updateDocs(IdDocs,response.salidaAlfresco.idAlfresco,'Ingresado');
            }
        }
        
        return response;
        
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 07-08-2020 
    * @param Id parentId 
    * @param String fileName 
    * @param String base64Data 
    * @param String contentType 
    * @param String fileId 
    * @return Id 
    **/
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

    /**
    * @description 
    * @author eayalcor@everis.com | 07-08-2020 
    * @param Id parentId 
    * @param String fileName 
    * @param String base64Data 
    * @param String contentType 
    * @return Id 
    **/
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

    /**
    * @description 
    * @author eayalcor@everis.com | 07-08-2020 
    * @param Id fileId 
    * @param String base64Data 
    **/
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

    /**
    * @description 
    * @author eayalcor@everis.com | 07-08-2020 
    * @param Id IdDocs 
    * @param String IdAlfresco 
    * @param String EstadoDoc 
    **/
    @AuraEnabled
    public static void updateDocs(Id IdDocs, String IdAlfresco,String EstadoDoc){

        try {
            documento_oportunidad_sales__c oppDoc = new documento_oportunidad_sales__c();
            oppDoc.Id= IdDocs;
            oppDoc.estado_documento_sales__c = EstadoDoc;
            oppDoc.Id_Alfresco_sales__c=IdAlfresco;
            update oppDoc;

        } catch(Exception e) {
            System.debug( e);
        }
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 07-08-2020 
    * @return ResponseDTOAlfresco 
    **/
    @AuraEnabled
    public static ResponseDTOAlfresco viewDoc(Id idDoc){

        RequestDTOAlfresco request = new RequestDTOAlfresco();
        ResponseDTOAlfresco response = new ResponseDTOAlfresco();

        List<documento_oportunidad_sales__c> lstDocs = [SELECT Id,Id_Alfresco_sales__c, opportunity_sales__r.Account.Rut__c 
                                FROM documento_oportunidad_sales__c WHERE Id =: idDoc];
        RequestDTOAlfresco.ConsultaDoc consultar = new RequestDTOAlfresco.ConsultaDoc();
        RequestDTOAlfresco.dtoRequestSetParametros dtoRequestSetParametros = new RequestDTOAlfresco.dtoRequestSetParametros();
        if (lstDocs[0].Id_Alfresco_sales__c!='' && lstDocs[0].Id_Alfresco_sales__c!=null) {
            consultar.idAlfresco = lstDocs[0].Id_Alfresco_sales__c;
            consultar.rutCliente = lstDocs[0].opportunity_sales__r.Account.Rut__c;
            dtoRequestSetParametros.ConsultaDoc = consultar;
            request.dtoRequestSetParametros = dtoRequestSetParametros;
            SalesCallout sc = new SalesCallout(CONSTANTS.ALFRESCO);
            response = sc.viewFileAlfresco(request);
        
        }else {

            ResponseDTOAlfresco.DtoResponseSetParametros rspSetParamet = new ResponseDTOAlfresco.DtoResponseSetParametros();
            rspSetParamet.codigoError='999';
            rspSetParamet.msjError='No posee Archivo cargado';
            response.dtoResponseSetParametros = rspSetParamet;
        }

        System.debug(response);
        return response;
    }

}