/*********************************************************************************************************
@Author       pcelisbe@everis.com
@name         cnf_sal_tri_event_Test
@CreateDate   10/10/2019
@Description  Test of the class cnf_sal_tri_event.
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          		Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
10/10/2019		pcelisbe@everis.com               initial version
30/10/2019		fbizamam@everis.com               W-000149 - (Gestión del Lead) - Cambio de estados del Candidato/T-00083/ Added onAfterUpdateLeadTest Method
08/11/2019		fbizamam@everis.com               W-000149 - (Gestión del Lead) - Cambio de estados del Candidato/T-00083/ Added testLeadManagement Method
11/11/2019		fbizamam@everis.com               W-000149 - (Gestión del Lead) - Cambio de estados del Candidato/T-00083/ Added testLeadManagementCustom Method
**********************************************************************************************************/
@isTest
public class cnf_sal_tri_lead_Test {
    
    
    private static final Datetime myDateTime = Datetime.now();
    private static final string Testrut1 = '14860696-k';
    private static final string Testrut2 = '9669258-7';
    private static final string Testrut3 = '14000525-8';
    private static final string lastName = 'PEREZ';
    private static final string location ='Santiago';
     private static final string Description ='Santiago';
    /**
      * @description       Tests when an after Insert of a Lead ocurrs  
      * @param            
      * @return            void
      * @throws            NA
    */
	@isTest
    static void TestonAfterInsert(){
        
    	Map<String, SObject> mpsObjects = TestFactorySales.populateOrg();
        User usr=(User) mpsObjects.get('User2');
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true);
        
