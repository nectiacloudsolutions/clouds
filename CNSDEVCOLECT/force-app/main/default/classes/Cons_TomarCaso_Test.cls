@isTest(SeeAllData = false)
public class Cons_TomarCaso_Test {
	
	static testMethod void TestTomarCaso(){

		Id rt_Cuenta = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cliente Persona Seguros').getRecordTypeId();
		Id rt_Caso = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Seguros - Solicitud').getRecordTypeId();

		Profile p = [SELECT Id FROM Profile WHERE Name = 'Ejecutivos de Atención al Cliente Seguros Remoto'];


        User usr = new User();
	        usr.Alias = 'standt1';
	        usr.Email = 'standarduser1@testorg.com';
	        usr.EmailEncodingKey = 'UTF-8';
	        usr.FirstName = 'User 1';
	        usr.LastName = 'Testing 1';
	        usr.LanguageLocaleKey = 'en_US';
	        usr.LocaleSidKey = 'en_US';
	        usr.ProfileId = p.Id;
	        usr.TimeZoneSidKey = 'America/Los_Angeles';
	        usr.UserName = 'correo1@mail.cl';
        insert usr;

        User usr2 = new User();
	        usr2.Alias = 'standt2';
	        usr2.Email = 'standarduser2@testorg.com';
	        usr2.EmailEncodingKey = 'UTF-8';
	        usr2.FirstName = 'User 2';
	        usr2.LastName = 'Testing 2';
	        usr2.LanguageLocaleKey = 'en_US';
	        usr2.LocaleSidKey = 'en_US';
	        usr2.ProfileId = p.Id;
	        usr2.TimeZoneSidKey = 'America/Los_Angeles';
	        usr2.UserName = 'correo2@mail.cl';
        insert usr2;

		Account a = new Account();
			a.FirstName = 'Name';
			a.LastName = 'Account';
			a.Tipo_de_documento_de_identidad__c = 'RUT';
			a.RUT__c = '44444444-4';
			a.RecordTypeId = rt_Cuenta;
		insert a;

		Case c = new Case();
		c.AccountId = a.Id;
		c.Status = 'En proceso';
		c.Type = 'Solicitud';
		c.Subtipo__c = 'Solicitud de Documento';
		c.RecordTypeId = rt_Caso;
		c.OwnerId = usr.Id;

		insert c;
		
		test.startTest();

			PageReference pageRef = Page.Cons_TomarCaso_VF;
			Test.setCurrentPage(pageRef);
			pageRef.getParameters().put('id',c.id);
			ApexPages.StandardController sc = new ApexPages.standardController(c);
			Cons_TomarCaso tc = new Cons_TomarCaso(sc);
			tc.redirige();
			tc.volver();

		test.stopTest();

	}
}