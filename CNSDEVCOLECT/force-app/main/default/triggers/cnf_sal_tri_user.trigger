/**
 * @File Name          : cnf_sal_tri_user.trigger
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 03-02-2020 12:41:57
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    03-02-2020   eayalcor@everis.com     Initial Version
**/
trigger cnf_sal_tri_user on User (before insert, before update, before delete, 
                            after insert, after update, after delete, after undelete) {
    
    Consorcio_Org__c org;

    if (Consorcio_Org__c.getInstance(UserInfo.getUserId()) == null) {
        org = Consorcio_Org__c.getInstance(UserInfo.getProfileId());
    } else {
        org = Consorcio_Org__c.getInstance(UserInfo.getUserId());
    }

    
    /* After Insert User */
    if(Trigger.isInsert && Trigger.isAfter){
        if(org.Sales_project__c){
            UserTriggerHandler.getInstance().onAfterInsert(Trigger.new);
        }
    }

    /* After Update User */
    if(Trigger.isUpdate && Trigger.isAfter){
        if(org.Sales_project__c){
            UserTriggerHandler.getInstance().onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
	}
}