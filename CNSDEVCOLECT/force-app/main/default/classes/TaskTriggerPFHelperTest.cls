/*********************************************************************************************************
@Author       gcabrerp@everis.com
@name         TaskTriggerPFHelperTest
@CreateDate   24/11/2020
@Description  Test class para CaseTriggerPFHelper - Casos de Salida
**********************************************************************************************************/
@isTest

public class TaskTriggerPFHelperTest {
    
    @testSetup static void setup(){
        
        Account cuenta = new Account();
        cuenta.RUT__c = '1-9';
        cuenta.FirstName='Juan';
        cuenta.LastName = 'Perez';
        
        insert cuenta;    

        List<sObject> ls1 = System.Test.loadData(TaskInformation__c.sObjectType, 'testTaskInformation');
        List<TaskInformation__c> lsn1 = (List<TaskInformation__c>)ls1;
        update lsn1;        
        
        List<sObject> ls = System.Test.loadData(MessageNotification__c.sObjectType, 'testMessageNotification');
        List<MessageNotification__c> lsn = (List<MessageNotification__c>)ls;
        update lsn;
        
        List<MessageNotification__c> notifyCs = [SELECT Header__c,Body__c,Parameters__c
                                                 FROM MessageNotification__c WHERE Functionality__c != null];
        
    }
    
    @isTest static void testTaskNotificacion(){
        
        
        
        
        
        Account acc = [Select Id, PersonContactId, Name FROM Account WHERE RUT__c = '1-9'];
        
        System.test.startTest(); 
        Task newTask = new Task(Id='00Tc000000VBoO4EAL');
        newTask.WhoId = acc.PersonContactId ;
        newTask.Status='Completada';    
        newTask.Subject ='Solicitar certificado de liquidación';
        newTask.PF_Cliente__c = 'Test User';
        newTask.PF_Opportunity_Owner__c = 'Usert test';
        
        List<task> lstT = new List<Task>{newTask};
            
		Task newTask2 = new Task(Id='00Tc000000VBoO4EAL');
        newTask2.WhoId = acc.PersonContactId ;
        newTask2.Status='Abierta';    
        newTask2.Subject ='Solicitar certificado de liquidación';
        newTask2.PF_Cliente__c = 'Test User';
        newTask2.PF_Opportunity_Owner__c = 'Usert test';
        List<task> lstTnew = new List<Task>{newTask2};    

        system.debug('lstT-->'+ lstT);
        system.debug('lstTnew-->'+ lstTnew);
        TaskTriggerPFHelper.onAfterUpdate(lstT,lstTnew);
        
        System.test.stopTest();
    }
}