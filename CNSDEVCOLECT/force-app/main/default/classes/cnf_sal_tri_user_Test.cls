@IsTest
private class cnf_sal_tri_user_Test {
    @testSetup 
    static void dataload(){
        TestFactorySales.populateOrg();
    }

    @isTest private static void usrIsActive(){
        Test.startTest();
        Test.stopTest();
        User newUsr =TestFactorySales.createUser('24770129k', 'System Administrator', 'señor45');     
        User usr = [SELECT Id FROM User WHERE RUT__c = '19' LIMIT 1];
        System.runAs(newUsr){
            usr.isActive=false;
            Update usr;
            User user4 =TestFactorySales.createUser('24770128k', 'Ejecutivo de venta', 'señor47'); 
            insert user4;
        }      
        User usrc = [SELECT Id,RUT__C FROM User WHERE RUT__c = '24770128k' LIMIT 1];
        //Crear usuario Seguros
        User usrSeg = TestFactorySales.createUserWithCompany('222242878', 'Ejecutivo Especialista', 'usrSeg', CONSTANTS.COMPANY_SEGUROS);
        //Crear usuario Corredora
        User usrCor = TestFactorySales.createUserWithCompany('234475878', 'Ejecutivo Especialista', 'usrCor', CONSTANTS.COMPANY_CORREDORA);
        //Crear usuario Banco
        User usrBan = TestFactorySales.createUserWithCompany('244000606', 'Ejecutivo Especialista', 'usrBan', CONSTANTS.COMPANY_BANCO);
        //Crear usuario Servicios
        User usrSer = TestFactorySales.createUserWithCompany('11416271K', 'Ejecutivo Especialista', 'usrSer', CONSTANTS.COMPANY_SERVICIOS);
        System.assertEquals(usr.isActive,false);
        System.assertEquals(usrc.RUT__c,'24770128k');       
    }

    @isTest static void updateUserTest(){
        Id profileId = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') OR (Name = 'Administrador del Sistema') LIMIT 1].Id;
        List<User> lstUser = [SELECT Id FROM User WHERE isActive = TRUE AND ProfileId =:profileId];
        upsert new Consorcio_Org__c(SetupOwnerId=lstUser[0].Id,Sales_project__c=true, Validation_rules__c = true); 
		
        User usrNew;
        User usrSeg;
        System.runAs(lstUser[0]){
            Test.startTest();
        	User newUsr = TestFactorySales.createUserWithCompany('27','Ejecutivo Especialista','testCNS', Constants.COMPANY_BANCO);
        	User newUsrSeg = TestFactorySales.createUserWithCompany('152833547','Ejecutivo Especialista','testSeg', Constants.COMPANY_SEGUROS);
            usrNew = newUsr;
            usrSeg = newUsrSeg;
            
            newUsr.CompanyName = Constants.COMPANY_CORREDORA;
            newUsrSeg.CompanyName = CONSTANTS.COMPANY_SERVICIOS;
            update newUsr;
            update newUsrSeg;
            Test.stopTest();
            
        }
        system.assertEquals(usrNew.CompanyName, Constants.COMPANY_CORREDORA);
        system.assertEquals(usrSeg.CompanyName, Constants.COMPANY_SERVICIOS);
    }
    
}