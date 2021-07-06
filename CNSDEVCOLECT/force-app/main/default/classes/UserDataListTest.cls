@isTest
private with sharing class UserDataListTest {

    @testSetup
    private static void loadDataConfig(){
        TestFactorySales.populateOrg();
    }

    @isTest
    static void UserDataListTest() {
		Test.startTest();
        
        String json = ('{"message": "TEST","action": "OK","code": "0"}');
 
		UsersDataList respuesta = UsersDataList.parse(json);
        Test.stopTest();
 		
        System.assertEquals(respuesta.action, Constants.OK);
    }
}