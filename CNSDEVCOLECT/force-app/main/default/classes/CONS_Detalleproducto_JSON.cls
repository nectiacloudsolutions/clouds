public class CONS_Detalleproducto_JSON {


	public class Recaudacion {
		public String via_pago;
		public Integer fecha_pago;
		public String tipo_tarjeta;
		public String total_prima;
		public String banco;
		public String expiracion_tarjeta_credito;
		public String cuotas_pactadas;
	}

	public Detalle_producto detalle_producto;

	public class Detalle_producto {
		public Cliente cliente;
		public Vigencia vigencia;
		public Materia_asegurada materia_asegurada;
		public Recaudacion recaudacion;
		public Roles roles;
		public Intermediario intermediario;
	}

	public class Intermediario {
		public String nombre_intermediario;
		public String rut_intermediario;
		public String agencia;
		public String sucursal;
		public String regional;
		public String canal;
		public String telefono;
		public String es_corredor;
	}

	public class Vigencia {
		public String emision;
		public String desde;
		public String hasta;
		public String fecha_anulacion;
		public String motivo_cancelacion;
	}

	public class Materia_asegurada {
		public String marca;
		public String anio;
		public String modelo;
		public String patente;
		public String direccion_riesgo;
	}

	public class Roles {
		public String nombre_contratante;
		public String rut_contratante;
		public String nombre_asegurado;
		public String rut_asegurado;
		public String nombre_pagador;
		public String rut_pagador;
	}

	public class Cliente {
		public String nombre_contratante;
		public String rut_contratante;
		public String familia;
		public String modulo;
		public String linea;
		public Integer nro_producto;
		public String estado;
	}

	
	public static CONS_Detalleproducto_JSON parse(String json) {
		return (CONS_Detalleproducto_JSON) System.JSON.deserialize(json, CONS_Detalleproducto_JSON.class);
	}

}