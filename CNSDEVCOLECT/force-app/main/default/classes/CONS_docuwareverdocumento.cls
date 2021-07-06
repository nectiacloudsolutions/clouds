public class CONS_docuwareverdocumento {
     public Transient String  base64{get;set;} 
    public  Transient string  tipo{get;set;}
    public  Transient string  nombre{get;set;}
      public User u {get; set;}
    public String accessToken {get; set;}
    public  string  iddocumento{get;set;}
    public User tmpUser{get;set;}
    
     public CONS_docuwareverdocumento(ApexPages.StandardController controller){
          
        case rt = (Case) controller.getRecord(); 
        system.debug('rt'+rt);
      iddocumento = ApexPages.currentPage().getParameters().get('d');
        system.debug('id'+iddocumento);
     }
  public PageReference obtener_documentos(){

  	tmpUser = [select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId()];

        system.debug('obt');
        Cons_callOutService call=new Cons_callOutService();
          CONS_estructuratoken est=new  CONS_estructuratoken();
       string resp='';
      if(!test.isRunningTest()){
        string access_token=est.token();
       system.debug('token=='+access_token);
         resp=call.callOutobtenerdocumentos(access_token,iddocumento,tmpUser);
        system.debug('res'+resp);
      }else{
          resp=accessToken;
              }
      if(!resp.contains('ERROR -')){
           CONS_documentovisualizar_JSON doclista = (CONS_documentovisualizar_JSON)JSON.deserialize(resp,CONS_documentovisualizar_JSON.class); 
          if(doclista.codigo=='0000'){
                base64=  EncodingUtil.Base64Encode(doclista.documents.documentResult[0].contenido);
              //base64=doclista.documents.documentResult[0].contenido;
               tipo=doclista.documents.documentResult[0].contentType;
               nombre=doclista.documents.documentResult[0].nombre;
          }else{
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR:'+doclista.mensaje); 
             ApexPages.addMessage(myMsg);  
          }
       
          
      }else{
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR:'+resp); 
             ApexPages.addMessage(myMsg);   
      }
       
        return null;
    }
}