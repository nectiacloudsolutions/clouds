@RestResource(urlMapping='/quote/update/*')
global with sharing class CloseQuoteService {
    public static boolean responseError = false;

    @HttpPatch
    global static void updateQuote() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String quoteId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);

        try {
            Quote thisQuote = [SELECT Id,cuota_uf_sales__c,Validacion_Estado_Propuesta_sales__c,Numero_de_Cotizacion_sales__c,Numero_de_Propuesta_sales__c,Tarifa_Anual_UF_sales__c,tipo_traspaso_sales__c,etapa_cotizador_sales__c,OpportunityId,Opportunity.Numero_de_documento_sales__c,OwnerId  FROM Quote WHERE Numero_de_Cotizacion_sales__c=:quoteId];
            
            Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(req.requestbody.tostring());
            
            for(String fieldName : params.keySet()) {
                thisQuote.put(fieldName, params.get(fieldName));
            }

            if (thisQuote.tipo_traspaso_sales__c==Constants.TYPECALL_AUTOMATICO) {

                Opportunity opp=[SELECT id, SyncedQuoteId,StageName FROM Opportunity WHERE id=:thisQuote.OpportunityId];
                opp.SyncedQuoteId=thisQuote.id;
                                                
                thisQuote= callVTime(thisQuote);
                if (responseError!=true) {
                    Update opp;
                }
 
            }
            
            Update thisQuote;
            String json='{"success":true,"statusCode":200,"message":"OK"}';
            res.statusCode=200;
            res.responseBody = Blob.valueOf(json);
            res.addHeader('Content-Type', 'application/json');
        } catch (Exception e) {

            String json='{"success":false,"statusCode":400,"message":"NOK"}';
            res.statusCode=400;
            res.responseBody = Blob.valueOf(json);
            res.addHeader('Content-Type', 'application/json');
        }   
    }
    
    /**
    * @description Metodo que llama a la integracion de VTIME
    * @author pcelisbe@everis.com | 09-22-2020 
    * @param myQuote 
    * @return Quote 
    **/
    public static Quote callVTime(Quote myQuote){
        List<User> lstUser = [SELECT Rut__c FROM User WHERE Id=:myQuote.OwnerId];
        List<Product2> prod = UtilitiesSales.getProduct2ByQuoteId(myQuote.id); 

        ProposalController.StoreProposalClass stProposal = new ProposalController.StoreProposalClass();
        ProposalController.ProposalResponse pr = new ProposalController.ProposalResponse();
            String rtEjec = lstUser[0].RUT__c;
            String rtCont = myQuote.Opportunity.Numero_de_documento_sales__c;
            Integer largoRutEjecutivo = (rtEjec.length() -1);
            Integer largoRutContratante = (rtCont.length() -2);
            pr.rutEjecutivo = Integer.valueOf(rtEjec.substring(0, largoRutEjecutivo));
            pr.rutContratante = Integer.valueOf(rtCont.substring(0, largoRutContratante));
            pr.numeroPropuesta = Integer.valueOf(myQuote.Numero_de_Propuesta_sales__c);
            pr.numeroCotizacion = Integer.valueOf(myQuote.Numero_de_Cotizacion_sales__c);
            pr.idOportunidad = myQuote.OpportunityId;
            pr.ramo = Integer.valueOf(prod[0].Codigo_Macroproducto_Operacional_sales__c);
            pr.numeroProducto = Integer.valueOf(prod[0].codigo_producto_sales__c);

            SalesCallout callOut = new SalesCallout(Constants.VTIME);
            stProposal = callOut.setProposal(pr,'-1',Constants.TYPECALL_AUTOMATICO);
            if (stProposal.estado!=0) {
                responseError=true;

            }
            myQuote.Validacion_Estado_Propuesta_sales__c = stProposal.mensaje;
            stProposal.codigo = 'OK';
            
            return myQuote;
    }
}