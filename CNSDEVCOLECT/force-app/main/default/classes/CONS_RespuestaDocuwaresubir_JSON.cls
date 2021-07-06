public class CONS_RespuestaDocuwaresubir_JSON {

		public Integer dwDocId;
		public String mensajeServicio;
		public String codigoServicio;
		public String mensaje;
		public String codigo;
	

	
	public static CONS_RespuestaDocuwaresubir_JSON parse(String json) {
		return (CONS_RespuestaDocuwaresubir_JSON) System.JSON.deserialize(json, CONS_RespuestaDocuwaresubir_JSON.class);
	}

}