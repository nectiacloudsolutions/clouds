@isTest
public class CONS_TestDataFactory {
    public static Account createTestAcc(String correoCliente, String rut) {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.RecordTypeId=recordTypeId;
        acc.rut__c=rut;
        acc.PersonEmail = correoCliente;
        insert acc;
        return acc;
    }
    public static Producto_del_Cliente__c createTestPrdCliente(String rut, String email, String EsquemaPrd, String Familia) {
        Account acc = new Account();
        acc = CONS_TestDataFactory.createTestAcc(email,rut);
        
        Producto_de_Seguros__c pds=new Producto_de_Seguros__c();
        pds.Name='Renta Vitalicia';
        pds.Codigo_de_Producto_nectia__c = '1111';
        pds.Familia__c = Familia;
        insert pds;
        
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Seguros'].id;
        pc.Cliente_Nectia__c = acc.id;
        pc.Producto_de_Seguros_Nectia__c=pds.id;
        pc.Name='Renta Vitalicia';
        pc.Id__c='12345678901';
        pc.Esquema_Nectia__c = EsquemaPrd;
        insert pc;
        return pc;
    }
    
    public static Case createTestCase(String tipoCaso, String subTipoCaso, String ClasificacionConsulta, String rut) {
        Account acc = new Account();
        acc = CONS_TestDataFactory.createTestAcc('',rut);
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
        return cas;
    }
}