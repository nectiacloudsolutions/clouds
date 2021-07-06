/*********************************************************************************************************
@Author       luis.vidal@consorcio.cl
@name         CreateCaseBanca_Test
@CreateDate   16/10/2020
@Description  Service Test para la clase CreateCaseBanca 
**********************************************************************************************************/
@IsTest
public class CreateCaseBancaTest {
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
    @isTest static void creacionCasosBanco() {
        User us = [SELECT Id FROM User WHERE RUT__c = '24770129k'];
        System.Test.startTest();
        String jsonReq = '';
        System.runAs(us) {
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestURI = '/services/apexrest/CreateCaseBanca/CreateCaseBanca';  //Request URL
            req.httpMethod = 'POST';//HTTP Request Type
            req.requestBody = Blob.valueof(pruebaJsonEntrada());
            RestContext.request = req;
            RestContext.response= res;

        	jsonReq = CreateCaseBanca.CreateCaseBanca();            
        }
        
        List<Case> lstCasos = consultaCasosCreados(jsonReq);
        
		System.Test.stopTest();
           
    }
    
    // consultamos la información creada en los Casos    
    private static List<Case> consultaCasosCreados(String jsonResponse){
        List<Case> lstCasosPF = new List<Case>();
        List<String> lstRUT = new List<String>();
        String cuentaRUT;
                
        CreateCaseBancaDto response = CreateCaseBancaDto.parse(jsonResponse);
        List<CreateCaseBancaDto.CreateCaseBancaResponse> subRespLst = response.CreateCaseBancaResponse;

        for(CreateCaseBancaDto.CreateCaseBancaResponse subResp : subRespLst){
            cuentaRUT = subResp.rutCliente;
			lstRUT.add(cuentaRUT);
        }
        
        lstCasosPF = [select Status, Rut__c, OwnerId from Case where Rut__c IN: lstRUT];

        return lstCasosPF;
    }
    
    private static String pruebaJsonEntrada(){
        String json = '{'+
            '  "CreateCaseBancaRequest": ['+
            '    {'+
            '      "rutCliente": "9121329-k",'+
            '      "tipo": "Consulta",'+
            '      "subtipo": "Activación PAC",'+
            '      "productoBanco": "Crédito hipotecario",'+
            '      "Origen": "IVR Autoatención"'+
            '    }'+
            '  ]'+
            '}';
        return json;
    }

}