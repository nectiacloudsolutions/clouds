/**
 * @description       : 
 * @author            : eayalcor@everis.com
 * @group             : 
 * @last modified on  : 07-08-2020
 * @last modified by  : eayalcor@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   07-06-2020   eayalcor@everis.com   Initial Version
**/
public class ResponseDTOAlfresco {

    @AuraEnabled public DtoResponseCodigosEstadoHttp dtoResponseCodigosEstadoHttp;
    @AuraEnabled public DtoResponseSetParametros dtoResponseSetParametros;
    @AuraEnabled public SalidaAlfresco salidaAlfresco;
    @AuraEnabled public SalidaDocAlfresco salidaDocAlfresco;

    public class SalidaAlfresco {
        @AuraEnabled public String codigo;
        @AuraEnabled public String idAlfresco;
        @AuraEnabled public String mensaje;
    }

    public class SalidaDocAlfresco {
        @AuraEnabled public String codigo;
        @AuraEnabled public String idAlfresco;
        @AuraEnabled public String mensaje;
        @AuraEnabled public String bytes;
        @AuraEnabled public String contentType;
        @AuraEnabled public String nombreArchivo;
    }

    public class DtoResponseCodigosEstadoHttp {
        @AuraEnabled public String codigo;
        @AuraEnabled public String mensaje;
        @AuraEnabled public String descripcion;
    }

    public class DtoResponseSetParametros {
        @AuraEnabled public String codigoError;
        @AuraEnabled public String msjError;
    }
}