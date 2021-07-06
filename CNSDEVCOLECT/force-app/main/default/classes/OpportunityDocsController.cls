public without sharing class OpportunityDocsController {
    

    public static  Map<Id, List<documento_oportunidad_sales__c>> getDocId(Id id) { 
        Map<Id, List<documento_oportunidad_sales__c>> mapIdDocumentos = new Map<Id, List<documento_oportunidad_sales__c>>();
        
        List<documento_oportunidad_sales__c> lstDocOpp = [SELECT Id, Opportunity_sales__c, motivo_rechazo_sales__c, estado_documento_sales__c, Name, 
                                                          observaciones_sales__c, check_documento_sales__c, Participante_sales__c, detalle_documento_sales__c, 
                                                          Opportunity_sales__r.tipo_contrato_sales__c,orden_doc_sales__c
                                                          FROM documento_oportunidad_sales__c 
                                                          WHERE Opportunity_sales__c =: id AND tipo_oportunidad_sales__c = ''
                                                          ORDER BY CreatedDate ASC];
        
       
        List<documento_oportunidad_sales__c> newlistdoc1 = new List<documento_oportunidad_sales__c>();
        mapIdDocumentos.put(null, newlistdoc1);
        
      
        List<participante_sales__c> lstParticipant = getParticipantId(id);
        
        if (lstParticipant != null && !lstParticipant.isEmpty()) {
            for (participante_sales__c prt : lstParticipant) {
                List<documento_oportunidad_sales__c> newlistdoc = new List<documento_oportunidad_sales__c>();
                mapIdDocumentos.put(prt.Id, newlistdoc);
            }
        }
        
     
        for (documento_oportunidad_sales__c doc : lstDocOpp) {
            if (mapIdDocumentos.get(doc.Participante_sales__c) != null) {
                    
                    mapIdDocumentos.get(doc.Participante_sales__c).add(doc);
                }
        }
        
        return mapIdDocumentos;
    } 
  
    @AuraEnabled
    public static List<aditionalDocument__c> getValuesDocumentClient() {
        List<aditionalDocument__c> lst = [SELECT Id, Name FROM aditionalDocument__c];
        return lst;
    }

    public static List<participante_sales__c> getParticipantId(Id id) {
     
        List<participante_sales__c> lstParticipantOpp = [SELECT estado_participante_sales__c, opportunity_participante_sales__c,Name
                                                         FROM participante_sales__c 
                                                         WHERE opportunity_participante_sales__r.Id =: id AND estado_participante_sales__c = 'Vigente'];
        
        if (lstParticipantOpp != null && !lstParticipantOpp.IsEmpty()) {
            return lstParticipantOpp;
        }
        return null;
    }   
    
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
    
   
    @AuraEnabled 
    public static dataWrapper getData(id oppId) {
       
        boolean isNewOpp = false;
        boolean isPlanPlusDependiente = false;
        boolean isPlanPlusIndependiente = false;
        boolean isPlanPlusPensionado = false;
        boolean isPlanPlus = false;
      
        boolean isConsumoDependiente = false;
        boolean isConsumoIndependiente = false;
        boolean isConsumoClienteSocio = false;
        boolean isConsumoClienteRentista = false;
        
        List<documento_oportunidad_sales__c> lstParticipantDocInsertBbdd = new List<documento_oportunidad_sales__c>();
        dataWrapper dWrapper = new dataWrapper();
        dWrapper.isPerfilVisado = Constants.NOK;
        dWrapper.isPerfilRiesgo = Constants.NOK;
        dWrapper.isPerfilJefeVisador = Constants.NOK;
        
        
        List<participante_sales__c> lstParticipant = getParticipantId(oppId);
        
        opportunity opp = getOpportunity(oppId);
        if(opp.aprobacion_visado_sales__c == '' || opp.aprobacion_visado_sales__c == null){
            dWrapper.estadoAprobacionVisado = CONSTANTS.NOK;
        }else if(opp.aprobacion_visado_sales__c == CONSTANTS.SELECT_ESTADO_RECHAZADO){
            dWrapper.estadoAprobacionVisado = CONSTANTS.SELECT_ESTADO_RECHAZADO;
        }else if(opp.aprobacion_visado_sales__c == CONSTANTS.APROBADO_RIESGO_EN_PROCESO){
            dWrapper.estadoAprobacionVisado = CONSTANTS.APROBADO_RIESGO_EN_PROCESO;
        }else if(opp.aprobacion_visado_sales__c == CONSTANTS.APROBADO_RIESGO_APROBADO){
            dWrapper.estadoAprobacionVisado = CONSTANTS.APROBADO_RIESGO_APROBADO;
        }
      
      
        
      
        Id idUser = UserInfo.getUserId();
        List<User> lstUser = [SELECT Id, Name, ManagerId, Profile.Name FROM User WHERE Id =: idUser];
       
        List<Map<String, Object>> outputList = new List<Map<String, Object>>();
        List<RecordType> rT = new List<RecordType>();
        
        if(lstUser[0].Profile.Name == CONSTANTS.PROFILE_EJECUTIVO_ATENCION_CLIENTE && opp.aprobacion_visado_sales__c != null){
            if(opp.aprobacion_visado_sales__c.equalsIgnoreCase(Constants.APROBADO_RIESGO_EN_PROCESO)){
                dWrapper.isPerfilVisado = Constants.OK;
            }
        }
        
   
        for(OpportunityTeamMember oppTeamMember : 
            [SELECT Id, TeamMemberRole, UserId, User.ManagerId FROM OpportunityTeamMember 
             WHERE OpportunityId =: oppId]){
                 if(oppTeamMember.TeamMemberRole.contains(Constants.OPPORTUNITY_MEMBER_REVISOR)){
                     if(oppTeamMember.UserID == idUser || oppTeamMember.User.ManagerId == idUser){
                         dWrapper.isPerfilVisado = Constants.OK;
                     }
                 }
                 if(oppTeamMember.TeamMemberRole.contains(Constants.OPPORTUNITY_MEMBER_RIESGO)){
                     if(oppTeamMember.UserID == idUser || oppTeamMember.User.ManagerId == idUser ){
                         dWrapper.isPerfilRiesgo = Constants.OK;
                     }
                 }
                 if(oppTeamMember.TeamMemberRole.contains(Constants.OPPORTUNITY_MEMBER_REVISION)){
                     if(oppTeamMember.UserID == idUser || oppTeamMember.User.ManagerId == idUser){
                         dWrapper.isPerfilJefeVisador = Constants.OK;
                     }
                 }
                 
             }

        Map<Id, List<documento_oportunidad_sales__c>> mapIdLstDoc = getDocId(oppId); 
        
     
        for (Id partId : mapIdLstDoc.keySet()) {
             if(mapIdLstDoc.get(partId).size() == 0) isNewOpp = true;
        }

   
        if (opp != null) {
            rT = [SELECT Id, DeveloperName FROM RecordType WHERE id =: opp.recordtypeid];
            dWrapper.rtName = rt[0].DeveloperName;
            if (opp.Aprobacion_Riesgo_sales__c != null) {
                dWrapper.estadoAprobacionRiesgo = opp.Aprobacion_Riesgo_sales__c;
            }
            else {
                dWrapper.estadoAprobacionRiesgo = '';
            }
            
            if (opp.aprobacion_visado_sales__c != null) {
                dWrapper.estadoAprobacionJefatura = opp.aprobacion_visado_sales__c;
            }
            else {
                dWrapper.estadoAprobacionJefatura = '';
            }
        }
        
        List<Opp_Document_Type__mdt> indeBoletaplanplus = new List<Opp_Document_Type__mdt>();
         indeBoletaplanplus = [SELECT MasterLabel,orden_doc_sales__c FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: Constants.OPP_MDT_PICK_PLAN_PLUS_IND];
        
        List<Opp_Document_Type__mdt> indeEmpres = new List<Opp_Document_Type__mdt>();
         indeEmpres = [SELECT MasterLabel,orden_doc_sales__c FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: Constants.OPP_MDT_PICK_PLAN_PLUS_INDEMP];
        
        List<Opp_Document_Type__mdt> depen = new List<Opp_Document_Type__mdt>();
         depen = [SELECT MasterLabel,orden_doc_sales__c FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: Constants.OPP_MDT_PICK_PLAN_PLUS_DEP];
        
        List<Opp_Document_Type__mdt> pensiona = new List<Opp_Document_Type__mdt>();
         pensiona = [SELECT MasterLabel,orden_doc_sales__c FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: Constants.OPP_MDT_PICK_PLAN_PLUS_PEN];
        
        List<Opp_Document_Type__mdt> rentista = new List<Opp_Document_Type__mdt>();
         rentista = [SELECT MasterLabel,orden_doc_sales__c FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: Constants.OPP_MDT_PICK_PLAN_PLUS_REN];
        
        
        List<Opp_Document_Type__mdt> docTypes = new List<Opp_Document_Type__mdt>();
        
        if (rT[0].DeveloperName == CONSTANTS.RECORDTYPE_BANCA_HIPOTECARIO || rT[0].DeveloperName == CONSTANTS.RECORDTYPE_BANCA_HIPOTECARIO_LECTURA) {
            
            docTypes = [SELECT MasterLabel,orden_doc_sales__c FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: Constants.OPP_STRING_HIPOTECARIO];
      
        } else if(rT[0].DeveloperName == CONSTANTS.RECORDTYPE_BANCA_PLAN_PLUS || rT[0].DeveloperName == CONSTANTS.RECORDTYPE_BANCA_PLAN_PLUS_LECTURA) {
            isPlanPlus = true;
            docTypes = [SELECT MasterLabel,orden_doc_sales__c FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: Constants.PLAN_PLUS ]; 

            
            if (opp.tipo_contrato_sales__c == Constants.OPP_CONTRACT_TYPE_INDEPEN_BOLETA) {            
                if (indeBoletaplanplus != null) {
                    docTypes.addall(indeBoletaplanplus);
                
                }
            }else if(opp.tipo_contrato_sales__c == Constants.OPP_CONTRACT_TYPE_INDEPEN_SOCIOEMP){
                if (indeEmpres != null) {
                    docTypes.addall(indeEmpres);
                 
                }
            }else if (opp.tipo_contrato_sales__c == Constants.OPP_CONTRACT_TYPE_DEPENDIENTE || (opp.tipo_contrato_sales__c == null || opp.tipo_contrato_sales__c == '')) {
                if (depen != null) {
                    docTypes.addall(depen);
                }
            }
            else if (opp.tipo_contrato_sales__c == Constants.OPP_CONTRACT_TYPE_PENSIONADO) {
                if (pensiona != null) {
                    docTypes.addall(pensiona);
                }
            }else if(opp.tipo_contrato_sales__c == Constants.OPP_CONTRACT_TYPE_RENTISTA){
                if (rentista != null) {
                    docTypes.addall(rentista);
                }
            }
        } else if(rT[0].DeveloperName == CONSTANTS.RECORDTYPE_BANCA_CREDITO_CONSUMO || 
                  rT[0].DeveloperName == CONSTANTS.RECORDTYPE_BANCA_CREDITO_CONSUMO_LECTURA) {
                      isPlanPlus = true;
                      docTypes = getDocTypesCreditoConsumo(opp);
                  }
        
        Map<Id, String> mapIdNameParticipant = new Map<Id, String>();
   
        List<String> pickListEsp = new List<String>{Constants.SELECT_ESTADO_INGRESADO};
        List<String> pickList = new List<String>{Constants.SELECT_ESTADO_INGRESADO};    
            
        dWrapper.pickListEstado = getPickListValuesIntoList(Constants.OPP_FIELDS_DOC_OP, Constants.OPP_FIELDS_DOC_ESTADO);
        dWrapper.pickListMotivo = getPickListValuesIntoList(Constants.OPP_FIELDS_DOC_OP, Constants.OPP_FIELDS_DOC_MOTIVO);
        
        List<Profile> currentProfile = [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId()];
        List<Opportunity> oppData = [SELECT Id, StageName, OwnerId FROM Opportunity WHERE Id =: oppId];

        if (oppData != null && !oppData.isEmpty()) {
            dWrapper.stageName = oppData[0].stageName;
        }
        if (currentProfile != null && !currentProfile.isEmpty()) {
            
            if (currentProfile[0].name == Constants.PROFILE_EJECUTIVO_VISADO) {
                dWrapper.isPerfilVisado = Constants.OK;
            }
            
            dWrapper.profile = currentProfile[0].name;
            dWrapper.isPerfilEspecialista = getAccessPerfilEspecialista(currentProfile[0].name);
            
            
           
         
            if (dWrapper.isPerfilEspecialista ==Constants.OK && oppData != null && !oppData.isEmpty() &&
               oppData[0].stageName == CONSTANTS.HIPOTECARIO_STATUS_RECOPILACION) {
                    dWrapper.pickListEstado = pickList;
                }
            else if(dWrapper.isPerfilEspecialista ==Constants.OK && oppData != null && !oppData.isEmpty() &&
                   oppData[0].stageName == CONSTANTS.HIPOTECARIO_STATUS_CONTACTO){
                   dWrapper.pickListEstado = pickListEsp;
            }

        }

        if (lstParticipant != null && !lstParticipant.IsEmpty()) {
            for (participante_sales__c par : lstParticipant) {
                mapIdNameParticipant.put(par.Id, par.Name);
            }
        }

        for (Id partId : mapIdLstDoc.keySet()) {
            for (Opp_Document_Type__mdt docType : docTypes) {
                String doc = docType.MasterLabel;
                Decimal numSort = docType.orden_doc_sales__c;
                boolean create = true;
                
                List<documento_oportunidad_sales__c> partActualDocs = mapIdLstDoc.get(partId);
                
                if (partActualDocs != null && !partActualDocs.isEmpty()) {
                    for (documento_oportunidad_sales__c actualDocPart : partActualDocs) {
                        if (actualDocPart.Name == doc) {
                            create = false;
                        }
                
                        if (actualDocPart.opportunity_sales__c == null) actualDocPart.opportunity_sales__c = oppId;
                        if (actualDocPart.motivo_rechazo_sales__c == null) actualDocPart.motivo_rechazo_sales__c = '';
                        if (actualDocPart.estado_documento_sales__c == null) actualDocPart.estado_documento_sales__c = '';
                    }
                }
                
           
                if (create && isNewOpp) {
                    documento_oportunidad_sales__c newDocc = new documento_oportunidad_sales__c();
                    newDocc.Participante_sales__c = partId;
                    newDocc.opportunity_sales__c = oppId;
                    newDocc.Name = doc;        
                    newDocc.orden_doc_sales__c = numSort;
                    newDocc.motivo_rechazo_sales__c = '';
                    newDocc.estado_documento_sales__c = '';       
                    if(doc == CONSTANTS.DOC_CON_RENTIS_CONTRATOARR){

                        newDocc.detalle_documento_sales__c = CONSTANTS.DOC_CON_REN_TOOLTIP_CONTRATOARR;
                    }else if(doc==Constants.DOC_PLAN_INDEPENDINTE_BOLETA){
                        newDocc.detalle_documento_sales__c = Constants.DOC_PLAN_PLUS_TOOTIL_INDEPEN_BOL;
                    }else if(doc== Constants.DOC_PLAN_INDEPENDIENTE_EMPRESA){
                        newDocc.detalle_documento_sales__c = Constants.DOC_PLAN_PLUS_TOOLTI_EMPRESA;
                    }else if(doc == Constants.DOC_PLAN_RENTISTA_ACRE_SIN_DEUDA){
                        newDocc.detalle_documento_sales__c = Constants.DOC_PLAN_PLUS_TOOLTIP_RENTIS_ACRESIN;
                    }else if(doc == Constants.DOC_PLAN_RENTISTA_ACRE_CON_DEUDA){
                        newDocc.detalle_documento_sales__c = Constants.DOC_PLAN_PLUS_TOOLTIP_RENTIS_ACRECRON;
                    }else if(doc == Constants.DOC_PLAN_RENTISTA_3MESES){
                        newDocc.detalle_documento_sales__c = Constants.DOC_PLAN_PLUS_TOOLTIP_RENTIS_3MESES;
                    }else if(doc == Constants.DOC_PLAN_RENTISTA_CONTRATO_ARR){
                        newDocc.detalle_documento_sales__c = Constants.DOC_PLAN_PLUS_TOOLTIP_RENTIS_CONTRA;
                    }
                    lstParticipantDocInsertBbdd.add(newDocc);  
                } else if (create && isPlanPlus) { 
                    documento_oportunidad_sales__c newDoc = new documento_oportunidad_sales__c();
                    newDoc.Participante_sales__c = partId;
                    newDoc.opportunity_sales__c = oppId;
                    newDoc.Name = doc;
                    newDoc.orden_doc_sales__c = numSort;
                    newDoc.motivo_rechazo_sales__c = '';
                    newDoc.estado_documento_sales__c = '';
                    if(doc==Constants.DOC_PLAN_INDEPENDINTE_BOLETA && opp.tipo_contrato_sales__c == Constants.OPP_CONTRACT_TYPE_INDEPEN_BOLETA){
                        newDoc.detalle_documento_sales__c = Constants.DOC_PLAN_PLUS_TOOTIL_INDEPEN_BOL;
                     
                    }else if(doc== Constants.DOC_PLAN_INDEPENDIENTE_EMPRESA && opp.tipo_contrato_sales__c == Constants.OPP_CONTRACT_TYPE_INDEPEN_SOCIOEMP){
                        newDoc.detalle_documento_sales__c = Constants.DOC_PLAN_PLUS_TOOLTI_EMPRESA;
                
                    }else if(doc == Constants.DOC_PLAN_RENTISTA_ACRE_SIN_DEUDA && opp.tipo_contrato_sales__c == Constants.OPP_CONTRACT_TYPE_RENTISTA){
                        newDoc.detalle_documento_sales__c = Constants.DOC_PLAN_PLUS_TOOLTIP_RENTIS_ACRESIN;
                    }else if (doc == Constants.DOC_PLAN_RENTISTA_ACRE_CON_DEUDA && opp.tipo_contrato_sales__c == Constants.OPP_CONTRACT_TYPE_RENTISTA){
                        newDoc.detalle_documento_sales__c = Constants.DOC_PLAN_PLUS_TOOLTIP_RENTIS_ACRECRON;
                    }else if(doc == Constants.DOC_PLAN_RENTISTA_3MESES && opp.tipo_contrato_sales__c == Constants.OPP_CONTRACT_TYPE_RENTISTA){
                        newDoc.detalle_documento_sales__c = Constants.DOC_PLAN_PLUS_TOOLTIP_RENTIS_3MESES;
                    }else if(doc == Constants.DOC_PLAN_RENTISTA_CONTRATO_ARR && opp.tipo_contrato_sales__c == Constants.OPP_CONTRACT_TYPE_RENTISTA){
                        newDoc.detalle_documento_sales__c = Constants.DOC_PLAN_PLUS_TOOLTIP_RENTIS_CONTRA;
                    }
                    lstParticipantDocInsertBbdd.add(newDoc);
                    
                }           
            }
        }
        
        if (lstParticipantDocInsertBbdd.size() > 0) {
            insert lstParticipantDocInsertBbdd;
            mapIdLstDoc = getDocId(oppId);
            
            for (Id partId : mapIdLstDoc.keySet()) {
                List<documento_oportunidad_sales__c> partDocs = mapIdLstDoc.get(partId);
                
                if (partDocs != null && !partDocs.isEmpty()) {
                    for (documento_oportunidad_sales__c docPart : partDocs) {
                       
                        if (docPart.estado_documento_sales__c == null) {
                            docPart.estado_documento_sales__c = '';
                        }
                        
                        if (docPart.motivo_rechazo_sales__c == null) {
                            docPart.motivo_rechazo_sales__c = '';
                        }
                    }
                }
            }
        }
       
        List<documento_oportunidad_sales__c> docsToDelete = new List<documento_oportunidad_sales__c>();
        mapIdLstDoc = getDocId(oppId);

        for (Id partId : mapIdLstDoc.keySet()) {
            
            List<documento_oportunidad_sales__c> partActualDocs = mapIdLstDoc.get(partId);
            if (partActualDocs != null && !partActualDocs.isEmpty()) {
               
                for (documento_oportunidad_sales__c actualDocPart : partActualDocs) {
                    boolean toDelete = true;
                   
                    for (Opp_Document_Type__mdt docType : docTypes) {
                        if (actualDocPart.Name == docType.MasterLabel || !String.isEmpty(actualDocPart.detalle_documento_sales__c)){
                            toDelete = false;
                        }
                    }
                    if(opp.tipo_contrato_sales__c != Constants.OPP_CONTRACT_TYPE_INDEPEN_BOLETA ){
                       
                        if(actualDocPart.Name == Constants.DOC_PLAN_INDEPENDINTE_BOLETA){
                            docsToDelete.add(actualDocPart);
                        }
                    }
                    if(opp.tipo_contrato_sales__c != Constants.OPP_CONTRACT_TYPE_INDEPEN_SOCIOEMP){
                      
                        if(actualDocPart.Name == Constants.DOC_PLAN_INDEPENDIENTE_EMPRESA){
                            docsToDelete.add(actualDocPart);
                        }
                    } 
                    if(opp.tipo_contrato_sales__c != Constants.OPP_CONTRACT_TYPE_RENTISTA){
                        if(actualDocPart.Name == Constants.DOC_PLAN_RENTISTA_ACRE_SIN_DEUDA){
                            docsToDelete.add(actualDocPart);
                        }
                        if(actualDocPart.Name == Constants.DOC_PLAN_RENTISTA_ACRE_CON_DEUDA){
                            docsToDelete.add(actualDocPart);
                        }
                        if(actualDocPart.Name == Constants.DOC_PLAN_RENTISTA_3MESES){
                            docsToDelete.add(actualDocPart);
                        }
                        if(actualDocPart.Name == Constants.DOC_PLAN_RENTISTA_CONTRATO_ARR){
                            docsToDelete.add(actualDocPart);
                        }
                    }
                   
                    if(toDelete){
                        docsToDelete.add(actualDocPart);
                    }
                }
            }
        }
        if(!docsToDelete.isempty()){
            delete docsToDelete;
        }
        
        mapIdLstDoc = getDocId(oppId);
        for (Id partId: mapIdLstDoc.keyset()) {
            Map<String, Object> mapParticipant = new Map<String, Object>();
            
            List<documento_oportunidad_sales__c> tmpListSort = mapIdLstDoc.get(partId); 
            Integer n = tmpListSort.size();
            documento_oportunidad_sales__c temp = new documento_oportunidad_sales__c(); 
            
            for (Integer i = 0; i < n; i++) {
                for (Integer j = 1; j < (n-i); j++) {   
                   
                    if ((Decimal)tmpListSort[j-1].get(Constants.OPP_FIELDS_DOC_ORDEN) > (Decimal)tmpListSort[j].get(Constants.OPP_FIELDS_DOC_ORDEN)) {   
                        temp = tmpListSort[j-1];
                        tmpListSort[j-1] = tmpListSort[j];
                        tmpListSort[j] = temp;
                    }            
                }
            }
            
     
            
            mapParticipant.put('idParticipante', partId);
            mapParticipant.put('nombre', mapIdNameParticipant.get(partId));
            mapParticipant.put('documentsList', tmpListSort);
            
            outputList.add(mapParticipant);
        }

   
        dWrapper.participantDoc = outputList;
        dWrapper.numPropuestaCom = opp.Numero_Op_Comercializadora_sales__c;
       
        
        return dWrapper;  
    }
    

    @AuraEnabled 
    public static String saveDoc(String oppDocId, String value) {

        
        try {
            documento_oportunidad_sales__c oppDoc = new documento_oportunidad_sales__c(id = oppDocId,
                                                                                       estado_documento_sales__c = value);
            update oppDoc;                                                                               
            return CONSTANTS.OK;
        } catch(Exception e) {
            debugException(e);
            return Constants.NOOK;
        }
    }
    

    @AuraEnabled 
    public static String saveAllDocs(List<documento_oportunidad_sales__c> docOppList) {
        if (docOppList != null && !docOppList.isEmpty()) {
            for (documento_oportunidad_sales__c docOpp : docOppList) {
         
                if (docOpp.estado_documento_sales__c == CONSTANTS.APROBADO_RIESGO_APROBADO){
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
            return Constants.NOOK;
        }
    }
    
  
    @AuraEnabled 
    public static String sendToValidate(String oppId) {
        List<user> userRisk = new List<user>();
        List<user> userVis = new List<user>();
        
        Opportunity oppValid = getOpportunity(oppId);
        Opportunity opp;
        
        List<OpportunityTeamMember> oppTeamList = new List<OpportunityTeamMember>();
        List<RecordType> rt = new List<RecordType>();
        List<RecordType> rtValid = new List<RecordType>();
        
        String res = CONSTANTS.OK;
        
        try {
            rtValid = [SELECT DeveloperName FROM RecordType WHERE Id =: oppValid.RecordTypeId];

            
            if (rtValid[0].DeveloperName.contains(CONSTANTS.RECORDTYPE_BANCA_HIPOTECARIO) || rtValid[0].DeveloperName.contains(CONSTANTS.RECORDTYPE_BANCA_HIPOTECARIO_LECTURA)) {
           
                rt = [SELECT ID, DeveloperName FROM RecordType WHERE DeveloperName =: CONSTANTS.RECORDTYPE_BANCA_HIPOTECARIO_LECTURA];
            } else if(rtValid[0].DeveloperName.equalsIgnoreCase(CONSTANTS.RECORDTYPE_BANCA_PLAN_PLUS) || rtValid[0].DeveloperName.equalsIgnoreCase(CONSTANTS.RECORDTYPE_BANCA_PLAN_PLUS_LECTURA)) {
           
                rt = [SELECT ID, DeveloperName FROM RecordType WHERE DeveloperName =: CONSTANTS.RECORDTYPE_BANCA_PLAN_PLUS_LECTURA];
            }
            
            if (rt != null && !rt.isEmpty()) {
                Map<String, String> mapsUserApprov= new Map<String, String>();
                
                for (ProfileApprovBank__c App : [SELECT Name,Rut__c FROM ProfileApprovBank__c]){
                    mapsUserApprov.put(App.name,App.rut__c);
                }
                userVis = [SELECT Id, Name FROM User WHERE Rut__c =: mapsUserApprov.get(Constants.PROFILE_EJECUTIVO_VISADO)  AND isActive = true LIMIT 1];
                userRisk = [SELECT Id, Name FROM User WHERE Rut__c =: mapsUserApprov.get(Constants.PROFILE_EJECUTIVO_DE_RIESGO)  AND isActive = true LIMIT 1];

                opp = new Opportunity(id = oppId, 
                                      aprobacion_visado_sales__c = CONSTANTS.APROBADO_RIESGO_EN_PROCESO, 
                                      StageName = CONSTANTS.HIPOTECARIO_STATUS_VISADO,
                                      ejecutivo_riesgo_sales__c = userRisk[0].id,
                                      ejecutivo_visado_sales__c = userVis[0].id,
                                      RecordTypeId = rt[0].id);
                
                if (userVis != null && !userVis.isEmpty()) {
                    OpportunityTeamMember oppTeamMemberVis = new OpportunityTeamMember(TeamMemberRole = CONSTANTS.TEAM_ROL_ASIGNADOR_VISADO, 
                                                                                       UserId = userVis[0].id,
                                                                                       OpportunityId = oppId,
                                                                                       OpportunityAccessLevel = Constants.OPPORTUNITY_TEAM_ACCESS_EDIT);
                    oppTeamList.add(oppTeamMemberVis);
                }
                
                if (userRisk != null && !userRisk.isEmpty()) {
                    OpportunityTeamMember oppTeamMemberRisk = new OpportunityTeamMember(TeamMemberRole = CONSTANTS.TEAM_ROL_ASIGNADOR_RIESGO, 
                                                                                        UserId = userRisk[0].id,
                                                                                        OpportunityId = oppId,
                                                                                        OpportunityAccessLevel = Constants.OPPORTUNITY_TEAM_ACCESS_EDIT);
                    oppTeamList.add(oppTeamMemberRisk);
                } else {
               
                    res = Constants.NOOK;
                }
            } else {
               
                res = Constants.NOOK;
            }
            
            if (oppTeamList != null && !oppTeamList.isEmpty() && res == 'OK') {
                insert oppTeamList;
                update opp;
            }
            
            return res;
        } catch(Exception e) {
            debugException(e);
            if(e.getMessage().contains(Constants.COMERCIALIZADOR)){
                return Constants.ERRA01;
            }else if(e.getMessage().contains(Constants.OPP_FIELDS_NUM_SOL)){
                return Constants.ERRA02;
            }else if(e.getMessage().contains(Constants.OPP_FIELDS_NUM_OPP_PCH)){
                return Constants.ERRA03;
            }else if(e.getMessage().contains(Constants.RV_CONTRATO)){
                return Constants.ERRA04;
            }
            return Constants.NOOK;
        }
    }
    
    @AuraEnabled 
    public static String visadoDecision(String oppId, String decision) {
        Opportunity opp = getOpportunity(oppId);
        List<RecordType> rt = new List<RecordType>();
        List<RecordType> rtValid = new List<RecordType>();
        
        try {
            rtValid = [SELECT DeveloperName FROM RecordType WHERE Id =: opp.RecordTypeId];
          
            if (rtValid[0].DeveloperName.equalsIgnoreCase(CONSTANTS.RECORDTYPE_BANCA_HIPOTECARIO_LECTURA) || rtValid[0].DeveloperName.contains(CONSTANTS.RECORDTYPE_BANCA_HIPOTECARIO)) {
                rt = [SELECT ID, DeveloperName FROM RecordType WHERE DeveloperName =: CONSTANTS.RECORDTYPE_BANCA_HIPOTECARIO];
            } else if (rtValid[0].DeveloperName.equalsIgnoreCase(CONSTANTS.RECORDTYPE_BANCA_PLAN_PLUS_LECTURA) || rtValid[0].DeveloperName.contains(CONSTANTS.RECORDTYPE_BANCA_PLAN_PLUS)) {
                rt = [SELECT ID, DeveloperName FROM RecordType WHERE DeveloperName =: CONSTANTS.RECORDTYPE_BANCA_PLAN_PLUS];
            } else if (rtValid[0].DeveloperName.equalsIgnoreCase(CONSTANTS.RECORDTYPE_BANCA_CREDITO_CONSUMO_LECTURA) || rtValid[0].DeveloperName.contains(CONSTANTS.RECORDTYPE_BANCA_CREDITO_CONSUMO)) {
                rt = [SELECT ID, DeveloperName FROM RecordType WHERE DeveloperName =: CONSTANTS.RECORDTYPE_BANCA_CREDITO_CONSUMO];
            }
            
            
            if (decision.equalsIgnoreCase(CONSTANTS.APROBADO_RIESGO_APROBADO)) {
                opp.aprobacion_visado_sales__c = CONSTANTS.APROBADO_RIESGO_APROBADO;
                opp.StageName = CONSTANTS.HIPOTECARIO_STATUS_EVALUACION;
                opp.Aprobacion_Riesgo_sales__c = CONSTANTS.APROBADO_RIESGO_EN_PROCESO;
            } else if (decision.equalsIgnoreCase(CONSTANTS.APROBADO_RIESGO_RECHAZADO)) {
                opp.aprobacion_visado_sales__c = CONSTANTS.APROBADO_RIESGO_RECHAZADO;
                opp.StageName = CONSTANTS.HIPOTECARIO_STATUS_RECOPILACION;
                opp.RecordTypeId = rt[0].id;
            }
            
            Map<Id, List<documento_oportunidad_sales__c>> mapIdLstDoc = getDocId(oppId);
            List<documento_oportunidad_sales__c> lstDoctoUpdate = new List<documento_oportunidad_sales__c>();
            
            for (Id partId : mapIdLstDoc.keySet()) {
                for (documento_oportunidad_sales__c docParticipante : mapIdLstDoc.get(partId)) {
                    if (docParticipante.estado_documento_sales__c == CONSTANTS.APROBADO_RIESGO_APROBADO || 
                        docParticipante.estado_documento_sales__c == CONSTANTS.SELECT_ESTADO_NO_APLICA){
                        docParticipante.check_documento_sales__c = true;
                        docParticipante.motivo_rechazo_sales__c = '';
                        docParticipante.observaciones_sales__c = '';
                    }
                    
                    lstDoctoUpdate.add(docParticipante);
                }
            }
            
            update lstDoctoUpdate;
            update opp;
            return CONSTANTS.OK;
        } catch(Exception e) {
            debugException(e);
            if(e.getMessage().contains(Constants.NUM_OP_COMERCIALIZA)){
                return Constants.ERRA01;
            }else if(e.getMessage().contains(Constants.OPP_FIELDS_NUM_SOL)){
                return Constants.ERRA02;
            }
            return Constants.NOOK;
        }
    }
    public static Opportunity getOpportunity(Id id) { 
        List<Opportunity> lstOpp = [SELECT Id, RecordTypeId,RecordType.name, tipo_contrato_sales__c, Aprobacion_Riesgo_sales__c, ejecutivo_riesgo_sales__c,
                                    aprobacion_visado_sales__c, ejecutivo_visado_sales__c, Motivo_otro_sales__c, tipo_cliente_sales__c, owner.managerid, Numero_Op_Comercializadora_sales__c
                                    FROM Opportunity WHERE Id =: id];
        if (lstOpp != null && !lstOpp.IsEmpty()) {
            return lstOpp[0];
        }
        return null;
    }
    
    @AuraEnabled
    public static void addNewDocumentType(String oppId, String name, String detail, String idParticipant) {
       
        List<documento_oportunidad_sales__c> docOppQuery = [SELECT Id, Name 
                                                            FROM documento_oportunidad_sales__c 
                                                            WHERE Name =: name AND Participante_sales__c =: idParticipant AND Opportunity_sales__c =: oppId AND tipo_oportunidad_sales__c = '' LIMIT 1];
        
        if (docOppQuery != null && !docOppQuery.isEmpty()) {
            throw new AuraHandledException(Constants.EXCEPTION_DOCUMENT);
        }
        
        List<documento_oportunidad_sales__c> documentsToInsert = new List<documento_oportunidad_sales__c>();
        
        documento_oportunidad_sales__c documentClient = new documento_oportunidad_sales__c(
            Opportunity_sales__c = oppId,
            Name = name,
            detalle_documento_sales__c = detail,
            Participante_sales__c = idParticipant
        );
        
        documentsToInsert.add(documentClient);        
        insert documentsToInsert;
    }
    
    @AuraEnabled 
    public static String sendToJefatura(String oppId) {
        try {
            List<RecordType> rt = new List<RecordType>();
            Opportunity opp = getOpportunity(oppId);
            Opportunity oppToSave;
            List<OpportunityTeamMember> oppTeamListToInsert = new List<OpportunityTeamMember>();
            List<RecordType> rtValid = [SELECT DeveloperName FROM RecordType WHERE Id =: opp.RecordTypeId];
            opp.aprobacion_visado_sales__c = CONSTANTS.APROBADO_RIESGO_EN_PROCESO;
            opp.Motivo_otro_sales__c = '';
            String res = CONSTANTS.OK;
            if (rtValid[0].DeveloperName.equalsIgnoreCase(CONSTANTS.RECORDTYPE_BANCA_HIPOTECARIO) || rtValid[0].DeveloperName.equalsIgnoreCase(CONSTANTS.RECORDTYPE_BANCA_HIPOTECARIO_LECTURA)) {
                rt = [SELECT ID, DeveloperName FROM RecordType WHERE DeveloperName =: CONSTANTS.RECORDTYPE_BANCA_HIPOTECARIO_LECTURA];
                opp.recordTypeId = rt[0].Id;
                update opp;
         
            } else if (rtValid[0].DeveloperName.equalsIgnoreCase(CONSTANTS.RECORDTYPE_BANCA_CREDITO_CONSUMO) || 
                       (rtValid[0].DeveloperName.equalsIgnoreCase(CONSTANTS.RECORDTYPE_BANCA_CREDITO_CONSUMO_LECTURA))) {
           
                rt = [SELECT ID, DeveloperName FROM RecordType WHERE DeveloperName =: CONSTANTS.RECORDTYPE_BANCA_CREDITO_CONSUMO_LECTURA];
                List<user> userRisk = new List<user>();
                Map<String, String> mapsUserApprov= new Map<String, String>();
                
                if (rt != null && !rt.isEmpty()) {
                   
                    for (ProfileApprovBank__c App : [SELECT Name,Rut__c FROM ProfileApprovBank__c]){
                        mapsUserApprov.put(App.name,App.rut__c);
                    }
                    userRisk = [SELECT Id, Name FROM User WHERE Rut__c =: mapsUserApprov.get(Constants.PROFILE_EJECUTIVO_DE_RIESGO)  AND isActive = true LIMIT 1];

                    oppToSave = new Opportunity(id = oppId, 
                                                aprobacion_visado_sales__c = CONSTANTS.APROBADO_RIESGO_EN_PROCESO, 
                                                ejecutivo_riesgo_sales__c = userRisk[0].id,
                                                RecordTypeId = rt[0].id);
                    if (userRisk != null && !userRisk.isEmpty() && !String.isEmpty(opp.owner.managerId)) {
                        OpportunityTeamMember oppTeamMemberRisk = new OpportunityTeamMember(TeamMemberRole = CONSTANTS.TEAM_ROL_ASIGNADOR_RIESGO, 
                                                                                            UserId = userRisk[0].id,
                                                                                            OpportunityId = oppId,
                                                                                            OpportunityAccessLevel = Constants.OPPORTUNITY_TEAM_ACCESS_EDIT);
                        oppTeamListToInsert.add(oppTeamMemberRisk);
                      
                        OpportunityTeamMember oppTeamMemberBoss = new OpportunityTeamMember(TeamMemberRole = Constants.OPPORTUNITY_MEMBER_REVISOR_DOCUMENTO, 
                                                                                            UserId = opp.owner.managerId,
                                                                                            OpportunityId = oppId,
                                                                                            OpportunityAccessLevel = Constants.OPPORTUNITY_TEAM_ACCESS_EDIT);
                        
                        oppTeamListToInsert.add(oppTeamMemberBoss);

                        insert oppTeamListToInsert;
                        update oppToSave;
                        res = CONSTANTS.OK;
                    } else {
                        res = CONSTANTS.NOK;
                    }
                }
            }
            return res;
        }catch(Exception e) {
            debugException(e);
            return Constants.NOOK;
        }
        
    }
   
    @AuraEnabled 
    public static String getAccessPerfilEspecialista(String perfil) {
       
        List<Functionality__c> func = [SELECT Id, Name FROM Functionality__c WHERE funcionalidad__c=: Constants.OPPORTUNITY_DOCS_EJECUTIVO_ESPECIALISTA
                                       and perfil__c =: perfil LIMIT 1];
      
        String retorno = Constants.NOOK;
        if (func.size()>0){
            retorno=CONSTANTS.OK; 
        }
        return retorno;
    }
    
    public static List<Opp_Document_Type__mdt> getDocTypesCreditoConsumo(Opportunity opp) {
        List<Opp_Document_Type__mdt> docTypes = new List<Opp_Document_Type__mdt>();
        
            docTypes = [SELECT MasterLabel,orden_doc_sales__c FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: Constants.OPP_MDT_LABEL_CONSUMO];
       
            switch on opp.tipo_cliente_sales__c {
                when 'Trabajador Independiente' {
                    docTypes.addAll([SELECT MasterLabel,orden_doc_sales__c FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: Constants.OPP_MDT_LABEL_CONSUMO_INDEPENDIENTE]);
                }
                when 'Trabajador Dependiente' {
                    docTypes.addAll([SELECT MasterLabel,orden_doc_sales__c FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: Constants.OPP_MDT_LABEL_CONSUMO_DEPENDIENTE]);
                }
                when 'Cliente Socio Empresa' {
                    docTypes.addAll([SELECT MasterLabel,orden_doc_sales__c FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: Constants.OPP_MDT_LABEL_CONSUMO_SOCIOEMPRESA]);
             
                }
                when 'Cliente Rentista' {
                    docTypes.addAll([SELECT MasterLabel,orden_doc_sales__c FROM Opp_Document_Type__mdt WHERE tipo_oportunidad__c =: Constants.OPP_MDT_LABEL_CONSUMO_RENTISTA]);
                }
            }
            return docTypes;
            
       
    }

    
    @AuraEnabled
    public static void stageRejectManager(Id oppId, String motivo) {
            Opportunity opp = [SELECT Id, Motivo_otro_sales__c, aprobacion_visado_sales__c FROM Opportunity WHERE Id =: oppId];
            opp.Motivo_otro_sales__c = motivo;
            opp.aprobacion_visado_sales__c = Constants.APROBADO_RIESGO_RECHAZADO;
            update opp;

    }
   
    @AuraEnabled
    public static String sendToApproveManager(String oppId) {
        Opportunity opp = [SELECT Id, aprobacion_visado_sales__c, StageName FROM Opportunity WHERE Id =: oppId];
        opp.StageName = CONSTANTS.HIPOTECARIO_STATUS_EVALUACION;
        opp.aprobacion_visado_sales__c = Constants.APROBADO_RIESGO_APROBADO;
        opp.Aprobacion_Riesgo_sales__c = Constants.APROBADO_RIESGO_EN_PROCESO;
        try{
            update opp;
             
        }catch(Exception ex){
            if(ex.getMessage().contains(Constants.OPP_FIELDS_NUM_SOL)){
                return Constants.ERRA02;
            }
           
        }
        return CONSTANTS.OK;     
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
    
    private static void debugException(Exception e) {
        System.debug('Exception: ' + e.getMessage());
        System.debug('Cause: ' + e.getCause());
        System.debug('Line: ' + e.getLineNumber());
        System.debug('Trace: ' + e.getStackTraceString());
    }
    
   
    @AuraEnabled
    public static String  setAllDocsStateTo(Id id,String estado) { 
        List<documento_oportunidad_sales__c> lstDocOpp = [SELECT Id, Opportunity_sales__c, motivo_rechazo_sales__c, estado_documento_sales__c, Name, 
                                                          observaciones_sales__c, check_documento_sales__c, Participante_sales__c, detalle_documento_sales__c, 
                                                          Opportunity_sales__r.tipo_contrato_sales__c
                                                          FROM documento_oportunidad_sales__c 
                                                          WHERE Opportunity_sales__c =: id AND tipo_oportunidad_sales__c = ''
                                                          ORDER BY CreatedDate DESC];
        List<documento_oportunidad_sales__c> lstDoctoUpdate = new List<documento_oportunidad_sales__c>();
        for (documento_oportunidad_sales__c docu : lstDocOpp) {
            if(docu.estado_documento_sales__c != CONSTANTS.SELECT_ESTADO_NO_APLICA){
                docu.estado_documento_sales__c = estado;
                lstDoctoUpdate.add(docu);     
            } 
        }    
     
        try{
            update lstDoctoUpdate;
        }catch(exception e){
            debugException(e);
            return CONSTANTS.NOK;
        }
        
        return CONSTANTS.OK;
    } 
    
   
    public class dataWrapper {
        @AuraEnabled public string rtName;
        @AuraEnabled public string stageName;
        @AuraEnabled public string profile;
        @AuraEnabled public List<Map<String, Object>> participantDoc;
        @AuraEnabled public List<string> pickListEstado;
        @AuraEnabled public List<string> pickListMotivo;
        @AuraEnabled public String estadoAprobacionRiesgo;
        @AuraEnabled public String estadoAprobacionJefatura;
        @AuraEnabled public String estadoAprobacionVisado;
        @AuraEnabled public String EjecutivoVisado;
        @AuraEnabled public String isPerfilVisado;
        @AuraEnabled public String isPerfilRiesgo;
        @AuraEnabled public String isPerfilEspecialista;
        @AuraEnabled public String isPerfilJefeVisador;
        @AuraEnabled public String numPropuestaCom;
    }   
    
}