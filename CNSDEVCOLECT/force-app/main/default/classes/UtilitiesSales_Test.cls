/**
 * @File Name          : UtilitiesSales_Test.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 09-01-2020 11:11:18
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    09-01-2020   eayalcor@everis.com     Initial Version
**/

@isTest
public class UtilitiesSales_Test {
    
    /**
      * @description       This method tests the functionality of the validateSingleRUT method in the UtilitiesSales class
      * @param1            
      * @return            void
      * @throws            NA
    */
    
    @isTest static void validateSingleRUT_Test(){
        
               
        String rutprueba = '9669258-7';
        String rutprueba2= '18137691-0';
        String rutprueba3 = '10854082-6';
        String rutprueba4 = null;
        
        Lead lead = TestFactorySales.createNewLead(rutprueba3, '9669258-7', 'ejemplo');
        lead.sla_sales__c = datetime.now();
        update lead;
		Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
		Account acc = (Account) mapsObjects.get('Account');  
        User usr = (User)mapsObjects.get('User2');  
        
        System.runAs(usr){
           
       		Test.startTest();
            string variablep = UtilitiesSales.validateSingleRUT(rutprueba);
            string variable2 = UtilitiesSales.validateSingleRUT(rutprueba2);
            string variable3 = UtilitiesSales.validateSingleRUT(rutprueba3);
            string variable4 = UtilitiesSales.validateSingleRUT(rutprueba4);
         	
            Test.stopTest();
            System.assertEquals(variable3,acc.id);
            System.assertEquals(null, variable2);
            System.assertEquals(null, variable4);        
        }  
        
    }
    
    /**
      * @description       This method tests the functionality of the validarRunRut method in the UtilitiesSales class
      * @param1            
      * @return            void
      * @throws            NA
    */
    
    @isTest static void validarRunRutTest(){
        string rutprueba = '20026661-7';
        String rutt = '18.137.691-0';
        String rutt1 = '18137691-9';
        string rut = '00000000-0';
        string rutK = '7755002-K';
        string rutnada = '';
        string rutmalo ='2';
        string rutnull = null;
        
        System.assert( UtilitiesSales.validarRunRut(rutprueba));
        System.assert( !(UtilitiesSales.validarRunRut(rutt)));
        System.assert( !(UtilitiesSales.validarRunRut(rutt1)));
        System.assert( UtilitiesSales.validarRunRut(rut));
        System.assert( UtilitiesSales.validarRunRut(rutK));
        System.assert( !(UtilitiesSales.validarRunRut(rutnada)));
        System.assert( !(UtilitiesSales.validarRunRut(rutmalo)));
    }
    
    /**
      * @description       This method tests the functionality of the existAccountLead method in the UtilitiesSales class
      * @param1            
      * @return            void
      * @throws            NA
    */
    
    @isTest static void existAccountLeadTest(){
        TestFactorySales.populateOrg();
        
        Set<String> s1 = new Set<String>();
        s1.add('9669258-7');
        //s1.add('00000000-0');
        
        Map<String,List<SObject>> mapObject = UtilitiesSales.existAccountLead(s1);
        List<Lead> led= mapObject.get('Lead');    
        System.assertEquals('9669258-7',led.get(0).numero_de_documento_sales__c );
 
    }
    
      /**
      * @description       This method tests the functionality of the getIdsExecutive method in the UtilitiesSales class
      * @param1            
      * @return            void
      * @throws            NA
    */
    
    @isTest static void getIdsExecutiveTest(){
        Test.startTest();
        TestFactorySales.populateOrg();
        Set<String> s1 = new Set<String>();
        String rut = '1-9';
        String rut2 = '18137691-0';
        s1.add(rut2.remove('-'));
        s1.add(rut.remove('-'));
        Map<String,Id> maps = UtilitiesSales.getIdsExecutive(s1);
        Test.stopTest();
        System.assertEquals(maps.size(),1);      
    }
    
