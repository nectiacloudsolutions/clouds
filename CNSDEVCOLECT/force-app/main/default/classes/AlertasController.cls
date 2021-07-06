/**
 * @File Name          : AlertasController.cls
 * @Description        : 
 * @Author             : nicolas.contreras@consorcio.cl
 * @Group              : 
 * @Last Modified By   : nicolas.contreras@consorcio.cl
 * @Last Modified On   : 04/02/2021, 03:06:00 PM
 * @Modification Log   : 
 * Ver       Date            Author      		          Modification
 * 1.0    04-02-2019   nicolas.contreras@consorcio.cl     Initial Version
**/

public class AlertasController {


 /**
========================================================================================================================
----------------------------------------------------Mandatos Pendientes-------------------------------------------------
========================================================================================================================
*/   
    
    @AuraEnabled
    public static CantidadAlerta getCantidadMandatosPendientes(String idUsuario){
        CantidadAlerta resp =new CantidadAlerta();
        String rutUsuarioFormateado='';
        try {
            
            System.debug('IdUsuario: ' + idUsuario );
             //Verificar en CustomSettings si es Jefe o si es Ejecutivo
            CalloutsAlertas ca=new CalloutsAlertas(Constants.ALERTAS); 
            resp.codigo = Constants.OK;
            resp.mensaje='OK';

            List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE Id =: idUsuario AND isActive = true LIMIT 1];

            rutUsuarioFormateado=lstUsr[0].Rut__c;
            rutUsuarioFormateado = rutUsuarioFormateado.Substring(0,lstUsr[0].Rut__c.length()-1);
            
            if(Consorcio_Org__c.getInstance(lstUsr[0].profileId).perfiles_ejecutivo_ventas__c){
                System.debug(lstUsr[0].id + 'es ejecutivo de Ventas');
                resp.perfil='Ejecutivo';
                resp  = ca.obtenerCntMandatosPnd(rutUsuarioFormateado,resp.perfil);
            }else if (Consorcio_Org__c.getInstance(lstUsr[0].profileId).perfiles_jefe_ventas__c){
                System.debug(lstUsr[0].id + 'es jefe de Ventas');
                resp.perfil='Jefe';
                resp  = ca.obtenerCntMandatosPnd(rutUsuarioFormateado,resp.perfil);
                
            }else{
                resp.codigo = Constants.NOK;
                resp.mensaje='Perfil funcionario no corresponde a jefe ni ejecutivo';
            }
        }
         catch (Exception e) {
            resp.cantidad=0;
            resp.codigo = Constants.NOK;
            resp.mensaje='Error, Consulte al Administrador'+e.getMessage();
        }
        System.debug('Respuesta Final ' + resp);
        return resp;   

    }

    @AuraEnabled
    public static DetMandatosPendientes getDetalleMandatosPendientes(String idUsuario){
        DetMandatosPendientes resp =new DetMandatosPendientes();
        String rutUsuarioFormateado='';
        try {
              
            
            //Verificar en CustomSettings si es Jefe o si es Ejecutivo
            CalloutsAlertas ca=new CalloutsAlertas(Constants.ALERTAS); 
            resp.codigo = Constants.OK;
            resp.mensaje='OK';
            List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE Id =: idUsuario AND isActive = true LIMIT 1];

            rutUsuarioFormateado=lstUsr[0].Rut__c;
            rutUsuarioFormateado = rutUsuarioFormateado.Substring(0,lstUsr[0].Rut__c.length()-1);

            if(Consorcio_Org__c.getInstance(lstUsr[0].profileId).perfiles_ejecutivo_ventas__c){
                System.debug(lstUsr[0].profileId + 'es ejecutivo de Ventas');
                resp  = ca.obtenerDetalleMandatosPnd(rutUsuarioFormateado,'Ejecutivo');
            }else if (Consorcio_Org__c.getInstance(lstUsr[0].profileId).perfiles_jefe_ventas__c){
                System.debug(lstUsr[0].profileId + 'es jefe de Ventas');
                resp  = ca.obtenerDetalleMandatosPnd(rutUsuarioFormateado,'Jefe');
            }else{
                resp.codigo = Constants.NOK;
                resp.mensaje='Perfil funcionario no corresponde a jefe ni ejecutivo';
                return resp;
            }
        }
         catch (Exception e) {
                resp.codigo = Constants.NOK;
                resp.mensaje='Error, Consulte al Administrador'+e.getMessage();    
                return resp;
        }
        System.debug('Respuesta Final ' + resp);
        return resp;  
    }

