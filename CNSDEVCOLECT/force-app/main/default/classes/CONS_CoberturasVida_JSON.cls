public class CONS_CoberturasVida_JSON {


	public class Lista_coberturas {
		public List<Coberturas> coberturas;
	}


		public Lista_coberturas lista_coberturas;
	

	public class Coberturas {
		public Integer codigo_cobertura;
		public String glosa_cobertura;
		public String condicionado;
		public String total_prima;
		public String prima_proyectada;
		public String prima_bruta;
		public String porcentaje_tasa_recargos;
		public String valor_tasa_recargos;
		public String tasa_ajuste;
		public String tasa_descuento;
		public String tasa_recargo;
		public String tasa_tarifa;
		public String aplica_factor_pago;
		public String factor_pago;
		public String impuesto;
        public String capital_asegurado;
        public String prima_forma_pago;
        
	}

	
	public static CONS_CoberturasVida_JSON parse(String json) {
		return (CONS_CoberturasVida_JSON) System.JSON.deserialize(json, CONS_CoberturasVida_JSON.class);
	}
}