/*********************************************************************************************************
@Author       cagonzle@everis.com
@name         PF_CasoSalidaNotiAnalyticsTest
@CreateDate   26/08/2020
@Description  Test class para PF_CasoSalidaNotiAnalytics - Casos de Salida
**********************************************************************************************************/
@isTest
public class PF_CasoSalidaNotiAnalyticsTest {

    private static Map<String,Group> gruposMap;
    
    private static String PF_RECORD_TYPE = Label.PF_Caso_RecordType_Salida;
    private static String PF_RECORD_TYPE_ENTRADA = Label.PF_Caso_RecordType;
    private static String PORT_HIPO = Label.PF_Cola_Hipotecario;
    private static String NO_HIPO = Label.PF_Cola_No_Hipotecario;
    private static String CAMPO_HIPO_CASO = Label.PF_Campo_Caso_Hipotecario;
    private static List<String> GRUPOS_COLAS = new List<String>{PORT_HIPO,NO_HIPO};
            
	@testSetup static void setup(){
        
        User newUsr = [Select Id From User Where Alias = 'DGarcia'];
		//User newUsr =TestFactorySales.createUser('24770129k', 'Ejecutivos de Atención al Cliente Seguros Comercial', 'testCsPF');     
		//Insert newUsr; 

        Account cuenta = new Account();
        cuenta.RUT__c = '1-9';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.FirstName='Juan';
        cuenta.LastName = 'Perez';
        cuenta.phone = '1333333222';
        cuenta.PersonEmail = 'test@test.cl';
        cuenta.OwnerId = newUsr.Id;
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

        List<sObject> ls = System.Test.loadData(MessageNotification__c.sObjectType, 'testMessageNotification');
        List<MessageNotification__c> lsn = (List<MessageNotification__c>)ls;
        update lsn;
        
        Consorcio_Org__c org = new Consorcio_Org__c();
        org.Sales_project__c = true;
        insert org;   

    }
    
    @isTest static void testCasoNotificacion(){
		String json = '{"codigo":"1","mensaje":"NOK", "respuesta" : {"hipotecario":true,"hipotecarioConCNS":false,"segmentacionCliente":"texto"}}';
        PFCalloutMock fakeResponse = new PFCalloutMock(200, 'ok', json, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

        System.test.startTest();
		User us = [SELECT Id FROM User WHERE Alias = 'DGarcia'];  
        // insertar caso nuevo
		// *******************************
		//System.runAs(us) {

            Boolean clienteApto = true;
            buscarGrupos();
            Account acc = [SELECT RUT__c, PersonContactId FROM Account WHERE RUT__c =: '1-9'];
            
            Case nCaso = new Case();

        	nCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PF_RECORD_TYPE).getRecordTypeId();
            nCaso.Caso_PF_Cliente_apto__c = clienteApto;
            nCaso.Sub_estado_Nectia__c = 'Solucionado';
            nCaso.Status = 'En Proceso';
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
        
			insert nCaso;
		//}
		System.test.stopTest();

		String query = 'SELECT '+Label.PF_Campo_Caso_Hipotecario + ',' + 
		Label.PF_Campo_Caso_Hipotecario_no_CNS + ',' +
		Label.PF_Campo_Caso_Segmentacion_Cliente +
		' FROM Case LIMIT 1';
		//Case 
        nCaso = Database.query(query);

        System.assertEquals(true,nCaso.get( Label.PF_Campo_Caso_Hipotecario) );
		System.assertEquals(false,nCaso.get( Label.PF_Campo_Caso_Hipotecario_no_CNS) );
		//System.assertEquals('texto',nCaso.get( Label.PF_Campo_Caso_Segmentacion_Cliente) );
    }
    
    @isTest static void testCasoNotificacionEntrada(){
        Boolean clienteApto = true;
        buscarGrupos();
        Account acc = [SELECT RUT__c, PersonContactId FROM Account WHERE RUT__c =: '1-9'];
        
        Case nCaso = new Case();        
        nCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PF_RECORD_TYPE_ENTRADA).getRecordTypeId();
        nCaso.Caso_PF_Cliente_apto__c = clienteApto;
        nCaso.Sub_estado_Nectia__c = 'Solucionado';
        nCaso.Status = 'En Proceso';
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
        insert nCaso;
        Case lstCaseQuery = [Select Id,Rut__c,CaseNumber,Type,Subtipo__c,status,Sub_estado_Nectia__c,Causa_Origen__c,RecordTypeId  from Case LIMIT 1];

        Test.startTest();
        String json = '{"codigo":"1","mensaje":"NOK", "respuesta" : {"hipotecario":true,"hipotecarioConCNS":false,"segmentacionCliente":"texto"}}';
        PFCalloutMock fakeResponse = new PFCalloutMock(200, 'ok', json, null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        PF_CasoSalidaNotiAnalytics.PortabilidadSegmentoReq psReq = new PF_CasoSalidaNotiAnalytics.PortabilidadSegmentoReq(lstCaseQuery);
        case temp = PF_CasoSalidaNotiAnalytics.sendNotificationWS(System.JSON.serialize(psReq));  
        System.assertEquals(false,temp.get( Label.PF_Campo_Caso_Hipotecario_no_CNS) );
        System.assertEquals('texto',temp.get( Label.PF_Campo_Caso_Segmentacion_Cliente) );
        Test.stopTest();
    }

    
    private static void buscarGrupos(){
        gruposMap = new Map<String,Group>();
        for(Group grupo : [select DeveloperName from Group where DeveloperName IN: GRUPOS_COLAS ]){
            gruposMap.put(grupo.DeveloperName, grupo);
        }
    }    
}