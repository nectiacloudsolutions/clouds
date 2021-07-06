/*********************************************************************************************************
@Author       fmaturan@everis.com
@name         cnf_sal_tri_task_Test
@CreateDate   08/10/2019
@Description  Test of the class cnf_sal_tri_task.
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          		Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
08/10/2019		fmaturan@everis.com               initial version
08/10/2019		fmaturan@everis.com               finished the test method TestAfterUpdateShedule
09/10/2019		fmaturan@everis.com               finished the test methods TestAfterUpdateCallBack and TestAfterUpdateNotInterested
10/10/2019		fmaturan@everis.com               finished the test method TestAfterDelete
12/11/2019    	fmaturan@everis.com				  W-000149 - (Gestión del Lead) - Cambio de estados del Candidato
**********************************************************************************************************/
@isTest
private class cnf_sal_tri_task_Test {
    
    	private static final Datetime myDateTime = Datetime.now();
    	private static final String Rut1 = '18469660-6';
        private static final String Rut2 = '8813645-4';
   	
    /**
      * @description       Tests when an after update of a Task ocurrs and "resultado_llamada_sales__c" = "Agendar".  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest static void TestAfterUpdateShedule() {
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        User usr=(User) mapsObjects.get('User2');
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        System.runAs(usr) {
            Task tsk = new Task(Priority='Normal',Status=Constants.TASK_STATUS_COMPLETADA,Subject=Constants.TASK_SUBJECT_CALL,fecha_nueva_gestion_sales__c=myDateTime.addDays(+2), 
                                resultado_llamada_sales__c=Constants.TASK_RESULTADO_AGENDAR);
            
            Test.startTest();
           insert tsk;
            Task tskToUpdate = 
                [SELECT Priority,Status FROM Task WHERE Subject = :Constants.TASK_SUBJECT_CALL LIMIT 1];
            
            tskToUpdate.resultado_llamada_sales__c = Constants.TASK_RESULTADO_AGENDAR;
                      
            update tskToUpdate;
            
            Test.stopTest();
            //Assert that validates if task was updated succesfully with 'resultado_llamada_sales__c' equals 'Agendar'
            System.assertEquals(Constants.TASK_RESULTADO_AGENDAR, tskToUpdate.resultado_llamada_sales__c);
        }
        
    }
    /**
      * @description       Tests when an after update of a Task ocurrs and "resultado_llamada_sales__c" = "Volver a Llamar".  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest static void TestAfterUpdateCallBack() {
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        User usr=(User) mapsObjects.get('User2');
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        System.runAs(usr) {
            Task tsk = new Task(Priority='Normal',Status=Constants.TASK_STATUS_COMPLETADA,Subject=Constants.TASK_SUBJECT_CALL,
                                fecha_nueva_gestion_sales__c=myDateTime.addDays(+2), 
                                resultado_llamada_sales__c=Constants.TASK_RESULTADO_VOLVER_LLAMAR);
            
            insert tsk;
            Task tskToUpdate = [SELECT Priority,Status FROM Task WHERE Subject = :Constants.TASK_SUBJECT_CALL LIMIT 1];
            
            tskToUpdate.resultado_llamada_sales__c = Constants.TASK_RESULTADO_VOLVER_LLAMAR;
                        
            update tskToUpdate;
            //Assert that validates if task was updated succesfully with 'resultado_llamada_sales__c' equals 'Volver a Llamar'
            System.assertEquals(Constants.TASK_RESULTADO_VOLVER_LLAMAR, tskToUpdate.resultado_llamada_sales__c);
        }
        
    }
    /**
      * @description       Tests when an after update of a Task ocurrs and "resultado_llamada_sales__c" = "No le interesa".  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest static void TestAfterUpdateNotInterested() {
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        //User usr=(User) mapsObjects.get('User2');
        User usr = [SELECT Id, Username, UserRoleId 
                      FROM User WHERE (Profile.Name = 'Administrador del sistema' or Profile.Name = 'System administrator') 
                      AND IsActive = true LIMIT 1];
        //Lead lead=(Lead) mapsObjects.get('Lead');
        Lead lead= TestFactorySales.createNewLead(Rut1,Rut2,'Test');
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        System.runAs(usr) {
            Task tsk = new Task(Priority='Normal',Status=Constants.TASK_STATUS_COMPLETADA,Subject=Constants.TASK_SUBJECT_CALL,
                                fecha_nueva_gestion_sales__c=myDateTime.addDays(+2), 
                                resultado_llamada_sales__c=Constants.TASK_RESULTADO_NO_INTERESA,WhoId = lead.Id);
            Test.startTest();
            //upsert lead;
            insert tsk;
            Task tskToUpdate = [SELECT Priority,Status FROM Task  WHERE Subject = :Constants.TASK_SUBJECT_CALL LIMIT 1];
            
            tskToUpdate.resultado_llamada_sales__c = Constants.TASK_RESULTADO_NO_INTERESA;
                        
            update tskToUpdate;
            Test.stopTest();
            //Assert that validates if task was updated succesfully with 'resultado_llamada_sales__c' equals 'No le interesa'
            System.assertEquals(Constants.TASK_RESULTADO_NO_INTERESA, tskToUpdate.resultado_llamada_sales__c);
        }
        
    }
    /**
      * @description       Tests when an after delete of a Task ocurrs.  
      * @param            
      * @return            void
      * @throws            NA
    */   
    @isTest static void TestAfterDelete() {
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        //User usr=(User) mapsObjects.get('User2');
        User usr = [SELECT Id, Username, UserRoleId 
                      FROM User WHERE (Profile.Name = 'Administrador del sistema' or Profile.Name = 'System administrator') 
                      AND IsActive = true LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        Lead lead=(Lead) mapsObjects.get('Lead');
        system.debug('TestAfterDelete------------------------->');
        System.runAs(usr) {
            Task tsk = new Task(Priority='Normal',Status=Constants.TASK_STATUS_COMPLETADA,Subject=Constants.TASK_SUBJECT_CALL,
                                fecha_nueva_gestion_sales__c=myDateTime.addDays(+2), 
                                resultado_llamada_sales__c=Constants.TASK_RESULTADO_NO_INTERESA,WhoId = lead.Id);
            
            insert tsk;
            Test.startTest();
            Database.DeleteResult result = Database.delete(tsk, false);
            Test.stopTest();
            //validates if task was deleted succesfully
            System.assert(result.isSuccess());
                       
        }
        
    }
    /**
      * @description       Tests when an after update task ocurrs with a subject = Llamada.  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest static void testAfterUpdateLeadWithoutRut() { 
        
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        Lead lead=(Lead) mapsObjects.get('Lead2');
        User usr=(User) mapsObjects.get('User2');
        
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
       
        
        System.runAs(usr) {
            Task tsk = new Task(Priority='Normal',Status=Constants.TASK_STATUS_COMPLETADA,
                                Subject= Constants.TASK_SUBJECT_LLAMADA,
                                fecha_nueva_gestion_sales__c=myDateTime.addDays(+2),WhoId = lead.Id);
            insert tsk;
            //Valida que el asunto sea de tipo llamada           
            System.assertEquals(Constants.TASK_SUBJECT_LLAMADA, tsk.Subject);
        }

    }
    
     /**
      * @description       Tests para flujo retencion on before insert.  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest static void TestonBeforeInsert() { 
        
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        Lead lead=(Lead) mapsObjects.get('Lead2');
        User usr = [SELECT Id, Username, UserRoleId 
                      FROM User WHERE (Profile.Name = 'Administrador del sistema' or Profile.Name = 'System administrator') 
                      AND IsActive = true LIMIT 1];
        
        Account acc=(Account) mapsObjects.get('Account');
        
        
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        
        
        // Entitlement entl = new entitlement(name='Test Entilement',accountid=acc.id,type='Gateway Support', StartDate=Date.valueof(System.now().addDays(-2)), EndDate=Date.valueof(System.now().addYears(2)));
        // insert entl;
    
        // String entlId;
        // if (entl != null){
        //     List<SlaProcess> lstEntitlementProcess = [SELECT Id, Name FROM SlaProcess WHERE Name='banco - solicitudes derivadas a consultas y solicitudes v3.27' and IsActive = true LIMIT 1];
        //     if (lstEntitlementProcess.size()>0)
        //     {
        //         entl.SlaProcessId = lstEntitlementProcess[0].id;
        //         update entl;        
        //     }
        //     entlId = entl.Id;
            
        // }
            
         Case case1 = new Case();
                    case1.AccountId=acc.id;
                    case1.Status='Nuevo';
                    // case1.EntitlementId = entl.id;
                    // case1.slaStartDate = system.now();
                    case1.Tipo_Auxiliar__c = 'Solicitud';
                    case1.Tipo_de_producto_banco__c = 'Crédito hipotecario';
                    case1.Motivo_Certificado__c = 'Prepago';
                    case1.Subtipo_Auxiliar__c = 'Liquidación de Prepago';
                    case1.RecordTypeId=[SELECT Id FROM RecordType WHERE developerName='Casos_Banco' LIMIT 1].Id;
                    insert case1;
        
        
       
        
        System.runAs(usr) {
            Task tsk = new Task(Priority='Normal',Status=Constants.TASK_STATUS_ABIERTA,
                                Subject= Constants.TASK_SUBJECT_SEGUNDARETENCION, WhatId = case1.Id );
            insert tsk;
            
                      
            //System.assertEquals(Constants.TASK_SUBJECT_PRIMERARETENCION, tsk.Subject);
        }

    }
    
         /**
      * @description       Tests para flujo retencion on before insert.  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest static void TestonBeforeInsert2() { 
        
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        Lead lead=(Lead) mapsObjects.get('Lead2');
        //User usr=(User) mapsObjects.get('User2');
        User usr = [SELECT Id, Username, UserRoleId 
                      FROM User WHERE (Profile.Name = 'Administrador del sistema' or Profile.Name = 'System administrator') 
                      AND IsActive = true LIMIT 1];
        usr.RUT__c = '171519098';
        
        Account acc2 = new Account();
            acc2.FirstName = 'ACCOUNTRET ';
            acc2.LastName = 'DUMMY SALES2';
            acc2.RUT__c = '18013376-3';
        	acc2.Rut_Ejecutivo_Banco__c = '17151909-8';
            acc2.PersonOtherPhone = '56701719';
            acc2.PersonEmail='Dummy@test.cl';
            acc2.PersonMobilePhone='66666666';
            acc2.Phone = '999999999';
            acc2.OwnerId = usr.Id;
            acc2.recordTypeId=[SELECT Id FROM RecordType WHERE developerName='Cliente_Persona_Seguros' LIMIT 1].Id;
            acc2.Tipo_de_documento_de_identidad__c = 'RUT';
        insert acc2;
        
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        
        // Entitlement entl = new entitlement(name='Test2 Entilement',accountid=acc2.id,type='Gateway Support', StartDate=Date.valueof(System.now().addDays(-2)), EndDate=Date.valueof(System.now().addYears(2)));
        // insert entl;
    
        // String entlId;
        // if (entl != null){
        //     List<SlaProcess> lstEntitlementProcess = [SELECT Id, Name FROM SlaProcess WHERE Name='banco - solicitudes derivadas a consultas y solicitudes v3.27' and IsActive = true LIMIT 1];
        //     if (lstEntitlementProcess.size()>0)
        //     {
        //         entl.SlaProcessId = lstEntitlementProcess[0].id;
        //         update entl;        
        //     }
        //     entlId = entl.Id;
            
        // }
            
        
         Case case1 = new Case();
                    case1.AccountId=acc2.id;
                    case1.Status='Nuevo';
                    // case1.EntitlementId = entl.id;
                    // case1.slaStartDate = system.now();
                    case1.Tipo_Auxiliar__c = 'Solicitud';
                    case1.Tipo_de_producto_banco__c = 'Crédito hipotecario';
                    case1.Motivo_Certificado__c = 'Prepago';
                    case1.Subtipo_Auxiliar__c = 'Liquidación de Prepago';
                    case1.RecordTypeId=[SELECT Id FROM RecordType WHERE developerName='Casos_Banco' LIMIT 1].Id;
                    insert case1;
       
        
        System.runAs(usr) {
            Task tsk = new Task(Priority='Normal',Status=Constants.TASK_STATUS_ABIERTA,
                                Subject= 'tarea vencida', WhatId = case1.Id );
            insert tsk;
            
        }

    }
    
          /**
      * @description       Tests para flujo retencion on before insert.  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest static void TestonAfterUpdate() { 
        
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        Lead lead=(Lead) mapsObjects.get('Lead2');
        //User usr=(User) mapsObjects.get('User2');
        User usr = [SELECT Id, Username, UserRoleId 
                      FROM User WHERE (Profile.Name = 'Administrador del sistema' or Profile.Name = 'System administrator') 
                      AND IsActive = true LIMIT 1];
        
        Account acc2 = new Account();
            acc2.FirstName = 'ACCOUNTRET ';
            acc2.LastName = 'DUMMY SALES2';
            acc2.RUT__c = '18013376-3';
        	acc2.Rut_Ejecutivo_Banco__c = '17151909-8';
            acc2.PersonOtherPhone = '56701719';
            acc2.PersonEmail='Dummy@test.cl';
            acc2.PersonMobilePhone='66666666';
            acc2.Phone = '999999999';
            acc2.OwnerId = usr.Id;
            acc2.recordTypeId=[SELECT Id FROM RecordType WHERE developerName='Cliente_Persona_Seguros' LIMIT 1].Id;
            acc2.Tipo_de_documento_de_identidad__c = 'RUT';
        insert acc2;
        
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        
        // Entitlement entl = new entitlement(name='Test2 Entilement',accountid=acc2.id,type='Gateway Support', StartDate=Date.valueof(System.now().addDays(-2)), EndDate=Date.valueof(System.now().addYears(2)));
        // insert entl;        	
    
        // String entlId;
        // if (entl != null){
        //     List<SlaProcess> lstEntitlementProcess = [SELECT Id, Name FROM SlaProcess WHERE Name='banco - solicitudes derivadas a consultas y solicitudes v3.27' and IsActive = true LIMIT 1];
        //     if (lstEntitlementProcess.size()>0)
        //     {
        //         entl.SlaProcessId = lstEntitlementProcess[0].id;
        //         update entl;        
        //     }
        //     entlId = entl.Id;
            
        // }
        Case case1 = new Case();
                    case1.AccountId=acc2.id;
                    case1.Status='Nuevo';
                    //case1.EntitlementId = entl.id;
                    //case1.slaStartDate = system.now();
                    case1.Tipo_Auxiliar__c = 'Solicitud';
                    case1.Tipo_de_producto_banco__c = 'Crédito hipotecario';
                    case1.Motivo_Certificado__c = 'Prepago';
                    case1.Subtipo_Auxiliar__c = 'Liquidación de Prepago';
                    case1.RecordTypeId=[SELECT Id FROM RecordType WHERE developerName='Casos_Banco' LIMIT 1].Id;
                    insert case1;
        
        			Task tsk = new Task(Priority='Normal',Status=Constants.TASK_STATUS_ABIERTA,
                                Subject= Constants.TASK_SUBJECT_PRIMERARETENCION, WhatId = case1.Id );
            		insert tsk;
        
        			Task tsk2 = new Task(Priority='Normal',Status=Constants.TASK_STATUS_ABIERTA,
                                Subject= Constants.TASK_SUBJECT_SEGUNDARETENCION, WhatId = case1.Id );
            		insert tsk2;
        
        			Task tsk3 = new Task(Priority='Normal',Status=Constants.TASK_STATUS_ABIERTA,
                                Subject= Constants.TASK_SUBJECT_PRIMERARETENCION, WhatId = case1.Id );
            		insert tsk3;
        
        			Task tsk4 = new Task(Priority='Normal',Status=Constants.TASK_STATUS_ABIERTA,
                                Subject= Constants.TASK_SUBJECT_PRIMERARETENCION, WhatId = case1.Id );
            		insert tsk4;
        
        			Task tsk5 = new Task(Priority='Normal',Status=Constants.TASK_STATUS_ABIERTA,
                                Subject= Constants.TASK_SUBJECT_PRIMERARETENCION, WhatId = case1.Id );
            		insert tsk5;
        
        System.runAs(usr) {
            
            tsk.Status = 'Completada';
            tsk.Tipo_Producto__c = 'Crédito de Consumo';
            tsk.Gestion__c = 'Contactado';
            tsk.Resultado_Gesti_n__c = 'Cliente Retenido';
            update tsk;
            /*tsk2.Status = 'Completada';
            tsk2.Tipo_Producto__c = 'Crédito hipotecario';
            update tsk2;*/
            
            tsk3.Status = 'Completada';
            tsk3.Tipo_Producto__c = 'Crédito hipotecario';
            tsk3.Gestion__c = 'Contactado';
            tsk3.Resultado_Gesti_n__c = 'Cliente Retenido';
            update tsk3;
            
            tsk4.Status = 'Completada';
            tsk4.Tipo_Producto__c = 'Crédito hipotecario';
            tsk4.Gestion__c = 'Contactado';
            tsk4.Resultado_Gesti_n__c = 'Cliente no Retenido';
            update tsk4;
            
            tsk5.Status = 'Vencida';
            tsk5.Tipo_Producto__c = 'Crédito hipotecario';
            tsk5.Gestion__c = 'Contactado';
            tsk5.Resultado_Gesti_n__c = 'Cliente no Retenido';
            update tsk5;
            
            
                      
            System.assertEquals(Constants.TASK_SUBJECT_PRIMERARETENCION, tsk.Subject);
            //System.assertEquals(Constants.TASK_SUBJECT_SEGUNDARETENCION, tsk2.Subject);
            System.assertEquals(Constants.TASK_SUBJECT_PRIMERARETENCION, tsk3.Subject);
            System.assertEquals(Constants.TASK_SUBJECT_PRIMERARETENCION, tsk4.Subject);
            System.assertEquals(Constants.TASK_SUBJECT_PRIMERARETENCION, tsk5.Subject);
        }

    }
}