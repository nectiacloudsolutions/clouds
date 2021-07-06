@isTest
public class CONS_JsonClassesTest {
	static testMethod void TestCoberturasGralesJson() {
		CONS_CoberturasGenerales_JSON estructuraJson = new CONS_CoberturasGenerales_JSON();
        CONS_CoberturasGenerales_JSON.Coberturas tst = new CONS_CoberturasGenerales_JSON.Coberturas();
        List<CONS_CoberturasGenerales_JSON.Coberturas> listaCoberturas = new List<CONS_CoberturasGenerales_JSON.Coberturas>();
        string arregloJson = 
            '{"codigo_cobertura": 1234567,"glosa_cobertura": "abc123","condicionado": "test","total_prima": "test","prima_proyectada": "test","prima_bruta": "test","porcentaje_tasa_recargos": "test","valor_tasa_recargos": "test","tasa_ajuste": "test","tasa_descuento": "test","tasa_recargo": "test","tasa_tarifa": "test","aplica_factor_pago": "test","factor_pago" : "test","impuesto":"test"}';
        
        estructuraJson = CONS_CoberturasGenerales_JSON.parse(arregloJson);
        
    }
    static testMethod void TestCoberturasVidaJson() {
		CONS_CoberturasVida_JSON estructuraJson = new CONS_CoberturasVida_JSON();
        CONS_CoberturasVida_JSON.Coberturas tst = new CONS_CoberturasVida_JSON.Coberturas();
        List<CONS_CoberturasVida_JSON.Coberturas> listaCoberturas = new List<CONS_CoberturasVida_JSON.Coberturas>();
        string arregloJson = 
            '{"codigo_cobertura": 1234567,"glosa_cobertura": "abc123","condicionado": "test","total_prima": "test","prima_proyectada": "test","prima_bruta": "test","porcentaje_tasa_recargos": "test","valor_tasa_recargos": "test","tasa_ajuste": "test","tasa_descuento": "test","tasa_recargo": "test","tasa_tarifa": "test","aplica_factor_pago": "test","factor_pago" : "test","impuesto":"test"}';
        
        estructuraJson = CONS_CoberturasVida_JSON.parse(arregloJson);
        
    }
    static testMethod void TestPagosGralesJson() {
		CONS_PagosGenerales_JSON estructuraJson = new CONS_PagosGenerales_JSON();
        string arregloJson = 
            '{"Pagos_poliza": {"nro_cuota": 1234567,"transaccion": "CELA","cuota": "CELA","tipo": "CELA","balance": "CELA","monto_moneda_origen": "CELA","relacion": "CELA","boletin": "CELA","contrato": "CELA","fecha_vencimiento": "CELA","fecha_cobranza": "CELA","fecha_pago": "CELA","codigo_estado": "CELA","glosa_estado": "CELA","estado_contrato": "CELA","fecha_actual": "CELA" ,"monto_cuota_uf": "CELA" ,"via_de_pago": "CELA" },"Recibos":{"recibo": 3558818,"glosa_movimiento": "3161783","fecha_inicio_vigencia": "test","fecha_limite_pago": "SEGUROAUTO","monto_cargo": "test","monto_abonado": "test","saldo": 29}}';
        estructuraJson = CONS_PagosGenerales_JSON.parse(arregloJson);
        
    }
    static testMethod void TestPagosVidaJson() {
		CONS_PagosVida_JSON estructuraJson = new CONS_PagosVida_JSON();
        string arregloJson = 
            '{"concepto": "1234567","periodo": "abc123","recibo": 2345,"valor_cargo": "test","via_de_pago": "test","fecha_de_abono": "test","pago_moneda_origen": "test","valor_moneda_origen": 12344,"moneda_origen": "test","monto_pagado": "test"}';
        
        estructuraJson = CONS_PagosVida_JSON.parse(arregloJson);
        
    }
    static testMethod void TestTerminoPolizaJson() {
		CONS_terminopoliza_JSON estructuraJson = new CONS_terminopoliza_JSON();
        string arregloJson = 
            '{"nBranch": 1234567,"nProduct": 1111,"nPolicy": 111,"nCertif": 111,"dPolicyNullDate": "test","nNullCode": 222,"nUserCode": 222,"nCase": 11,"sCaseName": "test","sClientName": "test","sTemplate": "test","nBusinessNumber": 22,"sClientCellphone": 11,"dRecceptionDate" : "test","sClientEmail":"test"}';
        
        estructuraJson = CONS_terminopoliza_JSON.parse(arregloJson);
        
    }
    static testMethod void TestRehabPolizaJson() {
		CONS_Rehabilitacionpoliza_JSON estructuraJson = new CONS_Rehabilitacionpoliza_JSON();
        string arregloJson = 
            '{"nBranch": 1234567,"nProduct": 1111,"nPolicy": 111,"nCertif": 111,"dPolicyNullDate": "test","dEffecDate": "222","nUserCode": 222,"nCase": 11,"sCaseName": "test","sClientName": "test","sTemplate": "test","nBusinessNumber": 22,"sClientCellphone": 11,"dRecceptionDate" : "test","sClientEmail":"test"}';
        
        estructuraJson = CONS_Rehabilitacionpoliza_JSON.parse(arregloJson);
        
    }
/*    static testMethod void TestRespViaPagoJson() {
		CONS_respuestaviadepago_JSON estructuraJson = new CONS_respuestaviadepago_JSON();
        string arregloJson = 
            '{"codigo": "1234567","mensaje": "abc123","nPropuesta": "2345"}';
        
        estructuraJson = CONS_respuestaviadepago_JSON.parse(arregloJson);
        
    }*/
    static testMethod void TestRespSiniestroJson() {
		CONS_Respuestasiniestro_JSON estructuraJson = new CONS_Respuestasiniestro_JSON();
        string arregloJson = 
            '{"tipo_perdida": "1234567","numero_siniestro": "abc123","numero_denuncio": "2345","liquidador_asignado": "2345","fecha_ocurrenci_denuncio": "2345","fecha_de_denuncio": "2345","estado": "2345","des_evento_siniestro": "2345","declaracion_involucrados": "2345","causal": "2345"}';
        
        estructuraJson = CONS_Respuestasiniestro_JSON.parse(arregloJson);
        
    }
    static testMethod void TestEnvioViaPagoJson() {
		CONS_EnvioViaPago_JSON estructuraJson = new CONS_EnvioViaPago_JSON();
        string arregloJson = 
            '{"nBranch": 1234567,"nProduct": 1111,"nPolicy": 111,"deffecDate": "111","nWayPay": 11,"nBillDay": 22,"sBanKauth": "222","nBank": 11,"nTypAccPac": 11,"sAccountPac": "test","nCodAgree": 11,"nUserCode": 22,"sClient": "11","sDigit" : "test","sFirstName":"test","sLastName":"test","sLastName2":"test","dBirthDat":"test","nSexo":1,"sRecType":11,"nProvince":11,"nLocal":11,"nMunicipality":11,"sStreet":"test","sInfor":null,"sBuild":"test","nFloor":11,"nDepartment":11,"nPolpulation":11,"nZipCode":11,"nCountry":11,"sEmail":"test","nOrder":11,"nPhoneType":11,"nAreaCode":11,"sPhone":"test","nPersonTyp":11,"nNationality":11,"sCaseName":"test","sClientName":"test","sTemplate":"test","nBusinessNumber":11,"nCase":11,"sClientCellphone":1111,"dRecceptionDate":"test","nTypCreCard":11,"sCrediCardVal":"test","dCardExpir":"test","sClientEmail":"test","lineadenegocio":"test"}';        
        estructuraJson = CONS_EnvioViaPago_JSON.parse(arregloJson);
        
    }
    static testMethod void TestEstrLiquidacionJson() {
		CONS_estructuraliquidacion_JSON estructuraJson = new CONS_estructuraliquidacion_JSON();
        string arregloJson = 
            '{"archivo": "1234567","nombreArchivo": "abc123"}';      
        estructuraJson = CONS_estructuraliquidacion_JSON.parse(arregloJson);
        
    }
    static testMethod void TestEstrLiqPeriodoJson() {
		CONS_estructuraliquidacionperiodo_JSON estructuraJson = new CONS_estructuraliquidacionperiodo_JSON();
        string arregloJson = 
            '{"numLiquidacion": "1234567","periodoPago": "abc123"}';     
        estructuraJson = CONS_estructuraliquidacionperiodo_JSON.parse(arregloJson);
        
    }
    static testMethod void TestRespCertCargaJson() {
		CONS_RespuestaCertificadocargasl_JSON estructuraJson = new CONS_RespuestaCertificadocargasl_JSON();
        string arregloJson = 
            '{"archivo": "1234567","nombreArchivo": "abc123"}';       
        estructuraJson = CONS_RespuestaCertificadocargasl_JSON.parse(arregloJson);
        
    }
    static testMethod void TestRespCertCoberJson() {
		CONS_RespuestaCertificadoCobertura_JSON estructuraJson = new CONS_RespuestaCertificadoCobertura_JSON();
        string arregloJson = 
            '{"archivo": "1234567","nombreArchivo": "abc123"}';       
        estructuraJson = CONS_RespuestaCertificadoCobertura_JSON.parse(arregloJson);
        
    }
    static testMethod void TestRespCertPagosJson() {
		CONS_RespuestaCertificadoPagos_JSON estructuraJson = new CONS_RespuestaCertificadoPagos_JSON();
        string arregloJson = 
            '{"archivo": "1234567","nombreArchivo": "abc123"}';       
        estructuraJson = CONS_RespuestaCertificadoPagos_JSON.parse(arregloJson);
        
    }
    static testMethod void TestRespCertVigenJson() {
		CONS_RespuestaCertificadoVigencia_JSON estructuraJson = new CONS_RespuestaCertificadoVigencia_JSON();
        string arregloJson = 
            '{"archivo": "1234567","nombreArchivo": "abc123"}';       
        estructuraJson = CONS_RespuestaCertificadoVigencia_JSON.parse(arregloJson);
        
    }
    static testMethod void TestRespCopPolizaJson() {
		CONS_Respuestacopiapoliza_JSON estructuraJson = new CONS_Respuestacopiapoliza_JSON();
        string arregloJson = 
            '{"archivo": "1234567","nombreArchivo": "abc123"}';       
        estructuraJson = CONS_Respuestacopiapoliza_JSON.parse(arregloJson);
        
    }
    static testMethod void TestDocVisualizarJson() {
		CONS_documentovisualizar_JSON estructuraJson = new CONS_documentovisualizar_JSON();
        string arregloJson = 
            '{"codigo": "1234567","mensaje": "abc123","mensajeServicio": "abc123","codigoServicio": "abc123"}';       
        estructuraJson = CONS_documentovisualizar_JSON.parse(arregloJson);
        
    }
    static testMethod void TestDocuObtenerJson() {
		CONS_docuwareobtener_JSON estructuraJson = new CONS_docuwareobtener_JSON();
        string arregloJson = 
            '{"codigo": "1234567","mensaje": "abc123","mensajeServicio": "abc123","codigoServicio": "abc123"}';       
        estructuraJson = CONS_docuwareobtener_JSON.parse(arregloJson);
        
    }
    static testMethod void TestRespCopPolizaVidaJson() {
		CONS_Respuestacopiapolizavida_JSON estructuraJson = new CONS_Respuestacopiapolizavida_JSON();
        string arregloJson = 
            '{"codigo": "1234567","mensaje": "abc123","mensajeEx": "abc123"}';       
        estructuraJson = CONS_Respuestacopiapolizavida_JSON.parse(arregloJson);
        
    }
    static testMethod void TestRespCopiaSOAPJson() {
		CONS_RespuestaCopiaSOAP_JSON estructuraJson = new CONS_RespuestaCopiaSOAP_JSON();
        string arregloJson = 
            '{"codigoError": "1234567","mensajeError": "abc123"}';       
        estructuraJson = CONS_RespuestaCopiaSOAP_JSON.parse(arregloJson);
        
    }
    static testMethod void TestRespEndosoJson() {
		Cons_respuestaendoso_JSON estructuraJson = new Cons_respuestaendoso_JSON();
        string arregloJson = 
            '{"codError": "1234567","descripcion": "abc123","descripcionUsuario": "abc123","nombreArchivo": "abc123","documento": "abc123","envioEmailCliente": 1}';       
        estructuraJson = Cons_respuestaendoso_JSON.parse(arregloJson);
        
    }
    static testMethod void TestRespCopiaPolizaRVJson() {
		CONS_RespuestaCopiaPolizaRV_JSON estructuraJson = new CONS_RespuestaCopiaPolizaRV_JSON();
        string arregloJson = 
            '{"codigo_error": "1234567","mensaje_estado": "abc123","descripcion_usuario": "abc123","documento": "abc123","nombre_archivo": "1"}';       
        estructuraJson = CONS_RespuestaCopiaPolizaRV_JSON.parse(arregloJson);
        
    }
    static testMethod void TestRespRehabPolizaJson() {
		CONS_RespuestaRehabilitacionpoliza_JSON estructuraJson = new CONS_RespuestaRehabilitacionpoliza_JSON();
        string arregloJson = 
            '{"httpCode": "1234567","httpMessage": "abc123","moreInformation": "abc123"}';       
        estructuraJson = CONS_RespuestaRehabilitacionpoliza_JSON.parse(arregloJson);
        
    }
    static testMethod void TestRespTermPolizaJson() {
		CONS_RespuestaTerminoPoliza_JSON estructuraJson = new CONS_RespuestaTerminoPoliza_JSON();
        string arregloJson = 
            '{"codigo": "1234567","mensaje": "abc123", "RespuestaBase":{"codigo": "1234567","mensaje": "abc123","nPropuesta": "abc123"}}';       
        estructuraJson = CONS_RespuestaTerminoPoliza_JSON.parse(arregloJson);
        
    }
    static testMethod void TestSiniestrosVidaJson() {
		CONS_SiniestrosVida_JSON estructuraJson = new CONS_SiniestrosVida_JSON();
        string arregloJson = 
            '{"total_siniestros": 1234567,"total_pagado": 123, "Siniestros":{"numero_siniestro": 1234567,"numero_poliza": 123,"nombre_asegurado": "abc123","glosa_corta_plan": "abc123","glosa_plan": "abc123","glosa_situacion": "abc123","total_pagado": 123,"no_reportado": 123}}';       
        estructuraJson = CONS_SiniestrosVida_JSON.parse(arregloJson);
        
    }
    static testMethod void TestTokenJson() {
		CONS_token_JSON estructuraJson = new CONS_token_JSON();
        string arregloJson = 
            '{"access_token": "1234567","expires_in": 123,"refresh_expires_in": 123,"refresh_token": "abc123","token_type": "1","id_token": "1","policy": 1,"session_state": "1"}';       
        estructuraJson = CONS_token_JSON.parse(arregloJson);
        
    }

    static testMethod void TestRespuestaServicioBaseJSON() {
		CONS_respuestaserviciobase_JSON respuestaServicio = new CONS_respuestaserviciobase_JSON();
        string arregloJson = 
            '{"codigo": "99","mensaje": "Ocurrió un error al ejecutar el servicio","respuestaBase": {"nCase_Id": "60","estado": {"nCodigo": "0","sMensaje": "OK"}},"respuestaEmailmatico": { "codigo": "0","mensaje": "ok" }}';
        respuestaServicio = CONS_respuestaserviciobase_JSON.parse(arregloJson);
        
    }
}