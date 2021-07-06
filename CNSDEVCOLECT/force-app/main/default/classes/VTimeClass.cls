/**
 * @File Name          : VTimeClass.cls
 * @Description        : 
 * @Author             : pcelis@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 09-03-2020 16:28:01
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11-12-2019   pcelis@everis.com                   Initial Version
**/
public class VTimeClass {

        @AuraEnabled public String codigo;
        @AuraEnabled public String mensaje;
        @AuraEnabled public ProposalClass proposal;
        @AuraEnabled public MandateClass mandate;
        
       public class MandateClass {
         @AuraEnabled public Integer numeroPoliza;
         @AuraEnabled public String numeroMandato;
         @AuraEnabled public String descripcion; 
         @AuraEnabled public String banco;
         @AuraEnabled public String viaPago;  
         @AuraEnabled public Integer resultado;    
         @AuraEnabled public String message;
       }
        
       public class ProposalClass {
         @AuraEnabled public String causal;
         @AuraEnabled public String descripcion;
         @AuraEnabled public Integer diasIngreso; 
         @AuraEnabled public Integer numeroEstado;
         @AuraEnabled public Integer resultado;  
       }
}