/**
 * @description       : 
 * @author            : mbeltran@everis.com
 * @group             : 
 * @last modified on  : 10-23-2020
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   10-21-2020   mbeltran@everis.com   Initial Version
**/
public without Sharing class LeadWizardControllerB2B_B2C {

    public static final String ComponentSales = 'c:leadWizard';
    public static final String ComponentSalesB2B = 'c:leadWizardB2B';

    @AuraEnabled 
    public static string GetComponentAccess(){ 

		Consorcio_Org__c org = Consorcio_Org__c.getInstance(UserInfo.getUserId());
            
        if(org.Sales_project__c){
        	return ComponentSales;
        }
        else { 
        	return ComponentSalesB2B;
        }
    }

}