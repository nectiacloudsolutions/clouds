/**
 * @description       : 
 * @author            : ggonzroj@everis.com
 * @group             : 
 * @last modified on  : 11-19-2020
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   09-05-2020   ggonzroj@everis.com   Initial Version
**/
public without sharing class LeadConvertHelperB2b {

    @InvocableMethod
    public static void assignleads (List<Id> LeadIds) {
        
            Set<Id> idsAccount = new Set<Id>();

            Map<Id, Lead> mapLeads = new Map<Id, Lead>( 
                [
                    SELECT Id, Company, FirstName, 
                        LastName, isConverted, 
                        OwnerId, RUTEmpresa__c 
                    FROM Lead 
                    WHERE Id =: LeadIds
                ]
            );

            List<Database.LeadConvertResult> lstConverted = LeadConvertHelperB2b.convertLeads(mapLeads.values());
       
            if (!lstConverted.isEmpty()) {
                update mapLeads.values();
            }
    }
    
    public static List<Database.LeadConvertResult> convertLeads (List<Lead> lstLeads) {
        Set<String> setRuts = new Set<String>();

        for (Lead vlead : lstLeads) {
            if (vlead.RUTEmpresa__c != null) {
                setRuts.add(vlead.RUTEmpresa__c);
            }
        }
        
        Map<Id, Account> mapAccoounts = new Map<Id, Account>(
            [SELECT  Id, Name, Estado_Cliente_Banca_Empresas__c, RUT__c, OwnerId,
                (SELECT Id, FirstName, LastName, AccountId 
                FROM Contacts)
            FROM Account 
            WHERE RUT__c IN: setRuts]
        );

        Map<String, Account> mapRutAccount = new Map<String, Account>();

        for (Account iAccount : mapAccoounts.values()) {
            if (!mapRutAccount.containsKey(iAccount.RUT__c)) {
                mapRutAccount.put(iAccount.RUT__c, iAccount);
            }
        }

        Map<Id, Id> leadWithContact = new Map<Id, Id>();
        Map<Id, Id> leadWithAccount = new Map<Id, Id>();

        for (Lead vlead : lstLeads) {
            String keylead = vlead.FirstName +'-'+ vlead.LastName;

            if (mapRutAccount.containsKey(vlead.RUTEmpresa__c)) {
                Account acc = mapRutAccount.get(vlead.RUTEmpresa__c);
                leadWithAccount.put(vlead.Id, acc.Id);

                if (acc.Contacts != null) {
                    for (Contact iCtc : acc.Contacts) {
                        String keyCTC = iCtc.FirstName +'-'+ iCtc.LastName;

                        if (keyCTC.equals(keylead)) {
                            leadWithContact.put(vlead.Id, iCtc.Id);
                        } 
                    }
                } 
            }
        }

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        List<Database.LeadConvert> leadsToconvert = new List<Database.LeadConvert>();

        for (Lead vlead : lstLeads) {
            if(vlead.IsConverted == false){
                Database.LeadConvert iLead = new Database.LeadConvert();

                iLead.setLeadId(vlead.Id); 
                if (leadWithAccount.containsKey(vlead.Id)) {
                    iLead.setAccountId(leadWithAccount.get(vlead.Id));
                }
                if (leadWithContact.containsKey(vlead.Id)) {
                    iLead.setContactId(leadWithContact.get(vlead.Id));
                }
                iLead.setConvertedStatus(convertStatus.MasterLabel);
                iLead.setDoNotCreateOpportunity(true);
                leadsToconvert.add(iLead);
            }
        }
        
        Map<Id, Id> accountConverted = new Map<Id, Id>();
        List<Database.LeadConvertResult> lcrList = new List<Database.LeadConvertResult>();
            
        if (!leadsToconvert.isEmpty()) {
            lcrList = Database.convertLead(leadsToconvert);
        }

        return lcrList;
    }


}