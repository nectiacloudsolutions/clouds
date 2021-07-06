/*********************************************************************************************************
@Author       mbeltrab@everis.com
@name         cnf_sal_tri_Informe_de_Visita
@CreateDate   13/08/2020
@Description  Trigger of the Informe de Visita object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
13/08/2020                    mbeltrab@everis.com           Initial Version
**********************************************************************************************************/

trigger cnf_sal_tri_Informe_de_Visita on Informe_de_Visita__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    
        Consorcio_Org_B2B__c orgB2B;

        if (Consorcio_Org_B2B__c.getInstance(UserInfo.getUserId()) == null) {
            orgB2B = Consorcio_Org_B2B__c.getInstance(UserInfo.getProfileId());
        } else {
            orgB2B = Consorcio_Org_B2B__c.getInstance(UserInfo.getUserId());
        }

        Informe_de_VisitaTriggerHandlerB2B handler = new Informe_de_VisitaTriggerHandlerB2B();

        /**Before Insert */
        if(Trigger.isInsert && Trigger.isBefore){
            handler.onBeforeInsert(Trigger.new,Trigger.oldMap);
        }
        
        /**Before Update */
         if(Trigger.isUpdate && Trigger.isBefore){ 
            handler.onBeforeUpdate(Trigger.new,Trigger.oldMap); 
        }

        /**After Insert */
        if(Trigger.isInsert && Trigger.isAfter){
            handler.onAfterInsert(Trigger.new);
        }
        
        /**After Update */
        /*if(Trigger.isUpdate && Trigger.isAfter){
        }*/
    
        
        /**Before Delete */
        /*else if(Trigger.isDelete && Trigger.isBefore){
        
        }*/
        
        /**After Delete */
        /*else if(Trigger.isDelete && Trigger.isAfter){  
        
        }*/
        
        /**After UnDelete */
        /*else if(Trigger.isUnDelete && Trigger.isAfter){

        }*/
}