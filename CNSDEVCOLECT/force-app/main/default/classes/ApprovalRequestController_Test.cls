/**
 * @File Name          : ApprovalRequestController_Test.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 08-01-2020 13:28:52
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    08-01-2020   eayalcor@everis.com     Initial Version
**/
@isTest
private class ApprovalRequestController_Test {

    /**
    * @description Generar Data test 
    * @author eayalcor@everis.com | 08-01-2020 
    * @return void 
    **/
    @TestSetup
    static void makeData(){
        TestFactorySales.populateOrg();
    }

    /**
    * @description Test for getInitialData
    * @author eayalcor@everis.com | 08-01-2020 
    * @return void 
    **/
   
    @isTest
    static void getInitialDataTest(){
        List<User> lstUser = [SELECT Id,Rut__C,ProfileID,Name FROM User WHERE UserName = 'ejecutivo2@consorcio.cl.devsales' LIMIT 1];
        List<Opportunity> lstOpp = [SELECT Id,StageName FROM Opportunity WHERE Name = 'test opp 1' LIMIT 1];
        
        System.runAs(lstUser[0]){
            Map<String,List<Object>> mapTest = ApprovalRequestController.getInitialData(lstOpp[0].Id);
            System.assertEquals(8, mapTest.size());
        }
    }

    /**
    * @description Test for saveApproval
    * @author eayalcor@everis.com | 08-01-2020 
    * @return void 
    **/
    @isTest
    static void saveApprovalTest(){
        List<User> lstUser = [SELECT Id,Rut__C,ProfileID,Name FROM User WHERE UserName = 'ejecutivo2@consorcio.cl.devsales' LIMIT 1];
        List<Opportunity> lstOpp = [SELECT Id,StageName FROM Opportunity WHERE Name = 'test opp 1' LIMIT 1];
        
        System.runAs(lstUser[0]){
            String status =  ApprovalRequestController.saveApproval(lstOpp[0].Id);
            System.assertEquals(status, Constants.OK);
        }
    }

    /**
    * @description Test for rejectProposalRisk
    * @author eayalcor@everis.com | 08-01-2020 
    * @return void 
    **/
    @isTest
    static void rejectProposalRiskTest(){
        List<User> lstUser = [SELECT Id,Rut__C,ProfileID,Name FROM User WHERE UserName = 'ejecutivo2@consorcio.cl.devsales' LIMIT 1];
        List<Opportunity> lstOpp = [SELECT Id,StageName FROM Opportunity WHERE Name = 'test opp 1' LIMIT 1];
        
        System.runAs(lstUser[0]){
            String status =  ApprovalRequestController.rejectProposalRisk(lstOpp[0].Id,Constants.HIPOTECARIO_MOTIVO_RECHAZO_RIESGO_DEUDA_CAST,'Test');
            System.assertEquals(status, Constants.OK);
        }
    }

    /**
    * @description Test for rejectProposalConfirmBoss
    * @author eayalcor@everis.com | 08-01-2020 
    * @return void 
    **/
    @isTest
    static void rejectProposalConfirmBossTest(){
        List<User> lstUser = [SELECT Id,Rut__C,ProfileID,Name FROM User WHERE UserName = 'ejecutivo2@consorcio.cl.devsales' LIMIT 1];
        List<Opportunity> lstOpp = [SELECT Id,StageName,RecordTypeId FROM Opportunity WHERE Name = 'test opp 1' LIMIT 1];
        List<RecordType> lstRcd = [SELECT Id FROM RecordType WHERE sobjectType =: Constants.OPPORTUNITY AND DeveloperName =: Constants.RECORDTYPE_BANCA_HIPOTECARIO LIMIT 1];
        lstOpp[0].RecordTypeId = lstRcd[0].Id;
        lstOpp[0].motivo_reingreso_sales__c= Constants.HIPOTECARIO_MOTIVO_REINGRESO_INCLUSION;
        upsert lstOpp;

        System.runAs(lstUser[0]){
            String status =  ApprovalRequestController.rejectProposalConfirmBoss(lstOpp[0].Id);
            System.assertEquals(status, Constants.OK);
        }
    }
    
    @isTest
    static void stageApprovalManagerTest() {
        List<User> lstUser = [SELECT Id,Rut__C,ProfileID,Name FROM User WHERE UserName = 'ejecutivo3@consorcio.cl.devsales' LIMIT 1];
        lstUser[0].ManagerId = [SELECT Id,Rut__C,ProfileID,Name FROM User WHERE UserName = 'ejecutivo6@consorcio.cl.devsales' LIMIT 1].Id;
        update lstUser;
        
        List<Opportunity> lstOpp = [SELECT Id, StageName FROM Opportunity WHERE Name = 'test opp 1' LIMIT 1];
        lstOpp[0].aprobacion_visado_sales__c = CONSTANTS.APROBADO_RIESGO_EN_PROCESO; 
        lstOpp[0].StageName = CONSTANTS.HIPOTECARIO_STATUS_VISADO;
        lstOpp[0].OwnerId = [SELECT Id,Rut__C,ProfileID,Name FROM User WHERE UserName = 'ejecutivo3@consorcio.cl.devsales' LIMIT 1].Id;
        
        List<RecordType> lstRcd = [SELECT Id FROM RecordType WHERE sobjectType =: Constants.OPPORTUNITY AND DeveloperName =: Constants.RECORDTYPE_BANCA_HIPOTECARIO LIMIT 1];
        lstOpp[0].RecordTypeId = lstRcd[0].Id;
        
        update lstOpp[0];
       
        System.runAs(lstUser[0]){
            System.assertEquals(Constants.OK, ApprovalRequestController.stageApprovalManager(lstOpp[0].Id));
        }
    }
    
