/**
 * @File Name          : OpportunityBackEnd_Test.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 4/23/2020, 6:12:40 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/23/2020   eayalcor@everis.com     Initial Version
**/
@isTest
private with sharing class OpportunityBackEnd_Test {
    @testSetup
    private static void loadDataConfig(){
        TestFactorySales.populateOrg();
        
        //Final Stage CS
        insert new FinalStageBancaBE__c(Name='GENERACION_ENTREGA',FinalStatus__c ='Mecanizado', Id_FinalStatus__c  = '5', 
                                    Id_Stage__c = '4' , Stage__c = 'Generación y Entrega', Product_Bank__c = 'PLANPLUS');
        
        insert new FinalStageBancaBE__c(Name='ACTIVACION',FinalStatus__c ='Cierre', Id_FinalStatus__c  = '8', 
                                    Id_Stage__c = '6' , Stage__c = 'Activación', Product_Bank__c = 'PLANPLUS');
        
        insert new FinalStageBancaBE__c(Name='CANCELACION',FinalStatus__c ='Cierre Perdida', Id_FinalStatus__c  = '-', 
                                    Id_Stage__c = '8' , Stage__c = 'Cancelación', Product_Bank__c = 'PLANPLUS');
        
        //Loss Reason CS
        insert new LossReasonBank__c (Name = '16', Product_Bank__c  = 'PLANPLUS', ReasonBE__c	= 'Desiste', ReasonSF__c	= 'Desistido');
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 4/23/2020 
    * @return void 
    **/
    @isTest
    static void opportunityBackEndTest(){
        OpportunityBackEnd.Request request = new OpportunityBackEnd.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        List<Opportunity> lstOpps = new List<Opportunity>();

        Id rtPlanplus = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.OPPORTUNITY 
                    AND DeveloperName =: Constants.RECORDTYPE_BANCA_PLAN_PLUS LIMIT 1].Id;
        
        Account acc = [SELECT Id FROM Account WHERE Rut__C = : '10854082-6'];
        
        Test.startTest();

        Opportunity opp = new Opportunity();
        opp.Name = 'Test1';
        opp.StageName = Constants.OPPORTUNITY_STAGE_CONTACTO;
        opp.CloseDate = Date.today();
        opp.AccountId = acc.Id;
        opp.Numero_Op_Comercializadora_sales__c = '12345';
        opp.Estado_Backend_sales__c = 'Cierre';
        opp.Id_Estado_Backend_sales__c = '8';
        opp.Etapa_Backend_sales__c = 'Activación';
        opp.Id_Etapa_Backend_sales__c = '6';
        opp.Fecha_Cambio_de_Estado_Backend_sales__c = Datetime.now();
        opp.BackEnd_Origen_sales__c = 'Cumbres'; 
        opp.recordTypeId = rtPlanplus;
        lstOpps.add(opp);

        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test2';
        opp2.StageName = Constants.OPPORTUNITY_STAGE_CONTACTO;
        opp2.CloseDate = Date.today();
        opp2.AccountId = acc.Id;
        opp2.Numero_Op_Comercializadora_sales__c = '12345';
        opp2.Estado_Backend_sales__c = 'Mecanizado y Entrega';
        opp2.Id_Estado_Backend_sales__c = '5';
        opp2.Etapa_Backend_sales__c = 'Generación y Entrega';
        opp2.Id_Etapa_Backend_sales__c = '4';
        opp2.Fecha_Cambio_de_Estado_Backend_sales__c = Datetime.now();
        opp2.BackEnd_Origen_sales__c = 'Cumbres'; 
        opp2.recordTypeId = rtPlanplus;
        lstOpps.add(opp2);
        
        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Test2';
        opp3.StageName = Constants.OPPORTUNITY_STAGE_CONTACTO;
        opp3.CloseDate = Date.today();
        opp3.AccountId = acc.Id;
        opp3.Numero_Op_Comercializadora_sales__c = '12345';
        opp3.Estado_Backend_sales__c = 'Desistido';
        opp3.Id_Estado_Backend_sales__c = '16';
        opp3.Etapa_Backend_sales__c = 'Cancelación';
        opp3.Id_Etapa_Backend_sales__c = '8';
        opp3.Fecha_Cambio_de_Estado_Backend_sales__c = Datetime.now();
        opp3.BackEnd_Origen_sales__c = 'Cumbres'; 
        opp3.recordTypeId = rtPlanplus;
        lstOpps.add(opp3);
        
        Opportunity opp4 = new Opportunity();
        opp4.Name = 'Test2';
        opp4.StageName = Constants.OPPORTUNITY_STAGE_CONTACTO;
        opp4.CloseDate = Date.today();
        opp4.AccountId = acc.Id;
        opp4.Numero_Op_Comercializadora_sales__c = '12345';
        opp4.Estado_Backend_sales__c = '';
        opp4.Id_Estado_Backend_sales__c = '';
        opp4.Etapa_Backend_sales__c = '';
        opp4.Id_Etapa_Backend_sales__c = '';
        opp4.Fecha_Cambio_de_Estado_Backend_sales__c = Datetime.now();
        opp4.BackEnd_Origen_sales__c = ''; 
        opp4.recordTypeId = rtPlanplus;
        lstOpps.add(opp4);

        insert lstOpps;

        request.records = lstOpps;

        String json = JSON.serialize(request);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/opportunity/backend/';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        Test.stopTest();

        response = OpportunityBackEnd.invokeService();
        
        System.assertEquals(response.response.size(), 4);

    }

}