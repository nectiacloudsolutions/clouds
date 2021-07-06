/**
 * @description       : 
 * @author            : eayalcor@everis.com
 * @group             : 
 * @last modified on  : 08-12-2020
 * @last modified by  : eayalcor@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-12-2020   eayalcor@everis.com   Initial Version
**/
@isTest
private class CnsCustomNotification_Test {
    @TestSetup
    static void makeData(){
        TestFactorySales.populateOrg();
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 08-12-2020 
    **/
    @isTest
    static void notifyCurrentUserTest(){
        TestFactorySales.makeCustomSettings();
        Test.startTest();
        List<Case> lstCase = [SELECT Id,CaseNumber,OwnerId FROM CASE LIMIT 1];
        CnsCustomNotification.notifyCurrentUser(JSON.serialize(lstCase[0]),Constants.CASE_CUSTOM_NOTIFY_VENCIMIENTO,new List<String>{lstCase[0].OwnerId});
        CnsCustomNotification.notifyCurrentUserSLAVencidos(JSON.serialize(lstCase[0]),Constants.CASE_CUSTOM_NOTIFY_VENCIMIENTO,new List<String>{lstCase[0].OwnerId});
        Integer callouts = Limits.getCallouts();
        Test.stopTest();
        System.assertEquals(0, callouts, 'A callout should be made');
    }
}