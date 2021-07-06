@isTest
public class labelPickListFlow_Test {

    	@testSetup static void dataload(){
        TestFactorySales.populateOrg();
       	TestFactorySales.createConsorcioOrg();
    }
    
  @isTest static void getPickListValue(){
        labelPickListFlow.requestInfo addApro = new labelPickListFlow.requestInfo();
   		List<String> lstResponse = new List<String>();
	    addApro.idsValue='1101';
     	addApro.fieldN='Comuna_Nectia__c';
        List<labelPickListFlow.requestInfo>lstA= new List<labelPickListFlow.requestInfo>();
        lstA.add(addApro);
		User Owner = [SELECT Id FROM User Where Rut__c = '88136454'];
        Test.startTest();
        system.runAs(Owner){
         lstResponse =   labelPickListFlow.getPickListValue(lstA);
        }
        System.assertEquals(1,lstResponse.size());
        test.stopTest();
    }

}