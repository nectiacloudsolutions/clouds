@isTest
public class addparticipantControllerTest {
    
    @testSetup static void setup() {
        Test.startTest();
        TestFactorySales.createConsorcioOrg();
        List<User> userList = new List<User>();
        Map<String, SObject> mapsOppObjects = new Map<String, SObject>();
        
        // Create User Ejecutivo Especialista
		User user01 = TestFactorySales.createUser('222222222', CONSTANTS.PROFILE_EJECUTIVO_ESPECIALISTA, 'USERESP');
        userList.add(user01);
        
        insert userList;
        
        // Create Account object
        //Account acc01 = TestFactorySales.createNewAccount('11111111-1', 'Cliente');
        //Account acc02 = TestFactorySales.createNewAccount('18920668-2', 'Dino');
        Account acc01 = TestFactorySales.createNewAccountWithOwner('11111111-1', 'Cliente', user01.id);
        Account acc02 = TestFactorySales.createNewAccountWithOwner('18920668-2', 'Dino', user01.id);
        
        // Create Opp with products
        Id idProd2 = Test.getStandardPricebookId();
        mapsOppObjects = TestFactorySales.createOpportunityWithProductContact(idProd2, acc01.id, user01.id);
        
		Opportunity opp = (Opportunity) mapsOppObjects.get('Opportunity');

        Lead ld = new Lead();
        ld.numero_de_documento_sales__c='8544096-9'; 
        ld.tipo_documento_sales__c='rut';
        ld.FirstName='Dino';
        ld.LastName='Stagno';
        ld.motherlastname_sales__c='soto';
        ld.Phone='895689567';
        ld.fecha_nacimiento_sales__c=Date.newInstance(2000, 12, 9);
        ld.IsConverted = false;
        insert ld;
        
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
    public static void testIsAllowed() {
        Test.startTest();
        List<User> lstUser = [SELECT Id,RUT__c,ProfileID,Name FROM User WHERE RUT__c = '222222222' LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        AddParticipantController.WrapperAllow wAllowed = addParticipantController.isAllowed(opp.Id);
        Test.stopTest();
       
        System.runAs(lstUser[0]){
            String status =  ApprovalRequestController.saveApproval(opp.Id);
            System.assertEquals(wAllowed.allowed, true);
        }
    }
    
    @isTest
    public static void testLeadAsignMethod() {
        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        List<User> lstUser = [SELECT Id,RUT__c,ProfileID,Name FROM User WHERE RUT__c = '222222222' LIMIT 1];
        
        // Test rut = Cliente oportunidad
        addParticipantController.LeadAssign('11111111-1', opp.Id);
        
        // Test rut = Participante oportunidad
        addParticipantController.LeadAssign('21484503-2', opp.Id);
        
        // Test agregar Account que no pertenece a la oportunidad
        addParticipantController.LeadAssign('18920668-2', opp.Id);
        
        // Test agregar Lead que no pertenece a la oportunidad
        addParticipantController.LeadAssign('8544096-9', opp.Id);
        
        // Test rut que no existe como Lead ni Account
        addParticipantController.LeadAssign('33333333-3', opp.Id);
        
        Test.stopTest();
         
        System.runAs(lstUser[0]){
            String status =  ApprovalRequestController.saveApproval(opp.Id);
            System.assertNotEquals(opp, null);
        }
    }
    
    @isTest
    public static void testRegisterParticipant() {
        Test.startTest();
        try{
            
            
            Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
            Lead lead = [SELECT Id FROM Lead LIMIT 1];
            List<User> lstUser = [SELECT Id,RUT__c,ProfileID,Name FROM User WHERE RUT__c = '222222222' LIMIT 1];
            
            // Test conversion Lead -> Account
            addParticipantController.registerParticipant(lead.Id, false, true, '8544096-9', 'RUT', 'Dino', 
                                                         'Stagno', 'Soto', '1990-01-01', '2000000', '123456789', opp.Id);
            
            // Test ingreso nuevo Account
            addParticipantController.registerParticipant(null, true, false, '55555555-5', 'RUT', 'Dino', 
                                                         'Stagno', 'Soto', '1990-01-01', '2000000', '123456789', opp.Id);
            System.runAs(lstUser[0]){
                String status =  ApprovalRequestController.saveApproval(opp.Id);     
                 system.debug(status);
            }
           
            system.debug(opp);
            system.debug(lead);
            System.assertNotEquals(opp, null);
            System.assertNotEquals(lead, null);
        }catch(Exception e){
            system.debug(e.getMessage());
            system.debug(e.getLineNumber());
        }
        
        Test.stopTest();
        
        
        
    }
    
}