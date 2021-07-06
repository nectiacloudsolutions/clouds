@isTest
private class cnf_sal_tri_opportunity_Test {
    
    @testSetup static void dataload(){
        TestFactorySales.populateOrg();
        TestFactorySales.createConsorcioOrg();
    } 

    @isTest private static void changeOwner(){
         
        Account acc = [SELECT Id FROM Account WHERE RUT__C = '10854082-6'];
        Id idProd2 = Test.getStandardPricebookId();
        User usr = [SELECT Id FROM User WHERE RUT__c = '19' LIMIT 1];
        User usr2 = [SELECT Id FROM User WHERE RUT__c = '88136454' LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);

        System.runAs(usr){
            Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,usr.Id);
        	Opportunity Opp = (Opportunity)mpsOppObjects.get('Opportunity');
            Opp.OwnerId = usr.id;
            Update Opp;
            System.assertEquals(usr.id, Opp.OwnerId);
        }
        
    }
    
    @isTest private static void changeStageName(){
         
        Account acc = [SELECT Id FROM Account WHERE RUT__C = '10854082-6'];
        Id idProd2 = Test.getStandardPricebookId();
        User usr = [SELECT Id FROM User WHERE RUT__c = '19' LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);
        
        Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,usr.Id);
        Opportunity Opp = (Opportunity)mpsOppObjects.get('Opportunity');
        
        System.runAs(usr){
            Opp.StageName = Constants.OPPORTUNITY_STAGE_CONTACTO;
            Update Opp;
        }
        System.assertEquals(Opp.StageName,Constants.OPPORTUNITY_STAGE_CONTACTO);
    }
    
    @isTest private static void createNewOppPlanTest(){
        RecordType rtHipotecario = [SELECT Id FROM RecordType WHERE DeveloperName =:Constants.RECORDTYPE_BANCA_HIPOTECARIO LIMIT 1]; 
        Account acc = [SELECT Id, OwnerId, FirstName, LastName, RUT__c FROM Account WHERE RUT__C = '19375874-6'];
        Id idProd2 = Test.getStandardPricebookId();
        User usr = [SELECT Id,name, rut__C FROM User WHERE RUT__c = '12654966' LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);
        system.debug('////////////////////////////////////////////////////////////////////');
        system.debug('RECORD TYPE '+ rtHipotecario);
        system.debug('Acount '+acc);
        system.debug('USUARIO '+ usr);
        Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,usr.Id);
        Opportunity Opp = (Opportunity)mpsOppObjects.get('Opportunity');
        system.debug('OPPORTUNITY '+ Opp);
        List<documento_oportunidad_sales__c> lstDocs= TestFactorySales.createNewOppHipoDoc(Opp.Id);
        Product2 p3 = new Product2();
        p3.IsActive = true;
        p3.ProductCode = '05112';
        p3.Name = Constants.PLAN_PLUS;
        p3.codigo_producto_sales__c= '0';
        p3.Codigo_Macroproducto_Operacional_sales__c='1';
        p3.tipo_producto_sales__c = 'plan_plus_sales';
        insert p3; 
        
        Id priceBookId = Test.getStandardPricebookId(); 
        
        //Create a new Standard Pricebook Entry
        PricebookEntry standardPBE = new PricebookEntry();
        standardPBE.Pricebook2Id = priceBookId;
        standardPBE.Product2Id = p3.Id;
        standardPBE.UnitPrice = 1;
        standardPBE.IsActive = true;
        insert standardPBE;
        
        System.runAs(usr){
            try{
                Opp.RecordTypeId = rtHipotecario.Id;
                Opp.StageName = Constants.OPPORTUNITY_STAGENAME_FORMALIZACION;
                Opp.origen_de_oportunidad_sales__c='WhatsApp';
                Update Opp;
            }catch(Exception e){
                system.debug(e.getMessage());
                system.debug(e.getLineNumber());
                system.debug(e.getStackTraceString());
            }
            
        }
        System.assertEquals(Opp.StageName,Constants.OPPORTUNITY_STAGENAME_FORMALIZACION);
    }
    @isTest private static void updateOpportunitySuccessStageNameCotizacionTest(){
   
        Account acc = [SELECT Id,firstname FROM Account WHERE RUT__c = '19375874-6'];
        Id idProd2 = Test.getStandardPricebookId(); 
        User usr = [SELECT Id, name, ProfileId,rut__c FROM User WHERE RUT__c = '12654966' LIMIT 1];
		TestFactorySales.createPricebook2(Constants.PRICEBOOK_NAME1);
        Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityVidaWithProduct(idProd2,acc.Id,usr.Id);
        Opportunity oppy = (Opportunity)mpsOppObjects.get('Opportunity');   

        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);
        
        User test = [SELECT id, name, rut__c from user where ID =: oppy.OwnerId];

        System.runAs(usr){
           try{
                oppy.StageName = CONSTANTS.OPPORTUNITY_STAGENAME_COTIZACION;
                Update oppy;
            }catch(Exception e){
                system.debug('***'+e.getMessage());
                system.debug('***'+e.getLineNumber());
                system.debug('***'+e.getStackTraceString());
            }
        }
        System.assertEquals(CONSTANTS.OPPORTUNITY_STAGENAME_COTIZACION, oppy.StageName);
    }
    
    @isTest private static void updateOpportunitySuccessStageNameSimulacionTest(){
   
        Account acc = [SELECT Id,firstname FROM Account WHERE RUT__c = '19375874-6'];
        Id idProd2 = Test.getStandardPricebookId(); 
        User usr = [SELECT Id, name, ProfileId,rut__c FROM User WHERE RUT__c = '12654966' LIMIT 1];
		TestFactorySales.createPricebook2(Constants.PRICEBOOK_NAME1);
        Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityWithProduct_RecordType(idProd2,acc.Id,usr.Id,Constants.RECORDTYPE_BANCA_HIPOTECARIO,Constants.RECORDTYPE_QUOTE_BANCA_HIPOTECARIO);
        Opportunity oppy = (Opportunity)mpsOppObjects.get('Opportunity');   

        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);
        
        User test = [SELECT id, name, rut__c from user where ID =: oppy.OwnerId];

        System.runAs(usr){
           try{
                oppy.StageName = CONSTANTS.OPPORTUNITY_STAGENAME_SIMULACION;
                Update oppy;
            }catch(Exception e){
                system.debug('***'+e.getMessage());
                system.debug('***'+e.getLineNumber());
                system.debug('***'+e.getStackTraceString());
            }
        }
        System.assertEquals(CONSTANTS.OPPORTUNITY_STAGENAME_SIMULACION, oppy.StageName);
    } 
    
    @isTest private static void updateOpportunitySuccessStageAuto(){
   
        Account acc = [SELECT Id,firstname FROM Account WHERE RUT__c = '19375874-6'];
        Id idProd2 = Test.getStandardPricebookId(); 
        User usr = [SELECT Id, name, ProfileId,rut__c FROM User WHERE RUT__c = '12654966' LIMIT 1];
		TestFactorySales.createPricebook2(Constants.PRICEBOOK_NAME1);
        Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityWithProduct_RecordType(idProd2,acc.Id,usr.Id,Constants.RECORDTYPE_AUTO,Constants.RECORDTYPE_QUOTE_AUTO);
        Opportunity oppy = (Opportunity)mpsOppObjects.get('Opportunity');   

        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);
        
        User test = [SELECT id, name, rut__c from user where ID =: oppy.OwnerId];

        System.runAs(usr){
           try{
                oppy.StageName = CONSTANTS.OPPORTUNITY_STAGENAME_COTIZACION;
                Update oppy;
            }catch(Exception e){
                system.debug('***'+e.getMessage());
                system.debug('***'+e.getLineNumber());
                system.debug('***'+e.getStackTraceString());
            }
        }
        System.assertEquals(CONSTANTS.OPPORTUNITY_STAGENAME_COTIZACION, oppy.StageName);
    }
    
        @isTest private static void updateOpportunitySuccessStageHogar(){
   
        Account acc = [SELECT Id,firstname FROM Account WHERE RUT__c = '19375874-6'];
        Id idProd2 = Test.getStandardPricebookId(); 
        User usr = [SELECT Id, name, ProfileId,rut__c FROM User WHERE RUT__c = '12654966' LIMIT 1];
		TestFactorySales.createPricebook2(Constants.PRICEBOOK_NAME1);
        Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityWithProduct_RecordType(idProd2,acc.Id,usr.Id,Constants.RECORDTYPE_HOGAR,Constants.RECORDTYPE_QUOTE_HOGAR);
        Opportunity oppy = (Opportunity)mpsOppObjects.get('Opportunity');   

        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);
        
        User test = [SELECT id, name, rut__c from user where ID =: oppy.OwnerId];

        System.runAs(usr){
           try{
                oppy.StageName = CONSTANTS.OPPORTUNITY_STAGENAME_COTIZACION;
                Update oppy;
            }catch(Exception e){
                system.debug('***'+e.getMessage());
                system.debug('***'+e.getLineNumber());
                system.debug('***'+e.getStackTraceString());
            }
        }
        System.assertEquals(CONSTANTS.OPPORTUNITY_STAGENAME_COTIZACION, oppy.StageName);
    }
            @isTest private static void updateOpportunitySuccessStageConsumo(){
   
        Account acc = [SELECT Id,firstname FROM Account WHERE RUT__c = '19375874-6'];
        Id idProd2 = Test.getStandardPricebookId(); 
        User usr = [SELECT Id, name, ProfileId,rut__c FROM User WHERE RUT__c = '12654966' LIMIT 1];
		TestFactorySales.createPricebook2(Constants.PRICEBOOK_NAME1);
        Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityWithProduct_RecordType(idProd2,acc.Id,usr.Id,Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO,Constants.RECORDTYPE_QUOTE_CREDITO_CONSUMO);
        Opportunity oppy = (Opportunity)mpsOppObjects.get('Opportunity');   

        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);
        
        User test = [SELECT id, name, rut__c from user where ID =: oppy.OwnerId];

        System.runAs(usr){
           try{
                oppy.StageName = CONSTANTS.OPPORTUNITY_STAGENAME_SIMULACION;
                Update oppy;
            }catch(Exception e){
                system.debug('***'+e.getMessage());
                system.debug('***'+e.getLineNumber());
                system.debug('***'+e.getStackTraceString());
            }
        }
        System.assertEquals(CONSTANTS.OPPORTUNITY_STAGENAME_SIMULACION, oppy.StageName);
    }
    
    
}