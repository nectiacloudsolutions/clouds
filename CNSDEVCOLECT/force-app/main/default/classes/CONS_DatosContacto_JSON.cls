public class CONS_DatosContacto_JSON {

    public class OFono {
        public String sTipotelefono;
        public String sCodarea;
        public String nNumeroTelefono;
        public String sExtension1;
        public String sExtension2;
    }

    public class ODireccion {
        public String sCalle;
        public String nNumero;
        public String nPiso;
        public String sDepartamento;
        public String sVillapoblacion;
        public String sCasilla;
        public String sCodigopostal;
        public String sComuna;
    }

    public class DatosContacto {
        public String sRut;
        public String sUsuario;
        public OCorreo oCorreo;
        public OFono oFono;
        public ODireccion oDireccion;
        public Integer nCase_Id;
    }

    public class OCorreo {
        public String sMailPrincipal;
    }

    public class DatosEmail {
        public Integer nCelular;
        public Integer nTelefono;
        public Integer nNumSolicitud;
        public Integer nNegocio;
        public String sLinNegocio;
        public String sPlantilla;
        public String sNombreCliente;
        public String sEmail;
        public String sFechaRecepcion;
        public String sEmail2;
        public String sDireccion;
    }

    public DatosContacto datosContacto;
    public DatosEmail datosEmail;

    
    public static CONS_DatosContacto_JSON parse(String json) {
        return (CONS_DatosContacto_JSON) System.JSON.deserialize(json, CONS_DatosContacto_JSON.class);
    }
}