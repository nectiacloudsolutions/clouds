public class OpportunityDocFormHipoController {
    /*
* 
* @description       This method returns the values of an especific picklist
* @param1            String
* @param2            String
* @return            List<String>
* @throws            NA
*/
 public static List<String> getPickListValuesIntoList(String objectType, String selectedField) {
     List<String> pickListValuesList = new List<String>();
     Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
     Schema.DescribeSObjectResult res = convertToObj.getDescribe();
     Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
     
     List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
     
     for (Schema.PicklistEntry pickListVal : ple) {
         pickListValuesList.add(pickListVal.getLabel());
     }
     
     return pickListValuesList;
 }
 
 /*
* 
* @description       This method saves the documento_oportunidad_sales__c with the option selected  
* @param1            oppDocId
* @param2            value
* @return            String 
* @throws            NA
*/
 @AuraEnabled 
 public static String saveDoc(String oppDocId, String value) {   
     try {
         documento_oportunidad_sales__c oppDoc = new documento_oportunidad_sales__c(id = oppDocId,
                                                                                    estado_documento_sales__c = value);
         update oppDoc;                                                                               
         return CONSTANTS.OK;
     } catch(Exception e) {
         debugException(e);
         return CONSTANTS.NOK;
     }
 }
  /*
* 
* @description       This method query all the required 'documento_oportunidad_sales__c' for an opportunity in the 'Fomalización' Stage 
* @param1            id
* @return            List<documento_oportunidad_sales__c> 
* @throws            NA
*/
 public static  List<documento_oportunidad_sales__c> getDocId(Id id) { 
     List<documento_oportunidad_sales__c> lstDocOpp = [SELECT Id, Opportunity_sales__c, motivo_rechazo_sales__c, estado_documento_sales__c, Name,Aprobado_sales__c,
                                                       observaciones_sales__c, check_documento_sales__c, Participante_sales__c,Id_Alfresco_sales__c, detalle_documento_sales__c, 
                                                       Opportunity_sales__r.tipo_contrato_sales__c
                                                       FROM documento_oportunidad_sales__c 
                                                       WHERE Opportunity_sales__c =: id AND tipo_oportunidad_sales__c =: CONSTANTS.OPP_MDT_LABEL_HIPOTECARIO_FORMALIZACION
                                                       ORDER BY CreatedDate DESC];
     return lstDocOpp;
 } 
   /*
* 
* @description       This method return the necessary data for the doInit method 
* @param1            oppId
* @return            dataWrapper 
* @throws            NA
*/
 @AuraEnabled 
 public static dataWrapper getData(id oppId) {
     Opportunity opp = getOpportunity(oppId);
     dataWrapper dWrapper = new dataWrapper();
     Id idUser = UserInfo.getUserId();
     List<User> lstUser = [SELECT Id, Name, ManagerId, Profile.Name FROM User WHERE Id =: idUser];
     if((idUser == opp.OwnerId || idUser == opp.Owner.ManagerId) 
         && (opp.Owner.Profile.Name == CONSTANTS.PROFILE_EJECUTIVO_ESPECIALISTA 
            || opp.Owner.Profile.Name == CONSTANTS.PROFILE_EJECUTIVO_ATENCION_CLIENTE
            || opp.Owner.Profile.Name == CONSTANTS.PROFILE_JEFE_ATENCION_CLIENTE)){
             
         dWrapper.isPerfilEjecutivo = true;
     }else{
         dWrapper.isPerfilEjecutivo = false;

     }
     for(OpportunityTeamMember oppTeamMember : 
         [SELECT Id, TeamMemberRole, UserId, Name, User.ManagerId FROM OpportunityTeamMember 
          WHERE OpportunityId =: oppId]){
              
              if(oppTeamMember.TeamMemberRole.contains(CONSTANTS.OPPORTUNITY_MEMBER_APROBADOR_ACTUAL)){
                 // system.debug(oppTeamMember.Name);
                  if(oppTeamMember.UserID == idUser){
                      dWrapper.isPerfilPreVisado = true;
                  }
              }else if (oppTeamMember.TeamMemberRole.contains(CONSTANTS.OPPORTUNITY_MEMBER_JEFE) && oppTeamMember.UserId == idUser){
                  dWrapper.isPerfilVisador = true;
              }
          }     
     List<documento_oportunidad_sales__c> lstParticipantDocInsertBbdd = new List<documento_oportunidad_sales__c>();
     List<documento_oportunidad_sales__c> docExistentes = getDocId(opp.Id);
     List <Opp_Document_Type__mdt> oppDocuFOrms = [SELECT MasterLabel, orden_doc_sales__c 
                                                    FROM Opp_Document_Type__mdt 
                                                    WHERE tipo_oportunidad__c =:  Constants.OPP_MDT_LABEL_HIPOTECARIO_FORMALIZACION
                                                    ORDER BY orden_doc_sales__c ASC];
     if(docExistentes.isEmpty()){
         for (Opp_Document_Type__mdt docType : oppDocuFOrms) {
             String doc = docType.MasterLabel;
             documento_oportunidad_sales__c newDoc = new documento_oportunidad_sales__c();        
             newDoc.opportunity_sales__c = oppId;
             newDoc.Name = doc;
             newDoc.motivo_rechazo_sales__c = '';
             newDoc.estado_documento_sales__c = '';
             newDoc.tipo_oportunidad_sales__c = Constants.OPP_MDT_LABEL_HIPOTECARIO_FORMALIZACION;
             lstParticipantDocInsertBbdd.add(newDoc);
             
         }
         insert lstParticipantDocInsertBbdd;
         dWrapper.listaDocs =lstParticipantDocInsertBbdd;
     }else{
         dWrapper.listaDocs = docExistentes;           
     }
     
     /*if(dWrapper.isPerfilVisador || dWrapper.isPerfilPreVisado || dWrapper.isPerfilEjecutivo){
         dWrapper.viewCmpFile = true;
     }*/
     
     dWrapper.stagename= Opp.StageName;
     dWrapper.pickListMotivo = getPickListValuesIntoList('documento_oportunidad_sales__c', 'motivo_rechazo_sales__c');
     dWrapper.observacionesPreVisado = opp.Motivo_otro_sales__c;       
     dWrapper.estadoAprobacionPreVisado = opp.aprobacion_pre_visado_sales__c;  
     dWrapper.estadoAprobacionVisado = opp.aprobacion_visado_sales__c;
     //dWrapper.isPerfilVisador = false;
    // system.debug(dWrapper);
     return dWrapper;
 }
       /*
* 
* @description       This method returns the Opportunity
* @param1            id
* @return            Opportunity
* @throws            NA
*/
 public static Opportunity getOpportunity(Id id) { 
     List<Opportunity> lstOpp = [SELECT Id, RecordTypeId,RecordType.name, tipo_contrato_sales__c, Aprobacion_Riesgo_sales__c, ejecutivo_riesgo_sales__c,stageName, owner.Profile.Name,
                                 aprobacion_visado_sales__c, ejecutivo_visado_sales__c, Motivo_otro_sales__c, tipo_cliente_sales__c, owner.managerid, Numero_Op_Comercializadora_sales__c,
                                 aprobacion_pre_visado_sales__c
                                 FROM Opportunity WHERE Id =: id];
     if (lstOpp != null && !lstOpp.IsEmpty()) {
         return lstOpp[0];
     }
     return null;
 }
 /*
* @description       debug method
* @throws            NA
*/
 private static void debugException(Exception e) {
     System.debug('Exception: ' + e.getMessage());
     System.debug('Cause: ' + e.getCause());
     System.debug('Line: ' + e.getLineNumber());
     System.debug('Trace: ' + e.getStackTraceString());
 }
 
           /*
* 
* @description       This method inserts or updates an opportunityTeamMember (asigna un pre-visador) and updates the opportunity
* @param1            id
* @param2            id
* @return            NA
* @throws            NA
*/
/*
 @AuraEnabled
 public static void saveApproval(Id userId,Id recordId){
     Opportunity opp = getOpportunity(recordId);

     List<OpportunityTeamMember> listaPre = [SELECT Id, TeamMemberRole, UserId, User.ManagerId, Resultado_Evaluacion_Riesgo__c FROM OpportunityTeamMember 
                                             WHERE OpportunityId =: recordId AND TeamMemberRole LIKE :'%'+Constants.OPPORTUNITY_MEMBER_APROBADOR+'%'];
     if(listaPre.size()>0){
         List<OpportunityTeamMember> optmInsert = new List<OpportunityTeamMember>();
         
         for(OpportunityTeamMember  optm : listaPre){
          
                  if(optm.UserID == userId){
                       optm.TeamMemberRole = CONSTANTS.OPPORTUNITY_MEMBER_APROBADOR_ACTUAL;
                     optm.Resultado_Evaluacion_Riesgo__c = 'Igual';
                  }else{
                      optm.TeamMemberRole = CONSTANTS.OPPORTUNITY_MEMBER_APROBADOR;
                      OpportunityTeamMember oppTeamMember = new OpportunityTeamMember(TeamMemberRole = CONSTANTS.OPPORTUNITY_MEMBER_APROBADOR_ACTUAL, 
                                                                         UserId = userId,
                                                                         OpportunityId = recordId,
                                                                         OpportunityAccessLevel = 'Edit');
                      optmInsert.add(oppTeamMember);
                  }
                   
          }
         insert optmInsert;
         
        // listaPre[0].TeamMemberRole = CONSTANTS.OPPORTUNITY_MEMBER_APROBADOR;
         update listaPre;
     }else{
         OpportunityTeamMember oppTeamMember = new OpportunityTeamMember(TeamMemberRole = CONSTANTS.OPPORTUNITY_MEMBER_APROBADOR_ACTUAL, 
                                                                         UserId = userId,
                                                                         OpportunityId = recordId,
                                                                         OpportunityAccessLevel = 'Edit');
         insert oppTeamMember;    
     }

     opp.aprobacion_pre_visado_sales__c = Constants.APROBADO_RIESGO_EN_PROCESO;     

     try{
         update opp;
     }catch(Exception e){
         system.debug(e.getMessage());
     }
     
 }*/
 
  /**
  * @description Apruebo Documentos Formalización para pre-visador, para flujo consumo (Etapa: Formalización)
  *//*
 @AuraEnabled
 public static String sendToApproveVisador(String oppId) {
     System.debug('ENTROOOOOOOO');
     List<user> userVis = new List<user>();
     Opportunity opp = [SELECT Id, aprobacion_pre_visado_sales__c, StageName FROM Opportunity WHERE Id =: oppId];
     opp.aprobacion_pre_visado_sales__c = Constants.APROBADO_RIESGO_APROBADO;
     opp.aprobacion_visado_sales__c = CONSTANTS.APROBADO_RIESGO_EN_PROCESO;
     opp.StageName = CONSTANTS.OPPORTUNITY_STAGENAME_CURSE;
     Map<String, String> mapsUserApprov= new Map<String, String>();          
     for (ProfileApprovBank__c App : [SELECT Name,Rut__c FROM ProfileApprovBank__c]){
         mapsUserApprov.put(App.name,App.rut__c);
     }
     userVis = [SELECT Id, Name, FirstName, LastName FROM User WHERE Rut__c =: mapsUserApprov.get('Ejecutivo de Visado')  AND isActive = true LIMIT 1];
     
     OpportunityTeamMember oppTeamMember = new OpportunityTeamMember(TeamMemberRole = CONSTANTS.TEAM_ROL_JEVE_DE_VISADO, 
                                                                     UserId = userVis[0].id,
                                                                     OpportunityId = oppId,
                                                                     OpportunityAccessLevel = 'Edit');
     upsert oppTeamMember; 
     try{   
     //ssList<User> usrResponsable = [SELECT Id, FirstName, LastName FROM User Where Id =: userVis[0].id];
         opp.Jefe_Visado__c = userVis[0].Id;
        // opp.Jefe_Visado__r = userVis[0];
         
         // opp.Jefe_Visador__c = userVis[0].FirstName + ' '+userVis[0].LastName;
         update opp; 
        // system.debug(opp); 
        // 
     }catch(Exception ex){
         system.debug(ex.getMessage());
     }
     return CONSTANTS.OK;     
 }*/
 /**
* @description Rechazo Documentos Pre-Visado (Etapa: Formalización)
*/
 @AuraEnabled
 public static void stageRejectManager(Id oppId, String motivo) {
         Opportunity opp = [SELECT Id, Motivo_otro_sales__c, aprobacion_pre_visado_sales__c FROM Opportunity WHERE Id =: oppId];
         opp.Motivo_otro_sales__c = motivo;
         opp.aprobacion_pre_visado_sales__c = Constants.APROBADO_RIESGO_RECHAZADO;
         update opp;

 }
 
     /*
* 
* @description       This method save the documento_oportunidad_sales__c with the option selected for visador user
* @param1            oppDocId
* @param2            value
* @return            String 
* @throws            NA
*/
 @AuraEnabled 
 public static String saveAllDocs(List<documento_oportunidad_sales__c> docOppList) {
     System.debug('LISTA:' + docOppList);
     if (docOppList != null && !docOppList.isEmpty()) {
         for (documento_oportunidad_sales__c docOpp : docOppList) {
             if (docOpp.estado_documento_sales__c == CONSTANTS.APROBADO_RIESGO_APROBADO){
                 docOpp.Aprobado_sales__c = TRUE; 
                 docOpp.motivo_rechazo_sales__c = '';
                 docOpp.observaciones_sales__c = '';
             }
         }
     }
     
     try {
         update docOppList;
         return CONSTANTS.OK;
     } catch(Exception e) {
         debugException(e);
         return 'NO OK';
     }
 }
     /*
* 
* @description       This method changes the oportunity stage to "Formalización" or "Cerrada" depending on the Document's state            
* @param1            oppId
* @param2            decision
* @return            String 
* @throws            NA
*/
 /*
 @AuraEnabled 
 public static String visadoDecision(String oppId, String decision) {
     Opportunity opp = getOpportunity(oppId);
     List<RecordType> rt = new List<RecordType>();
     List<RecordType> rtValid = new List<RecordType>();
     
     try {
         rtValid = [SELECT DeveloperName FROM RecordType WHERE Id =: opp.RecordTypeId];
         
         if (rtValid[0].DeveloperName.equalsIgnoreCase(CONSTANTS.RECORDTYPE_BANCA_HIPOTECARIO)) {
             rt = [SELECT ID, DeveloperName FROM RecordType WHERE DeveloperName =: CONSTANTS.RECORDTYPE_BANCA_HIPOTECARIO_LECTURA];
         }else{
             rt = rtValid;
         }
         
         if (decision.equalsIgnoreCase(CONSTANTS.APROBADO_RIESGO_APROBADO)) {
             opp.aprobacion_visado_sales__c = CONSTANTS.APROBADO_RIESGO_APROBADO;
             // opp.StageName = CONSTANTS.OPPORTUNITY_STAGENAME_CIERRE_GANADA;
            // opp.RecordTypeId = rt[0].id;     
 
         } else if (decision.equalsIgnoreCase(CONSTANTS.APROBADO_RIESGO_RECHAZADO)) {
             opp.aprobacion_visado_sales__c = CONSTANTS.APROBADO_RIESGO_RECHAZADO;
             opp.StageName = CONSTANTS.OPPORTUNITY_STAGENAME_FORMALIZACION;
                opp.aprobacion_pre_visado_sales__c = CONSTANTS.APROBADO_RIESGO_RECHAZADO;
             
         }
         
         List<documento_oportunidad_sales__c> lstDocs = getDocId(oppId);
         
         List<documento_oportunidad_sales__c> lstDoctoUpdate = new List<documento_oportunidad_sales__c>();
         for(documento_oportunidad_sales__c docu : lstDocs){
             if(docu.estado_documento_sales__c == CONSTANTS.APROBADO_RIESGO_APROBADO ||
                docu.estado_documento_sales__c == CONSTANTS.SELECT_ESTADO_NO_APLICA){
                    docu.motivo_rechazo_sales__c = '';
                    docu.observaciones_sales__c = '';
                    docu.Aprobado_sales__c = TRUE; 
                  
                }else{
                    docu.Aprobado_sales__c = FALSE;
                }
             lstDoctoUpdate.add(docu);
         }
         
         
         update lstDoctoUpdate;
         update opp;
         return CONSTANTS.OK;
     } catch(Exception e) {
         debugException(e);
         return 'NO OK';
     }
 }*/
 
 
 /*
* @description       response class for the getData Method
* @throws            NA
*/
 public class dataWrapper {
     @AuraEnabled public string stageName;
     @AuraEnabled public string profile;//NO SE USA 
     @AuraEnabled public List<documento_oportunidad_sales__c> listaDocs;
     @AuraEnabled public List<string> pickListEstado;
     @AuraEnabled public List<string> pickListMotivo;
     @AuraEnabled public String estadoAprobacionPreVisado;
     @AuraEnabled public String estadoAprobacionVisado;
     @AuraEnabled public String observacionesPreVisado;
     @AuraEnabled public boolean isPerfilVisador = false;
     @AuraEnabled public boolean isPerfilEjecutivo = false;
     @AuraEnabled public boolean isPerfilPreVisado = false;
     @AuraEnabled public String isPerfilJefeVisador;// NO SE USA
     @AuraEnabled public boolean viewCmpFile = false;
 }   
 
}