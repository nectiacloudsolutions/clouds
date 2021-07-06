public class CONS_Siniestros_PdC_Controller {
    
    private final sObject mysObject;
    
    public String TokenAcceso;
    public Producto_del_Cliente__c prod{get;set;}
    public boolean esquemavida{get;set;}
    public boolean esquemagenerales{get;set;}
    public boolean errorAcceso{get; set;}
    public list<listado>  lista {get;set;}
    public String mensaje {get; set;}
    public String id {get; set;}
    public String respuesta;
    public list<DetalleInfoSiniestro> listaSiniestros {get;set;}
    public String instancia;
    String mensajeForce;
    public User tmpUser{get;set;}
    
    public CONS_Siniestros_PdC_Controller(ApexPages.StandardController stdController){
        
        this.mysObject = (sObject)stdController.getRecord();
       // id='a094F000000yDXi';
        prod=[select Poliza_Nectia__c,Tipo_Registro_Nectia__c,Ramo_Nectia__c,Codigo_Plan_Nectia__c,Numero_Certificado_Nectia__c,Esquema_Nectia__c,Rut_del_Cliente__c from Producto_del_Cliente__c where id=:mysObject.Id];
       system.debug('prod'+prod);
        lista  =new list<listado>();
        
        if(prod.Esquema_Nectia__c!=null){
            if(prod.Esquema_Nectia__c=='INSUDB' || prod.Esquema_Nectia__c=='VTCNLIFE'){
                esquemavida=true;
                esquemagenerales=false;
                listar_vida_o_life();
                
            }else if(prod.Esquema_Nectia__c=='CLONINSUDB'){
                esquemagenerales=true;
                esquemavida=false;
                
                TokenAcceso = obtieneAcceso();
                system.debug('TokenAcceso->'+TokenAcceso);
                
                if (TokenAcceso == 'error'){
                    errorAcceso = true;
                    esquemavida=false;
                    esquemagenerales=false;
                    mensaje = 'Error al obtener los datos';
                }else{
                    string endPoint=instancia+'?rut='+prod.Rut_del_Cliente__c+'&pol='+prod.Poliza_Nectia__c+'&ram='+prod.Ramo_Nectia__c+'&pro='+prod.Codigo_Plan_Nectia__c+'';
                    system.debug('endpoint->'+endPoint);
                    Http h1=new Http();
                    HttpRequest req1=new HttpRequest();
                    req1.setHeader('Authorization','Bearer '+TokenAcceso);
                    req1.setMethod('GET');
                    req1.setEndpoint(endPoint);
                    HttpResponse hrespForce = new HttpResponse();
                    if(!Test.isRunningTest()){
                        hrespForce=h1.send(req1);
                    }else{
                        hrespForce.setBody('{"mensaje": "Encontrado","cls_Info": {"infosiniestro": [{"tipo_perdida": "Pérdida Parcial","numero_siniestro": "398336792","numero_denuncio": "187006","liquidador_asignado": "SOTO VELASQUEZ, JOSE GERMAN","fecha_ocurrenci_denuncio": "8/11/2018","fecha_de_denuncio": "2018-11-12","estado": "Rechazado","des_evento_siniestro": "Sin relato","declaracion_involucrados": null,"causal": "Actos maliciosos"}]}}');
                        hrespForce.setStatusCode(200);
                    }
                    system.debug('respuesta force->'+hrespForce);
                    String respuestaForce = hrespForce.getBody();
                    system.debug('body respuesta force->'+respuestaForce);
                    CONS_Respuestasiniestro_JSON RespSin=(CONS_Respuestasiniestro_JSON) JSON.deserialize(respuestaForce,CONS_Respuestasiniestro_JSON.class);
                    listaSiniestros  =new list<DetalleInfoSiniestro>();
                    for(integer i=0;i<RespSin.cls_Info.infosiniestro.size();i++){
                        CONS_Siniestros_PdC_Controller.DetalleInfoSiniestro  d=new CONS_Siniestros_PdC_Controller.DetalleInfoSiniestro();
                        d.tipo_perdida=RespSin.cls_Info.infosiniestro.get(i).tipo_perdida; 
                        d.numero_siniestro=RespSin.cls_Info.infosiniestro.get(i).numero_siniestro; 
                        d.numero_denuncio=RespSin.cls_Info.infosiniestro.get(i).numero_denuncio; 
                        d.liquidador_asignado=RespSin.cls_Info.infosiniestro.get(i).liquidador_asignado; 
                        d.fecha_ocurrenci_denuncio=RespSin.cls_Info.infosiniestro.get(i).fecha_ocurrenci_denuncio; 
                        d.fecha_de_denuncio=RespSin.cls_Info.infosiniestro.get(i).fecha_de_denuncio; 
                        d.estado=RespSin.cls_Info.infosiniestro.get(i).estado; 
                        d.des_evento_siniestro=RespSin.cls_Info.infosiniestro.get(i).des_evento_siniestro; 
                        d.declaracion_involucrados=RespSin.cls_Info.infosiniestro.get(i).declaracion_involucrados; 
                        d.causal=RespSin.cls_Info.infosiniestro.get(i).causal;
                        listaSiniestros.add(d);
                        
                    }
                    System.debug('mensaje->'+mensajeForce);
                }
            }
        }
    }

    
    public string obtieneAcceso(){
        
        AccesoSiniestros__mdt acceso;
        acceso = [SELECT MasterLabel, cKey__c, contrasena__c, cSecret__c, UsuarioSf__c,Instancia__c,EndPoint__c FROM AccesoSiniestros__mdt WHERE MasterLabel = 'SiniestrosForce'];
        system.debug('acceso->'+acceso);
        instancia = acceso.Instancia__c;
        
        string ckey = acceso.cKey__c;
        string csecret = acceso.cSecret__c;
        string usuario = acceso.UsuarioSf__c;
        string passwd = acceso.contrasena__c;
        string ep = acceso.EndPoint__c;
        
        
        string reqBody='grant_type=password&client_id='+ckey+'&client_secret='+csecret+'&username='+usuario+'&password='+passwd;
        
        Http h=new Http();
        HttpRequest req=new HttpRequest();
        req.setBody(reqBody);
        req.setMethod('POST');
        req.setEndpoint(ep);
        
        HttpResponse hresp = new HttpResponse();
        if(!Test.isRunningTest()){
            hresp=h.send(req);
        }else{
            hresp.setStatusCode(200);
            hresp.setBody('{"access_token": "00D0v00000094iN!ARIAQBXTMnBrguD5eqPAnQ3sokWenAY6SAIOqSe4U8PxqaLu.63D5R4PgZVa6YOnt12W.0MeG0VJ28nn5PRlpkPa_hZQPMIs","instance_url": "https://cs66.salesforce.com","id": "https://test.salesforce.com/id/00D0v00000094iNEAQ/005i0000000ZiXbAAK","token_type": "Bearer","issued_at": "1554773040101","signature": "6LKdvi81hD/aVcC21ZrxzpeaOz5jnk0hNLqmURCDeA0="}');
        }
        system.debug('hresp'+hresp);
        
        if (hresp.getStatusCode() == 200 ) {
            
            RespuestaServicioSiniestros wResp=(RespuestaServicioSiniestros) JSON.deserialize(hresp.getBody(),RespuestaServicioSiniestros.class);
            system.debug('Instance url'+wResp.instance_url);
            system.debug('session id'+wResp.access_token);
            
            respuesta = wResp.access_token;
        }
        else{
            respuesta = 'error';
        }
        system.debug('respuesta->'+respuesta);
        
        return respuesta;
    }
    
    
    public string listar_vida_o_life(){
        string envio='{'+
            '   "tipoRegistroPoliza": "'+prod.Tipo_Registro_Nectia__c+'",'+
            '   "ramoComercial": '+prod.Ramo_Nectia__c+','+
            '   "certificado": '+prod.Numero_Certificado_Nectia__c+','+
            '   "producto": '+prod.Codigo_Plan_Nectia__c+','+
            '   "poliza": '+prod.Poliza_Nectia__c+''+
            '}';
        
        system.debug('json=='+envio);
        Cons_callOutService call=new Cons_callOutService();

        CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);
        string resp='';

        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId() limit 1];

        if(prod.Esquema_Nectia__c=='INSUDB' ){

            resp=call.callOutlistadosiniestro_vida(access_token,envio,tmpUser);

        }else if( prod.Esquema_Nectia__c=='VTCNLIFE'){

            resp=call.callOutlistadosiniestro_life(access_token,envio,tmpUser);

        }
        if(test.isRunningTest()){
            resp='{    "lista_siniestros": {        "siniestros": [{"numero_siniestro":"123445"}],        "total_siniestros": 0,        "total_pagado": 0    }}';
        }
        system.debug('res'+resp);  
        CONS_SiniestrosVida_JSON sinvid = (CONS_SiniestrosVida_JSON)JSON.deserialize(resp,CONS_SiniestrosVida_JSON.class);
        system.debug('sinvid->'+sinvid);
        lista  =new list<listado>();
        if(sinvid !=null){
        if(sinvid.lista_siniestros.siniestros.size()>0){
            
            for(integer i=0;i<sinvid.lista_siniestros.siniestros.size();i++){
                CONS_Siniestros_PdC_Controller.listado l=new CONS_Siniestros_PdC_Controller.listado();
                l.numero_siniestro = sinvid.lista_siniestros.siniestros.get(i).numero_siniestro;        
                l.numero_poliza = sinvid.lista_siniestros.siniestros.get(i).numero_poliza;        
                l.nombre_asegurado = sinvid.lista_siniestros.siniestros.get(i).nombre_asegurado;         
                l.glosa_corta_plan  = sinvid.lista_siniestros.siniestros.get(i).glosa_corta_plan;       
                l.glosa_plan = sinvid.lista_siniestros.siniestros.get(i).glosa_plan;       
                l.glosa_situacion = sinvid.lista_siniestros.siniestros.get(i).glosa_situacion;      
                l.total_pagado = sinvid.lista_siniestros.siniestros.get(i).total_pagado;        
                l.no_reportado = sinvid.lista_siniestros.siniestros.get(i).no_reportado;    
                lista.add(l);
            }
        }
        }
        return null;
    }
    public class listado {
        public integer numero_siniestro{get;set;}         
        public integer numero_poliza{get;set;}         
        public string nombre_asegurado{get;set;}          
        public string glosa_corta_plan{get;set;}        
        public string glosa_plan{get;set;}        
        public string glosa_situacion{get;set;}       
        public integer total_pagado{get;set;}         
        public integer no_reportado{get;set;}  
        public listado(){}
        
    }
    
    public class RespuestaServicioSiniestros{
        public String signature;
        public String issued_at;
        public String token_type;
        public String id;
        public String instance_url;
        public String access_token;
    }
    
    public class DetalleInfoSiniestro {
        public String tipo_perdida{get;set;}
        public String numero_siniestro{get;set;}
        public String numero_denuncio{get;set;}
        public String liquidador_asignado{get;set;}
        public String fecha_ocurrenci_denuncio{get;set;}
        public String fecha_de_denuncio{get;set;}
        public String estado{get;set;}
        public String des_evento_siniestro{get;set;}
        public String declaracion_involucrados{get;set;}
        public String causal{get;set;}
        public DetalleInfoSiniestro(){}
    }

    public void updateUser(){
        if (esquemavida){
            system.debug(tmpUser.AccessToken_Nectia__c);
            update tmpUser;
        }
    }
    
}