@IsTest
public class PF_CrearCasos_ReqResp_JSON_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"PFCreaCasoreReq\": ['+
		'    {'+
		'      \"nombreCliente\": \"Juan Perez\",'+
		'      \"rutCliente\": \"1-9\",'+
		'      \"aptoNoApto\": true,'+
		'      \"productosPortar\": ['+
		'        {'+
		'          \"nombre\": \"Hipotecario\"'+
		'        },'+
		'        {'+
		'          \"nombre\": \"consumo\"'+
		'        },'+
		'        {'+
		'          \"nombre\": \"plan plus\"'+
		'        }'+
		'      ]'+
		'    },'+
		'    {'+
		'      \"nombreCliente\": \"Juana Perez\",'+
		'      \"rutCliente\": \"2-7\",'+
		'      \"aptoNoApto\": true,'+
		'      \"productosPortar\": ['+
		'        {'+
		'          \"nombre\": \"Hipotecario\"'+
		'        },'+
		'        {'+
		'          \"nombre\": \"consumo\"'+
		'        }'+
		'      ]'+
		'    },'+
		'    {'+
		'      \"nombreCliente\": \"Juanito Perez\",'+
		'      \"rutCliente\": \"3-6\",'+
		'      \"aptoNoApto\": false,'+
		'      \"productosPortar\": ['+
		'        {'+
		'          \"nombre\": \"Hipotecario\"'+
		'        }'+
		'      ]'+
		'    }'+
		'  ],'+
		'  \"PFCreaCasoreResp\": ['+
		'    {'+
		'      \"rutCliente\": \"1-9\",'+
		'      \"nroCaso\": \"123\",'+
		'      \"estadoCaso\": \"Pre Portabilidad\",'+
		'      \"subEstado\": \"Creación Oportunidad\"'+
		'    },'+
		'    {'+
		'      \"rutCliente\": \"2-7\",'+
		'      \"nroCaso\": \"1234\",'+
		'      \"estadoCaso\": \"Pre Portabilidad\",'+
		'      \"subEstado\": \"Creación Oportunidad\"'+
		'    },'+
		'    {'+
		'      \"rutCliente\": \"3-6\",'+
		'      \"nroCaso\": \"12345\",'+
		'      \"estadoCaso\": \"Pre Portabilidad\",'+
		'      \"subEstado\": \"Rechazado\"'+
		'    }'+
		'  ]'+
		'}';
        
		PF_CrearCasos_ReqResp_JSON obj = PF_CrearCasos_ReqResp_JSON.parse(json);
		System.assert(obj != null);
	}
}