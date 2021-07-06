@isTest
public class CONS_ProductoClientetest {
    static testMethod void Test1() {
        account  acc=new account();
        acc.Name='test';
        acc.rut__c='1233424';
        insert acc;
        Contact con=new Contact();
        con.LastName='test';
        con.AccountId=acc.id;
        con.Email='test@test.cl';
        insert con;
        Producto_del_Cliente__c  pro = new Producto_del_Cliente__c();
        pro.Cliente_Nectia__c=acc.id;
        pro.Name='test';
        pro.Poliza_Nectia__c='1234789';
        pro.Tipo_Registro_Nectia__c='2';
        pro.Ramo_Nectia__c='1';
        pro.Codigo_Plan_Nectia__c='330';
        pro.Numero_Certificado_Nectia__c='1';
        insert pro;
        ApexPages.StandardController  apsc=new ApexPages.StandardController(pro);
        CONS_ProductoCliente cpro=new CONS_ProductoCliente(apsc);
    }
     static testMethod void Test2() {
        string  resp = '{'+
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
         CONS_Detalleproducto_JSON.parse(resp);
    }
}