    @isTest
    static void stageRejectManagerTest() {
        List<User> lstUser = [SELECT Id,Rut__C,ProfileID,Name FROM User WHERE UserName = 'ejecutivo3@consorcio.cl.devsales' LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'test opp 1' LIMIT 1][0];
        String motivoRechazo = 'Motivo Rechazo';
        
        ApprovalRequestController.stageRejectManager(opp.Id, motivoRechazo);
        Opportunity oppAfter = [SELECT Id, Motivo_otro_sales__c FROM Opportunity WHERE Name = 'test opp 1' LIMIT 1][0];
        
         System.runAs(lstUser[0]){
             System.assertEquals(motivoRechazo, oppAfter.Motivo_otro_sales__c);
        }
    }

    @isTest
    static void sendToApproveManagerTest() {
        List<User> lstUser = [SELECT Id,Rut__C,ProfileID,Name FROM User WHERE UserName = 'ejecutivo3@consorcio.cl.devsales' LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'test opp 1' LIMIT 1][0];
        
        ApprovalRequestController.sendToApproveManager(String.valueOf(opp.Id));
        Id idrt = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('sales_credito_consumo').getRecordTypeId();
        opp.RecordTypeId = idrt;
        update opp;   
        Opportunity oppAfter = [SELECT Id, aprobacion_visado_sales__c FROM Opportunity WHERE Name = 'test opp 1' LIMIT 1][0];
        System.runAs(lstUser[0]){
            System.assertEquals(oppAfter.aprobacion_visado_sales__c, CONSTANTS.APROBADO_RIESGO_APROBADO);
        }
         
    }

    /**
    * @description Test for rejectProposalNotification
    * @author eayalcor@everis.com | 08-01-2020 
    * @return void 
    **/
    @isTest
    static void rejectProposalNotificationTest(){
        List<User> lstUser = [SELECT Id,Rut__C,ProfileID,Name FROM User WHERE UserName = 'ejecutivo2@consorcio.cl.devsales' LIMIT 1];
        List<Opportunity> lstOpp = [SELECT Id,StageName FROM Opportunity WHERE Name = 'test opp 1' LIMIT 1];
        
        System.runAs(lstUser[0]){
            String status1 =  ApprovalRequestController.rejectProposalNotification(lstOpp[0].Id,Constants.PROFILE_EJECUTIVO_ESPECIALISTA,'Test',Constants.HIPOTECARIO_MOTIVO_REINGRESO_CAMBIO);
            System.assertEquals(status1, Constants.OK);

            String status2 =  ApprovalRequestController.rejectProposalNotification(lstOpp[0].Id,Constants.PROFILE_EJECUTIVO_DE_RIESGO,'Test',Constants.HIPOTECARIO_MOTIVO_REINGRESO_INCLUSION);
            System.assertEquals(status2, Constants.OK);
        }
    }
    /**
    * @description Test for getApprovalVisibilityProfiles
    * @author -- | --
    * @Updated 16/04/2020 fbizama@everis.com
    * @return void 
    **/
    @isTest
    static void getVisibilityApprovalTest(){
        List<Opportunity> lstOpp = [SELECT Id, StageName FROM Opportunity WHERE Name = 'test opp 7' LIMIT 1];
        
        List<User> lstUser = [SELECT ID,Rut__C, ProfileID, Name FROM User WHERE UserName = 'ejecutivo2@consorcio.cl.devsales' LIMIT 1];
        List<User> lstUserRisk = [SELECT Id, Rut__C, ProfileID, Name FROM User WHERE UserName = 'ejecutivo4@consorcio.cl.devsales' LIMIT 1];
        System.runAs(lstUser[0]){
        	List<String> lst = ApprovalRequestController.getVisibilityApproval(lstOpp[0].Id);
           System.assertEquals(Constants.NOK, lst[0]);
            
        }
        System.runAs(lstUserRisk[0]){
            List<String> lst = ApprovalRequestController.getVisibilityApproval(lstOpp[0].Id); 
            System.assertEquals(Constants.OK, lst[0]);
        }
    }
    /**
    * @description Test for getApprovalVisibilityProfiles
    * @author fbizamam@everis.com | 16-04-2020 
    * @return void 
    **/
    @isTest
    static void getApprovalVisibilityProfilesTest(){
        List<Opportunity> lstOpp = [SELECT Id, StageName FROM Opportunity WHERE Name = 'test opp 1' LIMIT 1];
        List<User> lstUser = [SELECT Id,Rut__C,ProfileID,Name FROM User WHERE UserName = 'ejecutivo4@consorcio.cl.devsales' LIMIT 1];
        List<User> lstUser2 = [SELECT Id,Rut__C,ProfileID,Name FROM User WHERE UserName = 'ejecutivotest@consorcio.cl.devsales' LIMIT 1];
        system.runAs(lstUser[0]){
            List<String> NOK = ApprovalRequestController.getApprovalVisibilityProfiles();
             System.assertEquals(Constants.NOK, NOK[0]);
        } 
        system.runAs(lstUser2[0]){
            List<String> OK = ApprovalRequestController.getApprovalVisibilityProfiles();
            System.assertEquals(Constants.OK, OK[0]);
        }    
    }
}