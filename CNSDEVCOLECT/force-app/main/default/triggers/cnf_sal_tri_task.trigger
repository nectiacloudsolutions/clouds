/*********************************************************************************************************
@Author       curbinav@everis.com
@name         cnf_sal_tri_task
@CreateDate   01/10/2019
@Description  Main Trigger of the Task object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
01/10/2019    curbinav@everis.com           W-000068 - Agendar llamado
08/10/2019    eayalcor@everis.com           Se agrega validación Custom Jerarquica
**********************************************************************************************************/
trigger cnf_sal_tri_task on Task (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    Consorcio_Org__c org;

    if (Consorcio_Org__c.getInstance(UserInfo.getUserId()) == null) {
        org = Consorcio_Org__c.getInstance(UserInfo.getProfileId());
    } else {
        org = Consorcio_Org__c.getInstance(UserInfo.getUserId());
    }

    
    /**Before Insert Event*/
    /*if(Trigger.isInsert && Trigger.isBefore){
        TaskTriggerHandler.getInstance().onBeforeInsert(Trigger.new);
    }*/
        
    /**After Insert Event*/
    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
        if(org.Sales_project__c){
            TaskTriggerHandler.getInstance().onAfterInsert(Trigger.new);
        }
	}
    
    /**Before Update Event*/
    /*else if(Trigger.isUpdate && Trigger.isBefore){ 
        //TaskTriggerHandler.getInstance().onAfterInsert(Trigger.new);
    }*/
    
    /**After Update Event*/
    /*else if(Trigger.isUpdate && Trigger.isAfter){

}*/
    
    /**Before Delete Event*/
    /*else if(Trigger.isDelete && Trigger.isBefore){

}*/
    
    /**After Delete Event*/
    else if(Trigger.isDelete && Trigger.isAfter){  
        TaskTriggerHandler.getInstance().onAfterDelete(Trigger.old);
    }

    /**Before Insert Event*/
    if((Trigger.isInsert) && Trigger.isBefore){
        if(org.Sales_project__c){
            TaskTriggerHandler.getInstance().onBeforeInsert(Trigger.new);
        }
	}

 	if(Trigger.isUpdate && Trigger.isAfter){
        if(org.Sales_project__c){   
            TaskTriggerHandler.getInstance().onAfterUpdate(Trigger.new, Trigger.old, Trigger.oldmap );
        }
    }    
    /**After UnDelete Event*/
    /*else if(Trigger.isUnDelete && Trigger.isAfter){

}*/

}