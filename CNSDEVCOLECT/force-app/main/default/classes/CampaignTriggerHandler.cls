/*********************************************************************************************************
@Author       curbinav@everis.com
@name         CampaignTriggerHandler
@CreateDate   01/10/2019
@Description  Handler of the Campaign object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
12/11/2019    curbinav@everis.com           W-000073 - (Vista 360° Cliente) - Ingreso Sección Cliente (Resumen)
**********************************************************************************************************/
public with sharing class CampaignTriggerHandler {
    // Singleton instance
    private static CampaignTriggerHandler instance = null;

    /**
      * @description       This method calls helper class methods on Singleton pattern for sObject Campaign 
      * @param             void
      * @return            CampaignTriggerHandler
      * @throws            NA 
    */
    public static CampaignTriggerHandler getInstance() {
        if (instance == null){
            instance = new CampaignTriggerHandler();
        }    
        return instance;
    }

    /**
      * @description       This method calls helper class methods on After Insert event of sObject Campaign
      * @param1            new Records List<Campaign> : newCampaignList
      * @return            void
      * @throws            NA
    */
    public void onAfterUpdate(List<Campaign> newCampaignList, Map<Id, Campaign> oldCampaignMap){
       CampaignTriggerHelper.onAfterUpdate(newCampaignList, oldCampaignMap);
    }

}