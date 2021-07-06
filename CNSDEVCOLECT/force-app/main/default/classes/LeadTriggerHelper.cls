/*********************************************************************************************************
@Author       eayalcor@everis.com
@name         LeadTriggerHelper
@CreateDate   01/10/2019
@Description  Helper of the Lead object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
01/10/2019                    eayalcor@everis.com           Initial Version
11/11/2019					  fbizamam@everis.com			W-000149 - (Gestión del Lead) - Cambio de estados del Candidato/T-00083/ Updated the onAfterUpdate method
12/11/2019					  fbizamam@everis.com			W-000149 - (Gestión del Lead) - Cambio de estados del Candidato/T-00083/ Added the statusManagement method to manage the lead status
16/11/2019					  fbizamam@everis.com			W-000315 - (Integración) - Notificación cambio de etapa de un LEAD/T-00234/Added the reportModifiedStage Method and Updated the onAfterUpdate Method
**********************************************************************************************************/
public without sharing class LeadTriggerHelper {
    /**
* @description       Business logic for trigger on Before Update
* @param1            new Records List<Lead> : leadList
* @return            void
* @throws            NA
*/      
    public void onBeforeUpdate(List<Lead> leadList, Map<ID, Lead> oldLeadMap){
        try{
            for(Lead l : leadList){
                if(l.Status != oldLeadMap.get(l.Id).Status){
                    if(!Consorcio_Org__c.getInstance(UserInfo.getProfileId()).leads_sales__c && !EventWizardController.evtBtn){
                        throw new UtilitiesSales.SalesException('Usuario no posee permisos para cambiar manualmente el status');           
                    }
                }else if(oldLeadMap.get(l.Id).Status== CONSTANTS.LEAD_STATUS_NO_INTERESADO ){
                    l.Flag_Lead_sales__c = true;
                }else if(l.ownerId != oldLeadMap.get(l.Id).OwnerId ){
                    l.rut_ejecutivo_sales__c = UtilitiesSales.getRutExecutiveWithDot((Id)l.OwnerId,Constants.WITHOUTDOT);
                }     
            }
            
        }catch(Exception e){
           Trigger.new[0].addError(e.getMessage());
        }
    }
    
    /**
* @description       Business logic for trigger on After Update
* @param1            new Records List<Lead> : leadList
* @return            void
* @throws            NA
*/ 
    
    public void onAfterUpdate(List<Lead> leadList,Map<ID, Lead> oldLeadMap) {
        try{
            List<Id> lstLeadIds= new List<Id>();
            Set<String> rut = new Set<String>();        
            List<Id> lstReportToSend = new List<Id>();   
            List<Id> lstReportOwnerChanges = new List<Id>();
            
            
            for(Lead l : leadList){
                if(l.ownerId != oldLeadMap.get(l.Id).OwnerId ){
                    lstReportOwnerChanges.add(l.Id);
                } 
                if(l.Status != oldLeadMap.get(l.Id).Status && l.status != CONSTANTS.LEAD_STATUS_CONVERTIDO){
                    lstReportToSend.add(l.Id);
                } 
                if(l.numero_de_documento_sales__c != null && UtilitiesSales.validarRunRut(l.numero_de_documento_sales__c)){
                    rut.add(l.numero_de_documento_sales__c);  
                    
                }else if(l.numero_de_documento_sales__c == null && !UtilitiesSales.validarRunRut(l.numero_de_documento_sales__c)){
                    throw new UtilitiesSales.SalesException('El candidato no puede ser convertido a Cuenta si no posee RUT');
                }   
            } 
            if(!lstReportToSend.isEmpty()){
                system.debug('Entra en envio de Update');
                reportModifiedStage(lstReportToSend);
            }
            if(!lstReportOwnerChanges.isEmpty()){
                reportChangedOwner(lstReportOwnerChanges);
            }
            
           
            //comprobar duplicados
            List<Account> lstAccount = [SELECT Id,Rut__c,OwnerId FROM Account 
                                        WHERE Tipo_de_documento_de_identidad__c =: Constants.RUT 
                                        AND rut__c IN : rut];      
            if (lstAccount != null && !lstAccount.isEmpty()) {
                for(Lead lead : leadList){
                    for(Account acc : lstAccount){
                        if(!lead.numero_de_documento_sales__c.equals(acc.Rut__C)){
                            lstLeadIds.add(lead.Id);
                        }
                    }
                }
            }else{
                for(Lead lead : leadList){
                    if(lead.numero_de_documento_sales__c != null 
                       && !String.isBlank(lead.numero_de_documento_sales__c)
                       && UtilitiesSales.validarRunRut(lead.numero_de_documento_sales__c)){  
                           lstLeadIds.add(lead.Id);
                       }
                }
            }    
            if (lstLeadIds != null && !lstLeadIds.isEmpty()) {
                autoConvertLead(lstLeadIds);
                //metodo  para gestionar el estado de leads
                //statusManagement(lstLeadIds); 
            }
            
            
        }catch(Exception e){
            system.debug('ERROR LLAMADA:' + e.getMessage());
            e.setMessage('Ha ocurrido un error, informe a un administrador :'+e.getCause());
        }
        
    }
 
    
    /**
* @description       Business logic to convert Lead to PersonAccount
* @param1            new Records List<Id> : Id Leads List
* @return            void
* @throws            NA
*/ 
    private static void autoConvertLead(List<Id> lstIdsLeads){
        try{
            List<Database.LeadConvertResult> lcr;
            String urlRef;
            PageReference page;
            
            // convierte leads que tengan al menos un evento entrevista y que tengan resultados de entrevista: existosos
            AggregateResult[] aggResult = [SELECT WhoId, count(Event.Id) eventCount
                                           FROM Event
                                           WHERE WhoId IN : lstIdsLeads
                                           AND ((Type =: Constants.EVENT_TYPE_ENTREVISTA AND estado_reunion_sales__c =: Constants.EVENT_ESTADO_ENTREVISTA_EXITOSO )
                                                OR (Type =: Constants.EVENT_TYPE_LLAMADA AND resultado_llamada_sales__c =: Constants.EVENT_RESULTADO_LLAMADA_EXITOSA))
                                           AND flag_convertido_sales__c = false
                                           GROUP BY WhoId];
            List<Id> lstIdConvert = new List<Id>();
            
            if (aggResult != null && !aggResult.isEmpty()) { 
                
                for(AggregateResult ar : aggResult){
                    if((Integer)ar.get('eventCount') > 0){
                        lstIdConvert.add((Id)ar.get('WhoId'));   
                    } 
                }
                if (lstIdConvert != null && !lstIdConvert.isEmpty()) {
                    
                    updateEventToConvert(lstIdConvert);
                    
                    if(!Test.isRunningTest()){
                        
                        lcr = UtilitiesSales.autoConvertLead(lstIdConvert);
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
        }catch(Exception e){
            system.debug('ERROR:' + e.getMessage());
            e.setMessage('Ha ocurrido un error, informe a un administrador :'+e.getCause());
        }
    }
    /**
* @description       Business logic to convert Lead to PersonAccount
* @param1            new Records List<Event> : eventList
* @return            void
* @throws            NA
*/ 
    
    private static void updateEventToConvert(List<Id> lstIds){
        try{
            List<Event> lstEventUpdate = [SELECT Id,flag_convertido_sales__c FROM Event
                                          WHERE whoId IN : lstIds];  
            for(Event evt : lstEventUpdate){
                evt.flag_convertido_sales__c = true;
            }	
            update lstEventUpdate;
            reportLeadConvertAnalytics(lstIds);
            
        }catch(Exception e){e.setMessage('Ha ocurrido un error, informe a un administrador :'+e.getCause());}
    }
    /**
* @description      This method is used to inform the LEADS whose stage was changed
* @author           fbizamam@everis.com | 15-01-2020 
* @param            List<ID> LeadToReport 
* @return           void 
**/
    public static void reportModifiedStage(List<ID> LeadToReport){
        
        
        if(!LeadToReport.isEmpty()){
            system.debug('leadIds sent to analytics that had their stage changed'+LeadToReport);
            if(!test.isRunningTest()){
                SalesCallout.consultLeadAnalyticsAsyncMassive(LeadToReport, CONSTANTS.CHANGE_STATUS, CONSTANTS.ANALYTICSLEAD);            
            }
        }
    }
    /**
* @description      This method is used to inform the LEADS whose owner was changed
* @author           fbizamam@everis.com | 03-02-2020 
* @param            List<ID> LeadToReport 
* @return           void 
**/
    public static void reportChangedOwner(List<ID> LeadToReport){
        
        
        if(!LeadToReport.isEmpty()){
            system.debug('leadIds sent to analytics that had their OWNER changed'+LeadToReport);
            SalesCallout.consultLeadAnalyticsAsyncMassive(LeadToReport, CONSTANTS.CHANGE_OWNER, CONSTANTS.ANALYTICSLEAD);
        }
    }
    /**
* @description       This method calls helper class methods on afterInsert event of sObject Lead
* @param1            new Records List<Lead> : newLead
* @param2            new Records List<Lead, ID>: newLeadMap
* @return            void
* @throws            NA 
*/
    public void reportLeadCreationAnalytics(List<Lead> newLead, Map<ID,Lead> newLeadMap){
        //Logica
        List<String> leadIds = new List<String>();
        for(lead l : newLead){
            if(!l.origen_analytics_sales__c){
                leadIds.add(l.id);
            }
        }
        if(!leadIds.isEmpty()){
            system.debug('leadIds send analytics'+leadIds);
            if(!test.isRunningTest()){
                SalesCallout.consultLeadAnalyticsAsyncMassive(leadIds, CONSTANTS.INSERTED, CONSTANTS.ANALYTICSLEAD);
            }
        }
    }
    
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
            if(!test.isRunningTest()){
                SalesCallout.consultLeadAnalyticsAsyncMassive(leadIds, CONSTANTS.CONVERTED, CONSTANTS.ANALYTICSLEAD);
            }
        }
    }
}