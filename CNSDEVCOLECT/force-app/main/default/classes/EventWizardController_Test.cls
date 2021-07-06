/**
 * @File Name          : EventWizardController_Test.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 22-01-2020 13:00:47
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    22-01-2020   eayalcor@everis.com     Initial Version
**/
@isTest
private with sharing class EventWizardController_Test {
    @TestSetup
    static void makeData(){
        TestFactorySales.populateOrg();
    }

    @isTest
    static void getInitialDataTest(){
        List<User> lstUser = [SELECT Id,Rut__C,ProfileID,Name FROM User WHERE UserName = 'ejecutivo2@consorcio.cl.devsales' LIMIT 1];
        List<Lead> lstLead = [SELECT Id,ownerId FROM Lead LIMIT 1 ];
        lstLead[0].OwnerId = lstUser[0].Id;
        update lstLead;
        System.debug('LEAD Encontrado:' 
                    + lstLead);

        System.runAs(lstUser[0]){
            Test.startTest();
            Map<String,List<String>> mapData = new Map<String,List<String>>();
            mapData = EventWizardController.getInitialData(lstLead[0].Id);
            Test.stopTest();
            
            System.assertEquals(6, mapData.size());
        }
    }

    @isTest
    static void saveEventTest(){
        List<User> lstUser = [SELECT Id,Rut__C,ProfileID,Name FROM User WHERE UserName = 'ejecutivo2@consorcio.cl.devsales' LIMIT 1];
        List<Lead> lstLead = [SELECT Id FROM Lead LIMIT 1 ];
        lstLead[0].OwnerId = lstUser[0].Id;
        update lstLead;

        System.runAs(lstUser[0]){
            Test.startTest();
            String result = EventWizardController.saveEvent('87654321', Constants.EVENT_ESTADO_LLAMADA_CONTACTADO, Constants.EVENT_RESULTADO_LLAMADA_ENTEVISTA, '', '', lstLead[0].Id, null);
            Test.stopTest();
            
            
        }
    }
}