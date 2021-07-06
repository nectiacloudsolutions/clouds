/*********************************************************************************************************
@Author       zsuanaza@everis.com
@name         ReassignLeadBatch
@CreateDate   17/10/2019
@Description  Batch to call analytics for a new owner and SLA for expire leads
***********************************************************************************************************
History of changes: 
----------------------------------------------------------------------------------------------------------------------------------------
Date               Developer                         Comments   
----------------------------------------------------------------------------------------------------------------------------------------
17/10/2019  	zsuanaza@everis.com         W-000045 - (LEAD)Reasignación de Leads
19/06/2020	alvaro.tromilen@consorcio.cl	Avoid assigning Leads to users with profiles not allowed.
08/07/2020	alvaro.tromilen@consorcio.cl	Correction on arguments passed to check profiles. Loggers added.
28/07/2020  alvaro.tromilen@consorcio.cl	Logic about close Leads was moved to another class. Handling of field 'fecha_reasignacion_analytics' and code refactoring.
****************************************************************************************************************************************/
public class ReassignLeadBatch 
implements Database.Batchable<SObject>, Database.AllowsCallouts 
{
    private static final String TOKENMOCK ='ZZXCVBNM123';
    
    public Database.QueryLocator start(Database.BatchableContext BC) 
    { 
        system.debug('--> Comienza proceso de reasignación en ReassignLeadBatch');
        DateTime now = System.now();
        String currentTime = now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        String query = 'SELECT Id, numero_de_documento_sales__c, rut_ejecutivo_sales__c, OwnerId, '+
                                        'SLA_sales__c, reasignaciones_del_lead_sales__c '+
                                        'FROM Lead ' +
                                        'WHERE origen_analytics_sales__c = true ' +
                                        'AND status = \''+CONSTANTS.LEAD_STATUS_CREADO+'\' ' +
                                        'AND numero_de_documento_sales__c != null '+
                                        'AND SLA_Sales__c < '+ currentTime + ' ' +
                                        'AND (reasignaciones_del_lead_sales__c < 20 OR reasignaciones_del_lead_sales__c = null)';
        System.debug('Query para obtener Leads en status \'No Gestionado\' con SLA vencido: ' + query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext info, List<SObject> leadList) {
        //No es necesario validar que la lista de Leads se encuentre vacía. Si el método start no encuentra resultados, pasa de inmediato a finish()
        system.debug('--> Leads recibidos para reasignación: '+ leadList.size()); 
        System.debug(leadList);
        try{
            Map<String,String> rutIdLeads = new map<String,String>();
            Map<String,String> rutIdUserOriginal = new map<String,String>();
            
            for(lead l : (List<lead>) leadList){
                rutIdLeads.put(l.numero_de_documento_sales__c, l.Id);
                rutIdUserOriginal.put(l.numero_de_documento_sales__c, l.OwnerId);
            }
            
            //Llamada a Analytics para reasignación de prospectos
            SalesCallout sc = new SalesCallout(CONSTANTS.ANALYTICSLEAD); 
            String analyticsResponse;
            
            //Necesario para evitar error -> ErrorSystem.CalloutException: You have uncommitted work pending. Please commit or rollback before calling out
            //Documentado en clase ReassignLeadBatchTest.
            if(Test.isRunningTest()){
                String currentTime = System.now().addDays(2).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                system.debug('Test Corriendo: TIME --> '+currentTime);
                analyticsResponse = '{"message":null,"leadList":[{"attributes":{"type":"Lead","url":"/services/data/v47.0/sobjects/Lead/00Q8A000003HNEsUAO"},"Id":"00Q8A000003HNEsUAO","numero_de_documento_sales__c":"17664054-5","rut_ejecutivo_sales__c":"200133757","sla_sales__c":"'+ currentTime +'"},'+
                    '{"attributes":{"type":"Lead","url":"/services/data/v47.0/sobjects/Lead/00Q8A000003HNEtUAO"},"Id":"00Q8A000003HNEtUAO","numero_de_documento_sales__c":"16671940-2","rut_ejecutivo_sales__c":"200133757","sla_sales__c":"'+ currentTime +'"},'+
                    '{"attributes":{"type":"Lead","url":"/services/data/v47.0/sobjects/Lead/00Q8A000003HNEuUAO"},"Id":"00Q8A000003HNEuUAO","numero_de_documento_sales__c":"18809923-8","rut_ejecutivo_sales__c":"200133757","sla_sales__c":"'+ currentTime +'"},'+
                    '{"attributes":{"type":"Lead","url":"/services/data/v47.0/sobjects/Lead/00Q8A000003HNEvUAO"},"Id":"00Q8A000003HNEvUAO","numero_de_documento_sales__c":"22023427-4","rut_ejecutivo_sales__c":"995802406","sla_sales__c":"'+ currentTime +'"}],'+
                    '"code":null,"action":"REASSIGN"}';
            }else{
                analyticsResponse = sc.consultLeadAnalyticsMassive(leadList, CONSTANTS.REASSIGN);
            	system.debug('Resultado de Consulta a Analytics: '+ analyticsResponse);
            }

            if(analyticsResponse != null){
                SalesCallout.leadDataList result = (SalesCallout.leadDataList) system.json.deserialize(analyticsResponse, SalesCallout.leadDataList.class);
                List<lead> analyticsLeads = result.leadList;
                system.debug('Leads enviados por Analytics --> ' + analyticsLeads);
                
				//Aquellos Leads con ejecutivos con perfiles no autorizados en ProfileInjectionLead no serán reasignados y deberán esperar el próximo proceso.
                List<Lead> reassignLeads = getLeadsWithAuthorizedProfiles(analyticsLeads);
                System.debug('--> Leads con perfiles correctos: ' + reassignLeads.size());
                
                if(!reassignLeads.isEmpty()){
                    System.debug('--> ' + reassignLeads.size() + ' Leads con perfil autorizado: ' + reassignLeads);
                    Set<String> rutEjecutivosToReasign = new set<String>();
                    Map<String,String> rutIdNuevoEjecutivo = new map<String,String>();
                    
                    //Colección de ruts de ejecutivos a quienes serán reasignados los list
                    for(lead l : reassignLeads){
                        rutEjecutivosToReasign.add(removeDashFromRut(l.rut_ejecutivo_sales__c));
                    }
                    
                    //Obtener el User ID de los ejecutivos a los que serán reasignados los Leads (para referenciarlo como Lead.OwnerId en Update)
                    for(user u: [SELECT ID, RUT__c FROM User WHERE RUT__c =: rutEjecutivosToReasign]){
                        system.debug('RUT ejecutivo --> '+u.RUT__c);
                        rutIdNuevoEjecutivo.put(u.RUT__c, u.Id);
                    }
                    
                    for(lead l: reassignLeads){
                        system.debug('LEAD - UserID original: ' + l.OwnerId + ', Nuevo UserID: ' + rutIdNuevoEjecutivo.get(removeDashFromRut(l.rut_ejecutivo_sales__c)));
                        l.Id = rutIdLeads.get(l.numero_de_documento_sales__c); //Asigna el ID de Lead previamente guardado map rutIdLeads
                        l.reasignaciones_del_lead_sales__c = (l.reasignaciones_del_lead_sales__c == null? 0 : l.reasignaciones_del_lead_sales__c) + 1;
                        l.Fecha_reasignacion_analytics__c = System.now();
                        
                        //Si el RUT de ejecutivo tienen un ID de usuario en Salesforce, se reasignará. En caso contrario, quedará el ejecutivo original.
                        if(rutIdNuevoEjecutivo.get(removeDashFromRut(l.rut_ejecutivo_sales__c)) != null){
                            l.OwnerId = rutIdNuevoEjecutivo.get(removeDashFromRut(l.rut_ejecutivo_sales__c));
                            System.debug('--> Lead con RUT ' + l.numero_de_documento_sales__c + ' será reasignado al ejecutivo con RUT ' + removeDashFromRut(l.rut_ejecutivo_sales__c) + 
                                     '. Cantidad de reasignaciones: ' + l.reasignaciones_del_lead_sales__c);
                        } else {
                            l.OwnerId = rutIdUserOriginal.get(l.numero_de_documento_sales__c);
                            System.debug('--> Lead con RUT ' + l.numero_de_documento_sales__c + ' NO será reasignado (RUT ejecutivo informado por analytics ' +
                                        'no cuenta con ID en Salesforce). Cantidad de reasignaciones: ' + l.reasignaciones_del_lead_sales__c);
                        }                       
                    }
                    
                    system.debug('Leads to Update --> '+reassignLeads);
                    update reassignLeads;
                }
            }
        } catch(Exception e){
            System.debug(LoggingLevel.ERROR, 'Proceso BATCH de Reasignación terminado con errores. Finaliza ejecución. Error: ' + e.getMessage());
        }
    }
    
    public void finish(Database.BatchableContext info) {
        system.debug('--> Termino de proceso de reasignación en ReassignLeadBatch.');
    }

	/**
     * De una lista de usuarios retorna sólo aquellos usuarios con perfiles admitidos por Custom Settings 'ProfileInjectionLead'
     * */
    private List<Lead> getLeadsWithAuthorizedProfiles(List<Lead> leadList){
        List<Lead> newLeadList = new List<Lead>();
        
        Set<String> rutSet = getRutSetCleaned(leadList);
        System.debug('-->getLeadsWithAuthorizedProfiles() -  rutSet: ' + rutSet.toString());
        
        //Devuelve sólo los usuarios con perfil válido para reasignación (Custom Setting: ProfileInjectionLead)
        Map<String,Id> idsWithAuthorizedProfiles = UtilitiesSales.getIdsExecutive(rutSet);
        System.debug('--> getLeadsWithAuthorizedProfiles() -  idsWithAuthorizedProfiles: ' + idsWithAuthorizedProfiles.toString());
        
        for(Lead lead: leadList){
            String userRut = removeDashFromRut(lead.rut_ejecutivo_sales__c);
            String leadRUT = removeDashFromRut(lead.numero_de_documento_sales__c);
            
            //Sólo los usuarios con perfil autorizados serán agregados a la lista de Leads a retornar
            if(idsWithAuthorizedProfiles.get(userRut) != null){
                newLeadList.add(lead);
            }else{
                System.debug(LoggingLevel.WARN, 'EXCLUSIÓN Lead '+ leadRUT +': Usuario con RUT ' + userRut + ' no cuenta por un perfil ' +
                             'autorizado en custom setting ProfileInjectionLead para asignación de Leads.');
            }
        }
        
        System.System.debug('-->getLeadsWithAuthorizedProfiles() -  newLeadList: ' + newLeadList.toString());
        return newLeadList;
    }
    
    /*
     * Start of utility methods
     **/
    private Set<String> getRutSetCleaned(List<Lead> leadList){
        System.debug('--> getRutSetCleaned: ' + leadList);
        Set<String> rutSet = new Set<String>();
        for(Lead lead: leadList){
            rutSet.add(removeDashFromRut(lead.rut_ejecutivo_sales__c));
        }
        
        System.debug('--> RUTs to return: ' + rutSet);
        return rutSet;
    }
    
    private String removeDashFromRut(String rut){
        if(rut != null && rut.contains('-')) {
            return rut.remove('-');
        } 
        return rut;
    }
	/*
     * End of utility methods
     **/   
}