/*********************************************************************************************************
@Author       curbinav@everis.com
@name         CampaignMemberTriggerHelper
@CreateDate   01/10/2019
@Description  Helper of the CampaignMember object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
15/10/2019    curbinav@everis.com           W-000011 - Cargar Miembros de Campaña - Forma Masiva
06/11/2019    curbinav@everis.com           W-000073 - (Vista 360° Cliente) - Ingreso Sección Cliente (Resumen)
**********************************************************************************************************/
public without sharing class CampaignMemberTriggerHelper {
    //public static Boolean firstcallCM = false;

    /**
      * @description       Business logic for trigger on After Insert
      * @param1            new Records List<CampaignMember> : newCampaignMemberList
      * @return            void
      * @throws            NA
    */
    /*public static void onAfterInsert(List<CampaignMember> newCampaignMemberList) {
        System.debug('onAfterInsert[' + newCampaignMemberList.size() + ']: ' + JSON.serialize(newCampaignMemberList));
		//if(!firstcallCM){
            //Map<Id,Contact> contactMap = updateContactOwnerWithPropietarioMiembroCampana(newCampaignMemberList, true);
            //updateAccountWithActiveCampaign(contactMap);
        //}
    }*/

    /**
      * @description       Business logic for trigger on After Update
      * @param1            new Records List<CampaignMember> : newCampaignMemberList
      * @return            void
      * @throws            NA
    */
   /* public static void onAfterUpdate(List<CampaignMember> newCampaignMemberList) {
        System.debug('onAfterUpdate[' + newCampaignMemberList.size() + ']: ' + newCampaignMemberList);
		//if(!firstcallCM){
			//Map<Id,Contact> contactMap = updateContactOwnerWithPropietarioMiembroCampana(newCampaignMemberList, false);
			//updateAccountWithActiveCampaign(contactMap);
        //}
    }*/

    /*public static void updateAccountWithActiveCampaign(Map<Id,Contact> contactMap){
        //firstcallCM = true;
        // W-000073 (Vista 360° Cliente) - Ingreso Sección Cliente (Resumen)
        // Count active campaigns by contact
        Map<Id,Integer> countCampaignById = new Map<Id,Integer>();
        AggregateResult[] groupedResults = [SELECT ContactId, count(CampaignId) countCampaignId
                                            FROM CampaignMember 
                                            WHERE Campaign.IsActive = true
                                            AND ContactId in :contactMap.keySet()
                                            GROUP BY ContactId];

        if (groupedResults.size() > 0) {
            for (AggregateResult ar : groupedResults) {
                Id contactId = (Id) ar.get('ContactId');
                Integer count = (Integer) ar.get('countCampaignId');
                countCampaignById.put(contactId, count);
            }
        }
		
        Map<id, Account> accountsMap = new Map<Id, Account>();
        for (Account acc: [SELECT Id, PersonContactId FROM Account 
                           where PersonContactId in :contactMap.keySet() 
                           and IsPersonAccount = true]) {
            acc.campanas_activas_sales__c = countCampaignById.get(acc.PersonContactId);
            accountsMap.put(acc.PersonContactId, acc);
        }
        if (!accountsMap.isEmpty()) {
            update accountsMap.values();
        }        
    }*/
    
    /**
      * @description       Update Contact Owner With PropietarioMiembroCampana
      * @param1            new Records List<CampaignMember> : newCampaignMemberList
      * @return            Map<Id,Contact> Updated contacts
      * @throws            NA
    */
    /*public static Map<Id,Contact> updateContactOwnerWithPropietarioMiembroCampana(List<CampaignMember> newCampaignMemberList, Boolean flagUpdate) {
        List<Contact> contacts = new List<Contact>();
        Map<Id,CampaignMember> campaignByContactId = new Map<Id,CampaignMember>();
        
		// Actualizar Task y Event to new Owner of Contact
        for(CampaignMember cm : newCampaignMemberList) {
            
            if (cm.ContactId != null) {
                Contact contact = new Contact();
                contact.Id = cm.ContactId;
                //contact.OwnerId = cm.Propietario_Miembro_de_Campana__c;
                contacts.add(contact);
                campaignByContactId.put(cm.ContactId, cm);
            }
        }
        Map<Id,Contact> contactMap = new Map<Id,Contact>();
 		contactMap.putall(contacts);
        System.debug('ENTRO EN UPDATE MIEMBRO CAMPAÑA:' + flagUpdate);
        if (!contactMap.isEmpty() && flagUpdate) {
            System.debug('Real Contacts to update: ' + contactMap);
            update contactMap.values();
        }
        return contactMap;
    }    */
    
    
    /**
      * @description       Business logic for trigger on Before Insert
      * @param1            new Records List<CampaignMember> : newCampaignMemberList
      * @return            void
      * @throws            NA
    */
    public static void onBeforeInsert(List<CampaignMember> newCampaignMemberList) {
        System.debug('onBeforeInsert[' + newCampaignMemberList.size() + ']: ' + newCampaignMemberList);
        Set<String> rutsCliente = new Set<String>(); 
        Set<String> rutsEjecutivo = new Set<String>();
        
        List<Campaign> lstCampagin = [SELECT Description, Requiere_entrevista__c FROM Campaign WHERE Id =: newCampaignMemberList[0].CampaignId];
        
        // Extraer RUT de clientes y ejecutivos
        for(CampaignMember cm : newCampaignMemberList) {
            if (cm.RUT_sales__c != null) {
                rutsCliente.add(cm.RUT_sales__c);
            }
            if (cm.RUT_Ejecutivo_sales__c != null) {
                rutsEjecutivo.add(cm.RUT_Ejecutivo_sales__c);
            }
        }
        
        // Consultar contacto en account por rut nº documento
        Map<String, Account> accounts = new Map<String, Account>();
        for (Account acc: [SELECT Id, RUT__c, PersonContactId 
                           FROM Account 
                           WHERE RUT__c in :rutsCliente 
                           AND IsPersonAccount = true]) {
            accounts.put(acc.RUT__c, acc);
        }
        
        
        // Consultar Leads no convertidos por nº documento
        Map<String, Lead> leads = new Map<String, Lead>();
        for (Lead l: [SELECT  Id, numero_de_documento_sales__c, IsConverted
                        FROM Lead
                        WHERE numero_de_documento_sales__c in :rutsCliente 
                        AND IsConverted = false]) {
            leads.put(l.numero_de_documento_sales__c, l);
        }
        
        
        // Consultar usuarios por RUT de usuario
        Map<String, User> users = new Map<String, User>();
        for (User u: [SELECT Id, RUT__c 
                      FROM User 
                      WHERE RUT__c in :rutsEjecutivo 
                      	and Profile.UserLicense.Name = 'Salesforce']) {
            users.put(u.RUT__c, u);
        }
        
        System.debug('rutsCliente set: ' + rutsCliente);
        System.debug('rutsEjecutivo set: ' + rutsEjecutivo);
        for(CampaignMember cm : newCampaignMemberList) {
            if (cm.RUT_sales__c != null && UtilitiesSales.validarRunRut(UtilitiesSales.formatRut(cm.RUT_sales__c, Constants.WITHOUTDOT))) {
                // Buscar contact by rut
                if (accounts.containsKey(cm.RUT_sales__c)) {
                    cm.ContactId = accounts.get(cm.RUT_sales__c).PersonContactId;
                } else if (leads.containsKey(cm.RUT_sales__c)) {
                    cm.LeadId = leads.get(cm.RUT_sales__c).Id;
                } else {
                    cm.addError(String.format(Constants.CAMPAIGN_MEMBER_ERROR1, new List<Object> {cm.RUT_sales__c}));
                }
            } else {
                cm.addError(String.format(Constants.CAMPAIGN_MEMBER_ERROR2, new List<Object> {cm.RUT_sales__c}));
            }
            
            if (cm.RUT_Ejecutivo_sales__c != null && UtilitiesSales.validarRunRut(UtilitiesSales.formatRut(cm.RUT_Ejecutivo_sales__c, Constants.WITHOUTDOT))) {
                if (users.containsKey(cm.RUT_Ejecutivo_sales__c)) {
                    cm.Propietario_Miembro_de_Campana__c = users.get(cm.RUT_Ejecutivo_sales__c).Id;
                } else {
                    cm.addError(String.format(Constants.CAMPAIGN_MEMBER_ERROR3, new List<Object> {cm.RUT_Ejecutivo_sales__c}));
                }
            } else {
                cm.addError(String.format(Constants.CAMPAIGN_MEMBER_ERROR4, new List<Object> {cm.RUT_Ejecutivo_sales__c}));
            }
                        
            cm.Campana_requiere_entrevista__c = lstCampagin[0].Requiere_entrevista__c;
            cm.descripcion_campania_sales__c = lstCampagin[0].Description;
            
        }        
    } 
}