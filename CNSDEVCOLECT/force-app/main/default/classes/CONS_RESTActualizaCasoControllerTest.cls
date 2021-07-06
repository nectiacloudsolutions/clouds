@istest
public class CONS_RESTActualizaCasoControllerTest {
  static testMethod void Test() {
        String recordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName = 'test';
        acc.phone = '1333333222222';
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
        pc.Poliza_Nectia__c='11052691';
        insert pc;
        
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='Siniestros';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Producto_del_Cliente_Nectia__c=pc.id;
        cas.Clasificaci_n_de_Consulta__c = 'Estado';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
        insert cas;
        system.debug('cas'+cas.CaseNumber);
       case cas1=[select id,CaseNumber from Case  where id=: cas.id];
      integer numero=integer.valueOf(cas1.CaseNumber);
      CONS_RESTActualizaCasoController.actualizarcaso(numero, 'CIERRE', 'RECHAZO', 'Rechazado');
      CONS_RESTActualizaCasoController.actualizarcaso(numero, ' ', 'RECHAZO', 'Rechazado');
      CONS_RESTActualizaCasoController.actualizarcaso(1232134, '', 'RECHAZO', 'Rechazado');
    
      
       
      
    }
}