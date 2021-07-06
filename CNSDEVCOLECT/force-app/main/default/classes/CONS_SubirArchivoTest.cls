@isTest
public class CONS_SubirArchivoTest {
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
        pc.Esquema_Nectia__c='CLONINSUDB';
        insert pc;
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Producto_del_Cliente_Nectia__c=pc.id;
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
        
        
        
        
        ApexPages.StandardController  apsc=new ApexPages.StandardController(cas);
        CONS_SubirArchivo  sa=new CONS_SubirArchivo(apsc);
        sa.objCaseAtt.name='test.png';
        sa.objCaseAtt.name='test.png';
        sa.largo = 300000;
        sa.opcion = null; 
        sa.opcion2 = null;
        sa.opcion3 = null;
        
        
        sa.estado();
        
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
        pc.Esquema_Nectia__c='SISRVOWCNL';
        insert pc;
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Producto_del_Cliente_Nectia__c=pc.id;
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
        
        
        
        
        ApexPages.StandardController  apsc=new ApexPages.StandardController(cas);
        CONS_SubirArchivo  sa=new CONS_SubirArchivo(apsc);
        sa.objCaseAtt.name='test.png';
        sa.largo = 0;
        sa.opcion = null; 
        sa.opcion2 = null;
        sa.opcion3 = null;
        
        
        sa.estado();
        
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
        pds.Codigo_de_Producto_nectia__c = '1111';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        pc.Esquema_Nectia__c='';
        insert pc;
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Producto_del_Cliente_Nectia__c=pc.id;
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
        
        
        
        
        ApexPages.StandardController  apsc=new ApexPages.StandardController(cas);
        CONS_SubirArchivo  sa=new CONS_SubirArchivo(apsc);
        sa.objCaseAtt.name='test.png';
        sa.largo = 4300000;
        sa.opcion = null;  
        sa.opcion2 = null;
        sa.opcion3 = null;
        
        
        sa.estado();
        
    }
    static testMethod void test4() {
        
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
        pc.Esquema_Nectia__c='';
        insert pc;
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Producto_del_Cliente_Nectia__c=pc.id;
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
        
        
        
        
        ApexPages.StandardController  apsc=new ApexPages.StandardController(cas);
        CONS_SubirArchivo  sa=new CONS_SubirArchivo(apsc);
        sa.objCaseAtt.name='test.png';
        sa.largo = 4400000;
        sa.opcion = null;  
        sa.opcion2 = null;
        sa.opcion3 = null;
        
        
        sa.estado();
        sa.seccion();
        sa.opcion='';
        sa.opcion='END';
        sa.Items();
        sa.opcion='Rescate';
        sa.Items();
        sa.opcion='SIN';
        sa.Items();
        sa.opcion='RENV';
        sa.Items();
        sa.opcion='VEN';
        sa.Items();
        sa.opcion='EMI';
        sa.Items();
        sa.opcion='PAG';
        sa.Items();
        sa.opcion='PVEN';
        sa.Items();
        
        
    }
    static testMethod void test5() {
        
        CONS_RespuestaDocuwaresubir_JSON  sd=new CONS_RespuestaDocuwaresubir_JSON();
        string res='{    "codigo": "0000",    "codigoServicio": "0",    "dwDocId": 184953,    "mensajeServicio": "OK"}';
        sd=CONS_RespuestaDocuwaresubir_JSON.parse(res);
        
    }
}