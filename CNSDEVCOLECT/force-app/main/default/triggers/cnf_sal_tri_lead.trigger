/*********************************************************************************************************
@Author       eayalcor@everis.com
@name         cnf_sal_tri_lead
@CreateDate   01/10/2019
@Description  Trigger of the Lead object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
01/10/2019                    eayalcor@everis.com           W-000001 - Creación de Lead
23/09/2020                    mbeltrab@everis.com           Inicio B2B Banca Empresas Before Insert - Before Update - After Update
**********************************************************************************************************/
trigger cnf_sal_tri_lead on lead (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Consorcio_Org__c org;

    if (Consorcio_Org__c.getInstance(UserInfo.getUserId()) == null) {
        org = Consorcio_Org__c.getInstance(UserInfo.getProfileId());
    } else {
        org = Consorcio_Org__c.getInstance(UserInfo.getUserId());
    }

    /**Before Insert Event*/
    if(Trigger.isInsert && Trigger.isBefore){
        LeadTriggerHandlerB2b.onBeforeInsert(Trigger.new);
    }


    /**After Insert Lead*/
    if(Trigger.isInsert && Trigger.isAfter){
        if(org.Sales_project__c){
            LeadTriggerHandler.getInstance().onAfterInsert(Trigger.new,Trigger.newMap);
        }
    }

    /**Before Update Lead*/
     if(Trigger.isUpdate && Trigger.isBefore){ 
        if(org.Sales_project__c){
            LeadTriggerHandler.getInstance().onBeforeUpdate(Trigger.new,Trigger.oldMap);
        }
        
        LeadTriggerHandlerB2b.onBeforeUpdate(Trigger.new,Trigger.oldMap);
    }
    
    /**After Update Lead*/
    if(Trigger.isUpdate && Trigger.isAfter){
        if(org.Sales_project__c){
            LeadTriggerHandler.getInstance().onAfterUpdate(Trigger.new,Trigger.oldMap);
        }
        
        LeadTriggerHandlerB2b.onAfterUpdate(Trigger.new,Trigger.oldMap);
    }

}