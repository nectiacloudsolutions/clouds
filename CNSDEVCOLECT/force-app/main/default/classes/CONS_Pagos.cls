public class CONS_Pagos {
    public Producto_del_Cliente__c  prod{get;set;}
    public list<listado>  lista {get;set;}
    public list<listadogenerales>  listagenerales {get;set;}
    public User tmpUser{get;set;}
        
    public boolean  esquemavida {get;set;}
    public boolean  esquemagenerales {get;set;}
    public CONS_Pagos(ApexPages.StandardController  controller) {
        Producto_del_Cliente__c prod1 = (Producto_del_Cliente__c) controller.getRecord(); 
        prod=[select Poliza_Nectia__c,Tipo_Registro_Nectia__c,Ramo_Nectia__c,Codigo_Plan_Nectia__c,Numero_Certificado_Nectia__c,Esquema_Nectia__c from Producto_del_Cliente__c where id=:prod1.id];
        lista  =new list<listado>();
        listagenerales  =new list<listadogenerales>();
        if(prod.Esquema_Nectia__c!=null){
            if(prod.Esquema_Nectia__c=='INSUDB' || prod.Esquema_Nectia__c=='VTCNLIFE'){
                listar_vida_o_life();
                esquemavida=true;
                esquemagenerales=false;
            }else if(prod.Esquema_Nectia__c=='CLONINSUDB'){
                listar_generales();
                esquemagenerales=true;
                esquemavida=false;
            }
        }
    }   
    public string listar_vida_o_life(){
        string envio='{'+
            '	"tipoRegistroPoliza": "'+prod.Tipo_Registro_Nectia__c+'",'+
            '	"ramoComercial": '+prod.Ramo_Nectia__c+','+
            '	"certificado": '+prod.Numero_Certificado_Nectia__c+','+
            '	"producto": '+prod.Codigo_Plan_Nectia__c+','+
            '	"poliza": '+prod.Poliza_Nectia__c+''+
            '}';
        /* string envio='{'+
'	"tipoRegistroPoliza": "2",'+
'	"ramoComercial": 1,'+
'	"certificado": 0,'+
'	"producto": 37,'+
'	"poliza": 11127'+
'}';*/
        system.debug('json=='+envio);
        Cons_callOutService call=new Cons_callOutService();
       /* string token=call.callOuttoken();
        system.debug('token'+token);
        CONS_token_JSON tok = (CONS_token_JSON)JSON.deserialize(token,CONS_token_JSON.class); 
        system.debug('token=='+tok.access_token);*/
         CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);

        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId() limit 1];

        string resp='';
        if(prod.Esquema_Nectia__c=='INSUDB' ){
            resp=call.callOutpagos_vida(access_token,envio, tmpUser);
            
        }else if( prod.Esquema_Nectia__c=='VTCNLIFE'){
            resp=call.callOutpagos_life(access_token,envio, tmpUser);
            
        }
        system.debug('res'+resp);  
            if(test.isRunningTest()){
            resp='{"lista_pagos": { "pagos": [{ "concepto": "Emisión/Altas", "periodo": "01/01/1985 - 31/12/1986", "recibo": 10002118,  "valor_cargo": 5026, "via_de_pago": "Aviso De Cobranza",   "fecha_de_abono": "01-01-1900", "pago_moneda_origen": 5026, "valor_moneda_origen": 20, "moneda_origen": "Unid de Seg. Reajustable Mens.", "monto_pagado": 100520  }], "total_pagos": 73 }}';
        }
        
        CONS_PagosVida_JSON pagvid = (CONS_PagosVida_JSON)JSON.deserialize(resp,CONS_PagosVida_JSON.class);
        system.debug('pagvid'+pagvid);
        lista  =new list<listado>();
        if(pagvid.lista_pagos.pagos.size()>0){
            system.debug('entro al if');
            for(integer i=0;i<pagvid.lista_pagos.pagos.size();i++){
                CONS_Pagos.listado l=new CONS_Pagos.listado();
                l.concepto=pagvid.lista_pagos.pagos.get(i).concepto;
                l.periodo=pagvid.lista_pagos.pagos.get(i).periodo;
                l.recibo=pagvid.lista_pagos.pagos.get(i).recibo;
                l.valor_cargo=pagvid.lista_pagos.pagos.get(i).valor_cargo;
                l.via_de_pago=pagvid.lista_pagos.pagos.get(i).via_de_pago;
                l.fecha_de_abono=pagvid.lista_pagos.pagos.get(i).fecha_de_abono;
                l.pago_moneda_origen=pagvid.lista_pagos.pagos.get(i).pago_moneda_origen;
                l.valor_moneda_origen=pagvid.lista_pagos.pagos.get(i).valor_moneda_origen;
                l.moneda_origen=pagvid.lista_pagos.pagos.get(i).moneda_origen;
                l.monto_pagado=pagvid.lista_pagos.pagos.get(i).monto_pagado;
                lista.add(l);
            }
        }
        return null;
    }
    
    public string listar_generales(){
        string envio='{'+
            '	"tipoRegistroPoliza": "'+prod.Tipo_Registro_Nectia__c+'",'+
            '	"ramoComercial": '+prod.Ramo_Nectia__c+','+
            '	"certificado": '+prod.Numero_Certificado_Nectia__c+','+
            '	"producto": '+prod.Codigo_Plan_Nectia__c+','+
            '	"poliza": '+prod.Poliza_Nectia__c+''+
            '}';
        /* string envio='{'+
'	"tipoRegistroPoliza": "2",'+
'	"ramoComercial": 1,'+
'	"certificado": 0,'+
'	"producto": 37,'+
'	"poliza": 11127'+
'}';*/
        system.debug('json=='+envio);
        Cons_callOutService call=new Cons_callOutService();
       /* string token=call.callOuttoken();
        system.debug('token'+token);
        CONS_token_JSON tok = (CONS_token_JSON)JSON.deserialize(token,CONS_token_JSON.class); 
        system.debug('token=='+tok.access_token);*/
         CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);

        tmpUser = [select id, AccessToken_Nectia__c from user where  id=: userinfo.getUserId() limit 1];

        
        string resp='';
        if(!test.isRunningTest()){
        resp=call.callOutpagos_generales(access_token,envio,tmpUser);
        system.debug('res'+resp);  
        }else{
            resp='{"lista_pagos_poliza": { "pagos_poliza": [{ "concepto": "Emisión/Altas", "periodo": "01/01/1985 - 31/12/1986", "recibo": 10002118,  "valor_cargo": 5026, "via_de_pago": "Aviso De Cobranza",   "fecha_de_abono": "01-01-1900", "pago_moneda_origen": 5026, "valor_moneda_origen": 20, "moneda_origen": "Unid de Seg. Reajustable Mens.", "monto_pagado": 100520  }], "total_pagos": 73 }}';
        }
         
        
        CONS_PagosGenerales_JSON paggen = (CONS_PagosGenerales_JSON)JSON.deserialize(resp,CONS_PagosGenerales_JSON.class);
        system.debug('paggen'+paggen);
        listagenerales  =new list<listadogenerales>();
        
        if(paggen.lista_pagos_poliza.pagos_poliza!=null){
  
            
      for(integer i=0;i<paggen.lista_pagos_poliza.pagos_poliza.size();i++){
            CONS_Pagos.listadogenerales l=new CONS_Pagos.listadogenerales();
            l.nro_cuota=paggen.lista_pagos_poliza.pagos_poliza.get(i).nro_cuota;
            l.transaccion=paggen.lista_pagos_poliza.pagos_poliza.get(i).transaccion;
            l.cuota=paggen.lista_pagos_poliza.pagos_poliza.get(i).cuota;
            l.tipo=paggen.lista_pagos_poliza.pagos_poliza.get(i).tipo;
            l.balance=paggen.lista_pagos_poliza.pagos_poliza.get(i).balance;
            l.monto_moneda_origen=paggen.lista_pagos_poliza.pagos_poliza.get(i).monto_moneda_origen;
            l.relacion=paggen.lista_pagos_poliza.pagos_poliza.get(i).relacion;
            l.boletin=paggen.lista_pagos_poliza.pagos_poliza.get(i).boletin;
            l.contrato=paggen.lista_pagos_poliza.pagos_poliza.get(i).contrato;
            l.fecha_vencimiento=paggen.lista_pagos_poliza.pagos_poliza.get(i).fecha_vencimiento;
            l.fecha_cobranza=paggen.lista_pagos_poliza.pagos_poliza.get(i).fecha_cobranza;
            l.fecha_pago=paggen.lista_pagos_poliza.pagos_poliza.get(i).fecha_pago;
            l.codigo_estado=paggen.lista_pagos_poliza.pagos_poliza.get(i).codigo_estado;
            l.glosa_estado=paggen.lista_pagos_poliza.pagos_poliza.get(i).glosa_estado;
            l.estado_contrato=paggen.lista_pagos_poliza.pagos_poliza.get(i).estado_contrato;
            l.fecha_actual=paggen.lista_pagos_poliza.pagos_poliza.get(i).fecha_actual;
            l.monto_cuota_uf=paggen.lista_pagos_poliza.pagos_poliza.get(i).monto_cuota_uf;
            l.via_de_pago=paggen.lista_pagos_poliza.pagos_poliza.get(i).via_de_pago;
            listagenerales.add(l);
        }
        }
        
        return null;
    }
    
    
    
    
    public class listado {
        public String concepto {get;set;}
        public String periodo {get;set;}
        public Integer recibo {get;set;}
        public String valor_cargo {get;set;}
        public String via_de_pago {get;set;}
        public String fecha_de_abono {get;set;}
        public String pago_moneda_origen {get;set;}
        public Integer valor_moneda_origen {get;set;}
        public String moneda_origen {get;set;}
        public String monto_pagado {get;set;}
        public listado(){}
        
    } 
    public class listadogenerales {
        public Integer nro_cuota{get;set;}
        public String transaccion{get;set;}
        public String cuota{get;set;}
        public String tipo{get;set;}
        public String balance{get;set;}
        public String monto_moneda_origen{get;set;}
        public String relacion{get;set;}
        public String boletin{get;set;}
        public String contrato{get;set;}
        public String fecha_vencimiento{get;set;}
        public String fecha_cobranza{get;set;}
        public String fecha_pago{get;set;}
        public String codigo_estado{get;set;}
        public String glosa_estado{get;set;}
        public String estado_contrato{get;set;}
        public String fecha_actual{get;set;}
        public String monto_cuota_uf{get;set;}
        public String via_de_pago{get;set;}
    }

    public void updateUser(){
    	system.debug(tmpUser.AccessToken_Nectia__c);
    	update tmpUser;
    }
}