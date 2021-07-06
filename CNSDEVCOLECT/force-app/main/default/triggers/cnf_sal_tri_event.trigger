/*********************************************************************************************************
@Author       curbinav@everis.com
@name         cnf_sal_tri_event
@CreateDate   07/10/2019
@Description  Main Trigger of the Event object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
07/10/2019    curbinav@everis.com           W-000068 - Agendar llamado
08/10/2019    eayalcor@everis.com           Se agrega validación Custom Jerarquica
**********************************************************************************************************/
trigger cnf_sal_tri_event on event (before insert, before update, after insert, after update) {
    
    Consorcio_Org__c org;

    if (Consorcio_Org__c.getInstance(UserInfo.getUserId()) == null) {
        org = Consorcio_Org__c.getInstance(UserInfo.getProfileId());
    } else {
        org = Consorcio_Org__c.getInstance(UserInfo.getUserId());
    }

    EventTriggerHandlerB2B handler = new EventTriggerHandlerB2B();
    
    /**Before Insert Event*/
    if(Trigger.isInsert && Trigger.isBefore){
        handler.onBeforeInsert(Trigger.new);
    }

    /**After Insert Event*/
    if(Trigger.isInsert && Trigger.isAfter){
        if(org.Sales_project__c){
            EventTriggerHandler.getInstance().onAfterInsert(Trigger.new);
        }
    }
        
    if(Trigger.isUpdate && Trigger.isBefore){
        if(org.Sales_project__c){
            EventTriggerHandler.getInstance().onBeforeUpdate(Trigger.new,Trigger.oldMap);
        }
        handler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    }

    if(Trigger.isUpdate && Trigger.isAfter){
        if(org.Sales_project__c){
            EventTriggerHandler.getInstance().onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }

}