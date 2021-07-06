/*********************************************************************************************************
@Author       curbinav@everis.com
@name         CampaignMemberTriggerHandler
@CreateDate   01/10/2019
@Description  Handler of the CampaignMember object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
15/10/2019    curbinav@everis.com           W-000011 - Cargar Miembros de Campaña - Forma Masiva
**********************************************************************************************************/
public with sharing class CampaignMemberTriggerHandler {
    // Singleton instance
    private static CampaignMemberTriggerHandler instance = null;

    /**
      * @description       This method calls helper class methods on Singleton pattern for sObject CampaignMember 
      * @param             void
      * @return            CampaignMemberTriggerHandler
      * @throws            NA 
    */
    public static CampaignMemberTriggerHandler getInstance() {
        if (instance == null){
            instance = new CampaignMemberTriggerHandler();
        }    
        return instance;
    }

    /**
      * @description       This method calls helper class methods on After Insert event of sObject CampaignMember
      * @param1            new Records List<CampaignMember> : newCampaignMemberList
      * @return            void
      * @throws            NA
    */
    /*public void onAfterInsert(List<CampaignMember> newCampaignMemberList){
       CampaignMemberTriggerHelper.onAfterInsert(newCampaignMemberList);
    }*/

    /**
      * @description       This method calls helper class methods on After Update event of sObject CampaignMember
      * @param1            new Records List<CampaignMember> : newCampaignMemberList
      * @return            void
      * @throws            NA
    */
    /*public void onAfterUpdate(List<CampaignMember> newCampaignMemberList){
       CampaignMemberTriggerHelper.onAfterUpdate(newCampaignMemberList);
    }*/


    /**
      * @description       This method calls helper class methods on After Delete event of sObject CampaignMember
      * @param1            new Records List<CampaignMember> : oldCampaignMemberList
      * @return            void
      * @throws            NA

    public void onAfterDelete(List<CampaignMember> oldCampaignMemberList){
    //   CampaignMemberTriggerHelper.onAfterUpdate(oldCampaignMemberList);
    }    */


    /**
      * @description       This method calls helper class methods on After Insert event of sObject CampaignMember
      * @param1            new Records List<CampaignMember> : newCampaignMemberList
      * @return            void
      * @throws            NA
    */
    public void onBeforeInsert(List<CampaignMember> newCampaignMemberList){
       CampaignMemberTriggerHelper.onBeforeInsert(newCampaignMemberList);
    }

}