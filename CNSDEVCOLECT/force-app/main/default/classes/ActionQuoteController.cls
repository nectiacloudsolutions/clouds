public without sharing class ActionQuoteController { 

    @AuraEnabled
    public static QuoteWrapper getData(String oppId){
        QuoteWrapper objWrapper = new QuoteWrapper();
        objWrapper.status = false;
        objWrapper.typeAlert = Constants.TOAST_WARNING;

        List<Opportunity> lstOpp = [SELECT Id,StageName, RecordTypeId,(SELECT Id,Product2Id FROM OpportunityLineItems) FROM Opportunity 
                        WHERE Id =: oppId];
        List<URL_Cotizadores__mdt> cmdt = [SELECT DeveloperName ,URL__c , Producto__c  FROM URL_Cotizadores__mdt ];
        
        if(lstOpp != null && !lstOpp.isEmpty()){
			
            if(lstOpp[0].stageName.equalsIgnoreCase(Constants.OPPORTUNITY_STAGE_INGRESO_NEGOCIO) ||
                lstOpp[0].stageName.equalsIgnoreCase(Constants.OPPORTUNITY_STAGENAME_COTIZACION) && 
                                                     (Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(lstOpp[0].RecordTypeId).getDeveloperName() == Constants.RECORDTYPE_SEGURO_VIDA_COTIZADOR 
                                                      ||Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(lstOpp[0].RecordTypeId).getDeveloperName() == Constants.RECORDTYPE_AUTO)){

                List<Product2> lstProduct = [SELECT flujo_integrado_sales__c, name FROM Product2 
                    WHERE Id =: lstOpp[0].OpportunityLineItems[0].Product2Id];

                if(lstProduct != null && !lstProduct.isEmpty()){
                    if((lstProduct[0].flujo_integrado_sales__c && 
                             Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(lstOpp[0].RecordTypeId).getDeveloperName() == Constants.RECORDTYPE_SEGURO_VIDA_COTIZADOR &&
                            FlujoCotizador__c.getInstance(UserInfo.getUserId()).Cotizador__c) || (lstProduct[0].flujo_integrado_sales__c && Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(lstOpp[0].RecordTypeId).getDeveloperName() == Constants.RECORDTYPE_AUTO &&
                            FlujoCotizador__c.getInstance(UserInfo.getUserId()).Cotizador__c)){
                            if(!cmdt.isEmpty()){
                                for(URL_Cotizadores__mdt cm : cmdt){
                                    if(cm.Producto__c.equalsIgnoreCase(lstProduct[0].name)){
                                        objWrapper.url= cm.url__c+lstopp[0].Id;
                                    }
                                }
                            }
                            objWrapper.status = true;
                            objWrapper.message = Constants.OK;

                    
                    }else{
                        objWrapper.message = Constants.MESSAGE_COTIZADOR_NO_TIENE_PERMISO;
                    }
                }else{   
                    objWrapper.message = Constants.OPPORTUNITY_ERROR_EXCEPTION;
                    objWrapper.typeAlert = Constants.TOAST_ERROR;
                }
            }else{
                objWrapper.message = Constants.MESSAGE_COTIZADOR_ETAPA;
            }        
        }else{
            objWrapper.message = Constants.OPPORTUNITY_ERROR_EXCEPTION;
            objWrapper.typeAlert = Constants.TOAST_ERROR;
        }

        return objWrapper;
    }


    public class QuoteWrapper{
        @AuraEnabled public String message;
        @AuraEnabled public String url;
        @AuraEnabled public Boolean status;
        @AuraEnabled public String typeAlert;
      
    }

    public class QuoteWrapperRequest{
        public String opportunity_id;
    }

    public class QuoteWrapperResponse{
        public String url;
    }
}