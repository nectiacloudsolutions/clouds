/**
 * @File Name          : OfertaAnalytics.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 6/12/2020, 1:46:19 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    5/29/2020   eayalcor@everis.com     Initial Version
**/
@RestResource(urlMapping='/oferta/*')
global without sharing class OfertaAnalytics {
    /*
    * Listas estaticas Objeto Oferta y Response 
    */
    private static List<Oferta__c> lstOferta = new List<Oferta__c>();
    private static List<Oferta__c> lstUpsertOferta = new List<Oferta__c>();
    private static UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();
    private static List<UtilitiesSalesREST.Data> lstData = new List<UtilitiesSalesREST.Data>();

    @HttpPost
    global static UtilitiesSalesREST.Response invokeService(){

        Set<String> rutAccount = new Set<String>();
        Set<String> rutExecutive = new Set<String>();
        Request newRequest = (Request)JSON.deserialize(RestContext.request.requestBody.toString(), Request.class);

        lstOferta = newRequest.records;

        for(Oferta__c obj : lstOferta){
            rutAccount.add(obj.Rut_Cliente_sales__c);

            if(obj.Ejecutivo_sales__c != null && obj.Ejecutivo_sales__c.contains('-')) { 
                rutExecutive.add(obj.Ejecutivo_sales__c.remove('-'));
            } else{
                rutExecutive.add(obj.Ejecutivo_sales__c);
            }
        }

        Map<String,List<SObject>> mapObject = UtilitiesSales.existAccountLead(rutAccount);
        Map<String,Id> mapIdExecutive = UtilitiesSales.getIdsExecutive(rutExecutive);
        System.debug('Maps Ejecutivos: '+ mapIdExecutive);

        List<Account> lstAcc = mapObject.get(Constants.ACCOUNT);

        for(Oferta__c obj : lstOferta){
            Boolean existExec = true;
            if(validateFieldRequired(obj)){

                String rutExec = obj.Ejecutivo_sales__c.contains('-') ? obj.Ejecutivo_sales__c.remove('-') : obj.Ejecutivo_sales__c; 
            
                if(mapIdExecutive.get(rutExec) != null){
                    obj.Owner_Opp_sales__c = mapIdExecutive.get(rutExec);
                }else{
                    existExec = false;
                }
            
                if(existExec){
            
                    Boolean isAccount = false;
                    for(Account acc : lstAcc){
                        if(obj.Rut_Cliente_sales__c.equals(acc.Rut__C)){
                            obj.AccountId__c = acc.Id;
                            obj.Estado_Oferta_sales__c = Constants.OFERTA_NOGESTIONADO;
                            obj.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: Constants.OFERTA_SALES_RECORDTYPE AND SobjectType =: Constants.OFERTA LIMIT 1].Id;
                            lstUpsertOferta.add(obj);
                            isAccount = true;
                            break;
                        }
                    }
            
                    if(!isAccount){
                        addDataResponse(false, 'ERROR_ACCOUNTDOESNOTEXIT', Constants.RESPONSE_400,obj);
                    }
                }else{
                    addDataResponse(false, 'ERROR_EXECUTIVEDOESNOTEXIT', Constants.RESPONSE_400,obj);
                }
            }else{
                addDataResponse(false, 'ERROR_REQUIREDDATA', Constants.RESPONSE_400,obj);
            }
        }

        //UPSERT Custom Object Oferta
        if(lstUpsertOferta.size()>0){upsertOferta(lstUpsertOferta);}

        response.response = lstData;

        return response;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 5/29/2020 
    * @param Opportunity opp 
    * @return Boolean 
    **/
    private static Boolean validateFieldRequired(Oferta__c obj){
        Boolean isValid = true;

        if(String.isBlank(obj.Name) || obj.Name == null){
            isValid = false;
        }else if(String.isBlank(obj.Ejecutivo_sales__c) || obj.Ejecutivo_sales__c == null){
            isValid = false;
        }else if(String.isBlank(obj.Vigencia_Oferta_sales__c.format())){ 
            isValid = false;
        }

        return isValid;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 5/29/2020 
    * @param List<SObject> lst 
    * @return void 
    **/
    private static void upsertOferta(List<SObject> lst){
        Set<Id> lstIds = new Set<Id>();
        Map<Id,UtilitiesSalesREST.Data> mapData = new Map<Id,UtilitiesSalesREST.Data>();

        List<Database.UpsertResult> updateResults = Database.upsert(lst,false);
        for(Integer i=0;i<updateResults.size();i++){
            UtilitiesSalesREST.Data data = new UtilitiesSalesREST.Data();
            if (updateResults.get(i).isSuccess()){
                lstIds.add(updateResults.get(i).getId());
                data.success = true;
                data.message = 'OK_'+updateResults.get(i).getId();
                data.statusCode = Constants.RESPONSE_200;
                mapData.put(updateResults.get(i).getId() ,data);

            }else if (!updateResults.get(i).isSuccess()){
                // DML operation failed
                Database.Error error = updateResults.get(i).getErrors().get(0);
                String failedDML = error.getMessage();
                lstIds.add(lst.get(i).Id);
                data.success = false;
                data.message = 'ERROR_EXCEPTION-'+failedDML;
                data.statusCode = Constants.RESPONSE_400;
                data.jsonMap = JSON.serialize(lst.get(i));
                lstData.add(data);
            }

        }
        addDataResponseDbResult(lstIds,mapData);
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 5/29/2020 
    * @param Set<Id> lstIds 
    * @param Map<Id UtilitiesSalesREST.Data> mapOpps 
    * @return void 
    **/
    private static void addDataResponseDbResult(Set<Id> lstIds, Map<Id,UtilitiesSalesREST.Data> mapOpps){
        List<Oferta__c> lstTmp= [SELECT Id,Name,AccountId__c,Ejecutivo_sales__c,Rut_Cliente_sales__c,
                        Familia_Producto_sales__c,Vigencia_Oferta_sales__c FROM Oferta__c WHERE Id IN : lstIds];
        
        for(Oferta__c tmp : lstTmp){
            if(mapOpps.get(tmp.Id) != null){
                UtilitiesSalesREST.Data data = mapOpps.get(tmp.Id);
                data.jsonMap = JSON.serialize(tmp);
                lstData.add(data);
            }
        }
    }



    /**
    * @description 
    * @author eayalcor@everis.com | 5/29/2020 
    * @param Boolean success 
    * @param String message 
    * @param String statusCode 
    * @param sObject obj 
    * @return void 
    **/
    private static void addDataResponse(Boolean success, String message, String statusCode,sObject obj){
        UtilitiesSalesREST.Data data = new UtilitiesSalesREST.Data();
        data.success = success;
        data.message = message;
        data.statusCode = statusCode;
        data.jsonMap = JSON.serialize(obj);
        lstData.add(data);
    }

    global class Request{
        public List<Oferta__c> records;
    }
}