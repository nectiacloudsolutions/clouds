@isTest
public class CONS_FormularioActDatosControllerTest {
	static testMethod void TestFormulario() {
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
        
        ApexPages.StandardController  astc = new ApexPages.StandardController(cas);
		Test.setCurrentPageReference(new PageReference('Page.CONS_FormularioActDatos'));
		System.currentPageReference().getParameters().put('id', cas.Id);
		CONS_FormularioActDatosController actF4 = new CONS_FormularioActDatosController();
		//CONS_FormularioActDatosController actF4 = new CONS_FormularioActDatosController(new ApexPages.StandardController(cas));

    }
}