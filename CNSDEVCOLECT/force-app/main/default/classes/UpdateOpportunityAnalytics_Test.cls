@isTest
private with sharing class UpdateOpportunityAnalytics_Test {
	@testSetup
    private static void loadDataConfig(){
        TestFactorySales.populateOrg();
    }
    
	@isTest
    static void UpdateOppAnalytics_evaluation(){
        
        UpdateOpportunityAnalytics.Request request = new UpdateOpportunityAnalytics.Request();
        UtilitiesOppREST.Response response = new UtilitiesOppREST.Response();
        
        
        List<Opportunity> lstOpp =[SELECT id,StageName,OwnerId FROM Opportunity];
        system.debug(lstOpp);
        lstOpp[0].StageName = Constants.HIPOTECARIO_STATUS_EVALUACION;
        update lstOpp;
        string json= ('{"Fecha":"2009-10-27","registros":[{"idOportunidad":"'+lstOpp[0].id+'","estado":"Cierre Ganada","usuario":"111111","mensaje":"Hola mundo","fecha":"2009-10-27"},{"idOportunidad":"'+lstOpp[1].id+'","estado":"Cierre Ganada","usuario":"22222","mensaje":"Hola mundo","fecha":"2009-10-27"},{"idOportunidad":"'+lstOpp[2].id+'","estado":"Cierre Ganada","usuario":"22222","mensaje":"Hola mundo","fecha":"2009-10-27"}]}');
        System.debug(json);
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Opportunity';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;
        
        response= UpdateOpportunityAnalytics.UpdateOpp();
        System.assertEquals(response.resultados[0].estado,Constants.OK);
        
    }
    @isTest
    static void CreateOppAnalytics_evaluation(){
        
        UpdateOpportunityAnalytics.RequestCreate request = new UpdateOpportunityAnalytics.RequestCreate();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();
        
        //producto
        //account
        //user
        List<Account> lstAcc = [SELECT id,rut__c,name FROM Account LIMIT 1 ];
        System.debug('CUENTAS : '+lstAcc);
        List<User> lstUs = [SELECT Id,Rut__C FROM User WHERE isActive = true AND rut__c != null AND profileId IN : getProfileInjectionLead() LIMIT 1];
        System.debug('USUARIOS : '+lstUs);
        List<Product2> lstPro = [SELECT id,ProductCode FROM Product2 LIMIT 1];
        System.debug('PRODUCTOS : '+lstPro);
        string json= ('{"registros":[{"ProductCode":"'+lstPro[0].ProductCode+'","rut_cuenta":"'+lstAcc[0].rut__c+'","Descripcion":"Lorem ipsum dolor sit amet","rut_ejecutivo":"'+lstUs[0].rut__c+'"},{"ProductCode":"'+lstPro[0].ProductCode+'","rut_cuenta":"'+lstAcc[0].rut__c+'","Descripcion":"Lorem ipsum dolor sit amet","rut_ejecutivo":"183234939"},{"ProductCode":"'+lstPro[0].ProductCode+'","rut_cuenta":"222222-7","Descripcion":"Lorem ipsum dolor sit amet","rut_ejecutivo":"'+lstUs[0].rut__c+'"},{"ProductCode":"99999","rut_cuenta":"'+lstAcc[0].rut__c+'","Descripcion":"Lorem ipsum dolor sit amet","rut_ejecutivo":"'+lstUs[0].rut__c+'"}]}}');
        
        System.debug('JSON :' +json);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Opportunity';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;
        
        response= UpdateOpportunityAnalytics.CreateOpp();
        System.assertEquals(response.response[0].statusCode,Constants.RESPONSE_400);
    }
    
    private static List<Id> getProfileInjectionLead(){
        List<String> lstNames = new List<String>();
        
        List<ProfileInjectionLead__c > lstProfile = new List<ProfileInjectionLead__c>();
        
        lstProfile = [Select Name, ProfileName__c
                        From  ProfileInjectionLead__c];
        
        for(ProfileInjectionLead__c lst : lstProfile){
            lstNames.add(lst.ProfileName__c);
        }
        
        List<Id> lstIds = new List<Id>();

        List<Profile> lstPro = [SELECT Id FROM Profile WHERE Name IN : lstNames];
        for(Profile pro : lstPro){
            lstIds.add(pro.Id);
        }
        
        return lstIds;
    }

}