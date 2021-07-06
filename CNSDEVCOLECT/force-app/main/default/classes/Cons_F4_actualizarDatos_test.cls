@isTest(SeeAllData = false)
public class Cons_F4_actualizarDatos_test {
	
	static testMethod void Cons_F4_actualizarDatos_test(){

		Id rtps = [SELECT id FROM RecordType WHERE Name =: 'Producto cliente Seguros'].id;
		Id rtcp = [SELECT id FROM RecordType WHERE Name =: 'Cliente Persona Seguros'].id;
		
		Account a = new Account();
		a.FirstName = 'Cliente';
		a.LastName = 'Test';
		a.Phone = '+569123123123';
		a.PersonEmail = 'mimail@mimail.cl';
		a.ShippingStreet = 'Calle Falsa 123';
		a.ShippingCity = 'Santiago';
		a.ShippingState = 'Santiago';
		a.ShippingPostalCode = '8320000';
		a.RUT__c = '16213371-3';
		a.RecordTypeId = rtcp;

		insert a;

		ApexPages.StandardController  astc = new ApexPages.StandardController(a);
		Test.setCurrentPageReference(new PageReference('Page.Cons_F4_actualizarDatos'));
		System.currentPageReference().getParameters().put('id', a.Id);
		Cons_F4_actualizarDatos actF4 = new Cons_F4_actualizarDatos(astc);

		actF4.c.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
		actF4.c.AccountId = a.Id;
		actF4.c.Description = 'test';
		actF4.enviarDatos();
	}

	static testMethod void Cons_F4_actualizarDatos_test2(){

		Id rtps = [SELECT id FROM RecordType WHERE Name =: 'Producto cliente Seguros'].id;
		Id rtcp = [SELECT id FROM RecordType WHERE Name =: 'Cliente Persona Seguros'].id;
		
		Account a = new Account();
		a.FirstName = 'Cliente';
		a.LastName = 'Test';
		a.Phone = '+569123123123';
		a.PersonEmail = 'mimail@mimail.cl';
		a.ShippingStreet = 'Calle Falsa 123';
		a.ShippingCity = 'Santiago';
		a.ShippingState = 'Santiago';
		a.ShippingPostalCode = '8320000';
		a.RUT__c = '16213371-3';
		a.RecordTypeId = rtcp;

		insert a;

		ApexPages.StandardController  astc = new ApexPages.StandardController(a);
		Test.setCurrentPageReference(new PageReference('Page.Cons_F4_actualizarDatos'));
		System.currentPageReference().getParameters().put('id', a.Id);
		Cons_F4_actualizarDatos actF4 = new Cons_F4_actualizarDatos(astc);

		actF4.c.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
		actF4.c.AccountId = a.Id;
		actF4.c.Description = 'test';
		actF4.c.Nombre_calle__c = 'nueva calle';
		actF4.c.Numero_piso__c = '123';
		actF4.enviarDatos();
	}

	static testMethod void Cons_F4_actualizarDatos_test3(){

		Id rtps = [SELECT id FROM RecordType WHERE Name =: 'Producto cliente Seguros'].id;
		Id rtcp = [SELECT id FROM RecordType WHERE Name =: 'Cliente Persona Seguros'].id;
		
		Account a = new Account();
		a.FirstName = 'Cliente';
		a.LastName = 'Test';
		a.Phone = '+569123123123';
		a.PersonEmail = 'mimail@mimail.cl';
		a.ShippingStreet = 'Calle Falsa 123';
		a.ShippingCity = 'Santiago';
		a.ShippingState = 'Santiago';
		a.ShippingPostalCode = '8320000';
		a.RUT__c = '16213371-3';
		a.RecordTypeId = rtcp;

		insert a;

		ApexPages.StandardController  astc = new ApexPages.StandardController(a);
		Test.setCurrentPageReference(new PageReference('Page.Cons_F4_actualizarDatos'));
		System.currentPageReference().getParameters().put('id', a.Id);
		Cons_F4_actualizarDatos actF4 = new Cons_F4_actualizarDatos(astc);

		actF4.c.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
		actF4.c.AccountId = a.Id;
		actF4.c.Description = 'test';
		actF4.c.Otro_telefono__c = '1234567';
		actF4.c.Telefono_movil__c = '1234567';
		actF4.enviarDatos();
	}
}