global  class Cons_estructuraproducto_JSON {
    
        
    public respuesta respuesta;
    public List<producto> productos;
    public string rut;
     public class producto {

        public string producto;
        public string tipo;
        public string codigo;
        public string estado;
        public string fecha;
        public string nombreproducto;
        public string id;
    }
    global class respuesta {
        public String mensage;
        public String estado;
		public String codigo;
     }

    
global static Cons_estructuraproducto_JSON parse(String json) {
        system.debug('json'+json);
		return (Cons_estructuraproducto_JSON) System.JSON.deserialize(json, Cons_estructuraproducto_JSON.class);
	}    
}