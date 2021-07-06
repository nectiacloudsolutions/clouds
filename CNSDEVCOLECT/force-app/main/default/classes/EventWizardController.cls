/**
 * @File Name          : EventWizardController.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 07-07-2020
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    1/20/2020         eayalcor@everis.com    Initial Version
**/

public with sharing class EventWizardController { 

    public static Boolean evtBtn = false;

    /**
    * @description 
    * @author eayalcor@everis.com | 07-07-2020 
    * @param Id leadId 
    * @return Map<String, List<String>> 
    **/
    @AuraEnabled
    public static Map<String,List<String>> getInitialData(Id leadId){ 

        Map<String,List<String>> mapData = new Map<String,List<String>>();
        List<String> lstPhones = new List<String>();
		List<String> hasRut = new List<String>();
        List<Lead> lstLead = [SELECT phone,mobilephone,other_phone_sales__c,other_phone2_sales__c, numero_de_documento_sales__c
                 FROM Lead WHERE Id =: leadId]; 
        
        for(Lead lead : lstLead){
            lstPhones.add(lead.phone);
            lstPhones.add(lead.mobilephone);
            lstPhones.add(lead.other_phone_sales__c);
            lstPhones.add(lead.other_phone2_sales__c);
            if(lead.numero_de_documento_sales__c == null || String.isBlank(lead.numero_de_documento_sales__c)){
                hasRut.add(CONSTANTS.OK);
            }
        }

        Map<String,List<String>> mapDepent = UtilitiesSales.getDependentPicklistValues(Event.resultado_llamada_sales__c);

        mapData.put('Telefonos', lstPhones);
        mapData.put('Contactado', mapDepent.get('Contactado'));
        mapData.put('NoContactado', mapDepent.get('No Contactado'));
        mapData.put('Motivos', UtilitiesSales.getPicklistData(Event.motivo_no_interesa_sales__c));
        mapData.put('Rut', hasRut);
        mapData.put('MotivosFecha', null);

        return mapData;

    }

    /**
    * @description 
    * @author eayalcor@everis.com | 07-07-2020 
    * @param String phone 
    * @param String status 
    * @param String result 
    * @param String reason 
    * @param String comment 
    * @param String leadId 
    * @param String nextDate 
    * @return string 
    **/
    @AuraEnabled
    public static string saveEvent(String phone,String status,String result,String reason,
                                String comment, String leadId, String nextDate){

        String response = '';

        try {
            
            List<Lead> lstLead = [SELECT Name,phone,mobilephone,other_phone_sales__c,other_phone2_sales__c
                 FROM Lead WHERE Id =: leadId]; 

            Event event = new Event();
            event.Subject = 'Llamada a ' + lstLead[0].Name;
            event.StartDateTime = datetime.now();
            event.EndDateTime = datetime.now().addMinutes(5);
            event.Type = Constants.EVENT_TYPE_LLAMADA;
            event.WhoId = leadId;
            event.resultado_llamada_sales__c = Accents.removeDiacritics(result);
            event.estado_llamada_sales__c = status;
            event.motivo_no_interesa_sales__c = reason;
            event.telefono_gestion_sales__c = phone;
            event.Comentarios_sales__c = comment;
            event.RecordTypeId = [SELECT Id FROM RecordType WHERE sObjectType =: Constants.EVENT AND DeveloperName =: Constants.RECORDTYPE_EVENT_LLAMADA LIMIT 1].Id;
            if(!String.isBlank(nextDate) || nextDate != null){
                Datetime dt = (DateTime)JSON.deserialize('"' + nextDate + '"', DateTime.class);
                event.fecha_nueva_gestion_sales__c = dt;
            }
            evtBtn = true;
            insert event;

            response = event.Id;
            
        } catch (Exception ex) {
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
            System.debug(ex.getCause());
            System.debug(ex.getLineNumber());
            response = null; 
        }        

        return response;
    }

}