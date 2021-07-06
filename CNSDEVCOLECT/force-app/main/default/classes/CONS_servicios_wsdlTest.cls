@isTest
public class CONS_servicios_wsdlTest {
 
    
    static testMethod void Test() {
       account  acc=new account();
        acc.Name='test';
        acc.rut__c='1233424';
        insert acc;
        Contact con=new Contact();
        con.LastName='test';
        con.AccountId=acc.id;
        con.Email='test@test.cl';
        insert con;
        
        
        Cons_servicios_wsdl.Validacliente  v=new Cons_servicios_wsdl.Validacliente();
        v.rut='1233424';
        Cons_servicios_wsdl.consultaclienteURL(v);
          v.rut='123342';
        Cons_servicios_wsdl.consultaclienteURL(v);
    } 
     
}