/**
 * @description       : 
 * @author            : eayalcor@everis.com
 * @group             : 
 * @last modified on  : 09-21-2020
 * @last modified by  : eayalcor@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   09-21-2020   eayalcor@everis.com   Initial Version
**/
@isTest
private with sharing class OppQuoteService_Test {
    @testSetup
    private static void loadDataConfig(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();

        User user = (User)mpsObjects.get('User8');
        Account acc = (Account)mpsObjects.get('Account');

        List<Product2> lstInsPro = new List<Product2>();

        Product2 p1 = new Product2();
        p1.IsActive = true;
        p1.ProductCode = '800';
        p1.Name = 'Test1';
        p1.codigo_producto_sales__c= '2';
        p1.Codigo_Macroproducto_Operacional_sales__c='9';
        p1.tipo_producto_sales__c = 'Sales_Seguros_Auto';
        p1.Family = 'AUTO';
        p1.flujo_integrado_sales__c = false;
        lstInsPro.add(p1);

        Product2 p2 = new Product2();
        p2.IsActive = true;
        p2.ProductCode = '801';
        p2.Name = 'Test2';
        p2.codigo_producto_sales__c= '2';
        p2.Codigo_Macroproducto_Operacional_sales__c='9';
        p2.tipo_producto_sales__c = 'Sales_Seguros_Auto';
        p2.Family = 'AUTO';
        lstInsPro.add(p2);

        Product2 p3 = new Product2();
        p3.IsActive = true;
        p3.ProductCode = '802';
        p3.Name = 'Test3';
        p3.codigo_producto_sales__c= '2';
        p3.Codigo_Macroproducto_Operacional_sales__c='9';
        p3.tipo_producto_sales__c = 'Sales_Seguros_Auto';
        p3.Family = 'AUTO';
        p3.flujo_integrado_sales__c = true;
        lstInsPro.add(p3);

        insert lstInsPro;
        
        Id idProd2 = Test.getStandardPricebookId();

        List<PricebookEntry> lstPriEntry = new List<PricebookEntry>();
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = idProd2;
        pbe.Product2Id = p2.Id;
        pbe.UnitPrice = 1;
        pbe.IsActive = true;
        lstPriEntry.add(pbe);

        PricebookEntry pbe2 = new PricebookEntry();
        pbe2.Pricebook2Id = idProd2;
        pbe2.Product2Id = p3.Id;
        pbe2.UnitPrice = 1;
        pbe2.IsActive = true;
        lstPriEntry.add(pbe2);

        insert lstPriEntry;
        
        List<Opportunity> lstOpp = new List<Opportunity>();

        Opportunity newOpp = new Opportunity();
        newOpp.StageName = Constants.PLAN_PLUS_STATUS_RECOPILACION;
        newOpp.CloseDate = Date.TODAY().addMonths(1);
        newOpp.AccountId = acc.Id;
        newOpp.Name = 'Test3 - 1 - Prueba';
        newOpp.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: p2.tipo_producto_sales__c LIMIT 1].Id;
        newOpp.OwnerId = user.Id;
        lstOpp.add(newOpp);
        
        Opportunity newOpp2 = new Opportunity();
        newOpp2.StageName = Constants.PLAN_PLUS_STATUS_RECOPILACION;
        newOpp2.CloseDate = Date.TODAY().addMonths(1);
        newOpp2.AccountId = acc.Id;
        newOpp2.Name = 'Test3 - 1 - Prueba2';
        newOpp2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: p2.tipo_producto_sales__c LIMIT 1].Id;
        newOpp2.OwnerId = user.Id;
        lstOpp.add(newOpp2);
        
        insert lstOpp;
        
        OpportunityLineItem opli = new OpportunityLineItem();
        opli.OpportunityId = lstOpp[0].Id;
        opli.PricebookEntryId = pbe.Id;
        opli.Quantity = 1;
        opli.UnitPrice = 1;
        opli.Product2Id = p2.Id;
        insert opli;
    }
    
    @isTest
    static void invokeServiceGetTest(){
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity WHERE Name = 'Test3 - 1 - Prueba' LIMIT 1];
        OppQuoteService.ResponseGet response = new OppQuoteService.ResponseGet();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/quoteIntegrator/';  //Request URL
        req.httpMethod = 'GET';//HTTP Request Type
        
        RestContext.request = req;
        RestContext.response= res;
        
        req.addParameter('opportunityId', lstOpp[0].Id);
        
        response = OppQuoteService.invokeServiceGet();

        System.assertEquals(response.response.statusCode, Constants.RESPONSE_200);
    }
    
    @isTest
    static void invokeServiceGetTest2(){
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity WHERE Name = 'Test3 - 1 - Prueba' LIMIT 1];
        OppQuoteService.ResponseGet response = new OppQuoteService.ResponseGet();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/quoteIntegrator/';  //Request URL
        req.httpMethod = 'GET';//HTTP Request Type
        
        RestContext.request = req;
        RestContext.response= res;
        
        response = OppQuoteService.invokeServiceGet();

        System.assertEquals(response.response.statusCode, Constants.RESPONSE_400);
    }
    
    @isTest
    static void invokeServiceGetTest3(){
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity WHERE Name = 'Test3 - 1 - Prueba' LIMIT 1];
        OppQuoteService.ResponseGet response = new OppQuoteService.ResponseGet();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/quoteIntegrator/';  //Request URL
        req.httpMethod = 'GET';//HTTP Request Type
        
        RestContext.request = req;
        RestContext.response= res;
        
        req.addParameter('opportunityId','1234');
        
        response = OppQuoteService.invokeServiceGet();

        System.assertEquals(response.response.statusCode, Constants.RESPONSE_400);
    }
