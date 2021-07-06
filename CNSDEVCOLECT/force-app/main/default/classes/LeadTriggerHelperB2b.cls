/*********************************************************************************************************
@Author       sortiztr@everis.com
@name         LeadTriggerHelperB2b
@CreateDate   29/07/2020
@Description  Helper of the Lead object B2b
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
29/07/2020                    sortiztr@everis.com           Initial Version
**********************************************************************************************************/
public without sharing class LeadTriggerHelperB2b {
    public static final String LEAD = 'Lead';
    
    public static final String LEAD_STATUS_EVALUACION = 'Evaluación Prospecto';
    public static final String LEAD_STATUS_SIN_GESTION = 'Sin Gestión';
    public static final String LEAD_STATUS_NO_INTERESADO = 'No_Interesado';
    public static final String LEAD_STATUS_CREADO = 'No Gestionado';
    public static final String LEAD_STATUS_GESTIONADO = 'Gestionado';
    public static final String LEAD_STATUS_VISITA = 'Visita';
    public static final String LEAD_STATUS_COMITE = 'Comité';
    public static final String LEAD_STATUS_CONVERTIDO = 'Convertido';

    public static final String LEAD_ETAPA_SIN_GESTION = 'Sin Gestión';
    public static final String LEAD_ETAPA_DESCARTADOGESTIONADO = 'Descartado Gestionado';
    public static final String LEAD_ETAPA_CONTACTADO = 'Contactado';
    public static final String LEAD_ETAPA_CONTACTADOVISITA = 'Contactado Visita';
    public static final String LEAD_ETAPA_CURSADO = 'Cursado';
    public static final String LEAD_ETAPA_GESTIONNOLOGRADA = 'Gestión No Lograda';
    public static final String LEAD_ETAPA_PENDIENTEINFORMEVISITA = 'Pendiente Informe Visita';
    public static final String LEAD_ETAPA_INFORME_VISITA_COMPLETO = 'Informe Visita Completo';
    public static final String LEAD_ETAPA_DESCARTADOVISITA = 'Descartado Visita';
    public static final String LEAD_ETAPA_CAMPANAFINALIZADA = 'Campaña Finalizada';
    public static final String LEAD_ETAPA_RECHAZADO = 'Rechazado';
    public static final String LEAD_ETAPA_COMITE_ANALISIS = 'Comité en Análisis';
    public static final String LEAD_ETAPA_COMITE_APROBADO = 'Comité Aprobado';
    public static final String LEAD_ETAPA_PENDIENTE_CURSE = 'Pendiente de Curse';
    public static final String LEAD_ETAPA_COMITE_RECHAZADO = 'Comité Rechazado';
    
    public static final String RT_LEAD_EMPRESA = 'sales_empresa';
    public static final String RECORDTYPE_LEAD_EMPRESA= 'sales empresa';
    public static final String LEAD_ERROR1 = 'Rut {0} de cliente existe como prospecto en Salesforce';
    public static final String LEAD_ERROR2 = 'El Ejecutivo Rut {0}, ha superado el limite maximo de prospectos para asignar, Rut prospecto {1}';    
	public static final String LEAD_ERROR3 = 'Rut {0} de ejecutivo no existe o no tiene licencia';
    public static final String LEAD_ERROR4 = 'Rut {0} de prospecto invalido';
    public static final String LEAD_ERROR5 = 'Rut {0} de prospecto ya existe como prospecto en salesforce en estado distinto a No gestionado';
    public static final String LEAD_ERROR6 = 'El estado del Prospecto a actualizar, de RUT {0} es distinto a "No Convertido"';
    public static final String LEAD_ERROR7 = 'RUT Empresa Filial {0} y el grupo no coinciden o RUT Empresa inválido';
    public static final String LEAD_ERROR8 = 'Cliente {0} no contiene Estado Nectia igual a Prospecto';

    public static final String LEAD_ERROR9 = 'Cliente existente {0}, posee estado "Cliente"';
    public static final String LEAD_ERROR10 = 'Cliente existente {0} es del tipo persona (PersonAccounts) y no empresa';

    public static final String LEADSOURCE_GESTION_COMERCIAL = 'Gestión Comercial';
    public static final String LEADSOURCE_GESTION_CAMPANA = 'Campaña';
    public static final String LEAD_SOURCE_PROPIO = 'Propio';

    public static final String LEAD_EMPRESA_FILIAL_BANCA    = '1'; 
    public static final String LEAD_EMPRESA_FILIAL_SEGURO   = '2';

    public static final String SANCION_COMITE_APROBADO = 'Aprobado';
    public static final String SANCION_COMITE_ANALISIS = 'Análisis';
    public static final String SANCION_COMITE_RECHAZADO = 'Rechazado';

    public static final String LEAD_ESTADO_CURSE_PENDIENTE = 'Pendiente';
    public static final String LEAD_ESTADO_CURSE_CURSADO = 'Cursado';

    public static final String TEAMMEMBER_ROLE_EJECUTIVOBANCAEMPRESA = 'Ejecutivo Comercial Banca Empresas';

    /**
      * @description       This method return Maps with the Rut and Id executive
      * @param1            Set<String> RUT del ejecutivo - Format field RUT 11111111-1
      * @return            Map<String,Id> List Account . List Leads
    */
    public static Map<String,Id> getIdsExecutive(Set<String> RutEjecutivos){
        Map<String,Id> maps = new Map<String,Id>();
        for(User u : [SELECT Id,Rut__C FROM User WHERE Rut__C IN :RutEjecutivos AND isActive = true]){
            maps.put(u.Rut__c, u.Id);
        }
        return maps;
    }

    /**
      * @description       This method return Maps with the IdLead and Lead Record
      * @param1            Set<String> RUT del prospecto - Format field RUT 11111111-1
      * @return            Map<String,Lead> Map > Rut Prospecto, Lead
    */
    public static Map<String,Lead> getLeads(Set<String> RutProspectos){
        Id recordTypeEmpresa = LeadTriggerHelperB2b.getRecordTypeId(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
        Map<String,Lead> maps = new Map<String,Lead>();
        for(Lead l : [SELECT Id, RUTEmpresa__c, Status,
                        numero_de_documento_sales__c
                        FROM Lead 
                        WHERE RUTEmpresa__c IN: RutProspectos
                        AND RecordTypeId =: recordTypeEmpresa
                    ]){
            maps.put(l.RUTEmpresa__c, l);
        }
        return maps;
    }

    /**
      * @description       This method return Maps with the User Id and Lead Count records
      * @param1            Set<String> RUT del Ejecutivo - Format field RUT 11111111-1, Recordtype id 
      * @return            Map<Id,Integer> Map : Id User, Integer
    */
    public static Map<Id,Integer> getLeadsAsingadosEjecutivo(Set<String> RutEjecutivos, String Str_RecordTypeId){
        Map<Id,Integer> maps = new Map<Id,Integer>();

        //for(AggregateResult l : [SELECT OwnerId, count(id) Total FROM lead WHERE Status = :LeadTriggerHelperB2b.LEAD_STATUS_SIN_GESTION AND RecordTypeId = :Str_RecordTypeId AND LeadSource in (:LeadTriggerHelperB2b.LEADSOURCE_GESTION_CAMPANA,:LeadTriggerHelperB2b.LEADSOURCE_GESTION_COMERCIAL)  group by OwnerId]){
        for(AggregateResult l : [SELECT OwnerId, count(id) Total FROM lead WHERE Status = :LeadTriggerHelperB2b.LEAD_STATUS_SIN_GESTION AND RecordTypeId = :Str_RecordTypeId AND LeadSource in (:LeadTriggerHelperB2b.LEADSOURCE_GESTION_COMERCIAL)  group by OwnerId]){
            System.debug('>>>RT:' + Str_RecordTypeId + ',ID:' + (Id)l.get('OwnerId') + ', Total:' + (Integer)l.get('Total'));
            maps.put((Id)l.get('OwnerId'), (Integer)l.get('Total'));
        }
        return maps;
    }

    /**
      * @description       This method return String with the RecordtypeId asociated to Lead BBEE
      * @param1            NA 
      * @return            String Id RecordtypeId
    */
    public static String getIdRecordTypeLeadEmpresa(){
        RecordType RT = [SELECT Id 
                        FROM RecordType 
                        WHERE Name =:LeadTriggerHelperB2b.RECORDTYPE_LEAD_EMPRESA 
                        AND SobjectType =:LeadTriggerHelperB2b.LEAD 
                        LIMIT 1];
        String RTid = RT.id;
        return RTid;
    }

    /**
      * @description       This method return Maps with the IdLead and Lead Record
      * @param1            Set<Id> Id del prospecto
      * @return            Map<Id,Lead> Map > Id Prospecto, Lead
    */
    public static Map<Id,Lead> getLeadsbyId(Set<Id> IdProspectos){
        Id recordTypeEmpresa = LeadTriggerHelperB2b.getRecordTypeId(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
        Map<Id,Lead> maps = new Map<Id,Lead>();
        for(Lead l : [SELECT Id,Company,LeadSource, RUTEmpresa__c, numero_de_documento_sales__c,region_sales__c,Direccion_Oficina__c,comuna_sales__c,NumberOfEmployees,
                            SBIF_Comercial__c,SBIF_Contingente__c,SBIF_Leasing__c,Venta_Anual__c,Deuda_Financiera__c,Ebitda__c,Utilidad__c,Patrimonio__c,Moneda__c,
                            Nivel_de_Importaciones__c,Exportaciones_anio_anterior__c,Actividad_Economica__c,Giro_de_la_empresa__c,Cuenta_Corriente__c,Creditos_comerciales__c,Factoring__c,Leasing__c,Comex__c,Boletas_Garantia__c,Cash_Management__c,Financiamiento_Inmobiliario__c,Visita_comercial_exitosa__c,Informe_Visita_Generado__c,Mesa_de_Dinero__c,Deuda_Achef__c,OwnerId,rut_ejecutivo_sales__c
                        FROM Lead 
                        WHERE Id IN: IdProspectos
                        AND RecordTypeId =: recordTypeEmpresa
                    ]){
            maps.put(l.Id, l);
        }
        return maps;
    }

    public static Boolean validaCargaRutEmpresaFilial(Lead iLead){
        Integer result = iLead.IdRutEmpresaFilial__c.length();
        String filial = iLead.IdRutEmpresaFilial__c.substring(result-1,result);
        String rutCompuesto = iLead.IdRutEmpresaFilial__c.substring(0,result-1);

        return iLead.EmpresaGrupoFilial__c == filial 
                && iLead.RUTEmpresa__c == rutCompuesto
                && UtilitiesSalesB2B.validarRunRut(rutCompuesto);
    }

    public static void assignRutEmpresaFilial (List<Lead> lstLead){
        String idRtEmpresa = LeadTriggerHelperB2b.getIdRecordTypeLeadEmpresa();
        for (Lead iLead : lstLead) {
            if(ilead.RecordTypeId == idRtEmpresa){
                if ( (iLead.RUTEmpresa__c == null || iLead.RUTEmpresa__c == '') 
                    || !UtilitiesSalesB2B.validarRunRut(ilead.RUTEmpresa__c) ) {
                    ilead.RUTEmpresa__c.addError(String.format(LEAD_ERROR4, new String[]{ ilead.RUTEmpresa__c}));
                } 
                
                if (!validaCargaRutEmpresaFilial(iLead)) {
                    ilead.IdRutEmpresaFilial__c.addError(String.format(LEAD_ERROR7, new String[]{ ilead.IdRutEmpresaFilial__c}));
                }
            }
        }
    }

    public static void populateRutEmpresaFilialByPropio(List<Lead> lstLead, Map<ID,Lead> oldMap){
        for (Lead iLead : lstLead) {
            if (oldMap!=null) {
                Lead leadOld = oldMap.get(iLead.Id);
                if (leadOld.LeadSource != iLead.LeadSource && iLead.LeadSource == LEAD_SOURCE_PROPIO ) {
                    ilead.IdRutEmpresaFilial__c = ilead.RUTEmpresa__c + iLead.EmpresaGrupoFilial__c;
                }
            } else if ( iLead.LeadSource == LEAD_SOURCE_PROPIO ) {
                ilead.IdRutEmpresaFilial__c = ilead.RUTEmpresa__c + iLead.EmpresaGrupoFilial__c;
            }
        }
    }

    /*
	 * @Description : INserta / Asigna cuotas de leads a Ejecutivos. Método que sustituye onBeforeInsert anterior en esta clase
	 */	
    public static void assignCuotasByEjecutivosInsert(List<Lead> leadList){
        Set<String> rutEjecutivos = new Set<String>();
        Set<String> rutProspectos = new Set<String>();

        String idRtEmpresa = LeadTriggerHelperB2b.getIdRecordTypeLeadEmpresa();

        for(Lead iCargaLeads : leadList){
            if(iCargaLeads.RecordTypeId == LeadTriggerHelperB2b.getRecordTypeId(RT_LEAD_EMPRESA)){
                if(String.isNotBlank(iCargaLeads.rut_ejecutivo_sales__c)){
                    rutEjecutivos.add(UtilitiesSalesB2B.formatRutEjecutivo(iCargaLeads.rut_ejecutivo_sales__c));
                }
                if(String.isNotBlank(iCargaLeads.RUTEmpresa__c)){
                    rutProspectos.add(iCargaLeads.RUTEmpresa__c);
                }
    
            }
        }

        Map<String,Id> mapEjecutivos = LeadTriggerHelperB2b.getIdsExecutive(rutEjecutivos);
        Map<String,Lead> mapLeadsExistentes = LeadTriggerHelperB2b.getLeads(rutProspectos);
        Map<Id,Integer > mapCuotaActualEjecutivos = LeadTriggerHelperB2b.getLeadsAsingadosEjecutivo(rutEjecutivos, idRtEmpresa);

        ////////////
        Map<String,Account> mapAccountsbyRUT = AccountTriggerHelperB2B.getAccountsbyRUT(rutProspectos);
        System.debug('deb:' + mapAccountsbyRUT);
        System.debug('deb:' + rutProspectos);
        
        ////////////

        Decimal cuotaMaxima = Consorcio_Org_B2B__c.getInstance(UserInfo.getUserId()).Cuota_Maxima_de_Leads__c; 
        Integer cuotaActual = 0;
        
        for (Lead ilead : leadList){
            if(ilead.RecordTypeId == LeadTriggerHelperB2b.getRecordTypeId(RT_LEAD_EMPRESA)){

                ////////////////////////////////
                if(mapAccountsbyRUT.containskey(ilead.RUTEmpresa__c)){
                    System.debug('deb1--:'+ mapAccountsbyRUT.get(ilead.RUTEmpresa__c).RecordTypeId);
                    System.debug('deb2--:'+ mapAccountsbyRUT.get(ilead.RUTEmpresa__c).RecordType.IsPersonType);
                    System.debug('deb3--:'+ mapAccountsbyRUT.get(ilead.RUTEmpresa__c).Estado_Cliente_Banca_Empresas__c);
                    
                    if(mapAccountsbyRUT.get(ilead.RUTEmpresa__c).RecordType.IsPersonType){
                        ilead.addError(String.format(LEAD_ERROR10, new String[]{ilead.RUTEmpresa__c}));
                    }
                    else if (mapAccountsbyRUT.get(ilead.RUTEmpresa__c).Estado_Cliente_Banca_Empresas__c == AccountTriggerHelperB2B.ACCOUNT_ESTADO_CLIENTE_BANCA_EMPRESAS){
                        ilead.addError(String.format(LEAD_ERROR9, new String[]{ilead.RUTEmpresa__c}));

                    }
                }
                ////////////////////////////////

                String strRutEjecutivo = (ilead.rut_ejecutivo_sales__c != '' && ilead.rut_ejecutivo_sales__c != null)
                                            ? UtilitiesSalesB2B.formatRutEjecutivo(ilead.rut_ejecutivo_sales__c)
                                            : '';

                                            
                if(UtilitiesSalesB2B.validarRunRut(ilead.RUTEmpresa__c)){
                    if(ilead.LeadSource == LEADSOURCE_GESTION_COMERCIAL || ilead.LeadSource == LEADSOURCE_GESTION_CAMPANA) {
                        if(mapLeadsExistentes.get(ilead.RUTEmpresa__c) != null){
                            ilead.addError(String.format(LEAD_ERROR1, new String[]{ilead.RUTEmpresa__c}));
                        } 
                        else{ // Prospecto no existe en salesforce
                            if(mapEjecutivos.containsKey(strRutEjecutivo) && ilead.rut_ejecutivo_sales__c != null && ilead.rut_ejecutivo_sales__c != '' ){ //existe ejecutivo como usuario salesforce
                                if(!mapCuotaActualEjecutivos.containsKey(mapEjecutivos.get(strRutEjecutivo))){ //Como es un count al Lead, es probable que no exista en MAP
                                    mapCuotaActualEjecutivos.put(mapEjecutivos.get(strRutEjecutivo),0);
                                }
                                cuotaActual = mapCuotaActualEjecutivos.get(mapEjecutivos.get(strRutEjecutivo));

                                if(cuotaActual >= cuotaMaxima && iLead.LeadSource == LEADSOURCE_GESTION_COMERCIAL){
                                    ilead.addError(String.format(LEAD_ERROR2, new String[]{ilead.rut_ejecutivo_sales__c, ilead.RUTEmpresa__c}));
                                } else{

                                    /////////////////
                                    if(iLead.LeadSource == LEADSOURCE_GESTION_COMERCIAL){
                                        mapCuotaActualEjecutivos.put(mapEjecutivos.get(strRutEjecutivo),cuotaActual+1);
                                    }
                                    
                                    ilead.Ownerid = mapEjecutivos.get(strRutEjecutivo); // Se asigna ejecutivo
                                    ilead.Fecha_creacion_reingreso__c = System.today(); //Se asigna fecha para proceso de cambio de etapa
                                }
                            } else{ //Rut de Ejecutivo no fue encontrado en Salesforce
                                ilead.addError(String.format(LEAD_ERROR3, new String[]{ilead.rut_ejecutivo_sales__c}));
                            }
                        }
                    } else {
                        if(!UtilitiesSalesB2B.validarRunRut(ilead.RUTEmpresa__c)){
                            ilead.RUTEmpresa__c.addError(String.format(LEAD_ERROR4, new String[]{ilead.RUTEmpresa__c}));
                        } else{
                            ilead.Fecha_creacion_reingreso__c = System.today(); //Se asigna fecha para proceso de cambio de etapa
                        }
                    }
                } else{ //Rut prospescto erróneo
                    ilead.addError(String.format(LEAD_ERROR4, new String[]{ ilead.RUTEmpresa__c}));
                }
            }
        }
    }

    /*
	 * @Description : Asigna cuotas de leads a Ejecutivos. Método que sustituye onBeforeUpdate anterior en esta clase
	 */	
    public static void assignCuotasByEjecutivos(List<Lead> leadList, Map<ID,Lead> oldMap){
        Set<String> rutEjecutivos = new Set<String>();
        //////////////////////
        Set<String> rutProspectos = new Set<String>();
        //////////////////////
        for(Lead iCargaLeads : leadList){
            if(String.isNotBlank(iCargaLeads.rut_ejecutivo_sales__c)){
                rutEjecutivos.add(UtilitiesSalesB2B.formatRutEjecutivo(iCargaLeads.rut_ejecutivo_sales__c));
            }
            /////////////////////////
            if(String.isNotBlank(iCargaLeads.RUTEmpresa__c)){
                rutProspectos.add(iCargaLeads.RUTEmpresa__c);
            }
            ////////////////////////
        }

		////////////
        Map<String,Account> mapAccountsbyRUT = AccountTriggerHelperB2B.getAccountsbyRUT(rutProspectos);
        ////////////

        String idRtEmpresa = LeadTriggerHelperB2b.getIdRecordTypeLeadEmpresa();
        Map<String,Id> mapEjecutivos = LeadTriggerHelperB2b.getIdsExecutive(rutEjecutivos);
        Map<Id,Integer > mapCuotaActualEjecutivos = LeadTriggerHelperB2b.getLeadsAsingadosEjecutivo(rutEjecutivos, idRtEmpresa);
        Decimal cuotaMaxima = Consorcio_Org_B2B__c.getInstance(UserInfo.getUserId()).Cuota_Maxima_de_Leads__c; // cambiar a CS con valor 10
        Integer cuotaActual = 0;
    
        for (Lead iLead : leadList){
            if(iLead.RecordTypeId == idRtEmpresa ){
                //&& (iLead.LeadSource == LEADSOURCE_GESTION_COMERCIAL || iLead.LeadSource == LEADSOURCE_GESTION_CAMPANA)

                ////////////////////////////////
                if(mapAccountsbyRUT.containskey(ilead.RUTEmpresa__c)){
                    if(mapAccountsbyRUT.get(ilead.RUTEmpresa__c).RecordType.IsPersonType){
                        ilead.addError(String.format(LEAD_ERROR10, new String[]{ilead.RUTEmpresa__c}));
                    }
                    else if (mapAccountsbyRUT.get(ilead.RUTEmpresa__c).Estado_Cliente_Banca_Empresas__c == AccountTriggerHelperB2B.ACCOUNT_ESTADO_CLIENTE_BANCA_EMPRESAS){
                        ilead.addError(String.format(LEAD_ERROR9, new String[]{ilead.RUTEmpresa__c}));
                    }
                }
                ////////////////////////////////
                
                Lead oldlead = oldMap.get(iLead.Id);

                if (iLead.Status != oldlead.Status 
                    && shouldOpenlead(oldlead)
                    && (iLead.Status == LEAD_STATUS_EVALUACION || iLead.Status == LEAD_STATUS_SIN_GESTION)
                ) {
                    String strRutEjecutivo = String.isNotBlank(ilead.rut_ejecutivo_sales__c)
                    ? UtilitiesSalesB2B.formatRutEjecutivo(ilead.rut_ejecutivo_sales__c)
                    : '';

                    if(mapEjecutivos.containsKey(strRutEjecutivo) && String.isNotBlank(ilead.rut_ejecutivo_sales__c)) { //existe ejecutivo como usuario salesforce
                        if(!mapCuotaActualEjecutivos.containsKey(mapEjecutivos.get(strRutEjecutivo))){ //Como es un count al Lead, es probable que no exista en MAP
                            mapCuotaActualEjecutivos.put(mapEjecutivos.get(strRutEjecutivo),0);
                        }
                                
                        cuotaActual = mapCuotaActualEjecutivos.get(mapEjecutivos.get(strRutEjecutivo));

                        if(cuotaActual >= cuotaMaxima && iLead.LeadSource == LEADSOURCE_GESTION_COMERCIAL){
                            system.debug(String.format(LEAD_ERROR2, new String[]{iLead.rut_ejecutivo_sales__c, ilead.RUTEmpresa__c}));
                            iLead.addError(String.format(LEAD_ERROR2, new String[]{iLead.rut_ejecutivo_sales__c, ilead.RUTEmpresa__c}));
                        } else{

                            /////////////////
                            if(iLead.LeadSource == LEADSOURCE_GESTION_COMERCIAL){
                                mapCuotaActualEjecutivos.put(mapEjecutivos.get(strRutEjecutivo),cuotaActual+1);
                            }
                            updatefieldsleadConvertedToSinGestion(iLead);
                            //iLead.Fecha_creacion_reingreso__c = Date.today();
                            //iLead.Status = LEAD_STATUS_SIN_GESTION;
                            iLead.Ownerid = mapEjecutivos.get(strRutEjecutivo); // Se asigna ejecutivo
                            //iLead.Fecha_ultima_gestion__c = Date.today();
                            //iLead.Fecha_Inicio_Sin_Gestion__c = Date.today();
                            //iLead.Fecha_Inicio_Gestion__c = null;
                            //iLead.Fecha_Inicio_Visita__c = null;
                            //iLead.Fecha_Inicio_Comite__c = null;
                            //iLead.Fecha_Inicio_Convertido__c = null;
                            //iLead.Fecha_Inicio_No_Convertido__c = null;                                    
                        }
                    } else{ //Rut de Ejecutivo no fue encontrado en Salesforce
                        iLead.addError(String.format(LEAD_ERROR3, new String[]{iLead.rut_ejecutivo_sales__c}));
                    }                               
                }
            }
        }
    }

    /**
    * @description: Actualiza campos de seguimiento al momento de cambiar una etapa del Lead 
    * @author mbeltran@everis.com | 08-26-2020 
    * @param List<Lead> leadList 
    * @param Map<ID Lead> oldLeadMap 
    **/
    public static void Updatetrackingfields(List<Lead> leadList, Map<ID,Lead> oldLeadMap){
        Map<Id,CampaignMember> Map_CampaignMemberList = CampaignMemberTriggerHelperB2B.getCampaignMembersByLeads(leadList);
        List<CampaignMember> CampaignMemberToUpdate = new  List<CampaignMember>();

        for (Lead l: leadList){
            if(oldLeadMap.get(l.Id).Status != l.Status){
                //Fecha_ultima_gestion__c
                switch on l.Status {
                    when 'Sin Gestión' {
                        l.Fecha_Inicio_Sin_Gestion__c = Date.today();
                        l.Fecha_ultima_gestion__c = Date.today();
                        if(oldLeadMap.get(l.Id).Status == LEAD_STATUS_EVALUACION){
                            l.Fecha_Aprobacion_Evaluacion__c = Date.today();

                        }
                    }	
                    when 'Gestionado' {		
                        l.Fecha_Inicio_Gestion__c = Date.today();
                        l.Fecha_ultima_gestion__c = Date.today();
                        if (Map_CampaignMemberList.containsKey(l.id)) {
                            CampaignMemberToUpdate.add(
                                new CampaignMember(
                                    id = Map_CampaignMemberList.get(l.id).id
                                    , Status = CampaignMemberTriggerHelperB2B.CAMPAIGNMEMBER_STATUS_GESTIONADO
                                )
                            );
                        }
                    }
                    when 'Visita' {
                        l.Fecha_Inicio_Visita__c = Date.today();
                        l.Fecha_ultima_gestion__c = Date.today();
                        if (Map_CampaignMemberList.containsKey(l.id)) {
                            CampaignMemberToUpdate.add(
                                new CampaignMember(
                                    id = Map_CampaignMemberList.get(l.id).id
                                    , Status = CampaignMemberTriggerHelperB2B.CAMPAIGNMEMBER_STATUS_VISITA
                                )
                            );
                        }
                    }
                    when 'Comité' {
                        l.Fecha_Inicio_Comite__c = Date.today();
                        l.Fecha_ultima_gestion__c = Date.today();
                        if (Map_CampaignMemberList.containsKey(l.id)) {
                            CampaignMemberToUpdate.add(
                                new CampaignMember(
                                    id = Map_CampaignMemberList.get(l.id).id
                                    , Status = CampaignMemberTriggerHelperB2B.CAMPAIGNMEMBER_STATUS_COMITE
                                )
                            );
                        }
                    }
                    when 'Convertido' {
                        l.Fecha_Inicio_Convertido__c = Date.today();
                        l.Fecha_ultima_gestion__c = Date.today();
                        if (Map_CampaignMemberList.containsKey(l.id)) {
                            CampaignMemberToUpdate.add(
                                new CampaignMember(
                                    id = Map_CampaignMemberList.get(l.id).id
                                    , Status = CampaignMemberTriggerHelperB2B.CAMPAIGNMEMBER_STATUS_CONVERTIDO
                                )
                            );
                        }
                    }
                    when 'No_Interesado' {
                        l.Fecha_Inicio_No_Convertido__c = Date.today();
                        l.Fecha_ultima_gestion__c = Date.today();

                        if(l.Comentario_Analista__c != '' && l.Comentario_Analista__c != null){
                            l.Fecha_Rechazo_Evaluacion__c = Date.today();
                        }    

                        if (Map_CampaignMemberList.containsKey(l.id) && l.Etapa_Prospecto__c  != LEAD_ETAPA_CAMPANAFINALIZADA) {
                            CampaignMemberToUpdate.add(
                                new CampaignMember(
                                    id = Map_CampaignMemberList.get(l.id).id
                                    , Status = CampaignMemberTriggerHelperB2B.CAMPAIGNMEMBER_STATUS_NOCONVERTIDO
                                )
                            );
                        }
                    }
                }
            }
        }

        update CampaignMemberToUpdate;
    }

    /**
    * @description: Actualiza campos de seguimiento al momento de cambiar una etapa del Lead en Insert 
    * @author mbeltran@everis.com | 08-26-2020 
    * @param List<Lead> leadList 
    **/
    public static void Insertrackingfields(List<Lead> leadList){
        //traer los CPM asociados al lead para luego actualizar de acuerdo al estado 

        for (Lead l: leadList){
            switch on l.Status {
                when 'Evaluación Prospecto' {
                    l.Fecha_Inicio_Evaluacion_Prospecto__c = Date.today();
                    l.Fecha_ultima_gestion__c = Date.today();
                }
                when 'Sin Gestión' {
                    l.Fecha_Inicio_Sin_Gestion__c = Date.today();
                    l.Fecha_ultima_gestion__c = Date.today();
                //update CP Member    
                }
            }
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
								            	  WHERE SobjectType =: Schema.Lead.sObjectType.getDescribe().getName() 
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

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Conversion lead, pasa relacionados al Account, actualiza el contacto principal y crea otros según datos complementarios encuentre.
    */
    public static void leadConvertedFields (List<Lead> newList, Map<Id, Lead> oldMap){
        Set<Id> convertedIds = new Set<Id>();
        Set<Id> setContactId = new Set<Id>();
        List<Account> accToUpdate = new List<Account>();
        List<Contact> contactToUpdate = new List<Contact>();
        List<Contact> contactToCreate = new List<Contact>();

        /////////////////////////////////
        List<AccountTeamMember> lstAccountMembers = new List<AccountTeamMember>();
        List<AccountTeamMember> lstAccountMembersToDelete = new List<AccountTeamMember>();
        Set<Id> convertedIdAccounts = new Set<Id>();

        for(Lead iLead : newList){

            //if(iLead.isConverted == true && iLead.isConverted != oldMap.get(iLead.Id).isConverted){
            //if(iLead.isConverted == true && iLead.Status != oldMap.get(iLead.Id).Status && ilead.Status == LeadTriggerHelperB2b.LEAD_STATUS_CONVERTIDO){
            //if(iLead.isConverted == true && ilead.Status == LeadTriggerHelperB2b.LEAD_STATUS_CONVERTIDO){
            if((iLead.isConverted == true && iLead.isConverted != oldMap.get(iLead.Id).isConverted && ilead.Status == LeadTriggerHelperB2b.LEAD_STATUS_CONVERTIDO) || (iLead.isConverted == true && iLead.Status != oldMap.get(iLead.Id).Status && ilead.Status == LeadTriggerHelperB2b.LEAD_STATUS_CONVERTIDO)){
                if(iLead.convertedAccountId != null){
					convertedIdAccounts.add(iLead.convertedAccountId);
                }
            }
        }
        Map<Id, Account> mpConvertedAccount = convertedIdAccounts.isEmpty() ? new Map<Id, Account>() : new Map<Id, Account>([SELECT Id,Rut__c, RecordTypeId, OwnerId, Calle_Nectia__c, Region_Nectia__c, Comuna_Nectia__c  FROM Account WHERE id IN:convertedIdAccounts]);
//        Map<Id, AccountTeamMember> mpAccountTeams = convertedIdAccounts.isEmpty() ? new Map<Id, AccountTeamMember>() : new Map<Id, AccountTeamMember>([SELECT Id, AccountId, AccountAccessLevel,UserId, TeamMemberRole from AccountTeamMember where AccountId IN:convertedIdAccounts and TeamMemberRole = :LeadTriggerHelperB2b.TEAMMEMBER_ROLE_EJECUTIVOBANCAEMPRESA]);
//        List<AccountTeamMember> lstAccountTeams = convertedIdAccounts.isEmpty() ? new List<AccountTeamMember>() : [SELECT AccountId, Id, AccountAccessLevel,UserId, TeamMemberRole from AccountTeamMember where AccountId IN:convertedIdAccounts and TeamMemberRole = :TEAMMEMBER_ROLE_EJECUTIVOBANCAEMPRESA];

        Map<Id, AccountTeamMember> mpAccountTeams = new Map<Id, AccountTeamMember>();

        //validar si convertedIdAccounts isEmpty
        for(AccountTeamMember ACMT : [SELECT Id, AccountId, AccountAccessLevel,UserId, TeamMemberRole from AccountTeamMember where AccountId IN:convertedIdAccounts and TeamMemberRole = :TEAMMEMBER_ROLE_EJECUTIVOBANCAEMPRESA]){
            //system.debug(ACMT.accountid);
            mpAccountTeams.put(ACMT.AccountId, ACMT);
        }

        ////////////////////////////////


        for(Lead iLead : newList){
             System.debug('ilead:' + ilead);   
             System.debug('ileadold:' + oldMap.get(iLead.Id));  

             System.debug('validaciones1:' + iLead.isConverted + ', oldleadIsconverted:' + oldMap.get(iLead.Id).isConverted + ', status:' + ilead.Status);  
             System.debug('validaciones2:' + iLead.isConverted + ', oldleadStatus:' + oldMap.get(iLead.Id).Status + ', status:' + ilead.Status + ', varstaus:' + LeadTriggerHelperB2b.LEAD_STATUS_CONVERTIDO);  

             //if(iLead.isConverted == true && iLead.isConverted != oldMap.get(iLead.Id).isConverted){

            //if(iLead.isConverted == true && ilead.Status == LeadTriggerHelperB2b.LEAD_STATUS_CONVERTIDO){

            //if(iLead.isConverted == true && iLead.Status != oldMap.get(iLead.Id).Status && ilead.Status == LeadTriggerHelperB2b.LEAD_STATUS_CONVERTIDO){
            if((iLead.isConverted == true && iLead.isConverted != oldMap.get(iLead.Id).isConverted && ilead.Status == LeadTriggerHelperB2b.LEAD_STATUS_CONVERTIDO) || (iLead.isConverted == true && iLead.Status != oldMap.get(iLead.Id).Status && ilead.Status == LeadTriggerHelperB2b.LEAD_STATUS_CONVERTIDO)){
                if(iLead.convertedAccountId != null){
                    System.debug('ingresa');  
                    //////////////////
                    if(mpConvertedAccount.containsKey(iLead.convertedAccountId)){
                        ///Existe Acc

                        if(AccountTriggerHelperB2B.getRecordTypeId(AccountTriggerHelperB2B.RT_ACCOUNT_EMPRESA_BANCO) == mpConvertedAccount.get(iLead.convertedAccountId).RecordTypeId){
                            //Es RT Banca Empresa
                            System.debug('ingresa2');  
                            accToUpdate.add(updateAccountCreated(iLead, true, mpConvertedAccount.get(iLead.convertedAccountId)));
                            System.debug('ingresa3');  

                        }else{
                            //No Es RT Banca Empresa y debe generar el account teams

                            if(mpAccountTeams.containskey(iLead.convertedAccountId)){
                                //lstAccountMembersToDelete.add(mpAccountTeams.get(iLead.convertedAccountId));  
                                lstAccountMembersToDelete.add(new AccountTeamMember(id= mpAccountTeams.get(iLead.convertedAccountId).Id ));
                            }
                            //lstAccountMembersToDelete


                            lstAccountMembers.add(LeadTriggerHelperB2b.CreateAccountTeamMember(iLead.convertedAccountId,iLead.OwnerId));
                            accToUpdate.add(updateAccountCreated(iLead, false, mpConvertedAccount.get(iLead.convertedAccountId)));
                        }
                    }
                    /*
                    }else{ 
                        //No existe Acc
                        System.debug('ingresa4:' + accToUpdate);  
                        accToUpdate.add(updateAccountCreated(iLead, true, null));
                        System.debug('ingresa5:' + accToUpdate);  
                    }
                    */
                    ////////////////
					//accToUpdate.add(updateAccountCreated(iLead));
                }
                if(iLead.convertedContactId != null){
                    setContactId.add(iLead.convertedContactId);
                }
                convertedIds.add(iLead.Id);
            }
        }
        if(convertedIds.size() > 0){
            Map<Id, Contact> mapContacts = new Map<Id, Contact>(
                [SELECT Id, Name, Primer_Apellido_Nectia__c, 
                    RUT_Nectia__c, Cargo__c, Phone, Email, 
                    Contacto_Principal__c, Vigencia_del_cliente__c 
                FROM Contact 
                WHERE Id IN: setContactId]
            );

            List<Dato_Complementarios__c> lstDatosComplementarios = [SELECT Id, Name, Apellido__c, 
                                                                        Contacto_Principal__c, 
                                                                        Cargo__c, Telefono__c, 
                                                                        RecordTypeId, Email__c, Rut__c, 
                                                                        Id_Prospecto__r.convertedAccountId, 
                                                                        Id_Prospecto__r.convertedContactId
                                                                    FROM Dato_Complementarios__c
                                                                    WHERE Id_Prospecto__c IN: convertedIds];

            // --- Crear cuentas desde Datos_Complementarios tipo Contacto que no son Contacto_Principal__c. Relaciona resto de Datos_Complementarios al Account.
            Id iDC_RTYPE_CONTACTO = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CONTACTO_DEVELOPERNAME);
            for (Dato_Complementarios__c iDatos : lstDatosComplementarios) {
                if (iDatos.RecordTypeId == iDC_RTYPE_CONTACTO) {
                    if (iDatos.Contacto_Principal__c) {
                        if (mapContacts.containsKey(iDatos.Id_Prospecto__r.convertedContactId)) {
                            Contact iCtc = mapContacts.get(iDatos.Id_Prospecto__r.convertedContactId);
                            contactToUpdate.add(
                                new Contact(
                                    Id                          =   iCtc.Id,
                                    FirstName                   =   iDatos.Name,
                                    LastName                    =   iDatos.Apellido__c,
                                    Primer_Apellido_Nectia__c   =   iDatos.Apellido__c,
                                    Contacto_Principal__c       =   iDatos.Contacto_Principal__c,
                                    Phone                       =   iDatos.Telefono__c,
                                    Email                       =   iDatos.Email__c,
                                    RUT_Nectia__c               =   iDatos.Rut__c,
                                    cargo__c                    =   iDatos.Cargo__c
                                )
                            );
                        }
                    } else {
                        contactToCreate.add(
                            new Contact(
                                FirstName                   =   iDatos.Name,
                                LastName                    =   iDatos.Apellido__c,
                                Primer_Apellido_Nectia__c   =   iDatos.Apellido__c,
                                Contacto_Principal__c       =   iDatos.Contacto_Principal__c,
                                Phone                       =   iDatos.Telefono__c,
                                Email                       =   iDatos.Email__c,
                                RUT_Nectia__c               =   iDatos.Rut__c,
                                cargo__c                    =   iDatos.Cargo__c,
                                AccountId                   =   iDatos.Id_Prospecto__r.convertedAccountId
                            )        
                        );
                    }
                } else {
                    iDatos.Account__c = iDatos.Id_Prospecto__r.convertedAccountId;  
                }
            }

            // --- Assiganr informe de visita 
            List<Informe_de_Visita__c> lstInfo = [SELECT Id, Id_Prospecto__r.convertedAccountId
                                                    FROM Informe_de_Visita__c
                                                    WHERE Id_Prospecto__c IN: convertedIds];

            for (Informe_de_Visita__c info : lstInfo) {
                info.Account__c = info.Id_Prospecto__r.convertedAccountId;  
            }

            // ---- Assiganr Líneas Bancarias
            List<Linea_Bancaria__c> lstBancaria = [SELECT Id, Id_Prospecto__r.convertedAccountId
                                                    FROM Linea_Bancaria__c
                                                    WHERE Id_Prospecto__c IN: convertedIds];

            for (Linea_Bancaria__c ibancaria : lstBancaria) {
                ibancaria.Account__c = ibancaria.Id_Prospecto__r.convertedAccountId;  
            }

            update lstInfo;
            update lstBancaria;
            update lstDatosComplementarios;
        }
        System.debug('d_accToUpdate:' + accToUpdate);  
        
        update accToUpdate;
        update contactToUpdate;

        if (!contactToCreate.isEmpty()) {
            insert contactToCreate;
        }

        if (!lstAccountMembers.isEmpty()) {
            insert lstAccountMembers;
            if(!lstAccountMembersToDelete.isEmpty()){
                delete lstAccountMembersToDelete;
            }
        }
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Create Account from lead converted.
    */
    public static Account updateAccountCreated (Lead iLead, Boolean IsBancaEmpresas, Account oldAccount){  //IsChangeRT
        Account Acc = new Account();
        Acc.Id                                  =   iLead.convertedAccountId;
        Acc.AccountSource                       =   iLead.LeadSource;
//        Acc.Rut_Ejecutivo_Banco__c              =   (ilead.rut_ejecutivo_sales__c != null && ilead.rut_ejecutivo_sales__c != '') ? ilead.rut_ejecutivo_sales__c.trim() : '';
        Acc.NumberOfEmployees 				    = 	ilead.NumberOfEmployees;
        Acc.SBIF_Comercial__c 				    = 	ilead.SBIF_Comercial__c;
        Acc.SBIF_Contingente__c 			    = 	ilead.SBIF_Contingente__c;
        Acc.SBIF_Leasing__c 				    = 	ilead.SBIF_Leasing__c;
        Acc.Deuda_Achef__c 					    = 	ilead.Deuda_Achef__c;
        Acc.Venta_Anual__c 					    = 	ilead.Venta_Anual__c;
        Acc.Deuda_Financiera__c 			    = 	ilead.Deuda_Financiera__c;
        Acc.Ebitda__c 						    = 	ilead.Ebitda__c;
        Acc.Utilidad__c 					    = 	ilead.Utilidad__c;
        Acc.Patrimonio__c 					    = 	ilead.Patrimonio__c;
        Acc.Moneda__c 						    = 	ilead.Moneda__c;
        Acc.Nivel_de_Importaciones__c 		    = 	ilead.Nivel_de_Importaciones__c;
        Acc.Exportaciones_anio_anterior__c 	    = 	ilead.Exportaciones_anio_anterior__c;
        Acc.Actividad_Economica__c 			    = 	ilead.Actividad_Economica__c;
        Acc.Giro_de_la_empresa__c 			    = 	ilead.Giro_de_la_empresa__c;
        Acc.Cuenta_Corriente__c 			    = 	ilead.Cuenta_Corriente__c;
        Acc.Creditos_comerciales__c 		    = 	ilead.Creditos_comerciales__c;
        Acc.Factoring__c 					    = 	ilead.Factoring__c;
        Acc.Leasing__c 						    = 	ilead.Leasing__c;
        Acc.Comex__c 						    = 	ilead.Comex__c;
        Acc.Boletas_Garantia__c 			    = 	ilead.Boletas_Garantia__c;
        Acc.Cash_Management__c 				    = 	ilead.Cash_Management__c;
        Acc.Financiamiento_Inmobiliario__c 	    = 	ilead.Financiamiento_Inmobiliario__c;
        Acc.Mesa_de_Dinero__c 				    = 	ilead.Mesa_de_Dinero__c;
        Acc.Tipo_de_documento_de_identidad__c   =   ilead.tipo_documento_sales__c;
        Acc.RUT__c 							    = 	String.isNotBlank(ilead.RUTEmpresa__c) ? ilead.RUTEmpresa__c.trim() : '';
        Acc.Estado_Cliente_Banca_Empresas__c    =   AccountTriggerHelperB2B.ACCOUNT_ESTADO_CLIENTE_BANCA_EMPRESAS;
        if(String.isBlank(oldAccount.Calle_Nectia__c)){
            Acc.Calle_Nectia__c 				= 	ilead.Direccion_Oficina__c;
        }
        
        if(IsBancaEmpresas){
            Acc.RecordTypeId                    =   AccountTriggerHelperB2B.getRecordTypeId(AccountTriggerHelperB2B.RT_ACCOUNT_EMPRESA_BANCO);
            Acc.ownerid 						= 	ilead.Ownerid;
            if(String.isNotBlank(ilead.rut_ejecutivo_sales__c)){
                Acc.Rut_Ejecutivo_Banco__c              =   ilead.rut_ejecutivo_sales__c.trim();
            }
        }
        return Acc;
    }


    public static void updatefieldsleadConvertedToSinGestion(Lead iLead){
        iLead.Status                = LEAD_STATUS_SIN_GESTION;
        iLead.Informe_Visita_Generado__c            = false;
        iLead.Visita_comercial_exitosa__c           = false;
        iLead.Fecha_ultima_gestion__c               = null;
        iLead.Fecha_Inicio_Sin_Gestion__c           = null;
        iLead.Fecha_Inicio_Gestion__c               = null;
        iLead.Fecha_Inicio_Visita__c                = null;
        iLead.Fecha_Inicio_Comite__c                = null;
        iLead.Fecha_Inicio_Convertido__c            = null;
        iLead.Fecha_Inicio_No_Convertido__c         = null;
        iLead.Sancion_Comite__c                     = null;
        iLead.Fecha_Aprobacion_Comite__c            = null;
        iLead.Fecha_Estimada_Presentacion_Comite__c = null;
        iLead.Estado_Curse__c                       = null;
        iLead.Fecha_Curse__c                        = null;
        iLead.Moneda_Producto__c                    = null;
        iLead.Producto__c                           = null;
        iLead.Monto__c                              = null;
    }

    /**
     * @Author         :   Georvys Gonzalez <ggonzroj@everis.com>
     * @Description    :   shouldOpenlead valida que old Lead STATUS es CONVERTIDO o NO_INTERESADO
     */
    public static Boolean shouldOpenlead(Lead iLead){
        return iLead.Status == LEAD_STATUS_CONVERTIDO 
            || iLead.Status == LEAD_STATUS_NO_INTERESADO;
    }

    /**
     * @Author         :   Georvys Gonzalez <ggonzroj@everis.com>
     * @Description    :   When the process lead Owner has change, it should to change related records
     */
    public static void reasignOwnerToLeadAndRelated(List<Lead> newList, Map<ID,Lead> oldMap){
        Set<Id> setLeadId = new Set<Id>();
        List<Lead> listLead = new List<Lead>();
        Set<Id> idsOwner = new Set<Id>();

        List<Dato_Complementarios__c> lstDatos = new List<Dato_Complementarios__c>();
        List<Informe_de_Visita__c> lstInformes = new List<Informe_de_Visita__c>();
        List<Linea_Bancaria__c> lstBancarias = new List<Linea_Bancaria__c>();

        List<Dato_Complementarios__c> lstDatosUp = new List<Dato_Complementarios__c>();
        List<Informe_de_Visita__c> lstInformesUp = new List<Informe_de_Visita__c>();
        List<Linea_Bancaria__c> lstBancariasUp = new List<Linea_Bancaria__c>();

        for (Lead ilead : newList) {
            if (oldMap!=null) {
                Lead oldLead = oldMap.get(ilead.Id);
                if (oldLead.OwnerId != ilead.OwnerId) {
                    listLead.add(ilead);
                    setLeadId.add(ilead.Id);
                    idsOwner.add(ilead.OwnerId);
                }
            }
        }

        Map<Id, User> ownerMap = new Map<Id, User>(
            [
                SELECT Id, RUT__c
                FROM User
                WHERE Id IN :idsOwner
            ]
        );

        if (!setLeadId.isEmpty()) {
            // get related Dato_Complementarios__c
            Map<Id, List<Dato_Complementarios__c>> mapDatos = DatoComplementarioTriggerHelperB2b.getlstDatosComplementByleadMp(setLeadId);
            
            // get related Informe_de_Visita__c
            Map<Id, List<Informe_de_Visita__c>> mapInformes = Informe_de_VisitaTriggerHelperB2b.getMapInformeslstBylead(setLeadId);

            // get related Informe_de_Visita__c
            Map<Id, List<Linea_Bancaria__c>> mapLineas = LineaBancariaHelperB2b.getlineasBancariaByLead(setLeadId);

            for (Lead ilead : listLead) {

                if (mapDatos.containsKey(ilead.Id)) {
                    lstDatos = mapDatos.get(ilead.Id);

                    if (!lstDatos.isEmpty()) {
                        for (Dato_Complementarios__c iDatos : lstDatos) {
                            iDatos.OwnerId = ilead.OwnerId;
                            lstDatosUp.add(iDatos);
                        }
                    }
                }

                if (mapInformes.containsKey(ilead.Id)) {
                    lstInformes = mapInformes.get(ilead.Id);

                    if (!lstInformes.isEmpty()) {
                        for (Informe_de_Visita__c iInfo : lstInformes) {
                            iInfo.OwnerId = ilead.OwnerId;
                            lstInformesUp.add(iInfo);
                        }
                    }
                }

                if (mapLineas.containsKey(ilead.Id)) {
                    lstBancarias = mapLineas.get(ilead.Id);

                    if (!lstBancarias.isEmpty()) {
                        for (Linea_Bancaria__c ilinea : lstBancarias) {
                            ilinea.OwnerId = ilead.OwnerId;
                            lstBancariasUp.add(ilinea);
                        }
                    }
                }

                if (ownerMap.containsKey(ilead.OwnerId)) {
                    User iUser = ownerMap.get(ilead.OwnerId);
                    String newRut = UtilitiesSalesB2B.formatRut(iUser.RUT__c.toUpperCase(), 'WITHOUTDOT');
                    ilead.rut_ejecutivo_sales__c = newRut;
                }
            }

            //update lstDatos;
            //update lstInformes;
            //update lstBancarias;
            if(!lstDatosUp.isEmpty()){
                update lstDatosUp;
            }
            if(!lstInformesUp.isEmpty()){
                update lstInformesUp;
            }
            if(!lstBancariasUp.isEmpty()){
                update lstBancariasUp;
            }
        }
    }

    /**
     * @Author         :   Georvys Gonzalez <ggonzroj@everis.com>
     * @Description    :   Actualiza status y etapas de lead según avanza en el proceso.
     */
    public static void cambiosEtapasProspecto(List<Lead> newList, Map<ID,Lead> oldMap){
        List<Lead> listVisitas = new List<Lead>();
        List<Lead> listComite = new List<Lead>();
        List<Lead> listComiteAnalisis = new List<Lead>();
        List<Lead> listComiteRechazado = new List<Lead>();
        List<Lead> listComiteProbado = new List<Lead>(); 
        List<Lead> listCursePendiente = new List<Lead>(); 
        List<Lead> listCurseAprobado = new List<Lead>(); 

        for (Lead newlead : newList) {
            if (oldMap!=null) {
                Lead oldLead = oldMap.get(newlead.Id);
                // condición 1 Cambio estado visita-comite
                if (isInformeVisitaGenerado(newlead, oldLead) || isVisitaComercialExitosa(newlead, oldLead) && newlead.Status == LEAD_STATUS_VISITA) {
                    listVisitas.add(newlead);
                }
                // condición 2 Comité y cursado
                if (isEstadoCurseCursado(newlead, oldLead) && isSancionComiteAprobado(newlead, oldLead) && newlead.Status == LEAD_STATUS_COMITE ) {
                    listComite.add(newlead);
                }
                // condición 3 Comité en análisis
                if ( isComiteAnalisis(newlead, oldLead) && newlead.Status == LEAD_STATUS_COMITE ) {
                    listComiteAnalisis.add(newlead);
                }
                // condición 4 Comité rechazado
                if ( isComiteRechazado(newlead, oldLead) && newlead.Status == LEAD_STATUS_COMITE ) {
                    listComiteRechazado.add(newlead);
                }
                // condición 5 Comité aprobado
                if ( isSancionComiteAprobado (newlead, oldLead) && newlead.Status == LEAD_STATUS_COMITE ) {
                    listComiteProbado.add(newlead);
                }
                // condición 6 Curse pendiente
                if ( isEstadoCursePendiente(newlead, oldLead) && newlead.Status == LEAD_STATUS_COMITE ) {
                    listCursePendiente.add(newlead);
                }
                // condición 7 Curse aprobado
                if ( isEstadoCurseCursado(newlead, oldLead) && newlead.Status == LEAD_STATUS_COMITE ) {
                    listCurseAprobado.add(newlead);
                }

            }
        }

        if (!listVisitas.isEmpty()) {
            updateStatusAndEtapa(listVisitas, LEAD_STATUS_COMITE, LEAD_ETAPA_INFORME_VISITA_COMPLETO);
        }

        if (!listComite.isEmpty()) {
            updateStatusAndEtapa(listComite, LEAD_STATUS_CONVERTIDO, LEAD_ETAPA_CURSADO);
        }

        if (!listComiteAnalisis.isEmpty()) {
            updateStatusAndEtapa(listComiteAnalisis, '', LEAD_ETAPA_COMITE_ANALISIS);
        }

        if (!listComiteRechazado.isEmpty()) {
            updateStatusAndEtapa(listComiteRechazado, LEAD_STATUS_NO_INTERESADO , LEAD_ETAPA_COMITE_RECHAZADO);
        }

        if (!listComiteProbado.isEmpty()) {
            updateStatusAndEtapa(listComiteProbado, '', LEAD_ETAPA_COMITE_APROBADO);
        }

        if (!listCursePendiente.isEmpty()) {
            updateStatusAndEtapa(listCursePendiente, '', LEAD_ETAPA_PENDIENTE_CURSE);
        }

        if (!listCurseAprobado.isEmpty()) {
            updateStatusAndEtapa(listCurseAprobado, LEAD_STATUS_CONVERTIDO , LEAD_ETAPA_CURSADO);
        }

    }

    public static Boolean isComiteAnalisis (Lead newlead, Lead oldLead){
        return oldLead.Sancion_Comite__c != newlead.Sancion_Comite__c && newlead.Sancion_Comite__c == SANCION_COMITE_ANALISIS;
    }

    public static Boolean isComiteRechazado (Lead newlead, Lead oldLead){
        return oldLead.Sancion_Comite__c != newlead.Sancion_Comite__c && newlead.Sancion_Comite__c == SANCION_COMITE_RECHAZADO;
    }

    public static Boolean isSancionComiteAprobado (Lead newlead, Lead oldLead){
        return oldLead.Sancion_Comite__c != newlead.Sancion_Comite__c && newlead.Sancion_Comite__c == SANCION_COMITE_APROBADO;
    }

    public static Boolean isEstadoCursePendiente (Lead newlead, Lead oldLead){
        return oldLead.Estado_Curse__c != newlead.Estado_Curse__c && newlead.Estado_Curse__c == LEAD_ESTADO_CURSE_PENDIENTE;
    }

    public static Boolean isEstadoCurseCursado (Lead newlead, Lead oldLead){
        return oldLead.Estado_Curse__c != newlead.Estado_Curse__c && newlead.Estado_Curse__c == LEAD_ESTADO_CURSE_CURSADO;
    }

    public static Boolean isInformeVisitaGenerado (Lead newlead, Lead oldLead){
        return (oldLead.Informe_Visita_Generado__c != newlead.Informe_Visita_Generado__c) 
            && newlead.Informe_Visita_Generado__c == true 
            && newlead.Visita_comercial_exitosa__c == true
            && newlead.Status == LEAD_STATUS_VISITA;
    }

    public static Boolean isVisitaComercialExitosa (Lead newlead, Lead oldLead){
        return (oldLead.Visita_comercial_exitosa__c != newlead.Visita_comercial_exitosa__c) 
                && newlead.Visita_comercial_exitosa__c == true 
                && newlead.Informe_Visita_Generado__c == true
                && newlead.Status == LEAD_STATUS_VISITA;
    }

    public static void updateStatusAndEtapa(List<Lead> listLead, String status, String etapa){
        for (Lead newlead : listLead) {
            if (String.isNotBlank(status)) {
                newlead.Status = status;
            } 
            if (String.isNotBlank(etapa)) {
                newlead.Etapa_Prospecto__c = etapa;
            }
        }
    }

    ///////////////////////
    public static AccountTeamMember CreateAccountTeamMember(Id accountid, Id ownerid){
        return new AccountTeamMember(
            AccountId = accountid
            ,UserId = ownerid
            ,AccountAccessLevel = 'Edit'
            ,TeamMemberRole = LeadTriggerHelperB2b.TEAMMEMBER_ROLE_EJECUTIVOBANCAEMPRESA
            ,CaseAccessLevel = 'None'
            ,OpportunityAccessLevel = 'None'	
        );
    }

}