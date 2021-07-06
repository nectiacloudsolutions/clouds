@isTest
public class CONS_Opp_visualizarcumbreTest {
   static testMethod void TestCumbres() {

      Account ac = new Account();
      ac.Name = 'test';
      ac.RUT__c = '123';
      insert ac;

      Contact con = new Contact();
      con.LastName = 'test';
      con.AccountId = ac.id;
      con.Email = 'test@test.cl';
      insert con;

      Opportunity opp = new Opportunity();
      opp.RecordTypeId = [SELECT Id FROM RecordType where SobjectType='Opportunity' and Name ='RT Portabilidad financiera'].id;
      opp.Accountid = ac.id;
      opp.ContactId = con.Id;
      opp.Name = 'Test Opp';
      opp.CloseDate = System.today() + 20;
      opp.PF_Rut__c = '1233424';
      opp.StageName = 'Contacto';     
      insert opp;
   
      ApexPages.currentPage().getParameters().put('id', opp.id);
      ApexPages.StandardController apst = new ApexPages.StandardController(opp);
      CONS_Opp_visualizarcumbre cu = new CONS_Opp_visualizarcumbre(apst);   
   }
}