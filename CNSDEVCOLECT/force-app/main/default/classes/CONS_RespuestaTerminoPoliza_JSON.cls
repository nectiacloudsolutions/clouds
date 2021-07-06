public class CONS_RespuestaTerminoPoliza_JSON {

		public String codigo;
		public String mensaje;
		public RespuestaBase respuestaBase;


	public class RespuestaBase {
		public String codigo;
		public String mensaje;
		public String nPropuesta;
	}

	
	public static CONS_RespuestaTerminoPoliza_JSON parse(String json) {
		return (CONS_RespuestaTerminoPoliza_JSON) System.JSON.deserialize(json, CONS_RespuestaTerminoPoliza_JSON.class);
	}
}