/**
 * @description       : 
 * @author            : eayalcor@everis.com
 * @group             :  
 * @last modified on  : 09-02-2020
 * @last modified by  : eayalcor@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-24-2020   eayalcor@everis.com   Initial Version
**/
public without sharing class BtnInvokeController {

    public static MultiWrapper objWrapper = new MultiWrapper();
    public static List<Account> lstAccount;

    /**
    * @description 
    * @author eayalcor@everis.com | 08-24-2020 
    * @param String accId 
    * @param String typeInvoke 
    * @return MultiWrapper 
    **/
    @AuraEnabled
    public static MultiWrapper getData(String accId, String typeInvoke){
        objWrapper.status = false;
        objWrapper.typeAlert = 'warning';

        try{
            lstAccount = [SELECT Id,Autoriza_uso_de_datos__c,Rut_con_puntos__c FROM Account WHERE Id =: accId LIMIT 1];

            if(lstAccount!=null && !lstAccount.isEmpty()){

                List<User> lstUser = [SELECT Id,CompanyName FROM User WHERE Id =: UserInfo.getUserId()];

                System.debug('Empresa:' + lstUser);

                if(lstAccount[0].Autoriza_uso_de_datos__c){
                    openUrl(typeInvoke,lstUser[0].CompanyName);
                }else if(!lstAccount[0].Autoriza_uso_de_datos__c && (!lstUser[0].CompanyName.equalsIgnoreCase(Constants.COMPANY_BANCO) && !lstUser[0].CompanyName.equalsIgnoreCase(Constants.COMPANY_CORREDORA) )){
                    openUrl(typeInvoke,lstUser[0].CompanyName);
                }else{
                    objWrapper.message = 'Usted no posee permisos para acceder a esta aplicación';
                }

            }else {
                objWrapper.message = Constants.OPPORTUNITY_ERROR_EXCEPTION;
                objWrapper.typeAlert = 'error';
            }
        }catch(Exception ex){
            System.debug('Debug Error:' + ex.getMessage() + ' StackTrace:' + ex.getStackTraceString());
            objWrapper.message = ex.getMessage();
        }

        return objWrapper;
    }

    public class MultiWrapper{
        @AuraEnabled public String message;
        @AuraEnabled public String url;
        @AuraEnabled public Boolean status;
        @AuraEnabled public String typeAlert;
    }

    /**
    * @description 
    * @author eayalcor@everis.com | 08-24-2020 
    * @param String typeInvoke 
    * @param String companyName 
    **/
    private static void openUrl(String typeInvoke,String companyName){

        List<Url_Invoke_external__mdt> lstMetadata = [SELECT Url_servicio__c,Parametros__c 
                                    FROM Url_Invoke_external__mdt WHERE Servicio_Url__c=:typeInvoke AND Empresa__c =:companyName];
        
        System.debug('Lst Metadata: ' + lstMetadata);
        if(lstMetadata != null && !lstMetadata.isEmpty()){
            SObject customObject = lstAccount[0];
            List<String> lstParameters = lstMetadata[0].Parametros__c == null ? new List<String>() : lstMetadata[0].Parametros__c.split(';');
            if(!lstParameters.isEmpty() && lstParameters != null){
                List<Object> lstObject = new List<Object>();
                for(Integer i=0; i<lstParameters.size();i++){
                    lstObject.add((Object)customObject.get(lstParameters[i]));
                }
                
                objWrapper.url = String.format(lstMetadata[0].Url_servicio__c, lstObject);
            }else{
                objWrapper.url = lstMetadata[0].Url_servicio__c;
            }
            System.debug('URL:' + objWrapper.url);
            objWrapper.status = true;
            objWrapper.message = Constants.OK;

        }else{
            objWrapper.typeAlert = 'error';
            throw new UtilitiesSales.SalesException('Ha ocurrido un Error');
        }     
    }

}