@isTest
public class testCons_relatedProductsExtension {
    static testMethod void Test1() {
        account  acc=new account();
        acc.Name='test';
        acc.rut__c='16883497-7';
        insert acc;
        test.startTest();  
        ApexPages.StandardController  astc=new ApexPages.StandardController(acc);
        relatedProductsExtension rpe=new relatedProductsExtension(astc);
        
        rpe.crearCaso();
        test.stopTest();
    }
}