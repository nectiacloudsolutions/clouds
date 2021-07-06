/**
 * @File Name          : OpportunityLineItemTriggerHandler.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 6/2/2020, 12:15:17 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/2/2020   eayalcor@everis.com     Initial Version
**/
public with sharing class OpportunityLineItemTriggerHandler {
    private static OpportunityLineItemTriggerHandler instance = null;
    
    /**
    * @description 
    * @author eayalcor@everis.com | 6/2/2020 
    * @return OpportunityLineItemTriggerHandler 
    **/
    public static OpportunityLineItemTriggerHandler getInstance() {
        if (instance == null){
            instance = new OpportunityLineItemTriggerHandler();
        }    
        return instance;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 6/2/2020 
    * @param List<OpportunityLineItem> liLst 
    * @param Map<Id OpportunityLineItem> oldMap 
    * @return void 
    **/
    public void onBeforeInsert(List<OpportunityLineItem> liLst, Map<Id,OpportunityLineItem> oldMap){
        OpportunityLineItemTriggerHelper.onBeforeInsert(liLst, oldMap);   
    }

}