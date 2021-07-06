global class CONS_refrescartoken /*implements Schedulable*/ {
    public User u {get; set;}
    public AuthProvider aut {get; set;}
    public String accessToken {get; set;}
     public CONS_refrescartoken(){
        String usrId = userInfo.getUserId();
        u = [Select Id, username, Name, FirstName, Email,AccessToken_Nectia__c, Profile.name from User where Id = :usrId];
        aut=  [SELECT Id, DeveloperName FROM AuthProvider  where  DeveloperName ='consorcio_seguros'];
     }
    
    public PageReference actualiza_token(){
          if(u.AccessToken_Nectia__c!=null){
             system.debug('estructura  token existente');
        Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', u.AccessToken_Nectia__c);
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
               }
       system.debug('token_nuevo======'+token_nuevo);
           } 
            if(token_nuevo!=null && token_nuevo!='' ){    
           u.AccessToken_Nectia__c=token_nuevo;
              system.debug('AccessToken_Nectia__c'+u.AccessToken_Nectia__c);
             update u;
            }
       }else{
           system.debug('estructura inicio token ');
            string accessToken = Auth.AuthToken.getAccessToken(aut.id, 'Open ID Connect'); 
       system.debug('accessToken====='+accessToken);
           if(accessToken!=null){
               Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken(aut.id, 'open id connect', accessToken);
       system.debug('refreshAccessToken======'+responseMap);
       string token_nuevo=responseMap.get('AccessToken');
       system.debug('token_nuevo======'+token_nuevo);
               if(token_nuevo!=null && token_nuevo!='' ){
           u.AccessToken_Nectia__c=token_nuevo;
                system.debug('AccessToken_Nectia__c'+u.AccessToken_Nectia__c);
                update u;
               }
           }
           if(test.isRunningTest()){
               system.debug('esntro  a estructura de prueba test');
                string token_nuevo1 = 'test';
                system.debug('token_nuevo======'+token_nuevo1);
                u.AccessToken_Nectia__c=token_nuevo1;
                system.debug('AccessToken_Nectia__c'+u.AccessToken_Nectia__c);
                update u;          
           }
       
       }
        return null;
    }
         
    
  /* global void execute(SchedulableContext SC) {
       system.debug('userinfo.getUserId()'+userinfo.getUserId());
       user  u=[SELECT Id, Name, Email, LastModifiedDate,AccessToken_Nectia__c FROM User where id=:userinfo.getUserId()];
       if(u.AccessToken_Nectia__c!=null){
        Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken('0SO4F0000004CIAWA2', 'open id connect', u.AccessToken_Nectia__c);
       system.debug('refreshAccessToken======'+responseMap);
       string token_nuevo=responseMap.get('AccessToken');
       system.debug('token_nuevo======'+token_nuevo);
           if(token_nuevo==null){
          string accessToken = Auth.AuthToken.getAccessToken('0SO4F0000004CIAWA2', 'Open ID Connect'); 
       system.debug('accessToken====='+accessToken);
       responseMap = Auth.AuthToken.refreshAccessToken('0SO4F0000004CIAWA2', 'open id connect', accessToken);
       system.debug('refreshAccessToken======'+responseMap);
        token_nuevo=responseMap.get('AccessToken');
       system.debug('token_nuevo======'+token_nuevo);
           } 
           u.AccessToken_Nectia__c=token_nuevo;
       }else{
            string accessToken = Auth.AuthToken.getAccessToken('0SO4F0000004CIAWA2', 'Open ID Connect'); 
       system.debug('accessToken====='+accessToken);
       Map<String, String> responseMap = Auth.AuthToken.refreshAccessToken('0SO4F0000004CIAWA2', 'open id connect', accessToken);
       system.debug('refreshAccessToken======'+responseMap);
       string token_nuevo=responseMap.get('AccessToken');
       system.debug('token_nuevo======'+token_nuevo);
           u.AccessToken_Nectia__c=token_nuevo;
       }
       update u;
     
   
   }*/
}