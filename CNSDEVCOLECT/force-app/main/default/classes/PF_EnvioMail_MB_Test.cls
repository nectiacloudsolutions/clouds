/*********************************************************************************************************
@Author       lmunogar@everis.com
@name         PF_EnvioMail_MB_Test
@CreateDate   21/08/2020
@Description  Service Test para la clase PF_EnvioMail_MB 
**********************************************************************************************************/
@IsTest
public class PF_EnvioMail_MB_Test {

    private static Map<String,Group> gruposMap;
    
    private static String PF_RECORD_TYPE = Label.PF_Caso_RecordType;
    private static String PORT_HIPO = Label.PF_Cola_Hipotecario;
    private static String NO_HIPO = Label.PF_Cola_No_Hipotecario;
    private static String CAMPO_HIPO_CASO = Label.PF_Campo_Caso_Hipotecario;
    private static List<String> GRUPOS_COLAS = new List<String>{PORT_HIPO,NO_HIPO};

    @testSetup static void setup(){      
        System.Test.startTest();
        
        User newUsr = [Select Id From User Where Alias = 'DGarcia'];
		//User newUsr =TestFactorySales.createUser('24770129k', 'Ejecutivos de Atención al Cliente Seguros Comercial', 'testCsPF');     
		//Insert newUsr;         

        /*NotificacionPorMasterBase__c lsn2 = new NotificacionPorMasterBase__c();
        lsn2.Name = 'PLNT1';
        lsn2.ID_Notificacion__c = '8';
        lsn2.Nombre__c = 'SolicitudPortabilidad financiera de entradanullPre portabilidadCrear Oportunidad (es)true';
        lsn2.Tipo__c = 'Solicitud';
        lsn2.SubTipo__c = 'Portabilidad financiera de entrada';
        lsn2.Estado_Previo__c = 'null';
        lsn2.Estado__c = 'Pre portabilidad';
        lsn2.Sub_Estado__c = 'Crear Oportunidad (es)';
        lsn2.Cliente_Apto__c = 'true';
        lsn2.Plantilla__c = 'Comprobante de recepción de portabilidad N° Caso';
        lsn2.Campos_Plantilla__c = 'nombre,Nombres__c; numero,CaseNumber; fecha,CreatedDate';
        lsn2.Asunto__c = '';
        lsn2.Adjunto__c = 'Si';
        lsn2.Nombre_Adjunto__c = 'Portabilidad_Financiera';
        lsn2.SLA__c = 0;
        insert lsn2;
        
        system.debug('LEOTEST lsn2: ' + lsn2);*/

        
        Account cuenta = new Account();
        cuenta.RUT__c = '1-9';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.FirstName='Juan';
        cuenta.LastName = 'Perez';
        cuenta.phone = '1333333222';
		cuenta.PersonEmail = 'leonardo.munoz.garrido@everis.com';
		cuenta.OwnerId = newUsr.Id;
        insert cuenta;

        cuenta = new Account();
        cuenta.RUT__c = '2-7';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.FirstName='Juana';
        cuenta.LastName = 'Maria';
        cuenta.phone = '6545454555';
        cuenta.PersonEmail = 'lmunogar@everis.com';
        cuenta.OwnerId = newUsr.Id;
        insert cuenta;

        Group grupo = new Group();
        grupo.DeveloperName = PORT_HIPO;
		grupo.name = PORT_HIPO;
		grupo.Type='Queue';
		//insert grupo;
		
		System.runAs(new User(Id=UserInfo.getUserId()))
		{
			QueuesObject testQueue1 = new QueueSObject(QueueID = grupo.id, SObjectType = 'Case');
			//insert testQueue1;
		}

        grupo = new Group();
        grupo.DeveloperName = NO_HIPO;
		grupo.name = NO_HIPO;
		grupo.Type='Queue';
        //insert grupo;
        
        
        System.runAs(new User(Id=UserInfo.getUserId()))
		{
			QueuesObject testQueue2 = new QueueSObject(QueueID = grupo.id, SObjectType = 'Case');
			//insert testQueue2;
		}

        List<sObject> ls = System.Test.loadData(MessageNotification__c.sObjectType, 'testMessageNotification');
        List<MessageNotification__c> lsn = (List<MessageNotification__c>)ls;
        update lsn;
        
        Consorcio_Org__c org = new Consorcio_Org__c();
        org.Sales_project__c = true;
        insert org;   

        List<sObject> ls2 = System.Test.loadData(NotificacionPorMasterBase__c.sObjectType, 'testNotificationMasterBase');
        List<NotificacionPorMasterBase__c> lsn2 = (List<NotificacionPorMasterBase__c>)ls2;
        update lsn2;

        

        System.test.stopTest();
    }

