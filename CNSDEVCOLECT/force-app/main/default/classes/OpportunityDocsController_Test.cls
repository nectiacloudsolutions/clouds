/*********************************************************************************************************
@Author       curbinav@everis.com
@name         OpportunityDocsControllerTest
@CreateDate   06/11/2020
@Description  Test class for OpportunityDocsController
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
14/01/2020    fmaturan@everis.com           
**********************************************************************************************************/
@isTest
public class OpportunityDocsController_Test {
    
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
        
        //Create User Ejecutivo Especialista
        User user01 = TestFactorySales.createUser(USERESPRUT, Constants.PROFILE_EJECUTIVO_ESPECIALISTA, USERESPALIAS);
        user01.ManagerId = user04.Id;
        userList.add(user01);
        
        //Create User Ejecutivo Visado
        User user02 = TestFactorySales.createUser(USERVISRUT, Constants.PROFILE_EJECUTIVO_VISADO, USERVISALIAS);
        user02.ManagerId = user04.Id;
        userList.add(user02);
        
        //Create User Ejecutivo Riesgo
        User user03 = TestFactorySales.createUser(USERRISRUT, Constants.PROFILE_EJECUTIVO_DE_RIESGO, USERRIALIAS);
        user03.ManagerId = user04.Id;
        userList.add(user03);
        
        insert userList;
        
        //Create Account object
        //Account acc01 = TestFactorySales.createNewAccount(ACCRUT, ACCLASTNAME);
        Account acc01 = TestFactorySales.createNewAccountWithOwner(ACCRUT, ACCLASTNAME, user01.id);
        
        System.debug('acc01: ' + acc01);
        
        // Create Opp with products
        Id idProd2 = Test.getStandardPricebookId(); 
        mapsOppObjects = TestFactorySales.createOpportunityWithProduct(idProd2, acc01.id, user01.id);
        Opportunity opp = (Opportunity) mapsOppObjects.get('Opportunity');
        //system.debug('Etapa ' + opp.StageName);
        opp.StageName = 'Recopilación';
        opp.RecordTypeId = [SELECT Id, Name FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_BANCA_HIPOTECARIO AND SObjectType = 'Opportunity'].Id;
        opp.ejecutivo_visado_sales__c = user02.Id;
        opp.ejecutivo_riesgo_sales__c = user03.Id;
        update opp;
        
        participante_sales__c par = new participante_sales__c();
        par.rut_sales__c='15780137-6';
        par.tipo_documento_sales__c='RUT';
        par.Name='Dino';
        par.remuneracion_sales__c=5000000;
        par.telefono_movil_sales__c='828081865';
        par.estado_participante_sales__c='Vigente';
        par.opportunity_participante_sales__c = opp.Id;
        insert par;
        
        aditionalDocument__c addDoc = new aditionalDocument__c();
        addDoc.Name='Documentos de la propiedad';
        insert addDoc;
        
        documento_oportunidad_sales__c docOpp = new documento_oportunidad_sales__c();
        docOpp.detalle_documento_sales__c='detalle';
        docOpp.estado_documento_sales__c='Aprobado';
        docOpp.opportunity_sales__c=opp.Id;
        docOpp.Participante_sales__c=par.Id;
        
        insert docOpp;
        
