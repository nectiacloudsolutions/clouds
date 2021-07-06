@isTest
public class AgendarVFPageEx_Test {

    static testMethod void MyTest(){
        CampaignMember cm = new CampaignMember();
        Apexpages.StandardController sc = new Apexpages.StandardController(cm);
        AgendarVFPageEx ext = new  AgendarVFPageEx(sc); 
       ext.getGreeting();
        
    }
}