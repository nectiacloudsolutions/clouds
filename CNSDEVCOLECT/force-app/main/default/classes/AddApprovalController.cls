/**
* @File Name          : AddApprovalController.cls
* @Description        : 
* @Author             : pcelis@everis.com
* @Group              : 
* @Last Modified By   : pcelis@everis.com
* @Last Modified On   : 09-03-2020 11:03:08
* @Modification Log   : 
* Ver       Date            Author      		    Modification
* 1.0    09-03-2020   pcelis@everis.com     Initial Version
**/
public class AddApprovalController {
    
    /**
* @description 
* @author pcelis@everis.com | 09-03-2020 
* @param Id userId 
* @param Id recordId 
* @return void 
**/
    @AuraEnabled
    public static boolean save(Id userId,Id recordId){
        Boolean Result = null;
        Map<String, String> mapsUserApprov= new Map<String, String>();
        User u = [select id,Name,rut__c from User where id =: userInfo.getUserId()];
        For(ProfileApprovBank__c App : [SELECT Name,Rut__c FROM ProfileApprovBank__c])
        {
            mapsUserApprov.put(App.rut__c,App.name);
        }
        if(mapsUserApprov.containsKey(u.rut__c)){
            //Posee permisos para usar el boton.
            Opportunity Opp=[SELECT id,Flag_agregar_Aprobador__c,UserIdApp__c FROM Opportunity WHERE Id =: recordId LIMIT 1];
            System.debug('Oportunidad[AddApprovalController]==>'+Opp);
            Opp.Flag_agregar_Aprobador__c = !Opp.Flag_agregar_Aprobador__c;
            Opp.UserIdApp__c=userId;
            Update Opp;
            Result=true;
        }else{
            Result=false;
            
        }
        return Result;
        
        
        
    }
    
}