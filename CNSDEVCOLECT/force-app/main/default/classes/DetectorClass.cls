public class DetectorClass {

    public Formulario formulario;

    public class Formulario{
        @AuraEnabled public String code;
        @AuraEnabled public String message;
        @AuraEnabled public String nombreFormulario;
        @AuraEnabled public List<Pregunta> preguntas;
    }
    
    public class Pregunta{
        @AuraEnabled public String tipoSeleccionRespuesta;
        @AuraEnabled public String idPregunta;
        @AuraEnabled public String descripcionPregunta;
        @AuraEnabled public Boolean visible;
        @AuraEnabled public String helpText;
       	@AuraEnabled public List<Respuesta> respuestas;
    }
    
    public class Respuesta{
        @AuraEnabled public String respuesta;
		@AuraEnabled public String descripcionRespuesta;
		@AuraEnabled public String idRespuesta;
        @AuraEnabled public String idPreguntaHija;
    }
}