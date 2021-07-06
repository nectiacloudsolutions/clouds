/*********************************************************************************************************
@Author       curbinav@everis.com
@name         CampaignMemberTriggerTest
@CreateDate   11/11/2019
@Description  Test class for CampaignMemberTriggerHelper
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
11/11/2019    curbinav@everis.com           W-000073 - (Vista 360° Cliente) - Ingreso Sección Cliente (Resumen)
**********************************************************************************************************/
@isTest
public class CampaignMemberTriggerTest {

    //private static final Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
	
    @testSetup
    private static void loadDataConfig(){
        User u2 = new User();
        u2.firstName = 'TESTCAMPAIGNMEMBER';
        u2.LastName = 'Sales2';
        u2.RUT__c = '7755002K';
        u2.Email = 'TESTCAMPAIGNMEMBER@consorcio.cl';
        u2.CompanyName = Constants.COMPANY_SEGUROS;
        u2.Alias =  'TESTCTM';                    
        u2.UserName =  'TESTCAMPAIGNMEMBER@consorcio.cl.devsales';            
        u2.CommunityNickname =  'TESTCAMPAIGNMEMBER@consorcio.cl.devsales';
        u2.LocaleSidKey = 'es_CL';
        u2.EmailEncodingKey = 'ISO-8859-1';            
        u2.LanguageLocaleKey = 'en_US';
        u2.TimeZoneSidKey = 'America/Santiago';
        u2.UserPermissionsMarketingUser = true;      
        u2.isActive = true;
        u2.ProfileID = [SELECT Id,Name FROM Profile WHERE Name=: Constants.PROFILE_JEFE_CAMPANA LIMIT 1].Id;
        insert u2;
        upsert new Consorcio_Org__c(SetupOwnerId=u2.Id,Sales_project__c=true, Validation_rules__c = false);
        
        // Crear nueva cuenta persona
            Account personAccount = new Account();
            personAccount.RUT__c = '2-7';
            personAccount.LastName = 'Lastname';
            personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_PERSON_ACCOUNT_SEGUROS).getRecordTypeId();
            
