@isTest
private class testCons_RESTClienteController {
  static testMethod void Test() {
      //cliente persona corredora 
   Cons_EstructuraCliente_JSON es=new Cons_EstructuraCliente_JSON();
    
 string     json= '{'+
'"entidad": "corredora",'+
'"clientes": [{'+
   '        "RUT": "16883497-7",'+
   '        "Nombrecompleto": "Jorge eduardo",'+
  '         "PrimerApellido": "carvajal",'+
  '         "Correoelectronico": "test@test.com",'+
  '         "Movil": "992496617",'+
  '         "FATCA": 0,'+
 '         "Tipo": "0",'+
 '          "Agente": "",'+
 '          "ClasificacionRiesgo": null,'+
 '          "CodigodeAgente": "@",'+
 '          "Consentimiento": 1,'+
 '          "Genero": "MASCULINO",'+
 '          "IDinterno": 79128,'+
 '          "Nacionalidad": "CHILENO",'+
 '          "NCG380": 1,'+
 '          "PEP": 1,'+
 '          "PlantilladeComision": "TPCOBINTB",'+
 '          "Profesion": "25",'+
 '          "EstadoCivil": "CASADO",'+
 '          "Regimenconyugal": "Separación total de Bienes",'+
 '          "Segmento": "Bajo",'+
 '          "Simultaneas": 1,'+
 '          "Estado": "Cliente",'+
 '          "Subestado": "Sin Validar",'+
 '          "Fechadenacimiento": "1965-10-31 00:00:00.0",'+
 '          "NivelEducacional": "",'+
 '          "Ocupacion": "Informatica",'+
 '          "SegundoApellido": "crespo",'+
 '          "Nombredelacuenta": "",'+
 '          "Telefono": "22222222",'+
 '          "Direccion": "53 urbinas",'+
 '          "Ciudad": "santiago",'+
 '          "Region": "metropolitana",'+
 '          "Pais": "chile",'+
 '          "perfilinv":"Conservador",'+          
 '          "productos":[{'+
 '                   "codigo":"123456",'+
 '                   "tipo":"Cuenta Inversiones",'+
'                    "fecha":"2018-09-01",'+
'                    "producto":"APV",'+
'                    "estado":"activo",'+
'                    "id":"16883497750"'+
'                    }]'+
'}'+
']'+
'}';
      system.debug('json'+json);
     
        es=(Cons_EstructuraCliente_JSON) System.JSON.deserialize(json, Cons_EstructuraCliente_JSON.class); 
  test.startTest();
Cons_EstructuraCliente_JSON.parse(json);
      Cons_Respuesta_JSON.parse(json);
     
    
     //crear   cuenta
         Cons_RESTClienteController.CrearActuaizarCuenta(es);
     //acctualizar cuenta
         Cons_RESTClienteController.CrearActuaizarCuenta(es);
     test.stopTest(); 
            }

static testMethod void Test2() {
      //cliente empresa corredora 
   
 string     json= '{'+
'"entidad": "corredora",'+
'"clientes": [{'+
'           "RUT": "76604116-7",'+
'           "Nombrecompleto": "empresa nectia",'+
'           "Segmento": "Bajo",'+
'           "Correoelectronico": "test@test.com",'+
'           "Telefono": "22222222",'+
'           "Tipo": "Cliente Empresa Corredora",'+
'           "Nacionalidad": "CHILENO",'+
'           "CodigodeAgente": "@CNS",'+
'           "Nombredelacuenta": null,'+
'           "Direccion": "53 urbinas",'+
'           "Ciudad": "santiago",'+
'           "Region": "metropolitana",'+
'           "Pais": "chile",'+
'           "perfilinv":"Conservador" ,'+
'           "Estado": "Cliente",'+
'           "Subestado": "Sin Validar",'+
'           "Consentimiento": 1,'+
'           "contactos": [{'+
'                    "nombrecontacto":"juanito",'+
'                    "apellidocontacto":"pere",'+
'                    "telefonomovil":"123456",'+
'                    "correocontacto": "test@test.com",'+
'                    "Cargo":"1",'+
'                    "Genero":"Masculino",'+
'                    "Rutcontacto":"16883497-7"'+
'                    }],'+
'           "productos":[{'+
'                    "codigo":"123456",'+
'                    "tipo":"Cuenta Inversiones",'+
'                    "fecha":"2018-09-01",'+
'                    "producto":"APV",'+
'                    "estado":"activo",'+
'                    "id":"16883497750"'+
 '                   },{'+
 '                   "codigo":"1234562345",'+
 '                   "tipo":"Cuenta Inversiones",'+
 '                   "fecha":"2018-09-01",'+
 '                   "producto":"APV",'+
 '                   "estado":"activo",'+
 '                   "id":"16883497751"'+
'                    }]'+
'}]}';

       Cons_EstructuraCliente_JSON es=new Cons_EstructuraCliente_JSON();
    test.startTest();
        es=(Cons_EstructuraCliente_JSON) System.JSON.deserialize(json, Cons_EstructuraCliente_JSON.class); 
     //crear   cuenta empresa 
         Cons_RESTClienteController.CrearActuaizarCuenta(es);
     //acctualizar cuenta empresa
         Cons_RESTClienteController.CrearActuaizarCuenta(es);
    test.stopTest();
            }
   
