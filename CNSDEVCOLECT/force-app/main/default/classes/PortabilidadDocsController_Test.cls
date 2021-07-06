/*********************************************************************************************************
@Author       lmunogar@everis.com
@name         OpportunityDocsControllerTest
@CreateDate   15/09/2020
@Description  Test class for PortabilidadDocsController
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date          Developer                     Comments   
-----------------------------------------------------------------------------------------------------------
15/09/2020    lmunogar@everis.com           
**********************************************************************************************************/
@isTest
public class PortabilidadDocsController_Test {

    @testSetup
    private static void setup() {
        Test.startTest();
        Account cuenta = new Account();
        cuenta.RUT__c = '9121329-k';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.FirstName='Juan';
        cuenta.LastName = 'Perez';
        cuenta.phone = '1333333222';
        cuenta.PersonEmail = 'test@test.cl';
        insert cuenta;
        
        Group grupo = new Group();
        grupo.DeveloperName = 'Port_Hipotecario';
		grupo.name = 'Port_Hipotecario';
		grupo.Type='Queue';
		insert grupo;
		System.runAs(new User(Id=UserInfo.getUserId()))
		{
			QueuesObject testQueue1 = new QueueSObject(QueueID = grupo.id, SObjectType = 'Case');
			insert testQueue1;
		}
        
        Case nCaso = new Case();
		nCaso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Caso_PF_Caso_de_Portabilidad').getRecordTypeId();
		nCaso.Caso_PF_Cliente_apto__c = true;
		nCaso.Sub_estado_Nectia__c = Label.PF_Creacion_Oportunidad;
        nCaso.Status = Label.PF_Pre_Portabilidad;
		nCaso.Causa_Origen__c = Label.PF_Causa_Origen;
        nCaso.AccountId = cuenta.Id;
		nCaso.ContactId = cuenta.PersonContactId;
		nCaso.Rut__c = cuenta.RUT__c;
        ncaso.Rut_del_Cliente__c = cuenta.RUT__c;
        nCaso.Caso_PF_Credito_Hipotecario__c = true;
        insert nCaso;
        
        ////////////////
        Opportunity opp = new Opportunity();
        opp.CloseDate=date.today();
        opp.AccountId = cuenta.id;
        opp.Name='test opp 1';
        opp.StageName='Contacto';
        opp.OwnerId= UserInfo.getUserId();
        opp.Caso_PF__c = nCaso.Id;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('RT_Portabilidad_financiera').getRecordTypeId();
    	insert opp;
        ////////////////
        Product2 p2 = new Product2();
        p2.IsActive = true;
        p2.ProductCode = '07100';
        p2.Name = 'Crédito de Consumo';
        p2.codigo_producto_sales__c= '0';
        p2.Codigo_Macroproducto_Operacional_sales__c='0';
        p2.tipo_producto_sales__c = 'sales_credito_consumo';
        p2.Family = Constants.PRODUCT_CONSUMO;

        insert p2;
        Id idProd2 = Test.getStandardPricebookId();
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = idProd2;
        pbe.Product2Id = p2.Id;
        pbe.UnitPrice = 1;
        pbe.IsActive = true;
        insert pbe;
        
        OpportunityLineItem itemTmp = new OpportunityLineItem();
        itemTmp.OpportunityId = opp.Id;
        itemTmp.PricebookEntryId = pbe.Id;
        itemTmp.Product2Id = p2.id ;
        itemTmp.Quantity = 1;
        itemTmp.UnitPrice = 1;
        insert itemTmp;
        //   

		List<sObject> ls = System.Test.loadData(DocumentosAlfresco__c.sObjectType, 'testDocumentosAlfresco');
        List<DocumentosAlfresco__c> lsn = (List<DocumentosAlfresco__c>)ls;
        update lsn;
        
//        DocumentosAlfresco__c DocAlfresco = (DocumentosAlfresco__c)lsn[0];
//        DocAlfresco.Escritura__c = 'NO';
//        update DocAlfresco;
        
        Date myDate = Date.today();
        Object_Related_Document__c objLog = new Object_Related_Document__c();
        objLog.Estado_Documento__c = 'Ingresado';
        objLog.Id_Alfresco__c = 'workspace://SpacesStore/c6ecea36-1070-4450-afc0-e02bb59a57fe';
        objLog.Fecha_Carga_Alfresco__c = myDate;
        objLog.Caso_Relacionado__c = nCaso.Id;
        objLog.Tipo_Documento__c = 'Solicitud Portabilidad';
        objLog.External_Id__c = nCaso.Id + '-' + 'Solicitud Portabilidad';
        insert objLog;
        
        Test.stopTest();

    }

    private static testMethod void testGetData() {
        PortabilidadDocsController.dataWrapper dw = new PortabilidadDocsController.dataWrapper(); 
        Test.startTest();
        
        List<Case> csList = [SELECT Id  FROM Case limit 1];
        dw = PortabilidadDocsController.getData(csList[0].id, 'Case', ''); //////////

        List<Opportunity> oppList = [SELECT Id  FROM Opportunity limit 1];/////////
        dw = PortabilidadDocsController.getData(oppList[0].id, 'Opportunity', null); //////////

        List<OpportunityLineItem> oliList = [SELECT Id  FROM OpportunityLineItem limit 1];/////////
        dw = PortabilidadDocsController.getData(oliList[0].id, 'OpportunityLineItem', 'Documento_Formalizacion'); //////////
        
        Test.stopTest();
    }
}