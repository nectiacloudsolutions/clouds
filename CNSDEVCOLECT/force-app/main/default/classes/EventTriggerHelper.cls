/*********************************************************************************************************
@Author       curbinav@everis.com
@name         EventTriggerHelper
@CreateDate   07/10/2019
@Description  Helper of the Event object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
07/10/2019    curbinav@everis.com           W-000056 - (GLEAD) Crear evento (llamado -  Agendamiento o Email )
12/11/2019    fmaturan@everis.com           W-000149 - (Gestión del Lead) - Cambio de estados del Candidato
27/11/2019    fmaturan@everis.com           W-000156 - (Gestión de Oportunidades) - Visualización de estado "Contacto"
09/12/2019    pcelisbe@everis.com           W-000247 - Add method reportLeadConvertAnalytics
16/01/2020    eayalcor@everis.com           FIX      - Fix create Auto Quote by Opportunity
04/02/2020    eayalcor@everis.com           FIX      - FIX Change Status Lead by Event fire
**********************************************************************************************************/
public with sharing class EventTriggerHelper {
    
    /**
* @description      This method is used to inform the CONVERTED Lead
* @author           pcelis@everis.com | 09-12-2019 
* @param            List<ID> newLead 
* @return           void 
**/
    public static void reportLeadConvertAnalytics(List<ID> newLead){
        //Logica
        List<String> leadIds = new List<String>();
        for(Id l : newLead){
            leadIds.add(l);
        }
        if(!leadIds.isEmpty()){
            system.debug('leadIds send analytics convert'+leadIds);
            SalesCallout.consultLeadAnalyticsAsyncMassive(leadIds, CONSTANTS.CONVERTED, CONSTANTS.ANALYTICSLEAD);
        }
    }    
    
    
    /**
* @description       Business logic for trigger on After Insert
* @author            curbinav@everis.com | 07-10-2019
* @param             new Records List<Event> : eventList
* @return            void
* @throws            NA
*/ 
    public static void onAfterInsert(List<Event> eventList){
        try{
            System.debug('Entro on after Insert');
            boolean hadEmail;
            List<Event> lstEvent = new List<Event>();
            List<Id> lstLeadIdsGestionado= new List<Id>();
            List<Id> lstLeadIdsNoConvertido= new List<Id>();
            Set<Id> campaignIds = new Set<Id>();
            List<Id> leadIds = new List<Id>();
            List<Id> leadIdsToConvert = new List<Id>();
            Map<Id, String> mapLeadIdName = new Map<Id, String>();
            for (Event ev : eventList) {
                if(ev.WhoId != null ){
                    leadIds.add(ev.WhoId);
                }
            }           
            List<Lead> lstLeads = UtilitiesSales.getLeadByIds(leadIds);
            
            for (Lead lds : lstLeads) {
                mapLeadIdName.put(lds.Id, lds.Name);
            } 
            for (Event event: eventList) {
                System.debug('EVENTO DESENCADENADO: '+ event);
                //valida si tiene lead el candidato relacionado
                if(event.WhoId != null 
                   && String.valueOf(event.WhoId.getSobjectType())  == Constants.LEAD
                   && event.enviar_agenda_via_correo_sales__c == true){
                       hadEmail = hadEmailLead(event.WhoId);
                       if(!hadEmail){
                           event.addError(Constants.EVENT_ERROR2);  
                       }
                   }
                //valida si tiene mail el contacto relacionado
                if(event.WhoId != null 
                   && String.valueOf(event.WhoId.getSobjectType())  == Constants.CONTACT
                   && event.enviar_agenda_via_correo_sales__c == true){
                       hadEmail = hadEmailAccount(event.WhoId);
                       if(!hadEmail){
                           event.addError(Constants.EVENT_ERROR3);  
                       }
                   }
                //Evento del Lead de tipo Llamada con estado Contactado
                if(event.WhoId != null
                   && event.Type == Constants.EVENT_TYPE_LLAMADA
                   && event.estado_llamada_sales__c == Constants.EVENT_ESTADO_LLAMADA_CONTACTADO
                   && String.valueOf(event.WhoId.getSobjectType())  == Constants.LEAD){  
                       System.debug('Entro event tipo llamada');                          
                       //Resultado Volver a Llamar
                       if(event.resultado_llamada_sales__c == Constants.EVENT_RESULTADO_LLAMADA_LLAMAR){
                           System.debug('Entro event resultado volver a llamar');
                           Event objEvent = createEvent(event, Constants.EVENT_TYPE_LLAMADA, mapLeadIdName.get(event.WhoId));
                           lstEvent.add(objEvent);
                           lstLeadIdsGestionado.add(event.WhoId);
                       }
                       //Resultado Volver a Entrevistar
                       if (event.resultado_llamada_sales__c == Constants.EVENT_RESULTADO_LLAMADA_ENTEVISTA) {
                           Event objEvent = createEvent(event, Constants.EVENT_TYPE_ENTREVISTA, mapLeadIdName.get(event.WhoId) );
                           lstEvent.add(objEvent);
                           lstLeadIdsGestionado.add(event.WhoId);
                       }
                       //Resultado Llamada exitosa
                       if(event.resultado_llamada_sales__c == Constants.EVENT_RESULTADO_LLAMADA_EXITOSA){
                           leadIdsToConvert.add(event.WhoId);
                           System.debug('Entro a convertir'); 
                       }
                       //Resultado No le Interesa
                       if(event.resultado_llamada_sales__c == Constants.EVENT_RESULTADO_LLAMADA_NOINTERESA){
                           lstLeadIdsNoConvertido.add(event.WhoId);
                       }
                   }
                //Evento del Lead de tipo Llamada con estado No Contactado
                if(event.WhoId != null
                   && event.Type == Constants.EVENT_TYPE_LLAMADA
                   && event.estado_llamada_sales__c == Constants.EVENT_ESTADO_LLAMADA_NOCONTACTADO
                   && String.valueOf(event.WhoId.getSobjectType())  == Constants.LEAD){                            

                       if(event.resultado_llamada_sales__c == Constants.EVENT_RESULTADO_LLAMADA_EQUIVOCADO_N){
                           lstLeadIdsNoConvertido.add(event.WhoId); 
                       }
                       if(event.resultado_llamada_sales__c == Constants.EVENT_RESULTADO_LLAMADA_NOEXISTE
                          || event.resultado_llamada_sales__c == Constants.EVENT_RESULTADO_LLAMADA_NOCONTESTAINUBICABLE){
                              lstLeadIdsNoConvertido.add(event.WhoId); 

                          }
                       //Resultado No contesta, volver a llamar
                       if(event.resultado_llamada_sales__c == Constants.EVENT_RESULTADO_LLAMADA_NOCONTESTALLAMAR){
                           Event objEvent = createEvent(event, Constants.EVENT_TYPE_LLAMADA, mapLeadIdName.get(event.WhoId) );
                           lstEvent.add(objEvent);
                           lstLeadIdsGestionado.add(event.WhoId);
                       }
                       
                   }
                //Evento del Lead de tipo Entrevista 
                if(event.WhoId != null
                   && event.Type == Constants.EVENT_TYPE_ENTREVISTA
                   && String.valueOf(event.WhoId.getSobjectType())  == Constants.LEAD){                            
                       EventWizardController.evtBtn = true;
                       lstLeadIdsGestionado.add(event.WhoId);
                   }
                //Evento del Lead de tipo Entrevista con estado No Exitoso
                if(event.WhoId != null
                   && event.Type == Constants.EVENT_TYPE_ENTREVISTA
                   && event.estado_reunion_sales__c == Constants.EVENT_ESTADO_ENTREVISTA_NOEXITOSO
                   && String.valueOf(event.WhoId.getSobjectType())  == Constants.LEAD){ 
                       //Resultado Volver a Llamar                           
                       if(event.resultado_de_la_reunion_sales__c == Constants.EVENT_RESULTADO_ENTREVISTA_LLAMAR){
                           Event objEvent = createEvent(event, Constants.EVENT_TYPE_LLAMADA, mapLeadIdName.get(event.WhoId) );
                           lstEvent.add(objEvent);
                           lstLeadIdsGestionado.add(event.WhoId);
                       }
                       //Resultado Volver a Entrevistar 
                       if(event.resultado_de_la_reunion_sales__c == Constants.EVENT_RESULTADO_ENTREVISTA_ENTEVISTAR){
                            Event objEvent = createEvent(event, Constants.EVENT_TYPE_ENTREVISTA, mapLeadIdName.get(event.WhoId) );
                            lstEvent.add(objEvent);
                            lstLeadIdsGestionado.add(event.WhoId);
                       }
                       //Resultado No interesa
                       if(event.resultado_de_la_reunion_sales__c == Constants.EVENT_RESULTADO_ENTREVISTA_NOINTERESA){
                            lstLeadIdsNoConvertido.add(event.WhoId); 
                       }                     
                   }   
                if((event.WhoId != null && event.WhatId != null
                    && String.valueOf(event.WhatId.getSobjectType())  == CONSTANTS.CAMPAIGN) || 
                   (event.WhoId_Campana_sales__c != null && event.Nombre_de_Campana_sales__c != null)){
                       campaignIds.add(event.Id_Miembro_de_Campana_sales__c);
                   }
                
            }
            if(!lstEvent.isEmpty()){
                insert lstEvent; 
            }
            if (leadIdsToConvert != null && !leadIdsToConvert.isEmpty()) {
                autoConvertLead(leadIdsToConvert);
            }
            if (campaignIds != null && !campaignIds.isEmpty()) {
                markCampaignMember(campaignIds);
            }           
            if (lstLeadIdsGestionado != null && !lstLeadIdsGestionado.isEmpty()) {
                updateLeadToGestionado(lstLeadIdsGestionado);
            }
            if (lstLeadIdsNoConvertido != null && !lstLeadIdsNoConvertido.isEmpty()) {
                updateLeadToNoConvertido(lstLeadIdsNoConvertido);
            }
            
        }catch(Exception e){
            system.debug('Exception '+e.getMessage());
            Trigger.new[0].addError(e.getMessage());
        }        
    }   
    
        /**
* @description       Business logic for trigger on Before Update
* @author            fbizamam@everis.com | 13-07-2020
* @param             new Records List<Event> : eventList
* @return            void
* @throws            NA
*/     
    public static void onBeforeUpdate(List<Event> eventList, Map<Id,Event> eventOldMap) {
        
        List<Id> leadIds = new List<Id>();
        for (Event ev : eventList) {
            if(ev.WhoId != null && (ev.resultado_de_la_reunion_sales__c == CONSTANTS.EVENT_RESULTADO_REUNION_EXITOSA || ev.resultado_llamada_sales__c == CONSTANTS.EVENT_RESULTADO_LLAMADA_EXITOSA)){
                leadIds.add(ev.WhoId);
            }
        }
        if(!leadIds.isEmpty()){
            List<Lead> lstLeads = UtilitiesSales.getLeadByIds(leadIds);
            for(Event ev : eventList){
                for (Lead lds : lstLeads) {
                    if(lds.numero_de_documento_sales__c == null || String.isBlank(lds.numero_de_documento_sales__c)){
                        ev.addError('Debes completar con el RUT/Número de documento antes de convertir');
                    }
                }
            }      
        }
    }
    /**
* @description       Business logic for trigger on After Update
* @author            curbinav@everis.com | 07-10-2019
* @param             new Records List<Event> : eventList
* @return            void
* @throws            NA
*/     
    public static void onAfterUpdate(List<Event> eventList, Map<Id,Event> eventOldMap) {
        try{

            boolean hadEmail;
            List<Task> newTasks = new List<Task>();
            List<Id> lstLeadIdsGestionado= new List<Id>();
            List<Id> lstLeadIdsNoConvertido= new List<Id>();
            List<Id> lstOppSuccess= new List<Id>();
            List<Lead> updStatusLeads = new List<Lead>();
            List<Event> lstEvent = new List<Event>();
            List<Id> leadIds = new List<Id>();
            List<Id> leadIdsToConvert = new List<Id>();
            Map<Id, String> mapLeadIdName = new Map<Id, String>();
            for (Event ev : eventList) {
                if(ev.WhoId != null ){
                    leadIds.add(ev.WhoId);
                }
            }           
            List<Lead> lstLeads = UtilitiesSales.getLeadByIds(leadIds);
            
            for (Lead lds : lstLeads) {
                mapLeadIdName.put(lds.Id, lds.Name);
            } 
            for (Event event: eventList) {
                
                if(event.resultado_de_la_reunion_sales__c != eventOldMap.get(event.Id).resultado_de_la_reunion_sales__c
                  || event.resultado_llamada_sales__c != eventOldMap.get(event.Id).resultado_llamada_sales__c
                  || event.estado_reunion_sales__c != eventOldMap.get(event.Id).estado_reunion_sales__c){

                    //Inicio Agenda Opportunity
                    //Resultado reunion exitosa
                    if(event.WhatId != null
                       && event.Type == Constants.EVENT_TYPE_ENTREVISTA 
                       && event.estado_reunion_sales__c == Constants.EVENT_ESTADO_ENTREVISTA_EXITOSO
                       && event.resultado_de_la_reunion_sales__c == Constants.EVENT_RESULTADO_REUNION_EXITOSA
                       && String.valueOf(event.WhatId.getSobjectType())  == Constants.OPPORTUNITY){                             
                           lstOppSuccess.add(event.WhatId);                      
                       }
                    
                    //Resultado volver entrevistar y suspendido
                    if((event.resultado_de_la_reunion_sales__c == Constants.EVENT_RESULTADO_ENTREVISTA_ENTEVISTAR )
                       && event.WhatId != null && String.valueOf(event.WhatId.getSobjectType())  == Constants.OPPORTUNITY ) {
                           Event objEvent = new Event();
                           objEvent.IsReminderSet = true;
                           objEvent.Subject = Constants.TASK_SUBJECT_ENTREVISTA;
                           objEvent.ReminderDateTime = event.fecha_nueva_gestion_sales__c.addMinutes(-30);
                           objEvent.ActivityDate = event.fecha_nueva_gestion_sales__c.date();
                           objEvent.resultado_llamada_sales__c = null;
                           objEvent.DurationInMinutes = 60;
                           objEvent.telefono_gestion_sales__c = event.telefono_gestion_sales__c;
                           objEvent.ActivityDateTime = event.fecha_nueva_gestion_sales__c;
                           objEvent.WhatId = event.WhatId;
                           lstEvent.add(objEvent);
                       } //Resultado volver a llamar
                    else if (event.resultado_de_la_reunion_sales__c == Constants.EVENT_RESULTADO_ENTREVISTA_LLAMAR
                             && event.WhatId != null && String.valueOf(event.WhatId.getSobjectType()) == Constants.OPPORTUNITY) {
                                 Task callBackTask = new Task();
                                 callBackTask.IsReminderSet = true;
                                 callBackTask.Subject = Constants.TASK_SUBJECT_LLAMADA;
                                 callBackTask.Status = Constants.TASK_STATUS_ABIERTA;
                                 callBackTask.ReminderDateTime = event.fecha_nueva_gestion_sales__c.addMinutes(-30);
                                 callBackTask.ActivityDate = event.fecha_nueva_gestion_sales__c.date();
                                 callBackTask.resultado_llamada_sales__c = null;
                                 callBackTask.WhatId = event.WhatId;
                                 newTasks.add(callBackTask);
                             } 
                    
                    //Inicio Agenda Lead
                    //Evento del Lead de tipo Llamada con estado Contactado
                    if(event.WhoId != null
                       && event.Type == Constants.EVENT_TYPE_LLAMADA
                       && event.estado_llamada_sales__c == Constants.EVENT_ESTADO_LLAMADA_CONTACTADO
                       && String.valueOf(event.WhoId.getSobjectType())  == Constants.LEAD
                       && event.flag_convertido_sales__c != true){                            
                           //Resultado Volver a Llamar
                           if(event.resultado_llamada_sales__c == Constants.EVENT_RESULTADO_LLAMADA_LLAMAR){
                               Event objEvent = createEvent(event, Constants.EVENT_TYPE_LLAMADA, mapLeadIdName.get(event.WhoId) );
                               lstEvent.add(objEvent);
                               lstLeadIdsGestionado.add(event.WhoId);
                           }
                           //Resultado Volver a Entrevistar
                           if (event.resultado_llamada_sales__c == Constants.EVENT_RESULTADO_LLAMADA_ENTEVISTA) {
                               Event objEvent = createEvent(event, Constants.EVENT_TYPE_ENTREVISTA, mapLeadIdName.get(event.WhoId) );
                               lstEvent.add(objEvent);
                               lstLeadIdsGestionado.add(event.WhoId);
                           }
                           //Resultado Llamada exitosa
                           if(event.resultado_llamada_sales__c == Constants.EVENT_RESULTADO_LLAMADA_EXITOSA){
                               leadIdsToConvert.add(event.WhoId);
                           }
                           //Resultado No le Interesa
                           if(event.resultado_llamada_sales__c == Constants.EVENT_RESULTADO_LLAMADA_NOINTERESA){
                               lstLeadIdsNoConvertido.add(event.WhoId);
                           }
                       }

                    //Evento del Lead de tipo Llamada con estado No Contactado
                    if(event.WhoId != null
                       && event.Type == Constants.EVENT_TYPE_LLAMADA
                       && event.estado_llamada_sales__c == Constants.EVENT_ESTADO_LLAMADA_NOCONTACTADO	
                       && String.valueOf(event.WhoId.getSobjectType())  == Constants.LEAD
                       && event.flag_convertido_sales__c != true){   
                       
                           //Resultado Numero Equivocado, Numero no existe, Inubicable
                           if(event.resultado_llamada_sales__c.equalsIgnoreCase(Constants.EVENT_RESULTADO_LLAMADA_EQUIVOCADO)
                              || event.resultado_llamada_sales__c.equalsIgnoreCase(Constants.EVENT_RESULTADO_LLAMADA_NOEXISTE)
                              || event.resultado_llamada_sales__c.equalsIgnoreCase(Constants.EVENT_RESULTADO_LLAMADA_NOCONTESTAINUBICABLE)){
                                  lstLeadIdsNoConvertido.add(event.WhoId);                        
                              }
                           //Resultado No contesta, volver a llamar
                           if(event.resultado_llamada_sales__c == Constants.EVENT_RESULTADO_LLAMADA_NOCONTESTALLAMAR){
                               Event objEvent = createEvent(event, Constants.EVENT_TYPE_LLAMADA, mapLeadIdName.get(event.WhoId) );
                               lstEvent.add(objEvent);
                               lstLeadIdsGestionado.add(event.WhoId);
                           }

                       }
                    //Evento del Lead de tipo Entrevista con estado Exitoso
                    if(event.WhoId != null
                       && event.Type == Constants.EVENT_TYPE_ENTREVISTA
                       && event.estado_reunion_sales__c == Constants.EVENT_ESTADO_ENTREVISTA_EXITOSO
                       && String.valueOf(event.WhoId.getSobjectType())  == Constants.LEAD
                       && event.flag_convertido_sales__c != true){ 
                           EventWizardController.evtBtn = true; 
                           Lead lead = new Lead(Id=event.WhoId,Flag_Lead_sales__c=false); 
                           updStatusLeads.add(lead);                         
                           leadIdsToConvert.add(event.WhoId);
                       }
                    //Evento del Lead de tipo Entrevista con estado No Exitoso
                    if(event.WhoId != null
                       && event.Type == Constants.EVENT_TYPE_ENTREVISTA
                       && event.estado_reunion_sales__c == Constants.EVENT_ESTADO_ENTREVISTA_NOEXITOSO
                       && String.valueOf(event.WhoId.getSobjectType())  == Constants.LEAD
                       && event.flag_convertido_sales__c != true){ 
                           System.debug('Entro tipo entrevista No exitoso');
                           //Resultado Volver a Llamar                           
                           if(event.resultado_de_la_reunion_sales__c == Constants.EVENT_RESULTADO_ENTREVISTA_LLAMAR){
                               System.debug('Entro resultado volver a llamar');
                               Event objEvent = createEvent(event, Constants.EVENT_TYPE_LLAMADA, mapLeadIdName.get(event.WhoId) );
                               lstEvent.add(objEvent);
                               lstLeadIdsGestionado.add(event.WhoId);
                           }
                           //Resultado Volver a Entrevistar 
                           if(event.resultado_de_la_reunion_sales__c == Constants.EVENT_RESULTADO_ENTREVISTA_ENTEVISTAR){
                               Event objEvent = createEvent(event, Constants.EVENT_TYPE_ENTREVISTA, mapLeadIdName.get(event.WhoId) );
                               lstEvent.add(objEvent);
                               lstLeadIdsGestionado.add(event.WhoId);
                           }
                           //Resultado No interesa
                           if(event.resultado_de_la_reunion_sales__c == Constants.EVENT_RESULTADO_ENTREVISTA_NOINTERESA){
                               lstLeadIdsNoConvertido.add(event.WhoId); 
                           }
                       } 
                    
                    if (!newTasks.isEmpty()){
                        insert newTasks;
                    }    
                    if(!lstEvent.isEmpty()){
                        insert lstEvent;  
                    }
                    if (lstOppSuccess != null && !lstOppSuccess.isEmpty()) {               
                        updateOpportunitySuccess(lstOppSuccess);
                    }   
                    if (!updStatusLeads.isEmpty()) {
                        update updStatusLeads;
                    }         
                    if (leadIdsToConvert != null && !leadIdsToConvert.isEmpty()) {
                        //autoConvertLead(leadIdsToConvert);
                    }
                    if (lstLeadIdsGestionado != null && !lstLeadIdsGestionado.isEmpty()) {
                        updateLeadToGestionado(lstLeadIdsGestionado);
                    }
                    if (lstLeadIdsNoConvertido != null && !lstLeadIdsNoConvertido.isEmpty()) {
                        updateLeadToNoConvertido(lstLeadIdsNoConvertido);
                    }
                }
                
                //valida si tiene mail el candidato relacionado
                if(event.WhoId != null 
                   && String.valueOf(event.WhoId.getSobjectType())  == Constants.LEAD
                   && event.enviar_agenda_via_correo_sales__c == true){
                       hadEmail = hadEmailLead(event.WhoId);
                       if(!hadEmail){
                           event.addError(Constants.EVENT_ERROR2);  
                       }
                   }
                //valida si tiene mail el contacto relacionado
                if(event.WhoId != null 
                   && String.valueOf(event.WhoId.getSobjectType())  == Constants.CONTACT
                   && event.enviar_agenda_via_correo_sales__c == true){
                       hadEmail = hadEmailAccount(event.WhoId);
                       if(!hadEmail){
                           event.addError(Constants.EVENT_ERROR3);  
                       }
                   }
                
            }
        }catch(Exception e){
            system.debug('EXCEPTION '+ e.getMessage());
            system.debug('LINE '+ e.getLineNumber());
            Trigger.new[0].addError(e.getMessage());
        }          
    }
    
    /**
* @description       Business logic to convert Lead to PersonAccount
* @author            eayalcor@everis.com | 01-10-2019
* @param1            new Lead Records List<Id> : lstIdsLeads
* @return            void
* @throws            NA
*/ 
    private static void autoConvertLead(List<Id> lstIdsLeads){
        List<Database.LeadConvertResult> lcr;
        String urlRef;
        PageReference page;
        List<Lead> lstLead = UtilitiesSales.getLeadByIds(lstIdsLeads);
        System.debug('LEADS:' + lstLead);
        List<Id> lstIdConvert = new List<Id>();
        
        if (lstLead != null && !lstLead.isEmpty()) {
            Set<String> rut = new Set<String>();
            
            for(Lead lead : lstLead){
                if(lead.numero_de_documento_sales__c != null 
                   && !String.isBlank(Lead.numero_de_documento_sales__c)){
                       rut.add(lead.numero_de_documento_sales__c);
                   }
            }               
            //comprobar duplicados
            List<Account> lstAccount = [SELECT Id,Rut__c,OwnerId FROM Account 
                                        WHERE Tipo_de_documento_de_identidad__c =: Constants.RUT 
                                        AND rut__c IN : rut];
            
            if (lstAccount != null && !lstAccount.isEmpty()) {
                for(Lead lead : lstLead){
                    for(Account acc : lstAccount){
                        if(!lead.numero_de_documento_sales__c.equals(acc.Rut__C)){
                            lstIdConvert.add(lead.Id);
                        }
                    }
                }
            }else{
                for(Lead lead : lstLead){
                    if(lead.numero_de_documento_sales__c != null
                       && !String.isBlank(Lead.numero_de_documento_sales__c)){
                           lstIdConvert.add(lead.Id);
                       }
                }
            }
            
            System.debug('LstIdConvert' + lstIdConvert);
            
            if (lstIdConvert != null && !lstIdConvert.isEmpty()) {
                updateEventToConvert(lstIdConvert);
                
                if(!Test.isRunningTest()){
                    lcr = UtilitiesSales.autoConvertLead(lstIdConvert);
                    System.debug('Entro a convertir lead '+lstIdConvert); 
                    for(Database.LeadConvertResult lc : lcr ){
                        urlRef =  '/' + lc.getAccountId();
                        PageReference pageRef =  new PageReference(urlRef);
                        if(!System.isScheduled()){
                            aura.redirect(pageRef);
                        }
                    }   
                }
            }
            
        }
        
    }
    /**
    * @description       Business logic for set a flag in CampaignMember
    * @author            curbinav@everis.com | 07-10-2019
    * @param             new campaign records set<id> : campaignIds
    * @return            void
    * @throws            NA
    */     
    private static void markCampaignMember(set<id> campaignIds){
        
        List<campaignMember> cmList = [SELECT ID, Tiene_Agenda_sales__c FROM campaignMember where Id =: campaignIds];
        System.debug('Campaign Members: ' + cmList);
        if(!cmList.isEmpty()){
            for(campaignMember cm : cmList){
                cm.Tiene_Agenda_sales__c = true;
            }
            update cmList;
        }
        
    }
    /**
    * @description       create a new Event
    * @author            fmaturan@everis.com | 07-10-2019
    * @param             new campaign records set<id> : campaignIds
    * @return            void
    * @throws            NA
    */   
    private static Event createEvent(Event ev, String tipo, String leadName ){
        
        Map<String, Id> mapRTEvt = new Map<String, Id>();
        
        for (RecordType rt : [SELECT Id, DeveloperName, SobjectType  FROM RecordType WHERE SobjectType =: Constants.Event]) {
            mapRTEvt.put (rt.DeveloperName,rt.Id);
        }
        
        if(tipo == Constants.EVENT_TYPE_LLAMADA){
            Event objEvent = new Event();
            objEvent.IsReminderSet = true;
            objEvent.Type = Constants.EVENT_TYPE_LLAMADA;
            objEvent.Subject = 'Llamar a '+leadName;
            objEvent.ReminderDateTime = ev.fecha_nueva_gestion_sales__c.addMinutes(-30);
            objEvent.ActivityDate = ev.fecha_nueva_gestion_sales__c.date();
            objEvent.resultado_llamada_sales__c = null;
            objEvent.DurationInMinutes = 60;
            objEvent.ActivityDateTime = ev.fecha_nueva_gestion_sales__c;
            objEvent.telefono_gestion_sales__c = ev.telefono_gestion_sales__c;
            objEvent.WhoId = ev.WhoId;
            objEvent.RecordTypeId =mapRTEvt.get(Constants.RECORDTYPE_EVENT_LLAMADA);
            return objEvent;   
        }else if(tipo == Constants.EVENT_TYPE_ENTREVISTA){
            Event objEvent = new Event();
            objEvent.IsReminderSet = true;
            objEvent.Type = Constants.EVENT_TYPE_ENTREVISTA;
            objEvent.Subject = 'Reunión con '+leadName;
            objEvent.ReminderDateTime = ev.fecha_nueva_gestion_sales__c.addMinutes(-30);
            objEvent.ActivityDate = ev.fecha_nueva_gestion_sales__c.date();
            objEvent.telefono_gestion_sales__c = ev.telefono_gestion_sales__c;
            objEvent.resultado_de_la_reunion_sales__c = null;
            objEvent.DurationInMinutes = 60;
            objEvent.ActivityDateTime = ev.fecha_nueva_gestion_sales__c;
            objEvent.WhoId = ev.WhoId;
            objEvent.RecordTypeId =mapRTEvt.get(Constants.RECORDTYPE_EVENT_AGENDA);
            return objEvent; 
        }
        return null;
        
    }
    
    /**
    * @description       Business logic that sets Lead Status to "Gestionado"
    * @author            fmaturan@everis.com | 12-11-2019
    * @param             new Lead Records List<Id> : lstIdsLeads
    * @return            void
    * @throws            NA
    */ 
    private static void updateLeadToGestionado(List<Id> lstIdsLeads){
        
        List<Lead> lstLead = UtilitiesSales.getLeadByIds(lstIdsLeads); 
        List<Lead> lstLeadToUpdate = new List<Lead>();
        if (lstLead != null && !lstLead.isEmpty()) {
            for(Lead lead : lstLead){
                if(lead.Status !=Constants.LEAD_STATUS_GESTIONADO){
                    lead.Status = Constants.LEAD_STATUS_GESTIONADO;
                    lead.Flag_Lead_sales__c = true;
                    lstLeadToUpdate.add(lead);
                }
            }
            if (lstLeadToUpdate != null && !lstLeadToUpdate.isEmpty() ){
                Update lstLeadToUpdate;
            }
        }     
        
    }
    /**
    * @description       Business logic that sets Lead Status to "Gestionado"
    * @author            fmaturan@everis.com | 12-11-2019
    * @param             new Lead Records List<Id> : lstIdsLeads
    * @return            void
    * @throws            NA
    */
    private static void updateLeadToNoConvertido(List<Id> lstIdsLeads){
        
        List<Lead> lstLead = UtilitiesSales.getLeadByIds(lstIdsLeads); 
        List<Lead> lstLeadToUpdate = new List<Lead>();
        if (lstLead != null && !lstLead.isEmpty()) {
            for(Lead lead : lstLead){
                if(lead.Status !=Constants.LEAD_STATUS_NO_INTERESADO){
                    System.debug('UpdateLead');
                    lead.Status = Constants.LEAD_STATUS_NO_INTERESADO;
                    lead.Flag_Lead_sales__c = false;
                    EventWizardController.evtBtn = true;
                    lstLeadToUpdate.add(lead);
                }
            }
            if (lstLeadToUpdate != null && !lstLeadToUpdate.isEmpty() ){
                Update lstLeadToUpdate;
            }
        } 
        
    }
    /**
    * @description       Business logic that sets a flag to an event
    * @author            curbinav@everis.com | 07-10-2019
    * @param1            new Event Records List<Id> : lstIds
    * @return            void
    * @throws            NA
    */    
	private static void updateEventToConvert(List<Id> lstIds){
        
        List<Event> lstEventUpdate = [SELECT Id,flag_convertido_sales__c,WhoId,recordTypeId FROM Event
                                      WHERE whoId IN : lstIds];

        for(Event evt : lstEventUpdate){
            evt.flag_convertido_sales__c = true;
        }
        
        update lstEventUpdate;
        reportLeadConvertAnalytics(lstIds);
       
    }
    /*
    * @description       Business logic that creates a quote and quote line item to an opportunity
    * @author            fmaturan@everis.com | 27-11-2019
    * @param1            new Opportunity Records List<Id> : lstIdsOpp
    * @return            void
    * @throws            NA
    */  
    
    private static void updateOpportunitySuccess(List<Id> lstIdsOpp){
        Map<String, Id> mapRTOpp = new Map<String, Id>();
        Map<String, Id> mapRTQuote = new Map<String, Id>();
        
        Map<Id, Id> mapPbs = new Map<Id, Id>();
        List<Id> lstIdsOppProd = new List<Id>();
        
        List<Opportunity> lstOpp = [SELECT Id, StageName, RecordTypeId, Name 
                                    FROM Opportunity WHERE Id IN :lstIdsOpp]; 
        List<Opportunity> lstOppToUpdate = new List<Opportunity>();
        List<Quote> listNewQuotes = new List<Quote>();
        List<QuoteLineItem> listQteLineItems = new List<QuoteLineItem>();
        
        
        if (lstOpp != null && !lstOpp.isEmpty()) {
            
            List<OpportunityLineItem> listOppProducts = [SELECT Id,Product2Id,Quantity,UnitPrice,OpportunityId 
                                                         FROM OpportunityLineItem WHERE OpportunityId IN :lstIdsOpp];
            if(listOppProducts == null || listOppProducts.isEmpty()){
                throw new UtilitiesSales.SalesException('La oportunidad debe tener asociado un producto');
            }
            PriceBook2 pb2; 
            if(test.isRunningTest()){
                pb2 = [SELECT Id FROM PriceBook2 WHERE Name = :Constants.PRICEBOOK_NAME1 Limit 1];
            }else{
                pb2 = [SELECT Id FROM PriceBook2 WHERE Name = :Constants.PRICEBOOK_NAME Limit 1];
            }
            for (OpportunityLineItem oppProd : listOppProducts) {
                lstIdsOppProd.add(oppProd.Product2Id);
            }               
            List<PriceBookEntry> listPbs = [SELECT Id,Product2Id FROM PriceBookEntry 
                                            WHERE Product2Id IN :lstIdsOppProd AND Pricebook2Id =: pb2.id];
            for (PriceBookEntry pb : listPbs) {
                mapPbs.put(pb.Product2Id,pb.Id);
            }
            for (RecordType rt : [SELECT Id, DeveloperName, SobjectType  FROM RecordType WHERE SobjectType =: Constants.OPPORTUNITY]) {
                mapRTOpp.put (rt.DeveloperName,rt.Id);
            }
            
            for (RecordType rt : [SELECT Id, DeveloperName, SobjectType  FROM RecordType WHERE SobjectType =: Constants.QUOTE]) {
                mapRTQuote.put (rt.DeveloperName,rt.Id);
            }
            
            for(Opportunity opp : lstOpp){
                opp.Flag_Actividades_Quote_sales__c=true;
                if( opp.StageName ==Constants.OPPORTUNITY_STAGE_CONTACTO  
                   && opp.RecordTypeId == mapRTOpp.get(Constants.RECORDTYPE_SEGURO_VIDA) ){                       
                       //Quote newQuote = new Quote(Name = opp.Name, OpportunityId = opp.Id, Pricebook2Id = pb2.Id);
                       opp.StageName = Constants.OPPORTUNITY_STAGENAME_COTIZACION;
                       lstOppToUpdate.add(opp);
                       //listNewQuotes.add(newQuote);
                   }else if(opp.StageName ==Constants.OPPORTUNITY_STAGE_CONTACTO
                            && opp.RecordTypeId == mapRTOpp.get(Constants.RECORDTYPE_BANCA_HIPOTECARIO)){
                                Quote newQuote = new Quote(Name = opp.Name, OpportunityId = opp.Id, Pricebook2Id = pb2.Id, RecordTypeId=mapRTQuote.get(Constants.RECORDTYPE_QUOTE_BANCA_HIPOTECARIO));
                                opp.StageName = Constants.OPPORTUNITY_STAGENAME_SIMULACION;
                                lstOppToUpdate.add(opp);
                                //listNewQuotes.add(newQuote);
                            }else if(opp.StageName == Constants.OPPORTUNITY_STAGE_CONTACTO  
                                     && opp.RecordTypeId == mapRTOpp.get(Constants.RECORDTYPE_AUTO)){
                                         Quote newQuote = new Quote(Name = opp.Name, OpportunityId = opp.Id, Pricebook2Id = pb2.Id, RecordTypeId=mapRTQuote.get(Constants.RECORDTYPE_QUOTE_AUTO));
                                         opp.StageName = Constants.OPPORTUNITY_STAGENAME_COTIZACION;
                                         lstOppToUpdate.add(opp);
                                         //listNewQuotes.add(newQuote);
                                     }else if(opp.StageName == Constants.OPPORTUNITY_STAGE_CONTACTO  
                                              && opp.RecordTypeId == mapRTOpp.get(Constants.RECORDTYPE_HOGAR)){
                                                  Quote newQuote = new Quote(Name = opp.Name, OpportunityId = opp.Id, Pricebook2Id = pb2.Id, RecordTypeId=mapRTQuote.get(Constants.RECORDTYPE_QUOTE_HOGAR));
                                                  opp.StageName = Constants.OPPORTUNITY_STAGENAME_COTIZACION;
                                                  lstOppToUpdate.add(opp);
                                                  //listNewQuotes.add(newQuote);
                                              }
            }
            if (lstOppToUpdate != null && !lstOppToUpdate.isEmpty() ){
                Update lstOppToUpdate;
                if(listNewQuotes != null && !listNewQuotes.isEmpty()){
                	Insert listNewQuotes;
                    for (OpportunityLineItem oppProduct : listOppProducts) {
                        for (Quote qte : listNewQuotes) {
                            QuoteLineItem qteLineItem = new QuoteLineItem(UnitPrice = oppProduct.UnitPrice, 
                                                                          Product2Id=oppProduct.Product2Id,
                                                                          Quantity=oppProduct.Quantity,
                                                                          QuoteId=qte.Id,
                                                                          PricebookEntryId=mapPbs.get(oppProduct.Product2Id),
                                                                          OpportunityLineItemId=oppProduct.Id);
                            listQteLineItems.add(qteLineItem);                       
                        }                    
                    }
                    if (listQteLineItems != null && !listQteLineItems.isEmpty()) {
                        Insert listQteLineItems;                       
                    } 
                }   
             }
        }       
    }
    /*
    * @description       Logic detect email in Account
    * @author            fmaturan@everis.com | 27-11-2019
    * @param1            Id Account
    * @return            Boolean
    * @throws            NA
    */  
    private static boolean hadEmailAccount(Id IdAccount){
        Contact AccWithoutEmail = [Select Id, Email From Contact Where Id =:IdAccount];
        if (AccWithoutEmail != null) {
            
            if(AccWithoutEmail.Email == Null){
                return false;
            }else{
                return true;
            } 
            
        }
        return null;
    }
    /*
    * @description       Logic detect email in Lead
    * @author            fmaturan@everis.com | 27-11-2019
    * @param1            Id lead
    * @return            Boolean
    * @throws            NA
    */  
    private static boolean hadEmailLead(Id IdsLead){
        Lead leadWithoutEmail = [Select Id, Email From Lead Where Id =:IdsLead];
        if (leadWithoutEmail != null) {
            
            if(leadWithoutEmail.Email == Null){
                return false;
            }else{
                return true;
            } 
            
        }
        return null;
    }
}