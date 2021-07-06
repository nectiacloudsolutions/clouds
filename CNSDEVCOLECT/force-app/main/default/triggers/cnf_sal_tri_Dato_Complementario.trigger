/*********************************************************************************************************
@Author       mbeltrab@everis.com
@name         cnf_sal_tri_Dato_Complementario
@CreateDate   12/08/2020
@Description  Trigger of the Datos Complementarios object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
12/08/2020                    mbeltrab@everis.com           Initial Version
**********************************************************************************************************/


trigger cnf_sal_tri_Dato_Complementario on Dato_Complementarios__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    
        Consorcio_Org_B2B__c orgB2B;

        if (Consorcio_Org_B2B__c.getInstance(UserInfo.getUserId()) == null) {
            orgB2B = Consorcio_Org_B2B__c.getInstance(UserInfo.getProfileId());
        } else {
            orgB2B = Consorcio_Org_B2B__c.getInstance(UserInfo.getUserId());
        }

        DatoComplementarioTriggerHandlerB2B handler = new DatoComplementarioTriggerHandlerB2B();

        /**Before Insert Event*/
        if(Trigger.isInsert && Trigger.isBefore){
            if(orgB2B.Sales_Project_B2B__c){
                // DatoComplementarioTriggerHandlerB2B.getInstance().onBeforeInsert(Trigger.new,Trigger.oldMap);
                handler.onBeforeInsert(Trigger.new,Trigger.oldMap);
            }
        }
 
        /**After Insert Event*/
        if(Trigger.isInsert && Trigger.isAfter){
            if(orgB2B.Sales_Project_B2B__c){
                // DatoComplementarioTriggerHandlerB2B.getInstance().onAfterInsert(Trigger.new);
                handler.onAfterInsert(Trigger.new);
            }
        }

        /**Before Update Dato_Complementarios__c*/
         if(Trigger.isUpdate && Trigger.isBefore){ 
            //Banca Personas
            if(orgB2B.Sales_Project_B2B__c){
                // DatoComplementarioTriggerHandlerB2B.getInstance().onBeforeUpdate(Trigger.new,Trigger.oldMap); 
                handler.onBeforeUpdate(Trigger.new,Trigger.oldMap); 
            }
        }


         if(Trigger.isUpdate && Trigger.isAfter){
            if(orgB2B.Sales_Project_B2B__c){
                handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
            }
        }
        
        /**After Update Event*/
        /*if(Trigger.isUpdate && Trigger.isAfter){
            if(org.Sales_project__c){
                Dato_Complementarios__cTriggerHandler.getInstance().onAfterUpdate(Trigger.new,Trigger.oldMap); Lógica Personas/*
            }
         /*   if(!org.Sales_project__c){
                Dato_Complementarios__cTriggerHandlerB2b.getInstance().onAfterUpdate(Trigger.new,Trigger.oldMap);
            }
        }*/
    
        
        /**Before Delete Event*/
        /*else if(Trigger.isDelete && Trigger.isBefore){
        
        }*/
        
        /**After Delete Event*/
        /*else if(Trigger.isDelete && Trigger.isAfter){  
        
        }*/
        
        /**After UnDelete Event*/
        /*else if(Trigger.isUnDelete && Trigger.isAfter){

        }*/
}