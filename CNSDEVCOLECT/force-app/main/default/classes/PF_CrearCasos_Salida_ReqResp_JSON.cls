/*********************************************************************************************************
@Author       luis.vidal@consorcio.cl
@name         PF_CrearCasos_Salida_ReqResp_JSON
@CreateDate   21/10/2020
@Description  Service Rest Crear Caso de salida  
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
21/10/2020                    luis.vidal@consorcio.cl                 Initial Version
**********************************************************************************************************/
public class PF_CrearCasos_Salida_ReqResp_JSON {
	

    public class PFCreaCasoSalidaReq {
        
        public String rutCliente {get;set;}
        public String IdRedbanc {get;set;}
		public String IdCumbres {get;set;}
		public String correo_electronico {get;set;}
		public String BancoOrigen {get;set;}
	}

    public List<PFCreaCasoSalidaReq> PFCreaCasoSalidaReq {get;set;}
	public List<PFCreaCasoSalidaResp> PFCreaCasoSalidaResp {get;set;}
	

	public class PFCreaCasoSalidaResp {
		public Id idCaso  {get;set;}
		public string rutcliente  {get;set;}
		public Boolean success {get;set;}
		public string errors {get;set;}
    }
    
	public static PF_CrearCasos_Salida_ReqResp_JSON parse(String json) {
		return (PF_CrearCasos_Salida_ReqResp_JSON) System.JSON.deserialize(json, PF_CrearCasos_Salida_ReqResp_JSON.class);
	}
}