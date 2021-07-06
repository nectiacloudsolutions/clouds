/*********************************************************************************************************
@Author       lmunogar@everis.com
@name         CaseTriggerPF_MB_Helper
@CreateDate   26/08/2020
@Description  Trigger helper - Portabilidad Financiera - Envío correo por MasterBase
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
26/08/2020                    lmunogar@everis.com                 Initial Version
**********************************************************************************************************/
public class CaseTriggerPF_MB_Helper {

    public static void onBefore_MB(){
        system.debug('Trigger.newMap: ' + Trigger.newMap);
        List<Case> newMap = (List<Case>)Trigger.new;
        Map<Id,Case> caseOldMap = (Map<Id,Case>)Trigger.oldMap;
		// DEPRECATED PF_EnvioMail_MB.enviarCorreoMB(newMap, caseOldMap);
    }
}