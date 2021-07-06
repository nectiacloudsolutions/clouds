@isTest
private class  cnf_sal_tri_account_Test {
    @testSetup static void dataload(){
        
        Map<String, SObject> mpsObjects = TestFactorySales.populateOrg();
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        Account acc = (Account)mpsObjects.get('Account');
        acc.OwnerId = lstUsr[0].Id;
        acc.PersonDoNotCall = false;
        acc.PersonHasOptedOutOfEmail = false;
        update acc;
    } 
    @isTest
    static void afterUpdateEmailTest(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].Id,Sales_project__c=true, Validation_rules__c = false);
        Account acc = [SELECT Id FROM Account WHERE RUT__C = '10854082-6'];
        
        system.runAs(lstUsr[0]){
            acc.PersonHasOptedOutOfEmail = true;
            test.startTest();
            update acc;
            test.stopTest();   
        }
        List<Case> lstCases2 = [SELECT Id, AccountId, Account.Name, CaseNumber FROM Case WHERE AccountId =: acc.Id];
        System.assertEquals(lstCases2[0].AccountId, acc.Id );
    }
    
    @isTest
    static void afterUpdateTelefonoTest(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].Id,Sales_project__c=true, Validation_rules__c = false);
        Account acc = [SELECT Id FROM Account WHERE RUT__C = '10854082-6'];
        system.runAs(lstUsr[0]){
            acc.PersonDoNotCall = true;
            test.startTest();
            update acc;
            test.stopTest();
        }
        List<Case> lstCases2 = [SELECT Id, AccountId, Account.Name, CaseNumber FROM Case WHERE AccountId =: acc.Id];
        System.assertEquals(lstCases2[0].AccountId, acc.Id );
    }
    
    @isTest
    static void afterUpdateTelefonoAndEmailTest(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].Id,Sales_project__c=true, Validation_rules__c = false);
        Account acc = [SELECT Id FROM Account WHERE RUT__C = '10854082-6'];
        system.runAs(lstUsr[0]){
            acc.PersonHasOptedOutOfEmail = true;
            acc.PersonDoNotCall = true;
            test.startTest();
            update acc;
            test.stopTest();
        }
        List<Case> lstCases2 = [SELECT Id, AccountId, Account.Name, CaseNumber FROM Case WHERE AccountId =: acc.Id];
        System.assertEquals(lstCases2[0].AccountId, acc.Id );
    }
}