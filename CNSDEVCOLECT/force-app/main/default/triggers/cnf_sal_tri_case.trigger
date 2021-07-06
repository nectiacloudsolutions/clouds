trigger cnf_sal_tri_case on Case (before insert, before update, before delete, 
                            after insert, after update, after delete, after undelete) {

    Consorcio_Org__c org;

    if (Consorcio_Org__c.getInstance(UserInfo.getUserId()) == null) {
        org = Consorcio_Org__c.getInstance(UserInfo.getProfileId());
    } else {
        org = Consorcio_Org__c.getInstance(UserInfo.getUserId());
    }
                                
    /* Before Update Case */
    if(Trigger.isUpdate && Trigger.isBefore){
        if(org.Sales_project__c){
            CaseTriggerHandler.getInstance().onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
                                
    /* After Insert Case */
    if(Trigger.isInsert && Trigger.isAfter){
        if(org.Sales_project__c){
            CaseTriggerHandler.getInstance().onAfterInsert(Trigger.new, Trigger.oldMap);
        }
    }
                                
    // After Update Case 
    if(Trigger.isUpdate && Trigger.isAfter){
        if(org.Sales_project__c){
            CaseTriggerHandler.getInstance().onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }

	if(Trigger.isBefore){
        if(org.Sales_project__c){
            CaseTriggerHandler.getInstance().onBefore();
        }		
	}

	if(Trigger.isAfter){
        if(org.Sales_project__c){
            CaseTriggerHandler.getInstance().onAfter();
        }
        if(Trigger.isExecuting && !Test.isRunningTest()){
	        CaseTriggerHandler.getInstance().turnOffTgr(); // OJO: Debe ser la ultima instruccion a ejecutar en el After
        }
	}

}