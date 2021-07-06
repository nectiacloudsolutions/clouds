@isTest
public class CONS_PagosTest {
  static testMethod void Test1() {
        account  acc=new account();
        acc.Name='test';
        acc.rut__c='1233424';
        insert acc;
        Contact con=new Contact();
        con.LastName='test';
        con.AccountId=acc.id;
        con.Email='test@test.cl';
        insert con;
        Producto_del_Cliente__c  pro = new Producto_del_Cliente__c();
        pro.Cliente_Nectia__c=acc.id;
        pro.Name='test';
        pro.Poliza_Nectia__c='1234789';
        pro.Tipo_Registro_Nectia__c='2';
        pro.Ramo_Nectia__c='1';
        pro.Codigo_Plan_Nectia__c='330';
        pro.Numero_Certificado_Nectia__c='1';
        pro.Esquema_Nectia__c='VTCNLIFE';  
      
        insert pro;
        ApexPages.StandardController  apsc=new ApexPages.StandardController(pro);
        CONS_Pagos cpp=new CONS_Pagos(apsc);
        cpp.listar_generales();
    }
}