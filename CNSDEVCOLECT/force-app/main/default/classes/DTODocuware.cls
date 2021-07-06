/**
 * @description       : 
 * @author            : eayalcor@everis.com
 * @group             : 
 * @last modified on  : 08-10-2020
 * @last modified by  : eayalcor@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-05-2020   eayalcor@everis.com   Initial Version
**/
public with sharing class DTODocuware {

/**
========================================================================================================================
----------------------------------------------------GET DOC DOCUWARE-----------------------------------------------------
========================================================================================================================
*/

    public class RequestGetDocuware{
        public String archivador;
        public String xmlFiltros;
    }

    public class ResponseGetDocuware{
        @AuraEnabled public String codigo;
        @AuraEnabled public String mensaje;
        @AuraEnabled public String mensajeServicio;
        @AuraEnabled public String codigoServicio;
        @AuraEnabled public Documents documents;
    }

    public class DocumentResult {
		@AuraEnabled public String extension;
		@AuraEnabled public String contenido;
		@AuraEnabled public String nombre;
		@AuraEnabled public String contentType;
	}

	public class Documents {
		@AuraEnabled public List<DocumentResult> documentResult;
    }
    
/**
========================================================================================================================
----------------------------------------------------UPLOAD DOCUWARE-----------------------------------------------------
========================================================================================================================
*/

    public class RequestUploadDocuware{
        public String archivador;
        public String contenido;
        public String xmlIndices;
        public String extension;
    }

    public class ResponseUploadDocuware{
        public Integer dwDocId;
        public String mensajeServicio;
        public String codigoServicio;
        public String mensaje;
        public String codigo;
    }
}