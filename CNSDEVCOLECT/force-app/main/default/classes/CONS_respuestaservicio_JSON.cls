public class CONS_respuestaservicio_JSON {
    
    public String codigo;
    public String mensaje;
    public RespuestaBase respuestaBase;
    public respuestaEmailmatico respuestaEmailmatico;
    
    public class RespuestaBase {
        public String codigo;
        public String mensaje;
        public String nPropuesta;
    }
    public class respuestaEmailmatico {
        public String codigo;
        public String mensaje;
    }
    
    public static CONS_respuestaservicio_JSON parse(String json) {
        return (CONS_respuestaservicio_JSON) System.JSON.deserialize(json, CONS_respuestaservicio_JSON.class);
    }
    
}