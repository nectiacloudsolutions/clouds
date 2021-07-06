/**
 * @description       : 
 * @author            : eayalcor@everis.com
 * @group             : 
 * @last modified on  : 08-12-2020
 * @last modified by  : eayalcor@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-12-2020   eayalcor@everis.com   Initial Version
 * COPYRIGHT !!!!!! NO USAR EN OTRA CELULA RATAS !!
**/
public class CnsCustomNotification { 
    /**
    * @description 
    * @author eayalcor@everis.com | 08-12-2020 
    * @param string jsonObject 
    * @param String funcionality 
    * @param List<String> recipients 
    **/
   @future(callout=true)
    public static void notifyCurrentUser(string jsonObject, String funcionality, List<String> recipients)
   {
       try{
           String body;
           SObject customObject = (SObject)JSON.deserializeStrict(jsonObject, Sobject.class);
           List<MessageNotification__c> notifyCs = [SELECT Header__c,Body__c,Parameters__c
                                FROM MessageNotification__c WHERE Functionality__c =:funcionality];
           List<String> lstParameters = notifyCs[0].Parameters__c == null ? new List<String>() : notifyCs[0].Parameters__c.split(';');
           if(!lstParameters.isEmpty() && lstParameters != null){
               List<Object> lstObject = new List<Object>();
               for(Integer i=0; i<lstParameters.size();i++){
                   lstObject.add((Object)customObject.get(lstParameters[i]));
               }
               
               body = String.format(notifyCs[0].Body__c, lstObject);
           }else{
               body = notifyCs[0].Body__c;
           }
           
           Http h = new Http();
           HttpRequest req = new HttpRequest();
           req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
               + '/services/data/v46.0/actions/standard/customNotificationAction');
           req.setMethod('POST');
           req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
           req.setHeader('Content-Type', 'application/json');
           CustomNotificationActionInput input = new CustomNotificationActionInput();
           input.customNotifTypeId = [SELECT Id FROM CustomNotificationType WHERE CustomNotifTypeName = 'cnf_sal_cn_alerta_desktop'].Id;
           input.recipientIds = recipients;
           input.title = notifyCs[0].Header__c;
           input.body = body;
           input.targetId = customObject.Id;
           CustomNotificationAction action = new CustomNotificationAction();
           action.inputs = new List<CustomNotificationActionInput>{input};
           req.setBody(JSON.serialize(action));
           HttpResponse res = h.send(req);   
       }catch(Exception ex){
           System.debug('Error:' + ex.getMessage());
       }
   }
   
   @future(callout=true)
    public static void notifyCurrentUserSLAVencidos(string jsonObject, String funcionality, List<String> recipients)
   {
       try{
           String body;
           System.debug('antes de request:');
           SObject customObject = (SObject)JSON.deserializeStrict(jsonObject, Sobject.class);
           List<MessageNotification__c> notifyCs = [SELECT Header__c,Body__c,Parameters__c
                                FROM MessageNotification__c WHERE Functionality__c =:funcionality];
           List<String> lstParameters = notifyCs[0].Parameters__c == null ? new List<String>() : notifyCs[0].Parameters__c.split(';');
           if(!lstParameters.isEmpty() && lstParameters != null){
               List<Object> lstObject = new List<Object>();
               for(Integer i=0; i<lstParameters.size();i++){
                   lstObject.add((Object)customObject.get(lstParameters[i]));
               }
               
               body = String.format(notifyCs[0].Body__c, lstObject);
           }else{
               body = notifyCs[0].Body__c;
           }
           
           Http h = new Http();
           HttpRequest req = new HttpRequest();
           req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
               + '/services/data/v46.0/actions/standard/customNotificationAction');
           req.setMethod('POST');
           req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
           System.debug('sessionid bearer:' + UserInfo.getSessionId());
           req.setHeader('Content-Type', 'application/json');
           CustomNotificationActionInput input = new CustomNotificationActionInput();
           input.customNotifTypeId = [SELECT Id FROM CustomNotificationType WHERE CustomNotifTypeName = 'cnf_sal_cn_alerta_desktop'].Id;
           input.recipientIds = recipients;
           input.title = notifyCs[0].Header__c;
           input.body = body;
           input.targetId = customObject.Id;
           CustomNotificationAction action = new CustomNotificationAction();
           action.inputs = new List<CustomNotificationActionInput>{input};
           req.setBody(JSON.serialize(action));
           System.debug('request:' + req);
           HttpResponse res = h.send(req);   
       }catch(Exception ex){
           System.debug('Error:' + ex);
       }
   }

   public class CustomNotificationAction
   {
       public List<CustomNotificationActionInput> inputs { get; set; }
   }

   public class CustomNotificationActionInput
   {
       public String customNotifTypeId { get; set; }
       public List<String> recipientIds { get; set; }
       public String title { get; set; }
       public String body { get; set; }
       public String targetId { get; set; }
   }

}