    @isTest static void testCasoEnvioMailMasterBase(){

        String json = '{"mb_response": {"TransactionId": "985116795942c6f58","Version": "1.0.19.0"},  "status": 200}';
        PFCalloutMock fakeResponse = new PFCalloutMock(200, 'ok', json, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        List<NotificacionPorMasterBase__c> lsn2 = [SELECT Nombre__c, Adjunto__c, Asunto__c, Cliente_Apto__c, Estado_Previo__c, Estado__c, ID_Notificacion__c, Name,Plantilla__c,
                          SLA__c, SubTipo__c, Sub_Estado__c, Tipo__c, Nombre_Adjunto__c, Campos_Plantilla__c FROM NotificacionPorMasterBase__c];

        Boolean clienteApto = true;
        //buscarGrupos();
		Account acc = [SELECT RUT__c, PersonContactId FROM Account WHERE RUT__c =: '1-9'];
        
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
        
        //String nameCola = (nCaso.get(CAMPO_HIPO_CASO) == true ? PORT_HIPO : NO_HIPO);
        //if(clienteApto){ nCaso.OwnerId = gruposMap.get(nameCola).Id; }

		System.test.startTest(); 
		insert nCaso;
        
        nCaso.Correo_electr_nico__c = 'test@test.com';
        Update nCaso;

        System.test.stopTest();
    }

    @isTest static void testCasoEnvioMailMasterBase_Cerrado(){

        String json = '{"mb_response": {"TransactionId": "985116795942c6f58","Version": "1.0.19.0"},  "status": 200}';
        PFCalloutMock fakeResponse = new PFCalloutMock(200, 'ok', json, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        Boolean clienteApto = false;
        //buscarGrupos();
		Account acc = [SELECT RUT__c, PersonContactId FROM Account WHERE RUT__c =: '2-7'];
        
        Case nCaso = new Case();
        
        nCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PF_RECORD_TYPE).getRecordTypeId();
		nCaso.Caso_PF_Cliente_apto__c = clienteApto;
		nCaso.Sub_estado_Nectia__c = (clienteApto ? Label.PF_Creacion_Oportunidad : Label.PF_Rechazado_No_Apto);
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
        nCaso.Flag_envio_mail__c = false;
        nCaso.Type = 'Solicitud';
        nCaso.Subtipo__c = Label.PF_SubTipo_PFE;
        //nCaso.Motivo_de_no_inter_s__c = '-No apto';
        
        //String nameCola = (nCaso.get(CAMPO_HIPO_CASO) == true ? PORT_HIPO : NO_HIPO);
        //if(clienteApto){ nCaso.OwnerId = gruposMap.get(nameCola).Id; }
        //System.debug('Cola ID'+nCaso.OwnerId);
        User us = [Select Id From User Where Alias = 'DGarcia'];
		//User us = [SELECT Id FROM User WHERE RUT__c = '24770129k'];  
        
		System.test.startTest(); 
		System.runAs(us) {
			insert nCaso;
            nCaso.Correo_electr_nico__c = 'test@test.com';
            Update nCaso;            
		}

        System.test.stopTest();
    }

    @isTest static void testCasoEnvioMailMasterBase_Masivo(){

        String json = '{"mb_response": {"TransactionId": "985116795942c6f58","Version": "1.0.19.0"},  "status": 200}';
        PFCalloutMock fakeResponse = new PFCalloutMock(200, 'ok', json, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        Boolean clienteApto = true;
        //buscarGrupos();
		Account acc = [SELECT RUT__c, PersonContactId FROM Account WHERE RUT__c =: '2-7'];
        
        List<Case> lstCaso = new List<Case>();
        for(Integer i = 0; i<20; i++){
            Case nCaso = new Case();
            
            nCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PF_RECORD_TYPE).getRecordTypeId();
            nCaso.Caso_PF_Cliente_apto__c = clienteApto;
            nCaso.Sub_estado_Nectia__c = (clienteApto ? Label.PF_Creacion_Oportunidad : Label.PF_Rechazado_No_Apto);
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
            nCaso.Flag_envio_mail__c = false;
            nCaso.Type = 'Solicitud';
            nCaso.Subtipo__c = Label.PF_SubTipo_PFE;
            //nCaso.Motivo_de_no_inter_s__c = '-No apto';
            
            //String nameCola = (nCaso.get(CAMPO_HIPO_CASO) == true ? PORT_HIPO : NO_HIPO);
            //if(clienteApto){ nCaso.OwnerId = gruposMap.get(nameCola).Id; }
            lstCaso.add(nCaso);
        }
        User us = [Select Id From User Where Alias = 'DGarcia'];
		//User us = [SELECT Id FROM User WHERE RUT__c = '24770129k'];  
        
		System.test.startTest(); 
		System.runAs(us) {
			insert lstCaso;
            for(Case newCaso : lstCaso){
            	newCaso.Correo_electr_nico__c = 'test@test.com';    
            }
            
            Update lstCaso;            
		}

        System.test.stopTest();
    }
        
    
    @isTest static void testToken(){
        String json = '{"access_token": "123456","expires_in": 86400,"token_type": "Bearer"}';
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200, 'ok', json, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        Test.startTest();
        PF_EnvioMail_MB.getToken();
        Test.stopTest();
    } 
    
    @isTest static void testTokenError(){
        String json = '{"access_token": "123456","expires_in": 86400,"token_type": "Bearer"}';
        SalesCalloutMock fakeResponse = new SalesCalloutMock(404, 'fail', json, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        Test.startTest();
        PF_EnvioMail_MB.getToken();
        Test.stopTest();
    }     
    
    /*private static void buscarGrupos(){
        gruposMap = new Map<String,Group>();
        for(Group grupo : [select DeveloperName from Group where DeveloperName IN: GRUPOS_COLAS ]){
            gruposMap.put(grupo.DeveloperName, grupo);
        }
    }*/
}