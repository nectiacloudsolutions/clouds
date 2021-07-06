@isTest
public class CONS_Copia_SOAPTest {
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
        pds.L_nea__c='Rentas Vitalicias';
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
        Test.setCurrentPageReference(new PageReference('Page.CONS_Copia_SOAP'));
        System.currentPageReference().getParameters().put('id',pc.Id);
        CONS_Copia_SOAP cp=new CONS_Copia_SOAP(astc);
     //cp.siguiente();
     cp.verdocumento();
      cp.volver();
     
      cp.enviar();
      cp.updateUser();
     cp.siguiente();
      cp.continuarcaso();
      //cp.enviar();
      cp.continuar();
      //cp.continuarcaso();
       cp.orquestaMetodos();
       
        
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
        Test.setCurrentPageReference(new PageReference('Page.CONS_Copia_SOAP'));
        System.currentPageReference().getParameters().put('id',pc.Id);
        CONS_Copia_SOAP cp=new CONS_Copia_SOAP(astc);
     cp.siguiente();
      cp.volver();
     
      cp.continuar();
      //cp.continuarcaso();
       
        
    }
    static testMethod void test12() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
         RecordType tiporestro = [SELECT Id, DeveloperName, SobjectType, IsActive, Description FROM RecordType  where  DeveloperName ='Casos_Seguros'];
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
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        //pc.Esquema_Nectia__c='INSUDB';
        pc.Ramo_Nectia__c='05';
        pc.Codigo_Plan_Nectia__c='360';
        pc.Poliza_Nectia__c='12132413';
        insert pc;
        Case cas=new Case();
       
        cas.RecordTypeId=[SELECT Id, DeveloperName, SobjectType, IsActive, Description FROM RecordType  where  DeveloperName ='Casos_Seguros'].id;
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
        Test.setCurrentPageReference(new PageReference('Page.CONS_Copia_SOAP'));
        System.currentPageReference().getParameters().put('id',pc.Id);
        CONS_Copia_SOAP cp=new CONS_Copia_SOAP(astc);
     cp.siguiente();
      cp.volver();
     
      cp.continuar();
      //cp.continuarcaso();
       
        
    }
    
      static testMethod void test4() {
         CONS_RespuestaCopiaSOAP_JSON ev = new CONS_RespuestaCopiaSOAP_JSON();
        string Json ='{"codigoError":"1", "mensajeError":"testerror", "certificado":{ "archivo":"test", "nombreArchivo":"test"}}';   
          ev = CONS_RespuestaCopiaSOAP_JSON.parse(Json);
         
       
        
       
    }
}