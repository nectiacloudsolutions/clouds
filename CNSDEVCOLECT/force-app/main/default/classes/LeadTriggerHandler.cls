/*********************************************************************************************************
@Author       eayalcor@everis.com
@name         LeadTriggerHandler
@CreateDate   01/10/2019
@Description  Handler of the Lead object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
01/10/2019                    eayalcor@everis.com           Initial Version
**********************************************************************************************************/
public with sharing class LeadTriggerHandler
{
    private static LeadTriggerHandler instance = null;
    public LeadTriggerHelper helper;
    /**
      * @description       This method calls helper class methods on Singleton patern for sObject Lead 
      * @param             void
      * @return            LeadTriggerHandler
      * @throws            NA 
    */

    public LeadTriggerHandler(){
        helper = new LeadTriggerHelper();
    }

    public static LeadTriggerHandler getInstance() {
        if (instance == null){
            instance = new LeadTriggerHandler();
        }    
        return instance;
    }

    /**
      * @description       This method calls helper class methods on BeforeInsert event of sObject Lead
      * @param1            new Records List<Lead> : newLead
      * @param2            new Records List<Lead, ID>: newLeadMap
      * @return            void
      * @throws            NA
    */
    /*public void onBeforeInsert(List<Lead> newLead, Map<ID,Lead> newLeadMap){
     //Realizar comprobación de usuario integración
       //helper.onBeforeInsert(newLead);
    }*/
    /**
      * @description       This method calls helper class methods on AfterInsert event of sObject Lead
      * @param1            new Records List<Lead> : newLead
      * @param2            new Records List<Lead, ID>: newLeadMap
      * @return            void 
      * @throws            NA
    */
    public void onAfterInsert(List<Lead> newLead, Map<ID,Lead> newLeadMap){
        //Realizar comprobación de usuario integración
            helper.reportLeadCreationAnalytics(newLead,newLeadMap);
    }
    /**
      * @description       This method calls helper class methods on After Update event of sObject Lead
      * @param1            new Records List<Lead> : updateLead
      * @return            void
      * @throws            NA
    */
    public void onBeforeUpdate(List<Lead> updateLead,Map<ID, Lead> oldLeadMap){
       helper.onBeforeUpdate(updateLead,oldLeadMap);
    }

    /**
      * @description       This method calls helper class methods on After Update event of sObject Lead
      * @param1            new Records List<Lead> : updateLead
      * @return            void
      * @throws            NA
    */
    public void onAfterUpdate(List<Lead> updateLead,Map<ID, Lead> oldLeadMap){
       helper.onAfterUpdate(updateLead,oldLeadMap);
    }
}