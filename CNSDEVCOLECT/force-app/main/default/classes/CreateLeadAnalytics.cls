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
02/07/2020					  luis.vidal@consorcio.cl		Validation, Lead 'Propio' existing, add condition.
**********************************************************************************************************/
@RestResource(urlMapping='/Lead/*')
global without sharing class CreateLeadAnalytics {

    private static List<Task> lstTask = new List<Task>();
    private static List<Lead> lstUpsertLead = new List<Lead>();
    private static List<Lead> lstLead = new List<Lead>();
    private static UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();
    private static List<UtilitiesSalesREST.Data> lstData = new List<UtilitiesSalesREST.Data>();
    private static Set<String> idsUpsert = new Set<String>();

    /**
      * @description       This method invoke service REST
      * @return            Response response
      * @throws            NA
    */
    @HttpPost
    global static UtilitiesSalesREST.Response assignLeads(){
    
        Request newRequest = (Request)JSON.deserialize(RestContext.request.requestBody.toString(), Request.class);

        lstLead = newRequest.records;
        
        Set<String> rutLeads = new Set<String>();
        Set<String> rutExecutive = new Set<String>();

        Id rtId = [SELECT Id FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_SALES_LEAD_PERSONAS AND SObjectType =: Constants.LEAD LIMIT 1].Id;

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
            lead.RecordTypeId = rtId; 
            Boolean isAccount = false;
            Boolean existExec = true;
            Boolean insertNew = true;

            if(lead.rut_ejecutivo_sales__c != null){

                UtilitiesSales.ValidateData vData = UtilitiesSales.evaluateRequiredDataLead(lead);
                Boolean validDataContact = vdata.isValid;//validateDataContact(lead.Phone, lead.Email, lead.other_phone_sales__c);
                String rutExec = lead.rut_ejecutivo_sales__c.contains('-') ? lead.rut_ejecutivo_sales__c.remove('-') : lead.rut_ejecutivo_sales__c; 

                if(mapIdExecutive.get(rutExec) != null){
                    lead.OwnerId = mapIdExecutive.get(rutExec);
                }else{
                    existExec = false;
                    insertNew = false;
                }

                if(lead.numero_de_documento_sales__c != null && validDataContact && existExec){
                    //Validación Account
                    
                    for(Account acc : lstAcc){
                        if(lead.numero_de_documento_sales__c.equals(acc.Rut__C)){
                            insertNew = false;
                            createTaskOwner(acc.OwnerId,acc.Id);
                            addDataResponse(false,'ERROR_ACCOUNT',Constants.RESPONSE_400,lead);
                            isAccount = true;
                            break;
                        }
                    }
                    
                    if(!isAccount){
                        //Validación Lead
                        for(Lead l : lstLeadExist){
                            if(lead.numero_de_documento_sales__c.equals(l.numero_de_documento_sales__c)){
                                //existe ejecutivo
                                if(!existExec){
                                    insertNew = false;
                                    addDataResponse(false,'ERROR_EXECUTIVE',Constants.RESPONSE_400,lead);
                                }else{
                                    if(l.OwnerId.equals(lead.OwnerId)){
                                       insertNew = false;
                                       l.Email = lead.Email !=null ? lead.Email : null;
                                       l.Phone = lead.Phone !=null ? lead.Phone : null;
                                       l.other_phone_sales__c = lead.other_phone_sales__c !=null ? lead.other_phone_sales__c : null;
                                       l.Rating = lead.Rating;
                                       lstUpsertLead.add(l);
                                       idsUpsert.add(l.Id);
                                       createTaskOwner(l.OwnerId,l.Id);
                                       addDataResponse(false, 'ERROR_LEAD_OWNER '  , Constants.RESPONSE_400,lead);
                                    }else{
                                        //RESCATA EL CAMPO de leadsource en base al nuevo lead y asigna el campo a tipolead
                                        	List<Lead> lsource = [SELECT LeadSource FROM lead WHERE numero_de_documento_sales__c = :lead.numero_de_documento_sales__c  ];
                                        	string tipolead = '';
                                            if(lsource.size() > 0) {
                                              tipolead = lsource[0].LeadSource;
                                            }
                                        //CONDICIONA UNA RESPUESTA PARA NO MODIFICAR EL LEAD TIPO PROPIO EXISTENTE
                                        if(tipolead == 'Propio'){
                                            insertNew = false;
                                            addDataResponse(false, 'LEAD OWN ALREADY EXITS' , Constants.RESPONSE_400,lead);
                                        }else{
                                            insertNew = false;
                                            l.OwnerId = lead.OwnerId;
                                            l.rut_ejecutivo_sales__c = lead.rut_ejecutivo_sales__c;
                                            l.Email = lead.Email !=null ? lead.Email : null;
                                            l.Phone = lead.Phone !=null ? lead.Phone : null;
                                            l.other_phone_sales__c = lead.other_phone_sales__c !=null ? lead.other_phone_sales__c : null;
                                            l.Rating = lead.Rating;
                                            lstUpsertLead.add(l);
                                            idsUpsert.add(l.Id);
                                            createTaskOwner(l.OwnerId,l.Id);
                                            addDataResponse(false, 'ERROR_LEAD_NOOWNER ', Constants.RESPONSE_400,lead);}
                                        }
                                   
                                }
                                break;
                            }
                        }
                    }
                    
                }
                if(insertNew){ 
                    if(validDataContact){
                        lstUpsertLead.add(lead);
                    }else{
                        addDataResponse(false, vData.error , Constants.RESPONSE_400,lead);
                    }
                }else if(!existExec){
                    addDataResponse(false,'ERROR_EXECUTIVE',Constants.RESPONSE_400,lead);
                }
            
            }else{
                addDataResponse(false, 'ERROR_EXCEPTION-RUTEJECUTIVONULL', Constants.RESPONSE_400,lead);
            }    

        }

        //UPSERT LEADS
        if(lstUpsertLead.size()>0){upsertLead(lstUpsertLead);}

        //INSERT TASKS
        if(lstTask.size()>0){createTask(lstTask);}


        response.response = lstData;

        return response;
    }

    /**
      * @description       This method create a new Task and add to list.
      * @param1            String assignTo
      * @param2            String relatedTo
      * @return            void
      * @throws            NA
    */
    private static void createTaskOwner(String assignTo, String relatedTo){
        Task newTask = new Task();
        newTask.OwnerId = assignTo;
        newTask.Subject = Constants.TASK_SUBJECT_LLAMADA;
        newTask.WhoId = relatedTo;

        lstTask.add(newTask); 
        System.debug('CREATE TASK');
    }

    /**
      * @description       This method create or update a list de Lead.
      * @param1            List<Lead> lst
      * @return            void
      * @throws            NA
    */
    private static void upsertLead(List<Lead> lst){
        Set<Id> lstIdLead = new Set<Id>();
        Map<Id,UtilitiesSalesREST.Data> mapLeads = new Map<Id,UtilitiesSalesREST.Data>();
        Database.UpsertResult[] srList = Database.upsert(lst,false);
        for (Database.UpsertResult sr : srList) {
            UtilitiesSalesREST.Data data = new UtilitiesSalesREST.Data();
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                if(!idsUpsert.contains(sr.getId())){
                    lstIdLead.add(sr.getId());
                    data.success = true;
                    data.message = 'OK_'+sr.getId();
                    data.statusCode = Constants.RESPONSE_200;
                    mapLeads.put(sr.getId(), data);
                    //addDataResponse(true, '00-OK_'+sr.getId(), Constants.RESPONSE_200,lead);
                } 
            }else {
                if(!idsUpsert.contains(sr.getId())){
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        lstIdLead.add(sr.getId());
                        data.success = false;
                        data.message = 'ERROR_EXCEPTION-'+err.getMessage();
                        data.statusCode = Constants.RESPONSE_400;
                        mapLeads.put(sr.getId(), data);
                        Lead lead = new Lead();
                        addDataResponse(false, 'ERROR_EXCEPTION-'+err.getMessage(), Constants.RESPONSE_400,lead);                
                    }
                } 
                
            }
        }
        addDataResponseDbResult(lstIdLead,mapLeads);
    }

    /**
      * @description       This add message for response 
      * @param1            Boolean success
      * @param2            String message
      * @param3            String statusCode
      * @return            void
      * @throws            NA
    */
    private static void createTask(List<Task> newLstTask){
        System.debug('LISTA DE TASK A CREAR: ' +newLstTask.size());
        System.debug('TASKS: ' +newLstTask);
        Database.SaveResult[] srList = Database.insert(lstTask, false);
    }

    /**
      * @description       This add message for response 
      * @param1            Boolean success
      * @param2            String message
      * @param3            String statusCode
      * @return            void
      * @throws            NA
    */
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

    /**
      * @description       This add message for response 
      * @param1            Boolean success
      * @param2            String message
      * @param3            String statusCode
      * @return            void
      * @throws            NA
    */
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