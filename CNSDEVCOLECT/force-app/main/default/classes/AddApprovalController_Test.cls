/**
 * @File Name          : AddApprovalController_Test.cls
 * @Description        : 
 * @Author             : pcelisbe@everis.com
 * @Group              : 
 * @Last Modified By   : 
 * @Last Modified On   : 
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11-03-2020   pcelisbe@everis.com     Initial Version
**/
@isTest
public class AddApprovalController_Test {

    @testSetup static void dataload(){
        TestFactorySales.populateOrg();
       	TestFactorySales.createConsorcioOrg();
    }
    
    @isTest private static void save(){
        //User u = [select id,Name,rut__c from User where id =: userInfo.getUserId()];
        User u = [select id,Name,rut__c from User where rut__c ='9267710-9' LIMIT 1];

        sYSTEM.debug(u);
        ProfileApprovBank__c pA = new ProfileApprovBank__c();
        pA.Name='Ejecutivo de Visado';
        pA.Rut__c=u.RUT__c;
     	insert pA;
        Opportunity opp=[SELECT id FROM Opportunity WHERE ownerId=:u.Id];

        System.runAs(u){
        
        Boolean Result =AddApprovalController.save(u.id, opp.id);

        
		System.assert(result);        
            }
    }
}