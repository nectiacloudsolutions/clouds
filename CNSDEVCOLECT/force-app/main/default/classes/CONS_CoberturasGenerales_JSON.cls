public class CONS_CoberturasGenerales_JSON {


	public class Lista_coberturas {
		public List<Coberturas> coberturas;
	}

	public class Modulos {
		public String glosa_modulo;
		public String capital_asegurado;
	}

		public Lista_coberturas lista_coberturas;
	

	public class Coberturas {
		public String glosa_cobertura;
		public String capital_asegurado;
		public String deducible_uf;
		public String deducible_pje;
		public String tasa_fija;
		public String tasa_variable;
		public String descuento;
		public String prima_neta;
		public List<Modulos> modulos;
	}

	
	public static CONS_CoberturasGenerales_JSON parse(String json) {
		return (CONS_CoberturasGenerales_JSON) System.JSON.deserialize(json, CONS_CoberturasGenerales_JSON.class);
	}

    
    
}