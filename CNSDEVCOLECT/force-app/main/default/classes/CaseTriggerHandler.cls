public class CaseTriggerHandler {
    private static Boolean flagTgr = false;
 private static CaseTriggerHandler instance = null;

 /**
 * @description 
 * @author eayalcor@everis.com | 03-02-2020 
 * @return UserTriggerHandler 
 **/
 public static CaseTriggerHandler getInstance() {
     if (instance == null){
         instance = new CaseTriggerHandler();
     }    
     return instance;
 }
 
 public void turnOffTgr(){
     flagTgr = true;
 }
 
 /*
     AfterInsert
 */
 public void onAfterInsert(List<Case> caseLst, Map<Id,Case> oldMap){
    if(flagTgr){ return; }
    CaseTriggerHelper.onAfterInsert(caseLst, oldMap);
 }
 
  /*
     AfterUpdate
 */
 public void onAfterUpdate(List<Case> caseLst, Map<Id,Case> oldMap){
    if(flagTgr){ return; }
    CaseTriggerHelper.onAfterUpdate(caseLst, oldMap);
 }
 /*
     Before Update
 */
 public void onBeforeUpdate(List<Case> caseLst, Map<Id,Case> oldMap){
    if(flagTgr){ return; }
    CaseTriggerHelper.onBeforeUpdate(caseLst, oldMap);
 }

 public void onBefore(){
     if(flagTgr){ return; }
     // trigger helper para las notificaciones de los casos de Portabilidad Financiera
     CaseTriggerPFHelper.onBeforeUpdate();
     // trigger helper para enviar los correos de los casos por MasterBase
     CaseTriggerPF_MB_Helper.onBefore_MB();
 }

 public void onAfter(){
     if(flagTgr){ return; }
     CaseTriggerPFHelper.onAfter();
 }	

}