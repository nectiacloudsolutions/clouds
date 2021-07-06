/**
 * @description       : 
 * @author            : ggonzroj@everis.com
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : ggonzroj@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   10-29-2020   ggonzroj@everis.com   Initial Version
**/
@isTest
public without sharing class LineaBancariaHelperB2b_Test {
    @testSetup static void dataloadB2B(){
        User iUserEjecutivoVenta = TestFactoryB2B.getUserEjecutivoComercialBE();
        insert iUserEjecutivoVenta;

        TestFactoryB2B.createConsorcioOrgB2B();
    } 

    @isTest
    private static void lineasBancarias_Test(){
        User iUserEjecutivoVenta = [SELECT Id, RUT__c, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];

        System.runAs(iUserEjecutivoVenta){
            Account iAcc = new Account(
                Name = 'COMERCIAL HUMERES LIMITADA'
            );
            insert iAcc;
            
            Contact ctc = new Contact(
                AccountId = iAcc.Id,
                FirstName = 'COMERCIAL',
                LastName  = 'HUMERES LIMITADA'
            );
            insert ctc;

            Lead leadRTEmpresa = TestFactoryB2B.newLead(LeadTriggerHelperB2b.RT_LEAD_EMPRESA);
            leadRTEmpresa.Company                       = 'COMERCIAL HUMERES LIMITADA2';
            leadRTEmpresa.FirstName                     = 'COMERCIAL2'; 
            leadRTEmpresa.LastName                      = 'HUMERES LIMITADA2';
            leadRTEmpresa.RUTEmpresa__c                 = '5666663-k';
            leadRTEmpresa.EmpresaGrupoFilial__c         = '1';
            leadRTEmpresa.IdRutEmpresaFilial__c         = leadRTEmpresa.RUTEmpresa__c+leadRTEmpresa.EmpresaGrupoFilial__c;
            leadRTEmpresa.Etapa_Prospecto__c            = LeadTriggerHelperB2b.LEAD_ETAPA_SIN_GESTION;
            leadRTEmpresa.rut_ejecutivo_sales__c        = '24623236-9';
            insert leadRTEmpresa;

            Linea_Bancaria__c lbancarias =  TestFactoryB2B.newLineaBancaria('ProKetsol2');
            lbancarias.Id_Prospecto__c = leadRTEmpresa.Id;
            lbancarias.Banco__c = LineaBancariaHelperB2b.PKL_BANCO_CONSORCIO;
            lbancarias.Account__c = iAcc.Id;
            insert lbancarias;

            List<Linea_Bancaria__c> lst = LineaBancariaHelperB2b.getLineasBancariasByLeadId(new Set<Id>{leadRTEmpresa.Id});
            Map<Id, List<Linea_Bancaria__c>> mapAccount = LineaBancariaHelperB2b.getlineasBancariaByAccount(new Set<Id>{iAcc.Id});
            Map<Id, List<Linea_Bancaria__c>> maplead = LineaBancariaHelperB2b.getlineasBancariaByLead(new Set<Id>{leadRTEmpresa.Id});

        }
    }

}