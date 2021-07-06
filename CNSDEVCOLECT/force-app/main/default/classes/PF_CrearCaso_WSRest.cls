/*********************************************************************************************************
@Author       cagonzle@everis.com
@name         PF_CrearCaso_WSRest
@CreateDate   03/10/2019
@Description  Service Rest Crear Caso desde Analytics 
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
06/08/2020                    cagonzle@everis.com                 Initial Version
**********************************************************************************************************/
@RestResource(urlMapping='/CrearCasosPF/*') 
global with sharing class PF_CrearCaso_WSRest {

	private static Map<String,String> camposProductoMap;
    private static List<Case> lstCasosPF;

	private final static String PF_RECORD_TYPE = Label.PF_Caso_RecordType;
	private final static String CAMPO_HIPO_CASO = Label.PF_Campo_Caso_Hipotecario;

	/**
	 * crearCasosPF Procesa la peticion de creacion de casos de PF
	 * @param  solicitudPF solicitudPF Json con el request
	 * @return             return Json con el response
	 */
    @HttpPost
    global static String crearCasosPF(){
        String solicitudPF = RestContext.request.requestBody.toString();
        lstCasosPF = new List<Case>();
        
        // 1. parser Json
        PF_CrearCasos_ReqResp_JSON request = PF_CrearCasos_ReqResp_JSON.parse(solicitudPF);
		List<PF_CrearCasos_ReqResp_JSON.PFCreaCasoreReq> subReqLst = request.PFCreaCasoreReq;
		
		// 4. Extraer info y crear caso 
		for(PF_CrearCasos_ReqResp_JSON.PFCreaCasoreReq subReq : subReqLst){
			mapeoCaso(subReq);
		}
		//System.debug(lstCasosPF);
        // 5. Guardar caso
        Insert lstCasosPF;
        // 6. Armar Response
        String jsonResponse = crearResponse();

        return jsonResponse;
    }

	/**
	 * mapeoCaso instacia de cada caso 
	 * @param  subReq subReq Request item de la solicitud
	 */
    private static void mapeoCaso(PF_CrearCasos_ReqResp_JSON.PFCreaCasoreReq subReq){
		Case nCaso = new Case();
		Boolean clienteApto = subReq.aptoNoApto;
		camposDinamicos();
        nCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PF_RECORD_TYPE).getRecordTypeId();
		nCaso.Caso_PF_Cliente_apto__c = clienteApto;
        
		nCaso.Sub_estado_Nectia__c = (clienteApto ? Label.PF_Creacion_Oportunidad : Label.PF_Rechazado_No_Apto); 
        
        nCaso.Status = (clienteApto ? Label.PF_Pre_Portabilidad : Label.PF_Cerrado);
		nCaso.Causa_Origen__c = Label.PF_Causa_Origen;
        
        ///* HOTFIX 15092020-Resuelve problematica del rut cuando posee el dígito en 'K'*/
        string rut = subReq.rutCliente.replaceAll( '\\s+', '');

		nCaso.Rut__c = subReq.rutCliente;
        ncaso.Rut_del_Cliente__c = subReq.rutCliente;
		for(PF_CrearCasos_ReqResp_JSON.ProductosPortar producto : subReq.productosPortar){
			if(camposProductoMap.containsKey(producto.nombre)){	nCaso.put(camposProductoMap.get(producto.nombre),true); }
		}

		try{
			PF_CasoSalidaNotiAnalytics.PortabilidadSegmentoReq psReq = new PF_CasoSalidaNotiAnalytics.PortabilidadSegmentoReq(nCaso);
			Case tempCaso = PF_CasoSalidaNotiAnalytics.sendNotificationWS(JSON.serialize(psReq)); 
			nCaso.put( Label.PF_Campo_Caso_Hipotecario_no_CNS, tempCaso.get(Label.PF_Campo_Caso_Hipotecario_no_CNS) );
			nCaso.put( Label.PF_Campo_Caso_Segmentacion_Cliente, tempCaso.get(Label.PF_Campo_Caso_Segmentacion_Cliente) ); 
		}catch(exception e){
			System.debug('Error Analytics: ' + e.getMessage());
		}

        lstCasosPF.add(nCaso);
	}

	/**
	 * crearResponse Crea el response iterando por cada caso
	 * @return   return String con el Json response segun la estructura de la clase PF_CrearCasos_ReqResp_JSON.PFCreaCasoreResp
	 */
	private static String crearResponse(){
        PF_CrearCasos_ReqResp_JSON res = new PF_CrearCasos_ReqResp_JSON();
		List<PF_CrearCasos_ReqResp_JSON.PFCreaCasoreResp> responseLst = new List<PF_CrearCasos_ReqResp_JSON.PFCreaCasoreResp>();
		for(Case caso : lstCasosPF){
			PF_CrearCasos_ReqResp_JSON.PFCreaCasoreResp response = new PF_CrearCasos_ReqResp_JSON.PFCreaCasoreResp();
			response.rutCliente = caso.Rut__c;
			response.nroCaso = caso.Id;
			response.estadoCaso = caso.Status;
			response.subEstado = caso.Sub_estado_Nectia__c;
			responseLst.add(response);
		}
        res.PFCreaCasoreResp = responseLst;
		return System.JSON.serialize(res);
	}

	/**
	 * camposDinamicos mapeo de los campos del caso y el request
	 */
	private static void camposDinamicos(){
		camposProductoMap = new Map<String,String>();
		camposProductoMap.put('Consumo', Label.PF_Campo_Caso_Consumo);
		camposProductoMap.put('Hipotecario', Label.PF_Campo_Caso_Hipotecario);
		camposProductoMap.put('Cuenta Corriente', Label.PF_Campo_Caso_PlanPlus);
	}
}