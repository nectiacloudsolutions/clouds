public class CONS_docuwareobtener_JSON {



	public Archivadores archivadores;
	public String mensaje;
	public String codigo;
	public String mensajeServicio;
	public String codigoServicio;

	public class Archivadores {
		public List<Archivador> archivador;
	}

	public class Archivador {
		public String nombre;
		public String resultado;
		public String mensaje;
	}

	
	public static CONS_docuwareobtener_JSON parse(String json) {
		return (CONS_docuwareobtener_JSON) System.JSON.deserialize(json, CONS_docuwareobtener_JSON.class);
	}
}