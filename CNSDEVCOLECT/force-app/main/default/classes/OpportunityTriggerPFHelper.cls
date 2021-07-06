/**
* @File Name          : OpportunityTriggerPFHelper.cls
* @Description        : 
* @Author             : gcabrerp@everis.com
* @Group              : 
* @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
* @Last Modified On   : 12-28-2020
* @Modification Log   : 
* Ver       Date            Author      		    Modification
* 1.0    11-12-2020   gcabrerp@everis.com     Initial Version
**/
public without sharing class OpportunityTriggerPFHelper {
    
    private final static String PORT_COORDI_OPERA = Label.PF_Cola_Coordina_Operacional;
    private final static String PF_RECORD_TYPE = Label.PF_Opp_RecordType;
    private final static List<String> GRUPOS_COLAS = new List<String>{PORT_COORDI_OPERA};
    private final static String PF_ESTADO_EVALUACION= Label.PF_Estado_Evaluacion;    
    private final static String PF_OPPORTUNITY_STAGENAME_EVALUACION = Label.PF_Opportunity_StageName_Evaluacion;    
    private final static String PF_OPPORTUNITY_STAGENAME_OFERTA_PORTABILIDAD = Label.PF_Opportunity_StageName_Oferta_Portabilidad;    
    private final static String PF_OPPORTUNITY_STAGENAME_FIRMA_CONTRATO_ESCRITURA = Label.PF_Opportunity_StageName_Firma_Contrato_Escritura;    
    private final static String PF_ACEPTACION_OFERTA = Label.PF_Aceptacion_Oferta;    
    private final static String PF_COMPLETAR_CAMPO_ESTADO_EVALUACION = Label.PF_Completar_Campo_Estado_Evaluacion;
    private final static String PF_COMPLETAR_CAMPO_ACEPTACION_OFERTA = Label.PF_Completar_Campo_Aceptacion_Oferta; 
    private final static String PF_SIMULACION = Label.PF_Simula_Prd;
    private final static String PF_Plan_Plus = Label.PF_Prd_Plan_Plus;
    private final static String PF_Hipotecario = Label.PF_Prd_Hipotecario;
    private final static String PF_Consumo = Label.PF_Prd_Consumo;
    private final static String PF_AGREGA_CAMPO_PRD = Label.PF_Agrega_Campos_Prd;
    private final static List<String> NOMBRES_PRODUCTOS = new List<String>{PF_Plan_Plus,PF_Hipotecario,PF_Consumo};
        
    private static Map<String,Id> gruposMap;
    private static Map<String,TaskInformation__c> taskMap;
    public static List<TaskInformation__c> lstTask  {get; set;}
    
    public static List<TaskInformation__c> loadSettings(){
        if(lstTask == null){
            lstTask = [select  Name, Asunto__c, Estado__c, Origen__c, Vencimiento__c, Filtro__c, ValorFiltro__c, Tipo_Notificacion__c from TaskInformation__c where Origen__c =: PF_RECORD_TYPE];
        }
        taskMap = new Map<String,TaskInformation__c>();
        for(TaskInformation__c tsk:lstTask){
            taskMap.put(tsk.ValorFiltro__c, tsk);
        }
        return lstTask;
    }
    
    public static void createTaskByOpps(List<Opportunity> oppLst, Map<Id,Opportunity> mapOppsOld){
        List<Opportunity> lstOpp = new List<Opportunity>();
        Map<Id, TaskInformation__c> mpTskOpp = new Map<Id, TaskInformation__c>();
        TaskInformation__c task = new TaskInformation__c();
        List<Task> lsTask = new List<Task>();
        List<String> lstReci = new List<String>();
        Map<Id,Opportunity> oppIdMap = new Map<Id,Opportunity>();
        Boolean swNoti = False;
        for(Opportunity oppRTPF : oppLst ){
            if( oppRTPF.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(PF_RECORD_TYPE).getRecordTypeId()){
                lstOpp.add(oppRTPF);
            }
        }
        
        if(lstOpp.size()> 0){
            oppIdMap = new Map<Id,Opportunity>([SELECT ownerId, Account.PersonContact.Name, Account.PersonContactId  FROM Opportunity WHERE id IN :lstOpp]);
        }
        
        String tipoNot = '';   
        for(Opportunity oppTsk : oppLst ){
            if( oppTsk.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(PF_RECORD_TYPE).getRecordTypeId()){
                
                loadSettings();
                buscarGrupos(); 
                
                Opportunity retriOpp = oppIdMap.get(oppTsk.id);
                
                if(mapOppsOld != NULL){
                    if(oppTsk.Sol_Firmada_PF__c != NULL && oppTsk.Sol_Firmada_PF__c && !mapOppsOld.get(oppTsk.id).Sol_Firmada_PF__c){ 
                        mpTskOpp.put(oppTsk.Id, taskMap.get('Sol_Firmada_PF__c'));
                        swNoti = true;
                    }
                    if(oppTsk.StageName != NULL && oppTsk.StageName=='CAD'&& mapOppsOld.get(oppTsk.id).StageName!= 'CAD'){
                        mpTskOpp.put(oppTsk.Id, taskMap.get(oppTsk.StageName));
                        swNoti = true;
                    }
                    if(oppTsk.StageName != NULL && oppTsk.StageName=='Firma Contrato/Escritura'&& mapOppsOld.get(oppTsk.id).StageName== 'Oferta de portabilidad'){
                        mpTskOpp.put(oppTsk.Id, taskMap.get('CAD'));
                        swNoti = true;                      
                    }                    
                }else{
                    if(oppTsk.Sol_Firmada_PF__c != NULL && oppTsk.Sol_Firmada_PF__c ){ 
                        mpTskOpp.put(oppTsk.Id, taskMap.get('Sol_Firmada_PF__c'));
                        swNoti = true;
                    }
                    if(oppTsk.StageName != NULL && oppTsk.StageName=='CAD'){
                        mpTskOpp.put(oppTsk.Id, taskMap.get(oppTsk.StageName));
                        swNoti = true;
                    }
                }
                
                if(swNoti){
                    Task newTask = new Task();
                    newTask.Subject = mpTskOpp.get(retriOpp.Id).Asunto__c;
                    //newTask.WhoId = retriOpp.Account.PersonContactId; HU-1269
                    newTask.WhatId = retriOpp.Id;
                    newTask.Status = mpTskOpp.get(retriOpp.Id).Estado__c;
                    newTask.ActivityDate = System.today() + Integer.valueOf(mpTskOpp.get(retriOpp.Id).Vencimiento__c);
                    newTask.OwnerId = gruposMap.get(PORT_COORDI_OPERA);
                    newTask.PF_Opportunity_Owner__c = retriOpp.ownerId;
                    newTask.PF_Cliente__c = retriOpp.Account.PersonContact.Name;
                    newTask.PF_Nombre_Opp__c = retriOpp.Id;
                    newTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('PF_portabilidad_financiera_Tareas').getRecordTypeId();
                    lsTask.add(newTask);                        
                    swNoti = false;
                }
            }
        }
        if(lsTask.size() > 0){
            Insert lsTask;
            String tipoNot1;   
            
            for(Task nTask : lsTask){
                tipoNot1 = mpTskOpp.get(nTask.whatId).Tipo_Notificacion__c;               
                CnsCustomNotification.notifyCurrentUser(JSON.serialize(nTask), tipoNot1, new list<String>{nTask.OwnerId}  );      
            }
        }
    }    
    
    private static void buscarGrupos(){
        gruposMap = new Map<String,Id>();
        for(Group grupo : [select DeveloperName from Group where DeveloperName IN: GRUPOS_COLAS ]){
            gruposMap.put(grupo.DeveloperName, grupo.Id);  
        }
    }  
    
    public static void verificationRecordType(List<Opportunity> oppLst, Map<Id,Opportunity> oldMap){
        try{
            for (Opportunity opp : oppLst){
                if(opp.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(PF_RECORD_TYPE).getRecordTypeId()){
                    if(oldMap == null) {
                        createProductAutomatically(opp);
                    } else {
                        productoFieldControl(opp, oldMap);
                    }
                } 
            }
        }catch(Exception e){
            Trigger.new[0].addError(e.getMessage());
        }
    }
    
    /*
    * @description       Product field control on Opportunity when stage field is changed 
    * @author            cvillalm@everis.com | 12-01-2021
    * @param1            opp - Opportunity
    * @param2            oldMap - Map<Id,Opportunity>
    * @return            void
    * @throws            NA
    */  
    private static void productoFieldControl(Opportunity opp, Map<Id,Opportunity> oldMap) {
        if(opp.StageName != oldMap.get(opp.Id).StageName){
            if(oldMap.get(opp.Id).StageName.equals(PF_OPPORTUNITY_STAGENAME_EVALUACION )  && opp.StageName.equals(PF_OPPORTUNITY_STAGENAME_OFERTA_PORTABILIDAD) ){
                List<OpportunityLineItem> oppLineItems = [SELECT Id, Estado_de_Evaluacion__c,Aceptacion_de_Oferta__c FROM OpportunityLineItem WHERE OpportunityId=:opp.id] ;
                oppLineItemMnsgError(opp, oppLineItems, PF_ESTADO_EVALUACION);
            } else if(oldMap.get(opp.Id).StageName.equals(PF_OPPORTUNITY_STAGENAME_OFERTA_PORTABILIDAD )  && opp.StageName.equals(PF_OPPORTUNITY_STAGENAME_FIRMA_CONTRATO_ESCRITURA)) {
                List<OpportunityLineItem> oppLineItems = [SELECT Id, Estado_de_Evaluacion__c,Aceptacion_de_Oferta__c FROM OpportunityLineItem WHERE OpportunityId=:opp.id] ;
                oppLineItemMnsgError(opp, oppLineItems, PF_ACEPTACION_OFERTA);
            }else if(oldMap.get(opp.Id).StageName.equals(PF_SIMULACION )  && opp.StageName.equals(PF_OPPORTUNITY_STAGENAME_EVALUACION)) {
                List<OpportunityLineItem> oppLineItems = [SELECT Id, Estado_de_Evaluacion__c,Aceptacion_de_Oferta__c, Numero_Op_Comercializadora_sales__c, numero_oportunidad_pch_sales__c, numero_solicitud_sales__c, Product2.name FROM OpportunityLineItem WHERE OpportunityId=:opp.id] ;
                oppLineItemMnsgError(opp, oppLineItems, PF_SIMULACION);
            }
        }
    }
    
    /*
    * @description       Method to choise type of message that will be send when the stage on Opp is changed
    * @author            cvillalm@everis.com | 12-01-2021
    * @param1            opp - Opportunity
    * @param2            oppLineItems - List<OpportunityLineItem>
    * @param3			 field - String
    * @return            void
    * @throws            NA
    */
    private static void oppLineItemMnsgError(Opportunity opp, List<OpportunityLineItem> oppLineItems, String field) {
        for(OpportunityLineItem oli : oppLineItems) {
            if(field == PF_ESTADO_EVALUACION && oli.Estado_de_Evaluacion__c == null) {
                opp.addError(PF_COMPLETAR_CAMPO_ESTADO_EVALUACION);
            } else if(field == PF_ACEPTACION_OFERTA && oli.Aceptacion_de_Oferta__c == null) {
                opp.addError(PF_COMPLETAR_CAMPO_ACEPTACION_OFERTA);
            }else if(field == PF_SIMULACION) {
				if(oli.Product2.name == PF_Plan_Plus && oli.Numero_Op_Comercializadora_sales__c == null || oli.Product2.name == PF_Hipotecario && oli.numero_oportunidad_pch_sales__c == null  || oli.Product2.name == PF_Consumo && oli.numero_solicitud_sales__c == null ){
                opp.addError(PF_AGREGA_CAMPO_PRD);
				}
            }
        }
    }
    
    private static void createProductAutomatically(Opportunity opp) {
        if(opp.Caso_PF__c != null) {
            Case caso = [Select id, Caso_PF_Credito_Consumo__c, Caso_PF_Credito_Hipotecario__c, Caso_PF_Plan_Plus__c FROM Case where id=:opp.Caso_PF__c];
            List<Product2> lstProductos = new List<Product2>([Select id, Name FROM Product2 where Name=:NOMBRES_PRODUCTOS]);
            Map<String,Product2> Productos = new Map<String, Product2>();
            for(Product2 prd : lstProductos) {
                Productos.put(prd.Name,prd);
            }
            List<OpportunityLineItem> listOppLI = new List<OpportunityLineItem>();
            if(caso.Caso_PF_Credito_Consumo__c) {
                listOppLI.add(createProduct(opp,Productos.get(PF_Consumo)));
            } 
            if(caso.Caso_PF_Credito_Hipotecario__c) {
                listOppLI.add(createProduct(opp,Productos.get(PF_Hipotecario)));
            } 
            if(caso.Caso_PF_Plan_Plus__c) {
                listOppLI.add(createProduct(opp,Productos.get(PF_Plan_Plus)));
            }
            if(!listOppLI.isEmpty()) {
                insert listOppLI;
            }
        }
    }
    
    private static OpportunityLineItem createProduct(Opportunity opp, Product2 prod) {
        PricebookEntry pricePrdEntry = [Select id FROM PricebookEntry where Product2Id=:prod.id];
        OpportunityLineItem oppLI = new  OpportunityLineItem();
        oppLI.OpportunityId = opp.id;
        oppLI.PricebookEntryId = pricePrdEntry.id;
        oppLI.Product2Id = prod.id;
        oppLI.Quantity = 1;
        oppLI.TotalPrice = 1;
        return oppLI;
    }
}