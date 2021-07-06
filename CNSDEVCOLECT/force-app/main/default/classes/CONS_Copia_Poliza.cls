public class CONS_Copia_Poliza {
    public Transient String aux { get; set; }
    public Transient String extAux { get; set; }
    public  String error { get; set; }
    public  boolean errorpagina { get; set; }
    public  boolean continuarsinenviar { get; set; }
    public string nombre {get;set;}
    public string id {get;set;}
    public string body {get;set;}
    public string respuestaerror {get;set;}
    public string resp {get;set;}
    public string email {get;set;}
    public string codigoError {get;set;}
    public string mensageError {get;set;}
    public string idcas {get;set;}
    public User tmpUser{get;set;}

    list<Attachment> documentos = new list<Attachment>();
    public  Producto_del_Cliente__c pro{get;set;}
    public  Profile prof{get;set;}
    public  case cas {get;set;}
    public integer contadorcaso {get;set;}
    
    public CONS_Copia_Poliza(ApexPages.StandardController  controller) {
        system.debug('controller'+controller);
        string idusuario=userinfo.getUserId();
        user us =[SELECT Id, Username, LastName, FirstName, Name, ProfileId FROM User WHERE Id = :idusuario];
        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId() limit 1];
        system.debug('us'+us);
        prof=[SELECT Id, Name FROM Profile WHERE Id = :us.ProfileId];
        system.debug('prof'+prof);
        Producto_del_Cliente__c rt = (Producto_del_Cliente__c) controller.getRecord(); 
        id = ApexPages.currentPage().getParameters().get('id');
        pro = [SELECT Id, Poliza_Nectia__c,Cliente_Nectia__r.PersonEmail,Rut_del_Cliente__c,Cliente_Nectia__c,Tipo_Registro_Nectia__c,Esquema_Nectia__c,Numero_Certificado_Nectia__c,Codigo_Plan_Nectia__c,
               Ramo_Nectia__c,Cliente_Nectia__r.name,Cliente_Nectia__r.CambioMail__c,Cliente_Nectia__r.NuevoCorreo__c,L_nea__c,Cliente_Nectia__r.PersonContactId
               FROM Producto_del_Cliente__c where  id=:id limit 1];
        if(pro.Cliente_Nectia__r.CambioMail__c==true){
            email = pro.Cliente_Nectia__r.NuevoCorreo__c;
        }else{
            email = pro.Cliente_Nectia__r.PersonEmail;
        }
        
        errorpagina = true;
        contadorcaso=0;
        // verdocumento();
    }

    public PageReference siguiente(){
        system.debug('prof.id'+prof.id);
        continuarsinenviar=true;
        errorpagina = true;
        return verdocumento();   
    }

    public PageReference verdocumento(){

        string estructura='{'+
            '"datosLoggerCns": {'+
            '"nombreAplicacion": "CELA",'+
            '"nombreUsuario": "CELA" '+
            '},'+
            '"copiaPolizaInputAll":{'+
            '"rut_cliente": "'+pro.Rut_del_Cliente__c+'",'+
            '"numero_poliza": '+pro.Poliza_Nectia__c+','+
            '"numero_propuesta": 0,'+
            '"numero_certificado": 0,'+
            '"tipo_certificado": 2,'+  //'+(pro.Numero_Certificado_Nectia__c==null?'':pro.Numero_Certificado_Nectia__c)+'
            '"correo_electronico": "",';
        
        if(pro.Esquema_Nectia__c=='INSUDB'){
            estructura=estructura+  '"flag_lineaNegocio": "2",'+
                '"ramo_comercial": '+(pro.Ramo_Nectia__c==null?'0':pro.Ramo_Nectia__c)+','+
                '"numero_producto": '+(pro.Codigo_Plan_Nectia__c==null?'':pro.Codigo_Plan_Nectia__c)+',';
            if(pro.Ramo_Nectia__c=='1' || pro.Ramo_Nectia__c=='6'){
                estructura=estructura+  '"nombre_producto": "VIDA",';
            }
        }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){
            estructura=estructura+  '"flag_lineaNegocio": "3",'+
                '"ramo_comercial": '+(pro.Ramo_Nectia__c==null?'0':pro.Ramo_Nectia__c)+','+
                '"numero_producto": '+(pro.Codigo_Plan_Nectia__c==null?'':pro.Codigo_Plan_Nectia__c)+',';
            if(pro.Ramo_Nectia__c=='9'){
                estructura=estructura+  '"nombre_producto": "SEGUROAUTO",';
            }else if(pro.Ramo_Nectia__c=='10'){
                estructura=estructura+  '"nombre_producto": "SEGUROHOGAR",';
            }
        }else if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){
            estructura=estructura+  '"flag_lineaNegocio": "2",'+
                '"ramo_comercial": 3,'+
                '"numero_producto": 8,';
            //  if(pro.Ramo_Nectia__c=='3'){
            estructura=estructura+  '"nombre_producto": "RRVV",';
            //  }
        }
        
        estructura= estructura+ '"nombre_completo": "'+pro.Cliente_Nectia__r.name+'"'+
            '}}';
        
        
        Cons_callOutService  call= new Cons_callOutService();
        // string token=call.callOuttoken();
        // system.debug('token'+token);
        
        //  CONS_token_JSON tok = (CONS_token_JSON)JSON.deserialize(token,CONS_token_JSON.class); 
        CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);
        string  resp;
        if(pro.Esquema_Nectia__c=='INSUDB'){
            resp = call.callOutCopia_Poliza_Vida(access_token, estructura, tmpUser);
        }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){
            resp = call.callOutCopia_Poliza_Generales(access_token, estructura, tmpUser);
        }else if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){
            resp = call.callOutCopia_Poliza_RV(access_token, estructura, tmpUser);
        }
        if(test.isRunningTest()){
            if(pro.Esquema_Nectia__c=='INSUDB'){
                resp='{    "DTOcopiaPolizaPDF_VI": {        "ruta_archivo": "http://tcon194/WS_InterfacePuente/GetArchivoCartolasVidaServlet?ruta=/POLIZAS_VIDAIND/POLN_P1016967_1_214.pdf",        "documento": "JVBAgT0YK", "nombre_archivo": "POLN_P1016967_1_214.pdf"    },    "codigo": "0",    "mensaje": "Pdf creado correctamente",    "mensajeEx": "OK"}';
            }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){
                resp='{    "DTOcopiaPolizaPDF_GEN": {        "documento": "JVBERi0xLjTANCiUlRU9GDQo=", "nombre_archivo": "POLN_GEN_3149949_9_29.PDF"    },    "codigo": "0",    "mensaje": "PDF OK",    "mensajeEx": "PDF OK"}';
            }else if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){
                resp='{    "DTOcopiaPolizaPDF_RRVV": {        "codigo_error": "0",        "mensaje_estado": "PDF OK",        "descripcion_usuario": "PDF OK",        "documento": "JVBERigCiUlRU9GIAo=", "nombre_archivo": "POLN_RRVV_273933_CNS_V467.pdf"    },    "codigo": "0",    "mensaje": "Ejecucion exitosa",    "mensajeEx": "Ejecucion sin Excepciones"}';
                
            }
        }
        
        system.debug('resp'+resp);   
        CONS_Respuestacopiapoliza_JSON rescoppol;
        CONS_Respuestacopiapolizavida_JSON rescoppolv ;
        CONS_RespuestaCopiaPolizaRV_JSON rescoppolRV;
        if(pro.Esquema_Nectia__c=='CLONINSUDB'){
            rescoppol = (CONS_Respuestacopiapoliza_JSON)JSON.deserialize(resp,CONS_Respuestacopiapoliza_JSON.class); 
            codigoError=rescoppol.codigo;
            mensageError=rescoppol.mensaje;
        }else if(pro.Esquema_Nectia__c=='INSUDB'){
            rescoppolv = (CONS_Respuestacopiapolizavida_JSON)JSON.deserialize(resp,CONS_Respuestacopiapolizavida_JSON.class); 
            codigoError=rescoppolv.codigo;
            mensageError=rescoppolv.mensaje;
        }else if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){
            rescoppolRV = (CONS_RespuestaCopiaPolizaRV_JSON)JSON.deserialize(resp,CONS_RespuestaCopiaPolizaRV_JSON.class); 
            codigoError=rescoppolRV.codigo;
            mensageError=rescoppolRV.mensaje;
            
        }
        
        // parse(resp);
        system.debug('codigoError'+codigoError);        
        system.debug('aux'+aux);       
        if(codigoError =='0'){
            errorpagina = true; 
            if(pro.Esquema_Nectia__c=='CLONINSUDB'){
                aux = rescoppol.DTOcopiaPolizaPDF_GEN.documento;
            }else if(pro.Esquema_Nectia__c=='INSUDB'){
                aux = rescoppolv.DTOcopiaPolizaPDF_VI.documento;
            }else if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){
                aux = rescoppolRV.DTOcopiaPolizaPDF_RRVV.documento;
            }
            extAux = 'applicacion/pdf';
            
            if(contadorcaso==0){

                // tipo de registro para caso cerrado por emisión correcta
                String TipoDeRegistro;
                String CaseRecordTypeId;
                String linea;
                String tipo = 'Solicitud';
                if (pro.L_nea__c == 'Rentas Vitalicias'){
                    linea = 'Renta';
                }else{
                    linea = pro.L_nea__c;
                }
                TipoDeRegistro = 'Seguros - ' + tipo + ' - ' + linea;
                System.debug('tipo->'+TipoDeRegistro);

                Schema.DescribeSObjectResult caseDesribe = Schema.SObjectType.Case;
                Map<String,Schema.RecordTypeInfo> rtMapByName = caseDesribe.getRecordTypeInfosByName();
                Schema.RecordTypeInfo rtByName =  rtMapByName.get(TipoDeRegistro);
                CaseRecordTypeId = rtByName.getRecordTypeId();
                System.debug('Id Tipo de registro->'+CaseRecordTypeId); 
                
                System.debug('tipo de registro->'+CaseRecordTypeId);


                cas = new case();
                //cas.RecordTypeId = [SELECT Id, DeveloperName, SobjectType, IsActive, Description FROM RecordType  where  DeveloperName ='Casos_Seguros'].id;
                cas.RecordTypeId = CaseRecordTypeId;
                cas.Type = 'Solicitud';
                cas.Subtipo__c = 'Emisión Documentos';
                cas.Status='Cerrado';
                cas.Tipo_de_documento__c = 'Copia de Póliza';
                cas.Subject = 'Copia de Póliza generada exitosamente';
                
                cas.AccountId = pro.Cliente_Nectia__c;
                cas.ContactId = pro.Cliente_Nectia__r.PersonContactId;
                cas.Producto_del_Cliente_Nectia__c = id;
                cas.Rut_del_Cliente__c = pro.Rut_del_Cliente__c;
                insert cas;
                contadorcaso++;
            }
            
        }else{
            
            cas = new case();
            cas.RecordTypeId = [SELECT Id, DeveloperName, SobjectType, IsActive, Description FROM RecordType  where  DeveloperName ='Casos_Seguros'].id;
            cas.Type = 'Solicitud';
            cas.Subtipo__c = 'Emisión Documentos';
            cas.Status = 'Nuevo';
            cas.Tipo_de_documento__c = 'Copia de Póliza';
            cas.Subject = 'Copia de Póliza no generada. Derivada a cola de resolución correspondiente';
            cas.Description = 'No se ha encontrado la poliza. Se asigna a la cola correspondiente para que resuelvan la situación.';
            cas.AccountId = pro.Cliente_Nectia__c;
            cas.ContactId = pro.Cliente_Nectia__r.PersonContactId;
            cas.Producto_del_Cliente_Nectia__c = id;  
            cas.Rut_del_Cliente__c = pro.Rut_del_Cliente__c;
            insert cas;
            continuarsinenviar=false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No se pudo encontrar el documento se generara un caso presione continuar para verificar el caso');
            ApexPages.addMessage(myMsg);
            ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: '+ mensageError);
            ApexPages.addMessage(myMsg1);
            errorpagina = false; 
        }
        return null;
    }
    public PageReference volver(){

/*        cas.Status = 'Cerrado';
        cas.Sub_estado_Nectia__c='Solucionado';
        cas.Description = 'Documento descargado por usuario.';     
        update cas;*/
        
        PageReference pageRef = new PageReference('/'+id);
        return pageRef;
    }
    public PageReference enviar(){
        if(email!=null){
            
            string estructura='{'+
                '"datosLoggerCns": {'+
                '"nombreAplicacion": "CELA",'+
                '"nombreUsuario": "CELA" '+
                '},'+
                '"copiaPolizaInputAll":{'+
                '"rut_cliente": "'+pro.Rut_del_Cliente__c+'",'+
                '"numero_poliza": '+pro.Poliza_Nectia__c+','+
                '"numero_propuesta": 0,'+
                '"numero_certificado": 0,'+
                '"tipo_certificado": 2,'+  //'+(pro.Numero_Certificado_Nectia__c==null?'':pro.Numero_Certificado_Nectia__c)+'
                '"correo_electronico": "'+email+'",';
            
            if(pro.Esquema_Nectia__c=='INSUDB'){
                estructura=estructura+  '"flag_lineaNegocio": "2",'+
                    '"ramo_comercial": '+(pro.Ramo_Nectia__c==null?'0':pro.Ramo_Nectia__c)+','+
                    '"numero_producto": '+(pro.Codigo_Plan_Nectia__c==null?'':pro.Codigo_Plan_Nectia__c)+',';
                if(pro.Ramo_Nectia__c=='1' || pro.Ramo_Nectia__c=='6'){
                    estructura=estructura+  '"nombre_producto": "VIDA",';
                }
            }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){
                estructura=estructura+  '"flag_lineaNegocio": "3",'+
                    '"ramo_comercial": '+(pro.Ramo_Nectia__c==null?'0':pro.Ramo_Nectia__c)+','+
                    '"numero_producto": '+(pro.Codigo_Plan_Nectia__c==null?'':pro.Codigo_Plan_Nectia__c)+',';
                if(pro.Ramo_Nectia__c=='9'){
                    estructura=estructura+  '"nombre_producto": "SEGUROAUTO",';
                }else if(pro.Ramo_Nectia__c=='10'){
                    estructura=estructura+  '"nombre_producto": "SEGUROHOGAR",';
                }
            }else if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){
                estructura=estructura+  '"flag_lineaNegocio": "2",'+
                    '"ramo_comercial": 3,'+
                    '"numero_producto": 8,';
                //  if(pro.Ramo_Nectia__c=='3'){
                estructura=estructura+  '"nombre_producto": "RRVV",';
                //  }
            }
            
            estructura= estructura+ '"nombre_completo": "'+pro.Cliente_Nectia__r.name+'"'+
                '}}';
            
            Cons_callOutService  call= new Cons_callOutService();
            CONS_estructuratoken est=new  CONS_estructuratoken();
            string access_token=est.token();
            system.debug('token=='+access_token);
            string  resp;
            if(pro.Esquema_Nectia__c=='INSUDB'){
                resp = call.callOutCopia_Poliza_Vida(access_token, estructura, tmpUser);
            }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){
                resp = call.callOutCopia_Poliza_Generales(access_token, estructura, tmpUser);
            }else if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){
                resp = call.callOutCopia_Poliza_RV(access_token, estructura, tmpUser);
            }        system.debug('resp'+resp);
            if(test.isRunningTest()){
                if(pro.Esquema_Nectia__c=='INSUDB'){
                    resp='{    "DTOcopiaPolizaPDF_VI": {        "ruta_archivo": "http://tcon194/WS_InterfacePuente/GetArchivoCartolasVidaServlet?ruta=/POLIZAS_VIDAIND/POLN_P1016967_1_214.pdf",        "documento": "JVBAgT0YK", "nombre_archivo": "POLN_P1016967_1_214.pdf"    },    "codigo": "0",    "mensaje": "Pdf creado correctamente",    "mensajeEx": "OK"}';
                }else if(pro.Esquema_Nectia__c=='CLONINSUDB'){
                    resp='{    "DTOcopiaPolizaPDF_GEN": {        "documento": "JVBERi0xLjTANCiUlRU9GDQo=", "nombre_archivo": "POLN_GEN_3149949_9_29.PDF"    },    "codigo": "0",    "mensaje": "PDF OK",    "mensajeEx": "PDF OK"}';
                }else if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){
                    resp='{    "DTOcopiaPolizaPDF_RRVV": {        "codigo_error": "0",        "mensaje_estado": "PDF OK",        "descripcion_usuario": "PDF OK",        "documento": "JVBERigCiUlRU9GIAo=", "nombre_archivo": "POLN_RRVV_273933_CNS_V467.pdf"    },    "codigo": "0",    "mensaje": "Ejecucion exitosa",    "mensajeEx": "Ejecucion sin Excepciones"}';
                    
                }
            }
            CONS_Respuestacopiapoliza_JSON rescoppol;
            CONS_Respuestacopiapolizavida_JSON rescoppolv ;
            CONS_RespuestaCopiaPolizaRV_JSON rescoppolRV;
            if(pro.Esquema_Nectia__c=='CLONINSUDB'){
                rescoppol = (CONS_Respuestacopiapoliza_JSON)JSON.deserialize(resp,CONS_Respuestacopiapoliza_JSON.class); 
                codigoError=rescoppol.codigo;
                mensageError=rescoppol.mensaje;
            }else if(pro.Esquema_Nectia__c=='INSUDB'){
                rescoppolv = (CONS_Respuestacopiapolizavida_JSON)JSON.deserialize(resp,CONS_Respuestacopiapolizavida_JSON.class); 
                codigoError=rescoppolv.codigo;
                mensageError=rescoppolv.mensaje;
            }else if(pro.Esquema_Nectia__c=='SISRVOWCNS'|| pro.Esquema_Nectia__c=='SISRVOWPCNS' || pro.Esquema_Nectia__c=='SISRVOWCNL'){
                rescoppolRV = (CONS_RespuestaCopiaPolizaRV_JSON)JSON.deserialize(resp,CONS_RespuestaCopiaPolizaRV_JSON.class); 
                codigoError=rescoppolRV.codigo;
                mensageError=rescoppolRV.mensaje;
                
            }
            //  codigoError=rescoppol.codigo;
            system.debug('codigoError'+codigoError);        
            system.debug('aux'+aux);       
            if(codigoError =='OK'){
               
                //cas.Status = 'Cerrado';
                cas.Sub_estado_Nectia__c='Solucionado';
                cas.Description = 'Documento enviado con éxito al email  '+email;
                update cas;    
                PageReference pageRef = new PageReference('/'+cas.id);
                return pageRef;       
                
            }else{
                
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: '+ mensageError);
                ApexPages.addMessage(myMsg1);
                errorpagina = false;  
            }
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Cliente no tiene email válido');//+cas1.CaseNumber);
            ApexPages.addMessage(myMsg); 
            verdocumento();
            return null;
        }
        
        return null;
    }
    public PageReference continuar(){
        system.debug('cas'+cas);
        if(cas==null){
            PageReference pageRef = new PageReference('/'+id);
            return pageRef;   
        }else{
            
            PageReference pageRef = new PageReference('/'+cas.id);
            return pageRef;
        }
    }
    public PageReference continuarcaso(){
        //cas.Status = 'Cerrado';
        cas.Sub_estado_Nectia__c='Solucionado';
        cas.Description = 'Documento  descargada por usuario.';     
        update cas;
        PageReference pageRef = new PageReference('/'+cas.id);
        return pageRef;
    }

    public void updateUser(){
        system.debug(tmpUser.AccessToken_Nectia__c);
        update tmpUser;
    }

    public PageReference orquestaMetodos(){
        siguiente();
        updateUser();
        return null;
    }
    
    
    
    /*    public String parse(String toParse) {
DOM.Document doc = new DOM.Document();
try {
doc.load(toParse);    
DOM.XMLNode root = doc.getRootElement();
return walkThrough(root);

} catch (System.XMLException e) {  // invalid XML
return e.getMessage();
}
}

public String walkThrough(DOM.XMLNode node) {
String result = '\n';
integer j=0;
if (node.getNodeType() == DOM.XMLNodeType.COMMENT) {

return 'Comment (' +  node.getText() + ')';
}
if (node.getNodeType() == DOM.XMLNodeType.TEXT) {

return 'Text (' + node.getText() + ')';
}
if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
result += 'Element: ' + node.getName();

if (node.getText().trim() != '') {
result += ', text=' + node.getText().trim();

}
system.debug('=======nodo========='+node.getName());
if(node.getName()=='Documento'){
aux= node.getText().trim();
system.debug('=======Documento========= '+aux);
}
if(node.getName()=='codigo'){
codigoError= node.getText().trim();
system.debug('=======codigo========= '+codigoError);

}
if(node.getName()=='mensaje'){
mensageError= node.getText().trim();
system.debug('=======mensageError========= '+mensageError);

}

if (node.getAttributeCount() > 0) { 
for (Integer i = 0; i< node.getAttributeCount(); i++ ) {
result += ', attribute #' + i + ':' + node.getAttributeKeyAt(i) + '=' + node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));

}  
}

for (Dom.XMLNode child: node.getChildElements()) {
result += walkThrough(child);
}
// system.debug('result'+result);
return result;
}
system.debug('result'+result);
return '';  //should never reach here 
}*/
}