/**
 * @description       : 
 * @author            : ggonzroj@everis.com
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ggonzroj@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   09-14-2020   ggonzroj@everis.com   Initial Version
**/
@isTest
public without sharing class EventTriggerHelperB2BTest {
    @testSetup static void dataloadB2B(){
        User iUserEjecutivoVenta = TestFactoryB2B.getUserEjecutivoComercialBE();
        insert iUserEjecutivoVenta;

        TestFactoryB2B.createConsorcioOrgB2B();

        CS_IntegracionesAndes__c apitoken = TestFactoryB2B.getCSIntegracionesAndes('GetTokenInformesAndes');
        insert apitoken;

        CS_IntegracionesAndes__c apiGenerarInfo = TestFactoryB2B.getCSIntegracionesAndes('GenerarInformesAndes');
        apiGenerarInfo.Active__c = false;
        insert apiGenerarInfo;
    } 

    @isTest 
    private static void eventInsertTest(){
        User iUserEjecutivoVenta = [SELECT Id, RUT__c, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];
        
        System.runAs(iUserEjecutivoVenta){
            Lead leadRTEmpresa = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadRTEmpresa.FirstName                     = 'Lorena1141'; 
            leadRTEmpresa.LastName                      = 'Reinoso1141';
            leadRTEmpresa.RUTEmpresa__c                 = '18685983-9';
            leadRTEmpresa.EmpresaGrupoFilial__c         = '1';
            leadRTEmpresa.IdRutEmpresaFilial__c         = leadRTEmpresa.RUTEmpresa__c+leadRTEmpresa.EmpresaGrupoFilial__c;
            leadRTEmpresa.Etapa_Prospecto__c            = LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION;
            insert leadRTEmpresa;

            Event iEvent = getEventsByStatusAndEtapa('Llamada',leadRTEmpresa.Id,EventTriggerHelperB2B.EVENT_ESTADO_CONTACTADOINTERESADO,EventTriggerHelperB2B.RT_EVENT_EMPRESA);
            insert iEvent;

            Event iEvent2 = getEventsByStatusAndEtapa('Llamada',leadRTEmpresa.Id,EventTriggerHelperB2B.EVENT_ESTADO_DESECHADOEJECUTIVO,EventTriggerHelperB2B.RT_EVENT_EMPRESA);
            insert iEvent2;
            
            // ---------------------------------------------------------------------------------------------------------
            // ------------   Lead LEAD_STATUS_SIN_GESTION +++ EVENT_ESTADO_COORDINARAVISITA   ----------------
            // ---------------------------------------------------------------------------------------------------------
            Lead leadStatusGestionado = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadStatusGestionado = getleadByStatusAndEtapa(leadStatusGestionado, LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION, LeadTriggerHelperB2b.LEAD_STATUS_SIN_GESTION, 'Reinoso1142', '23093442-8');
            insert leadStatusGestionado;

            Event iEvent6 = getEventsByStatusAndEtapa('Llamada', leadStatusGestionado.Id, EventTriggerHelperB2B.EVENT_ESTADO_COORDINARAVISITA, EventTriggerHelperB2B.RT_EVENT_EMPRESA);
            insert iEvent6;

            // ---------------------------------------------------------------------------------------------------------
            // ------------   Lead LEAD_STATUS_GESTIONADO +++ EVENT_ESTADO_VISITAAGENDADA   ----------------
            // ---------------------------------------------------------------------------------------------------------
            Lead leadViAgendada = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadViAgendada = getleadByStatusAndEtapa(
                                            leadViAgendada, 
                                            LeadTriggerHelperB2b.LEAD_ETAPA_CONTACTADO, 
                                            LeadTriggerHelperB2b.LEAD_STATUS_GESTIONADO, 
                                            'Reinotri1142', 
                                            '16343408-3');
            insert leadViAgendada; 

            Event iEvent3 = getEventsByStatusAndEtapa('Visita',leadViAgendada.Id,EventTriggerHelperB2B.EVENT_ESTADO_VISITAAGENDADA, EventTriggerHelperB2B.RT_EVENT_EMPRESA);
            insert iEvent3;


            // ---------------------------------------------------------------------------------------------------------
            // ------------   Lead LEAD_STATUS_GESTIONADO +++ EVENT_ESTADO_NOCONTACTADO   ----------------
            // ---------------------------------------------------------------------------------------------------------
            Lead leadGestionadoEvNoContactado = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadGestionadoEvNoContactado = getleadByStatusAndEtapa(
                                                leadGestionadoEvNoContactado, 
                                                LeadTriggerHelperB2b.LEAD_ETAPA_CONTACTADO, 
                                                LeadTriggerHelperB2b.LEAD_STATUS_GESTIONADO, 
                                                'Reino1142', 
                                                '15715551-2');
            insert leadGestionadoEvNoContactado;

            Event iEvent4 = getEventsByStatusAndEtapa('Llamada', 
                                        leadGestionadoEvNoContactado.Id, 
                                        EventTriggerHelperB2B.EVENT_ESTADO_NOCONTACTADO, 
                                        EventTriggerHelperB2B.RT_EVENT_EMPRESA);
            insert iEvent4;


            // leadRTEmpresa.Status = LeadTriggerHelperB2b.LEAD_STATUS_VISITA;
            // update leadRTEmpresa;


            // ---------------------------------------------------------------------------------------------------------
            // ------------   Lead LEAD_STATUS_VISITA +++ EVENT_ESTADO_VISITAEXITOSA   ----------------
            // ---------------------------------------------------------------------------------------------------------
            Lead leadEvenVisitExitosa = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadEvenVisitExitosa = getleadByStatusAndEtapa(leadEvenVisitExitosa, 
                                                        LeadTriggerHelperB2b.LEAD_ETAPA_CONTACTADOVISITA, 
                                                        LeadTriggerHelperB2b.LEAD_STATUS_VISITA, 
                                                        'Reo1982', 
                                                        '15125192-7');
            leadEvenVisitExitosa.Email = null;
            insert leadEvenVisitExitosa;

            try {
                Event iEvent5 = getEventsByStatusAndEtapa('Visita', leadEvenVisitExitosa.Id, EventTriggerHelperB2B.EVENT_ESTADO_VISITAEXITOSA, EventTriggerHelperB2B.RT_EVENT_EMPRESA);
                insert iEvent5;
            } catch (Exception ex) {
                System.assertEquals(ex.getMessage().contains(EventTriggerHelperB2B.EVENT_ERROR1), true);
            } 


            Lead leadEvenVisitExitosa2 = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadEvenVisitExitosa2 = getleadByStatusAndEtapa(leadEvenVisitExitosa2, 
                                                        LeadTriggerHelperB2b.LEAD_ETAPA_CONTACTADOVISITA, 
                                                        LeadTriggerHelperB2b.LEAD_STATUS_VISITA, 
                                                        'Reo1982tren', 
                                                        '24325286-5');
            insert leadEvenVisitExitosa2;

            Event iEvent51 = getEventsByStatusAndEtapa('Visita', leadEvenVisitExitosa2.Id, EventTriggerHelperB2B.EVENT_ESTADO_VISITAEXITOSA, EventTriggerHelperB2B.RT_EVENT_EMPRESA);
            insert iEvent51;

            // ---------------------------------------------------------------------------------------------------------
            // ------------   Lead LEAD_STATUS_VISITA +++ EVENT_ESTADO_VISITAEXITOSADESCARTADOCLIENTE   ----------------
            // ---------------------------------------------------------------------------------------------------------
            Lead leadVisitExitoDescartadoClient = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadVisitExitoDescartadoClient = getleadByStatusAndEtapa(
                                        leadVisitExitoDescartadoClient, 
                                        LeadTriggerHelperB2b.LEAD_ETAPA_CONTACTADOVISITA,
                                        LeadTriggerHelperB2b.LEAD_STATUS_VISITA, 
                                        'Reo1142', 
                                        '17075075-6');
            insert leadVisitExitoDescartadoClient;

            Event iEvent7 = getEventsByStatusAndEtapa('Visita', 
                                        leadVisitExitoDescartadoClient.Id, 
                                        EventTriggerHelperB2B.EVENT_ESTADO_VISITAEXITOSADESCARTADOCLIENTE, 
                                        EventTriggerHelperB2B.RT_EVENT_EMPRESA);

            insert iEvent7;
           
            // ---------------------------------------------------------------------------------------------------------
            // ------------   Lead LEAD_STATUS_VISITA +++ EVENT_ESTADO_VISITAEXITOSADESCARTADOEJECUTIVO   ----------------
            // ---------------------------------------------------------------------------------------------------------
            Lead leadVisitDescartaEjecut = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadVisitDescartaEjecut = getleadByStatusAndEtapa(leadVisitDescartaEjecut, 
                                                            LeadTriggerHelperB2b.LEAD_ETAPA_CONTACTADOVISITA, 
                                                            LeadTriggerHelperB2b.LEAD_STATUS_VISITA, 
                                                            'Reo1142', 
                                                            '16664687-1');
            insert leadVisitDescartaEjecut;

            Event iEvent8 = getEventsByStatusAndEtapa('Visita', 
                                        leadVisitDescartaEjecut.Id, 
                                        EventTriggerHelperB2B.EVENT_ESTADO_VISITAEXITOSADESCARTADOEJECUTIVO, 
                                        EventTriggerHelperB2B.RT_EVENT_EMPRESA);
            insert iEvent8;

            // ---------------------------------------------------------------------------------------------------------
            // ------------   Lead LEAD_STATUS_VISITA +++ EVENT_ESTADO_VISITANEGADA   ----------------
            // ---------------------------------------------------------------------------------------------------------
            Lead leadVisitNegada = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadVisitNegada = getleadByStatusAndEtapa(leadVisitNegada, 
                                                    LeadTriggerHelperB2b.LEAD_ETAPA_CONTACTADOVISITA, 
                                                    LeadTriggerHelperB2b.LEAD_STATUS_VISITA, 
                                                    'Reo1142', 
                                                    '23768723-k');
            insert leadVisitNegada;

            Event iEvent9 = getEventsByStatusAndEtapa( 'Visita', leadVisitNegada.Id, EventTriggerHelperB2B.EVENT_ESTADO_VISITANEGADA, EventTriggerHelperB2B.RT_EVENT_EMPRESA);
            insert iEvent9;

        }
    }

    @isTest 
    private static void eventUpdateTest(){
        User iUserEjecutivoVenta = [SELECT Id, RUT__c, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];

        System.runAs(iUserEjecutivoVenta){
            Lead leadB2b = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadB2b     = getleadByStatusAndEtapa(leadB2b, 
                                            LeadTriggerHelperB2b.LEAD_ETAPA_CONTACTADOVISITA, 
                                            LeadTriggerHelperB2b.LEAD_STATUS_VISITA, 
                                            'Reo1142', 
                                            '16664687-1');
            insert leadB2b;

            Event iEvent = getEventsByStatusAndEtapa('Llamada', 
                                                    leadB2b.Id, 
                                                    EventTriggerHelperB2B.EVENT_ESTADO_CONTACTADOINTERESADO, 
                                                    EventTriggerHelperB2B.RT_EVENT_EMPRESA);
            insert iEvent;
            System.assertEquals('Contactado Interesado', iEvent.Estado__c);

            iEvent.Tipo_de_contacto__c = 'Visita';
            iEvent.Estado__c = EventTriggerHelperB2B.EVENT_ESTADO_VISITAEXITOSA;
            update iEvent;
            System.assertEquals('Visita Exitosa', iEvent.Estado__c);

            leadB2b = [SELECT Id, Status, Etapa_Prospecto__c FROM Lead WHERE Id =: leadB2b.Id];
            System.assertEquals(LeadTriggerHelperB2b.LEAD_ETAPA_PENDIENTEINFORMEVISITA, leadB2b.Etapa_Prospecto__c);

            // ---- Event EVENT_ESTADO_VISITAEXITOSADESCARTADOCLIENTE ------ Lead LEAD_ETAPA_DESCARTADOVISITA -------
            iEvent = [SELECT Id, Estado__c FROM Event WHERE Id = : iEvent.Id LIMIT 1];
            iEvent.Estado__c = EventTriggerHelperB2B.EVENT_ESTADO_VISITAEXITOSADESCARTADOCLIENTE;
            update iEvent;

            leadB2b = [SELECT Id, Status, Etapa_Prospecto__c FROM Lead WHERE Id =: leadB2b.Id];
            System.assertEquals(LeadTriggerHelperB2b.LEAD_ETAPA_DESCARTADOVISITA, leadB2b.Etapa_Prospecto__c);

            // este no entra
            // iEvent.Tipo_de_contacto__c = 'Visita';
            // iEvent.Estado__c = EventTriggerHelperB2B.EVENT_ESTADO_VISITAEXITOSADESCARTADOEJECUTIVO;
            // update iEvent;

        }
    }
    
    @isTest 
    private static void eventUpdateVisitaExitosaleadSinMail_Test(){
        User iUserEjecutivoVenta = [SELECT Id, RUT__c, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];

        System.runAs(iUserEjecutivoVenta){
            Lead leadB2b = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadB2b     = getleadByStatusAndEtapa(leadB2b, 
                                            LeadTriggerHelperB2b.LEAD_ETAPA_CONTACTADOVISITA, 
                                            LeadTriggerHelperB2b.LEAD_STATUS_VISITA, 
                                            'Reo1142', 
                                            '24592562-k');
            leadB2b.Email = null;
            insert leadB2b;

            Event iEvent = getEventsByStatusAndEtapa('Llamada', 
                                                    leadB2b.Id, 
                                                    EventTriggerHelperB2B.EVENT_ESTADO_CONTACTADOINTERESADO, 
                                                    EventTriggerHelperB2B.RT_EVENT_EMPRESA);
            insert iEvent;
            System.assertEquals('Contactado Interesado', iEvent.Estado__c);

            try {
                iEvent.Tipo_de_contacto__c = 'Visita';
                iEvent.Estado__c = EventTriggerHelperB2B.EVENT_ESTADO_VISITAEXITOSA;
                update iEvent;
            } catch (Exception ex) {
                System.assertEquals(ex.getMessage().contains(EventTriggerHelperB2B.EVENT_ERROR1), true);
            }
        }
    }
 
    
    @isTest 
    private static void eventUpdate2Test(){
        User iUserEjecutivoVenta = [SELECT Id, RUT__c, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];

        System.runAs(iUserEjecutivoVenta){
            Lead leadVisitDescartaEjecut = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadVisitDescartaEjecut = getleadByStatusAndEtapa(leadVisitDescartaEjecut, 
                                                        LeadTriggerHelperB2b.LEAD_ETAPA_CONTACTADOVISITA, 
                                                        LeadTriggerHelperB2b.LEAD_STATUS_VISITA, 
                                                        'Reo1142', 
                                                        '16664687-1');
            insert leadVisitDescartaEjecut;

            Event iEvent = getEventsByStatusAndEtapa('Llamada', 
                                                    leadVisitDescartaEjecut.Id, 
                                                    EventTriggerHelperB2B.EVENT_ESTADO_CONTACTADOINTERESADO, 
                                                    EventTriggerHelperB2B.RT_EVENT_EMPRESA);
            insert iEvent;

            iEvent.Tipo_de_contacto__c = 'Visita';
            iEvent.Estado__c = EventTriggerHelperB2B.EVENT_ESTADO_VISITAEXITOSADESCARTADOEJECUTIVO;
            update iEvent;

            leadVisitDescartaEjecut = [SELECT Id, Status, Etapa_Prospecto__c FROM Lead WHERE Id =: leadVisitDescartaEjecut.Id];
            System.assertEquals(LeadTriggerHelperB2b.LEAD_ETAPA_DESCARTADOVISITA, leadVisitDescartaEjecut.Etapa_Prospecto__c);
        }
    }

    
    @isTest 
    private static void eventUpdateVisitaNegada_Test(){
        User iUserEjecutivoVenta = [SELECT Id, RUT__c, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];

        System.runAs(iUserEjecutivoVenta){
            Lead leadVisitNegada = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadVisitNegada = getleadByStatusAndEtapa(leadVisitNegada, LeadTriggerHelperB2b.LEAD_ETAPA_CONTACTADOVISITA, LeadTriggerHelperB2b.LEAD_STATUS_VISITA, 'Reo1142', '23768723-k');
            insert leadVisitNegada;

            Event iEvent = getEventsByStatusAndEtapa('Llamada', 
                                                    leadVisitNegada.Id, 
                                                    EventTriggerHelperB2B.EVENT_ESTADO_CONTACTADOINTERESADO, 
                                                    EventTriggerHelperB2B.RT_EVENT_EMPRESA);
            insert iEvent;

            iEvent.Tipo_de_contacto__c = 'Visita';
            iEvent.Estado__c = EventTriggerHelperB2B.EVENT_ESTADO_VISITANEGADA;
            update iEvent;

            leadVisitNegada = [SELECT Id, Status, Etapa_Prospecto__c FROM Lead WHERE Id =: leadVisitNegada.Id];
            System.assertEquals(LeadTriggerHelperB2b.LEAD_ETAPA_DESCARTADOVISITA, leadVisitNegada.Etapa_Prospecto__c);
        }
    }

    
    private static Lead getleadByStatusAndEtapa(Lead ilead, String etapalead, String statuslead, String lastName, String numeroRut){
        ilead.FirstName                     = 'NameleadOne'; 
        ilead.LastName                      = lastName;
        ilead.RUTEmpresa__c                 = numeroRut;
        ilead.Etapa_Prospecto__c            = etapalead;        	 
        ilead.Status                        = statuslead;
        return ilead;
    }
    
    private static Event getEventsByStatusAndEtapa(String tipoContacto, String iWhoId, String estado, String rtDeveloperName){
        Event iEvent = new Event();
        iEvent.Subject             =   'Asunto calling'; 
        iEvent.Tipo_de_contacto__c =   tipoContacto;
        iEvent.Type                =   'Meeting';
        iEvent.WhoId               =   iWhoId;          
        iEvent.StartDateTime       =   System.today();
        iEvent.EndDateTime         =   System.today();  
        iEvent.Estado__c           =   estado;
        iEvent.RecordTypeId        =   EventTriggerHelperB2B.getRecordTypeId(rtDeveloperName);    
        iEvent.enviar_agenda_via_correo_sales__c = false;
        return iEvent;
    }


}