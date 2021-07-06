/**
 * @File Name          : QuoteTriggerHandler.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 3/10/2020, 1:00:11 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    3/10/2020   eayalcor@everis.com     Initial Version
**/
public with sharing class QuoteTriggerHandler {

    private static QuoteTriggerHandler instance = null;

    /**
    * @description 
    * @author pcelis@everis.com | 10-03-2020 
    * @return QuoteTriggerHandler 
    **/
    public static QuoteTriggerHandler getInstance() {
        if (instance == null){
            instance = new QuoteTriggerHandler();
        }    
        return instance;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 3/10/2020 
    * @param List<Quote> qtLst 
    * @param Map<Id Quote> oldMap 
    * @return void 
    **/
    public void onBeforeUpdate(List<Quote> qtLst, Map<Id,Quote> oldMap){
        QuoteTriggerHelper.onBeforeUpdate(qtLst, oldMap);   
    }
}