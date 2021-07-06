trigger cnf_sal_tri_attachment on Attachment (Before Insert, After Insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            AttachmentTriggerHandler.afterInsert(Trigger.new, Trigger.old, trigger.newMap, Trigger.oldMap);
        }
    }
}