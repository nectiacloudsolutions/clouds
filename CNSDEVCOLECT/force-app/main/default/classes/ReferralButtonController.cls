/*********************************************************************************************************
@Author       zsuanaza@everis.com
@name         ReferralButtonController
@CreateDate   26/12/2019
@Description  Controller for the lightining component ReferralButton
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
26/12/2019                    zsuanaza@everis.com                Initial Version 
**********************************************************************************************************/
public without sharing class ReferralButtonController {
    
    public static Boolean referirBtn = false;
    
    /**
      * @name			   getNewExecutive
      * @description       Validate if the oportunity is in the stage that correspond
      * @params            N/A
      * @return            Boolean
      * @throws            NA
    **/
    @AuraEnabled 
    public static String getNewExecutive (String recordId){
        
        try{
            SalesCallout.OpportunityDataList executive= new SalesCallout.OpportunityDataList();
            String rut;
            List<user> uList = new List<user>();
            List<opportunityLineItem> prodList = new List<opportunityLineItem>();
            List<opportunity> oppList = [SELECT id,telefono_sales__c,telefono_oportunidad_sales__c,Description,correo_oportunidad_sales__c,Account.RUT__c,Owner.RUT__c,Numero_de_documento_sales__c,StageName 
                                         FROM opportunity
                                         WHERE id =: recordId LIMIT 1];   
            if(!oppList.isEmpty()){
                prodList = [SELECT id, Product2.ProductCode FROM opportunityLineItem WHERE OpportunityId =: oppList[0].id LIMIT 1];
            }
            if(!prodList.isEmpty()){
                SalesCallout sc = new SalesCallout(Constants.ANALYTICSLEAD);          
                SalesCallout.OpportunityDataList opdr = new SalesCallout.OpportunityDataList();
                SalesCallout.OppObj data = new SalesCallout.OppObj();
                List<SalesCallout.OppObj> lstOpp =new List<SalesCallout.OppObj>();
                if(Test.isRunningTest()){             
                    data.rut_Ejecutivo = '88136454';
                    lstOpp.add(data);
                    opdr.jsonMap=lstOpp;
                }
                
                executive = Test.isRunningTest() ? opdr : sc.reassignExecutive(oppList[0],prodList[0].Product2.ProductCode);
                System.debug('EXE--->'+executive);
                OpportunityTeamMember oppTeamMem = new OpportunityTeamMember(OpportunityId = oppList[0].id, 
                                                                             OpportunityAccessLevel = 'Read',
                                                                             TeamMemberRole = 'Referidor',
                                                                             UserId = oppList[0].ownerid);
                if(!String.isBlank(executive.jsonMap[0].rut_Ejecutivo)){
                    rut = executive.jsonMap[0].rut_Ejecutivo.replace('-','');
                    system.debug('EXECUTIVE-->'+executive);
                    
                    uList = [SELECT Id, Name FROM User where RUT__c =: rut];
                }
             
                if(!uList.isEmpty()){
                    referirBtn = true;
                    insert oppTeamMem;
                    oppList[0].ownerid = uList[0].id;
                    update oppList;
                    return uList[0].name;
                }
                return Constants.OPPORTUNITY_ERROR_USER_NOTFOUND;
            }else{
                return Constants.OPPORTUNITY_ERROR_PRODUCTO;
            }
            
        }catch(Exception e){
            return Constants.OPPORTUNITY_ERROR_EXCEPTION;
        }
    }
    
    /**
      * @name			   validateOppStage
      * @description       Validate if the oportunity is in the stage that correspond 
      * @params            N/A
      * @return            Boolean
      * @throws            NA
    **/
    @AuraEnabled 
    public static String validateOppStage(String recordId){
        
        if(Consorcio_Org__c.getInstance(UserInfo.getProfileId()).Referir_sales__c){

            Id idUser = UserInfo.getUserId();
            
            List<Opportunity> oppList = [SELECT Id, Opportunity.StageName, OwnerId, Owner.ManagerId, Owner.Profile.Name, RecordType.DeveloperName
                                         FROM Opportunity WHERE Id =:recordId LIMIT 1];

            List<documento_oportunidad_sales__c> lstDocOpp = [SELECT Id, Opportunity_sales__c, motivo_rechazo_sales__c, estado_documento_sales__c, Name, 
                                                              observaciones_sales__c, check_documento_sales__c, Participante_sales__c, detalle_documento_sales__c, 
                                                              Opportunity_sales__r.tipo_contrato_sales__c
                                                              FROM documento_oportunidad_sales__c 
                                                              WHERE Opportunity_sales__c =: recordId AND tipo_oportunidad_sales__c = ''
                                                              ORDER BY CreatedDate ASC];

            List<User> userInf = [SELECT Id, Profile.Name FROM User WHERE Id =: idUser LIMIT 1];

            if((oppList[0].RecordType.DeveloperName == Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO) || (oppList[0].RecordType.DeveloperName == Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO_LECTURA)){
                if(oppList[0].StageName == Constants.OPPORTUNITY_STAGE_CONTACTO && userInf[0].Profile.Name != Constants.PROFILE_EJECUTIVO_VENTA){
                    return Constants.OK;
                }else if(oppList[0].StageName == Constants.OPPORTUNITY_STAGE_INGRESO_NEGOCIO || oppList[0].StageName == Constants.OPPORTUNITY_STAGENAME_SIMULACION || oppList[0].StageName == Constants.OPPORTUNITY_STAGE_CONTACTO && 
                        ((userInf[0].Profile.Name == Constants.PROFILE_EJECUTIVO_VENTA && oppList[0].OwnerId == idUser) ||
                        (oppList[0].Owner.Profile.Name == Constants.PROFILE_EJECUTIVO_VENTA && oppList[0].Owner.ManagerId == idUser))){
                    Integer contDocs = 0;
                    for(documento_oportunidad_sales__c doc : lstDocOpp){
                        if((doc.estado_documento_sales__c != 'Ingresado') && (doc.estado_documento_sales__c != 'No aplica')){
                          //  contDocs++;
                        }
                    }
                    if(contDocs > 0){
                        return Constants.OPPORTUNITY_ERROR_DOCUMENTOS;
                    }else{
                        return Constants.OK;
                    }
                }else{
                    return Constants.OPPORTUNITY_ERROR_ETAPA;
                }
            }else if ((oppList[0].RecordType.DeveloperName != Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO) && (oppList[0].RecordType.DeveloperName != Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO_LECTURA)){
                if (oppList[0].StageName.equals(Constants.OPPORTUNITY_STAGE_CONTACTO) || oppList[0].StageName.equals(Constants.OPPORTUNITY_STAGENAME_SIMULACION) ||
                    oppList[0].StageName.equals(Constants.OPPORTUNITY_STAGENAME_COTIZACION) || oppList[0].StageName.equals(Constants.OPPORTUNITY_STAGE_INGRESO_NEGOCIO) || 
                    oppList[0].StageName.equals(Constants.OPPORTUNITY_STAGENAME_RECOPILACION)) {   
                        
                        return Constants.OK;
                    }else{
                        return Constants.OPPORTUNITY_ERROR_ETAPA;
                    }
            }    
        }else{
            return Constants.OPPORTUNITY_ERROR_USUARIO;
        }
        return Constants.OPPORTUNITY_ERROR_EXCEPTION;
    }
}