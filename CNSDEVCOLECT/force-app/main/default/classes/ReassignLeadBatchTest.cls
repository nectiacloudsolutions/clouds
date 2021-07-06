@isTest
public class ReassignLeadBatchTest {
    private static final String LEADRUT1 ='17664054-5';
    private static final String LEADRUT2 ='16671940-2';
    private static final String LEADRUT3 ='18809923-8';
    private static final String LEADRUT4 ='22023427-4';
    private static final String LEADRUT5 ='15540900-2';
    private static final String USERRUT1 ='200133757';
    private static final String USERRUT2 ='182605441';
    private static final String USERRUT3 ='995802406';
    private static final String ALIAS1 ='UTEST1';
    private static final String ALIAS2 ='UTEST2';
    private static final String ALIAS3 ='UTEST3';
    private static final String LEADALIAS1 = 'TEST1';
    private static final String LEADALIAS2 = 'TEST2';
    private static final String LEADALIAS3 = 'TEST3';
    private static final String LEADALIAS4 = 'TEST4';

    @testSetup 
    static void setup() {
        //Insert profiles
        ProfileInjectionLead__c profileInjectionLead = 
            new ProfileInjectionLead__c(Name=CONSTANTS.EJECUTIVAVENTAS, ProfileName__c=CONSTANTS.EJECUTIVAVENTAS);
        insert profileInjectionLead;
        
		// insert Users
        List<User> userToInsert = new List<User>();
        userToInsert.add(TestFactorySales.createUser(USERRUT1, CONSTANTS.EJECUTIVAVENTAS, ALIAS1));
        userToInsert.add(TestFactorySales.createUser(USERRUT2, CONSTANTS.EJECUTIVAVENTAS, ALIAS2));
        userToInsert.add(TestFactorySales.createUser(USERRUT3, CONSTANTS.PROFILE_JEFE_PLATAFORMA_HIPOTECARIO, ALIAS3));
        insert userToInsert;
    }
    
    /**
     * Método que prueba todo el flujo. El método nunca ha podido integrar el approach de HttpCalloutMock,
     * ya que al existir múltiples DML en misma transacción, genera el error: 
     * "ErrorSystem.CalloutException: You have uncommitted work pending. Please commit or rollback before calling out"
     * Por este motivo, se removió la llamada a SalesCalloutMock, ya que no estaba siendo correctamente utilizada.
     * Datos de prueba están siendo manejos en clase batch, con el approach if(Test.isRunningTest()){...)
     * 
     * @author Álvaro Tromilen
     * */
    @isTest 
    static void reassingMethod_sucess(){
        System.debug('--> TEST STARTED: testUsersWithUnauthorizedProfilesFoundOnReassignProcess');
        // Insert: 4 leads con SLA vencido y No Gestionados
        List<Lead> newLeads = new List<Lead>();
        newLeads.add(TestFactorySales.createNewLeadwithSLA(LEADRUT1, USERRUT1, LEADALIAS1));
        newLeads.add(TestFactorySales.createNewLeadwithSLA(LEADRUT2, USERRUT1, LEADALIAS2));
        newLeads.add(TestFactorySales.createNewLeadwithSLA(LEADRUT3, USERRUT1, LEADALIAS3));
        newLeads.add(TestFactorySales.createNewLeadwithSLA(LEADRUT4, USERRUT1, LEADALIAS4));
        insert newLeads;

        System.debug('Leads Insertados:');
        for(Lead l: newLeads){
        	System.debug(l);
        }
		        
        Test.startTest();
        executeBash();
        Test.stopTest();
        
        //Obtengo los leads con SLA posterior a la fecha actual de sistema. Esto debiera devolver los 3 leads reasignados correctamente
        //La clase bajo test (ReassignLeadBatch) está devolviendo los datos mock. Entre ellos, se retorna el rut de USERRUT3, cuyo perfil
        //No está listado en ProfileInjection Lead, permitiendo validar todos los escenarios de la clase execute.
        List<lead> leads = (List<Lead>) [SELECT id, numero_de_documento_sales__c, rut_ejecutivo_sales__c, status, reasignaciones_del_lead_sales__c 
                            			FROM lead 
                            			WHERE sla_sales__c > :System.now()
                                        AND reasignaciones_del_lead_sales__c = 1];
        system.debug('Leads quantity: '+ leads.size());
        system.debug('LEADS after reassign process finish: '+ leads);
        
        system.assertEquals(3, leads.size(), 'Leads returned on query after process is not the expected result.');
		system.assertEquals(1, leads[0].reasignaciones_del_lead_sales__c, 'value on \'reasignaciones_del_lead_sales__c\' is not the expected');
		system.assertEquals(1, leads[1].reasignaciones_del_lead_sales__c, 'value on \'reasignaciones_del_lead_sales__c\' is not the expected');
		system.assertEquals(1, leads[2].reasignaciones_del_lead_sales__c, 'value on \'reasignaciones_del_lead_sales__c\' is not the expected');
        
        System.debug('--> TEST FINISHED: testUsersWithUnauthorizedProfilesFoundOnReassignProcess');
    }
    
    private static void executeBash(){
        ReassignleadBatch myBatchObject = new reassignleadBatch(); 
        Id batchId = Database.executeBatch(myBatchObject,200);
    }
	
    private static List<Lead> getModifiedLeads(List<Lead> leads, String newRutAssigned){
        List<Lead> modifiedLeads = new List<Lead>();
        for(Lead l: leads){
            l.rut_ejecutivo_sales__c = newRutAssigned;
            modifiedLeads.add(l);
        }
             
        return modifiedLeads;
    }
    
    private static List<Lead> getModifiedLeadsWithUnauthorized(List<Lead> leads, String newRutAssigned, String unauthorizedRut){
        List<Lead> modifiedLeads = getModifiedLeads(leads, newRutAssigned);
        
        if(unauthorizedRut != null && !leads.isEmpty()){
            leads[0].rut_ejecutivo_sales__c = unauthorizedRut;
        }
                
        return modifiedLeads;
    }
    
    private static List<Lead> getLeadsWithExpiredSLA(){
        return (List<Lead>) [SELECT ID, reasignaciones_del_lead_sales__c, rut_ejecutivo_sales__c, numero_de_documento_sales__c, sla_sales__c 
                               FROM LEAD
                              WHERE sla_sales__c > :System.now()];
    }
}