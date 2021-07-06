/**
 * @File Name          : OppCumbresButtonController_Test.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 6/23/2020, 4:43:06 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/23/2020   eayalcor@everis.com     Initial Version
**/
@isTest 
public with sharing class OppCumbresButtonController_Test {
    
    /**
    * @description 
    * @author eayalcor@everis.com | 6/23/2020 
    * @return void 
    **/
    @TestSetup
    static void makeData(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();

        User user = (User)mpsObjects.get('User8');
        Account acc = (Account)mpsObjects.get('Account');

        Product2 p2 = new Product2();
        p2.IsActive = true;
        p2.ProductCode = '801';
        p2.Name = 'Test';
        p2.codigo_producto_sales__c= '2';
        p2.Codigo_Macroproducto_Operacional_sales__c='1';
        p2.tipo_producto_sales__c = 'plan_plus_sales';
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

        Opportunity newOpp = new Opportunity();
        newOpp.StageName = Constants.PLAN_PLUS_STATUS_RECOPILACION;
        newOpp.CloseDate = Date.TODAY().addMonths(1);
        newOpp.AccountId = acc.Id;
        newOpp.Name = 'TESTOPPCUMBRES';
        newOpp.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: p2.tipo_producto_sales__c LIMIT 1].Id;
        newOpp.OwnerId = user.Id;
        lstOpp.add(newOpp);
        
        Opportunity newOpp2 = new Opportunity();
        newOpp2.StageName = Constants.PLAN_PLUS_STATUS_RECOPILACION;
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
        insert opli;
    }

    @isTest
    static void getCumbresInfoTest(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity WHERE Name = 'TESTOPPCUMBRES' LIMIT 1];

        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].profileId, Envio_Solicitud_Backend__C = TRUE);


        System.runAs(lstUsr[0]){
            Test.startTest();
            try{
                OppCumbresButtonController.ResponseDto response = new OppCumbresButtonController.ResponseDto();
                response = OppCumbresButtonController.getCumbresInfo(lstOpp[0].Id);
            }catch(Exception e){
                System.assert(e instanceof AuraHandledException);
            }

            Test.stopTest();
        }
    }

    @isTest
    static void getCumbresInfoTest2(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        List<Opportunity> lstOpp = [SELECT Id,OwnerId FROM Opportunity WHERE Name = 'TESTOPPCUMBRES2' LIMIT 1];
        lstOpp[0].Numero_Op_Comercializadora_sales__c = '12345';
        lstOpp[0].OwnerId = lstUsr[0].Id;
        update lstOpp;
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].profileId, Envio_Solicitud_Backend__C = TRUE);

        
        System.debug('Lista:' + lstOpp);
        System.debug('Lista:' + lstUsr);

        System.runAs(lstUsr[0]){
            Test.startTest();
            
            Boolean result = OppCumbresButtonController.getOppStage(lstOpp[0].Id);

            System.assertEquals(true, result);
            
            OppCumbresButtonController.ResponseDto response = new OppCumbresButtonController.ResponseDto();
            response = OppCumbresButtonController.getCumbresInfo(lstOpp[0].Id);

            Test.stopTest();
        }
    }

    @isTest
    static void getCumbresInfoTest3(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        List<Opportunity> lstOpp = [SELECT Id,OwnerId FROM Opportunity WHERE Name = 'TESTOPPCUMBRES2' LIMIT 1];
        lstOpp[0].Numero_Op_Comercializadora_sales__c = '12345';
        lstOpp[0].OwnerId = lstUsr[0].Id;
        update lstOpp;
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].profileId, Envio_Solicitud_Backend__C = FALSE);

        System.runAs(lstUsr[0]){
            Test.startTest();
            
            OppCumbresButtonController.ResponseDto response = new OppCumbresButtonController.ResponseDto();
            response = OppCumbresButtonController.getCumbresInfo(lstOpp[0].Id);

            Test.stopTest();
            
            System.assertEquals(response.dtoResponseSetParametros.codigoError, '-1');

        }
    }
    
    @isTest
    static void getCumbresInfoTest4(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        List<Opportunity> lstOpp = [SELECT Id,OwnerId FROM Opportunity WHERE Name = 'TESTOPPCUMBRES2' LIMIT 1];
        lstOpp[0].OwnerId = lstUsr[0].Id;
        update lstOpp;
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].profileId, Envio_Solicitud_Backend__C = FALSE);

        System.runAs(lstUsr[0]){
            Test.startTest();
            
            OppCumbresButtonController.ResponseDto response = new OppCumbresButtonController.ResponseDto();
            response = OppCumbresButtonController.getCumbresInfo(lstOpp[0].Id);

            Test.stopTest();
            
            System.assertEquals(response.dtoResponseSetParametros.codigoError, '-1');

        }
    }
    
        @isTest
    static void getCumbresInfoTest5(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        List<Opportunity> lstOpp = [SELECT Id,OwnerId FROM Opportunity WHERE Name = 'TESTOPPCUMBRES2' LIMIT 1];
        lstOpp[0].Numero_Op_Comercializadora_sales__c = null;
        lstOpp[0].OwnerId = lstUsr[0].Id;
        update lstOpp;
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].profileId, Envio_Solicitud_Backend__C = TRUE);

        
        System.debug('Lista:' + lstOpp);
        System.debug('Lista:' + lstUsr);

        System.runAs(lstUsr[0]){
            Test.startTest();
            try{
                OppCumbresButtonController.ResponseDto response = new OppCumbresButtonController.ResponseDto();
                response = OppCumbresButtonController.getCumbresInfo(lstOpp[0].Id);
            }catch(Exception e){
                System.assert(e instanceof AuraHandledException);
            }

            Test.stopTest();
        }        
    }
   
}