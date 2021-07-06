@isTest
public class ActivateParticipantControllerTest {
    @testSetup static void setup() {
        Test.startTest();
        List<User> userList = new List<User>();
        Map<String, SObject> mapsOppObjects = new Map<String, SObject>();
        TestFactorySales.createConsorcioOrg();
        // Create User Ejecutivo Especialista
        User user01 = TestFactorySales.createUser('222222222', CONSTANTS.PROFILE_EJECUTIVO_ESPECIALISTA, 'USERESP');
        userList.add(user01);
        
        insert userList;
        
        // Create Account object
        //Account acc01 = TestFactorySales.createNewAccount('11111111-1', 'Cliente');
        Account acc01 = TestFactorySales.createNewAccountWithOwner('11111111-1', 'Cliente', user01.id);

        
        // Create Opp with products
        Id idProd2 = Test.getStandardPricebookId();
        mapsOppObjects = TestFactorySales.createOpportunityWithProductContact(idProd2, acc01.id, user01.id);
        
        Opportunity opp = (Opportunity) mapsOppObjects.get('Opportunity');

        participante_sales__c par = new participante_sales__c();
        par.rut_sales__c='21484503-2';
        par.tipo_documento_sales__c='RUT';
        par.Name='dino';
        par.remuneracion_sales__c=5000000;
        par.telefono_movil_sales__c='828081865';
        par.estado_participante_sales__c='Vigente';
        par.opportunity_participante_sales__c = opp.Id;
        insert par; 
        Test.stopTest();
    }
    
    @isTest
    public static void testActivateParticipant() {
        Test.startTest();
        User user01 = TestFactorySales.createUser('222222244', CONSTANTS.PROFILE_EJECUTIVO_ESPECIALISTA, 'USERESP2');
        
        insert user01;
        participante_sales__c par = [SELECT Id FROM participante_sales__c LIMIT 1];
        ActivateParticipantController.getInitialData(par.Id); 
        
        system.runAs(user01){
            System.assertNotEquals(par, null);
        }
        Test.stopTest(); 
        
    }
    
	
    @isTest
    public static void testActivateOppParticipant() {
        Test.startTest();
        String result;
        User user01 = [select id, alias,profileid from User Where Alias = 'USERESP'];
        participante_sales__c par = [SELECT Id FROM participante_sales__c LIMIT 1];
        system.runAs(user01){
            result = ActivateParticipantController.activateOppParticipant(par.Id); 
             System.assertEquals(CONSTANTS.OK, result);
        }
        system.runAs(user01){
            result = ActivateParticipantController.activateOppParticipant(user01.Id); 
             System.assertEquals(CONSTANTS.PARTICIPANT_ERROR1, result);
        }
        

        Test.stopTest();   
       
    }
    
    @isTest
    public static void testDeactivateOppParticipant(){
        Test.startTest();
        String result;
        User user01 = [select id, alias,profileid from User Where Alias = 'USERESP'];
        participante_sales__c par = [SELECT Id FROM participante_sales__c LIMIT 1];
        system.runAs(user01){
            result = ActivateParticipantController.deactivateOppParticipant(par.Id, 'Rechazado por riesgo');
        }
        Test.stopTest(); 
        System.assertEquals(CONSTANTS.OK, result);
    }
    
}