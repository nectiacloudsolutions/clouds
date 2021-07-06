/**
 * @description       : 
 * @author            : mbeltran@everis.com
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   10-23-2020   mbeltran@everis.com   Initial Version
**/
@isTest
public without sharing class LeadWizardControllerB2B_Test {

    @testSetup static void dataloadB2B(){
        User iUserEjecutivoVentaB2C = TestFactoryB2B.getUserEjecutivoComercialBE();
        insert iUserEjecutivoVentaB2C;
        TestFactoryB2B.createConsorcioOrgB2B();
    } 

    @isTest
    private static void Get_ValidationToOpenorCreateRecord() {

        User iUserEjecutivoVenta = [SELECT Id, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];

        System.runAs(iUserEjecutivoVenta){

            Account iAcc = new Account(
                Name = 'COMERCIAL HUMERES LIMITADA',
                RUT__c = '1-9'
            );
            insert iAcc;
            
            Lead leadRTEmpresa = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadRTEmpresa.Company                       = 'COMERCIAL HUMERES LIMITADA';
            leadRTEmpresa.FirstName                     = 'COMERCIAL'; 
            leadRTEmpresa.LastName                      = 'HUMERES LIMITADA';
            leadRTEmpresa.RUTEmpresa__c                 = '18685983-9';
            leadRTEmpresa.Etapa_Prospecto__c            = LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION;
            leadRTEmpresa.rut_ejecutivo_sales__c        = '24623236-9';
            insert leadRTEmpresa;
        }

        Map<String,List<SObject>> validatedRUTBBEE = LeadWizardControllerB2B.validatedRUTBBEE('18685983-9');
        Map<String,List<SObject>> validatedRUTBBEE2 = LeadWizardControllerB2B.validatedRUTBBEE('1-9');
    }
}