            insert personAccount;
    }
    

    @isTest 
    static void TestContarCampanasActivas() {
       
        User usr = [SELECT Id,RUT__c FROM User WHERE UserName = 'TESTCAMPAIGNMEMBER@consorcio.cl.devsales' LIMIT 1];      
       
        System.runAs(usr) {

            // Perform test
            Test.startTest();
            
            // Crear nueva campaña vigente
            Campaign campaign1 = new Campaign();
            //campaign1.IsActive = true;
            campaign1.Name = 'Campaña de test unitario';
			campaign1.Status = Constants.CAMPAIGN_STATUS_INGRESADA;
            // Prueba de test BBEE
            campaign1.CampaignMemberRecordTypeId = Schema.SObjectType.CampaignMember.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_CAMPAIGN_SALES_PERSONA).getRecordTypeId();
            campaign1.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_RP_SALES_CAMPAIGN).getRecordTypeId();
            
            insert campaign1;
            
            // Crear Miembro asociado a una campaña
            CampaignMember cm = new CampaignMember();
            cm.CampaignId = campaign1.Id;
            cm.RUT_sales__c = '2-7';
            cm.RUT_Ejecutivo_sales__c = usr.RUT__c;
    
            Database.SaveResult result = Database.insert(cm, false);
           
            Test.stopTest();
            
            
            System.assert(result.isSuccess());
        }
            
    }

    
    @isTest 
    static void testImportCampaignMemberWithNullValues() {

        User usr = [SELECT Id,RUT__c FROM User WHERE UserName = 'TESTCAMPAIGNMEMBER@consorcio.cl.devsales' LIMIT 1]; 
        
        System.runAs(usr) {

            // Perform test
            Test.startTest();
            
            // Crear nueva campaña vigente
            Campaign campaign1 = new Campaign();
            campaign1.IsActive = true;
            campaign1.Name = 'Campaña de test unitario';
			campaign1.Status = Constants.CAMPAIGN_STATUS_INGRESADA;
            // Prueba de test BBEE
            campaign1.CampaignMemberRecordTypeId = Schema.SObjectType.CampaignMember.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_CAMPAIGN_SALES_PERSONA).getRecordTypeId();
            campaign1.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_RP_SALES_CAMPAIGN).getRecordTypeId();

            insert campaign1;

			List<CampaignMember> cms = new List<CampaignMember>();
            // Crear Miembro asociado a una campaña
            CampaignMember cm = new CampaignMember();
            cm.CampaignId = campaign1.Id;
 

            CampaignMember cm2 = new CampaignMember();
            cm2.CampaignId = campaign1.Id;
            cm.RUT_sales__c = '3-5';
            cm.RUT_Ejecutivo_sales__c = '3-5';

            cms.add(cm2);
            cms.add(cm);
            Database.SaveResult[] result = Database.insert(cms, false);
           
            Test.stopTest();
            
         
            System.assert(!result[0].isSuccess());
            System.assert(!result[1].isSuccess());
        }
    }

    @isTest 
    static void testUpdateCampaignMemberWithNullValues() {

        User usr = [SELECT Id,RUT__c FROM User WHERE UserName = 'TESTCAMPAIGNMEMBER@consorcio.cl.devsales' LIMIT 1]; 
        
        System.runAs(usr) {

            // Perform test
            Test.startTest();
            
            // Crear nueva campaña vigente
            Campaign campaign1 = new Campaign();
            campaign1.IsActive = true;
            campaign1.Name = 'Campaña de test unitario';
			campaign1.Status = Constants.CAMPAIGN_STATUS_INGRESADA;
            // Prueba de test BBEE
            campaign1.CampaignMemberRecordTypeId = Schema.SObjectType.CampaignMember.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_CAMPAIGN_SALES_PERSONA).getRecordTypeId();
            campaign1.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_RP_SALES_CAMPAIGN).getRecordTypeId();
            
            insert campaign1;

			List<CampaignMember> cms = new List<CampaignMember>();
            // Crear Miembro asociado a una campaña
            CampaignMember cm = new CampaignMember();
            cm.CampaignId = campaign1.Id;
            cm.RUT_sales__c = '2-7';
            cm.RUT_Ejecutivo_sales__c = usr.RUT__c;
            cms.add(cm);
            
            insert cms;
            
            Database.SaveResult[] result = Database.update(cms, false);            
           
            Test.stopTest();
            
           
            System.assert(result[0].isSuccess());
        }
    }

    @isTest 
    static void testCampaignMemberWithLeads() {

        User usr = [SELECT Id,RUT__c FROM User WHERE UserName = 'TESTCAMPAIGNMEMBER@consorcio.cl.devsales' LIMIT 1]; 
        
        System.runAs(usr) {

            // Perform test
            Test.startTest();
            
            // Crear nueva campaña vigente
            Campaign campaign1 = new Campaign();
            campaign1.IsActive = true;
            campaign1.Name = 'Campaña de test unitario';
			campaign1.Status = Constants.CAMPAIGN_STATUS_INGRESADA;
            // Prueba de test BBEE
            campaign1.CampaignMemberRecordTypeId = Schema.SObjectType.CampaignMember.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_CAMPAIGN_SALES_PERSONA).getRecordTypeId();
            campaign1.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_RP_SALES_CAMPAIGN).getRecordTypeId();
            
            insert campaign1;
            
           
            Lead lead1 = new Lead();
            lead1.LastName = 'Lastname';
            lead1.tipo_documento_sales__c = Constants.RUT;
            lead1.numero_de_documento_sales__c = '24145640-4';
            lead1.Email = 'wwww@www.cl';
            lead1.recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_SALES_LEAD_PERSONAS).getRecordTypeId(); 
            
            insert lead1;
            
            // Crear Miembro asociado a una campaña
            CampaignMember cm = new CampaignMember();
            cm.CampaignId = campaign1.Id;
            cm.RUT_sales__c = '24145640-4';
            cm.RUT_Ejecutivo_sales__c = usr.RUT__c;
  
    
            Database.SaveResult result = Database.insert(cm, false);
           
            Test.stopTest();
            
            System.assert(result.isSuccess());
        }
    }    
}