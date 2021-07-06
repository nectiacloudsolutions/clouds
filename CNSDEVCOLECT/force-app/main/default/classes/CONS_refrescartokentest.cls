@isTest
public class CONS_refrescartokentest {
  
    static testMethod void TestMethod_1() {
        string re=UserInfo.getUserId();
        user us2=[SELECT Id,AccessToken_Nectia__c FROM user WHERE id=: re];
        us2.AccessToken_Nectia__c=null;
        update us2;        
        CONS_refrescartoken ref = new CONS_refrescartoken();
        ref.actualiza_token();
      
    }
    static testMethod void TestMethod_2() {
       
        Profile pf = [SELECT Id FROM profile WHERE name='Administrador del sistema'];
        user   us=new  user();
        us.FirstName='1234';
        us.LastName='1234';
        us.AccessToken_Nectia__c='1234sdsfs';
        us.username =  '12345@myorg.com';
        us.email = '12345@myorg.com';
        us.Alias = '1234';
        us.languagelocalekey = 'es';
        us.localesidkey = 'es_CL';
        us.emailEncodingKey = 'ISO-8859-1';
        us.timeZoneSidKey = 'America/Santiago';
        us.profileId = pf.Id;
        insert us;
        
        string re=UserInfo.getUserId();
        user us2=[SELECT Id,AccessToken_Nectia__c FROM user WHERE id=: re];
        us2.AccessToken_Nectia__c='12323';
        update us2;
        CONS_refrescartoken ref = new CONS_refrescartoken();
        ref.actualiza_token();
      
    }
}