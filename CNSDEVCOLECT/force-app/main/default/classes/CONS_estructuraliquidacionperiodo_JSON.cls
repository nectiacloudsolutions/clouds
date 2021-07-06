public class CONS_estructuraliquidacionperiodo_JSON {



		public String codigoError;
		public String mensajeError;
		public PeriodosCertificadoLiquidacionPension periodosCertificadoLiquidacionPension;
	

	public class Liquidacion {
		public String numLiquidacion;
		public String periodoPago;
	}

	public class PeriodosCertificadoLiquidacionPension {
		public List<Liquidacion> liquidacion;
	}

	
	public static CONS_estructuraliquidacionperiodo_JSON parse(String json) {
		return (CONS_estructuraliquidacionperiodo_JSON) System.JSON.deserialize(json, CONS_estructuraliquidacionperiodo_JSON.class);
	}
}