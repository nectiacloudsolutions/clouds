@isTest
public class RenderEmailController_Test {
    @isTest
    public static void renderEmailControllerConstructorTest(){
        renderEmailController renderTest2 = new renderEmailController();
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        Account acc = (Account)mpsObjects.get('Account');
        User use = (User)mpsObjects.get('User');
        Test.StartTest(); 
        system.runAs(use){
            ApexPages.currentPage().getParameters().put('IdAcc', String.valueOf(acc.Id));
            renderEmailController renderTest = new renderEmailController();
            renderTest.IdAcc = '0012f00000WilpAAAR';
            List<EmailTemplate> et = [SELECT Id,body,DeveloperName,HtmlValue, Markup, Name 
                                      FROM EmailTemplate Where DeveloperName =: Constants.TEMPLATE_PDF_LEGAL_AGREE LIMIT 1];
            
            System.assertNotEquals(renderTest.body,et[0].body);
        }     
        Test.StopTest();
    }
}