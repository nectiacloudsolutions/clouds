/**
 * @description       : 
 * @author            : pcelisbe@everis.com
 * @group             : 
 * @last modified on  : 09-22-2020
 * @last modified by  : pcelisbe@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   09-17-2020   pcelisbe@everis.com   Initial Version
**/
@isTest
public with sharing class CloseQuoteService_Test {
    @testSetup
    public static void insertOpp() {
            //Create user
            User u2 = new User();
            u2.firstName = 'Ejecutivo 2';
            u2.LastName = 'Sales2';
            u2.RUT__c = '88136454';
            u2.Email = 'ejecutivo2@consorcio.cl';
            u2.CompanyName = 'Consorcio Seguros';
            u2.Department = 'Adm. Funcional CRM';
            u2.Alias =  'test2';                    
            u2.UserName =  'ejecutivo2@consorcio.cl.devsales';            
            u2.CommunityNickname =  'ejecutivo2@consorcio.cl.devsales';
            u2.LocaleSidKey = 'es_CL';
            u2.EmailEncodingKey = 'ISO-8859-1';            
            u2.LanguageLocaleKey = 'en_US';
            u2.TimeZoneSidKey = 'America/Santiago';
            u2.isActive = true;
            u2.ProfileID = [SELECT Id,Name FROM Profile WHERE Name='Ejecutivo de Venta' LIMIT 1].Id;
            insert u2;
            //Create a new Account
            Account acc1 = new Account();
            acc1.FirstName = 'ACCOUNT1 ';
            acc1.LastName = 'DUMMY SALES';
            acc1.RUT__c = '19375874-6';
            acc1.PersonOtherPhone = '95671734';
            acc1.PersonEmail='Dummy@test.cl';
            acc1.PersonMobilePhone='66666666';
            acc1.Phone = '999999999';
            acc1.Tipo_de_documento_de_identidad__c = 'RUT';
            insert acc1;

            Opportunity opp3 = new Opportunity();
            opp3.CloseDate=date.today();
            opp3.AccountId = acc1.id;
            opp3.Name='Opportunity Test Auto Cotizador';
            opp3.RecordTypeId=[SELECT Id FROM RecordType WHERE developerName='Sales_Seguros_Auto' LIMIT 1].Id;
            opp3.StageName='Cotización';
        	opp3.OwnerId=u2.id;
            insert opp3;

            Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true );
            insert pb;
            Product2 p3 = new Product2();
            p3.IsActive = true;
            p3.ProductCode = '2';
            p3.Name = 'TestStandard';
            p3.codigo_producto_sales__c= '2';
            p3.Codigo_Macroproducto_Operacional_sales__c='1';
            p3.tipo_producto_sales__c = 'Sales_Opp_Seguro_Vida_Standard';
            insert p3;

            PricebookEntry pbe=new PricebookEntry(unitprice=0.01,Product2Id=p3.Id, Pricebook2Id=Test.getStandardPricebookId(), IsActive= true); 
            insert pbe;   
 			PricebookEntry customprice = new pricebookentry( product2id = p3.Id, pricebook2id = pb.id,UnitPrice=50, usestandardprice = false, IsActive = true);
       		insert customprice;
            Quote q= new Quote ();
        	q.Name= 'Testq';
        	q.OpportunityId= opp3.id;
        	q.OwnerId=u2.Id;
        	q.BillingStreet= '123';
        	q.BillingCity= 'City';
        	q.BillingPostalCode= '12345';
        	q.Numero_de_Cotizacion_sales__c='9999';
            q.Pricebook2Id= pb.id;
            q.RecordTypeId=[SELECT Id FROM RecordType WHERE developerName='Sales_Seguros_Auto_Cotizador' LIMIT 1].Id;
        	insert q;
        
        
         	QuoteLineItem qli = new QuoteLineItem();
            qli.QuoteId = q.Id;
            qli.PricebookEntryId = customprice.Id;
            qli.Quantity = 1;
            qli.UnitPrice = 1;
            insert qli;

       

	}
    @isTest static void updateQuoteTest() {
        Quote myQuote =[SELECT id,Numero_de_Cotizacion_sales__c FROM Quote LIMIT 1];
        string json=('{"cuota_uf_sales__c":10,"Numero_de_Cotizacion_sales__c":"'+myQuote.Numero_de_Cotizacion_sales__c+'","Numero_de_Propuesta_sales__c":"2343232","Tarifa_Anual_UF_sales__c":10,"tipo_traspaso_sales__c":"Automático","etapa_cotizador_sales__c":"1"}');
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestUri ='/services/apexrest/quote/update/'+myQuote.Numero_de_Cotizacion_sales__c;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestContext.response=response;
        
		Test.startTest();  
        CloseQuoteService.updateQuote();
        Test.stopTest();
        
        System.assertEquals(response.statusCode,200);

    }
    

}