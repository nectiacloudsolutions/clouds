/**
 * @File Name          : labelPickListFlow.cls
 * @Description        : 
 * @Author             : ricardo.adriazola.moraga@everis.com
 * @Group              : 
 * @Last Modified By   : 
 * @Last Modified On   : 
 * @Modification Log   : 
 * Ver       Date            Author      		   				 Modification
 * 1.0    31-10-2020   ricardo.adriazola.moraga@everis.com     Initial Version
**/
global class labelPickListFlow {
@InvocableMethod(label='Get Label PickList' description='Clase creada para obtener el label de PickList' category='Account')
    public static List<String> getPickListValue(List<requestInfo> info){
        List<String> Labels = new List<String>();
        Map<String,String> mpsLabel= new Map<String,String>();
        String objectName = CONSTANTS.ACCOUNT;
		String fieldName =info[0].fieldN;
  		
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            mpsLabel.put(pickListVal.getValue(),pickListVal.getLabel());
        }
        List<String> lstValues = new List<String>();
        lstValues=mpsLabel.values();
        if(mpsLabel.containsKey(info[0].idsValue)){
            Labels.add(mpsLabel.get(info[0].idsValue));
        }else if(lstValues.contains(info[0].idsValue)){
            Labels.add(info[0].idsValue);
        }else if(!mpsLabel.containsKey(info[0].idsValue) || !lstValues.contains(info[0].idsValue)){
            Labels.add(Constants.ACCOUNT_PICKLISTS_NINGUNO);
        }
        
        return Labels;
    }
    
        global class requestInfo {
        @InvocableVariable
        global String idsValue;
        
        @InvocableVariable(required=true)
        global String fieldN;
  }
}