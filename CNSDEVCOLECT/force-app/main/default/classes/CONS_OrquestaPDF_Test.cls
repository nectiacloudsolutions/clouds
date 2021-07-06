@isTest
private class CONS_OrquestaPDF_Test {
	
	@isTest static void test_method_one() {

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

		String recordTypeIdPdC = Schema.getGlobalDescribe().get('Producto_del_Cliente__c').getDescribe().getRecordTypeInfosByName().get('Producto cliente Seguros').getRecordTypeId();
		Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
		pc.RecordTypeId= recordTypeIdPdC;
		pc.Cliente_Nectia__c=acc.id;
		pc.Producto_de_Seguros_Nectia__c=pds.id;
		pc.Name='Renta Vitalicia';
		pc.Id__c='12345678901';
		pc.Ramo_Nectia__c='05';
		pc.Codigo_Plan_Nectia__c='360';
		pc.Poliza_Nectia__c='12132413';
		pc.Esquema_Nectia__c='INSUDB';
		insert pc;

		String recordTypeIdCaso = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('Casos Seguros').getRecordTypeId();
		Case cas=new Case();
		cas.RecordTypeId= recordTypeIdCaso;
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
		Test.setCurrentPageReference(new PageReference('Page.CONS_OrquestaPDF'));
		System.currentPageReference().getParameters().put('id', cas.Id);
		CONS_OrquestaPDF actF4 = new CONS_OrquestaPDF();
		actF4.generador();
	}

	@isTest static void test_method_two() {

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

		String recordTypeIdPdC = Schema.getGlobalDescribe().get('Producto_del_Cliente__c').getDescribe().getRecordTypeInfosByName().get('Producto cliente Seguros').getRecordTypeId();
		Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
		pc.RecordTypeId= recordTypeIdPdC;
		pc.Cliente_Nectia__c=acc.id;
		pc.Producto_de_Seguros_Nectia__c=pds.id;
		pc.Name='Renta Vitalicia';
		pc.Id__c='12345678901';
		pc.Ramo_Nectia__c='05';
		pc.Codigo_Plan_Nectia__c='360';
		pc.Poliza_Nectia__c='12132413';
		pc.Esquema_Nectia__c='INSUDB';
		insert pc;

		String recordTypeIdCaso = Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosByName().get('Casos Seguros').getRecordTypeId();
		Case cas=new Case();
		cas.RecordTypeId= recordTypeIdCaso;
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
		Test.setCurrentPageReference(new PageReference('Page.CONS_OrquestaPDF'));
		System.currentPageReference().getParameters().put('id', cas.Id);
		CONS_OrquestaPDF actF4 = new CONS_OrquestaPDF();
		actF4.volver();

	}
	
}