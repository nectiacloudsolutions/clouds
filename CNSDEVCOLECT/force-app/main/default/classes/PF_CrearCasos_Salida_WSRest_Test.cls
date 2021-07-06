/*********************************************************************************************************
@Author       luis.vidal@consorcio.cl
@name         PF_CrearCaso_Salida_WSRest_Test
@CreateDate   21/10/2020
@Description  Service Test para la clase PF_CrearCaso_Salida_WSRest_Test 
**********************************************************************************************************/
@IsTest
public class PF_CrearCasos_Salida_WSRest_Test {
    @testSetup static void setup(){

        User newUsr =TestFactorySales.createUser('24770129k', 'Integraciones', 'testCsPF');     
		Insert newUsr; 
        
        Account cuenta = new Account();
        cuenta.RUT__c = '9121329-k';//1-9';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.FirstName='Juan';
        cuenta.LastName = 'Perez';
        cuenta.phone = '1333333222';
        cuenta.PersonEmail = 'test@test.cl';
        insert cuenta;
        
        
        
        
    }
    @isTest static void testCasosRetencion() {

        String json = '{"codigo":"1","mensaje":"OK", "respuesta" : {"hipotecario":true,"hipotecarioConCNS":false,"segmentacionCliente":"texto"}}';
        PFCalloutMock fakeResponse = new PFCalloutMock(200, 'ok', json, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

        User us = [SELECT Id FROM User WHERE RUT__c = '24770129k'];
        System.Test.startTest();
        String jsonReq = '';
        System.runAs(us) {
            
            
        	
            
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestURI = '/services/apexrest/CrearCasosSalidaPF/CrearCasosSalidaPF';  //Request URL
            req.httpMethod = 'POST';//HTTP Request Type
            req.requestBody = Blob.valueof(pruebaJsonEntrada());
            RestContext.request = req;
            RestContext.response= res;

        	jsonReq = PF_CrearCasos_Salida_WSRest.CrearCasosSalidaPF();            
        }
        
        List<Case> lstCasos = consultaCasosCreados(jsonReq);
        
		System.Test.stopTest();
        for (Case nCaso : lstCasos){
			//system.assertEquals('Caso_Portabilidad_Salida', nCaso.get(Label.PF_Caso_RecordType_Salida));
			
        }    
        
		
    }
    
    // consultamos la información creada en los Casos    
    private static List<Case> consultaCasosCreados(String jsonResponse){
        List<Case> lstCasosPF = new List<Case>();
        List<String> lstRUT = new List<String>();
        String cuentaRUT;
                
        PF_CrearCasos_Salida_ReqResp_JSON response = PF_CrearCasos_Salida_ReqResp_JSON.parse(jsonResponse);
        List<PF_CrearCasos_Salida_ReqResp_JSON.PFCreaCasoSalidaResp> subRespLst = response.PFCreaCasoSalidaResp;

        for(PF_CrearCasos_Salida_ReqResp_JSON.PFCreaCasoSalidaResp subResp : subRespLst){
            cuentaRUT = subResp.rutCliente;
			lstRUT.add(cuentaRUT);
        }
        
        lstCasosPF = [select Status, Rut__c, OwnerId from Case where Rut__c IN: lstRUT];

        return lstCasosPF;
    }
    
    private static String pruebaJsonEntrada(){
        String json = '{'+
            '  "PFCreaCasoSalidaReq": ['+
            '    {'+
            '      "rutCliente": "9121329-k",'+
            '      "tipo": "solicitud",'+
            '      "subtipo": "Portabilidad Financiera Salida",'+
            '      "IdRedbanc": "1234ASD",'+
            '      "IdCumbres": "12324EW"'+
            '    }'+
            '  ]'+
            '}';
        return json;
    }

}