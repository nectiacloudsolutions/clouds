global class ReportE05E04Scheduler implements Schedulable{
    global void execute(SchedulableContext SC) {
        ReportCmfE04 reportE04Object = new ReportCmfE04(); 
        Id batchIdE04 = Database.executeBatch(reportE04Object);

        ReportCmfE05 reportE05Object = new ReportCmfE05(); 
        Id batchIdE05 = Database.executeBatch(reportE05Object);
    }
}