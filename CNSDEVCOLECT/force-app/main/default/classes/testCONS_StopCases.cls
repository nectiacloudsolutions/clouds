@isTest
public class testCONS_StopCases {
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
         
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Corredora'].id;
        cas.Accountid=acc.id;
        cas.ContactId = con.Id;
        cas.Rut_del_Cliente__c='1233424';
        cas.Status='Nuevo';
        cas.Type='consulta';
        cas.Subtipo__c='clave internet';
        cas.Priority='alta';
        cas.Origin='web';
        cas.Description='problemas de clave de acceso';
        cas.Subject='reclamo';
        cas.SlaStartDate=System.now(); 
        insert cas;
     
     ApexPages.StandardController  astc=new ApexPages.StandardController(cas);
      
       CONS_StopCases sc=new CONS_StopCases(astc);
     
     sc.Stopcases();
     sc.continuar();
     sc.StartCases();
    
 }
}