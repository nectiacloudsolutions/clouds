/*********************************************************************************************************
@Author       lmunogar@everis.com
@name         PF_EnvioMail_MB_JSON
@CreateDate   03/10/2019
@Description  Service Rest Crear Caso desde Analytics 
***********************************************************************************************************
History of changes: 
API: https://mail-sender-api.services.cert.digital.consorcio.cl/v1/sendmail
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
20/08/2020                    lmunogar@everis.com                 Initial Version
30/12/2020                    mbeltrab@everis.com                 Cambio de emisor de correos de Digital a Masterbase directo
**********************************************************************************************************/
public class PF_EnvioMail_MB_JSON {

	public class BodyMail {
		public GeneralData GeneralData {get;set;}
	}

	public class GeneralData {
		public String FromName {get;set;}
		public String FromMail {get;set;}
		public To To {get;set;}
		public Message Message {get;set;}
		public Options Options {get;set;}
	}

    public class To {
		public List<String> Email {get;set;}
	}
    
    public class Message {
		public String Subject {get;set;}	
		public String Classification {get;set;}
		public Body Body  {get;set;}
		public BasedOn BasedOn {get;set;}
		public List<Attachment> Attachment {get;set;}
	}

	public class Attachment {
		public String FileName {get;set;}	//POC.pdf
		public String Encode {get;set;}	//Base64
		public String Size {get;set;}	//1
		public String Value {get;set;}	//JVBERi0x
	}
    
	public class BasedOn {
		public Integer Id {get;set;}	
		public String Type {get;set;}
	}

	public class Body {
		public String Format {get;set;}	
		public String Value {get;set;}
		public List<Variables> Variables {get;set;}
	}

	public class Variables {
		public String Name {get;set;}	
		public String Value {get;set;}
	}

	public class Options {
		public Boolean OpenTracking {get;set;}	
		public Boolean ClickTracking {get;set;}
		public Boolean TextHtmlTracking {get;set;}	
		public Boolean AutoTextBody {get;set;}
		public Boolean Personalization {get;set;}
	}

	public static PF_EnvioMail_MB_JSON parse(String json){
		return (PF_EnvioMail_MB_JSON) System.JSON.deserialize(json, PF_EnvioMail_MB_JSON.class);
	}
}