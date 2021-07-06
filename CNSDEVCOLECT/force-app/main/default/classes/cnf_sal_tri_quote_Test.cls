@isTest
private class cnf_sal_tri_quote_Test {
    
    @testSetup static void dataload(){
        TestFactorySales.populateOrg();
    } 
    
    @isTest private static void onBeforeUpdateTest(){
        User usr = [SELECT Id,username FROM User WHERE RUT__c = '12654966'];
        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false,Sincronizar_sales__c = false);
		Account acc = [SELECT Id,firstname FROM Account WHERE RUT__c = '19375874-6'];
        Id idProd2 = Test.getStandardPricebookId(); 
        TestFactorySales.createPricebook2(Constants.PRICEBOOK_NAME1);
        Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityVidaWithProduct(idProd2,acc.Id,usr.Id);
        Quote qt = (Quote)mpsOppObjects.get('Quote');
        Opportunity opp = (Opportunity)mpsOppObjects.get('Opportunity');
        
        System.runAs(usr){
            String status = Constants.OK;
            try{
                opp.SyncedQuoteId = qt.Id;
				update opp;
            }catch(Exception e){
                status = Constants.NOK;
                System.debug('Exception:' + e.getMessage());
            }
            
            System.assertEquals(Constants.NOK, status);
        }
    }
}