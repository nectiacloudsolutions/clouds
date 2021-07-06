/*********************************************************************************************************
@Author       cagonzle@everis.com
@name         ObjectRelatedDocumentHelper_Test
@CreateDate   02/10/2020
@Description  Test para la clase ObjectRelatedDocumentHelper_Test 
**********************************************************************************************************/
@IsTest
public class ObjectRelatedDocumentHelper_Test {
    private static Map<String,Group> gruposMap;
    
    private static String PF_RECORD_TYPE = Label.PF_Caso_RecordType;
    private static String PORT_HIPO = Label.PF_Cola_Hipotecario;
    private static String NO_HIPO = Label.PF_Cola_No_Hipotecario;
    private static String CAMPO_HIPO_CASO = Label.PF_Campo_Caso_Hipotecario;
    private static List<String> GRUPOS_COLAS = new List<String>{PORT_HIPO,NO_HIPO};

    @testSetup static void setup(){   

        DocumentosAlfresco__c da = new DocumentosAlfresco__c();
        da.Escritura__c='INTEGRACION';
        da.Lectura__c='Todos';
        da.NombreDocumento__c='Solicitud Portabilidad Firmada';
        da.OrdenListDoc__c=2;
        da.OrigenDocumento__c='Portabilidad Financiera Entrada';  
        da.Name='DA_Port_SP';
        Insert da;

        DocumentosAlfresco__c da1 = new DocumentosAlfresco__c();
        da1.Escritura__c='INTEGRACION';
        da1.Lectura__c='Todos';
        da1.NombreDocumento__c='Solicitud Portabilidad';
        da1.OrdenListDoc__c=2;
        da1.OrigenDocumento__c='Portabilidad Financiera Entrada';  
        da1.Name='DA_Port_SP1';
        Insert da1;

        Account cuenta = new Account();
        cuenta.RUT__c = '9121329-k';//1-9';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.FirstName='Juan';
        cuenta.LastName = 'Perez';
        cuenta.phone = '1333333222';
        cuenta.PersonEmail = 'test@test.cl';
        cuenta.Cliente_Banco__c = true;
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

        grupo = new Group();
        grupo.DeveloperName = 'No_Hipotecario';
		grupo.name = 'No_Hipotecario';
		grupo.Type='Queue';
        insert grupo;
		System.runAs(new User(Id=UserInfo.getUserId()))
		{
			QueuesObject testQueue2 = new QueueSObject(QueueID = grupo.id, SObjectType = 'Case');
			insert testQueue2;
		}
 
 
        Boolean clienteApto = true;
		Account acc = cuenta;

        Case nCaso = new Case();
        
        nCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PF_RECORD_TYPE).getRecordTypeId();
		nCaso.Caso_PF_Cliente_apto__c = clienteApto;
		nCaso.Status = (clienteApto ? Label.PF_Pre_Portabilidad : Label.PF_Cerrado);
		nCaso.Sub_estado_Nectia__c = (clienteApto ? Label.PF_Creacion_Oportunidad : Label.PF_Rechazado_No_Apto);
		nCaso.Causa_Origen__c = Label.PF_Causa_Origen;       
        nCaso.AccountId = acc.Id;
		nCaso.ContactId = acc.PersonContactId;
		nCaso.Rut__c = acc.RUT__c;
        ncaso.Rut_del_Cliente__c = acc.RUT__c;
        nCaso.Caso_PF_Credito_Hipotecario__c = true;
        nCaso.Caso_PF_Credito_Consumo__c =true;
        // variables para notificación
        nCaso.Notificacion_Ejecutivo__c = true;
        nCaso.Notificacion_Gestor__c = true;
        nCaso.Flag_envio_mail__c = false;
        nCaso.Type = 'Solicitud';
        nCaso.Subtipo__c = Label.PF_SubTipo_PFE;
        
		insert nCaso;
        
