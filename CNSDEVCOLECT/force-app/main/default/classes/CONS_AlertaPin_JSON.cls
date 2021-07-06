public class CONS_AlertaPin_JSON {

	public String nNumCaso;
	public String sProductId;
	public String nPoliza;
	public String sDescr;
	public String sFechaIngreso;
	public String sFechaCierre;
	public String sEstado;
	public String sMontoTrasp;
	public String sInstitTrasp;
	public String sRutIntermediario;
	public String sDetalle;

	
	public static CONS_AlertaPin_JSON parse(String json) {
		return (CONS_AlertaPin_JSON) System.JSON.deserialize(json, CONS_AlertaPin_JSON.class);
	}
}