/**
 * @File Name          : AlertasController_Test.cls
 * @Description        : 
 * @Author             : nicolas.contreras@consorcio.cl
 * @Group              : 
 * @Last Modified By   : nicolas.contreras@consorcio.cl
 * @Last Modified On   : 09-02-2021 15:42:00
 * @Modification Log   : 
 * Ver       Date            Author      		          Modification
 * 1.0    09-02-2021   nicolas.contreras@consorcio.cl     Initial Version
**/
@isTest
private class AlertasController_Test {
	
    @isTest
    static void getCantidadMandatosPendientesJefe(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Jefe de Ventas' LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].profileId, perfiles_jefe_ventas__c = TRUE);
        Test.startTest();
            
            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'OK',
                                                     '{"codigo":"OK","cantidad": 0}',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            AlertasController.CantidadAlerta ca = AlertasController.getCantidadMandatosPendientes(lstUsr[0].Id);
            Test.stopTest();
            System.assertEquals(Constants.OK, ca.codigo);
    }

    @isTest
    static void getCantidadMandatosPendientesEjecutivo(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = :Constants.PROFILE_EJECUTIVO_VENTA LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].profileId, perfiles_ejecutivo_ventas__c = TRUE);    
        Test.startTest();
            

            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'OK',
                                                     '{"codigo":"OK","cantidad": 0}',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            AlertasController.CantidadAlerta ca = AlertasController.getCantidadMandatosPendientes(lstUsr[0].Id);
            Test.stopTest();
            System.assertEquals(Constants.OK, ca.codigo);
    }

    @isTest
    static void getCantidadMandatosPendientesSinPerfil(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = :Constants.PROFILE_EJECUTIVO_ESPECIALISTA LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
            Test.startTest();
            
            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'OK',
                                                     '{"codigo":"NOK","cantidad": 0}',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            AlertasController.CantidadAlerta ca = AlertasController.getCantidadMandatosPendientes(lstUsr[0].Id);
            Test.stopTest();
            System.assertEquals(Constants.NOK, ca.codigo);
    }



    @isTest
    static void getDetalleMandatosPendientesJefe(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Jefe de Ventas' LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].profileId, perfiles_jefe_ventas__c = TRUE);    
        Test.startTest();
            

            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'OK',
                                                     '{"codigo":"OK","type": "detalleMandatosResponse","detalleMandatos": [{"DCompDate": "25-11-2020","DEffecDate": "25-11-2020","DExpirDat": "25-11-2021","DFechaEnvioMandatoBanco": "25-11-2020","DFechaInicioVigenciaPoliza": "25-11-2020","DStatDate": "25-11-2020","NAgency": 13435,"NBranch": "9","NCertif": 0,"NDiasEstado": 76,"NDiasEstadoHabiles": 55,"NDiasIngreso": 76,"NDiasIngresoHabiles": 55,"NEstadoMandato": 1,"NId": 8583102,"NInterTyp": 6,"NPolicy": 3293757,"NProduct": 29,"NStatQuota": 0,"SBanco": "Banco de Crédito e Inversiones","SBankAuth": "I3293757","SCertype": "2","SCodigoObservaciones": "","SEstadoReal": "Ingresado                     ","SGlosaObservaciones": "","SJefeVentas": "","SLineaNegocio": "GENERALES","SNombreCliente": "PEbwNHenDX PEbwNHenDX, sYzlMSoXtm                           ","SNombreEjecutivo": "FxTjDDTdyQ FxTjDDTdyQ, QvlZbOoViw                           ","SPolprop": "Poliza","SProducto": "Seguro Auto Consorcio         ","SRutCliente": "9707250-7","SRutEjecutivo": "9684194-9","SStateBankauth": "1","SStatusPol": "5","SViaPago": "Transbank/Diners"}]}',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            AlertasController.DetMandatosPendientes ca = AlertasController.getDetalleMandatosPendientes(lstUsr[0].Id);
            Test.stopTest();
            System.assertEquals(Constants.OK, ca.codigo);
    }

    @isTest
    static void getDetalleMandatosPendientesEjecutivo(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = :Constants.PROFILE_EJECUTIVO_VENTA LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].profileId, perfiles_ejecutivo_ventas__c = TRUE);    
        Test.startTest();
            

            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'OK',
                                                     '{"codigo":"OK","type": "detalleMandatosResponse","detalleMandatos": [{"DCompDate": "25-11-2020","DEffecDate": "25-11-2020","DExpirDat": "25-11-2021","DFechaEnvioMandatoBanco": "25-11-2020","DFechaInicioVigenciaPoliza": "25-11-2020","DStatDate": "25-11-2020","NAgency": 13435,"NBranch": "9","NCertif": 0,"NDiasEstado": 76,"NDiasEstadoHabiles": 55,"NDiasIngreso": 76,"NDiasIngresoHabiles": 55,"NEstadoMandato": 1,"NId": 8583102,"NInterTyp": 6,"NPolicy": 3293757,"NProduct": 29,"NStatQuota": 0,"SBanco": "Banco de Crédito e Inversiones","SBankAuth": "I3293757","SCertype": "2","SCodigoObservaciones": "","SEstadoReal": "Ingresado                     ","SGlosaObservaciones": "","SJefeVentas": "","SLineaNegocio": "GENERALES","SNombreCliente": "PEbwNHenDX PEbwNHenDX, sYzlMSoXtm                           ","SNombreEjecutivo": "FxTjDDTdyQ FxTjDDTdyQ, QvlZbOoViw                           ","SPolprop": "Poliza","SProducto": "Seguro Auto Consorcio         ","SRutCliente": "9707250-7","SRutEjecutivo": "9684194-9","SStateBankauth": "1","SStatusPol": "5","SViaPago": "Transbank/Diners"}]}',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            AlertasController.DetMandatosPendientes ca = AlertasController.getDetalleMandatosPendientes(lstUsr[0].Id);
            Test.stopTest();
            System.assertEquals(Constants.OK, ca.codigo);
    }

    @isTest
    static void getDetalleMandatosPendientesSinPerfil(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = :Constants.PROFILE_EJECUTIVO_ESPECIALISTA LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
            Test.startTest();
            
            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'OK',
                                                     '{"codigo":"NOK","cantidad": 0}',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            AlertasController.DetMandatosPendientes ca = AlertasController.getDetalleMandatosPendientes(lstUsr[0].Id);
            Test.stopTest();
            System.assertEquals(Constants.NOK, ca.codigo);
    }



    @isTest
    static void getCantidadPropuestasPendientesJefe(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Jefe de Ventas' LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].profileId, perfiles_jefe_ventas__c = TRUE);    
        Test.startTest();
            
            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'OK',
                                                     '{"codigo":"OK","cantidad": 0}',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            AlertasController.CantidadAlerta ca = AlertasController.getCantidadPropuestasPendientes(lstUsr[0].Id);
            Test.stopTest();
            System.assertEquals(Constants.OK, ca.codigo);
    }

    @isTest
    static void getCantidadPropuestasPendientesEjecutivo(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = :Constants.PROFILE_EJECUTIVO_VENTA LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].profileId, perfiles_ejecutivo_ventas__c = TRUE);    
        Test.startTest();
            

            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'OK',
                                                     '{"codigo":"OK","cantidad": 0}',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            AlertasController.CantidadAlerta ca = AlertasController.getCantidadPropuestasPendientes(lstUsr[0].Id);
            Test.stopTest();
            System.assertEquals(Constants.OK, ca.codigo);
    }

    @isTest
    static void getCantidadPropuestasPendientesSinPerfil(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = :Constants.PROFILE_EJECUTIVO_ESPECIALISTA LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
            Test.startTest();
            
            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'OK',
                                                     '{"codigo":"NOK","cantidad": 0}',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            AlertasController.CantidadAlerta ca = AlertasController.getCantidadPropuestasPendientes(lstUsr[0].Id);
            Test.stopTest();
            System.assertEquals(Constants.NOK, ca.codigo);
    }



    


    @isTest
    static void getDetallePropuestasPendientesJefe(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Jefe de Ventas' LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].profileId, perfiles_jefe_ventas__c = TRUE);    
        Test.startTest();
            

            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'OK',
                                                     '{"codigo":"OK","type": "detallePropuestasPendienteResponse","detallePropuestasPendiente": [{"agencia": "13844","canal": "Desconocido","causal": "Falta Inform. (Capt. Incomp.)","estado": "Pendiente","fechaEstado": "25/01/2021","nombreAgente": "Fxtjddtdyq Fxtjddtdyq, Qvlzbooviw","nombreProducto": "Seguro Auto Consorcio","producto": 29,"propuesta": 3299209,"ramo": 9,"rutAgente": "9684194"}]}',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            AlertasController.DetPropuestasPendientes ca = AlertasController.getDetallePropuestasPendientes(lstUsr[0].Id);
            Test.stopTest();
            System.assertEquals(Constants.OK, ca.codigo);
    }

    @isTest
    static void getDetallePropuestasPendientesEjecutivo(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = :Constants.PROFILE_EJECUTIVO_VENTA LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
        upsert new Consorcio_Org__c(SetupOwnerId=lstUsr[0].profileId, perfiles_ejecutivo_ventas__c = TRUE);    
        Test.startTest();
            

            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'OK',
                                                     '{"codigo":"OK","type": "detallePropuestasPendienteResponse","detallePropuestasPendiente": [{"agencia": "13844","canal": "Desconocido","causal": "Falta Inform. (Capt. Incomp.)","estado": "Pendiente","fechaEstado": "25/01/2021","nombreAgente": "Fxtjddtdyq Fxtjddtdyq, Qvlzbooviw","nombreProducto": "Seguro Auto Consorcio","producto": 29,"propuesta": 3299209,"ramo": 9,"rutAgente": "9684194"}]}',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            AlertasController.DetPropuestasPendientes ca = AlertasController.getDetallePropuestasPendientes(lstUsr[0].Id);
            Test.stopTest();
            System.assertEquals(Constants.OK, ca.codigo);
    }

    @isTest
    static void getDetallePropuestasPendientesSinPerfil(){
        Id profileId = [SELECT Id FROM Profile WHERE Name = :Constants.PROFILE_EJECUTIVO_ESPECIALISTA LIMIT 1].Id;
        List<User> lstUsr = [SELECT Id, Rut__c,profileId FROM User WHERE profileId =: profileId AND isActive = true LIMIT 1];
            Test.startTest();
            
            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'OK',
                                                     '{"codigo":"NOK","cantidad": 0}',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            AlertasController.DetPropuestasPendientes ca = AlertasController.getDetallePropuestasPendientes(lstUsr[0].Id);
            Test.stopTest();
            System.assertEquals(Constants.NOK, ca.codigo);
    }

    @isTest
    static void testDetalle(){
        String detalleMandatos='{"DCompDate": "29-01-2021",'+
            '"DEffecDate": "03-02-2021",'+
            '"DExpirDat": "27-02-2096",'+
            '"DFechaEnvioMandatoBanco": "28-01-2021",'+
            '"DFechaInicioVigenciaPoliza": "03-02-2021",'+
            '"DStatDate": "28-01-2021",'+
            '"NAgency": 13213,'+
            '"NBranch": "1",'+
            '"NCertif": 0,'+
            '"NDiasEstado": 12,'+
            '"NDiasEstadoHabiles": 9,'+
            '"NDiasIngreso": 6,'+
            '"NDiasIngresoHabiles": 5,'+
            '"NEstadoMandato": 2,'+
            '"NId": 4851506,'+
            '"NInterTyp": 6,'+
            '"NPolicy": 11813426,'+
            '"NProduct": 650,'+
            '"NStatQuota": 0,'+
            '"SBanco": "Banco Falabella",'+
            '"SBankAuth": "2837186",'+
            '"SCertype": "2",'+
            '"SCodigoObservaciones": "",'+
            '"SEstadoReal": "En Validación                 ",'+
            '"SGlosaObservaciones": "",'+
            '"SJefeVentas": "pOYQIsJewP pOYQIsJewP, GzYJaszFAh",'+
            '"SLineaNegocio": "VIDA",'+
            '"SNombreCliente": "AdcHsaIDXV AdcHsaIDXV, qiDYMlJQBP                           ",'+
            '"SNombreEjecutivo": "YfzJqoVCnj YfzJqoVCnj, jYjOxMBMAb                           ",'+
            '"SPolprop": "Poliza",'+
            '"SProducto": "Vidahorro Flex                ",'+
            '"SRutCliente": "19291399-3",'+
            '"SRutEjecutivo": "6828280-2",'+
            '"SStateBankauth": "2",'+
            '"SStatusPol": "5",'+
            '"SViaPago": "Transbank/Diners"'+
        '}';

        AlertasController.DetalleMandatosPendientes salida = (AlertasController.DetalleMandatosPendientes) System.JSON.deserialize(detalleMandatos, AlertasController.DetalleMandatosPendientes.class);
        System.debug(salida);
        salida.SNombreCliente='Cliente';
        System.debug(salida.SNombreCliente);
        salida.SRutCliente='1-9';
        System.debug(salida.SRutCliente);
        salida.SProducto='Producto';
        System.debug(salida.SProducto);
        salida.SPolprop='Producto';
        System.debug(salida.SPolprop);
        salida.SViaPago='Via';
        System.debug(salida.SViaPago);
        salida.SestadoReal='SestadoReal';
        System.debug(salida.SestadoReal);
        salida.SnombreEjecutivo='Ejecutivo';
        System.debug(salida.SnombreEjecutivo);
        
        AlertasController.DetallePropuestasPendiente det=new AlertasController.DetallePropuestasPendiente();
        det.propuesta=1;
        System.debug(det.propuesta);
        det.estado='Estado';
        System.debug(det.estado);
        det.causal='Causal';
        System.debug(det.causal);
        det.fechaEstado='10-01-2020';
        System.debug(det.fechaEstado);
        det.nombreProducto='Producto';
        System.debug(det.nombreProducto);
        
        System.assertEquals(11813426, salida.NPolicy);
        
    }

    
}