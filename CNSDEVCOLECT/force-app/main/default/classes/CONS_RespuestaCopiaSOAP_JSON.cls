public class CONS_RespuestaCopiaSOAP_JSON {
    

		public Certificado certificado;
		public String codigoError;
		public String mensajeError;


	public class Certificado {
		public String archivo;
		public String nombreArchivo;
	}

	
	public static CONS_RespuestaCopiaSOAP_JSON parse(String json) {
		return (CONS_RespuestaCopiaSOAP_JSON) System.JSON.deserialize(json, CONS_RespuestaCopiaSOAP_JSON.class);
	}
}