    /**
      * @description       This method tests the evaluateRequiredDataLead method in the UtilitiesSales Class
      * @param1            
      * @return            void
      * @throws            NA
    */
    @isTest static void evaluateRequiredDataLeadTest(){

        Test.startTest();
        /* VALIDATE ERROR_RUTEXECUTIVE */ 
        Lead lead = TestFactorySales.createNewLead('18137691-0', '1-9', 'ejemplo');
        lead.sla_sales__c = datetime.now();
        lead.rut_ejecutivo_sales__c='';
        
        /* VALIDATE ERROR_SLA */
        Lead lead2 = TestFactorySales.createNewLead('9669258-7', '1-9', 'ejemplo');
        lead2.sla_sales__c = null;
        
        /* VALIDATE 08-ERROR_RATING */
        Lead lead3 = TestFactorySales.createNewLead('7755002-K', '88136454', 'ejemplo');
        lead3.Phone = '233';
        lead3.sla_sales__c = datetime.now();
        lead3.other_phone_sales__c='222222';
        lead3.Email= 'hola@gmail.com';
        lead3.sla_sales__c = datetime.now();
        
        /* VALIDATE ERROR_DATACONTACT */ 
        Lead lead4 = TestFactorySales.createNewLead('17678241-2', '1-9', 'ejemplo');
 		lead4.Phone = '';
        lead4.other_phone_sales__c='';
        lead4.Email= '';
        
        /* VALIDATE 08-ERROR_LEADSOURCE */
        Lead lead5 = TestFactorySales.createNewLead('22372807-3', '88136454', 'ejemplo');
        lead5.Phone = '233';
        lead5.sla_sales__c = datetime.now();
        lead5.other_phone_sales__c='222222';
        lead5.Email= 'holaasdfprueba@gmail.com';
        lead5.sla_sales__c = datetime.now();
        lead5.Rating = 'Alta';
        
        
        /* VALIDATE 09-ERROR_FORMATRUT */
		Lead lead6 = TestFactorySales.createNewLead('00000000-3', '88136454', 'ejemplo');
        lead6.Phone = '233';
        lead6.sla_sales__c = datetime.now();
        lead6.other_phone_sales__c='2222222';
        lead6.Email= 'hola1@gmail.com';
        lead6.sla_sales__c = datetime.now();
        lead6.LeadSource = 'Analytics';
        lead6.Rating = 'Alta';
        
		Lead lead7 = new Lead();
        lead7.rut_ejecutivo_sales__c = '1-9';
        lead7.numero_de_documento_sales__c = '18082489-8';
        lead.LastName = null;
        lead7.Phone = '2333';
        lead7.sla_sales__c = datetime.now();
        lead7.other_phone_sales__c='22222222';
        lead7.Email= 'hola12@gmail.com';
        lead7.sla_sales__c = datetime.now();
        lead7.LeadSource = 'Analytics';
        lead7.Rating = 'Alta';
        
        Lead lead8 = TestFactorySales.createNewLead('9836545-1', '88136454', 'ejemplo');
        lead8.Phone = '233';
        lead8.sla_sales__c = datetime.now();
        lead8.other_phone_sales__c='222222';
        lead8.Email= 'holaasdfprueba@gmail.com';
        lead8.sla_sales__c = datetime.now();
        lead8.LeadSource = 'Analytics';
        lead8.Rating = 'Alta';
        
        UtilitiesSales.ValidateData usvd  = UtilitiesSales.evaluateRequiredDataLead(lead);
        UtilitiesSales.ValidateData usvd2 = UtilitiesSales.evaluateRequiredDataLead(lead2);
        UtilitiesSales.ValidateData usvd3 = UtilitiesSales.evaluateRequiredDataLead(lead3);
        UtilitiesSales.ValidateData usvd4 = UtilitiesSales.evaluateRequiredDataLead(lead4);
        UtilitiesSales.ValidateData usvd5 = UtilitiesSales.evaluateRequiredDataLead(lead5);
        UtilitiesSales.ValidateData usvd6 = UtilitiesSales.evaluateRequiredDataLead(lead6);
        UtilitiesSales.ValidateData usvd7 = UtilitiesSales.evaluateRequiredDataLead(lead7);
        UtilitiesSales.ValidateData usvd8 = UtilitiesSales.evaluateRequiredDataLead(lead8);
        
        
        Test.stopTest();
 
        System.assertEquals(usvd.error,  'ERROR_RUTEXECUTIVE');
        System.assertEquals(usvd2.error, 'ERROR_SLA');
        System.assertEquals(usvd3.error, 'ERROR_RATING');
        System.assertEquals(usvd4.error, 'ERROR_DATACONTACT');
        System.assertEquals(usvd5.error, 'ERROR_LEADSOURCE');
        System.assertEquals(usvd6.error, 'ERROR_FORMATRUT');
        System.assertEquals(usvd7.error, 'ERROR_LASTNAME');
        System.assertEquals(usvd8.error, 'OK');
       
    }
    
