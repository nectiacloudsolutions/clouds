public class CONS_RespuestaCertificadoPagos_JSON {

	public class Certificado {
		public String archivo;
		public String nombreArchivo;
	}

	
		public Certificado certificado;
		public String codigoError;
		public String mensajeError;
	

	
	public static CONS_RespuestaCertificadoPagos_JSON parse(String json) {
		return (CONS_RespuestaCertificadoPagos_JSON) System.JSON.deserialize(json, CONS_RespuestaCertificadoPagos_JSON.class);
	}
}