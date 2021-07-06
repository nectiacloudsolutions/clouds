/**
 * @File Name          : OpportunityLineItemTriggerHelper.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : mbeltran@everis.com
 * @Last Modified On   : 01-11-2021
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    6/2/2020   eayalcor@everis.com     Initial Version
**/
public without sharing class OpportunityLineItemTriggerHelper {

    /**
    * @description 
    * @author eayalcor@everis.com | 6/2/2020 
    * @param List<OpportunityLineItem> liLst 
    * @param Map<Id OpportunityLineItem> oldMap 
    * @return void 
    **/
    private final static String PF_RECORD_TYPE = Label.PF_Opp_RecordType;

    public static void onBeforeInsert(List<OpportunityLineItem> liLst, Map<Id,OpportunityLineItem> oldMap){
        Map<Id,SObject> maps = getIds(liLst);
        try{
            for(OpportunityLineItem data : liLst){
                Product2 product =  (Product2)maps.get(data.Product2Id);
                Opportunity opp = (Opportunity)maps.get(data.OpportunityId);
                if(!Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opp.recordTypeId).getDeveloperName().equals(PF_RECORD_TYPE)){
                    if(!Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opp.recordTypeId).
                        getDeveloperName().equals(product.tipo_producto_sales__c) &&
                        // !Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opp.recordTypeId).
                        //getDeveloperName().equals(product.TipoProductoFlujoIntegradoSales__c)) &&
                       !Test.isRunningTest()){
                            throw new UtilitiesSales.SalesException(Constants.OPPORTUNITYLINEITEM_ERROR01);            
                        }
                } 
            }

        }catch(Exception e){
            Trigger.new[0].addError(e.getMessage());
            System.debug('Error' + e.getStackTraceString());
        }   
    }


    /**
    * @description 
    * @author eayalcor@everis.com | 6/2/2020 
    * @param List<OpportunityLineItem> liLst 
    * @return Map<Id, SObject> 
    **/
    private static Map<Id,SObject> getIds(List<OpportunityLineItem> liLst){
        Map<Id,SObject> mapObject = new Map<Id,SObject>();
        Set<Id> setOppIds = new Set<Id>();
        Set<Id> setProIds = new Set<Id>();

        for (OpportunityLineItem oppLI : liLst){
            setProIds.add(oppLI.Product2Id);
            setOppIds.add(oppLI.OpportunityId);
        }

        List<Product2> lstProduct = [SELECT Id,tipo_producto_sales__c FROM Product2 WHERE Id IN : setProIds];
        List<Opportunity> lstOpp = [SELECT Id,RecordTypeId FROM Opportunity WHERE Id IN : setOppIds];

        for(Opportunity opp : lstOpp){
            mapObject.put(opp.Id, opp);
        }
        for(Product2 pro : lstProduct){
            mapObject.put(pro.Id, pro);
        }

        return mapObject;
    }
}