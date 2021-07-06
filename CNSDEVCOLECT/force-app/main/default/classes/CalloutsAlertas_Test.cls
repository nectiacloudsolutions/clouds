/**
 * @File Name          : CallOutsAlerta_Test.cls
 * @Description        : 
 * @Author             : nicolas.contreras@consorcio.cl
 * @Group              : 
 * @Last Modified By   : nicolas.contreras@consorcio.cl
 * @Last Modified On   : 08-02-2021
 * @Modification Log   : 
 * Ver       Date            Author                       Modification
 * 1.0    08-02-2021   nicolas.contreras@consorcio.cl     Initial Version
**/

@isTest
private with sharing class CalloutsAlertas_Test {
     /**
      * @description       This method test the get Token from Analytics.
      * @throws            NA
    */
    @isTest
    static void testGetTokenByClientCredencial(){ 
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"access_token": "eyJra","expires_in": 3600,"token_type": "Bearer"}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        CallOutsAlertas sc = new CallOutsAlertas(Constants.ALERTAS);
        String token = sc.getTokenByClientCredencial();
        system.debug(token);
        System.assertEquals(token,'eyJra');       
    }
    
    @isTest
    static void testobtenerCntPropuestasPndEjecutivo(){ 
        AlertasController.CantidadAlerta resp =new AlertasController.CantidadAlerta();
        resp.codigo = Constants.OK;
        resp.mensaje='OK'; 
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"codigo":"OK","cantidad": 0}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        CallOutsAlertas ca=new CallOutsAlertas(Constants.ALERTAS); 
        resp  = ca.obtenerCntPropuestasPnd('6051014','Ejecutivo');
        System.debug('resp' + resp);
        Test.stopTest();
        System.assertEquals(resp.codigo,Constants.OK);
        

    }
    @isTest
    static void testobtenerCntPropuestasPndEjecutivoError401(){ 
        AlertasController.CantidadAlerta resp =new AlertasController.CantidadAlerta();
        resp.codigo = Constants.OK;
        resp.mensaje='OK'; 
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(401,
                                                 'NOK',
                                                 '{"codigo":"OK","cantidad": 0}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        CallOutsAlertas ca=new CallOutsAlertas(Constants.ALERTAS); 
        resp  = ca.obtenerCntPropuestasPnd('6051014','Ejecutivo');
        System.debug('resp' + resp);
        Test.stopTest();
        System.assertEquals(resp.codigo,'1');
        

    }




    @isTest
    static void testobtenerCntPropuestasPndJefe(){ 
        AlertasController.CantidadAlerta resp =new AlertasController.CantidadAlerta();
        resp.codigo = Constants.OK;
        resp.mensaje='OK'; 
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"codigo":"OK","cantidad": 0}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        CallOutsAlertas ca=new CallOutsAlertas(Constants.ALERTAS); 
        resp  = ca.obtenerCntPropuestasPnd('6051014','Jefe');
        System.debug('resp' + resp);
        Test.stopTest();
        System.assertEquals(resp.codigo,Constants.OK);

    }
    @isTest
    static void testobtenerDetallePropuestasPndEjectuvo(){ 
        AlertasController.DetPropuestasPendientes resp =new AlertasController.DetPropuestasPendientes();
        resp.codigo = Constants.OK;
        resp.mensaje='OK'; 
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"codigo":"OK","cantidad": 0}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        CallOutsAlertas ca=new CallOutsAlertas(Constants.ALERTAS); 
        resp  = ca.obtenerDetallePropuestasPnd('6051014','Ejecutivo');
        System.debug('resp' + resp);
        Test.stopTest();
        System.assertEquals(resp.codigo,Constants.OK);

    }

    @isTest
    static void testobtenerDetallePropuestasPndEjectuvoError401(){ 
        AlertasController.DetPropuestasPendientes resp =new AlertasController.DetPropuestasPendientes();
        resp.codigo = Constants.OK;
        resp.mensaje='OK'; 
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(401,
                                                 'NOK',
                                                 '{"codigo":"OK","cantidad": 0}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        CallOutsAlertas ca=new CallOutsAlertas(Constants.ALERTAS); 
        resp  = ca.obtenerDetallePropuestasPnd('6051014','Ejecutivo');
        System.debug('resp' + resp);
        Test.stopTest();
        System.assertEquals(resp.codigo,'1');

    }


    @isTest
    static void testobtenerDetallePropuestasPndJefe(){ 
        AlertasController.DetPropuestasPendientes resp =new AlertasController.DetPropuestasPendientes();
        resp.codigo = Constants.OK;
        resp.mensaje='OK'; 
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"codigo":"OK","cantidad": 0}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        CallOutsAlertas ca=new CallOutsAlertas(Constants.ALERTAS); 
        resp  = ca.obtenerDetallePropuestasPnd('6051014','Jefe');
        Test.stopTest();
        System.assertEquals(resp.codigo,Constants.OK);

    }

    @isTest
    static void testobtenerCntMandatosPndEjecutivo(){ 
        AlertasController.CantidadAlerta resp =new AlertasController.CantidadAlerta();
        resp.codigo = Constants.OK;
        resp.mensaje='OK'; 
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"codigo":"OK","cantidad": 0}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        CallOutsAlertas ca=new CallOutsAlertas(Constants.ALERTAS); 
        resp  = ca.obtenerCntMandatosPnd('6051014','Ejecutivo');
        Test.stopTest();
        System.assertEquals(resp.codigo,Constants.OK);
        

    }

    @isTest
    static void testobtenerCntMandatosPndEjecutivoError401(){ 
        AlertasController.CantidadAlerta resp =new AlertasController.CantidadAlerta();
        resp.codigo = Constants.OK;
        resp.mensaje='OK'; 
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(401,
                                                 'NOK',
                                                 '{"codigo":"NOK","cantidad": 0}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        CallOutsAlertas ca=new CallOutsAlertas(Constants.ALERTAS); 
        resp  = ca.obtenerCntMandatosPnd('6051014','Ejecutivo');
        Test.stopTest();
        System.assertEquals(resp.codigo,'1');
        

    }
   
    @isTest
    static void testobtenerCntMandatosPndJefe(){ 
        AlertasController.CantidadAlerta resp =new AlertasController.CantidadAlerta();
        resp.codigo = Constants.OK;
        resp.mensaje='OK'; 
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"codigo":"OK","cantidad": 0}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        CallOutsAlertas ca=new CallOutsAlertas(Constants.ALERTAS); 
        resp  = ca.obtenerCntMandatosPnd('6051014','Jefe');
        Test.stopTest();
        System.assertEquals(resp.codigo,Constants.OK);

    }

    @isTest
    static void testobtenerDetalleMandatosPndEjecutivo(){ 
        AlertasController.DetMandatosPendientes resp =new AlertasController.DetMandatosPendientes();
        resp.codigo = Constants.OK;
        resp.mensaje='OK'; 
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"codigo":"OK","cantidad": 0}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        CallOutsAlertas ca=new CallOutsAlertas(Constants.ALERTAS); 
        resp  = ca.obtenerDetalleMandatosPnd('6051014','Ejecutivo');
        Test.stopTest();
        System.assertEquals(resp.codigo,Constants.OK);

    }

    @isTest
    static void testobtenerDetalleMandatosPndJefe(){ 
        AlertasController.DetMandatosPendientes resp =new AlertasController.DetMandatosPendientes();
        resp.codigo = Constants.OK;
        resp.mensaje='OK'; 
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"codigo":"OK","cantidad": 0}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        CallOutsAlertas ca=new CallOutsAlertas(Constants.ALERTAS); 
        resp  = ca.obtenerDetalleMandatosPnd('6051014','Jefe');
        Test.stopTest();
        System.assertEquals(resp.codigo,Constants.OK);

    }

    
   
    
    



    

    
}