@isTest
private class ActionQuoteController_Test {
    @TestSetup
    static void makeData(){
        Map<String, SObject> mpsObjects = TestFactorySales.populateOrg();
        User user = (User)mpsObjects.get('User8');
        Account acc = (Account)mpsObjects.get(Constants.ACCOUNT);

        Product2 p2 = new Product2();
        p2.IsActive = true;
        p2.ProductCode = '801';
        p2.Name = 'TestActionController';
        p2.codigo_producto_sales__c= '2';
        p2.Codigo_Macroproducto_Operacional_sales__c='1';
        p2.tipo_producto_sales__c = Constants.RECORDTYPE_BANCA_PLAN_PLUS;
        p2.Family = Constants.PLAN_PLUS;

        insert p2;
        
        Id idProd2 = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = idProd2;
        pbe.Product2Id = p2.Id;
        pbe.UnitPrice = 1;
        pbe.IsActive = true;
        insert pbe;
        
        List<Opportunity> lstOpp = new List<Opportunity>();
        List<OpportunityLineItem> lstOppItem = new List<OpportunityLineItem>();

        Opportunity newOpp = new Opportunity();
        newOpp.StageName = Constants.PLAN_PLUS_STATUS_RECOPILACION;
        newOpp.CloseDate = Date.TODAY().addMonths(1);
        newOpp.AccountId = acc.Id;
        newOpp.Name = 'TESTOPPCUMBRES';
        newOpp.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: p2.tipo_producto_sales__c LIMIT 1].Id;
        newOpp.OwnerId = user.Id;
        lstOpp.add(newOpp);
        
        Opportunity newOpp2 = new Opportunity();
        newOpp2.StageName = Constants.OPPORTUNITY_STAGE_INGRESO_NEGOCIO;
        newOpp2.CloseDate = Date.TODAY().addMonths(1);
        newOpp2.AccountId = acc.Id;
        newOpp2.Name = 'TESTOPPCUMBRES2';
        newOpp2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: p2.tipo_producto_sales__c LIMIT 1].Id;
        newOpp2.OwnerId = user.Id;
        lstOpp.add(newOpp2);
        
        insert lstOpp;
        
        OpportunityLineItem opli = new OpportunityLineItem();
        opli.OpportunityId = lstOpp[0].Id;
        opli.PricebookEntryId = pbe.Id;
        opli.Quantity = 1;
        opli.UnitPrice = 1;
        opli.Product2Id = p2.Id;
        lstOppItem.add(opli);
        
        OpportunityLineItem opli2 = new OpportunityLineItem();
        opli2.OpportunityId = lstOpp[1].Id;
        opli2.PricebookEntryId = pbe.Id;
        opli2.Quantity = 1;
        opli2.UnitPrice = 1;
        opli2.Product2Id = p2.Id;
        lstOppItem.add(opli2);
        
        insert lstOppItem;
    }
    
    @isTest
    static void getDataTest(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity WHERE Name = 'TESTOPPCUMBRES' LIMIT 1];
        List<Product2> lstpro = [SELECT Id,flujo_integrado_sales__c FROM Product2 WHERE Name = 'TestActionController' LIMIT 1];
        RecordType rt = [SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_AUTO LIMIT 1];
        lstopp[0].RecordTypeId = rt.Id;
        system.debug('rttttttt     ' +lstopp[0].RecordTypeId);
        update lstOpp[0];
        lstpro[0].flujo_integrado_sales__c = true; 
        update lstpro; 
        
        System.RunAs(lstUsr[0]){
            Test.startTest();
            ActionQuoteController.QuoteWrapper objWrapper = new ActionQuoteController.QuoteWrapper();
            objWrapper = ActionQuoteController.getData(lstOpp[0].Id);            
            Test.stopTest();
            
            System.assertEquals(false, objWrapper.status);
        }
    }
    
    @isTest
    static void getDataTest02(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity WHERE Name = 'TESTOPPCUMBRES2' LIMIT 1];
        List<Product2> lstpro = [SELECT Id,flujo_integrado_sales__c FROM Product2 WHERE Name = 'TestActionController' LIMIT 1];
        lstpro[0].flujo_integrado_sales__c = true; 
		upsert new FlujoCotizador__c(SetupOwnerId=lstUsr[0].Id,Cotizador__c=true);
        RecordType rt = [SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_AUTO LIMIT 1];
        lstopp[0].RecordTypeId = rt.Id;
        update lstOpp[0];
       system.debug(FlujoCotizador__c.getInstance(lstUsr[0].Id).Cotizador__c);
        system.debug('test'+Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(lstOpp[0].RecordTypeId).getDeveloperName());
        SYSTEM.debug('test2'+lstpro[0].flujo_integrado_sales__c);
        update lstpro; 
     
        
        System.RunAs(lstUsr[0]){
            Test.startTest();
            
            ActionQuoteController.QuoteWrapper objWrapper = new ActionQuoteController.QuoteWrapper();
            objWrapper = ActionQuoteController.getData(lstOpp[0].Id);            
            Test.stopTest();
            
            System.assertEquals(true, objWrapper.status);
        }
    }
    
    @isTest
    static void getDataTest03(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity WHERE Name = 'TESTOPPCUMBRES2' LIMIT 1];
        List<Product2> lstpro = [SELECT Id,flujo_integrado_sales__c FROM Product2 WHERE Name = 'TestActionController' LIMIT 1];
  
        lstpro[0].flujo_integrado_sales__c = false; 
        
        update lstpro; 
      
        
        System.RunAs(lstUsr[0]){
            Test.startTest();
            ActionQuoteController.QuoteWrapper objWrapper = new ActionQuoteController.QuoteWrapper();
            objWrapper = ActionQuoteController.getData(lstOpp[0].Id);            
            Test.stopTest();
            
            System.assertEquals(false, objWrapper.status);
        }
    }
    
    @isTest
    static void getDataTest04(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity WHERE Name = 'TESTOPPCUMBRES2' LIMIT 1];
        List<Product2> lstpro = [SELECT Id,flujo_integrado_sales__c FROM Product2 WHERE Name = 'TestActionController' LIMIT 1];
        lstpro[0].flujo_integrado_sales__c = false; 
        update lstpro; 
        
        System.RunAs(lstUsr[0]){
            Test.startTest();
            ActionQuoteController.QuoteWrapper objWrapper = new ActionQuoteController.QuoteWrapper();
            objWrapper = ActionQuoteController.getData(lstOpp[0].Id);            
            Test.stopTest();
            
            System.assertEquals(false, objWrapper.status);
        }
    }
    @isTest
    static void getDataTest05(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity WHERE Name = 'TESTOPPCUMBRES2' LIMIT 1];
        List<Product2> lstpro = [SELECT Id,flujo_integrado_sales__c FROM Product2 WHERE Name = 'TestActionController' LIMIT 1];
        lstpro[0].flujo_integrado_sales__c = false; 
        update lstpro; 
        
        System.RunAs(lstUsr[0]){
            Test.startTest();
            ActionQuoteController.QuoteWrapper objWrapper = new ActionQuoteController.QuoteWrapper();
            objWrapper = ActionQuoteController.getData(lstOpp[0].Id);            
            Test.stopTest();
            
            System.assertEquals(false, objWrapper.status);
        }
    }
}