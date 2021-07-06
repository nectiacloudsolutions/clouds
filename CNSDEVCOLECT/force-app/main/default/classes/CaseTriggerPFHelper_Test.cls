/*********************************************************************************************************
@Author       lmunogar@everis.com
@name         PF_CrearCaso_WSRest_Test
@CreateDate   13/08/2020
@Description  Service Test para la clase CaseTriggerPFHelper 
**********************************************************************************************************/
@isTest
public class CaseTriggerPFHelper_Test {

    private static Map<String,Group> gruposMap;
    
    private static String PF_RECORD_TYPE = Label.PF_Caso_RecordType;
    private static String PF_RECORD_TYPE_SALIDA = Label.PF_Caso_RecordType_Salida;
    private static String PORT_HIPO = Label.PF_Cola_Hipotecario;
    private static String NO_HIPO = Label.PF_Cola_No_Hipotecario;
    private static String CAMPO_HIPO_CASO = Label.PF_Campo_Caso_Hipotecario;
    private static List<String> GRUPOS_COLAS = new List<String>{PORT_HIPO,NO_HIPO};
            
	@testSetup static void setup(){
        System.Test.startTest();

        User newUsr = [Select Id From User Where Alias = 'DGarcia'];
        
        Account cuenta = new Account();
        cuenta.RUT__c = '1-9';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.FirstName='Juan';
        cuenta.LastName = 'Perez';
        cuenta.phone = '1333333222';
        cuenta.PersonEmail = 'test@test.cl';
        insert cuenta;

        Opportunity opp = new Opportunity();
        opp.CloseDate=date.today();
        opp.AccountId = cuenta.id;
        opp.Name='test opp 1';
        opp.StageName='Contacto';
        opp.OwnerId=newUsr.Id;
        insert opp;        
        
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

        System.test.stopTest();
    }
    
    @isTest static void testCasoNotificacion(){
        Boolean clienteApto = true;
        buscarGrupos();
		Account acc = [SELECT RUT__c, PersonContactId FROM Account WHERE RUT__c =: '1-9'];
        
        Case nCaso = new Case();
        
        nCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PF_RECORD_TYPE).getRecordTypeId();
		nCaso.Caso_PF_Cliente_apto__c = clienteApto;
		nCaso.Sub_estado_Nectia__c = (clienteApto ? Label.PF_Creacion_Oportunidad : Label.PF_Rechazado);
		nCaso.Status = (clienteApto ? Label.PF_Pre_Portabilidad : Label.PF_Cerrado);
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
        
        String nameCola = (nCaso.get(CAMPO_HIPO_CASO) == true ? PORT_HIPO : NO_HIPO);
        if(clienteApto){ nCaso.OwnerId = gruposMap.get(nameCola).Id; }

        System.test.startTest();  
        // insertar caso nuevo
        // *******************************
		insert nCaso;
        
        System.assertEquals(nCaso.Caso_PF_Primer_propietario_Formula__c, null);
		
		String json = '[{"actionName" : "customNotificationAction","errors" : null,"isSuccess" : true,"outputValues" : {"SuccessMessage" : "Your custom notification is processed successfully."}}]';
        PFCalloutMock fakeResponse = new PFCalloutMock(200, 'ok', json, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

        // insertar caso nuevo
        // *******************************
        nCaso.OwnerId = UserInfo.getUserId();
        nCaso.lista_notificacion__c = 'Warning';
		// update nCaso;
        
        nCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PF_RECORD_TYPE_SALIDA).getRecordTypeId();
		update nCaso;

        nCaso = [SELECT Caso_PF_Primer_propietario_Formula__c, OwnerId, Subject FROM Case WHERE Id =: nCaso.Id];
        System.assertEquals('Solicitud de Retención', nCaso.Subject);
        
		//Caso.Nombre_Ejecutivo_Referidor__r.Manager.FirstName  = 'Nombre Prueba';
        //nCaso.Nombre_Ejecutivo_Referidor__r.Manager.LastName  = 'Apellido';
        //update nCaso;   
        
        //Opportunity lstOpps = [Select Id,Gestor_del_Referidor__c from Opportunity where Id =:nCaso.Id];
        //system.debug('Nombre->' + lstOpps.Gestor_del_Referidor__c);
        
        System.test.stopTest();
        
    }
    
    private static void buscarGrupos(){
        gruposMap = new Map<String,Group>();
        for(Group grupo : [select DeveloperName from Group where DeveloperName IN: GRUPOS_COLAS ]){
            gruposMap.put(grupo.DeveloperName, grupo);
        }
    }  
}