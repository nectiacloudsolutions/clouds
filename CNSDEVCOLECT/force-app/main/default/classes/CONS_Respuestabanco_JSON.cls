global class CONS_Respuestabanco_JSON {

		
		public string mensaje;
        public string codigo;
    
    public static CONS_Respuestabanco_JSON parse(String json) {
        return (CONS_Respuestabanco_JSON) System.JSON.deserialize(json, CONS_Respuestabanco_JSON.class);
	}
}