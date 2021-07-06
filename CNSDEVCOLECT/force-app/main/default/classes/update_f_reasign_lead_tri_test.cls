@isTest
private with sharing class update_f_reasign_lead_tri_test {
    @testSetup
    private static void loadDataConfig(){
        TestFactorySales.populateOrg();
    }

    @isTest
    static void onBeforeInsert(){
        Test.startTest();
        
        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '17944392-9';
        newLead.numero_de_documento_sales__c = '22222222-2';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = '';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = '';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = Datetime.now();
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = 'Alta';
        
        insert newLead;

        Test.stopTest();
        System.assertEquals(newLead.fecha_reasignacion_analytics__c, newLead.CreatedDate);
    }

    @isTest
    static void onBeforeUpdate(){
        Test.startTest();

        Lead ld = [SELECT fecha_reasignacion_analytics__c, createdDate, lastname, numero_de_documento_sales__c
                     FROM Lead WHERE fecha_reasignacion_analytics__c = null LIMIT 1];
        ld.lastname = 'FUENTESS';
        update ld;

        Test.stopTest();
    }

    
}