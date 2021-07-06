/**
 * @description       : 
 * @author            : mbeltran@everis.com
 * @group             : 
 * @last modified on  : 11-18-2020
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   10-18-2020   mbeltran@everis.com   Initial Version
**/
public without Sharing class LeadWizardControllerB2B {

    public static final String EmpresaGrupoFilial = '1';

    @AuraEnabled 
    public static Map<String,List<SObject>> validatedRUTBBEE(String RUT){ 
        Map<String,List<SObject>> mapResult = new Map<String,List<SObject>>();
        Set<String> set1 = new Set<String>{RUT};
        mapResult = existAccountLeadBBEE(set1);
                    
        return mapResult;
    }
    public static Map<String,List<SObject>> existAccountLeadBBEE(Set<String> rut){
        Map<String,List<SObject>> mapObject = new Map<String,List<SObject>>();

        List<Account> lstAccount = [SELECT Id,Rut__c,OwnerId,name,Estado_Cliente_Banca_Empresas__c FROM Account 
                                //WHERE (Tipo_de_documento_de_identidad__c =: Constants.RUT 
                                //AND rut__c IN : rut) OR (rut__c IN : rut)];
                                WHERE rut__c IN : rut];

        List<Lead> lstLead = [SELECT Id, RUTEmpresa__c, rut_ejecutivo_sales__c,OwnerId,Email,Phone,total_tareas_sales__c, Status FROM Lead 
                            WHERE RUTEmpresa__c IN : rut and EmpresaGrupoFilial__c = :LeadWizardControllerB2B.EmpresaGrupoFilial];
        
        if(lstLead != null && !lstLead.isEmpty()){
            List<User> lstLeadOwner = [SELECT Id, Name FROM User where Id =: lstLead[0].OwnerId];
            mapObject.put('LeadOwner', lstLeadOwner);
        }
        if(lstAccount != null && !lstAccount.isEmpty()){
            List<User> lstAccountOwner = [SELECT Id, Name FROM User where Id =: lstAccount[0].OwnerId];
            mapObject.put('AccountOwner', lstAccountOwner);

            /////////////////////
            List<AccountTeamMember> lstAccountTeamMember = [SELECT Id,AccountId,Account.Owner.name, AccountAccessLevel,UserId, User.Name from AccountTeamMember where AccountId =: lstAccount[0].Id];
            mapObject.put('AccountTeamMemberOwner', lstAccountTeamMember);
        }
        
        mapObject.put('Account', lstAccount);
        mapObject.put('Lead', lstLead);
     
        return mapObject;
    }
}