/**
========================================================================================================================
----------------------------------------------------TEST POST----------------------------------------------------------
========================================================================================================================
*/
    @isTest
    static void invokeServicePostTest1(){

        Test.startTest();

        List<Quote> lstQuotes = new List<Quote>();
        List<Opportunity> lstOpp = [SELECT Id,Etapas_Cotizador_Sales__c FROM Opportunity WHERE Name = 'Test3 - 1 - Prueba' LIMIT 1];
        lstOpp[0].Etapas_Cotizador_Sales__c = 1;

        List<Product2> lstPro = [SELECT Id, ProductCode FROM Product2 WHERE PRoductCode = '801'];

        OppQuoteService.RequestPost request = new OppQuoteService.RequestPost();
        OppQuoteService.ResponsePost response = new OppQuoteService.ResponsePost();

        request.opportunity = lstOpp[0];
        request.product2 = lstPro[0];

        Quote oneQuote = new Quote();
        oneQuote.Numero_de_Cotizacion_sales__c = '123';
        oneQuote.Tarifa_Anual_UF_sales__c = 10.2;
        lstQuotes.add(oneQuote);

        Quote twoQuote = new Quote();
        twoQuote.Numero_de_Cotizacion_sales__c = '123';
        twoQuote.Tarifa_Anual_UF_sales__c = 10.2;
        lstQuotes.add(twoQuote);

        request.quotes = lstQuotes;

        String json = JSON.serialize(request);
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/quoteIntegrator/';  //Request URL
        req.httpMethod = Constants.REQUEST_METHOD_POST;//HTTP Request Type
        req.requestBody = Blob.valueOf(json);
        RestContext.request = req;
        RestContext.response= res;
        
        response = OppQuoteService.invokeServicePost();

        Test.stopTest();

        System.assertEquals(response.response.statusCode, Constants.RESPONSE_200);
    }

    @isTest
    static void invokeServicePostTest2(){

        Test.startTest();

        List<Quote> lstQuotes = new List<Quote>();
        List<Opportunity> lstOpp = [SELECT Id,Etapas_Cotizador_Sales__c FROM Opportunity WHERE Name = 'Test3 - 1 - Prueba' LIMIT 1];
        lstOpp[0].Etapas_Cotizador_Sales__c = 1;

        List<Product2> lstPro = [SELECT Id, ProductCode FROM Product2 WHERE PRoductCode = '802'];

        OppQuoteService.RequestPost request = new OppQuoteService.RequestPost();
        OppQuoteService.ResponsePost response = new OppQuoteService.ResponsePost();

        request.opportunity = lstOpp[0];
        request.product2 = lstPro[0];

        Quote oneQuote = new Quote();
        oneQuote.Numero_de_Cotizacion_sales__c = '123';
        oneQuote.Tarifa_Anual_UF_sales__c = 10.2;
        lstQuotes.add(oneQuote);

        Quote twoQuote = new Quote();
        twoQuote.Numero_de_Cotizacion_sales__c = '123';
        twoQuote.Tarifa_Anual_UF_sales__c = 10.2;
        lstQuotes.add(twoQuote);

        request.quotes = lstQuotes;

        String json = JSON.serialize(request);
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/quoteIntegrator/';  //Request URL
        req.httpMethod = Constants.REQUEST_METHOD_POST;//HTTP Request Type
        req.requestBody = Blob.valueOf(json);
        RestContext.request = req;
        RestContext.response= res;
        
        response = OppQuoteService.invokeServicePost();

        Test.stopTest();

        System.assertEquals(response.response.statusCode, Constants.RESPONSE_200);
    }
}