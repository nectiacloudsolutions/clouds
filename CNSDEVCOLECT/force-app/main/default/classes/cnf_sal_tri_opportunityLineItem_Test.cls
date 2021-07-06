/**
 * @File Name          : cnf_sal_tri_opportunityLineItem_Test.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 6/3/2020, 11:00:13 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/2/2020   eayalcor@everis.com     Initial Version
**/
@isTest
private with sharing class cnf_sal_tri_opportunityLineItem_Test {

    private static String codeTest = '1010TEST';

    @TestSetup
    static void makeData(){
        TestFactorySales.populateOrg();

        Product2 p2 = new Product2();
        p2.IsActive = true;
        p2.ProductCode = codeTest;
        p2.Name = 'Test';
        p2.codigo_producto_sales__c= '2';
        p2.Codigo_Macroproducto_Operacional_sales__c='1';
        p2.tipo_producto_sales__c = 'plan_plus_sales';
        p2.Family = Constants.PLAN_PLUS;

        insert p2;
    }

    @isTest
    static void createOppLineItem(){
        User usr = [SELECT Id FROM User WHERE RUT__c = '19' LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);
        System.runAs(usr){
            Test.startTest();
            String rtByFamily = UtilitiesSales.getRTbyFamilyProduct(Constants.PLAN_PLUS);
            /*
            Creación Opportunity
            */
            Opportunity newOpp = new Opportunity();
            newOpp.StageName = Constants.OPPORTUNITY_STAGE_CONTACTO;
            newOpp.CloseDate = Date.TODAY().addMonths(1);
            newOpp.AccountId = [SELECT Id FROM Account WHERE Rut__c = '10854082-6' LIMIT 1].Id;
            newOpp.Name = 'Test';
            newOpp.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: rtByFamily LIMIT 1].Id;
            insert newOpp;

            Id proId = [SELECT Id FROM Product2 WHERE ProductCode !=: codeTest LIMIT 1].Id;

            Id pbEntry = [SELECT Id FROM PricebookEntry WHERE Product2Id =: proId LIMIT 1].Id;
            
            try{
                OpportunityLineItem opli = new OpportunityLineItem();
                opli.OpportunityId = newOpp.Id;
                opli.PricebookEntryId = pbEntry;
                opli.Quantity = 1;
                opli.UnitPrice = 1;
                opli.Product2Id = proId;
                insert opli;
            }catch(Exception ex){
                Boolean expectedExceptionThrown =  ex.getMessage().contains(Constants.OPPORTUNITYLINEITEM_ERROR01) ? true : false;
                System.assertEquals(expectedExceptionThrown, true);
            }



            Test.stopTest();
        }
    }
}