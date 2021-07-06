/**
* @File Name          : OpportunityTriggerHandler.cls
* @Description        : 
* @Author             : pcelis@everis.com
* @Group              : 
* @Last Modified By   : pcelis@everis.com
* @Last Modified On   : 03-02-2020 16:40:57
* @Modification Log   : 
* Ver       Date            Author      		    Modification
* 1.0    03-02-2020   pcelis@everis.com     Initial Version
**/
public with sharing class OpportunityTriggerHandler {
    private static OpportunityTriggerHandler instance = null;
    
    
    /**
* @description 
* @author pcelis@everis.com | 03-02-2020 
* @return OpportunityTriggerHandler 
**/
    public static OpportunityTriggerHandler getInstance() {
        if (instance == null){
            instance = new OpportunityTriggerHandler();
        }    
        return instance;
    }
    
    /**
* @description 
* @author pcelis@everis.com | 03-02-2020 
* @param List<Opportunity> oppLst 
* @return void 
**/
    public void onAfterInsert(List<Opportunity> oppLst){
        //UserTriggerHelper.onAfterInsert(usrLst);
    }
    
    /**
* @description 
* @author pcelis@everis.com | 03-02-2020 
* @param List<Opportunity> oppLst 
* @param Map<Id Opportunity> oldMap 
* @return void 
**/
    public void onBeforeUpdate(List<Opportunity> oppLst, Map<Id,Opportunity> oldMap){
        OpportunityTriggerHelper.onBeforeUpdate(oppLst, oldMap);
        OpportunityTriggerPFHelper.verificationRecordType(oppLst, oldMap);
        
    }
    
    
    /**
* @description 
* @author pcelis@everis.com | 03-02-2020 
* @param List<Opportunity> oppLst 
* @param Map<Id Opportunity> oldMap 
* @return void 
**/
    public void onAfterUpdate(List<Opportunity> oppLst, Map<Id,Opportunity> oldMap){
        OpportunityTriggerHelper.onAfterUpdate(oppLst, oldMap);
        
    }
    
    /**
* @description 
* @author gcabrerp@everis.com | 24-11-2020 
* @param List<Opportunity> oppLst 
* @param Map<Id Opportunity> oldMap 
* @return void 
**/
    public void onAfterInsertUpdate(List<Opportunity> oppLst, Map<Id,Opportunity> oldMap){
        OpportunityTriggerPFHelper.createTaskByOpps(oppLst, oldMap);
        OpportunityTriggerPFHelper.verificationRecordType(oppLst, oldMap);
        
    }
}