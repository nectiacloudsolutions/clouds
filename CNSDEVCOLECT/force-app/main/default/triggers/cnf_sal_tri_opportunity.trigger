/**
 * @File Name          : cnf_sal_tri_opportunity.trigger
 * @Description        : 
 * @Author             : pcelis@everis.com
 * @Group              : 
 * @Last Modified By   : pcelis@everis.com
 * @Last Modified On   : 03-02-2020 13:42:15
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    03-02-2020   pcelis@everis.com     Initial Version
**/
trigger cnf_sal_tri_opportunity on Opportunity (before insert, before update, before delete, 
                            after insert, after update, after delete, after undelete) {
    
    Consorcio_Org__c org;

    if (Consorcio_Org__c.getInstance(UserInfo.getUserId()) == null) {
        org = Consorcio_Org__c.getInstance(UserInfo.getProfileId());
    } else {
        org = Consorcio_Org__c.getInstance(UserInfo.getUserId());
    }
                                
 	/* After Insert User */
    if(Trigger.isUpdate && Trigger.isBefore){
        if(org.Sales_project__c){
            OpportunityTriggerHandler.getInstance().onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }

    /* After Insert User */
    if(Trigger.isInsert && Trigger.isAfter){
        if(org.Sales_project__c){
            //OpportunityTriggerHandler.getInstance().onAfterInsert(Trigger.new);
        }
    }

    /* After Update User */
    if(Trigger.isUpdate && Trigger.isAfter){
        if(org.Sales_project__c){
            OpportunityTriggerHandler.getInstance().onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
	}

    /* After Update User */
    if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert )){
        if(org.Sales_project__c){
            OpportunityTriggerHandler.getInstance().onAfterInsertUpdate(Trigger.new, Trigger.oldMap);
        }
	}
                                
	/* Before Update User */
    if(Trigger.isBefore && (Trigger.isUpdate )){
        if(org.Sales_project__c){
            OpportunityTriggerHandler.getInstance().onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
	}
                               
                                
}