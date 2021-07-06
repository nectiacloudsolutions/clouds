@isTest
public class ProposalController_Test {
    
        
	@isTest 
    static void proposalControllerQuoteTest(){
        Test.startTest();
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();       
        Account acc = (Account)mpsObjects.get('Account');
        Id idProd2 = Test.getStandardPricebookId(); 
        User user = (User)mpsObjects.get('User');
        Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,user.Id);
        Quote qte = (Quote)mpsOppObjects.get('Quote');
        qte.Numero_de_Propuesta_sales__c = '0';
        qte.Numero_de_Cotizacion_sales__c = '1234';
        update qte;
        
        
        upsert new Consorcio_Org__c(SetupOwnerId=user.profileId, Sales_project__c = FALSE);
        
        System.runAs(user){
            
            ProposalController.StoreProposalClass stPro = new ProposalController.StoreProposalClass();
            stPro.estado = 0;
            stPro.mensaje = 'Propuesta ingresada correctamente';

            String json = JSON.serialize(stPro);
            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'OK',
                                                     '{ "estado": 0, "mensaje": "Propuesta ingresada correctamente" }',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            ProposalController.StoreProposalClass sp = ProposalController.getStoreProposal(qte.Id);
            System.assertEquals(-1, sp.estado);
        }
        
        Test.stopTest();
    }
    
    @isTest 
    static void proposalControllerQuoteTest2(){
                    
        Test.startTest();
        
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();       
        Account acc = (Account)mpsObjects.get('Account');
        Id idProd2 = Test.getStandardPricebookId(); 
        User user = (User)mpsObjects.get('User');
        Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,user.Id);
        Quote qte = (Quote)mpsOppObjects.get('Quote');
        qte.Numero_de_Propuesta_sales__c = '1';
        qte.Numero_de_Cotizacion_sales__c='1';
        update qte;
        
        
        System.runAs(user){

            ProposalController.StoreProposalClass stPro = new ProposalController.StoreProposalClass();
            stPro.estado = 0;
            stPro.mensaje = 'Propuesta ingresada correctamente';

            String json = JSON.serialize(stPro);
            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'OK',
                                                     '{ "estado": 0, "mensaje": "Propuesta ingresada correctamente" }',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            ProposalController.StoreProposalClass sp = ProposalController.getStoreProposal(qte.Id);
            Boolean isStageOK = ProposalController.getOppStage(qte.id);
            //System.assertEquals(true, isStageOk);
            System.assertEquals(-1, sp.estado);
        }
                    
        Test.stopTest();
    }

}