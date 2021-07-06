/**
 * @File Name          : VTimeController.cls
 * @Description        : 
 * @Author             : pcelis@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 2/19/2020, 10:12:44 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11-12-2019   pcelis@everis.com     Initial Version
**/
public class VTimeController {
    
    @AuraEnabled
    public static VTimeClass getConsultVTime(String recordId){
        VTimeClass vt = new VTimeClass();
		
        try {
           
            List<Quote> lstQu= [SELECT id, Numero_de_Propuesta_sales__c FROM Quote WHERE ID=:recordId];
            List<QuoteLineItem> lstLineIt=[SELECT PricebookEntryId,Id FROM QuoteLineItem WHERE QuoteId=:recordId];
            List<PricebookEntry> ListPri=[SELECT Product2Id FROM PricebookEntry WHERE Id=:lstLineIt[0].PricebookEntryId ];
            List<Product2> lstPro=[SELECT codigo_producto_sales__c,Codigo_Macroproducto_Operacional_sales__c   FROM Product2 WHERE Id=:ListPri[0].Product2Id];
            //List<Product2> lst= UtilitiesSales.getProduct2ByQuoteId(recordId);
            String NPro='1';
            if(lstQu[0].Numero_de_Propuesta_sales__c != null){
            	NPro = String.valueOf(lstQu[0].Numero_de_Propuesta_sales__c);
            }            
            
            SalesCallout sc= new SalesCallout(Constants.VTIME);
            VTimeClass.ProposalClass vTPropo= sc.getProposalStatus(NPro,lstPro[0].Codigo_Macroproducto_Operacional_sales__c,lstPro[0].codigo_producto_sales__c);
            vt.proposal = vTPropo;
            VTimeClass.MandateClass vTM= sc.getMandateStatus(NPro,lstPro[0].Codigo_Macroproducto_Operacional_sales__c,lstPro[0].codigo_producto_sales__c);
           	vt.mandate = vTM;
			
            vt.codigo = Constants.OK;

        }catch(ListException le){
            vt.codigo= Constants.NOK;
            vt.mensaje='Error, Verifique que la cotizacion tenga producto'+ le.getMessage();
            System.debug(vt.mensaje);
        }
         catch (Exception e) {
            vt.codigo = Constants.NOK;
            vt.mensaje='Error, Consulte al Administrador'+e.getMessage();
            System.debug(vt.mensaje);
        }
        
        return vt;  

    }

    @AuraEnabled 
    public static Boolean getOppStage(String recordId){
        List<Quote> qte = [SELECT Id,Opportunity.StageName FROM Quote WHERE Id =:recordId LIMIT 1];
        System.debug(qte[0].Opportunity.StageName);
        if (qte[0].Opportunity.StageName.equals('Evaluación')) {
            System.debug('Entro al IF Evaluacion');
            return true;
        }
        return false;
    }

}