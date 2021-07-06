public class CONS_documentovisualizar_JSON {
    
		public String codigo;
		public String mensaje;
		public String mensajeServicio;
		public String codigoServicio;
		public Documents documents;
	

	public class DocumentResult {
		public String extension;
		public blob contenido;
        public String nombre;
		public String contentType;
	}

	public class Documents {
		public List<DocumentResult> documentResult;
	}

	
	public static CONS_documentovisualizar_JSON parse(String json) {
		return (CONS_documentovisualizar_JSON) System.JSON.deserialize(json, CONS_documentovisualizar_JSON.class);
	}
}