public class CONS_Respuestacopiapoliza_JSON {

	public class DTOcopiaPolizaPDF_GEN {
		public String documento;
		public String nombre_archivo;
       
        
	}


		public DTOcopiaPolizaPDF_GEN DTOcopiaPolizaPDF_GEN;
		public String codigo;
		public String mensaje;
		public String mensajeEx;
	

	
	public static CONS_Respuestacopiapoliza_JSON parse(String json) {
		return (CONS_Respuestacopiapoliza_JSON) System.JSON.deserialize(json, CONS_Respuestacopiapoliza_JSON.class);
	}
}