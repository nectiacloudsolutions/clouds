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
public with sharing class AttachmentTriggerHandler {  
    public static void afterInsert(List<Attachment> newAtt, List<Attachment> oldAtt, Map<Id,Attachment> newMapAtt, Map<Id,Attachment> oldMapAtt){
        AttachmentTriggerHelper.getAdjuntosPFDigital(newAtt);
    }
}