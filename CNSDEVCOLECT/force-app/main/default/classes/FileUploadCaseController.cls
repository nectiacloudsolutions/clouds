/**
 * @description       : 
 * @author            : mbeltran@everis.com
 * @group             : 
 * @last modified on  : 12-17-2020
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   12-17-2020   mbeltran@everis.com   Initial Version
**/
public with sharing class FileUploadCaseController {

	@AuraEnabled
    public static ResponseDTOAlfresco invokeUploadAlfrescoNew(Id idRecord, Id fileId, Id IdDocs) {
        String sourceip;
        try{
            sourceip = (!System.Test.isRunningTest() ? Auth.SessionManagement.getCurrentSession().get('SourceIp') : null);
        }catch(Exception ex){ } 
        
        Attachment a = [
            SELECT Id, Name,Body,ContentType, Description
            FROM Attachment
            WHERE Id =: fileId
        ];
        
		List<Case> lstCase = [SELECT Id, Account.Rut__c FROM Case WHERE Id = : idRecord];
        
        ResponseDTOAlfresco response = new ResponseDTOAlfresco();
        response = FileUploadServiceController.invokeUploadAlfresco(a, lstCase);
        
        delete a;
        
        if(response.salidaAlfresco!=null){
            if (response.salidaAlfresco.idAlfresco!='' && response.salidaAlfresco.idAlfresco!=null) {
                updateDocsNew(IdDocs,response.salidaAlfresco.idAlfresco,'Ingresado');

                 FileUploadCaseHelper.FileUploadRequest psReq = new FileUploadCaseHelper.FileUploadRequest();
                for(Case lstcse : lstCase){
                    psReq.idSolicitudSaleforce = '';
                    psReq.idCasoSalesforce = String.valueOf(lstcse.Id);
                    psReq.dataDoc = response.salidaAlfresco.idAlfresco;
                    psReq.dataDoc = psReq.dataDoc.removeEnd('\\');
                }
                FileUploadCaseHelper.uploadHelper(JSON.serialize(psReq),IdDocs,idRecord, sourceip); 
            }
        }
        
        return response;
    }
    
    @AuraEnabled
    public static void updateDocsNew(Id IdDocs, String IdAlfresco,String EstadoDoc){
        Date myDate = Date.today();
        try {
            Object_Related_Document__c oppDoc = new Object_Related_Document__c();
            oppDoc.Id= IdDocs;
            oppDoc.Estado_Documento__c = EstadoDoc;
            oppDoc.Id_Alfresco__c=IdAlfresco;
            oppDoc.Fecha_Carga_Alfresco__c = String.isBlank(EstadoDoc) ? null : myDate;
            update oppDoc;

        } catch(Exception e) {
            System.debug( e);
        }
    }
    @AuraEnabled
    public static ResponseDTOAlfresco viewDocNew(Id idDoc){

        RequestDTOAlfresco request = new RequestDTOAlfresco();
        ResponseDTOAlfresco response = new ResponseDTOAlfresco();

        List<Object_Related_Document__c> lstDocs = [SELECT Caso_Relacionado__c, Id_Alfresco__c 
                                FROM Object_Related_Document__c WHERE Id =: idDoc];
        
        List<Case> lstOpp = [SELECT Id, Account.Rut__c FROM Case WHERE Id =: lstDocs[0].Caso_Relacionado__c];

        RequestDTOAlfresco.ConsultaDoc consultar = new RequestDTOAlfresco.ConsultaDoc();
        RequestDTOAlfresco.dtoRequestSetParametros dtoRequestSetParametros = new RequestDTOAlfresco.dtoRequestSetParametros();
        if (lstDocs[0].Id_Alfresco__c!='' && lstDocs[0].Id_Alfresco__c!=null) {
            consultar.idAlfresco = lstDocs[0].Id_Alfresco__c;
            consultar.rutCliente = lstOpp[0].Account.Rut__c;
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
}