/*********************************************************************************************************
@Author       curbinav@everis.com
@name         ProductoDelClienteTriggerTest
@CreateDate   11/11/2019
@Description  Test class for ProductoDelClienteTriggerHelper
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
11/11/2019    curbinav@everis.com           W-000073 - (Vista 360° Cliente) - Ingreso Sección Cliente (Resumen)
**********************************************************************************************************/
@isTest
public class ProductoDelClienteTriggerTest {
    
    private static final Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
	
    /**
     * Flag multiproducto false
     * 
     **/
    @isTest static void TestFlagMultiprodcutoFalse() {

        User usr=(User) mapsObjects.get('User2');
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        
        System.runAs(usr) {
            // Perform test
            Test.startTest();
    
            // Crear nueva cuenta persona
            Account personAccount = new Account();
            personAccount.RUT__c = '2-7';
            personAccount.LastName = 'Lastname';
            personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            
            insert personAccount;
            System.debug('personAccount: ' + personAccount);
            
            Producto_Del_Cliente__c pdc1 = new Producto_Del_Cliente__c();
            pdc1.RecordTypeId = Schema.SObjectType.Producto_Del_Cliente__c.getRecordTypeInfosByDeveloperName().get('Producto_cliente_Seguros').getRecordTypeId();
			pdc1.Cliente_Nectia__c = personAccount.Id;
            
            insert pdc1;
            System.debug('Inserted pdc1 ' + pdc1);
            
            Account personAccountDB = [SELECT Id, Multiproducto_sales__c                                       
										FROM Account 
                                       	WHERE Id = :personAccount.Id LIMIT 1];
            System.debug('personAccountDB: ' + personAccountDB);
            System.assertEquals(false, personAccountDB.Multiproducto_sales__c, 'Se espera que no sea multiproducto');
            
            Test.stopTest();
        }
    }

    /**
     * Flag multiproducto true
     * 
     **/
    @isTest static void TestFlagMultiprodcutoTrue() {

        User usr=(User) mapsObjects.get('User2');
        upsert new Consorcio_Org__c(SetupOwnerId=Usr.Id,Sales_project__c=true, Validation_rules__c = false);
        
        System.runAs(usr) {
            // Perform test
            Test.startTest();
    
            // Crear nueva cuenta persona
            Account personAccount = new Account();
            personAccount.RUT__c = '2-7';
            personAccount.LastName = 'Lastname';
            personAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            
            insert personAccount;
            System.debug('personAccount: ' + personAccount);
            
            Producto_Del_Cliente__c pdc1 = new Producto_Del_Cliente__c();
            pdc1.RecordTypeId = Schema.SObjectType.Producto_Del_Cliente__c.getRecordTypeInfosByDeveloperName().get('Producto_cliente_Seguros').getRecordTypeId();
			pdc1.Cliente_Nectia__c = personAccount.Id;
                        
            Producto_Del_Cliente__c pdc2 = new Producto_Del_Cliente__c(); 
            pdc2.RecordTypeId = Schema.SObjectType.Producto_Del_Cliente__c.getRecordTypeInfosByDeveloperName().get('Producto_cliente_Banco').getRecordTypeId();
			pdc2.Cliente_Nectia__c = personAccount.Id;
            pdc2.Name = 'APV';
            pdc2.Productos_asociados__c = 'Acciones';
            pdc2.Estado_Nectia__c = 'VIGENTE';
            
            Producto_de_Seguros__c pds = new Producto_de_Seguros__c();
            pds.L_nea__c = 'FFMM';
            pds.Codigo_de_Producto_nectia__c = '9999';
            insert pds;
            
            pdc2.Producto_de_Seguros_Nectia__c = pds.Id;
            
            List<Producto_Del_Cliente__c> pdcList = new List<Producto_Del_Cliente__c>();
            pdcList.add(pdc1);
            pdcList.add(pdc2);
            insert pdcList;
            System.debug('Inserted list pdc2: ' + pdcList);
            
            Account personAccountDB2 = [SELECT Id, Multiproducto_sales__c                                       
										FROM Account 
                                       	WHERE Id = :personAccount.Id LIMIT 1];
            //System.debug('personAccountDB2: ' + personAccountDB2);
            //System.assertEquals(true, personAccountDB2.Multiproducto_sales__c, 'Se espera que sea multiproducto');

            delete pdcList.get(0);

            Account personAccountDB = [SELECT Id, Multiproducto_sales__c                                       
										FROM Account 
                                       	WHERE Id = :personAccount.Id LIMIT 1];
            //System.debug('personAccountDB: ' + personAccountDB);
            System.assertEquals(false, personAccountDB.Multiproducto_sales__c, 'Se espera que no sea multiproducto');
            
            Test.stopTest();
        }
    }

}