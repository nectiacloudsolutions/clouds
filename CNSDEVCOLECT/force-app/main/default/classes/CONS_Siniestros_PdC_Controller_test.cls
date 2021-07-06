@isTest
private class CONS_Siniestros_PdC_Controller_test {

	/*@isTest static void test_method_one() {

		Id rtcp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();

		Account cuenta = new Account();
		cuenta.FirstName = 'cuenta';
		cuenta.LastName = 'cuenta';
		cuenta.RUT__c = '14381623-0';
		cuenta.RecordTypeId = rtcp;
		insert cuenta;

		Producto_de_Seguros__c PdS = new Producto_de_Seguros__c();
		PdS.Name = 'prod seguro';
		PdS.Codigo_de_Producto_nectia__c = '1000';
		insert PdS;

		Producto_del_Cliente__c PdC = new Producto_del_Cliente__c();
		PdC.Name = 'prod cliente';
		PdC.Producto_de_Seguros_Nectia__c = PdS.Id;
		PdC.Cliente_Nectia__c = cuenta.Id;
		PdC.Id__c = '1234514381623-0';
		PdC.Poliza_Nectia__c = '12345';
		PdC.Esquema_Nectia__c = 'INSUDB';
		PdC.Tipo_Registro_Nectia__c = '2';
		PdC.Ramo_Nectia__c = '1';
		PdC.Codigo_Plan_Nectia__c = '650';
		PdC.Numero_Certificado_Nectia__c = '0';
		insert PdC;

		ApexPages.StandardController siniestrosPdC = new ApexPages.StandardController(PdC);
		Test.setCurrentPageReference(new PageReference('Page.CONS_Siniestros_Producto_Cliente'));
		System.currentPageReference().getParameters().put('id',Pdc.Id);
		CONS_Siniestros_PdC_Controller pdcController = new CONS_Siniestros_PdC_Controller(siniestrosPdC);
	}*/

	@isTest static void test_method_two() {

		Id rtcp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();

		Account cuenta = new Account();
		cuenta.FirstName = 'cuenta';
		cuenta.LastName = 'cuenta';
		cuenta.RUT__c = '14381623-0';
		cuenta.RecordTypeId = rtcp;
		insert cuenta;

		Producto_de_Seguros__c PdS = new Producto_de_Seguros__c();
		PdS.Name = 'prod seguro';
		PdS.Codigo_de_Producto_nectia__c = '1000';
		insert PdS;

		Producto_del_Cliente__c PdC = new Producto_del_Cliente__c();
		PdC.Name = 'prod cliente';
		PdC.Producto_de_Seguros_Nectia__c = PdS.Id;
		PdC.Cliente_Nectia__c = cuenta.Id;
		PdC.Id__c = '1234514381623-0';
		PdC.Poliza_Nectia__c = '12345';
		PdC.Esquema_Nectia__c = 'CLONINSUDB';
		PdC.Tipo_Registro_Nectia__c = '2';
		PdC.Ramo_Nectia__c = '9';
		PdC.Codigo_Plan_Nectia__c = '29';
		PdC.Numero_Certificado_Nectia__c = '0';
		insert PdC;

		ApexPages.StandardController siniestrosPdC = new ApexPages.StandardController(PdC);
		Test.setCurrentPageReference(new PageReference('Page.CONS_Siniestros_Producto_Cliente'));
		System.currentPageReference().getParameters().put('id',Pdc.Id);
		CONS_Siniestros_PdC_Controller pdcController = new CONS_Siniestros_PdC_Controller(siniestrosPdC);
pdcController.listar_vida_o_life();
	}
}