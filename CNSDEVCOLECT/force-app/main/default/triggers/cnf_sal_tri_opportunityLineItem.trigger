/**
 * @File Name          : cnf_sal_tri_opportunityLineItem.trigger
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 6/2/2020, 12:17:13 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/2/2020   eayalcor@everis.com     Initial Version
**/
trigger cnf_sal_tri_opportunityLineItem on OpportunityLineItem (before insert, before update, before delete, 
                                    after insert, after update, after delete, after undelete) {
    
    Consorcio_Org__c org;

    if (Consorcio_Org__c.getInstance(UserInfo.getUserId()) == null) {
        org = Consorcio_Org__c.getInstance(UserInfo.getProfileId());
    } else {
        org = Consorcio_Org__c.getInstance(UserInfo.getUserId());
    }
                                
    /* Before insert OpportunityLineItem */
    if(Trigger.isInsert && Trigger.isBefore){
        if(org.Sales_project__c){
            OpportunityLineItemTriggerHandler.getInstance().onBeforeInsert(Trigger.new, Trigger.oldMap);
        }
    }
                                          
}