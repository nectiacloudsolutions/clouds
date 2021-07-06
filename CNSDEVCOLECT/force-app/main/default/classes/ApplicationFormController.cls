/**
* @ Author: Claudia Villalobos
* @ Create Time: 2021-1-04 16:28:13
* @ Modified by: --
* @ Modified time: --
* @ Description: Clase para obtener los campos para el llenado del formulario customizado del componente ***
*/
public with sharing class ApplicationFormController {
    private static final String EMPTY = '';
    private static final String OPLINEITEM = 'OpportunityLineItem';
    private static final String FORMAT_DATE = 'dd/MM/yyyy';

    @AuraEnabled
    public static Map<String,FormField__mdt> getForm(Id recordId) {
        String pageLayout = EMPTY;
        OpportunityLineItem oppLineItem = [Select Product2.Name FROM OpportunityLineItem WHERE Id=:recordId];
        pageLayout =  oppLineItem.Product2.Name;
        List<FormField__mdt> reqs = [SELECT API_Name_Field__c,Related_Object__c,MasterLabel, Section__c,seccion_nro__c,nro_orden__c from FormField__mdt WHERE pageLayout__c=:pageLayout and Activo__c = True ORDER BY seccion_nro__c ASC, nro_orden__c ASC];
        Map<String,FormField__mdt> mapMatchMetadata = new Map<String,FormField__mdt>();
        String query = 'SELECT Id ';
        for(FormField__mdt a: reqs){
            if(a.Related_Object__c == null) {
                query += ',' + a.API_Name_Field__c;
                mapMatchMetadata.put(a.API_Name_Field__c,a);
            } else {
                query += ',' +a.Related_Object__c+'.'+a.API_Name_Field__c;
                mapMatchMetadata.put(a.Related_Object__c+'.'+a.API_Name_Field__c,a);
            }
        }        
        String qryString = query+' FROM OpportunityLineItem WHERE Id=\''+recordId+'\'';
        OpportunityLineItem customObject = Database.query(qryString);
        Map<String,FormField__mdt> testMetadata = new Map<String,FormField__mdt>();        
        Map<String,String> mapMatch = new Map<String,String>();
        if(!mapMatchMetadata.isEmpty() && mapMatchMetadata != null){
            String valor = '';
            for(String s: mapMatchMetadata.keySet()) {
                if(mapMatchMetadata.get(s).Related_Object__c == null) {	
					valor = formatDate(OPLINEITEM,mapMatchMetadata.get(s).API_Name_Field__c,customObject,null);
                    mapMatchMetadata.get(s).valor__c = valor;
                    testMetadata.put(mapMatchMetadata.get(s).API_Name_Field__c,mapMatchMetadata.get(s));
                }else {
                    valor = formatDate(OPLINEITEM,mapMatchMetadata.get(s).API_Name_Field__c,customObject,mapMatchMetadata.get(s).Related_Object__c);
                    mapMatchMetadata.get(s).valor__c = valor;
                    testMetadata.put(mapMatchMetadata.get(s).Related_Object__c + '.' + mapMatchMetadata.get(s).API_Name_Field__c,mapMatchMetadata.get(s));
                }
            }
        }   
        return testMetadata;
    }
    
    private static String formatDate(String obj, String apiName, OpportunityLineItem oppLineItem, String relatedObj){
        Schema.DisplayType typeData = Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(apiName).getDescribe().getType();
		String value = '';
        if(Schema.DisplayType.Date == typeData) {
            Datetime myDT;
            if(relatedObj == null) {
                myDT = (DateTime)oppLineItem.get(apiName);
            } else {
                myDT = (DateTime)oppLineItem.getSobject(relatedObj).get(apiName);
            }
            if(myDT != null) {
                value = myDT.formatGMT(FORMAT_DATE);
            }
        } else {
            if(relatedObj == null) {
                value = String.valueOf(oppLineItem.get(apiName));
            } else {
                if(oppLineItem.getSobject(relatedObj) != null) {
                    value = String.valueOf(oppLineItem.getSobject(relatedObj).get(apiName));
                } else {
                    value = EMPTY;
                }
                
            }
        }
        return value;
    }
}