@istest
public class CONS_RESTCasoSeguroControlllerTest {
    static testMethod void Test() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.phone = '1333322';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        acc.PersonMobilePhone = '569 5645 0989';
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
        pc.Poliza_Nectia__c='11052691';
        insert pc;
       
       CONS_RESTCasoSeguroControlller.crearcaso('11052691', '6676081-2', '', '', '', 'En proceso', '', 'Fondos de Inversión');
    }
    
    static testMethod void Test2() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.phone = '1333322';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c='6676081-2';
        acc.PersonEmail = 'test@test.cl';
        acc.PersonMobilePhone = '569 5645 0989';
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
        pc.Poliza_Nectia__c='11052691';
        insert pc;
       
       CONS_RESTCasoSeguroControlller.crearcaso('11052691', '6976081-2', '', '', '', 'En proceso', '', 'Fondos de Inversión');
    }
    
    
}