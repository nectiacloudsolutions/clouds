public class CONS_PagosGenerales_JSON {


	public class Pagos_poliza {
		public Integer nro_cuota;
		public String transaccion;
		public String cuota;
		public String tipo;
		public String balance;
		public String monto_moneda_origen;
		public String relacion;
		public String boletin;
		public String contrato;
		public String fecha_vencimiento;
		public String fecha_cobranza;
		public String fecha_pago;
		public String codigo_estado;
		public String glosa_estado;
		public String estado_contrato;
		public String fecha_actual;
		public String monto_cuota_uf;
		public String via_de_pago;
	}

	public class Lista_pagos_poliza {
		
        public list<Pagos_poliza> pagos_poliza;
		public Integer total_pagos_poliza;
         public list<Pagos_poliza> historia_pagos;
		public Integer total_historia;
		public list<Recibos> recibos;
		public Integer total_recibos;
	}

	public class Recibos {
		public Integer recibo;
		public String glosa_movimiento;
		public String fecha_inicio_vigencia;
		public String fecha_limite_pago;
		public String monto_cargo;
		public String monto_abonado;
		public Double saldo;
	}

	public Lista_pagos_poliza lista_pagos_poliza;

	
	public static CONS_PagosGenerales_JSON parse(String json) {
		return (CONS_PagosGenerales_JSON) System.JSON.deserialize(json, CONS_PagosGenerales_JSON.class);
	}
}