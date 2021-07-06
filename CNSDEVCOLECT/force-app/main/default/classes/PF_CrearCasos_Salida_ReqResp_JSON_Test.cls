/*********************************************************************************************************
@Author       luis.vidal@consorcio.cl
@name         PF_CrearCasos_Salida_ReqResp_JSON_Test
@CreateDate   21/10/2020
@Description  Service Test para la clase PF_CrearCasos_Salida_ReqResp_JSON_Test 
**********************************************************************************************************/

@IsTest
public class PF_CrearCasos_Salida_ReqResp_JSON_Test {

    static testMethod void testParse() {
        String json = '{'+
		'  \"PFCreaCasoSalidaReq\": ['+
        '    {'+
		'      \"rutCliente\": \"1-9\",'+
		'      \"tipo\": \"solicitud\",'+
        '      \"subtipo\": \"Portabilidad Financiera Salida\",'+
        '      \"IdRedbanc\": \"1234ASD\",'+
        '      \"IdCumbres\": \"12324EW\"'+
		'    }'+
		'  ],'+
        '  \"PFCreaCasoSalidaResp\": ['+
		'    {'+
        '      \"success\": true,'+
		'      \"rutcliente\": \"11009672-0\",'+
		'      \"errors\": \"mensaje de error\"'+
		'    },'+
        '   {'+
        '      \"success\": true,'+
		'      \"rutcliente\": \"11009672-0\",'+
		'      \"errors\": \"mensaje de error\"'+
		'    }'+
		'  ]'+
		'}';
        System.debug('este es el json: '+ json);
		PF_CrearCasos_Salida_ReqResp_JSON obj = PF_CrearCasos_Salida_ReqResp_JSON.parse(json);
        System.debug('objeto parseado: '+ obj);
        System.debug('objeto parseado rutcliente: '+ obj.PFCreaCasoSalidaReq);
        
		System.assert(obj != null);
        System.assert(obj.PFCreaCasoSalidaReq != null);
        System.assert(obj.PFCreaCasoSalidaResp != null);
    }
    
    static testMethod void testParse2() {
       // String json0 = '{\"PFCreaCasoSalidaResp\":[{\"success\":true,\"rutcliente\":\"11009672-0\",\"errors\":\"\"}],\"PFCreaCasoSalidaReq\":null}";
        String json = '{'+
		'  \"PFCreaCasoSalidaResp\": ['+
		'    {'+
        '      \"success\": true,'+
		'      \"rutcliente\": \"11009672-0\",'+
		'      \"errors\": \"mensaje de error\"'+
		'    },'+
        '   {'+
        '      \"success\": true,'+
		'      \"rutcliente\": \"11009672-0\",'+
		'      \"errors\": \"mensaje de error\"'+
		'    }'+
		'  ],'+
        '  \"PFCreaCasoSalidaReq\": null'+
		'}';
        System.debug('jsonlista : '+ json);
		PF_CrearCasos_Salida_ReqResp_JSON obj = PF_CrearCasos_Salida_ReqResp_JSON.parse(json);
        System.debug('objeto lista : '+ obj);
		System.assert(obj != null);
        System.assert(obj.PFCreaCasoSalidaResp != null);
    }

	
   
}