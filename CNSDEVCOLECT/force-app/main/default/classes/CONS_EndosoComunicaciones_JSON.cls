public class CONS_EndosoComunicaciones_JSON {

		public String nCelular;
		public String nNumMandato;
		public String nNumpoliza;
		public String nNumsolicitud;
		public String nResolucionCaso;
		public String nTelefonoEjec;
		public String sBanco;
		public String sDoc_Adjunto;
		public String sEmail;
		public String sFechaCierre;
		public String sFechaEfectivaEndoso;
		public String sFechaRecepcion;
		public String sLinNegocio;
		public String nNegocio;
		public String sMailEjecutivo;
		public String sMotivoRechazo;
		public String sNomEjecutivo;
		public String sNombcaso;
		public String sNombreCliente;
		public String sPlantilla;
	

	
	public static CONS_EndosoComunicaciones_JSON parse(String json) {
		return (CONS_EndosoComunicaciones_JSON) System.JSON.deserialize(json, CONS_EndosoComunicaciones_JSON.class);
	}
}