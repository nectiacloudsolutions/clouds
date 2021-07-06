public class ReassignScheduler implements Schedulable{
    public void execute(SchedulableContext SC) {
        system.debug('Schedulable ----> Start');
        ReassignLeadBatch myBatchObject = new ReassignLeadBatch(); 
        Id batchId = Database.executeBatch(myBatchObject,10);
        system.debug('batch id ---->'+batchId);
    }
}