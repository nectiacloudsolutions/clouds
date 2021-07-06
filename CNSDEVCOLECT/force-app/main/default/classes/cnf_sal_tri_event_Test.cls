/*********************************************************************************************************
@Author       pcelisbe@everis.com
@name         cnf_sal_tri_event_Test
@CreateDate   08/10/2019
@Description  Test of the class cnf_sal_tri_event.
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          		Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
08/10/2019		pcelisbe@everis.com               initial version
12/11/2019    	fmaturan@everis.com				  W-000149 - (Gestión del Lead) - Cambio de estados del Candidato
27/11/2019    	fmaturan@everis.com				  W-000156 - (Gestión de Oportunidades) - Visualización de estado "Contacto"
**********************************************************************************************************/
@isTest
private class cnf_sal_tri_event_Test {
    
    private static final Datetime myDateTime = Datetime.now();
    private static final String Rut1 = '18469660-6';
    private static final String Rut2 = '23180775-6';
    private static final String USERVTPRUT = '3-7';
    private static final String USERVTPALIAS = 'USERVTA';
    private static final String ACCRUT = '14568948-1';
    private static final String ACCLASTNAME = 'Hernandez';
    
    /**
    * @description       Test -- testCreateObj
    * @param             void
    * @return            NA
    * @throws            NA 
    */	
    @testSetup
    private static void testCreateObj(){

        test.startTest();
        
        //Create User Ejecutivo Venta
		User user01 = TestFactorySales.createUser(USERVTPRUT, CONSTANTS.PROFILE_EJECUTIVO_VENTA, USERVTPALIAS);        
        insert user01;
        System.runAs(user01){
            Lead lead01 = TestFactorySales.createNewLead(Rut1, USERVTPRUT, 'TEST');
        }        
        Test.stopTest();
    }
    @isTest static void testLlamadaNoContactoVolverALlamar(){
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false,leads_sales__c = true);
        Lead lead = [SELECT Id FROM Lead WHERE numero_de_documento_sales__c =: Rut1 LIMIT 1];
        EventWizardController.evtBtn = true;
        Test.startTest();
        System.runAs(usr){
            Event evt = TestFactorySales.createEvent(lead.id,Constants.EVENT_TYPE_LLAMADA,
                                                     Constants.EVENT_ESTADO_LLAMADA_NOCONTACTADO,Constants.EVENT_RESULTADO_LLAMADA_NOCONTESTALLAMAR);
            insert evt;
            update evt;
            Test.stopTest();
            System.assertEquals(Constants.EVENT_TYPE_LLAMADA, evt.Type);
        }
    }
    
    @isTest private static void TestLlamadaContactoVolverAEntrevistar() {
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        Lead lead = [SELECT Id FROM Lead WHERE numero_de_documento_sales__c =: Rut1 LIMIT 1];
        test.startTest();
        System.runAs(usr) {
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
            Event evt = TestFactorySales.createEvent(lead.id,Constants.EVENT_TYPE_LLAMADA,
                                                     Constants.EVENT_ESTADO_LLAMADA_CONTACTADO,Constants.EVENT_RESULTADO_LLAMADA_ENTEVISTA);
            insert evt;
            update evt;
		    Test.stopTest();
            System.assertEquals(Constants.EVENT_TYPE_LLAMADA, evt.Type);
        }
    }
        @isTest private static void testLlamadaContactoLlamadaLlamar() {
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false,leads_sales__c = true);
        Lead lead = [SELECT Id FROM Lead WHERE numero_de_documento_sales__c =: Rut1 LIMIT 1];
        EventWizardController.evtBtn = true;
        test.startTest();
        System.runAs(usr) {
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
            Event evt = TestFactorySales.createEvent(lead.id,Constants.EVENT_TYPE_LLAMADA,
                                                     Constants.EVENT_ESTADO_LLAMADA_CONTACTADO,Constants.EVENT_RESULTADO_LLAMADA_LLAMAR);
            insert evt;
            //update evt;
		    Test.stopTest();
            System.assertEquals(Constants.EVENT_TYPE_LLAMADA, evt.Type);
        }
    }
    @isTest private static void TestLlamadaContactoExitoso() {
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        Lead lead = [SELECT Id FROM Lead WHERE numero_de_documento_sales__c =: Rut1 LIMIT 1];
        test.startTest();
        System.runAs(usr) {
            Event Evt = TestFactorySales.createEvent(lead.id,Constants.EVENT_TYPE_LLAMADA,
                                                     Constants.EVENT_ESTADO_LLAMADA_CONTACTADO,Constants.EVENT_RESULTADO_LLAMADA_EXITOSA);
            insert Evt;
            update Evt;
            Test.stopTest();
            System.assertEquals(Constants.EVENT_TYPE_LLAMADA, evt.Type);
        }
    }
    @isTest private static void TestLlamadaContactoNoInteresa() {
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        Lead lead = [SELECT Id FROM Lead WHERE numero_de_documento_sales__c =: Rut1 LIMIT 1];
        test.startTest();
        System.runAs(usr) {
            Event Evt = TestFactorySales.createEvent(lead.id,Constants.EVENT_TYPE_LLAMADA,
                                                     Constants.EVENT_ESTADO_LLAMADA_CONTACTADO,Constants.EVENT_RESULTADO_LLAMADA_NOINTERESA);
            insert Evt;
            update Evt;
            Test.stopTest();
            System.assertEquals(Constants.EVENT_TYPE_LLAMADA, evt.Type);
        }
    }
    /**
      * @description       Tests when an after update event ocurrs and "resultado_de_la_reunion_sales__c" = "Volver a LLamar". 
      * @author            pcelisbe@everis.com | 08-10-2019 
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest private static void TestAfterUpdateNewCall() { 
        // Test data setup
		User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        Lead lead = [SELECT Id FROM Lead WHERE numero_de_documento_sales__c =: Rut1 LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);

        System.runAs(usr) {
            // Create an Event
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
            Event Evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA,Subject=Constants.EVENT_SUBJECT_AGENDA,
                                DurationInMinutes=2,ActivityDateTime=myDateTime.addDays(1),whoId=lead.Id, recordTypeId = rTypeEvent);
            insert Evt;
            Event upEvent = [SELECT Subject,resultado_de_la_reunion_sales__c,fecha_nueva_gestion_sales__c
                     FROM Event WHERE Subject=:Constants.EVENT_SUBJECT_AGENDA LIMIT 1];
        
            // Update the Subject
            upEvent.Subject = Constants.EVENT_SUBJECT_ENTREVISTA;
            upEvent.estado_reunion_sales__c = Constants.EVENT_ESTADO_ENTREVISTA_NOEXITOSO;
            upEvent.resultado_de_la_reunion_sales__c = Constants.EVENT_RESULTADO_ENTREVISTA_LLAMAR;
            upEvent.fecha_nueva_gestion_sales__c= myDateTime.addDays(3);
            // Make the update call.
            update upEvent;
        
            System.assertEquals('Entrevista', upEvent.Subject);
        }

    }
    /**
      * @description       Tests when an after update event ocurrs and "resultado_de_la_reunion_sales__c" = "No le Interesa".
      * @author            pcelisbe@everis.com | 08-10-2019   
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest private static void testAfterUpdateNotInterested() { 
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        Lead lead = [SELECT Id FROM Lead WHERE numero_de_documento_sales__c =: Rut1 LIMIT 1];
       
        
        System.runAs(usr) {
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
            Event Evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA,Subject=Constants.EVENT_SUBJECT_AGENDA,
                                  DurationInMinutes=2,ActivityDateTime=myDateTime.addDays(1),whoId=lead.Id,
                                  recordTypeId = rTypeEvent);
            insert Evt;
            Event upEvent = [SELECT Id,resultado_de_la_reunion_sales__c,estado_reunion_sales__c FROM Event WHERE Id=: Evt.Id LIMIT 1];

            upEvent.estado_reunion_sales__c = Constants.EVENT_ESTADO_ENTREVISTA_NOEXITOSO;
            upEvent.resultado_de_la_reunion_sales__c = Constants.EVENT_RESULTADO_ENTREVISTA_NOINTERESA;
            update upEvent;
            
            System.assertEquals(Constants.EVENT_RESULTADO_ENTREVISTA_NOINTERESA, upEvent.resultado_de_la_reunion_sales__c);
        }

    }
    /**
      * @description       Tests when an after insert event ocurrs with a person contact and a campaign related. 
      * @author            fmaturan@everis.com | 27-11-2019 
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest
    static private void onAfterInsertEventTest(){
		RecordType rt = [Select Id FROM RecordType WHERE DeveloperName='Cliente_Persona_Seguros' Limit 1];
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        Lead lead = [SELECT Id FROM Lead WHERE numero_de_documento_sales__c =: Rut1 LIMIT 1];
        System.runAs(usr){
            Account acc= New Account(recordTypeId=rt.Id,LastName='Test',Rut__c=Rut1,Tipo_de_documento_de_identidad__c = Constants.RUT);
            Campaign cmp = new Campaign(name='Campaña1',isActive = true);
            
            insert acc;
            insert cmp;
            Account acc1 = [Select PersonContactId From Account Where Rut__c=:Rut1 Limit 1];
            CampaignMember cm= new CampaignMember(CampaignId=cmp.Id, ContactId=acc1.PersonContactId);
            insert cm;

            Event evt = new Event(Subject='Entrevista',
                                  Id_Miembro_de_Campana_sales__c= cm.Id,
                                  Type=Constants.EVENT_TYPE_ENTREVISTA,
                                  StartDateTime=myDateTime.addMinutes(30),
                                  EndDateTime=myDateTime.addMinutes(60),
                                  WhoId=acc1.PersonContactId,
                                  WhatId=cmp.Id,
                                  Description='Test',
                                  Location='Santiago',
                                  flag_convertido_sales__c = true);
            insert evt;
            System.assertEquals(Constants.EVENT_TYPE_ENTREVISTA, evt.Type);
        }
    }
    /**
      * @description       Tests when an after insert event ocurrs with a resultado_de_la_reunion_sales__c = Null. 
      * @author            fmaturan@everis.com | 12-11-2019  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest private static void testAfterInsertRutAndMeeting() { 
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        Lead lead = [SELECT Id FROM Lead WHERE numero_de_documento_sales__c =: Rut1 LIMIT 1];
       
        
        System.runAs(usr) {
            Event Evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA ,Subject=Constants.EVENT_SUBJECT_AGENDA,DurationInMinutes=2,
                                  ActivityDateTime=myDateTime.addDays(1),whoId=lead.Id);
            insert Evt;
            //Valida que el resultado no haya sido ingresado           
            System.assertEquals(Null, Evt.resultado_de_la_reunion_sales__c);
        }

    }
    /**
      * @description       Tests when an after insert event ocurrs with a resultado_de_la_reunion_sales__c = Reunion Exitosa. 
      * @author            fmaturan@everis.com | 12-11-2019  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest private static void testAfterUpdateRutMeetingAndResult() { 
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        Lead lead = [SELECT Id FROM Lead WHERE numero_de_documento_sales__c =: Rut1 LIMIT 1];
        Account acc2= TestFactorySales.createNewAccount(Rut1, 'Test');
       
        
        System.runAs(usr) {
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
            Event Evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA ,Subject=Constants.EVENT_SUBJECT_AGENDA,DurationInMinutes=2,
                                  ActivityDateTime=myDateTime.addDays(1),whoId=lead.Id,recordTypeId = rTypeEvent);
            
            insert Evt;
            Event upEvent = [SELECT Id,resultado_de_la_reunion_sales__c,estado_reunion_sales__c FROM Event WHERE Id=: Evt.Id LIMIT 1];

            upEvent.estado_reunion_sales__c = Constants.EVENT_ESTADO_ENTREVISTA_EXITOSO;
            upEvent.resultado_de_la_reunion_sales__c = Constants.EVENT_RESULTADO_REUNION_EXITOSA;
            update upEvent;
            //Valida que el resultado del evento fue exitoso
            System.assertEquals(Constants.EVENT_RESULTADO_REUNION_EXITOSA, upEvent.resultado_de_la_reunion_sales__c);
        }

    }
    /**
      * @description       Tests when an after insert event ocurrs with a resultado_de_la_reunion_sales__c = Reunion Exitosa. 
      * @author            fmaturan@everis.com | 12-11-2019  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest private static void testAfterInsertLeadRutNotEqualsAccount() { 
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        Lead lead = [SELECT Id FROM Lead WHERE numero_de_documento_sales__c =: Rut1 LIMIT 1];
        Account acc= TestFactorySales.createNewAccount(Rut2, 'Test');
        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);
        
        System.runAs(usr) {
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
            Event Evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA ,Subject=Constants.EVENT_SUBJECT_AGENDA,DurationInMinutes=2,
                                  ActivityDateTime=myDateTime.addDays(1),whoId=lead.Id, recordTypeId = rTypeEvent);
            
            insert Evt;
            Event upEvent = [SELECT Id,resultado_de_la_reunion_sales__c,estado_reunion_sales__c FROM Event WHERE Id=: Evt.Id LIMIT 1];

            upEvent.estado_reunion_sales__c = Constants.EVENT_ESTADO_ENTREVISTA_EXITOSO;
            upEvent.resultado_de_la_reunion_sales__c = Constants.EVENT_RESULTADO_REUNION_EXITOSA;
            update upEvent;            
            //Valida que el resultado del evento fue exitoso
            System.assertEquals(Constants.EVENT_RESULTADO_REUNION_EXITOSA, upEvent.resultado_de_la_reunion_sales__c);
        }

    }
    /**
      * @description       Tests when an after insert event ocurrs with a resultado_de_la_reunion_sales__c = Reunion Exitosa and Lead Rut not equals Account rut. 
      * @author            fmaturan@everis.com | 12-11-2019  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest private static void testAfterUpdateLeadRutNotEqualsAccount() { 
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        Lead lead = [SELECT Id FROM Lead WHERE numero_de_documento_sales__c =: Rut1 LIMIT 1];
        Account acc= TestFactorySales.createNewAccount(Rut2, 'Test');
       upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);
        
        System.runAs(usr) {
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
            Event Evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA ,Subject=Constants.EVENT_SUBJECT_AGENDA,DurationInMinutes=2,
                                  ActivityDateTime=myDateTime.addDays(1),whoId=lead.Id, recordTypeId = rTypeEvent);
            
            insert Evt;
            Event upEvent = [SELECT Id,resultado_de_la_reunion_sales__c,estado_reunion_sales__c FROM Event WHERE Id=: Evt.Id LIMIT 1];

            upEvent.estado_reunion_sales__c = Constants.EVENT_ESTADO_ENTREVISTA_EXITOSO;
            upEvent.resultado_de_la_reunion_sales__c = Constants.EVENT_RESULTADO_REUNION_EXITOSA;
            update upEvent;            
            //Valida que el resultado del evento fue exitoso
            System.assertEquals(Constants.EVENT_RESULTADO_REUNION_EXITOSA, upEvent.resultado_de_la_reunion_sales__c);
        }

    }
    /**
      * @description       Tests when an after update event ocurrs in Opportunity with RT Seguros and "resultado_de_la_reunion_sales__c" = "Reunion exitosa".
      * @author            fmaturan@everis.com | 27-11-2019   
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest private static void TestAfterUpdateOpportunitySuccessRTSeguros() { 
        // Test data setup;
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        RecordType rt = [Select Id FROM RecordType WHERE DeveloperName=:Constants.RECORDTYPE_SEGURO_VIDA LIMIT 1];
        Account acc= New Account(LastName='Test',Rut__c=Rut1,Tipo_de_documento_de_identidad__c = Constants.RUT);
        Insert acc;
        id pbId = Test.getStandardPricebookId();
        Pricebook2 customPB = new Pricebook2(Name=Constants.PRICEBOOK_NAME1, isActive=true);
        insert customPB;
        Product2 prod=new Product2(Name='Seguro de vida',codigo_producto_sales__c='99',tipo_producto_sales__c= Constants.RECORDTYPE_SEGURO_VIDA);
        Insert prod;
        PriceBookEntry pbStd = new PriceBookEntry(UnitPrice=1,Product2Id= prod.Id, Pricebook2Id=pbId, IsActive=true, UseStandardPrice = false);
        insert pbStd;      
		PriceBookEntry pb = new PriceBookEntry(UnitPrice=0,Product2Id= prod.Id, Pricebook2Id=customPB.id, IsActive=true, UseStandardPrice = false);
		insert pb;        
        Opportunity opp = new Opportunity (StageName =Constants.OPPORTUNITY_STAGE_CONTACTO,
                                           Name='test',CloseDate=Date.today(),
                                           AccountId=acc.Id,
                                           RecordTypeId=rt.Id,
                                           OwnerId=usr.Id);
        Insert opp;
        OpportunityLineItem prodOpp = new OpportunityLineItem(Quantity=13,
                                                              OpportunityId=opp.Id,
                                                              PricebookEntryId=pb.Id,
                                                              Product2Id= prod.id,
                                                              UnitPrice=10);

        System.debug('Oportunidad creada: ' + opp);
        insert prodOpp;
        // Create an Event
        Test.startTest();
        System.runAs(usr) {
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
            Event evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA,Subject=Constants.EVENT_SUBJECT_AGENDA,
                                  DurationInMinutes=2,ActivityDateTime=myDateTime.addDays(1),WhatId=opp.Id,
                                  recordTypeId = rTypeEvent);
            insert evt;

            System.debug('Evento Creado: '+ evt);
            
            Event upEvent = [SELECT Id,resultado_de_la_reunion_sales__c,estado_reunion_sales__c FROM Event WHERE Id=: evt.Id LIMIT 1];
         
            // Update the Subject
            upEvent.estado_reunion_sales__c = Constants.EVENT_ESTADO_ENTREVISTA_EXITOSO;
            upEvent.resultado_de_la_reunion_sales__c = Constants.EVENT_RESULTADO_REUNION_EXITOSA;
    
            // Make the update call.
            update upEvent;

        }
        Test.stopTest();
        Quote qte = [SELECT Id FROM Quote WHERE OpportunityId = :opp.Id Limit 1];

        QuoteLineItem qteLI =[Select QuoteId,Quantity FROM QuoteLineItem WHERE QuoteId=:qte.Id Limit 1];
        
        System.assertEquals(13, qteLI.Quantity); 
    }
    /**
      * @description       Tests when an after update event ocurrs in Opportunity with RT Banca and "resultado_de_la_reunion_sales__c" = "Reunion exitosa".
      * @author            fmaturan@everis.com | 27-11-2019   
      * @param            
      * @return            void
      * @throws            NA
    */
    
    @isTest private static void testAfterUpdateOpportunitySuccessRTBanca() { 
        // Test data setup
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        RecordType rt = [Select Id FROM RecordType WHERE DeveloperName=:Constants.RECORDTYPE_BANCA_HIPOTECARIO Limit 1];
        Account acc= New Account(LastName='Test',Rut__c=Rut1,Tipo_de_documento_de_identidad__c = Constants.RUT);
        Insert acc;
        id pbId = Test.getStandardPricebookId();
        Pricebook2 customPB = new Pricebook2(Name=Constants.PRICEBOOK_NAME1, isActive=true);
        insert customPB;
        Product2 prod=new Product2(Name='HIPOTECARIO',codigo_producto_sales__c='99',tipo_producto_sales__c= Constants.RECORDTYPE_BANCA_HIPOTECARIO);
        Insert prod;
        PriceBookEntry pbStd = new PriceBookEntry(UnitPrice=1,Product2Id= prod.Id, Pricebook2Id=pbId, IsActive=true, UseStandardPrice = false);
        insert pbStd;      
		PriceBookEntry pb = new PriceBookEntry(UnitPrice=0,Product2Id= prod.Id, Pricebook2Id=customPB.id, IsActive=true, UseStandardPrice = false);
		insert pb;        
        Opportunity opp = new Opportunity (StageName =Constants.OPPORTUNITY_STAGE_CONTACTO,
                                           Name='test',CloseDate=Date.today(),
                                           AccountId=acc.Id,
                                           RecordTypeId=rt.Id,
                                           OwnerId=usr.Id);
        Insert opp;
        OpportunityLineItem prodOpp = new OpportunityLineItem(Quantity=13,
                                                              OpportunityId=opp.Id,
                                                              PricebookEntryId=pb.Id,
                                                              Product2Id= prod.id,
                                                              UnitPrice=10);
        insert prodOpp;
        // Create an Event
        Test.startTest();
        System.runAs(usr) {
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
            Event evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA,Subject=Constants.EVENT_SUBJECT_AGENDA,
                                  DurationInMinutes=2,ActivityDateTime=myDateTime.addDays(1),WhatId=opp.Id,
                                  recordTypeId = rTypeEvent);
            insert evt;
            
            Event upEvent = [SELECT Id,resultado_de_la_reunion_sales__c,estado_reunion_sales__c FROM Event WHERE Id=: evt.Id LIMIT 1];
         
            // Update the Subject
            upEvent.estado_reunion_sales__c = Constants.EVENT_ESTADO_ENTREVISTA_EXITOSO;
            upEvent.resultado_de_la_reunion_sales__c = Constants.EVENT_RESULTADO_REUNION_EXITOSA;
    
            // Make the update call.
            update upEvent;
        }
        Test.stopTest();
        Quote qte = [SELECT Id FROM Quote WHERE OpportunityId = :opp.Id Limit 1];
        QuoteLineItem qteLI =[Select QuoteId,Quantity FROM QuoteLineItem WHERE QuoteId=:qte.Id Limit 1];
        System.assertEquals(13, qteLI.Quantity); 


    }
     /**
     * @description 
     * @author eayalcor@everis.com | 27-01-2020 
     * @return void 
     **/
     @isTest private static void TestAfterUpdateOpportunitySuccessRTCar() { 
        // Test data setup;
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        RecordType rt = [SELECT Id FROM RecordType WHERE DeveloperName=:Constants.RECORDTYPE_AUTO LIMIT 1];
        Account acc= New Account(LastName='Test',Rut__c=Rut1,Tipo_de_documento_de_identidad__c = Constants.RUT);
        insert acc;
        Id pbId = Test.getStandardPricebookId();
        Pricebook2 customPB = new Pricebook2(Name=Constants.PRICEBOOK_NAME1, isActive=true);
        insert customPB;
        Product2 prod=new Product2(Name='Seguro de vida',codigo_producto_sales__c='99',tipo_producto_sales__c= Constants.RECORDTYPE_AUTO);
        insert prod;
        PriceBookEntry pbStd = new PriceBookEntry(UnitPrice=1,Product2Id= prod.Id, Pricebook2Id=pbId, IsActive=true, UseStandardPrice = false);
        insert pbStd;      
		PriceBookEntry pb = new PriceBookEntry(UnitPrice=0,Product2Id= prod.Id, Pricebook2Id=customPB.id, IsActive=true, UseStandardPrice = false);
		insert pb;        
        Opportunity opp = new Opportunity (StageName =Constants.OPPORTUNITY_STAGE_CONTACTO,
                                           Name='test',CloseDate=Date.today(),
                                           AccountId=acc.Id,
                                           RecordTypeId=rt.Id,
                                           OwnerId=usr.Id);
        Insert opp;
        OpportunityLineItem prodOpp = new OpportunityLineItem(Quantity=13,
                                                              OpportunityId=opp.Id,
                                                              PricebookEntryId=pb.Id,
                                                              Product2Id= prod.id,
                                                              UnitPrice=10);

        System.debug('Oportunidad creada: ' + opp);
        insert prodOpp;
        // Create an Event
        Test.startTest();
        System.runAs(usr) {
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
            Event evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA,Subject=Constants.EVENT_SUBJECT_AGENDA,
                                  DurationInMinutes=2,ActivityDateTime=myDateTime.addDays(1),WhatId=opp.Id,
                                  recordTypeId = rTypeEvent);
            insert evt;

            System.debug('Evento Creado: '+ evt);
            
            Event upEvent = [SELECT Id,resultado_de_la_reunion_sales__c,estado_reunion_sales__c FROM Event WHERE Id=: evt.Id LIMIT 1];
         
            // Update the Subject
            upEvent.estado_reunion_sales__c = Constants.EVENT_ESTADO_ENTREVISTA_EXITOSO;
            upEvent.resultado_de_la_reunion_sales__c = Constants.EVENT_RESULTADO_REUNION_EXITOSA;
    
            // Make the update call.
            update upEvent;

            System.debug('Evento Actualizado: '+ upEvent);
        }
        Test.stopTest();
        Quote qte = [SELECT Id FROM Quote WHERE OpportunityId = :opp.Id Limit 1];
        QuoteLineItem qteLI =[Select QuoteId,Quantity FROM QuoteLineItem WHERE QuoteId=:qte.Id Limit 1];
        System.assertEquals(13, qteLI.Quantity);    
    }
    /**
    * @description 
    * @author eayalcor@everis.com | 27-01-2020 
    * @return void 
    **/
    @isTest private static void TestAfterUpdateOpportunitySuccessRTHome() { 
        // Test data setup;
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        RecordType rt = [SELECT Id FROM RecordType WHERE DeveloperName=:Constants.RECORDTYPE_HOGAR LIMIT 1];
        Account acc= New Account(LastName='Test',Rut__c=Rut1,Tipo_de_documento_de_identidad__c = Constants.RUT);
        insert acc;
        Id pbId = Test.getStandardPricebookId();
        Pricebook2 customPB = new Pricebook2(Name=Constants.PRICEBOOK_NAME1, isActive=true);
        insert customPB;
        Product2 prod=new Product2(Name='Seguro de vida',codigo_producto_sales__c='99',tipo_producto_sales__c= Constants.RECORDTYPE_HOGAR);
        insert prod;
        PriceBookEntry pbStd = new PriceBookEntry(UnitPrice=1,Product2Id= prod.Id, Pricebook2Id=pbId, IsActive=true, UseStandardPrice = false);
        insert pbStd;      
		PriceBookEntry pb = new PriceBookEntry(UnitPrice=0,Product2Id= prod.Id, Pricebook2Id=customPB.id, IsActive=true, UseStandardPrice = false);
		insert pb;        
        Opportunity opp = new Opportunity (StageName =Constants.OPPORTUNITY_STAGE_CONTACTO,
                                           Name='test',CloseDate=Date.today(),
                                           AccountId=acc.Id,
                                           RecordTypeId=rt.Id,
                                           OwnerId=usr.Id);
        Insert opp;
        OpportunityLineItem prodOpp = new OpportunityLineItem(Quantity=13,
                                                              OpportunityId=opp.Id,
                                                              PricebookEntryId=pb.Id,
                                                              Product2Id= prod.id,
                                                              UnitPrice=10);

        System.debug('Oportunidad creada: ' + opp);
        insert prodOpp;
        // Create an Event
        Test.startTest();
        System.runAs(usr) {
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
            Event evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA,Subject=Constants.EVENT_SUBJECT_AGENDA,
                                  DurationInMinutes=2,ActivityDateTime=myDateTime.addDays(1),WhatId=opp.Id,
                                  recordTypeId = rTypeEvent);
            insert evt;

            System.debug('Evento Creado: '+ evt);
            
            Event upEvent = [SELECT Id,resultado_de_la_reunion_sales__c,estado_reunion_sales__c FROM Event WHERE Id=: evt.Id LIMIT 1];
         
            // Update the Subject
            upEvent.estado_reunion_sales__c = Constants.EVENT_ESTADO_ENTREVISTA_EXITOSO;
            upEvent.resultado_de_la_reunion_sales__c = Constants.EVENT_RESULTADO_REUNION_EXITOSA;
    
            // Make the update call.
            update upEvent;

            System.debug('Evento Actualizado: '+ upEvent);
        }
        Test.stopTest();
        Quote qte = [SELECT Id FROM Quote WHERE OpportunityId = :opp.Id Limit 1];
        QuoteLineItem qteLI =[Select QuoteId,Quantity FROM QuoteLineItem WHERE QuoteId=:qte.Id Limit 1];
        System.assertEquals(13, qteLI.Quantity);    
    }
    /**
      * @description       Tests when an after update event ocurrs in Opportunity and "resultado_de_la_reunion_sales__c" = "Volver a Entrevistar". 
      * @author            fmaturan@everis.com | 27-11-2019  
      * @param            
      * @return            void
      * @throws            NA
    */
    
    @isTest private static void TestAfterUpdateNewInerviewOpp() {
        // Test data setup
        RecordType rt = [Select Id FROM RecordType WHERE DeveloperName=:Constants.RECORDTYPE_BANCA_HIPOTECARIO Limit 1];
        Account acc= New Account(LastName='Test',Rut__c=Rut1,Tipo_de_documento_de_identidad__c = Constants.RUT);
        Insert acc;
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        Opportunity opp = new Opportunity (StageName =Constants.OPPORTUNITY_STAGE_CONTACTO,Name='test',CloseDate=Date.today(),AccountId=acc.Id,RecordTypeId=rt.Id,OwnerId=usr.Id);
        Insert opp;
        System.runAs(usr) {
            // Create an Event
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
            Event Evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA,Subject=Constants.EVENT_SUBJECT_ENTREVISTA,fecha_nueva_gestion_sales__c=myDateTime.addDays(1),DurationInMinutes=2,
                                ActivityDateTime=myDateTime.addDays(2),WhatId=opp.Id,resultado_de_la_reunion_sales__c=null,recordTypeId = rTypeEvent);
            insert Evt;
            Event upEvent = [SELECT resultado_de_la_reunion_sales__c,estado_reunion_sales__c FROM Event WHERE Id=: Evt.Id LIMIT 1];
        
            // Update the Subject
            // Update the Subject
            upEvent.estado_reunion_sales__c = Constants.EVENT_ESTADO_ENTREVISTA_NOEXITOSO;
            upEvent.resultado_de_la_reunion_sales__c = Constants.EVENT_RESULTADO_ENTREVISTA_ENTEVISTAR;
            // Make the update call.
            update upEvent;
        
            System.assertEquals(Constants.EVENT_RESULTADO_ENTREVISTA_ENTEVISTAR, upEvent.resultado_de_la_reunion_sales__c);
        }

    }
    /**
      * @description       Tests when an after update event ocurrs in Opportunity and "resultado_de_la_reunion_sales__c" = "Volver a LLamar".
      * @author            fmaturan@everis.com | 27-11-2019   
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest private static void TestAfterUpdateNewCallOpp() {
        // Test data setup
        RecordType rt = [Select Id FROM RecordType WHERE DeveloperName=:Constants.RECORDTYPE_BANCA_HIPOTECARIO Limit 1];
        Account acc= New Account(LastName='Test',Rut__c=Rut1,Tipo_de_documento_de_identidad__c = Constants.RUT);
        Insert acc;
		User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);
        Opportunity opp = new Opportunity (StageName =Constants.OPPORTUNITY_STAGE_CONTACTO,Name='test',CloseDate=Date.today(),AccountId=acc.Id,RecordTypeId=rt.Id,OwnerId=usr.Id);
        Insert opp;
        System.runAs(usr) {
            // Create an Event
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
            Event Evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA,Subject=Constants.EVENT_SUBJECT_ENTREVISTA,DurationInMinutes=2,fecha_nueva_gestion_sales__c=myDateTime.addDays(1),
                                ActivityDateTime=myDateTime.addDays(2),WhatId=opp.Id,resultado_de_la_reunion_sales__c=null, recordTypeId = rTypeEvent);
            insert Evt;
            Event upEvent = [SELECT resultado_de_la_reunion_sales__c FROM Event WHERE Id=: Evt.Id LIMIT 1];
        
            // Update the Subject
            upEvent.estado_reunion_sales__c = Constants.EVENT_ESTADO_ENTREVISTA_NOEXITOSO;
            upEvent.resultado_de_la_reunion_sales__c = Constants.EVENT_RESULTADO_ENTREVISTA_LLAMAR;
            // Make the update call.
            update upEvent;
        
            System.assertEquals(Constants.EVENT_RESULTADO_ENTREVISTA_LLAMAR, upEvent.resultado_de_la_reunion_sales__c);
        }

    }
        @isTest private static void TestAfterUpdateHadEmailLead() { 
        // Test data setup
		User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        Lead lead = [SELECT Id FROM Lead WHERE numero_de_documento_sales__c =: Rut1 LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);
        System.runAs(usr) {
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
            // Create an Event
            Event Evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA,Subject=Constants.EVENT_SUBJECT_AGENDA,
                                DurationInMinutes=2,ActivityDateTime=myDateTime.addDays(1),whoId=lead.Id,
                                enviar_agenda_via_correo_sales__c = false, recordTypeId = rTypeEvent);
            insert Evt;
            
            Event upEvent = [SELECT Subject,estado_reunion_sales__c,resultado_de_la_reunion_sales__c,
                    fecha_nueva_gestion_sales__c,enviar_agenda_via_correo_sales__c FROM Event WHERE Subject=:Constants.EVENT_SUBJECT_AGENDA LIMIT 1];
        
            // Update the Subject
            upEvent.estado_reunion_sales__c = Constants.EVENT_ESTADO_ENTREVISTA_NOEXITOSO;
            upEvent.resultado_de_la_reunion_sales__c = Constants.EVENT_RESULTADO_ENTREVISTA_LLAMAR;
            upEvent.Subject = Constants.EVENT_SUBJECT_ENTREVISTA;
            upEvent.fecha_nueva_gestion_sales__c= myDateTime.addDays(3);
            upEvent.enviar_agenda_via_correo_sales__c = true;  
            // Make the update call. 
            update upEvent;
            
            System.assertEquals('Entrevista', upEvent.Subject);
        }

    }
    @isTest private static void TestAfterInsertDontHaveEmailLead() { 
        // Test data setup
        Lead lead = [SELECT Id FROM Lead WHERE numero_de_documento_sales__c =: Rut1 LIMIT 1];
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);
        System.runAs(usr) {
        // Create an Event
           try{
                Event Evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA,Subject=Constants.EVENT_SUBJECT_AGENDA,
                                      DurationInMinutes=2,ActivityDateTime=myDateTime.addDays(1),whoId=lead.Id,
                                      enviar_agenda_via_correo_sales__c = true);
                insert Evt;
            }catch(Exception e){
                System.assert(e.getMessage().contains(Constants.EVENT_ERROR2));
            } 
         }

    }
    @isTest private static void TestAfterUpdateHadEmailContact() { 
        // Test data setup
        RecordType rt = [Select Id FROM RecordType WHERE DeveloperName='Cliente_Persona_Seguros' Limit 1];
        Account acc= New Account(recordTypeId=rt.Id,LastName='Test',Rut__c=Rut1,Tipo_de_documento_de_identidad__c = Constants.RUT,
                                 PersonEmail='test@test.test');
        Contact con= New Contact(Email= 'test@test.test');
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        Lead lead = [SELECT Id FROM Lead WHERE numero_de_documento_sales__c =: Rut1 LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);
        System.runAs(usr) {
            Insert acc;
            Account acc1 = [SELECT PersonContactId FROM Account WHERE Rut__c=:Rut1 LIMIT 1];
            // Create an Event
            Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
            Event Evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA,Subject=Constants.EVENT_SUBJECT_AGENDA,
                                DurationInMinutes=2,ActivityDateTime=myDateTime.addDays(1),whoId=acc1.PersonContactId,
                                enviar_agenda_via_correo_sales__c = false,flag_convertido_sales__c = true,recordTypeId = rTypeEvent);
            insert Evt;
            
            Event upEvent = [SELECT Subject,resultado_de_la_reunion_sales__c,fecha_nueva_gestion_sales__c,enviar_agenda_via_correo_sales__c 
                        FROM Event WHERE Subject=:Constants.EVENT_SUBJECT_AGENDA LIMIT 1];
        
            // Update the Subject
            upEvent.estado_reunion_sales__c = Constants.EVENT_ESTADO_ENTREVISTA_NOEXITOSO;
            upEvent.Subject = Constants.EVENT_SUBJECT_ENTREVISTA;
            upEvent.resultado_de_la_reunion_sales__c = Constants.EVENT_RESULTADO_ENTREVISTA_ENTEVISTAR;
            upEvent.fecha_nueva_gestion_sales__c= myDateTime.addDays(3);
            upEvent.enviar_agenda_via_correo_sales__c = true;
            // Make the update call.
            update upEvent;
            
            System.assertEquals('Entrevista', upEvent.Subject);
        }

    }
    @isTest private static void TestAfterInsertDontHaveEmailContact() { 
        // Test data setup
        RecordType rt = [Select Id FROM RecordType WHERE DeveloperName='Cliente_Persona_Seguros' Limit 1];
        Account acc= New Account(recordTypeId=rt.Id,LastName='Test',Rut__c=Rut1,Tipo_de_documento_de_identidad__c = Constants.RUT);
        //insert lead;
        User usr = [SELECT Id FROM User WHERE RUT__c =: USERVTPRUT LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=usr.Id,Sales_project__c=true, Validation_rules__c = false);
        System.runAs(usr) {
        insert acc; 
        Account acc1 = [SELECT PersonContactId FROM Account WHERE Rut__c=:Rut1 LIMIT 1];
        System.debug('Cuenta creada: ' + acc1);
        // Create an Event
            try{
                Id rTypeEvent = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_AGENDA LIMIT 1].Id; 
                Event evt = new Event(Type=Constants.EVENT_TYPE_ENTREVISTA,Subject=Constants.EVENT_SUBJECT_AGENDA,
                                      DurationInMinutes=2,ActivityDateTime=myDateTime.addDays(1),whoId=acc1.PersonContactId,
                                      enviar_agenda_via_correo_sales__c = true,flag_convertido_sales__c = true, recordTypeId=rTypeEvent);
                insert evt;   
                System.debug('TIPO DE OBJETO WHOID: ' + String.valueOf(Evt.WhoId.getSobjectType()));     
            }catch(Exception e){
                System.debug('Exception: '+ e);
        		System.assert(e.getMessage().contains(Constants.EVENT_ERROR3));
    		}          
        }

    }
}