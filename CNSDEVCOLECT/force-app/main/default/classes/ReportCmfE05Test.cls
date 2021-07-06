@isTest
private with sharing class ReportCmfE05Test {

    @testSetup
    private static void loadDataConfig(){
        TestFactorySales.populateOrg();
    }

    @isTest
    static void ReportCmfE05Test() {

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
        cas.Tipo_Auxiliar__c='Solicitud';
        cas.Subtipo__c='clave internet';
        cas.Subtipo_Auxiliar__c='Cierre Linea de credito';
        cas.Tipo_de_producto_banco__c='Tarjeta de Débito';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        
        insert cas;
       

        Test.startTest();
        List<Case> listCase=[SELECT CaseNumber, Tipo_de_producto_banco__c, Subtipo_Auxiliar__c, Rut_del_Cliente__c, Origin, CreatedDate 
                            FROM Case 
                            WHERE 
                                RecordTypeId=:RecordTypeId AND
                                Tipo_Auxiliar__c='Solicitud' AND 
                                (Tipo_de_producto_banco__c='Tarjeta de Crédito' OR
                                Tipo_de_producto_banco__c='Tarjeta de Débito' OR 
                                Tipo_de_producto_banco__c='Cuenta Corriente' OR 
                                Tipo_de_producto_banco__c='Línea de crédito' OR  
                                Tipo_de_producto_banco__c='Cuenta Vista' OR 
                                Tipo_de_producto_banco__c='Multiproducto') AND 
                                (Subtipo_Auxiliar__c = 'Cierre TC' OR 
                                Subtipo_Auxiliar__c = 'Cierre de cuenta Corriente' OR 
                                Subtipo_Auxiliar__c = 'Cierre Linea de credito' OR 
                                Subtipo_Auxiliar__c = 'Cierre de cuenta')];

        ReportCmfE05 reportE05Object = new ReportCmfE05(); 
        Database.QueryLocator ql = reportE05Object.start(null);
        reportE05Object.execute(null,listCase);
        reportE05Object.Finish(null);
        Test.stopTest();

    }

}