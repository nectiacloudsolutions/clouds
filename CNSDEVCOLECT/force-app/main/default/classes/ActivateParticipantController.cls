/**
 * @File Name          : ActivateParticipantController.cls
 * @Description        : 
 * @Author             : zsuanaza@everis.com
 * @Group              : 
 * @Last Modified By   : zsuanaza@everis.com
 * @Last Modified On   : 23-01-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    1/23/2020         zsuanaza@everis.com    Initial Version
**/
public without sharing class ActivateParticipantController {
	    /**
    * @description 
    * @author eayalcor@everis.com | 1/20/2020 
    * @param Id oppId 
    * @return Map<String, List<String>> 
    **/
    @AuraEnabled
    public static responseParticipant getInitialData(Id participantId){
        system.debug('ID-->'+participantId);
        responseParticipant res = new responseParticipant();
        List<participante_sales__c> partList = [SELECT Id, Name, Cliente_sales__c, correo_sales__c, 
                                           telefono_movil_sales__c, telefono_fijo_sales__c, 
                                           rol_participante_sales__c, rut_sales__c, estado_participante_sales__c, 
                                           remuneracion_sales__c, opportunity_participante_sales__c,
                                           opportunity_participante_sales__r.Stagename,motivo_desactivacion_sales__c
                                           FROM participante_sales__c 
                                           WHERE id=:participantId];
		system.debug('PART --->'+partList);
        res.Motivos = UtilitiesSales.getPicklistData(participante_sales__c.motivo_desactivacion_sales__c);
        system.debug('res.Motivos--->'+res.Motivos);
        if((partList != null || !partList.isEmpty())&&
           (partList[0].opportunity_participante_sales__r.Stagename == CONSTANTS.OPPORTUNITY_STAGE_CONTACTO)){
			res.Participant = partList[0];  
        }else{
            res.Participant = null;
        }
        system.debug('res--->'+res);
        return res;
    }
    @AuraEnabled
    public static String activateOppParticipant(Id participantId){ 
        try{
            system.debug('Profile----->'+Consorcio_Org__c.getInstance(UserInfo.getProfileId()));
            if(Consorcio_Org__c.getInstance(UserInfo.getProfileId()).Participantes_Sales__c){
                participante_sales__c part = new participante_sales__c();
                part.id = participantId;
                part.estado_participante_sales__c = CONSTANTS.PARTICIPANT_ESTADO_VIGENTE;
                part.motivo_desactivacion_sales__c = '';
                update part;
                System.debug('PARTICIPANTE--<'+ part);
                return 'OK'; 
            }else{
                return 'ERROR: Su perfil no puede realizar la acción solicitada.';
            }
        }catch(exception e){
            return 'ERROR: Contactar a su administrador';
        }   
    }
    @AuraEnabled
    public static String deactivateOppParticipant(Id participantId,string motivo){ 
        try{
            if(Consorcio_Org__c.getInstance(UserInfo.getProfileId()).Participantes_Sales__c){
                participante_sales__c part = new participante_sales__c();
                part.id = participantId;
                part.estado_participante_sales__c = CONSTANTS.PARTICIPANT_ESTADO_NO_VIGENTE;
                part.motivo_desactivacion_sales__c = motivo;
                update part;
                System.debug('PARTICIPANTE--<'+ part);
                return 'OK';   
            }else{
                return 'ERROR: Su perfil no puede realizar la acción solicitada.';
            }
        }catch(exception e){
            return 'ERROR: Contactar a su administrador';
        }   
    }
    public class responseParticipant{
        @AuraEnabled public List<String> Motivos;
        @AuraEnabled public participante_sales__c Participant;
    }
}