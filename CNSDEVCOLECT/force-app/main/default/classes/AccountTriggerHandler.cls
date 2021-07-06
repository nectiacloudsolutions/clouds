public class AccountTriggerHandler {
    private static AccountTriggerHandler instance = null;

    /**
    * @description 
    * @author eayalcor@everis.com | 03-02-2020 
    * @return UserTriggerHandler 
    **/
    public static AccountTriggerHandler getInstance() {
        if (instance == null){
            instance = new AccountTriggerHandler();
        }    
        return instance;
    }
	
    public void onAfterUpdate(List<Account> accLst, Map<Id,Account> oldMap){
       AccountTriggerHelper.onAfterUpdate(accLst, oldMap);
    }
}