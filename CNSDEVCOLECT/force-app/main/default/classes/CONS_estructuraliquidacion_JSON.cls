public class CONS_estructuraliquidacion_JSON {


	
		public Certificado certificado;
		public String codigoError;
		public String mensajeError;
	

	public class Certificado {
		public String archivo;
		public String nombreArchivo;
	}

	
	public static CONS_estructuraliquidacion_JSON parse(String json) {
		return (CONS_estructuraliquidacion_JSON) System.JSON.deserialize(json, CONS_estructuraliquidacion_JSON.class);
	}
}