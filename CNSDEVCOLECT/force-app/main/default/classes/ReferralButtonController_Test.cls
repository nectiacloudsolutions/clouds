/*********************************************************************************************************
@Author       fbizamam@everis.com
@name         ReferralButtonController_Test
@CreateDate   02/01/2020
@Description  Test Class of the ReferralButtonController class.
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          		Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
02/01/2020		fbizamam@everis.com               initial version
**********************************************************************************************************/
@isTest
public class ReferralButtonController_Test {
	
    /**
      * @name			   getNewExecutiveTest
      * @description       Tests the getNewExecutive method in the ReferralButtonController Class
      * @params            N/A
      * @return            NA
      * @throws            NA
    */
    @isTest static void getNewExecutiveTest(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        Account acc = (Account)mpsObjects.get('Account');
        acc.RUT__c = '6058051-0';
        Id idProd2 = Test.getStandardPricebookId(); 
        User user = (User)mpsObjects.get('User'); 
        User usr6 = (User)mpsObjects.get('User6');
        Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,user.Id);       
            Opportunity oppy = (Opportunity)mpsOppObjects.get('Opportunity');
        system.runAs(user){       
            Test.startTest();           
            System.assertEquals('Ejecutivo 2 Sales2', ReferralButtonController.getNewExecutive(oppy.Id)); 
            Test.stopTest();
        }
        oppy.Pricebook2Id = null;    
        update oppy;   
        system.runAs(user){
            system.assertEquals(Constants.OPPORTUNITY_ERROR_PRODUCTO,ReferralButtonController.getNewExecutive(oppy.Id) );
        }
    }
    /**
      * @name			   validateOppStageTest
      * @description       Tests the validateOppStage method in the ReferralButtonController Class
      * @params            N/A
      * @return            NA
      * @throws            NA
    */
    @isTest static void validateOppStageTest(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        Account acc = (Account)mpsObjects.get('Account');
        acc.RUT__c = '13558830-k';
        Id idProd2 = Test.getStandardPricebookId(); 
        User usr2 = (User)mpsObjects.get('User');
        User usr6 = (User)mpsObjects.get('User6');
        
        usr2.ManagerId = usr6.Id;
        update usr2;
        
        Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,usr2.Id);
        Opportunity oppy = (Opportunity)mpsOppObjects.get('Opportunity');  
    	system.runAs(usr2){
            System.assertEquals(Constants.OPPORTUNITY_ERROR_USUARIO, ReferralButtonController.validateOppStage(oppy.Id));
        }
        upsert new Consorcio_Org__c(SetupOwnerId=usr2.profileId, Sales_project__c = FALSE,Referir_sales__c=TRUE);
        upsert new Consorcio_Org__c(SetupOwnerId=usr6.profileId, Sales_project__c = FALSE,Referir_sales__c=TRUE);
        
        Test.startTest();

        Id idrt = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(constants.RECORDTYPE_BANCA_CREDITO_CONSUMO).getRecordTypeId();
        oppy.StageName = CONSTANTS.OPPORTUNITY_STAGE_INGRESO_NEGOCIO;
        oppy.RecordTypeId = idrt;
        update oppy;
        
        System.runAs(usr2){
            System.assertEquals(Constants.OK, ReferralButtonController.validateOppStage(oppy.Id));     
        }

        update oppy;
        oppy.OwnerId = usr6.Id;
        oppy.StageName = Constants.OPPORTUNITY_STAGE_CONTACTO;
        update oppy;
        
        System.runAs(usr6){         
            System.assertEquals(Constants.OK, ReferralButtonController.validateOppStage(oppy.Id));
        }    
        Test.stopTest();
    }
}