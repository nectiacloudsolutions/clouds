public class CONS_EnvioReclamos_JSON {

		public String nCelular;
		public String nMandato;
		public String nNumpoliza;
		public String nNumsolicitud;
		public String sResolucionCaso;
		public String nTelefonoEjec;
		public String nNegocio;
		public String sBanco;
		public String sDoc_Adjunto;
		public String sEmail;
		public String sFechaCierre;
		public String sFechaEfectivaEndoso;
		public String sFechaRecepcion;
		public String sLinNegocio;
		public String sMailEjecutivo;
		public String sMotivoRechazo;
		public String sNombcaso;
		public String sNombreCliente;
		public String sNomEjecutivo;
		public String sPlantilla;
		public String sRutCliente;
	    public String sNombreLiquidador;
        public String sNombreTaller;
        public String sNominstitucion;

	
	public static CONS_EnvioReclamos_JSON parse(String json) {
		return (CONS_EnvioReclamos_JSON) System.JSON.deserialize(json, CONS_EnvioReclamos_JSON.class);
	}
}