public class CONS_ProductoCliente {
    public  CONS_Detalleproducto_JSON doclista {get;set;}
    public User tmpUser{get;set;}
    
    public  string  via_pago {get;set;}
    public Integer fecha_pago{get;set;}
    public String tipo_tarjeta{get;set;}
    public String total_prima{get;set;}
    public String banco{get;set;}
    public String expiracion_tarjeta_credito{get;set;}
    public String cuotas_pactadas{get;set;}
    
    public String nombre_contratante{get;set;}
    public String rut_contratante{get;set;}
    public String nombre_asegurado{get;set;}
    public String rut_asegurado{get;set;}
    public String nombre_pagador{get;set;}
    public String rut_pagador{get;set;}
    
    public String estado{get;set;}
    
    public String marca{get;set;}
    public String anio{get;set;}
    public String modelo{get;set;}
    public String patente{get;set;}
    public String direccion_riesgo{get;set;}
    
    public String nombre_intermediario{get;set;}
    public String rut_intermediario{get;set;}
    public String agencia{get;set;}
    public String sucursal{get;set;}
    public String regional{get;set;}
    public String canal{get;set;}
    public String telefono{get;set;}
    public String es_corredor{get;set;}
    
    public String emision{get;set;}
    public String desde{get;set;}
    public String hasta{get;set;}
    public String fecha_anulacion{get;set;}
    public String motivo_cancelacion{get;set;}
    
    
    public Producto_del_Cliente__c  prod{get;set;}
    
    public CONS_ProductoCliente(ApexPages.StandardController controller) {
        Producto_del_Cliente__c prod1 = (Producto_del_Cliente__c) controller.getRecord(); 
        prod=[select Poliza_Nectia__c,Tipo_Registro_Nectia__c,Ramo_Nectia__c,Codigo_Plan_Nectia__c,Numero_Certificado_Nectia__c from Producto_del_Cliente__c where id=:prod1.id];
        listar();
    }
    public string listar(){
        string envio='{'+
            '	"tipoRegistroPoliza": "'+prod.Tipo_Registro_Nectia__c+'",'+
            '	"ramoComercial": '+prod.Ramo_Nectia__c+','+
            '	"certificado": '+prod.Numero_Certificado_Nectia__c+','+
            '	"producto": '+prod.Codigo_Plan_Nectia__c+','+
            '	"poliza": '+prod.Poliza_Nectia__c+''+
            '}';
        system.debug('json=='+envio);
        
        Cons_callOutService call=new Cons_callOutService();
        /*string token=call.callOuttoken();
system.debug('token'+token);
CONS_token_JSON tok;

if(!test.isRunningTest()){
tok = (CONS_token_JSON)JSON.deserialize(token,CONS_token_JSON.class); 
system.debug('token=='+tok.access_token);
} */
        tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];
        System.debug('tmpUser->'+tmpUser);

        CONS_estructuratoken est=new  CONS_estructuratoken();
        string access_token=est.token();
        system.debug('token=='+access_token);

        string resp;
        resp=call.callOutdetalle_producto(access_token,envio, tmpUser);
        
        system.debug('res'+resp);
        
