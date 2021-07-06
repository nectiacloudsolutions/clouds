@isTest
public class FileUploadCaseHelperTest {
        private final static String PF_RECORD_TYPE = Label.PF_Opp_RecordType;
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
        
        List<sObject> ls1 = System.Test.loadData(DocumentosAlfresco__c.sObjectType, 'testDocumentosAlfresco');
        List<DocumentosAlfresco__c> lsn1 = (List<DocumentosAlfresco__c>)ls1;
        update lsn1;
        
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
        
        Opportunity opp = new Opportunity();
        opp.CloseDate=date.today();
        opp.AccountId = cuenta.id;
        opp.Name='test opp 1';
        opp.StageName='Contacto';
        opp.OwnerId= UserInfo.getUserId();
        opp.Caso_PF__c = nCaso.id;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(PF_RECORD_TYPE).getRecordTypeId();
        insert opp;
        
        Date myDate = Date.today();
        Object_Related_Document__c objLog = new Object_Related_Document__c();
        objLog.Estado_Documento__c = 'Ingresado';
        objLog.Id_Alfresco__c = 'workspace://SpacesStore/c6ecea36-1070-4450-afc0-e02bb59a57fe';
        objLog.Fecha_Carga_Alfresco__c = myDate;
        objLog.Caso_Relacionado__c = nCaso.Id;
        objLog.Tipo_Documento__c = 'Firma Manual';
        objLog.External_Id__c = nCaso.Id + '-' + 'Firma Manual';
        insert objLog;
        
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