@isTest
public class CONS_CertificadosTest {
	static testMethod void TestCargasLegales_01() {
        
		//EmailTemplate eT = new EmailTemplate();
		//eT.Subject = 'Test';
		//eT.Body = 'Test';
		//eT.DeveloperName = 'TestCargasLegales1';
		//eT.Name = 'Test';
		//eT.FolderId = [SELECT  Id FROM Folder where  DeveloperName='Prueba' limit 1].id;
		//eT.TemplateType = 'custom';
		//insert eT;
		
		//EmailTemplate eT=[SELECT Id,Subject, Body FROM EmailTemplate WHERE DeveloperName = 'TestCargasLegales'];

		/*
		Contact contacto = new Contact();
		contacto.FirstName = 'Cristhofer';
		contacto.LastName = 'Rodriguez';
		contacto.Email = 'cristhoferr1@gmail.com';
		insert contacto;
		*/
		String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
		//acc.PersonContactId = contacto.Id;		
        insert acc;
		

        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901'; 
        pc.Esquema_Nectia__c = 'SISRVOWCNS';
        insert pc;
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
		cas.ContactId=acc.PersonContactId;
        insert cas;
     	Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        
		
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Cargas_Legales'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Cargas_Legales sc=new CONS_Certificado_Cargas_Legales(astc);
        sc.pro = pc;
        sc.cas = cas;
        sc.documentos.add(adjuntoDoc);
        string aux = sc.aux;
        string body = sc.body;
        string email = sc.email;
        string error = sc.error;
        string resp = sc.resp;
        string respuestaerror = sc.respuestaerror;
        string nombre = sc.nombre;
        string extAux = sc.extAux;
        PageReference continuar = sc.continuar();
        PageReference continuarcaso = sc.continuarcaso();
        boolean continuarsinenviar = sc.continuarsinenviar;
        PageReference enviar = sc.enviar();
        sc.Conresser = '0';
        //sc.siguiente();
        PageReference volver = sc.volver();
    }

	static testMethod void TestCargasLegales_01_Else() {
        
		//EmailTemplate eT = new EmailTemplate();
		//eT.Subject = 'Test';
		//eT.Body = 'Test';
		//eT.DeveloperName = 'TestCargasLegales1';
		//eT.Name = 'Test';
		//eT.FolderId = [SELECT  Id FROM Folder where  DeveloperName='Prueba' limit 1].id;
		//eT.TemplateType = 'custom';
		//insert eT;					

		//EmailTemplate eT=[SELECT Id,Subject, Body FROM EmailTemplate WHERE DeveloperName = 'TestCargasLegales'];

		/*
		Contact contacto = new Contact();
		contacto.FirstName = 'Cristhofer';
		contacto.LastName = 'Rodriguez';
		contacto.Email = 'cristhoferr1@gmail.com';
		insert contacto;
		*/
		String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
		acc.CambioMail__c = true;
		//acc.PersonContactId = contacto.Id;		
        insert acc;
		

        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c='Rentas Vitalicias';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901'; 
        pc.Esquema_Nectia__c = 'SISRVOWCNS';
       
		//pc.Cliente_Nectia__r.CambioMail__c = acc.CambioMail__c;
        insert pc;
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
		cas.ContactId=acc.PersonContactId;
        insert cas;
     	Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        
		

     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Cargas_Legales'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Cargas_Legales sc=new CONS_Certificado_Cargas_Legales(astc);
         sc.Conresser = '0';
        sc.siguiente();
       // sc.pro = pc;
        sc.cas = cas;
        sc.documentos.add(adjuntoDoc);
        string aux = sc.aux;
        string body = sc.body;
        string email = sc.email;
        string error = sc.error;
        string resp = sc.resp;
        string respuestaerror = sc.respuestaerror;
        string nombre = sc.nombre;
        string extAux = sc.extAux;
       
        PageReference continuar = sc.continuar();
        PageReference continuarcaso = sc.continuarcaso();
        boolean continuarsinenviar = sc.continuarsinenviar;
         PageReference orquestaMetodos = sc.orquestaMetodos();
        PageReference enviar = sc.enviar();
        

		//CONS_RespuestaCertificadocargasl_JSON resser = (CONS_RespuestaCertificadocargasl_JSON)JSON.deserialize(resp,CONS_RespuestaCertificadocargasl_JSON.class);
		//resser.codigoError = '0';  
       // sc.siguiente();
        //PageReference volver = sc.volver();
    }

