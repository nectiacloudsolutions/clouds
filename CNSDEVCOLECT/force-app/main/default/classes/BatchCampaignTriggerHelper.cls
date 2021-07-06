global class BatchCampaignTriggerHelper implements Database.Batchable<AggregateResult>{
    
    Set<Id> batchCampaignIds;
    List<Campaign> batchLstCampaign;
    global BatchCampaignTriggerHelper(Set<Id> campaignIds, List<Campaign> lstCampaign){
        batchCampaignIds = campaignIds;
        batchLstCampaign = lstCampaign;  
    }

    global Iterable<AggregateResult> start(Database.BatchableContext bc){

        String inQuery =  inClausify(batchCampaignIds);

        String query = 'SELECT Propietario_Miembro_de_Campana__c FROM CampaignMember WHERE CampaignId IN ' + inQuery + ' GROUP BY Propietario_Miembro_de_Campana__c ';

        return new AggregateResultIterable(query);
    }
     
    global void execute(Database.BatchableContext bc, List<sObject> scope){ 
        
        List <Id> lstcmFlags = new List<Id>();
        for(sObject sObj : scope) {
          	AggregateResult ar = (AggregateResult)sObj;
            lstcmFlags.add((Id)ar.get('Propietario_Miembro_de_Campana__c'));
        }

      List<CampaignMember> lstCm = [SELECT Id, enviar_correo_sales__c,Propietario_Miembro_de_Campana__c,CampaignId
                                      FROM CampaignMember
                                      WHERE Propietario_Miembro_de_Campana__c IN : lstcmFlags
                                      AND CampaignId IN: batchCampaignIds];
        

        List<CampaignMember> tmpCMember = new List<CampaignMember>();
		List<String> tmpExist = new List<String>();
        
        for(CampaignMember us: lstCm){
            String keyName = us.CampaignId + '-' + us.Propietario_Miembro_de_Campana__c;
            if(!tmpExist.contains(keyName)){
                us.enviar_correo_sales__c = !us.enviar_correo_sales__c;
            	tmpCMember.add(us);              
                tmpExist.add(keyName);   
            }

        } 

        Database.SaveResult[] SR = Database.update(tmpCMember,true); 
    }   
     
    global void finish(Database.BatchableContext BC){
        // execute any post-processing operations like sending email
    }
    
    public String inClausify(Set<Id> ids) {
        String inClause = String.format( '(\'\'{0}\'\')', 
                             new List<String> { String.join( new List<Id>(ids) , '\',\'') });
        return inClause; 
	}
    
}