/**
 * @File Name          : CallOutsAlertas.cls
 * @Description        : 
 * @Author             : nicolas.contreras@consorcio.cl
 * @Group              : 
 * @Last Modified By   : nicolas.contreras@consorcio.cl
 * @Last Modified On   : 04/02/2021, 03:06:00 PM
 * @Modification Log   : 
 * Ver       Date            Author      		          Modification
 * 1.0    04-02-2019   nicolas.contreras@consorcio.cl     Initial Version
**/

public class CalloutsAlertas {
    protected Sales_Connect__mdt sc;
    public CallOutsAlertas(String nameCredentials){
        this.sc = [SELECT password__c,URL_sales__c,username__c,user_pool_id__c,x_api_key__c,token__c,Callback_url__c,
                client_id__c,Client_Secret__c,Codigo_App__c,Codigo_Canal__c,Empresa_App__c,Modalidad__c
                FROM Sales_Connect__mdt WHERE DeveloperName=:nameCredentials LIMIT 1];
    }

    public CalloutsAlertas(){
        
    }

    /**
    * @description 
    * @author nicolas.contreras@consorcio.cl | 04/02/2021 
    * @param String url 
    * @param String json 
    * @param String method 
    * @return HttpRequest 
    **/
    private  HttpRequest requestAlerta(String url, String json, String method){
        String realToken;
        realToken=Test.isRunningTest() ? 'tokenTest' : getTokenByClientCredencial(); 
        
        HttpRequest request = new HttpRequest();
        
        request.setTimeout(120000);
        request.setMethod(method);
        request.setHeader('content-type','application/json');
        request.setEndpoint(url); 
        request.setHeader('Authorization','Bearer '+realToken);
        
        if(method.equalsIgnoreCase(Constants.REQUEST_METHOD_POST)){
            
            request.setBody(json);
        }
        
        return request;
    }


