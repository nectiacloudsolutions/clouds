public class CONS_estructuratoken {

    public string token_servicio(){
        Cons_callOutService  call=new Cons_callOutService();
        string token;
        if(!test.isRunningTest()){
            token=call.callOuttoken();
        } else{
            token='{"access_token":"eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiIwNzc3MTM2Yi1hNTVhLTQ5ZTMtYWMxMS01MzNkNWUxZjJkZTMiLCJleHAiOjE1NTI5MTkwODksIm5iZiI6MCwiaWF0IjoxNTUyOTE4MTg5LCJpc3MiOiJodHRwczovL2Rlc2Fycm9sbG8uY29uc29yY2lvLmNsL2F1dGgvcmVhbG1zL0NSTSIsImF1ZCI6InNmLWNybSIsInN1YiI6IjIyY2Q3YmY0LTI2MTItNDIzYy05MGU1LTlkNGQ4YjdhMzEwMyIsInR5cCI6IkJlYXJlciIsImF6cCI6InNmLWNybSIsInNlc3Npb25fc3RhdGUiOiJhYTQwNGE2My00YjVkLTRiNzAtYTQwMC0yOTkyODJlMGM1NGEiLCJjbGllbnRfc2Vzc2lvbiI6ImYxYzNlZDJlLTc5NGMtNDZjMC1iZWQzLWFlZWY4MTFiOGQyNSIsImFsbG93ZWQtb3JpZ2lucyI6WyJodHRwczovL2JhbmNvY29uc29yY2lvLS1QYXJjaWFsQ05TLmNzOTMubXkuc2FsZXNmb3JjZS5jb20iLCJodHRwOi8vbG9jYWxob3N0OjgwODAiXSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJ2aWV3LXByb2ZpbGUiXX19LCJuYW1lIjoiRXh0ZXJubyBOZWN0aWEgMDMgTmVjdGlhIDAzIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiZXhuZWN0MDMiLCJnaXZlbl9uYW1lIjoiRXh0ZXJubyBOZWN0aWEgMDMiLCJmYW1pbHlfbmFtZSI6Ik5lY3RpYSAwMyIsImVtYWlsIjoiZXh0ZXJuby5uZWN0aWEwM0Bjb25zb3JjaW8uY2wifQ.j2yrPAYZXbJsTPUD3p9n53RGexHRWjzSBHNVDonpQSy2w4ArGbj-9WF-OM--9kCi7jkbMmI_10wR_8GID70pmyWohvW1WhxmjqL_lTZtwGpCnkaoFVUabTsrLsK6R-JuEwqLTFUZQwZJ3v32d0nP5UiOq4sd2auo0HQXYkxNpWovCbFMgmSPDoKgL1acqw1HnCbA3QxagKOfzDvermyjE70xwi6r3JMGQXRV9256x3Fp7zhp2uJNEPYqwmecASfUBMtiJhSm7RF5xfnN3H_rbMVg1CeHgIcd4CD3lcDQh8h6S4i8e8qVKq-Vt-lokUoXhlskgTfm_jKfMFzmmUCxvw","expires_in":900,"refresh_expires_in":1800,"refresh_token":"eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiIwYTg1NjZjNy0zMTExLTQ4OGMtYmM2OS0xYjc1YzU5NGZmMTQiLCJleHAiOjE1NTI5MTk5ODksIm5iZiI6MCwiaWF0IjoxNTUyOTE4MTg5LCJpc3MiOiJodHRwczovL2Rlc2Fycm9sbG8uY29uc29yY2lvLmNsL2F1dGgvcmVhbG1zL0NSTSIsImF1ZCI6InNmLWNybSIsInN1YiI6IjIyY2Q3YmY0LTI2MTItNDIzYy05MGU1LTlkNGQ4YjdhMzEwMyIsInR5cCI6IlJlZnJlc2giLCJhenAiOiJzZi1jcm0iLCJzZXNzaW9uX3N0YXRlIjoiYWE0MDRhNjMtNGI1ZC00YjcwLWE0MDAtMjk5MjgyZTBjNTRhIiwiY2xpZW50X3Nlc3Npb24iOiJmMWMzZWQyZS03OTRjLTQ2YzAtYmVkMy1hZWVmODExYjhkMjUiLCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsInZpZXctcHJvZmlsZSJdfX19.ZJioclVj9L3tZU4MAC2D0chwNX73WnRhSd3kSviSQdbYDp6meGtY_TRnyvD2w9hDM9OmsGEfwzeN9npsPVTbjo07YItPm6SfHF7WeFKRToxm1oyBhgnxx7JBJSLcUlv6SryAtx2_AmDhvUl5g175vYUtURzGwwdzUzzUThfZV5sJrJp0ZPwyPoGuu9JxeGSDGTlJ1ZomuT6zMr0pstZzlU6Qj7cWwenyFGQFo0QkI5atxD9wboeTriV2TO6oBZ2e9H0ZZECVej-uPmBsIOo85cp-9UUxXHXEHs7OrAExb2Jjo2a-6mNHFGgP87QabwMaxYDzznbvU1UDA4eszmLe_g","token_type":"bearer","id_token":"eyJhbGciOiJSUzI1NiJ9.eyJqdGkiOiI0ODRmYzY2Mi1iYjc1LTQ1MjAtYTNlZi0yMjNlYWRlZjA0ZjQiLCJleHAiOjE1NTI5MTkwODksIm5iZiI6MCwiaWF0IjoxNTUyOTE4MTg5LCJpc3MiOiJodHRwczovL2Rlc2Fycm9sbG8uY29uc29yY2lvLmNsL2F1dGgvcmVhbG1zL0NSTSIsImF1ZCI6InNmLWNybSIsInN1YiI6IjIyY2Q3YmY0LTI2MTItNDIzYy05MGU1LTlkNGQ4YjdhMzEwMyIsInR5cCI6IklEIiwiYXpwIjoic2YtY3JtIiwic2Vzc2lvbl9zdGF0ZSI6ImFhNDA0YTYzLTRiNWQtNGI3MC1hNDAwLTI5OTI4MmUwYzU0YSIsIm5hbWUiOiJFeHRlcm5vIE5lY3RpYSAwMyBOZWN0aWEgMDMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJleG5lY3QwMyIsImdpdmVuX25hbWUiOiJFeHRlcm5vIE5lY3RpYSAwMyIsImZhbWlseV9uYW1lIjoiTmVjdGlhIDAzIiwiZW1haWwiOiJleHRlcm5vLm5lY3RpYTAzQGNvbnNvcmNpby5jbCJ9.inpmBqKTJCc7zI0ULub8QtuFFKJhT6w8Fd-2mIMF_2rl6YtF-QDgXesMG-kVK9k_AIaurVihsSh5lUOWmxGEpfHDPCSoOJGijyqf8RjtyiBbtOwcwphLGrdhU3PhX7T34kiDVVtLztdFYEjBILW8UMGGnsR02mx4JGLGmmGSZ8hP3X1uWBYFYNiC5vg23k7aVD8Z31gIsj6w1pulBS4t-UwsqrmqrMdJnXLCv3Er3reMIXtdC1ev8ssXp82EU8r0vNIUghYACYyf4iaWIQ9dH_S3x4EwVqi38wLYBslXbQ5yAVQA-sCIUf3LqyXpuvpbCP7HjmHcWzCejuMpUs3tPA","not-before-policy":0,"session_state":"aa404a63-4b5d-4b70-a400-299282e0c54a"}';
        }
        system.debug('token'+token);
        CONS_token_JSON tok = (CONS_token_JSON)JSON.deserialize(token,CONS_token_JSON.class);  
        system.debug('token=='+tok.access_token);
        string access_token=tok.access_token;
        system.debug('token_servicio'+access_token);
        return access_token;
        
    } 
    
    public string token_usuario(){

		string userid= UserInfo.getUserId();
		user us=[select id,AccessToken_Nectia__c from user where  id=:userid limit 1];
		AuthProvider   aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
		string res=us.AccessToken_Nectia__c;

		if(us.AccessToken_Nectia__c==null){
			string accessToken = Auth.AuthToken.getAccessToken(aut.id, 'Open ID Connect'); 
			res=accessToken;
			system.debug('TOKEN NULO -- token_usuario'+res);
		}

		system.debug('token_usuario'+res);
		return res;


        //---------------------estructura de prueba--------------------------
  /*        if(us.AccessToken_Nectia__c!=null){
             system.debug('estructura  token existente');
        Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', us.AccessToken_Nectia__c);
       system.debug('refreshAccessToken======'+responseMap);
       string token_nuevo=responseMap.get('AccessToken');
       system.debug('token_nuevo======'+token_nuevo);
           if(token_nuevo==null){
          string accessToken = Auth.AuthToken.getAccessToken(aut.id, 'Open ID Connect'); 
       system.debug('accessToken====='+accessToken);
               if(accessToken!=null){
       responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', accessToken);
       system.debug('refreshAccessToken======'+responseMap);
        token_nuevo=responseMap.get('AccessToken');
       system.debug('token_nuevo======'+token_nuevo);
               }
           } 
           us.AccessToken_Nectia__c=token_nuevo;
              system.debug('AccessToken_Nectia__c'+us.AccessToken_Nectia__c);
             update us;
       }else{
           system.debug('estructura inicio token ');
            string accessToken = Auth.AuthToken.getAccessToken(aut.id, 'Open ID Connect'); 
       system.debug('accessToken====='+accessToken);
           if(accessToken!=null){
               Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', accessToken);
       system.debug('refreshAccessToken======'+responseMap);
       string token_nuevo=responseMap.get('AccessToken');
       system.debug('token_nuevo======'+token_nuevo);
           us.AccessToken_Nectia__c=token_nuevo;
                system.debug('AccessToken_Nectia__c'+us.AccessToken_Nectia__c);
                update us;
           }
       
       }*/
        //------------------------------------------------
    }
    
	public string token(){
	
		string idusuario=userinfo.getUserId();
		user us =[SELECT Id, Username, LastName, FirstName, Name, ProfileId FROM User WHERE Id = :idusuario];
		system.debug('us'+us);
		Profile prof=[SELECT Id, Name FROM Profile WHERE Id = :us.ProfileId];
		
		if(prof.Name=='Administrador del sistema'  ){
			return  token_servicio();
		}else{
			return  token_usuario();
		}
	}
}