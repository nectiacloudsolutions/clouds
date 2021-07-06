/*********************************************************************************************************
@Author       curbinav@everis.com
@name         CampaignTriggerHelper
@CreateDate   01/10/2019
@Description  Helper of the Campaign object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
12/11/2019    curbinav@everis.com           W-000073 - (Vista 360° Cliente) - Ingreso Sección Cliente (Resumen)
**********************************************************************************************************/
public with sharing class CampaignTriggerHelper {

    /**
      * @description       Business logic for trigger on After Update
      * @param1            new Records List<Campaign> : newCampaignList
      * @return            void
      * @throws            NA
    */
    public static void onAfterUpdate(List<Campaign> newCampaignList, Map<Id, Campaign> oldCampaignMap) {

        Set<Id> campaignIds = new Set<Id>();
        for (Campaign cp : newCampaignList){
            if ((oldCampaignMap.get(cp.Id) != null && (cp.IsActive != oldCampaignMap.get(cp.Id).IsActive))){
                // Campaña pasa de IsActive false (old) -> true (new)
                campaignIds.add(cp.Id);
            }
        }

        if (!campaignIds.isEmpty()) {
            Id batchId = Database.executeBatch(new BatchCampaignTriggerHelper(campaignIds, newCampaignList));
        }
    } 
}