        System.runAs(usr) {
            Map<Id,Lead> MapLead= new Map<Id,Lead>();
            //List<Lead> NewLead= new List<Lead>();
            //NewLead.add(LD);
                   SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"AccessToken": "eyJra","ExpiresIn": 3600,"TokenType": "Bearer","RefreshToken": "eyJjdHki","IdToken": "eyJraWQiOiJlT"}',
                                                 null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        Lead lead = TestFactorySales.createNewLead('14000525-8', '1-9', 'Test Analytics');
        SalesCallout.leadData ldata = new SalesCallout.leadData();
        ldata.message = 'OK';
        ldata.code = '200';
        ldata.action = 'query';
        ldata.lead = lead;
        String json = JSON.serialize(ldata);
        System.debug('JSON: '+json);
        Test.startTest();
        SalesCalloutMock fakeResponseConsult = new SalesCalloutMock(200,
                                                 'ok',
                                                 json,
                                                 null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
        String s = LeadWizardController.consultAnalyticsForLead('14000525-8');
        System.assertEquals('{"AccessToken": "eyJra","ExpiresIn": 3600,"TokenType": "Bearer","RefreshToken": "eyJjdHki","IdToken": "eyJraWQiOiJlT"}', s);
        }
    }
     /**
      * @description       Tests when an after update of a Lead ocurrs  
      * @param            
      * @return            void
      * @throws            NA
    */
       
    @isTest
    static void onAfterUpdateLeadTest(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();
        
      
        Lead lead = (Lead)mpsObjects.get('Lead');
        User user = (User)mpsObjects.get('User');
        User user2 = (User)mpsObjects.get('User2');
        upsert new Consorcio_Org__c(SetupOwnerId=user.Id,Sales_project__c=true);
        Event Evt = new Event(Subject=CONSTANTS.EVENT_SUBJECT_ENTREVISTA,Type=Constants.EVENT_TYPE_ENTREVISTA,StartDateTime=myDateTime.addMinutes(30),EndDateTime=myDateTime.addMinutes(60),
                              WhoId=lead.id,Description=description,Location=location,flag_convertido_sales__c = false);
        insert Evt;
        Evt.estado_reunion_sales__c =  CONSTANTS.EVENT_ESTADO_ENTREVISTA_EXITOSO;
        update Evt;
  
        System.debug(Evt);
        
        System.runAs(user){
            Lead led = TestFactorySales.createNewLead('16749436-6','19','testLead');
             led.Status = constants.LEAD_STATUS_CREADO;
            upsert led;
           
            Event ev = TestFactorySales.createEvent(led.Id,CONSTANTS.EVENT_TYPE_ENTREVISTA,CONSTANTS.EVENT_ESTADO_ENTREVISTA_NOEXITOSO, CONSTANTS.EVENT_RESULTADO_ENTREVISTA_NOINTERESA);
             ev.motivo_no_interesa_sales__c = CONSTANTS.EVENT_MOTIVO_NO_INTERESA; 
            ev.StartDateTime =  DateTime.now();
            ev.ActivityDateTime = ev.StartDateTime;
                insert ev;
            Event eveConvert = TestFactorySales.createEvent(lead.Id,CONSTANTS.EVENT_TYPE_ENTREVISTA,CONSTANTS.EVENT_ESTADO_ENTREVISTA_EXITOSO, CONSTANTS.EVENT_RESULTADO_REUNION_EXITOSA);
           
            eveConvert.StartDateTime = DateTime.now();
            eveConvert.ActivityDateTime =  eveConvert.StartDateTime;
            INSERT  eveConvert;
           
             led.status = constants.LEAD_STATUS_NO_INTERESADO; update led;
            
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id;
            ev.RecordTypeId = rTypeEvent;
            EV.estado_reunion_sales__c = CONSTANTS.EVENT_ESTADO_ENTREVISTA_NOEXITOSO;
            EV.resultado_de_la_reunion_sales__c = CONSTANTS.EVENT_RESULTADO_ENTREVISTA_NOINTERESA;
            update ev;
            Account ac = new Account(LastName=LASTNAME);
            ac.Tipo_de_documento_de_identidad__c = CONSTANTS.RUT;
            insert ac;
            ac.RUT__c = testrut2;
            update ac;
            List<Lead> leads = new List<Lead>();
            leads.add(lead);
           
            Database.SaveResult[] srList = Database.update(leads, false);
            for (Database.SaveResult sr : srList) {   
               
                System.assertEquals(lead.Id, sr.getId());
               
            } 
            
            //T
            lead.OwnerId = user2.Id;
            List<Lead> leads2 = new List<Lead>();
            leads2.add(lead);
            Database.SaveResult[] srList2 = Database.update(leads2, false);
            for (Database.SaveResult sr : srList2) {   
               
                System.assertEquals(lead.Id, sr.getId());
               
            } 
            
            
        }
    }
    
  
    /**
      * @description       Tests when an after update of a Lead occurs and the management of his status
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest
    static void testLeadManagement(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();
        Lead lead = (Lead)mpsObjects.get('Lead2');
        User usrr = (User)mpsObjects.get('User');
        lead.OwnerId = usrr.Id;
        lead.numero_de_documento_sales__c = '';
        
        User user = (User)mpsObjects.get('User2');
        User us = [SELECT id,name,rut__c FROM user WHERE id =: lead.OwnerId];
        upsert new Consorcio_Org__c(SetupOwnerId=user.Id,Sales_project__c=true);
        Event Evt = new Event(Subject=CONSTANTS.EVENT_SUBJECT_ENTREVISTA,Type=Constants.EVENT_TYPE_ENTREVISTA,StartDateTime=myDateTime.addMinutes(30),
                              EndDateTime=myDateTime.addMinutes(60),WhoId=lead.id,Description=description,Location=location,
                              flag_convertido_sales__c = false);
        insert Evt;
        Evt.estado_reunion_sales__c =  CONSTANTS.EVENT_ESTADO_ENTREVISTA_EXITOSO;
        update Evt;
        
        System.debug(Evt);
        
        System.runAs(us){
            lead.numero_de_documento_sales__c = testrut1;
            lead.tipo_documento_sales__c = CONSTANTS.RUT;
            lead.Flag_Lead_sales__c=true;
            List<Lead> leads = new List<Lead>();
            leads.add(lead);
            Database.SaveResult[] srList = Database.update(leads, false);
           // system.debug('BOOM');
            //System.debug(lead.OwnerId);
            //System.debug(user.Id);
            //System.debug(us.Id);
            for (Database.SaveResult sr : srList) { 
               // System.debug('ATANGANA');
//                system.debug(sr.getErrors());
               // system.debug(sr.id);
               // system.debug(sr.errors);
                // System.assertEquals(lead.Id, sr.getId());
 
  
            }
            try{
                update lead;
            }catch(Exception e){
                system.debug(e.getMessage());
                system.debug(e.getStackTraceString());
                system.debug(e.getLineNumber());
            }
            
            
        }
    }
    /**
      * @description       Tests when an after update of a Lead occurs and the management of his status under different circumstances 
      * @param            
      * @return            void
      * @throws            NA
    */
     @isTest
    static void testLeadManagementCustom(){  
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();
        Lead lead = (Lead)mpsObjects.get('Lead2');
        User user = (User)mpsObjects.get('User2');
        upsert new Consorcio_Org__c(SetupOwnerId=user.Id,Sales_project__c=true);
        Event Evt = new Event(Subject=CONSTANTS.EVENT_SUBJECT_ENTREVISTA,Type=Constants.EVENT_TYPE_ENTREVISTA,StartDateTime=myDateTime.addMinutes(30),
                              EndDateTime=myDateTime.addMinutes(60),WhoId=lead.id,Description=description,Location=location,
                              flag_convertido_sales__c = false);
        
        insert Evt;
        
        System.runAs(user){
            lead.numero_de_documento_sales__c = Testrut1;
            lead.tipo_documento_sales__c = CONSTANTS.RUT;
            lead.Flag_Lead_sales__c=true;
            List<Lead> leads = new List<Lead>();
            leads.add(lead);
            Database.SaveResult[] srList = Database.update(leads, false);
            for (Database.SaveResult sr : srList) {    
                 System.assertEquals(lead.Id, sr.getId());
  
            } 
            
        }
    }
    
   
}