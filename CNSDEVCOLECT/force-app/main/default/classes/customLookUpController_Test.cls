@isTest
public class customLookUpController_Test {

        @testSetup static void dataload(){
        TestFactorySales.populateOrg();
       	TestFactorySales.createConsorcioOrg();
    }
    @isTest private static void customLookUp_Test(){
        List < sObject > returnList = customLookUpController.fetchLookUpValues('Ejecutivo', 'User');
        System.assert(!returnList.isEmpty());
    }
}