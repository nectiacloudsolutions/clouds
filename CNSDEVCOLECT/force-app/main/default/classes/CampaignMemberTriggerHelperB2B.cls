/**
 * @description       : Helper CP Member B2B
 * @author            : mbeltran@everis.com
 * @group             : 
 * @last modified on  : 11-11-2020
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-26-2020   mbeltran@everis.com   Initial Version
**/
public without sharing class CampaignMemberTriggerHelperB2B {
    public static final String RECORDTYPE_CAMPAIGNMEMBER_EMPRESA = 'Miembro_campana_sales_bbee';
    public static final String CAMPAIGNMEMBER = 'CampaignMember';
    public static final String CAMPAIGNMEMBER_STATUS_SINGESTION = 'Sin Gestión';
    public static final String CAMPAIGNMEMBER_STATUS_GESTIONADO = 'Gestionado';
    public static final String CAMPAIGNMEMBER_STATUS_VISITA = 'Visita';
    public static final String CAMPAIGNMEMBER_STATUS_COMITE = 'Comité';
    public static final String CAMPAIGNMEMBER_STATUS_CONVERTIDO = 'Convertido';
    public static final String CAMPAIGNMEMBER_STATUS_NOCONVERTIDO = 'No Convertido';
    public static final String CAMPAIGNMEMBER_TYPE_LEAD = 'Lead';
    public static final String CAMPAIGNMEMBER_TYPE_CONTACT = 'Contact';
    public static final String CAMPAIGNMEMBER_ERROR_RT = 'El recordtype no corresponde a Banca Empresas';
	public static final String CAMPAIGNMEMBER_ERROR_RUTEJEC = 'Rut {0} de ejecutivo no existe o no tiene licencia';
    public static final String CAMPAIGNMEMBER_ERROR_RUTCLI = 'El Rut {0} de Empresa invalido o no contiene información';
    public static final String CAMPAIGNMEMBER_ERROR_CONTACT = 'El Rut {0} de Empresa no existe como cliente o no posee un contacto principal';
    public static final String CAMPAIGNMEMBER_ERROR_RUTCLIEMPTY = 'Debe ingresar el Rut para asociar el miembro de campaña';

    /**
    * @description 
    * @author mbeltran@everis.com | 09-01-2020 
    * @param List<CampaignMember> newCampaignMemberList 
    **/
    public static void assignCampaignMemberByRutaccount(List<CampaignMember> newCampaignMemberList) {
        Set<Id> IdLeads = new Set<Id>();
        Set<String> RutEjecutivos = new Set<String>();
        Set<String> RutClientes = new Set<String>();
        //String IdRtEmpresa = CampaignMemberTriggerHelperB2B.getIdRecordTypeCampaignMemberEmpresa();

        String IdRtEmpresa = CampaignMemberTriggerHelperB2B.getRecordTypeId(RECORDTYPE_CAMPAIGNMEMBER_EMPRESA);

        for(CampaignMember CargaCampaignMember : newCampaignMemberList){
            if(CargaCampaignMember.RecordTypeId == IdRtEmpresa && String.isNotBlank(CargaCampaignMember.RUT_Ejecutivo_sales__c)){
                RutEjecutivos.add(UtilitiesSalesB2B.formatRutEjecutivo(CargaCampaignMember.RUT_Ejecutivo_sales__c));
            }

            if(CargaCampaignMember.RecordTypeId == IdRtEmpresa && CargaCampaignMember.LeadId == null && CargaCampaignMember.ContactId == null && String.isNotBlank(CargaCampaignMember.RUT_sales__c)){
                RutClientes.add(CargaCampaignMember.RUT_sales__c);
            }

            if(CargaCampaignMember.RecordTypeId == IdRtEmpresa && CargaCampaignMember.LeadId != null){
                IdLeads.add(CargaCampaignMember.LeadId);
            }
        }

        Map<String,Id> Map_Ejecutivos = RutEjecutivos.isEmpty() ? new Map<String,Id>() : LeadTriggerHelperB2b.getIdsExecutive(RutEjecutivos);
        Map<String,Contact> Map_Contacts = RutClientes.isEmpty() ? new Map<String,Contact>() : AccountTriggerHelperB2B.getPrincipalContactfromAccountsbyRUTAccount(RutClientes);
        Map<Id,Lead> Map_Leads = IdLeads.isEmpty() ? new Map<Id,Lead>() : LeadTriggerHelperB2b.getLeadsbyId(IdLeads);

        for (CampaignMember CPM: newCampaignMemberList){
            String strRutEjecutivo = (CPM.RUT_Ejecutivo_sales__c != '' && CPM.RUT_Ejecutivo_sales__c != null)
            ? UtilitiesSalesB2B.formatRutEjecutivo(CPM.RUT_Ejecutivo_sales__c)
            : '';

            if(CPM.RecordTypeId == IdRtEmpresa && CPM.LeadId != null){
                //CPM.Propietario_Miembro_de_Campana__c = CPM.LeadOrContactOwnerId;
                if (Map_Leads.containsKey(CPM.LeadId)) {
                    CPM.Propietario_Miembro_de_Campana__c = Map_Leads.get(CPM.LeadId).Ownerid;
                }
                CPM.Status = CAMPAIGNMEMBER_STATUS_SINGESTION;
            }
            else if(CPM.RecordTypeId == IdRtEmpresa && CPM.ContactId == null){
                CPM.Status = CAMPAIGNMEMBER_STATUS_SINGESTION;

                if(Map_Ejecutivos.containsKey(strRutEjecutivo) && CPM.RUT_Ejecutivo_sales__c != null && CPM.RUT_Ejecutivo_sales__c != ''){ 
                    CPM.Propietario_Miembro_de_Campana__c = Map_Ejecutivos.get(strRutEjecutivo);
                }
                else {
                    CPM.addError(String.format(CAMPAIGNMEMBER_ERROR_RUTEJEC, new String[]{CPM.RUT_Ejecutivo_sales__c}));
                }

                if(CPM.RUT_sales__c != null && CPM.RUT_sales__c != ''){
                    if(UtilitiesSalesB2B.validarRunRut(CPM.RUT_sales__c)){
                        if (Map_Contacts.containsKey(CPM.RUT_sales__c)) {
                            //system.debug('Obtiene COntact id:' + CPM.RUT_sales__c);
                            CPM.ContactId = Map_Contacts.get(CPM.RUT_sales__c).Id;
                        }
                        else{
                            //system.debug('No tiene COntact:' + CPM.RUT_sales__c);
                            CPM.addError(String.format(CAMPAIGNMEMBER_ERROR_CONTACT, new String[]{CPM.RUT_sales__c}));
                        }
                    }
                    else{
                        CPM.addError(String.format(CAMPAIGNMEMBER_ERROR_RUTCLI, new String[]{CPM.RUT_sales__c}));
                    }
                }
                else{
                    CPM.addError(CAMPAIGNMEMBER_ERROR_RUTCLIEMPTY);
                }
            }
        }
    }
    /**
      * @description       This method return String with the RecordtypeId asociated to CampaignMember BBEE
      * @param1            NA 
      * @return            String Id RecordtypeId
    */
    // public static String getIdRecordTypeCampaignMemberEmpresa(){
    //     RecordType RT = [SELECT Id 
    //                     FROM RecordType 
    //                     WHERE Name =:CampaignMemberTriggerHelperB2B.RECORDTYPE_CAMPAIGNMEMBER_EMPRESA
    //                     AND SobjectType =:CampaignMemberTriggerHelperB2B.CAMPAIGNMEMBER 
    //                     LIMIT 1];
    //     String RTid = RT.id;
    //     return RTid;
    // }

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
								            	  WHERE SobjectType =: Schema.CampaignMember.sObjectType.getDescribe().getName() 
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

    /**
    * @description 
    * @author mbeltran@everis.com | 09-07-2020 
    * @param List<IdLeads> Leads 
    * @return Map<Id, CampaignMember> 
    **/
    public static Map<Id,CampaignMember> getCampaignMembersByLeads(List<Lead> Leads){
        Map<Id,CampaignMember> maps = new Map<Id,CampaignMember>();
        
        for(CampaignMember CPM : [SELECT Id,LeadId FROM CampaignMember WHERE Campaign.Status in(:CampaignTriggerHelperB2B.CAMPAIGN_STATUS_INGRESADA, :CampaignTriggerHelperB2B.CAMPAIGN_STATUS_ACTIVADA) and LeadId IN :Leads]){
            maps.put(CPM.LeadId, CPM);
        }
        return maps;
    }

    public static void UpdateLeadsFromCampaignMembersByCampaignClose(Set<Id> IdCampanas){
        List<Lead> LeadsUp = new List<Lead>();
        //System.debug('UpdateLeadsFromCampaignMembersByCampaignClose');
        
        for(Lead l : [SELECT Id, 
                        Status 
                        FROM Lead 
                        WHERE Status IN (:LeadTriggerHelperB2b.LEAD_STATUS_SIN_GESTION, :LeadTriggerHelperB2b.LEAD_STATUS_GESTIONADO) 
                        AND Id IN (SELECT LeadId  
                                    FROM CampaignMember 
                                    WHERE LeadId != null 
                                    AND CampaignId IN: IdCampanas)]){
            //System.debug('LeadId:' + l.Id + ',Status:' + l.Status);
            LeadsUp.add(new Lead(Id= l.Id, status= LeadTriggerHelperB2b.LEAD_STATUS_NO_INTERESADO, Etapa_Prospecto__c = LeadTriggerHelperB2b.LEAD_ETAPA_CAMPANAFINALIZADA ));
        }
        update LeadsUp;
    }
}