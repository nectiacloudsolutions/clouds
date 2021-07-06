/*********************************************************************************************************
@Author       cagonzle@everis.com
@name         AttachmentTriggerHelper
@CreateDate   30/09/2020
@Description  Attachment Trigger Helper  
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
30/09/2020                    cagonzle@everis.com          			Implementacion PF
**********************************************************************************************************/
public with sharing class AttachmentTriggerHelper {
        
    public static void getAdjuntosPFDigital(List<Attachment> attNew){

		List<Id> lstIds = new List<Id>();
        for(Attachment att : attNew){
            lstIds.add(att.Id);
		}

        String sourceip = null;
        try{
            sourceip = (!System.Test.isRunningTest() ? Auth.SessionManagement.getCurrentSession().get('SourceIp') : null);
        }catch(Exception ex){ }
        
        if(lstIds.size() > 0){
			//String sourceip = (!System.Test.isRunningTest() ? Auth.SessionManagement.getCurrentSession().get('SourceIp') : null);
			ObjectRelatedDocumentHelper.createLogDocPF(lstIds, sourceip);	
		}
    }
}