/**
 * @description       : 
 * @author            : mbeltran@everis.com
 * @group             : 
 * @last modified on  : 11-24-2020
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   09-15-2020   mbeltran@everis.com   Initial Version
**/
@isTest
public without sharing class AccountTriggerB2B_Test {

    @testSetup static void dataloadB2B(){
        User iUserEjecutivoVenta = TestFactoryB2B.getUserEjecutivoComercialBE();
        insert iUserEjecutivoVenta;

        TestFactoryB2B.createConsorcioOrgB2B();
    } 

    @isTest
    private static void account_test_Insert() {
        User iUserEjecutivoVenta = [SELECT Id, RUT__c, UserRoleId FROM User WHERE RUT__c = '246232369' LIMIT 1];

        System.runAs(iUserEjecutivoVenta){
            Account newAccount = TestFactoryB2B.newAccount('1-9','Baccount', AccountTriggerHelperB2B.getRecordTypeId(AccountTriggerHelperB2B.RT_ACCOUNT_EMPRESA_BANCO));
            insert  newAccount;
            
            Contact newContact = TestFactoryB2B.newContact('Apellido 1', true,newAccount.Id);
            insert newContact;

            Contact newContact2 = TestFactoryB2B.newContact('Apellido 2', false,newAccount.Id);
            insert newContact2;

            Set<String> RUTs = new Set<String>();
            RUTs.add('1-9');

            Set<Id> Ids = new Set<Id>();
            Ids.add(newAccount.Id);

            Map<String,Account> GetAccbyRut = AccountTriggerHelperB2B.getAccountsbyRUT(RUTs);
            Map<String,Contact> GetAccCtsbyRut =  AccountTriggerHelperB2B.getPrincipalContactfromAccountsbyRUTAccount(RUTs);
            Map<Id,Account> GetAccbyIds =  AccountTriggerHelperB2B.getAccountsAndContacts(Ids);

            
        }
    }
}