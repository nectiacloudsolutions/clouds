/**
 * @description       : Handler Campaign B2B
 * @author            : mbeltran@everis.com
 * @group             : 
 * @last modified on  : 09-08-2020
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-26-2020   mbeltran@everis.com   Initial Version
**/
public without sharing class CampaignTriggerHandlerB2B {
    private static Consorcio_Org_B2B__c orgB2B = ProcessControlHelper.shouldRunProcessB2B();
   

    /**
    * @description 
    * @author mbeltran@everis.com | 09-08-2020 
    * @param List<Campaign> newCampaignList 
    * @param Map<Id Campaign> oldCampaignMap 
    **/
    public static void onBeforeUpdate(List<Campaign> newCampaignList, Map<Id, Campaign> oldCampaignMap){
      if(orgB2B.Carga_Masiva_de_Prospectos__c){
        CampaignTriggerHelperB2B.CloseLeadsinCampaignMemberwheCampaignClose(newCampaignList, oldCampaignMap);
      }
    }
}