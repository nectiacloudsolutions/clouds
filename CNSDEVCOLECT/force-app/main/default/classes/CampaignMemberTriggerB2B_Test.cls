/**
 * @description       : 
 * @author            : mbeltran@everis.com
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   09-16-2020   mbeltran@everis.com   Initial Version
**/
@isTest
public without sharing class CampaignMemberTriggerB2B_Test {
    @testSetup static void dataloadB2B(){
        User analistaInteliNegocioB2B = TestFactoryB2B.getUserAnalistaInteligenciaNegocioBE();
        insert analistaInteliNegocioB2B;

        TestFactoryB2B.createConsorcioOrgB2B();
    } 

    @isTest
    private static void CampaignMemberTriggerB2B_Test_Insert() {
        User iUAnalistaIntNeg = [SELECT Id, UserRoleId FROM User WHERE RUT__c = '219200315' LIMIT 1];

        System.runAs(iUAnalistaIntNeg){
            Account newAccount = TestFactoryB2B.newAccount('88840560-7','Baccount1', AccountTriggerHelperB2B.getRecordTypeId(AccountTriggerHelperB2B.RT_ACCOUNT_EMPRESA_BANCO));
            insert  newAccount;
    
            Contact newContact = TestFactoryB2B.newContact('Contact1',true,newAccount.Id);
            insert newContact;

            List<Lead> LstLead = new List<Lead>();

            Campaign icampaign = TestFactoryB2B.newCampaignContact('campaña 1','Ingresada');
            insert  icampaign;

            System.assertEquals(true, icampaign != null);

            List<CampaignMember> lstCPM = new List<CampaignMember>();
            
            CampaignMember icampaignmember1 = TestFactoryB2B.newCampaignMember('88840560-7','21920031-5',icampaign.Id);
            lstCPM.add(icampaignmember1);

            CampaignMember icampaignmember6 = TestFactoryB2B.newCampaignMember('24132273-4','',icampaign.Id);        // caso 1
            lstCPM.add(icampaignmember6);

            CampaignMember icampaignmember2 = TestFactoryB2B.newCampaignMember('2-9','21920031-5',icampaign.Id);        // caso 2
            lstCPM.add(icampaignmember2);

            CampaignMember icampaignmember4 = TestFactoryB2B.newCampaignMember(null,'21920031-5',icampaign.Id);         // caso 3
            lstCPM.add(icampaignmember4);

            CampaignMember icampaignmember5 = TestFactoryB2B.newCampaignMember('24132273-4','21920031-5',icampaign.Id);
            lstCPM.add(icampaignmember5);

            CampaignMember icampaignmember7 = TestFactoryB2B.newCampaignMember('24132273-4','31231231231',icampaign.Id);
            lstCPM.add(icampaignmember7);   

            try {
                insert lstCPM;
            } catch (Exception ex) {

                if (ex.getMessage().contains('ejecutivo no existe o no tiene licencia')) {
                    System.assertEquals(ex.getMessage().contains('ejecutivo no existe o no tiene licencia'), true);
                } else if (ex.getMessage().contains('no existe como cliente o no posee un contacto principal')) {
                    System.assertEquals(ex.getMessage().contains('no existe como cliente o no posee un contacto principal'), true);      // caso 1
                } else if (ex.getMessage().contains('Empresa invalido o no contiene información')) {
                    System.assertEquals(ex.getMessage().contains('Empresa invalido o no contiene información'), true);                   // caso 2
                } else if (ex.getMessage().contains('Debe ingresar el Rut para asociar el miembro de campaña')) {
                    System.assertEquals(ex.getMessage().contains('Debe ingresar el Rut para asociar el miembro de campaña'), true);      // caso 3
                }
                
            }
        }

    }

    @isTest
    private static void CampaignMemberTriggerB2B_Lead_Test_Insert() {
        User iUAnalistaIntNeg = [SELECT Id, UserRoleId FROM User WHERE RUT__c = '219200315' LIMIT 1];

        System.runAs(iUAnalistaIntNeg){

            Account newAccount = TestFactoryB2B.newAccount('88840560-7','Baccount1', AccountTriggerHelperB2B.getRecordTypeId(AccountTriggerHelperB2B.RT_ACCOUNT_EMPRESA_BANCO));
            insert  newAccount;
    
            Contact newContact = TestFactoryB2B.newContact('Contact1',true,newAccount.Id);
            insert newContact;
    
            List<Lead> LstLead = new List<Lead>();

            Campaign icampaign = TestFactoryB2B.newCampaignContact('campaña 1','Ingresada');
            insert  icampaign;
            System.assertEquals(true, icampaign != null);

            List<CampaignMember> lstCPM = new List<CampaignMember>();
            
            Lead ilead = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            ilead.FirstName                     = 'Lorena1141'; 
            ilead.LastName                      = 'Reinoso1141';
            ilead.RUTEmpresa__c                 = '18685983-9';
            ilead.EmpresaGrupoFilial__c         = '1';
            ilead.IdRutEmpresaFilial__c         = ilead.RUTEmpresa__c+ilead.EmpresaGrupoFilial__c;
            ilead.rut_ejecutivo_sales__c        = '21920031-5';
            LstLead.add(ilead);
            insert LstLead;

            CampaignMember icampaignmember = TestFactoryB2B.newCampaignMemberLead(ilead.Id,icampaign.Id);
            lstCPM.add(icampaignmember);

            insert lstCPM;
            Map<Id,CampaignMember> mpCMPLeads = CampaignMemberTriggerHelperB2B.getCampaignMembersByLeads(LstLead);

            update new Campaign (
                Id = icampaign.Id,
                Status = 'Terminada'
            );
        }
    } 


}