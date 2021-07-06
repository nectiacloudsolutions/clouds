public class CONS_RespuestaCertificadoVigencia_JSON {


	public class Certificado {
		public String archivo;
		public String nombreArchivo;
	}

	
		public Certificado certificado;
		public String codigoError;
		public String mensajeError;
	

	
	public static CONS_RespuestaCertificadoVigencia_JSON parse(String json) {
		return (CONS_RespuestaCertificadoVigencia_JSON) System.JSON.deserialize(json, CONS_RespuestaCertificadoVigencia_JSON.class);
	}
}