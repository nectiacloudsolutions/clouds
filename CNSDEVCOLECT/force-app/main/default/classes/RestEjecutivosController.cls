@RestResource(urlMapping='/Ejecutivos/*')  //  https://xxx.salesforce.com/services/apexrest/Ejecutivos/ObtenerEjecutivosPlus
global with sharing class RestEjecutivosController {
    
    @HttpGet
    global static UsersDataList ObtenerEjecutivosPlus() { 
        List<User> listadoUsers = new List<User>();
        UsersDataList respuesta = new UsersDataList();

		
        listadoUsers = [SELECT Id,RUT__C, Firstname, Lastname, Email, CompanyName, Manager.FirstName,Manager.LastName, Manager.Email, Zonales__c FROM User WHERE isActive = TRUE and UserRole.developername like '%ejecutivo%plus%'  ];	
        
        if(listadoUsers!=null && listadoUsers.size()>0){
            respuesta.message='Usuarios encontrados exitosamente';
            respuesta.action='OK'; 
            respuesta.code='0'; 
            respuesta.userList = listadoUsers;
        }else{
            respuesta.message='No existen usuarios';
            respuesta.action='OK'; 
            respuesta.code='1'; 
            
        }
        
        return respuesta;
    }
    
    @HttpPost
    global static EjecutivosClienteResponse obtenerNombresEjecutivosDeCliente() {
        RestRequest req = RestContext.request;
		string rutCliente = req.params.get('rutCliente');
        EjecutivosClienteResponse response = new EjecutivosClienteResponse();        

        Account[] ejecutivoBanco = [SELECT Rut_Ejecutivo_Banco__c, Nombre_Ejecutivo_Banco__c, Correo_Ejecutivo_Banco__c FROM Account WHERE RUT__c =:rutCliente LIMIT 1];
        Account[] ejecutivoSeguros = [SELECT Rut_Ejecutivo_Seguros__c, Nombre_Ejecutivo_Seguros__c, Correo_Ejecutivo_Seguros__c FROM Account WHERE RUT__c =:rutCliente LIMIT 1];

        if(ejecutivoBanco.size() == 0 && ejecutivoSeguros.size() == 0){
            response.message = 'No se encontraron ejecutivos de cliente';
            response.action = 'OK';
            response.code = '0';
        } else {
            response.message = 'Búsqueda de ejecutivos terminado con éxito';
            response.action = 'OK';
            response.code = '0';
            
            response.ejecutivoBanco = ejecutivoBanco[0];
            response.ejecutivoSeguros = ejecutivoSeguros[0];
        } 
        
        return response;
    }
    
}