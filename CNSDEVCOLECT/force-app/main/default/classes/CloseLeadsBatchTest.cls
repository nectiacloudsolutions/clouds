/**
 * Unit tests for Batchable class CloseLeadsBatch
 * 
 * @author Álvaro Tromilen (alvaro.tromilen@consorcio.cl)
 **/
@isTest
public class CloseLeadsBatchTest {
    private static final String RUT_LEAD_NOT_EXPIRED = '995802406';
    private static Map<String, String> usersMap;
    private static Map<String, String> leadsMap;
    
    static {        
        usersMap = new Map<String, String>();
        usersMap.put('Lead1', '200133757');
        usersMap.put('Lead2', '182605441');
        usersMap.put('Lead3', '970040005');
        
        leadsMap = new Map<String, String>();
        leadsMap.put('User1', '17664054-5');
        leadsMap.put('User2', '16671940-2');
        leadsMap.put('User3', '18809923-8');
    }
    
    @testSetup static void setup(){
        List<User> usersForTest = new List<User>();
        for(String key: usersMap.keySet()){
            usersForTest.add(TestFactorySales.createUser(usersMap.get(key), CONSTANTS.PROFILE_EJECUTIVO_VENTA, key));
        }
        insert usersForTest;
        
        //Create 1 Lead with a future SLA or Not Expired, simulating it have been injected by Analytics.
        Lead newLead = new Lead();
        newLead.FirstName = 'TEST LEAD';
        newLead.LastName = 'NOT EXPIRED';
        newLead.numero_de_documento_sales__c = RUT_LEAD_NOT_EXPIRED;
        newLead.rut_ejecutivo_sales__c = usersMap.get('User1');
        newLead.Email = 'test@test.cl';
        newLead.LeadSource = 'Analytics';
        newLead.origen_analytics_sales__c = true;
        newLead.sla_sales__c = Datetime.now().AddDays(+7);        
        newLead.status = CONSTANTS.LEAD_STATUS_CREADO;

        insert newLead;
    }
    
    @isTest static void testRecordsWithStatusNoGestionadoAndExpiredSLAWereFound(){
        //Create Leads with SLA expired, modifying for each one the reassign times to 20, in order to test this scenario
        List<Lead> leads = new List<Lead>();
        Integer idx = 0;
        for(String key: leadsMap.keySet()){
            Lead newLead = TestFactorySales.createNewLeadwithSLA(leadsMap.get(key), new List<String>(usersMap.keySet())[idx], key);
            newLead.reasignaciones_del_lead_sales__c = 20;
            leads.add(newLead);
            idx++;
        }
        
        insert leads;
        
        Test.startTest();
        executeBash();
        Test.stopTest();
        
        List<Lead> leadsClosed = getClosedLeads();
        
        System.assertEquals(3, leadsClosed.size(), 'Expected 3 leads with status \'No_Gestionado\', but there is ' + leadsClosed.size());
    }
    
    @isTest static void testNoRecordsFoundWithExpiredSLA(){
        Test.startTest();
        executeBash();
        Test.stopTest();
        
        List<Lead> leadsClosed = getClosedLeads();
        
        System.assertEquals(0, leadsClosed.size(), 'The resulting list of Leads is not the expected result');
    }
    
    private static void executeBash(){
        CloseLeadsBatch myBatchObject = new CloseLeadsBatch(); 
        Id batchId = Database.executeBatch(myBatchObject,200);
    }
    
    private static List<Lead> getClosedLeads(){
        System.debug('--> Looking for Leads with status \'No Gestionado\', SLA expired and reasignaciones >= 20');
        List<Lead> leads = [SELECT ID, numero_de_documento_sales__c, rut_ejecutivo_sales__c, SLA_sales__c, reasignaciones_del_lead_sales__c
                            FROM Lead
                            WHERE reasignaciones_del_lead_sales__c >= 20];
        System.debug('--> Records found: ' + leads.size());
        return leads;
    }
}