@isTest
public class CONS_SolicitudRescateTest {
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
        pc.RUT_intermediario_Nectia__c='15555555-6';
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
        cas.Description='Monto UF Cotizacion A: 582\n'+
            'Monto UF Deposito A: 582\n'+
            'Monto UF Cotizacion B: 582\n'+
            'Monto UF Cotizacion Voluntaria B: 582\n'+
            'Monto Peso Deposito B: 582\n'+
            'Monto UF Deposito B: 582\n'+
            'Monto Peso Deposito APV B: 582506\n'+
            'Monto UF Deposito APV B: 20.99997800883324\n'+
            'N° Origen: 0.0';
        cas.Rut__c='15555555-6';
        cas.Tipo_Rescate__c='2';
        cas.Monto_UF__c=11324;
        insert cas;
        
        //ApexPages.StandardController  astc=new ApexPages.StandardController(pc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_solicitudRescate'));
        System.currentPageReference().getParameters().put('id', cas.Id);
        CONS_SolicitudRescate CSR=new CONS_SolicitudRescate();
        CSR.solicitud_rescate();
        CSR.continuar();
        
    }
    
    static testMethod void test1() {
        CONS_RespuestaRecalcular_JSON  RR=new CONS_RespuestaRecalcular_JSON();
        string json ='{"codigo":0,"mensaje":"test"}';
        CONS_RespuestaRecalcular_JSON.parse(json);
    }
      
      static testMethod void test2() {
        CONS_RescateSolicitud_JSON  Rs=new CONS_RescateSolicitud_JSON();
        string json ='{"codigo":0,"mensaje":"test"}';
        CONS_RescateSolicitud_JSON.parse(json);
    }
    
}