/**
 * @File Name          : OfferCmpController_Test.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 6/23/2020, 11:07:20 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/2/2020   eayalcor@everis.com     Initial Version
**/
@isTest 
public with sharing class OfferCmpController_Test {
    /**
    * @description 
    * @author eayalcor@everis.com | 6/2/2020 
    * @return void 
    **/
    @TestSetup
    static void makeData(){
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg(); 
        User usr = (User)mapsObjects.get('User');      

        Oferta__c offer = new Oferta__c();
        offer.Name= 'OFERID';
        offer.Ejecutivo_sales__c= '1-9';
        offer.Rut_Cliente_sales__c= '10854082-6';
        offer.Vigencia_Oferta_sales__c= Date.today();
        offer.Familia_Producto_sales__c= 'PLAN PLUS';
        offer.Descripcion_oferta_sales__c = '<p>test</p>';
        offer.Detalle_sales__c = 'Nueva Oferta';
        offer.Origen_sales__c = 'Contact Center';
        offer.AccountId__c = [SELECT Id FROM Account WHERE Rut__c = '10854082-6' LIMIT 1].Id;
        offer.Owner_Opp_sales__c = usr.Id;
        insert offer;

        Product2 p2 = new Product2();
        p2.IsActive = true;
        p2.ProductCode = '801';
        p2.Name = 'Test';
        p2.codigo_producto_sales__c= '2';
        p2.Codigo_Macroproducto_Operacional_sales__c='1';
        p2.tipo_producto_sales__c = 'plan_plus_sales';
        p2.Family = Constants.PLAN_PLUS;

        insert p2;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 6/2/2020 
    * @return void 
    **/
    @isTest
    static void testGetInitialData(){

        Test.startTest();
        List<Oferta__c> lstOffer = [SELECT Id,Name,AccountId__c,Ejecutivo_sales__c,Rut_Cliente_sales__c,
        Familia_Producto_sales__c,Vigencia_Oferta_sales__c,Motivo_no_interes_sales__c,Estado_Oferta_sales__c FROM Oferta__c LIMIT 1];
        
        OfferCmpController.ResponseData response = OfferCmpController.getInitialData(lstOffer[0].Id);

        Test.stopTest();

        System.assertEquals(lstOffer[0].Name, response.offer.Name);
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 6/2/2020 
    * @return void 
    **/
    @isTest
    static void testRejectOffer(){
        Test.startTest();
        List<Oferta__c> lstOffer = [SELECT Id,Name,AccountId__c,Ejecutivo_sales__c,Rut_Cliente_sales__c,
        Familia_Producto_sales__c,Vigencia_Oferta_sales__c,Motivo_no_interes_sales__c,Estado_Oferta_sales__c FROM Oferta__c LIMIT 1];
        
        List<String> lst = UtilitiesSales.getPicklistData(Oferta__c.Motivo_no_interes_sales__c);

        String response = OfferCmpController.rejectOffer(lstOffer[0].Id,lst[0]);

        Test.stopTest();

        System.assertEquals(Constants.OK, response);
    }

    @isTest
    static void testGenerateOpportunity(){
        Test.startTest();
        List<Oferta__c> lstOffer = [SELECT Id,Name,AccountId__c,Ejecutivo_sales__c,Rut_Cliente_sales__c,
        Familia_Producto_sales__c,Vigencia_Oferta_sales__c,Motivo_no_interes_sales__c,Estado_Oferta_sales__c FROM Oferta__c LIMIT 1];

        String response = OfferCmpController.generateOpportunity(lstOffer[0].Id,'test');

        Test.stopTest();

        System.assertEquals(Constants.OK, response);
    }

}