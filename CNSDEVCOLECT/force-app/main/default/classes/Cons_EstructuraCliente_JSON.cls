global class Cons_EstructuraCliente_JSON {
    
    
    public String entidad;//17
    public List<Cliente> Clientes;
    
    
    public class Cliente {
        public String Tipo;
        public String Agente;//20
        public String ClasificacionRiesgo;
        public String CodigodeAgente;//19
        public Integer Consentimiento;
        public String EstadoCivil;//10
        public Integer FATCA;
        public String Genero;//11
        public Integer IDinterno;
        public String Nacionalidad;//8
        public Integer NCG380;//23
        public String NivelEducacional;
        public String Ocupacion;
        public Integer PEP;//24
        public String PlantilladeComision;//21
        public String PrimerApellido;
        public String Profesion;//13
        public String Regimenconyugal;//12
        public String RUT;//3
        public String Segmento;//4
        public String SegundoApellido;//2
        public Integer Simultaneas;//22
        public String Subestado;//18
        public String TelefonoComercial;
        public String TelefonoOtro;//6
        public Integer US_PersonEntity;//25
        public String Correoelectronico;//7
        public String Movil;
        public String Fechadenacimiento;//9
        public String Nombrecompleto;//1
        public String Nombredelacuenta;
        public String Telefono;//5
        public String Telefonoparticular;
        public String Estado;//17
        public String Fax;
        //***campos agregados*****//
        public String cargo;//14
        public String razonsocialempleador;//15
        public String renta;//16
        public Integer crs;//26
        public Integer ID;//27
        public String Direccion;//28
        public String Ciudad;//29
        public String Region;//30
        public String Pais;//31
        public String perfilinv;
        public string  fechaincorporacion;
        public List<producto> productos;
        public List<contacto> contactos;
    }
    public class producto {

        public string producto;
        public string tipo;
        public string codigo;
        public string estado;
        public string fecha;
        public string id;
        public string secuencia;
    }
   
     public class contacto {

        public string nombrecontacto;
        public string apellidocontacto;
        public string telefonomovil;
        public string correocontacto;
        public string Cargo;
        public string Genero;
        public string Rutcontacto;
       
        
    }
    
    
    public static Cons_EstructuraCliente_JSON parse(String json) {
        system.debug('json'+json);
        return (Cons_EstructuraCliente_JSON) System.JSON.deserialize(json, Cons_EstructuraCliente_JSON.class);
    }
}