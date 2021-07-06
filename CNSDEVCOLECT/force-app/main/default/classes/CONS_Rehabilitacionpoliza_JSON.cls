public class CONS_Rehabilitacionpoliza_JSON {

    
		public Integer nBranch;
		public Integer nProduct;
		public Integer nPolicy;
		public Integer nCertif;
		public String dEffecDate;
		public String nUserCode;
		public Integer nCase;
		public String sCaseName;
		public String sClientName;
		public String sTemplate;
		public Integer nBusinessNumber;
		public Integer sClientCellphone;
		public String dRecceptionDate;
        public String sClientEmail;
    
	 

	
	public static CONS_Rehabilitacionpoliza_JSON parse(String json) {
		return (CONS_Rehabilitacionpoliza_JSON) System.JSON.deserialize(json, CONS_Rehabilitacionpoliza_JSON.class);
	}
}