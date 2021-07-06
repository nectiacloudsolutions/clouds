/*********************************************************************************************************
@Author       curbinav@everis.com
@name         TaskTriggerHandler
@CreateDate   01/10/2019
@Description  Handler of the Task object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
01/10/2019    curbinav@everis.com           W-000068 - Agendar llamado
**********************************************************************************************************/
public with sharing class TaskTriggerHandler {
  // Singleton instance
  private static TaskTriggerHandler instance = null;
  public static Boolean isFirstTime = true;

  /**
    * @description       This method calls helper class methods on Singleton pattern for sObject Task 
    * @param             void
    * @return            TaskTriggerHandler
    * @throws            NA 
  */
  public static TaskTriggerHandler getInstance() {
      if (instance == null){
          instance = new TaskTriggerHandler();
      }    
      return instance;
  }

  /**
    * @description       This method calls helper class methods on After Insert event of sObject Task
    * @param1            new Records List<Task> : newTaskList
    * @return            void
    * @throws            NA
  */
  public void onAfterInsert(List<Task> newTaskList){
     TaskTriggerHelper.onAfterInsert(newTaskList);
  }

  /**
    * @description       This method calls helper class methods on After Delete event of sObject Task
    * @param1            new Records List<Task> : newTaskList
    * @return            void
    * @throws            NA
  */
  public void onAfterDelete(List<Task> newTaskList){
     TaskTriggerHelper.updateTaskCountByLead(newTaskList);
  }
  
  /**
* @description       This method calls helper class methods on After Delete event of sObject Task
* @param1            new Records List<Task> : newTaskList
* @return            void
* @throws            NA
*/
  public void onAfterUpdate(List<Task> newTaskList,List<Task> oldTaskList, Map<Id,Task> oldMap){
      TaskTriggerPFHelper.onAfterUpdate(newTaskList,oldTaskList);
      TaskTriggerHelper.onAfterUpdate(newTaskList);
  }

   /**
    * @description       This method calls helper class methods on before insert event of sObject Task
    * @param1            new Records List<Task> : newTaskList
    * @return            void
    * @throws            NA
  */
   public void onBeforeInsert(List<Task> newTaskList){
     TaskTriggerHelper.onBeforeInsert(newTaskList);
  }

}