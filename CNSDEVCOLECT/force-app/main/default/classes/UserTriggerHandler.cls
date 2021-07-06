/**
 * @File Name          : UserTriggerHandler.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 03-02-2020 12:45:52
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    03-02-2020   eayalcor@everis.com     Initial Version
**/
public with sharing class UserTriggerHandler {
    private static UserTriggerHandler instance = null;

    /**
    * @description 
    * @author eayalcor@everis.com | 03-02-2020 
    * @return UserTriggerHandler 
    **/
    public static UserTriggerHandler getInstance() {
        if (instance == null){
            instance = new UserTriggerHandler();
        }    
        return instance;
    }
    /**
    * @description 
    * @author eayalcor@everis.com | 03-02-2020 
    * @param List<User> usrLst 
    * @return void 
    **/
    public void onAfterInsert(List<User> usrLst){
        UserTriggerHelper.onAfterInsert(usrLst);
    }

     /**
     * @description 
     * @author eayalcor@everis.com | 03-02-2020 
     * @param List<User> eveuserLstntList 
     * @param Map<Id User> oldMap 
     * @return void 
     **/
     public void onAfterUpdate(List<User> usrLst, Map<Id,User> oldMap){
        UserTriggerHelper.onAfterUpdate(usrLst, oldMap);
     }
}