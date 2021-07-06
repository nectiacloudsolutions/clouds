/**
 * @File Name          : OfertaAnalytics_Test.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 6/4/2020, 12:50:24 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/4/2020   eayalcor@everis.com     Initial Version
**/
@isTest
private with sharing class OfertaAnalytics_Test {
    
    /**
    * @description 
    * @author eayalcor@everis.com | 6/4/2020 
    * @return void 
    **/
    @TestSetup
    static void makeData(){
        TestFactorySales.populateOrg();
    }

    @isTest
    static void testInvokeService(){
        OfertaAnalytics.Request request = new OfertaAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        List<Oferta__c> lstOffers = new List<Oferta__c>();

        Test.startTest();

        Oferta__c offer = new Oferta__c();
        offer.Name= 'OFERID';
        offer.Ejecutivo_sales__c= '1-9';
        offer.Rut_Cliente_sales__c= '10854082-6';
        offer.Vigencia_Oferta_sales__c= Date.today();
        offer.Familia_Producto_sales__c= 'PLAN PLUS';
        offer.Descripcion_oferta_sales__c = '<p>test</p>';
        offer.Detalle_sales__c = 'Nueva Oferta';
        offer.Origen_sales__c = 'Contact Center';
        lstOffers.add(offer); 

        Oferta__c offer2 = new Oferta__c();
        offer2.Name= 'OFERID';
        offer2.Ejecutivo_sales__c= '19';
        offer2.Rut_Cliente_sales__c= '6129422-8';
        offer2.Vigencia_Oferta_sales__c= Date.today();
        offer2.Familia_Producto_sales__c= 'PLAN PLUS';
        offer2.Descripcion_oferta_sales__c = '<p>test</p>';
        offer2.Detalle_sales__c = 'Nueva Oferta';
        offer2.Origen_sales__c = 'Contact Center';
        lstOffers.add(offer2); 

        Oferta__c offer3 = new Oferta__c();
        offer3.Name= '';
        offer3.Ejecutivo_sales__c= '19';
        offer3.Rut_Cliente_sales__c= '6129422-8';
        offer3.Vigencia_Oferta_sales__c= Date.today();
        offer3.Familia_Producto_sales__c= 'PLAN PLUS';
        offer3.Descripcion_oferta_sales__c = '<p>test</p>';
        offer3.Detalle_sales__c = 'Nueva Oferta';
        offer3.Origen_sales__c = 'Contact Center';
        lstOffers.add(offer3); 
        
        Oferta__c offer4 = new Oferta__c();
        offer4.Name= 'Test';
        offer4.Ejecutivo_sales__c= '22592674-3';
        offer4.Rut_Cliente_sales__c= '6129422-8';
        offer4.Vigencia_Oferta_sales__c= Date.today();
        offer4.Familia_Producto_sales__c= 'PLAN PLUS';
        offer4.Descripcion_oferta_sales__c = '<p>test</p>';
        offer4.Detalle_sales__c = 'Nueva Oferta';
        offer4.Origen_sales__c = 'Contact Center';
        lstOffers.add(offer4); 

        request.records = lstOffers;

        String json = JSON.serialize(request);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/oferta/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        Test.stopTest();

        response = OfertaAnalytics.invokeService();
        System.assertEquals(response.response.size(), 4);
    }

}