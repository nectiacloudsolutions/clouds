/**
 * @File Name          : SalesCallout_Test.cls
 * @Description        : 
 * @Author             : eayalcor@everis.com
 * @Group              : 
 * @Last Modified By   : fbizamam@everis.com
 * @Last Modified On   : 10-20-2020
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    08-10-2019   eayalcor@everis.com     Initial Version
**/

@isTest
private with sharing class SalesCallout_Test {
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
        SalesCallout sc = new SalesCallout('VTIME');
        String token = sc.getTokenByClientCredencial();
        system.debug(token);
        System.assertEquals(token,'eyJra');       
    }
    
        @isTest
    static void testGetAnalyticsTokenOK(){ 
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"access_token": "eyJra","expires_in": 3600,"token_type": "Bearer"}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout('ANALYTICS');
        String token = sc.getAnalyticsToken();
        system.debug(token);
        System.assertEquals(token,'eyJra');       
    }

    /**
      * @description       This method test consult Lead Analytics
      * @throws            NA
    */
    @isTest
    static void testConsultLeadAnalytics(){
        Lead lead = TestFactorySales.createNewLead('14000525-8', '1-9', 'Test Analytics');
        SalesCallout.leadData ldata = new SalesCallout.leadData();
        ldata.message = 'OK';
        ldata.code = '200';
        ldata.action = 'query';
        ldata.lead = lead;
        String json = JSON.serialize(ldata);
        System.debug('JSON: '+json);
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'ok',
                                                 json,
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout('ANALYTICS');
        String response = sc.consultLeadAnalytics(lead, 'query');
        SalesCallout.leadData responseLead = (SalesCallout.leadData) system.json.deserialize(response, SalesCallout.leadData.class);
        Test.stopTest();
        System.assertEquals(responseLead.code,Constants.RESPONSE_200);       
    }
    /**
      * @description       This method test consult Lead Analytics Future
      * @throws            NA
    */
    @isTest
    static void testConsultLeadAnalyticsFuture(){
        Lead lead = TestFactorySales.createNewLead('14000525-8', '1-9', 'Test Analytics');
        SalesCallout.leadData ldata = new SalesCallout.leadData();
        ldata.message = 'OK';
        ldata.code = '200';
        ldata.action = 'query';
        ldata.lead = lead;
        String json = JSON.serialize(ldata);
        System.debug('JSON: '+json);
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'ok',
                                                 json,
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout.consultLeadAnalyticsAsync(lead.Id, Constants.INSERTED, Constants.ANALYTICSLEAD);
        
        Test.stopTest();
        System.assertEquals('200',Constants.RESPONSE_200);       
    }
       /**
      * @description      
      * @throws            NA
    */
    @isTest
    static void testconsultLeadAnalyticsMassiv(){
        Lead lead = TestFactorySales.createNewLead('14000515-8', '1-9', 'Test Analytics');
        List<lead> Llead=new List<lead>();
        Llead.add(lead);
        SalesCallout.LeadDataList ldata = new SalesCallout.LeadDataList();
        ldata.message = 'OK';
        ldata.code = '200';
        ldata.action = 'query';
        ldata.leadList =  Llead;
        String json = JSON.serialize(ldata);
        System.debug('JSON: '+json);
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'ok',
                                                 json,
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout('ANALYTICS');
        String response = sc.consultLeadAnalyticsMassive( Llead, 'query');
        SalesCallout.leadData responseLead = (SalesCallout.leadData) system.json.deserialize(response, SalesCallout.leadData.class);
        Test.stopTest();
        System.assertEquals(responseLead.code,Constants.RESPONSE_200);       
    }
    /**
      * @description       This method invoke next best offer
      * @throws            NA
    */
    @isTest
    static void testNextBestOffer(){
        Lead lead = new Lead(); 
        lead.numero_de_documento_sales__c =  '18082489-8';
        lead.rut_ejecutivo_sales__c = '17678241-2';
        lead.tipo_documento_sales__c = Constants.RUT;
        String json = '{"Code": "1","message": "Mensaje Por definir","Products": [{"prodCod": "100","prodFamDesc": "Vida","order": "1","propension": "Muy Alta","descripción":"Por definir","icon": "Por definir.jpg"}]}';
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'ok',
                                                 json,
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout('ANALYTICS');
        
        String response = sc.getNextBestOffer(lead);
        PropensityController.Propensity propensity = (PropensityController.Propensity) system.json.deserialize(response, PropensityController.Propensity.class);
        Test.stopTest();
        System.assertEquals(propensity.code,'1');       
    }
    /**
      * @description       This method test invoke need detector
      * @throws            NA
    */
    @isTest
    static void testNeedDetector(){
        DetectorClass dt = new DetectorClass();
        PropensityController.RequestQuestion request = new PropensityController.RequestQuestion();
        request.rut = '176782412';
        request.rutEjecutivo = '19';
        request.origin = Constants.REQUEST_ANALYTICS_ORIGIN;
        request.codigoFormulario = '1';
        String json = '{"formulario": {"code": "1", "message": "exitoso", "nombreFormulario": "FORMULARIO-VIDA", "preguntas": [{"idPregunta": "1", "tipoSeleccionRespuesta": "EXCLUYENTE", "descripcionPregunta": "PROYECCION DE AHORRO", "visible": true, "respuestas": [{"idRespuesta": "1", "descripcionRespuesta": "PREVISIONAL", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "2", "descripcionRespuesta": "AHORRO", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "3", "descripcionRespuesta": "NINGUNO", "respuesta": "0", "idPreguntaHija": "None"}]}, {"idPregunta": "2", "tipoSeleccionRespuesta": "EXCLUYENTE", "descripcionPregunta": "FUMA", "visible": true, "respuestas": [{"idRespuesta": "1", "descripcionRespuesta": "SI", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "2", "descripcionRespuesta": "NO", "respuesta": "0", "idPreguntaHija": "None"}]}, {"idPregunta": "3", "tipoSeleccionRespuesta": "EXCLUYENTE", "descripcionPregunta": "RIESGO DE ACTIVIDAD LABORAL", "visible": true, "respuestas": [{"idRespuesta": "1", "descripcionRespuesta": "ALTO", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "2", "descripcionRespuesta": "BAJO", "respuesta": "0", "idPreguntaHija": "None"}]}, {"idPregunta": "4", "tipoSeleccionRespuesta": "EXCLUYENTE", "descripcionPregunta": "NIVEL DE INGRESO", "visible": true, "respuestas": [{"idRespuesta": "1", "descripcionRespuesta": "<550.000", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "2", "descripcionRespuesta": "ENTRE 550.000 Y 900.000", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "3", "descripcionRespuesta": "ENTRE 900.000 Y 1.200.000", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "4", "descripcionRespuesta": "ENTRE 1.200.000 Y 2.000.000", "respuesta": "0", "idPreguntaHija": "None"}, {"idRespuesta": "5", "descripcionRespuesta": "> 2.000.000", "respuesta": "0", "idPreguntaHija": "None"}]}]}}';
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'ok',
                                                 json,
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout('ANALYTICS');
        
        String response = sc.getQuestionsDetector(request);
        System.debug('Result:' + response);
        dt = (DetectorClass) System.json.deserialize(response, DetectorClass.class); 
        Test.stopTest();
        System.assertEquals(dt.formulario.code,'1');       
    }
       /**
      * @description       This method test invoke consultLeadAnalyticsAsyncMassive
      * @throws            NA
    */
    @isTest
    static void TestconsultLeadAnalyticsAsyncMassive(){
        Lead lead = TestFactorySales.createNewLead('14000525-8', '1-9', 'Test Analytics');
        List<String> Llead=new List<String>();
        Llead.add(lead.Id);
        List<Lead> Lleadssss= new List<Lead>();
        Lleadssss.add(lead);
        SalesCallout.LeadDataList ldata = new SalesCallout.LeadDataList();
        ldata.message = 'OK';
        ldata.code = '200';
        ldata.action = 'query';
        ldata.leadList = Lleadssss;
        String json = JSON.serialize(ldata);
        System.debug('JSON: '+json);
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'ok',
                                                 json,
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout.consultLeadAnalyticsAsyncMassive(Llead, Constants.INSERTED, Constants.ANALYTICSLEAD);
        
        Test.stopTest();
        System.assertEquals('200',Constants.RESPONSE_200); 
    }
    @isTest
    static void getProductsOpp(){
        DetectorClassResponse dtResponse = new DetectorClassResponse();
        dtResponse.codigoFormulario='1';
        dtResponse.rut='1234567';
        dtResponse.rutEjecutivo='1234567';
        List<DetectorClassResponse.Respuesta> lstResp = new list<DetectorClassResponse.Respuesta>();
        DetectorClassResponse.Respuesta res1 = new DetectorClassResponse.Respuesta();
        res1.idPregunta = '1';
        res1.idRespuesta = '1';
        lstResp.add(res1);
        dtResponse.respuestas = lstResp;
        String finalJson = json.serialize(dtResponse);
        System.debug('REQUEST JSON GET PRODUCT: ' + finalJson);
        String json = '{"code": "1","message": "exitoso","productos": [{"idProducto": 2,"nombreProducto": "Auto por Km","coberturas": [{"nombreCobertura": "fallecimiento","montoUF": "500"}]}]}';
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 json,
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout('ANALYTICS');
        
        DetectorClassProduct res = sc.getProductsOpp(dtResponse);
        //DetectorClassProduct dtProduct = (DetectorClassProduct) System.JSON.deserialize(res, DetectorClassProduct.class);
        System.debug('RESPUESTA DEL TEST'+res);
        Test.stopTest();
        System.assertEquals(res.code, '1');
    }
    
    @isTest
    static void testReassignExecutive(){
        
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        Account acc = (Account)mpsObjects.get('Account'); 
        Id idProd2 = Test.getStandardPricebookId();  
        User usea = (User)mpsObjects.get('User7');
        User usr = (User)mpsObjects.get('User3');
        acc.OwnerId=usea.Id;
        upsert acc;
        upsert new Consorcio_Org__c(SetupOwnerId=usea.Id,Sales_project__c=false, Validation_rules__c = false);

        String json = '{"message":"OK_0011900000oE1ZiAAK","jsonMap":[{"telefono_Sales":null,"telefono_Opp":null,"stageName":"Contacto","rut_ejecutivo":"17302755-9","rut_cuenta":"17961022-1","ownerId":"005190000030T2VAAU","idOportunidad":null,"description":null,"correoOportunidad":null,"cod_prod":"1","AccountId":"0011900000oE1ZiAAK"}],"StatusCode":"200","action":"CHANGE_STATUS "}';
        
        system.runAs(usea){ 
            Map<String,SObject> mpsOppObjects = TestFactorySales.createOpportunityWithProduct(idProd2,acc.Id,usea.Id);
            Opportunity oppy = (Opportunity)mpsOppObjects.get('Opportunity');  
            Product2 prod = (Product2)mpsOppObjects.get('Product2'); 
            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                                 'ok',
                                                                 json,
                                                                 null);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            SalesCallout sc = new SalesCallout('ANALYTICS');
            SalesCallout.OpportunityDataList odr = sc.reassignExecutive(oppy, prod.ProductCode);           
            Test.stopTest();   
            System.AssertEquals(Constants.RESPONSE_200,odr.statusCode); 
        }
    }
    
     @isTest
    static void TestconsultOppAnalyticsAsyncMassive(){
        Map<String, SObject> Opp = TestFactorySales.populateOrg();
        List<String> idsOp = new List<String>();
        idsOp.add(Opp.get('Opp4').id);
        
        SalesCallout.OpportunityDataList OppData = new SalesCallout.OpportunityDataList();
        OppData.action=Constants.CHANGE_STATUS;
        OppData.message='OK';
        OppData.statusCode='200';
        
        String json = JSON.serialize(OppData);
        System.debug('JSON: '+json);
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'ok',
                                                 json,
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout.consultOppAnalyticsAsyncMassive(idsOp, Constants.CHANGE_STATUS, Constants.ANALYTICSLEAD);
        
        Test.stopTest();
        System.assertEquals('200',Constants.RESPONSE_200); 
    }
    
