/**
 * @description       : Handler CP Member para B2B 
 * @author            : mbeltran@everis.com
 * @group             : 
 * @last modified on  : 10-09-2020
 * @last modified by  : ggonzroj@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-26-2020   mbeltran@everis.com   Initial Version
**/
public without sharing class CampaignMemberTriggerHandlerB2B {

    private static Consorcio_Org_B2B__c orgB2B = ProcessControlHelper.shouldRunProcessB2B();

    /**
    * @description: This method calls helper class methods on Before Insert event of sObject CampaignMember B2B
    * @author mbeltran@everis.com | 08-26-2020 
    * @param List<CampaignMember> newCampaignMemberList 
    **/
    public void onBeforeInsert(List<CampaignMember> newCampaignMemberList){
        if(orgB2B.Carga_Masiva_de_Prospectos__c){
          CampaignMemberTriggerHelperB2B.assignCampaignMemberByRutaccount(newCampaignMemberList);
        }
      }
  

}