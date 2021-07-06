@isTest
public class testCons_urlcontroller {
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
        //cas.Rut_del_Cliente__c='1233424';
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
    Cons_urlcontroller cu=new  Cons_urlcontroller(apst);
    
     string str='{ "codigo": "-1", "mensaje": "Error Validacion: rutEjecutivo no valido"}';
    Cons_Respuestaserviciourl_JSON  resser=new Cons_Respuestaserviciourl_JSON();
   
    Cons_Respuestaserviciourl_JSON.parse(str);
  
   
    
}
}