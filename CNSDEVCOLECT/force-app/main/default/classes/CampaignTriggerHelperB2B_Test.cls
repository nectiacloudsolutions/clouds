/**
 * @description       : 
 * @author            : ggonzroj@everis.com
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ggonzroj@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   09-24-2020   ggonzroj@everis.com   Initial Version
**/
@isTest
public class CampaignTriggerHelperB2B_Test {

    @testSetup static void dataloadB2B(){
        User iUAnalistaIntNeg = TestFactoryB2B.getUserAnalistaInteligenciaNegocioBE();
        insert iUAnalistaIntNeg;

        TestFactoryB2B.createConsorcioOrgB2B();
    } 

    @isTest
    private static void UpdateLeadsFromCampaignMembersByCampaignClose_test(){
        User iUAnalistaIntNeg = [SELECT Id, RUT__c, UserRoleId FROM User WHERE RUT__c = '219200315' LIMIT 1];

        System.runAs(iUAnalistaIntNeg){

            Campaign icampaign = TestFactoryB2B.newCampaignContact('Campaña 2','Ingresada');
            insert  icampaign;

            Lead ilead = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            ilead.FirstName                     = 'Lorena1142'; 
            ilead.LastName                      = 'Reinoso1142';
            ilead.RUTEmpresa__c                 = '10114941-2';
            ilead.EmpresaGrupoFilial__c         = '1';
            ilead.IdRutEmpresaFilial__c         = ilead.RUTEmpresa__c+ilead.EmpresaGrupoFilial__c;
            ilead.rut_ejecutivo_sales__c        = iUAnalistaIntNeg.RUT__c;
            insert ilead;

            CampaignMember icampaignmember = TestFactoryB2B.newCampaignMemberLead(ilead.Id,icampaign.Id);
            insert icampaignmember;

            icampaign.Status = CampaignTriggerHelperB2B.CAMPAIGN_STATUS_TERMINADA;
            update icampaign;

            Test.startTest();
                System.assertEquals(
                        [SELECT Id, 
                            Etapa_Prospecto__c 
                            FROM Lead 
                            WHERE Id =: ilead.Id
                        ].Etapa_Prospecto__c, 
                        LeadTriggerHelperB2b.LEAD_ETAPA_CAMPANAFINALIZADA
                    );
            Test.stopTest();
        }

    }

}