    /**
    * @description 
    * @author eayalcor@everis.com | 6/23/2020 
    * @return String 
    **/
    @TestVisible
    private String getTokenByClientCredencial(){
        string json='';
        String res;
        String url = sc.URL_sales__c;
       
        json='grant_type=password'+
            '&client_secret='+ EncodingUtil.urlEncode(sc.Client_Secret__c,'UTF-8')+
            '&client_id=' + EncodingUtil.urlEncode(sc.client_id__c,'UTF-8')+
            '&username='+ EncodingUtil.urlEncode(sc.username__c,'UTF-8')+
            '&password='+ EncodingUtil.urlEncode(sc.password__c,'UTF-8');

          
            //String json = JSON.serializePretty(dtResponse);
        
        System.debug('Payload --> ' + json);
               
        try{
            
            Http http =new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod(Constants.REQUEST_METHOD_POST);
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            request.setTimeout(120000);
            request.setEndpoint(url); 
            request.setBody(json);
            HttpResponse response = http.send(request);
            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){

                   res=response.getbody();
                   
               }else{
                   res='{"access_token": "-1", "token_type": "Servicio no disponible"}';
               }
            
        }catch(Exception e){
            res='{"access_token": "-1", "token_type": "Servicio no disponible"}';
            System.debug('Error -->' + e.getStackTraceString());
        } 
        System.debug('Objeto Token ' + res);
        AccessToken accToken = (AccessToken) System.JSON.deserialize(res, AccessToken.class); 
        System.debug('Object Token -->' + accToken.access_token);
        return accToken.access_token;
    }

    /**
    * @description 
    * @author nicolas.contreras@consorcio.cl | 04/02/2021 
    * @param String rutFuncionario 
    * @param String perfil 
    * @return AlertasController.ProposalClass 
    **/
    public AlertasController.CantidadAlerta obtenerCntPropuestasPnd(String rutFuncionario, String perfil){
        String res;
        String url='';
        if(perfil.equalsIgnoreCase('Ejecutivo')){
           url = sc.Callback_url__c +'/v1/integracion-crm-ventas/ejecutivo/'+ rutFuncionario + '/propuestas-pendientes/cantidad';
        }
        else{
           url = sc.Callback_url__c +'/v1/integracion-crm-ventas/jefe-ventas/'+ rutFuncionario + '/propuestas-pendientes/cantidad';
        }  
        
        System.debug('URL: '+ url);

        try{
            
            Http http =new Http();
            HttpRequest request = new HttpRequest();
            request = requestAlerta(url, '', Constants.REQUEST_METHOD_GET);          
            HttpResponse response = http.send(request);
            System.debug('Response Status ' +response.getStatus());
            System.debug('Response  StatusCode' +response.getStatuscode());

            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){
                   
                   res=response.getbody();
                   
            }else{
                res='{"codigo": 1,"mensaje": "error servicio"}';
            }
        }catch(Exception e){
            if(e.getMessage().equalsIgnoreCase('ERROR_401')){
                res='{"codigo": 0,"mensaje": "Favor iniciar sesión SSO"}';
            }else{
                res='{"codigo": 0,"mensaje": "Error en Servicio "}';
            }
        } 
        
        AlertasController.CantidadAlerta salida = (AlertasController.CantidadAlerta) System.JSON.deserialize(res, AlertasController.CantidadAlerta.class);
        salida.perfil=perfil;
        System.debug('Salida Cantidad Propuestas Pendientes ' + salida);
        return salida;
    }


    /**
    * @description 
    * @author nicolas.contreras@consorcio.cl | 04/02/2021 
    * @param String rutFuncionario 
    * @param String perfil 
    * @return AlertasController.DetPropuestasPendientes 
    **/
    public AlertasController.DetPropuestasPendientes obtenerDetallePropuestasPnd(String rutFuncionario, String perfil){
        String res;
        String url='';
        if(perfil.equalsIgnoreCase('Ejecutivo')){
           url = sc.Callback_url__c +'/v1/integracion-crm-ventas/ejecutivo/'+ rutFuncionario + '/propuestas-pendientes/detalle';
        }
        else{
           url = sc.Callback_url__c +'/v1/integracion-crm-ventas/jefe-ventas/'+ rutFuncionario + '/propuestas-pendientes/detalle';
        }  
        
        System.debug('URL: '+ url);
        try{
            Http http =new Http();
            HttpRequest request = new HttpRequest();
            request = requestAlerta(url, '', Constants.REQUEST_METHOD_GET);          
            HttpResponse response = http.send(request);
            System.debug('Response Status ' +response.getStatus());
            System.debug('Response  StatusCode' +response.getStatuscode());

            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){
                   
                   res=response.getbody();
                   
            }else{
                res='{"codigo": 1,"mensaje": "error servicio"}';
            }
        }catch(Exception e){
            if(e.getMessage().equalsIgnoreCase('ERROR_401')){
                res='{"codigo": 0,"mensaje": "Favor iniciar sesión SSO"}';
            }else{
                res='{"codigo": 0,"mensaje": "Error en Servicio "}';
            }
        } 
        AlertasController.DetPropuestasPendientes salida = (AlertasController.DetPropuestasPendientes) System.JSON.deserialize(res, AlertasController.DetPropuestasPendientes.class);
        System.debug('Salida Propuestas Pendientes ' + salida);
        return salida;
    }

     /**
    * @description 
    * @author nicolas.contreras@consorcio.cl | 04/02/2021 
    * @param String rutFuncionario 
    * @param String perfil 
    * @return AlertasController.CantidadAlerta 
    **/
    public AlertasController.CantidadAlerta obtenerCntMandatosPnd(String rutFuncionario, String perfil){
        String res;
        String url='';
        if(perfil.equalsIgnoreCase('Ejecutivo')){
           url = sc.Callback_url__c +'/v1/integracion-crm-ventas/ejecutivo/'+ rutFuncionario + '/mandato-pendiente/cantidad';
        }
        else{
           url = sc.Callback_url__c +'/v1/integracion-crm-ventas/jefe-ventas/'+ rutFuncionario + '/mandato-pendiente/cantidad';
        }  
        
        System.debug('URL: '+ url);

        try{
            
            Http http =new Http();
            HttpRequest request = new HttpRequest();
            request = requestAlerta(url, '', Constants.REQUEST_METHOD_GET);          
            HttpResponse response = http.send(request);
            System.debug('Response Status ' +response.getStatus());
            System.debug('Response  StatusCode' +response.getStatuscode());

            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){
                   
                   res=response.getbody();
                   
            }else{
                res='{"codigo": 1,"mensaje": "error servicio"}';
            }
        }catch(Exception e){
            if(e.getMessage().equalsIgnoreCase('ERROR_401')){
                res='{"codigo": 0,"mensaje": "Favor iniciar sesión SSO"}';
            }else{
                res='{"codigo": 0,"mensaje": "Error en Servicio "}';
            }
        } 
        
        AlertasController.CantidadAlerta salida = (AlertasController.CantidadAlerta) System.JSON.deserialize(res, AlertasController.CantidadAlerta.class);
        salida.perfil=perfil;
        System.debug('Salida Cantidad Mandatos Pendientes ' + salida);
        return salida;
    }

     /**
    * @description 
    * @author nicolas.contreras@consorcio.cl | 04/02/2021 
    * @param String rutFuncionario 
    * @param String perfil 
    * @return AlertasController.DetMandatosPendientes 
    **/
    public AlertasController.DetMandatosPendientes obtenerDetalleMandatosPnd(String rutFuncionario, String perfil){
        String res;
        String url='';
        if(perfil.equalsIgnoreCase('Ejecutivo')){
           url = sc.Callback_url__c +'/v1/integracion-crm-ventas/ejecutivo/'+ rutFuncionario + '/mandato-pendiente/detalle';
        }
        else{
           url = sc.Callback_url__c +'/v1/integracion-crm-ventas/jefe-ventas/'+ rutFuncionario + '/mandato-pendiente/detalle';
        }  
        
        System.debug('URL: '+ url);

        try{
            
            Http http =new Http();
            HttpRequest request = new HttpRequest();
            request = requestAlerta(url, '', Constants.REQUEST_METHOD_GET);          
            HttpResponse response = http.send(request);
            System.debug('Response Status ' +response.getStatus());
            System.debug('Response  StatusCode' +response.getStatuscode());

            if(response.getStatus()== Constants.RESPONSE_200 
               || response.getStatus()== Constants.RESPONSE_201
               ||response.getStatus()== Constants.RESPONSE_OK ){
                   
                   res=response.getbody();
                   
            }else{
                res='{"codigo": 1,"mensaje": "error servicio"}';
            }
        }catch(Exception e){
            if(e.getMessage().equalsIgnoreCase('ERROR_401')){
                res='{"codigo": 0,"mensaje": "Favor iniciar sesión SSO"}';
            }else{
                res='{"codigo": 0,"mensaje": "Error en Servicio "}';
            }
        } 
        
        AlertasController.DetMandatosPendientes salida = (AlertasController.DetMandatosPendientes) System.JSON.deserialize(res, AlertasController.DetMandatosPendientes.class);
        System.debug('Salida Mandatos Pendientes ' + salida);
        return salida;
    }


    

    /**
========================================================================================================================
----------------------------------------------------WRAPPERS----------------------------------------------------------
========================================================================================================================
*/
    
public class AccessToken{
    public String access_token;
    public String token_type;
}

public class TokenResponse{
    public String AccessToken;
    public Integer ExpiresIn;
    public String TokenType;
    public String RefreshToken;
    public String IdToken;
}

    
    

}