     /**
      * @description       This method tests the changeLeadOwner method in the UtilitiesSales Class
      * @param1            
      * @return            void
      * @throws            NA
    */
    @isTest static void changeLeadOwnerTest(){         
		Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        User usr = (User)mapsObjects.get('User'); 
        User usr2 = (User)mapsObjects.get('User2');  
        Lead ld = (Lead) mapsObjects.get('Lead');
        Lead lead =new Lead(rut_ejecutivo_sales__c ='1-9');
        lead.Phone='9999';
        lead.LastName='ej';    
              
        ld.OwnerId = usr.Id;
        
        System.runAs(usr){           
            Test.startTest();
            insert lead;			
           	Test.stopTest(); 
            System.assert(UtilitiesSales.changeLeadOwner(lead.Id, usr.Id));              
        }  
    }
    
    /**
      * @description       This method tests the formatRut method in the UtilitiesSales Class
      * @param1            
      * @return            void
      * @throws            NA
    */
    @isTest static void formatRutTest(){   
      
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
	    User usr=(User) mapsObjects.get('User2');        

        System.runAs(usr){           
            Test.startTest();
            System.assertEquals('9.669.258-7',UtilitiesSales.formatRut('9669258-7','WITHDOT'));
  
           System.assertEquals(null,UtilitiesSales.formatRut('','test'));
           	Test.stopTest();                 
        } 
        
    }
    
    /**
      * @description       This method tests the getLeadByIds method in the UtilitiesSales Class
      * @param1            
      * @return            void
      * @throws            NA
    */
    @isTest static void getLeadByIdsTest(){
              
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        User usr=(User) mapsObjects.get('User2'); 
       
       
        Lead lead = (lead) mapsObjects.get('Lead');
        Lead lead2 = TestFactorySales.createNewLead('17678241-2', '1-9', 'ejemplo');
        //
        List<Id> lista = new List<Id>();
        lista.add(lead.Id);
        lista.add(lead2.Id);
        List<Lead> leadsList = (List<Lead>)UtilitiesSales.getLeadByIds(lista);
        System.assertEquals(lista.get(0), leadsList.get(0).Id);          
    }
    
    /**
      * @description       This method tests the autoConvertLead method in the UtilitiesSales Class
      * @param1            
      * @return            void
      * @throws            NA
    */
    @isTest static void autoConvertLeadTest(){   
        test.startTest();
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        User usr=(User) mapsObjects.get('User2');
        Lead lead = (lead) mapsObjects.get('Lead');
        //
        List<Id> lista = new List<Id>();
        lista.add(lead.Id);
        System.runAs(usr){  
        List<Database.LeadConvertResult> lcr = UtilitiesSales.autoConvertLead(lista);
         for(Database.LeadConvertResult lctemp: lcr){
             System.assertEquals(lead.Id,lctemp.getLeadId());
        }
        test.stopTest(); 
        }
    }

