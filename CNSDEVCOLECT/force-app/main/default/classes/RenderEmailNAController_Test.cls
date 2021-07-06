@isTest
public class RenderEmailNAController_Test {
    @isTest
    public static void renderEmailNAControllerConstructorTest(){
        renderEmailNAController renderTest2 = new renderEmailNAController();
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        Account acc = (Account)mpsObjects.get('Account');
        User use = (User)mpsObjects.get('User');
        Test.StartTest(); 
        system.runAs(use){
            ApexPages.currentPage().getParameters().put('IdAcc', String.valueOf(acc.Id));
            renderEmailNAController renderTest = new renderEmailNAController();
            renderTest.IdAcc = '0012f00000WilpAAAR';
            
            List<EmailTemplate> et = [SELECT Id,body,DeveloperName,HtmlValue, Markup, Name 
                                      FROM EmailTemplate Where DeveloperName =: Constants.TEMPLATE_PDF_LEGAL_NOTAGREE LIMIT 1];
            System.assertNotEquals(renderTest.body,et[0].body);
        }      
        Test.StopTest();
    }
}