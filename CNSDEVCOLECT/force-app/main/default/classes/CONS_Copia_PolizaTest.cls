@isTest
public class CONS_Copia_PolizaTest {
    static testMethod void test() {
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
        pc.Ramo_Nectia__c='05';
        pc.Codigo_Plan_Nectia__c='360';
        pc.Poliza_Nectia__c='12132413';
        pc.Esquema_Nectia__c='SISRVOWPCNS';
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
        cas.Producto_del_Cliente_Nectia__c=pc.id;
        cas.N_mandato__c='123';
        cas.V_a_de_Pago__c='1';
        cas.Tipo_de_cuenta__c='1';
        
        cas.Rut__c='15555555-6';
        insert cas;
        Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Copia_Poliza'));
        System.currentPageReference().getParameters().put('id',pc.Id);
        CONS_Copia_Poliza cp=new CONS_Copia_Poliza(astc);
        //cp.siguiente();
        cp.volver();
        cp.enviar();
        cp.continuar();
        //cp.continuarcaso();
        cp.email=null;
        //cp.siguiente();
         
    }
     static testMethod void test1() {
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
        pc.Ramo_Nectia__c='05';
        pc.Codigo_Plan_Nectia__c='360';
        pc.Poliza_Nectia__c='12132413';
        pc.Esquema_Nectia__c='CLONINSUDB';
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
        cas.Producto_del_Cliente_Nectia__c=pc.id;
        cas.N_mandato__c='123';
        cas.V_a_de_Pago__c='1';
        cas.Tipo_de_cuenta__c='1';
        
        cas.Rut__c='15555555-6';
        insert cas;
        Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Copia_Poliza'));
        System.currentPageReference().getParameters().put('id',pc.Id);
        CONS_Copia_Poliza cp=new CONS_Copia_Poliza(astc);
        //cp.siguiente();
        cp.volver();
        cp.enviar();
        cp.continuar();
        //cp.continuarcaso();
        
    }
      static testMethod void test2() {
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
        pc.Ramo_Nectia__c='01';
        pc.Codigo_Plan_Nectia__c='360';
        pc.Poliza_Nectia__c='12132413';
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
        cas.Producto_del_Cliente_Nectia__c=pc.id;
        cas.N_mandato__c='123';
        cas.V_a_de_Pago__c='1';
        cas.Tipo_de_cuenta__c='1';
        
        cas.Rut__c='15555555-6';
        insert cas;
        Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Copia_Poliza'));
        System.currentPageReference().getParameters().put('id',pc.Id);
        CONS_Copia_Poliza cp=new CONS_Copia_Poliza(astc);
        cp.siguiente();
        cp.volver();
        cp.enviar();
        cp.continuar();
        cp.continuarcaso();
        cp.orquestaMetodos();
        
    }
      static testMethod void test3() {
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
        pds.L_nea__c='Rentas Vitalicias';
        pds.Codigo_de_Producto_nectia__c = '1111';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        pc.Ramo_Nectia__c='05';
        pc.Codigo_Plan_Nectia__c='360';
        pc.Poliza_Nectia__c='12132413';
        pc.Esquema_Nectia__c='CLONINSUDB';
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
        cas.Producto_del_Cliente_Nectia__c=pc.id;
        cas.N_mandato__c='123';
        cas.V_a_de_Pago__c='1';
        cas.Tipo_de_cuenta__c='1';
        
        cas.Rut__c='15555555-6';
        insert cas;
        Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Copia_Poliza'));
        System.currentPageReference().getParameters().put('id',pc.Id);
        CONS_Copia_Poliza cp=new CONS_Copia_Poliza(astc);
        //cp.siguiente();
        cp.volver();
        cp.enviar();
        cp.continuar();
        cp.verdocumento();
        //cp.continuarcaso();
        
    }
    static testMethod void test34() {
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
        pc.Ramo_Nectia__c='05';
        pc.Codigo_Plan_Nectia__c='360';
        pc.Poliza_Nectia__c='12132413';
        pc.Esquema_Nectia__c='INSUDB';
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
        cas.Producto_del_Cliente_Nectia__c=pc.id;
        cas.N_mandato__c='123';
        cas.V_a_de_Pago__c='1';
        cas.Tipo_de_cuenta__c='1';
        
        cas.Rut__c='15555555-6';
        insert cas;
        Attachment adjuntoDoc = new Attachment();
        adjuntoDoc.Name = 'Unit Test Attachment';
        adjuntoDoc.Body = Blob.valueOf('Unit Test Attachment Body');
        adjuntoDoc.ParentId = cas.Id;
        insert adjuntoDoc;
        
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Copia_Poliza'));
        System.currentPageReference().getParameters().put('id',pc.Id);
        CONS_Copia_Poliza cp=new CONS_Copia_Poliza(astc);
        //cp.siguiente();
        cp.volver();
        cp.enviar();
        cp.continuar();
        //cp.continuarcaso();
        cp.email=null;
        //cp.siguiente();
         
    }
        static testMethod void test4() {
         CONS_Respuestacopiapoliza_JSON ev = new CONS_Respuestacopiapoliza_JSON();
        string Json ='{"codigoError":"1", "mensajeError":"testerror", "certificado":{ "archivo":"test", "nombreArchivo":"test"}}';   
          ev = CONS_Respuestacopiapoliza_JSON.parse(Json);
              CONS_Respuestacopiapolizavida_JSON ev1 = new CONS_Respuestacopiapolizavida_JSON();
        string Json1 ='{"codigoError":"1", "mensajeError":"testerror", "certificado":{ "archivo":"test", "nombreArchivo":"test"}}';   
          ev1 = CONS_Respuestacopiapolizavida_JSON.parse(Json);
              CONS_RespuestaCopiaPolizaRV_JSON ev2 = new CONS_RespuestaCopiaPolizaRV_JSON();
        string Json2 ='{"codigoError":"OK", "mensajeError":"testerror", "certificado":{ "archivo":"test", "nombreArchivo":"test"}}';   
          ev2 = CONS_RespuestaCopiaPolizaRV_JSON.parse(Json);
        string Json3 ='{"codigoError":"OK", "mensajeError":"testerror", "certificado":{ "archivo":"test", "nombreArchivo":"test"}}'; 
             CONS_RespuestaCopiaPolizaRV_JSON ev23 = new CONS_RespuestaCopiaPolizaRV_JSON();
          ev23 = CONS_RespuestaCopiaPolizaRV_JSON.parse(Json);
            string Json4 ='{"codigoError":"0", "mensajeError":"testerror", "certificado":{ "archivo":"test", "nombreArchivo":"test"}}';  
      
       
    }
}