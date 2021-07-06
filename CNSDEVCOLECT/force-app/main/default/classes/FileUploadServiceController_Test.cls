@isTest
public with sharing class FileUploadServiceController_Test {
/**
 * @description       : 
 * @author            : pcelisbe@everis.com
 * @group             : 
 * @last modified on  : 08-12-2020
 * @last modified by  : pcelisbe@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   08-12-2020   pcelisbe@everis.com   Initial Version
**/

@testSetup
    private static void testDataCreate() {
		List<RecordType> lstRecord=[select Id,DeveloperName,SobjectType from RecordType where SobjectType ='Case'];
        System.debug(lstRecord);
        Map<String,SObject> mpsObjects = TestFactorySales.populateOrg();
        Case cass=(Case)mpsObjects.get('Case1');

    }
    /**
    * @description 
    * @author pcelisbe@everis.com | 08-12-2020 
    **/
@isTest
    public static void testSaveChunk(){
		List<Case> lstcase=[SELECT id FROM Case LIMIT 1];
        String fileName = 'Test Attachment';
		String filebody ='Hi this is the test Attachment to Upload';
		Blob beforeblob = Blob.valueOf(filebody);
		string paramvalue = EncodingUtil.base64Encode(beforeblob);
		String contentType ='text/plain';
		String fileId = '';
        
        Id attachmentCreatedFileId = FileUploadServiceController.saveChunk(lstcase[0].Id,fileName,paramvalue,contentType,fileId);
        FileUploadServiceController.saveChunk(lstcase[0].Id,fileName,paramvalue,contentType,attachmentCreatedFileId);
        
		List<Attachment> attachments=[select id, name from Attachment where parent.id=:lstcase[0].Id];
		System.assertEquals(1, attachments.size());

    }

    @isTest
    public static void testCallDocumentManager(){
		List<Account> lstAccount = [SELECT Id FROM Account WHERE Rut__C=: '19375874-6'];
        lstAccount[0].Cliente_Banco__c = true;
        lstAccount[0].Cliente_Seguros__c = false;
        update lstAccount;
        List<Case> lstCase=[SELECT Id,id_alfresco_caso_sales__c FROM Case LIMIT 1];
        String base64Data='fdsgerhreher45fgdfsg';
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = lstcase[0].Id;
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name ='Archivo_TEST';
        oAttachment.ContentType ='application/pdf';
        insert oAttachment;
        Test.startTest();
        FileUploadServiceController.callDocumentManager(lstcase[0].Id,oAttachment.Id);
        Integer callouts = Limits.getCallouts();
        Test.stopTest();
        
         Integer Attach=[SELECT count()  FROM Attachment WHERE parentId=:lstcase[0].Id];

        system.assertEquals(0, Attach);
    }
    
    @isTest
    public static void testCallDocumentManager02(){

        List<Case> lstCase=[SELECT Id,id_alfresco_caso_sales__c FROM Case LIMIT 1];
        String base64Data='fdsgerhreher45fgdfsg';
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = lstcase[0].Id;
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name ='Archivo_TEST';
        oAttachment.ContentType ='application/pdf';
        insert oAttachment;
        Test.startTest();
        FileUploadServiceController.callDocumentManager(lstcase[0].Id,oAttachment.Id);
        Integer callouts = Limits.getCallouts();
        Test.stopTest();
        
         Integer Attach=[SELECT count()  FROM Attachment WHERE parentId=:lstcase[0].Id];

        system.assertEquals(0, Attach);
    }
    
    @isTest
    static void validateManagerTest(){
        List<User> lstUser = [SELECT Id,ManagerId FROM User WHERE Rut__c = '19' LIMIT 1];
        System.runAs(lstUser[0]){
            Boolean res = FileUploadServiceController.validateManagerId();
            system.assertEquals(false, res);
        }
    }
}