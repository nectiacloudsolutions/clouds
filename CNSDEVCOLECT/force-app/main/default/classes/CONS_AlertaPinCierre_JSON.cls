public class CONS_AlertaPinCierre_JSON {

	public String nNumCaso;
	public String nPoliza;
	public String sFechaCierre;
	public String sEstado;
	

	public static CONS_AlertaPinCierre_JSON parse(String json) {
		return (CONS_AlertaPinCierre_JSON) System.JSON.deserialize(json, CONS_AlertaPinCierre_JSON.class);
	}

}