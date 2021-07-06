/**
 * @description       : 
 * @author            : ggonzroj@everis.com
 * @group             : 
 * @last modified on  : 10-29-2020
 * @last modified by  : ggonzroj@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-21-2020   ggonzroj@everis.com   Initial Version
**/
public with sharing class LineaBancariaHelperB2b {
    public static String PKL_BANCO_CONSORCIO = 'Banco Consorcio';
    
    /**
      * @description       This method return list with the Linea_Bancaria__c Records
      * @param1            Set<Id> Id del prospecto
      * @return            List Linea_Bancaria__c
    */
    public static List<Linea_Bancaria__c> getLineasBancariasByLeadId(Set<Id> idsLeads){
        return [SELECT Id, Id_Prospecto__c, Banco__c, Monto_Aprobado__c, Monto_Utilizado__c FROM Linea_Bancaria__c WHERE Id_Prospecto__c IN: idsLeads];
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Helper Map de Account con lista de Linea_Bancaria__c relacionadas.
    */
    public static Map<Id, List<Linea_Bancaria__c>> getlineasBancariaByAccount (Set<Id> accountds) {
        Map<Id, List<Linea_Bancaria__c>> lbacnariasMap = new Map<Id, List<Linea_Bancaria__c>>();
        for (Linea_Bancaria__c linea : [SELECT Id, Id_Prospecto__c, Banco__c, Account__c,
                                            Monto_Aprobado__c, Monto_Utilizado__c
                                        FROM Linea_Bancaria__c 
                                        WHERE Account__c IN: accountds]){
            if (!lbacnariasMap.containsKey(linea.Account__c)) {
                lbacnariasMap.put(linea.Account__c, new List<Linea_Bancaria__c> {linea});
            } else {
                lbacnariasMap.get(linea.Account__c).add(linea);
            }
        }
        return lbacnariasMap;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Helper Map de Account con lista de Linea_Bancaria__c relacionadas.
    */
    public static Map<Id, List<Linea_Bancaria__c>> getlineasBancariaByLead (Set<Id> leadIds) {
        Map<Id, List<Linea_Bancaria__c>> lbacnariasMap = new Map<Id, List<Linea_Bancaria__c>>();
        for (Linea_Bancaria__c linea : [SELECT Id, Id_Prospecto__c, Banco__c, Account__c,
                                                Monto_Aprobado__c, Monto_Utilizado__c, OwnerId
                                        FROM Linea_Bancaria__c 
                                        WHERE Id_Prospecto__c IN: leadIds ]){
            if (!lbacnariasMap.containsKey(linea.Id_Prospecto__c)) {
                lbacnariasMap.put(linea.Id_Prospecto__c, new List<Linea_Bancaria__c> {linea});
            } else {
                lbacnariasMap.get(linea.Id_Prospecto__c).add(linea);
            }
        }
        return lbacnariasMap;
    }

}