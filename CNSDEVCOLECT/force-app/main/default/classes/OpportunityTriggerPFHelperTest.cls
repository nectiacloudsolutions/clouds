/*********************************************************************************************************
@Author       gcabrerp@everis.com
@name         OpportunityTriggerPFHelperTest
@CreateDate   13/11/2020
@Description  Service Test para la clase OpportunityTriggerPFHelper 
**********************************************************************************************************/
@isTest
public class OpportunityTriggerPFHelperTest {
    private static Map<String,Group> gruposMap;
    private final static String PORT_COORDI_OPERA = Label.PF_Cola_Coordina_Operacional;
    private final static String PF_RECORD_TYPE = Label.PF_Opp_RecordType;
    private final static List<String> GRUPOS_COLAS = new List<String>{PORT_COORDI_OPERA};
        
    private static final String USER_8 = 'User8';
    private static final String ACCOUNT_NAME = 'Account';
    private static final String PRODUCT_CODE = '801';
    private static final String PRODUCT_NAME = 'Plan Plus';
    private static final String DOS = '2';
    private static final String UNO = '1';
    private static final String TIPO_PRODUCTO = 'plan_plus_sales';
    private static final String OPP_NAME = 'Test Control Field Opp';
    private static final String OLI_NAME = 'Test Opp Plan Plus';
    private final static String PF_COMPLETAR_CAMPO_ESTADO_EVALUACION = Label.PF_Completar_Campo_Estado_Evaluacion;
    private final static String PF_COMPLETAR_CAMPO_ACEPTACION_OFERTA = Label.PF_Completar_Campo_Aceptacion_Oferta;    
    
    
    @testSetup static void setup(){
        Test.startTest();
        Account cuenta = new Account();
        cuenta.RUT__c = '1-9';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.FirstName='Juan';
        cuenta.LastName = 'Perez';
        cuenta.phone = '1333333222';
        cuenta.PersonEmail = 'test@test.cl';
        insert cuenta;
        
        Group grupo = new Group();
        grupo.DeveloperName = 'PORT_COORDI_OPERA';
        grupo.name = PORT_COORDI_OPERA;
        grupo.Type='Queue';
        insert grupo;
        
        Opportunity opp = new Opportunity();
        opp.CloseDate=date.today();
        opp.AccountId = cuenta.id;
        opp.Name='test opp 1';
        opp.StageName='Contacto';
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(PF_RECORD_TYPE).getRecordTypeId();
        insert opp;
        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue1 = new QueueSObject(QueueID = grupo.id, SObjectType = 'Case'); /* Validar si se cambia a Opportunity*/
            insert testQueue1;
        }
        
        List<sObject> ls1 = System.Test.loadData(TaskInformation__c.sObjectType, 'testTaskInformation');
        List<TaskInformation__c> lsn1 = (List<TaskInformation__c>)ls1;
        update lsn1; 
        
        List<sObject> ls = System.Test.loadData(MessageNotification__c.sObjectType, 'testMessageNotification');
        List<MessageNotification__c> lsn = (List<MessageNotification__c>)ls;
        update lsn;
        
        Consorcio_Org__c org = new Consorcio_Org__c();
        org.Sales_project__c = true;
        insert org;  
        
