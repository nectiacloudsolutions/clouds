public class CONS_RescateSolicitud_JSON {
    
    public DatosRescate datosRescate;
    public DatosAlarma datosAlarma;
    public DatosEmail datosEmail;
    
    
    public class SARRAYACCOUNT {
        public Integer nOrigin;
        public Double namount;
    }
    
    public class DatosAlarma {
        public String nNumCaso;
        public String sProductId;
        public String nPoliza;
        public String sDescr;
        public String sFechaIngreso;
        public String sFechaCierre;
        public String sEstado;
        public String sMontoTrasp;
        public String sInstitTrasp;
        public String sRutIntermediario;
        public String sDetalle;
    }
    
    public class DatosRescate {
        public Integer nBranch;
        public Integer nProduct;
        public Integer nPolicy;
        public String deffecdate;
        public String sSurrType;
        public Integer nPayWay;
        public String nAgency;
        public String nUsercode;
        public String sRequestTy;
        public String nBankCode;
        public String sAccount;
        public String ntypAcc;
        public Integer nSurrReas;
        public String sClientDest;
        public Integer nDocTransfer;
        public Integer nCase;
        public double nSurrAmount;
        public List<SARRAYACCOUNT> SARRAYACCOUNT;
        
    }
    
    public class DatosEmail {
        public String nCelular;
        public String nNegocio;
        public String nNumpoliza;
        public String nNumsolicitud;
        public integer nMontoRescate;
        public String nNumRescate;
        public String sLinNegocio;
        public String sNombreCliente;
        public String sEmail;
        public String sFechaRecepcion;
        public String sNombcaso;
        public String sNombreProducto;
        public String sDoc_Adjunto;
        public String sTipoPago;
        public String sBancoRescate;
        public String sDestinoChequeRescate;
        public String sCuentaDepositoRescate;
        public String sPlantilla;
        public String sNombreSucursal;
    }
    
    
    public static CONS_RescateSolicitud_JSON parse(String json) {
        return (CONS_RescateSolicitud_JSON) System.JSON.deserialize(json, CONS_RescateSolicitud_JSON.class);
    }
}