/*********************************************************************************************************
@Author       mbeltrab@everis.com
@name         EventTriggerHandlerB2B
@CreateDate   04/08/2020
@Description  Handler of the Event object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
04/08/2020                    mbeltrab@everis.com           Initial Version
**********************************************************************************************************/

public without sharing class EventTriggerHandlerB2B {
    private static Consorcio_Org_B2B__c orgB2B = ProcessControlHelper.shouldRunProcessB2B();

    /**
      * @description       This method calls helper class methods on Before Insert event of sObject Event
      * @param1            new Records List<Event> : eventList
      * @return            void
      * @throws            NA
    */
    public void onBeforeInsert(List<Event> eventList){
      system.debug('debugEVHANDLER0: eventList' + eventList);
      if(orgB2B.Sales_Project_B2B__c){
        system.debug('debugEVHANDLER1: eventList' + eventList);

        EventTriggerHelperB2B.statusLeadByEventEstado(eventList);
      }
    }

	/**
      * @description       This method calls helper class methods on Before Update event of sObject Event
      * @param1            new Records List<Event> : eventList
      * @return            void
      * @throws            NA
    */
    public void onBeforeUpdate(List<Event> updateEvent, Map<ID,Event> oldEvent){
      system.debug('debugEVHANDLERUP0: updateEvent' + updateEvent);
      if(orgB2B.Sales_Project_B2B__c){
        system.debug('debugEVHANDLERUP1: updateEvent' + updateEvent);
        EventTriggerHelperB2B.updateLeadByEventEstado(updateEvent, oldEvent);
      }
    }
}