/*********************************************************************************************************
@Author       curbinav@everis.com
@name         CampaignTriggerTest
@CreateDate   12/11/2019
@Description  Test class for CampaignTriggerHelper
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
12/11/2019    curbinav@everis.com           W-000073 - (Vista 360° Cliente) - Ingreso Sección Cliente (Resumen)
**********************************************************************************************************/
@isTest
public class CampaignTriggerTest {

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
    /**
     * Contador de campañas activas
     * 
     **/
    @isTest static void TestContarCampanasActivas() {

       User usr = [SELECT Id,RUT__c FROM User WHERE UserName = 'TESTCAMPAIGNMEMBER@consorcio.cl.devsales' LIMIT 1];   
      
        
        System.runAs(usr) {

            // Perform test
            Test.startTest();
            
            // Crear nueva campaña vigente
            Campaign campaign1 = new Campaign();
            campaign1.Type =  Constants.CAMPAIGN_TYPE_CLIENTES;
            campaign1.IsActive = false;
            campaign1.Name = 'Campaña inactiva';
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
	        insert cm;
           	
            // Activar campaña
            campaign1.IsActive = true;
            campaign1.Status = Constants.CAMPAIGN_STATUS_ACTIVADA;

            Database.SaveResult result = Database.update(campaign1, false);
            System.assert(result.isSuccess());
            
            // Desactivar campaña
            campaign1.IsActive = false;
            campaign1.Status = Constants.CAMPAIGN_STATUS_SUSPENDIDA;

            Database.SaveResult resSus = Database.update(campaign1, false);
			System.assert(resSus.isSuccess());

            Test.stopTest();

        }
    }    
}