        llenarData();
        System.test.stopTest();
    }
    
    @isTest static void debeCrearTareaSolFirmada(){
        Boolean clienteApto = true;
        buscarGrupos();
        System.test.startTest();  
        Opportunity opp = [SELECT StageName, Sol_Firmada_PF__c FROM Opportunity LIMIT 1];
        
        opp.Sol_Firmada_PF__c = true;
        
        List<PermissionSetAssignment>  usr = [select AssigneeId from PermissionSetAssignment where PermissionSet.Name = 'PS_PortabilidadFinanciera' and Assignee.isActive = true LIMIT 1];
        User usrId = new User();
        
        
        for(PermissionSetAssignment usuario : usr){
            usrId.id = (usuario.AssigneeId);
        }
        
        System.runAs(usrId){
            if(usrId==null){
                update opp;
            }
        }
        
        System.test.stopTest();
    }
    
    @isTest static void debeCrearTareaStageCAD(){
        Boolean clienteApto = true;
        buscarGrupos();
        System.test.startTest();  
        Map<Id,Opportunity> oppIdMap = new Map<Id,Opportunity>( [SELECT RecordTypeId, StageName, Sol_Firmada_PF__c FROM Opportunity LIMIT 1]);
        List<Opportunity> lstOpp = new list<Opportunity>();
        for(Opportunity opp : oppIdMap.values()){
            Opportunity nOpp = opp.clone(true,true);
            nOpp.StageName = 'CAD';
            lstOpp.add(nOpp);
        }
        OpportunityTriggerPFHelper.createTaskByOpps(lstOpp, oppIdMap);
        System.test.stopTest();
    }
    
    @isTest static void debeCrearTareaStageFCE(){
        buscarGrupos();
        System.test.startTest();  
        Map<Id,Opportunity> oppIdMap = new Map<Id,Opportunity>( [SELECT RecordTypeId, StageName, Sol_Firmada_PF__c FROM Opportunity LIMIT 1]);
        List<Id> mapKeys = new List<Id>(oppIdMap.keySet());
        oppIdMap.get(mapKeys[0]).StageName = 'Oferta de portabilidad';
        
        List<Opportunity> lstOpp = new list<Opportunity>();
        for(Opportunity opp : oppIdMap.values()){            
            Opportunity nOpp = opp.clone(true,true);
            nOpp.StageName = 'Firma Contrato/Escritura';
            lstOpp.add(nOpp);
        }
        OpportunityTriggerPFHelper.createTaskByOpps(lstOpp, oppIdMap);
        System.test.stopTest();
    }
    
    @isTest static void debeCrearTareaSolFirmadaNuevo(){
        buscarGrupos();
        System.test.startTest();  
        Map<Id,Opportunity> oppIdMap = new Map<Id,Opportunity>( [SELECT RecordTypeId, StageName, Sol_Firmada_PF__c FROM Opportunity LIMIT 1]);
        List<Opportunity> lstOpp = new list<Opportunity>();
        for(Opportunity opp : oppIdMap.values()){
            Opportunity nOpp = opp.clone(true,true);
            nOpp.StageName = 'Contacto';
            nOpp.Sol_Firmada_PF__c = true;          
            lstOpp.add(nOpp);
        }
        OpportunityTriggerPFHelper.createTaskByOpps(lstOpp, null);
        System.test.stopTest();
    }   
    
    @isTest static void debeCrearTareaStageCADNuevo(){
        buscarGrupos();
        System.test.startTest();  
        Map<Id,Opportunity> oppIdMap = new Map<Id,Opportunity>( [SELECT RecordTypeId, StageName, Sol_Firmada_PF__c FROM Opportunity LIMIT 1]);
        List<Opportunity> lstOpp = new list<Opportunity>();
        for(Opportunity opp : oppIdMap.values()){
            Opportunity nOpp = opp.clone(true,true);
            nOpp.StageName = 'CAD';
            lstOpp.add(nOpp);
        }
        OpportunityTriggerPFHelper.createTaskByOpps(lstOpp, null);
        System.test.stopTest();
    } 
    
    @isTest static void debeCrearTareaStageFCENuevo(){
        buscarGrupos();
        System.test.startTest();  
        Map<Id,Opportunity> oppIdMap = new Map<Id,Opportunity>( [SELECT RecordTypeId, StageName, Sol_Firmada_PF__c FROM Opportunity LIMIT 1]);
        List<Opportunity> lstOpp = new list<Opportunity>();
        for(Opportunity opp : oppIdMap.values()){
            Opportunity nOpp = opp.clone(true,true);
            nOpp.StageName = 'Firma Contrato/Escritura';
            lstOpp.add(nOpp);
        }
        OpportunityTriggerPFHelper.createTaskByOpps(lstOpp, null);
        System.test.stopTest();
    }    
    
    private static void buscarGrupos(){
        gruposMap = new Map<String,Group>();
        for(Group grupo : [select DeveloperName from Group where DeveloperName IN: GRUPOS_COLAS ]){
            gruposMap.put(grupo.DeveloperName, grupo);
        }
    }
    
    private static void llenarData(){
        //Create a new Account
        Account acc = new Account();
        acc.FirstName = 'ACCOUNT ';
        acc.LastName = 'DUMMY SALES';
        acc.RUT__c = '10854082-6';
        acc.PersonOtherPhone = '56701719';
        acc.PersonEmail='Dummy@test.cl';
        acc.PersonMobilePhone='66666666';
        acc.Phone = '999999999';
        acc.OwnerId = UserInfo.getUserId();
        acc.recordTypeId=[SELECT Id FROM RecordType WHERE developerName='Cliente_Persona_Seguros' LIMIT 1].Id;
        acc.Tipo_de_documento_de_identidad__c = 'RUT';
        insert acc;
                
        Product2 p2 = new Product2();
        p2.IsActive = true;
        p2.ProductCode = PRODUCT_CODE;
        p2.Name = PRODUCT_NAME;
        p2.codigo_producto_sales__c= DOS;
        p2.Codigo_Macroproducto_Operacional_sales__c=UNO;
        p2.tipo_producto_sales__c = TIPO_PRODUCTO;
        p2.Family = 'Plan Plus';
        
        insert p2;
        
        Id idProd2 = Test.getStandardPricebookId();
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = idProd2;
        pbe.Product2Id = p2.Id;
        pbe.UnitPrice = 1;
        pbe.IsActive = true;
        insert pbe;
        
        Opportunity newOpp = new Opportunity();
        newOpp.StageName = 'Contacto';
        newOpp.Sol_Firmada_PF__c = true;
        newOpp.tipo_de_gestion_portabilidad__c= 'Contactado';
        newOpp.CloseDate = Date.TODAY().addMonths(1);
        newOpp.AccountId = acc.Id;
        newOpp.Name = OPP_NAME;
        newOpp.tipo_contrato_sales__c = 'Dependiente';
        newOpp.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =:'RT_Portabilidad_financiera' LIMIT 1].Id;
        newOpp.OwnerId = UserInfo.getUserId();        
        insert newOpp;
        
        newOpp.StageName = 'Simulación';
        newOpp.PF_Cert_Liq_Adjuntado__c = true;
        newOpp.PF_Correo_Simulacion__c = true;
        newOpp.PF_Fecha_Solicitud_Antecedentes_Simula__c = Date.today();
        
        update newOpp;
        
        OpportunityLineItem opli = new OpportunityLineItem();
        opli.OpportunityId = newOpp.Id;
        opli.PricebookEntryId = pbe.Id;
        opli.Quantity = 1;
        opli.UnitPrice = 1;
        opli.Product2Id = p2.Id;
        opli.Numero_Op_Comercializadora_sales__c = '123';
        insert opli;

        newOpp.StageName = 'Evaluación';
        newOpp.tipo_de_gestion_portabilidad__c= 'Contactado';
        newOpp.PF_Cert_Liq_Adjuntado__c = true;
        newOpp.PF_Oferta_enviada__c = true;
        newOpp.PF_flag_evaluacion__c = true;
        update newOpp;
    }
    
    @isTest static void cambiarEstadoEvaluacionToOferta(){
        System.test.startTest();  
        Opportunity Opp = [SELECT RecordTypeId, StageName, Sol_Firmada_PF__c FROM Opportunity where Name=:OPP_NAME LIMIT 1];
        try{
            opp.StageName = 'Oferta de portabilidad';
            update opp;
        } catch(Exception e) {
            Boolean expectedExceptionThrown =  (e.getMessage().contains(PF_COMPLETAR_CAMPO_ESTADO_EVALUACION)) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        OpportunityLineItem oppLineItem = [SELECT Id FROM OpportunityLineItem WHERE OpportunityId=:opp.Id LIMIT 1];
        oppLineItem.Estado_de_Evaluacion__c = 'Aprobado';
        update oppLineItem;
        opp.StageName = 'Oferta de portabilidad';
        
        update opp;
        opp.PF_Resultado_Oferta__c = 'Aceptada Total';
        update opp;
        try{
            opp.StageName = 'Firma Contrato/Escritura';
            update opp;
        } catch(Exception e) {
            Boolean expectedExceptionThrown =  (e.getMessage().contains(PF_COMPLETAR_CAMPO_ACEPTACION_OFERTA)) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }

        oppLineItem.Aceptacion_de_Oferta__c = 'No';
        update oppLineItem;
        opp.StageName = 'Firma Contrato/Escritura';
        
        
        update opp;
        System.test.stopTest();  
    }
    
    @isTest static void CrearProdAutomaticamente(){
		System.test.startTest();
        Account acc = new Account();
        acc.FirstName = 'ACCOUNT ';
        acc.LastName = 'TEST SALES';
        acc.RUT__c = '11111111-1';
        acc.PersonOtherPhone = '56701719';
        acc.PersonEmail='Dummytest@test.cl';
        acc.PersonMobilePhone='999999999';
        acc.Phone = '66666666';
        acc.OwnerId = UserInfo.getUserId();
        acc.recordTypeId=[SELECT Id FROM RecordType WHERE developerName='Cliente_Persona_Seguros' LIMIT 1].Id;
        acc.Tipo_de_documento_de_identidad__c = 'RUT';
        insert acc;
        
        Case caso = new Case();
        caso.Caso_PF_Credito_Consumo__c = true;
        caso.Caso_PF_Credito_Hipotecario__c = true;
        caso.Caso_PF_Plan_Plus__c = true;
		caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Caso_PF_Caso_de_Portabilidad').getRecordTypeId();
		caso.Status = 'Evaluación';
        caso.Type = 'Solicitud';
        caso.Subtipo__c ='Portabilidad Financiera entrada';
        caso.Priority = 'Media';
        caso.AccountId= acc.id;
        caso.Rut_del_Cliente__c = '11111111-1';
        insert caso;
        
        Product2 p1 = new Product2();
        p1.IsActive = true;
        p1.ProductCode = PRODUCT_CODE;
        p1.Name = 'Crédito de Consumo';
        p1.codigo_producto_sales__c= DOS;
        p1.Codigo_Macroproducto_Operacional_sales__c=UNO;
        p1.tipo_producto_sales__c = TIPO_PRODUCTO;
        p1.Family = 'CREDITO DE CONSUMO';
        
        insert p1;
        
        Product2 p2 = new Product2();
        p2.IsActive = true;
        p2.ProductCode = PRODUCT_CODE;
        p2.Name = PRODUCT_NAME;
        p2.codigo_producto_sales__c= DOS;
        p2.Codigo_Macroproducto_Operacional_sales__c=UNO;
        p2.tipo_producto_sales__c = TIPO_PRODUCTO;
        p2.Family = 'Plan Plus';
        
        insert p2;
        
        Product2 p3 = new Product2();
        p3.IsActive = true;
        p3.ProductCode = PRODUCT_CODE;
        p3.Name = 'Crédito Hipotecario';
        p3.codigo_producto_sales__c= DOS;
        p3.Codigo_Macroproducto_Operacional_sales__c=UNO;
        p3.tipo_producto_sales__c = TIPO_PRODUCTO;
        p3.Family = 'CREDITO HIPOTECARIO';
        
        insert p3;
        
        Id idProd2 = Test.getStandardPricebookId();
        
        PricebookEntry pbe1 = new PricebookEntry();
        pbe1.Pricebook2Id = idProd2;
        pbe1.Product2Id = p1.Id;
        pbe1.UnitPrice = 1;
        pbe1.IsActive = true;
        insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry();
        pbe2.Pricebook2Id = idProd2;
        pbe2.Product2Id = p2.Id;
        pbe2.UnitPrice = 1;
        pbe2.IsActive = true;
        insert pbe2;
        
        PricebookEntry pbe3 = new PricebookEntry();
        pbe3.Pricebook2Id = idProd2;
        pbe3.Product2Id = p3.Id;
        pbe3.UnitPrice = 1;
        pbe3.IsActive = true;
        insert pbe3;
        
        Opportunity newOpp = new Opportunity();
        newOpp.StageName = 'Contacto';
        newOpp.Sol_Firmada_PF__c = true;
        newOpp.tipo_de_gestion_portabilidad__c= 'Contactado';
        newOpp.CloseDate = Date.TODAY().addMonths(1);
        newOpp.AccountId = acc.Id;
        newOpp.Name = OPP_NAME;
        newOpp.tipo_contrato_sales__c = 'Dependiente';
        newOpp.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName =:'RT_Portabilidad_financiera' LIMIT 1].Id;
        newOpp.OwnerId = UserInfo.getUserId();        
        insert newOpp;
		System.test.stopTest();

    }
}