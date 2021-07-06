/*********************************************************************************************************
@Author       fmaturan@everis.com
@name         TestFactorySales_Test
@CreateDate   07/10/2019
@Description  Test of the class TestFactorySales.
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          		Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
07/10/2019		fmaturan@everis.com               initial version
06/07/2020		fvasquen@everis.com				  Add methods for the creation of users with companies
**********************************************************************************************************/
@isTest
private class TestFactorySales_Test {
    /**
      * @description       Tests the method populateOrg.  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest static void popOrg() {
        Map<String,sObject> objs = TestFactorySales.populateOrg();
        User u = (User)objs.get('User');
        User u2 =(User)objs.get('User2');
        Account acc =(Account)objs.get('Account');
        Lead lead =(Lead)objs.get('Lead');
        
        System.assertEquals('Ejecutivo', u.firstName);
        System.assertEquals('Sales', u.LastName);
    }
    /**
      * @description       Tests the method createSobjects.  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest static void createSobjects(){
        Lead lead =TestFactorySales.createNewLead('10249770-8','18518299-1','Test');
        User user = TestFactorySales.createUser('19604714', 'Jefe de Campaña', 'Test');
        insert user;
        User userBanco = TestFactorySales.createUserWithCompany('110675674','Ejecutivo Especialista','TestBan','Consorcio Banco');
        //insert userBanco;
        User userSeguros = TestFactorySales.createUserWithCompany('148579296','Ejecutivos de Atención al Cliente Seguros Comercial','TestSeg','Consorcio Seguros');
        //insert userSeguros;
        User userCorredora = TestFactorySales.createUserWithCompany('123009959','Ejecutivo Especialista','TestCor','Consorcio Corredora de Bolsa');
        //insert userCorredora;        
        Lead lead2 = TestFactorySales.createNewLeadwithSLA('10249770-8','1-9','Test');
        Account ac = TestFactorySales.createNewAccount('22820433-1', 'Test');
        Lead lead3 = TestFactorySales.createNewLead('9266847-9','1-9','Test');
        
        Account acw = TestFactorySales.createNewAccountWithOwner('6571150-8','test', user.Id);
        Event ev = TestFactorySales.createEvent(lead.Id,Constants.EVENT_TYPE_ENTREVISTA, Constants.EVENT_ESTADO_ENTREVISTA_EXITOSO,Constants.EVENT_RESULTADO_REUNION_EXITOSA);
 		Event evCall = TestFactorySales.createEvent(lead.Id,Constants.EVENT_TYPE_LLAMADA, Constants.EVENT_ESTADO_LLAMADA_CONTACTADO,Constants.EVENT_RESULTADO_REUNION_EXITOSA);
 		Event evNull = TestFactorySales.createEvent(lead.Id,'', Constants.EVENT_ESTADO_LLAMADA_CONTACTADO,Constants.EVENT_RESULTADO_REUNION_EXITOSA);
        
       	System.assertEquals('TestFirstName', lead.FirstName);
        System.assertEquals('TestLastName', lead.LastName);
        System.assertEquals('18518299-1', lead.rut_ejecutivo_sales__c);
        System.assertEquals('10249770-8', lead.numero_de_documento_sales__c);
        System.assertEquals('test@test.cl', lead.Email);
        System.assertEquals(null, lead.sla_sales__c);
        System.assertEquals(null, lead.fecha_nacimiento_sales__c);
        System.assertEquals('19604714', user.RUT__c);
        System.assertEquals('110675674', userBanco.RUT__c);
        System.assertEquals('148579296', userSeguros.RUT__c);
        System.assertEquals('123009959', userCorredora.RUT__c);
        System.assertEquals('10249770-8', lead2.numero_de_documento_sales__c);
        System.assertEquals('22820433-1', ac.RUT__c);
        System.assertEquals('9266847-9', lead3.numero_de_documento_sales__c);
        System.assertEquals(ev.WhoId,lead.Id);
        System.assertEquals(evCall.WhoId, lead.Id);
        System.assertEquals(null, evNull);
                
    }
    /**
      * @description       Tests the method createDataOpp.  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest static void createDataOpp(){
        Map<String,sObject> mapsObjects = TestFactorySales.populateOrg();
        Account acc = (Account)mapsObjects.get('Account');
        User u2 = (User)mapsObjects.get('User2');
        Id Idpro = Test.getStandardPricebookId();
        Map<String, SObject> mapsOppObject = TestFactorySales.createOpportunityWithProduct(Idpro, acc.Id, u2.Id);
        Quote quo = (Quote)mapsOppObject.get('Quote');
        Opportunity opp = (Opportunity)mapsOppObject.get('Opportunity');
        documento_oportunidad_sales__c newDoc= TestFactorySales.createNewOppDoc(opp.Id,'Aprobado');
        List<documento_oportunidad_sales__c> listDocc = TestFactorySales.createNewOppHipoDoc(opp.Id);
        try
        {
            Map<String, SObject> mapsOppObjectVida = TestFactorySales.createOpportunityVidaWithProduct(Idpro, acc.Id, u2.Id);
        }
        catch(exception e)
        {
        }             
       
     
        System.assertEquals(opp.Id,listDocc[0].opportunity_sales__c);
        System.assertEquals('Test', quo.Name);
        System.assertEquals('Aprobado', newDoc.estado_documento_sales__c);
                
    }
    /**
      * @description       Tests the method createPricebook2.  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest static void createPricebook2Test(){
        TestFactorySales.createPricebook2('StandardPricebook');
        
        List<Pricebook2> pr = [SELECT Id, name FROM pricebook2 WHERE Name = 'StandardPricebook' LIMIT 1];
        System.assertEquals('StandardPricebook', pr[0].name);
    }
    
    /**
      * @description       Tests the method createConsorcioOrg.  
      * @param            
      * @return            void
      * @throws            NA
    */
    @isTest static void createConsorcioOrgTest(){
        TestFactorySales.createConsorcioOrg();
        
        System.assertEquals(Consorcio_Org__c.getInstance(UserInfo.getProfileId()).Sales_project__c, TRUE);
    }
}