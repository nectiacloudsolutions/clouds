/*********************************************************************************************************
@Author       luis.vidal@consorcio.cl
@name         CreateCaseBanca_DTO
@CreateDate   12/11/2020
@Description  DTO for service CreateCaseBanca.cls 
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
12/11/2020                    luis.vidal@consorcio.cl           Initial Version
**********************************************************************************************************/
public class CreateCaseBancaDto {
	

    public class CreateCaseBancaRequest {
        
        public String rutCliente {get;set;}
        public String tipo {get;set;}
		public String Subtipo {get;set;}
		public String productoBanco {get;set;}
		public String Origen {get;set;}
	}

    public List<CreateCaseBancaRequest> CreateCaseBancaRequest {get;set;}
	public List<CreateCaseBancaResponse> CreateCaseBancaResponse {get;set;}
	

	public class CreateCaseBancaResponse {
		public Id idCaso  {get;set;}
		public string rutcliente  {get;set;}
		public Boolean success {get;set;}
		public string errors {get;set;}
    }
    
	public static CreateCaseBancaDto parse(String json) {
		return (CreateCaseBancaDto) System.JSON.deserialize(json, CreateCaseBancaDto.class);
	}
}