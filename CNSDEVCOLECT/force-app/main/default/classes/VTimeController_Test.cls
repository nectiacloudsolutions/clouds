/**
 * @File Name          : VTimeController_Test.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : eayalcor@everis.com
 * @Last Modified On   : 09-01-2020 10:59:03
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    09-01-2020   eayalcor@everis.com     Initial Version
**/
@isTest
private class VTimeController_Test {
	
    /**
    * @description Test method for getConsultVtime
    * @author eayalcor@everis.com | 09-01-2020 
    * @return void 
    **/
    @isTest
    static void getConsultVTimeTest(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();
        TestFactorySales.createConsorcioOrg();       
        Account acc = (Account)mpsObjects.get('Account');
        Id idProd2 = Test.getStandardPricebookId(); 
        User user = (User)mpsObjects.get('User');
        Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,user.Id);
        Quote qte = (Quote)mpsOppObjects.get('Quote');
        
        
        System.runAs(user){
            
            Test.startTest();
            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'OK',
                                                     '{"banco": "Banco Santiago","descripcion": "Activado","numeroMandato": "37633","numeroPoliza": 4033873,"resultado": 0}',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            VTimeClass vtime = VTimeController.getConsultVTime(qte.Id);
            VTimeClass vtime2 = VTimeController.getConsultVTime('');
            Boolean isStageOK = VTimeController.getOppStage(qte.id);
            Test.stopTest();
            System.assertEquals(Constants.OK, vtime.codigo);
            System.assertEquals(Constants.NOK, vtime2.codigo);
            System.assertEquals(false, isStageOK);
        }
    }
    
}