    /**
      * @description       Test Method for getProduct2ByQuoteId
      * @param1            
      * @return            void
      * @throws            NA
    */
    @isTest static void getProduct2ByQuoteIdTest(){   
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();       
        Account acc = (Account)mpsObjects.get('Account');
        Id idProd2 = Test.getStandardPricebookId(); 
        User user = (User)mpsObjects.get('User');
        Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,user.Id);
        Quote qte = (Quote)mpsOppObjects.get('Quote');
        
        
        System.runAs(user){
          Test.startTest();
          List<Product2> lstPro2 = UtilitiesSales.getProduct2ByQuoteId(qte.Id);
          Test.stopTest();

          System.assertEquals(1, lstPro2.size());

        }
            
    }
    @isTest 
    static void getProduct(){  
        TestFactorySales.populateOrg();
        List<Product2> lstPro =[SELECT id,ProductCode,tipo_producto_sales__c FROM Product2];
        set<String> codPro=new set<String>();
        for(Product2 pr : lstPro){
            codPro.add(pr.ProductCode);
        }
        
        Map<String,Product2> mapsProduct = UtilitiesSales.getProduct(codPro);
        
        Integer mSize = mapsProduct.size();
        
		system.assert(mSize>0);

      
        
    }
    
    @isTest
    static void getPicklistDataAndgetDependentPicklistValues(){
        List<String> lstPick =UtilitiesSales.getPicklistData(Event.motivo_no_interesa_sales__c);
        Map<String,List<String>> mapDepent = UtilitiesSales.getDependentPicklistValues(Event.resultado_llamada_sales__c);
        
        System.assert(mapDepent.size()>0);
        System.assert(lstPick.size()>0);
        
    }
    
    /**
    * @description Tests the method notifyExecutive
    * @author fbizamam@everis.com | 21-02-2020 
    * @return void 
    **/
    @isTest static void notifyExecutiveTest(){
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        List<User> usr =[Select id from User where RUT__c ='19' LIMIT 1];
        List<Lead> lead =[Select id,FirstName,OwnerId from Lead where numero_de_documento_sales__c ='9669258-7' LIMIT 1];
        List<Account> acc =[Select id,FirstName,OwnerId from Account where RUT__c ='10854082-6' LIMIT 1];
        System.runAs(usr[0]){
            System.assert(UtilitiesSales.notifyExecutive( lead[0].Id));
            System.assert(UtilitiesSales.notifyExecutive( acc[0].Id));
            System.assert(!UtilitiesSales.notifyExecutive('00000000-0'));
         
        }    
    }
    
    /**
    * @description Tests the method notifyExecutive
    * @author fbizamam@everis.com | 21-02-2020 
    * @return void 
    **/
    @isTest static void getSpecifictRTypeOppTest(){
        Account acc = TestFactorySales.createNewAccount('2-7','Test New');
        Opportunity newOpp = new Opportunity();
        newOpp.StageName = Constants.PLAN_PLUS_STATUS_RECOPILACION;
        newOpp.CloseDate = Date.TODAY().addMonths(1);
        newOpp.Name = 'TESTOPPCUMBRES';
        newOpp.OwnerId = userinfo.getUserId();
        newOpp.AccountId = acc.Id;
        insert newOpp;
        

        
        Map<Id,String> mapRcd = UtilitiesSales.getSpecifictRTypeOpp(Constants.RECORDTYPES_BANCA);
        Id idRt = [SELECT Id FROM RecordType WHERE SobjectType =: Constants.OPPORTUNITY AND DeveloperName =: Constants.RECORDTYPE_BANCA_HIPOTECARIO].Id;
        
        System.assertEquals(Constants.RECORDTYPE_BANCA_HIPOTECARIO, mapRcd.get(idRt));
        
        Set<Id> lstIds = new Set<Id>();
        Id idOpp = [SELECT Id FROM Opportunity LIMIT 1].Id;
        lstIds.add(idOpp);
        Map<Id,Opportunity> mapOpp = UtilitiesSales.getOppByIds(lstIds);
        
        System.assertEquals(mapOpp.size(), 1);   
    }
    
    /**
    * @description test Class for the cleanRut Method
    * @author fbizamam@everis.com | 20-08-2020 
    * @param 
    * @return  
    **/
    @isTest static void cleanRutTest(){
        system.assertEquals('181376910',UtilitiesSales.cleanRut('18137691-0'));
        system.assertEquals('181376910', UtilitiesSales.cleanRut('181376910'));
    }
    @isTest static void getRutExcecutiveWithDotTest(){
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        List<User> usr =[Select Id,Rut__c from User where RUT__c ='19' LIMIT 1];
      
        String r = UtilitiesSales.getRutExecutiveWithDot(usr[0].Id, CONSTANTS.WITHDOT);
        system.debug(r);
        system.assertEquals(usr[0].RUT__c, UtilitiesSales.cleanRut(r));

    }
    
    @isTest static void getRutByIdExecutiveTest(){
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        List<User> usr =[Select Id,RUT__c from User where RUT__c ='19' LIMIT 1];
        Set<Id> ids = new Set<Id>();
        ids.add(usr[0].Id);
        Map<String,String> mapi = new Map<String,String>();
        mapi = UtilitiesSales.getRutByIdExecutive(ids);
        System.assertEquals(usr[0].Rut__c, UtilitiesSales.cleanRut(mapi.get(usr[0].Id)));
    }
    
    @isTest static void getCaseFieldNotifyTest(){
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        List<User> usr =[Select Id,RUT__c from User where RUT__c ='19' LIMIT 1];
        List<CaseNotifiesToAnalytics__c> lstCset = new List<CaseNotifiesToAnalytics__c>();
        CaseNotifiesToAnalytics__c cscase = new CaseNotifiesToAnalytics__c();
        cscase.IdTipoMarca__c = 4;
        cscase.SalesforceField__c = 'Desuscribir_Email__c';
        cscase.Name = 'Desuscripción Email';
        lstCset.add(cscase);
        insert cscase;
        Map<String,Integer> getCaseFieldNotify = new Map<String,Integer>();
        Map<String,Integer> mapMarca = UtilitiesSales.getCaseFieldNotify();
        system.assertEquals(cscase.IdTipoMarca__c, mapMarca.get('Desuscribir_Email__c'));
    }
    
    @isTest static void asd(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        Account acc = (Account)mpsObjects.get('Account');
        Id idrtaccount = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Cliente_Persona_Seguros').getRecordTypeId();
        acc.RecordTypeId = idrtaccount;
        
        update acc;
       // system.debug(acc.RecordTypeId);
        Id idProd2 = Test.getStandardPricebookId(); 
        User usr = (User)mpsObjects.get('User');   
        
        Map<String,SObject> oppor = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,usr.Id);
        List<Id> ids = new List<Id>();
        Opportunity oppp = (Opportunity)oppor.get('Opportunity');
        oppp.RecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_BANCA_PLAN_PLUS).getRecordTypeId();
        test.startTest();
        update oppp;
        test.stopTest();
        ids.add(oppp.Id);
        Map<Id,Boolean> mapi = UtilitiesSales.validateHasPlanPlus(ids);
        system.assert(mapi.get(acc.Id));
       //  system.debug(mapi);
        
    }

    @isTest
    static void HomologateCodeTest() {

        Test.startTest();
        List <Codigo_Origen_CMF__mdt> cmfCodes = [SELECT MasterLabel, value__c FROM Codigo_Origen_CMF__mdt];
        String cmfCodeEmpty = UtilitiesSales.homologateCode('', cmfCodes);
        String cmfCodeValue = UtilitiesSales.homologateCode('App', cmfCodes);
        Test.stopTest();

        System.assertEquals('', cmfCodeEmpty);
        System.assertEquals('11.0', cmfCodeValue);
    }
    
	@isTest static void testGetAllSubRoles(){

        Boolean assertValue = false;
        String role = 'Consorcio';
        String query = 'SELECT Id, Name FROM UserRole WHERE Name = : role';
        List<SObject> results = Database.query(query);
       
        Set<Id> resultIds = (new Map<Id,SObject>(results)).keySet();

        
        
        if(UtilitiesSales.getAllSubRoleIds(resultIds).size() > 0){
            assertValue = true;
        }
        
        System.assertEquals(true, assertValue);
    }
    
    @isTest static void testGetAllUpperRoles(){
        Boolean assertValue = false;
        String role = 'Consorcio';
        String query = 'SELECT Id, Name FROM UserRole WHERE Name = : role';
        List<SObject> results = Database.query(query);
       
        Set<Id> resultIds = (new Map<Id,SObject>(results)).keySet();

        
        
        if(UtilitiesSales.getParentRoleId(resultIds).size() > 0){
            assertValue = true;
        }
        
        System.assertEquals(true, assertValue);
    }
    
    @isTest 
    static void getCompanyNameTest(){
         
		List<CompanyNameListUsr__c> lstCompany = new List<CompanyNameListUsr__c>();
        CompanyNameListUsr__c companyTest = new CompanyNameListUsr__c();
        companyTest.CompanyNameSalesForce__c = 'CORRE';
        companyTest.Name = 'Consorcio Corredora de Bolsa';
        lstCompany.add(companyTest);
        insert lstCompany;
        Map<String, String> mapCompany = utilitiesSales.getCompanyName();
        system.assertEquals(companyTest.CompanyNameSalesForce__c, mapCompany.get(companyTest.Name));
    }
    
    @isTest
    static void getSucursalNameTest(){
         
		List<SucursalNameUsr__c> lstSucursal = new List<SucursalNameUsr__c>();
        SucursalNameUsr__c sucursalTest = new SucursalNameUsr__c();
        sucursalTest.NombreApiSalesForce__c = '240';
        sucursalTest.Name = 'AGUSTINAS PISO 1';
        sucursalTest.SucursalName__c = 'Oficina Agustinas';
        lstSucursal.add(sucursalTest);
        insert lstSucursal;
        Map<String, String> mapSucursal = utilitiesSales.getSucursalName();
        system.assertEquals(sucursalTest.NombreApiSalesForce__c, mapSucursal.get(sucursalTest.Name));
    }
 }