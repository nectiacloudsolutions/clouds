@istest
public class CONS_modalbotonesTest {
 static testMethod void Test1() {
     CONS_modalbotones  vm=new CONS_modalbotones();
     CONS_modalbotones.getAccount(null);
      account  acc=new account();
        acc.Name='test';
        acc.rut__c='15555555-6';
        insert acc;
        Contact con=new Contact();
        con.LastName='test';
        con.AccountId=acc.id;
        con.Email='test@test.cl';
        insert con;
     CONS_modalbotones.saveContactWithAccount(con,null);
    }
}