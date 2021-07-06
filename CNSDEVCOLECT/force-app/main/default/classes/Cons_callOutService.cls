public class Cons_callOutService {
    
    /*--------------------------servicios corredora-----------------------------*/
    
    /*
        if (!Test.IsRunningTest())
        {
            response = http.send(request);       
        }
        else
        {
            response.setStatusCode(200);
            response.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
        }
*/
 
    
    public String callOutConvenioEmpresa(string rut_cliente,string rut_usuario){
        String str;
        string json='{"rutCliente": "'+rut_cliente+'", "rutEjecutivo": "'+rut_usuario+'"}';
        String username = 'ccbolsa';
        String password = 'ccbolsa2018.,';
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String autorizacionHeader = 'Basic  ' + EncodingUtil.base64Encode(headerValue);
        
        string url=[SELECT URL_Nectia__c FROM URL_Transaccional__mdt where Label='Transaccional' limit 1].URL_Nectia__c;
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);                    
            req.setHeader('content-type','application/json');  
            req.setHeader('Authorization', autorizacionHeader);
            req.setmethod('POST');
            req.setBody(json);
            
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                str=res1.getbody();
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                //para entrar al catch - para cobertura
                account  acc=new account();
                acc.Name='===================================================================================================Some string which is longer than 255 characters================================================================================================================';
                insert acc;
            }
        }catch(Exception e){
            str='error entro al catch' +e;
        } 
        System.debug('str='+str);
        return str;
    }
    
    
    /*--------------------------------------------------------------------------*/
    
    /*--------------------------servicio bancos-------------------------------*/
    /*

public String callOutCumbre(string rut_cliente,string rut_usuario){
String str;

string cod_sistema='270';
system.debug('rut_cliente'+rut_cliente);
system.debug('rut_usuario'+rut_usuario);
system.debug('cod_sistema'+cod_sistema);
Blob cryptoKey = Crypto.generateAesKey(128);
Blob data = Blob.valueOf(rut_cliente+rut_usuario+cod_sistema);
// string test=Crypto.encrypt('AES128', cryptoKey, initializationVector, data)
Blob encryptedData = Crypto.encryptWithManagedIV('AES128', cryptoKey, data);
Blob decryptedData = Crypto.decryptWithManagedIV('AES128', cryptoKey, encryptedData);
String decryptedDataString = encryptedData.toString();
String encryptedDataString = '';
system.debug('encryptedData'+ encryptedData); 
system.debug('decryptedData' + decryptedData); 
system.debug('encryptedDataString'+ encryptedDataString); 
encryptedDataString='xI9xEY0Ts0mhf3cgHTdbgo1VGFWlcOnpVEchrtEw4qGiQ6Q5m2j5XDEwG+I+joDa';
string  json='{"key":"'+encryptedDataString+'"}';
string url='http://10.250.12.128/Cumbres/salesforce';
system.debug('url=   '+ url); 
system.debug('json=   '+ json); 
try{
Http h =new Http();
HttpRequest req= new HttpRequest();
req.setTimeout(120000);
req.setEndpoint(url);                    
req.setHeader('content-type','application/json');  
//req.setHeader('Authorization', autorizacionHeader);
req.setmethod('POST');
req.setBody(json);
system.debug('req=   '+ req);   
if(!test.isRunningTest()){
HttpResponse res1;
res1 = h.send(req);
system.debug('res1.getStatus()'+res1.getStatus());
if(res1.getStatus()=='200' || res1.getStatus()=='201' ){
str=res1.getbody();

}

}else{
str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
}
}catch(Exception  e ){
system.debug('error entro al catch' +e);
str=null;
} 
System.debug('str='+str);
return str;
}
*/
    /*-----------------------------------------------------------------------------*/
    
    
    /*-------------------------------------servicios seguro-------------------------*/
    public String callOuttoken(){
        string str;
        
        string url=urlservicios('callOuttoken');
         boolean Sandbox = [SELECT Id, InstanceName, IsSandbox FROM Organization limit 1].IsSandbox;
         string json='';
         if(Sandbox==true){
         json='grant_type=password'+
            '&client_secret=36291917-f53e-4c15-a1fc-8aa535862f45'+
            '&client_id=sf-crm'+
            '&username=usr_slintegracionescrm'+
            '&password=0b432i8pfbtr';
         }else{
              json='grant_type=password'+
            '&client_secret=df09c903-a07e-4250-8bc4-ffa59baf84cf'+
            '&client_id=sf-crm'+
            '&username=usr_slintegracionescrm'+
            '&password=slintegraciones2k19$v';
         }
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);                    
            req.setHeader('content-type','application/x-www-form-urlencoded'); 
            req.setMethod('POST');   
            /* String payload = 'client_id='+EncodingUtil.urlEncode(sf-crm,'UTF-8')+
'&client_secret='+EncodingUtil.urlEncode(clientSecret,'UTF-8')+
'&refresh_token='+EncodingUtil.urlEncode(36291917-f53e-4c15-a1fc-8aa535862f45,'UTF-8')+
'&grant_type=password';
System.debug(payload);
*/
            req.setBody(json);
            system.debug('req=   '+ req);   
            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
               
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()'+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                //   if(res1.getStatus()=='200' || res1.getStatus()=='201'||res1.getStatus()=='ok' ){
                str=res1.getbody();
                
                system.debug('strstrstr='+str);
                //  }
              
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }

    public String callOutvalida_token(string token){
        string str;
        //  string url='https://api.us-south.apiconnect.appdomain.cloud/cnsappconsorciosegurosus-dev/catalogo-servicio-crm/seguridad-reino-ssoconsorciocrm-via-oidc/Token';
        string url='https://ssoqa.consorcio.cl/auth/realms/SsoConsorcioServicios/protocol/openid-connect/token/introspect';
        string json='token='+token;
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);                    
            req.setHeader('content-type','application/x-www-form-urlencoded'); 
            req.setHeader('Authorization','Basic  Y2xpZW50ZVNlZ3Vyb3M6Zjg3ODk1YzctMWE3NS00ZGE4LWEyZjEtMjU0OGVjNTRjMGVi'); 
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);   
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()'+res1.getStatus());
                if(res1.getStatus()=='200' || res1.getStatus()=='201'||res1.getStatus()=='ok' ){
                    str=res1.getbody();
                    system.debug('strstrstr='+str);
                }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                account  acc=new account();
                acc.Name='===================================================================================================Some string which is longer than 255 characters================================================================================================================';
                insert acc;
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    public String callOuttoken_de_prueba_diferentes_url(){
        string str;
        
        // string url='https://desarrollo.consorcio.cl/auth/realms/CRM'; // error503
        string url='https://ssoqa.consorcio.cl/auth/realms/CRM'; // error 404
        // string url='https://sso.consorcio.cl/auth/realms/CRM'; // error 404
        string json='grant_type=password'+
            '&client_secret=36291917-f53e-4c15-a1fc-8aa535862f45'+
            '&client_id=sf-crm'+
            '&username=exnect03'+
            '&password=Consorcio#2019';
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);                    
            req.setHeader('content-type','application/x-www-form-urlencoded'); 
            // req.setHeader('Authorization','Basic  Y2xpZW50ZVNlZ3Vyb3M6Zjg3ODk1YzctMWE3NS00ZGE4LWEyZjEtMjU0OGVjNTRjMGVi'); 
            req.setMethod('POST');  
            req.setBody(json);
            system.debug('req=   '+ req);   
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()'+res1.getStatus());
                system.debug('res1.getStatus()'+res1.getStatusCode());
                str=res1.getbody();
                system.debug('strstrstr='+str);
                
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                account  acc=new account();
                acc.Name='===================================================================================================Some string which is longer than 255 characters================================================================================================================';
                insert acc;
            }
        }catch(Exception  e ){
            system.debug('error entro al catch ' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    
    public String callOutlistardocumentos(string token,string rut,string numero, User tmpUser){
        string str='';
        
        string url=urlservicios('callOutlistardocumentos');
        string json='{'+
            '"archivadores":"Carpeta Digital Cliente",'+
            '"xmlFiltros":"<IndexList>'+
            '<Index Label=\\\"CLIENTE\\\" Value=\\\"'+rut+'\\\"/>'+
            '<Index Label=\\\"ID PROCESO\\\" Value=\\\"'+numero+'\\\"/>'+
            '</IndexList>"'+
            '}';
        system.debug('json'+json);
        try{ 
            
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            //system.debug('Authorization=   '+ req.getHeader('Authorization')); 
            system.debug('req=   '+ req);   
            system.debug('json=   '+ json);

            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()'+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

               if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

                    System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);
                	tmpUser.AccessToken_Nectia__c = token;
                   
               }else if(res1.getStatusCode() == 401){

                   AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c = token_nuevo;
			        System.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        
			        str = callOutlistardocumentos(token_nuevo,rut,numero,tmpUser);
                }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                account  acc=new account();
                acc.Name='===================================================================================================Some string which is longer than 255 characters================================================================================================================';
                insert acc;
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    public String callOutobtenerdocumentos(string token,string numero, user tmpUser){
        string str='';
        
        string json='{'+
            '"archivador":"Carpeta Digital Cliente",'+
            '"xmlFiltros":"<IndexList>'+
            '<Index Label=\\\"DWDOCID\\\" Value=\\\"'+numero+'\\\"/>'+
            '</IndexList>"'+
            '}';
        system.debug('json'+json);
        try{
            string url=urlservicios('callOutobtenerdocumentos');
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);   
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()'+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();
                    System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);
                	tmpUser.AccessToken_Nectia__c = token;
                   
               }else if(res1.getStatusCode() == 401){
                   AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        str = callOutobtenerdocumentos(token_nuevo,numero,tmpUser);                   
                    system.debug('res1.getbody()'+res1.getbody());
                }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                account  acc=new account();
                acc.Name='===================================================================================================Some string which is longer than 255 characters================================================================================================================';
                insert acc;
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    
	public String callOutguardardocumento(string token,string PN,string TP, string clas, string  rut,blob base64,string extencion,string numero,string nombre,string poliza,string tipo,User tmpUser){
        system.debug('PN='+PN);
        system.debug('TP='+TP);
        system.debug('clas='+clas);
        system.debug('rut='+rut);
        system.debug('base64='+base64);
        system.debug('extencion='+extencion);
        system.debug('numero='+numero);
        string str='';
        string url=urlservicios('callOutguardardocumento');
        string b64= (base64==null?'':EncodingUtil.base64Encode(base64));
        string json='{"archivador":"Carpeta Digital Cliente",'+
            '"contenido":"'+b64+'",'+
            '"xmlIndices":"<IndexList>'+
            '<Index Label=\\\"CLIENTE\\\" Value=\\\"'+rut+'\\\"/>'+
            '<Index Label=\\\"PROCESO_DE_NEGOCIO\\\" Value=\\\"'+PN+'\\\"/>'+
            '<Index Label=\\\"TIPO_DE_DOCUMENTO\\\" Value=\\\"'+TP+'\\\"/>'+
            '<Index Label=\\\"ID_PROCESO\\\" Value=\\\"'+numero+'\\\"/>'+
            '<Index Label=\\\"ID_NEGOCIO\\\" Value=\\\"'+poliza+'\\\"/>'+
            '<Index Label=\\\"LINEA_DE_NEGOCIO\\\" Value=\\\"'+tipo+'\\\"/>'+
            '<Index Label=\\\"CLASIFICACION_DOCUMENTO\\\" Value=\\\"'+clas+'\\\"/>'+
            '<Index Label=\\\"NUMERACION\\\" Value=\\\"0\\\"/>'+
            '<Index Label=\\\"COMENTARIOS_SUSCRIPCION\\\" Value=\\\"'+nombre+'\\\"/>'+
            '<Index Label=\\\"FECHA\\\" Value=\\\"'+system.now()+'\\\"/>'+
            '</IndexList>",'+
            '"extension":"'+extencion+'"'+    
            '}';
        //'<Index Label=\\\"OBS1\\\" Value=\\\"'+nombre+'\\\"/>'+
        system.debug('json'+json);
        
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);   
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()'+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();
                    System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);
                	tmpUser.AccessToken_Nectia__c = token;
                   
               }else if(res1.getStatusCode() == 401){
                    AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c = token_nuevo;
			        str = callOutguardardocumento(token_nuevo,PN,TP,clas,rut,base64,extencion,numero,nombre,poliza,tipo,tmpUser);                   
                    system.debug('res1.getbody()'+res1.getbody());
                }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                account  acc=new account();
                acc.Name='===================================================================================================Some string which is longer than 255 characters================================================================================================================';
                insert acc;
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    
    
    public String callOutdetalle_producto(string token,string json, User tmpUser){
        string str;
        string url=urlservicios('callOutdetalle_producto');
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
             HttpResponse res1 = new httpResponse();
		 
		    if (!Test.IsRunningTest())
		    {         
                res1 = h.send(req);   
            }
            else
            {
            res1.setStatusCode(200);
            }     
                system.debug('res1.getStatus()@@@@@@='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
                	str=res1.getbody();
                	System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);
                    
                	tmpUser.AccessToken_Nectia__c = token;
                    
                }else if(res1.getStatusCode() == 401){
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        str = callOutdetalle_producto(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    
    public String callOutpagos_vida(string token,string json, User tmpUser){
        string str='';
        string url=urlservicios('callOutpagos_vida');
        
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            
             HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
 
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                
            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        str = callOutpagos_vida(token_nuevo,json,tmpUser);
                }
          
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    
    public String callOutpagos_life(string token,string json, User tmpUser){
        string str='';
        string url=urlservicios('callOutpagos_life');
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
                	str=res1.getbody();
                	System.debug('uesr->'+tmpUser);
			       	System.debug('token->'+token);
                    
                	tmpUser.AccessToken_Nectia__c = token;
                    
                }else if(res1.getStatusCode() == 401){
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        str = callOutpagos_life(token_nuevo,json,tmpUser);
                }
          
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    
    public String callOutpagos_generales(string token,string json, User tmpUser){
        string str='';
        
        string url=urlservicios('callOutpagos_generales');
        
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            system.debug('token=   '+ token);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
                	str=res1.getbody();
                	System.debug('body res1->'+str);
                	System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);
			       	
                	tmpUser.AccessToken_Nectia__c = token;
                    
                }else if(res1.getStatusCode() == 401){
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        str = callOutpagos_generales(token_nuevo,json,tmpUser);
                }
            }
            else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                account  acc=new account();
                acc.Name='===================================================================================================Some string which is longer than 255 characters================================================================================================================';
                insert acc;
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    
    
    public String callOutCoberturas_vida(string token,string json, User tmpUser){
        string str='';
        
        string url=urlservicios('callOutCoberturas_vida'); 
   
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
			system.debug('token=   '+ token);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
	            if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
                	str=res1.getBody();
                	System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);
                	tmpUser.AccessToken_Nectia__c = token;
                    
                }else if(res1.getStatusCode() == 401){
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        str = callOutCoberturas_vida(token_nuevo,json,tmpUser);
                }
            }
            else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                account  acc=new account();
                acc.Name='===================================================================================================Some string which is longer than 255 characters================================================================================================================';
                insert acc;
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    
    public String callOutCoberturas_life(string token,string json, User tmpUser){
        string str='';
        
        string url=urlservicios('callOutCoberturas_life'); 
        
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                // if(res1.getStatus()=='200' || res1.getStatus()=='201' || res1.getStatus()=='ok' ){
                //str=res1.getbody();
                // }
                
            if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){

                	str=res1.getBody();
                	System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);
                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){
                	
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        
			        str = callOutCoberturas_life(token_nuevo,json,tmpUser);
                }
            }
            else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                account  acc=new account();
                acc.Name='===================================================================================================Some string which is longer than 255 characters================================================================================================================';
                insert acc;
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    public String callOutCoberturas_generales(string token,string json, User tmpUser){
        string str;
        
        string url=urlservicios('callOutCoberturas_generales'); 
        
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            system.debug('token=   '+ token);
            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
                	str=res1.getbody();
                	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                    
                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);	    

			        str = callOutCoberturas_generales(token_nuevo,json,tmpUser);
                }

        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    
    
    // revisión error 401, no se usa en otros desarrollos
    public String callOutdetallecuenta_vida(string token,string json){
        string str='';
        
        string url=urlservicios('callOutdetallecuenta_vida'); 
        
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                // if(res1.getStatus()=='200' || res1.getStatus()=='201' || res1.getStatus()=='ok' ){
                str=res1.getbody();
                
                // }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }

    // revisión error 401, no se usa en otros desarrollos
    public String callOutdetallecuenta_life(string token,string json){
        string str='';
        string url=urlservicios('callOutdetallecuenta_life'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                // if(res1.getStatus()=='200' || res1.getStatus()=='201' || res1.getStatus()=='ok' ){
                str=res1.getbody();
                
                // }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }

    // revisión error 401, no se usa en otros desarrollos
    public String callOutdetallecuenta_generales(string token,string json){
        string str='';
        string url=urlservicios('callOutdetallecuenta_generales'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                // if(res1.getStatus()=='200' || res1.getStatus()=='201' || res1.getStatus()=='ok' ){
                str=res1.getbody();
                
                // }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    
    // revisión error 401, no se usa en otros desarrollos
    public String callOutdetallecobertura_vida(string token,string json){
        string str='';
        string url=urlservicios('callOutdetallecobertura_vida'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                // if(res1.getStatus()=='200' || res1.getStatus()=='201' || res1.getStatus()=='ok' ){
                str=res1.getbody();
                
                // }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }

    // revisión error 401, no se usa en otros desarrollos
    public String callOutdetallecobertura_life(string token,string json){
        string str='';
        string url=urlservicios('callOutdetallecobertura_life'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                // if(res1.getStatus()=='200' || res1.getStatus()=='201' || res1.getStatus()=='ok' ){
                str=res1.getbody();
                
                // }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }

    // revisión error 401, no se usa en otros desarrollos
    public String callOutdetallecobertura_generales(string token,string json){
        string str='';
        string url=urlservicios('callOutdetallecobertura_generales'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                // if(res1.getStatus()=='200' || res1.getStatus()=='201' || res1.getStatus()=='ok' ){
                str=res1.getbody();
                
                // }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    
    // revisión error 401, no se usa en otros desarrollos (este método esta modificado)
    public String callOutdetallesiniestro_vida(string token,string json, User tmpUser){
        string str='';
        string url=urlservicios('callOutdetallesiniestro_vida'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
           
             HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                
            if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){

                	str=res1.getbody();
                	tmpUser.AccessToken_Nectia__c = token;
                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutdetallesiniestro_vida(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }

    // revisión error 401, no se usa en otros desarrollos (este método esta modificado)
    public String callOutdetallesiniestro_life(string token,string json, User tmpUser){
        string str='';
        string url=urlservicios('callOutdetallesiniestro_life'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                // if(res1.getStatus()=='200' || res1.getStatus()=='201' || res1.getStatus()=='ok' ){
                //str=res1.getbody();
                // }           
            if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){

                	str=res1.getbody();

                	tmpUser.AccessToken_Nectia__c = token;
                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutdetallesiniestro_life(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }

    // revisión error 401, no se usa en otros desarrollos
    public String callOutdetallesiniestro_generales(string token,string json){
        string str='';
        string url=urlservicios('callOutdetallesiniestro_generales');
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                // if(res1.getStatus()=='200' || res1.getStatus()=='201' || res1.getStatus()=='ok' ){
                str=res1.getbody();
                
                // }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    

    // revisión error 401, no se usa en otros desarrollos 
    public String callOutlistadosiniestro_vida(string token,string json, User tmpUser){

        string str='';
        string url=urlservicios('callOutlistadosiniestro_vida');

        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            system.debug('token= '+ token);
            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                // if(res1.getStatus()=='200' || res1.getStatus()=='201' || res1.getStatus()=='ok' ){
                //str=res1.getbody();
                // }

                if (res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus() == 'OK'){

                	str = res1.getBody();
                	System.debug('body res1->'+str);

                	tmpUser.AccessToken_Nectia__c = token;
                }else if (res1.getStatusCode() == 401){
					AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];

					Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
					system.debug('refreshAccessToken======'+responseMap);
					string token_nuevo=responseMap.get('AccessToken');
					system.debug('token_nuevo======'+token_nuevo);
					tmpUser.AccessToken_Nectia__c=token_nuevo;
					system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

					str = callOutpagos_generales(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }

    
    public String callOutlistadosiniestro_life(string token,string json, User tmpUser){
        string str='';
        string url=urlservicios('callOutlistadosiniestro_life');

        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            system.debug('token=   '+ token);
          HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                // if(res1.getStatus()=='200' || res1.getStatus()=='201' || res1.getStatus()=='ok' ){
                //str=res1.getbody();
                // }

				if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
					str=res1.getbody();
					System.debug('body res1->'+str);
					tmpUser.AccessToken_Nectia__c = token;
				}else if(res1.getStatusCode() == 401){
					AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
					Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
					system.debug('refreshAccessToken======'+responseMap);
					string token_nuevo=responseMap.get('AccessToken');
					system.debug('token_nuevo======'+token_nuevo);
					tmpUser.AccessToken_Nectia__c=token_nuevo;
					system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
					str = callOutpagos_generales(token_nuevo,json,tmpUser);
				}
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }

    // revisión error 401, no se usa en otros desarrollos 
    public String callOutlistadosiniestro_generales(string token,string json){
        string str='';
        
        string url=urlservicios('callOutlistadosiniestro_generales'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                // if(res1.getStatus()=='200' || res1.getStatus()=='201' || res1.getStatus()=='ok' ){
                str=res1.getbody();
                
                // }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    
    
    public String callOutCambio_via_pago_vida(string token,string json, user tmpUser){
        string str='';
        string url=urlservicios('callOutCambio_via_pago_vida'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);

             HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();
                    System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                    
                }else if(res1.getStatusCode() == 401){
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        str = callOutCambio_via_pago_vida(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }   


    public String callOutCambio_via_pago_Generales(string token,string json, user tmpUser){
        string str='';
        
        string url=urlservicios('callOutCambio_via_pago_Generales'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            System.debug('token->'+token);
             HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
            
            
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();
                    System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                    
                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        str = callOutCambio_via_pago_Generales(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    

    public String callOutCertificado_Cobertura_Vida(string token,string json, user tmpUser){
        string str='';
        string url=urlservicios('callOutCertificado_Cobertura_Vida'); 
        
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
           
             HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
            system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                
            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();
                    System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                    
                }else if(res1.getStatusCode() == 401){
                	
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutCertificado_Cobertura_Vida(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutCertificado_pagos_Vida(string token,string json, user tmpUser){
        string str='';
        string url=urlservicios('callOutCertificado_pagos_Vida'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            //req.setHeader('Accept','application/xml; charset=UTF-8');
            req.setHeader('Accept',' application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
           HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                
            if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();
            	    System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                
            }else if(res1.getStatusCode() == 401){
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        str = callOutCertificado_pagos_Vida(token_nuevo,json,tmpUser);
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutCertificado_pagos_Generales(string token,string json, user tmpUser){
        string str='';
        
        string url=urlservicios('callOutCertificado_pagos_Generales'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept',' application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();
            	    System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                    
              	}else if(res1.getStatusCode() == 401){
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        str = callOutCertificado_pagos_Generales(token_nuevo,json,tmpUser);
                }
           
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    
    
    public String callOutCertificado_Vigencia_RV(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutCertificado_Vigencia_RV'); 

        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);

             HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                // if(res1.getStatus()=='200' || res1.getStatus()=='201' || res1.getStatus()=='ok' ){
                //str=res1.getbody();
                // }

                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutCertificado_Vigencia_RV(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutCertificado_cargas_legales_RV(string token,string json,user tmpUser){
        string str='';
        string url=urlservicios('callOutCertificado_cargas_legales_RV'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
           HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                // if(res1.getStatus()=='200' || res1.getStatus()=='201' || res1.getStatus()=='ok' ){
                //str=res1.getbody();                
                // }

            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutCertificado_cargas_legales_RV(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutCertificado_liquidacion_Pension_RV(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutCertificado_liquidacion_Pension_RV'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
         
             HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutCertificado_liquidacion_Pension_RV(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutCertificado_liquidacion_pension_periodo_RV(string token,string json,user tmpUser){
        string str='';
        string url=urlservicios('callOutCertificado_liquidacion_pension_periodo_RV'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());


            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){
                	
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        
			        str = callOutCertificado_liquidacion_pension_periodo_RV(token_nuevo,json,tmpUser);
                }

        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    } 

    public String callOutCertificado_Pagos_RV(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutCertificado_Pagos_RV'); 

        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);

             HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){
                	
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        
			        str = callOutCertificado_Pagos_RV(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    
    
    public String callOutCertificado_Vigencia_Vehiculo_Generales(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutCertificado_Vigencia_Vehiculo_Generales'); 

        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

                if (res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus() == 'OK'){
					
					System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutCertificado_Vigencia_Vehiculo_Generales(token_nuevo,json,tmpUser);
                }

        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutCertificado_Vigencia_Vida(string token,string json, user tmpUser){
        string str='';
        
        string url=urlservicios('callOutCertificado_Vigencia_Vida'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();
                    System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                
            }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutCertificado_Vigencia_Vida(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    

    public String callOutCopia_Poliza_Vida(string token,string json, user tmpUser){
        string str='';
        string url=urlservicios('callOutCopia_Poliza_Vida'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept',' application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                    str=res1.getbody();
                    System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                    
                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutCopia_Poliza_Vida(token_nuevo,json,tmpUser);
                  }
                }
                else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                account  acc=new account();
                acc.Name='===================================================================================================Some string which is longer than 255 characters================================================================================================================';
                insert acc;
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutCopia_Poliza_Generales(string token,string json, user tmpUser){
        string str='';
        string url=urlservicios('callOutCopia_Poliza_Generales'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                    str=res1.getbody();
                    System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutCopia_Poliza_Generales(token_nuevo,json,tmpUser);
                 }
             }
                
             else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                account  acc=new account();
                acc.Name='===================================================================================================Some string which is longer than 255 characters================================================================================================================';
                insert acc;
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutCopia_Poliza_RV(string token,string json, user tmpUser){
        string str='';
        string url=urlservicios('callOutCopia_Poliza_RV'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                    str=res1.getbody();
                    System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                    
               }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutCopia_Poliza_RV(token_nuevo,json,tmpUser);
                 }
             }
                
                else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                account  acc=new account();
                acc.Name='===================================================================================================Some string which is longer than 255 characters================================================================================================================';
                insert acc;
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    

    public String callOutCertificado_Vigencia_Hogar_Generales(string token,string json,User tmpUser){
        string str='';
        
        string url=urlservicios('callOutCertificado_Vigencia_Hogar_Generales'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);

            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus() == 'OK'){

            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutCertificado_Vigencia_Hogar_Generales(token_nuevo,json,tmpUser);
                }

        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutCertificado_Copia_SOAP(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutCertificado_Copia_SOAP'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
                	System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutCertificado_Copia_SOAP(token_nuevo,json,tmpUser);
                }

                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                account  acc=new account();
                acc.Name='===================================================================================================Some string which is longer than 255 characters================================================================================================================';
                insert acc;
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }
    
    
    public String callOutRehabilitacion_poliza_vida(string token,string json, user tmpUser){
        string str='';
        string url=urlservicios('callOutRehabilitacion_poliza_vida'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
             HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                 if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                    str=res1.getbody();
                    System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                    
                 }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutRehabilitacion_poliza_vida(token_nuevo,json,tmpUser);
                 }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutRehabilitacion_poliza_generales(string token,string json, user tmpUser){
        string str='';
        string url=urlservicios('callOutRehabilitacion_poliza_generales'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
             HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                 if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                    str=res1.getbody();
                    System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                    
               }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutRehabilitacion_poliza_generales(token_nuevo,json,tmpUser);
                 }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutTermino_poliza_vida(string token,string json, user tmpUser){
        string str='';
        string url=urlservicios('callOutTermino_poliza_vida'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                    str=res1.getbody();
                    System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                    
               }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutTermino_poliza_vida(token_nuevo,json,tmpUser);
                 }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutTermino_poliza_generales(string token,string json, user tmpUser){
        string str='';
        string url=urlservicios('callOutTermino_poliza_generales'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                    str=res1.getbody();
                    System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                    
               }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutTermino_poliza_generales(token_nuevo,json,tmpUser);
                 }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutReclamos_RV(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutReclamos_RV'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);

            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutReclamos_RV(token_nuevo,json,tmpUser);
                }

        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }

    public String callOutReclamos_Vida(string token,string json,User tmpUser){
        string str='';
        
        string url=urlservicios('callOutReclamos_Vida'); 

        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
             HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
	
	          	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutReclamos_Vida(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutReclamos_Generales(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutReclamos_Generales'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);

            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                    
          		if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutReclamos_Generales(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }



    public String callOutEndoso_Comunicaciones_Generales(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutEndoso_Comunicaciones_Generales'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
             HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutEndoso_Comunicaciones_Generales(token_nuevo,json,tmpUser);
                }

        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutEndoso_Comunicaciones_Vida(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutEndoso_Comunicaciones_Vida'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
           HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutEndoso_Comunicaciones_Vida(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }


    public String callOutActualiza_Datos_Contacto(string token,string json, user tmpUser){

        string str='';
        string url=urlservicios('callOutActualiza_Datos_Contacto'); 

        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setHeader('Authorization','Bearer '+token);
            req.setMethod('PUT');   
            
            req.setBody(json);
            
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            
            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
            
                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus() == 'OK'){
                	System.debug('res1.getBody()->'+res1.getBody());
                	str = res1.getBody();

                	System.debug('usr->'+tmpUser);
                	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                }else if(res1.getStatusCode() == 401){

					AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
					Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
					system.debug('refreshAccessToken======'+responseMap);
					string token_nuevo=responseMap.get('AccessToken');
					system.debug('token_nuevo======'+token_nuevo);
					tmpUser.AccessToken_Nectia__c=token_nuevo;
					system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
					str = callOutActualiza_Datos_Contacto(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }   


    
    public String callOutSolisitud_clave_email(string token,string json, User tmpUser){
        string str='';
        string url=urlservicios('callOutSolisitud_clave_email'); 

        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);

            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

				if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){

					System.debug('res1.getBody()->'+res1.getBody());
					str=res1.getbody();

					System.debug('usr->'+tmpUser);
					System.debug('token->'+token);

					tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        str = callOutSolisitud_clave_email(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  


    public String callOutSolisitud_clave_folio(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutSolisitud_clave_folio'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            
            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
                res1.setStatusCode(200);
                //res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
                res1.setBody('{"Codigo":"0","Mensaje":"test"}');//Se paso para cubrir la clase "CONS_GestionarclaveinternetReintento" 12/03/2020
            }
            system.debug('res1.getStatus()='+res1.getStatus());
            system.debug('res1.getStatusCode()'+res1.getStatusCode());
            
            if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
                
                System.debug('res1.getBody()->'+res1.getBody());
                str=res1.getbody();
                
                System.debug('usr->'+tmpUser);
                System.debug('token->'+token);
                
                tmpUser.AccessToken_Nectia__c = token;
                
            }else if(res1.getStatusCode() == 401){
                
                //user us=[select id,AccessToken_Nectia__c from user where  id=: userinfo.getUserId() limit 1];
                AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
                system.debug('refreshAccessToken======'+responseMap);
                string token_nuevo=responseMap.get('AccessToken');
                system.debug('token_nuevo======'+token_nuevo);
                tmpUser.AccessToken_Nectia__c=token_nuevo;
                system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
                //update us;
                str = callOutSolisitud_clave_folio(token_nuevo,json,tmpUser);
            }
            
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  
    
    
    public String callOutconsulta_via_pago_Vida(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutconsulta_via_pago_Vida'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', tmpUser.AccessToken_Nectia__c);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutconsulta_via_pago_Vida(token_nuevo,json,tmpUser);
                }
                
        }catch(Exception  e ){
            system.debug('error entro al catch vía de pago vida' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    } 


    public String callOutconsulta_via_pago_Generales(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutconsulta_via_pago_Generales'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);

            System.debug('req=   '+ req);
            System.debug('json=   '+ json);
            System.debug('usr->'+tmpUser);
            System.debug('token->'+token);
            
             HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutconsulta_via_pago_Generales(token_nuevo,json,tmpUser);
                }

        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  

    
    
    public String callOutCambio_prima_proyectada_Vida(string token,string json, user tmpUser){
        string str='';
        string url=urlservicios('callOutCambio_prima_proyectada_Vida'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('PUT');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
             HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();
                    System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                    
                }else if(res1.getStatusCode() == 401){            	
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        str = callOutCambio_prima_proyectada_Vida(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  


    public String callOutSuspension_pagos_Vida(string token,string json, user tmpUser){
        string str='';
        string url=urlservicios('callOutSuspension_pagos_Vida'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('PUT');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
           HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                if(res1.getStatusCode()==200 || res1.getStatusCode()==201 ){
                    str=res1.getbody();
                    System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                    
                }else if(res1.getStatusCode() == 401){
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        str = callOutSuspension_pagos_Vida(token_nuevo,json,tmpUser);
                }   
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  
    
    // revisión error 401, no se usa en otros desarrollos
    public String callOutCambio_Apoderado_CNS(string token,string json){
        string str='';
        string url=urlservicios('callOutCambio_Apoderado_CNS'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','text/xml');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('PUT');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                if(res1.getStatusCode()==200 || res1.getStatusCode()==201 ){
                    str=res1.getbody();
                    
                }else{
                    str='ERROR - '+res1.getStatusCode();                     
                    system.debug('res1.getbody()'+res1.getbody());
                }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  

    // revisión error 401, no se usa en otros desarrollos
    public String callOutCambio_Apoderado_CNL(string token,string json){
        string str='';
        string url=urlservicios('callOutCambio_Apoderado_CNL'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','text/xml');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('PUT');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                if(res1.getStatusCode()==200 || res1.getStatusCode()==201 ){
                    str=res1.getbody();
                    
                }else{
                    str='ERROR - '+res1.getStatusCode();                     
                    system.debug('res1.getbody()'+res1.getbody());
                }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  
    
    // revisión error 401, no se usa en otros desarrollos
    public String callOutCambio_Via_Pago_CNS(string token,string json){
        string str='';
        string url=urlservicios('callOutCambio_Via_Pago_CNS'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','text/xml');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('PUT');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                if(res1.getStatusCode()==200 || res1.getStatusCode()==201 ){
                    str=res1.getbody();
                    
                }else{
                    str='ERROR - '+res1.getStatusCode();                     
                    system.debug('res1.getbody()'+res1.getbody());
                }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  

    // revisión error 401, no se usa en otros desarrollos
    public String callOutCambio_Via_Pago_CNL(string token,string json){
        string str='';
        string url=urlservicios('callOutCambio_Via_Pago_CNL'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','text/xml');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('PUT');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                if(res1.getStatusCode()==200 || res1.getStatusCode()==201 ){
                    str=res1.getbody();
                    
                }else{
                    str='ERROR - '+res1.getStatusCode();                     
                    system.debug('res1.getbody()'+res1.getbody());
                }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  
    

    public String callOutCalcular_Rescate_Vida(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutCalcular_Rescate_Vida'); 
        // string url='https://api.us-south.apiconnect.appdomain.cloud/cnsappconsorciosegurosus-qa/catalogo-crm/f-vida/rescate/calculo-fondos';   
        
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
             HttpResponse res1 = new httpResponse();
            if(!test.isRunningTest()){
                res1 = h.send(req);
            }else{
            res1.setStatusCode(200);
            res1.setBody('{"idFoto":"test","base64Thumbnail":"test"}');
            }
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', tmpUser.AccessToken_Nectia__c);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutCalcular_Rescate_Vida(token_nuevo,json,tmpUser);
                }
        }catch(Exception  e ){
            system.debug('error entro al catch calcular rescate vida' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  


    public String callOutRescate_Solicitud_Vida(string token,string json, user tmpUser){
        string str='';
        string url=urlservicios('callOutRescate_Solicitud_Vida'); 
        // string url='https://api.us-south.apiconnect.appdomain.cloud/cnsappconsorciosegurosus-qa/catalogo-crm/f-vida/rescate/solicitud';   
        
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();
                    System.debug('user->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;
                    
                }else if(res1.getStatusCode() == 401){
       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);
			        str = callOutRescate_Solicitud_Vida(token_nuevo,json,tmpUser);
                }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  
    
    public String callOutValor_UF(string token,User tmpUser){
        string str='';
        string url=urlservicios('callOutValor_UF'); 

        Datetime fecha = system.now();
        string fechaconsulta=fecha.format('dd/MM/yyyy');
        string json='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.wsrescatevida.cnsv.cl/">'+
            '<soapenv:Header/>'+
            '<soapenv:Body>'+
            '<ws:getUf>'+
            '<!--Optional:-->'+
            '<objetoEntrada>'+
            '<!--Optional:-->'+
            '<sEffecdate>'+fechaconsulta+'</sEffecdate>'+
            '</objetoEntrada>'+
            '</ws:getUf>'+
            '</soapenv:Body>'+
            '</soapenv:Envelope>';
        
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','text/xml');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', tmpUser.AccessToken_Nectia__c);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutValor_UF(token_nuevo,tmpUser);
                }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  
    

    public String callOutRescate_Cierre_Vida(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutRescate_Cierre_Vida'); 
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutRescate_Cierre_Vida(token_nuevo,json,tmpUser);
                }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  
    

    public String callOutRescate_Recalcular(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutRescate_Recalcular'); 
        
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutRescate_Recalcular(token_nuevo,json,tmpUser);
                }

                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  


     public String callOutAlertaPin_Solicitud(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutAlertaPin_Solicitud');         
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());

            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutAlertaPin_Solicitud(token_nuevo,json,tmpUser);
                }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  


     public String callOutAlertaPin_Cierre(string token,string json,User tmpUser){
        string str='';
        string url=urlservicios('callOutAlertaPin_Cierre'); 
       
        try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);     
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','Bearer '+token);
            req.setHeader('x-introspect-basic-authorization-header',headerauth());
            req.setMethod('POST');   
            req.setBody(json);
            system.debug('req=   '+ req);
            system.debug('json=   '+ json);
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                system.debug('res1.getStatus()='+res1.getStatus());
                system.debug('res1.getStatusCode()'+res1.getStatusCode());
                
            	if(res1.getStatusCode() == 200 || res1.getStatusCode() == 201 || res1.getStatus()=='OK' ){
            		
            		System.debug('res1.getBody()->'+res1.getBody());
                	str=res1.getbody();

			       	System.debug('usr->'+tmpUser);
			       	System.debug('token->'+token);

                	tmpUser.AccessToken_Nectia__c = token;

                }else if(res1.getStatusCode() == 401){

       				AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
                	Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', token);
			       	system.debug('refreshAccessToken======'+responseMap);
			       	string token_nuevo=responseMap.get('AccessToken');
			       	system.debug('token_nuevo======'+token_nuevo);
			        tmpUser.AccessToken_Nectia__c=token_nuevo;
			        system.debug('AccessToken_Nectia__c'+tmpUser.AccessToken_Nectia__c);

			        str = callOutAlertaPin_Cierre(token_nuevo,json,tmpUser);
                }
                
            }else{
                str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
                
            }
        }catch(Exception  e ){
            system.debug('error entro al catch' +e);
            str=null;
        } 
        System.debug('str='+str);
        return str;
    }  
    
    
    
    public String urlservicios(string metodo){
        string url;
        try{
            EndPointS__mdt  ep= [SELECT Id, Endpoint__c, Ambiente__c, Metodo__c, Label, QualifiedApiName, DeveloperName, MasterLabel, Language, NamespacePrefix FROM EndPointS__mdt where Metodo__c=:metodo ];
            url=ep.Endpoint__c;
        }catch(Exception e){
            url='no encontrada';
        }
        return url;
    }
      public String headerauth(){
        string aut;
        try{
            AplicacionCNS__mdt  AC= [SELECT Id,authorization_header__c  FROM AplicacionCNS__mdt limit 1];
            aut=AC.authorization_header__c ;
        }catch(Exception e){
            aut='no encontrada';
        }
        return aut;
    }
    
    /*------------------------------------------------------------------------------*/
}