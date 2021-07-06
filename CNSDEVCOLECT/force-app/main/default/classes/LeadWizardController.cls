/*********************************************************************************************************
@Author       zsuanaza@everis.com
@name         leadWizardController
@CreateDate   30/09/2019
@Description  Controller of the Lead Wizard Component
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
30/09/2019                    zsuanaza@everis.com           W-000065 - (LEAD) Crear nuevo LEAD
**********************************************************************************************************/
public without Sharing class LeadWizardController {
     /*
      * 
      * @description       This method verify if the RUT is an account or lead
      * @param1            client RUT 
      * @return            void
      * @throws            NA
	  */
    @AuraEnabled 
    public static Map<String,List<SObject>> validatedRUT(String RUT){ 
        Map<String,List<SObject>> mapResult = new Map<String,List<SObject>>();
        Set<String> set1 = new Set<String>{RUT};
        mapResult = UtilitiesSales.existAccountLead(set1);
        return mapResult;
    }
     /**
      * @description       This method call Analytics to get information about a client sending the RUT
      * @param1            client RUT 
      * @return            SalesCallout.leadData the response of the callout
      * @throws            NA
	  */
    @AuraEnabled
    public static string consultAnalyticsForLead(string RUT){
        string Res;
        SalesCallout co = new SalesCallout(CONSTANTS.ANALYTICSLEAD);
        List<lead> leadList = new List<lead>();
        leadList.add(new lead(numero_de_documento_sales__c = RUT, tipo_documento_sales__c = CONSTANTS.RUT));
        string res2 = co.consultLeadAnalyticsMassive(leadList,CONSTANTS.CONSULT);
		system.debug('Respuesta----->'+res2);
        return res2;
    }
     /**
      * @description       This method call Analytics to get information about a client sending the RUT
      * @param1            client RUT 
      * @return            SalesCallout.leadData the response of the callout
      * @throws            NA
	  */
    @AuraEnabled
    public static boolean changeLeadOwner(String leadID, String newOwnerId ){
        system.debug('Change owner ---------------->'+leadID);
        return UtilitiesSales.changeLeadOwner(leadID, newOwnerId);
        
    }
    @AuraEnabled
    public static String createLead(String fName, String lName, String phone, String email, String RUT){
        
        Id rtId = [SELECT Id FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_SALES_LEAD_PERSONAS AND SObjectType =: Constants.LEAD LIMIT 1].Id;
		
        lead l = new lead(numero_de_documento_sales__c = RUT,
                          tipo_documento_sales__c = CONSTANTS.RUT,
                          FirstName = fName,
                          LastName = lName,
                          Email = email,
                          Phone = phone,
                          RecordTypeId = rtId);
        try{
            insert l;
			return l.Id;            
        }catch(exception e){
            return 'ERROR: '+e;
        }
    }
    @AuraEnabled
    public static boolean notifyExecutive(String leadId){
        return UtilitiesSales.notifyExecutive(leadId);
    }
    
}