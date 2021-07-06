/*********************************************************************************************************
@Author       eayalcor@everis.com   
@name         PropensityController_Test
@CreateDate   21/10/2019
@Description  Test class for PropensityController
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
21/10/2019                         eayalcor@everis.com               Initial Version 
**********************************************************************************************************/
@isTest
private with sharing class PropensityController_Test {
    /**
      * @description       This method test consult next propensity Offer by record page Lead
      * @throws            NA
    */
    @isTest
    static void propensityControllerLeadTest(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();
        User user = (User)mpsObjects.get('User2');
        Lead nwLead = TestFactorySales.createNewLead('20780910-1', '8813645-4', 'Propensity Test');
        nwLead.OwnerId = user.Id;
        upsert nwLead;
        
        System.runAs(user){
            Test.startTest();
            
            List<PropensityController.ProductPropensity> lstProducts = new List<PropensityController.ProductPropensity>();
            PropensityController.Propensity nbo = new PropensityController.Propensity();
            PropensityController.ProductPropensity products = new PropensityController.ProductPropensity();
            nbo.code = '1';
            nbo.message = 'OK';
            products.icon = 'test.jpg';
            products.order = '1';
            products.prodCod = '100'; 
            products.prodFamDesc = 'Vida';
            products.propension = 'Alta';
            products.descripcion = 'test';
            lstProducts.add(products);
            nbo.products = lstProducts;
            String json = JSON.serialize(nbo);
            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'ok',
                                                     json,
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            SalesCallout sc = new SalesCallout('ANALYTICS');
            PropensityController.Propensity resultNbo = PropensityController.getPropensityAnalytics(nwLead.Id, Constants.LEAD);
            Test.stopTest();
            System.assertEquals('1', resultNbo.code);
        }
    }
    /**
      * @description       This method test consult next propensity Offer by record page Account
      * @throws            NA
    */   
    @isTest
    static void propensityControllerAccountTest(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();
        Account acc = (Account)mpsObjects.get('Account');
        User user = (User)mpsObjects.get('User2');
        
        System.runAs(user){
            Test.startTest();
            List<PropensityController.ProductPropensity> lstProducts = new List<PropensityController.ProductPropensity>();
            PropensityController.Propensity nbo = new PropensityController.Propensity();
            PropensityController.ProductPropensity products = new PropensityController.ProductPropensity();
            nbo.code = '1';
            nbo.message = 'OK';
            products.icon = 'test.jpg';
            products.order = '1';
            products.prodCod = '100';
            products.prodFamDesc = 'Vida';
            products.propension = 'Alta';
            products.descripcion = 'test';
            lstProducts.add(products);
            nbo.products = lstProducts;
            String json = JSON.serialize(nbo);
            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'ok',
                                                     json,
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            SalesCallout sc = new SalesCallout('ANALYTICS');
            PropensityController.Propensity resultNbo = PropensityController.getPropensityAnalytics(acc.Id, Constants.ACCOUNT);
            Test.stopTest();
            System.assertEquals('1', resultNbo.code);
        }
    }

    @isTest
    static void propensityControllerInvokeDetector(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();
        Account acc = (Account)mpsObjects.get('Account');
        User user = (User)mpsObjects.get('User2');
        
        System.runAs(user){
            Test.startTest();
            DetectorClass dt = new DetectorClass();
            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'ok',
                                                     '{"formulario": {"code": "1", "message": "exitoso", "nombreFormulario": "FORMULARIO-VIDA", "preguntas": [{"idPregunta": "1", "tipoSeleccionRespuesta": "EXCLUYENTE", "descripcionPregunta": "PROYECCION DE AHORRO", "visible": true, "respuestas": [{"idRespuesta": "1", "descripcionRespuesta": "PREVISIONAL", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "2", "descripcionRespuesta": "AHORRO", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "3", "descripcionRespuesta": "NINGUNO", "respuesta": "0", "idPreguntaHija": "None"}]}, {"idPregunta": "2", "tipoSeleccionRespuesta": "EXCLUYENTE", "descripcionPregunta": "FUMA", "visible": true, "respuestas": [{"idRespuesta": "1", "descripcionRespuesta": "SI", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "2", "descripcionRespuesta": "NO", "respuesta": "0", "idPreguntaHija": "None"}]}, {"idPregunta": "3", "tipoSeleccionRespuesta": "EXCLUYENTE", "descripcionPregunta": "RIESGO DE ACTIVIDAD LABORAL", "visible": true, "respuestas": [{"idRespuesta": "1", "descripcionRespuesta": "ALTO", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "2", "descripcionRespuesta": "BAJO", "respuesta": "0", "idPreguntaHija": "None"}]}, {"idPregunta": "4", "tipoSeleccionRespuesta": "EXCLUYENTE", "descripcionPregunta": "NIVEL DE INGRESO", "visible": true, "respuestas": [{"idRespuesta": "1", "descripcionRespuesta": "<550.000", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "2", "descripcionRespuesta": "ENTRE 550.000 Y 900.000", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "3", "descripcionRespuesta": "ENTRE 900.000 Y 1.200.000", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "4", "descripcionRespuesta": "ENTRE 1.200.000 Y 2.000.000", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "5", "descripcionRespuesta": "> 2.000.000", "respuesta": "0", "idPreguntaHija": "None"}]}]}}',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            String response =  PropensityController.getQuestionsDetector('1', '176782412', '61916334');
            dt = (DetectorClass) System.json.deserialize(response, DetectorClass.class); 
            Test.stopTest();
            System.assertEquals('1', dt.formulario.code);
        }
    }

    @isTest
    static void propensityCheckBrandTest(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();
        Account acc = (Account)mpsObjects.get('Account');
        Id profileId = [SELECT Id FROM Profile WHERE (Name = 'System Administrator') OR (Name = 'Administrador del Sistema') LIMIT 1].Id;
        List<User> lstUser = [SELECT Id FROM User WHERE isActive = TRUE AND ProfileId =:profileId];
        
        System.runAs(lstUser[0]){
            Test.startTest();
            DetectorClass dt = new DetectorClass();
            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'ok',
                                                     '{"codigo":"1","mensaje":"OK","detalleMarcas":[{"idTipoMarca":1,"obtenerAutorizacion": "actualizar","nombreTipoMarca":"compartir datos","idMedioDesuscripcion":null,"nombreMedioDesuscripcion":null,"vigente":false,"fechaInicioVigencia":null,"fechaActualizacion":null},{"idTipoMarca":2,"nombreTipoMarca":"almacenamiento nube","idMedioDesuscripcion":null,"nombreMedioDesuscripcion":null,"vigente":false,"fechaInicioVigencia":null,"fechaActualizacion":null},{"idTipoMarca":3,"nombreTipoMarca":"uso canales remotos","idMedioDesuscripcion":null,"nombreMedioDesuscripcion":null,"vigente":false,"fechaInicioVigencia":null,"fechaActualizacion":null},{"idTipoMarca":4,"nombreTipoMarca":"uso canales remotos","idMedioDesuscripcion":null,"nombreMedioDesuscripcion":null,"vigente":false,"fechaInicioVigencia":null,"fechaActualizacion":null},{"idTipoMarca":12,"nombreTipoMarca":"uso canales remotos","idMedioDesuscripcion":null,"nombreMedioDesuscripcion":null,"vigente":false,"fechaInicioVigencia":null,"fechaActualizacion":null}]}',
                                                     null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            PropensityController.checkBrandStatusAnalytics(acc.Id,'19');
            Test.stopTest();
            System.assertEquals(acc.Autoriza_uso_de_datos__c, false);
        } 
    }
}