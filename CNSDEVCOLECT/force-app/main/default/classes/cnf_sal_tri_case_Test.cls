@isTest
private class cnf_sal_tri_case_Test { 
    
    @testSetup static void dataload(){
        TestFactorySales.makeCustomSettings();
        Map<String, SObject> mpsObjects = TestFactorySales.populateOrg();
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].Id,Sales_project__c=true, Validation_rules__c = false);
        Account acc = (Account)mpsObjects.get('Account');
        Id idrtaccount = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Cliente_Persona_Seguros').getRecordTypeId();
        acc.RecordTypeId = idrtaccount;
        acc.OwnerId = lstUsr[0].Id;
        update acc;  
        Id rt = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('casos_corporativos').getRecordTypeId();
        Case csToInsert = new Case();
        csToInsert.AccountId = acc.Id;
        csToInsert.Subject = Constants.CASE_SUBJECT_DEFAULT;
        csToInsert.Description = Constants.CASE_DESCRIPTION_AUTORIZA;
        csToInsert.Notificar_Advertencia_SLA__c = false;
        csToInsert.Notificacion_Gestor__c = false;
        csToInsert.Sla_Vencido__c = false;
        csToInsert.Envio_notificacion_sales__c = '';
        csToInsert.Origin = Constants.CASE_CASE_ORIGIN_PRESENCIAL;
        csToInsert.RecordTypeId = rt;
        csToInsert.Type = Constants.CASE_TYPE_SOLICITUD;
        csToInsert.Subtipo__c = Constants.CASE_SUBTIPO_AUTORIZA;
        csToInsert.Status = Constants.CASE_STATUS_NUEVO;
        csToInsert.OwnerId = lstUsr[0].Id;
        csToInsert.Comparte_Datos__c = Constants.CASE_COMPARTEDATOS_SI;
        insert csToInsert;
      
    } 
    
    @isTest
    static void afterInsertTest (){
        
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        List<RecordType> rt = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_CASE_CORPORATIVOS LIMIT 1];
        List<Account> lstAcc = [SELECT Id,Rut__c FROM Account WHERE RUT__C = '10854082-6' LIMIT 1];
        
        System.runAs(lstUsr[0]){  
            Test.startTest();
            List<Case> lstToInsert = new List<Case>();
            Case cIns = new Case();
            cIns.AccountId = lstAcc[0].Id;
            cIns.Rut_del_Cliente__c = lstAcc[0].RUT__c;
            cIns.Subject = Constants.CASE_SUBJECT_DEFAULT;
            cIns.Description = Constants.CASE_DESCRIPTION_AUTORIZA;
            cIns.Origin = Constants.CASE_CASE_ORIGIN_PRESENCIAL;
            cIns.RecordTypeId = rt[0].Id;
            cIns.Type = Constants.CASE_TYPE_SOLICITUD;
            cIns.Subtipo__c = Constants.CASE_SUBTIPO_DESUSCRIPCION;
            cIns.Status = Constants.CASE_STATUS_CERRADO;
            cIns.Sub_estado_Nectia__c = Constants.CASE_SUBESTADONECTIA_SOLUCIONADO;
            cIns.OwnerId = lstUsr[0].Id;
            cIns.Desuscribir_Telefono__c = true;
            
            lstToInsert.add(cIns);
            
            Case cIns2 = new Case();
            cIns2.AccountId = lstAcc[0].Id;
            cIns2.Rut_del_Cliente__c = lstAcc[0].RUT__c;
            cIns2.Subject = Constants.CASE_SUBJECT_DEFAULT;
            cIns2.Description = Constants.CASE_DESCRIPTION_AUTORIZA;
            cIns2.Origin = Constants.CASE_CASE_ORIGIN_PRESENCIAL;
            cIns2.RecordTypeId = rt[0].Id;
            cIns2.Type = Constants.CASE_TYPE_SOLICITUD;
            cIns2.Subtipo__c = Constants.CASE_SUBTIPO_DESUSCRIPCION;
            cIns2.Status = Constants.CASE_STATUS_CERRADO;
            cIns2.Sub_estado_Nectia__c = Constants.CASE_SUBESTADONECTIA_SOLUCIONADO;
            cIns2.OwnerId = lstUsr[0].Id;
            cIns2.Desuscribir_Email__c = true;
            
            lstToInsert.add(cIns2);
            
            insert lstToInsert;
            
            Test.stopTest();
            System.assertNotEquals(cIns2.Id, null);
        }   
        
        
    }
    @isTest
    static void beforeUpdateTest (){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        List<Case> lstCase = [SELECT Id,Notificar_Advertencia_SLA__c FROM Case WHERE OwnerId =: lstUsr[0].Id];
        
        System.runAs(lstUsr[0]){  
            Test.startTest();        
            lstCase[0].Notificar_Advertencia_SLA__c = true;
            update lstCase;
            System.assert(lstCase[0].Notificar_Advertencia_SLA__c);
            Test.stopTest();
        }     
    }
    
    @isTest
    static void beforeUpdateTest2(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        List<Case> lstCase = [SELECT Id,Notificar_Advertencia_SLA__c,SLA_vencido__c,Envio_notificacion_sales__c FROM Case WHERE OwnerId =: lstUsr[0].Id];
        
        System.runAs(lstUsr[0]){  
            Test.startTest();        
            lstCase[0].Notificar_Advertencia_SLA__c = true;
            lstCase[0].SLA_vencido__c = true; 
            lstCase[0].Envio_notificacion_sales__c = Constants.CASE_ENVIO_NOTIFICACION_PROPIETARIO_VENCIMIENTO;
            update lstCase;
            System.assertEquals(lstCase[0].Envio_notificacion_sales__c, Constants.CASE_ENVIO_NOTIFICACION_PROPIETARIO_VENCIMIENTO);
            Test.stopTest();
        }   
    }
    
    @isTest
    static void beforeUpdateTest3(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        List<Case> lstCase = [SELECT Id,Notificar_Advertencia_SLA__c,SLA_vencido__c,Envio_notificacion_sales__c,Notificacion_Gestor__c FROM Case WHERE OwnerId =: lstUsr[0].Id];
        
        System.runAs(lstUsr[0]){  
            Test.startTest();        
            lstCase[0].Notificar_Advertencia_SLA__c = true;
            lstCase[0].SLA_vencido__c = true; 
            lstCase[0].Notificacion_Gestor__c = true;
            lstCase[0].Envio_notificacion_sales__c = Constants.CASE_ENVIO_NOTIFICACION_GESTOR_ADVERTENCIA;
            update lstCase;
            System.assertEquals(lstCase[0].Envio_notificacion_sales__c, Constants.CASE_ENVIO_NOTIFICACION_GESTOR_ADVERTENCIA);
            Test.stopTest();
        }   
    }
    
    @isTest
    static void beforeUpdateTest4(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        List<Case> lstCase = [SELECT Id,Notificar_Advertencia_SLA__c,SLA_vencido__c,Envio_notificacion_sales__c,Notificacion_Gestor__c FROM Case WHERE OwnerId =: lstUsr[0].Id];
        
        System.runAs(lstUsr[0]){  
            Test.startTest();        
            lstCase[0].Notificar_Advertencia_SLA__c = true;
            lstCase[0].SLA_vencido__c = true; 
            lstCase[0].Notificacion_Gestor__c = true;
            lstCase[0].Envio_notificacion_sales__c = Constants.CASE_ENVIO_NOTIFICACION_GESTOR_VENCIMIENTO;
            
            update lstCase;
            
            Test.stopTest();
            system.assertEquals(lstCase[0].Envio_notificacion_sales__c, Constants.CASE_ENVIO_NOTIFICACION_GESTOR_VENCIMIENTO);
        } 
    }
    
    @isTest
    static void beforeUpdateTest5(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 2];
        lstUsr[0].ManagerId = lstUsr[1].Id;
        Update lstUsr;
        List<Case> lstCase = [SELECT Id FROM Case WHERE OwnerId =: lstUsr[0].Id];
        System.runAs(lstUsr[0]){  
            Test.startTest();        
            lstCase[0].Status = Constants.CASE_STATUS_PROCESO;
            lstCase[0].Sub_estado_Nectia__c = Constants.CASE_SUBESTADONECTIA_VALIDACION; 
            update lstCase;    
            Test.stopTest();
            system.assertEquals(lstCase[0].Sub_estado_Nectia__c, Constants.CASE_SUBESTADONECTIA_VALIDACION);
        } 
    }
    
    @isTest
    static void beforeUpdateTest6(){
        Id profileId = [SELECT Id FROM Profile WHERE Name =: Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 2];
        lstUsr[0].ManagerId = lstUsr[1].Id;
        Update lstUsr;
        List<Case> lstCase = [SELECT Id FROM Case WHERE OwnerId =: lstUsr[0].Id];
        System.runAs(lstUsr[0]){  
            Test.startTest();        
            lstCase[0].Status = Constants.CASE_STATUS_CERRADO;
            lstCase[0].Sub_estado_Nectia__c = Constants.CASE_SUBESTADONECTIA_CANCELADO;
            lstCase[0].Desuscribir_Telefono__c = true;
            lstCase[0].RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('casos_corporativos').getRecordTypeId();
            update lstCase;    
            Test.stopTest();
            system.assertEquals(lstCase[0].Sub_estado_Nectia__c, Constants.CASE_SUBESTADONECTIA_CANCELADO);
        } 
    }
    
    
}