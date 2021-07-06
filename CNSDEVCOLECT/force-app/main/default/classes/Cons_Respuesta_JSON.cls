global class Cons_Respuesta_JSON {

		public String estado;
		public string mensaje;
        public string RUT;
        public string codigo;
    
    public static Cons_Respuesta_JSON parse(String json) {
        return (Cons_Respuesta_JSON) System.JSON.deserialize(json, Cons_Respuesta_JSON.class);
	}
}