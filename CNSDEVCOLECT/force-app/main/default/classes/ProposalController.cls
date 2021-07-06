/**
 * @File Name          : ProposalController.cls
 * @Description        : 
 * @Author             : fmaturan@everis.com
 * @Group              : 
 * @Last Modified By   : pcelisbe@everis.com
 * @Last Modified On   : 09-17-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    12-12-2019   fmaturan@everis.com     Initial Version
**/
public class ProposalController {
    
    
    @AuraEnabled 
    public static ProposalController.StoreProposalClass getStoreProposal(Id id){
        System.debug('getStoreProposal '+ id);
        List<Id> usrIds = new List<Id>();
        Map<Id, String> mapUsrIds = new Map<Id, String>();
        List<Product2> prod = UtilitiesSales.getProduct2ByQuoteId(id);
        ProposalController.StoreProposalClass stProposal = new ProposalController.StoreProposalClass();
        stProposal.codigo = 'NOK';      
        List<Quote> lstQuote = [SELECT Validacion_Estado_Propuesta_sales__c,OpportunityId,Opportunity.Numero_de_documento_sales__c,Numero_de_Cotizacion_sales__c,Numero_de_Propuesta_sales__c,OwnerId,venta_asistida_sales__c FROM Quote WHERE Id = :id LIMIT 1];
        System.debug('lstQuote '+lstQuote);
        for (Quote qte : lstQuote) {
            usrIds.add(qte.OwnerId);
        }
        List<User> lstUser = [SELECT Rut__c FROM User WHERE Id IN :usrIds];
        for (User usr : lstUser) {
            mapUsrIds.put(usr.Id,usr.Rut__c);
        }
        if(lstQuote[0].venta_asistida_sales__c==false){
        if (lstQuote != null && !lstQuote.IsEmpty() ) {
            ProposalController.ProposalResponse pr = new ProposalController.ProposalResponse();
            String rtEjec = mapUsrIds.get(lstQuote[0].OwnerId); 
            String rtCont = lstQuote[0].Opportunity.Numero_de_documento_sales__c;
            Integer largoRutEjecutivo = (rtEjec.length() -1);
            Integer largoRutContratante = (rtCont.length() -2);
            pr.rutEjecutivo = Integer.valueOf(rtEjec.substring(0, largoRutEjecutivo));
            pr.rutContratante = Integer.valueOf(rtCont.substring(0, largoRutContratante));
            pr.numeroPropuesta = Integer.valueOf(lstQuote[0].Numero_de_Propuesta_sales__c);
            pr.numeroCotizacion = Integer.valueOf(lstQuote[0].Numero_de_Cotizacion_sales__c);
            pr.idOportunidad = lstQuote[0].OpportunityId;
            pr.ramo = Integer.valueOf(prod[0].Codigo_Macroproducto_Operacional_sales__c);
            pr.numeroProducto = Integer.valueOf(prod[0].codigo_producto_sales__c);
            if(pr.numeroPropuesta == null ){
                stProposal.estado=-1;
                stProposal.mensaje='No ha completado el número de propuesta';
                lstQuote[0].Validacion_Estado_Propuesta_sales__c = 'No ha completado el número de propuesta';
            }else if(lstQuote[0].Validacion_Estado_Propuesta_sales__c == 'Propuesta ingresada correctamente'){
                stProposal.estado=-1;
                stProposal.mensaje='Esta propuesta ya ha sido validada';
            }else {
                SalesCallout callOut = new SalesCallout(Constants.VTIME);
                stProposal = callOut.setProposal(pr,'-1',Constants.TYPECALL_MANUAL);
                lstQuote[0].Validacion_Estado_Propuesta_sales__c = stProposal.mensaje;
                stProposal.codigo = 'OK';
            }
            
            update lstQuote;
        }else{
            stProposal.mensaje='ocurrio un error';
            stProposal.estado=-1;
            
        }
        }else{
            
            throw new AuraHandledException('Venta asistida no posee validación');
        }
        return stProposal;   
    }

    @AuraEnabled 
    public static Boolean getOppStage(Id id){
        List<Quote> qte = [SELECT Id,Opportunity.StageName FROM Quote WHERE Id =:id LIMIT 1];
        if (qte[0].Opportunity.StageName.equals('Ingreso del Negocio')) {
            return true;
        }
        return false;
    }

    public class StoreProposalClass {
        @AuraEnabled public Integer estado;
        @AuraEnabled public String mensaje;
        @AuraEnabled public String codigo;
    }
    
    public class ProposalResponse {
        @AuraEnabled public Integer rutEjecutivo;
        @AuraEnabled public Integer rutContratante;
        @AuraEnabled public Integer numeroPropuesta;
        @AuraEnabled public Integer numeroCotizacion;
        @AuraEnabled public String idOportunidad;
        @AuraEnabled public Integer ramo;
        @AuraEnabled public Integer numeroProducto;
    }

}