/*********************************************************************************************************
@Author       eayalcor@everis.com
@name         TestFactorySales
@CreateDate   04/10/2019
@Description  Factory test ORG Sales Cloud 
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
04/10/2019                    eayalcor@everis.com           Initial Version
06/11/2019					  fbizamam@everis.com			Added the tipo_documento_sales__c field to the createNewLead Method
06/07/2019					  fvasquen@everis.com			Added the createUserWithCompany method
**********************************************************************************************************/
@isTest
public with sharing class TestFactorySales {
    
    /**
* @description       This method populate Org Data
* @return            Response Map<String,SObject>
* @throws            NA
*/
    static Map<String, SObject> mapsOppObjects = new Map<String, SObject>();
    
    public static Map<String, SObject> populateOrg(){
        
        Map<String, SObject> mapsObjects = new Map<String, SObject>();
        
        User admin = [SELECT Id, Username, UserRoleId 
                      FROM User WHERE (Profile.Name = 'Administrador del sistema' or Profile.Name = 'System administrator') 
                      AND IsActive = true LIMIT 1];
        
        System.runAs(admin){
            //Carga CS
            insert new ProfileInjectionLead__c(Name='EjecutivoVenta', ProfileName__c='Ejecutivo de Venta');

            insert new DocuwareMetadata__c(Name='INDEX01',Index_Label__c='CLIENTE',
                        Index_value__c='0',Type_Index_List__c = Constants.XML_INDICES);
            
            insert new DocuwareMetadata__c(Name='INDEX02',Index_Label__c='PROCESO_DE_NEGOCIO',
                        Index_value__c='0',Type_Index_List__c = Constants.XML_INDICES);
            
            insert new DocuwareMetadata__c(Name='INDEX03',Index_Label__c='TIPO_DE_DOCUMENTO',
                        Index_value__c='0',Type_Index_List__c = Constants.XML_INDICES);
            
            insert new DocuwareMetadata__c(Name='INDEX04',Index_Label__c='ID_PROCESO',
                        Index_value__c='0',Type_Index_List__c = Constants.XML_INDICES);

            insert new DocuwareMetadata__c(Name='INDEX05',Index_Label__c='DWDOCID',
                        Index_value__c='0',Type_Index_List__c = Constants.XML_FILTROS);

            //Create user
            User u2 = new User();
            u2.firstName = 'Ejecutivo 2';
            u2.LastName = 'Sales2';
            u2.RUT__c = '88136454';
            u2.Email = 'ejecutivo2@consorcio.cl';
            u2.CompanyName = 'Consorcio Seguros';
            u2.Department = 'Adm. Funcional CRM';
            u2.Alias =  'test2';                    
            u2.UserName =  'ejecutivo2@consorcio.cl.devsales';            
            u2.CommunityNickname =  'ejecutivo2@consorcio.cl.devsales';
            u2.LocaleSidKey = 'es_CL';
            u2.EmailEncodingKey = 'ISO-8859-1';            
            u2.LanguageLocaleKey = 'en_US';
            u2.TimeZoneSidKey = 'America/Santiago';
            u2.isActive = true;
            u2.ProfileID = [SELECT Id,Name FROM Profile WHERE Name='Ejecutivo de Venta' LIMIT 1].Id;
            insert u2;
            mapsObjects.put('User2', u2); 
            
            //Create user
            User u = new User();
            u.firstName = 'Ejecutivo';
            u.LastName = 'Sales';
            u.RUT__c = '19';
            u.Email = 'ejecutivo@consorcio.cl';
            u.CompanyName = 'Consorcio Seguros';
            u.Department = 'Adm. Funcional CRM';
            u.Alias =  'test';                    
            u.UserName =  'ejecutivotest@consorcio.cl.devsales';            
            u.CommunityNickname =  'ejecutivotest@consorcio.cl.devsales';
            u.LocaleSidKey = 'es_CL';
            u.EmailEncodingKey = 'ISO-8859-1';            
            u.LanguageLocaleKey = 'en_US';
            u.TimeZoneSidKey = 'America/Santiago';
            u.isActive = true;
            u.ManagerId=u2.Id;
            u.ProfileID = [SELECT Id FROM Profile WHERE Name='Ejecutivo de Venta' LIMIT 1].Id;
            insert u;
            mapsObjects.put('User', u); 
            

            
            //Create user With the 'Ejecutivo Especialista' Profile
            User u3 = new User();
            u3.firstName = 'Ejecutivo 3';
            u3.LastName = 'Sales3';
            u3.RUT__c = '12654966';
            u3.Email = 'ejecutivo2@consorcio.cl';
            u3.CompanyName = 'Consorcio Seguros';
            u3.Department = 'Adm. Funcional CRM';
            u3.Alias =  'test';                    
            u3.UserName =  'ejecutivo3@consorcio.cl.devsales';            
            u3.CommunityNickname =  'ejecutivo3@consorcio.cl.devsales';
            u3.LocaleSidKey = 'es_CL';
            u3.EmailEncodingKey = 'ISO-8859-1';            
            u3.LanguageLocaleKey = 'en_US';
            u3.TimeZoneSidKey = 'America/Santiago';
            u3.isActive = true;
            u3.ProfileID = [SELECT Id FROM Profile WHERE Name='Ejecutivo Especialista' LIMIT 1].Id;
            insert u3;
            mapsObjects.put('User3', u3); 
            
            //Create user With the 'Ejecutivo de Riesgo' Profile
            User u4 = new User();
            u4.firstName = 'Ejecutivo 4';
            u4.LastName = 'Sales4';
            u4.RUT__c = '9188703-7';
            u4.Email = 'ejecutivo2@consorcio.cl';
            u4.CompanyName = 'Consorcio Banco';
            u4.Alias = 'test';
            u4.UserName = 'ejecutivo4@consorcio.cl.devsales';
            u4.CommunityNickname =  'ejecutivo4@consorcio.cl.devsales';
            u4.LocaleSidKey = 'es_CL';
            u4.EmailEncodingKey = 'ISO-8859-1';            
            u4.LanguageLocaleKey = 'en_US';
            u4.TimeZoneSidKey = 'America/Santiago';
            u4.isActive = true;
            u4.ProfileID = [SELECT Id FROM Profile WHERE Name='Ejecutivo de Riesgo' LIMIT 1].Id;
            insert u4;
            mapsObjects.put('User4', u4);
            
            //Create user With the 'Ejecutivo de Visado' Profile
            User u5 = new User();
            u5.firstName = 'Ejecutivo 5';
            u5.LastName = 'Sales5';
            u5.RUT__c = '9267710-9';
            u5.Email = 'ejecutivo2@consorcio.cl';
            u5.CompanyName = 'Consorcio Banco';
            u5.Alias = 'test';
            u5.UserName = 'ejecutivo5@consorcio.cl.devsales';
            u5.CommunityNickname =  'ejecutivo5@consorcio.cl.devsales';
            u5.LocaleSidKey = 'es_CL';
            u5.EmailEncodingKey = 'ISO-8859-1';            
            u5.LanguageLocaleKey = 'en_US';
            u5.TimeZoneSidKey = 'America/Santiago';
            u5.isActive = true;
            u5.ProfileID = [SELECT Id FROM Profile WHERE Name='Ejecutivo de Visado' LIMIT 1].Id;
            insert u5;
            mapsObjects.put('User5', u5);
            
            
            
            //Create user With the 'Jefe de Ventas' Profile
            User u6 = new User();
            u6.firstName = 'Ejecutivo 6';
            u6.LastName = 'Sales6';
            u6.RUT__c = '9212438-k';
            u6.Email = 'ejecutivo2@consorcio.cl';
            u6.CompanyName = 'Consorcio Banco';
            u6.Alias = 'test';
            u6.UserName = 'ejecutivo6@consorcio.cl.devsales';
            u6.CommunityNickname =  'ejecutivo6@consorcio.cl.devsales';
            u6.LocaleSidKey = 'es_CL';
            u6.EmailEncodingKey = 'ISO-8859-1';            
            u6.LanguageLocaleKey = 'en_US';
            u6.TimeZoneSidKey = 'America/Santiago';
            u6.isActive = true;
            u6.ProfileID = [SELECT Id FROM Profile WHERE Name='Jefe de Ventas' LIMIT 1].Id;
            insert u6;
            mapsObjects.put('User6', u6);
            
                        //Create user
            User u7 = new User();
            u7.firstName = 'Analitycs';
            u7.LastName = 'Sales2';
            u7.RUT__c = '88136456';
            u7.Email = 'Analitycs@consorcio.cl';
            u7.CompanyName = 'Consorcio Seguros';
            u7.Department = 'Adm. Funcional CRM';
            u7.Alias =  'Anali';                    
            u7.UserName =  'Analitycs@consorcio.cl.devsales';            
            u7.CommunityNickname =  'Analitycs@consorcio.cl.devsales';
            u7.LocaleSidKey = 'es_CL';
            u7.EmailEncodingKey = 'ISO-8859-1';            
            u7.LanguageLocaleKey = 'en_US';
            u7.TimeZoneSidKey = 'America/Santiago';
            u7.isActive = true;
            u7.ProfileID = [SELECT Id FROM Profile WHERE Name='Integraciones' LIMIT 1].Id;
            insert u7;
            mapsObjects.put('User7', u7); 
            
            //Create user With the 'Ejecutivos de Atención al Cliente Seguros Comercial' Profile
            User u8 = new User();
            u8.firstName = 'Ejecutivo 8';
            u8.LastName = 'Sales8';
            u8.RUT__c = '8890162-2';
            u8.Email = 'ejecutivo8@consorcio.cl';
            u8.CompanyName = 'Consorcio Banco';
            u8.Alias = 'test';
            u8.UserName = 'ejecutivo8@consorcio.cl.devsales';
            u8.CommunityNickname =  'ejecutivo8@consorcio.cl.devsales';
            u8.LocaleSidKey = 'es_CL';
            u8.EmailEncodingKey = 'ISO-8859-1';            
            u8.LanguageLocaleKey = 'en_US';
            u8.TimeZoneSidKey = 'America/Santiago';
            u8.isActive = true;
            u8.ProfileID = [SELECT Id FROM Profile WHERE Name='Ejecutivos de Atención al Cliente Seguros Comercial' LIMIT 1].Id;
            insert u8;
            mapsObjects.put('User8', u8);
            
            //Create a new Account
            Account acc = new Account();
            acc.FirstName = 'ACCOUNT ';
            acc.LastName = 'DUMMY SALES';
            acc.RUT__c = '10854082-6';
            acc.PersonOtherPhone = '56701719';
            acc.PersonEmail='Dummy@test.cl';
            acc.PersonMobilePhone='66666666';
            acc.Phone = '999999999';
            acc.OwnerId = u.Id;
            acc.recordTypeId=[SELECT Id FROM RecordType WHERE developerName='Cliente_Persona_Seguros' LIMIT 1].Id;
            acc.Tipo_de_documento_de_identidad__c = 'RUT';
            insert acc;
            mapsObjects.put('Account', acc);
            
            //Create a new Account
            Account acc1 = new Account();
            acc1.FirstName = 'ACCOUNT1 ';
            acc1.LastName = 'DUMMY SALES';
            acc1.RUT__c = '19375874-6';
            acc1.PersonOtherPhone = '95671734';
            acc.PersonEmail='Dummy@test.cl';
            acc.PersonMobilePhone='66666666';
            acc.Phone = '999999999';
            acc1.OwnerId = u.Id;
            acc1.Tipo_de_documento_de_identidad__c = 'RUT';
            insert acc1;
            mapsObjects.put('Account1', acc1);
            
            //Create a new Lead
            Lead newLead = new Lead();
            newLead.FirstName = 'sample';
            newLead.LastName = 'Factory';
            newLead.motherlastname_sales__c = '';
            newLead.rut_ejecutivo_sales__c = '1-9';
            newLead.numero_de_documento_sales__c = '9669258-7';
            newLead.tipo_documento_sales__c = Constants.RUT;
            newLead.Phone = '';
            newLead.other_phone_sales__c = '';
            newLead.Email = 'test@test.cl';
            newLead.nuevo_correo_sales__c = '';
            newLead.LeadSource = '';
            newLead.genero_sales__c = '';
            newLead.calle_sales__c = '';
            newLead.numero_sales__c = '';
            newLead.numero_de_piso_sales__c = '';
            newLead.numero_departamento_sales__c = '';
            newLead.comuna_sales__c = '';
            newLead.villa_sales__c = '';
            newLead.region_sales__c = '';
            newLead.sla_sales__c = null;
            newLead.fecha_nacimiento_sales__c = null;
            newLead.Rating = 'Alta';
            newLead.OwnerId = u.Id;
            newLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('sales_lead_personas').getRecordTypeId();
            insert newLead;
            mapsObjects.put('Lead', newLead);
            
            //Create a new Lead
            Lead emptyRutLead = new Lead();
            emptyRutLead.FirstName = 'sample';
            emptyRutLead.LastName = 'Factory';
            emptyRutLead.motherlastname_sales__c = '';
            emptyRutLead.rut_ejecutivo_sales__c = '1-9';
            emptyRutLead.numero_de_documento_sales__c = '20690798-3';
            emptyRutLead.Phone = '';
            emptyRutLead.other_phone_sales__c = '';
            emptyRutLead.Email = 'test@test.cl';
            emptyRutLead.nuevo_correo_sales__c = '';
            emptyRutLead.LeadSource = '';
            emptyRutLead.genero_sales__c = '';
            emptyRutLead.calle_sales__c = '';
            emptyRutLead.numero_sales__c = '';
            emptyRutLead.numero_de_piso_sales__c = '';
            emptyRutLead.numero_departamento_sales__c = '';
            emptyRutLead.comuna_sales__c = '';
            emptyRutLead.villa_sales__c = '';
            newLead.region_sales__c = '';
            emptyRutLead.sla_sales__c = null;
            emptyRutLead.fecha_nacimiento_sales__c = null;
            emptyRutLead.Rating = 'Alta';
            emptyRutLead.OwnerId = u2.Id;
            emptyRutLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('sales_lead_personas').getRecordTypeId();
            insert emptyRutLead;
            mapsObjects.put('Lead2', emptyRutLead);
            
            
            Opportunity opp = new Opportunity();
            opp.CloseDate=date.today();
            opp.AccountId = acc.id;
            opp.Flag_Banca_Nueva_Oportunidad_sales__c=true;
            opp.Name='test opp 1';
            opp.StageName='Contacto';
            opp.OwnerId=u2.id;
            insert opp;
            mapsObjects.put('Opp1', opp);
            
            Opportunity opp2 = new Opportunity();
            opp2.CloseDate=date.today();
            opp2.AccountId = acc1.id;
            opp2.Name='test opp 2';
            opp2.Flag_Banca_Nueva_Oportunidad_sales__c=true;
            opp2.StageName='Contacto';
            opp2.OwnerId=u2.id;
            insert opp2;
            mapsObjects.put('Opp2', opp2);
            
            Opportunity opp3 = new Opportunity();
            opp3.CloseDate=date.today();
            opp3.AccountId = acc1.id;
            opp3.Name='test opp 3';
            opp3.StageName='Contacto';
            opp3.OwnerId=u2.id;
            insert opp3;
            mapsObjects.put('Opp3', opp3);
            
            
            //Create a new Product2
            Product2 p2 = new Product2();
            p2.IsActive = true;
            p2.ProductCode = '801';
            p2.Name = 'Test';
            p2.codigo_producto_sales__c= '2';
            p2.Codigo_Macroproducto_Operacional_sales__c='1';
            p2.tipo_producto_sales__c = 'Sales_Opp_Seguro_Vida';
            p2.Plazo_estimado_cierre__c= 120;
            insert p2;
            mapsOppObjects.put('Product2', p2);
            
            //Create a new Standard Product2
            Product2 p3 = new Product2();
            p3.IsActive = true;
            p3.ProductCode = '2';
            p3.Name = 'TestStandard';
            p3.codigo_producto_sales__c= '2';
            p3.Codigo_Macroproducto_Operacional_sales__c='1';
            p3.tipo_producto_sales__c = 'Sales_Opp_Seguro_Vida_Standard';
            p3.Plazo_estimado_cierre__c=120;
            insert p3;
            mapsOppObjects.put('Product2Standard', p3);
            
            //Create a new Pricebook
            Pricebook2 pr2 = new Pricebook2();
            pr2.IsActive = true;
            pr2.Name = 'test';
            insert pr2;
            mapsOppObjects.put('Pricebook2', pr2);
            
            //Create a new Standard Pricebook Entry
            PricebookEntry standardPBE = new PricebookEntry();
            standardPBE.Pricebook2Id = Test.getStandardPricebookId();
            standardPBE.Product2Id = p2.Id;
            standardPBE.UnitPrice = 1;
            standardPBE.IsActive = true;
            standardPBE.useStandardPrice=false;
            insert standardPBE;
            
            //Create a new Pricebook Entry
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = pr2.Id;
            pbe.Product2Id = p2.Id;
            pbe.UnitPrice = 1;
            pbe.IsActive = true;
            insert pbe;
            mapsOppObjects.put('PricebookEntry', pbe);
            
            Opportunity opp4 = new Opportunity();
            opp4.CloseDate=date.today();
            opp4.AccountId = acc1.id;
            opp4.Name='test opp 4';
            opp4.StageName='Contacto';
            opp4.OwnerId=u3.id;
            opp4.Pricebook2Id=Test.getStandardPricebookId();
            insert opp4;
            mapsObjects.put('Opp4', opp4);
            
            Opportunity opp5 = new Opportunity();
            opp5.CloseDate=date.today();
            opp5.AccountId = acc1.id;
            opp5.Name='test opp 5';
            opp5.StageName='Contacto';
            opp5.OwnerId=u3.id;
            opp5.Pricebook2Id=Test.getStandardPricebookId();
            insert opp5;
            mapsObjects.put('Opp5', opp5);
            
            OpportunityLineItem itemTmp = new OpportunityLineItem();
            itemTmp.OpportunityId = opp4.Id;
            itemTmp.PricebookEntryId = standardPBE.id ;
            itemTmp.Product2Id = p2.id ;
            itemTmp.Quantity = 1;
            itemTmp.UnitPrice = 1;
            insert itemTmp;
            mapsObjects.put('itemTmp', itemTmp);
            
            Opportunity opp6 = new Opportunity();
            opp6.CloseDate=date.today();
            opp6.AccountId = acc1.id;
            opp6.Name='test opp 5';
            opp6.StageName='Contacto';
            opp6.OwnerId=u5.id;
            insert opp6;
            mapsObjects.put('Opp6', opp6);
            
            Opportunity opp7 = new Opportunity();
            opp7.CloseDate=date.today();
            opp7.AccountId = acc1.id;
            opp7.Name='test opp 7';
            opp7.StageName='Contacto';
            opp7.OwnerId=u2.id;
            opp7.ejecutivo_riesgo_sales__c = u4.Id;
            insert opp7;
            mapsObjects.put('Opp7', opp7);
            
            Case case1 = new Case();
            case1.AccountId=acc1.id;
            case1.Status='Nuevo';
            case1.RecordTypeId=[SELECT Id FROM RecordType WHERE developerName='casos_corporativos' LIMIT 1].Id;
            case1.instituci_n_financiera__c = 'Bci';
            insert case1;
            mapsObjects.put('Case1', case1);
            
            Case case2 = new Case();
            case2.AccountId=acc1.id;
            case2.Status='Nuevo';
            case2.id_alfresco_caso_sales__c='workspace://SpacesStore/d7f6a362-8015-4df0-a0ca-f96c60d27b63';
        	case2.id_docuware_sales__c='56653';
            case2.Fecha_Documento__c=datetime.now();
            case2.RecordTypeId=[SELECT Id FROM RecordType WHERE developerName='casos_corporativos' LIMIT 1].Id;
            insert case2;
            mapsObjects.put('Case2', case2);

        }
        
        return mapsObjects;
    }
    
    /**
* @description       This method create a New Lead
* @return            Response Lead
* @throws            NA
*/
    public static Lead createNewLead(String rutLead,String rutExecutive,String name){
        Lead newLead = new Lead();
        newLead.FirstName = name + 'FirstName';
        newLead.LastName =  name + 'LastName';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = rutExecutive;
        newLead.numero_de_documento_sales__c = rutLead;
        newLead.Email = 'test@test.cl';
        newLead.tipo_documento_sales__c = CONSTANTS.RUT;
        newLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('sales_lead_personas').getRecordTypeId();
        insert newLead;
        
        return newLead;
    }
    /**
* @description       This method create a New Lead
* @return            Response Lead
* @throws            NA
*/
    public static Lead createNewLeadwithSLA(String rutLead,String rutExecutive,String name){
        Lead newLead = new Lead();
        newLead.FirstName = name + 'FirstName';
        newLead.LastName =  name + 'LastName';
        newLead.rut_ejecutivo_sales__c = rutExecutive;
        newLead.numero_de_documento_sales__c = rutLead;
        newLead.Email = 'test@test.cl';
        newLead.LeadSource = 'Analytics';
        newLead.origen_analytics_sales__c = true;
        newLead.sla_sales__c = Datetime.now().AddDays(-2);
        newLead.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('sales_lead_personas').getRecordTypeId();
        newLead.status = CONSTANTS.LEAD_STATUS_CREADO;
        return newLead;
    }
    
    /**
* @description       This method creates a New Account
* @return            Response Account
* @throws            NA
*/
    
    public static Account createNewAccount(String rutAccount, String lastName){
        final Account account = new Account();
        account.FirstName = 'ACCOUNT ';
        account.LastName = lastName;
        account.RUT__c = rutAccount;
        account.PersonOtherPhone = '56701719';
        account.Tipo_de_documento_de_identidad__c = CONSTANTS.RUT;
        account.PersonEmail = 'email@test.net';
        account.Phone = '123456789';
        account.Calle_Nectia__c = 'Calle';
        account.Numero_Nectia__c = 'Numero';
        account.Region_Nectia__c = 'CL-AR';
        account.Comuna_Nectia__c = '9101';
        account.PersonMobilePhone = '123456789';
        insert account;
        
        return account;
    }
    
    /**
* @description       This method creates a New Account with Owner
* @return            Response Account
* @throws            NA
*/
    
    public static Account createNewAccountWithOwner(String rutAccount, String lastName,id owner ){
        final Account account = new Account();
        account.FirstName = 'ACCOUNT ';
        account.LastName = lastName;
        account.RUT__c = rutAccount;
        account.PersonOtherPhone = '56701719';
        account.Tipo_de_documento_de_identidad__c = CONSTANTS.RUT;
        account.PersonEmail = 'email@test.net';
        account.Phone = '123456789';
        account.Calle_Nectia__c = 'Calle';
        account.Numero_Nectia__c = 'Numero';
        account.Region_Nectia__c = 'CL-AR';
        account.Comuna_Nectia__c = '9101';
        account.PersonMobilePhone = '123456789';
        account.OwnerId =owner;
        insert account;
        
        return account;
    }    
    /**
* @description       This method creates a New Account
* @return            Response Account
* @throws            NA
*/
    public static Event createEvent(String idLead, String tipo, String estado, String resultado){
        Map<String, Id> mapRTEvt = new Map<String, Id>();
        
        for (RecordType rt : [SELECT Id, DeveloperName, SobjectType  FROM RecordType WHERE SobjectType =: Constants.Event]) {
            mapRTEvt.put (rt.DeveloperName,rt.Id);
        }
        
        if(tipo == Constants.EVENT_TYPE_LLAMADA){
            Event objEvent = new Event();
            objEvent.IsReminderSet = true;
            objEvent.fecha_nueva_gestion_sales__c = Datetime.now().addDays(1);
            objEvent.ActivityDateTime= Datetime.now();
            objEvent.Type = Constants.EVENT_TYPE_LLAMADA; 
            objEvent.Subject = 'Test';
            objEvent.WhoId = idLead;
            objEvent.estado_llamada_sales__c = estado;
            objEvent.resultado_llamada_sales__c = resultado;
            objEvent.DurationInMinutes = 60;
            objEvent.RecordTypeId =mapRTEvt.get(Constants.RECORDTYPE_EVENT_LLAMADA);
            return objEvent;   
        }else if(tipo == Constants.EVENT_TYPE_ENTREVISTA){
            Event objEvent = new Event();
            objEvent.IsReminderSet = true;
            objEvent.ActivityDate=Date.today();
            objEvent.fecha_nueva_gestion_sales__c = Datetime.now().addDays(1);
            objEvent.Type = Constants.EVENT_TYPE_ENTREVISTA;
            objEvent.Subject = 'Test';
            objEvent.WhoId = idLead;
            objEvent.estado_reunion_sales__c = estado;
            objEvent.resultado_de_la_reunion_sales__c = resultado;
            objEvent.ReminderDateTime = Datetime.now().addDays(1);
            objEvent.DurationInMinutes = 60;
            objEvent.ActivityDateTime= Datetime.now();
            objEvent.StartDateTime= Datetime.now();
            objEvent.RecordTypeId =mapRTEvt.get(Constants.RECORDTYPE_EVENT_AGENDA);
            return objEvent;  
        }   
        return null;
    }
    
    /**
* @description       This method create a New Lead
* @return            Response Lead
* @throws            NA
*/
    public static User createUser(String rutUser,String profile,String alias){
        
        //Create user
        User u = new User();
        u.firstName = 'Ejecutivo';
        u.LastName = 'Sales';
        u.RUT__c = rutUser;
        u.Email = 'ejecutivo@consorcio.cl';
        u.CompanyName = 'Consorcio Seguros';
        u.Department = 'Adm. Funcional CRM';
        u.Alias = alias;                    
        u.UserName =  alias+'ejecutivo@consorcio.cl.devsales';  
        u.LocaleSidKey = 'es_CL';
        u.EmailEncodingKey = 'ISO-8859-1';            
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'America/Santiago';
        u.isActive = true;
        u.ProfileID = [SELECT Id FROM Profile WHERE Name=:profile limit 1].Id;
        return u;
    }
    
    public static User createUserWithCompany(String rutUser,String profile,String alias, String company){
        User u = new User();
        switch on company{
            when 'Consorcio Banco'{
                u.firstName = 'Ejecutivo';
                u.LastName = 'Sales';
                u.RUT__c = rutUser;
                u.Email = 'ejecutivo@consorcio.cl';
                u.CompanyName = 'Consorcio Banco';
                u.Department = 'Adm. Funcional CRM';
                u.Alias = alias;                    
                u.UserName =  alias+'ejecutivo@consorcio.cl.devsales';  
                u.LocaleSidKey = 'es_CL';
                u.EmailEncodingKey = 'ISO-8859-1';            
                u.LanguageLocaleKey = 'en_US';
                u.TimeZoneSidKey = 'America/Santiago';
                u.isActive = true;
                u.ProfileID = [SELECT Id FROM Profile WHERE (Name =:profile) OR (Name =:profile) limit 1].Id;
            }
            when 'Consorcio Corredora de Bolsa'{
                u.firstName = 'Ejecutivo';
                u.LastName = 'Sales';
                u.RUT__c = rutUser;
                u.Email = 'ejecutivo@consorcio.cl';
                u.CompanyName = 'Consorcio Corredora de Bolsa';
                u.Department = 'Adm. Funcional CRM';
                u.Alias = alias;                    
                u.UserName =  alias+'ejecutivo@consorcio.cl.devsales';  
                u.LocaleSidKey = 'es_CL';
                u.EmailEncodingKey = 'ISO-8859-1';            
                u.LanguageLocaleKey = 'en_US';
                u.TimeZoneSidKey = 'America/Santiago';
                u.isActive = true;
                u.ProfileID = [SELECT Id FROM Profile WHERE (Name =:profile) OR (Name =:profile) limit 1].Id;
            }
            when 'Consorcio Seguros'{
                u.firstName = 'Ejecutivo';
                u.LastName = 'Sales';
                u.RUT__c = rutUser;
                u.Email = 'ejecutivo@consorcio.cl';
                u.CompanyName = 'Consorcio Seguros';
                u.Department = 'Adm. Funcional CRM';
                u.Alias = alias;                    
                u.UserName =  alias+'ejecutivo@consorcio.cl.devsales';  
                u.LocaleSidKey = 'es_CL';
                u.EmailEncodingKey = 'ISO-8859-1';            
                u.LanguageLocaleKey = 'en_US';
                u.TimeZoneSidKey = 'America/Santiago';
                u.isActive = true;
                u.ProfileID = [SELECT Id FROM Profile WHERE (Name =:profile) OR (Name =:profile) limit 1].Id;
            }
            when 'Consorcio Servicios'{
                u.firstName = 'Ejecutivo';
                u.LastName = 'Sales';
                u.RUT__c = rutUser;
                u.Email = 'ejecutivo@consorcio.cl';
                u.CompanyName = 'Consorcio Servicios';
                u.Department = 'Adm. Funcional CRM';
                u.Alias = alias;                    
                u.UserName =  alias+'ejecutivo@consorcio.cl.devsales';  
                u.LocaleSidKey = 'es_CL';
                u.EmailEncodingKey = 'ISO-8859-1';            
                u.LanguageLocaleKey = 'en_US';
                u.TimeZoneSidKey = 'America/Santiago';
                u.isActive = true;
                u.ProfileID = [SELECT Id FROM Profile WHERE (Name =:profile) OR (Name =:profile) limit 1].Id;
            }
        }
        insert u;
        return u;
    }
    
    public static Map<String, SObject> createOpportunityWithProduct(Id idProduct2, Id idAcc, Id usrId){
        
        User runUser = [SELECT Id, Username, UserRoleId 
                        FROM User WHERE Id =: usrId 
                        AND IsActive = true LIMIT 1];
        
        System.runAs(runUser){
            
            //Create a new Product2
            Product2 p2 = new Product2();
            p2.IsActive = true;
            p2.ProductCode = '801';
            p2.Name = 'Test';
            p2.codigo_producto_sales__c= '2';
            p2.Codigo_Macroproducto_Operacional_sales__c='1';
            p2.tipo_producto_sales__c = 'Sales_Opp_Seguro_Vida';
            p2.Plazo_estimado_cierre__c= 120;
            insert p2;
            mapsOppObjects.put('Product2', p2);
            
            //Create a new Standard Product2
            Product2 p3 = new Product2();
            p3.IsActive = true;
            p3.ProductCode = '2';
            p3.Name = 'TestStandard';
            p3.codigo_producto_sales__c= '2';
            p3.Codigo_Macroproducto_Operacional_sales__c='1';
            p3.tipo_producto_sales__c = 'Sales_Opp_Seguro_Vida_Standard';
            p3.Plazo_estimado_cierre__c= 120;
            insert p3;
            mapsOppObjects.put('Product2Standard', p3);
            
            //Create a new Pricebook
            Pricebook2 pr2 = new Pricebook2();
            pr2.IsActive = true;
            pr2.Name = 'test';
            insert pr2;
            mapsOppObjects.put('Pricebook2', pr2);
            
            //Create a new Standard Pricebook Entry
            PricebookEntry standardPBE = new PricebookEntry();
            standardPBE.Pricebook2Id = idProduct2;
            standardPBE.Product2Id = p2.Id;
            standardPBE.UnitPrice = 1;
            standardPBE.IsActive = true;
            insert standardPBE;
            
            //Create a new Pricebook Entry
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = pr2.Id;
            pbe.Product2Id = p2.Id;
            pbe.UnitPrice = 1;
            pbe.IsActive = true;
            insert pbe;
            mapsOppObjects.put('PricebookEntry', pbe);
            
            system.debug('ID RECORDTYPE: '+[SELECT Id FROM RecordType WHERE sObjectType =:Constants.OPPORTUNITY AND DeveloperName =: Constants.RECORDTYPE_SEGURO_VIDA LIMIT 1].Id);
            system.debug('ID PRICEBOOK: '+pr2.Id);
            system.debug('USER RUN: '+runUser.Id);
            system.debug('ID ACCOUNT: '+idAcc);
            
            //Create a new Opportunity
            Opportunity opp = new Opportunity();
            opp.AccountId = idAcc;
            opp.Name = 'Test';
           opp.StageName = 'Contacto';
            opp.CloseDate = Date.today();
            opp.Pricebook2Id = pr2.Id;
            opp.OwnerId = runUser.Id;
            opp.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType =:Constants.OPPORTUNITY AND DeveloperName =: Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO LIMIT 1].Id;
            //opp.Motivo_otro_sales__c = 'Test';
            opp.aprobacion_visado_sales__c = constants.APROBADO_RIESGO_EN_PROCESO;
            opp.Flag_Banca_Nueva_Oportunidad_sales__c = true;
            insert opp;
            // opp.StageName = 'Ingreso del Negocio';
           // update opp;
            mapsOppObjects.put('Opportunity', opp);
            
			//Creaate Participant
			addParticipantController.registerParticipant('', true, false, '10788982-5', 'RUT', 'test', 'test', 'test', String.valueOf(Date.today()), '5000000', '999999999', opp.Id); 

            //Create a new quote
            Quote q = new Quote();
            q.OpportunityId = opp.Id;
            q.Pricebook2Id = pr2.Id;
            q.OwnerId = usrId;
            q.Name = 'Test';    
            q.Numero_de_Propuesta_sales__c = '1';         
            q.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType =:Constants.QUOTE AND DeveloperName =: Constants.RECORDTYPE_QUOTE_SEGURO_VIDA LIMIT 1].Id;
            insert q;
            mapsOppObjects.put('Quote', q);
            
            //Create a new quote line item
            QuoteLineItem qli = new QuoteLineItem();
            qli.QuoteId = q.Id;
            qli.PricebookEntryId = pbe.Id;
            qli.Quantity = 1;
            qli.UnitPrice = 1;
            insert qli;
            mapsOppObjects.put('QuoteLineItem', qli);
            
            //Create an Opportunity Linte Item
            OpportunityLineItem opli = new OpportunityLineItem();
            opli.OpportunityId = opp.Id;
            opli.PricebookEntryId = pbe.Id;
            opli.Quantity = 1;
            opli.UnitPrice = 1;
            opli.Product2Id = p2.Id;
            insert opli;
            mapsOppObjects.put('OpportunityLineItem', opli);
            
        }
        
        return mapsOppObjects;      
    }

            
    public static Map<String, SObject> createOpportunityWithProductContact(Id idProduct2, Id idAcc, Id usrId){
        
        User runUser = [SELECT Id, Username, UserRoleId 
                        FROM User WHERE Id =: usrId 
                        AND IsActive = true LIMIT 1];
        
        System.runAs(runUser){
            
            //Create a new Product2
            Product2 p2 = new Product2();
            p2.IsActive = true;
            p2.ProductCode = '801';
            p2.Name = 'Test';
            p2.codigo_producto_sales__c= '2';
            p2.Codigo_Macroproducto_Operacional_sales__c='1';
            p2.tipo_producto_sales__c = 'Sales_Opp_Seguro_Vida';
            p2.Plazo_estimado_cierre__c= 120;
            insert p2;
            mapsOppObjects.put('Product2', p2);
            
            //Create a new Standard Product2
            Product2 p3 = new Product2();
            p3.IsActive = true;
            p3.ProductCode = '2';
            p3.Name = 'TestStandard';
            p3.codigo_producto_sales__c= '2';
            p3.Codigo_Macroproducto_Operacional_sales__c='1';
            p3.tipo_producto_sales__c = 'Sales_Opp_Seguro_Vida_Standard';
            p3.Plazo_estimado_cierre__c= 120;
            insert p3;
            mapsOppObjects.put('Product2Standard', p3);
            
            //Create a new Pricebook
            Pricebook2 pr2 = new Pricebook2();
            pr2.IsActive = true;
            pr2.Name = 'test';
            insert pr2;
            mapsOppObjects.put('Pricebook2', pr2);
            
            //Create a new Standard Pricebook Entry
            PricebookEntry standardPBE = new PricebookEntry();
            standardPBE.Pricebook2Id = idProduct2;
            standardPBE.Product2Id = p2.Id;
            standardPBE.UnitPrice = 1;
            standardPBE.IsActive = true;
            insert standardPBE;
            
            //Create a new Pricebook Entry
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = pr2.Id;
            pbe.Product2Id = p2.Id;
            pbe.UnitPrice = 1;
            pbe.IsActive = true;
            insert pbe;
            mapsOppObjects.put('PricebookEntry', pbe);
            
            system.debug('ID RECORDTYPE: '+[SELECT Id FROM RecordType WHERE sObjectType =:Constants.OPPORTUNITY AND DeveloperName =: Constants.RECORDTYPE_SEGURO_VIDA LIMIT 1].Id);
            system.debug('ID PRICEBOOK: '+pr2.Id);
            system.debug('USER RUN: '+runUser.Id);
            system.debug('ID ACCOUNT: '+idAcc);
            
            //Create a new Opportunity
            Opportunity opp = new Opportunity();
            opp.AccountId = idAcc;
            opp.Name = 'Test';
            opp.StageName = 'Contacto';
            opp.CloseDate = Date.today();
            opp.Pricebook2Id = pr2.Id;
            opp.OwnerId = runUser.Id;
            opp.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType =:Constants.OPPORTUNITY AND DeveloperName =: Constants.RECORDTYPE_SEGURO_VIDA LIMIT 1].Id;
            insert opp;
            mapsOppObjects.put('Opportunity', opp);
            
			//Creaate Participant
			addParticipantController.registerParticipant('', true, false, '19375874-6', 'RUT', 'test', 'test', 'test', String.valueOf(Date.today()), '5000000', '999999999', opp.Id); 

            //Create a new quote
            Quote q = new Quote();
            q.OpportunityId = opp.Id;
            q.Pricebook2Id = pr2.Id;
            q.OwnerId = usrId;
            q.Name = 'Test';    
            q.Numero_de_Propuesta_sales__c = '1';        
            q.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType =:Constants.QUOTE AND DeveloperName =: Constants.RECORDTYPE_QUOTE_SEGURO_VIDA LIMIT 1].Id;
            insert q;
            mapsOppObjects.put('Quote', q);
            
            //Create a new quote line item
            QuoteLineItem qli = new QuoteLineItem();
            qli.QuoteId = q.Id;
            qli.PricebookEntryId = pbe.Id;
            qli.Quantity = 1;
            qli.UnitPrice = 1;
            insert qli;
            mapsOppObjects.put('QuoteLineItem', qli);
            
            //Create an Opportunity Linte Item
            OpportunityLineItem opli = new OpportunityLineItem();
            opli.OpportunityId = opp.Id;
            opli.PricebookEntryId = pbe.Id;
            opli.Quantity = 1;
            opli.UnitPrice = 1;
            opli.Product2Id = p2.Id;
            insert opli;
            mapsOppObjects.put('OpportunityLineItem', opli);
            
        }
        
        return mapsOppObjects;      
    }
    

        
        
        
        
        
    public static Map<String, SObject> createOpportunityVidaWithProduct(Id idProduct2, Id idAcc, Id usrId){
        
        User runUser = [SELECT Id, Username, UserRoleId 
                        FROM User WHERE Id =: usrId 
                        AND IsActive = true LIMIT 1];

        
        System.runAs(runUser){
            
            //Create a new Product2
            Product2 p2 = new Product2();
            p2.IsActive = true;
            p2.ProductCode = '801';
            p2.Name = 'Test';
            p2.codigo_producto_sales__c= '2';
            p2.Codigo_Macroproducto_Operacional_sales__c='1';
            p2.tipo_producto_sales__c = 'Sales_Opp_Seguro_Vida';
            p2.Plazo_estimado_cierre__c= 120;
            insert p2;
            mapsOppObjects.put('Product2', p2);
            
            //Create a new Standard Product2
            Product2 p3 = new Product2();
            p3.IsActive = true;
            p3.ProductCode = '2';
            p3.Name = 'TestStandard';
            p3.codigo_producto_sales__c= '2';
            p3.Codigo_Macroproducto_Operacional_sales__c='1';
            p3.tipo_producto_sales__c = 'Sales_Opp_Seguro_Vida_Standard';
            p3.Plazo_estimado_cierre__c= 120;
            insert p3;
            mapsOppObjects.put('Product2Standard', p3);
            
            //Create a new Pricebook
            Pricebook2 pr2 = new Pricebook2();
            pr2.IsActive = true;
            pr2.Name = 'test';
            insert pr2;
            mapsOppObjects.put('Pricebook2', pr2);
            
            //Create a new Standard Pricebook Entry
            PricebookEntry standardPBE = new PricebookEntry();
            standardPBE.Pricebook2Id = idProduct2;
            standardPBE.Product2Id = p2.Id;
            standardPBE.UnitPrice = 1;
            standardPBE.IsActive = true;
            insert standardPBE;
            
            //Create a new Pricebook Entry
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = pr2.Id;
            pbe.Product2Id = p2.Id;
            pbe.UnitPrice = 1;
            pbe.IsActive = true;
            insert pbe;
            mapsOppObjects.put('PricebookEntry', pbe);
            
            //Create a new Opportunity
            Opportunity opp = new Opportunity();
            opp.AccountId = idAcc;
            opp.Name = 'Test';
            opp.StageName = 'Contacto';
            opp.CloseDate = Date.today();
            opp.Pricebook2Id = pr2.Id;
            opp.OwnerId = runUser.Id;

            insert opp;
            
            mapsOppObjects.put('Opportunity', opp);
            
            //Create a new quote
            Quote q = new Quote();
            q.OpportunityId = opp.Id;
            q.Pricebook2Id = pr2.Id;
            q.OwnerId = runUser.Id;
            q.Name = 'Test';    
            q.Numero_de_Propuesta_sales__c = '1';        
            insert q;
            mapsOppObjects.put('Quote', q);
            
            //Create a new quote line item
            QuoteLineItem qli = new QuoteLineItem();
            qli.QuoteId = q.Id;
            qli.PricebookEntryId = pbe.Id;
            qli.Quantity = 1;
            qli.UnitPrice = 1;
            insert qli;
            mapsOppObjects.put('QuoteLineItem', qli);
            
            //Create an Opportunity Linte Item
            OpportunityLineItem opli = new OpportunityLineItem();
            opli.OpportunityId = opp.Id;
            opli.PricebookEntryId = pbe.Id;
            opli.Quantity = 1;
            opli.UnitPrice = 1;
            opli.Product2Id = p2.Id;
            insert opli;
            mapsOppObjects.put('OpportunityLineItem', opli);
            
			//Creaate Participant
			addParticipantController.registerParticipant('', true, false, '10788982-5', 'RUT', 'test', 'test', 'test', String.valueOf(Date.today()), '5000000', '999999999', opp.Id); 

            
            
        }
        
        return mapsOppObjects;      
    }
    /**
* @description       This method creates a New Opportunity Document
* @return            Response Account
* @throws            NA
*/
    
    public static documento_oportunidad_sales__c createNewOppDoc(String oppId, String estado){
        documento_oportunidad_sales__c newDoc = new documento_oportunidad_sales__c(
            opportunity_sales__c= oppId,
            Name ='doc',
            motivo_rechazo_sales__c = '',
            estado_documento_sales__c = estado); 
        insert newDoc;
        return newDoc;
    }
    
    
    public static List<documento_oportunidad_sales__c> createNewOppHipoDoc(String oppId){
        Map<Integer, String> docTypes = CONSTANTS.DOC_TYPES;
        List<documento_oportunidad_sales__c> docsToCreate = new List<documento_oportunidad_sales__c>();
        for (Integer key : docTypes.keySet()) {                              
            String doc = docTypes.get(key);            
            documento_oportunidad_sales__c newDoc = new documento_oportunidad_sales__c(
                opportunity_sales__c = oppId,
                Name = doc,
                motivo_rechazo_sales__c = '',
                estado_documento_sales__c = ''
            );
            docsToCreate.add(newDoc);
    
        }
        if(docsToCreate != null && !docsToCreate.isEmpty()){
        insert docsToCreate;
        return docsToCreate;
        }
        return null;
    }
    
    public static void createPricebook2(string Pricebook2Name){
        Pricebook2 pr2 = new Pricebook2();
        pr2.IsActive = true;
        pr2.Name = Pricebook2Name;
        insert pr2;
    }
        
    public static void createConsorcioOrg(){
        Map<String,Id> profileNameId = new Map<String,Id>();
        for(profile p : [Select Id, name From Profile]){
            profileNameId.put(p.name, p.id);
        }
        
        List<Consorcio_Org__c> ConsOrgList = new List<Consorcio_Org__c>();
        Consorcio_Org__c ConsOrgAdmin = new Consorcio_Org__c();
        ConsOrgAdmin.SetupOwnerId = profileNameId.get('System Administrator');
        ConsOrgAdmin.Sales_project__c= True;
        ConsOrgAdmin.Validation_rules__c= True;
        ConsOrgAdmin.Hipotecario_sales__c= True;
        ConsOrgAdmin.PPlus_sales__c= True;
        ConsOrgAdmin.Vida_sales__c= True;
        ConsOrgAdmin.Auto_sales__c= True;
        ConsOrgAdmin.Hogar_sales__c= True;
        ConsOrgAdmin.Referir_sales__c= True;
        ConsOrgAdmin.Sincronizar_sales__c= True;
        ConsOrgAdmin.Cambiar_Propietario_sales__c= True;
        ConsOrgAdmin.Participantes_Sales__c= True;
        ConsOrgAdmin.Etapa_Simulacion_sales__c= True;
        ConsOrgAdmin.Etapa_Cierre_Ganada_sales__c= True;
        ConsOrgAdmin.Etapa_Recopilacion_sales__c= True;
        //ConsOrgAdmin.Etapa_Visado_sales__c= False;
        ConsOrgAdmin.Etapa_Activacion_sales__c= False;
        ConsOrgAdmin.Etapa_Evaluacion_sales__c= False;
        ConsOrgAdmin.Etapa_Formalizacion_sales__c= False;
        ConsOrgAdmin.Etapa_Inscripcion_sales__c= False;
        ConsOrgAdmin.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgAdmin);
        
        Consorcio_Org__c ConsOrgJefeComercial = new Consorcio_Org__c();
        ConsOrgJefeComercial.SetupOwnerId = profileNameId.get('Jefe de Atención al Cliente Seguros Comercial');
        ConsOrgJefeComercial.Sales_project__c= True;
        ConsOrgJefeComercial.Validation_rules__c= True;
        ConsOrgJefeComercial.Hipotecario_sales__c= False;
        ConsOrgJefeComercial.PPlus_sales__c= True;
        ConsOrgJefeComercial.Vida_sales__c= False;
        ConsOrgJefeComercial.Auto_sales__c= False;
        ConsOrgJefeComercial.Hogar_sales__c= False;
        ConsOrgJefeComercial.Referir_sales__c= True;
        ConsOrgJefeComercial.Sincronizar_sales__c= False;
        ConsOrgJefeComercial.Cambiar_Propietario_sales__c= True;
        ConsOrgJefeComercial.Participantes_Sales__c= False;
        ConsOrgJefeComercial.Etapa_Simulacion_sales__c= False;
        ConsOrgJefeComercial.Etapa_Cierre_Ganada_sales__c= True;
        ConsOrgJefeComercial.Etapa_Recopilacion_sales__c= True;
        //ConsOrgJefeComercial.Etapa_Visado_sales__c= False;
        ConsOrgJefeComercial.Etapa_Activacion_sales__c= False;
        ConsOrgJefeComercial.Etapa_Evaluacion_sales__c= False;
        ConsOrgJefeComercial.Etapa_Formalizacion_sales__c= False;
        ConsOrgJefeComercial.Etapa_Inscripcion_sales__c= False;
        ConsOrgJefeComercial.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgJefeComercial);
        
        Consorcio_Org__c ConsOrgEjecutivoVenta = new Consorcio_Org__c();
        ConsOrgEjecutivoVenta.SetupOwnerId = profileNameId.get('Ejecutivo de Venta');
        ConsOrgEjecutivoVenta.Sales_project__c= True;
        ConsOrgEjecutivoVenta.Validation_rules__c= True;
        ConsOrgEjecutivoVenta.Hipotecario_sales__c= False;
        ConsOrgEjecutivoVenta.PPlus_sales__c= False;
        ConsOrgEjecutivoVenta.Vida_sales__c= False;
        ConsOrgEjecutivoVenta.Auto_sales__c= False;
        ConsOrgEjecutivoVenta.Hogar_sales__c= False;
        ConsOrgEjecutivoVenta.Referir_sales__c= True;
        ConsOrgEjecutivoVenta.Sincronizar_sales__c= True;
        ConsOrgEjecutivoVenta.Cambiar_Propietario_sales__c= False;
        ConsOrgEjecutivoVenta.Participantes_Sales__c= False;
        ConsOrgEjecutivoVenta.Etapa_Simulacion_sales__c= False;
        ConsOrgEjecutivoVenta.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgEjecutivoVenta.Etapa_Recopilacion_sales__c= False;
        //ConsOrgEjecutivoVenta.Etapa_Visado_sales__c= False;
        ConsOrgEjecutivoVenta.Etapa_Activacion_sales__c= False;
        ConsOrgEjecutivoVenta.Etapa_Evaluacion_sales__c= False;
        ConsOrgEjecutivoVenta.Etapa_Formalizacion_sales__c= False;
        ConsOrgEjecutivoVenta.Etapa_Inscripcion_sales__c= False;
        ConsOrgEjecutivoVenta.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgEjecutivoVenta);
        
        Consorcio_Org__c ConsOrgEjecutivoRelacionamiento = new Consorcio_Org__c();
        ConsOrgEjecutivoRelacionamiento.SetupOwnerId = profileNameId.get('Ejecutivo de Relacionamiento');
        ConsOrgEjecutivoRelacionamiento.Sales_project__c= True;
        ConsOrgEjecutivoRelacionamiento.Validation_rules__c= True;
        ConsOrgEjecutivoRelacionamiento.Hipotecario_sales__c= False;
        ConsOrgEjecutivoRelacionamiento.PPlus_sales__c= False;
        ConsOrgEjecutivoRelacionamiento.Vida_sales__c= False;
        ConsOrgEjecutivoRelacionamiento.Auto_sales__c= False;
        ConsOrgEjecutivoRelacionamiento.Hogar_sales__c= False;
        ConsOrgEjecutivoRelacionamiento.Referir_sales__c= True;
        ConsOrgEjecutivoRelacionamiento.Sincronizar_sales__c= False;
        ConsOrgEjecutivoRelacionamiento.Cambiar_Propietario_sales__c= False;
        ConsOrgEjecutivoRelacionamiento.Participantes_Sales__c= False;
        ConsOrgEjecutivoRelacionamiento.Etapa_Simulacion_sales__c= False;
        ConsOrgEjecutivoRelacionamiento.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgEjecutivoRelacionamiento.Etapa_Recopilacion_sales__c= False;
        //ConsOrgEjecutivoRelacionamiento.Etapa_Visado_sales__c= False;
        ConsOrgEjecutivoRelacionamiento.Etapa_Activacion_sales__c= False;
        ConsOrgEjecutivoRelacionamiento.Etapa_Evaluacion_sales__c= False;
        ConsOrgEjecutivoRelacionamiento.Etapa_Formalizacion_sales__c= False;
        ConsOrgEjecutivoRelacionamiento.Etapa_Inscripcion_sales__c= False;
        ConsOrgEjecutivoRelacionamiento.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgEjecutivoRelacionamiento);
        
        Consorcio_Org__c ConsOrgJefeCampania = new Consorcio_Org__c();
        ConsOrgJefeCampania.SetupOwnerId = profileNameId.get('Jefe de Campaña');
        ConsOrgJefeCampania.Sales_project__c= True;
        ConsOrgJefeCampania.Validation_rules__c= True;
        ConsOrgJefeCampania.Hipotecario_sales__c= False;
        ConsOrgJefeCampania.PPlus_sales__c= False;
        ConsOrgJefeCampania.Vida_sales__c= False;
        ConsOrgJefeCampania.Auto_sales__c= False;
        ConsOrgJefeCampania.Hogar_sales__c= False;
        ConsOrgJefeCampania.Referir_sales__c= False;
        ConsOrgJefeCampania.Sincronizar_sales__c= False;
        ConsOrgJefeCampania.Cambiar_Propietario_sales__c= False;
        ConsOrgJefeCampania.Participantes_Sales__c= False;
        ConsOrgJefeCampania.Etapa_Simulacion_sales__c= False;
        ConsOrgJefeCampania.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgJefeCampania.Etapa_Recopilacion_sales__c= False;
        //ConsOrgJefeCampania.Etapa_Visado_sales__c= False;
        ConsOrgJefeCampania.Etapa_Activacion_sales__c= False;
        ConsOrgJefeCampania.Etapa_Evaluacion_sales__c= False;
        ConsOrgJefeCampania.Etapa_Formalizacion_sales__c= False;
        ConsOrgJefeCampania.Etapa_Inscripcion_sales__c= False;
        ConsOrgJefeCampania.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgJefeCampania);
        
        Consorcio_Org__c ConsOrgJefeVentas = new Consorcio_Org__c();
        ConsOrgJefeVentas.SetupOwnerId = profileNameId.get('Jefe de Ventas');
        ConsOrgJefeVentas.Sales_project__c= True;
        ConsOrgJefeVentas.Validation_rules__c= True;
        ConsOrgJefeVentas.Hipotecario_sales__c= False;
        ConsOrgJefeVentas.PPlus_sales__c= False;
        ConsOrgJefeVentas.Vida_sales__c= False;
        ConsOrgJefeVentas.Auto_sales__c= False;
        ConsOrgJefeVentas.Hogar_sales__c= False;
        ConsOrgJefeVentas.Referir_sales__c= True;
        ConsOrgJefeVentas.Sincronizar_sales__c= False;
        ConsOrgJefeVentas.Cambiar_Propietario_sales__c= True;
        ConsOrgJefeVentas.Participantes_Sales__c= False;
        ConsOrgJefeVentas.Etapa_Simulacion_sales__c= False;
        ConsOrgJefeVentas.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgJefeVentas.Etapa_Recopilacion_sales__c= False;
        //ConsOrgJefeVentas.Etapa_Visado_sales__c= False;
        ConsOrgJefeVentas.Etapa_Activacion_sales__c= False;
        ConsOrgJefeVentas.Etapa_Evaluacion_sales__c= False;
        ConsOrgJefeVentas.Etapa_Formalizacion_sales__c= False;
        ConsOrgJefeVentas.Etapa_Inscripcion_sales__c= False;
        ConsOrgJefeVentas.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgJefeVentas);
        
        Consorcio_Org__c ConsOrgEjecutivoEspecialista = new Consorcio_Org__c();
        ConsOrgEjecutivoEspecialista.SetupOwnerId = profileNameId.get('Ejecutivo Especialista');
        ConsOrgEjecutivoEspecialista.Sales_project__c= True;
        ConsOrgEjecutivoEspecialista.Validation_rules__c= True;
        ConsOrgEjecutivoEspecialista.Hipotecario_sales__c= True;
        ConsOrgEjecutivoEspecialista.PPlus_sales__c= False;
        ConsOrgEjecutivoEspecialista.Vida_sales__c= False;
        ConsOrgEjecutivoEspecialista.Auto_sales__c= False;
        ConsOrgEjecutivoEspecialista.Hogar_sales__c= False;
        ConsOrgEjecutivoEspecialista.Referir_sales__c= True;
        ConsOrgEjecutivoEspecialista.Sincronizar_sales__c= True;
        ConsOrgEjecutivoEspecialista.Cambiar_Propietario_sales__c= False;
        ConsOrgEjecutivoEspecialista.Participantes_Sales__c= True;
        ConsOrgEjecutivoEspecialista.Etapa_Simulacion_sales__c= True;
        ConsOrgEjecutivoEspecialista.Etapa_Cierre_Ganada_sales__c= True;
        ConsOrgEjecutivoEspecialista.Etapa_Recopilacion_sales__c= True;
        //ConsOrgEjecutivoEspecialista.Etapa_Visado_sales__c= False;
        ConsOrgEjecutivoEspecialista.Etapa_Activacion_sales__c= False;
        ConsOrgEjecutivoEspecialista.Etapa_Evaluacion_sales__c= False;
        ConsOrgEjecutivoEspecialista.Etapa_Formalizacion_sales__c= False;
        ConsOrgEjecutivoEspecialista.Etapa_Inscripcion_sales__c= False;
        ConsOrgEjecutivoEspecialista.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgEjecutivoEspecialista);
        
        Consorcio_Org__c ConsOrgJefePlataformaHipotecario = new Consorcio_Org__c();
        ConsOrgJefePlataformaHipotecario.SetupOwnerId = profileNameId.get('Jefe Plataforma Hipotecario');
        ConsOrgJefePlataformaHipotecario.Sales_project__c= True;
        ConsOrgJefePlataformaHipotecario.Validation_rules__c= True;
        ConsOrgJefePlataformaHipotecario.Hipotecario_sales__c= True;
        ConsOrgJefePlataformaHipotecario.PPlus_sales__c= False;
        ConsOrgJefePlataformaHipotecario.Vida_sales__c= False;
        ConsOrgJefePlataformaHipotecario.Auto_sales__c= False;
        ConsOrgJefePlataformaHipotecario.Hogar_sales__c= False;
        ConsOrgJefePlataformaHipotecario.Referir_sales__c= True;
        ConsOrgJefePlataformaHipotecario.Sincronizar_sales__c= True;
        ConsOrgJefePlataformaHipotecario.Cambiar_Propietario_sales__c= True;
        ConsOrgJefePlataformaHipotecario.Participantes_Sales__c= True;
        ConsOrgJefePlataformaHipotecario.Etapa_Simulacion_sales__c= True;
        ConsOrgJefePlataformaHipotecario.Etapa_Cierre_Ganada_sales__c= True;
        ConsOrgJefePlataformaHipotecario.Etapa_Recopilacion_sales__c= True;
        //ConsOrgJefePlataformaHipotecario.Etapa_Visado_sales__c= True;
        ConsOrgJefePlataformaHipotecario.Etapa_Activacion_sales__c= False;
        ConsOrgJefePlataformaHipotecario.Etapa_Evaluacion_sales__c= False;
        ConsOrgJefePlataformaHipotecario.Etapa_Formalizacion_sales__c= False;
        ConsOrgJefePlataformaHipotecario.Etapa_Inscripcion_sales__c= False;
        ConsOrgJefePlataformaHipotecario.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgJefePlataformaHipotecario);
        
        Consorcio_Org__c ConsOrgAsistenteCP = new Consorcio_Org__c();
        ConsOrgAsistenteCP.SetupOwnerId = profileNameId.get('Asistente CP');
        ConsOrgAsistenteCP.Sales_project__c= True;
        ConsOrgAsistenteCP.Validation_rules__c= True;
        ConsOrgAsistenteCP.Hipotecario_sales__c= False;
        ConsOrgAsistenteCP.PPlus_sales__c= False;
        ConsOrgAsistenteCP.Vida_sales__c= False;
        ConsOrgAsistenteCP.Auto_sales__c= False;
        ConsOrgAsistenteCP.Hogar_sales__c= True;
        ConsOrgAsistenteCP.Referir_sales__c= False;
        ConsOrgAsistenteCP.Sincronizar_sales__c= True;
        ConsOrgAsistenteCP.Cambiar_Propietario_sales__c= False;
        ConsOrgAsistenteCP.Participantes_Sales__c= False;
        ConsOrgAsistenteCP.Etapa_Simulacion_sales__c= False;
        ConsOrgAsistenteCP.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgAsistenteCP.Etapa_Recopilacion_sales__c= False;
        //ConsOrgAsistenteCP.Etapa_Visado_sales__c= False;
        ConsOrgAsistenteCP.Etapa_Activacion_sales__c= False;
        ConsOrgAsistenteCP.Etapa_Evaluacion_sales__c= False;
        ConsOrgAsistenteCP.Etapa_Formalizacion_sales__c= False;
        ConsOrgAsistenteCP.Etapa_Inscripcion_sales__c= False;
        ConsOrgAsistenteCP.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgAsistenteCP);
        
        Consorcio_Org__c ConsOrgJefeVisado = new Consorcio_Org__c();
        ConsOrgJefeVisado.SetupOwnerId = profileNameId.get('Jefe de Visado');
        ConsOrgJefeVisado.Sales_project__c= True;
        ConsOrgJefeVisado.Validation_rules__c= True;
        ConsOrgJefeVisado.Hipotecario_sales__c= True;
        ConsOrgJefeVisado.PPlus_sales__c= True;
        ConsOrgJefeVisado.Vida_sales__c= False;
        ConsOrgJefeVisado.Auto_sales__c= False;
        ConsOrgJefeVisado.Hogar_sales__c= False;
        ConsOrgJefeVisado.Referir_sales__c= False;
        ConsOrgJefeVisado.Sincronizar_sales__c= False;
        ConsOrgJefeVisado.Cambiar_Propietario_sales__c= False;
        ConsOrgJefeVisado.Participantes_Sales__c= False;
        ConsOrgJefeVisado.Etapa_Simulacion_sales__c= False;
        ConsOrgJefeVisado.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgJefeVisado.Etapa_Recopilacion_sales__c= False;
        //ConsOrgJefeVisado.Etapa_Visado_sales__c= False;
        ConsOrgJefeVisado.Etapa_Activacion_sales__c= False;
        ConsOrgJefeVisado.Etapa_Evaluacion_sales__c= False;
        ConsOrgJefeVisado.Etapa_Formalizacion_sales__c= False;
        ConsOrgJefeVisado.Etapa_Inscripcion_sales__c= False;
        ConsOrgJefeVisado.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgJefeVisado);
        
        Consorcio_Org__c ConsOrgEjecutivoPresencial = new Consorcio_Org__c();
        ConsOrgEjecutivoPresencial.SetupOwnerId = profileNameId.get('Ejecutivos de Atención al Cliente Seguros Presencial');
        ConsOrgEjecutivoPresencial.Sales_project__c= True;
        ConsOrgEjecutivoPresencial.Validation_rules__c= True;
        ConsOrgEjecutivoPresencial.Hipotecario_sales__c= False;
        ConsOrgEjecutivoPresencial.PPlus_sales__c= False;
        ConsOrgEjecutivoPresencial.Vida_sales__c= False;
        ConsOrgEjecutivoPresencial.Auto_sales__c= False;
        ConsOrgEjecutivoPresencial.Hogar_sales__c= False;
        ConsOrgEjecutivoPresencial.Referir_sales__c= True;
        ConsOrgEjecutivoPresencial.Sincronizar_sales__c= False;
        ConsOrgEjecutivoPresencial.Cambiar_Propietario_sales__c= False;
        ConsOrgEjecutivoPresencial.Participantes_Sales__c= False;
        ConsOrgEjecutivoPresencial.Etapa_Simulacion_sales__c= False;
        ConsOrgEjecutivoPresencial.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgEjecutivoPresencial.Etapa_Recopilacion_sales__c= False;
        //ConsOrgEjecutivoPresencial.Etapa_Visado_sales__c= False;
        ConsOrgEjecutivoPresencial.Etapa_Activacion_sales__c= False;
        ConsOrgEjecutivoPresencial.Etapa_Evaluacion_sales__c= False;
        ConsOrgEjecutivoPresencial.Etapa_Formalizacion_sales__c= False;
        ConsOrgEjecutivoPresencial.Etapa_Inscripcion_sales__c= False;
        ConsOrgEjecutivoPresencial.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgEjecutivoPresencial);
        
        Consorcio_Org__c ConsOrgJefePresencial = new Consorcio_Org__c();
        ConsOrgJefePresencial.SetupOwnerId = profileNameId.get('Jefe de Atención al Cliente Seguros Presencial');
        ConsOrgJefePresencial.Sales_project__c= True;
        ConsOrgJefePresencial.Validation_rules__c= True;
        ConsOrgJefePresencial.Hipotecario_sales__c= False;
        ConsOrgJefePresencial.PPlus_sales__c= False;
        ConsOrgJefePresencial.Vida_sales__c= False;
        ConsOrgJefePresencial.Auto_sales__c= False;
        ConsOrgJefePresencial.Hogar_sales__c= False;
        ConsOrgJefePresencial.Referir_sales__c= True;
        ConsOrgJefePresencial.Sincronizar_sales__c= False;
        ConsOrgJefePresencial.Cambiar_Propietario_sales__c= True;
        ConsOrgJefePresencial.Participantes_Sales__c= False;
        ConsOrgJefePresencial.Etapa_Simulacion_sales__c= False;
        ConsOrgJefePresencial.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgJefePresencial.Etapa_Recopilacion_sales__c= False;
        //ConsOrgJefePresencial.Etapa_Visado_sales__c= False;
        ConsOrgJefePresencial.Etapa_Activacion_sales__c= False;
        ConsOrgJefePresencial.Etapa_Evaluacion_sales__c= False;
        ConsOrgJefePresencial.Etapa_Formalizacion_sales__c= False;
        ConsOrgJefePresencial.Etapa_Inscripcion_sales__c= False;
        ConsOrgJefePresencial.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgJefePresencial);
        
        Consorcio_Org__c ConsOrgCanalDigital = new Consorcio_Org__c();
        ConsOrgCanalDigital.SetupOwnerId = profileNameId.get('Canal Digital');
        ConsOrgCanalDigital.Sales_project__c= True;
        ConsOrgCanalDigital.Validation_rules__c= True;
        ConsOrgCanalDigital.Hipotecario_sales__c= False;
        ConsOrgCanalDigital.PPlus_sales__c= False;
        ConsOrgCanalDigital.Vida_sales__c= False;
        ConsOrgCanalDigital.Auto_sales__c= False;
        ConsOrgCanalDigital.Hogar_sales__c= False;
        ConsOrgCanalDigital.Referir_sales__c= True;
        ConsOrgCanalDigital.Sincronizar_sales__c= False;
        ConsOrgCanalDigital.Cambiar_Propietario_sales__c= True;
        ConsOrgCanalDigital.Participantes_Sales__c= False;
        ConsOrgCanalDigital.Etapa_Simulacion_sales__c= False;
        ConsOrgCanalDigital.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgCanalDigital.Etapa_Recopilacion_sales__c= False;
        //ConsOrgCanalDigital.Etapa_Visado_sales__c= False;
        ConsOrgCanalDigital.Etapa_Activacion_sales__c= False;
        ConsOrgCanalDigital.Etapa_Evaluacion_sales__c= False;
        ConsOrgCanalDigital.Etapa_Formalizacion_sales__c= False;
        ConsOrgCanalDigital.Etapa_Inscripcion_sales__c= False;
        ConsOrgCanalDigital.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgCanalDigital);
        
        Consorcio_Org__c ConsOrgEjecutivoRemoto = new Consorcio_Org__c();
        ConsOrgEjecutivoRemoto.SetupOwnerId = profileNameId.get('Ejecutivos de Atención al Cliente Seguros Remoto');
        ConsOrgEjecutivoRemoto.Sales_project__c= True;
        ConsOrgEjecutivoRemoto.Validation_rules__c= True;
        ConsOrgEjecutivoRemoto.Hipotecario_sales__c= False;
        ConsOrgEjecutivoRemoto.PPlus_sales__c= False;
        ConsOrgEjecutivoRemoto.Vida_sales__c= False;
        ConsOrgEjecutivoRemoto.Auto_sales__c= False;
        ConsOrgEjecutivoRemoto.Hogar_sales__c= False;
        ConsOrgEjecutivoRemoto.Referir_sales__c= True;
        ConsOrgEjecutivoRemoto.Sincronizar_sales__c= False;
        ConsOrgEjecutivoRemoto.Cambiar_Propietario_sales__c= False;
        ConsOrgEjecutivoRemoto.Participantes_Sales__c= False;
        ConsOrgEjecutivoRemoto.Etapa_Simulacion_sales__c= False;
        ConsOrgEjecutivoRemoto.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgEjecutivoRemoto.Etapa_Recopilacion_sales__c= False;
        //ConsOrgEjecutivoRemoto.Etapa_Visado_sales__c= False;
        ConsOrgEjecutivoRemoto.Etapa_Activacion_sales__c= False;
        ConsOrgEjecutivoRemoto.Etapa_Evaluacion_sales__c= False;
        ConsOrgEjecutivoRemoto.Etapa_Formalizacion_sales__c= False;
        ConsOrgEjecutivoRemoto.Etapa_Inscripcion_sales__c= False;
        ConsOrgEjecutivoRemoto.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgEjecutivoRemoto);
        
        Consorcio_Org__c ConsOrgJefeRiesgo = new Consorcio_Org__c();
        ConsOrgJefeRiesgo.SetupOwnerId = profileNameId.get('Jefe de Riesgo');
        ConsOrgJefeRiesgo.Sales_project__c= True;
        ConsOrgJefeRiesgo.Validation_rules__c= True;
        ConsOrgJefeRiesgo.Hipotecario_sales__c= True;
        ConsOrgJefeRiesgo.PPlus_sales__c= True;
        ConsOrgJefeRiesgo.Vida_sales__c= False;
        ConsOrgJefeRiesgo.Auto_sales__c= False;
        ConsOrgJefeRiesgo.Hogar_sales__c= False;
        ConsOrgJefeRiesgo.Referir_sales__c= False;
        ConsOrgJefeRiesgo.Sincronizar_sales__c= False;
        ConsOrgJefeRiesgo.Cambiar_Propietario_sales__c= False;
        ConsOrgJefeRiesgo.Participantes_Sales__c= False;
        ConsOrgJefeRiesgo.Etapa_Simulacion_sales__c= False;
        ConsOrgJefeRiesgo.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgJefeRiesgo.Etapa_Recopilacion_sales__c= False;
        //ConsOrgJefeRiesgo.Etapa_Visado_sales__c= False;
        ConsOrgJefeRiesgo.Etapa_Activacion_sales__c= False;
        ConsOrgJefeRiesgo.Etapa_Evaluacion_sales__c= True;
        ConsOrgJefeRiesgo.Etapa_Formalizacion_sales__c= False;
        ConsOrgJefeRiesgo.Etapa_Inscripcion_sales__c= False;
        ConsOrgJefeRiesgo.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgJefeRiesgo);
        
        Consorcio_Org__c ConsOrgJefeRemoto = new Consorcio_Org__c();
        ConsOrgJefeRemoto.SetupOwnerId = profileNameId.get('Jefe de Atención al Cliente Seguros Remoto');
        ConsOrgJefeRemoto.Sales_project__c= True;
        ConsOrgJefeRemoto.Validation_rules__c= True;
        ConsOrgJefeRemoto.Hipotecario_sales__c= False;
        ConsOrgJefeRemoto.PPlus_sales__c= False;
        ConsOrgJefeRemoto.Vida_sales__c= False;
        ConsOrgJefeRemoto.Auto_sales__c= False;
        ConsOrgJefeRemoto.Hogar_sales__c= False;
        ConsOrgJefeRemoto.Referir_sales__c= True;
        ConsOrgJefeRemoto.Sincronizar_sales__c= False;
        ConsOrgJefeRemoto.Cambiar_Propietario_sales__c= True;
        ConsOrgJefeRemoto.Participantes_Sales__c= False;
        ConsOrgJefeRemoto.Etapa_Simulacion_sales__c= False;
        ConsOrgJefeRemoto.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgJefeRemoto.Etapa_Recopilacion_sales__c= False;
        //ConsOrgJefeRemoto.Etapa_Visado_sales__c= False;
        ConsOrgJefeRemoto.Etapa_Activacion_sales__c= False;
        ConsOrgJefeRemoto.Etapa_Evaluacion_sales__c= False;
        ConsOrgJefeRemoto.Etapa_Formalizacion_sales__c= False;
        ConsOrgJefeRemoto.Etapa_Inscripcion_sales__c= False;
        ConsOrgJefeRemoto.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgJefeRemoto);
        
        Consorcio_Org__c ConsOrgIntegraciones = new Consorcio_Org__c();
        ConsOrgIntegraciones.SetupOwnerId = profileNameId.get('Integraciones');
        ConsOrgIntegraciones.Sales_project__c= True;
        ConsOrgIntegraciones.Validation_rules__c= True;
        ConsOrgIntegraciones.Hipotecario_sales__c= False;
        ConsOrgIntegraciones.PPlus_sales__c= False;
        ConsOrgIntegraciones.Vida_sales__c= False;
        ConsOrgIntegraciones.Auto_sales__c= False;
        ConsOrgIntegraciones.Hogar_sales__c= False;
        ConsOrgIntegraciones.Referir_sales__c= True;
        ConsOrgIntegraciones.Sincronizar_sales__c= False;
        ConsOrgIntegraciones.Cambiar_Propietario_sales__c= True;
        ConsOrgIntegraciones.Participantes_Sales__c= False;
        ConsOrgIntegraciones.Etapa_Simulacion_sales__c= False;
        ConsOrgIntegraciones.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgIntegraciones.Etapa_Recopilacion_sales__c= False;
        //ConsOrgIntegraciones.Etapa_Visado_sales__c= False;
        ConsOrgIntegraciones.Etapa_Activacion_sales__c= False;
        ConsOrgIntegraciones.Etapa_Evaluacion_sales__c= False;
        ConsOrgIntegraciones.Etapa_Formalizacion_sales__c= False;
        ConsOrgIntegraciones.Etapa_Inscripcion_sales__c= False;
        ConsOrgIntegraciones.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgIntegraciones);
        
        Consorcio_Org__c ConsOrgJefeCP = new Consorcio_Org__c();
        ConsOrgJefeCP.SetupOwnerId = profileNameId.get('Jefe CP');
        ConsOrgJefeCP.Sales_project__c= True;
        ConsOrgJefeCP.Validation_rules__c= True;
        ConsOrgJefeCP.Hipotecario_sales__c= False;
        ConsOrgJefeCP.PPlus_sales__c= False;
        ConsOrgJefeCP.Vida_sales__c= False;
        ConsOrgJefeCP.Auto_sales__c= True;
        ConsOrgJefeCP.Hogar_sales__c= True;
        ConsOrgJefeCP.Referir_sales__c= False;
        ConsOrgJefeCP.Sincronizar_sales__c= True;
        ConsOrgJefeCP.Cambiar_Propietario_sales__c= True;
        ConsOrgJefeCP.Participantes_Sales__c= False;
        ConsOrgJefeCP.Etapa_Simulacion_sales__c= False;
        ConsOrgJefeCP.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgJefeCP.Etapa_Recopilacion_sales__c= False;
        //ConsOrgJefeCP.Etapa_Visado_sales__c= False;
        ConsOrgJefeCP.Etapa_Activacion_sales__c= False;
        ConsOrgJefeCP.Etapa_Evaluacion_sales__c= False;
        ConsOrgJefeCP.Etapa_Formalizacion_sales__c= False;
        ConsOrgJefeCP.Etapa_Inscripcion_sales__c= False;
        ConsOrgJefeCP.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgJefeCP);
        
        Consorcio_Org__c ConsOrgEjecutivoVisado = new Consorcio_Org__c();
        ConsOrgEjecutivoVisado.SetupOwnerId = profileNameId.get('Ejecutivo de Visado');
        ConsOrgEjecutivoVisado.Sales_project__c= True;
        ConsOrgEjecutivoVisado.Validation_rules__c= True;
        ConsOrgEjecutivoVisado.Hipotecario_sales__c= True;
        ConsOrgEjecutivoVisado.PPlus_sales__c= True;
        ConsOrgEjecutivoVisado.Vida_sales__c= False;
        ConsOrgEjecutivoVisado.Auto_sales__c= False;
        ConsOrgEjecutivoVisado.Hogar_sales__c= False;
        ConsOrgEjecutivoVisado.Referir_sales__c= False;
        ConsOrgEjecutivoVisado.Sincronizar_sales__c= False;
        ConsOrgEjecutivoVisado.Cambiar_Propietario_sales__c= False;
        ConsOrgEjecutivoVisado.Participantes_Sales__c= False;
        ConsOrgEjecutivoVisado.Etapa_Simulacion_sales__c= False;
        ConsOrgEjecutivoVisado.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgEjecutivoVisado.Etapa_Recopilacion_sales__c= False;
        //ConsOrgEjecutivoVisado.Etapa_Visado_sales__c= False;
        ConsOrgEjecutivoVisado.Etapa_Activacion_sales__c= False;
        ConsOrgEjecutivoVisado.Etapa_Evaluacion_sales__c= True;
        ConsOrgEjecutivoVisado.Etapa_Formalizacion_sales__c= False;
        ConsOrgEjecutivoVisado.Etapa_Inscripcion_sales__c= False;
        ConsOrgEjecutivoVisado.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgEjecutivoVisado);
        
        Consorcio_Org__c ConsOrgEjecutivoRiesgo = new Consorcio_Org__c();
        ConsOrgEjecutivoRiesgo.SetupOwnerId = profileNameId.get('Ejecutivo de Riesgo');
        ConsOrgEjecutivoRiesgo.Sales_project__c= True;
        ConsOrgEjecutivoRiesgo.Validation_rules__c= True;
        ConsOrgEjecutivoRiesgo.Hipotecario_sales__c= True;
        ConsOrgEjecutivoRiesgo.PPlus_sales__c= True;
        ConsOrgEjecutivoRiesgo.Vida_sales__c= False;
        ConsOrgEjecutivoRiesgo.Auto_sales__c= False;
        ConsOrgEjecutivoRiesgo.Hogar_sales__c= False;
        ConsOrgEjecutivoRiesgo.Referir_sales__c= False;
        ConsOrgEjecutivoRiesgo.Sincronizar_sales__c= False;
        ConsOrgEjecutivoRiesgo.Cambiar_Propietario_sales__c= False;
        ConsOrgEjecutivoRiesgo.Participantes_Sales__c= False;
        ConsOrgEjecutivoRiesgo.Etapa_Simulacion_sales__c= False;
        ConsOrgEjecutivoRiesgo.Etapa_Cierre_Ganada_sales__c= False;
        ConsOrgEjecutivoRiesgo.Etapa_Recopilacion_sales__c= False;
        //ConsOrgEjecutivoRiesgo.Etapa_Visado_sales__c= False;
        ConsOrgEjecutivoRiesgo.Etapa_Activacion_sales__c= False;
        ConsOrgEjecutivoRiesgo.Etapa_Evaluacion_sales__c= True;
        ConsOrgEjecutivoRiesgo.Etapa_Formalizacion_sales__c= False;
        ConsOrgEjecutivoRiesgo.Etapa_Inscripcion_sales__c= False;
        ConsOrgEjecutivoRiesgo.Etapa_entrega_sales__c = False;
        ConsOrgList.add(ConsOrgEjecutivoRiesgo);
        insert ConsOrgList;
    }
    
     public static Map<String, SObject> createOpportunityWithProduct_RecordType(Id idProduct2, Id idAcc, Id usrId,String rType_Opp,String rType_Quote){
         
         User runUser = [SELECT Id, Username, UserRoleId 
                         FROM User WHERE Id =: usrId 
                         AND IsActive = true LIMIT 1];
         
         
        System.runAs(runUser){
            
            //Create a new Product2
            Product2 p2 = new Product2();
            p2.IsActive = true;
            p2.ProductCode = '801';
            p2.Name = 'Test';
            p2.codigo_producto_sales__c= '2';
            p2.Codigo_Macroproducto_Operacional_sales__c='1';
            p2.tipo_producto_sales__c = rType_Opp;
            p2.Plazo_estimado_cierre__c= 120;
            insert p2;
            mapsOppObjects.put('Product2', p2);
            
            //Create a new Standard Product2
            Product2 p3 = new Product2();
            p3.IsActive = true;
            p3.ProductCode = '2';
            p3.Name = 'TestStandard';
            p3.codigo_producto_sales__c= '2';
            p3.Codigo_Macroproducto_Operacional_sales__c='1';
            p3.tipo_producto_sales__c = 'Sales_Opp_Seguro_Vida_Standard';
            p3.Plazo_estimado_cierre__c= 120;
            insert p3;
            mapsOppObjects.put('Product2Standard', p3);
            
            //Create a new Pricebook
            Pricebook2 pr2 = new Pricebook2();
            pr2.IsActive = true;
            pr2.Name = 'test';
            insert pr2;
            mapsOppObjects.put('Pricebook2', pr2);
            
            //Create a new Standard Pricebook Entry
            PricebookEntry standardPBE = new PricebookEntry();
            standardPBE.Pricebook2Id = idProduct2;
            standardPBE.Product2Id = p2.Id;
            standardPBE.UnitPrice = 1;
            standardPBE.IsActive = true;
            insert standardPBE;
            
            //Create a new Pricebook Entry
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = pr2.Id;
            pbe.Product2Id = p2.Id;
            pbe.UnitPrice = 1;
            pbe.IsActive = true;
            insert pbe;
            mapsOppObjects.put('PricebookEntry', pbe);
            
            //Create a new Opportunity
            Opportunity opp = new Opportunity();
            opp.AccountId = idAcc;
            opp.Name = 'Test';
            opp.StageName = 'Contacto';
            opp.CloseDate = Date.today();
            opp.Pricebook2Id = pr2.Id;
            opp.OwnerId = runUser.Id;
            opp.correo_oportunidad_sales__c = 'hola@hola.com';
            opp.telefono_oportunidad_sales__c ='42323232';
            opp.direccion_oportunidad_sales__c = 'casa 1212';
            opp.movil_oportunidad_sales__c = '99999999';
            opp.Aprobacion_Plan_Plus_sales__c = false;
           
            opp.RecordTypeId= [SELECT Id FROM RecordType WHERE sObjectType =:Constants.OPPORTUNITY AND DeveloperName =:rType_Opp LIMIT 1].Id;

            insert opp;
            
            mapsOppObjects.put('Opportunity', opp);
            
            //Create a new quote
            Quote q = new Quote();
            q.OpportunityId = opp.Id;
            q.Pricebook2Id = pr2.Id;
            q.OwnerId = runUser.Id;
            q.Name = 'Test';    
            q.Numero_de_Propuesta_sales__c = '1';
            q.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType =:Constants.QUOTE AND DeveloperName =:rType_Quote LIMIT 1].Id;
            insert q;
            mapsOppObjects.put('Quote', q);
            
            //Create a new quote line item
            QuoteLineItem qli = new QuoteLineItem();
            qli.QuoteId = q.Id;
            qli.PricebookEntryId = pbe.Id;
            qli.Quantity = 1;
            qli.UnitPrice = 1;
            insert qli;
            mapsOppObjects.put('QuoteLineItem', qli);
            
            //Create an Opportunity Linte Item
            OpportunityLineItem opli = new OpportunityLineItem();
            opli.OpportunityId = opp.Id;
            opli.PricebookEntryId = pbe.Id;
            opli.Quantity = 1;
            opli.UnitPrice = 1;
            opli.Product2Id = p2.Id;
            insert opli;
            mapsOppObjects.put('OpportunityLineItem', opli);
            
			//Creaate Participant
			addParticipantController.registerParticipant('', true, false, '10788982-5', 'RUT', 'test', 'test', 'test', String.valueOf(Date.today()), '5000000', '999999999', opp.Id);   
            
        }
        
        return mapsOppObjects;           
    }

    public static void makeCustomSettings(){
            insert new ProfileInjectionLead__c(Name='EjecutivoVenta', ProfileName__c='Ejecutivo de Venta');

            insert new DocuwareMetadata__c(Name='INDEX01',Index_Label__c='CLIENTE',
                        Index_value__c='0',Type_Index_List__c = Constants.XML_INDICES);
            
            insert new DocuwareMetadata__c(Name='INDEX02',Index_Label__c='PROCESO_DE_NEGOCIO',
                        Index_value__c='0',Type_Index_List__c = Constants.XML_INDICES);
            
            insert new DocuwareMetadata__c(Name='INDEX03',Index_Label__c='TIPO_DE_DOCUMENTO',
                        Index_value__c='0',Type_Index_List__c = Constants.XML_INDICES);
            
            insert new DocuwareMetadata__c(Name='INDEX04',Index_Label__c='ID_PROCESO',
                        Index_value__c='0',Type_Index_List__c = Constants.XML_INDICES);

            insert new DocuwareMetadata__c(Name='INDEX05',Index_Label__c='DWDOCID',
                        Index_value__c='0',Type_Index_List__c = Constants.XML_FILTROS);

            insert new MessageNotification__c(Name='N1',Header__c='Test',Body__c ='Test {0}',
                        Parameters__c = 'CaseNumber', Functionality__c = 'VENCIMIENTO');
        	
        	insert new CaseNotifiesToAnalytics__c(Name='N1',IdTipoMarca__c=4,SalesforceField__c ='Desuscribir_Email__c');
        	
        	insert new CaseNotifiesToAnalytics__c(Name='N1',IdTipoMarca__c=12,SalesforceField__c ='Desuscribir_Telefono__c');
        
            insert new CompanyNameListUsr__c(Name='CGRAL',CompanyNameSalesForce__c ='Consorcio Seguros');
        
        	insert new CompanyNameListUsr__c(Name='CVIDA',CompanyNameSalesForce__c ='Consorcio Seguros');
        
        	insert new SucursalNameUsr__c (Name='EDIFICIO EL BOSQUE PISO 1',SucursalName__c ='Oficina El Bosque',  NombreApiSalesForce__c = '230' );
    }    

}