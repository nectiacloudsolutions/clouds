@isTest(SeeAllData=false)
private class InfoUserBatch_Test {
	@TestSetup
    static void CargaFactory(){
        
        TestFactorySales.populateOrg();   
        TestFactorySales.makeCustomSettings();
        User User = TestFactorySales.createUserWithCompany('235364425', 'Jefe de Ventas', 'Test',CONSTANTS.COMPANY_SEGUROS);
    }
        
    
    @isTest
    static void PruebaInfoUser(){
       	String CRON_EXP = '0 0 0 15 3 ? 2022';
        Test.startTest();
        InfoUserScheduler infuser = new InfoUserScheduler();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, infuser);
        infuser.execute(null);
        Test.stopTest();
    }
}