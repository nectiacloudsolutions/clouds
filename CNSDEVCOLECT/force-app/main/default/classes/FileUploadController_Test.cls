/**
 * @description       : 
 * @author            : pcelisbe@everis.com
 * @group             : 
 * @last modified on  : 07-10-2020
 * @last modified by  : pcelisbe@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   07-10-2020   pcelisbe@everis.com   Initial Version
**/
@isTest
public class FileUploadController_Test {
    /**
    * @description 
    * @author pcelisbe@everis.com | 07-10-2020 
    **/
@testSetup
    private static void testDataCreate() {

        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();
        Opportunity opp=(Opportunity)mpsObjects.get('Opp1');
       	documento_oportunidad_sales__c Docs =New documento_oportunidad_sales__c();
        Docs.Id_Alfresco_sales__c='workspace://SpacesStore/d7f6a362-8015-4df0-a0ca-f96c60d27b63';
        Docs.estado_documento_sales__c='Ingresado';
        Docs.opportunity_sales__c=opp.id;
        insert Docs;

    }
    /**
    * @description 
    * @author pcelisbe@everis.com | 07-10-2020 
    **/
@isTest
    public static void testSaveChunk(){
		List<Opportunity> opp=[SELECT id FROM Opportunity LIMIT 1];
        String fileName = 'Test Attachment';
		String filebody ='Hi this is the test Attachment to Upload';
		Blob beforeblob = Blob.valueOf(filebody);
		string paramvalue = EncodingUtil.base64Encode(beforeblob);
		String contentType ='text/plain';
		String fileId = '';
        
        Id attachmentCreatedFileId = FileUploadController.saveChunk(opp[0].Id,fileName,paramvalue,contentType,fileId);
        FileUploadController.saveChunk(opp[0].Id,fileName,paramvalue,contentType,attachmentCreatedFileId);
        
		List<Attachment> attachments=[select id, name from Attachment where parent.id=:opp[0].Id];
		System.assertEquals(1, attachments.size());

    }
    /**
    * @description 
    * @author pcelisbe@everis.com | 07-10-2020 
    **/
@isTest
    static void viewDocs(){     
        
		List<documento_oportunidad_sales__c> Docs =[SELECT id FROM documento_oportunidad_sales__c LIMIT 1];
        ResponseDTOAlfresco response = new ResponseDTOAlfresco();
        String json = '{"dtoResponseCodigosEstadoHttp":{"codigo":"200","mensaje":"OK","descripcion":"OK"},"dtoResponseSetParametros":{"codigoError":"0","msjError":"Operacion realizada exitosamente"},"salidaDocAlfresco":{"bytes":"JVBERi0xLjUNJeLjz9MNCjM5MiAwIG9iag08PC9MaW5lYXJpemVkIDEvTCAxMTE4MjEyL08gMzk0L0UgMTg2Mjc3L04gMTcvVCAxMTE3NjQ5L0ggWyA0NzkgMjczXT4+DWVuZG9iag0gICAgICAgICAgDQo0MDEgMCBvYmoNPDwvRGVjb2RlUGFybXM8PC9Db2x1bW5zIDUvUHJlZGljdG9yIDEyPj4vRmlsdGVyL0ZsYXRlRGVjb2RlL0lEWzw5ODM3N0IxM0RFQzREODRDOUZFQkY5MzFEQTU2RjEyQT48NEZBMEZENDJGREEwM0E0MDkzRTI4RjAyMEEwNzZGNDY+XS9JbmRleFszOTIgMjNdL0luZm8gMzkxIDAgUi9MZW5ndGggNjgvUHJldiAxMTE3NjUwL1Jvb3QgMzkzIDAgUi9TaXplIDQxNS9UeXBlL1hSZWYvV1sxIDMgMV0","codigo":"0","contentType":"application/pdf","mensaje":"OK","nombreArchivo":"18137691-0Manual-de-Usuario-autoconsultas-eXpert (1).pdf1594151806515"}}';

        Test.startTest();
        	SalesCalloutMock fakeResponse = new SalesCalloutMock(200,'OK',json,null);
        	Test.setMock(HttpCalloutMock.class, fakeResponse);
        	response = FileUploadController.viewDoc(Docs[0].Id);
        Test.stopTest();

        System.assertEquals(response.SalidaDocAlfresco.codigo, '0');
    }
	/**
	* @description 
	* @author pcelisbe@everis.com | 07-10-2020 
	**/
@isTest
	public static void testUpdateDocs(){
        List<documento_oportunidad_sales__c> Docs =[SELECT id,Id_Alfresco_sales__c FROM documento_oportunidad_sales__c LIMIT 1];
        FileUploadController.updateDocs(Docs[0].id, 'workspace://SpacesStore/d7f6a362-8015-4df0-a0ca-f96c60d27b63', '');
        System.assertEquals('workspace://SpacesStore/d7f6a362-8015-4df0-a0ca-f96c60d27b63', Docs[0].Id_Alfresco_sales__c);
    }
    /**
    * @description 
    * @author pcelisbe@everis.com | 07-10-2020 
    **/
@isTest
    public static void testInvokeUploadAlfresco(){

        List<documento_oportunidad_sales__c> Docs =[SELECT id,opportunity_sales__c FROM documento_oportunidad_sales__c LIMIT 1];
        
        String base64Data='fdsgerhreher45fgdfsg';
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = Docs[0].opportunity_sales__c;
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name ='Archivo_TEST';
        oAttachment.ContentType ='application/pdf';
        insert oAttachment;
        
        ResponseDTOAlfresco response = new ResponseDTOAlfresco();
        String json ='{"dtoResponseCodigosEstadoHttp":{"codigo":"200","mensaje":"OK","descripcion":"OK"},"dtoResponseSetParametros":{"codigoError":"0","msjError":"Operacion realizada exitosamente"},"salidaAlfresco":{"codigo":"0","idAlfresco":"workspace://SpacesStore/7c63426b-70ba-4752-a835-af2ab0a07eb7","mensaje":"Ok"}}';
        Test.startTest();
        	SalesCalloutMock fakeResponse = new SalesCalloutMock(200,'OK',json,null);
        	Test.setMock(HttpCalloutMock.class, fakeResponse);
        	response = FileUploadController.invokeUploadAlfresco(Docs[0].opportunity_sales__c,oAttachment.id,Docs[0].Id);
        Test.stopTest();

        System.assertEquals(response.dtoResponseCodigosEstadoHttp.codigo, '200');
    }
    
}