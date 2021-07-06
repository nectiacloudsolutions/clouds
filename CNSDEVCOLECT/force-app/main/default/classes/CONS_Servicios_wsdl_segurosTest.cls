@isTest
public class CONS_Servicios_wsdl_segurosTest {
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
        
        
        CONS_Servicios_wsdl_seguros.Validacliente  v=new CONS_Servicios_wsdl_seguros.Validacliente();
        v.rut='1233424';
        CONS_Servicios_wsdl_seguros.consultaclienteURL(v);
          v.rut='123342';
        CONS_Servicios_wsdl_seguros.consultaclienteURL(v);
    } 
}