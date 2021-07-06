/*********************************************************************************************************
@Author       luis.vidal@consorcio.cl
@name         CreateCaseBanca_DTO_Test
@CreateDate   16/10/2020
@Description  Service Test para la clase CreateCaseBanca_DTO 
**********************************************************************************************************/

@IsTest
public class CreateCaseBancaDtoTest {

    static testMethod void validaEstructuraEntrada() {
        String json = '{'+
		'  \"CreateCaseBancaRequest\": ['+
        '    {'+
		'      \"rutCliente\": \"1-9\",'+
		'      \"tipo\": \"Consulta\",'+
        '      \"subtipo\": \"Activación PAC\",'+
        '      \"productoBanco\": \"Crédito hipotecario\",'+
        '      \"Origen\": \"IVR Autoatención\"'+
		'    }'+
		'  ],'+
        '  \"CreateCaseBancaResponse\": ['+
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

		CreateCaseBancaDto obj = CreateCaseBancaDto.parse(json);
        
		System.assert(obj != null);
        System.assert(obj.CreateCaseBancaRequest != null);
        System.assert(obj.CreateCaseBancaResponse != null);
    }
    
    static testMethod void validaEstructuraSalida() {
         String json = '{'+
		'  \"CreateCaseBancaResponse\": ['+
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
        '  \"CreateCaseBancaRequest\": null'+
		'}';
		CreateCaseBancaDto obj = CreateCaseBancaDto.parse(json);
		System.assert(obj != null);
        System.assert(obj.CreateCaseBancaResponse != null);
    }

	
   
}