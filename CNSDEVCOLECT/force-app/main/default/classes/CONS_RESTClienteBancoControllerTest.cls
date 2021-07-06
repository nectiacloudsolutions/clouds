@istest
public class CONS_RESTClienteBancoControllerTest {
 static testMethod void Test() {
      //cliente persona corredora 
   CONS_EstructuraClienteBanco_JSON es=new CONS_EstructuraClienteBanco_JSON();
    
 string     json= '{"RUT":"23229614-3",'+
            '"Nombre":"nombre test",'+
            '"Apellido_paterno":"paterno",'+
            '"Apellido_materno":"materno",'+
            '"Telefono":"12345678765432",'+
            '"Correoelectronico":"test1@test.cl",'+
            '"Tipo":"1",'+
            '"id_Tipo":"1",'+
            '"banca":"Pensionado",'+
            '"id_banca":"1"'+

'}';
      system.debug('json'+json);
     
        es=(CONS_EstructuraClienteBanco_JSON) System.JSON.deserialize(json, CONS_EstructuraClienteBanco_JSON.class); 
  test.startTest();
CONS_EstructuraClienteBanco_JSON.parse(json);
      CONS_Respuestabanco_JSON.parse(json);
    list<CONS_EstructuraClienteBanco_JSON> resp1=new list<CONS_EstructuraClienteBanco_JSON>();  
     resp1 =new list<CONS_EstructuraClienteBanco_JSON>();
        resp1.add(es);
     //crear   cuenta
         CONS_RESTClienteBancoController.CrearActuaizarclientesBanco(resp1);
     //acctualizar cuenta
         CONS_RESTClienteBancoController.CrearActuaizarclientesBanco(resp1);
     test.stopTest(); 
            }

    static testMethod void Test1() {
        CONS_Respuestabanco_JSON cres=new  CONS_Respuestabanco_JSON();
      string json='{"codigo":"232296143",'+
                  '"mensaje":"test"}';       
        
cres=(CONS_Respuestabanco_JSON) System.JSON.deserialize(json, CONS_Respuestabanco_JSON.class);         
    }
    
    
    
    
   
  
}