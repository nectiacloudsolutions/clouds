/**
 * @description       : Helper de Account para Sales B2B
 * @author            : mbeltran@everis.com
 * @group             : 
 * @last modified on  : 11-27-2020
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-26-2020   mbeltran@everis.com   Initial Version
**/
public without sharing class AccountTriggerHelperB2B {

    public static final String RT_ACCOUNT_EMPRESA_BANCO = 'Cliente_Empresa_Banco';
    public static final String ACCOUNT_ESTADO_NECTIA_PROSPECTO = 'Prospecto';
    public static final String ACCOUNT_ESTADO_CLIENTE_BANCA_EMPRESAS = 'Cliente';

    /**
    * @description: Obtiene lista de Ruts para validar si existe en Account
    * @author mbeltran@everis.com | 08-26-2020 
    * @param Set<String> RUTs 
    * @return Map<String, Account> 
    **/
    public static Map<String,Account> getAccountsbyRUT(Set<String> RUTs){
        Map<String,Account> maps = new Map<String,Account>();
        for(Account Acc : [SELECT Id,RUT__c, RecordType.IsPersonType, Estado_Cliente_Banca_Empresas__c
                      	FROM Account WHERE RUT__c IN :RUTs]){
            maps.put(Acc.Rut__c, Acc);
        }
        return maps;
    }

    /**
    * @description 
    * @author mbeltran@everis.com | 09-15-2020 
    * @param Set<String> RUTs 
    * @return Map<String, Contact> 
    **/
    public static Map<String,Contact> getPrincipalContactfromAccountsbyRUTAccount(Set<String> RUTs){
        Map<String,Contact> maps = new Map<String,Contact>();
        System.debug(RUTs);
        for(Account Acc : [SELECT Id, RUT__c ,(select id from contacts where Contacto_Principal__c = true)
                      	FROM Account WHERE RUT__c IN :RUTs]){
                            
                            //List<Contact> Contactos = Acc.Contacts.size() > 0 ? Acc.Contacts.get(0):new list<Contact>();

                            if(Acc.Contacts.size()> 0)
                                maps.put(Acc.Rut__c, Acc.Contacts.get(0));

                            // if(!Contactos.isEmpty()){
                                //maps.put(Acc.Rut__c, Acc.Contacts.get(0));
                                //maps.put(Acc.Rut__c, Acc.Contacts.get(0));
                           // }
        }
        return maps;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   RECORD_TYPE_MAP_DEVELOPERNAME of Account object
    */
    public static Map<String, RecordType> RECORD_TYPE_MAP_DEVELOPERNAME{
        get{
            if (RECORD_TYPE_MAP_DEVELOPERNAME == null){

            	RECORD_TYPE_MAP_DEVELOPERNAME = new Map<String, RecordType>();

            	List<RecordType> lstRecordType = [SELECT Id, Name,
								            	  DeveloperName 
								            	  FROM RecordType 
								            	  WHERE SobjectType =: Account.sObjectType.getDescribe().getName() 
            									  ];

            	for (RecordType iRecordType : lstRecordType){
            		RECORD_TYPE_MAP_DEVELOPERNAME.put(iRecordType.DeveloperName, iRecordType);
            	}
            }
            return RECORD_TYPE_MAP_DEVELOPERNAME;
        }
        set;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Map of RecordTypeInfo
    */
    public static String getRecordTypeId (String developerName){
        return RECORD_TYPE_MAP_DEVELOPERNAME.get(developerName).Id;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Get Map<Id, Account> by Ids
    */
    public static Map<Id, Account> getAccountsAndContacts(Set<Id> setAccountId){
        Map<Id, Account> mapAccounts = new Map<Id, Account>(
        [
            SELECT Id, Name, RUT__c, Rut_Ejecutivo_Banco__c,
                Calle_Nectia__c, NumberOfEmployees, 
                SBIF_Comercial__c, SBIF_Contingente__c, 
                SBIF_Leasing__c, Venta_Anual__c,
                Ebitda__c, Utilidad__c, Patrimonio__c, 
                Moneda__c, Cuenta_Corriente__c, 
                Creditos_Comerciales__c, Leasing__c, 
                Comex__c, Boletas_Garantia__c,
                Cash_Management__c, Mesa_de_Dinero__c,
                Financiamiento_Inmobiliario__c, 
                (SELECT Id, FirstName, Email,
                    Contacto_Principal__c, 
                    LastName, AccountId 
                FROM Contacts)
            FROM Account 
            WHERE Id IN: setAccountId
        ]);

        return mapAccounts;
    }

}