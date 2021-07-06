/*********************************************************************************************************
@Author       curbinav@everis.com
@name         ProductoDelClienteTriggerHelper
@CreateDate   01/10/2019
@Description  Helper of the ProductoDelCliente object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
07/11/2019    curbinav@everis.com           W-000073 - (Vista 360° Cliente) - Ingreso Sección Cliente (Resumen)
**********************************************************************************************************/
public class ProductoDelClienteTriggerHelper {

    /**
      * @description       Business logic for update multiproducto flag on Account record
      * @param1            new Records List<Producto_Del_Cliente> : newProductoDelClienteList
      * @return            void
      * @throws            NA
    */
    public static void onAfterInsert(List<Producto_Del_Cliente__c> newProductoDelClienteList) {
        System.debug('ProductoDelClienteTriggerHelper.onAfterInsert[' + newProductoDelClienteList + ']: ');
        
        Set<Id> ids = new Set<Id>();
        Map<Id, Integer> grpPdc2 = new Map<Id, Integer>();
        Map<Id, Account> accountsMap = new Map<Id, Account>();
        if (newProductoDelClienteList != null) {
            for (Producto_Del_Cliente__c pdc : newProductoDelClienteList) {
                System.debug('pdc.Cliente_Nectia__c: ' + pdc.Cliente_Nectia__c);
                ids.add(pdc.Cliente_Nectia__c);
            }
            System.debug('ids: ' + ids);

            List<Producto_Del_Cliente__c> pdcList = new List<Producto_Del_Cliente__c>();

            String lastCN = null;
            for (Producto_Del_Cliente__c pdc : [SELECT Cliente_Nectia__c, L_nea__c 
                                                FROM Producto_Del_Cliente__c
                                                WHERE Cliente_Nectia__c in :ids
                                                order by Cliente_Nectia__c, L_nea__c]) {
            System.debug('pdc: ' + pdc);

                if (!grpPdc2.containsKey(pdc.Cliente_Nectia__c)){
                    grpPdc2.put(pdc.Cliente_Nectia__c, 1);
                } else {
                    if (pdc.L_nea__c != lastCN) {
                        grpPdc2.put(pdc.Cliente_Nectia__c, grpPdc2.get(pdc.Cliente_Nectia__c) + 1);
                    }
                }
                lastCN = pdc.L_nea__c;
            }
        }
        
        for (Id accId : grpPdc2.keySet()){
            Account acc = new Account();
            acc.Id = accId;
            Boolean multiproducto = grpPdc2.get(accId) > 1 ? true : false;
            acc.Multiproducto_sales__c = multiproducto;
            accountsMap.put(accId, acc);
        }
        System.debug('grpPdc2: ' + grpPdc2);
        System.debug('accountsMap: ' + accountsMap);
        
        if (!accountsMap.isEmpty()) {
            System.debug('accountsMap to update: ' + accountsMap.values());
            update accountsMap.values();
        }






/*        
        Map<Id,Account> accountsMap = new Map<Id,Account>();

        AggregateResult[] groupedResults = [SELECT  Cliente_Nectia__c, count(id) countAccountId
                                            FROM Producto_Del_Cliente__c 
                                            GROUP BY Cliente_Nectia__c];
        System.debug('COUNT Cliente_Nectia__c QUERY: ' + groupedResults);
        if (groupedResults.size() > 0) {
            for (AggregateResult ar : groupedResults) {
                Id accountId = (Id) ar.get('Cliente_Nectia__c');
                Integer countAccountId = (Integer) ar.get('countAccountId');
                Account acc = new Account();
                acc.Id = accountId;
                Boolean multiproducto = countAccountId > 1 ? true : false;
                acc.Multiproducto_sales__c = multiproducto;
                accountsMap.put(accountId, acc);
            }
        }
*/       
    }
    
}