public class CONS_ConsultaRescate_JSON {


	public class ListaCuentas {
		public Integer nCodigoProducto;
		public Integer nOrigin;
		public Integer nPoliza;
		public Integer nRamoProducto;
		public Double nRescateEstimado;
		public String sOrigin;
	}
		public List<ListaCuentas> listaCuentas;
		public Integer nTipoRescate;
		public Double nTotalEstimado;
		//public List<ResponseError> responseError;
	    public ResponseError responseError;

	public class ResponseError {
		public Integer nCodigo;
		public String sMensaje;
	}
 
	
	public static CONS_ConsultaRescate_JSON parse(String json) {
		return (CONS_ConsultaRescate_JSON) System.JSON.deserialize(json, CONS_ConsultaRescate_JSON.class);
	}
}