/**
 * @description       : 
 * @author            : eayalcor@everis.com
 * @group             : 
 * @last modified on  : 07-06-2020
 * @last modified by  : eayalcor@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   07-06-2020   eayalcor@everis.com   Initial Version
**/
public class RequestDTOAlfresco {

    public class SubirArchivo {
        public Entrada entrada;
    }

    public class DtoRequestSetParametros {
        public SubirArchivo subirArchivo;
        public ConsultaDoc consultaDoc;
    }

    public DtoRequestSetParametros dtoRequestSetParametros;

    public class Entrada {
        public String bytes;
        public String codigoProducto;
        public String contentType;
        public String fecha;
        public String nombreArchivo;
        public String numeroProducto;
        public String rutCliente;
    }
    
    public class ConsultaDoc {
        public String idAlfresco;
        public String rutCliente;
    }
}