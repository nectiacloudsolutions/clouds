@isTest()
public class ListFileController_Test {
    
    @testSetup
    private static void testDataCreate() {
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();
        TestFactorySales.makeCustomSettings();
    }
    @isTest()
    public static void testGetData(){
            List<Case> lstCase = [SELECT Id,id_alfresco_caso_sales__c,id_docuware_sales__c,Fecha_Documento__c FROM Case WHERE id_alfresco_caso_sales__c!=null and id_docuware_sales__c!=null];
        ListFileController.getData(lstCase[0].id);
 
    }
    
    @isTest()
    public static void testviewDocAlfresco(){
                
        List<Case> lstCase = [SELECT Id,id_alfresco_caso_sales__c,id_docuware_sales__c FROM Case WHERE id_alfresco_caso_sales__c!=null];
        ResponseDTOAlfresco response = new ResponseDTOAlfresco();
        String json = '{"dtoResponseCodigosEstadoHttp":{"codigo":"200","mensaje":"OK","descripcion":"OK"},"dtoResponseSetParametros":{"codigoError":"0","msjError":"Operacion realizada exitosamente"},"salidaDocAlfresco":{"bytes":"JVBERi0xLjUNJeLjz9MNCjM5MiAwIG9iag08PC9MaW5lYXJpemVkIDEvTCAxMTE4MjEyL08gMzk0L0UgMTg2Mjc3L04gMTcvVCAxMTE3NjQ5L0ggWyA0NzkgMjczXT4+DWVuZG9iag0gICAgICAgICAgDQo0MDEgMCBvYmoNPDwvRGVjb2RlUGFybXM8PC9Db2x1bW5zIDUvUHJlZGljdG9yIDEyPj4vRmlsdGVyL0ZsYXRlRGVjb2RlL0lEWzw5ODM3N0IxM0RFQzREODRDOUZFQkY5MzFEQTU2RjEyQT48NEZBMEZENDJGREEwM0E0MDkzRTI4RjAyMEEwNzZGNDY+XS9JbmRleFszOTIgMjNdL0luZm8gMzkxIDAgUi9MZW5ndGggNjgvUHJldiAxMTE3NjUwL1Jvb3QgMzkzIDAgUi9TaXplIDQxNS9UeXBlL1hSZWYvV1sxIDMgMV0","codigo":"0","contentType":"application/pdf","mensaje":"OK","nombreArchivo":"18137691-0Manual-de-Usuario-autoconsultas-eXpert (1).pdf1594151806515"}}';

        Test.startTest();
            SalesCalloutMock fakeResponse = new SalesCalloutMock(200,'OK',json,null);
            Test.setMock(HttpCalloutMock.class, fakeResponse);
            response = ListFileController.viewDocAlfresco(lstCase[0].id_alfresco_caso_sales__c);
        Test.stopTest();

        System.assertEquals(response.SalidaDocAlfresco.codigo, '0');
    }
    @isTest
    public static void testviewDocDocuware(){
        
        List<Case> lstCase = [SELECT Id,id_alfresco_caso_sales__c,id_docuware_sales__c,Fecha_Documento__c FROM Case WHERE id_docuware_sales__c!=null];
        DTODocuware.ResponseGetDocuware response = new DTODocuware.ResponseGetDocuware();
        
        Test.startTest();
        SalesCalloutMock fakeResponse = new SalesCalloutMock(200,
                                                 'OK',
                                                 '{"codigo": "0000","mensaje": "Ha ocurrido un error, contacte su administrador","mensajeServicio": "OK","codigoServicio": "0","documents": {"documentResult":[]}}',
                                                 null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        response = ListFileController.viewDocDocuware(lstCase[0].id_docuware_sales__c);
        Test.stopTest();
        System.assertEquals(response.mensajeServicio,Constants.OK);  
        
    }
    
}