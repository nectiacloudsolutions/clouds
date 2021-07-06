public class CONS_Visualizar_Multiconsulta {
    public string url {get;set;}
    public string idac {get;set;}
    public CONS_Visualizar_Multiconsulta(ApexPages.StandardController  controller) {
        idac = controller.getId();
          Account acc=[select id, RUT__c from Account where id=:idac];
           boolean issandbox = [SELECT Id, InstanceName, IsSandbox FROM Organization limit 1].IsSandbox;
        
        
      
        String[] rutsindigito  = acc.RUT__c.split('-');
        string rutfinal='';
        if(rutsindigito[0].length()==9){
            String[] digitos =rutsindigito[0].split('');
            rutfinal=digitos[0]+digitos[1]+digitos[2]+'.'+digitos[3]+digitos[4]+digitos[5]+'.'+digitos[6]+digitos[7]+digitos[8]+'-'+rutsindigito[1];
            
        }else if(rutsindigito[0].length()==8){
            String[] digitos =rutsindigito[0].split('');
            rutfinal=digitos[0]+digitos[1]+'.'+digitos[2]+digitos[3]+digitos[4]+'.'+digitos[5]+digitos[6]+digitos[7]+'-'+rutsindigito[1];
            
        }else if(rutsindigito[0].length()==7){
            String[] digitos =rutsindigito[0].split('');
            rutfinal=digitos[0]+'.'+digitos[1]+digitos[2]+digitos[3]+'.'+digitos[4]+digitos[5]+digitos[6]+'-'+rutsindigito[1];
        }
        system.debug('rutfinal'+rutfinal);
        if(issandbox==true){
        //url='http://aplicacionesqa.cnsv.cl/ConsultasPolizas/loginCRM2.asp?sRutCliente=13.163.853-1&sAplicacion=MULCONCCVB';
        url='http://aplicacionesqa.cnsv.cl/ConsultasPolizas/loginCRM2.asp?sRutCliente='+rutfinal+'&sAplicacion=MULCONCCVB';
       // url='https://aplicacionesqa.cnsv.cl/ConsultasPolizas/loginCRM2.asp?sRutCliente='+rutfinal+'&sAplicacion=MULCONCCV';
        }else{
            
        url='http://aplicaciones.cnsv.cl/ConsultasPolizas/loginCRM2.asp?sRutCliente='+rutfinal+'&sAplicacion=MULCONCCV';
        }
        
        system.debug('url==>'+url);
    }    
}