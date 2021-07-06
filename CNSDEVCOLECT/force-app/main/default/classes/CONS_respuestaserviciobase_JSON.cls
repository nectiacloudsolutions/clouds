public class CONS_respuestaserviciobase_JSON {

    public String codigo;
    public String mensaje;
    public RespuestaBase respuestaBase;
    public respuestaEmailmatico respuestaEmailmatico;

    public class Estado {
        public String nCodigo;
        public String sMensaje;
    }

    public class RespuestaBase {
        public Estado estado;
        public String nCase_Id;
    }

    public class respuestaEmailmatico {
        public String codigo;
        public String mensaje;
    }

    
    public static CONS_respuestaserviciobase_JSON parse(String json) {
        return (CONS_respuestaserviciobase_JSON) System.JSON.deserialize(json, CONS_respuestaserviciobase_JSON.class);
    }
}