@isTest
private with sharing class ReportCmfE04Test {

    @isTest
    static void ReportCmfE04Test() {

        String RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Casos_Banco').getRecordTypeId();
        Id rtcp = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuentas Corporativas').getRecordTypeId();

		account ac=new account();
     	ac.Name='test';
     	ac.RUT__c='123';

     	insert ac;
  		Contact con=new Contact();
        con.LastName='test';
        con.AccountId=ac.id;
        con.Email='test@test.cl';
        insert con;
    	
        Case cas=new Case();
        cas.RecordTypeId=RecordTypeId;
        cas.Accountid=ac.id;
        cas.ContactId = con.Id;
        cas.Rut_del_Cliente__c='1233424';
        cas.Status='En proceso';
        cas.Type='Reclamo';
        cas.Tipo_Auxiliar__c='Reclamo';
        cas.Subtipo__c='clave internet';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        
        insert cas;
        
        List<Case> listCase=[SELECT  CaseNumber, Rut_del_Cliente__c, Origin, CreatedDate, ClosedDate, Clasificaci_n_SBIF_nectia__c 
                            FROM Case 
                            WHERE 
                                RecordTypeId=:RecordTypeId AND
                                Tipo_Auxiliar__c='Reclamo'
                                ];

        Test.startTest();
        ReportCmfE04 reportE04Object = new ReportCmfE04(); 
        Database.QueryLocator ql = reportE04Object.start(null);
        reportE04Object.execute(null,listCase);
        reportE04Object.Finish(null);
        Test.stopTest();

    }

}