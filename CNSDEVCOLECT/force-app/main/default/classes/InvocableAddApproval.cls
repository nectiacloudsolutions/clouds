/**
 * @File Name          : InvocableAddApproval.cls
 * @Description        : 
 * @Author             : pcelis@everis.com
 * @Group              : 
 * @Last Modified By   : pcelis@everis.com
 * @Last Modified On   : 09-03-2020 11:58:15
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    09-03-2020   pcelis@everis.com     Initial Version
**/
global class InvocableAddApproval {
@InvocableMethod(label='Agregar Aprobador' description='Metodo invocable para agregar aprobador al opportunity teams y saltarse los problemas con permisos' category='Opportunity')
    public static void AddApprovalAction(List<AddApprovalRequest> add){
        Profile p = [Select Name from Profile where Id =: userinfo.getProfileid()];
        String pName=p.name;
        String rName;
        if (pName.contains('Visado')) {
            rName='Revisor';
            List<Opportunity> lstOpp = [SELECT Id FROM Opportunity WHERE Id =: add[0].opportunityId LIMIT 1];
            lstOpp[0].ejecutivo_visado_sales__c = add[0].userId;
            update lstOpp;
            verificationTeamRole(add[0].opportunityId,rName);
        }else {
            rName='Riesgo';
            List<Opportunity> lstOpp = [SELECT Id FROM Opportunity WHERE Id =: add[0].opportunityId LIMIT 1];
            lstOpp[0].ejecutivo_riesgo_sales__c = add[0].userId;
            update lstOpp;
            verificationTeamRole(add[0].opportunityId,rName);
        }
        OpportunityTeamMember otm =new OpportunityTeamMember (OpportunityId = add[0].opportunityId,UserId = add[0].userId ,TeamMemberRole = rName, OpportunityAccessLevel='Edit');
        
        insert otm;
        System.debug(otm);
    }
    
    public static void verificationTeamRole(id OppId,string teamRole){
        List<OpportunityTeamMember> lstTeam=[SELECT id FROM OpportunityTeamMember WHERE TeamMemberRole=:teamRole and OpportunityId =:OppId];
        if(!lstTeam.isEmpty()){
            delete lstTeam;
        }    
    }
    
    global class AddApprovalRequest {
        @InvocableVariable(required=true)
        global String userId;
        
        @InvocableVariable(required=true)
        global ID opportunityId;
  }
}