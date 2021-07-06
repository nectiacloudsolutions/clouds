public class CONS_Respuestacopiapolizavida_JSON {

		public DTOcopiaPolizaPDF_VI DTOcopiaPolizaPDF_VI;
		public String codigo;
		public String mensaje;
		public String mensajeEx;
	

	public class DTOcopiaPolizaPDF_VI {
		public String ruta_archivo;
		public String documento;
		public String nombre_archivo;
	}

	
	public static CONS_Respuestacopiapolizavida_JSON parse(String json) {
		return (CONS_Respuestacopiapolizavida_JSON) System.JSON.deserialize(json, CONS_Respuestacopiapolizavida_JSON.class);
	}
}