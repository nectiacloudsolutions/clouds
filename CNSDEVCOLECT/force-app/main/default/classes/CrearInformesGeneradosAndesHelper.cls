/**
 * @description       : 
 * @author            : ggonzroj@everis.com
 * @group             : 
 * @last modified on  : 10-27-2020
 * @last modified by  : ggonzroj@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   10-15-2020   ggonzroj@everis.com   Initial Version
**/
public without sharing class CrearInformesGeneradosAndesHelper {

    /**
     * getCSIntegracionesAndes GenerarInformesAndes - GetTokenInformesAndes
     */
    public static CS_IntegracionesAndes__c getCSIntegracionesAndes(String nameCustomSetting){
        CS_IntegracionesAndes__c url = CS_IntegracionesAndes__c.getValues(nameCustomSetting);
        return url;
    }

    public static CrearInformesGeneradosAndesHelper.TokenResponseWrp tokenResponseWrp {
        get{
            if (tokenResponseWrp == null) {
                tokenResponseWrp = new CrearInformesGeneradosAndesHelper.TokenResponseWrp();
            }
            return tokenResponseWrp;
        }
        set;
    }

    public static CrearInformesGeneradosAndesHelper.ResponsesAndesWrp responsesAndesWrp {
        get{
            if (responsesAndesWrp == null) {
                responsesAndesWrp = new CrearInformesGeneradosAndesHelper.ResponsesAndesWrp();
            }
            return responsesAndesWrp;
        }
        set;
    }

    public static CrearInformesGeneradosAndesHelper.ResponsesAndesErrorsWrp responsesAndesErrorsWrp {
        get{
            if (responsesAndesErrorsWrp == null) {
                responsesAndesErrorsWrp = new CrearInformesGeneradosAndesHelper.ResponsesAndesErrorsWrp();
            }
            return responsesAndesErrorsWrp;
        }
        set;
    }
    
    /**
     * Clase para serialización informes form Lead
     */
    public static String JSONEngine (Informe_de_Visita__c iInforme, Lead ilead) {
        dtoRequestSetParametros wrp = new dtoRequestSetParametros();

        // RecordTypeId
        Id iRecordTypeIdContacto = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CONTACTO_DEVELOPERNAME);
        Id iRecordTypeIdSocio = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_SOCIO_DEVELOPERNAME);
        Id iRecordTypeIdCliente = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CLIENTE_DEVELOPERNAME);
        Id iRecordTypeIdProveedor = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_PROVEEDORES_DEVELOPERNAME);

        // Datos Complementarios 
        Map<Id, List<Dato_Complementarios__c>> mpleadDCContacto = DatoComplementarioTriggerHelperB2b.getDatosComplementByleadAndRT(new Set<Id>{ilead.Id},iRecordTypeIdContacto);
        Map<Id, List<Dato_Complementarios__c>> mpleadDCSocio = DatoComplementarioTriggerHelperB2b.getDatosComplementByleadAndRT(new Set<Id>{ilead.Id},iRecordTypeIdSocio);
        Map<Id, List<Dato_Complementarios__c>> mpleadDCCliente = DatoComplementarioTriggerHelperB2b.getDatosComplementByleadAndRT(new Set<Id>{ilead.Id},iRecordTypeIdCliente);
        Map<Id, List<Dato_Complementarios__c>> mpleadDCProveedor = DatoComplementarioTriggerHelperB2b.getDatosComplementByleadAndRT(new Set<Id>{ilead.Id},iRecordTypeIdProveedor);

        List<Dato_Complementarios__c> lstDCContacto = mpleadDCContacto.get(ilead.Id);
        List<Dato_Complementarios__c> lstDCSocio = mpleadDCSocio.get(ilead.Id);
        List<Dato_Complementarios__c> lstDCCliente = mpleadDCCliente.get(ilead.Id);
        List<Dato_Complementarios__c> lstDCProveedor = mpleadDCProveedor.get(ilead.Id);

        // Linea Bancaria
        List<Linea_Bancaria__c> listlineaBancarias = LineaBancariaHelperB2b.getLineasBancariasByLeadId(new Set<Id>{ilead.Id});

        // Objects a serializar
        dtoValidarClienteAndes validarClienteAndes = new dtoValidarClienteAndes(); 
        validarClienteAndes.rutCliente = ilead.RUTEmpresa__c ;
        validarClienteAndes.razonSocial = ilead.Company;
        validarClienteAndes.rutEjecutivo = ilead.rut_ejecutivo_sales__c;

        dtoInsertarDatosVisita insertDatosVisita = new dtoInsertarDatosVisita();
        insertDatosVisita.fechaProgramadaVisita                 = String.valueOf(Date.newinstance(iInforme.FechaProgramadaVisita__c.year(), 
                                                                                                iInforme.FechaProgramadaVisita__c.month(), 
                                                                                                iInforme.FechaProgramadaVisita__c.day()));
        insertDatosVisita.moneda                                = ilead.Moneda__c;
        insertDatosVisita.direccionEmpresa                      = ilead.Direccion_Oficina__c ;
        insertDatosVisita.numeroEmpleado                        = ilead.NumberOfEmployees ;

        if (lstDCContacto != null && !lstDCContacto.isEmpty()) {
            for (Dato_Complementarios__c iDatoComplementarios : lstDCContacto) {
                if (iDatoComplementarios.Contacto_Principal__c) {
                    insertDatosVisita.contacto1      = iDatoComplementarios.Name;
                    insertDatosVisita.paterno1       = iDatoComplementarios.Apellido__c;
                    insertDatosVisita.emailContacto1 = iDatoComplementarios.Email__c;
                } else {
                    insertDatosVisita.contacto2      = iDatoComplementarios.Name;
                    insertDatosVisita.paterno2       = iDatoComplementarios.Apellido__c;
                    insertDatosVisita.emailContacto2 = iDatoComplementarios.Email__c;
                }
            }
        }
        
        insertDatosVisita.ventaAnual                            = String.valueOf(ilead.Venta_Anual__c);
        insertDatosVisita.deudaFinal                            = String.valueOf(0);
        insertDatosVisita.ebitda                                = String.valueOf(ilead.Ebitda__c);
        insertDatosVisita.utilidad                              = String.valueOf(ilead.Utilidad__c);
        insertDatosVisita.patrimonio                            = String.valueOf(0);
        insertDatosVisita.objetivoCaptacion                     = false;
        insertDatosVisita.objetivoCruce                         = false;
        insertDatosVisita.productosCuentaCorriente              = ilead.Cuenta_Corriente__c ;
        insertDatosVisita.productosCreditosComerciales          = ilead.Creditos_Comerciales__c ;
        insertDatosVisita.productosLeasing                      = ilead.Leasing__c ;
        insertDatosVisita.productosComex                        = ilead.Comex__c ;
        insertDatosVisita.productosBoletasGarantias             = ilead.Boletas_Garantia__c ;
        insertDatosVisita.productosCashManagement               = ilead.Cash_Management__c ;
        insertDatosVisita.productosFinanciamientoInmobiliario   = ilead.Financiamiento_Inmobiliario__c ;

        /**
         * Listado de dtosInsertarIntegranteVisita
         */
        List<dtosInsertarIntegranteVisita> listdtosInsertarIntegranteVisita = new List<dtosInsertarIntegranteVisita>();

        if (lstDCSocio != null && !lstDCSocio.isEmpty()) {
            for (Dato_Complementarios__c iDatoComplementariosSocio : lstDCSocio) {
                dtosInsertarIntegranteVisita visitaSocio = new dtosInsertarIntegranteVisita(); 
                visitaSocio.tipoIntegrante         = iDatoComplementariosSocio.Tipo__c.toUppercase() ;            
                visitaSocio.nombre                 = iDatoComplementariosSocio.Name +' '+ iDatoComplementariosSocio.Apellido__c;                    
                visitaSocio.rutIntegrante          = iDatoComplementariosSocio.Rut__c;            
                visitaSocio.porcentajeParticipacion = Integer.valueOf(iDatoComplementariosSocio.Participacion__c); 
                listdtosInsertarIntegranteVisita.add(visitaSocio);
                break;
            }
        }

        if (lstDCCliente != null && !lstDCCliente.isEmpty()) {
            for (Dato_Complementarios__c iDatoComplementariosCliente : lstDCCliente) {
                dtosInsertarIntegranteVisita visitaCliente = new dtosInsertarIntegranteVisita();
                visitaCliente.tipoIntegrante         = iDatoComplementariosCliente.Tipo__c.toUppercase() ;            
                visitaCliente.nombre                 = iDatoComplementariosCliente.Name +' '+ iDatoComplementariosCliente.Apellido__c;                    
                visitaCliente.rutIntegrante          = '';            
                visitaCliente.porcentajeParticipacion = 0; 
                listdtosInsertarIntegranteVisita.add(visitaCliente);
                break;
            }
        }

        if (lstDCProveedor != null && !lstDCProveedor.isEmpty()) {
            for (Dato_Complementarios__c iDatoComplementariosProveedor : lstDCProveedor) {
                dtosInsertarIntegranteVisita visitaProveedor = new dtosInsertarIntegranteVisita();
                visitaProveedor.tipoIntegrante         = iDatoComplementariosProveedor.Tipo__c.toUppercase() ;            
                visitaProveedor.nombre                 = iDatoComplementariosProveedor.Name +' '+ iDatoComplementariosProveedor.Apellido__c;                    
                visitaProveedor.rutIntegrante          = '';            
                visitaProveedor.porcentajeParticipacion = 0; 
                listdtosInsertarIntegranteVisita.add(visitaProveedor);
                break;
            }
        }

        /**
         * Listado de Linea Bancaria
         */
        List<dtosInsertarDatosBanco> listdtosInsertarDatosBanco = new List<dtosInsertarDatosBanco>();

        if (listlineaBancarias != null && !listlineaBancarias.isEmpty()) {
            for (Linea_Bancaria__c ilinea : listlineaBancarias) {
                dtosInsertarDatosBanco iBanco = new dtosInsertarDatosBanco();
                iBanco.nombreBanco     =  ilinea.Banco__c ;                                 
                iBanco.montoLinea      =  Integer.valueOf(ilinea.Monto_Aprobado__c);        
                iBanco.montoUtilizado  =  Integer.valueOf(ilinea.Monto_Utilizado__c);     
                iBanco.codigoMoneda    =  '' ;                                             
                listdtosInsertarDatosBanco.add(iBanco);
            }
        }

        /**
         * serialize description
         */
        dtoRequestSetParametros requestSetParametrosWrp = new dtoRequestSetParametros();
        requestSetParametrosWrp.dtoValidarClienteAndes = validarClienteAndes;
        requestSetParametrosWrp.dtoInsertarDatosVisita = insertDatosVisita;
        requestSetParametrosWrp.listdtosInsertarIntegranteVisita = listdtosInsertarIntegranteVisita;
        requestSetParametrosWrp.listdtosInsertarDatosBanco = listdtosInsertarDatosBanco;

        String result = JSON.serialize(requestSetParametrosWrp);
        return result;
    }

    public static String JSONBodyToken (String userID) {
        TokenBodyWrp itoken = new TokenBodyWrp();
        itoken.userID = userID;
        String tokenBody = JSON.serialize(itoken);
        return tokenBody;
    }

    public static void getTokensAndes(String body){
        CS_IntegracionesAndes__c apiOAuth = CrearInformesGeneradosAndesHelper.getCSIntegracionesAndes('GetTokenInformesAndes');
        Map<String, String> headers = new Map<String, String>();

        headers.put('Content-Type', apiOAuth.ContentType__c);
        headers.put('Cache-Control',apiOAuth.Cache_Control__c);
        headers.put('codigoAplicacion',apiOAuth.CodigoAplicacion__c);
        headers.put('empresaAplicacion',apiOAuth.EmpresaAplicacion__c);
        headers.put('ipCliente',apiOAuth.IpCliente__c);
        headers.put('codigoCanal',apiOAuth.CodigoCanal__c);
        headers.put('modalidad',apiOAuth.Modalidad__c);

        String endpoint     =   apiOAuth.URLApi__c + apiOAuth.EndPoint__c;
        String method 		=   apiOAuth.Method__c;

        CalloutsHttpRequest httpReq = new CalloutsHttpRequest(
                endpoint, 
                method, 
                new Map<String,String>(), 
                headers, 
                body );
        
        HttpResponse response = httpReq.sendRequest();

        if (!Test.isRunningTest()) {
            tokenResponseWrp = (TokenResponseWrp)System.JSON.deserialize(response.getBody(), TokenResponseWrp.class);
        } else {
            String resposeBodyTmp = '{"dtoResponseCodigosEstado":{"codigo":"0","mensaje":"OK","descripcion":"OK"},"respuestaGeneraToken":{"token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyMjM0ODgwM0siLCJhdWQiOiIxMTYiLCJpc3MiOiIyIiwiZXhwIjoxNjAyNzE0MjE5LCJqdGkiOiJhMXQ1TlRoc1RDazNieVJmTVhaS1ZtOVNOVlZvTzFaRlVYRWpVV1ZPTjJGVFZqSjBkWHd0Y2x3cE5FRitOMWRiZm41TWVWNTRReklrTnlnNUp5OVJSVHBHZWxoaUxtQTdUejFVS2pSNlBHMU1LV005VlhZNmZpaHZlR2g4VDFGckswRldYMEFwSjNCR04xc3FjUzFNTEVaUVB6WXVVV2xHWDB4MlhYazVYU2M9In0.W1JYoJtPl3X5948zQe2MQY03wY87hJFOW6k0Nm7pHCo1gvyGeQwmF7wcV2EMRElp-DxJNi7vWI6ZW7CIeHoAAQ","requestID":"a1t5NThsTCk3byRfMXZKVm9SNVVoO1ZFUXEjUWVON2FTVjJ0dXwtclwpNEF+N1dbfn5MeV54QzIkNyg5Jy9RRTpGelhiLmA7Tz1UKjR6PG1MKWM9VXY6fihveGh8T1FrK0FWX0ApJ3BGN1sqcS1MLEZQPzYuUWlGX0x2XXk5XSc=","minutosRestantes":180}}';
            tokenResponseWrp = (TokenResponseWrp)System.JSON.deserialize(resposeBodyTmp, TokenResponseWrp.class);
        }
    }

    public static Map<String,Object> generateInformesAndes (String body, String rutEjecutivo){
        CS_IntegracionesAndes__c apiOAuth = CrearInformesGeneradosAndesHelper.getCSIntegracionesAndes('GenerarInformesAndes');
        Map<String, String> headers = new Map<String, String>();
        Map<String,Object> mapObj = new Map<String,Object>();   
        HttpResponse res = new HttpResponse();
        respuestaGeneraToken iRespuestaGeneraToken = tokenResponseWrp.respuestaGeneraToken;

        headers.put('Content-Type', apiOAuth.ContentType__c);
        headers.put('Cache-Control',apiOAuth.Cache_Control__c);
        headers.put('codigoAplicacion',apiOAuth.CodigoAplicacion__c);
        headers.put('clientId',rutEjecutivo);
        headers.put('empresaAplicacion',apiOAuth.EmpresaAplicacion__c);
        headers.put('ipCliente',apiOAuth.IpCliente__c);
        headers.put('codigoCanal',apiOAuth.CodigoCanal__c);
        headers.put('modalidad',apiOAuth.Modalidad__c);
        headers.put('requestID', iRespuestaGeneraToken.requestID);
        headers.put('Token-Authorization', iRespuestaGeneraToken.token);

        String endpoint     =   apiOAuth.URLApi__c + apiOAuth.EndPoint__c;
        String method 		=   apiOAuth.Method__c;

        CalloutsHttpRequest httpReq = new CalloutsHttpRequest(
                endpoint, 
                method, 
                new Map<String,String>(), 
                headers, 
                body );
        
        res = httpReq.sendRequest();

        if (!Test.isRunningTest()) {
            responsesAndesWrp = (ResponsesAndesWrp)System.JSON.deserialize(res.getBody(), ResponsesAndesWrp.class);
            mapObj = parseAsMap(res);
        } else {
            String resposeBodyTmp = '{"dtoResponseCodigosEstadoHttp":{"codigo":"200","mensaje":"OK","descripcion":"OK"},"dtoResponseSetResultados":{"codigoSalida":1,"mensajeSalida":"Se ha agregado de forma exitosa una visita con el siguiente identificador: 18293"}}';
            responsesAndesWrp = (ResponsesAndesWrp)System.JSON.deserialize(resposeBodyTmp, ResponsesAndesWrp.class);
            
            mapObj = (Map<String, Object>) JSON.deserializeUntyped(resposeBodyTmp);
            mapObj.put('codeAPI',String.valueOf(200));
            mapObj.put('msjAPI','OK');
        }

        return mapObj;
    }
    
    private static Map<String, Object> parseAsMap(HttpResponse response) {
        Map<String, Object> mapReturn = new Map<String, Object>();
        mapReturn = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        mapReturn.put('codeAPI',String.valueOf(response.getStatusCode()));
        mapReturn.put('msjAPI',response.getStatus());
        return mapReturn;
    }

    public static Map<String,Object> respMapErrors(String codeAPI, String msjAPI) {
        Map<String, Object> mapReturn = new Map<String, Object>();
        mapReturn.put('codeAPI',codeAPI);
        mapReturn.put('msjAPI',msjAPI);
        return mapReturn;
    }

    /**
     * Clases para serialización JSON Request to ANDES
     */
    public class dtoRequestSetParametros {
        public dtoValidarClienteAndes dtoValidarClienteAndes;
        public dtoInsertarDatosVisita dtoInsertarDatosVisita;
        public List<dtosInsertarIntegranteVisita> listdtosInsertarIntegranteVisita;
        public List<dtosInsertarDatosBanco> listdtosInsertarDatosBanco;
    }

    public class dtoValidarClienteAndes {
        public String rutCliente;
        public String razonSocial;
        public String rutEjecutivo;
    }

    public class dtoInsertarDatosVisita {
        public String fechaProgramadaVisita;
        public String moneda;                           
        public String direccionEmpresa;                         
        public Integer numeroEmpleado;                         
        public String contacto1;                          
        public String paterno1;                          
        public String emailContacto1;                       
        public String contacto2;                          
        public String paterno2;                          
        public String emailContacto2;                         
        public String ventaAnual;                         
        public String deudaFinal;                        
        public String ebitda;                        
        public String utilidad;                   
        public String patrimonio;                    
        public Boolean objetivoCaptacion;                       
        public Boolean objetivoCruce;                          
        public Boolean productosCuentaCorriente;                      
        public Boolean productosCreditosComerciales;                        
        public Boolean productosLeasing;                        
        public Boolean productosComex;                         
        public Boolean productosBoletasGarantias;                      
        public Boolean productosCashManagement;                          
        public Boolean productosFinanciamientoInmobiliario;                          
    }

    public class dtosInsertarIntegranteVisita {
        public String tipoIntegrante;            
        public String nombre;                    
        public String rutIntegrante;            
        public Integer porcentajeParticipacion;  
    }

    public class dtosInsertarDatosBanco{
        public String nombreBanco;
        public Integer montoLinea;
        public Integer montoUtilizado;
        public String codigoMoneda;
    }

    /**
     * Clases para deserialización JSON Responses 200 desde ANDES
     */
    public class ResponsesAndesWrp  {
        public dtoResponseCodigosEstadoHttp dtoResponseCodigosEstadoHttp;
        public dtoResponseSetResultados dtoResponseSetResultados;
    }

    public class dtoResponseCodigosEstadoHttp  {
        public String codigo;
        public String mensaje;
        public String descripcion;
    }

    public class dtoResponseSetResultados  {
        public Integer codigoSalida;
        public String mensajeSalida;
    }

    /**
     * Clase para serialización JSON request body
     * Token de autorización
     */
    public class TokenBodyWrp {
        public String userID;
    }

    public class TokenResponseWrp {
        public dtoResponseCodigosEstado dtoResponseCodigosEstado;
        public respuestaGeneraToken respuestaGeneraToken;
    }

    public class dtoResponseCodigosEstado{
        public String codigo;
        public String mensaje;
        public String descripcion;
    }

    public class respuestaGeneraToken{
        public String token;
        public String requestID;
        public String minutosRestantes;
    }    


    /**
     * Clases para deserialización JSON Responses != 200 desde ANDES
     */
    public class ResponsesAndesErrorsWrp  {
        public dtoResponseCodigosEstadoHttp dtoResponseCodigosEstadoHttp;
        public dtoResponseSetParametros dtoResponseSetParametros;
    }

    public class dtoResponseSetParametros  {}

    /**
     * Clase para serialización informes form Account
     */
    public static String JSONEngineFromAccount (Informe_de_Visita__c iInforme, Account iAccount) {
        dtoRequestSetParametros wrp = new dtoRequestSetParametros();

        // Utiles
        Id iRecordTypeIdContacto = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CONTACTO_DEVELOPERNAME);
        Id iRecordTypeIdSocio = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_SOCIO_DEVELOPERNAME);
        Id iRecordTypeIdCliente = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_CLIENTE_DEVELOPERNAME);
        Id iRecordTypeIdProveedor = DatoComplementarioTriggerHelperB2b.getRecordTypeId(DatoComplementarioTriggerHelperB2b.DC_RTYPE_PROVEEDORES_DEVELOPERNAME);

        // Datos Complementarios 
        Map<Id, List<Dato_Complementarios__c>> mpleadDCSocio = DatoComplementarioTriggerHelperB2b.getDatosComplementByAccountAndRT(new Set<Id>{iAccount.Id},iRecordTypeIdSocio);
        Map<Id, List<Dato_Complementarios__c>> mpleadDCCliente = DatoComplementarioTriggerHelperB2b.getDatosComplementByAccountAndRT(new Set<Id>{iAccount.Id},iRecordTypeIdCliente);
        Map<Id, List<Dato_Complementarios__c>> mpleadDCProveedor = DatoComplementarioTriggerHelperB2b.getDatosComplementByAccountAndRT(new Set<Id>{iAccount.Id},iRecordTypeIdProveedor);

        List<Dato_Complementarios__c> lstDCSocio = mpleadDCSocio.get(iAccount.Id);
        List<Dato_Complementarios__c> lstDCCliente = mpleadDCCliente.get(iAccount.Id);
        List<Dato_Complementarios__c> lstDCProveedor = mpleadDCProveedor.get(iAccount.Id);

        // Linea Bancaria
        //List<Linea_Bancaria__c> listlineaBancarias = LineaBancariaHelperB2b.getLineasBancariasByLeadId(new Set<Id>{iAccount.Id});
        Map<Id, List<Linea_Bancaria__c>> mpAcclineaBancarias = LineaBancariaHelperB2b.getlineasBancariaByAccount(new Set<Id>{iAccount.Id});
        List<Linea_Bancaria__c> listlineaBancarias = mpAcclineaBancarias.get(iAccount.Id);

        // Objects a serializar
        dtoValidarClienteAndes validarClienteAndes = new dtoValidarClienteAndes(); 
        validarClienteAndes.rutCliente = iAccount.RUT__c;
        validarClienteAndes.razonSocial = iAccount.Name;
        validarClienteAndes.rutEjecutivo = iAccount.Rut_Ejecutivo_Banco__c;

        dtoInsertarDatosVisita insertDatosVisita = new dtoInsertarDatosVisita();
        insertDatosVisita.fechaProgramadaVisita                 = String.valueOf(Date.newinstance(iInforme.FechaProgramadaVisita__c.year(), 
                                                                                                iInforme.FechaProgramadaVisita__c.month(), 
                                                                                                iInforme.FechaProgramadaVisita__c.day()));
        insertDatosVisita.moneda                                = iAccount.Moneda__c;
        insertDatosVisita.direccionEmpresa                      = iAccount.Calle_Nectia__c ;
        insertDatosVisita.numeroEmpleado                        = iAccount.NumberOfEmployees ;

        if (iAccount.Contacts != null) {
            for (Contact iContact : iAccount.Contacts) {
                if ( iContact.Contacto_Principal__c == true ) {
                    insertDatosVisita.contacto1      = iContact.FirstName;
                    insertDatosVisita.paterno1       = iContact.LastName;
                    insertDatosVisita.emailContacto1 = iContact.Email;
                } else {
                    insertDatosVisita.contacto2      = iContact.FirstName;
                    insertDatosVisita.paterno2       = iContact.LastName;
                    insertDatosVisita.emailContacto2 = iContact.Email;
                }
            }
        } 
        
        insertDatosVisita.ventaAnual                            = String.valueOf(iAccount.Venta_Anual__c);
        insertDatosVisita.deudaFinal                            = String.valueOf(0);
        insertDatosVisita.ebitda                                = String.valueOf(iAccount.Ebitda__c);
        insertDatosVisita.utilidad                              = String.valueOf(iAccount.Utilidad__c);
        insertDatosVisita.patrimonio                            = String.valueOf(iAccount.Patrimonio__c);
        insertDatosVisita.objetivoCaptacion                     = false;
        insertDatosVisita.objetivoCruce                         = false;
        insertDatosVisita.productosCuentaCorriente              = iAccount.Cuenta_Corriente__c ;
        insertDatosVisita.productosCreditosComerciales          = iAccount.Creditos_Comerciales__c ;
        insertDatosVisita.productosLeasing                      = iAccount.Leasing__c ;
        insertDatosVisita.productosComex                        = iAccount.Comex__c ;
        insertDatosVisita.productosBoletasGarantias             = iAccount.Boletas_Garantia__c ;
        insertDatosVisita.productosCashManagement               = iAccount.Cash_Management__c ;
        insertDatosVisita.productosFinanciamientoInmobiliario   = iAccount.Financiamiento_Inmobiliario__c ;

        /**
         * Listado de dtosInsertarIntegranteVisita
         */
        List<dtosInsertarIntegranteVisita> listdtosInsertarIntegranteVisita = new List<dtosInsertarIntegranteVisita>();

        if (lstDCSocio != null && !lstDCSocio.isEmpty()) {
            for (Dato_Complementarios__c iDatoComplementariosSocio : lstDCSocio) {
                dtosInsertarIntegranteVisita visitaSocio = new dtosInsertarIntegranteVisita(); 
                visitaSocio.tipoIntegrante         = iDatoComplementariosSocio.Tipo__c.toUppercase() ;            
                visitaSocio.nombre                 = iDatoComplementariosSocio.Name +' '+ iDatoComplementariosSocio.Apellido__c;                    
                visitaSocio.rutIntegrante          = iDatoComplementariosSocio.Rut__c;            
                visitaSocio.porcentajeParticipacion = Integer.valueOf(iDatoComplementariosSocio.Participacion__c); 
                listdtosInsertarIntegranteVisita.add(visitaSocio);
                break;
            }
        }

        if (lstDCCliente != null && !lstDCCliente.isEmpty()) {
            for (Dato_Complementarios__c iDatoComplementariosCliente : lstDCCliente) {
                dtosInsertarIntegranteVisita visitaCliente = new dtosInsertarIntegranteVisita();
                visitaCliente.tipoIntegrante         = iDatoComplementariosCliente.Tipo__c.toUppercase() ;            
                visitaCliente.nombre                 = iDatoComplementariosCliente.Name +' '+ iDatoComplementariosCliente.Apellido__c;                    
                visitaCliente.rutIntegrante          = '';            
                visitaCliente.porcentajeParticipacion = 0; 
                listdtosInsertarIntegranteVisita.add(visitaCliente);
                break;
            }
        }

        if (lstDCProveedor != null && !lstDCProveedor.isEmpty()) {
            for (Dato_Complementarios__c iDatoComplementariosProveedor : lstDCProveedor) {
                dtosInsertarIntegranteVisita visitaProveedor = new dtosInsertarIntegranteVisita();
                visitaProveedor.tipoIntegrante         = iDatoComplementariosProveedor.Tipo__c.toUppercase() ;            
                visitaProveedor.nombre                 = iDatoComplementariosProveedor.Name +' '+ iDatoComplementariosProveedor.Apellido__c;                    
                visitaProveedor.rutIntegrante          = '';            
                visitaProveedor.porcentajeParticipacion = 0; 
                listdtosInsertarIntegranteVisita.add(visitaProveedor);
                break;
            }
        }

        /**
         * Listado de Linea Bancaria
         */
        List<dtosInsertarDatosBanco> listdtosInsertarDatosBanco = new List<dtosInsertarDatosBanco>();

        if (listlineaBancarias != null && !listlineaBancarias.isEmpty()) {
            for (Linea_Bancaria__c ilinea : listlineaBancarias) {
                dtosInsertarDatosBanco iBanco = new dtosInsertarDatosBanco();
                iBanco.nombreBanco     =  ilinea.Banco__c ;                                 // :"Banco Consorcio",
                iBanco.montoLinea      =  Integer.valueOf(ilinea.Monto_Aprobado__c);        // :987654321.0,
                iBanco.montoUtilizado  =  Integer.valueOf(ilinea.Monto_Utilizado__c);       // :98765.0,
                iBanco.codigoMoneda    =  '' ;                                              // :"CLP"
                listdtosInsertarDatosBanco.add(iBanco);
            }
        }

        /**
         * serialize description
         */
        dtoRequestSetParametros requestSetParametrosWrp = new dtoRequestSetParametros();
        requestSetParametrosWrp.dtoValidarClienteAndes = validarClienteAndes;
        requestSetParametrosWrp.dtoInsertarDatosVisita = insertDatosVisita;
        requestSetParametrosWrp.listdtosInsertarIntegranteVisita = listdtosInsertarIntegranteVisita;
        requestSetParametrosWrp.listdtosInsertarDatosBanco = listdtosInsertarDatosBanco;

        String result = JSON.serialize(requestSetParametrosWrp);
        return result;
    }




}