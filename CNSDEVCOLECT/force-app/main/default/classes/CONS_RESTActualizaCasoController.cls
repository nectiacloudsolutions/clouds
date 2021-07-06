@RestResource(urlMapping='/ActualizaCasos/*')    //https://xxx.salesforce.com/services/apexrest/ActualizaCasos/actualizarcaso
global with sharing class CONS_RESTActualizaCasoController {
    
    @HttpPost
    global static CONS_RESTActualizaCasoController.mensaje   actualizarcaso(integer num_caso,string estado, string sub_estado, string estado_mandato) { 
        CONS_RESTActualizaCasoController.mensaje  men=new CONS_RESTActualizaCasoController.mensaje();
        try{
            string num_caso1=string.valueOf(num_caso);
            for(integer i=num_caso1.length();num_caso1.length()<8;i++){
                num_caso1='0'+num_caso1;
            }
            system.debug('num_caso'+num_caso1);
            case cas =[select id,Status,Sub_estado_Nectia__c,Producto_del_Cliente_Nectia__c ,Account.PersonEmail,Account.name,Account.PersonMobilePhone,Account.Phone,CaseNumber,IdDocumentoDocuware__c,Estado_Activaci_n_Mandato__c
                       from case where CaseNumber =:num_caso1 limit 1 ];
            Producto_del_Cliente__c pro;
            if(cas.Producto_del_Cliente_Nectia__c!=null){
                pro =[SELECT Id, Telefono_intermediario__c, Nombre_intermediario_Nectia__c, Mail_intermediario__c FROM Producto_del_Cliente__c where id=:cas.Producto_del_Cliente_Nectia__c  limit 1 ];
                
            }
            if(estado!=null){
   if(estado=='CIERRE'){
              cas.Status='Cerrado';  
            }else{
               cas.Status=estado; 
            }
              if(sub_estado=='RECHAZO'){
              cas.Sub_estado_Nectia__c='Rechazado';  
            }else{
              cas.Sub_estado_Nectia__c=sub_estado;
            }
          
            
            cas.Estado_Activaci_n_Mandato__c=estado_mandato;
                system.debug('cas'+cas);
            }
           
            try{
                
                update cas;
                system.debug('cas'+cas);
                CONS_RESTActualizaCasoController.cliente  clie=new CONS_RESTActualizaCasoController.cliente();
                clie.nombre_cliente=cas.Account.name;
                clie.email_cliente=cas.Account.PersonEmail;
                if(cas.Account.PersonMobilePhone==null){
                   clie.celular_cliente=integer.valueOf('0');  
                }else{
                    string telefono=(cas.Account.PersonMobilePhone).replace(' ','').replace('+','');
                       clie.celular_cliente=integer.valueOf(telefono);  
                }
               
                CONS_RESTActualizaCasoController.ejecutivo  ejec=new CONS_RESTActualizaCasoController.Ejecutivo();
                if(cas.Producto_del_Cliente_Nectia__c!=null){  
                    ejec.Nombre_Ejecutivo=pro.Nombre_intermediario_Nectia__c ;
                    ejec.Email_Ejecutivo= pro.Mail_intermediario__c;
                    ejec.Telefono_Ejecutivo= pro.Telefono_intermediario__c;
                }
                men.ejecutivo=ejec;
                men.cliente=clie;
                men.Archivoid=cas.IdDocumentoDocuware__c;
            }catch(Exception e){
                
                system.debug('Exeption=: '+e);
                CONS_RESTActualizaCasoController.error  men2=new CONS_RESTActualizaCasoController.error();
                men2.error=string.valueOf(e);
                men2.codigo='1';
                men.errores=men2;
                
            }
        }catch(Exception e){
            
            system.debug('Exeption=: '+e);
            CONS_RESTActualizaCasoController.error  men2=new CONS_RESTActualizaCasoController.error();
            men2.error='numero de caso no encontrado';
            men2.codigo='1';
            men.errores=men2;
        }
        
        return men;
    }
    
    
    /*  @HttpPost  
global static CONS_RESTActualizaCasoController.mensaje   actualizarcaso2(string num_caso,string estado, string sub_estado,string numero_de_poliza,
string linea_de_negocio,string numero_linea_de_negocion,
string Plantilla,string Motivo_Rechazo,string banco, string numero_mandato, string resolucion_caso) { 

system.debug( 'num_caso='+num_caso);
system.debug( 'estado='+estado); 
system.debug( 'sub_estado='+sub_estado);
system.debug( 'numero_de_poliza='+numero_de_poliza);
system.debug( 'linea_de_negocio='+linea_de_negocio);
system.debug( 'numero_linea_de_negocion='+numero_linea_de_negocion);
system.debug( 'Plantilla='+Plantilla);
system.debug( 'Motivo_Rechazo='+Motivo_Rechazo);
system.debug( 'banco='+banco); 
system.debug( 'numero_mandato='+numero_mandato); 
system.debug( 'resolucion_caso='+resolucion_caso);




CONS_RESTActualizaCasoController.mensaje  men=new CONS_RESTActualizaCasoController.mensaje();
try{
case cas =[select id,Status,Sub_estado_Nectia__c,Account.PersonEmail,Account.name,Account.PersonMobilePhone,Account.Phone,CaseNumber from case where CaseNumber =:num_caso limit 1 ];
cas.Status=estado;
cas.Sub_estado_Nectia__c=sub_estado;
if(numero_de_poliza!=null && numero_de_poliza!=''){
cas.Banco__c=banco;
cas.Motivo_Rechazo__c=Motivo_Rechazo;
cas.N_mandato__c=decimal.valueOf(numero_mandato);
cas.Description=resolucion_caso;
}
try{

update cas;
if(numero_de_poliza==null || numero_de_poliza==''){
CONS_RESTActualizaCasoController.cliente  clie=new CONS_RESTActualizaCasoController.cliente();  
clie.nombre_cliente=cas.Account.name;
clie.email_cliente=cas.Account.PersonEmail;
clie.celular_cliente=cas.Account.PersonMobilePhone;
men.cliente=clie;  
}else{
CONS_RESTActualizaCasoController.datoscliente  dat=new CONS_RESTActualizaCasoController.datoscliente();
dat.Numero_de_Caso=cas.CaseNumber;
dat.Estado=cas.Status;
dat.poliza='';
dat.Linea_de_Negocio='';
dat.Numero_Linea_de_Negocion='';
dat.Nombre_Caso='';
dat.Email_Cliente=cas.Account.PersonEmail;
dat.Nombre_Cliente=cas.Account.name;
dat.Celular_Cliente=cas.Account.PersonMobilePhone;
dat.Nombre_Ejecutivo='';
dat.Email_Ejecutivo='';
dat.Telefono_Ejecutivo='';
dat.Id_Archivos_Adjuntos='';  
men.datoscliente=dat;    
}
}catch(Exception e){

system.debug('Exeption=: '+e);
CONS_RESTActualizaCasoController.error  men2=new CONS_RESTActualizaCasoController.error();
men2.error=string.valueOf(e);
men2.codigo='1';
men.errores=men2;
}
}catch(Exception e){

system.debug('Exeption=: '+e);
CONS_RESTActualizaCasoController.error  men2=new CONS_RESTActualizaCasoController.error();
men2.error='numero de caso no encontrado';
men2.codigo='1';
men.errores=men2;
}

return men;
}
*/ 
    global class mensaje {
        
        public cliente cliente {get;set;}
        public ejecutivo ejecutivo {get;set;}
        public error errores {get;set;}
         public string Archivoid {get;set;}
        
        // public datoscliente datoscliente {get;set;}
    }
    global class cliente {
        string nombre_cliente {get;set;}
        string email_cliente {get;set;}
        integer celular_cliente {get;set;}
        
    }
    global class ejecutivo {
        
        string nombre_ejecutivo {get;set;}
        string email_ejecutivo {get;set;}
        string telefono_ejecutivo {get;set;}
    }
    /*  global class datoscliente {
string Numero_de_Caso {get;set;}
string Estado {get;set;}
string poliza {get;set;}
string Linea_de_Negocio {get;set;}
string Numero_Linea_de_Negocion {get;set;}
string Nombre_Caso {get;set;}
string Email_Cliente {get;set;}
string Nombre_Cliente {get;set;}
string Celular_Cliente {get;set;}
string Nombre_Ejecutivo {get;set;}
string Email_Ejecutivo {get;set;}
string Telefono_Ejecutivo {get;set;}
string Id_Archivos_Adjuntos {get;set;}  
}
*/
    global class error {
        string error {get;set;}
        string codigo {get;set;}
    }
}