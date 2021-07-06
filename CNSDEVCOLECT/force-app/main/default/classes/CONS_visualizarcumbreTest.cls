@isTest
public class CONS_visualizarcumbreTest {
static testMethod void Test1() {

      account ac=new account();
     ac.Name='test';
     ac.RUT__c='123';

     insert ac;
  Contact con=new Contact();
        con.LastName='test';
        con.AccountId=ac.id;
           con.Email='test@test.cl';
        insert con;
    Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Corredora'].id;
        cas.Accountid=ac.id;
        cas.ContactId = con.Id;
        cas.Rut_del_Cliente__c='1233424';
        cas.Status='En proceso';
        cas.Type='consulta';
        cas.Subtipo__c='clave internet';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        
        insert cas;
  
     ApexPages.currentPage().getParameters().put('id', cas.id);

    ApexPages.StandardController   apst=new ApexPages.StandardController(cas);
    CONS_visualizarcumbre cu=new  CONS_visualizarcumbre(apst);
    
    
    
  
   
    
}
}