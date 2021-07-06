public class CONS_Respuestasolicitudclave_JSON {
    
    public String Codigo;
    public String mensaje;
    
    public static CONS_Respuestasolicitudclave_JSON parse(String json) {
        return (CONS_Respuestasolicitudclave_JSON) System.JSON.deserialize(json, CONS_Respuestasolicitudclave_JSON.class);
    }
}