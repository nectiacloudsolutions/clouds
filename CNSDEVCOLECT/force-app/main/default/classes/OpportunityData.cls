/*********************************************************************************************************
@Author       zsuanaza@everis.com
@name         OpportunityData
@CreateDate   26/12/2019
@Description  Class use to get a new executive from analytics
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
26/12/2019                    zsuanaza@everis.com                Initial Version 
**********************************************************************************************************/
public class OpportunityData {
    @AuraEnabled public String idOportunidad;
    @AuraEnabled public String rutEjecutivo;
    @AuraEnabled public String rutCliente;
    @AuraEnabled public String producto;
    @AuraEnabled public String etapa;
}