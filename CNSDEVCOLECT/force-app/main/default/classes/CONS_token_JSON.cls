public class CONS_token_JSON {



		public String access_token;
		public Integer expires_in;
		public Integer refresh_expires_in;
		public String refresh_token;
		public String token_type;
		public String id_token;
		public Integer policy;
		public String session_state;
	

	
	public static CONS_token_JSON parse(String json) {
		return (CONS_token_JSON) System.JSON.deserialize(json, CONS_token_JSON.class);
	}

}