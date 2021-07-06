trigger trigger_fecha_reasignacion_lead on Lead (before insert, before update) {
    Consorcio_Org__c org;

    if (Consorcio_Org__c.getInstance(UserInfo.getUserId()) == null) {
        org = Consorcio_Org__c.getInstance(UserInfo.getProfileId());
    } else {
        org = Consorcio_Org__c.getInstance(UserInfo.getUserId());
    }
    
    if(Trigger.isInsert && Trigger.isBefore){
        list <Lead> lds = Trigger.new;
        for(Lead l : lds){      
           if(String.isBlank(String.Valueof(l.fecha_reasignacion_analytics__c))){
		        if(org.Sales_project__c){
                   l.fecha_reasignacion_analytics__c = l.CreatedDate; 
               }
           }
       }
    }
    
    if(Trigger.isUpdate && Trigger.isBefore){
       list <Lead> lds = Trigger.new;
       for(Lead l : lds){      
           if(String.isBlank(String.Valueof(l.fecha_reasignacion_analytics__c))){
               if(org.Sales_project__c){
                   l.fecha_reasignacion_analytics__c = l.CreatedDate; 
               }
           }
       }
    }
}