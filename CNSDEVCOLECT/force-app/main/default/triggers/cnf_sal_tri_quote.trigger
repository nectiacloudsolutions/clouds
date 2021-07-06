/**
 * @File Name          : cnf_sal_tri_quote.trigger
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 3/10/2020, 4:12:14 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    3/10/2020   eayalcor@everis.com     Initial Version
**/
trigger cnf_sal_tri_quote on Quote (before insert, before update, before delete, 
                            after insert, after update, after delete, after undelete) {
	
    Consorcio_Org__c org;

    if (Consorcio_Org__c.getInstance(UserInfo.getUserId()) == null) {
        org = Consorcio_Org__c.getInstance(UserInfo.getProfileId());
    } else {
        org = Consorcio_Org__c.getInstance(UserInfo.getUserId());
    }
                                
 	/* Before Update Quote */
    if(Trigger.isUpdate && Trigger.isBefore){
        if(org.Sales_project__c){
            QuoteTriggerHandler.getInstance().onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }                            
}