public class CONS_RespuestaConsultaViaPago_JSON {
    
    public Integer codigoViaPago;
    public Integer diaPago;
    public Integer codigoBanco;
    public Long numeroCuenta;
    public String mandatoPoliza;
    public Integer codigoTipoCuenta;
    public Integer codigoTipoTarjeta;
    public String fechaExpiracionTarjeta;
    public String fechaVigenciaTarjeta;
    public Integer frecuenciaPagos;
    public Integer codigoEmpleador;
    public Integer numeroCalle;
    public Integer codigoComuna;
    public Integer codigoCiudad;
    public Integer codigo;
    public String rutPagador;
    public String digitoPagador;
    public String nombrePagador;
    public String apellidoPPagador;
    public String apellidoMPagador;
    public String fechaNaciminetoPagador;
    public String sexoPagador;
    public String rutEmpleador;
    public String nombreEmpleador;
    public String direccionCalle;
    
    
    
    public static CONS_RespuestaConsultaViaPago_JSON parse(String json) {
        return (CONS_RespuestaConsultaViaPago_JSON) System.JSON.deserialize(json, CONS_RespuestaConsultaViaPago_JSON.class);
    }
}