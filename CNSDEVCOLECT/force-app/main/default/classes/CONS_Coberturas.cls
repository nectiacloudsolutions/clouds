public class CONS_Coberturas {
    public Producto_del_Cliente__c  prod{get;set;}
    public list<listado>  lista {get;set;}
    public list<listadogenerales>  listag {get;set;}
    public User tmpUser{get;set;}
    
    public boolean  esquemavida {get;set;}
    public boolean  esquemagenerales {get;set;}
    public CONS_Coberturas(ApexPages.StandardController  controller) {
        Producto_del_Cliente__c prod1 = (Producto_del_Cliente__c) controller.getRecord(); 
        prod=[select Poliza_Nectia__c,Tipo_Registro_Nectia__c,Ramo_Nectia__c,Codigo_Plan_Nectia__c,Numero_Certificado_Nectia__c,Esquema_Nectia__c from Producto_del_Cliente__c where id=:prod1.id];
        lista  =new list<listado>();
        system.debug('prod.Esquema_Nectia__c'+prod.Esquema_Nectia__c);
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
'	"ramoComercial": 6,'+
'	"certificado": 0,'+
'	"producto": 13,'+
'	"poliza": 181248'+
'}';*/
        system.debug('json=='+envio);
        Cons_callOutService call=new Cons_callOutService();
        /*  string token=call.callOuttoken();
system.debug('token'+token);
CONS_token_JSON tok;
if(!test.isRunningTest()){
tok = (CONS_token_JSON)JSON.deserialize(token,CONS_token_JSON.class); 
system.debug('token=='+tok.access_token);
}*/
        CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);

        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];
        
        string resp='';
        if(prod.Esquema_Nectia__c=='INSUDB' && !test.isRunningTest()){

            resp=call.callOutCoberturas_Vida(access_token,envio, tmpUser);
            
        }else if( prod.Esquema_Nectia__c=='VTCNLIFE' && !test.isRunningTest()){

            resp=call.callOutCoberturas_life(access_token,envio, tmpUser);
            
        }
        if(test.isRunningTest()){
            resp='{"lista_coberturas": { "coberturas": [{"codigo_cobertura": 6,"glosa_cobertura": "Fallecimiento","condicionado": "Cond.Gen.","total_prima": "40,25", "prima_proyectada": "2563,6835", "prima_bruta": "2563,6835", "porcentaje_tasa_recargos": 0,"valor_tasa_recargos": 0, "tasa_ajuste": 0, "tasa_descuento": 0, "tasa_recargo": 0,"tasa_tarifa": 0, "aplica_factor_pago": "S", "factor_pago": ",26", "impuesto": 0,"capital_asegurado": 63694,"prima_forma_pago": "666,55771", "tipo_prima": "Prima Bruta" }] }}';
        }
        system.debug('res'+resp);
        CONS_CoberturasVida_JSON cobvid = new CONS_CoberturasVida_JSON();
            cobvid = (CONS_CoberturasVida_JSON)JSON.deserialize(resp,CONS_CoberturasVida_JSON.class);
         
        system.debug('cobvid'+cobvid);
        lista  =new list<listado>();
        if(cobvid.lista_coberturas.coberturas.size()>0){
            system.debug('entro al if');
            for(integer i=0;i<cobvid.lista_coberturas.coberturas.size();i++){
                CONS_Coberturas.listado l=new CONS_Coberturas.listado();
                l.codigo_cobertura=cobvid.lista_coberturas.coberturas.get(i).codigo_cobertura;
                l.glosa_cobertura=cobvid.lista_coberturas.coberturas.get(i).glosa_cobertura;
                l.condicionado=cobvid.lista_coberturas.coberturas.get(i).condicionado;
                l.total_prima=cobvid.lista_coberturas.coberturas.get(i).total_prima;
                l.prima_proyectada=cobvid.lista_coberturas.coberturas.get(i).prima_proyectada;
                l.prima_bruta=cobvid.lista_coberturas.coberturas.get(i).prima_bruta;
                l.porcentaje_tasa_recargos=cobvid.lista_coberturas.coberturas.get(i).porcentaje_tasa_recargos;
                l.valor_tasa_recargos=cobvid.lista_coberturas.coberturas.get(i).valor_tasa_recargos;
                l.tasa_ajuste=cobvid.lista_coberturas.coberturas.get(i).tasa_ajuste;
                l.tasa_descuento=cobvid.lista_coberturas.coberturas.get(i).tasa_descuento;
                l.tasa_recargo=cobvid.lista_coberturas.coberturas.get(i).tasa_recargo;
                l.tasa_tarifa=cobvid.lista_coberturas.coberturas.get(i).tasa_tarifa;
                l.aplica_factor_pago=cobvid.lista_coberturas.coberturas.get(i).aplica_factor_pago;
                l.factor_pago=cobvid.lista_coberturas.coberturas.get(i).factor_pago;
                l.impuesto=cobvid.lista_coberturas.coberturas.get(i).impuesto;
                l.capital_asegurado=cobvid.lista_coberturas.coberturas.get(i).capital_asegurado;
                l.prima_forma_pago=cobvid.lista_coberturas.coberturas.get(i).prima_forma_pago;
                
                
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
'	"ramoComercial": 6,'+
'	"certificado": 0,'+
'	"producto": 13,'+
'	"poliza": 181248'+
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
        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];
        
        string resp=call.callOutCoberturas_generales(access_token,envio, tmpUser);
        
         if(test.isRunningTest()){
            resp='{"lista_coberturas": { "coberturas": [{"codigo_cobertura": 6,"glosa_cobertura": "Fallecimiento","condicionado": "Cond.Gen.","total_prima": "40,25", "prima_proyectada": "2563,6835", "prima_bruta": "2563,6835", "porcentaje_tasa_recargos": 0,"valor_tasa_recargos": 0, "tasa_ajuste": 0, "tasa_descuento": 0, "tasa_recargo": 0,"tasa_tarifa": 0, "aplica_factor_pago": "S", "factor_pago": ",26", "impuesto": 0,"capital_asegurado": 63694,"prima_forma_pago": "666,55771", "tipo_prima": "Prima Bruta" }] }}';
        }
        system.debug('res'+resp);
        CONS_CoberturasGenerales_JSON cobgen = (CONS_CoberturasGenerales_JSON)JSON.deserialize(resp,CONS_CoberturasGenerales_JSON.class);
        system.debug('cobgen'+cobgen);
        listag  =new list<listadogenerales>();
        if(cobgen.lista_coberturas.coberturas.size()>0){
            system.debug('entro al if');
            for(integer i=0;i<cobgen.lista_coberturas.coberturas.size();i++){
                CONS_Coberturas.listadogenerales l=new CONS_Coberturas.listadogenerales();
                l.glosa_cobertura=cobgen.lista_coberturas.coberturas.get(i).glosa_cobertura;
                l.capital_asegurado=cobgen.lista_coberturas.coberturas.get(i).capital_asegurado;
                l.deducible_uf=cobgen.lista_coberturas.coberturas.get(i).deducible_uf;
                l.deducible_pje=cobgen.lista_coberturas.coberturas.get(i).deducible_pje;
                l.tasa_fija=cobgen.lista_coberturas.coberturas.get(i).tasa_fija;
                l.tasa_variable=cobgen.lista_coberturas.coberturas.get(i).tasa_variable;
                l.descuento=cobgen.lista_coberturas.coberturas.get(i).descuento;
                l.prima_neta=cobgen.lista_coberturas.coberturas.get(i).prima_neta;
                listag.add(l);
            }
        }
        //updateUser(tmpUser);
        return null;
    }
    
    public void updateUser(){
    	system.debug(tmpUser.AccessToken_Nectia__c);
    	update tmpUser;
    }
    
    public class listado {
        public Integer codigo_cobertura{get;set;}
        public String glosa_cobertura{get;set;}
        public String condicionado{get;set;}
        public String total_prima{get;set;}
        public String prima_proyectada{get;set;}
        public String prima_bruta{get;set;}
        public String porcentaje_tasa_recargos{get;set;}
        public String valor_tasa_recargos{get;set;}
        public String tasa_ajuste{get;set;}
        public String tasa_descuento{get;set;}
        public String tasa_recargo{get;set;}
        public String tasa_tarifa{get;set;}
        public String aplica_factor_pago{get;set;}
        public String factor_pago{get;set;}
        public String impuesto{get;set;}
        public String capital_asegurado{get;set;}
        public String prima_forma_pago{get;set;}
        public listado(){}
    }
    public class listadogenerales {
        public String glosa_cobertura{get;set;}
        public String capital_asegurado{get;set;}
        public String deducible_uf{get;set;}
        public String deducible_pje{get;set;}
        public String tasa_fija{get;set;}
        public String tasa_variable{get;set;}
        public String descuento{get;set;}
        public String prima_neta{get;set;}
        public listadogenerales(){}
    }
}