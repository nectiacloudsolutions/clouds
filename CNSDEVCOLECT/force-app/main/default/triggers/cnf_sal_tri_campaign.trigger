/*********************************************************************************************************
@Author       curbinav@everis.com
@name         cnf_sal_tri_campaign
@CreateDate   12/11/2019
@Description  Main Trigger of the Campaign object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
12/11/2019    curbinav@everis.com           W-000073 - (Vista 360° Cliente) - Ingreso Sección Cliente (Resumen)
23/09/2020    mbeltrab@everis.com           Inicio B2B Banca Empresas Before Update 
**********************************************************************************************************/
trigger cnf_sal_tri_campaign on Campaign (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Consorcio_Org__c org;

    if (Consorcio_Org__c.getInstance(UserInfo.getUserId()) == null) {
        org = Consorcio_Org__c.getInstance(UserInfo.getProfileId());
    } else {
        org = Consorcio_Org__c.getInstance(UserInfo.getUserId());
    }

    /**Before Insert/Update Event*/
    /*if((Trigger.isInsert) && Trigger.isBefore){
        if(org.Sales_project__c){
        	CampaignTriggerHandler.getInstance().onBeforeInsert(Trigger.new);
        }
    }*/
        
    /**After Insert/Update Event*/
    /*else if(Trigger.isInsert && Trigger.isAfter){
        if(org.Sales_project__c){
            CampaignTriggerHandler.getInstance().onAfterInsert(Trigger.new);
        }
	}*/
    
    /**Before Update Event*/
    /*else if(Trigger.isUpdate && Trigger.isBefore){ 
        //CampaignTriggerHandler.getInstance().onAfterInsert(Trigger.new);
    }*/
    if(Trigger.isUpdate && Trigger.isBefore){ 
        CampaignTriggerHandlerB2B.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
	
    /**After Update Event*/
    /*else*/ 
	if (Trigger.isUpdate && Trigger.isAfter){
        if(org.Sales_project__c){
			CampaignTriggerHandler.getInstance().onAfterUpdate(Trigger.new, Trigger.oldMap);
        }    
	}

	
    /**Before Delete Event*/
    /*else if(Trigger.isDelete && Trigger.isBefore){

}*/
    
    /**After Delete Event*/
    /*else if(Trigger.isDelete && Trigger.isAfter){  
        CampaignTriggerHandler.getInstance().onAfterDelete(Trigger.old);
    }
    */
    /**After UnDelete Event*/
    /*else if(Trigger.isUnDelete && Trigger.isAfter){

}*/
    
}