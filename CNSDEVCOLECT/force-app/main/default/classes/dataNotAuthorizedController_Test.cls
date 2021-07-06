@isTest
private class dataNotAuthorizedController_Test {
    private static final String AccountId = '0012f00000WilpAAAR';
    private static final String RecordTypeId = '0122f000000E99jAAC';
    
    @isTest static void viewDoctest() {
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        User use = (User)mpsObjects.get('User8');
        Account acc = (Account)mpsObjects.get('Account');
        Id idrtaccount = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Cliente_Persona_Seguros').getRecordTypeId();
        acc.RecordTypeId = idrtaccount;
        acc.OwnerId = use.Id;
        update acc;    
        Test.startTest();
        system.runas(use){
            Blob blobValue = EncodingUtil.base64Decode(dataNotAuthorizedController.viewDoc(acc.Id));
            System.assertEquals('Test.Unitario',blobValue.toString());
        }   
        Test.stopTest();
    }
    
    @isTest static void DataNotAuthorizeAndInsertCaseTest() { 
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        User use = (User)mpsObjects.get('User8');
        Account acc = (Account)mpsObjects.get('Account');
        Id idrtaccount = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Cliente_Persona_Seguros').getRecordTypeId();
        acc.RecordTypeId = idrtaccount;
        acc.OwnerId = use.Id;
        update acc;    
        String res; 
        Test.startTest();
        System.runAs(use){
            res = dataNotAuthorizedController.DataNotAuthorizeAndInsertCase(acc.Id);
            System.assertEquals(Constants.TEMPLATE_PDF_SUCCESS, res);  
            res = dataNotAuthorizedController.DataNotAuthorizeAndInsertCase(RecordTypeId);
            System.assertEquals(Constants.NOK, res);
        }
        Test.stopTest(); 
    }
    
    @isTest static void getAccessPerfilEjecutivoTest(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        User use = (User)mpsObjects.get('User8');
        Test.startTest();
        system.runAs(use){
            List<CaseDataFunctionality__c> lstCS=new list<CaseDataFunctionality__c>();
            CaseDataFunctionality__c csRecord=new CaseDataFunctionality__c();
            csRecord.Name = 'Test';
            csRecord.funcionalidad__c = CONSTANTS.CASE_FUNCTIONALITY_NAME;
            csRecord.perfil__c = CONSTANTS.PROFILE_EJECUTIVO_ATENCION_CLIENTE;
            lstCS.add(csRecord);
            insert lstCS;
            System.assertEquals(Constants.OK,dataNotAuthorizedController.getAccessPerfilEjecutivo());     
        }
        System.assertEquals(Constants.NOK,dataNotAuthorizedController.getAccessPerfilEjecutivo());
        Test.stopTest();
    }
}