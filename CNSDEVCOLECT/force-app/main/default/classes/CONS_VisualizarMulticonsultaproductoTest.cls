@isTest
public class CONS_VisualizarMulticonsultaproductoTest {
	static testMethod void TestControlador_1() {
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
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        pc.Esquema_Nectia__c = 'INSUDB';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Visualizar_MulticonsultaProducto'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Visualizar_Multiconsultaproducto sc=new CONS_Visualizar_Multiconsultaproducto(astc);  
        sc.continuar();
    }
    static testMethod void TestControlador_2() {
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
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        pc.Esquema_Nectia__c = 'CLONINSUDB';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Visualizar_MulticonsultaProducto'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Visualizar_Multiconsultaproducto sc=new CONS_Visualizar_Multiconsultaproducto(astc);  
        sc.continuar();
    }
    static testMethod void TestControlador_3() {
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
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        pc.Esquema_Nectia__c = 'VTCNLIFE';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Visualizar_MulticonsultaProducto'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Visualizar_Multiconsultaproducto sc=new CONS_Visualizar_Multiconsultaproducto(astc);  
        sc.continuar();
    }
    
      static testMethod void TestControlador_4() {
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
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        pc.Esquema_Nectia__c = 'VTCNLIFE';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(acc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Visualizar_Multiconsulta'));
       // System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Visualizar_Multiconsulta sc=new CONS_Visualizar_Multiconsulta(astc);  
       
    }
      static testMethod void TestControlador_5() {
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
        pds.L_nea__c = 'Vida';
        pds.Familia__c = 'APV';
        insert pds;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c=acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        pc.Esquema_Nectia__c = 'VTCNLIFE';
        insert pc;
        ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_Visualizar_Multiservicio'));
        System.currentPageReference().getParameters().put('id', pc.Id);
        CONS_Visualizar_Multiservicio sc=new CONS_Visualizar_Multiservicio(astc);  
       
    }
    
}