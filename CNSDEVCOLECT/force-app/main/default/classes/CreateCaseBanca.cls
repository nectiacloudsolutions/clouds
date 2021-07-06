/*********************************************************************************************************
@Author       luis.vidal@consorcio.cl
@name         CreateCaseBanca
@CreateDate   12/11/2020
@Description  Service Rest create case of type banca 
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
12/11/2020                    luis.vidal@consorcio.cl           Initial Version
**********************************************************************************************************/
@RestResource(urlMapping='/CreateCaseBanca/*') 
global with sharing class CreateCaseBanca {

    private final static String CB_RECORD_TYPE_ID = [SELECT Id FROM RecordType where DeveloperName = 'Casos_Banco' LIMIT 1][0].Id;
    
    private static Map<String,Account> cuentasMap;
    private static List<Case> lstCasosBanca;
    private static String cuentaRUT;


    /**
	 * CrearCasosBanca Procesa la peticion de creacion de casos de banca
	 * @param  newRequest solicitud Json con el request
	 * @return             return Json con el response
	 */
    @HttpPost
    global static String CreateCaseBanca() {
        
        String newRequest = RestContext.request.requestBody.toString();
        lstCasosBanca = new List<Case>();

        CreateCaseBancaDto request = CreateCaseBancaDto.parse(newRequest);
        List<CreateCaseBancaDto.CreateCaseBancaRequest> subReqLst = request.CreateCaseBancaRequest;
        List<String> lstRUT = new List<String>();
		for(CreateCaseBancaDto.CreateCaseBancaRequest subReq : subReqLst){
			cuentaRUT = subReq.rutCliente;
			lstRUT.add(cuentaRUT);
        }
         buscarCuentas(lstRUT);
         
		for(CreateCaseBancaDto.CreateCaseBancaRequest subReq : subReqLst){
			mapeoCaso(subReq);
		}

        Insert lstCasosBanca;
        String jsonResponse = crearResponse();

        return jsonResponse;
    }


    /**
	 * buscarCuentas Lista de Cuentas por numero de RUT
	 * @param  cuentaRUT cuentaRUT Lista de Numeros RUT de las cuentas 
	 */
    private static void buscarCuentas(List<String> cuentaRUT){
        cuentasMap = new Map<String,Account>();
        for(Account acc : [SELECT RUT__c, PersonContactId FROM Account WHERE RUT__c IN: cuentaRUT]){
           string rut = acc.RUT__c.replaceAll( '\\s+', '');
            cuentasMap.put(rut.toLowerCase(), acc);
           
        }


    }

    // /**
	//  * mapeoCaso instacia de cada caso 
	//  * @param  subReq subReq Request item de la solicitud
	//  */
    private static void mapeoCaso(CreateCaseBancaDto.CreateCaseBancaRequest subReq){
        Case nCaso = new Case();
        
        string rut = subReq.rutCliente.replaceAll( '\\s+', '');
		Account acc = cuentasMap.get(rut.toLowerCase());

        nCaso.RecordTypeId = CB_RECORD_TYPE_ID;
        nCaso.AccountId = acc.Id;
		nCaso.ContactId = acc.PersonContactId;
		nCaso.Rut__c = subReq.rutCliente;
        ncaso.Rut_del_Cliente__c = subReq.rutCliente;
        nCaso.Tipo_Auxiliar__c = subReq.tipo;
        nCaso.Subtipo_Auxiliar__c = subReq.Subtipo;
        nCaso.Tipo_de_producto_banco__c = subReq.productoBanco;
        nCaso.Origin = subReq.Origen;
        nCaso.Status = 'Cerrado';
        nCaso.Sub_estado_Nectia__c = 'Solucionado';

	
        lstCasosBanca.add(nCaso);
        
    }
    
    /**
	 * crearResponse Crea el response iterando por cada caso
	 * @return   return String con el Json response segun la estructura de la clase PF_CrearCasos_ReqResp_JSON.PFCreaCasoreResp
	 */
	private static String crearResponse(){
        CreateCaseBancaDto res = new CreateCaseBancaDto();
		List<CreateCaseBancaDto.CreateCaseBancaResponse> responseLst = new List<CreateCaseBancaDto.CreateCaseBancaResponse>();
        
        for(Case caso : lstCasosBanca){
			CreateCaseBancaDto.CreateCaseBancaResponse response = new CreateCaseBancaDto.CreateCaseBancaResponse();
            response.idCaso = caso.Id;
            response.rutcliente = caso.Rut__c;
            response.success = true; 
            response.errors = '';
			responseLst.add(response);
		}
        res.CreateCaseBancaResponse = responseLst;
		return System.JSON.serialize(res);
    }
}