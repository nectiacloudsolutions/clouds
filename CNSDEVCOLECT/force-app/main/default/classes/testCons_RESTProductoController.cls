@isTest
public class testCons_RESTProductoController {
    static testMethod void Test1() {
        
        string json='{'+
            '"rut":"16883497-7",'+
            '"productos":[{'+
            '	"codigo":"123456",'+
            '	"nombreproducto": "APV",'+
            '	"tipo":"Cuenta Inversiones",'+
            '	"fecha":"2018-09-01",'+
            '	"producto":"Fondos Mutuos",'+
            '	"estado":"activo"'+
            '}]}';
        Cons_estructuraproducto_JSON  resp=(Cons_estructuraproducto_JSON) System.JSON.deserialize(json, Cons_estructuraproducto_JSON.class); 
       Cons_estructuraproducto_JSON.parse(json);
       
        Cons_RESTproductocontroller.crearproducto(resp);
        
    }
      static testMethod void Test2() {
        
          account  acc=new account();
        acc.Name='test';
        acc.rut__c='16883497-7';
        insert acc;
          
        string json='{'+
            '"rut":"16883497-7",'+
            '"productos":[{'+
            '	"codigo":"123456",'+
            '	"nombreproducto": "APV",'+
            '	"tipo":"Cuenta Inversiones",'+
            '	"fecha":"2018-09-01",'+
            '	"producto":"Fondos Mutuos",'+
            '	"estado":"activo"'+
            '}]}';
        Cons_estructuraproducto_JSON  resp=(Cons_estructuraproducto_JSON) System.JSON.deserialize(json, Cons_estructuraproducto_JSON.class); 
       
       
        Cons_RESTproductocontroller.crearproducto(resp);
        Cons_RESTproductocontroller.crearproducto(resp);
    }
}