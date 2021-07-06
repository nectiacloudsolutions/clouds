/**
* @File Name          : UserTriggerHelper.cls
* @Description        : 
* @Author             : eayalcor@everis.com
* @Group              : 
* @Last Modified By   : eayalcor@everis.com
* @Last Modified On   : 03-02-2020 12:47:13
* @Modification Log   : 
* Ver       Date            Author      		    Modification
* 1.0    03-02-2020   eayalcor@everis.com     Initial Version
**/
public with sharing class UserTriggerHelper {    
    
    /**
* @description 
* @author eayalcor@everis.com | 03-02-2020 
* @param List<User> usrLst 
* @return void 
**/
    public static void onAfterInsert(List<User> usrLst){
        List<String> userId = new List<String>();   
        
        //Experimento
        List<Group> grpSeguros = new List<Group>();
        List<Group> grpBanco = new List<Group>();
        List<Group> grpCorredora = new List<Group>();
        List<Group> grpServicios = new List<Group>();
        List<GroupMember> gmInsert = new List<GroupMember>();
        
        grpSeguros = [select id, DeveloperName from Group where DeveloperName =: CONSTANTS.GRUPO_SEGUROS];
        grpBanco = [select id, DeveloperName from Group where DeveloperName =: CONSTANTS.GRUPO_BANCO];
        grpCorredora = [select id, DeveloperName from Group where DeveloperName =: CONSTANTS.GRUPO_CORREDORA];
        grpServicios = [select id, DeveloperName from Group where DeveloperName =: CONSTANTS.GRUPO_SERVICIOS];
        
        try{
            for(User u : usrLst){
                userId.add(u.Id);
                GroupMember gm = new GroupMember();
                if(u.CompanyName.equalsIgnoreCase(CONSTANTS.COMPANY_SEGUROS)){
                    gm.GroupId = grpSeguros[0].id;
                    gm.UserOrGroupId = u.Id;
                }else if(u.CompanyName.equalsIgnoreCase(CONSTANTS.COMPANY_CORREDORA)){
                    gm.GroupId = grpCorredora[0].id;
                    gm.UserOrGroupId = u.Id;                
                }else if(u.CompanyName.equalsIgnoreCase(CONSTANTS.COMPANY_BANCO)){
                    gm.GroupId = grpBanco[0].id;
                    gm.UserOrGroupId = u.Id;                
                }else if(u.CompanyName.equalsIgnoreCase(CONSTANTS.COMPANY_SERVICIOS)){
                    gm.GroupId = grpServicios[0].id;
                    gm.UserOrGroupId = u.Id;                    
                }
                gmInsert.add(gm);
            }
            if(!gmInsert.isEmpty() && gmInsert != null){
                insert gmInsert;
            }
            
            if(!userId.isEmpty() && userId != null){               
                if(!Test.isRunningTest()){
                    SalesCallout.consultUserAnalyticsAsyncMassive(userId,CONSTANTS.INSERTED,CONSTANTS.ANALYTICSLEAD);
                }
            }
        }catch(Exception e){
            Trigger.new[0].addError(e.getMessage());  
        }        
    }
    
    /**
* @description 
* @author eayalcor@everis.com | 03-02-2020 
* @param List<User> usrLst 
* @param Map<Id User> oldMap 
* @return void 
**/
    public static void onAfterUpdate(List<User> usrLst, Map<Id,User> oldMap){
        List<String> userId = new List<String>();
        List<User> usrToUpdate = new List<User>();
        //Experimento
        List<Group> grpSeguros = new List<Group>();
        List<Group> grpBanco = new List<Group>();
        List<Group> grpCorredora = new List<Group>();
        List<Group> grpServicios = new List<Group>();
        List<Group> grp3Types = new List<Group>();
        List<GroupMember> gmInsert = new List<GroupMember>();

        Map<Id,GroupMember> usrGroupmemberMap = new Map<Id,GroupMember>();
        grp3Types = [SELECT Id, DeveloperName FROM Group WHERE (DeveloperName =: CONSTANTS.GRUPO_SEGUROS OR DeveloperName =: CONSTANTS.GRUPO_BANCO OR DeveloperName =: CONSTANTS.GRUPO_CORREDORA OR DeveloperName =: CONSTANTS.GRUPO_SERVICIOS)];
        for(Group g : grp3Types){
            if(g.developerName == CONSTANTS.GRUPO_BANCO){
                grpBanco.add(g);
            }else if(g.developerName == CONSTANTS.GRUPO_SEGUROS){
                grpSeguros.add(g);
            }else if(g.developerName == CONSTANTS.GRUPO_CORREDORA){
                grpCorredora.add(g);
            }else if(g.DeveloperName == CONSTANTS.GRUPO_SERVICIOS){
                grpServicios.add(g);
            }
        }
       // grpSeguros = [SELECT id, DeveloperName FROM Group where DeveloperName =: CONSTANTS.GRUPO_SEGUROS];
       // grpBanco = [SELECT id, DeveloperName FROM Group where DeveloperName =: CONSTANTS.GRUPO_BANCO];
       // grpCorredora = [SELECT id, DeveloperName FROM Group where DeveloperName =: CONSTANTS.GRUPO_CORREDORA];
        
        for(User u : usrLst){
            if (u.CompanyName != oldMap.get(u.Id).CompanyName) {
                userId.add(u.Id);
                usrToUpdate.add(u);
            }
        }
        
        List<GroupMember> oldGroup  = [SELECT UserOrGroupId, Id, GroupId  FROM GroupMember 
                                       WHERE UserOrGroupId IN :userId AND (GroupId=: grpSeguros[0].Id OR GroupId=: grpBanco[0].Id OR GroupId=:grpCorredora[0].Id OR GroupId =: grpServicios[0].Id) ];               
        
        for(GroupMember grpmb: oldGroup){
            usrGroupmemberMap.put(grpmb.UserOrGroupId, grpmb);
        }
        
        try{
            for (User u : usrToUpdate) {      
                GroupMember gm = new GroupMember();
                if(u.CompanyName.equalsIgnoreCase(CONSTANTS.COMPANY_SEGUROS)){
                    gm.GroupId = grpSeguros[0].id;
                    gm.UserOrGroupId = u.Id;                
                }else if(u.CompanyName.equalsIgnoreCase(CONSTANTS.COMPANY_CORREDORA)){
                    gm.GroupId = grpCorredora[0].id;
                    gm.UserOrGroupId = u.Id;                
                }else if(u.CompanyName.equalsIgnoreCase(CONSTANTS.COMPANY_BANCO)){
                    gm.GroupId = grpBanco[0].id;
                    gm.UserOrGroupId = u.Id;                
                }else if(u.CompanyName.equalsIgnoreCase(CONSTANTS.COMPANY_SERVICIOS)){
                    gm.GroupId = grpServicios[0].id;
                    gm.UserOrGroupId = u.Id;
                }
                gmInsert.add(gm);
            }
            
            if(!oldGroup.isEmpty() && oldGroup != null){
                delete oldGroup;
            }
            
            if(!gmInsert.isEmpty() && gmInsert != null){
                insert gmInsert;
            } 
            
            if (!userId.isEmpty() && userId != null) {
                if(!Test.isRunningTest() && !system.isBatch()){
                    SalesCallout.consultUserAnalyticsAsyncMassive(userId,CONSTANTS.MODIFIED,CONSTANTS.ANALYTICSLEAD);
                }
            }
            
        }catch(Exception e){
            Trigger.new[0].addError(e.getMessage());  
        }
        
    }
}