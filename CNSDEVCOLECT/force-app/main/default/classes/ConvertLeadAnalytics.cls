/*********************************************************************************************************
@Author       eayalcor@everis.com
@name         CreateLeadAnalytics
@CreateDate   03/10/2019
@Description  Service Rest create Lead from Analytics 
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
03/10/2019                    eayalcor@everis.com           Initial Version
14/10/2019                    eayalcor@everis.com           Validation, duplicate error.
**********************************************************************************************************/
@RestResource(urlMapping='/LeadConvert/*')
global without sharing class ConvertLeadAnalytics {
    
    private static List<Lead> lstLead = new List<Lead>();
    private static List<Id> lstLeadtoConvert = new List<Id>();
    private static List<Lead> lstLeadtoUpdate = new List<Lead>();
    private static UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();
    private static List<UtilitiesSalesREST.Data> lstData = new List<UtilitiesSalesREST.Data>();
    private static Map<String,String> mapOwner = new Map<String,String>();
    private static Set<String> lstIdError = new Set<String>();
    private static Set<String> lstIdOK = new Set<String>();
    
    
    /**
* @description       This method invoke service REST
* @return            Response response
* @throws            NA
*/
    @HttpPost
    global static UtilitiesSalesREST.Response convertLeads(){
        
        Request newRequest = (Request)JSON.deserialize(RestContext.request.requestBody.toString(), Request.class);
        System.debug('Entro convertLeads request:'+newRequest);
        lstLead = newRequest.records;
        
        Set<String> rutLeads = new Set<String>();
        Set<String> rutExecutive = new Set<String>();
        
        for(Lead l : lstLead){
            
            rutLeads.add(l.numero_de_documento_sales__c);
            if(l.rut_ejecutivo_sales__c != null && l.rut_ejecutivo_sales__c.contains('-')) { 
                rutExecutive.add(l.rut_ejecutivo_sales__c.remove('-'));
            } else{
                rutExecutive.add(l.rut_ejecutivo_sales__c);
            }
        }
        
        
        Map<String,Id> mapIdExecutive = UtilitiesSales.getIdsExecutive(rutExecutive);
        
        Map<String,List<SObject>> mapObject = UtilitiesSales.existAccountLead(rutLeads);
        
        List<Account> lstAcc = mapObject.get(Constants.ACCOUNT);
        
        List<Lead> lstLeadExist = mapObject.get(Constants.LEAD);

        for(Lead lead : lstLead){

            Boolean existExec = true;    
            Boolean isAccount = false;
            
            String rutExec;
            if(lead.rut_ejecutivo_sales__c!=null){
               rutExec = lead.rut_ejecutivo_sales__c.contains('-') ? lead.rut_ejecutivo_sales__c.remove('-') : lead.rut_ejecutivo_sales__c;  
            }else{
                rutExec = null;
            }          
                if(mapIdExecutive.get(rutExec) != null){
                    lead.OwnerId = mapIdExecutive.get(rutExec);
                    System.debug('Existe rut ejecutivo');
                }else{
                    existExec = false;
                    System.debug('No existe rut ejecutivo');
                    //addDataResponse(false,'ERROR_Ejecutivo',Constants.RESPONSE_400,null);
                }
                
                if(lead.numero_de_documento_sales__c != null){
                    
                    //Validación Account
                    for(Account acc : lstAcc){
                        System.debug('Entro lista de accounts relacionadas a lead');
                        if(lead.numero_de_documento_sales__c.equals(acc.Rut__C)){
                            AccountObj accObj = new AccountObj();
                            accObj.Id = acc.Id;                                     
                            accObj.rut_ejecutivo_sales = rutExec;
                            accObj.numero_de_documento_sales = lead.numero_de_documento_sales__c;
                            addDataResponse(false,'ERROR_ACCOUNT',Constants.RESPONSE_400,accObj);
                            isAccount = true;
                            break;
                        }
                    }        
                    if(!isAccount){
                        //Validación Lead
                        if (lstLeadExist != null && !lstLeadExist.isEmpty()) {
                            for(Lead l : lstLeadExist){
                                          
                                if(lead.numero_de_documento_sales__c.equals(l.numero_de_documento_sales__c)){
                                    if(!existExec){
                                        lead.OwnerId = l.OwnerId;
                                    }
                                    lstLeadtoConvert.add(l.Id);
                                    lead.Flag_Lead_sales__c = false;
                                    lead.Id = l.Id;
                                    lead.email = lead.email == null ? l.email : lead.email;
                                    lead.phone = lead.phone == null ? l.phone : lead.phone;
                                    
                                    lstLeadtoUpdate.add(lead);
                                    break;
                                }
                            }
                        }else{
                            addDataResponse(false, 'ERROR_LEAD_DOESNT_EXISTS', Constants.RESPONSE_400,null);
                        }
                        
                    }
                    
                }else{
                    System.debug('Entro rut igual null');
                    addDataResponse(false,'ERROR_N°DOCUMENTO_LEAD',Constants.RESPONSE_400,null);
                }        
        }
        if(lstLeadtoUpdate != null && !lstLeadtoUpdate.isEmpty()){
            
            update lstLeadtoUpdate;
            
            if(lstLeadtoConvert != null && !lstLeadtoConvert.isEmpty()){
                leadToConvert();
            }
        }
        
        
        response.response = lstData;
        
        return response;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 31-01-2020 
    * @return void 
    **/
    private static void leadToConvert(){
        updateEventToConvert(lstLeadtoConvert);

        List<Database.LeadConvertResult> lcr = UtilitiesSales.autoConvertLead(lstLeadtoConvert);

        for(Database.LeadConvertResult lc : lcr ){
            String accId = lc.getAccountId();
            String leadId = lc.getLeadId();
            if(lc.isSuccess()){                     
                lstIdOK.add(accId);
            }else{
                lstIdError.add(leadId);
            }
            
        } 

        /************************** RESPONSE OK **************************/
        List<Account> lstAccount = [SELECT Id,Rut__C,OwnerId FROM Account WHERE Id IN : lstIdOK];
        Set<String> idOwner = new Set<String>();
        for (Account A: lstAccount) {
            idOwner.add(A.OwnerId);
        }
        Map<Id,String> getOwner = getOwner(idOwner);
        for(Account acc : lstAccount){
            AccountObj data = new AccountObj();
            data.Id = acc.Id;                                     
            data.numero_de_documento_sales = acc.Rut__c;
            data.rut_ejecutivo_sales = UtilitiesSales.formatRut(getOwner.get(acc.OwnerId), 'WITHOUTDOT');//getOwner.get(acc.OwnerId);
            addDataResponse(true, 'OK', Constants.RESPONSE_200,data);
        }

        /************************** RESPONSE ERROR **************************/
        List<Lead> lstLeadTmp = [SELECT numero_de_documento_sales__c, tipo_documento_sales__c FROM Lead 
            WHERE Id IN : lstIdError];
        
        for(Lead lead : lstLeadTmp){
            AccountObj data = new AccountObj();
            data.Id = null;                                     
            data.numero_de_documento_sales = lead.numero_de_documento_sales__c;
            data.rut_ejecutivo_sales = lead.rut_ejecutivo_sales__c;
            addDataResponse(false, 'ERROR_CONVERT', Constants.RESPONSE_400,data);
        }
    }

    
    /**
    * @description 
    * @author eayalcor@everis.com | 31-01-2020 
    * @param List<Id> lstIds 
    * @return void 
    **/
    private static void updateEventToConvert(List<Id> lstIds){
            
        List<Event> lstEventUpdate = [SELECT Id,flag_convertido_sales__c FROM Event
                                    WHERE whoId IN : lstIds];
        
        for(Event evt : lstEventUpdate){    
            evt.flag_convertido_sales__c = true;
        }
        
        update lstEventUpdate;
    }

    /**
    * @description 
    * @author pcelis@everis.com | 10-02-2020 
    * @param Set<String> lstId 
    * @return Map<Id, String> 
    **/
    private static Map<Id,String> getOwner(Set<String> lstId){
        Map<Id,String> getRut = new Map<Id,String>();
        for (User us: [SELECT id,RUT__c  FROM User WHERE id IN:lstId]) {
            getRut.put(us.Id, us.RUT__c);
        }
        return getRut;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 31-01-2020 
    * @param Boolean success 
    * @param String message 
    * @param String statusCode 
    * @param AccountObj acc 
    * @return void 
    **/
    private static void addDataResponse(Boolean success, String message, String statusCode, AccountObj acc){
        UtilitiesSalesREST.Data data = new UtilitiesSalesREST.Data();
        data.success = success;
        data.message = message;
        data.statusCode = statusCode;
        data.jsonMap = JSON.serialize(acc);
        lstData.add(data); 
    }
    
    global class Request{
        public List<Lead> records;
    }
    
    global class AccountObj{
        public String Id {get;set;}
        public String rut_ejecutivo_sales {get;set;}
        public String numero_de_documento_sales {get;set;}
    }
    
}