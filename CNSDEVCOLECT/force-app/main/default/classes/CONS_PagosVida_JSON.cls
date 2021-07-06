public class CONS_PagosVida_JSON {


	public class Lista_pagos {
		public List<Pagos> pagos;
		public Integer total_pagos;
	}

	
		public Lista_pagos lista_pagos;
	

	public class Pagos {
		public String concepto;
		public String periodo;
		public Integer recibo;
		public String valor_cargo;
		public String via_de_pago;
		public String fecha_de_abono;
		public String pago_moneda_origen;
		public Integer valor_moneda_origen;
		public String moneda_origen;
		public String monto_pagado;
	}

	
	public static CONS_PagosVida_JSON parse(String json) {
		return (CONS_PagosVida_JSON) System.JSON.deserialize(json, CONS_PagosVida_JSON.class);
	}

}