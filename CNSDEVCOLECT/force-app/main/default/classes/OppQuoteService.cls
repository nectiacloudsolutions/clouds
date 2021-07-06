/**
 * @description       : 
 * @author            : eayalcor@everis.com
 * @group             : 
 * @last modified on  : 09-22-2020
 * @last modified by  : eayalcor@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-03-2020   eayalcor@everis.com   Initial Version
**/
@RestResource(urlMapping='/quoteIntegrator/*')
global without sharing class OppQuoteService {

    /**
    * @description Metodo retorna información de una Opp Especifica.
    * @author eayalcor@everis.com | 08-03-2020 
    * @return ResponseGet 
    **/
    @HttpGet
    global static ResponseGet invokeServiceGet(){

        ResponseGet responseGet = new ResponseGet();
        DataQuote data = new DataQuote();
        DtoGetRecords records = new DtoGetRecords();

        try{

            RestRequest request = RestContext.request;
            Map<String, String> params = RestContext.request.params;
            Id oppId = params.get('opportunityId');
            String rutExecutive = params.get('rut');
            data.statusCode = Constants.RESPONSE_200;
            data.success = true;
            data.message = Constants.OK;

            if(oppId != null){
                List<Opportunity> lstOpportunity = [SELECT Id,Name,Numero_de_documento_sales__c,fecha_creacion_sales__c,
                telefono_oportunidad_sales__c,telefono_sales__c,correo_oportunidad_sales__c,direccion_oportunidad_sales__c,
                StageName,RecordTypeID,CreatedById,OwnerId,AccountId,(SELECT Id,Product2Id FROM OpportunityLineItems) FROM Opportunity WHERE Id =: oppId];

                if(lstOpportunity != null && !lstOpportunity.isEmpty()){

                    List<Product2> lstProduct = [SELECT Id,Name,ProductCode,Codigo_Macroproducto_Operacional_sales__c,
                    codigo_producto_sales__c FROM Product2 WHERE Id =: lstOpportunity[0].OpportunityLineItems[0].Product2Id];

                    List<Quote> lstQuotes = [SELECT Id,Name,Status,Numero_de_Cotizacion_sales__c,Numero_de_Propuesta_sales__c,
                    Fecha_Estado_de_Cotizacion_sales__c,Tarifa_Anual_UF_sales__c,medio_pago_sales__c,vigencia_poliza_sales__c,
                    numero_cuotas_sales__c,cuota_uf_sales__c,marca_sales__c,modelo_sales__c,anio_sales__c,tipo_traspaso_sales__c,
                    presupuesto_cerrado_sales__c,etapa_cotizador_sales__c,Deducible_sales__c,
                    Requiere_Inspeccion_sales__c,RecordTypeId FROM Quote WHERE OpportunityId =: oppId];
                    
                    List<User> lstUserCreated = [SELECT Name,Rut__c,Email,Profile.Name FROM User WHERE Id =:lstOpportunity[0].CreatedById LIMIT 1];
                    List<User> lstUserOwner = [SELECT Name,Rut__c,Email,Profile.Name FROM User WHERE Id =:lstOpportunity[0].OwnerId LIMIT 1];

                    List<Account> lstAccount = [SELECT PersonBirthdate FROM Account WHERE Id =: lstOpportunity[0].AccountId];

                    records.opportunity = lstOpportunity[0];
                    records.creatorUser = lstUserCreated[0];
                    records.ownerUser = lstUserOwner[0];
                    records.account = lstAccount[0];
                    records.product = lstProduct[0];
                    records.quotes = lstQuotes;

                    data.records = records;
                }else{
                    data.statusCode = Constants.RESPONSE_400;
                    data.success = false;
                    data.message = 'El Id Informado no corresponde a una Oportunidad valida.';     
                }

            }else{
                data.statusCode = Constants.RESPONSE_400;
                data.success = false;
                data.message = 'Debe informar el Id de la Oportunidad'; 
            }

        }catch(Exception ex){
            data.success = false;
            data.message = 'Ha ocurrido un problema: ' + ex.getMessage();
            data.statusCode = Constants.RESPONSE_400;
        }finally{
            responseGet.response = data; 
        }

        return responseGet;
    }

    global class ResponseGet{
        public DataQuote response; 
    }

    global class DataQuote{
        public boolean success  {get;set;}
        public String statusCode {get;set;}
        public String message {get;set;}
        public DtoGetRecords records;
    }

    global class DtoGetRecords{
        public Opportunity opportunity {get;set;}
        public User creatorUser {get;set;}
        public User ownerUser {get;set;}
        public Product2 product {get;set;}
        public Account account {get;set;}
        public List<Quote> quotes;
    }


/**
========================================================================================================================
----------------------------------------------------INVOKE POST----------------------------------------------------------
========================================================================================================================
*/
    private static ResponsePost responsePost = new ResponsePost();
    private static RequestPost request = new RequestPost();
    private static DataPost data = new DataPost();
    private static DtoPostRecords records = new DtoPostRecords();
    private static List<Opportunity> lstOpportunity = new List<Opportunity>();
    private static List<OpportunityLineItem> lstOppLinItem = new List<OpportunityLineItem>();
    private static List<QuoteLineItem> lstQuoteLinItem = new List<QuoteLineItem>();
    private static List<Product2> lstProduct = new List<Product2>();
    private static List<Quote> lstQuotes = new List<Quote>();
    private static Map<String,Id> quoteToUpsert = new Map<String,Id>(); 

    /**
    * @description 
    * @author eayalcor@everis.com | 09-11-2020 
    * @return ResponsePost 
    **/
    @HttpPost
    global static ResponsePost invokeServicePost(){

        Savepoint sp = Database.setSavepoint();

        try{

            request = (RequestPost)JSON.deserialize(RestContext.request.requestBody.toString(), RequestPost.class);
            data.statusCode = Constants.RESPONSE_200;
            data.success = true;
            data.message = Constants.OK;

            validateRequest();

            lstOpportunity = [SELECT Id,Name,StageName,RecordTypeID,Pricebook2Id,OwnerId,AccountId,Etapas_Cotizador_Sales__c,(SELECT Id,Product2Id,UnitPrice,Quantity,PricebookEntryId FROM OpportunityLineItems) 
                FROM Opportunity WHERE Id =: request.opportunity.Id];

            if(lstOpportunity != null && !lstOpportunity.isEmpty()){
                System.debug('Line Item ' +lstOpportunity[0].OpportunityLineItems );
                lstOppLinItem.add(lstOpportunity[0].OpportunityLineItems);

                lstProduct = [SELECT Id,Name,ProductCode,codigo_producto_sales__c,flujo_integrado_sales__c
                    FROM Product2 WHERE Id =: lstOpportunity[0].OpportunityLineItems[0].Product2Id];

                if(!request.product2.ProductCode.equalsIgnoreCase(lstProduct[0].ProductCode)){
                    setNewProductOpp();
                }

                lstOpportunity[0].StageName = setStageNameOpp(request.opportunity.Etapas_Cotizador_Sales__c);

                lstQuotes = [SELECT Id,Name,Status,Numero_de_Cotizacion_sales__c,(SELECT Id,Quantity,QuoteId,PricebookEntryId,Product2Id,UnitPrice FROM QuoteLineItems)
                    FROM Quote WHERE OpportunityId =: lstOpportunity[0].Id];
                
                System.debug('Quote List: ' + lstQuotes);

                update lstOpportunity;
                
                generateOppQuotes();

            }else{
                data.success = false;
                data.message = 'La Opportunidad indicada no existe';
                data.statusCode = Constants.RESPONSE_400; 
            }

        }catch(Exception ex){
            data.success = false;
            data.message = 'Ha ocurrido un problema: ' + ex.getMessage();
            data.statusCode = Constants.RESPONSE_400;
            System.debug('LOG -->'+ ex.getStackTraceString());
            Database.rollback(sp);
        }finally{
            responsePost.response = data;
        }
        return responsePost;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 09-16-2020 
    **/
    private static void validateRequest(){
        
        if(request.opportunity.Id == null || String.isBlank(request.opportunity.Id)){
            System.debug('Oportunidad:' + request.opportunity);
            throw new UtilitiesSales.SalesException('Debe Enviar una oportunidad');
        }else if(request.product2.ProductCode == null || String.isBlank(request.product2.ProductCode)){
            throw new UtilitiesSales.SalesException('Debe Enviar el Producto de la Oportunidad');
        }else if(request.quotes.isEmpty() || request.quotes == null){
            throw new UtilitiesSales.SalesException('Debe a lo menos enviar una Cotización');
        }
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 09-16-2020 
    * @param String nameOpp 
    * @param String nameProduct 
    * @return String 
    **/
    private static String generateNewNameOpp(String nameOpp, String nameProduct){
        List<String> splitName = nameOpp.split('-');
        splitName.set(0, nameProduct);
 
        return splitName[0] + ' - ' + splitName[1] + ' - ' + splitName[2];
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 09-16-2020 
    * @param String stageQuote 
    * @return String 
    **/
    private static String setStageNameOpp(Decimal stageQuote){

        if(stageQuote == null || stageQuote == 0){
            throw new UtilitiesSales.SalesException('Debe indicar la Etapa de la Cotización');
        }

        lstOpportunity[0].Etapas_Cotizador_Sales__c = stageQuote;
        if(stageQuote != 5){
            return Constants.OPPORTUNITY_STAGENAME_COTIZACION;
        }else{
            return Constants.OPPORTUNITY_STAGE_INGRESO_NEGOCIO;
        }
    }

    /**
    * @description Metodo que Genera nuevo producto asociada a la oportunidad 
    * @author eayalcor@everis.com | 09-16-2020 
    **/
    private static void setNewProductOpp(){

        delete lstOppLinItem;
        lstOppLinItem.clear();

        List<Product2> newPro = [SELECT Id,Name,flujo_integrado_sales__c,ProductCode,codigo_producto_sales__c
            FROM Product2 WHERE ProductCode =: request.product2.ProductCode LIMIT 1];

        if(!newPro[0].flujo_integrado_sales__c){
            throw new UtilitiesSales.SalesException('El producto indicado no posee flujo Integrado');
        }

        List<PricebookEntry> pentry = [SELECT Id FROM PricebookEntry 
                WHERE Product2Id =: newPro[0].Id AND Pricebook2Id =: lstOpportunity[0].Pricebook2Id AND isActive = TRUE LIMIT 1];

        OpportunityLineItem oppItem = new OpportunityLineItem();
        oppItem.UnitPrice=0;
        oppItem.OpportunityId = lstOpportunity[0].Id;
        oppItem.Quantity = 1;
        oppItem.Product2Id = newPro[0].Id;
        oppItem.PricebookEntryId = pentry[0].Id;
        lstOppLinItem.add(oppItem);
        insert lstOppLinItem;

        lstProduct.clear();
        lstProduct.addAll(newPro);

        lstOpportunity[0].Name = generateNewNameOpp(lstOpportunity[0].Name, newPro[0].Name);
    }


    /**
    * @description Metodo que comprueba si existe la quote informada, de existir realiza upsert
    * @author eayalcor@everis.com | 09-17-2020 
    **/
    private static void getQuoteExist(){

        Set<String> setTemp = new Set<String>();

        for(Quote quote : request.quotes){
            setTemp.add(quote.Numero_de_Cotizacion_sales__c);
        }

        List<Quote> lstQuoTmp = [SELECT Id,Numero_de_Cotizacion_sales__c FROM Quote WHERE Numero_de_Cotizacion_sales__c IN : setTemp 
                AND OpportunityId =: lstOpportunity[0].Id];

        if(lstQuoTmp !=null && !lstQuoTmp.isEmpty()){
            for(Quote tmp : lstQuoTmp){
                quoteToUpsert.put(tmp.Numero_de_Cotizacion_sales__c, tmp.Id);
            }
        }

        System.debug('Map Exist: ' + quoteToUpsert);
    }

    /**
    * @description Metodo que Genera las Quotes asociadas a la Oportunidad
    * @author eayalcor@everis.com | 09-17-2020 
    **/
    private static void generateOppQuotes(){

        getQuoteExist();
        List<QuoteLineItem> lstQuoteLineItem = new List<QuoteLineItem>();
        List<Quote> lstToRmv = new List<Quote>();

        for(Quote tmpRmv : lstQuotes){
            if(!quoteToUpsert.containsKey(tmpRmv.Numero_de_Cotizacion_sales__c)){
                lstToRmv.add(tmpRmv);
            }else{
                lstQuoteLineItem.addAll(tmpRmv.QuoteLineItems);
            }
        }

        if(!lstToRmv.isEmpty() && lstToRmv != null){ delete lstToRmv;}
        if(!lstQuoteLineItem.isEmpty() && lstQuoteLineItem != null){ delete lstQuoteLineItem;}

        lstQuotes.clear();
        lstQuoteLineItem.clear();

        for(Quote quote : request.quotes){
            if(quoteToUpsert.containsKey(quote.Numero_de_Cotizacion_sales__c)){
                quote.Id = quoteToUpsert.get(quote.Numero_de_Cotizacion_sales__c);
            }
            quote.OwnerId = lstOpportunity[0].OwnerId;
            quote.etapa_cotizador_sales__c = String.valueOf((Integer)lstOpportunity[0].Etapas_Cotizador_Sales__c);
            quote.OpportunityId = lstOpportunity[0].Id;
            quote.Name = lstOpportunity[0].Name;
            quote.Pricebook2Id = lstOpportunity[0].Pricebook2Id;
            quote.RecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('Sales_Seguros_Auto_Cotizador').getRecordTypeId();
            lstQuotes.add(quote);
        }

        System.debug('Quotes: ' + lstQuotes);

        if(lstQuotes.size() > 0){
            upsert lstQuotes;

            for(OpportunityLineItem oppItem : lstOppLinItem){
                for(Quote ltq : lstQuotes){
                    QuoteLineItem qteLineItem = new QuoteLineItem(UnitPrice = oppItem.UnitPrice, 
                                                                Product2Id=oppItem.Product2Id,
                                                                Quantity=oppItem.Quantity,
                                                                QuoteId=ltq.Id,
                                                                PricebookEntryId=oppItem.PricebookEntryId,
                                                                OpportunityLineItemId=oppItem.Id);
                    lstQuoteLineItem.add(qteLineItem);
                }
            }

            if(lstQuoteLineItem != null && !lstQuoteLineItem.isEmpty()){
                insert lstQuoteLineItem;
            }
        } 

        records.opportunity = lstOpportunity[0];
        records.product = lstProduct[0];
        records.quotes = lstQuotes;

        data.records = records;
    }

    global class RequestPost{
        public Opportunity opportunity;
        public List<Quote> quotes;
        public Product2 product2;
    }

    global class ResponsePost{
        public DataPost response; 
    }

    global class DataPost{
        public boolean success  {get;set;}
        public String statusCode {get;set;}
        public String message {get;set;}
        public DtoPostRecords records;
    }

    global class DtoPostRecords{
        public Opportunity opportunity {get;set;}
        public Product2 product {get;set;}
        public List<Quote> quotes;
    }
}