/*********************************************************************************************************
@Author       curbinav@everis.com
@name         TaskTriggerHelper
@CreateDate   01/10/2019
@Description  Helper of the Task object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
01/10/2019    curbinav@everis.com           W-000068 - Agendar llamado
10/10/2019    eayalcor@everis.com		    Validate t.whoId is related a Object Lead / 
                                            total_tareas_sales__c = 0 if Lead don't have task assign
12/11/2019    fmaturan@everis.com			W-000149 - (Gestión del Lead) - Cambio de estados del Candidato
**********************************************************************************************************/
public with sharing class TaskTriggerHelper {

    /**
      * @description       Business logic for trigger on After Insert
      * @param1            new Records List<Task> : newTaskList
      * @return            void
      * @throws            NA
    */
    public static void onBeforeInsert(List<Task> newTaskList){
        System.debug('llego a metodo before helper ');
        try{
            List<Task> updateTasks = new List<Task>();
            List<Task> TasksWithRetention = new List<Task>();
            List<Task> updateTasksQueue = new List<Task>();
            List<Task> Taskslist = new List<Task>();
            List<Task> TaskslistSR = new List<Task>();
            List<Task> TaskslistPRV = new List<Task>();
            List<Case> caso = new List<Case>();
            List<CaseMilestone> cmsofcase = new List<CaseMilestone>();
            Id MT_TAREAS_RETENCION1 = [ SELECT Id FROM MilestoneType Where Name = 'Primera Retención' ].Id;
            Id MT_TAREAS_RETENCION2 = [ SELECT Id FROM MilestoneType Where Name = 'Segunda Retención' ].Id;
            Id RT_TAREAS_RETENCION = [ SELECT Id FROM RecordType WHERE DeveloperName = :Constants.RECORDTYPE_TASK_P_RETENCION ].Id;
            //Id ID_EQUIPO_RETENCION = [ select id from queuesobject where queue.name='Equipo de Retención' ].QueueId;
            //Group g = [SELECT Id, Name, Type from Group WHERE Type = 'Queue' AND Name = '{{your_queue}}' LIMIT 1];
            //Equipo_de_Retenci_n
            Group g = [Select Id from Group where Type = 'Queue' AND DeveloperName = 'Equipo_de_Retenci_n' LIMIT 1];
			ID qID = g.ID;
            date fechavencimiento = date.today();
            
            
            for (Task t: newTaskList){
                if (t.Subject == Constants.TASK_SUBJECT_PRIMERARETENCION){
                    Taskslist.add(t);
                    
                }else if (t.Subject == Constants.TASK_SUBJECT_SEGUNDARETENCION){
                    TaskslistSR.add(t);
                }
                else if (t.Subject == 'tarea vencida'){
                    TaskslistPRV.add(t);
                }
            }
            if(!Taskslist.isEmpty()){
                TasksWithRetention = Taskslist;
            }else if(!TaskslistSR.isEmpty()){
                TasksWithRetention = TaskslistSR;
            }else if(!TaskslistPRV.isEmpty()){
                TasksWithRetention = TaskslistPRV;
            }
            
             if (!Taskslist.isEmpty()){
                System.debug('lista retencion 1: ' + Taskslist);
               	caso = [ SELECT Id, AccountId, Tipo_de_producto_banco__c, CreatedById FROM Case WHERE Id = :Taskslist[0].WhatId LIMIT 1];
                 System.debug('despues de caso: ' + caso);
            	cmsofcase = [select Id, TargetDate, IsCompleted from CaseMilestone cm where caseId = :caso[0].Id and MilestoneTypeId = :MT_TAREAS_RETENCION1 and completionDate = null limit 1];
                 System.debug('despues de cms: ' + cmsofcase);
                 fechavencimiento = date.newinstance(cmsofcase[0].TargetDate.year(), cmsofcase[0].TargetDate.month(), cmsofcase[0].TargetDate.day());
                System.debug('lista retencion 1.1 caso: ' + caso);
                 System.debug('lista retencion 1.1 cms: ' + cmsofcase);
            }
            if (!TaskslistSR.isEmpty()){
                System.debug('lista retencion 2: ' + TaskslistSR);
               	caso = [ SELECT Id, AccountId, Tipo_de_producto_banco__c, CreatedById FROM Case WHERE Id = :TaskslistSR[0].WhatId LIMIT 1];
            	cmsofcase = [select Id, TargetDate, IsCompleted from CaseMilestone cm where caseId = :caso[0].Id and MilestoneTypeId = :MT_TAREAS_RETENCION2 and completionDate = null limit 1];
                fechavencimiento = date.newinstance(cmsofcase[0].TargetDate.year(), cmsofcase[0].TargetDate.month(), cmsofcase[0].TargetDate.day());
            }
            
            if (!TaskslistPRV.isEmpty()){
                System.debug('lista retencion 3: ' + TaskslistPRV);
                caso = [ SELECT Id, AccountId, Tipo_de_producto_banco__c, CreatedById FROM Case WHERE Id = :TaskslistPRV[0].WhatId LIMIT 1];
               
            }
            
            
            
            
            
           // Case[] caso = [ SELECT Id, AccountId, Tipo_de_producto_banco__c, CreatedById FROM Case WHERE Id = :Taskslist[0].WhatId LIMIT 1];
           // List<CaseMilestone> cmsofcase = [select Id, TargetDate from CaseMilestone cm where caseId = :caso[0].Id and MilestoneTypeId = '557q00000008R23AAE' and completionDate = null limit 1];
            
           // Date fechavencimiento = date.newinstance(cmsofcase[0].TargetDate.year(), cmsofcase[0].TargetDate.month(), cmsofcase[0].TargetDate.day());
            Account[] cuenta = [SELECT Id, Id_Ejecutivo_Banco__c, Nombre_Ejecutivo_Banco__c, Rut_Ejecutivo_Banco__c, PersonContactId FROM Account WHERE Id = :caso[0].AccountId LIMIT 1];
            string rutlimpio = '';
            List<User> usuario = new List<User>();
             if (cuenta[0].Rut_Ejecutivo_Banco__c != null){
                  System.debug('cuenta rut no es nul ' + cuenta[0].Rut_Ejecutivo_Banco__c);
                        rutlimpio = UtilitiesSales.cleanRut(cuenta[0].Rut_Ejecutivo_Banco__c);
                 		usuario = [SELECT Id, IsActive FROM User WHERE RUT__c = :rutlimpio LIMIT 1];
                  System.debug('rut limpio  ' + usuario);
             }else{
                 System.debug('cuenta rut es nul  ' + cuenta[0].Rut_Ejecutivo_Banco__c);
             }
            
            
            for (Task t: TasksWithRetention) {
                    if (t.Subject == Constants.TASK_SUBJECT_PRIMERARETENCION && cmsofcase[0].IsCompleted == false){
                         System.debug('primer if '+ newTaskList );
                        t.RecordTypeId = RT_TAREAS_RETENCION;
                        t.Tipo_Producto__c = caso[0].Tipo_de_producto_banco__c;
                        t.ActivityDate = fechavencimiento;
                        t.Type = Constants.TASK_SUBJECT_PRIMERARETENCION;
                        t.WhoId = cuenta[0].PersonContactId;
                        if(usuario[0].IsActive == true && caso[0].Tipo_de_producto_banco__c == 'Crédito de Consumo'){
                            System.debug('dentro de if 1');
                            t.OwnerId = usuario[0].Id;
                        }else if((usuario[0].IsActive == false || usuario.isEmpty()) && caso[0].Tipo_de_producto_banco__c == 'Crédito de Consumo'){
                            System.debug('dentro de if 2');
                            t.RecordTypeId = RT_TAREAS_RETENCION;
                        }else if(usuario[0].IsActive == true && caso[0].CreatedById == usuario[0].Id && caso[0].Tipo_de_producto_banco__c == 'Crédito hipotecario'){
                            System.debug('dentro de if 3');
                            t.Subject = Constants.TASK_SUBJECT_SEGUNDARETENCION;
                            t.Type = Constants.TASK_SUBJECT_SEGUNDARETENCION;
                            t.OwnerId = usuario[0].Id;
                            
                        }else if(usuario[0].IsActive == true && caso[0].CreatedById != usuario[0].Id && caso[0].Tipo_de_producto_banco__c == 'Crédito hipotecario'){
                            System.debug('dentro de if 4');
                            //t.Subject = Constants.TASK_SUBJECT_PRIMERARETENCION;
                            //t.Type = Constants.TASK_SUBJECT_PRIMERARETENCION;
                            //t.OwnerId = usuario[0].Id;
                            //t.estado_tarea_cola__c = '2';
                           // updateTasksQueue.add(t);
                           // System.debug('updateTasksQueue resultado: '+ updateTasksQueue);
                            
                            
                        }
                        updateTasks.add(t);
                    }else if (t.Subject == Constants.TASK_SUBJECT_SEGUNDARETENCION && cmsofcase[0].IsCompleted == false){
                        System.debug('segundo if '+ newTaskList );
                        t.RecordTypeId = RT_TAREAS_RETENCION;
                        t.Tipo_Producto__c = caso[0].Tipo_de_producto_banco__c;
                        t.ActivityDate = fechavencimiento;
                        t.Type = Constants.TASK_SUBJECT_SEGUNDARETENCION;
                        t.WhoId = cuenta[0].PersonContactId;
                        if(usuario[0].IsActive == true && caso[0].Tipo_de_producto_banco__c == 'Crédito hipotecario'){
                            System.debug('dentro de if 1');
                            t.OwnerId = usuario[0].Id;
                        }
                        updateTasks.add(t);
                    }else if (t.Subject == 'tarea vencida'){
                        System.debug('tercar if '+ TasksWithRetention );
                        t.RecordTypeId = RT_TAREAS_RETENCION;
                        t.Tipo_Producto__c = caso[0].Tipo_de_producto_banco__c;
                        t.ActivityDate = fechavencimiento;
                        t.Type = Constants.TASK_SUBJECT_SEGUNDARETENCION;
                        t.Subject = Constants.TASK_SUBJECT_SEGUNDARETENCION;
                        t.WhoId = cuenta[0].PersonContactId;
                        if(usuario[0].IsActive == true && caso[0].Tipo_de_producto_banco__c == 'Crédito hipotecario'){
                            System.debug('dentro de if 1');
                            t.OwnerId = usuario[0].Id;
                        }
                        updateTasks.add(t);
                    }
                		
                }
            if (!updateTasks.isEmpty()){
                System.debug('resultado retencion 1: ' + updateTasks.size() + 'tasklist: '+ Taskslist.size() + ' TaskslistSR: ' + TaskslistSR.size() + ' cmilstone: '+ cmsofcase + 'updateTasks: '+ updateTasks);
               // Upsert updateTasks;
            }
            
            
            
            
            
        }catch(Exception e){e.setMessage('Ha ocurrido un error, informe a un administrador :'+e.getCause());}
    }
        
    public static void onAfterInsert(List<Task> newTaskList){
        try{
            System.debug('llego a after insert: ' );
            List<Id> lstLeadIdsWhithoutRut= new List<Id>();
            List<Task> newTasks = new List<Task>();
            List<Task> newTasksCola = new List<Task>();
            List<Event> lstEvent = new List<Event>();
            List<Lead> updStatusLeads = new List<Lead>();
            
            
            for (Task t: newTaskList) {
                
                if(t.WhoId != null && t.Subject == Constants.TASK_SUBJECT_LLAMADA
                   && t.resultado_de_la_reunion_sales__c != Constants.TASK_RESULTADO_NO_INTERESA
                   && String.valueOf(t.WhoId.getSobjectType())  == Constants.LEAD){
                       lstLeadIdsWhithoutRut.add(t.WhoId);
                   }
                
                
                if(TaskTriggerHandler.isFirstTime && t.Status == 'Abierta' && t.Subject == 'Primera Retención' && t.Tipo_Producto__c == 'Crédito hipotecario' ){
                    System.debug('llego a if after insert: ' );
                    TaskTriggerHandler.isFirstTime = false;
                       //t.enCola__c = true;
                       newTasksCola.add(t);
                    System.debug('entro en tarea equipo retencion : ' +  newTasksCola);
                   }
                System.debug('llego a if after insert tarea es : ' +  t);
                
                //Sin Rut pero con actividad
                if(t.WhoId != null && t.Subject == Constants.TASK_SUBJECT_LLAMADA
                   && t.resultado_de_la_reunion_sales__c != Constants.TASK_RESULTADO_NO_INTERESA
                   && String.valueOf(t.WhoId.getSobjectType())  == Constants.LEAD){
                       lstLeadIdsWhithoutRut.add(t.WhoId);
                   }
                System.debug('Task (Subject=' + t.Subject 
                             + ', t.resultado_llamada_sales__c=' + t.resultado_llamada_sales__c
                             + ', Status=' + t.Status
                             + ', WhoId=' + t.WhoId + ')'
                            );
                
                // When "Log a call" save event
                if((t.Subject == Constants.TASK_SUBJECT_CALL || t.Subject == Constants.TASK_SUBJECT_LLAMADA) 
                   && t.resultado_llamada_sales__c == Constants.TASK_RESULTADO_AGENDAR 
                   // && t.Status == Constants.TASK_STATUS_COMPLETADA
                  ) {
                      System.debug('Caso agendar');
                      Event objEvent = new Event();
                      objEvent.Type = Constants.EVENT_TYPE_ENTREVISTA;
                      objEvent.enviar_agenda_via_correo_sales__c = true;
                      objEvent.IsReminderSet = true;
                      objEvent.Subject = Constants.TASK_SUBJECT_ENTREVISTA;
                      objEvent.ReminderDateTime = t.fecha_nueva_gestion_sales__c.addMinutes(-30);
                      objEvent.ActivityDate = t.fecha_nueva_gestion_sales__c.date();
                      objEvent.resultado_llamada_sales__c = null;
                      objEvent.DurationInMinutes = 60;
                      objEvent.ActivityDateTime = t.fecha_nueva_gestion_sales__c;
                      objEvent.WhoId = t.WhoId;
                      lstEvent.add(objEvent);
                  } else if ((t.Subject == Constants.TASK_SUBJECT_CALL || t.Subject == Constants.TASK_SUBJECT_LLAMADA) 
                             && (t.resultado_llamada_sales__c == Constants.TASK_RESULTADO_VOLVER_LLAMAR 
                                 || t.resultado_llamada_sales__c == Constants.TASK_RESULTADO_NO_CONTESTA) 
                             && t.Status == Constants.TASK_STATUS_COMPLETADA) {
                                 // And call result "Call back"
                                 // Then create new Task
                                 System.debug('Caso volver a llamar o no contesta');
                                 Task callBackTask = new Task();
                                 callBackTask.IsReminderSet = true;
                                 callBackTask.Subject = Constants.TASK_SUBJECT_LLAMADA;
                                 callBackTask.Status = Constants.TASK_STATUS_ABIERTA;
                                 callBackTask.ReminderDateTime = t.fecha_nueva_gestion_sales__c.addMinutes(-30);
                                 callBackTask.ActivityDate = t.fecha_nueva_gestion_sales__c.date();
                                 callBackTask.resultado_llamada_sales__c = null;
                                 callBackTask.WhoId = t.WhoId;
                                 newTasks.add(callBackTask);
                             } else if ((t.Subject == Constants.TASK_SUBJECT_CALL || t.Subject == Constants.TASK_SUBJECT_LLAMADA) 
                                        && t.resultado_llamada_sales__c == Constants.TASK_RESULTADO_NO_INTERESA 
                                        //&& t.Status == Constants.TASK_STATUS_COMPLETADA
                                        && t.WhoId != NULL
                                        && String.valueOf(t.WhoId.getSobjectType())  == Constants.LEAD) {
                                            System.debug('Caso no está interesado');
                                            // Change Lead Status to "No interesado"
                                            Lead lead = new Lead(Id=t.WhoId, Status=Constants.LEAD_STATUS_NO_INTERESADO);
                                            updStatusLeads.add(lead);
                                            //primera retencion
                                        } 
            }
            //Sin Rut pero con actividad
            if (lstLeadIdsWhithoutRut != null && !lstLeadIdsWhithoutRut.isEmpty()) {
                System.debug('Actualizo Leads Sin Rut');
                updateLeadWithoutRut(lstLeadIdsWhithoutRut);
            }
            if (!newTasks.isEmpty()){
                System.debug('Task to insert ' + newTasks);
                insert newTasks;
            }
             if (!newTasksCola.isEmpty()){
                System.debug('Task to update newTasksCola: ' + newTasksCola);
                 List<CaseMilestone> cmsofcase = new List<CaseMilestone>();
                //Group g = [Select Id from Group where Type = 'Queue' AND DeveloperName = 'Equipo_de_Retenci_n' LIMIT 1];
                Id MT_TAREAS_RETENCION1 = [ SELECT Id FROM MilestoneType Where Name = 'Primera Retención' ].Id;
                cmsofcase = [select Id, TargetDate, IsCompleted from CaseMilestone cm where caseId = :newTasksCola[0].WhatId and MilestoneTypeId = :MT_TAREAS_RETENCION1 and completionDate = null limit 1];
				System.debug('Task to update cmsofcase: ' + cmsofcase);
                 //ID qID = g.ID;
				Date fechavencimiento = date.newinstance(cmsofcase[0].TargetDate.year(), cmsofcase[0].TargetDate.month(), cmsofcase[0].TargetDate.day());
                Task myTask = newTasksCola[0];
				Task upTask = [select id from Task where id = :myTask.id];
				//upTask.OwnerId = qID;
                upTask.ActivityDate = fechavencimiento;
                 System.debug('Task to update upTask: ' + upTask);
				update upTask;
            }
            
            if (!lstEvent.isEmpty()){
                System.debug('Event to insert ' + lstEvent);
                insert lstEvent;  
            }
            if (!updStatusLeads.isEmpty()) {
                System.debug('Lead to update ' + updStatusLeads);
                update updStatusLeads;
                System.debug('lead actualizado' + updStatusLeads);
            }
            
            updateTaskCountByLead(newTaskList);
        }catch(Exception e){e.setMessage('Ha ocurrido un error, informe a un administrador :'+e.getCause());}
    }


    public static void updateTaskCountByLead(List<Task> newTaskList) {
        List<Lead> updStatusLeads = new List<Lead>();
        Lead lead;

        // First extract leads ID
        //List<Id> leads = new List<Id>();
        Set<Id> leads = new Set<Id>();
        for (Task t: newTaskList) {
            if (t.WhoId != null && String.valueOf(t.WhoId.getSobjectType())  == Constants.LEAD) {
                leads.add(t.WhoId);
            }
        }

        // Count task by lead ID
        AggregateResult[] groupedResults = [SELECT WhoId, count(task.Id) taskCount
                                            FROM Task
                                            WHERE WhoId in :leads
                                            GROUP BY WhoId];
        system.debug('Ls--->'+groupedResults);
        system.debug('Leads Before--->'+leads);
        if(groupedResults.size()>0){
            for (AggregateResult ar : groupedResults) {
                System.debug('Count Task:' +(Integer) ar.get('taskCount') );
                lead = new Lead();
                lead.Id = (Id) ar.get('WhoId');
                lead.total_tareas_sales__c = (Integer) ar.get('taskCount') ;
                updStatusLeads.add(lead);
                leads.remove((Id) ar.get('WhoId'));
            }
        }
        system.debug('Leads after--->'+leads);
        for(Id id : leads){
            lead = new Lead();
            lead.Id = id;
            lead.total_tareas_sales__c = 0;
            updStatusLeads.add(lead);
        }

        // Finally update leads
        if (!updStatusLeads.isEmpty()) {
            update updStatusLeads;
        }

    }
    /**
      * @description       Business logic that sets Lead Status to "Gestionado"
      * @param1            new Records List<Event> : eventList
      * @return            void
      * @throws            NA
    */
    private static void updateLeadWithoutRut(List<Id> lstIdsLeads){
        
        List<Lead> lstLead = UtilitiesSales.getLeadByIds(lstIdsLeads); 
        List<Lead> lstLeadToUpdate = new List<Lead>();
        if (lstLead != null && !lstLead.isEmpty()) {
            for(Lead lead : lstLead){
                if(lead.numero_de_documento_sales__c == Null && lead.Status !=Constants.LEAD_STATUS_GESTIONADO){
                    lead.Status = Constants.LEAD_STATUS_GESTIONADO;
                    lstLeadToUpdate.add(lead);
                }
            }
        	if (lstLeadToUpdate != null && !lstLeadToUpdate.isEmpty()){
            	Update lstLeadToUpdate;
        	}
        } 
    }
    
    public static void onAfterUpdate(List<Task> newTaskList ) {
        try{
            system.debug('llego a task after update: ' + newTaskList);
        //List<Id> IdCasos = new List<Id>();
        List<Task> Taskslist = new List<Task>();
        List<Task> Taskslist2 = new List<Task>();
            boolean verificaGestion = false;
            boolean PRetencionCompleted = false;
            boolean SRetencionCompleted = false;
            boolean PRetencionVencida = false;
            for (Task t: newTaskList){
                if (t.Subject == Constants.TASK_SUBJECT_PRIMERARETENCION && t.Status == 'Completada' && t.Tipo_Producto__c == 'Crédito de Consumo'){
                    Taskslist.add(t);
                    PRetencionCompleted = true;
                    //IdCasos.add(t.WhatId);
                }else if (t.Subject == Constants.TASK_SUBJECT_SEGUNDARETENCION && t.Status == 'Completada' && t.Tipo_Producto__c == 'Crédito hipotecario'){
                    Taskslist.add(t);
                    SRetencionCompleted = true;
                    //IdCasos.add(t.WhatId);
                }else if (t.Subject == Constants.TASK_SUBJECT_PRIMERARETENCION && t.Status == 'Completada' && t.Tipo_Producto__c == 'Crédito hipotecario' 
                          && ((t.Gestion__c == 'No Contactado' && t.Resultado_Gesti_n__c == 'Reintentar') 
                             || (t.Gestion__c == 'Contactado'  && t.Resultado_Gesti_n__c != 'Cliente no Retenido'))){
                    			 system.debug('excepcion de gestion 1');
                                 Taskslist.add(t);
                                 PRetencionCompleted = true;
                }else if (t.Subject == Constants.TASK_SUBJECT_PRIMERARETENCION && t.Status == 'Completada' && t.Tipo_Producto__c == 'Crédito hipotecario' 
                          && ((t.Gestion__c == 'No Contactado' && (t.Resultado_Gesti_n__c == 'Número Equivocado' || t.Resultado_Gesti_n__c == 'Número no existe' || t.Resultado_Gesti_n__c == 'Inubicable')) 
                             || (t.Gestion__c == 'Contactado'  && t.Resultado_Gesti_n__c == 'Cliente no Retenido'))){
                                 system.debug('excepcion de gestion 2');
                                 Taskslist.add(t);
                                 verificaGestion = true;
                                 PRetencionCompleted = true;
                    
                }else if (TaskTriggerHandler.isFirstTime && t.Subject == Constants.TASK_SUBJECT_PRIMERARETENCION && t.Status == 'Vencida' && t.Tipo_Producto__c == 'Crédito hipotecario'){
                    TaskTriggerHandler.isFirstTime = false;
                    Taskslist.add(t);
                    PRetencionVencida = true;
                    //IdCasos.add(t.WhatId);
                }
            }
            Case[] caso = [ SELECT Id, AccountId, PR_estado__c, SR_estado__c, Status FROM Case WHERE Id = :Taskslist[0].WhatId LIMIT 1];
            if(PRetencionCompleted == true){
                caso[0].PR_estado__c = true;
            }
            if(SRetencionCompleted == true){
                caso[0].SR_estado__c = true;
            }
            
            if(verificaGestion == true){
                caso[0].ActivaCaseMilestone__c = true;
                system.debug('if de activacion: '+  caso[0]);
            }
            if(PRetencionVencida == true){
                caso[0].PRVencida__c = true;
                caso[0].ActivaCaseMilestone__c = true;
                system.debug('if de activacion vencida: '+  caso[0]);
            }
            
            if (!caso.isEmpty() && caso[0].Status != 'Cerrado') {
                system.debug('caso a actualizar: '+  caso);
            	update caso;
        	}
            
            
     
        }catch(Exception e){e.setMessage('Ha ocurrido un error, informe a un administrador :'+e.getCause());}

    }

}