    static testMethod void Test3() {
      //cliente empresa corredora 
   
 string     json= '{'+
                               '"entidad": "corredora",'+
                               '"clientes": [{'+
                                                               '"RUT": "20198775-k",'+
                                                               '"Nombrecompleto": "Wladimir",'+
                                                               '"Correoelectronico": "fpedraza@consorciocb.cl",'+
                                                               '"Tipo": "Cuenta Personal",'+
                                                               '"CodigodeAgente": "@",'+
                                                               '"Nombredelacuenta": "",'+
                                                               '"Telefono": "97263061",'+
                                                               '"Estado": "Prospecto",'+
                                                               '"Subestado": "En Proceso",'+
                                                               '"Consentimiento": "1",'+
                                                               '"Direccion": "Agua Santa 2116",'+
                                                               '"Ciudad": "Santiago",'+
                                                               '"Region": "Región Metropolitana",'+
                                                               '"Pais": "Chile",'+
                                                               '"perfilinv": "",'+
                                                               '"Segmento": "",'+
                                                               '"fechaincorporacion": "2018-10-08 11:37:00.0",'+
                                                               '"productos": [],'+
                                                               '"PrimerApellido": "Torres ",'+
                                                               '"SegundoApellido": "Muñoz",'+
                                                               '"Movil": "72630611",'+
                                                               '"FATCA": 0,'+
                                                               '"Agente": "",'+
                                                               '"Genero": "MASCULINO",'+
                                                               '"IDinterno": 91356,'+
                                                               '"Nacionalidad": "CL",'+
                                                               '"NCG380": 1,'+
                                                               '"PEP": 0,'+
                                                               '"PlantilladeComision": "TPCOBINTA",'+
                                                               '"Profesion": "47",'+
                                                               '"EstadoCivil": "SOLTERO",'+
                                                               '"Regimenconyugal": "",'+
                                                               '"Simultaneas": 0,'+
                                                               '"Fechadenacimiento": "1999-04-19 00:00:00.0",'+
                                                               '"NivelEducacional": "",'+
                                                               '"Ocupacion": "",'+
                                                               '"ClasificacionRiesgo": ""'+
                                               '}]}';

       Cons_EstructuraCliente_JSON es=new Cons_EstructuraCliente_JSON();
    test.startTest();
        es=(Cons_EstructuraCliente_JSON) System.JSON.deserialize(json, Cons_EstructuraCliente_JSON.class); 
     //crear   cuenta empresa 
         Cons_RESTClienteController.CrearActuaizarCuenta(es);
     
    test.stopTest();
            }
}