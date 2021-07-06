/**
 * @File Name          : OfferValidityBatch.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 07-29-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/12/2020   eayalcor@everis.com     Initial Version
**/
global class OfferValidityBatch implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    global Database.QueryLocator start(Database.BatchableContext BC){

        // collect the batches of records or objects to be passed to execute
        DateTime currentTime = System.now();
        String CT = currentTime.format('yyyy-MM-dd');

        return Database.getQueryLocator('SELECT Id,Name,Ejecutivo_sales__c,Rut_Cliente_sales__c,Vigencia_Oferta_sales__c,Familia_Producto_sales__c,'+
                                        'Descripcion_oferta_sales__c,Detalle_sales__c,Origen_sales__c,Interes_Oferta_sales__c,OpportunityId__c, Motivo_no_interes_sales__c,' +
                                        'comentario_oferta_sales__c, telefono_ivr_sales__c FROM Oferta__c WHERE Vigente_sales__c = true AND Estado_Oferta_sales__c = \''+CONSTANTS.OFERTA_NOGESTIONADO+'\' AND '+
                                        'Vigencia_Oferta_sales__c <'+CT);

    }
     
    global void execute(Database.BatchableContext BC, List<Oferta__c> lstObj){
            List<Oferta__c> lstOffer = new List<Oferta__c>();

            for(Oferta__c offer : lstObj){
                offer.Vigente_sales__c = false;
                offer.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: Constants.OFERTA_SALES_RECORDTYPE_LECTURA AND SobjectType =: Constants.OFERTA LIMIT 1].Id;
                offer.OpportunityId__c = offer.OpportunityId__c == null ? null : offer.OpportunityId__c;
                offer.Motivo_no_interes_sales__c = offer.Motivo_no_interes_sales__c == null ? null : offer.Motivo_no_interes_sales__c;  
                offer.comentario_oferta_sales__c = offer.comentario_oferta_sales__c == null ? null : offer.comentario_oferta_sales__c; 
                offer.telefono_ivr_sales__c = offer.telefono_ivr_sales__c == null ? null : offer.telefono_ivr_sales__c; 
                lstOffer.add(offer);
            }

            SalesCallout sc = new SalesCallout(Constants.ANALYTICSLEAD);
            OfferCmpController.NotifyAnalyticOffer obj = new OfferCmpController.NotifyAnalyticOffer();
            obj.code = 200;
            obj.message = null;
            obj.action = Constants.INSERTED;
            obj.OfertaList = lstOffer;

            sc.notifyAnalyticsOffer(obj);

            List<Database.UpsertResult> updateResults = Database.upsert(lstOffer,false);

    }   
     
    global void finish(Database.BatchableContext BC){
        // execute any post-processing operations like sending email
    }
}