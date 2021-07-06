/**
 * @File Name          : OfferValidityBatch_Test.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 6/22/2020, 11:03:22 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/22/2020   eayalcor@everis.com     Initial Version
**/
@isTest
private class OfferValidityBatch_Test {
	@TestSetup
    static void makeData(){
        Date myDate = date.newInstance(2020, 6, 19);
        
        System.debug('DATE:' + myDate);
        
        TestFactorySales.populateOrg();        

        Oferta__c offer = new Oferta__c();
        offer.Name= 'OFERID';
        offer.Ejecutivo_sales__c= '1-9';
        offer.Rut_Cliente_sales__c= '10854082-6';
        offer.Vigencia_Oferta_sales__c= myDate;
        offer.Familia_Producto_sales__c= 'PLAN PLUS';
        offer.Descripcion_oferta_sales__c = '<p>test</p>';
        offer.Detalle_sales__c = 'Nueva Oferta';
        offer.Origen_sales__c = 'Contact Center';
        offer.Estado_Oferta_sales__c = CONSTANTS.OFERTA_NOGESTIONADO;
        offer.Vigente_sales__c = true;
        offer.AccountId__c = [SELECT Id FROM Account WHERE Rut__c = '10854082-6' LIMIT 1].Id;
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
    
    @isTest
    static void testBatchOffer(){
        
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        Test.startTest();
        OfferValidityScheduler osb = new OfferValidityScheduler();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, osb);
        osb.execute(null);
        Test.stopTest();
    }
}