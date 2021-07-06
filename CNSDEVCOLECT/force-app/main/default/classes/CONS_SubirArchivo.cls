public class CONS_SubirArchivo {
    
    public String opcion{get; set;}
    public String opcion2{get; set;}
    public String opcion3{get; set;}
    public String casid{get; set;}
    public blob archivo{get; set;}
    public integer largo{get; set;}
    public Attachment objCaseAtt {get; set;}
    Public  case cas1 {get; set;}
    Public List<SelectOption> lista2 {get; set;}
    Public  Transient CONS_RespuestaDocuwaresubir_JSON resser {get; set;}

    public User tmpUser{get;set;}
    
    
    public CONS_SubirArchivo(ApexPages.StandardController controller) {
        casid=controller.getId();
        
        cas1=[select id,Rut_del_Cliente__c,CaseNumber,IdDocumentoDocuware__c,Producto_del_Cliente_Nectia__r.L_nea__c,Producto_del_Cliente_Nectia__r.Poliza_Nectia__c,
              Producto_del_Cliente_Nectia__r.Ramo_Nectia__c, Producto_del_Cliente_Nectia__r.Esquema_Nectia__c
              from case where id =: casid limit 1];
        objCaseAtt=new Attachment();
        opcion='ANU';
        opcion3='DOCTOS';
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Después de cargar archivo en Carpeta Digital, espere unos segundos antes de actualizar la ficha del caso.');
        ApexPages.addMessage(myMsg);
        Items(); 
    }
    
    
    public List<SelectOption> Items() {
        system.debug('opcion'+opcion);
        List<SelectOption> options = new List<SelectOption>();
        if(opcion=='END'){
            
            options.add(new SelectOption('AUTCLIEN','Autorización Cliente'));
            options.add(new SelectOption('CARCAR','Carta de Cancelación'));
            options.add(new SelectOption('CARDES','Carta de desafiliación'));
            options.add(new SelectOption('CARNOREN','Carta de no Renovación'));
            options.add(new SelectOption('CARCL','Carta del Cliente'));
            options.add(new SelectOption('CARCON','Carta del Contratante'));
            options.add(new SelectOption('CARSIN','Carta no siniestralidad'));
            options.add(new SelectOption('CUEST','Cuestionario'));
            options.add(new SelectOption('DECLAR','Declaración'));
            options.add(new SelectOption('DOCAUT','Documento Auto'));
            options.add(new SelectOption('DOCNOT','Documento Notarial'));
            options.add(new SelectOption('FORMEND','Formulario Endoso'));
            options.add(new SelectOption('FCI','Fotocopia Cédula de Identidad'));
            options.add(new SelectOption('FR','Fotocopia rut (empresa/contratante'));
            options.add(new SelectOption('INSPEC','Inspección'));
            options.add(new SelectOption('MAILAUT','Mail Autorización'));
            options.add(new SelectOption('MAILCLI','Mail Cliente'));
            options.add(new SelectOption('MAILEJ','Mail Ejecutivo'));
            options.add(new SelectOption('MAILINSP','Mail Inspección'));
            options.add(new SelectOption('MAILPOL','Mail Póliza'));
            options.add(new SelectOption('MDTO','Mandato'));
            options.add(new SelectOption('CERIOT','Otro Certificado'));
            options.add(new SelectOption('SAAP','SAAP'));
            opcion2='AUTCLIEN';
        }else if(opcion=='CANC'){       
            
            options.add(new SelectOption('CARCAR','Carta de Cancelación'));
            options.add(new SelectOption('CARCL','Carta del Cliente'));
            options.add(new SelectOption('CONT','Contrato'));
            options.add(new SelectOption('FCI','Fotocopia Cédula de Identidad'));
            options.add(new SelectOption('MAILPOL','Mail Póliza'));
            options.add(new SelectOption('CERIOT','Otro Certificado'));
            opcion2='CARCAR';
        }else if(opcion=='ANU'){    
            
            options.add(new SelectOption('DCTO','Documento'));
            options.add(new SelectOption('CARCL','Carta del Cliente'));
            opcion2='DCTO';
        }else if(opcion=='Rescate'){
            
            options.add(new SelectOption('CARPERBEN','Carta de pérdida de beneficiario'));
            options.add(new SelectOption('DOCNOT','Documento Notarial'));
            options.add(new SelectOption('FORMRES','Formulario Rescate'));
            options.add(new SelectOption('FCI','Fotocopia Cédula de Identidad'));
            options.add(new SelectOption('SAAP','SAAP'));
            opcion2='SAAP';
        }else if(opcion=='SIN'){    
            
            options.add(new SelectOption('CART','Cartola'));
            options.add(new SelectOption('CERTDEF','Certificado de Defunción'));
            options.add(new SelectOption('CERTMED','Certificado Médico'));
            options.add(new SelectOption('EXAM','Exámenes'));
            options.add(new SelectOption('FORMSIN','Formulario Siniestro'));
            options.add(new SelectOption('FCI','Fotocopia Cédula de Identidad'));
            options.add(new SelectOption('FOTOS','Fotos'));
            options.add(new SelectOption('PP','Parte Policias'));
            options.add(new SelectOption('REEMB','Reembolso'));
            opcion2='CART';
        }else if(opcion=='RENV'){   
            
            options.add(new SelectOption('CARREN','Carta de Renovación'));
            options.add(new SelectOption('CARNOREN','Carta de no Renovación'));
            options.add(new SelectOption('CARCL','Carta del cliente'));
            options.add(new SelectOption('DCTO','Documento'));
            opcion2='CARREN';
        }else if(opcion=='VEN'){    
            
            options.add(new SelectOption('CARCL','Carta del cliente'));
            options.add(new SelectOption('DCTO','Documento'));
            opcion2='CARCL';
        }else if(opcion=='EMI'){    
            
            options.add(new SelectOption('CARCL','Carta del cliente'));
            options.add(new SelectOption('DCTO','Documento'));
            opcion2='CARCL';
        }else if(opcion=='PAG'){    
            options.add(new SelectOption('CARCL','Carta del Cliente'));
            options.add(new SelectOption('CARDEVPRI','Carta devolución Prima'));
            options.add(new SelectOption('CERTCIVIL','Certificado Civil'));
            options.add(new SelectOption('CERTDEF','Certificado de Defunción'));
            options.add(new SelectOption('CERTIEST','Certificado de Estudios'));
            options.add(new SelectOption('DECLAR','Declaración'));
            options.add(new SelectOption('DOCNOT','Documento Notarial'));
            options.add(new SelectOption('FACT','Factura'));
            options.add(new SelectOption('FORMPAG','Formulario Pago'));
            options.add(new SelectOption('FCI','Fotocopia Cédula de Identidad'));
            options.add(new SelectOption('MDTO','Mandato'));
            options.add(new SelectOption('CERIOT','Otro Certificado'));
            opcion2='CARCL';
        }else if(opcion=='PVEN'){   
            
            
            options.add(new SelectOption('CARMOR','Carta de Mora'));
            options.add(new SelectOption('COT','Cotización'));
            options.add(new SelectOption('DOCNOT','Documento Notarial'));
            options.add(new SelectOption('FCI','Fotocopia Cédula de Identidad'));
            options.add(new SelectOption('GRAB','Grabación'));
            options.add(new SelectOption('INSPEC','Inspección'));
            options.add(new SelectOption('MAILEJ','Mail Ejecutivo'));
            options.add(new SelectOption('CERIOT','Otro Certificado'));
            options.add(new SelectOption('PLANPAG','Plan de Pago'));
            
            opcion2='CARMOR';
        }
        lista2=options;
        return lista2;
    }
    
    
  
    public PageReference  estado(){
        system.debug('objCaseAtt'+objCaseAtt);
        system.debug('objCaseAtt'+objCaseAtt.Name);
        system.debug('objCaseAtt'+objCaseAtt.Body);
        system.debug('largo'+largo);
        system.debug('opcion'+opcion);
        system.debug('opcion2'+opcion2);
        system.debug('opcion3'+opcion3);
        
        if(largo < 5000000 && largo > 0){
            Cons_callOutService  call= new Cons_callOutService();
            CONS_estructuratoken est=new  CONS_estructuratoken();
            string access_token=est.token();
            system.debug('token=='+access_token);
            string str='';
            string texto= string.valueOf(objCaseAtt.Name);
            system.debug('texto'+texto);
            string tex=texto.replace('.', '//');
            string []tex1=tex.split('//');
            system.debug('texto'+tex);
            system.debug('texto'+tex1[0]);
            string poliza;
            string tipo;
            if(cas1.Producto_del_Cliente_Nectia__r.Poliza_Nectia__c==null){
                poliza='';
                
            }else{
                poliza=cas1.Producto_del_Cliente_Nectia__r.Poliza_Nectia__c; 
            }
            
            if(cas1.Producto_del_Cliente_Nectia__r.Esquema_Nectia__c=='CLONINSUDB'){
                if(cas1.Producto_del_Cliente_Nectia__r.Ramo_Nectia__c=='9'){
                    tipo = 'VEH'; 
                }else if(cas1.Producto_del_Cliente_Nectia__r.Ramo_Nectia__c=='10'){
                    tipo = 'Hogar'; 
                }else{
                    tipo = ''; 
                }
                
            }else if(cas1.Producto_del_Cliente_Nectia__r.Esquema_Nectia__c=='INSUDB'){
                tipo = 'VI';
            }else if(cas1.Producto_del_Cliente_Nectia__r.Esquema_Nectia__c=='SISRVOWCNS'|| cas1.Producto_del_Cliente_Nectia__r.Esquema_Nectia__c=='SISRVOWPCNS' || cas1.Producto_del_Cliente_Nectia__r.Esquema_Nectia__c=='SISRVOWCNL'){
                tipo = 'RRVV';
            }else{
                tipo='';
            }

    		tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];

            if(!test.isRunningTest()){

				str=call.callOutguardardocumento(access_token, opcion, opcion2, opcion3, cas1.Rut_del_Cliente__c ,objCaseAtt.Body,tex1[1],cas1.CaseNumber,objCaseAtt.Name,poliza,tipo,tmpUser);
                objCaseAtt.Body = null;

                updateUser();

            }else{
                str='{"codigo":"0000","codigoServicio":"0","dwDocId":184948,"mensajeServicio":"OK"}';
            }
            
            if(!str.contains('ERROR -')){
                 resser = (CONS_RespuestaDocuwaresubir_JSON)JSON.deserialize(str,CONS_RespuestaDocuwaresubir_JSON.class);  
                if(resser.codigo=='0000'){
                    
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Archivo subido correctamente');
                    ApexPages.addMessage(myMsg);
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.CONFIRM,'id de documento: '+resser.dwDocId);
                    ApexPages.addMessage(myMsg1);
                    cas1.IdDocumentoDocuware__c=string.valueOf(resser.dwDocId);
                    update cas1;
                    return volver(); 
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR:'+resser.mensaje); 
                    ApexPages.addMessage(myMsg);
                    return null; 
                }
                
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR:'+str); 
                ApexPages.addMessage(myMsg); 
                return null; 
            }
            
            
        }else if(largo == 0 || largo == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Adjunte algún archivo');
            ApexPages.addMessage(myMsg);
            
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'El archivo seleccionado supera el tamaño máximo permitido de 5 MB');
            ApexPages.addMessage(myMsg);
            objCaseAtt=null;
        }
        
        return null; 
    }
    
    public PageReference  seccion(){
        system.debug('opcion'+opcion);
        system.debug('opcion2'+opcion2);
        system.debug('opcion3'+opcion3);
        Items();
        return null;
    }
    
    public PageReference  volver(){
        PageReference pageRef = new PageReference('/'+cas1.id);
        return pageRef;
    }

	public void updateUser(){
		system.debug(tmpUser.AccessToken_Nectia__c);
		update tmpUser;
	}

}