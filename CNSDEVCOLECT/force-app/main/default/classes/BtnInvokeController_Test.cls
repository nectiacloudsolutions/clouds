/**
 * @description       : 
 * @author            : eayalcor@everis.com
 * @group             : 
 * @last modified on  : 08-24-2020
 * @last modified by  : eayalcor@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-24-2020   eayalcor@everis.com   Initial Version
**/
@isTest
private with sharing class BtnInvokeController_Test {
    /**
    * @description 
    * @author eayalcor@everis.com | 08-24-2020 
    **/
    @testSetup
    private static void loadDataConfig(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();
        User newUsrSeg = TestFactorySales.createUserWithCompany('152833547','Ejecutivo Especialista','testSeg', Constants.COMPANY_SEGUROS);
    }

    @isTest
    static void getDataTest(){
        List<User> lstUser = [SELECT Id FROM User WHERE isActive = TRUE AND Rut__c = '152833547'];
        Account acc = TestFactorySales.createNewAccountWithOwner('15283354-7','TestQuickAction',lstUser[0].Id);
        acc.Autoriza_uso_de_datos__c = true;
        
        update acc;

        System.runAs(lstUser[0]){
            Test.startTest();
            System.debug('Acc: ' + acc);
            BtnInvokeController.MultiWrapper wrapper = BtnInvokeController.getData(acc.Id, Constants.MULTICONSULTA);
            Test.stopTest();

            System.assertEquals(wrapper.status, true);
        }
    }
    
    @isTest
    static void getDataTest02(){
        List<User> lstUser = [SELECT Id FROM User WHERE isActive = TRUE AND Rut__c = '152833547'];
        Account acc = TestFactorySales.createNewAccountWithOwner('15283354-7','TestQuickAction',lstUser[0].Id);
        acc.Autoriza_uso_de_datos__c = false;
        
        update acc;

        System.runAs(lstUser[0]){
            Test.startTest();
            System.debug('Acc: ' + acc);
            BtnInvokeController.MultiWrapper wrapper = BtnInvokeController.getData(acc.Id, Constants.MULTICONSULTA);
            Test.stopTest();

            System.assertEquals(wrapper.status, true);
        }
    }
    
    @isTest
    static void getDataTest03(){
        List<User> lstUser = [SELECT Id FROM User WHERE isActive = TRUE AND Rut__c = '152833547'];
        Account acc = TestFactorySales.createNewAccountWithOwner('15283354-7','TestQuickAction',lstUser[0].Id);
        acc.Autoriza_uso_de_datos__c = true;
        
        update acc;

        System.runAs(lstUser[0]){
            Test.startTest();
            System.debug('Acc: ' + acc);
            BtnInvokeController.MultiWrapper wrapper = BtnInvokeController.getData(acc.Id, Constants.MULTISERVICIO);
            Test.stopTest();

            System.assertEquals(wrapper.status, true);
        }
    }
}