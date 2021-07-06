/*********************************************************************************************************
@Author       curbinav@everis.com
@name         cnf_sal_tri_campaign_member
@CreateDate   01/10/2019
@Description  Main Trigger of the CampaignMember object
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
15/10/2019    curbinav@everis.com           W-000011 - Cargar Miembros de Campaña - Forma Masiva
23/09/2020    mbeltrab@everis.com           Inicio B2B Banca Empresas Before Insert
**********************************************************************************************************/
trigger cnf_sal_tri_campaign_member on CampaignMember (before insert) {
    Consorcio_Org__c org;

    if (Consorcio_Org__c.getInstance(UserInfo.getUserId()) == null) {
        org = Consorcio_Org__c.getInstance(UserInfo.getProfileId());
    } else {
        org = Consorcio_Org__c.getInstance(UserInfo.getUserId());
    }

    CampaignMemberTriggerHandlerB2B handlerB2B = new CampaignMemberTriggerHandlerB2B();

    /**Before Insert/Update Event*/
    if((Trigger.isInsert) && Trigger.isBefore){
        system.debug('ORG SALES ------>'+org.Sales_project__c);
        if(org.Sales_project__c){
        	CampaignMemberTriggerHandler.getInstance().onBeforeInsert(Trigger.new);
        }
		handlerB2B.onBeforeInsert(Trigger.new);
    }
    
}