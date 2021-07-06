public class Cons_Respuestaserviciourl_JSON {
	public String codigo;
	public String mensaje;
	public String url;
  
	
	public static Cons_Respuestaserviciourl_JSON parse(String json) {
		return (Cons_Respuestaserviciourl_JSON) System.JSON.deserialize(json, Cons_Respuestaserviciourl_JSON.class);
	}
    
}