        if(test.isRunningTest()){
            resp = '{'+
                '    "detalle_producto": {'+
                '        "cliente": {'+
                '            "nombre_contratante": "-",'+
                '            "rut_contratante": "-",'+
                '            "familia": null,'+
                '            "modulo": null,'+
                '            "linea": null,'+
                '            "nro_producto": 350095,'+
                '            "estado": "Terminada Fin Cobertura"'+
                '        },'+
                '        "vigencia": {'+
                '            "emision": "1997-04-17",'+
                '            "desde": "2010-01-01",'+
                '            "hasta": "2010-12-31",'+
                '            "fecha_anulacion": null,'+
                '            "motivo_cancelacion": "-"'+
                '        },'+
                '        "materia_asegurada": {'+
                '            "marca": "-",'+
                '            "anio": null,'+
                '            "modelo": "-",'+
                '            "patente": "-",'+
                '            "direccion_riesgo": "-"'+
                '        },'+
                '        "recaudacion": {'+
                '            "via_pago": "Aviso de cobranza",'+
                '            "fecha_pago": 17,'+
                '            "tipo_tarjeta": null,'+
                '            "total_prima": "104,970168",'+
                '            "banco": null,'+
                '            "expiracion_tarjeta_credito": null,'+
                '            "cuotas_pactadas": null'+
                '        },'+
                '        "roles": {'+
                '           "nombre_contratante": "-",'+
                '            "rut_contratante": "-",'+
                '            "nombre_asegurado": "61108000-K",'+
                '            "rut_asegurado": "Caja De Prevision De La Defensa Nacional",'+
                '            "nombre_pagador": "-",'+
                '            "rut_pagador": "-"'+
                '        },'+
                '        "intermediario": {'+
                '            "nombre_intermediario": "Exit Chile Corredores De Seguros Limitada",'+
                '            "rut_intermediario": "78427200-1",'+
                '            "agencia": "Broker Colectivo Stgo. Virtual",'+
                '            "sucursal": "Santiago (El Bosque)",'+
                '            "regional": "Regional 13 Santiago",'+
                '            "canal": null,'+
                '            "telefono": null,'+
                '            "es_corredor": null'+
                '        }'+
                '    }'+
                '}';  
        }
        if(resp==null){
            return 'Error';
        }else{
        doclista = (CONS_Detalleproducto_JSON)JSON.deserialize(resp,CONS_Detalleproducto_JSON.class); 
        system.debug('doclista'+doclista);
        if(doclista !=null){
        via_pago=doclista.Detalle_producto.recaudacion.via_pago;
        fecha_pago=doclista.Detalle_producto.recaudacion.fecha_pago;
        tipo_tarjeta=doclista.Detalle_producto.recaudacion.tipo_tarjeta;
        total_prima=doclista.Detalle_producto.recaudacion.total_prima;
        banco=doclista.Detalle_producto.recaudacion.banco;
        expiracion_tarjeta_credito=doclista.Detalle_producto.recaudacion.expiracion_tarjeta_credito;
        cuotas_pactadas=doclista.Detalle_producto.recaudacion.cuotas_pactadas;
        
        nombre_contratante=doclista.Detalle_producto.roles.nombre_contratante;
        rut_contratante=doclista.Detalle_producto.roles.rut_contratante;
        nombre_asegurado=doclista.Detalle_producto.roles.nombre_asegurado;
        rut_asegurado=doclista.Detalle_producto.roles.rut_asegurado;
        nombre_pagador=doclista.Detalle_producto.roles.nombre_pagador;
        rut_pagador=doclista.Detalle_producto.roles.rut_pagador;
        
        nombre_intermediario=doclista.Detalle_producto.intermediario.nombre_intermediario;
        rut_intermediario=doclista.Detalle_producto.intermediario.rut_intermediario;
        agencia=doclista.Detalle_producto.intermediario.agencia;
        sucursal=doclista.Detalle_producto.intermediario.sucursal;
        regional=doclista.Detalle_producto.intermediario.regional;
        canal=doclista.Detalle_producto.intermediario.canal;
        telefono=doclista.Detalle_producto.intermediario.telefono;
        es_corredor=doclista.Detalle_producto.intermediario.es_corredor;
        
        estado=doclista.detalle_producto.cliente.estado;
        
        marca=doclista.detalle_producto.materia_asegurada.marca;
        anio=doclista.detalle_producto.materia_asegurada.anio;
        modelo=doclista.detalle_producto.materia_asegurada.modelo;
        patente=doclista.detalle_producto.materia_asegurada.patente;
        direccion_riesgo=doclista.detalle_producto.materia_asegurada.direccion_riesgo;
        
        
        emision=doclista.detalle_producto.vigencia.emision;
        desde=doclista.detalle_producto.vigencia.desde;
        hasta=doclista.detalle_producto.vigencia.hasta;
        fecha_anulacion=doclista.detalle_producto.vigencia.fecha_anulacion;
        motivo_cancelacion=doclista.detalle_producto.vigencia.motivo_cancelacion;
        }
            return null;}
    }
    public void updateUser(){
    	system.debug(tmpUser.AccessToken_Nectia__c);
    	update tmpUser;
    }
}