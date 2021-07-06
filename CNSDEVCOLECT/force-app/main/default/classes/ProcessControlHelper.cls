/**
 * @description       : Control process B2B or B2C.
 * @author            : ggonzroj@everis.com
 * @group             :
 * @last modified on  : 08-26-2020
 * @last modified by  : ggonzroj@everis.com
 * Modifications Log
 * Ver   Date         Author                Modification
 * 1.0   08-26-2020   ggonzroj@everis.com   Initial Version
 **/
public without sharing class ProcessControlHelper{

	public static Consorcio_Org_B2B__c shouldRunProcessB2B(){
        Consorcio_Org_B2B__c orgB2B;
		if (Consorcio_Org_B2B__c.getInstance(UserInfo.getUserId()) == null){
			orgB2B = Consorcio_Org_B2B__c.getInstance(UserInfo.getProfileId());
		} else{
			orgB2B = Consorcio_Org_B2B__c.getInstance(UserInfo.getUserId());
        }
        return orgB2B;
    }
    
}