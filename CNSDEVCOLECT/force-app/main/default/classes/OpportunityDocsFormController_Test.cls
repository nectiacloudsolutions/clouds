/*********************************************************************************************************
@Author       fbizamam@everis.com
@name         OpportunityDocsControllerTest
@CreateDate   06/11/2020
@Description  Test class for OpportunityDocsFormController
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
06/05/2020    fbizamam@everis.com           
**********************************************************************************************************/

@isTest
public class OpportunityDocsFormController_Test {
      private static final String USERESPRUT = '1-9';
    private static final String USERVISRUT = '3-7';
    private static final String USERRISRUT = '6191633-4';
    private static final String USERESPALIAS = 'USERESP';
    private static final String USERVISALIAS = 'USERVIS';
    private static final String USERRIALIAS = 'USERRI';
    private static final String ACCRUT = '14568948-1';
    private static final String ACCLASTNAME = 'Hernandez';
   
    
    /**
* @description       Test -- testCreateObj
* @param             void
* @return            NA
* @throws            NA 
*/	
    @testSetup
    private static void testCreateObj() {
       
    
        Test.startTest();
        List<User> userList = new List<User>();
        Map<String, SObject> mapsOppObjects = new Map<String, SObject>();
        
        // Jefe de Ventas
        User user04 = TestFactorySales.createUser('6-6', Constants.PROFILE_EJECUTIVO_VENTA, 'USRVENTA');
        insert user04;
        
        //Create User Ejecutivo 
        User user01 = TestFactorySales.createUser(USERESPRUT, Constants.PROFILE_EJECUTIVO_ATENCION_CLIENTE, USERESPALIAS);
        user01.ManagerId = user04.Id;
        userList.add(user01);
        insert userList;
        
        //Create Account object
        Account acc01 = TestFactorySales.createNewAccountWithOwner(ACCRUT, ACCLASTNAME, user01.id);
        
        System.debug('acc01: ' + acc01);
        
        // Create Opp with products
        Id idProd2 = Test.getStandardPricebookId(); 
        mapsOppObjects = TestFactorySales.createOpportunityWithProduct(idProd2, acc01.id, user01.id);
        Opportunity opp = (Opportunity) mapsOppObjects.get('Opportunity');
    
        opp.StageName = CONSTANTS.OPPORTUNITY_STAGENAME_FORMALIZACION;
        opp.RecordTypeId = [SELECT Id, Name FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO AND SObjectType = 'Opportunity'].Id;
     
        update opp; 
        documento_oportunidad_sales__c docOpp = new documento_oportunidad_sales__c();
        docOpp.detalle_documento_sales__c='detalle';
        docOpp.estado_documento_sales__c='Aprobado';
        docOpp.opportunity_sales__c=opp.Id;  
        insert docOpp;
        System.assertNotEquals(docOpp.Id, null);
        Test.stopTest();
    
  
    }
    
    private static testMethod void saveApprovalTest(){
        
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        Account acc = (Account)mpsObjects.get('Account');
        Id idrtaccount = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Cliente_Persona_Seguros').getRecordTypeId();
        acc.RecordTypeId = idrtaccount;
        
        update acc;
        system.debug(acc.RecordTypeId);
        Id idProd2 = Test.getStandardPricebookId(); 
        User usr = (User)mpsObjects.get('User');   
        User usr2 = (User)mpsObjects.get('User2');   
        
        Map<String,SObject> oppor = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,usr.Id);
        Opportunity oppy = (Opportunity)oppor.get('Opportunity'); 
        OpportunityDocsFormController.saveApproval(usr.id, oppy.id);
        OpportunityDocsFormController.saveApproval(usr2.id, oppy.id);
         OpportunityDocsFormController.saveApproval(usr.id, oppy.id);
        Opportunity opp=[SELECT id, aprobacion_pre_visado_sales__c FROM Opportunity WHERE ownerId=:usr.Id];      
        
