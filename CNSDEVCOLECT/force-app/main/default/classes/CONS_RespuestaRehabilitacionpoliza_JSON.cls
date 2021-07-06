public class CONS_RespuestaRehabilitacionpoliza_JSON {

		public String httpCode;
		public String httpMessage;
		public String moreInformation;


	
	public static CONS_RespuestaRehabilitacionpoliza_JSON parse(String json) {
		return (CONS_RespuestaRehabilitacionpoliza_JSON) System.JSON.deserialize(json, CONS_RespuestaRehabilitacionpoliza_JSON.class);
	}
}