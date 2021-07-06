@isTest
private class BatchCampaignTriggerHelper_Test {
	@TestSetup
    static void makeData(){
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
        
        Account personAccount = new Account();
        personAccount.RUT__c = '2-7';
        personAccount.LastName = 'Lastname';
        personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_PERSON_ACCOUNT_SEGUROS).getRecordTypeId();
        
        insert personAccount;
    }
    
    @isTest
    static void testBatchNotificacionesMiembrosCampana(){
        
        User usr = [SELECT Id,RUT__c FROM User WHERE UserName = 'TESTCAMPAIGNMEMBER@consorcio.cl.devsales' LIMIT 1];   
       
        System.runAs(usr) {

            Test.startTest();
            
            List<Campaign> lstCmp = new List<Campaign>();
            Campaign campaign1 = new Campaign();
            campaign1.Type =  Constants.CAMPAIGN_TYPE_CLIENTES;
            campaign1.IsActive = false;
            campaign1.Name = 'Campaña TestBatch';
            campaign1.Status = Constants.CAMPAIGN_STATUS_INGRESADA;
            campaign1.CampaignMemberRecordTypeId = Schema.SObjectType.CampaignMember.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_CAMPAIGN_SALES_PERSONA).getRecordTypeId();
            campaign1.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_RP_SALES_CAMPAIGN).getRecordTypeId();
            insert campaign1;

            CampaignMember cm = new CampaignMember();
            cm.CampaignId = campaign1.Id;
            cm.RUT_sales__c = '2-7';
            cm.RUT_Ejecutivo_sales__c = usr.RUT__c;
            cm.enviar_correo_sales__c = false;
	        insert cm;
           	
			Set<Id> campaignIds = new Set<Id>();
            campaignIds.add(campaign1.Id);
             
            Database.executeBatch(new BatchCampaignTriggerHelper(campaignIds, lstCmp));            

            Test.stopTest();
            
            List<CampaignMember> lstcmtest = [SELECT enviar_correo_sales__c FROM CampaignMember WHERE CampaignId =: campaign1.Id LIMIT 1];
            
            System.assertEquals(true, lstcmtest[0].enviar_correo_sales__c);

        }        
    }
}