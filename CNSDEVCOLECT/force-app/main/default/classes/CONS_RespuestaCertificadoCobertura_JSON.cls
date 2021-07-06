public class CONS_RespuestaCertificadoCobertura_JSON {


	
		public Certificado certificado;
		public String codigoError;
		public String mensajeError;
	

	public class Certificado {
		public String archivo;
		public String nombreArchivo;
	}

	
	public static CONS_RespuestaCertificadoCobertura_JSON parse(String json) {
		return (CONS_RespuestaCertificadoCobertura_JSON) System.JSON.deserialize(json,CONS_RespuestaCertificadoCobertura_JSON.class);
	}
}