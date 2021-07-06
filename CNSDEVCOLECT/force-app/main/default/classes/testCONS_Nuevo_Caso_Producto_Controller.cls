@isTest
public class testCONS_Nuevo_Caso_Producto_Controller {
    
    static testMethod void Test1() {
        
        Recordtype registro = [Select Id from recordtype where Name = 'Cliente Persona Seguros'];
        account ac=new account();
        ac.FirstName='prueba';
        ac.LastName='Nectia';
        ac.RUT__c='123';
        ac.RecordTypeId = registro.id;
        insert ac;
        /*Contact con=new Contact();
        con.LastName='test';
        con.AccountId=ac.id;
        con.Email='test@test.cl';
        insert con;*/
        
        Producto_de_Corredora__c pcc=new Producto_de_Corredora__c();
        pcc.Name='apv';
        insert pcc;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Corredora'].id;
        pc.Cliente_Nectia__c=ac.id;
        pc.Producto_de_Corredora_Nectia__c=pcc.id;
        pc.Name='apv';
        pc.Id__c='12345678901';
        insert pc;
        
        string idr=[Select Id_Producto__c  from Tipo_de_registro_casos__mdt where DeveloperName ='Casos_Corredora' ].Id_Producto__c;
        test.startTest();
        ApexPages.currentPage().getParameters().put('idTipoRegistro', idr);
        ApexPages.StandardController  apst = new ApexPages.StandardController(pc);
        CONS_Nuevo_Caso_Producto_Controller cncp=new CONS_Nuevo_Caso_Producto_Controller(apst);
        
        cncp.cerrar();
        cncp.saveAndSee();
        cncp.saveAndClose();
        test.stopTest();
    }
    
    static testMethod void Test2() {
        
        Recordtype registro = [Select Id from recordtype where Name = 'Cliente Persona Seguros'];
        account ac=new account();
        ac.FirstName='prueba';
        ac.LastName='Nectia';
        ac.RUT__c='1223';
        ac.RecordTypeId = registro.id;
        insert ac;
       /* Contact con=new Contact();
        con.LastName='test';
        con.AccountId=ac.id;
        con.Email='test@test.cl';
        insert con;*/
        
        Producto_Banco__c prb=new Producto_Banco__c();
        prb.Name='apv';
        insert prb;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Banco'].id;
        pc.Cliente_Nectia__c=ac.id;
        pc.Producto_de_Banco_Nectia__c=prb.id;
        pc.Name='apv';
        pc.Id__c='123456789011';
        insert pc;
        
        string idr=[Select Id_Producto__c  from Tipo_de_registro_casos__mdt where DeveloperName ='Casos_Banco'].Id_Producto__c;
        test.startTest();
        ApexPages.currentPage().getParameters().put('idTipoRegistro', idr);
        ApexPages.StandardController  apst = new ApexPages.StandardController(pc);
        CONS_Nuevo_Caso_Producto_Controller cncp=new CONS_Nuevo_Caso_Producto_Controller(apst);
        
        
        cncp.cerrar();
        cncp.saveAndSee();
        cncp.saveAndClose();
        test.stopTest();
    }
    static testMethod void Test3() {
        
        Recordtype registro = [Select Id from recordtype where Name = 'Cliente Persona Seguros'];
        account ac=new account();
        ac.FirstName='prueba';
        ac.LastName='Nectia';
        ac.RUT__c='1223';
        ac.RecordTypeId = registro.id;
        insert ac;
        /*Contact con=new Contact();
        con.LastName='test';
        con.AccountId=ac.id;
        con.Email='test@test.cl';
        insert con;*/
        
        Producto_Banco__c prb=new Producto_Banco__c();
        prb.Name='apv';
        insert prb;
        
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Banco'].id;
        pc.Cliente_Nectia__c=ac.id;
        pc.Producto_de_Banco_Nectia__c=prb.id;
        pc.Name='apv';
        pc.Id__c='123456789011';
        insert pc;
        
        string idr=[Select Id_Producto__c  from Tipo_de_registro_casos__mdt where DeveloperName ='Casos_Banco'].Id_Producto__c;
        test.startTest();
        ApexPages.currentPage().getParameters().put('idTipoRegistro', idr);
        ApexPages.StandardController  apst = new ApexPages.StandardController(pc);
        CONS_Nuevo_Caso_Producto_Controller cncp=new CONS_Nuevo_Caso_Producto_Controller(apst);
        cncp.nuevoCaso.Subtipo_Auxiliar__c = 'Fraude - Desconoce transacción';
        cncp.nuevoCaso.Status='Cerrado';
        cncp.saveAndSee();
        
        cncp.nuevoCaso.Status='Nuevo';
        cncp.nuevoCaso.Fecha_y_hora_del_evento__c=null;
        cncp.nuevoCaso.Tipo_de_medio_de_pago__c='';
        cncp.nuevoCaso.Tipo_de_moneda__c='';
        cncp.nuevoCaso.Monto_reclamado__c=null;
        cncp.saveAndSee();
        
        cncp.nuevoCaso.Subtipo_Auxiliar__c = 'Bloqueo Tarjeta';
        cncp.nuevoCaso.Status='Nuevo';
        cncp.nuevoCaso.Tipo_de_medio_de_pago__c=null;
        cncp.nuevoCaso.Fecha_y_hora_del_evento__c=null;
        cncp.saveAndSee();
        
        cncp.nuevoCaso.Subtipo_Auxiliar__c = 'Bloqueo Cuenta';
        cncp.nuevoCaso.Status='Nuevo';
        cncp.nuevoCaso.Tipo_de_medio_de_pago__c=null;
        cncp.nuevoCaso.Fecha_y_hora_del_evento__c=null;
        cncp.saveAndSee();
        test.stopTest();
    }
    
    
    
    /*   
     static testMethod void Test3() {
        test.startTest();
        
        account ac=new account();
        ac.Name='test';
        ac.RUT__c='1238';
        insert ac;
        Contact con=new Contact();
        con.LastName='test';
        con.AccountId=ac.id;
        con.Email='test@test.cl';
        insert con;
        
        Producto_de_Seguros__c prs=new Producto_de_Seguros__c();
        prs.Name='apv';
        prs.Codigo_de_Producto_nectia__c='123456';
        insert prs;
        Producto_del_Cliente__c pc=new Producto_del_Cliente__c();
        pc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Corredora'].id;
        pc.Cliente_Nectia__c=ac.id;
        pc.Producto_de_Seguros_Nectia__c=prs.id;
        pc.Name='apv';
        pc.Id__c='123456789012';
        insert pc;
        
        string idr=[Select Id_Producto__c  from Tipo_de_registro_casos__mdt where DeveloperName ='Casos_Seguros' ].Id_Producto__c;
        
        ApexPages.currentPage().getParameters().put('idTipoRegistro', idr);
        ApexPages.StandardController  apst = new ApexPages.StandardController(pc);
        CONS_Nuevo_Caso_Producto_Controller cncp=new CONS_Nuevo_Caso_Producto_Controller(apst);
        
        cncp.cerrar();
        cncp.saveAndSee();
        cncp.saveAndClose();
        test.stopTest();
    }
    */
    
    
}