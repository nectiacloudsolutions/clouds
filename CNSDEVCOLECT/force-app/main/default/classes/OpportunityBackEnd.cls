/**
 * @File Name          : OpportunityBackEnd.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 5/19/2020, 6:02:39 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/17/2020   eayalcor@everis.com     Initial Version
**/
@RestResource(urlMapping='/opportunity/backend/*')
global without sharing class OpportunityBackEnd {

    private static List<Opportunity> lstOpp = new List<Opportunity>();
    private static List<Opportunity> lstUpsertOpportunity = new List<Opportunity>();
    private static UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();
    private static List<UtilitiesSalesREST.Data> lstData = new List<UtilitiesSalesREST.Data>();

    @HttpPost
    global static UtilitiesSalesREST.Response invokeService(){
        Request newRequest = (Request)JSON.deserialize(RestContext.request.requestBody.toString(), Request.class);

        lstOpp = newRequest.records;
        Set<Id> setIdOpp = new Set<Id>();
        Map<Id,String> mapRtOpp = UtilitiesSales.getSpecifictRTypeOpp(Constants.RECORDTYPES_BANCA);

        for(Opportunity opp : lstOpp){
            setIdOpp.add(opp.Id);
        }

        Map<Id,Opportunity> mapOpp = UtilitiesSales.getOppByIds(setIdOpp);

        for (Opportunity opp : lstOpp) {
            if(opp.Id != null && mapOpp.containsKey(opp.Id)){

                /* VALIDACION DE CAMPOS */
                if(validateFieldRequired(opp)){

                    Opportunity tmpOpp = mapOpp.get(opp.Id);
                    /*
                    * LOGICA PLAN PLUS
                    */
                    if(mapRtOpp.get(tmpOpp.RecordTypeId) == Constants.RECORDTYPE_BANCA_PLAN_PLUS ||
                    mapRtOpp.get(tmpOpp.RecordTypeId) == Constants.RECORDTYPE_BANCA_PLAN_PLUS_LECTURA ){

                        oppPlanPlus(opp);
    
                    /*
                    * LOGICA HIPOTECARIO
                    */
                    }else if(mapRtOpp.get(tmpOpp.RecordTypeId) == Constants.RECORDTYPE_BANCA_HIPOTECARIO ||
                    mapRtOpp.get(tmpOpp.RecordTypeId) == Constants.RECORDTYPE_BANCA_HIPOTECARIO_LECTURA ){
                        addDataResponse(false, 'ERROR_OPPHIPOTECARIO_SINDESARROLLO', Constants.RESPONSE_400,opp);
                    }else{
                        addDataResponse(false, 'ERROR_TIPOOPPORTUNIDAD_NOCORRESPONDE', Constants.RESPONSE_400,opp);
                    }
                }else{
                    //campos obligatorios a llenar
                    addDataResponse(false, 'ERROR_FALTANCAMPOSREQUERIDOS', Constants.RESPONSE_400,opp);
                }
            }else{
                addDataResponse(false, 'ERROR_EXCEPTION-IDNULL-OR-NOTEXIST', Constants.RESPONSE_400,opp);
            }
        }

        //UPSERT LEADS
        if(lstUpsertOpportunity.size()>0){upsertOpp(lstUpsertOpportunity);}

        response.response = lstData;

        return response;
    }

    /**
    * @description Metodo para validar el ingreso de campos requeridos
    * @author eayalcor@everis.com | 5/19/2020 
    * @param Opportunity opp 
    * @return Boolean 
    **/
    private static Boolean validateFieldRequired(Opportunity opp){
        Boolean isValid = true;

        if(String.isBlank(opp.Etapa_Backend_sales__c) || opp.Etapa_Backend_sales__c == null){
            isValid = false;
        }else if(String.isBlank(opp.Id_Etapa_Backend_sales__c) || opp.Id_Etapa_Backend_sales__c == null){
            isValid = false;
        }else if(String.isBlank(opp.Estado_Backend_sales__c) || opp.Estado_Backend_sales__c == null){
            isValid = false;
        }else if(String.isBlank(opp.Id_Estado_Backend_sales__c) || opp.Id_Estado_Backend_sales__c == null){
            isValid = false;
        }

        return isValid;
    }


    /**
    * @description Logica para Banca Plan Plus
    * @author eayalcor@everis.com | 5/19/2020 
    * @return void 
    **/
    private static void oppPlanPlus(Opportunity opp){
        Datetime dt = (Datetime)opp.Fecha_Cambio_de_Estado_Backend_sales__c; 
        Map<String,FinalStageBancaBE__c> mapStageFinal = UtilitiesSales.getStageFinalBE(Constants.PRODUCT_PLAN_PLUS);
        Map<String,String> mapLoss = UtilitiesSales.getReasonLossBE(Constants.PRODUCT_PLAN_PLUS);

        /* LOGICA ETAPA ENTREGA */ 
        if(opp.Id_Etapa_Backend_sales__c.equalsIgnoreCase(mapStageFinal.get(Constants.OPP_PPLUS_GENERACION_ENTREGA).Id_Stage__c)){
            opp.Estado_Generacion_y_Entrega_sales__c = opp.Estado_Backend_sales__c;
            opp.Fecha_de_Cambio_de_Estado_Entrega_sales__c = dt.date();
            if(opp.Id_Estado_Backend_sales__c.equalsIgnoreCase(mapStageFinal.get(Constants.OPP_PPLUS_GENERACION_ENTREGA).Id_FinalStatus__c)){
                opp.StageName = Constants.PLAN_PLUS_STATUS_ACTIVACION;                             
            }

        /* LOGICA ETAPA ACTIVACION */
        }else if(opp.Id_Etapa_Backend_sales__c.equalsIgnoreCase(mapStageFinal.get(Constants.OPP_PPLUS_ESTADO_ACTIVACION).Id_Stage__c)){
            opp.Estado_activacion_sales__c = opp.Estado_Backend_sales__c;
            opp.Fecha_cambio_estado_activacion_sales__c = dt.date();
            if(opp.Id_Estado_Backend_sales__c.equalsIgnoreCase(mapStageFinal.get(Constants.OPP_PPLUS_ESTADO_ACTIVACION).Id_FinalStatus__c)){
                opp.StageName = Constants.PLAN_PLUS_STATUS_CIERRE_GANADA;
            }      
        }else if(opp.Id_Etapa_Backend_sales__c.equalsIgnoreCase(mapStageFinal.get(Constants.OPP_PPLUS_ESTADO_CANCELACION).Id_Stage__c)){
            opp.StageName = Constants.PLAN_PLUS_STATUS_CIERRE_PERDIDA;
            opp.Loss_Reason__c = mapLoss.get(opp.Id_Estado_Backend_sales__c);
        }
        lstUpsertOpportunity.add(opp);
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 4/20/2020 
    * @param List<Lead> lst 
    * @return void 
    **/
    private static void upsertOpp(List<Opportunity> lst){
        Set<Id> lstIdOpp = new Set<Id>();
        Map<Id,UtilitiesSalesREST.Data> mapOpp = new Map<Id,UtilitiesSalesREST.Data>();

        List<Database.UpsertResult> updateResults = Database.upsert(lst,false);
        for(Integer i=0;i<updateResults.size();i++){
            UtilitiesSalesREST.Data data = new UtilitiesSalesREST.Data();
            if (updateResults.get(i).isSuccess()){
                lstIdOpp.add(updateResults.get(i).getId());
                data.success = true;
                data.message = 'OK_'+updateResults.get(i).getId();
                data.statusCode = Constants.RESPONSE_200;
                mapOpp.put(updateResults.get(i).getId() ,data);

            }else if (!updateResults.get(i).isSuccess()){
                // DML operation failed
                Database.Error error = updateResults.get(i).getErrors().get(0);
                String failedDML = error.getMessage();
                lstIdOpp.add(lst.get(i).Id);
                data.success = false;
                data.message = 'ERROR_EXCEPTION-'+failedDML;
                data.statusCode = Constants.RESPONSE_400;
                mapOpp.put(lst.get(i).Id, data);
            }

        }
        addDataResponseDbResult(lstIdOpp,mapOpp);
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 4/20/2020 
    * @param Set<Id> lstIdLeads 
    * @param Map<Id UtilitiesSalesREST.Data> mapLeads 
    * @return void 
    **/
    private static void addDataResponseDbResult(Set<Id> lstIds, Map<Id,UtilitiesSalesREST.Data> mapOpps){
        List<Opportunity> lstOppTmp = [SELECT Id,Numero_Op_Comercializadora_sales__c,Estado_Backend_sales__c,
                                Id_Estado_Backend_sales__c,Etapa_Backend_sales__c,Id_Etapa_Backend_sales__c,
                                Fecha_Cambio_de_Estado_Backend_sales__c,BackEnd_Origen_sales__c FROM Opportunity WHERE Id IN : lstIds];
        
        for(Opportunity tmp : lstOppTmp){
            if(mapOpps.get(tmp.Id) != null){
                UtilitiesSalesREST.Data data = mapOpps.get(tmp.Id);
                data.jsonMap = JSON.serialize(tmp);
                lstData.add(data);
            }
        }
    }


    /**
    * @description 
    * @author eayalcor@everis.com | 4/20/2020 
    * @param Boolean success 
    * @param String message 
    * @param String statusCode 
    * @param Lead lead 
    * @return void 
    **/
    private static void addDataResponse(Boolean success, String message, String statusCode,Opportunity opp){
        UtilitiesSalesREST.Data data = new UtilitiesSalesREST.Data();
        data.success = success;
        data.message = message;
        data.statusCode = statusCode;
        data.jsonMap = JSON.serialize(opp);
        lstData.add(data);
    }

    global class Request{
        public List<Opportunity> records;
    }
}