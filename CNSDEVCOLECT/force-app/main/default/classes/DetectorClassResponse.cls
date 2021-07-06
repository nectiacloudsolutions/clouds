/*********************************************************************************************************
@Author       zsuanaza@everis.com
@name         DetectorClassResponse
@CreateDate   15/11/2019
@Description  response to analytics after Questions where answered in needs detector 
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
15/11/2019                    zsuanaza@everis.com           W-XXXXX - INTEGRATION
**********************************************************************************************************/
public class DetectorClassResponse {
    
    @AuraEnabled public String codigoFormulario;
    @AuraEnabled public String rut;
    @AuraEnabled public String rutEjecutivo;
    @AuraEnabled public List<respuesta> respuestas;
    
    public class Respuesta{
        @AuraEnabled public String idPregunta;
        @AuraEnabled public String idRespuesta;
    }
}