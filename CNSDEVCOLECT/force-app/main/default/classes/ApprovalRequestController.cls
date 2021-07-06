public without sharing class ApprovalRequestController {

    @AuraEnabled
    public static Map<String,List<Object>> getInitialData(Id oppId){ 
        Map<String,List<Object>> mapOpp = new Map<String,List<Object>>();
        List<Opportunity> lstOpp = [SELECT Id, StageName, Indicaciones_ejecutivo_sales__c, 
                                    Indicaciones_riesgo_sales__c, Motivo_rechazo_riesgo_sales__c, ejecutivo_riesgo_sales__c, Motivo_otro_sales__c,
                                    Aprobacion_Riesgo_sales__c, motivo_reingreso_sales__c, recordType.developerName, OwnerId, aprobacion_visado_sales__c
                        FROM Opportunity WHERE Id =: oppId LIMIT 1];
        
        List<Profile> lstProfile = [SELECT Name 
                        FROM Profile WHERE Id =: UserInfo.getProfileId() LIMIT 1];
        List<Id> ids = new List<Id>();     
        for(Opportunity op : lstOpp){
            ids.add(op.OwnerId);    
        }
        List<OpportunityTeamMember> otmRisk = [SELECT Id, OpportunityId, UserId, Name,  Title, TeamMemberRole, OpportunityAccessLevel 
                                               FROM OpportunityTeamMember 
                                               WHERE OpportunityId =: oppId AND TeamMemberRole like: Constants.OPPORTUNITY_MEMBER_RIESGO];
        
        List<User> riskUserList = new List<User>();
        if(!otmRisk.isEmpty()){
            for(OpportunityTeamMember otm: otmRisk){
                if(otm.UserId == UserInfo.getUserId()){
                    riskUserList.add(new user(id = UserInfo.getUserId()));
                }
            }
        } 
        
        List<User> lstManagers = [SELECT Id, ManagerId, manager.managerId, firstName, lastName 
                                  FROM User where Id IN: ids];
        mapOpp.put('Risk',riskUserList);
        mapOpp.put('Opportunity', lstOpp);
        mapOpp.put('Reason', getReason());
        mapOpp.put('Actions', getActions());
        mapOpp.put('Profile', lstProfile); 
        mapOpp.put('Manager',lstManagers);
        mapOpp.put('VisibilityApproval', getVisibilityApproval(oppId));
        mapOpp.put('ProfileVApp', getApprovalVisibilityProfiles());
        
        return mapOpp;
    }

    @AuraEnabled
    public static List<String> getApprovalVisibilityProfiles(){
        List<String> result = new List<String>();
        String resultd = Constants.NOK; 
        Id currentUser = UserInfo.getUserId();
        List<ViewApprovalProfiles__mdt> ProfileListMdt = [SELECT ProfileName__c FROM ViewApprovalProfiles__mdt];
        List<User> usresViewApproval = [SELECT id,ProfileId, Profile.Name FROM User WHERE ProfileId =: UserInfo.getProfileId() AND Id =: currentUser LIMIT 1];
        if((!ProfileListMdt.isEmpty() && ProfileListMdt !=null && !usresViewApproval.isEmpty() && usresViewApproval != null)){
            for(ViewApprovalProfiles__mdt lstmd : ProfileListMdt) {
                 if(usresViewApproval[0].Profile.Name == lstmd.ProfileName__c){
                     resultd = Constants.OK;                                   
                 }
            } 
        }
        result.add(resultd);  
        return result;
    }
    
    @AuraEnabled
    public static List<String> getVisibilityApproval(id oppId){
        
        List<String> result = new List<String>();
        Id idUser = UserInfo.getUserId();
        List<User> usrs = [SELECT Id, ManagerId FROM User WHERE Id IN (SELECT ejecutivo_riesgo_sales__c FROM Opportunity WHERE Id =: oppId)];
     
        if(!usrs.isEmpty() && usrs != null){
            
            if (usrs[0].ManagerId == idUser || usrs[0].Id == idUser ){
                result.add(Constants.OK);
            }
            else
            {
                result.add(Constants.NOK);
            }
        }
        return result;
    }

  
    @AuraEnabled
    public static string saveApproval(Id oppId) {
        Id rcdType;
        
     
        boolean validateDocs = true;
        List<documento_oportunidad_sales__c> lstDocOpp = [SELECT id
                                                          FROM documento_oportunidad_sales__c 
                                                          WHERE Opportunity_sales__c =: oppId
                                                          and estado_documento_sales__c='' AND tipo_oportunidad_sales__c = ''
                                                          ORDER BY CreatedDate ASC];
        if (lstDocOpp.size()>0){
            validateDocs = false;
        }
        
        
        String response = Constants.OK;
        
        if (validateDocs){
            try {
                
             
                List<Opportunity> lstOpp = [SELECT Id,StageName,Aprobacion_Riesgo_sales__c,OwnerId,recordTypeId
                                            FROM Opportunity WHERE Id =: oppId LIMIT 1];
                
                if (Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(lstOpp[0].recordTypeId).
                    getDeveloperName().equals(Constants.RECORDTYPE_BANCA_HIPOTECARIO_LECTURA)){
                        
                        rcdType = [SELECT Id,Name FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_BANCA_HIPOTECARIO LIMIT 1].Id;
                        lstOpp[0].StageName = Constants.HIPOTECARIO_STATUS_FORMALIZACION;
                    } else if(Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(lstOpp[0].recordTypeId).
                              getDeveloperName().equals(Constants.RECORDTYPE_BANCA_PLAN_PLUS_LECTURA)){
                                  
                                  rcdType = [SELECT Id,Name FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_BANCA_PLAN_PLUS LIMIT 1].Id;
                                  lstOpp[0].StageName = Constants.PLAN_PLUS_STATUS_ENTREGA;
                                  
                              } else if(Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(lstOpp[0].recordTypeId).
                                        getDeveloperName().equals(Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO_LECTURA)){
                                            
                                            rcdType = [SELECT Id,Name FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO LIMIT 1].Id;
                                            lstOpp[0].StageName = Constants.OPPORTUNITY_STAGENAME_FORMALIZACION;
                                        }
                
                lstOpp[0].RecordtypeId = rcdType;
                lstOpp[0].Aprobacion_Riesgo_sales__c = Constants.APROBADO_RIESGO_APROBADO;
                lstOpp[0].notificacion_evaluacion_sales__c  = Constants.NOTIFICACION_APROBADO_ESPECIALISTA;
                
                update lstOpp;
            } catch(Exception ex) {
                
                response = Constants.NOK;
            }
        }
        else
        {
            
            response = Constants.INVALID;            
        }
        return response; 
    }

 
    @AuraEnabled
    public static string rejectProposalRisk(Id oppId, String reason, String obs){
		String response = Constants.OK;

        try {
			
            List<Opportunity> lstOpp = [SELECT Id,StageName,Aprobacion_Riesgo_sales__c,
                                        Indicaciones_riesgo_sales__c, Motivo_rechazo_riesgo_sales__c, OwnerId
                            FROM Opportunity WHERE Id =: oppId LIMIT 1];
            lstOpp[0].Aprobacion_Riesgo_sales__c = Constants.APROBADO_RIESGO_RECHAZADO;
            lstOpp[0].Indicaciones_riesgo_sales__c = obs;
            lstOpp[0].Motivo_rechazo_riesgo_sales__c = reason;      
            update lstOpp;

        } catch(Exception ex) {
            
            response = Constants.NOK;
        }

        return response;
    }

   
    @AuraEnabled
    public static string rejectProposalConfirmBoss(Id oppId){
		String response = Constants.OK;

        try {
            List<Opportunity> lstOpp = [SELECT Id,StageName,Aprobacion_Riesgo_sales__c,OwnerId,Loss_Reason__C, RecordTypeId
                            FROM Opportunity WHERE Id =: oppId LIMIT 1];

            lstOpp[0].StageName = Constants.HIPOTECARIO_STATUS_CIERRE_PERDIDA;
         
            lstOpp[0].Loss_reason__c = Constants.HIPOTECARIO_MOTIVO_PERDIDA_RECHAZADO_RIESGO;
        
            	
            update lstOpp;
        } catch(Exception ex) {
            response = Constants.NOK;
             
        }
        
        return response;
    }

    
    @AuraEnabled
    public static string rejectProposalNotification(Id oppId, String profile, String obs, String action){
		Id rcdType;
        String response = Constants.OK;
		
        try {
			List<Opportunity> lstOpp = [SELECT Id,StageName,Indicaciones_ejecutivo_sales__c, Indicaciones_riesgo_sales__c,Motivo_rechazo_riesgo_sales__c,
                            fecha_ingreso_evalhipo_sales__c,numero_de_operacion_sales__c,recordTypeId,motivo_reingreso_sales__c
                            FROM Opportunity WHERE Id =: oppId LIMIT 1];
            
            if (profile.equalsIgnoreCase(Constants.PROFILE_EJECUTIVO_ESPECIALISTA)) {
                lstOpp[0].StageName = Constants.HIPOTECARIO_STATUS_CONTACTO;
                lstOpp[0].SyncedQuoteId=Null ;
                lstOpp[0].flag_banca_quote_sync_sales__c = false;
                lstOpp[0].Indicaciones_ejecutivo_sales__c = obs;
                lstOpp[0].motivo_reingreso_sales__c = action;
                lstOpp[0].notificacion_evaluacion_sales__c  = Constants.NOTIFICACION_RECHAZO_ESPECIALISTA;
                
                if (Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(lstOpp[0].recordTypeId).
                    getDeveloperName().equals(Constants.RECORDTYPE_BANCA_HIPOTECARIO_LECTURA) ||
                    Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(lstOpp[0].recordTypeId).
                    getDeveloperName().equals(Constants.RECORDTYPE_BANCA_HIPOTECARIO)){

                    rcdType = [SELECT Id,Name FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_BANCA_HIPOTECARIO LIMIT 1].Id;
                } else if(Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(lstOpp[0].recordTypeId).
                    getDeveloperName().equals(Constants.RECORDTYPE_BANCA_PLAN_PLUS_LECTURA) ||
                    Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(lstOpp[0].recordTypeId).
                    getDeveloperName().equals(Constants.RECORDTYPE_BANCA_PLAN_PLUS_LECTURA)){
                    
                    rcdType = [SELECT Id, Name FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_BANCA_PLAN_PLUS LIMIT 1].Id;
                }
                
                lstOpp[0].RecordtypeId = rcdType;
            } else {
                lstOpp[0].Aprobacion_Riesgo_sales__c = Constants.APROBADO_RIESGO_EN_PROCESO;
                lstOpp[0].Indicaciones_ejecutivo_sales__c = obs; 
                lstOpp[0].notificacion_evaluacion_sales__c  = Constants.NOTIFICACION_RECHAZO_RIESGO;
            }
            
            update lstOpp;
        } catch(Exception ex) {
            
            response = Constants.NOK;
        }

        return response;
    }

    
    private static List<ReasonRejection> getReason(){
        List<ReasonRejection> lstData = new List<ReasonRejection>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Motivo_rechazo_riesgo_sales__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry value : values) {
            ReasonRejection data = new ReasonRejection();
            data.label = value.getLabel();
            data.value = value.getValue();
            lstData.add(data);
        }

        return lstdata;
    }
    
  
    private static List<ReasonRejection> getActions(){
        List<ReasonRejection> lstData = new List<ReasonRejection>();
        Schema.DescribeFieldResult fieldResult = Opportunity.motivo_reingreso_sales__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        
        for ( Schema.PicklistEntry value : values) {
            ReasonRejection data = new ReasonRejection();
            data.label = value.getLabel();
            data.value = value.getValue();
            lstData.add(data);
        }

        return lstdata;
    }
    
    
    @AuraEnabled
    public static String stageApprovalManager(String oppId) {
        try {
            Opportunity opp = [SELECT Id, Motivo_otro_sales__c, aprobacion_visado_sales__c FROM Opportunity WHERE Id =: oppId];
        	opp.Motivo_otro_sales__c = '';
        	opp.aprobacion_visado_sales__c = '';
        	update opp;
        	
            return OpportunityDocsController.sendToValidate(oppId);
        }
        catch (Exception e) {
            
            return CONSTANTS.NOOK;
        }
    }
    
    
    @AuraEnabled
    public static void stageRejectManager(Id oppId, String motivo) {
        Opportunity opp = [SELECT Id, Motivo_otro_sales__c, aprobacion_visado_sales__c FROM Opportunity WHERE Id =: oppId];
        opp.Motivo_otro_sales__c = motivo;
        opp.aprobacion_visado_sales__c = Constants.APROBADO_RIESGO_RECHAZADO;
        update opp;
    }

    public class ReasonRejection{
        @AuraEnabled public String label{get;set;}
        @AuraEnabled public String value{get;set;}
    }
    
    
    @AuraEnabled
    public static String sendToApproveManager(String oppId) {
        Opportunity opp = [SELECT Id, aprobacion_visado_sales__c, RecordType.DeveloperName, StageName FROM Opportunity WHERE Id =: oppId];
        opp.StageName = CONSTANTS.HIPOTECARIO_STATUS_EVALUACION;
        
        opp.aprobacion_visado_sales__c = Constants.APROBADO_RIESGO_APROBADO;
        opp.Aprobacion_Riesgo_sales__c = Constants.APROBADO_RIESGO_EN_PROCESO;
        try{
            update opp;
             
        }catch(Exception ex){
        }
        return CONSTANTS.OK;     
    }
    
   
}