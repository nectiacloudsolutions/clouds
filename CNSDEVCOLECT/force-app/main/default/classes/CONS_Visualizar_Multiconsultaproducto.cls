public class CONS_Visualizar_Multiconsultaproducto {
    public string url {get;set;}
    public string idpro {get;set;}
    public CONS_Visualizar_Multiconsultaproducto(ApexPages.StandardController  controller) {
        idpro = controller.getId();
        Producto_del_Cliente__c pro=[select id, Poliza_Nectia__c,Tipo_Registro_Nectia__c,Ramo_Nectia__c,Codigo_Plan_Nectia__c,Numero_Certificado_Nectia__c,Esquema_Nectia__c 
                                     from Producto_del_Cliente__c where id=:idpro limit 1];
        string aplicacion='';
         boolean issandbox = [SELECT Id, InstanceName, IsSandbox FROM Organization limit 1].IsSandbox;
        if(issandbox==true){
           /* if(pro.Esquema_Nectia__c=='INSUDB'){
                aplicacion='MULCONCCV'; 
            }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){
                aplicacion='MULCONCCG';
            }else if(pro.Esquema_Nectia__c=='VTCNLIFE'){
                aplicacion='MULCONCCNL';
            }  */      
       		//url='http://aplicacionesqa.cnsv.cl/ConsultasPolizas/loginCRM.asp?sCertype=2&nBranch=1&nProduct=650&nPolicy=11514904&nCertif=0&sAplicacion=MULCONCCVB';
        	url='http://aplicacionesqa.cnsv.cl/ConsultasPolizas/loginCRM.asp?sCertype=2&nBranch='+pro.Ramo_Nectia__c+'&nProduct='+pro.Codigo_Plan_Nectia__c+'&nPolicy='+pro.Poliza_Nectia__c+'&nCertif='+pro.Numero_Certificado_Nectia__c+'&sAplicacion=MULCONCCVB';    
       		// url='https://aplicacionesqa.cnsv.cl/ConsultasPolizas/loginCRM.asp?sCertype=2&nBranch='+pro.Ramo_Nectia__c+'&nProduct='+pro.Codigo_Plan_Nectia__c+'&nPolicy='+pro.Poliza_Nectia__c+'&nCertif='+pro.Numero_Certificado_Nectia__c+'&sAplicacion='+aplicacion;
        }else {
           //MJV - Comentado para pasar a sandbox devcns
         /*   if(pro.Esquema_Nectia__c=='INSUDB'){
            	aplicacion='MULTICONVIDA'; 
            }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){
                aplicacion='MULTICONGRAL';
            }else if(pro.Esquema_Nectia__c=='VTCNLIFE'){
                aplicacion='MULTICONCNLI';
            }  */      
            url='http://aplicaciones.cnsv.cl/ConsultasPolizas/loginCRM.asp?sCertype=2&nBranch='+pro.Ramo_Nectia__c+'&nProduct='+pro.Codigo_Plan_Nectia__c+'&nPolicy='+pro.Poliza_Nectia__c+'&nCertif='+pro.Numero_Certificado_Nectia__c+'&sAplicacion=MULCONCCVB';
           
        }
        system.debug('url==>'+url);
        }    
      public PageReference  continuar(){
        system.debug('idpro'+idpro);
        pageReference p = new PageReference('/'+idpro);
        return p;
          
      }
}