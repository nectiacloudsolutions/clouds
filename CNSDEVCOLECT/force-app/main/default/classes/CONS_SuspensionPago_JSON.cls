public class CONS_SuspensionPago_JSON {


	public class DatosSuspension {
		public String codigoISPL;
		public Integer codigoAreaSeguro;
		public Integer numeroPoliza;
		public Integer codigoBranch;
		public Integer codigoProducto;
		public String deffecDate;
		public Integer codigoTipoOperacion;
		public String fechaInicioSuspencion;
		public String fechaFinSuspencion;
		public Integer codigoRazonSuspencion;
		public Integer codigoTipoSuspencion;
		public Integer numeroCaso;
		public String codigoUsuario;
	}


		public DatosSuspension datosSuspension;
		public ParamsEmailmatico paramsEmailmatico;
	

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

	
	public static CONS_SuspensionPago_JSON parse(String json) {
		return (CONS_SuspensionPago_JSON) System.JSON.deserialize(json, CONS_SuspensionPago_JSON.class);
	}
}