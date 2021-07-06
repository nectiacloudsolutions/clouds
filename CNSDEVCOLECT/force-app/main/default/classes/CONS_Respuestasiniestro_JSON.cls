public class CONS_Respuestasiniestro_JSON {

		public String mensaje;
		public Cls_Info cls_Info;
	

	public class Infosiniestro {
		public String tipo_perdida;
		public String numero_siniestro;
		public String numero_denuncio;
		public String liquidador_asignado;
		public String fecha_ocurrenci_denuncio;
		public String fecha_de_denuncio;
		public String estado;
		public String des_evento_siniestro;
		public String declaracion_involucrados;
		public String causal;
	}

	public class Cls_Info {
		public List<Infosiniestro> infosiniestro;
	}

	
	public static CONS_Respuestasiniestro_JSON parse(String json) {
		return (CONS_Respuestasiniestro_JSON) System.JSON.deserialize(json, CONS_Respuestasiniestro_JSON.class);
	}
}