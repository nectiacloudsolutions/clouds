/**
 * @File Name          : HeaderOppLineItemControllerTest.apxc
 * @Description        : Clase test del controlador HeaderOppLineItemControllerTest.apxc
 * @Author             : claudia.villalobos@everis.com
 * @Group              : 
 * @Last Modified By   : claudia.villalobos@everis.com
 * @Last Modified On   : 1/27/2021, 4:43:06 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    1/27/2021   claudia.villalobos@everis.com    Initial Version
**/
@isTest 
public with sharing class HeaderOppLineItemControllerTest {
	/**
    * @description 
    * @author claudia.villalobos@everis.com | 1/27/2021 
    * @return void 
    **/
    private static final String USER_8 = 'User8';
    private static final String ACCOUNT_NAME = 'Account';
    private static final String PRODUCT_CODE = '801';
    private static final String PRODUCT_NAME = 'Plan Plus';
    private static final String DOS = '2';
    private static final String UNO = '1';
    private static final String TIPO_PRODUCTO = 'plan_plus_sales';
    private static final String OPP_NAME = 'Test Opp';
    private static final String OLI_NAME = 'Test Opp Plan Plus';
    
    @TestSetup
    static void makeData(){
        Test.startTest();
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();

        User user = (User)mpsObjects.get(USER_8);
        Account acc = (Account)mpsObjects.get(ACCOUNT_NAME);

        Product2 p2 = new Product2();
        p2.IsActive = true;
        p2.ProductCode = PRODUCT_CODE;
        p2.Name = PRODUCT_NAME;
        p2.codigo_producto_sales__c= DOS;
        p2.Codigo_Macroproducto_Operacional_sales__c=UNO;
        p2.tipo_producto_sales__c = TIPO_PRODUCTO;
        p2.Family = Constants.PLAN_PLUS;

        insert p2;
        
        Id idProd2 = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = idProd2;
        pbe.Product2Id = p2.Id;
        pbe.UnitPrice = 1;
        pbe.IsActive = true;
        insert pbe;
        
        Opportunity newOpp = new Opportunity();
        newOpp.StageName = Constants.PLAN_PLUS_STATUS_RECOPILACION;
        newOpp.CloseDate = Date.TODAY().addMonths(1);
        newOpp.AccountId = acc.Id;
        newOpp.Name = OPP_NAME;
        newOpp.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: p2.tipo_producto_sales__c LIMIT 1].Id;
        newOpp.OwnerId = user.Id;
        
        insert newOpp;
        
        OpportunityLineItem opli = new OpportunityLineItem();
        opli.OpportunityId = newOpp.Id;
        opli.PricebookEntryId = pbe.Id;
        opli.Quantity = 1;
        opli.UnitPrice = 1;
        opli.Product2Id = p2.Id;
        insert opli;
        Test.stopTest();
    }
    /**
    * @description Obtenemos la data para llenar el formulario
    * @author claudia.villalobos@everis.com | 1/27/2021 
    * @return void 
    **/
    @isTest
    static void getDataForm(){
        Test.startTest();
        OpportunityLineItem oppLnItm = [SELECT Id,Name FROM OpportunityLineItem WHERE Name =:OLI_NAME LIMIT 1];
		HeaderOppLineItemController.getForm(oppLnItm.Id,'OpportunityLineItem','PF_Header');
		System.assertEquals(oppLnItm.Name, OLI_NAME);
        Test.stopTest();
    }
}