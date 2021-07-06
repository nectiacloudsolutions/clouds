public with sharing class CONS_modalbotones {

    @AuraEnabled
    public static string getAccount(Id accountId) {
        // Perform isAccessible() checks here
         system.debug('accountId'+accountId);
       // Account acc =[SELECT Name, BillingCity, BillingState FROM Account WHERE Id = :accountId];
      //  system.debug('acc='+acc);
        string res=accountId;
        system.debug('accountId'+res);
        return accountId;
    }
    
    @AuraEnabled
    public static Contact saveContactWithAccount(Contact contact, Id accountId) {
        // Perform isAccessible() and isUpdateable() checks here
        contact.AccountId = accountId;
        system.debug('contact'+contact);
        upsert contact;
        return contact;
    }

}