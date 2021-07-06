public without sharing class AccountTriggerHelper {
    
    public static Set<Id> lstIds = new Set<Id>();
    
    public static void onAfterUpdate(List<Account> accLst, Map<Id,Account> oldMap){
        try{
            List<DTOCaseAnalytics.CaseTmp> lstCaseNotify = new List<DTOCaseAnalytics.CaseTmp>();
            List<Case> lstToInsert = new List<Case>();
            List<RecordType> rt = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_CASE_CORPORATIVOS LIMIT 1];
            Id UserId = UserInfo.getUserId();
            
            for(Account acc : accLst){
                Case cIns = new Case();
                if(!acc.isAnalytics__c && (acc.PersonDoNotCall != oldMap.get(acc.Id).PersonDoNotCall || acc.PersonHasOptedOutOfEmail != oldMap.get(acc.Id).PersonHasOptedOutOfEmail)){
                    if( acc.PersonDoNotCall && acc.PersonHasOptedOutOfEmail ){
                        cIns.AccountId = acc.Id;
                            cIns.Rut_del_Cliente__c = acc.RUT__c;
                            cIns.Subject = Constants.CASE_SUBJECT_DEFAULT;
                            cIns.Description = Constants.CASE_DESCRIPTION_AUTORIZA;
                            cIns.Origin = Constants.CASE_CASE_ORIGIN_PRESENCIAL;
                            cIns.RecordTypeId = rt[0].Id;
                            cIns.Type = Constants.CASE_TYPE_SOLICITUD;
                            cIns.Subtipo__c = Constants.CASE_SUBTIPO_DESUSCRIPCION;
                            cIns.Status = Constants.CASE_STATUS_CERRADO;
                            cIns.Sub_estado_Nectia__c = Constants.CASE_SUBESTADONECTIA_SOLUCIONADO;
                            cIns.OwnerId = UserId;
                        	cIns.Desuscribir_Email__c = true;
                            cIns.Desuscribir_Telefono__c = true;
                            lstToInsert.add(cIns);
                    }
                }
                if(!acc.isAnalytics__c){
                    if(acc.PersonDoNotCall != oldMap.get(acc.Id).PersonDoNotCall){
                        if(acc.PersonDoNotCall && !acc.PersonHasOptedOutOfEmail){
                            if(!rt.isEmpty()){
                                cIns.AccountId = acc.Id;
                                cIns.Rut_del_Cliente__c = acc.RUT__c;
                                cIns.Subject = Constants.CASE_SUBJECT_DEFAULT;
                                cIns.Description = Constants.CASE_DESCRIPTION_AUTORIZA;
                                cIns.Origin = Constants.CASE_CASE_ORIGIN_PRESENCIAL;
                                cIns.RecordTypeId = rt[0].Id;
                                cIns.Type = Constants.CASE_TYPE_SOLICITUD;
                                cIns.Subtipo__c = Constants.CASE_SUBTIPO_DESUSCRIPCION;
                                cIns.Status = Constants.CASE_STATUS_CERRADO;
                                cIns.Sub_estado_Nectia__c = Constants.CASE_SUBESTADONECTIA_SOLUCIONADO;
                                cIns.OwnerId = UserId;
                                cIns.Desuscribir_Telefono__c = true;
                                lstToInsert.add(cIns);
                            }
                        }
                        
                    }else if(acc.PersonHasOptedOutOfEmail != oldMap.get(acc.Id).PersonHasOptedOutOfEmail){
                        if(acc.PersonHasOptedOutOfEmail && !acc.PersonDoNotCall){
                            if(!rt.isEmpty()){
                                cIns.AccountId = acc.Id;
                                cIns.Rut_del_Cliente__c = acc.RUT__c;
                                cIns.Subject = Constants.CASE_SUBJECT_DEFAULT;
                                cIns.Description = Constants.CASE_DESCRIPTION_AUTORIZA;
                                cIns.Origin = Constants.CASE_CASE_ORIGIN_PRESENCIAL;
                                cIns.RecordTypeId = rt[0].Id;
                                cIns.Type = Constants.CASE_TYPE_SOLICITUD;
                                cIns.Subtipo__c = Constants.CASE_SUBTIPO_DESUSCRIPCION;
                                cIns.Status = Constants.CASE_STATUS_CERRADO;
                                cIns.Sub_estado_Nectia__c = Constants.CASE_SUBESTADONECTIA_SOLUCIONADO;
                                cIns.OwnerId = UserId;
                                cIns.Desuscribir_Email__c = true;
                                lstToInsert.add(cIns);
                            }
                        }
                    }
                }
            }
            
            if(!lstToInsert.isEmpty()){
                System.debug('Insert Case:' + lstToInsert);
                insert lstToInsert;
            }
        }catch(Exception e){
            system.debug(e.getMessage());
            system.debug(e.getStackTraceString());
            system.debug(e.getLineNumber());
            
        }
    }
    
}