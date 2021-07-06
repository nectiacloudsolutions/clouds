global class CONS_Respuestaproducto_JSON {
      
        public string mensage;
        public string codigo;
        
       
        
    public static CONS_Respuestaproducto_JSON parse(String json) {
        system.debug('json'+json);
        return (CONS_Respuestaproducto_JSON) System.JSON.deserialize(json, CONS_Respuestaproducto_JSON.class);

    
}
}