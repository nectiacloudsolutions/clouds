/**
* @description       : 
* @author            : eayalcor@everis.com
* @group             : 
* @last modified on  : 09-02-2020
* @last modified by  : eayalcor@everis.com
* Modifications Log 
* Ver   Date         Author                Modification
* 1.0   08-12-2020   eayalcor@everis.com   Initial Version
**/
public class CaseTriggerHelper { 
    
    public static Set<Id> lstIds = new Set<Id>();
    
    public static void onBeforeUpdate(List<Case> caseList, Map<Id,Case> oldMap){
        try{
            List<DTOCaseAnalytics.CaseTmp> lstCaseNotify = new List<DTOCaseAnalytics.CaseTmp>();
            Map<String,String> mapsManagerId = UtilitiesSales.getManagerIdbyOwner(caseList);
            Map<String,String> mapsSlaProcess = UtilitiesSales.getSlaProcessByType(Constants.CASE_OBJECT);
            List<Case> caseListUpdate = new List<Case>();

            for(Case cs : caseList){
               
                if(cs.PRVencida__c == true){
                    system.debug('el evento clave before rt 1 vencio: '+ oldMap.get(cs.Id).PRVencida__c +' nuevo : '+ cs.PRVencida__c);
                     //oldMap.get(cs.Id).ActivaCaseMilestone__c = true;
                     //cs.ActivaCaseMilestone__c = true;
                    
                     caseListUpdate.add(cs);
                }
                if(cs.Type != null && cs.Subtipo__c != null){ 
                    if(cs.Type.equalsIgnoreCase(Constants.CASE_TYPE_SOLICITUD) && cs.Subtipo__c.equalsIgnoreCase(Constants.CASE_SUBTIPO_AUTORIZA) && 
                       Schema.SObjectType.Case.getRecordTypeInfosById().get(cs.RecordTypeId).getDeveloperName() == Constants.CASE_RECORDTYPE_CASOS_CORPORATIVOS)
                       {
                           
                           if(cs.Notificar_Advertencia_SLA__c && cs.Notificacion_Gestor__c && cs.Envio_notificacion_sales__c.equalsIgnoreCase(Constants.CASE_ENVIO_NOTIFICACION_GESTOR_ADVERTENCIA)){
                               CnsCustomNotification.notifyCurrentUser(JSON.serialize(cs),Constants.CASE_CUSTOM_NOTIFY_ADVERTENCIA,new List<String>{mapsManagerId.get(cs.OwnerId),cs.OwnerId});
                           }else if(cs.Notificacion_Gestor__c && cs.Sla_Vencido__c && cs.Envio_notificacion_sales__c.equalsIgnoreCase(Constants.CASE_ENVIO_NOTIFICACION_GESTOR_VENCIMIENTO)){
                               CnsCustomNotification.notifyCurrentUser(JSON.serialize(cs),Constants.CASE_CUSTOM_NOTIFY_VENCIMIENTO,new List<String>{mapsManagerId.get(cs.OwnerId),cs.OwnerId});
                           }else if(cs.Notificar_Advertencia_SLA__c && !cs.Notificacion_Gestor__c && !cs.Sla_Vencido__c ){
                               CnsCustomNotification.notifyCurrentUser(JSON.serialize(cs),Constants.CASE_CUSTOM_NOTIFY_ADVERTENCIA,new List<String>{mapsManagerId.get(cs.OwnerId),cs.OwnerId});
                               cs.Envio_notificacion_sales__c = Constants.CASE_ENVIO_NOTIFICACION_PROPIETARIO_VENCIMIENTO;
                           }else if(cs.Notificar_Advertencia_SLA__c && cs.Sla_Vencido__c && !cs.Notificacion_Gestor__c && cs.envio_notificacion_sales__c != null){
                               if(cs.envio_notificacion_sales__c.equalsIgnoreCase(Constants.CASE_ENVIO_NOTIFICACION_PROPIETARIO_VENCIMIENTO)){
                                   CnsCustomNotification.notifyCurrentUser(JSON.serialize(cs),Constants.CASE_CUSTOM_NOTIFY_VENCIMIENTO,new List<String>{mapsManagerId.get(cs.OwnerId),cs.OwnerId});
                                   cs.Envio_notificacion_sales__c = Constants.CASE_ENVIO_NOTIFICACION_GESTOR_ADVERTENCIA;
                               }
                           }else if (oldMap.get(cs.Id).Status == Constants.CASE_STATUS_NUEVO && cs.Status == Constants.CASE_STATUS_PROCESO &&
                                     (oldMap.get(cs.Id).Sub_estado_Nectia__c == '' || oldMap.get(cs.Id).Sub_estado_Nectia__c == null) &&
                                     cs.Sub_estado_Nectia__c == Constants.CASE_SUBESTADONECTIA_VALIDACION){
                                         cs.OwnerId = mapsManagerId.get(cs.OwnerId);
                                     }
                           //Cierre condiciones para notificaciones
                           if(cs.Sub_estado_Nectia__c != oldMap.get(cs.Id).sub_estado_Nectia__c){
                               if(cs.Sub_estado_Nectia__c == Constants.CASE_SUBESTADONECTIA_RECHAZADO || 
                                  cs.Sub_estado_Nectia__c == CONSTANTS.CASE_SUBESTADONECTIA_CANCELADO &&
                                  cs.Status == CONSTANTS.CASE_STATUS_CERRADO){
                                      lstCaseNotify.add(generatWrapperCaseTmp(cs,'Status')); 
                                  }
                           }
                       } // Cierre Campos a validar
                    if(cs.Type.equalsIgnoreCase(Constants.CASE_TYPE_SOLICITUD) && cs.Subtipo__c.equalsIgnoreCase(Constants.CASE_SUBTIPO_DESUSCRIPCION) && 
                       Schema.SObjectType.Case.getRecordTypeInfosById().get(cs.RecordTypeId).getDeveloperName() == Constants.CASE_RECORDTYPE_CASOS_CORPORATIVOS && cs.Sub_estado_Nectia__c == Constants.CASE_SUBESTADONECTIA_RECHAZADO || 
                       cs.Sub_estado_Nectia__c == CONSTANTS.CASE_SUBESTADONECTIA_CANCELADO &&
                       cs.Status == CONSTANTS.CASE_STATUS_CERRADO && cs.Sub_estado_Nectia__c != oldMap.get(cs.Id).sub_estado_Nectia__c){
                           if(cs.Desuscribir_Telefono__c && !cs.Desuscribir_Email__c){
                               lstCaseNotify.add(generatWrapperCaseTmp(cs,'Desuscribir_Telefono__c'));
              					
                           }else if(cs.Desuscribir_Email__c && !cs.Desuscribir_Telefono__c){
                               lstCaseNotify.add(generatWrapperCaseTmp(cs,'Desuscribir_Email__c'));	
                           }else if(cs.Desuscribir_Email__c && cs.Desuscribir_Telefono__c){
                               lstCaseNotify.add(generatWrapperCaseTmp(cs,'Desuscribir_Email__c'));	
                           }
                         
                    }
                } // Cierre comprobación de null 
            }//Cierre for
            
            system.debug('lista: '+ caseListUpdate);
            if(!caseListUpdate.isEmpty()){
                system.debug('lista dentro: '+ caseListUpdate);
               // update caseListUpdate;
            }
            
            
            if(!lstCaseNotify.isEmpty() && lstCaseNotify != null){
                DTOCaseAnalytics.ListCaseTmp lstJson = new DTOCaseAnalytics.ListCaseTmp();
                lstJson.lstCase = lstCaseNotify;
                SalesCallout.notifyBrand(JSON.serialize(lstJson),Constants.ANALYTICSMARCA,lstIds);
                
            }
            
            
        }catch(Exception e){
            Trigger.new[0].addError(e.getMessage());
            System.debug(e.getMessage());
            system.debug(e.getLineNumber());
        }
    }
    
    
    public static void onAfterInsert(List<Case> caseList, Map<Id,Case> oldMap){
        
        List<DTOCaseAnalytics.CaseTmp> lstCaseNotify = new List<DTOCaseAnalytics.CaseTmp>();
        
        try{
            for(Case cs : caseList){
                //inserta caso según casuísticas
                if(cs.Type != null && cs.Subject != null && cs.Subtipo__c != null && cs.Sub_estado_Nectia__c != null){
                    if(cs.Type.equalsIgnoreCase(Constants.CASE_TYPE_SOLICITUD) && cs.Subject.equalsIgnoreCase(Constants.CASE_SUBJECT_DEFAULT) 
                       && cs.Subtipo__c.equalsIgnoreCase(Constants.CASE_SUBTIPO_DESUSCRIPCION) && cs.Sub_estado_Nectia__c.equalsIgnoreCase(Constants.CASE_SUBESTADONECTIA_SOLUCIONADO)){
                           if(cs.Desuscribir_Telefono__c){
                               lstCaseNotify.add(generatWrapperCaseTmp(cs,'Desuscribir_Telefono__c'));  
                           }else if(cs.Desuscribir_Email__c){
                               lstCaseNotify.add(generatWrapperCaseTmp(cs,'Desuscribir_Email__c')); 
                           }
                       }
                }
                
            }
                      
            if(!lstCaseNotify.isEmpty() && lstCaseNotify != null){
                DTOCaseAnalytics.ListCaseTmp lstJson = new DTOCaseAnalytics.ListCaseTmp();
                lstJson.lstCase = lstCaseNotify;
                SalesCallout.notifyBrand(JSON.serialize(lstJson),Constants.ANALYTICSMARCA,lstIds);
            }
            
        }catch(Exception e){
            Trigger.new[0].addError(e.getMessage());
            system.debug(e.getMessage());
            system.debug(e.getStackTraceString());
        }
    }
    
