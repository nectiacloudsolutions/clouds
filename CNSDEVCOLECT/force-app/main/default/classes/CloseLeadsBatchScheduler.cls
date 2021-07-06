/**
 * @author Álvaro Tromilen
 * Clase Scheduler que permite agendar la ejecución de la clase CloseLeadsBatch
 */
global class CloseLeadsBatchScheduler implements Schedulable{
    global void execute(SchedulableContext SC) {
        System.debug(LoggingLevel.INFO, 'Execution of scheduled class \"CloseLeadsBatch\" started');
        CloseLeadsBatch closeLeadsbatch = new CloseLeadsBatch(); 
        Id batchId = Database.executeBatch(closeLeadsbatch);
        system.debug(LoggingLevel.INFO, 'Batch execution ID: '+ batchId);
    }
}