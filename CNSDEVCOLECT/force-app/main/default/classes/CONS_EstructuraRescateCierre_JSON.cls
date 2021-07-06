public class CONS_EstructuraRescateCierre_JSON {


	public class DatosAlarma {
		public String nNumCaso;
		public String nPoliza;
		public String sFechaCierre;
		public String sEstado;
	}

	public class DatosEmail {
		public String nCelular;
		public String nNegocio;
		public String nNumpoliza;
		public String nNumsolicitud;
		public String nMontoRescate;
		public String nNumRescate;
		public String sLinNegocio;
		public String sNombreCliente;
		public String sEmail;
		public String sFechaRecepcion;
		public String sNombcaso;
		public String sNombreProducto;
		public String sDoc_Adjunto;
		public String sTipoPago;
		public String sBancoRescate;
		public String sDestinoChequeRescate;
		public String sCuentaDepositoRescate;
		public String sPlantilla;
		public String sNombreSucursal;
	}

	public DatosEmail datosEmail;
	public DatosAlarma datosAlarma;

	
	public static CONS_EstructuraRescateCierre_JSON parse(String json) {
		return (CONS_EstructuraRescateCierre_JSON) System.JSON.deserialize(json, CONS_EstructuraRescateCierre_JSON.class);
	}
}