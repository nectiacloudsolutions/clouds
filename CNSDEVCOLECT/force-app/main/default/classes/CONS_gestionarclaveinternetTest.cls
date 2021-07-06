@isTest
public class CONS_gestionarclaveinternetTest {
    static testMethod void Test1() {
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName='test';
        acc.rut__c='15555555-6';
        acc.PersonEmail='test@test.cl';
        acc.RecordTypeId=[select id from RecordType where Name=:'Cliente Persona Seguros'].id;
        insert acc;
        
        
        
        ApexPages.StandardController  apsc=new ApexPages.StandardController(acc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_gestionarclaveinternet'));
        System.currentPageReference().getParameters().put('id', acc.Id);
        CONS_gestionarclaveinternet cgc=new CONS_gestionarclaveinternet(apsc);
        cgc.tipodeseguro();
        cgc.siguiente();
        cgc.verificaemail();
        cgc.guardar();
        cgc.Guardarremoto();
        cgc.desbloquear();
        cgc.nuevaclave();
        cgc.rechazaclave();
        cgc.servicioerror();
        cgc.volver();
        cgc.continuar();
    }
       static testMethod void Test2() {
        account  acc=new account();
        acc.Name='test';
        acc.rut__c='15555555-6';
        insert acc;
        Contact con=new Contact();
        con.LastName='test';
        con.AccountId=acc.id;
        con.Email='test@test.cl';
        insert con;
        
        ApexPages.StandardController  apsc=new ApexPages.StandardController(acc);
        Test.setCurrentPageReference(new PageReference('Page.CONS_gestionarclaveinternet'));
        System.currentPageReference().getParameters().put('id', acc.Id);
            System.currentPageReference().getParameters().put('tipo', 'Nueva_clave');
        CONS_gestionarclaveinternet cgc=new CONS_gestionarclaveinternet(apsc);
        cgc.opcion='Nueva Clave';
        cgc.tipodeseguro();
        cgc.siguiente();
        cgc.verificaemail();
        cgc.guardar();
        cgc.Guardarremoto();
       // cgc.desbloquear();
        cgc.nuevaclave();
        cgc.rechazaclave();
        cgc.servicioerror();
        cgc.volver();
        cgc.continuar();
    }
        static testMethod void Test3() {
          CONS_Respuestasolicitudclave_JSON   re=new CONS_Respuestasolicitudclave_JSON();
            string stw='{"Codigo":"400", "mensaje":"ok"}';
            re=CONS_Respuestasolicitudclave_JSON.parse(stw);
            
        }
    
    
    
     static testMethod void Test4() {
        account  acc=new account();
        acc.FirstName='test';
        acc.LastName='test';
        acc.rut__c='15555555-6';
        acc.PersonEmail='test@test.cl';
        acc.RecordTypeId=[select id from RecordType where Name=:'Cliente Persona Seguros'].id;
        insert acc;
         
        Case cas=new Case();
        cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
        cas.Accountid=acc.id;
         cas.Status='Nuevo';
        cas.Subtipo__c='Gestión Clave';
        cas.Type='Solicitud';
        cas.Subject='se requierer validacion';
        cas.Priority='Media';
        cas.Subject='nueva clave';
        insert cas;
        
        
        
         System.currentPageReference().getParameters().put('id', cas.Id);
         CONS_GestionarclaveinternetReintento   cgcr=new  CONS_GestionarclaveinternetReintento();
         cgcr.verificaemail();
    }
       static testMethod void Test5() {
           
           account  acc=new account();
           acc.FirstName='test';
           acc.LastName='test';
           acc.rut__c='15555555-6';
           acc.PersonEmail=null;
           acc.RecordTypeId=[select id from RecordType where Name=:'Cliente Persona Seguros'].id;
           insert acc;
           
           Case cas=new Case();
           cas.RecordTypeId=[SELECT Id FROM RecordType where SobjectType='case' and Name ='Casos Seguros'].id;
           cas.Accountid=acc.id;
           cas.Status='Nuevo';
           cas.Subtipo__c='Gestión Clave';
           cas.Type='Solicitud';
           cas.Subject='se requierer validacion';
           cas.Priority='Media';
           cas.Subject='nueva clave';
           insert cas;  
           
        
         System.currentPageReference().getParameters().put('id', cas.Id);
         CONS_GestionarclaveinternetReintento   cgcr=new  CONS_GestionarclaveinternetReintento();
         cgcr.verificaemail();
         cgcr.continuar();
    }
    
}