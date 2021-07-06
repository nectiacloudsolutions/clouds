/*********************************************************************************************************
@Author       anibal.bustos@consorcio.cl
@name         UpdateLeadAnalytics
@CreateDate   25/08/2020
@Description  Service Rest update Lead from Analytics 
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
25/08/2020                    anibal.bustos@consorcio.cl           Initial Version
**********************************************************************************************************/
@RestResource(urlMapping='/UpdateLeadAnalytics/*')
global with sharing class UpdateLeadAnalytics {

    private static List<Lead> lstLead = new List<Lead>();
    private static List<Lead> lstUpdateLead = new List<Lead>();
    private static UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();
    private static List<UtilitiesSalesREST.Data> lstData = new List<UtilitiesSalesREST.Data>();
    private static Set<String> idsUpdate = new Set<String>();

    @HttpPost
    global static UtilitiesSalesREST.Response UpdateLeadAnalytics() {

        Request newRequest = (Request)JSON.deserialize(RestContext.request.requestBody.toString(), Request.class);
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

			lead.origen_analytics_sales__c = true;
            Boolean isAccount = false;
            Boolean existExec = true;
            Boolean updateLead = true;

            if(lead.rut_ejecutivo_sales__c != null){

                String rutExec = lead.rut_ejecutivo_sales__c.contains('-') ? lead.rut_ejecutivo_sales__c.remove('-') : lead.rut_ejecutivo_sales__c; 
                
                if(mapIdExecutive.get(rutExec) != null){
                    lead.OwnerId = mapIdExecutive.get(rutExec);
                }else{
                    existExec = false;
                    updateLead = false;
                }

                if(lead.numero_de_documento_sales__c != null){
                    for(Account acc : lstAcc){
                        if(lead.numero_de_documento_sales__c.equals(acc.Rut__C)){
                            updateLead = false;
                            isAccount = true;
                            addDataResponse(false,'ERROR_ACCOUNT',Constants.RESPONSE_400,lead);
                            break;
                        }
                    }

                    if(!isAccount){
                        for(Lead l : lstLeadExist){
                            if(lead.numero_de_documento_sales__c.equals(l.numero_de_documento_sales__c)){
                                if(!existExec){
                                    updateLead = false;
                                    addDataResponse(false,'ERROR_EXECUTIVE',Constants.RESPONSE_400,lead);
                                }else{
                                    // se actualiza
                                    idsUpdate.add(l.Id);
                                    if (!String.isBlank(lead.FirstName) && lead.FirstName != null){ l.FirstName = lead.FirstName;}
                                    if (!String.isBlank(lead.LastName) && lead.LastName != null){ l.LastName = lead.LastName;}
                                    if (!String.isBlank(lead.motherlastname_sales__c) && lead.motherlastname_sales__c != null){ l.motherlastname_sales__c = lead.motherlastname_sales__c;}
                                    if (!String.isBlank(lead.rut_ejecutivo_sales__c) && lead.rut_ejecutivo_sales__c != null){ l.rut_ejecutivo_sales__c = lead.rut_ejecutivo_sales__c;}
                                    if (!String.isBlank(lead.numero_de_documento_sales__c) && lead.numero_de_documento_sales__c != null){ l.numero_de_documento_sales__c = lead.numero_de_documento_sales__c;}
                                    if (!String.isBlank(lead.Phone) && lead.Phone != null){ l.Phone = lead.Phone;}
                                    if (!String.isBlank(lead.other_phone_sales__c) && lead.other_phone_sales__c != null){ l.other_phone_sales__c = lead.other_phone_sales__c;}
                                    if (!String.isBlank(lead.other_phone2_sales__c) && lead.other_phone2_sales__c != null){ l.other_phone2_sales__c = lead.other_phone2_sales__c;}
                                    if (!String.isBlank(String.Valueof(lead.reasignaciones_del_lead_sales__c)) && lead.reasignaciones_del_lead_sales__c != null){ l.reasignaciones_del_lead_sales__c = lead.reasignaciones_del_lead_sales__c;}
                                    if (!String.isBlank(lead.Email) && lead.Email != null){ l.Email = lead.Email;}
                                    if (!String.isBlank(lead.nuevo_correo_sales__c) && lead.nuevo_correo_sales__c != null){ l.nuevo_correo_sales__c = lead.nuevo_correo_sales__c;}
                                    if (!String.isBlank(lead.LeadSource) && lead.LeadSource != null){ l.LeadSource = lead.LeadSource;}
                                    if (!String.isBlank(lead.Status) && lead.Status != null){
                                        //if (lead.Status != 'No Gestionado' && lead.Status != 'Gestionado' && lead.Status != 'Convertido' && lead.Status != 'No Convertido'){
                                        //    addDataResponse(false, 'LEAD STATUS DONT EXITS' , Constants.RESPONSE_400,lead);
                                        //}else{
                                            l.Status = lead.Status;
                                        //}
                                    }
                                    if (!String.isBlank(lead.descripcion_sales__c) && lead.descripcion_sales__c != null){ l.descripcion_sales__c = lead.descripcion_sales__c;}
                                    if (!String.isBlank(lead.genero_sales__c) && lead.genero_sales__c != null){ l.genero_sales__c = lead.genero_sales__c;}
                                    if (!String.isBlank(lead.calle_sales__c) && lead.calle_sales__c != null){ l.calle_sales__c = lead.calle_sales__c;}
                                    if (!String.isBlank(lead.numero_sales__c) && lead.numero_sales__c != null){ l.numero_sales__c = lead.numero_sales__c;}
                                    if (!String.isBlank(lead.numero_de_piso_sales__c) && lead.numero_de_piso_sales__c != null){ l.numero_de_piso_sales__c = lead.numero_de_piso_sales__c;}
                                    if (!String.isBlank(lead.numero_departamento_sales__c) && lead.numero_departamento_sales__c != null){ l.numero_departamento_sales__c = lead.numero_departamento_sales__c;}
                                    if (!String.isBlank(lead.comuna_sales__c) && lead.comuna_sales__c != null){ l.comuna_sales__c = lead.comuna_sales__c;}
                                    if (!String.isBlank(lead.villa_sales__c) && lead.villa_sales__c != null){ l.villa_sales__c = lead.villa_sales__c;}
                                    if (!String.isBlank(lead.region_sales__c) && lead.region_sales__c != null){ l.region_sales__c = lead.region_sales__c;}
                                    if (!String.isBlank(lead.provincia_sales__c) && lead.provincia_sales__c != null){ l.provincia_sales__c = lead.provincia_sales__c;}
                                    if (!String.isBlank(String.Valueof(lead.sla_sales__c)) && lead.sla_sales__c != null){ l.sla_sales__c = lead.sla_sales__c;}
                                    if (!String.isBlank(String.Valueof(lead.fecha_nacimiento_sales__c)) && lead.fecha_nacimiento_sales__c != null){ l.fecha_nacimiento_sales__c = lead.fecha_nacimiento_sales__c;}
                                    if (!String.isBlank(lead.tipo_documento_sales__c) && lead.tipo_documento_sales__c != null){ l.tipo_documento_sales__c = lead.tipo_documento_sales__c;}
                                    if (!String.isBlank(lead.zona_sales__c) && lead.zona_sales__c != null){ l.zona_sales__c = lead.zona_sales__c;}
                                    if (!String.isBlank(lead.sucursal_sales__c) && lead.sucursal_sales__c != null){ l.sucursal_sales__c = lead.sucursal_sales__c;}
                                    if (!String.isBlank(lead.rating) && lead.rating != null){ l.rating = lead.rating;}
    
                                    lstUpdateLead.add(l);
                                }
                            }else{
                                idsUpdate.add(l.Id);
                                // se genera grupo de datos que no coinciden
                                addDataResponse(false, 'LEAD DONT EXITS' , Constants.RESPONSE_400,lead);
                            }
                        }
                    }
                }

            }
        }
        //Update Leads
        if(lstUpdateLead.size()>0){updateLead(lstUpdateLead);}

        response.response = lstData;

        return response;
    }

    private static void updateLead(List<Lead> lst){

        Set<Id> lstIdLead = new Set<Id>();
        Map<Id,UtilitiesSalesREST.Data> mapLeads = new Map<Id,UtilitiesSalesREST.Data>();
        List<Database.SaveResult> srList = Database.update(lst,false);

        for (Database.SaveResult sr : srList) {
            UtilitiesSalesREST.Data data = new UtilitiesSalesREST.Data();
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                if(idsUpdate.contains(sr.getId())){
                    lstIdLead.add(sr.getId());
                    data.success = true;
                    data.message = 'OK';
                    data.statusCode = Constants.RESPONSE_200;
                    mapLeads.put(sr.getId(), data);
                    //addDataResponse(true, '00-OK_'+sr.getId(), Constants.RESPONSE_200,lead);
                } 
            }else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    lstIdLead.add(sr.getId());
                    data.success = false;
                    data.message = 'NOK '+err.getMessage();
                    data.statusCode = Constants.RESPONSE_400;
                    mapLeads.put(sr.getId(), data);
                    Lead lead = new Lead();
                    addDataResponse(false, 'NOK '+err.getMessage(), Constants.RESPONSE_400,lead);                
                }
            }
        }

        addDataResponseDbResult(lstIdLead,mapLeads);
    }

    private static void addDataResponseDbResult(Set<Id> lstIdLeads, Map<Id,UtilitiesSalesREST.Data> mapLeads){
        
        List<Lead> lstLeadTmp = [SELECT Id,LastName,sla_sales__c,rut_ejecutivo_sales__c,Email,numero_de_documento_sales__c,tipo_documento_sales__c,
                            Rating FROM Lead WHERE Id IN : lstIdLeads];
        
        for(Lead tmp : lstLeadTmp){
            if(mapLeads.get(tmp.Id) != null){
                UtilitiesSalesREST.Data data = mapLeads.get(tmp.Id);
                data.jsonMap = addLeadJson(tmp);
                lstData.add(data);
            }
        }
    }

    private static void addDataResponse(Boolean success, String message, String statusCode,Lead lead){
        UtilitiesSalesREST.Data data = new UtilitiesSalesREST.Data();
        data.success = success;
        data.message = message;
        data.statusCode = statusCode;
        data.jsonMap = addLeadJson(lead);
        lstData.add(data);
    }

    private static String addLeadJson(Lead lead){
        Lead addLead = new Lead();
        addLead.tipo_documento_sales__c = lead.tipo_documento_sales__c;
        addLead.numero_de_documento_sales__c = lead.numero_de_documento_sales__c;
        addLead.rut_ejecutivo_sales__c = lead.rut_ejecutivo_sales__c;
        addLead.LastName = lead.LastName;
        addLead.sla_sales__c = lead.sla_sales__c;
        addLead.Email = lead.Email;
        addLead.Rating = lead.Rating;

        String json = JSON.serialize(addLead);

        return json;
    }

    global class Request{
        public List<Lead> records;
    }
}