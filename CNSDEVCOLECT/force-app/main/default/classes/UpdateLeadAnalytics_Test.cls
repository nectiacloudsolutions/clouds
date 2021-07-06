@isTest
private with sharing class UpdateLeadAnalytics_Test {

    @testSetup
    private static void loadDataConfig(){
        TestFactorySales.populateOrg();
    }

    @isTest
    static void UpdateLeadAnalytics_Test_success(){

        UpdateLeadAnalytics.Request request = new UpdateLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        Test.startTest();

        User usr = [SELECT RUT__c
                      FROM User WHERE (Profile.Name = 'Ejecutivo de Venta') 
                      AND IsActive = true LIMIT 1];
        
        string rut_ejec = usr.RUT__c;
        
        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '17944392-9';
        newLead.numero_de_documento_sales__c = '22222222-2';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = '';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = '';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = Datetime.now();
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = 'Alta';
        
        insert newLead;

        String json = ('{"records": [{"FirstName": "TEST2","LastName": "TEST2","motherlastname_sales__c": "ZIMMERMANN3","rut_ejecutivo_sales__c": "'+rut_ejec+'","numero_de_documento_sales__c": "22222222-2","tipo_documento_sales__c": "RUT","Phone": "992502057","status": "No Gestionado","other_phone_sales__c": "222222","other_phone2_sales__c": "22222","reasignaciones_del_lead_sales__c": "2","Email": "email@hdhdh.cl","nuevo_correo_sales__c": "nuevo@email.com","LeadSource": "Analytics","genero_sales__c": "Femenino","calle_sales__c": "calle 1","numero_sales__c": "22","numero_de_piso_sales__c": "2","numero_departamento_sales__c": "2","comuna_sales__c": "13107","villa_sales__c": "villa x","region_sales__c": "CL-RM","provincia_sales__c": "131","sla_sales__c": "2020-02-14T09:00:00Z","fecha_nacimiento_sales__c": "1970-02-23","zona_sales__c": "Metroplitana","sucursal_sales__c": "Casa Matriz (El Bosque)","Rating": "baja"}]}');
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/UpdateLeadAnalytics';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = UpdateLeadAnalytics.UpdateLeadAnalytics();
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_200);

    }
    
    @isTest
    static void UpdateLeadAnalytics_Test_bad_request_data(){

        UpdateLeadAnalytics.Request request = new UpdateLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        Test.startTest();
        
        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '17944392-9';
        newLead.numero_de_documento_sales__c = '22222222-2';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = '';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = '';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = Datetime.now();
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = 'Alta';
        
        insert newLead;

        String json = ('{"records": [{"FirstName": "TEST2","LastName": "TEST2","motherlastname_sales__c": "ZIMMERMANN3","rut_ejecutivo_sales__c": "17944392-9","numero_de_documento_sales__c": "22222222-2","tipo_documento_sales__c": "RUT","Phone": "992502057","status": "No Gestionado","other_phone_sales__c": "222222","other_phone2_sales__c": "22222","reasignaciones_del_lead_sales__c": "2","Email": "email@hdhdh.cl","nuevo_correo_sales__c": "nuevo@email.com","LeadSource": "Analytics","genero_sales__c": "Femenino","calle_sales__c": "calle 1","numero_sales__c": "22","numero_de_piso_sales__c": "2","numero_departamento_sales__c": "2","comuna_sales__c": "13107","villa_sales__c": "villa x","region_sales__c": "CL-R2M","provincia_sales__c": "131","sla_sales__c": "2020-02-14T09:00:00Z","fecha_nacimiento_sales__c": "1970-02-23","zona_sales__c": "Metroplitana","sucursal_sales__c": "Casa Matriz (El Bosque)","Rating": "baja"}]}');

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/UpdateLeadAnalytics';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = UpdateLeadAnalytics.UpdateLeadAnalytics();
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_400);
    }

    @isTest
    static void UpdateLeadAnalytics_Test_no_exectuve(){

        UpdateLeadAnalytics.Request request = new UpdateLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        Test.startTest();
        
        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '';
        newLead.numero_de_documento_sales__c = '22222222-2';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = '';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = '';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = Datetime.now();
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = 'Alta';
        
        insert newLead;

        String json = ('{"records": [{"FirstName": "TEST2","LastName": "TEST2","motherlastname_sales__c": "ZIMMERMANN3","rut_ejecutivo_sales__c": "17944392-9","numero_de_documento_sales__c": "22222222-2","tipo_documento_sales__c": "RUT","Phone": "992502057","status": "No Gestionado","other_phone_sales__c": "222222","other_phone2_sales__c": "22222","reasignaciones_del_lead_sales__c": "2","Email": "email@hdhdh.cl","nuevo_correo_sales__c": "nuevo@email.com","LeadSource": "Analytics","genero_sales__c": "Femenino","calle_sales__c": "calle 1","numero_sales__c": "22","numero_de_piso_sales__c": "2","numero_departamento_sales__c": "2","comuna_sales__c": "13107","villa_sales__c": "villa x","region_sales__c": "CL-R2M","provincia_sales__c": "131","sla_sales__c": "2020-02-14T09:00:00Z","fecha_nacimiento_sales__c": "1970-02-23","zona_sales__c": "Metroplitana","sucursal_sales__c": "Casa Matriz (El Bosque)","Rating": "baja"}]}');

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/UpdateLeadAnalytics';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = UpdateLeadAnalytics.UpdateLeadAnalytics();
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_400);
    }

    @isTest
    static void UpdateLeadAnalytics_Test_fail_status_value(){

        UpdateLeadAnalytics.Request request = new UpdateLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        Test.startTest();
        
        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '17944392-9';
        newLead.numero_de_documento_sales__c = '22222222-2';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = '';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = '';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = Datetime.now();
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = 'Alta';
        
        insert newLead;

        String json = ('{"records": [{"FirstName": "TEST2","LastName": "TEST2","motherlastname_sales__c": "ZIMMERMANN3","rut_ejecutivo_sales__c": "17944392-9","numero_de_documento_sales__c": "22222222-2","tipo_documento_sales__c": "RUT","Phone": "992502057","status": "Hola","other_phone_sales__c": "222222","other_phone2_sales__c": "22222","reasignaciones_del_lead_sales__c": "2","Email": "email@hdhdh.cl","nuevo_correo_sales__c": "nuevo@email.com","LeadSource": "Analytics","genero_sales__c": "Femenino","calle_sales__c": "calle 1","numero_sales__c": "22","numero_de_piso_sales__c": "2","numero_departamento_sales__c": "2","comuna_sales__c": "13107","villa_sales__c": "villa x","region_sales__c": "CL-RM","provincia_sales__c": "131","sla_sales__c": "2020-02-14T09:00:00Z","fecha_nacimiento_sales__c": "1970-02-23","zona_sales__c": "Metroplitana","sucursal_sales__c": "Casa Matriz (El Bosque)","Rating": "baja"}]}');

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/UpdateLeadAnalytics';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = UpdateLeadAnalytics.UpdateLeadAnalytics();
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_400);

    }

    @isTest
    static void UpdateLeadAnalytics_Test_fail_invalid_executive(){

        UpdateLeadAnalytics.Request request = new UpdateLeadAnalytics.Request();
        UtilitiesSalesREST.Response response = new UtilitiesSalesREST.Response();

        Test.startTest();
        
        Lead newLead = new Lead();
        newLead.FirstName = 'sample';
        newLead.LastName = 'sample';
        newLead.motherlastname_sales__c = '';
        newLead.rut_ejecutivo_sales__c = '17944392-9';
        newLead.numero_de_documento_sales__c = '22222222-2';
        newLead.Phone = '';
        newLead.other_phone_sales__c = '';
        newLead.Email = '';
        newLead.nuevo_correo_sales__c = '';
        newLead.LeadSource = '';
        newLead.genero_sales__c = '';
        newLead.calle_sales__c = '';
        newLead.numero_sales__c = '';
        newLead.numero_de_piso_sales__c = '';
        newLead.numero_departamento_sales__c = '';
        newLead.comuna_sales__c = '';
        newLead.villa_sales__c = '';
        newLead.region_sales__c = '';
        newLead.sla_sales__c = Datetime.now();
        newLead.fecha_nacimiento_sales__c = null;
        newLead.Rating = 'Alta';
        
        insert newLead;

        String json = ('{"records": [{"FirstName": "TEST2","LastName": "TEST2","motherlastname_sales__c": "ZIMMERMANN3","rut_ejecutivo_sales__c": "17944223-9","numero_de_documento_sales__c": "22222222-2","tipo_documento_sales__c": "RUT","Phone": "992502057","status": "Hola","other_phone_sales__c": "222222","other_phone2_sales__c": "22222","reasignaciones_del_lead_sales__c": "2","Email": "email@hdhdh.cl","nuevo_correo_sales__c": "nuevo@email.com","LeadSource": "Analytics","genero_sales__c": "Femenino","calle_sales__c": "calle 1","numero_sales__c": "22","numero_de_piso_sales__c": "2","numero_departamento_sales__c": "2","comuna_sales__c": "13107","villa_sales__c": "villa x","region_sales__c": "CL-RM","provincia_sales__c": "131","sla_sales__c": "2020-02-14T09:00:00Z","fecha_nacimiento_sales__c": "1970-02-23","zona_sales__c": "Metroplitana","sucursal_sales__c": "Casa Matriz (El Bosque)","Rating": "baja"}]}');

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/UpdateLeadAnalytics';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(json);
        RestContext.request = req;
        RestContext.response= res;

        response = UpdateLeadAnalytics.UpdateLeadAnalytics();
        
        Test.stopTest();
        System.assertEquals(response.response[0].statusCode, Constants.RESPONSE_400);

    }


}