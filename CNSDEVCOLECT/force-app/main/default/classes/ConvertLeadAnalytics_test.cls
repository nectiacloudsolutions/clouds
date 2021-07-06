/**
 * @File Name          : ConvertLeadAnalytics_test.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 31-01-2020 14:10:18
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    31-01-2020   eayalcor@everis.com     Initial Version
**/
@isTest
private with sharing class ConvertLeadAnalytics_test {
	@testSetup
    private static void loadDataConfig(){
        TestFactorySales.populateOrg();
    }
    
    @isTest
    static void ConvertLeadAnalytics_test01(){
        ConvertLeadAnalytics.Request request = new ConvertLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();
        
        
        List<Lead> lstLead = new List<Lead>();

        Test.startTest();

        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '8813645-4';
        newLead.numero_de_documento_sales__c = '19957117-6';
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
		insert newLead;
        lstLead.add(newLead);

        request.records = lstLead;

        String json = JSON.serialize(request);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/LeadConvert';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = ConvertLeadAnalytics.convertLeads();
        System.debug(response);
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_200);
        
        
    }
    
            @isTest
    static void ConvertLeadAnalytics_test02(){
        ConvertLeadAnalytics.Request request = new ConvertLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();
        
        
        List<Lead> lstLead = new List<Lead>();

        Test.startTest();

        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '8813645-4';
        newLead.numero_de_documento_sales__c = '19375864-6';
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

        req.requestURI = '/services/apexrest/LeadConvert';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = ConvertLeadAnalytics.convertLeads();
        System.debug(response);
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_400);
        
        
    }
    
        @isTest
    static void ConvertLeadAnalytics_test03(){
        ConvertLeadAnalytics.Request request = new ConvertLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();
        
        
        List<Lead> lstLead = new List<Lead>();

        Test.startTest();

        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '';
        newLead.numero_de_documento_sales__c = '19957117-6';
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
		insert newLead;
        lstLead.add(newLead);

        request.records = lstLead;

        String json = JSON.serialize(request);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/LeadConvert';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = ConvertLeadAnalytics.convertLeads();
        System.debug(response);
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_200);
        
        
    }
     @isTest
    static void ConvertLeadAnalytics_test04(){
        ConvertLeadAnalytics.Request request = new ConvertLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();
        
        
        List<Lead> lstLead = new List<Lead>();

        Test.startTest();

        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '';
        newLead.numero_de_documento_sales__c = '18989632-8';
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
		insert newLead;
        lstLead.add(newLead);

        request.records = lstLead;

        String json = JSON.serialize(request);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/LeadConvert';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = ConvertLeadAnalytics.convertLeads();
        System.debug(response);
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_200);
        
        
    }
    
}