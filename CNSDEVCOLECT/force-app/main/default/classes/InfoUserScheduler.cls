public class InfoUserScheduler implements Schedulable{
    public void execute(SchedulableContext SC) {
        InfoUserBatch myBatch = new InfoUserBatch(); 
        Id batchId = Database.executeBatch(myBatch,200);
    }
}