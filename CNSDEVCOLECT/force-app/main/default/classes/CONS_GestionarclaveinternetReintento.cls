public class CONS_GestionarclaveinternetReintento {
    public string  idcas {get;set;}
    public case  cas {get;set;}
    public user  us {get;set;}
    public string   email {get;set;}
    public user tmpUser{get;set;}
    
    public CONS_GestionarclaveinternetReintento(){
        idcas = ApexPages.currentPage().getParameters().get('id');
        cas=[select id,Rut__c,Accountid,Account.Name,Account.FirstName,Account.lastName,Producto_del_Cliente_Nectia__c,Rut_del_Cliente__c,Seguros_producto__c,Linea_Producto_Seguros__c,
             V_a_de_Pago__c,D_a_de_Pago__c,Account.PersonBirthdate,Account.Genero_Nectia__pc,Account.PersonEmail,Account.RUT__c,Folio_nueva_clave_Nectia__c,
             Mensaje_Transaci_n__c,transacion_ejecutada__c,Account.NuevoCorreo__c,Account.CambioMail__c
             from case where id=:idcas];
        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId() limit 1]; 
        
        string iduser=userinfo.getUserId();
        us =[SELECT Id, RUT__c  FROM User WHERE Id = :iduser];
         if(cas.Account.CambioMail__c==true){
            email = cas.Account.NuevoCorreo__c;
        }else{
            email = cas.Account.PersonEmail;
        }
    }
    
    public PageReference verificaemail(){
        if(email!=null){
            string []rut= (cas.Account.RUT__c).split('-');
            
            string estructura ='{'+
                '"rut": "'+rut[0]+'",'+
                '"emailCliente": "'+email+'",'+
                '"nombres": "'+cas.Account.FirstName+'",'+
                '"apellidoPaterno": "'+cas.Account.lastName+'",'+
                '"apellidoMaterno": " "'+
                '}';
            
            system.debug('json->'+estructura);
            
            
            CONS_estructuratoken est=new  CONS_estructuratoken();
            string access_token=est.token();
            system.debug('token=='+access_token);
            Cons_callOutService  call=new Cons_callOutService();
            string resp=call.callOutSolisitud_clave_email(access_token, estructura,tmpUser);
            
            system.debug('respuesta->'+resp);
            if(!resp.contains('ERROR -')){
                cas.Mensaje_Transaci_n__c=resp.left(255); 
                cas.transacion_ejecutada__c=true;
                  cas.Status='Cerrado';
                    cas.Sub_estado_Nectia__c='Solucionado';
                
            }else{
                cas.Mensaje_Transaci_n__c=resp.left(255); 
                cas.transacion_ejecutada__c=false;
                
            }
            update cas;
        }else{
            
            
            
            string []rutejec= us.RUT__c.split('');
            integer i=rutejec.size();
            string rutejecutivo='';
            for(integer j=0;j<=i-2;j++){
                rutejecutivo=rutejecutivo+rutejec[j];  
            }
            string []rut= (cas.Account.RUT__c).split('-');
            string estructura='{'+
                '"rut": "'+rut[0]+'",'+    //sin dijito  verificador 
                '"folio": "'+cas.Folio_nueva_clave_Nectia__c+'",'+
                '"rutEjecutivo": "'+rutejecutivo+'"'+     //sin dijito  verificador   es obligatorio 
                '}';
            CONS_estructuratoken est=new  CONS_estructuratoken();
            string access_token=est.token();
            system.debug('token=='+access_token);
            Cons_callOutService  call=new Cons_callOutService();
            string resp=call.callOutSolisitud_clave_folio(access_token, estructura,tmpUser);
            CONS_Respuestasolicitudclave_JSON rescla;
            if(!resp.contains('ERROR -')){
                rescla=(CONS_Respuestasolicitudclave_JSON)JSON.deserialize(resp,CONS_Respuestasolicitudclave_JSON.class);  
                if(rescla.Codigo=='0'){
                     cas.Mensaje_Transaci_n__c=rescla.mensaje.left(255); 
                cas.transacion_ejecutada__c=true;
                      cas.Status='Cerrado';
                    cas.Sub_estado_Nectia__c='Solucionado';
                }else{
                     cas.Mensaje_Transaci_n__c=rescla.mensaje.left(255); 
                cas.transacion_ejecutada__c=false;
                }
                
                
            }else{
                cas.Mensaje_Transaci_n__c=resp.left(255); 
                cas.transacion_ejecutada__c=false;
                
            }
            update cas;
            
            
            
       }
        
        
        
        PageReference p = new PageReference('/'+idcas);
        p.setRedirect(true);
        return p;
        
    }
       public  PageReference continuar(){
        system.debug('entro a continuar'); 
        PageReference p = new PageReference('/'+idcas);
        p.setRedirect(true);
        return p;
    }

}