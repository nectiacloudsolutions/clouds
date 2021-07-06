@isTest
private with sharing class RestEjecutivosControllerTest {

    @testSetup
    private static void loadDataConfig(){
        TestFactorySales.populateOrg();
    }

    @isTest
    static void ObtenerEjecutivosPlus_Test_success(){

        UsersDataList response = new UsersDataList();
		Test.startTest();
 
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Ejecutivos/ObtenerEjecutivosPlus';  //Request URL
        req.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;

        response = RestEjecutivosController.ObtenerEjecutivosPlus();
        
        Test.stopTest();
        System.assertEquals(response.action, Constants.OK);

    }

    @isTest
    static void obtenerNombresEjecutivosDeCliente_Test_Success(){

        EjecutivosClienteResponse response = new EjecutivosClienteResponse(); 

        Test.startTest();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        Account acct = new Account();

        acct.Lastname = 'Test2';
        acct.phone = '3383737';
        acct.RUT__c = '5705530-8';

        insert acct;
       


        req.requestURI = '/services/apexrest/Ejecutivos/ObtenerEjecutivosPlus';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.addParameter('rutCliente', '5705530-8');
        RestContext.request = req;
        RestContext.response= res;

        response = RestEjecutivosController.obtenerNombresEjecutivosDeCliente();
        
        Test.stopTest();
        System.assertEquals(response.action, Constants.OK);

    }

    @isTest
    static void obtenerNombresEjecutivosDeCliente_Test_Success_Notfound(){

        EjecutivosClienteResponse response = new EjecutivosClienteResponse(); 

        Test.startTest();

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        Account acct = new Account();

        acct.Lastname = 'Test2';
        acct.phone = '3383737';
        acct.RUT__c = '5705530-8';

        insert acct;
       


        req.requestURI = '/services/apexrest/Ejecutivos/ObtenerEjecutivosPlus';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.addParameter('rutCliente', '1111111-3');
        RestContext.request = req;
        RestContext.response= res;

        response = RestEjecutivosController.obtenerNombresEjecutivosDeCliente();
        
        Test.stopTest();
        System.assertEquals(response.action, Constants.OK);

    }

}