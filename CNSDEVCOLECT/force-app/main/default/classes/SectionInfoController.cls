public without sharing class SectionInfoController {

    private static final String MODELO_MARCA_COMERCIAL = 'FFVV Seguros Nueva';

    @AuraEnabled(cacheable=true)
    public static List<InformativoEEVV__mdt> getSectionInfo(){

        List<InformativoEEVV__mdt> lstMetadata = [SELECT Titulo__c,Descripcion__c,URL_informativa__c 
        FROM InformativoEEVV__mdt];

        return lstMetadata;
    }

    @AuraEnabled(cacheable=true)
    public static Boolean hasAccess(){

        Boolean access = false;

        List<User> lstUser = [SELECT Id,Modelo_Comercial__c FROM User WHERE Id =: UserInfo.getUserId()];

        if(lstUser[0].Modelo_Comercial__c != null && (lstUser[0].Modelo_Comercial__c.equalsIgnoreCase(MODELO_MARCA_COMERCIAL) && 
            VisualizarTab__c.getInstance(UserInfo.getProfileId()).Visualizar__c )){
            access = true;
        }

        return access;
    }
}