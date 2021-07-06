trigger cnf_sal_tri_account on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    Consorcio_Org__c org;

    if (Consorcio_Org__c.getInstance(UserInfo.getUserId()) == null) {
        org = Consorcio_Org__c.getInstance(UserInfo.getProfileId());
    } else {
        org = Consorcio_Org__c.getInstance(UserInfo.getUserId());
    }
    
    if(Trigger.isUpdate && Trigger.isAfter){
        if(org.Sales_project__c){
            AccountTriggerHandler.getInstance().onAfterUpdate(Trigger.new,Trigger.oldMap);
        }
    }

}