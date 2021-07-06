/*********************************************************************************************************
@Author       luis.vidal@consorcio.cl
@name         PF_CrearCaso_Salida_WSRest
@CreateDate   21/10/2020
@Description  Service Rest Crear Casos Salida PF
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
21/10/2020                    luis.vidal@consorcio.cl                 Initial Version
**********************************************************************************************************/
@RestResource(urlMapping='/CrearCasosSalidaPF/*') 
global with sharing class PF_CrearCasos_Salida_WSRest {

    private static Map<String,Account> cuentasMap;
    private static List<Case> lstCasosPF;
    private static String cuentaRUT;

    private final static String PF_RECORD_TYPE = Label.PF_Caso_RecordType_Salida;


    /**
	 * CrearCasosSalidaPF Procesa la peticion de creacion de casos de PF de salida
	 * @param  solicitudSalidaPF solicitudPF Json con el request
	 * @return             return Json con el response
	 */
    @HttpPost
    global static String CrearCasosSalidaPF(){
        String solicitudSalidaPF = RestContext.request.requestBody.toString();
        lstCasosPF = new List<Case>();
        System.debug('solicitud recibida: '+ solicitudSalidaPF);

        // 1. parser Json
        PF_CrearCasos_Salida_ReqResp_JSON request = PF_CrearCasos_Salida_ReqResp_JSON.parse(solicitudSalidaPF);
        System.debug('solicitud recibida 2: '+ request.PFCreaCasoSalidaReq);
        List<PF_CrearCasos_Salida_ReqResp_JSON.PFCreaCasoSalidaReq> subReqLst = request.PFCreaCasoSalidaReq;
        List<String> lstRUT = new List<String>();
        System.debug('solicitud recibida 3: '+ subReqLst);
		for(PF_CrearCasos_Salida_ReqResp_JSON.PFCreaCasoSalidaReq subReq : subReqLst){
			cuentaRUT = subReq.rutCliente;
			lstRUT.add(cuentaRUT);
        }

        System.debug('recordtypename: '+ PF_RECORD_TYPE);
        System.debug('lista de rut: '+ lstRUT);
        System.debug('PF_RECORD_TYPE : '+ PF_RECORD_TYPE);
         // 2. Extraer info cuenta, buscar y asignar a Caso
         buscarCuentas(lstRUT);
         System.debug('lista de cuentas por ruts: '+ cuentasMap);
        
        // 4. Extraer info y crear caso 
		for(PF_CrearCasos_Salida_ReqResp_JSON.PFCreaCasoSalidaReq subReq : subReqLst){
			mapeoCaso(subReq);
		}

         // 5. Guardar caso
         Insert lstCasosPF;
        // 6. Armar Response
        String jsonResponse = crearResponse();
        System.debug('casoObjeto: '+ lstCasosPF);
        System.debug('contenido de response: '+ jsonResponse);

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
     private static void mapeoCaso(PF_CrearCasos_Salida_ReqResp_JSON.PFCreaCasoSalidaReq subReq){
        Case nCaso = new Case();
        
        string rut = subReq.rutCliente.replaceAll( '\\s+', '');
		Account acc = cuentasMap.get(rut.toLowerCase());

        nCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PF_RECORD_TYPE).getRecordTypeId();
        nCaso.AccountId = acc.Id;
		nCaso.ContactId = acc.PersonContactId;
		nCaso.Rut__c = subReq.rutCliente;
        ncaso.Rut_del_Cliente__c = subReq.rutCliente;
        nCaso.type = 'solicitud';
        nCaso.Subtipo__c = 'Portabilidad Financiera Salida';
        nCaso.Priority = 'Alta';
        nCaso.SuppliedEmail = subReq.correo_electronico;
        nCaso.ID_Redbanc__c = subReq.IdRedbanc;
        nCaso.Id_Cumbres__c = subReq.IdCumbres;
        nCaso.instituci_n_financiera__c = subReq.BancoOrigen;

        try{
            PF_CasoSalidaNotiAnalytics.PortabilidadSegmentoReq psReq = new PF_CasoSalidaNotiAnalytics.PortabilidadSegmentoReq(nCaso);
            Case tempCaso = PF_CasoSalidaNotiAnalytics.sendNotificationWS(JSON.serialize(psReq)); 
            nCaso.put( Label.PF_Campo_Caso_Hipotecario_no_CNS, tempCaso.get(Label.PF_Campo_Caso_Hipotecario_no_CNS) );
            nCaso.put( Label.PF_Campo_Caso_Hipotecario, tempCaso.get(Label.PF_Campo_Caso_Hipotecario) );
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
        PF_CrearCasos_Salida_ReqResp_JSON res = new PF_CrearCasos_Salida_ReqResp_JSON();
		List<PF_CrearCasos_Salida_ReqResp_JSON.PFCreaCasoSalidaResp> responseLst = new List<PF_CrearCasos_Salida_ReqResp_JSON.PFCreaCasoSalidaResp>();
        
        for(Case caso : lstCasosPF){
			PF_CrearCasos_Salida_ReqResp_JSON.PFCreaCasoSalidaResp response = new PF_CrearCasos_Salida_ReqResp_JSON.PFCreaCasoSalidaResp();
            response.idCaso = caso.Id;
            response.rutcliente = caso.Rut__c;
            response.success = true; 
            response.errors = '';
			responseLst.add(response);
		}
        res.PFCreaCasoSalidaResp = responseLst;
		return System.JSON.serialize(res);
    }
    
   

}