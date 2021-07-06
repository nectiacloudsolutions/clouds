public class Cons_respuestaendoso_JSON {
	public String codError;
	public String descripcion;
	public String descripcionUsuario;
	public String nombreArchivo;
	public String documento;
	public Integer envioEmailCliente;

	
	public static Cons_respuestaendoso_JSON parse(String json) {
		return (Cons_respuestaendoso_JSON) System.JSON.deserialize(json, Cons_respuestaendoso_JSON.class);
	}
}