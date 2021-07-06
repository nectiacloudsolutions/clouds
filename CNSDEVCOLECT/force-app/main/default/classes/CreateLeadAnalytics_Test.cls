/*********************************************************************************************************
@Author       eayalcor@everis.com
@name         CreateLeadAnalytics
@CreateDate   03/10/2019
@Description  Test Class for CreateLeadAnalytics
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
04/10/2019                    eayalcor@everis.com           Initial Version
**********************************************************************************************************/
@isTest
private with sharing class CreateLeadAnalytics_Test {
    @testSetup
    private static void loadDataConfig(){
        TestFactorySales.populateOrg();
    }

    /**
      * @description       Test method - 05-ERROR_DATACONTACT
      * @param1            void
      * @return            void
      * @throws            NA
    */
    @isTest
    static void createLeadAnalyticsTest01(){
        CreateLeadAnalytics.Request request = new CreateLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        List<Lead> lstLead = new List<Lead>();

        Test.startTest();

        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '8813645-4';
        newLead.numero_de_documento_sales__c = '7811844-K';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = '';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = '';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = Datetime.now();
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = 'Alta';

        lstLead.add(newLead);

        request.records = lstLead;

        String json = JSON.serialize(request);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Lead';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = CreateLeadAnalytics.assignLeads();
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_400);

    }
    /**
      * @description       Test method - 01-ERROR_ACCOUNT
      * @param1            void
      * @return            void
      * @throws            NA
    */
    @isTest
    static void createLeadAnalyticsTest02(){
        CreateLeadAnalytics.Request request = new CreateLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        List<Lead> lstLead = new List<Lead>();

        Test.startTest();

        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '8813645-4';
        newLead.numero_de_documento_sales__c = '10854082-6';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = 'test@test.cl';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = 'Analytics';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = Datetime.now();
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = 'Alta';

        lstLead.add(newLead);

        request.records = lstLead;

        String json = JSON.serialize(request);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Lead';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = CreateLeadAnalytics.assignLeads();
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_400);

    }
    /**
      * @description       Test method - 04-ERROR_LEAD_NOOWNER
      * @param1            void
      * @return            void
      * @throws            NA
    */
    @isTest
    static void createLeadAnalyticsTest03(){
    
        CreateLeadAnalytics.Request request = new CreateLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        List<Lead> lstLead = new List<Lead>();

        Test.startTest();

        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '8813645-4';
        newLead.numero_de_documento_sales__c = '9669258-7';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = 'test@test.cl';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = 'Analytics';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = Datetime.now();
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = 'Alta';

        lstLead.add(newLead);

        request.records = lstLead;

        String json = JSON.serialize(request);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Lead';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = CreateLeadAnalytics.assignLeads();
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_400);
    }
    /**
      * @description       Test method - 00-OK
      * @param1            void
      * @return            void
      * @throws            NA
    */
    @isTest
    static void createLeadAnalyticsTest04(){

        CreateLeadAnalytics.Request request = new CreateLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        List<Lead> lstLead = new List<Lead>();

        Test.startTest();

        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '8813645-4';
        newLead.numero_de_documento_sales__c = '17678241-2';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = 'test@test.cl';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = 'Analytics';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = Datetime.now();
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = 'Alta';

        lstLead.add(newLead);

        request.records = lstLead;

        String json = JSON.serialize(request);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Lead';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = CreateLeadAnalytics.assignLeads();
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_200);

    }
    /**
      * @description       Test method - 06-RUTEXECUTIVE
      * @param1            void
      * @return            void
      * @throws            NA
    */
    @isTest
    static void createLeadAnalyticsTest05(){

        CreateLeadAnalytics.Request request = new CreateLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        List<Lead> lstLead = new List<Lead>();

        Test.startTest();

        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '';
        newLead.numero_de_documento_sales__c = '';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = 'test@test.cl';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = '';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = Datetime.now();
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = '';

        lstLead.add(newLead);

        request.records = lstLead;

        String json = JSON.serialize(request);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Lead';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = CreateLeadAnalytics.assignLeads();
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_400);

    }
    /**
      * @description       Test method - 07-ERROR_SLA
      * @param1            void
      * @return            void
      * @throws            NA
    */
    @isTest
    static void createLeadAnalyticsTest06(){

        CreateLeadAnalytics.Request request = new CreateLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        List<Lead> lstLead = new List<Lead>();

        Test.startTest();

        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '1-9';
        newLead.numero_de_documento_sales__c = '';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = 'test@test.cl';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = 'Analytics';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = null;
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = 'Alta';

        lstLead.add(newLead);

        request.records = lstLead;

        String json = JSON.serialize(request);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Lead';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = CreateLeadAnalytics.assignLeads();
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_400);

    }
    /**
      * @description       Test method - 02-ERROR_EXECUTIVE
      * @param1            void
      * @return            void
      * @throws            NA
    */
    @isTest
    static void createLeadAnalyticsTest07(){

        CreateLeadAnalytics.Request request = new CreateLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        List<Lead> lstLead = new List<Lead>();

        Test.startTest();

        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '8591016-7';
        newLead.numero_de_documento_sales__c = '9669258-7';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = 'test@test.cl';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = 'Analytics';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = datetime.now();
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = 'Alta';

        lstLead.add(newLead);

        request.records = lstLead;

        String json = JSON.serialize(request);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Lead';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = CreateLeadAnalytics.assignLeads();
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_400);

    }
    /**
      * @description       Test method - 03-ERROR_LEAD_OWNER
      * @param1            void
      * @return            void
      * @throws            NA
    */
    @isTest
    static void createLeadAnalyticsTest08(){

        CreateLeadAnalytics.Request request = new CreateLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        List<Lead> lstLead = new List<Lead>();

        Test.startTest();

        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '1-9';
        newLead.numero_de_documento_sales__c = '9669258-7';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = 'test@test.cl';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = 'Analytics';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = datetime.now();
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = 'Alta';

        lstLead.add(newLead);

        request.records = lstLead;

        String json = JSON.serialize(request);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Lead';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = CreateLeadAnalytics.assignLeads();
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_400);

    }
    /**
      * @description       Test method - 08-ERROR_RATING
      * @param1            void
      * @return            void
      * @throws            NA
    */
    @isTest
    static void createLeadAnalyticsTest09(){

        CreateLeadAnalytics.Request request = new CreateLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        List<Lead> lstLead = new List<Lead>();

        Test.startTest();

        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '1-9';
        newLead.numero_de_documento_sales__c = '17678241-2';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = 'test@test.cl';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = 'Analytics';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = Datetime.now();
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = '';

        lstLead.add(newLead);

        request.records = lstLead;

        String json = JSON.serialize(request);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Lead';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = CreateLeadAnalytics.assignLeads();
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_400);

    }
    /**
      * @description       Test method - 09-ERROR_FORMATRUT
      * @param1            void
      * @return            void
      * @throws            NA
    */
    @isTest
    static void createLeadAnalyticsTest10(){

        CreateLeadAnalytics.Request request = new CreateLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        List<Lead> lstLead = new List<Lead>();

        Test.startTest();

        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '8813645-4';
        newLead.numero_de_documento_sales__c = '17678241-1';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = 'test@test.cl';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = '';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = Datetime.now();
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = 'Alta';

        lstLead.add(newLead);

        request.records = lstLead;

        String json = JSON.serialize(request);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/Lead';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = CreateLeadAnalytics.assignLeads();
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_400);

    }
}