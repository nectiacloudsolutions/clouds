/*********************************************************************************************************
@Author       gcabrerp@everis.com
@name         TaskTriggerPFHelper
@CreateDate   18/11/2020
@Description  Helper of the Task object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
**********************************************************************************************************/
public with sharing class TaskTriggerPFHelper {
    public static List<TaskInformation__c> lstTask  {get; set;}
    private static Map<String,TaskInformation__c> taskMap;   
    private final static String PF_RECORD_TYPE = Label.PF_Opp_RecordType;
    
    public static List<TaskInformation__c> loadSettings(){
        if(lstTask == null){
            lstTask = [select  Name, Asunto__c, Estado__c, Origen__c, Vencimiento__c, Filtro__c, ValorFiltro__c, Tipo_Notificacion__c from TaskInformation__c where Origen__c =: PF_RECORD_TYPE];
        }
        taskMap = new Map<String,TaskInformation__c>();
        for(TaskInformation__c tsk:lstTask){
            taskMap.put(tsk.ValorFiltro__c, tsk);
        }
        return lstTask;
    }
    
    public static void onAfterUpdate(List<Task> newTaskList, List<Task> oldTaskList){
        loadSettings();
        try{
            for (Task o: oldTaskList) {
                    for (Task t: newTaskList) {
                        String ss = t.who.FirstName;
                       if(o.Status == 'Abierta' && t.Status == taskMap.get('Tarea_Completa').Estado__c && (t.Subject == taskMap.get('Sol_Firmada_PF__c').Asunto__c || t.Subject== taskMap.get('CAD').Asunto__c)){
                            CnsCustomNotification.notifyCurrentUser(JSON.serialize(t), taskMap.get('Tarea_Completa').Tipo_Notificacion__c, new List<String>{t.PF_Opportunity_Owner__c});
                        }
                    }
            }
        }catch(Exception e){e.setMessage('Ha ocurrido un error, informe a un administrador :'+e.getCause());}
    }
}