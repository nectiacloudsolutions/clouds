global class CONS_EstructuraClienteBanco_JSON {
   
        public string Nombre;
        public string Tipo;
        public string id_Tipo;
        public string Apellido_paterno;
        public string Apellido_materno;
        public string RUT;
        public boolean No_llamar;
        public boolean No_recibirfax;
        public boolean No_recibir_correo_electronicos;    
        public boolean Consentimiento;    
        public String banca;
        public String id_banca;
        public String Telefono; 
        public String Correoelectronico;
       /* public list<producto> Productos;
        public list<contac> Contacto;
    
    public class producto{
         public String Id;
    }
    public class contac{
         public String Nombre;
         public String Apellido;
         public String Correoelectronicocontacto;
    }*/
    public static CONS_EstructuraClienteBanco_JSON parse(String json) {
        system.debug('json'+json);
        return (CONS_EstructuraClienteBanco_JSON) System.JSON.deserialize(json, CONS_EstructuraClienteBanco_JSON.class);
    }
    
}