/**
 * @File Name          : QuoteTriggerHelper.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 3/10/2020, 4:13:50 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    3/10/2020   eayalcor@everis.com     Initial Version
**/
public with sharing class QuoteTriggerHelper {

    /**
    * @description 
    * @author eayalcor@everis.com | 3/10/2020 
    * @param List<Quote> qtLst 
    * @param Map<Id Quote> oldMap 
    * @return void 
    **/
    public static void onBeforeUpdate(List<Quote> qtLst, Map<Id,Quote> oldMap){
        try{
            for (Quote quote : qtLst){
                if(quote.IsSyncing!= oldMap.get(quote.Id).IsSyncing){
                    if(!Consorcio_Org__c.getInstance(UserInfo.getProfileId()).Sincronizar_sales__c){
                        throw new UtilitiesSales.SalesException('Usuario no posee permisos para Sincronizar el presupuesto');           
                    }
                }
        	}
        }catch(Exception e){
            System.debug('Exception Message:' + e.getMessage());
            Trigger.new[0].addError(e.getMessage());
        }

    }
}