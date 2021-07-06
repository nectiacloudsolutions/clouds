/**
 * @File Name          : OfferCmpController.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 6/12/2020, 1:48:06 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/1/2020   eayalcor@everis.com     Initial Version
**/
public with sharing class OfferCmpController {

    /**
    * @description 
    * @author eayalcor@everis.com | 6/1/2020 
    * @param Id offerId 
    * @return responseData 
    **/
    @AuraEnabled
    public static responseData getInitialData(Id offerId){
        ResponseData data = new ResponseData();

        List<Oferta__c> lstOffer = [SELECT Id,Name,AccountId__c,Ejecutivo_sales__c,Rut_Cliente_sales__c,Vigente_sales__c,
        Familia_Producto_sales__c,Vigencia_Oferta_sales__c,Motivo_no_interes_sales__c,Estado_Oferta_sales__c FROM Oferta__c WHERE Id =: offerId];

        data.reasons = UtilitiesSales.getPicklistData(Oferta__c.Motivo_no_interes_sales__c);

        if(lstOffer!= null || !lstOffer.isEmpty()){
            data.offer = lstOffer[0];
        }else{
            data.offer = null;
        }

        return data;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 6/1/2020 
    * @param Id offerId 
    * @param String reason 
    * @return string 
    **/
    @AuraEnabled
    public static string rejectOffer(Id offerId,String reason){
        try{
            Oferta__c offer = new Oferta__c();
            offer.Id = offerId;
            offer.Interes_Oferta_sales__c = Constants.OFERTA_NOINTERESADO;
            offer.Estado_Oferta_sales__c = Constants.OFERTA_GESTIONADO;
            offer.Motivo_no_interes_sales__c = reason;
            offer.Vigente_sales__c = false;
            offer.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: Constants.OFERTA_SALES_RECORDTYPE_LECTURA AND SobjectType =: Constants.OFERTA LIMIT 1].Id;
            update offer;
    
            return Constants.OK;

        }catch (Exception ex){
            return 'ERROR: Contactar a su Administrador';
        }finally {
            Set<Id> setOffers = new Set<Id>{offerId};
            SalesCallout.futureNotifyAnalyticsOffer(setOffers, Constants.INSERTED);
        }
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 6/1/2020 
    * @param Id offerId 
    * @return string 
    **/
    @AuraEnabled
    public static string generateOpportunity(Id offerId,String obs){
        try{
            List<Oferta__c> lstOffer = [SELECT Id,Name,AccountId__c, telefono_ivr_sales__c, Ejecutivo_sales__c,Rut_Cliente_sales__c,AccountId__r.firstName,Vigente_sales__c,comentario_oferta_sales__c,
            AccountId__r.lastName,Familia_Producto_sales__c,Vigencia_Oferta_sales__c,Motivo_no_interes_sales__c,Estado_Oferta_sales__c,Origen_sales__c,Owner_Opp_sales__c,Descripcion_oferta_sales__c  
            FROM Oferta__c WHERE Id =: offerId];

            String rtByFamily = UtilitiesSales.getRTbyFamilyProduct(lstOffer[0].Familia_Producto_sales__c);
            Integer count =[SELECT COUNT() FROM Opportunity WHERE AccountId=:lstOffer[0].AccountId__c]+1;
            /*
            Creación Opportunity
            */
            Opportunity newOpp = new Opportunity();
            newOpp.StageName = Constants.OPPORTUNITY_STAGE_CONTACTO;
            newOpp.CloseDate = Date.TODAY().addMonths(1);
            newOpp.AccountId = lstOffer[0].AccountId__c;
            newOpp.Name = lstOffer[0].Familia_Producto_sales__c + ' - ' + count +' - '+lstOffer[0].AccountId__r.firstName + ' '+lstOffer[0].AccountId__r.lastName;
            newOpp.origen_de_oportunidad_sales__c = lstOffer[0].Origen_sales__c;
            newOpp.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: rtByFamily LIMIT 1].Id;
            newOpp.OwnerId = lstOffer[0].Owner_Opp_sales__c;
            newOpp.comentario_oferta_sales__c = obs;
            newOpp.Flag_Banca_Nueva_Oportunidad_sales__c = true;
            newOpp.Descripcion_Analitycs__c = lstOffer[0].Descripcion_oferta_sales__c;
            newOpp.telefono_oportunidad_sales__c = lstOffer[0].telefono_ivr_sales__c;
            newOpp.flag_creacion_oferta_sales__c = true;
            insert newOpp;

            lstOffer[0].Interes_Oferta_sales__c = Constants.OFERTA_INTERESADO;
            lstOffer[0].Estado_Oferta_sales__c = Constants.OFERTA_GESTIONADO;
            lstOffer[0].OpportunityId__c = newOpp.Id;
            lstOffer[0].Vigente_sales__c = false;
            lstOffer[0].comentario_oferta_sales__c = obs;
            lstOffer[0].RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =: Constants.OFERTA_SALES_RECORDTYPE_LECTURA AND SobjectType =: Constants.OFERTA LIMIT 1].Id;

            update lstOffer;

            return Constants.OK;


        }catch(Exception ex){
            System.debug('ERROR:' +ex.getStackTraceString() + ' ' + ex.getMessage());
            return 'ERROR: Contactar a su Administrador';
        }finally {
            Set<Id> setOffers = new Set<Id>{offerId};
            SalesCallout.futureNotifyAnalyticsOffer(setOffers, Constants.INSERTED);
        }
    }

    public class ResponseData{
        @AuraEnabled public List<String> reasons;
        @AuraEnabled public Oferta__c offer;
    }

    public class NotifyAnalyticOffer{
        public String message {get;set;}
        public Integer code {get;set;}
        public String action {get;set;}
        public List<Oferta__c> OfertaList;

    }
}