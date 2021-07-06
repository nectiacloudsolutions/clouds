/**
 * @author Álvaro Tromilen
 * 
 * Clase encargada del cierre de Leads no gestionados con más de 5 reasignaciones, cuyo SLA ya ha vencido respecto a la fecha actual.
 * Esta clase nació como una forma de dar dependencia funcional a ReassignLeadBatch para que sólo se encargue de las reasignaciones, haciendo más
 * testeable y abordable cada aspecto por separado.
 */
public class CloseLeadsBatch implements Database.Batchable<SObject>{
    
    public Database.queryLocator start(Database.BatchableContext BC){
        system.debug(LoggingLevel.INFO, '--> CloseLeadsNoGestionados process starting...');
        DateTime now = System.now();
        String currentTime = now.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        String query = 'SELECT Id, numero_de_documento_sales__c, rut_ejecutivo_sales__c, OwnerId, '+
                                        'SLA_sales__c, reasignaciones_del_lead_sales__c '+
                                        'FROM Lead ' +
                                        'WHERE origen_analytics_sales__c = true ' +
                                        'AND status = \''+CONSTANTS.LEAD_STATUS_CREADO+'\' ' +
                                        'AND numero_de_documento_sales__c != null '+
                                        'AND SLA_Sales__c < '+ currentTime + ' ' +
                                        'AND reasignaciones_del_lead_sales__c >= 20';
        System.debug('Query para obtener Leads en status \'No Gestionado\' con SLA vencido: ' + query);
        return Database.getQueryLocator(query);
    }
	
    public void execute(Database.BatchableContext BC, List<SObject> leads) {
        //No es necesario valida que la lista de Leads se encuentre vacía. Si el método start no encuentra resultados, pasa de inmediato a finish()
        System.debug('Se han encontrado (' + leads.size() + ') Leads con status \'No Gestionado\', con SLA vencido y reasignado 20 veces');
        List<Lead> leadsToClose = new List<Lead>();
        for(Lead lead: (List<Lead>) leads){
            //lead.status = Constants.LEAD_STATUS_NO_INTERESADO;
            leadsToClose.add(lead);
        }
        
        System.debug(LoggingLevel.INFO, 'Cambiando status de Leads a \'No_Interesado\'');
        update leadsToClose;
    }
    
    public void finish(Database.BatchableContext context){
        System.debug(LoggingLevel.INFO, '--> CloseLeadsNoGestionados process finished.');
    }
    
    
}