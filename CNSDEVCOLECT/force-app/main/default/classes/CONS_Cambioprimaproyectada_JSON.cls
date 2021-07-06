public class CONS_Cambioprimaproyectada_JSON {


	public class DatoscambioPrima {
		public String companiaPoliza;
		public Integer numeroPoliza;
		public double montoPrima;
		public String numeroUsuario;
		public Integer numeroCaso;
	}

	public class ParamsEmailmatico {
		public Integer nCelular;
		public Integer nNumMandato;
		public Integer nNumpoliza;
		public Integer nNumsolicitud;
		public String nResolucionCaso;
		public Integer nTelefonoEjec;
		public Integer nNegocio;
		public String sBanco;
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
	}


		public DatoscambioPrima datoscambioPrima;
		public ParamsEmailmatico paramsEmailmatico;
	

	
	public static CONS_Cambioprimaproyectada_JSON parse(String json) {
		return (CONS_Cambioprimaproyectada_JSON) System.JSON.deserialize(json, CONS_Cambioprimaproyectada_JSON.class);
	}

    
}