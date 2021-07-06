/*********************************************************************************************************
@Author       curbinav@everis.com
@name         EventTriggerHandler
@CreateDate   07/10/2019
@Description  Handler of the Event object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
07/10/2019    curbinav@everis.com           W-000056 - (GLEAD) Crear evento (llamado -  Agendamiento o Email )
**********************************************************************************************************/
public with sharing class EventTriggerHandler {
    // Singleton instance 
    private static EventTriggerHandler instance = null;

    /**
      * @description       This method calls helper class methods on Singleton pattern for sObject Event 
      * @param             void
      * @return            EventTriggerHandler
      * @throws            NA 
    */
    public static EventTriggerHandler getInstance() {
        if (instance == null){
            instance = new EventTriggerHandler();
        }    
        return instance;
    }
    
    /**
      * @description       This method calls helper class methods on Before Insert event of sObject Event
      * @param1            new Records List<Event> : eventList
      * @return            void
      * @throws            NA
    */
    /*
    public void onBeforeInsert(List<Event> eventList){
       EventTriggerHelper.onBeforeInsert(eventList);
    }
*/
    
    
    /**
      * @description       This method calls helper class methods on After Insert event of sObject Event
      * @param1            new Records List<Event> : eventList
      * @return            void
      * @throws            NA
    */
    public void onAfterInsert(List<Event> eventList){
       EventTriggerHelper.onAfterInsert(eventList);
    }
    
    /**
      * @description       This method calls helper class methods on After Update event of sObject Event
      * @param1            new Records List<Event> : eventList
      * @return            void
      * @throws            NA
    */
    
    public void onBeforeUpdate(List<Event> eventList, Map<Id,Event> eventOldMap){
       EventTriggerHelper.onBeforeUpdate(eventList, eventOldMap);
    }

    
    /**
      * @description       This method calls helper class methods on After Update event of sObject Event
      * @param1            new Records List<Event> : eventList
      * @return            void
      * @throws            NA
    */
    public void onAfterUpdate(List<Event> eventList, Map<Id,Event> eventOldMap){
       EventTriggerHelper.onAfterUpdate(eventList, eventOldMap);
    }

}