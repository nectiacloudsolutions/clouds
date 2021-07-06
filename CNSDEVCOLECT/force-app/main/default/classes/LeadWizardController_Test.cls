/*********************************************************************************************************
@Author       fmaturan@everis.com
@name         LeadWizardController_Test
@CreateDate   07/10/2019
@Description  Test of the class LeadWizardController.
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          		Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
07/10/2019		fmaturan@everis.com               initial version
07/10/2019		fmaturan@everis.com               Finished the test method validRut
08/10/2019		fmaturan@everis.com               Created the test method AnalyticsForLeadTest
10/10/2019		fmaturan@everis.com               finished the test methods AnalyticsForLeadTest and changeLeadOwnerTest
**********************************************************************************************************/
@isTest
private class LeadWizardController_Test {
    private static final String RUT='10854082-6';

    /**
    * @description make Data for Org Test
    * @author eayalcor@everis.com | 03-12-2019 
    * @return void 
    **/
    @TestSetup
    static void makeData(){
        TestFactorySales.populateOrg();
    }
    
    /**
    * @description Test method, validate RUT
    * @author eayalcor@everis.com | 03-12-2019 
    * @return void 
    **/
    @isTest static void validRutMethod(){

        Test.startTest();        
        Map<String,List<SObject>> validRut = new Map<String,List<SObject>>();
        validRut= LeadWizardController.validatedRUT(RUT);
        Test.stopTest();
        
        List<Account> accs = validRut.get('Account');
        Account acc = new Account();
        string rutAcc;
        if (accs.size()>0){
            acc = accs.get(0);
            rutAcc = acc.Rut__c;
    	}
        List<Lead> leads = validRut.get('Lead');
        Lead lead = new Lead();
        string rutLead;
        if(leads.size()>0){
            lead = leads.get(0);
            rutLead = lead.numero_de_documento_sales__c;
        }
        System.assertEquals(RUT, rutAcc, 'Fallo Test Equals');
        System.assertNotEquals(RUT, rutLead, 'Fallo Test');
        
    }
    
    /**
      * @description       Tests the method consultAnalyticsForLead using a mock call.  
      * @param            
      * @return            void
      * @throws            NA
    */
    
    @isTest static void AnalyticsForLeadTest(){

        Lead lead = TestFactorySales.createNewLead('14000525-8', '1-9', 'Test Analytics');
        SalesCallout.leadData ldata = new SalesCallout.leadData();
        ldata.message = 'OK';
        ldata.code = '200';
        ldata.action = 'query';
        ldata.lead = lead;
        String json = JSON.serialize(ldata);
        System.debug('JSON: '+json);
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200, 
                                                 'ok',
                                                 json,
                                                 null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        String response = LeadWizardController.consultAnalyticsForLead('14000525-8');
        SalesCallout.leadData result = (SalesCallout.leadData) system.json.deserialize(response, SalesCallout.leadData.class);
        Test.stopTest();

        System.assertEquals('200',result.code);
        
    }
    
    /**
      * @description       Tests the method changeLeadOwner.  
      * @param            
      * @return            void
      * @throws            NA
    */
    
    @isTest static void changeLeadOwnerTest(){
        List<User> usr = [Select id,name from User ];
        List<Lead> lead =[Select id,name from Lead ];
        boolean b = LeadWizardController.changeLeadOwner(lead[0].Id,Usr[1].Id);
        System.assert(b);
    }

    /**
    * @description Tests the method createLead
    * @author pcelis@everis.com | 10-12-2019 
    * @return void 
    **/
    @isTest static void createLeadTest(){
        String Fname='Test007';
        String LName='LTest';
        String Phone='5656454';
        String email='test@test.cl';
        String Rut='18343856-4';

        LeadWizardController.createLead(FName, LName, Phone, email, Rut);
        List<Lead> lead =[Select id,FirstName from Lead where FirstName='Test007'];
        System.assertEquals(Fname,lead[0].FirstName);
    }
    
    /**
    * @description Tests the method notifyExecutive
    * @author fbizamam@everis.com | 21-02-2020 
    * @return void 
    **/
    @isTest static void notifyExecutiveTest(){
        List<User> usr =[Select id from User where RUT__c ='19' LIMIT 1];
        List<Lead> lead =[Select id,FirstName,OwnerId from Lead where numero_de_documento_sales__c ='9669258-7' LIMIT 1];
        List<Account> acc =[Select id,FirstName,OwnerId from Account where RUT__c ='10854082-6' LIMIT 1];
        System.runAs(usr[0]){
            System.assert(LeadWizardController.notifyExecutive( lead[0].Id));
            System.assert(LeadWizardController.notifyExecutive( acc[0].Id));
        }
        
        
    }
	
}