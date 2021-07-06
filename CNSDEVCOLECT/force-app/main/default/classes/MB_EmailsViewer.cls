/**
 * @description       : 
 * @author            : mbeltran@everis.com
 * @group             : 
 * @last modified on  : 01-19-2021
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   01-04-2021   mbeltran@everis.com   Initial Version
**/
public with sharing class MB_EmailsViewer {

    public class EmailViewerRecord {
        @AuraEnabled public String nombreComunicacion {get;set;} 
        @AuraEnabled public Date fechaEnvio {get;set;}
        @AuraEnabled public Integer enviado {get;set;}
        @AuraEnabled public Integer recibido {get;set;}
        @AuraEnabled public Integer leido {get;set;}
        @AuraEnabled public Integer reenvios {get;set;}
        @AuraEnabled public Integer clicks {get;set;}
        @AuraEnabled public String url {get;set;}
        @AuraEnabled public String FromMail {get;set;}
        @AuraEnabled public Datetime ReceptionDate {get;set;}
        @AuraEnabled public Integer RuleId {get;set;}
        @AuraEnabled public String Status {get;set;}
        @AuraEnabled public String To {get;set;}
    }
    public class ParameterLWC {
        @AuraEnabled public String objectApiName {get;set;}
        @AuraEnabled public String fieldApiName {get;set;}
        @AuraEnabled public String recordId {get;set;}
        @AuraEnabled public String subjectTextFilter {get;set;}
    }

    private static String mailTO { get; set;}
    private static Sales_Connect__mdt sc;
    private static String endpointMasterBase;
    
    /**
    * @description : Obteniene desde custom metadata type los datos de conección para consumir servicio masterbase
    * @author mbeltran@everis.com | 01-05-2021 
    **/
    @TestVisible
    private static void loadConfig(){

        if(String.isEmpty(endpointMasterBase)){
             sc = [SELECT password__c,URL_sales__c,username__c,user_pool_id__c,x_api_key__c,token__c,Callback_url__c,
                    client_id__c,Client_Secret__c,Codigo_App__c,Codigo_Canal__c,Empresa_App__c,Modalidad__c
                    FROM Sales_Connect__mdt WHERE DeveloperName= 'MASTERBASE' LIMIT 1];
            endpointMasterBase = sc.Callback_url__c + sc.Modalidad__c;        
        }        
    }
    @TestVisible
	private static String getToken(){
		Blob headerValue = Blob.valueOf(sc.username__c + ':' + sc.password__c);
		return 'Basic ' + EncodingUtil.base64Encode(headerValue);
    }
    
    @AuraEnabled(cacheable=true)
    public static list<EmailViewerRecord> getEmailsList(ParameterLWC parameterLWC) {

        loadConfig();
        getMailTOFromParameter(parameterLWC);

        MB_EmailsSummary_JSON mb_EmailsSummary_JSON = getMailTOSummaryMB();
        MB_EmailsStatistics_JSON mb_EmailsStatistics_JSON = getMailTOStatisticsMB();

        list<EmailViewerRecord> lst_emailsViewer = createEmailViewerFromMasterbaseResponses(mb_EmailsSummary_JSON, mb_EmailsStatistics_JSON, parameterLWC.subjectTextFilter);

        return lst_emailsViewer;
    }

    /**
    * @description : Obtiene dinamicamente el mail (con respecto a Objeto, campo y id) que servirá como parámetro en los servicios de masterbase
    * @author mbeltran@everis.com | 01-05-2021 
    * @param ParameterLWC parameterLWC 
    **/
    private static void getMailTOFromParameter(ParameterLWC parameterLWC){
        String qryString = 'SELECT id,' + parameterLWC.fieldApiName +' FROM ' + parameterLWC.objectApiName + ' WHERE id= \'' + parameterLWC.recordId + '\' Limit 1'; 
        SObject queryResult = Database.query(qryString);

        try{
            MailTO = (String)queryResult.get(parameterLWC.fieldApiName);
		} catch(Exception e){
			System.debug('Error Get Field: '+e.getMessage());
		}        
    }

    private static MB_EmailsSummary_JSON getMailTOSummaryMB(){
        
		String paramsUrl = '?To=' + mailTO + '&Order=1';

        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpointMasterBase + '/Summary' + paramsUrl);
		request.setMethod('GET');
		request.setHeader('Authorization', getToken());
        request.setHeader('Content-Type', 'application/json');

        HTTP http = new HTTP();
        HttpResponse response = new HttpResponse();
        String mensjExp = '';
        try {
            response = http.send(request);
        } catch(Exception e) { 
            System.debug('mensjExp:' + e.getMessage());
        }

        boolean respuesta = (response.getStatus() == 'OK' && response.getStatusCode() == 200);
		
		MB_EmailsSummary_JSON wrapper = new MB_EmailsSummary_JSON();
        if(respuesta){ 
            wrapper = (MB_EmailsSummary_JSON)JSON.deserialize(response.getBody(), MB_EmailsSummary_JSON.class);
        }
        System.debug('wrapperSumm:' + wrapper); 
        
        return wrapper;
    }
    private static MB_EmailsStatistics_JSON getMailTOStatisticsMB(){
        
		String paramsUrl = '?To=' + mailTO + '&Order=1';

        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpointMasterBase + '/Statistics' + paramsUrl);
		request.setMethod('GET');
		request.setHeader('Authorization', getToken());
        request.setHeader('Content-Type', 'application/json');

        HTTP http = new HTTP();
        HttpResponse response = new HttpResponse();
        String mensjExp = '';
        try {
            response = http.send(request);
        } catch(Exception e) { 
            System.debug('HttpRequest Error:' + e.getMessage()); 
        }

        boolean respuesta = (response.getStatus() == 'OK' && response.getStatusCode() == 200);
		MB_EmailsStatistics_JSON wrapper = new MB_EmailsStatistics_JSON();
        if(respuesta){ 
            wrapper = (MB_EmailsStatistics_JSON)JSON.deserialize(response.getBody(), MB_EmailsStatistics_JSON.class); 
        }

        System.debug('wrapperSta:' + wrapper); 

        return wrapper;
    }

    public static list<EmailViewerRecord> createEmailViewerFromMasterbaseResponses(MB_EmailsSummary_JSON mb_EmailsSummary_JSON, MB_EmailsStatistics_JSON mb_EmailsStatistics_JSON, String subjectTextFilter){

        list<EmailViewerRecord> emailViewerRecords = new list<EmailViewerRecord>();

        if(mb_EmailsSummary_JSON.Data == null) { return emailViewerRecords; }

        Map<String, String> mapSubjects = convertStringSubjectToMapSubjects(subjectTextFilter);
        Map<String, MB_EmailsStatistics_JSON.Mails> statisticsMap = new Map<String, MB_EmailsStatistics_JSON.Mails>();

        for(MB_EmailsStatistics_JSON.Mails statisticsRecord : mb_EmailsStatistics_JSON.Data.Mails)
        {
            StatisticsMap.put(statisticsRecord.MailId, statisticsRecord);
        }

        EmailViewerRecord emailViewerRecord;
        MB_EmailsStatistics_JSON.Mails emailsStatistics;

        for(MB_EmailsSummary_JSON.Mails summaryList : MB_EmailsSummary_JSON.Data.Mails){
            if(mapSubjects.size() == 0 || String.isNotBlank(mapSubjects.get(summaryList.Subject))){

                emailsStatistics = statisticsMap.get(summaryList.Id);
                emailViewerRecord = new EmailViewerRecord();
                emailViewerRecord.nombreComunicacion = summaryList.Subject;
                emailViewerRecord.fechaEnvio = summaryList.SendDate.date();
                emailViewerRecord.url = summaryList.UrlEmlProced;
                emailViewerRecord.FromMail = summaryList.FromMail;
                emailViewerRecord.ReceptionDate = summaryList.ReceptionDate;
                emailViewerRecord.RuleId = summaryList.RuleId;
                emailViewerRecord.Status = summaryList.Status;
                emailViewerRecord.To = summaryList.To;

                if(emailsStatistics != null){
                    emailViewerRecord.enviado = emailsStatistics.Sents;
                    emailViewerRecord.recibido =emailsStatistics.Accepteds;
                    emailViewerRecord.leido = emailsStatistics.Opens;
                    emailViewerRecord.reenvios = emailsStatistics.Retry;
                    emailViewerRecord.clicks = emailsStatistics.Clicks;
                }
                else {
                    emailViewerRecord.enviado = 0;
                    emailViewerRecord.recibido = 0;
                    emailViewerRecord.leido = 0;
                    emailViewerRecord.reenvios = 0;
                    emailViewerRecord.clicks = 0;
                }
                emailViewerRecords.add(emailViewerRecord);
            }
        }
        return emailViewerRecords;
    }
    public static Map<String, String> convertStringSubjectToMapSubjects(String subjectTextFilter){
        Map<String, String> mapSubjects = new Map<String, String>();
        if(String.isNotBlank(subjectTextFilter)){
            List<String> lstSubject = subjectTextFilter.split(';');
            for(String Subject :lstSubject){
                 if(String.isNotBlank(Subject)){
                     mapSubjects.put(Subject,Subject);
                 }
            }
        }
        return mapSubjects;
    }
}