        public static void onAfterUpdate(List<Case> caseList, Map<Id,Case> oldMap){
            Map<String,String> mapsManagerId = UtilitiesSales.getManagerIdbyOwner(caseList);
            List<Case> caseListUpdate = new List<Case>();
            system.debug('en el metodo afterupdate!!');
        
        try{
            for(Case cs : caseList){
                if(cs.estado_milestone__c == true){
                    system.debug('en el metodo afterupdate previo a call cnsnotification!!');
                     CnsCustomNotification.notifyCurrentUserSLAVencidos(JSON.serialize(cs),Constants.CASE_CUSTOM_NOTIFY_VENCIMIENTO_SLA,new List<String>{cs.OwnerId});
                }
                if(cs.PRVencida__c == true){
                    system.debug('el evento clave rt 1 vencio: '+ oldMap.get(cs.Id).PRVencida__c +' nuevo : '+ cs.PRVencida__c);
                     //oldMap.get(cs.Id).ActivaCaseMilestone__c = true;
                     caseListUpdate.add(cs);
                }
                //update cs;
            }
             
            if(!caseListUpdate.isEmpty()){
               Id MT_TAREAS_RETENCION1 = [ SELECT Id FROM MilestoneType Where Name = 'Primera Retención' ].Id;
                List<CaseMilestone> cmsToUpdate = [select Id, completionDate, TargetDate from CaseMilestone cm where caseId = :caseListUpdate[0].Id and MilestoneTypeId = :MT_TAREAS_RETENCION1 and completionDate = null limit 1];
                //List<CaseMilestone> cmsToInsert = new List<CaseMilestone>();
                List<Task> tareasAsignadas = [select Id, Status from Task cm where WhatId = :caseListUpdate[0].Id and Subject = 'Primera Retención' limit 1];
                //List<Case> caseup = [select Id, ActivaCaseMilestone__c from Case where Id = :caseListUpdate[0].Id limit 1];
                        System.debug('casemilestone encontrado ' + cmsToUpdate);
                        if (cmsToUpdate.isEmpty() == false){
                            for (CaseMilestone cm : cmsToUpdate){
                                Datetime now = System.now();
                                cm.completionDate = now;
                                }
                            System.debug('final: ' + cmsToUpdate);
                            update cmsToUpdate;
                            //cmsToInsert[0].MilestoneTypeId = 'asd';
                            //CaseMilestone cmls = new CaseMilestone();
                            
                            //CaseMilestone clonedCML = cmsToUpdate[0].clone(false);
                            //insert clonedCML;
                            
                            
                            }
                		if (tareasAsignadas.isEmpty() == false){
                            for (Task ta : tareasAsignadas){
                                
                                ta.Status = 'Vencida';
                                }
                            System.debug('final tarea: ' + tareasAsignadas);
                            update tareasAsignadas;
                            }
                		
                		
                		//caseup[0].ActivaCaseMilestone__c = true;
                		//update caseup;
            
            system.debug('lista a actualizar: '+ caseListUpdate);
                }
           
            
        }catch(Exception e){
            Trigger.new[0].addError(e.getMessage());
            system.debug(e.getMessage());
            system.debug(e.getStackTraceString());
        }
    }
    
   
    
    private static DTOCaseAnalytics.CaseTmp generatWrapperCaseTmp(Case tmp, String field){
        DTOCaseAnalytics.CaseTmp obj = new DTOCaseAnalytics.CaseTmp();
        obj.id = tmp.Id;
        obj.ownerId = tmp.OwnerId;
        obj.createdId = tmp.CreatedById;
        obj.fieldName = field;
        obj.caseTmp = tmp;
        
        if(!lstIds.contains(tmp.OwnerId)){lstIds.add(tmp.OwnerId);}
        if(!lstIds.contains(tmp.CreatedById)){lstIds.add(tmp.CreatedById);}
        
        return obj;
    }
}