        Test.stopTest();
        system.assertNotEquals(docOpp.Id, null);
        system.assertNotEquals(addDoc.Id, null);
        system.assertNotEquals(par.Id, null);
    }
    
    /**
* @description       Check the functionality of GetData in the Controller
* @param             void
* @return            NA
* @throws            NA 
*/	
    private static testMethod void testGetData() {
        OpportunityDocsController.dataWrapper dw = new OpportunityDocsController.dataWrapper(); 
        // Get CT User
        Test.startTest();
        
        User user = [SELECT Id FROM User WHERE RUT__c =: USERESPRUT LIMIT 1];
        List<Opportunity> oppList = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test'];
        oppList[0].RecordTypeId = [SELECT Id, Name FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_BANCA_PLAN_PLUS AND SObjectType = 'Opportunity'].Id;
        oppList[0].tipo_contrato_sales__c = CONSTANTS.OPP_CONTRACT_TYPE_INDEPEN_BOLETA;
        update oppList[0];        
        System.runAs(user) {
            dw = OpportunityDocsController.getData(oppList[0].id);
            oppList[0].tipo_contrato_sales__c = CONSTANTS.OPP_CONTRACT_TYPE_DEPENDIENTE;
            update oppList[0];
            dw = OpportunityDocsController.getData(oppList[0].id);
            oppList[0].tipo_contrato_sales__c = CONSTANTS.OPP_CONTRACT_TYPE_PENSIONADO;
            update oppList[0];
            dw = OpportunityDocsController.getData(oppList[0].id);
        }
        oppList[0].RecordTypeId = [SELECT Id, Name FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO_LECTURA AND SObjectType = 'Opportunity'].Id;

        update oppList[0]; 
        System.runAs(user) {
            dw = OpportunityDocsController.getData(oppList[0].id);
        }
        Test.stopTest();
        
        System.assertEquals(CONSTANTS.OPPORTUNITY_STAGENAME_RECOPILACION, dw.StageName);
    }
    
    /**
* @description       Check the functionality of GetData in the Controller with profile Visado
* @param             void
* @return            NA
* @throws            NA 
*/	
    private static testMethod void testGetDataVisado() {
        OpportunityDocsController.dataWrapper dw = new OpportunityDocsController.dataWrapper();
        // Get CT User
        User user = [SELECT Id FROM User WHERE RUT__c =: USERVISRUT LIMIT 1];
        List<Opportunity> oppList = [SELECT ID, Name FROM Opportunity WHERE Name = 'Test'];
        oppList[0].StageName = CONSTANTS.HIPOTECARIO_STATUS_VISADO;
        
        update oppList[0];
        
        OpportunityTeamMember oppTeamMemberVis = new OpportunityTeamMember(TeamMemberRole = CONSTANTS.HIPOTECARIO_STATUS_VISADO, 
                                                                           UserId = user.id,
                                                                           OpportunityId = oppList[0].id,
                                                                           OpportunityAccessLevel = 'Edit');
        insert oppTeamMemberVis;
        
        Test.startTest();
        
        System.runAs(user) {
            dw = OpportunityDocsController.getData(oppList[0].id);
        }
        
        Test.stopTest();
        
        System.assertEquals(CONSTANTS.PROFILE_EJECUTIVO_VISADO, dw.profile);
    }
    
    /**
* @description       Check the functionality of saveDoc in the Controller
* @param             void
* @return            NA
* @throws            NA 
*/	
    private static testMethod void testSaveDoc() {
        String res;
        // Get CT User
        User user = [SELECT Id FROM User WHERE RUT__c =: USERESPRUT LIMIT 1];
        List<Opportunity> oppList = [SELECT ID, Name FROM Opportunity WHERE Name = 'Test'];
        documento_oportunidad_sales__c newDoc = TestFactorySales.createNewOppDoc(oppList[0].id, '');
        
        Test.startTest();
        
        System.runAs(user) {
            res = OpportunityDocsController.saveDoc(newDoc.id, 'Aprobado');    
            System.assertEquals(CONSTANTS.OK, res);
            res = OpportunityDocsController.saveDoc(newDoc.id, 'ASDSAF'); 
            System.assertEquals('NO OK', res);
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
            res = OpportunityDocsController.saveAllDocs(lstDocToCreate);   
            System.assertEquals(CONSTANTS.OK, res);
        }
        
        Test.stopTest();
        
        
    }
    
    /**
* @description       Check the functionality of sendToValidate in the Controller
* @param             void
* @return            NA
* @throws            NA 
*/
    private static testMethod void testSendToValidate() {
        String res;
        // Get CT User
        User user = [SELECT Id FROM User WHERE RUT__c =: USERESPRUT LIMIT 1];
        List<Opportunity> oppList = [SELECT ID, Name FROM Opportunity WHERE Name = 'Test'];  
        
        Test.startTest();   
        System.runAs(user) {
            res = OpportunityDocsController.sendToValidate(oppList[0].id);
            System.assertEquals(Constants.OK, res);
        }      
        Test.stopTest();   
        
    }
    
    /**
* @description       Check the functionality of visadoDecision in the Controller
* @param             void
* @return            NA
* @throws            NA 
*/
    private static testMethod void testVisadoDecision() {
        String res;
        // Get CT User
        User user = [SELECT Id FROM User WHERE RUT__c =: USERESPRUT LIMIT 1];
        List<Opportunity> oppList = [SELECT ID, Name FROM Opportunity WHERE Name = 'Test'];
        documento_oportunidad_sales__c newDoc = TestFactorySales.createNewOppDoc(oppList[0].id, 'Aprobado'); 
        oppList[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO).getRecordTypeId();
        update oppList[0];
        //system.debug( oppList[0].RecordTypeId);
        //system.debug(Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO).getRecordTypeId());
        Test.startTest();       
        System.runAs(user) {
            res = OpportunityDocsController.visadoDecision(oppList[0].id, 'APROBADO');
            System.assertEquals(Constants.OK, res);
        }      
        
        // Se comenta assert por error PB Poblar_Campos_Contacto_Hipotecario
           
        System.runAs(user) {
            res = OpportunityDocsController.visadoDecision(user.Id, 'Test');
            System.assertEquals('NO OK', res);
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
        String res;
        //Get CT User
        User user = [SELECT Id FROM User WHERE RUT__c =: USERESPRUT LIMIT 1];
        List<Opportunity> oppList = [SELECT ID, Name FROM Opportunity WHERE Name = 'Test'];
        oppList[0].RecordTypeId = [SELECT Id, Name FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_BANCA_HIPOTECARIO_LECTURA AND SObjectType = 'Opportunity'].Id;
        update oppList;
        
        OpportunityDocsController.sendToValidate(oppList[0].id);
        //documento_oportunidad_sales__c newDoc = TestFactorySales.createNewOppDoc(oppList[0].id, 'Rechazado');
        
        Test.startTest();
        
        System.runAs(user) {
            res = OpportunityDocsController.visadoDecision(oppList[0].id, 'RECHAZADO');
            System.assertEquals(Constants.OK, res);
        }
        
        Test.stopTest();
        
        
    }
    
    private static testMethod void testaddNewDocumentType() {
        List<Participante_sales__c> par= [SELECT  Id, rut_sales__c, tipo_documento_sales__c, Name, remuneracion_sales__c, telefono_movil_sales__c, estado_participante_sales__c, opportunity_participante_sales__c FROM participante_sales__c];
        List<Opportunity> oppList = [SELECT ID, Name FROM Opportunity WHERE Name = 'Test'];
        insert new aditionalDocument__c (Name='Test');
        List<aditionalDocument__c> lst = [SELECT Id, Name FROM aditionalDocument__c WHERE Name = 'Test'];
        documento_oportunidad_sales__c newDoc = TestFactorySales.createNewOppDoc(oppList[0].id, '');
   
        User user = [SELECT Id FROM User WHERE RUT__c =: USERRISRUT LIMIT 1];
        OpportunityTeamMember otm =new OpportunityTeamMember (OpportunityId = oppList[0].id,UserId = user.Id ,TeamMemberRole ='Riesgo', OpportunityAccessLevel='Edit');
        insert otm;
        
        Test.startTest();
        
        System.runAs(user) {
            //  OpportunityDocsController.addNewDocumentType(oppList[0].id, lst[0].Name, newDoc.detalle_documento_sales__c, par[0].Id);
            // Second time will throw duplicated error
            try {
                OpportunityDocsController.addNewDocumentType(oppList[0].id, lst[0].Name, newDoc.detalle_documento_sales__c, par[0].Id);
            }
            catch (Exception e) {
                System.debug(e.getStackTraceString());
                System.assert(e instanceof AuraHandledException);
            }
        }
        
        Test.stopTest();
    } 
    
    private static testMethod void testGetDocumentClient() {
        // No requiere runAs
        test.startTest();
        List<aditionalDocument__c> lst = OpportunityDocsController.getValuesDocumentClient();
        test.stopTest();
        System.assert(lst != null && !lst.isEmpty());
    }
    
    private static testMethod void sendToJefaturaTest() {
        User ejecutivoEspecialista = [SELECT Id FROM User WHERE RUT__c =: USERESPRUT LIMIT 1];
        List<Opportunity> oppList = [SELECT ID, Name FROM Opportunity WHERE Name = 'Test'];
        Test.startTest();
        System.runAs(ejecutivoEspecialista) {
            oppList[0].OwnerId = ejecutivoEspecialista.Id;
            update oppList;
            
            String resultado = OpportunityDocsController.sendToJefatura(oppList[0].id);
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
    
    @isTest 
    private static  void getDocTypesCreditoConsumoTest(){
        
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        Account acc = (Account)mpsObjects.get('Account');
        Id idrtaccount = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Cliente_Persona_Seguros').getRecordTypeId();
        acc.RecordTypeId = idrtaccount;
        
        update acc;
       // system.debug(acc.RecordTypeId);
        Id idProd2 = Test.getStandardPricebookId(); 
        User usr = (User)mpsObjects.get('User');   
        
        Map<String,SObject> oppor = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,usr.Id);
        Opportunity oppy = (Opportunity)oppor.get('Opportunity');  
       //SYSTEM.debug(oppy.recordtype.DeveloperName);
        Id idrt = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO).getRecordTypeId();
        oppy.RecordTypeId = idrt;
        
        Map<String,SObject> oppor2 = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,usr.Id);
        Opportunity oppy2 = (Opportunity)oppor2.get('Opportunity');  
        oppy2.RecordTypeId = idrt;
        
        Map<String,SObject> oppor3 = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,usr.Id);
        Opportunity oppy3 = (Opportunity)oppor3.get('Opportunity');  
        oppy3.RecordTypeId = idrt;
        
        Map<String,SObject> oppor4 = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,usr.Id);
        Opportunity oppy4 = (Opportunity)oppor4.get('Opportunity');  
        oppy4.RecordTypeId = idrt;
        
        List<Opp_Document_Type__mdt>  realDocList = [SELECT MasterLabel FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: CONSTANTS.OPP_MDT_LABEL_CONSUMO];
        List<Opp_Document_Type__mdt> cleaner = realDocList;
        List<Opp_Document_Type__mdt> docTypesTOTAL = realDocList;
        oppy.tipo_cliente_sales__c = Constants.OPP_CLIENT_TYPE_INDEPENDIENTE;
  
        Test.startTest();
        try{
            update oppy; 
        }catch(exception ex){
            system.debug(ex.getMessage());
        }
        system.runAs(usr){
            oppy.Flag_Banca_Nueva_Oportunidad_sales__c = false;
            update oppy; 
        }
        
     //   system.debug(cleaner);
        
        realDocList.addAll([SELECT MasterLabel FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: CONSTANTS.OPP_MDT_LABEL_CONSUMO_INDEPENDIENTE]);
        system.runAs(usr){        
            docTypesTOTAL= OpportunityDocsController.getDocTypesCreditoConsumo(oppy);
            system.assertEquals(docTypesTOTAL.size(), 9);         
        }
        realDocList = cleaner;
        docTypesTOTAL = cleaner; 
        oppy.tipo_cliente_sales__c = Constants.OPP_CLIENT_TYPE_DEPENDIENTE;
        update oppy; 
        realDocList.addAll([SELECT MasterLabel FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: CONSTANTS.OPP_MDT_LABEL_CONSUMO_DEPENDIENTE]);
        
        system.assertEquals(docTypesTOTAL, realDocList);  
        realDocList.addAll([SELECT MasterLabel FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: CONSTANTS.OPP_MDT_LABEL_CONSUMO_DEPENDIENTE]);
        system.runAs(usr){
            docTypesTOTAL= OpportunityDocsController.getDocTypesCreditoConsumo(oppy2);
        }
        
        oppy.tipo_cliente_sales__c = Constants.OPP_CLIENT_TYPE_SOCIOEMPRESA;
        update oppy; 
        system.runAs(usr){
            List<Opp_Document_Type__mdt> lista = OpportunityDocsController.getDocTypesCreditoConsumo(oppy);
        }
        
        oppy.tipo_cliente_sales__c = Constants.OPP_CLIENT_TYPE_RENTISTA;
        update oppy; 
        
        system.runAs(usr){
            List<Opp_Document_Type__mdt> lista = OpportunityDocsController.getDocTypesCreditoConsumo(oppy);
            List<Opp_Document_Type__mdt> docTypes = [SELECT MasterLabel FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: CONSTANTS.OPP_MDT_LABEL_CONSUMO_RENTISTA];
        }
        Test.stopTest();
    }
    
    /**
* @description       Check the functionality of sendToApproveManager Method in the Controller
* @param             void
* @return            NA
* @throws            NA
* @author            fbizamam@everis.com  
*/
    @isTest 
    private static  void sendToApproveManagerTest(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        Account acc = (Account)mpsObjects.get('Account');
        
        update acc;
        Id idProd2 = Test.getStandardPricebookId(); 
        User usr = (User)mpsObjects.get('User2');  
        
        Map<String,SObject> oppor = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,usr.Id);
        Opportunity oppy = (Opportunity)oppor.get('Opportunity');  
        Test.startTest();
        system.runAs(usr){
            System.AssertEquals(Constants.OK,OpportunityDocsController.sendToApproveManager(oppy.Id));
        }  
        Test.stopTest();
    }
    /**
* @description       Check the functionality of stageRejectManager Method in the Controller
* @param             void
* @return            NA
* @throws            NA
* @author            fbizamam@everis.com  
*/
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
            OpportunityDocsController.stageRejectManager(oppy.Id,'Test');
            Opportunity oppya = [SELECT Id, Motivo_otro_sales__c FROM Opportunity where Id =: oppy.Id ];
            System.assertEquals(oppya.Motivo_otro_sales__c, 'Test');
        }
        Test.stopTest();
        
        
        
    }
    
    /**
* @description Test for rejectProposalConfirmBoss
* @author eayalcor@everis.com | 08-01-2020 
* @return void 
**/
    @isTest
    static void rejectProposalConfirmBossTest(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        Account acc = (Account)mpsObjects.get('Account');
        update acc;
        Id idProd2 = Test.getStandardPricebookId(); 
        User usr = (User)mpsObjects.get('User2');      
        Map<String,SObject> oppor = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,usr.Id);
        Opportunity oppy = (Opportunity)oppor.get('Opportunity');  
        oppy.motivo_reingreso_sales__c= Constants.HIPOTECARIO_MOTIVO_REINGRESO_INCLUSION;
        upsert oppy;
        Test.startTest();
        System.runAs(usr){
            String status =  OpportunityDocsController.rejectProposalConfirmBoss(oppy.Id);
            System.assertEquals(status, Constants.OK);
        }
        Test.stopTest();
    }
      /**
* @description Test for setAllDocsStateTo Method
* @author fbizamam@everis.com | 15-06-2020 
* @return void 
**/
    @isTest
    static void setAllDocsStateToTest(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        Account acc = (Account)mpsObjects.get('Account');
        Id idrtaccount = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Cliente_Persona_Seguros').getRecordTypeId();
        acc.RecordTypeId = idrtaccount;
        
        update acc;
   
        Id idProd2 = Test.getStandardPricebookId(); 
        User usr = (User)mpsObjects.get('User2');   
        
        Map<String,SObject> oppor = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,usr.Id);
        Opportunity oppy = (Opportunity)oppor.get('Opportunity');
         
        Id idrt = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO).getRecordTypeId();
        oppy.RecordTypeId = idrt;
        OpportunityDocsController.dataWrapper dw = new OpportunityDocsController.dataWrapper(); 
        dw = OpportunityDocsController.getData(oppy.Id);
        update oppy;

        system.runAs(usr){
            String result = OpportunityDocsController.setAllDocsStateTo(oppy.Id, CONSTANTS.SELECT_ESTADO_APROBADO);
       		system.assertEquals(CONSTANTS.OK, result);
        }
        
    }
    
}