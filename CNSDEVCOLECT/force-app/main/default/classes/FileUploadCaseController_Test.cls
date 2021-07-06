@isTest
public class FileUploadCaseController_Test {
	@testSetup
    private static void setup() {
		Account cuenta = new Account();
        cuenta.RUT__c = '9121329-k';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.FirstName='Juan';
        cuenta.LastName = 'Perez';
        cuenta.phone = '1333333222';
        cuenta.PersonEmail = 'test@test.cl';
        insert cuenta;
        
        Group grupo = new Group();
        grupo.DeveloperName = 'Port_Hipotecario';
		grupo.name = 'Port_Hipotecario';
		grupo.Type='Queue';
		insert grupo;
		System.runAs(new User(Id=UserInfo.getUserId()))
		{
			QueuesObject testQueue1 = new QueueSObject(QueueID = grupo.id, SObjectType = 'Case');
			insert testQueue1;
		}
        
        Case nCaso = new Case();
		nCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Caso_PF_Caso_de_Portabilidad').getRecordTypeId();
		nCaso.Caso_PF_Cliente_apto__c = true;
		nCaso.Sub_estado_Nectia__c = Label.PF_Creacion_Oportunidad;
        nCaso.Status = Label.PF_Pre_Portabilidad;
		nCaso.Causa_Origen__c = Label.PF_Causa_Origen;
        nCaso.AccountId = cuenta.Id;
		nCaso.ContactId = cuenta.PersonContactId;
		nCaso.Rut__c = cuenta.RUT__c;
        ncaso.Rut_del_Cliente__c = cuenta.RUT__c;
        nCaso.Caso_PF_Credito_Hipotecario__c = true;
        insert nCaso;
        
        Date myDate = Date.today();
        Object_Related_Document__c objLog = new Object_Related_Document__c();
        objLog.Estado_Documento__c = 'Ingresado';
        objLog.Id_Alfresco__c = 'workspace://SpacesStore/c6ecea36-1070-4450-afc0-e02bb59a57fe';
        objLog.Fecha_Carga_Alfresco__c = myDate;
        objLog.Caso_Relacionado__c = nCaso.Id;
        objLog.Tipo_Documento__c = 'Solicitud Portabilidad';
        objLog.External_Id__c = nCaso.Id + '-' + 'Solicitud Portabilidad';
        insert objLog;
        
    }

@isTest
    public static void testSaveChunk(){
		List<Case> opp=[SELECT id FROM Case LIMIT 1];
        String fileName = 'Test Attachment';
		String filebody ='Hi this is the test Attachment to Upload';
		Blob beforeblob = Blob.valueOf(filebody);
		string paramvalue = EncodingUtil.base64Encode(beforeblob);
		String contentType ='text/plain';
		String fileId = '';
        
        Id attachmentCreatedFileId = FileUploadCaseController.saveChunk(opp[0].Id,fileName,paramvalue,contentType,fileId);
        FileUploadCaseController.saveChunk(opp[0].Id,fileName,paramvalue,contentType,attachmentCreatedFileId);
        
		List<Attachment> attachments=[select id, name from Attachment where parent.id=:opp[0].Id];
		System.assertEquals(1, attachments.size());

    }

@isTest
    static void viewDocs(){     
		List<Object_Related_Document__c> Docs =[SELECT id FROM Object_Related_Document__c LIMIT 1];
        ResponseDTOAlfresco response = new ResponseDTOAlfresco();
        String json = '{"dtoResponseCodigosEstadoHttp":{"codigo":"200","mensaje":"OK","descripcion":"OK"},"dtoResponseSetParametros":{"codigoError":"0","msjError":"Operacion realizada exitosamente"},"salidaDocAlfresco":{"bytes":"JVBERi0xLjUNJeLjz9MNCjM5MiAwIG9iag08PC9MaW5lYXJpemVkIDEvTCAxMTE4MjEyL08gMzk0L0UgMTg2Mjc3L04gMTcvVCAxMTE3NjQ5L0ggWyA0NzkgMjczXT4+DWVuZG9iag0gICAgICAgICAgDQo0MDEgMCBvYmoNPDwvRGVjb2RlUGFybXM8PC9Db2x1bW5zIDUvUHJlZGljdG9yIDEyPj4vRmlsdGVyL0ZsYXRlRGVjb2RlL0lEWzw5ODM3N0IxM0RFQzREODRDOUZFQkY5MzFEQTU2RjEyQT48NEZBMEZENDJGREEwM0E0MDkzRTI4RjAyMEEwNzZGNDY+XS9JbmRleFszOTIgMjNdL0luZm8gMzkxIDAgUi9MZW5ndGggNjgvUHJldiAxMTE3NjUwL1Jvb3QgMzkzIDAgUi9TaXplIDQxNS9UeXBlL1hSZWYvV1sxIDMgMV0","codigo":"0","contentType":"application/pdf","mensaje":"OK","nombreArchivo":"18137691-0Manual-de-Usuario-autoconsultas-eXpert (1).pdf1594151806515"}}';

        Test.startTest();
        	SalesCalloutMock fakeResponse = new SalesCalloutMock(200,'OK',json,null);
        	Test.setMock(HttpCalloutMock.class, fakeResponse);
        	response = FileUploadCaseController.viewDocNew(Docs[0].Id);
        Test.stopTest();

        System.assertEquals(response.SalidaDocAlfresco.codigo, '0');
    }

@isTest
	public static void testUpdateDocs(){
        List<Object_Related_Document__c> Docs =[SELECT id,Id_Alfresco__c FROM Object_Related_Document__c LIMIT 1];
        FileUploadCaseController.updateDocsNew(Docs[0].id, 'workspace://SpacesStore/c6ecea36-1070-4450-afc0-e02bb59a57fe', '');
        System.assertEquals('workspace://SpacesStore/c6ecea36-1070-4450-afc0-e02bb59a57fe', Docs[0].Id_Alfresco__c);
    }
@isTest
    public static void testInvokeUploadAlfresco(){
        List<Object_Related_Document__c> Docs =[SELECT id,Caso_Relacionado__c FROM Object_Related_Document__c LIMIT 1];
        
        String base64Data='fdsgerhreher45fgdfsg';
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = Docs[0].Caso_Relacionado__c;
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name ='Archivo_TEST';
        oAttachment.ContentType ='application/pdf';
        insert oAttachment;
        
        ResponseDTOAlfresco response = new ResponseDTOAlfresco();
        String json ='{"dtoResponseCodigosEstadoHttp":{"codigo":"200","mensaje":"OK","descripcion":"OK"},"dtoResponseSetParametros":{"codigoError":"0","msjError":"Operacion realizada exitosamente"},"salidaAlfresco":{"codigo":"0","idAlfresco":"workspace://SpacesStore/7c63426b-70ba-4752-a835-af2ab0a07eb7","mensaje":"Ok"}}';
        Test.startTest();
        	SalesCalloutMock fakeResponse = new SalesCalloutMock(200,'OK',json,null);
        	Test.setMock(HttpCalloutMock.class, fakeResponse);
        	response = FileUploadCaseController.invokeUploadAlfrescoNew(Docs[0].Caso_Relacionado__c, oAttachment.id, Docs[0].Id);
        Test.stopTest();

        System.assertEquals(response.dtoResponseCodigosEstadoHttp.codigo, '200');
    }
}