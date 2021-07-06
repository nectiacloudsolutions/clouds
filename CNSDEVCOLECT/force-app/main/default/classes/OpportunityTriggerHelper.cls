/**
* @File Name          : OpportunityTriggerHelper.cls
* @Description        : 
* @Author             : pcelis@everis.com
* @Group              : 
* @Last Modified By   : pcelisbe@everis.com
* @Last Modified On   : 09-14-2020
* @Modification Log   : 
* Ver       Date            Author      		    Modification
* 1.0    03-02-2020   pcelis@everis.com     Initial Version
**/
public without sharing class OpportunityTriggerHelper {
    public static boolean flag_recordtype = false;
    public static boolean flag_rompeCiclodeUpdate = false;
    
    public static void onBeforeUpdate(List<Opportunity> oppLst, Map<Id,Opportunity> oldMap){
        try{
            for (Opportunity opp : oppLst){
                if(opp.OwnerId!= oldMap.get(opp.Id).OwnerId){
                    if(!Consorcio_Org__c.getInstance(UserInfo.getProfileId()).Cambiar_Propietario_sales__c && !ReferralButtonController.referirBtn){
                        throw new UtilitiesSales.SalesException('Usuario no posee permisos para modificar propietario');           
                    }
                }
            }
        }catch(Exception e){
            Trigger.new[0].addError(e.getMessage());
        }
        
    }
    
    /**
    * @description 
    * @author pcelis@everis.com | 03-02-2020 
    * @param List<Opportunity> oppLst 
    * @return void 
    **/
    public static void onAfterInsert(List<Opportunity> oppLst){
        
    }
    
    /**
    * @description 
    * @author pcelis@everis.com | 03-02-2020 
    * @param List<Opportunity> oppLst 
    * @param Map<Id Opportunity> oldMap 
    * @return void 
    **/
    public static void onAfterUpdate(List<Opportunity> oppLst, Map<Id,Opportunity> oldMap){
        try{   
            List<String> lstReportToSend = new List<String>();
            List<String> lstReportOwner = new List<String>();
            List<Id> lstOppSuccess= new List<Id>();
            List<Id> lstNewOppPlan= new List<Id>();
            
            for (Opportunity l : oppLst){
                
                if(l.StageName != oldMap.get(l.Id).StageName){
                    lstReportToSend.add(l.Id);
                    system.debug(l.StageName+ ' test '+oldMap.get(l.Id).StageName);
                    if(l.StageName == Constants.OPPORTUNITY_STAGENAME_COTIZACION || l.StageName == Constants.OPPORTUNITY_STAGENAME_SIMULACION){
                        if(oldMap.get(l.Id).StageName == Constants.OPPORTUNITY_STAGE_INGRESO_NEGOCIO &&  l.StageName == Constants.OPPORTUNITY_STAGENAME_COTIZACION){
                            flag_recordtype = true;
                        }else{
                            lstOppSuccess.add(l.Id);
                            if (lstOppSuccess != null && !lstOppSuccess.isEmpty()) {               
                                updateOpportunitySuccess(lstOppSuccess);
                            }
                        }
                    }
                    

                    if (((Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(l.RecordTypeId).getDeveloperName() == Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO || 
                          Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(l.RecordTypeId).getDeveloperName() == Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO_LECTURA)
                        && l.StageName == Constants.OPPORTUNITY_STAGENAME_FORMALIZACION && oldMap.get(l.Id).StageName != Constants.OPPORTUNITY_STAGENAME_CURSE) || 
                       		((Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(l.RecordTypeId).getDeveloperName() == Constants.RECORDTYPE_BANCA_HIPOTECARIO || 
                             Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(l.RecordTypeId).getDeveloperName() == Constants.RECORDTYPE_BANCA_HIPOTECARIO_LECTURA)
                        && l.StageName == Constants.OPPORTUNITY_STAGENAME_FORMALIZACION && oldMap.get(l.Id).StageName != Constants.OPPORTUNITY_STAGENAME_INSCRIPCION 
                        && l.origen_de_oportunidad_sales__c!=null && l.origen_de_oportunidad_sales__c!='Web Privado' && l.origen_de_oportunidad_sales__c!='Web Público')) {

                        lstNewOppPlan.add(l.Id);
                    } 
                }
                if (l.OwnerId!= oldMap.get(l.Id).OwnerId) {
                    lstReportOwner.add(l.Id);        
                }

            }
            
            if (lstNewOppPlan != null && !lstNewOppPlan.isEmpty()) {
                createNewOppPlan(lstNewOppPlan);
            }
            if (!lstReportToSend.isEmpty()) {
                SalesCallout.consultOppAnalyticsAsyncMassive(lstReportToSend,CONSTANTS.CHANGE_STATUS,CONSTANTS.ANALYTICSLEAD);
            }
            if (!lstReportOwner.isEmpty()) {
                SalesCallout.consultOppAnalyticsAsyncMassive(lstReportOwner,CONSTANTS.CHANGE_OWNER,CONSTANTS.ANALYTICSLEAD);
            }
            
        }catch(Exception e){
            system.debug('Exception --->'+e.getMessage() + e.getStackTraceString());
            if(!test.isRunningTest()){
                Trigger.new[0].addError(e.getMessage());    
            }
            
        } 
        
    }
    
    
    private static void createNewOppPlan(List<Id> lstIdsOpp){
        Integer cont = 0;
        Map<String, Id> mapRTOpp = new Map<String, Id>();
        Map<Integer, String> docTypes = CONSTANTS.DOC_TYPES_PP;
        Map<Id,List<documento_oportunidad_sales__c>> mapOppDocs= new Map<Id,List<documento_oportunidad_sales__c>>();
        Map<Id,Id> mapOppNewDocs= new Map<Id,Id>();
        Map<Id,List<documento_oportunidad_sales__c>> mapOppDocsPlan= new Map<Id,List<documento_oportunidad_sales__c>>();
        Map<Id,Id> mapPartOpp= new Map<Id,Id>();
        List<Opportunity> lstOppToCreate = new List<Opportunity>();
        List<User> userEsp = [SELECT Id, Name FROM User WHERE Profile.Name =: Constants.PROFILE_EJECUTIVO_ESPECIALISTA AND isActive = TRUE LIMIT 1];
        List<documento_oportunidad_sales__c> docsToCreate = new List<documento_oportunidad_sales__c>();
        List<documento_oportunidad_sales__c> docsToUpdate = new List<documento_oportunidad_sales__c>();
        Map<Id,Boolean> mapValidate= UtilitiesSales.validateHasPlanPlus(lstIdsOpp);

        for (RecordType rt : [SELECT Id, DeveloperName, SobjectType  FROM RecordType WHERE SobjectType =: Constants.OPPORTUNITY]) {
            mapRTOpp.put (rt.DeveloperName,rt.Id);
        }
        List<Opportunity> lstOpp = [SELECT Id, StageName, RecordTypeId, Name,OwnerId, Numero_de_documento_sales__c, AccountId, fecha_creacion_sales__c, telefono_oportunidad_sales__c,  
                                    correo_oportunidad_sales__c, tipo_contrato_sales__c,Account.Name FROM Opportunity WHERE Id IN :lstIdsOpp]; 
        for (participante_sales__c par : [SELECT estado_participante_sales__c, opportunity_participante_sales__c,Name,Cliente_sales__c FROM participante_sales__c WHERE opportunity_participante_sales__r.Id IN : lstIdsOpp AND estado_participante_sales__c = 'Vigente']){
            mapPartOpp.put(par.Cliente_sales__c, par.opportunity_participante_sales__c);
        }
        List<documento_oportunidad_sales__c> oppDocs = new List<documento_oportunidad_sales__c>();
        Map<Id,String> mapsName= nameOpp(lstOpp);
        
        if (lstOpp != null && !lstOpp.isEmpty()) {
            for(Opportunity opp : lstOpp){
                if(opp.RecordTypeId == mapRTOpp.get(Constants.RECORDTYPE_BANCA_HIPOTECARIO)
                   || opp.RecordTypeId == mapRTOpp.get(Constants.RECORDTYPE_BANCA_HIPOTECARIO_LECTURA)
                      || opp.RecordTypeId == mapRTOpp.get(Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO)
                  		|| opp.RecordTypeId == mapRTOpp.get(Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO_LECTURA)){
                       Opportunity newOpp = new Opportunity(AccountId =  opp.AccountId,
                                                            Flag_Banca_Nueva_Oportunidad_sales__c = true,
                                                            Name = mapsName.get(opp.AccountId),
                                                            OwnerId = userEsp[0].Id,
                                                            Negocio_de_Origen_sales__c = opp.Id,
                                                            StageName = Constants.OPPORTUNITY_STAGE_CONTACTO,
                                                            CloseDate=Date.today().AddDays(30),
                                                            tipo_contrato_sales__c = opp.tipo_contrato_sales__c,
                                                            RecordTypeId = mapRTOpp.get(Constants.RECORDTYPE_BANCA_PLAN_PLUS));
                       lstOppToCreate.add(newOpp);
                       for(Id key : mapPartOpp.keyset()){
                           System.debug('Cliente Participante Id'  + key);
                           if(mapPartOpp.get(key) == opp.Id){
                               Opportunity newOpp1 = new Opportunity(AccountId =  key,
                                                                     Flag_Banca_Nueva_Oportunidad_sales__c = true,
                                                                     Name = opp.Name,
                                                                     OwnerId = userEsp[0].Id,
                                                                     Negocio_de_Origen_sales__c = opp.Id,
                                                                     StageName = Constants.OPPORTUNITY_STAGE_CONTACTO,
                                                                     CloseDate=Date.today().AddDays(30),
                                                                     tipo_contrato_sales__c = opp.tipo_contrato_sales__c,
                                                                     RecordTypeId = mapRTOpp.get(Constants.RECORDTYPE_BANCA_PLAN_PLUS));
                               lstOppToCreate.add(newOpp1);
                           }
                       }
                       
                   }else if (!mapValidate.containsKey(Opp.AccountId)) {
                    Opportunity newOpp = new Opportunity(AccountId =  opp.AccountId,
                    Flag_Banca_Nueva_Oportunidad_sales__c = true,
                    Name =mapsName.get(opp.AccountId)+' - '+opp.Account.Name,
                    OwnerId = opp.OwnerId,
                    Negocio_de_Origen_sales__c = opp.Id,
                    StageName = Constants.OPPORTUNITY_STAGENAME_CONTACTO,
                    CloseDate=Date.today().AddDays(30),
                    tipo_contrato_sales__c = opp.tipo_contrato_sales__c,
                    RecordTypeId = mapRTOpp.get(Constants.RECORDTYPE_BANCA_PLAN_PLUS));
					lstOppToCreate.add(newOpp);
                   }
            }
            if (lstOppToCreate != null && !lstOppToCreate.isEmpty()) {               
                insert lstOppToCreate;
                //agregada 30-03-2020
                Id pricebookId;
                if(test.isRunningTest()){ 
                    pricebookId = Test.getStandardPricebookId(); 
                    System.debug('Pricebook' + pricebookId);
                }else{
                    pricebookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1].Id;
                }
                List<OpportunityLineItem> lstOppLineItems= new List<OpportunityLineItem>();
                PricebookEntry entry = [SELECT Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :pricebookId AND Product2.name =: Constants.PLAN_PLUS];
                ////
                System.debug('Created Opp Plan Plus: '+ lstOppToCreate);
                for(Opportunity opp : lstOpp){
                    List<documento_oportunidad_sales__c> docs = [SELECT opportunity_sales__c, Name FROM documento_oportunidad_sales__c WHERE opportunity_sales__c = :opp.Id];
                    mapOppDocs.put(opp.Id,docs);
                    
                    System.debug('Map opp hipotecario docs: '+ mapOppDocs);
                }
                
                for(Opportunity opp1 : lstOppToCreate){
                    //agregada 30-03-2020
                    lstOppLineItems.add(new OpportunityLineItem(PricebookEntryId=entry.Id, OpportunityId=opp1.Id, UnitPrice=entry.UnitPrice, Quantity=1));
                    ////
                    System.debug('Opportunity Plan Plus '+ opp1);
                    if (opp1.tipo_contrato_sales__c == 'Independiente' && cont == 0) {
                        docTypes.put(docTypes.size() + 1, Constants.DOC_TYPE_DEC_ANUAL_IMPUESTOS);
                        cont++;
                    }
                    //Crea documentos ya existentes en la oportunidad de Origen
                    for (Integer key : docTypes.keySet()) {                              
                        String doc = docTypes.get(key);
                        System.debug('Doc Opp Plan Plus '+ doc);
                        documento_oportunidad_sales__c newDoc = new documento_oportunidad_sales__c(
                            opportunity_sales__c = opp1.Id,
                            Name = doc,
                            motivo_rechazo_sales__c = '',
                            estado_documento_sales__c = ''
                        );
                        docsToCreate.add(newDoc);
                        System.debug('Lista parcial new docs '+ docsToCreate);
                    }               
                }                 
                
                insert lstOppLineItems;////nuevo
                if(docsToCreate != null && !docsToCreate.isEmpty()){
                    insert docsToCreate;
                    for(Opportunity opp : lstOppToCreate){
                        if(opp.RecordTypeId == mapRTOpp.get(Constants.RECORDTYPE_BANCA_HIPOTECARIO)){
                            opp.StageName = CONSTANTS.OPPORTUNITY_STAGENAME_RECOPILACION;
                        }                   
                    }
                    update lstOppToCreate;
                    System.debug('All Doc Opp Plan Plus '+ docsToCreate);
                    for(Opportunity opp1 : lstOppToCreate){
                        List<documento_oportunidad_sales__c> docs = [SELECT opportunity_sales__c, Name FROM documento_oportunidad_sales__c WHERE opportunity_sales__c = :opp1.Id];
                        mapOppDocsPlan.put(opp1.Id,docs);
                        
                        System.debug('Map opp hipotecario docs: '+ mapOppDocs);
                    }
                    for(Opportunity opp : lstOpp){  
                        System.debug('Opportunity Hipotecario '+ opp);
                        for(Opportunity opp1 : lstOppToCreate){
                            System.debug('Opportunity Plan Plus '+ opp1);
                            if(opp.Id == opp1.Negocio_de_Origen_sales__c){
                                System.debug('Opp hipo Origen Opportunity Plan Plus ');
                                for (documento_oportunidad_sales__c docsPlan: mapOppDocsPlan.get(opp1.Id)) {                        
                                    
                                    for(documento_oportunidad_sales__c docs : mapOppDocs.get(opp.Id) ){
                                        System.debug('Doc Opp Hipotecario '+ docs);
                                        System.debug('Doc Plan Name = '+docsPlan.Name);
                                        System.debug('Doc hipo Name = '+docs.Name);
                                        System.debug('Doc Plan Id = '+docsPlan.Id);
                                        if(docsPlan.Name == docs.Name ){
                                            
                                            documento_oportunidad_sales__c newDoc = new documento_oportunidad_sales__c(
                                                Id=docsPlan.id,
                                                estado_documento_sales__c = 'Ingresado'
                                            );
                                            docsToUpdate.add(newDoc);
                                            System.debug('Lista parcial updated docs '+ docsToUpdate);
                                            break;
                                        }
                                        
                                        
                                    }               
                                }
                                
                            }  
                        }                 
                    }
                    if(docsToUpdate != null && !docsToUpdate.isEmpty()){
                        update docsToUpdate;
                        System.debug('Lista updated docs '+ docsToUpdate);
                    }
                }
            }  
        }
    }
    
    
    /*
    * @description       Business logic that creates a quote and quote line item to an opportunity
    * @author            fmaturan@everis.com | 27-11-2019
    * @param1            new Opportunity Records List<Id> : lstIdsOpp
    * @return            void
    * @throws            NA
    */  
    
    private static void updateOpportunitySuccess(List<Id> lstIdsOpp){
        Map<String, Id> mapRTOpp = new Map<String, Id>();
        Map<String, Id> mapRTQuote = new Map<String, Id>();
        
        Map<Id, Id> mapPbs = new Map<Id, Id>();
        List<Id> lstIdsOppProd = new List<Id>();
        Map<id,Boolean> mapValidateFlow= new Map<id,Boolean>();
        
        List<Opportunity> lstOpp = [SELECT Id, StageName, RecordTypeId, Name 
                                    FROM Opportunity WHERE Id IN :lstIdsOpp]; 
        
        List<Quote> listNewQuotes = new List<Quote>();
        List<QuoteLineItem> listQteLineItems = new List<QuoteLineItem>();
        
        
        if (lstOpp != null && !lstOpp.isEmpty()) {
            
            List<OpportunityLineItem> listOppProducts = [SELECT Id,Product2Id,Quantity,UnitPrice,OpportunityId 
                                                         FROM OpportunityLineItem WHERE OpportunityId IN :lstIdsOpp];
            if(listOppProducts == null || listOppProducts.isEmpty()){
                throw new UtilitiesSales.SalesException('La oportunidad debe tener asociado un producto');
            }
            PriceBook2 pb2; 
            if(test.isRunningTest()){
                
                system.debug('REV TEST '+Constants.PRICEBOOK_NAME1);
                
                pb2 = [SELECT Id FROM PriceBook2 WHERE Name = :Constants.PRICEBOOK_NAME1 Limit 1]; 
            }else{
                pb2 = [SELECT Id FROM PriceBook2 WHERE Name = :Constants.PRICEBOOK_NAME Limit 1];
            }
            for (OpportunityLineItem oppProd : listOppProducts) {
                lstIdsOppProd.add(oppProd.Product2Id);
            }               
            List<PriceBookEntry> listPbs = [SELECT Id,Product2Id,Product2.flujo_integrado_sales__c FROM PriceBookEntry 
                                            WHERE Product2Id IN :lstIdsOppProd AND Pricebook2Id =: pb2.id];
            for (PriceBookEntry pb : listPbs) {
                mapPbs.put(pb.Product2Id,pb.Id);
                mapValidateFlow.put(pb2.id, pb.Product2.flujo_integrado_sales__c);

            }
            for (RecordType rt : [SELECT Id, DeveloperName, SobjectType  FROM RecordType WHERE SobjectType =: Constants.OPPORTUNITY]) {
                mapRTOpp.put (rt.DeveloperName,rt.Id);
            }
            
            for (RecordType rt : [SELECT Id, DeveloperName, SobjectType  FROM RecordType WHERE SobjectType =: Constants.QUOTE]) {
                mapRTQuote.put (rt.DeveloperName,rt.Id);
            }
            
            for(Opportunity opp : lstOpp){
                opp.Flag_Actividades_Quote_sales__c=true;
                if( opp.StageName ==Constants.OPPORTUNITY_STAGENAME_COTIZACION  
                   && opp.RecordTypeId == mapRTOpp.get(Constants.RECORDTYPE_SEGURO_VIDA) ){  
                       Quote newQuote = new Quote(Name = opp.Name, OpportunityId = opp.Id, Pricebook2Id = pb2.Id,RecordTypeId=mapRTQuote.get(Constants.RECORDTYPE_QUOTE_SEGURO_VIDA));
                       opp.StageName = Constants.OPPORTUNITY_STAGENAME_COTIZACION;
                       if(!flag_recordtype){
                           system.debug('AKAAA'+ flag_recordtype);
                           listNewQuotes.add(newQuote);
                       }
                   }else if(opp.StageName ==Constants.OPPORTUNITY_STAGENAME_SIMULACION
                            && opp.RecordTypeId == mapRTOpp.get(Constants.RECORDTYPE_BANCA_HIPOTECARIO)){
                                Quote newQuote = new Quote(Name = opp.Name, OpportunityId = opp.Id, Pricebook2Id = pb2.Id, RecordTypeId=mapRTQuote.get(Constants.RECORDTYPE_QUOTE_BANCA_HIPOTECARIO));
                                opp.StageName = Constants.OPPORTUNITY_STAGENAME_SIMULACION;
                                listNewQuotes.add(newQuote);
                            }else if(opp.StageName == Constants.OPPORTUNITY_STAGENAME_COTIZACION  
                                     && opp.RecordTypeId == mapRTOpp.get(Constants.RECORDTYPE_AUTO)){
                                         if (mapValidateFlow.get(pb2.Id)==True && FlujoCotizador__c.getInstance(UserInfo.getUserId()).Cotizador__c) {
                                            Quote newQuote = new Quote(Name = opp.Name, OpportunityId = opp.Id, Pricebook2Id = pb2.Id, RecordTypeId=mapRTQuote.get(Constants.RECORDTYPE_QUOTE_AUTO_COTIZADOR));
                                            if(!flag_recordtype){
                                                listNewQuotes.add(newQuote);
                                            }
                                         }else{
                                            Quote newQuote = new Quote(Name = opp.Name, OpportunityId = opp.Id, Pricebook2Id = pb2.Id, RecordTypeId=mapRTQuote.get(Constants.RECORDTYPE_QUOTE_AUTO));
                                            if(!flag_recordtype){
                                                listNewQuotes.add(newQuote);
                                            }
                                         }
                                         opp.StageName = Constants.OPPORTUNITY_STAGENAME_COTIZACION;
                                     }else if(opp.StageName == Constants.OPPORTUNITY_STAGENAME_COTIZACION  
                                              && opp.RecordTypeId == mapRTOpp.get(Constants.RECORDTYPE_HOGAR)){
                                                  Quote newQuote = new Quote(Name = opp.Name, OpportunityId = opp.Id, Pricebook2Id = pb2.Id, RecordTypeId=mapRTQuote.get(Constants.RECORDTYPE_QUOTE_HOGAR));
                                                  opp.StageName = Constants.OPPORTUNITY_STAGENAME_COTIZACION;
                                                  if(!flag_recordtype){
                                                      listNewQuotes.add(newQuote);
                                                  }
                                              }
                //codigo agregado para consumo
                else if(opp.StageName ==Constants.OPPORTUNITY_STAGENAME_SIMULACION
                        && (opp.RecordTypeId == mapRTOpp.get(Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO) || opp.RecordTypeId == mapRTOpp.get(Constants.RECORDTYPE_BANCA_CREDITO_CONSUMO_LECTURA))){
                            Quote newQuote = new Quote(Name = opp.Name, OpportunityId = opp.Id, Pricebook2Id = pb2.Id, RecordTypeId=mapRTQuote.get(Constants.RECORDTYPE_QUOTE_CREDITO_CONSUMO));
                            opp.StageName = Constants.OPPORTUNITY_STAGENAME_SIMULACION;
                            listNewQuotes.add(newQuote);
                        }
                
            }
            if (listNewQuotes != null && !listNewQuotes.isEmpty()){
                Insert listNewQuotes;
                for (OpportunityLineItem oppProduct : listOppProducts) {
                    for (Quote qte : listNewQuotes) {
                        QuoteLineItem qteLineItem = new QuoteLineItem(UnitPrice = oppProduct.UnitPrice, 
                                                                      Product2Id=oppProduct.Product2Id,
                                                                      Quantity=oppProduct.Quantity,
                                                                      QuoteId=qte.Id,
                                                                      PricebookEntryId=mapPbs.get(oppProduct.Product2Id),
                                                                      OpportunityLineItemId=oppProduct.Id);
                        listQteLineItems.add(qteLineItem);                       
                    }                    
                }
                if (listQteLineItems != null && !listQteLineItems.isEmpty()) {
                    Insert listQteLineItems;                       
                }
            }
        }       
    }

    public static Map<Id,String> nameOpp(List<Opportunity> lstOpp){
        List<id> AccountIds = new List<Id>();
        String NameOpp = '';
        Map<Id,String> mapsName= new Map<Id,String>();
        for (Opportunity Opp : lstOpp) {
            AccountIds.add(Opp.AccountId);
            NameOpp = OPP.account.Name;
        }
         system.debug(nameOpp);
        
        List<Product2> lstPro=[SELECT Id,tipo_producto_sales__c,Name FROM Product2 WHERE tipo_producto_sales__c =:Constants.RECORDTYPE_BANCA_PLAN_PLUS];
        
        List<AggregateResult> lstResult = [SELECT AccountId, COUNT(Id) countId FROM Opportunity WHERE AccountId IN:AccountIds GROUP BY AccountId];
        for ( AggregateResult result: lstResult ) {
            mapsName.put((String)result.get('AccountId'),lstPro[0].Name+' - '+String.valueOf((Integer)result.get('countId')+1) + ' - '+NameOpp);
        }
        system.debug(mapsName);
        return mapsName;
    }
}