        System.assertEquals(Constants.APROBADO_RIESGO_EN_PROCESO,opp.aprobacion_pre_visado_sales__c);       
    }
    
    private static testMethod void saveDocTest(){
        String res;
        // Get CT User
        User user = [SELECT Id FROM User WHERE RUT__c =: USERESPRUT LIMIT 1];
        List<Opportunity> oppList = [SELECT ID, Name FROM Opportunity WHERE Name = 'Test'];
        documento_oportunidad_sales__c newDoc = TestFactorySales.createNewOppDoc(oppList[0].id, '');
        
        Test.startTest();
        
        System.runAs(user) {
            res = OpportunityDocsFormController.saveDoc(newDoc.id, CONSTANTS.APROBADO_RIESGO_APROBADO);    
            System.assertEquals(CONSTANTS.OK, res);
            res = OpportunityDocsFormController.saveDoc(newDoc.id, 'Cubre exception'); 
            System.assertEquals(CONSTANTS.NOK, res);
        }
        
        Test.stopTest();
    }
    
    
    @isTest 
    private static  void stageRejectManagerTest(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        Account acc = (Account)mpsObjects.get('Account');
        update acc;
        Id idProd2 = Test.getStandardPricebookId(); 
        User usr = (User)mpsObjects.get('User');  
        
        Map<String,SObject> oppor = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,usr.Id);
        
        Opportunity oppy = (Opportunity)oppor.get('Opportunity');  
        update oppy;
        Test.startTest();
        system.runAs(usr){
            OpportunityDocsFormController.stageRejectManager(oppy.Id,'Test');
            Opportunity oppya = [SELECT Id, Motivo_otro_sales__c FROM Opportunity where Id =: oppy.Id ];
            System.assertEquals(oppya.Motivo_otro_sales__c, 'Test');
        }
        Test.stopTest(); 
    }

    /**
* @description       Checks the functionality of the GetData method in the Controller
* @param             void
* @return            NA
* @throws            NA 
*/	
    private static testMethod void testGetData() {
		 OpportunityDocsFormController.dataWrapper dw = new OpportunityDocsFormController.dataWrapper(); 
        Test.startTest();
        User user = [SELECT Id FROM User WHERE RUT__c =: USERESPRUT LIMIT 1];
        List<Opportunity> oppList = [SELECT Id, Name, RecordType.DeveloperName FROM Opportunity WHERE Name = 'Test'];
        oppList[0].RecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO AND SObjectType = 'Opportunity'].Id;
        oppList[0].tipo_contrato_sales__c = CONSTANTS.OPP_CONTRACT_TYPE_PENSIONADO;
        update oppList[0];        
        System.runAs(user) {
           
            dw = OpportunityDocsFormController.getData(oppList[0].id);
            oppList[0].tipo_contrato_sales__c = CONSTANTS.OPP_CONTRACT_TYPE_PENSIONADO;
            update oppList[0];

        }
        oppList[0].RecordTypeId = [SELECT Id, Name FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO_LECTURA AND SObjectType = 'Opportunity'].Id;
        update oppList[0]; 
        System.runAs(user) {
            dw = OpportunityDocsFormController.getData(oppList[0].id);
        }
        Test.stopTest();
        System.assertEquals(CONSTANTS.OPPORTUNITY_STAGENAME_FORMALIZACION, dw.StageName);
    }
    
    private static testMethod void sendToJefaturaTest() {
        User ejecutivoEspecialista = [SELECT Id FROM User WHERE RUT__c =: USERESPRUT LIMIT 1];
        List<Opportunity> oppList = [SELECT ID, Name FROM Opportunity WHERE Name = 'Test'];
        Test.startTest();
        System.runAs(ejecutivoEspecialista) {
            oppList[0].OwnerId = ejecutivoEspecialista.Id;
            update oppList;
            
            String resultado = OpportunityDocsFormController.sendToApproveVisador(oppList[0].id);
            System.assertEquals(CONSTANTS.OK, resultado);
        }
        
        Id idrt = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO_LECTURA).getRecordTypeId();
        oppList[0].RecordTypeId = idrt;
        System.runAs(ejecutivoEspecialista) {
            oppList[0].OwnerId = ejecutivoEspecialista.Id;
            update oppList;
            
            String resultado = OpportunityDocsController.sendToJefatura(oppList[0].id);
            System.assertEquals(CONSTANTS.OK, resultado); 
        }
        Test.stopTest();
        
    }
    
       /**
* @description       Check the functionality of saveAllDocs in the Controller
* @param             void
* @return            NA
* @throws            NA 
*/
    private static testMethod void testSaveAllDocs(){
        String res;
        // Get CT User
        User user = [SELECT Id FROM User WHERE RUT__c =: USERESPRUT LIMIT 1];
        List<Opportunity> oppList = [SELECT ID, Name FROM Opportunity WHERE Name = 'Test'];
        List<documento_oportunidad_sales__c> lstDocToCreate = new List<documento_oportunidad_sales__c>();
        documento_oportunidad_sales__c newDoc = TestFactorySales.createNewOppDoc(oppList[0].id, '');
        newDoc.estado_documento_sales__c = CONSTANTS.APROBADO_RIESGO_APROBADO;
        lstDocToCreate.add(newDoc);
        
        Test.startTest();
        
        System.runAs(user) {
            res = OpportunityDocsFormController.saveAllDocs(lstDocToCreate);   
            System.assertEquals(CONSTANTS.OK, res);
        }
        
        Test.stopTest();
        
        
    }
    
    
      
    /**
* @description       Check the functionality of visadoDecision in the Controller
* @param             void
* @return            NA
* @throws            NA 
*/
    private static testMethod void testVisadoDecisionRechazado() {
        String USERESPRUT = '1-9';
        String res;
        // Get CT User
        User user = [SELECT Id FROM User WHERE RUT__c =: USERESPRUT LIMIT 1];
        List<Opportunity> oppList = [SELECT ID, Name FROM Opportunity WHERE Name = 'Test'];
        documento_oportunidad_sales__c newDoc = TestFactorySales.createNewOppDoc(oppList[0].id, 'Aprobado'); 
        oppList[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO).getRecordTypeId();
        update oppList[0];
 
        Test.startTest();       
        System.runAs(user) {
            res = OpportunityDocsFormController.visadoDecision(oppList[0].id, 'APROBADO');
            System.assertEquals(Constants.OK, res);
        }  
        System.runAs(user) {
            res = OpportunityDocsFormController.visadoDecision(oppList[0].id, 'RECHAZADO');
            System.assertEquals(Constants.OK, res);
        }      
        
 
           
        System.runAs(user) {
            res = OpportunityDocsFormController.visadoDecision(user.Id, 'Test');
            System.assertEquals('NO OK', res);
        }     
        Test.stopTest();
        
    }
  
}