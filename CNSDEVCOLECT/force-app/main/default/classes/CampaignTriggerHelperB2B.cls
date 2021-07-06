/**
 * @description       : Helper Campaign B2B 
 * @author            : mbeltran@everis.com
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-26-2020   mbeltran@everis.com   Initial Version
**/
public without sharing class CampaignTriggerHelperB2B {
    public static final String CAMPAIGN = 'CAMPAIGN';
    public static final String RECORDTYPE_CAMPAIGN_EMPRESA = 'sales_empresas';
    public static final String CAMPAIGN_STATUS_INGRESADA = 'Ingresada';
    public static final String CAMPAIGN_STATUS_ACTIVADA = 'Activada';
    public static final String CAMPAIGN_STATUS_TERMINADA = 'Terminada';
    public static final String CAMPAIGN_STATUS_CANCELADA = 'Cancelada';

    public static void CloseLeadsinCampaignMemberwheCampaignClose(List<Campaign> newCampaignList, Map<ID,Campaign> oldCampaignMap){
        System.debug('CloseLeadsinCampaignMemberwheCampaignClose');
        Set<Id> IdCampanas = new Set<Id>();

        for(Campaign iCampaign : newCampaignList){
            if(oldCampaignMap.get(iCampaign.Id).Status != iCampaign.status){ 
                if((iCampaign.status == CAMPAIGN_STATUS_TERMINADA || iCampaign.status == CAMPAIGN_STATUS_CANCELADA) 
                    && iCampaign.RecordTypeId == CampaignTriggerHelperB2B.getRecordTypeId(RECORDTYPE_CAMPAIGN_EMPRESA)){
                    System.debug('Existe campaña:' + iCampaign.name + ',Status:' + iCampaign.status);
                    IdCampanas.add(iCampaign.Id);
                }
            }
        }

        CampaignMemberTriggerHelperB2B.UpdateLeadsFromCampaignMembersByCampaignClose(IdCampanas);
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   RECORD_TYPE_MAP_DEVELOPERNAME of Campaign object
    */
    public static Map<String, RecordType> RECORD_TYPE_MAP_DEVELOPERNAME{
        get{
            if (RECORD_TYPE_MAP_DEVELOPERNAME == null){

            	RECORD_TYPE_MAP_DEVELOPERNAME = new Map<String, RecordType>();

            	List<RecordType> lstRecordType = [SELECT Id, Name,
								            	  DeveloperName 
								            	  FROM RecordType 
								            	  WHERE SobjectType =: Schema.Campaign.sObjectType.getDescribe().getName() 
            									  ];

            	for (RecordType iRecordType : lstRecordType){
            		RECORD_TYPE_MAP_DEVELOPERNAME.put(iRecordType.DeveloperName, iRecordType);
            	}
            }
            return RECORD_TYPE_MAP_DEVELOPERNAME;
        }
        set;
    }

    /*
    * @Author          :   Georvys Gonzalez <ggonzroj@everis.com>
    * @Description     :   Map of RecordTypeInfo
    */
    public static String getRecordTypeId (String developerName){
        return RECORD_TYPE_MAP_DEVELOPERNAME.get(developerName).Id;
    }
}