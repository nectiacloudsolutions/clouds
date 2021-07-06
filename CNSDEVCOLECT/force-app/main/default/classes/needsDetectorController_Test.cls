/*********************************************************************************************************
@Author       eayalcor@everis.com
@name         needsDetectorController_Test
@CreateDate   25/11/2019
@Description  Test Class for needsDetectorController
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
25/11/2019                    eayalcor@everis.com                Initial Version
27/11/2019                    fbizamam@everis.com                Added createOpTest test Method
**********************************************************************************************************/
@isTest
public class needsDetectorController_Test {
      /**
      * @description       This method tests getProducts method in the needsDetectorController Class
      * @param1            
      * @return            void
      * @throws            NA
    */
    
    @isTest
    static void getProducts(){

        Test.startTest();
        String rut='1234567';
        String rutEjecutivo='1234567'; 
        String jsonRequest = '{"formulario": {"code": "1", "message": "exitoso", "nombreFormulario": "FORMULARIO-VIDA", "preguntas": [{"idPregunta": "1", "tipoSeleccionRespuesta": "EXCLUYENTE", "descripcionPregunta": "PROYECCION DE AHORRO", "visible": true, "respuestas": [{"idRespuesta": "1", "descripcionRespuesta": "PREVISIONAL", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "2", "descripcionRespuesta": "AHORRO", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "3", "descripcionRespuesta": "NINGUNO", "respuesta": "0", "idPreguntaHija": "None"}]}, {"idPregunta": "2", "tipoSeleccionRespuesta": "EXCLUYENTE", "descripcionPregunta": "FUMA", "visible": true, "respuestas": [{"idRespuesta": "1", "descripcionRespuesta": "SI", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "2", "descripcionRespuesta": "NO", "respuesta": "0", "idPreguntaHija": "None"}]}, {"idPregunta": "3", "tipoSeleccionRespuesta": "EXCLUYENTE", "descripcionPregunta": "RIESGO DE ACTIVIDAD LABORAL", "visible": true, "respuestas": [{"idRespuesta": "1", "descripcionRespuesta": "ALTO", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "2", "descripcionRespuesta": "BAJO", "respuesta": "0", "idPreguntaHija": "None"}]}, {"idPregunta": "4", "tipoSeleccionRespuesta": "EXCLUYENTE", "descripcionPregunta": "NIVEL DE INGRESO", "visible": true, "respuestas": [{"idRespuesta": "1", "descripcionRespuesta": "<550.000", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "2", "descripcionRespuesta": "ENTRE 550.000 Y 900.000", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "3", "descripcionRespuesta": "ENTRE 900.000 Y 1.200.000", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "4", "descripcionRespuesta": "ENTRE 1.200.000 Y 2.000.000", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "5", "descripcionRespuesta": "> 2.000.000", "respuesta": "0", "idPreguntaHija": "None"}]}]}}';
        String jsonResponse = '{"code": "1","message": "exitoso","productos": [{"idProducto": 2,"nombreProducto": "Auto por Km","coberturas": [{"nombreCobertura": "fallecimiento","montoUF": "500"}]}]}';
        String code='1';
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                     'ok',
                                                     jsonResponse,
                                                     null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout('ANALYTICS');
        DetectorClassProduct dtProduct =  needsDetectorController.getProducts(rut, rutEjecutivo, jsonRequest, code);
        Test.stopTest();    

        System.assertEquals('1', dtProduct.code);
    }
    
    /**
      * @description       This method tests createOpp method in the needsDetectorController Class
      * @param1            
      * @return            void
      * @throws            NA
    */
    @isTest
    static void createOpTest(){
        Test.startTest();
        
        Map<String, SObject> mapsObjects = TestFactorySales.populateOrg();
        User use = (User)mapsObjects.get('User2');  
        System.runAs(use){
            Account acc = (Account)mapsObjects.get('Account');
            Id Idpro = Test.getStandardPricebookId();
            Map<String, SObject> mapsOppObject = TestFactorySales.createOpportunityWithProduct(Idpro, acc.Id, use.Id);
            Product2 poga = (Product2)  mapsOppObject.get('Product2');
          
            Id ide = needsDetectorController.createOpp(acc.Id, poga.ProductCode);
            List<Opportunity> listop = [SELECT Id from Opportunity where ID =: ide LIMIT 1];
            
            system.assertEquals(listop[0].Id, ide);
            System.assert(ide != null);
        }
         
        Test.stopTest();
    }
    
}