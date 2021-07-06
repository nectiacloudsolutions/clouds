/*********************************************************************************************************
@Author       lmunogar@everis.com
@name         PF_CrearCasos_ReqResp_JSON
@CreateDate   03/10/2019
@Description  Service Rest Crear Caso desde Analytics 
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
06/08/2020                    lmunogar@everis.com                 Initial Version
**********************************************************************************************************/
public class PF_CrearCasos_ReqResp_JSON {
	
    public class PFCreaCasoreReq {
		public String nombreCliente {get;set;}
		public String rutCliente {get;set;}
		public Boolean aptoNoApto {get;set;}
		public List<ProductosPortar> productosPortar {get;set;}
	}

	public List<PFCreaCasoreReq> PFCreaCasoreReq {get;set;}
	public List<PFCreaCasoreResp> PFCreaCasoreResp {get;set;}

	public class ProductosPortar {
		public String nombre {get;set;}
	}

	public class PFCreaCasoreResp {
		public String rutCliente {get;set;}
		public String nroCaso {get;set;}
		public String estadoCaso {get;set;}
		public String subEstado {get;set;}
	}
    
	public static PF_CrearCasos_ReqResp_JSON parse(String json) {
		return (PF_CrearCasos_ReqResp_JSON) System.JSON.deserialize(json, PF_CrearCasos_ReqResp_JSON.class);
	}
}