/**
========================================================================================================================
----------------------------------------------------Propuestas Pendientes-----------------------------------------------
========================================================================================================================
*/
    @AuraEnabled
    public static CantidadAlerta getCantidadPropuestasPendientes(String idUsuario){
        CantidadAlerta resp =new CantidadAlerta();
        String rutUsuarioFormateado='';
        try {
             //Verificar en CustomSettings si es Jefe o si es Ejecutivo
            CalloutsAlertas ca=new CalloutsAlertas(Constants.ALERTAS); 
            resp.codigo = Constants.OK;
            resp.mensaje='OK';
            
            List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE Id =: idUsuario AND isActive = true LIMIT 1];

            rutUsuarioFormateado=lstUsr[0].Rut__c;
            rutUsuarioFormateado = rutUsuarioFormateado.Substring(0,lstUsr[0].Rut__c.length()-1);

            if(Consorcio_Org__c.getInstance(lstUsr[0].profileId).perfiles_ejecutivo_ventas__c){
                System.debug(lstUsr[0].id + 'es ejecutivo de Ventas');
                resp.perfil='Ejecutivo';
                resp  = ca.obtenerCntPropuestasPnd(rutUsuarioFormateado,resp.perfil);
            }else if (Consorcio_Org__c.getInstance(lstUsr[0].profileId).perfiles_jefe_ventas__c){
                resp.perfil='Jefe';
                System.debug(lstUsr[0].id + 'es jefe de Ventas');
                resp  = ca.obtenerCntPropuestasPnd(rutUsuarioFormateado,resp.perfil);
            }else{
                resp.codigo = Constants.NOK;
                resp.mensaje='Perfil funcionario no corresponde a jefe ni ejecutivo';
            }
        }
         catch (Exception e) {
            resp.cantidad=0;
            resp.codigo = Constants.NOK;
            resp.mensaje='Error, Consulte al Administrador'+e.getMessage();
        }
        System.debug('Respuesta Final ' + resp);
        return resp;  

    }

    @AuraEnabled
    public static DetPropuestasPendientes getDetallePropuestasPendientes(String idUsuario){
        DetPropuestasPendientes resp =new DetPropuestasPendientes();
        String rutUsuarioFormateado='';
        try {
             //Verificar en CustomSettings si es Jefe o si es Ejecutivo
            CalloutsAlertas ca=new CalloutsAlertas(Constants.ALERTAS); 
            resp.codigo = Constants.OK;
            resp.mensaje='OK';
            List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE Id =: idUsuario AND isActive = true LIMIT 1];

            rutUsuarioFormateado=lstUsr[0].Rut__c;
            rutUsuarioFormateado = rutUsuarioFormateado.Substring(0,lstUsr[0].Rut__c.length()-1);

            if(Consorcio_Org__c.getInstance(lstUsr[0].profileId).perfiles_ejecutivo_ventas__c){
                System.debug(lstUsr[0].Id + 'es ejecutivo de Ventas');
                resp  = ca.obtenerDetallePropuestasPnd(rutUsuarioFormateado,'Ejecutivo');
            }else if (Consorcio_Org__c.getInstance(lstUsr[0].profileId).perfiles_jefe_ventas__c){
                System.debug(lstUsr[0].Id + 'es jefe de Ventas');
                resp  = ca.obtenerDetallePropuestasPnd(rutUsuarioFormateado,'Jefe');
            }else{
                resp.codigo = Constants.NOK;
                resp.mensaje='Perfil funcionario no corresponde a jefe ni ejecutivo';
                return resp;
            }
        }
         catch (Exception e) {
                resp.codigo = Constants.NOK;
                resp.mensaje='Error, Consulte al Administrador'+e.getMessage();     
                return resp;
        }
        System.debug('Respuesta Final ' + resp);
        return resp;  

    }

/**
========================================================================================================================
----------------------------------------------------WRAPPERS----------------------------------------------------------
========================================================================================================================
*/

    public class CantidadAlerta{
        @AuraEnabled public String codigo{get;set;}
        @AuraEnabled public String mensaje{get;set;}
        @AuraEnabled public String perfil{get;set;}
        @AuraEnabled public Integer cantidad{get;set;}
    }
    
    public class DetPropuestasPendientes{
        @AuraEnabled public String codigo{get;set;}
        @AuraEnabled public String mensaje{get;set;}
        @AuraEnabled public List<DetallePropuestasPendiente> detallePropuestasPendiente{get;set;}
    }

    public class DetallePropuestasPendiente{
        @AuraEnabled public Integer propuesta{get;set;}
        @AuraEnabled public String  estado {get;set;}
        @AuraEnabled public String  causal {get;set;}
        @AuraEnabled public String  fechaEstado {get;set;}
        @AuraEnabled public String nombreProducto {get;set;}
    }

    public class DetMandatosPendientes{
        @AuraEnabled public String codigo{get;set;}
        @AuraEnabled public String mensaje{get;set;}
        @AuraEnabled public List<DetalleMandatosPendientes> detalleMandatos{get;set;}
    }

    public class DetalleMandatosPendientes{
        @AuraEnabled public String SNombreCliente{get;set;}
        @AuraEnabled public String SRutCliente{get;set;}
        @AuraEnabled public String SProducto{get;set;}
        @AuraEnabled public String SPolprop{get;set;}
        @AuraEnabled public Integer NPolicy{get;set;}
        @AuraEnabled public String SViaPago{get;set;}
        @AuraEnabled public String SestadoReal{get;set;}
        @AuraEnabled public String SnombreEjecutivo{get;set;}
    }

}