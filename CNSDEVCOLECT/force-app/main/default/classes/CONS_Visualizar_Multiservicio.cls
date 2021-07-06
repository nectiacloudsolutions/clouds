public class CONS_Visualizar_Multiservicio {
    public string url {get;set;}
  public CONS_Visualizar_Multiservicio(ApexPages.StandardController  controller) {
       boolean issandbox = [SELECT Id, InstanceName, IsSandbox FROM Organization limit 1].IsSandbox;
        if(issandbox==true){
             url='https://consorcioqa.consorcio.cl/Multiservicio/apps/script/loginCRM.asp';
        }else{
             url='https://www.consorcio.cl/Multiservicio/apps/script/loginCRM.asp';
        }
      system.debug('url==>'+url);
  }
}