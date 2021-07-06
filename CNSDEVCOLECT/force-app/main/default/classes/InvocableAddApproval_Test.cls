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
public class InvocableAddApproval_Test {

	@testSetup static void dataload(){
        TestFactorySales.populateOrg();
       	TestFactorySales.createConsorcioOrg();
    }
    
    @isTest static void AddApprovalAction(){
        User us =[SELECT id, email FROM user WHERE profile.name='Ejecutivo de Visado' AND IsActive = true LIMIT 1];
        User us2 =[SELECT id, email FROM user WHERE profile.name='Ejecutivo de Riesgo' AND IsActive = true LIMIT 1];
        Opportunity opp=[SELECT id FROM Opportunity WHERE name = 'test opp 1' LIMIT 1];
        InvocableAddApproval.AddApprovalRequest addApro = new InvocableAddApproval.AddApprovalRequest();
        InvocableAddApproval.AddApprovalRequest addApro2 = new InvocableAddApproval.AddApprovalRequest();
        addApro.userId=us.id;
        addApro.opportunityId=opp.Id;
        addApro2.userId=us2.id;
        addApro2.opportunityId=opp.Id;
        List<InvocableAddApproval.AddApprovalRequest>lstA= new List<InvocableAddApproval.AddApprovalRequest>();
        List<InvocableAddApproval.AddApprovalRequest>lstA2= new List<InvocableAddApproval.AddApprovalRequest>();
        lstA.add(addApro);
        lstA2.add(addApro2);
        User Owner = [SELECT Id FROM User Where Rut__c = '88136454'];
        Test.startTest();
        system.runAs(Owner){
            InvocableAddApproval.AddApprovalAction(lstA);
            InvocableAddApproval.AddApprovalAction(lstA2);
        }
        System.assertEquals(1,lstA2.size());
        System.assertEquals(1, lstA.size());
        test.stopTest();
    }

}