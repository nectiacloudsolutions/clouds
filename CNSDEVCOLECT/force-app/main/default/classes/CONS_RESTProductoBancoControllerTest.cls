@isTest
public class CONS_RESTProductoBancoControllerTest {
    static testMethod void Test1() {
        Producto_Banco__c  prb=new Producto_Banco__c();
        prb.name='qwer';
        prb.Id_Interno_Nectia__c='123456543';
        insert prb;
        account acc=new account();
        acc.RUT__c='23229614-3';
        acc.name='test';
       
        insert acc;
        string json='{"rut_cliente":"23229614-3",'+
            '"estado":"activo",'+
            '"id_producto":"123456543",'+
            '"nombre_producto":"nombre producto test",'+
            '"id_operacion":"123123123"}';
        test.startTest();
        CONS_EstructuraproductoBanco_JSON  resp=(CONS_EstructuraproductoBanco_JSON) System.JSON.deserialize(json, CONS_EstructuraproductoBanco_JSON.class); 
        CONS_EstructuraproductoBanco_JSON.parse(json);
        CONS_Respuestaproducto_JSON.parse(json);
        list<CONS_EstructuraproductoBanco_JSON> resp1=new list<CONS_EstructuraproductoBanco_JSON>();
        resp1 =new list<CONS_EstructuraproductoBanco_JSON>();
        resp1.add(resp);
        CONS_RESTProductoBancoController.CrearActuaizarproductoclienteBanco(resp1);
        test.stopTest();
        
    }
    static testMethod void Test2() {
        Producto_Banco__c  prb=new Producto_Banco__c();
        prb.name='qwer';
        prb.Id_Interno_Nectia__c='123456543';
        insert prb;
        
        account acc=new account();
        acc.RUT__c='23229614-3';
        acc.name='test';
      
        insert acc;
        
       Producto_del_Cliente__c proc=new Producto_del_Cliente__c();
       proc.Id__c='123123123'; 
        proc.Cliente_Nectia__c=acc.id; 
        proc.RecordTypeId=[select id from RecordType where Name=:'Producto cliente Banco'].id;
        proc.Estado_Nectia__c=''; 
        proc.Producto_de_Banco_Nectia__c=prb.id; 
        proc.Name=prb.name;
       insert proc;
        string json='{"rut_cliente":"23229614-3",'+
            '"estado":"activo",'+
            '"id_producto":"123456543",'+
            '"nombre_producto":"nombre producto test",'+
            '"id_operacion":"123123123"}';
        test.startTest();
        CONS_EstructuraproductoBanco_JSON  resp=(CONS_EstructuraproductoBanco_JSON) System.JSON.deserialize(json, CONS_EstructuraproductoBanco_JSON.class); 
        CONS_EstructuraproductoBanco_JSON.parse(json);
        
        list<CONS_EstructuraproductoBanco_JSON> resp1=new list<CONS_EstructuraproductoBanco_JSON>();
        resp1 =new list<CONS_EstructuraproductoBanco_JSON>();
        resp1.add(resp);
        CONS_RESTProductoBancoController.CrearActuaizarproductoclienteBanco(resp1);
        test.stopTest();
        
    }
    
}