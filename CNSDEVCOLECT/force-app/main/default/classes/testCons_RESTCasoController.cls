@isTest
public class testCons_RESTCasoController {
    //COMENTAR
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
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Casos/buscarcasos'; 
        req.addParameter('rut', '1233424');
        req.httpMethod = 'GET'; 
        RestContext.request = req;
        RestContext.response = res;
        
        
        Cons_RESTCasoController.buscarcasos();
        
    }



     static testMethod void Test2() {
         
            string JSON='{'+
' "rut":"16883497-7",'+
' "productocuenta": "",'+
' "tipo":"Solicitud",'+
' "subtipo":"Certificados, Cartolas y Patentes",'+
' "prioridad":"alta",'+
' "origen":"web",'+
'   "asunto":"Certificados, Cartolas y Patentes",'+
'    "glosa":"test Certificados, Cartolas y Patentes"'+
'}';
    Cons_estructurarespuestacaso_JSON es=new Cons_estructurarespuestacaso_JSON();
        Cons_estructurarespuestacaso_JSON.parse(json);
         
     }
    static testMethod void Test3() {
        
        account  acc=new account();
        acc.Name='test';
        acc.rut__c='1233424';
        insert acc;
        
        Contact con=new Contact();
        con.LastName='test';
        con.AccountId=acc.id;
           con.Email='test@test.cl';
        insert con;
        
        Cons_RESTCasoController rescas=new Cons_RESTCasoController();
        rescas.test='1'; 
     
   Cons_RESTCasoController.crearcaso('1233424', '', 'Solicitud', 'Certificados, Cartolas y Patentes', 'alta', 'web', 'reclamo', 'problemas ','','','0');
     Cons_RESTCasoController.crearcaso('1233424', '', 'Consulta', 'Certificados, Cartolas y Patentes', '', '', 'Consulta', 'problemas ','','','Comex');
}

}