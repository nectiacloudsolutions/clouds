/*********************************************************************************************************
@Author       lmunogar@everis.com
@name         PF_CrearCaso_WSRest_Test
@CreateDate   10/08/2020
@Description  Service Test para la clase PF_CrearCaso_WSRest 
**********************************************************************************************************/
@IsTest
public class PF_CrearCaso_WSRest_Test {

    @testSetup static void setup(){ 

        User newUsr =TestFactorySales.createUser('24770129k', 'Integraciones', 'testCsPF');     
		Insert newUsr; 
        
        Consorcio_Org__c org = new Consorcio_Org__c();
        org.Sales_project__c = true;
        org.SetupOwnerId = newUsr.ProfileId;
        org.Name = 'Consorcio Org (Profile)';
        Insert org;
        
        Account cuenta = new Account();
        cuenta.RUT__c = '9121329-k';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.FirstName='Juan';
        cuenta.LastName = 'Perez';
        cuenta.phone = '1333333222';
        cuenta.PersonEmail = 'test@test.cl';
        insert cuenta;

        cuenta = new Account();
        cuenta.RUT__c = '6978755-K';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.FirstName='Maria';
        cuenta.LastName = 'Perez';
        cuenta.phone = '1333332444';
        cuenta.PersonEmail = 'test2@test2.cl';
        insert cuenta;
		
        Case nCaso = new Case();
		nCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Caso_PF_Caso_de_Portabilidad').getRecordTypeId();
		nCaso.Caso_PF_Cliente_apto__c = true;
        nCaso.Status = Label.PF_Pre_Portabilidad;
        nCaso.AccountId = cuenta.Id;
		nCaso.Rut__c = cuenta.RUT__c;
        ncaso.Rut_del_Cliente__c = cuenta.RUT__c;
        nCaso.Caso_PF_Credito_Hipotecario__c = false;
        nCaso.Caso_PF_Credito_Consumo__c = true;
        nCaso.Caso_PF_Plan_Plus__c = true;
        nCaso.Sub_estado_Nectia__c = Label.PF_Creacion_Oportunidad;
        insert nCaso;
        
		
		cuenta = new Account();
        cuenta.RUT__c = '16604173-2';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.FirstName='Jorge';
        cuenta.LastName = 'Perez';
        cuenta.phone = '1333332444';
        cuenta.PersonEmail = 'test2@test2.cl';
        insert cuenta;

       
        
        cuenta = new Account();
        cuenta.RUT__c = '3-5';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.FirstName='Pedro';
        cuenta.LastName = 'Perez';
        cuenta.phone = '1311111222';
        cuenta.PersonEmail = 'test3@test3.cl';
        insert cuenta;
		
		nCaso = new Case();
		nCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Caso_PF_Caso_de_Portabilidad').getRecordTypeId();
		nCaso.Caso_PF_Cliente_apto__c = true;
        nCaso.Status = Label.PF_Cerrado;
        nCaso.AccountId = cuenta.Id;
		nCaso.Rut__c = cuenta.RUT__c;
        ncaso.Rut_del_Cliente__c = cuenta.RUT__c;
        nCaso.Caso_PF_Credito_Hipotecario__c = false;
        nCaso.Caso_PF_Credito_Consumo__c = true;
        nCaso.Caso_PF_Plan_Plus__c = true;
        nCaso.Sub_estado_Nectia__c = Label.PF_Rechazado_No_Apto;
        insert nCaso;

     
    }