        String base64Data='fdsgerhreher45fgdfsg';
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = nCaso.Id;
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name ='Archivo_TEST';
        oAttachment.ContentType ='application/pdf';
        oAttachment.Description = 'Solicitud Portabilidad';
        insert oAttachment;
    }

    @isTest static void testAttachmentTrigger() {
        Case caso = [SELECT Id, Subtipo__c FROM Case LIMIT 1];
        String json ='{"dtoResponseCodigosEstadoHttp":{"codigo":"200","mensaje":"OK","descripcion":"OK"},"dtoResponseSetParametros":{"codigoError":"0","msjError":"Operacion realizada exitosamente"},"salidaAlfresco":{"codigo":"0","idAlfresco":"workspace://SpacesStore/7c63426b-70ba-4752-a835-af2ab0a07eb7","mensaje":"Ok"}}';
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200, 'ok', json, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        System.Test.startTest();
        Attachment att = new Attachment();
        att.ParentId = caso.Id;
        att.Name = 'SPF.pdf';
        att.Description='Solicitud Portabilidad Firmada';
        att.body=EncodingUtil.base64Decode('JVBERi0xLjcKCjEgMCBvYmogICUgZW50cnkgcG9pbnQKPDwKICAvVHlwZSAvQ2F0YWxvZwog');
        att.ContentType='application/pdf';
        Insert att;

        System.Test.stopTest();
    }   

    @isTest static void testORD_matchRecords() {
        Case caso = [SELECT Id, Subtipo__c FROM Case LIMIT 1];
        String json ='{"dtoResponseCodigosEstadoHttp":{"codigo":"200","mensaje":"OK","descripcion":"OK"},"dtoResponseSetParametros":{"codigoError":"0","msjError":"Operacion realizada exitosamente"},"salidaAlfresco":{"codigo":"0","idAlfresco":"workspace://SpacesStore/7c63426b-70ba-4752-a835-af2ab0a07eb7","mensaje":"Ok"}}';
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200, 'ok', json, null);
        Object_Related_Document__c ord = new Object_Related_Document__c();
        ord.Caso_Relacionado__c=caso.Id;
        ord.Tipo_Documento__c='Solicitud Portabilidad';
        ord.External_Id__c=ord.Caso_Relacionado__c+'-'+ord.Tipo_Documento__c;
        Insert ord;
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        System.Test.startTest();
        ObjectRelatedDocumentHelper.matchRecords(caso.Id, 'Caso_Relacionado__c', caso.Subtipo__c);

        System.Test.stopTest();
    }   
    
    @isTest static void testcreateLogDocPF(){

        
        Case caso = [SELECT Id, Subtipo__c FROM Case LIMIT 1];
        Attachment att = new Attachment();
        att.ParentId = caso.Id;
        att.Name = 'SPF.pdf';
        att.Description='Solicitud Portabilidad Firmada';
        att.body=EncodingUtil.base64Decode('JVBERi0xLjcKCjEgMCBvYmogICUgZW50cnkgcG9pbnQKPDwKICAvVHlwZSAvQ2F0YWxvZwog');
        att.ContentType='application/pdf';
        Insert att;
        
        List<Attachment> attLst = [SELECT ParentId, Body, BodyLength, ContentType, Description, Name FROM Attachment];
        String json ='{"dtoResponseCodigosEstadoHttp":{"codigo":"200","mensaje":"OK","descripcion":"OK"},"dtoResponseSetParametros":{"codigoError":"0","msjError":"Operacion realizada exitosamente"},"salidaAlfresco":{"codigo":"0","idAlfresco":"workspace://SpacesStore/7c63426b-70ba-4752-a835-af2ab0a07eb7","mensaje":"Ok"}}';
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200, 'ok', json, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		if(attLst.size() > 0){
            System.Test.startTest();
            ObjectRelatedDocumentHelper.createLogDocPF(attLst, null);	
            System.Test.stopTest();
		}
        
    }
}