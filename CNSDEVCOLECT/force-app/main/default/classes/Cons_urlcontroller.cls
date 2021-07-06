public class Cons_urlcontroller {
    public string url{get; set;}
    
    public boolean error{get; set;}
    public string id{get; set;}
    public final case cc;
    public  Cons_urlcontroller(ApexPages.StandardController controller) {
        this.cc = (case) controller.getRecord(); 
        id =ApexPages.currentPage().getParameters().get('id');
        
        system.debug('cc'+cc);
        system.debug('id'+id);
        string userId = UserInfo.GetUserId();
        system.debug('userId'+userId);
        // case cas = (case) controller.getRecord();
        system.debug('===cas.id==='+id+'==userId==='+userId);
        // system.debug('===cas.id==='+cc.id+'==userId==='+userId);
        
        case cas1=[select id, Rut_del_Cliente__c  from case where id=:id];
        user us=[select id, RUT__c   from user where id=:userId];
        if(us.RUT__c==null){
            error=true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No existe Rut  en  el usuario logueado');
            ApexPages.addMessage(myMsg); 
        }else{
            
            string rut_cliente=cas1.Rut_del_Cliente__c.replace('-','');
            string rut_usuario=us.RUT__c.replace('-','');
            system.debug('===rut_cliente==='+rut_cliente+'==rut_usuario==='+rut_usuario);
            Cons_callOutService   call=new Cons_callOutService();
            string resp = call.callOutConvenioEmpresa(rut_cliente,rut_usuario);
            system.debug('===resp==='+resp);
            if(test.isRunningTest()){
                 resp='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
            }
            Cons_Respuestaserviciourl_JSON resser= (Cons_Respuestaserviciourl_JSON)JSON.deserialize(resp,Cons_Respuestaserviciourl_JSON.class);
            if(resser.codigo=='0'){
                url=resser.url;
                
                error=false;
                
            }else{
                error=true;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,resser.mensaje);
                ApexPages.addMessage(myMsg); 
            }
        }
        
    }
}