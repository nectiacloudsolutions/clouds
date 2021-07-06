global class CONS_Estructurarespuestacaso_JSON {

		public String cliente_rut;
		public List<listacaso> casos;
	

	public class listacaso {
        public String id;
        public String numero_de_caso;
		public String caso_principal;
		public String descripcion;
        public String origen_del_caso;
        public String propietario_del_caso;
        public String estado;
        public String sub_estado;
		public String nombre_asignacion;
        public String tipo;
		public String subtipo;
        public Datetime  asignacion_hora_inicio;
		public Datetime  asignacion_hora_finalizacion;
	}

	
	global static CONS_Estructurarespuestacaso_JSON parse(String json) {
        system.debug('json'+json);
		return (CONS_Estructurarespuestacaso_JSON) System.JSON.deserialize(json, CONS_Estructurarespuestacaso_JSON.class);
	}
}