    /* se prueba un caso de Apto con hipotecario, que debiese ir a la cola "Port. Hipotecario" 
     ************************************************************************************/
    @isTest static void testCrearCasosAptoConHipot() {
		String json = '{"codigo":"1","mensaje":"OK", "respuesta" : {"hipotecario":true,"hipotecarioConCNS":false,"segmentacionCliente":"texto"}}';
        PFCalloutMock fakeResponse = new PFCalloutMock(200, 'ok', json, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        User us = [SELECT Id FROM User WHERE RUT__c = '24770129k'];
        System.Test.startTest();
        String response = '';
        System.runAs(us) {
            RestRequest request = new RestRequest();
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueof(pruebaJSon_Apto_Hipotecario());
            RestContext.request = request;
            
            response = PF_CrearCaso_WSRest.crearCasosPF();
       }
		System.Test.stopTest();
		for (Case nCaso : consultaCasosCreados(response)){
			system.assertEquals(Label.PF_Pre_Portabilidad, nCaso.Status);
			system.assertEquals(Label.PF_Creacion_Oportunidad, nCaso.Sub_estado_Nectia__c);
			system.assertEquals(true, nCaso.get(Label.PF_Campo_Caso_Hipotecario));
			system.assertEquals(true, nCaso.get(Label.PF_Campo_Caso_Consumo));
			system.assertEquals(true, nCaso.get(Label.PF_Campo_Caso_PlanPlus));
		}
    }
	    /* se prueba un caso de Apto con hipotecario, que debiese ir a la cola "Casos de Portabilidad" 
     ************************************************************************************/
    @isTest static void testCrearCasosAptoSinHipot() {
		String json = '{"codigo":"1","mensaje":"OK", "respuesta" : {"hipotecario":true,"hipotecarioConCNS":false,"segmentacionCliente":"texto"}}';
        PFCalloutMock fakeResponse = new PFCalloutMock(200, 'ok', json, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        User us = [SELECT Id FROM User WHERE RUT__c = '24770129k'];
        System.Test.startTest();
        String response = '';
        String responseDupl = '';
        System.runAs(us) {

            RestRequest request = new RestRequest();
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueof(pruebaJSon_Apto_NO_Hipotecario());
            RestContext.request = request;
    
            response = PF_CrearCaso_WSRest.crearCasosPF();
		}
		List<Case> lstCasos = consultaCasosCreados(response);
		for (Case nCaso : lstCasos){
            nCaso.Correo_electr_nico__c = 'Test@test.com';
        }
		//Update lstCasos;

        System.Test.stopTest();

      for (Case nCaso : consultaCasosCreados(response)){

                system.assertEquals(Label.PF_Pre_Portabilidad, nCaso.Status);
                system.assertEquals(Label.PF_Creacion_Oportunidad, nCaso.Sub_estado_Nectia__c);
                system.assertEquals(false, nCaso.get(Label.PF_Campo_Caso_Hipotecario));
                system.assertEquals(true, nCaso.get(Label.PF_Campo_Caso_Consumo));
                system.assertEquals(true, nCaso.get(Label.PF_Campo_Caso_PlanPlus));
 
	    }
    }
 
	
	
    /* se prueba un caso de Apto con hipotecario duplicado, que debiese ir a la cola "Casos de Portabilidad" 
     ************************************************************************************/
    @isTest static void testCrearCasosAptoConHipotDup() {
		String json = '{"codigo":"1","mensaje":"OK", "respuesta" : {"hipotecario":true,"hipotecarioConCNS":false,"segmentacionCliente":"texto"}}';
        PFCalloutMock fakeResponse = new PFCalloutMock(200, 'ok', json, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        User us = [SELECT Id FROM User WHERE RUT__c = '24770129k'];
        System.Test.startTest();
        String response = '';
        String responseDupl = '';

		System.runAs(us) {
            RestRequest request = new RestRequest();
            request = new RestRequest();
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueof(pruebaJSon_Apto_Duplicado());
            RestContext.request = request;
    
            response = PF_CrearCaso_WSRest.crearCasosPF();

		} 
        System.Test.stopTest();
        
        boolean primerCase = true;
      for (Case nCaso : consultaCasosCreados(response)){
            if (primerCase){
                system.assertEquals(Label.PF_Pre_Portabilidad, nCaso.Status);
                system.assertEquals(Label.PF_Creacion_Oportunidad, nCaso.Sub_estado_Nectia__c);
                system.assertEquals(false, nCaso.get(Label.PF_Campo_Caso_Hipotecario));
                system.assertEquals(true, nCaso.get(Label.PF_Campo_Caso_Consumo));
                system.assertEquals(true, nCaso.get(Label.PF_Campo_Caso_PlanPlus));
                primerCase = false;
            }else{
                system.assertEquals(Label.PF_Pre_Portabilidad, nCaso.Status);
                system.assertEquals(Label.PF_Creacion_Oportunidad, nCaso.Sub_estado_Nectia__c);
                system.assertEquals(true, nCaso.get(Label.PF_Campo_Caso_Hipotecario));
                system.assertEquals(true, nCaso.Caso_PF_Cliente_atendido_Ent__c);
            }
	    }
    }
    
    /* se prueba un caso de apto que se debe cerrar con sub-estado Rechazado
       y en cola "Casos Portabilidad No Apto"
     ************************************************************************************/
    @isTest static void testCrearCasosNoApto() {
		String json = '{"codigo":"1","mensaje":"OK", "respuesta" : {"hipotecario":true,"hipotecarioConCNS":false,"segmentacionCliente":"texto"}}';
        PFCalloutMock fakeResponse = new PFCalloutMock(200, 'ok', json, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        User us = [SELECT Id FROM User WHERE RUT__c = '24770129k'];
        System.Test.startTest();
        String response = '';
        System.runAs(us) {
            RestRequest request = new RestRequest();
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueof(pruebaJSon_NoApto());
            RestContext.request = request;
            
            response = PF_CrearCaso_WSRest.crearCasosPF();            
        }
       

        System.Test.stopTest();

 
        for (Case nCaso : consultaCasosCreados(response)){

                system.assertEquals(Label.PF_Cerrado, nCaso.Status);
            	system.assertEquals(Label.PF_Rechazado_No_Apto, nCaso.Sub_estado_Nectia__c);
        }
    }
	
	
	
	 /* se prueba un caso de apto que se debe cerrar con sub-estado Rechazado
       y en cola "Casos Portabilidad No Apto"
     ************************************************************************************/
    @isTest static void testCrearCasosNoAptoDup() {
		String json = '{"codigo":"1","mensaje":"OK", "respuesta" : {"hipotecario":true,"hipotecarioConCNS":false,"segmentacionCliente":"texto"}}';
        PFCalloutMock fakeResponse = new PFCalloutMock(200, 'ok', json, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        User us = [SELECT Id FROM User WHERE RUT__c = '24770129k'];
        System.Test.startTest();
        String response = '';
      
        
		/* Validamos caso nuevo Pero NO duplicado, porque el anterior estaba cerrado 
		****************************************************************************/ 
		System.runAs(us) {
            RestRequest request = new RestRequest();
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueof(pruebaJSon_AptoPrevioNoAptoNoDuplicado());
            RestContext.request = request;

            response = PF_CrearCaso_WSRest.crearCasosPF();
        }
        System.Test.stopTest();

       boolean primerCase = true;
        for (Case nCaso : consultaCasosCreados(response)){
            if (primerCase){
                system.assertEquals(Label.PF_Cerrado, nCaso.Status);
            	system.assertEquals(Label.PF_Rechazado_No_Apto, nCaso.Sub_estado_Nectia__c);
                primerCase = false;
            }else{
                system.assertEquals(Label.PF_Pre_Portabilidad, nCaso.Status);
                system.assertEquals(Label.PF_Creacion_Oportunidad, nCaso.Sub_estado_Nectia__c);
                system.assertEquals(true, nCaso.get(Label.PF_Campo_Caso_Hipotecario));
                system.assertEquals(false, nCaso.Caso_PF_Cliente_atendido_Ent__c);
            }
        }
    }
    
    // consultamos la información creada en los Casos    
    private static List<Case> consultaCasosCreados(String jsonResponse){
        List<Case> lstCasosPF = new List<Case>();
        List<String> lstRUT = new List<String>();
        String cuentaRUT;
                
        PF_CrearCasos_ReqResp_JSON response = PF_CrearCasos_ReqResp_JSON.parse(jsonResponse);
        List<PF_CrearCasos_ReqResp_JSON.PFCreaCasoreResp> subRespLst = response.PFCreaCasoreResp;

        for(PF_CrearCasos_ReqResp_JSON.PFCreaCasoreResp subResp : subRespLst){
            cuentaRUT = subResp.rutCliente;
			lstRUT.add(cuentaRUT);
        }
        
        lstCasosPF = [select Caso_PF_Cliente_atendido_Ent__c, Caso_PF_Plan_Plus__c, Caso_PF_Credito_Hipotecario__c, Caso_PF_Credito_Consumo__c, Status, Sub_estado_Nectia__c, OwnerId from Case where Rut__c IN: lstRUT];

        return lstCasosPF;
    }
    private static String pruebaJSon_Apto_Hipotecario(){
        String json = '{'+
            '  "PFCreaCasoreReq": ['+
            '    {'+
            '      "nombreCliente": "Juan Perez",'+
            '      "rutCliente": "9121329-k",'+
            '      "aptoNoApto": true,'+
            '      "productosPortar": ['+
            '        {"nombre": "Hipotecario"},'+
            '        {"nombre": "Consumo"},'+
            '        {"nombre": "Cuenta Corriente"}'+
            '      ]'+
            '    }'+
            '  ]'+
            '}';
        return json;
    }
    // funciona igual si no posee productos
    private static String pruebaJSon_Apto_NO_Hipotecario(){
        String json = '{'+
            '  "PFCreaCasoreReq": ['+
            '    {'+
            '      "nombreCliente": "2 Perez",'+
            '      "rutCliente": "16604173-2",'+
            '      "aptoNoApto": true,'+
            '      "productosPortar": ['+
            '        {"nombre": "Consumo"},'+
            '        {"nombre": "Cuenta Corriente"}'+
            '      ]'+
            '    }'+
            '  ]'+
            '}';
        return json;
    }
    // funciona igual si no posee productos
    private static String pruebaJSon_Apto_Duplicado(){
        String json = '{'+
            '  "PFCreaCasoreReq": ['+
            '    {'+
            '      "nombreCliente": "Maria Perez",'+
            '      "rutCliente": "6978755-k",'+
            '      "aptoNoApto": true,'+
            '      "productosPortar": ['+
            '        {"nombre": "Hipotecario"}'+
            '      ]'+
            '    }'+
            '  ]'+
            '}';
        return json;
    }
	private static String pruebaJSon_NoApto(){
        String json = '{'+
            '  "PFCreaCasoreReq": ['+
            '    {'+
            '      "nombreCliente": "Jorge Perez",'+
            '      "rutCliente": "16604173-2",'+
            '      "aptoNoApto": false,'+
            '      "productosPortar": ['+
            '        {"nombre": "Hipotecario"},'+
            '        {"nombre": "Consumo"}'+
            '      ]'+
            '    }'+
            '  ]'+
            '}';
        return json;
    }
    // Este se debe crear, pero no marcar el check de duplicado
    private static String pruebaJSon_AptoPrevioNoAptoNoDuplicado(){
        String json = '{'+
            '  "PFCreaCasoreReq": ['+
            '    {'+
            '      "nombreCliente": "Pedro Perez",'+
            '      "rutCliente": "3-5",'+
            '      "aptoNoApto": true,'+
            '      "productosPortar": ['+
            '        {"nombre": "Hipotecario"},'+
            '        {"nombre": "Consumo"}'+
            '      ]'+
            '    }'+
            '  ]'+
            '}';
        return json;
    }
}