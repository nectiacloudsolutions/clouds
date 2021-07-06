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
public without sharing class LeadWizardControllerB2B_B2C_Test {

    @testSetup static void dataloadB2B(){
        User iUserEjecutivoVentaB2C = TestFactoryB2B.getUserEjecutivoComercialBE();
        insert iUserEjecutivoVentaB2C;
        TestFactoryB2B.createConsorcioOrgB2B();

        TestFactorySales.populateOrg();
        TestFactorySales.createConsorcioOrg();
    } 

    @isTest
    private static void Validate_To_OpenComponent() {

        User iUserEjecutivoVentaB2C = [SELECT Id, UserRoleId FROM User WHERE RUT__c = '88136454' LIMIT 1];
        User iUserEjecutivoVentaB2B = [SELECT Id, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];
        System.runAs(iUserEjecutivoVentaB2B){
            String GetComponentNameToOpen3 = LeadWizardControllerB2B_B2C.GetComponentAccess();
        }
        System.runAs(iUserEjecutivoVentaB2C){
            String GetComponentNameToOpen = LeadWizardControllerB2B_B2C.GetComponentAccess();
        }

    }
}