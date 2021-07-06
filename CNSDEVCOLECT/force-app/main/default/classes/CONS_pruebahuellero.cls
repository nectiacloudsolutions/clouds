public class CONS_pruebahuellero {
    
    public String urlSF{ get; set; }
    public String Id{ get; set; }
    public String tipo{get; set;}
    public String obj{get; set;}
    public String ruts{get; set;}
    public String div{get; set;}
    public String naut{get; set;}
    public String naut2{get; set;}
    public case cas{get; set;}
    
    public CONS_pruebahuellero(){
        
        urlSF = URL.getSalesforceBaseUrl().toExternalForm()+'/';
        Id = ApexPages.currentPage().getParameters().get('id');
        tipo= ApexPages.currentPage().getParameters().get('tipo');
        obj = ApexPages.currentPage().getParameters().get('obj');
        
        system.debug('obj'+obj);
        system.debug('tipo'+tipo);
        system.debug('Id'+Id);
        
        if(obj=='c'){
            cas=[select id,CaseNumber,Rut_del_Cliente__c,Rut_Tercero__c,Codigo_de_Validacion_Autentia_Nectia__c,Sub_estado_Nectia__c,Autoriza_huella_Nectia__c from case where id=:Id limit 1];
            system.debug('cas'+cas);
            if(cas.Rut_Tercero__c=='' || cas.Rut_Tercero__c==null){
                system.debug('cas.Rut_Tercero__c'+cas.Rut_Tercero__c);
                string []rut=cas.Rut_del_Cliente__c.split('-');
                ruts=rut[0];
                div=rut[1];
            }else{
                string []rut=cas.Rut_Tercero__c.split('-');
                ruts=rut[0];
                div=rut[1];  
            }
            
        }else if(obj=='p'){
            Account ac=[select id,RUT__c  from Account where id=:Id limit 1];
            
            string []rut=ac.RUT__c.split('-');
            ruts=rut[0];
            div=rut[1];
        }
        
        system.debug('ruts='+ruts);
        system.debug('div='+div);
        system.debug('urlSF='+urlSF);
        system.debug('id='+Id);
        system.debug('tipo='+tipo);
    }
    
    public PageReference  continuar(){
        system.debug('naut'+naut);
        // system.debug('naut2'+naut2);
        system.debug('continua  con  clase despues de huella ');
        if(tipo=='VP'){
            pageReference p = new PageReference('/apex/CONS_CambioviaPago?id='+Id+'&&Naut='+naut);
            return p;
        }
        if (tipo=='RP'){
            pageReference p = new PageReference('/apex/CONS_Rehabilitacionpoliza?id='+Id+'&&Naut='+naut);
            return p;
        }
        if (tipo=='TP'){
            pageReference p = new PageReference('/apex/CONS_TerminoPoliza?id='+Id+'&&Naut='+naut);
            return p;
            
        }
        if (tipo=='OP'){
            pageReference p = new PageReference('/'+Id);
            return p;
            
        }
        if (tipo=='PP'){
            pageReference p = new PageReference('/'+Id);
            return p;
            
        }
        if (tipo=='Res'){
            pageReference p = new PageReference('/'+Id);
            return p;
            
        }
        if (tipo=='SP'){
            pageReference p = new PageReference('/apex/CONS_SuspensionPago?id='+Id+'&&Naut='+naut);
            return p;
            
        }
        if (tipo=='CP'){
            pageReference p = new PageReference('/apex/CONS_CambioPrimaProyectada?id='+Id+'&&Naut='+naut);
            return p;
            
        }
        if (tipo=='com'){
            pageReference p = new PageReference('/apex/CONS_Comunicaciones?id='+Id+'&&Naut='+naut);
            return p;
            
        }
        if (tipo=='RR'){
            pageReference p = new PageReference('/apex/CONS_SolicitudRescate?id='+Id+'&&Naut='+naut);
            return p;
            
        }
        if (tipo=='AA'){
            cas.Codigo_de_Validacion_Autentia_Nectia__c=naut;
            update cas;
            pageReference p = new PageReference('/'+Id);
            return p;
            
        }
        if (tipo=='VPR'){
            cas.Codigo_de_Validacion_Autentia_Nectia__c=naut;
            update cas;
            pageReference p = new PageReference('/'+Id);
            return p;
            
        }
        if (tipo=='SI'){
            cas.Codigo_de_Validacion_Autentia_Nectia__c=naut;
            update cas;
            pageReference p = new PageReference('/'+Id);
            return p;
            
        }
        if (tipo=='Nueva_clave'){
            pageReference p = new PageReference('/apex/CONS_gestionarclaveinternet?scontrolCaching=1&id='+Id+'&&Naut='+naut+'&tipo=Nueva_clave');
            return p;
            
        }
        
        if (tipo=='ModificaDatos'){
            pageReference p = new PageReference('//apex/CONS_ProcesaCambioDatos??scontrolCaching=1&id='+Id+'&&Naut='+naut+'&tipo=ModificaDatos');
            return p;
        }
        
        return null;
    }
    public PageReference  huellarechasada(){
        if(obj=='c'){
            cas.Codigo_de_Validacion_Autentia_Nectia__c='huella rechazada';
            cas.Sub_estado_Nectia__c='Derivado a Supervisor';
            cas.Status = 'Nuevo';
            cas.Autoriza_huella_Nectia__c=false;
            
            update cas;
            pageReference p = new PageReference('/'+cas.Id);
            return p; 
            
        }else if(obj=='p'){
            if (tipo=='Nueva_clave'){
                pageReference p = new PageReference('/apex/CONS_gestionarclaveinternet?scontrolCaching=1&id='+Id+'&&Naut=huella_rechazada&tipo=Nueva_clave&T=RHA');
                return p;
            }
        }
        
        return null;   
    }
    
}