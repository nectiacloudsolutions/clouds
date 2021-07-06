public class CONS_SiniestrosVida_JSON {
    
    public class Lista_siniestros {
        public List<Siniestros> siniestros;
        public Integer total_siniestros;
        public Integer total_pagado;
    }
    
    public class Siniestros {
        
        public integer numero_siniestro;         
        public integer numero_poliza;         
        public string nombre_asegurado;          
        public string glosa_corta_plan ;        
        public string glosa_plan;        
        public string glosa_situacion;       
        public integer total_pagado;         
        public integer no_reportado;          
    }
    
    
    public Lista_siniestros lista_siniestros;
    
    
    
    public static CONS_SiniestrosVida_JSON parse(String json) {
        return (CONS_SiniestrosVida_JSON) System.JSON.deserialize(json, CONS_SiniestrosVida_JSON.class);
    }
}