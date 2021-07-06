public class CONS_terminopoliza_JSON {

		public Integer nBranch;
		public Integer nProduct;
		public Integer nPolicy;
		public Integer nCertif;
		public String dPolicyNullDate;
		public Integer nNullCode;
		public String nUserCode;
		public Integer nCase;
		public String sCaseName;
		public String sClientName;
		public String sTemplate;
		public Integer nBusinessNumber;
		public Integer sClientCellphone;
		public String dRecceptionDate;
        public String sClientEmail;
        public String dEffecDate;
 
    
	

	
	public static CONS_terminopoliza_JSON parse(String json) {
		return (CONS_terminopoliza_JSON) System.JSON.deserialize(json, CONS_terminopoliza_JSON.class);
	}
}