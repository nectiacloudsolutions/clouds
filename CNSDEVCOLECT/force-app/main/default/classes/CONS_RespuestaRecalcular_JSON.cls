public class CONS_RespuestaRecalcular_JSON {


	public class MsjError {
		public Integer nCodigo;
		public String sMensaje;
	}


		public MsjError msjError;
		public Integer nCodigoProducto;
		public Integer nOrigin;
		public Integer nPoliza;
		public Integer nRamoProducto;
		public Double nRescateEstimado;
		public Double nRescateSobrecargado;
	

	
	public static CONS_RespuestaRecalcular_JSON parse(String json) {
		return (CONS_RespuestaRecalcular_JSON) System.JSON.deserialize(json, CONS_RespuestaRecalcular_JSON.class);
	}
}