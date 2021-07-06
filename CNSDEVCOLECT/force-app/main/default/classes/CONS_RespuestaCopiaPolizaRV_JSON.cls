public class CONS_RespuestaCopiaPolizaRV_JSON {


	public class DTOcopiaPolizaPDF_RRVV {
		public String codigo_error;
		public String mensaje_estado;
		public String descripcion_usuario;
		public String documento;
		public String nombre_archivo;
	}

	public DTOcopiaPolizaPDF_RRVV DTOcopiaPolizaPDF_RRVV;
	public String codigo;
	public String mensaje;
	public String mensajeEx;

	
	public static CONS_RespuestaCopiaPolizaRV_JSON parse(String json) {
		return (CONS_RespuestaCopiaPolizaRV_JSON) System.JSON.deserialize(json, CONS_RespuestaCopiaPolizaRV_JSON.class);
	}
}