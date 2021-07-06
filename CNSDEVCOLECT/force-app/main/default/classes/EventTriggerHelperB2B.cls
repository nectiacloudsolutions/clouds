/*********************************************************************************************************
@Author       mbeltrab@everis.com
@name         EventTriggerHelperB2B
@CreateDate   05/08/2020
@Description  Helper of the Event object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
05/08/2020                    mbeltrab@everis.com           Initial Version
**********************************************************************************************************/

public with sharing class EventTriggerHelperB2B {
    public static final String EVENT = 'Event';
    public static final String RECORDTYPE_EVENT_EMPRESA= 'Evento BBEE';
    public static final String RT_EVENT_EMPRESA= 'Evento_BBEE';
    
    public static final String EVENT_ESTADO_CONTACTADOINTERESADO = 'Contactado Interesado'; //estado__c
    public static final String EVENT_ESTADO_DESECHADOEJECUTIVO = 'Desechado Ejecutivo'; //estado__c
    public static final String EVENT_ESTADO_DESCARTADOCLIENTE = 'Descartado Cliente'; //estado__c
    public static final String EVENT_ESTADO_NOCONTACTADO = 'No Contactado'; //estado__c
    public static final String EVENT_ESTADO_COORDINARAVISITA = 'Se coordinará Visita'; //estado__c

    
    public static final String EVENT_ESTADO_VISITAAGENDADA = 'Visita Agendada'; //estado__c
    public static final String EVENT_ESTADO_VISITAEXITOSA = 'Visita Exitosa'; //estado__c
    public static final String EVENT_ESTADO_VISITAEXITOSADESCARTADOCLIENTE = 'Visita Exitosa - Descartado Cliente'; //estado__c
    public static final String EVENT_ESTADO_VISITAEXITOSADESCARTADOEJECUTIVO = 'Visita Exitosa - Descartado Ejecutivo'; //estado__c
    public static final String EVENT_ESTADO_VISITACANCELADA = 'Visita Cancelada'; //estado__c
    public static final String EVENT_ESTADO_VISITANEGADA = 'Visita Negada'; //estado__c
    
    public static final String EVENT_ERROR1 = 'Debe ingresar un MAIL en el prospecto antes de cambiar el estado de la visita a través de un contacto principal';


    public static Lead getLeadByStatusAndetapaProspecto (Lead ilead, String iStatus, String etapaProspecto){
        system.debug('debug1: iStatus' + iStatus);
        return new Lead (
            Id          = ilead.Id,
            Status      = iStatus,
            Etapa_Prospecto__c = etapaProspecto
        );
    }

	public static void statusLeadByEventEstado (List<Event> eventList){
        system.debug('debug0: eventList' + eventList);
        Set<String> LeadsId = new Set<String>();
        Lead LeadUpdate = new Lead();
        List<Lead> leadsToUpdate = new List<Lead>();

        String RTEventEmpresa = EventTriggerHelperB2B.getRecordTypeId(RT_EVENT_EMPRESA);
        system.debug('debug00: eventList' + eventList);
        
        for (Event ev : eventList) {
            if(ev.WhoId != null 
                && ev.RecordTypeId == RTEventEmpresa 
                && String.valueOf(ev.WhoId.getSobjectType())  == LeadTriggerHelperB2b.LEAD){
                LeadsId.add(ev.WhoId);
            }
        }  
        system.debug('debug000: eventList' + eventList);

        Map<Id,Lead> mapLeadsAsociadosaEventos = UtilitiesSalesB2B.getLeadsAsociadosEventos(LeadsId);
        // UtilitiesSalesB2B.getIdRecordTypeEventEmpresa();
        system.debug('debug0000: eventList' + eventList);

        for (Event event: eventList) {
            if(event.WhoId != null 
                && String.valueOf(event.WhoId.getSobjectType())  == LeadTriggerHelperB2b.LEAD
                && (event.Estado__c == EVENT_ESTADO_CONTACTADOINTERESADO
                    || event.Estado__c == EVENT_ESTADO_COORDINARAVISITA
                    || event.Estado__c == EVENT_ESTADO_DESECHADOEJECUTIVO
                    || event.Estado__c == EVENT_ESTADO_VISITAAGENDADA
                    || event.Estado__c == EVENT_ESTADO_DESCARTADOCLIENTE
                    || event.Estado__c == EVENT_ESTADO_NOCONTACTADO
                    || event.Estado__c == EVENT_ESTADO_VISITAEXITOSA
                    || event.Estado__c == EVENT_ESTADO_VISITAEXITOSADESCARTADOCLIENTE
                    || event.Estado__c == EVENT_ESTADO_VISITAEXITOSADESCARTADOEJECUTIVO
                    || event.RecordTypeId == RTEventEmpresa)
                    ){
                    system.debug('debug2: WhoId:' + event.WhoId);
                        
                    if (mapLeadsAsociadosaEventos.containsKey(event.WhoId)) {
                        Lead leadEvent = mapLeadsAsociadosaEventos.get(event.WhoId);
                        system.debug('debug3: leadEvent' + leadEvent);
                        
                        if (leadEvent.Status == LeadTriggerHelperB2b.LEAD_STATUS_SIN_GESTION && event.estado__c == EVENT_ESTADO_CONTACTADOINTERESADO) {
                            leadsToUpdate.add(
                                getLeadByStatusAndetapaProspecto(leadEvent, LeadTriggerHelperB2b.LEAD_STATUS_GESTIONADO, LeadTriggerHelperB2b.LEAD_ETAPA_CONTACTADO)
                            );
                        } 
                        else if (leadEvent.Status == LeadTriggerHelperB2b.LEAD_STATUS_SIN_GESTION && event.estado__c == EVENT_ESTADO_COORDINARAVISITA) {
                            leadsToUpdate.add(
                                getLeadByStatusAndetapaProspecto(leadEvent, LeadTriggerHelperB2b.LEAD_STATUS_GESTIONADO, LeadTriggerHelperB2b.LEAD_ETAPA_CONTACTADO)
                            );
                        } 
                        else if (leadEvent.Status == LeadTriggerHelperB2b.LEAD_STATUS_GESTIONADO 
                                && (event.estado__c == EVENT_ESTADO_DESECHADOEJECUTIVO ||  event.estado__c == EVENT_ESTADO_DESCARTADOCLIENTE)) {
                            leadsToUpdate.add(
                                getLeadByStatusAndetapaProspecto(leadEvent, LeadTriggerHelperB2b.LEAD_STATUS_NO_INTERESADO, LeadTriggerHelperB2b.LEAD_ETAPA_DESCARTADOGESTIONADO)
                            );
                        } 
                        else if (leadEvent.Status == LeadTriggerHelperB2b.LEAD_STATUS_GESTIONADO && event.estado__c == EVENT_ESTADO_VISITAAGENDADA) {
                            leadsToUpdate.add(
                                getLeadByStatusAndetapaProspecto(leadEvent, LeadTriggerHelperB2b.LEAD_STATUS_VISITA, LeadTriggerHelperB2b.LEAD_ETAPA_CONTACTADOVISITA)
                            );
                        } 
                        else if (leadEvent.Status == LeadTriggerHelperB2b.LEAD_STATUS_GESTIONADO && event.estado__c == EVENT_ESTADO_NOCONTACTADO) {
                            leadsToUpdate.add(
                                getLeadByStatusAndetapaProspecto(leadEvent, leadEvent.Status, LeadTriggerHelperB2b.LEAD_ETAPA_GESTIONNOLOGRADA)
                            );
                        } 
                        else if (leadEvent.Status == LeadTriggerHelperB2b.LEAD_STATUS_VISITA && event.estado__c == EVENT_ESTADO_VISITAEXITOSA) {
                            if (leadEvent.Email == '' || leadEvent.Email == null) {
                                event.addError(EVENT_ERROR1);
                            }else{
                                if(!leadEvent.Informe_Visita_Generado__c){
                                    leadEvent.Etapa_Prospecto__c = LeadTriggerHelperB2b.LEAD_ETAPA_PENDIENTEINFORMEVISITA;
                                }
                                leadEvent.Visita_comercial_exitosa__c = true;
                                leadsToUpdate.add(leadEvent);
                            }
                        } 
                        else if (leadEvent.Status == LeadTriggerHelperB2b.LEAD_STATUS_VISITA && event.estado__c == EVENT_ESTADO_VISITAEXITOSADESCARTADOCLIENTE) {
                            leadsToUpdate.add(
                                getLeadByStatusAndetapaProspecto(leadEvent, LeadTriggerHelperB2b.LEAD_STATUS_NO_INTERESADO, LeadTriggerHelperB2b.LEAD_ETAPA_DESCARTADOVISITA)
                            );
                        } 
                        else if(leadEvent.Status == LeadTriggerHelperB2b.LEAD_STATUS_VISITA 
                                && event.estado__c == EVENT_ESTADO_VISITAEXITOSADESCARTADOEJECUTIVO){
                            leadsToUpdate.add(
                                getLeadByStatusAndetapaProspecto(leadEvent, LeadTriggerHelperB2b.LEAD_STATUS_NO_INTERESADO, LeadTriggerHelperB2b.LEAD_ETAPA_DESCARTADOVISITA)
                            );
                        } 
                        else if(leadEvent.Status == LeadTriggerHelperB2b.LEAD_STATUS_VISITA 
                                && event.estado__c == EVENT_ESTADO_VISITANEGADA){
                            leadsToUpdate.add(
                                getLeadByStatusAndetapaProspecto(leadEvent, LeadTriggerHelperB2b.LEAD_STATUS_NO_INTERESADO, LeadTriggerHelperB2b.LEAD_ETAPA_DESCARTADOVISITA)
                            );
                        }
                    }
                }
            }


        if(!leadsToUpdate.isEmpty()){
            system.debug('debug5: leadsToUpdate:' + leadsToUpdate);
            Update leadsToUpdate;
        }
	}
    
    
	public static void updateLeadByEventEstado (List<Event> updateEvent, Map<ID,Event> oldEvent){
        Set<String> LeadsId = new Set<String>();
        Lead LeadUpdate = new Lead();
        List<Lead> leadsToUpdate = new List<Lead>();

        String RTEventEmpresa = EventTriggerHelperB2B.getRecordTypeId(RT_EVENT_EMPRESA);

        for (Event ev : updateEvent) {
            if(ev.WhoId != null 
                && ev.RecordTypeId == RTEventEmpresa 
                && String.valueOf(ev.WhoId.getSobjectType())  == LeadTriggerHelperB2b.LEAD){            
                LeadsId.add(ev.WhoId);
            }
        }  

        Map<Id,Lead> mapLeadsAsociadosaEventos = UtilitiesSalesB2B.getLeadsAsociadosEventos(LeadsId);
        
        for (Event event: updateEvent){
            Event eventOld = oldEvent.get(event.Id);

            if (String.valueOf(event.WhoId.getSobjectType())  == LeadTriggerHelperB2b.LEAD ) {
                if ( eventOld.Estado__c != event.Estado__c && event.RecordTypeId == RTEventEmpresa ) {
                    Lead leadEvent = mapLeadsAsociadosaEventos.get(event.WhoId);
                    
                    if (leadEvent.Status == LeadTriggerHelperB2b.LEAD_STATUS_VISITA) {
                        //Estado Prospecto Visita, Evento visita exitosa
                        if(event.Estado__c == EVENT_ESTADO_VISITAEXITOSA){
                            if(leadEvent.Email == '' || leadEvent.Email == null){
                                event.addError(EVENT_ERROR1);
                            }else{
                                if(!leadEvent.Informe_Visita_Generado__c){
                                    leadEvent.Etapa_Prospecto__c = LeadTriggerHelperB2b.LEAD_ETAPA_PENDIENTEINFORMEVISITA;
                                }
                                leadEvent.Visita_comercial_exitosa__c = true;
                                leadsToUpdate.add(leadEvent);
                            }
                        }
                        //Estado Prospecto Visita, Evento visita exitosa descartado cliente
                        else if(event.Estado__c == EVENT_ESTADO_VISITAEXITOSADESCARTADOCLIENTE  
                                || event.Estado__c == EVENT_ESTADO_VISITAEXITOSADESCARTADOEJECUTIVO 
                                || event.estado__c == EVENT_ESTADO_VISITANEGADA ){
                            
                            leadsToUpdate.add(
                                getLeadByStatusAndetapaProspecto(leadEvent, LeadTriggerHelperB2b.LEAD_STATUS_NO_INTERESADO, LeadTriggerHelperB2b.LEAD_ETAPA_DESCARTADOVISITA)
                            );
                        }
                    }
                }
            }
        }
        
        if(leadsToUpdate.size()>0){
            Update leadsToUpdate;
        }
             
    }
    

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   RECORD_TYPE_MAP_DEVELOPERNAME of Lead object
    */
    public static Map<String, RecordType> RECORD_TYPE_MAP_DEVELOPERNAME{
        get{
            if (RECORD_TYPE_MAP_DEVELOPERNAME == null){

            	RECORD_TYPE_MAP_DEVELOPERNAME = new Map<String, RecordType>();

            	List<RecordType> lstRecordType = [SELECT Id, Name,
								            	  DeveloperName 
								            	  FROM RecordType 
								            	  WHERE SobjectType =: Schema.Event.sObjectType.getDescribe().getName() 
            									  ];

            	for (RecordType iRecordType : lstRecordType){
            		RECORD_TYPE_MAP_DEVELOPERNAME.put(iRecordType.DeveloperName, iRecordType);
            	}
            }
            return RECORD_TYPE_MAP_DEVELOPERNAME;
        }
        set;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Map of RecordTypeInfo
    */
    public static String getRecordTypeId (String developerName){
        return RECORD_TYPE_MAP_DEVELOPERNAME.get(developerName).Id;
    }

}