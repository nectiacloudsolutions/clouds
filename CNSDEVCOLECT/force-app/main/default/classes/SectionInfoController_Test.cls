@isTest
private class SectionInfoController_Test {

    @TestSetup
    static void makeData(){
        List<User> makeUser = new List<User>();
        User user1 = TestFactorySales.createUser('19', Constants.PROFILE_EJECUTIVO_VENTA, 'TSInfo1');
        user1.Modelo_Comercial__c = 'FFVV Seguros Nueva';
        makeUser.add(user1);
        makeUser.add(TestFactorySales.createUser('28', Constants.PROFILE_JEFE_CAMPANA, 'TSInfo2'));

        insert makeUser;
    }

    @isTest
    static void getSectionInfoOK() {
        Test.startTest();
        Boolean isVisible = false;
        List<InformativoEEVV__mdt> lstMeta = new List<InformativoEEVV__mdt>();
        lstMeta = SectionInfoController.getSectionInfo();
        if(lstMeta.size() > 0){
            isVisible = true;
        }
        System.assertEquals(true, isVisible);
        Test.stopTest();
    }

    @isTest
    static void hasAccessTest(){
        List<User> lstUser = [SELECT Id,Modelo_Comercial__c FROM User WHERE Rut__c = '19'];

        upsert new VisualizarTab__c(SetupOwnerId=lstUser[0].Id,Visualizar__c = true);
        
        System.runAs(lstUser[0]){
            Test.startTest();
            Boolean testValue = SectionInfoController.hasAccess();

            System.assertEquals(false, testValue);
            Test.stopTest();
        }
    }
}