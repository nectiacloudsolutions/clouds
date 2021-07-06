/*********************************************************************************************************
@Author       cagonzle@everis.com
@name         PFLoadAlfrescoDocument
@CreateDate   30/11/2020
@Description  Service Rest Crear Caso desde Analytics 
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
30/11/2020                    cagonzle@everis.com                 Initial Version
**********************************************************************************************************/
@RestResource(urlMapping='/PFLoadAlfrescoDoc/*') 
global class PFLoadAlfrescoDocument {

    /**
	 * loadDocument Procesa la peticion de creacion de documentos en Alfresco
	 * @return             return Json con el response
	 */
    @HttpPost
    global static String loadDocument(){
		String request = RestContext.request.requestBody.toString();
        AlfrescoDocument objReq = (AlfrescoDocument) System.JSON.deserialize(request, AlfrescoDocument.class);
        Attachment doc = new Attachment();
        doc.ParentId = objReq.ParentId;
        doc.Name = objReq.Name;
        doc.Description = objReq.Description;
        doc.ContentType = objReq.ContentType;
        doc.body = objReq.body;
        String sourceip = null;
        try{
            sourceip = (!System.Test.isRunningTest() ? Auth.SessionManagement.getCurrentSession().get('SourceIp') : null);
        }catch(Exception ex){ }        
        List<ResponseDTOAlfresco> response = ObjectRelatedDocumentHelper.createLogDocPF(new List<Attachment>{doc}, sourceip);
        Return System.JSON.serialize(response[0]);
    }

    public class AlfrescoDocument{
        String ParentId {get;set;}
        String Name {get;set;}
        String Description {get;set;}
        String ContentType {get;set;}
        Blob body {get;set;}
    }

}