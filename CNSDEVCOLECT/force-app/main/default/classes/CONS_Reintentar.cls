public class CONS_Reintentar {
    public string idcas{get;set;}
    public case cas{get;set;}
    public   CONS_Reintentar(ApexPages.StandardController controller){
        Idcas = ApexPages.currentPage().getParameters().get('id');   
        
        cas=[select id,Type,Subtipo__c,transacion_ejecutada__c,Autoriza_huella_Nectia__c,Tipo_de_Modificaci_n__c,V_a_de_Pago__c  from  case where  id=:idcas];
        
        
    } 
    
    public PageReference  validar(){
        if(cas.transacion_ejecutada__c==true){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No es posible reintentar la transacción debido a que ésta ya fue procesada');
            ApexPages.addMessage(myMsg); 
        }else if(cas.transacion_ejecutada__c==false){
            if(cas.Autoriza_huella_Nectia__c==false){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Debe solicitar autorización de su jefe en funciones');
                ApexPages.addMessage(myMsg); 
            }else{
                return   continuar();
            }
            
            
        }
        return null;
    }
    
    public PageReference  continuar(){
        
        
        if (cas.Type=='Solicitud' && cas.Subtipo__c=='Modificación de Póliza'  && cas.Tipo_de_Modificaci_n__c=='Vía de Pago' && (cas.V_a_de_Pago__c=='1' || cas.V_a_de_Pago__c=='2' || cas.V_a_de_Pago__c=='3')){
            system.debug('entro a proseso via de pago');
            
            system.debug('a servicio de modificación de vía de pago');
            pageReference p = new PageReference('/apex/CONS_CambioviaPago?id='+cas.Id);
            return p;
            
        }else if (cas.Type=='Solicitud' && cas.Subtipo__c=='Modificación de Póliza' && cas.Tipo_de_Modificaci_n__c=='Rehabilitación'){
            system.debug('entro a proseso rehabilitación');
            
            system.debug('a servicio de rehabilitación de póliza');
            pageReference p = new PageReference('/apex/CONS_Rehabilitacionpoliza?id='+cas.Id);
            return p;
            
        }else if (cas.Type=='Solicitud' && ((cas.Subtipo__c=='Modificación de Póliza'  && cas.Tipo_de_Modificaci_n__c=='Terminos de Pólizas (Solo Vida Tradicional)' ) || cas.Subtipo__c=='Término de Póliza') ){
            
            system.debug('entro a proseso Término');
            system.debug('a servicio de término de póliza');
            pageReference p = new PageReference('/apex/CONS_TerminoPoliza?id='+cas.Id);
            return p;
            
        }else if (cas.Type=='Solicitud' && cas.Subtipo__c=='Modificación de Póliza'  &&  cas.Tipo_de_Modificaci_n__c=='Suspensión de Pagos' ){
            system.debug('entro a Suspensión de Pagos');
            pageReference p = new PageReference('/apex/CONS_SuspensionPago?id='+cas.Id);
            return p;
            
        }else  if (cas.Type=='Solicitud' && cas.Subtipo__c=='Modificación de Póliza'  &&  cas.Tipo_de_Modificaci_n__c=='Prima Proyectada' ){
             system.debug('entro a Prima Proyectada');
            pageReference p = new PageReference('/apex/CONS_CambioPrimaProyectada?id='+cas.Id);
            return p; 
            
        }else  if (cas.Type=='Solicitud' && (cas.Subtipo__c=='Rescate' )){
            system.debug('entro a rescate');
            pageReference p = new PageReference('/apex/CONS_SolicitudRescate?id='+cas.Id);
            return p; 	               
            
        }else if (cas.Type=='Solicitud' && cas.Subtipo__c=='Actualización de datos' ){
            
            system.debug('entro a Actualización de datos');
            pageReference p = new PageReference('/apex/CONS_ProcesaCambioDatos?Id='+cas.Id);
            return p;
            
        }else if (cas.Type == 'Solicitud' && cas.Subtipo__c=='Gestión Clave'){
            
            system.debug('entro a Actualización de datos');
            pageReference p = new PageReference('/apex/CONS_GestionarclaveinternetReintento?Id='+cas.Id);
            return p;
            
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Solo se puede reintentar para las transacciones que no hayan sido cursadas de rehabilitacion, termino , via de pago  ,  prima  proyectada, suspencion de pago, rescate,  actualizadatos  y  gestion clave ' );
            ApexPages.addMessage(myMsg); 
        }
        
        
        return null;
    }
    public PageReference  volver(){
        pageReference p = new PageReference('/'+Idcas);
        return p;
        
    }
    
    
}