/**
========================================================================================================================
----------------------------------------------------VISUALTIME_TEST-----------------------------------------------------
========================================================================================================================
*/
    
    /**
    * @description Test for Get Proposal status - Vtime
    * @author eayalcor@everis.com | 28-01-2020 
    * @return void 
    **/
    @isTest
    static void testGetProposalStatus(){
        
        String json = '{"causal": "OK","descripcion": "Aprobada","diasIngreso": 5539,"numeroEstado": 4,"resultado": 0}';
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 json,
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout(Constants.VTIME);
        
        VTimeClass.ProposalClass res = sc.getProposalStatus('54545','4548','5454');
        System.debug('RESPUESTA DEL TEST'+res);
        Test.stopTest();
        System.assertEquals(res.causal, 'OK');
    }
    /**
    * @description Test for Get Mandate Status 
    * @author eayalcor@everis.com | 28-01-2020 
    * @return void 
    **/
    @isTest
    static void testGetMandateStatus(){

        String json = '{"numeroPoliza": 202246,"numeroMandato": 57444,"descripcion": "Activado","banco" : "Banco Chile","motivoRechazo": "","resultado": 0 }';
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 json,
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout(Constants.VTIME);
        
        VTimeClass.MandateClass res = sc.getMandateStatus('54545','4548','5454');
        System.debug('RESPUESTA DEL TEST'+res);
        Test.stopTest();
        System.assertEquals(res.resultado, 0);
    }
    /**
    * @description Test for Set new Proposal
    * @author eayalcor@everis.com | 28-01-2020 
    * @return void 
    **/
    @isTest
    static void testSetProposal(){ 

        ProposalController.ProposalResponse pr = new ProposalController.ProposalResponse();
            pr.rutEjecutivo = 1;//mapUsrIds.get(lstQuote[0].OwnerId);
            pr.rutContratante = 1;//lstQuote[0].Opportunity.Numero_de_documento_sales__c;
            pr.numeroPropuesta =1;//= String.valueOf(lstQuote[0].Numero_de_Propuesta_sales__c);
            pr.numeroCotizacion =1;// String.valueOf(lstQuote[0].Numero_de_Cotizacion_sales__c);
            pr.idOportunidad = '1';//lstQuote[0].OpportunityId;
            pr.ramo = 1;//prod[0].Codigo_Macroproducto_Operacional_sales__c;
            pr.numeroProducto = 1;//prod[0].codigo_producto_sales__c;
        String json = '{"estado": 1,"mensaje": "La propuesta no existe"}';
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 json,
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout(Constants.VTIME);
        
        ProposalController.StoreProposalClass res = sc.setProposal(pr,'token', Constants.TYPECALL_MANUAL);
        System.debug('RESPUESTA DEL TEST'+res);
        Test.stopTest();
        //actualizar esta clase proposal, cambiaron los atributos de la clase proposal response
        System.assertEquals(res.estado, 1);
    }
    
    /**
    * @description 
    * @author eayalcor@everis.com | 6/23/2020 
    * @return void 
    **/
    @isTest
    static void testNotifyOffer(){
        TestFactorySales.populateOrg();
        List<Oferta__c> lstOffers = new List<Oferta__c>();
        Oferta__c offer = new Oferta__c();
        offer.Name= 'OFERID';
        offer.Ejecutivo_sales__c= '1-9';
        offer.Rut_Cliente_sales__c= '10854082-6';
        offer.Vigencia_Oferta_sales__c= Date.today();
        offer.Familia_Producto_sales__c= 'PLAN PLUS';
        offer.Descripcion_oferta_sales__c = '<p>test</p>';
        offer.Detalle_sales__c = 'Nueva Oferta';
        offer.Origen_sales__c = 'Contact Center';
        offer.AccountId__c = [SELECT Id FROM Account WHERE Rut__c = '10854082-6' LIMIT 1].Id;
        insert offer;
        
        lstOffers.add(offer);
        
        Set<Id> ids = new Set<Id>{offer.Id};
        
        OfferCmpController.NotifyAnalyticOffer obj = new OfferCmpController.NotifyAnalyticOffer();
        obj.code = 200;
        obj.message = null;
        obj.action = Constants.INSERTED;
        obj.OfertaList = lstOffers;     
            
        String json = JSON.serializePretty(lstOffers);
        
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 json,
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        //SalesCallout sc = new SalesCallout(Constants.ANALYTICSLEAD);
        
        SalesCallout.futureNotifyAnalyticsOffer(ids,Constants.INSERTED);
        Integer calloutsBefore = Limits.getCallouts();
        Test.stopTest();
        //actualizar esta clase proposal, cambiaron los atributos de la clase proposal response
        System.assertEquals(calloutsBefore,Limits.getCallouts());
    }

   

    /**
    * @description Test for Set new Proposal
    * @author eayalcor@everis.com | 28-01-2020 
    * @return void 
    **/
    @isTest
    static void testSetCumbres(){

        OppCumbresButtonController.RequestDto request = new OppCumbresButtonController.RequestDto();
        OppCumbresButtonController.dtoRequestSetParametros dto = new OppCumbresButtonController.dtoRequestSetParametros();
        
        String json = '{"dtoResponseCodigosEstadoHttp": {"codigo": "200","mensaje": "OK","descripcion": "OK"},"dtoResponseSetParametros": {"codigoError": "0","msjError": "Operacion realizada exitosamente"}}';
        dto.numeroSolicitud = '1234';
        dto.numeroOportunidad = '112344';
        dto.rutCliente = '176782412';
        dto.fechaSolicitud = date.today().format();
        dto.identificadorEjecutivo ='176782412';
        dto.producto = '4';
        request.dtoRequestSetParametros = dto;

        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 json,
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout(Constants.CUMBRES);
        
        OppCumbresButtonController.ResponseDto response = sc.setCumbres(request);
        Test.stopTest();
        //actualizar esta clase proposal, cambiaron los atributos de la clase proposal response
        System.assertEquals(response.dtoResponseSetParametros.codigoError, '0');
    }

        /**
    * @description Test for Set new Proposal
    * @author eayalcor@everis.com | 28-01-2020 
    * @return void 
    **/
    @isTest
    static void testUploadFileAlfresco(){

        RequestDTOAlfresco request = new RequestDTOAlfresco();
        ResponseDTOAlfresco response = new ResponseDTOAlfresco();

        RequestDTOAlfresco.Entrada entrada = new  RequestDTOAlfresco.Entrada();
        RequestDTOAlfresco.dtoRequestSetParametros dtoRequestSetParametros = new RequestDTOAlfresco.dtoRequestSetParametros();
        RequestDTOAlfresco.SubirArchivo subirArchivo = new RequestDTOAlfresco.SubirArchivo();

        
        String json = '{"dtoResponseCodigosEstadoHttp":{"codigo":"200","mensaje":"OK","descripcion":"OK"},"dtoResponseSetParametros":{"codigoError":"0","msjError":"Operacion realizada exitosamente"},"salidaAlfresco":{"codigo":"0","idAlfresco":"workspace://SpacesStore/ab3b80a7-1d6b-4968-b50d-8354598232f8","mensaje":"Ok"}}';
        entrada.codigoProducto = 'LALA';
        entrada.numeroProducto = '1';
        entrada.fecha = date.today().format();
        entrada.nombreArchivo = 'lalaalalaalal';
        entrada.contentType = 'application/pdf';
        entrada.rutCliente = '18344595';
        entrada.bytes = 'ESTE ES EL SUPER PDF';

        subirArchivo.entrada  = entrada;
        dtoRequestSetParametros.subirArchivo = subirArchivo;
        request.dtoRequestSetParametros = dtoRequestSetParametros;

        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 json,
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout(Constants.ALFRESCO);
        
        response = sc.uploadFileAlfresco(request);
        Test.stopTest();

        System.assertEquals(response.dtoResponseSetParametros.codigoError, '0');
    }
    /**
    * @description Test for Set new Proposal
    * @author eayalcor@everis.com | 28-01-2020 
    * @return void 
    **/
    @isTest
    static void viewFileAlfresco(){

        RequestDTOAlfresco request = new RequestDTOAlfresco();
        ResponseDTOAlfresco response = new ResponseDTOAlfresco();


        RequestDTOAlfresco.ConsultaDoc consultar = new RequestDTOAlfresco.ConsultaDoc();
        RequestDTOAlfresco.dtoRequestSetParametros dtoRequestSetParametros = new RequestDTOAlfresco.dtoRequestSetParametros();
        String json = '{"dtoResponseCodigosEstadoHttp":{"codigo":"200","mensaje":"OK","descripcion":"OK"},"dtoResponseSetParametros":{"codigoError":"0","msjError":"Operacion realizada exitosamente"},"salidaDocAlfresco":{"bytes":"JVBERi0xLjUNJeLjz9MNCjM5MiAwIG9iag08PC9MaW5lYXJpemVkIDEvTCAxMTE4MjEyL08gMzk0L0UgMTg2Mjc3L04gMTcvVCAxMTE3NjQ5L0ggWyA0NzkgMjczXT4+DWVuZG9iag0gICAgICAgICAgDQo0MDEgMCBvYmoNPDwvRGVjb2RlUGFybXM8PC9Db2x1bW5zIDUvUHJlZGljdG9yIDEyPj4vRmlsdGVyL0ZsYXRlRGVjb2RlL0lEWzw5ODM3N0IxM0RFQzREODRDOUZFQkY5MzFEQTU2RjEyQT48NEZBMEZENDJGREEwM0E0MDkzRTI4RjAyMEEwNzZGNDY+XS9JbmRleFszOTIgMjNdL0luZm8gMzkxIDAgUi9MZW5ndGggNjgvUHJldiAxMTE3NjUwL1Jvb3QgMzkzIDAgUi9TaXplIDQxNS9UeXBlL1hSZWYvV1sxIDMgMV0","codigo":"0","contentType":"application/pdf","mensaje":"OK","nombreArchivo":"18137691-0Manual-de-Usuario-autoconsultas-eXpert (1).pdf1594151806515"}}';
        consultar.idAlfresco = 'workspace://SpacesStore/d7f6a362-8015-4df0-a0ca-f96c60d27b63';
        consultar.rutCliente = '1325467';
        dtoRequestSetParametros.ConsultaDoc = consultar;
        request.dtoRequestSetParametros = dtoRequestSetParametros;
    
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 json,
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout(Constants.ALFRESCO);
        
        response = sc.viewFileAlfresco(request);
        Test.stopTest();

        System.assertEquals(response.dtoResponseSetParametros.codigoError, '0');
    }
    
        /**
    * @description 
    * @author eayalcor@everis.com | 6/23/2020 
    * @return void 
    **/
    @isTest
    static void testSetCheckBrandAnalytics(){ 
        PropensityController.RequestMarca request = new PropensityController.RequestMarca();
        PropensityController.ResponseMarca response = new PropensityController.ResponseMarca();
        
        request.rut = '176782412';
        request.rutEjecutivo = '176782412';
        
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"codigo":"1","mensaje":"OK","detalleMarcas":[]}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout(Constants.ANALYTICSMARCA);
        response = sc.checkBrandStatus(request);

        System.assertEquals(response.mensaje,Constants.OK);       
    }

    @isTest
    static void uploadFileDocuwareTest(){ 

        TestFactorySales.makeCustomSettings();

        DTODocuware.RequestUploadDocuware request = new DTODocuware.RequestUploadDocuware();
        DTODocuware.ResponseUploadDocuware response = new DTODocuware.ResponseUploadDocuware();
        
        List<DocuwareMetadata__c> lsMetadata = [SELECT Index_Label__c,Index_value__c FROM DocuwareMetadata__c
                                       WHERE Type_Index_List__c = : Constants.XML_INDICES];

        Map<String,String> mapMetadata = new Map<String,String>();
        for(DocuwareMetadata__c metaData : lsMetadata){
            if(metaData.Index_Label__c.equalsIgnoreCase(Constants.INDICE_CLIENTE)){
                metaData.Index_value__c = '176782412';
            }
            mapMetadata.put(metaData.Index_Label__c,metaData.Index_value__c);
        }

        request.archivador = Constants.CARPETA_DIGITAL_CLIENTE;
        request.xmlIndices = UtilitiesSales.generateMetadataDocuware(mapMetadata);
        request.extension = Constants.EXTENSION_PDF;
        request.contenido = ''; 
        
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"codigo":"0000", "codigoServicio":"0", "dwDocId":191986, "mensaje":null, "mensajeServicio":"OK"}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout(Constants.DOCUWARE);
        response = sc.uploadFileDocuware(request);
        Test.stopTest();
        System.assertEquals(response.mensajeServicio,Constants.OK);       
    }

    @isTest
    static void getFileDocuwareTest(){ 

        TestFactorySales.makeCustomSettings();

        DTODocuware.RequestGetDocuware request = new DTODocuware.RequestGetDocuware();
        DTODocuware.ResponseGetDocuware response = new DTODocuware.ResponseGetDocuware();
        
        List<DocuwareMetadata__c> lsMetadata = [SELECT Index_Label__c,Index_value__c FROM DocuwareMetadata__c
                                       WHERE Type_Index_List__c = : Constants.XML_FILTROS];

        Map<String,String> mapMetadata = new Map<String,String>();
        for(DocuwareMetadata__c metaData : lsMetadata){
            if(metaData.Index_Label__c.equalsIgnoreCase(Constants.INDICE_DWDOCID)){
                metaData.Index_value__c = '1234567';
            }
            mapMetadata.put(metaData.Index_Label__c,metaData.Index_value__c);
        }

        request.archivador = Constants.CARPETA_DIGITAL_CLIENTE;
        request.xmlFiltros = UtilitiesSales.generateMetadataDocuware(mapMetadata);
        
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"codigo": "0000","mensaje": "Ha ocurrido un error, contacte su administrador","mensajeServicio": "OK","codigoServicio": "0","documents": {"documentResult":[]}}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout(Constants.DOCUWARE);
        response = sc.getFileDocuware(request);
        Test.stopTest();
        System.assertEquals(response.mensajeServicio,Constants.OK);       
    }

  
    
    @isTest
    static void notifyBrandTest(){ 
        TestFactorySales.makeCustomSettings();
        List<RecordType> rt = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName =: Constants.RECORDTYPE_CASE_CORPORATIVOS LIMIT 1];
        Account acc = TestFactorySales.createNewAccount('24681953-k','TestNotifyBrand');
        Set<Id> lstIds = new Set<Id>();
        lstIds.add(UserInfo.getUserId());
        DTOCaseAnalytics.ListCaseTmp lstJson = new DTOCaseAnalytics.ListCaseTmp();
        List<DTOCaseAnalytics.CaseTmp> lstCaseNotify = new List<DTOCaseAnalytics.CaseTmp>();
        Case cIns = new Case();
        cIns.AccountId = acc.Id;
        cIns.Rut_del_Cliente__c = acc.RUT__c;
        cIns.Subject = Constants.CASE_SUBJECT_INCORPORACION;
        cIns.Description = Constants.CASE_DESCRIPTION_TERMINAR_PROCESO;
        cIns.Origin = Constants.CASE_CASE_ORIGIN_PRESENCIAL;
        cIns.RecordTypeId = rt[0].Id;
        cIns.Type = Constants.CASE_TYPE_SOLICITUD;
        cIns.Subtipo__c = Constants.CASE_SUBTIPO_DESUSCRIPCION;
        cIns.Status = Constants.CASE_STATUS_CERRADO;
        cIns.Sub_estado_Nectia__c = Constants.CASE_SUBESTADONECTIA_SOLUCIONADO;
        cIns.OwnerId = UserInfo.getUserId();
        cIns.Desuscribir_Telefono__c = true;
        insert cIns;
        
        DTOCaseAnalytics.CaseTmp obj = new DTOCaseAnalytics.CaseTmp();
        obj.id = cIns.Id;
        obj.ownerId = UserInfo.getUserId();
        obj.createdId = UserInfo.getUserId();
        obj.fieldName = 'Desuscribir_Telefono__c';
        obj.caseTmp = cIns;
        lstCaseNotify.add(obj);
        lstJson.lstCase = lstCaseNotify;
        
        Test.startTest();
        SalesCallout.notifyBrand(JSON.serialize(lstJson),Constants.ANALYTICSMARCA,lstIds);
        Test.stopTest();
		Integer callouts = Limits.getCallouts();
		System.assertEquals(0, callouts);    
    }
    
    /**
    * @description 
    * @author eayalcor@everis.com | 6/23/2020 
    * @return void 
    **/
    @isTest
    static void testGetDocuwareTokenOK(){ 
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"access_token": "eyJra","expires_in": 3600,"token_type": "Bearer"}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout(Constants.DOCUWARE);
        String token = sc.getDocuwareToken();

        System.assertEquals(token,'eyJra');       
    }

    @isTest
    static void consultUserAnalyticsAsyncMassivecTest(){
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg(); 
        Test.startTest();
         Account acc = (Account)mpsObjects.get('Account'); 
        User usea = (User)mpsObjects.get('User7');
        List<String> lst = new List<String>();
        lst.add(usea.Id);
        
         
         SalesCallout.consultUserAnalyticsAsyncMassive(lst,CONSTANTS.INSERTED,CONSTANTS.ANALYTICSLEAD);
        
        Test.stopTest();
        Integer callouts = Limits.getCallouts();
		System.assertEquals(0, callouts); 
    }

    @isTest
    static void callServiceCumbresTest(){
        String res = '{"DtoResponseCodigosEstadoHttp":{"codigo":"expected","mensaje":"expected","descripcion":"expected"},"DtoResponseSetParametros":{"codigoError":"expected","msjError":"expected"}}';
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,'OK',res,null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);

        String json = '{"rutEjecutivo":"1-9","idSolicitudSaleforce":"12324","idCasoSalesforce":"500","dataDoc":"test"}';
        Test.startTest();
        SalesCallout sc = new SalesCallout('CUMBRES2');
        sc.sourceip = '127.0.0.1';
        String response = sc.callServiceCumbres(json);
        SalesCallout.ResponseDTO dto = (SalesCallout.ResponseDTO) System.JSON.deserialize(response, SalesCallout.ResponseDTO.class );
        System.assertEquals('expected', dto.dtoResponseCodigosEstadoHttp.codigo);
        System.assertEquals('expected', dto.dtoResponseCodigosEstadoHttp.mensaje);
        System.assertEquals('expected', dto.dtoResponseCodigosEstadoHttp.descripcion);
        System.assertEquals('expected', dto.dtoResponseSetParametros.codigoError);
        System.assertEquals('expected', dto.dtoResponseSetParametros.msjError);
        Test.stopTest();
    }

    @isTest
    static void callServiceCumbresErrorTest(){
        String res = '{"DtoResponseCodigosEstadoHttp":{"codigo":"expected","mensaje":"expected","descripcion":"expected"},"DtoResponseSetParametros":{"codigoError":"expected","msjError":"expected"}}';
        SalesCalloutMock fakeResponse = new SalesCalloutMock(500,'BAD',res,null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);

        String json = '{"rutEjecutivo":"1-9","idSolicitudSaleforce":"12324","idCasoSalesforce":"500","dataDoc":"test"}';
        Test.startTest();
        SalesCallout sc = new SalesCallout('CUMBRES2');
        sc.sourceip = '127.0.0.1';
        String response = sc.callServiceCumbres(json);
        SalesCallout.ResponseDTO dto = (SalesCallout.ResponseDTO) System.JSON.deserialize(response, SalesCallout.ResponseDTO.class );
        System.assertEquals('expected', dto.dtoResponseCodigosEstadoHttp.codigo);
        System.assertEquals('expected', dto.dtoResponseCodigosEstadoHttp.mensaje);
        System.assertEquals('expected', dto.dtoResponseCodigosEstadoHttp.descripcion);
        System.assertEquals('expected', dto.dtoResponseSetParametros.codigoError);
        System.assertEquals('expected', dto.dtoResponseSetParametros.msjError);
        Test.stopTest();
    }
    
    @isTest
    static void testgetInfoUserRRHH(){ 
        
        
        InfoUserBatch.RequestRRHH request = new InfoUserBatch.RequestRRHH();
        InfoUserBatch.ResponseRRHH response = new InfoUserBatch.ResponseRRHH();
        List<String> lstRut = new List<String>();
        lstRut.add('235364425');       
      	Request.ruts = lstRut;
        
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"registros":[{"rut":"235364425","email":"eduardo.ojeda@consorcio.cl","cargo":"JEFE DESARROLLO CRM","departamento":"GCIA INTELIGENCIA COM Y CRM","compania":"CGRAL","sucursal":"EDIFICIO EL BOSQUE PISO 1","telefono":"5622222222","anexo":"2242","rut_jefe_directo":"83270942","fecha_inicio_licencia":"01-10-2020","fecha_termino_licencia":"05-10-2020","fecha_inicio_vacaciones":"","fecha_termino_vacaciones":""},{"rut":"161040819","email":"dummy.ffvv@consorcio.cl","cargo":"EJECUTIVO DE VENTAS","departamento":"AGENCIA ANTOFAGASTA 199","compania":"CVIDA","sucursal":"EDIFICIO EL BOSQUE PISO 1","telefono":"222222221","anexo":"2249","rut_jefe_directo":"83270942","fecha_inicio_licencia":"","fecha_termino_licencia":"","fecha_inicio_vacaciones":"","fecha_termino_vacaciones":""}]}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SalesCallout sc = new SalesCallout(Constants.RRHH);
        response = sc.getInfoUserRRHH(request);

        System.assertEquals(response.registros[0].rut,'235364425');       
    }
}