    static testMethod void TestCargasLegales_02() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        pc.Esquema_Nectia__c = 'SISRVOWCNS';
        insert pc;
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
        insert cas;
     	Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Cargas_Legales'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Cargas_Legales sc=new CONS_Certificado_Cargas_Legales(astc);
        sc.pro = pc;
        sc.cas = cas;
        sc.Conresser = '1';
        sc.siguiente();
        sc.documentos.add(adjuntoDoc);
        sc.email = 'test@test.cl';
        //PageReference enviar = sc.enviar();
    
    }
    static testMethod void TestCargasLegales_03() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        pc.Esquema_Nectia__c = 'SISRVOWCNS';
        insert pc;
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
        insert cas;
     	Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Cargas_Legales'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Cargas_Legales sc=new CONS_Certificado_Cargas_Legales(astc);
        sc.pro = pc;
        sc.cas = cas;
        sc.documentos.add(adjuntoDoc);
        string aux = sc.aux;
        string body = sc.body;
        string email = sc.email;
        string error = sc.error;
        string resp = sc.resp;
        string respuestaerror = sc.respuestaerror;
        string nombre = sc.nombre;
        string extAux = sc.extAux;
        PageReference continuar = sc.continuar();
        PageReference continuarcaso = sc.continuarcaso();
        boolean continuarsinenviar = sc.continuarsinenviar;
                       
        PageReference enviar = sc.enviar();
        sc.siguiente();
    }
    
    
    
    static testMethod void TestCertificadoCoberturas_01() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
        insert cas;
     
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Cobertura'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Cobertura sc=new CONS_Certificado_Cobertura(astc);
     	PageReference continuar = sc.continuar();
		sc.messageBody = 'test';   
        sc.cas = cas;
        String aux = sc.aux;
        String body = sc.body;
        String error = sc.error;
        string email = sc.email;
        string extAux = sc.extAux;
        string nombre = sc.nombre;
        string resp = sc.resp;
        Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        sc.documentos.add(adjuntoDoc);
        sc.cas = cas;
        sc.Conresser = '0';
        PageReference siguiente = sc.siguiente();
       // PageReference enviar = sc.enviar();
        PageReference continuarcaso = sc.continuarcaso();
    }
    static testMethod void TestCertificadoCoberturas_02() {
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc = CONS_TestDataFactory.createTestPrdCliente('5285349-4','','INSUDB','Rentas Vitalicias');
        Case cas=new Case();
        cas = CONS_TestDataFactory.createTestCase('Consulta','Siniestros','Estado','6676081-2');
     
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Cobertura'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Cobertura sc=new CONS_Certificado_Cobertura(astc);
     	PageReference continuar = sc.continuar(); 
		sc.messageBody = 'test';   
        sc.cas = cas;
        String aux = sc.aux;
        String body = sc.body;
        String error = sc.error;
        string email = sc.email;
        string extAux = sc.extAux;
        string nombre = sc.nombre;
        string resp = sc.resp;
        Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        sc.documentos.add(adjuntoDoc);
        sc.email = 'test@test.cl';
        sc.cas = cas;
        sc.Conresser = '1';
        PageReference siguiente = sc.siguiente();
        //PageReference enviar = sc.enviar();
        PageReference continuarcaso = sc.continuarcaso();
       
    }
    static testMethod void TestCertificadoCoberturas_03() {
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc = CONS_TestDataFactory.createTestPrdCliente('5285349-4','','CLONINSUDB','Seguro Hogar');
        Case cas=new Case();
        cas = CONS_TestDataFactory.createTestCase('Consulta','Siniestros','Estado','6676081-2');
     
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Cobertura'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Cobertura sc=new CONS_Certificado_Cobertura(astc);
     	
        PageReference continuar = sc.continuar(); 
		sc.messageBody = 'test';   
        sc.cas = cas;
        String aux = sc.aux;
        String body = sc.body;
        String error = sc.error;
        string email = sc.email;
        string extAux = sc.extAux;
        string nombre = sc.nombre;
        string resp = sc.resp;
        Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        sc.documentos.add(adjuntoDoc);
        sc.email = 'test@test.cl';
       sc.cas = cas;
        sc.Conresser = '0'; 
        //PageReference siguiente = sc.siguiente();
       // PageReference enviar = sc.enviar();
        PageReference continuarcaso = sc.continuarcaso();
        PageReference volver = sc.volver();
    }
    static testMethod void TestCertificadoCoberturas_04() {
       //Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        //pc = CONS_TestDataFactory.createTestPrdCliente('5285349-4','','CLONINSUDB','Seguro Vehículos');
        //Case cas=new Case();
        //cas = CONS_TestDataFactory.createTestCase('Consulta','Siniestros','Estado','6676081-2');
     
		String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
		acc.CambioMail__c = true;		
        insert acc;
		
		Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c='SOAP';
		pds.Familia__c = 'Seguro Hogar';
        insert pds;

        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901'; 
        pc.Esquema_Nectia__c = 'CLONINSUDB';
		insert pc;	 	

		Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
		cas.ContactId=acc.PersonContactId;
        insert cas;        

     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Cobertura'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Cobertura sc=new CONS_Certificado_Cobertura(astc);
     	sc.Conresser = '0';
		sc.id = pc.Id;
        //sc.siguiente();
	
		Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
		
		sc.messageBody = 'test';   
        sc.cas = cas;
		sc.documentos.add(adjuntoDoc);
        String aux = sc.aux;
        String body = sc.body;
        String error = sc.error;
        string email = sc.email;
        string extAux = sc.extAux;
        string nombre = sc.nombre;
        string resp = sc.resp;
        string respuestaerror = sc.respuestaerror;        
        sc.documentos.add(adjuntoDoc);
        sc.email = 'test@test.cl';
        sc.cas = cas;
        //PageReference siguiente = sc.siguiente();
        PageReference continuarcaso = sc.continuarcaso();

		PageReference continuar = sc.continuar();
        //PageReference continuarcaso = sc.continuarcaso();
        //boolean continuarsinenviar = sc.continuarsinenviar;
        //PageReference enviar = sc.enviar();
    }

	static testMethod void TestCertificadoCoberturas_04_Else() {
       //Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        //pc = CONS_TestDataFactory.createTestPrdCliente('5285349-4','','CLONINSUDB','Seguro Vehículos');
        //Case cas=new Case();
        //cas = CONS_TestDataFactory.createTestCase('Consulta','Siniestros','Estado','6676081-2');
     
		String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
		acc.CambioMail__c = true;		
        insert acc;
		
		Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c='Rentas Vitalicias';
		pds.Familia__c = 'Seguro Vehículos';
        insert pds;

        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901'; 
        pc.Esquema_Nectia__c = 'CLONINSUDB';
		//pc.Familia_del__c='Seguro Hogar';
		insert pc;	 	

		Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
		cas.ContactId=acc.PersonContactId;
        insert cas;        

     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Cobertura'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Cobertura sc=new CONS_Certificado_Cobertura(astc);
     	sc.Conresser = '0';
		sc.id = pc.Id;
        //sc.siguiente();
	
		Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
		
		sc.messageBody = 'test';   
        sc.cas = cas;
		sc.documentos.add(adjuntoDoc);
        String aux = sc.aux;
        String body = sc.body;
        String error = sc.error;
        string email = sc.email;
        string extAux = sc.extAux;
        string nombre = sc.nombre;
        string resp = sc.resp;
        string respuestaerror = sc.respuestaerror;        
        sc.documentos.add(adjuntoDoc);
        sc.email = 'test@test.cl';
        sc.cas = cas;
        PageReference siguiente = sc.siguiente();
        PageReference continuarcaso = sc.continuarcaso();
		
        PageReference enviar = sc.enviar();
    }
    static testMethod void TestCertificadoCoberturas_05() {
       //Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        //pc = CONS_TestDataFactory.createTestPrdCliente('5285349-4','','CLONINSUDB','Seguro Vehículos');
        //Case cas=new Case();
        //cas = CONS_TestDataFactory.createTestCase('Consulta','Siniestros','Estado','6676081-2');
     
		String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        //acc.PersonEmail = 'test@test.cl';
		//acc.CambioMail__c = true;		
        insert acc;
		
		Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c='';
	//	pds.Familia__c = 'Seguro Vehículos';
        insert pds;

        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        //pc.Esquema_Nectia__c = 'CLONINSUDB';
		//pc.Familia_del__c='Seguro Hogar';
		insert pc;	 	

		Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
		cas.ContactId=acc.PersonContactId;
        insert cas;        

     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Cobertura'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Cobertura sc=new CONS_Certificado_Cobertura(astc);
     	sc.Conresser = '0';
		sc.id = pc.Id;
        //sc.siguiente();
	
		Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
		
		sc.messageBody = 'test';   
        sc.cas = cas;
		sc.documentos.add(adjuntoDoc);
        String aux = sc.aux;
        String body = sc.body;
        String error = sc.error;
        string email = sc.email;
        string extAux = sc.extAux;
        string nombre = sc.nombre;
        string resp = sc.resp;
        string respuestaerror = sc.respuestaerror;        
        sc.documentos.add(adjuntoDoc);
        sc.email = 'test@test.cl';
        sc.cas = cas;
        PageReference siguiente = sc.siguiente();
        PageReference continuarcaso = sc.continuarcaso();
		
        PageReference enviar = sc.enviar();
    }

    static testMethod void TestCertificadoLiquidacionPension_01() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c='Rentas Vitalicias';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Esquema_Nectia__c='SISRVOWCNS';
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        //pc = CONS_TestDataFactory.createTestPrdCliente('5285349-4','','SISRVOWCNS','Seguro Vehículos');
       // Case cas=new Case();
      //  cas = CONS_TestDataFactory.createTestCase('Consulta','Siniestros','Estado','6676081-2');
       Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
        insert cas;
      
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_liquidacion_pension'));
        
        System.currentPageReference().getParameters().put('id', pc.Id);
        
        CONS_Certificado_liquidacion_pension sc=new CONS_Certificado_liquidacion_pension(astc);
       
		String aux = sc.aux;
        String body = sc.body;
        String error = sc.error;
        string email = sc.email;
        string extAux = sc.extAux;
        string nombre = sc.nombre;
        string resp = sc.resp;
        string respuestaerror = sc.respuestaerror;
        Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        sc.documentos.add(adjuntoDoc);
        sc.email = 'test@test.cl';
        sc.cas = cas;
        sc.Conresser = '0'; 
        PageReference siguiente = sc.siguiente();
        sc.numfch = String.valueOf(system.today());
        //PageReference enviar = sc.enviar(); 
        //PageReference verdocumento = sc.verdocumento(); 
        PageReference continuar = sc.continuar(); 
        PageReference continuarcaso = sc.continuarcaso();
        PageReference documento= sc.documento();
      //  PageReference orquestaMetodos= sc.orquestaMetodos();
    }
    static testMethod void TestCertificadoLiquidacionPension_02() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c='Rentas Vitalicias';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Esquema_Nectia__c='SISRVOWCNS';
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
        //pc = CONS_TestDataFactory.createTestPrdCliente('5285349-4','','SISRVOWCNS','Seguro Vehículos');
       // Case cas=new Case();
      //  cas = CONS_TestDataFactory.createTestCase('Consulta','Siniestros','Estado','6676081-2');
       Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
        insert cas;
       OrgWideEmailAddress owa=[select id, Address from OrgWideEmailAddress where Address='consorcio.informa@consorcio.cl' limit 1 ];
       // EmailTemplate plantilla = [SELECT Id,Subject, Body FROM EmailTemplate WHERE DeveloperName = 'CSeguros_Certificado_Liquidaci_n_Pensi_n'];
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_liquidacion_pension'));
        
        System.currentPageReference().getParameters().put('id', pc.Id);
        
        CONS_Certificado_liquidacion_pension sc=new CONS_Certificado_liquidacion_pension(astc);
        PageReference continuar = sc.continuar(); 
		String aux = sc.aux;
        String body = sc.body;
        String error = sc.error;
        string email = sc.email;
        string extAux = sc.extAux;
        string nombre = sc.nombre;
        string resp = sc.resp;
        string respuestaerror = sc.respuestaerror;
        Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        sc.documentos.add(adjuntoDoc);
       
        sc.email = 'test@test.cl';
        sc.cas = cas;
        sc.Conresser = '0'; 
        PageReference siguiente = sc.siguiente();
        sc.numfch = String.valueOf(system.today());
         PageReference enviar = sc.enviar();
         //PageReference orquestaMetodos = orquestaMetodos();
         sc.orquestaMetodos();
        
        PageReference continuarcaso = sc.continuarcaso();
       
    }
    static testMethod void TestCertificadoLiquidacionPension_03() {
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc = CONS_TestDataFactory.createTestPrdCliente('5285349-4','','SISRVOWCNL','Seguro Vehículos');
        Case cas=new Case();
        cas = CONS_TestDataFactory.createTestCase('Consulta','Siniestros','Estado','6676081-2');
      
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_liquidacion_pension'));
        
        System.currentPageReference().getParameters().put('id', pc.Id);
        
        CONS_Certificado_liquidacion_pension sc=new CONS_Certificado_liquidacion_pension(astc);
        PageReference continuar = sc.continuar(); 
		String aux = sc.aux;
        String body = sc.body;
        String error = sc.error;
        string email = sc.email;
        string extAux = sc.extAux;
        string nombre = sc.nombre;
        string resp = sc.resp;
        string respuestaerror = sc.respuestaerror;
        Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        sc.documentos.add(adjuntoDoc);
        sc.email = 'test@test.cl';
        sc.cas = cas;
        sc.Conresser = '1'; 
        PageReference siguiente = sc.siguiente();
        sc.numfch = String.valueOf(system.today());
        PageReference volver = sc.volver();
        //PageReference enviar = sc.enviar();
        //PageReference continuarcaso = sc.continuarcaso();
    }
    static testMethod void TestCertificadoPagos_01() {
        
          String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c='Rentas Vitalicias';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Esquema_Nectia__c='SISRVOWCNS';
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
 
       Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
        insert cas;
        
        OrgWideEmailAddress owa=[select id, Address from OrgWideEmailAddress where Address='consorcio.informa@consorcio.cl' limit 1 ];
       // EmailTemplate plantilla = [SELECT Id,Subject, Body FROM EmailTemplate WHERE DeveloperName = 'CSeguros_Certificado_Liquidaci_n_Pensi_n'];
      
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Pagos'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Pagos sc=new CONS_Certificado_Pagos(astc);
        String aux = sc.aux;
        String body = sc.body;
        String error = sc.error;
        string email = sc.email;
        string extAux = sc.extAux;
        string nombre = sc.nombre;
        string resp = sc.resp;
        string respuestaerror = sc.respuestaerror;
     	Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        sc.documentos.add(adjuntoDoc);
        sc.email = 'test@test.cl';
        sc.cas = cas;
        sc.Conresser = '0'; 
        sc.orquestaMetodos();
        //PageReference siguiente = sc.siguiente();
        PageReference volver = sc.volver();
        PageReference enviar = sc.enviar(); 
        PageReference continuar = sc.continuar(); 
        PageReference continuarcaso = sc.continuarcaso();
    }
    static testMethod void TestCertificadoPagos_02() {
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc = CONS_TestDataFactory.createTestPrdCliente('5285349-4','','SISRVOWCNL','Seguro Vehículos');
        Case cas=new Case();
        cas = CONS_TestDataFactory.createTestCase('Consulta','Siniestros','Estado','6676081-2');
      
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Pagos'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Pagos sc=new CONS_Certificado_Pagos(astc);
        String aux = sc.aux;
        String body = sc.body;
        String error = sc.error;
        string email = sc.email;
        string extAux = sc.extAux;
        string nombre = sc.nombre;
        string resp = sc.resp;
        string respuestaerror = sc.respuestaerror;
     	Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        sc.documentos.add(adjuntoDoc);
        sc.email = 'test@test.cl';
        sc.cas = cas;
        sc.Conresser = '1'; 
        PageReference siguiente = sc.siguiente();
        PageReference volver = sc.volver();
    }
    static testMethod void TestCertificadoVigencia_01() {
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc = CONS_TestDataFactory.createTestPrdCliente('5285349-4','','SISRVOWCNL','Seguro Vehículos');
        Case cas=new Case();
        cas = CONS_TestDataFactory.createTestCase('Consulta','Siniestros','Estado','6676081-2');
      
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Vigencia'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Vigencia sc=new CONS_Certificado_Vigencia(astc);
     	String aux = sc.aux;
        String body = sc.body;
        String error = sc.error;
        string email = sc.email;
        string extAux = sc.extAux;
        string nombre = sc.nombre;
        string resp = sc.resp;
        string respuestaerror = sc.respuestaerror;
     	Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        sc.documentos.add(adjuntoDoc);
        sc.email = 'test@test.cl';
        sc.cas = cas;
        sc.Conresser = '0'; 
        //PageReference siguiente = sc.siguiente();
        PageReference volver = sc.volver();
    }
	static testMethod void TestCertificadoVigencia_02() {
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc = CONS_TestDataFactory.createTestPrdCliente('5285349-4','','CLONINSUDB','Seguro Vehículos');
        Case cas=new Case();
        cas = CONS_TestDataFactory.createTestCase('Consulta','Siniestros','Estado','6676081-2');
      
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Vigencia'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Vigencia sc=new CONS_Certificado_Vigencia(astc);
     	String aux = sc.aux;
        String body = sc.body;
        String error = sc.error;
        string email = sc.email;
        string extAux = sc.extAux;
        string nombre = sc.nombre;
        string resp = sc.resp;
        string respuestaerror = sc.respuestaerror;
     	Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        sc.documentos.add(adjuntoDoc);
        sc.email = 'test@test.cl';
        sc.cas = cas; 
        sc.Conresser = '1'; 
        PageReference siguiente = sc.siguiente();
        PageReference volver = sc.volver();
    }
    static testMethod void TestCertificadoVigencia_03() {
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc = CONS_TestDataFactory.createTestPrdCliente('5285349-4','','CLONINSUDB','Seguro Hogar');
        Case cas=new Case();
        cas = CONS_TestDataFactory.createTestCase('Consulta','Siniestros','Estado','6676081-2');
      
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Vigencia'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Vigencia sc=new CONS_Certificado_Vigencia(astc);
     	String aux = sc.aux;
        String body = sc.body;
        String error = sc.error;
        string email = sc.email;
        string extAux = sc.extAux;
        string nombre = sc.nombre;
        string resp = sc.resp;
        string respuestaerror = sc.respuestaerror;
     	Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        sc.documentos.add(adjuntoDoc);
        sc.email = 'test@test.cl';
        sc.cas = cas; 
        sc.Conresser = '0'; 
        //PageReference siguiente = sc.siguiente();
        PageReference volver = sc.volver();
    }
    static testMethod void TestCertificadoVigencia_04() {
        
        
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.L_nea__c='Rentas Vitalicias';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Esquema_Nectia__c='SISRVOWCNS';
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        insert pc;
 
       Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
        insert cas;
        
        /*        
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc = CONS_TestDataFactory.createTestPrdCliente('5285349-4','','INSUDB','Seguro Hogar');
        Case cas=new Case();
        cas = CONS_TestDataFactory.createTestCase('Consulta','Siniestros','Estado','6676081-2');
     	 */
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Certificado_Vigencia'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Certificado_Vigencia sc=new CONS_Certificado_Vigencia(astc);
     	String aux = sc.aux;
        String body = sc.body;
        String error = sc.error;
        string email = sc.email;
        string extAux = sc.extAux;
        string nombre = sc.nombre;
        string resp = sc.resp;
        string respuestaerror = sc.respuestaerror;
     	Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        sc.documentos.add(adjuntoDoc);
        sc.email = 'test@test.cl';
        sc.cas = cas; 
        sc.Conresser = '0'; 
        //PageReference siguiente = sc.siguiente();
        PageReference volver = sc.volver();
        sc.enviar(); 
        sc.orquestaMetodos();
        PageReference continuar = sc.continuar(); 
        PageReference continuarcaso = sc.continuarcaso();
    }
    static testMethod void TestCoberturas() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        pc.Esquema_Nectia__c ='INSUDB';
        insert pc;
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
        insert cas;
        
      
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Coberturas'));
        //System.currentPageReference().getParameters().put('id', pc.Id);
        //CONS_Coberturas sc=new CONS_Coberturas(astc);
     	//sc.listar_vida_o_life();
    }
   /* static testMethod void TestCopiaPoliza() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        pc.Esquema_Nectia__c ='INSUDB';
        insert pc;
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
        insert cas;
      
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Copia_Poliza'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Copia_Poliza sc=new CONS_Copia_Poliza(astc);
     	//sc.listar_vida_o_life();
    }
    static testMethod void TestCopiaSOAP() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        insert acc;
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        pc.Esquema_Nectia__c ='INSUDB';
        insert pc;
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
        insert cas;
      
     	ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Copia_SOAP'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Copia_SOAP sc=new CONS_Copia_SOAP(astc);
     	//sc.listar_vida_o_life();
    }*/
}