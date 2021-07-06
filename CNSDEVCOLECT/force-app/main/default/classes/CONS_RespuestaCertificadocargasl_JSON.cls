public class CONS_RespuestaCertificadocargasl_JSON {
public class Certificado {
		public String archivo;
		public String nombreArchivo;
	}

	
		public Certificado certificado;
		public String codigoError;
		public String mensajeError;
	

	
	public static CONS_RespuestaCertificadocargasl_JSON parse(String json) {
		return (CONS_RespuestaCertificadocargasl_JSON) System.JSON.deserialize(json, CONS_RespuestaCertificadocargasl_JSON.class);
	}
}