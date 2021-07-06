@isTest
public class CONS_PolizaTest {
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
        
        //ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_TerminoPoliza'));
        System.currentPageReference().getParameters().put('id', cas.Id);
        CONS_Poliza vp=new CONS_Poliza();
        vp.terminopoliza();
        vp.Rehabilitacionpoliza();  
        vp.continuar();
        vp.alertaspin('12331123', '1213212', '201201','15555555-6', 'test');
        
    }
 static testMethod void test4() {
       
         CONS_respuestaservicio_JSON   rt= new CONS_respuestaservicio_JSON();
           string Json = '{ "codigo": "99", "mensaje": "Ocurrió un error al ejecutar el servicio", "respuestaBase": { "codigo": "1", "mensaje": "Ingrese codigo de usuario valido", "nPropuesta": "0" }}';
          
          rt=CONS_respuestaservicio_JSON.parse(Json);
       
    }
}