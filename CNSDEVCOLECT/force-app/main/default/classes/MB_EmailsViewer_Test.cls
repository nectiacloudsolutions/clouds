/**
 * @description       : 
 * @author            : mbeltran@everis.com
 * @group             : 
 * @last modified on  : 01-15-2021
 * @last modified by  : mbeltran@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   01-07-2021   mbeltran@everis.com   Initial Version
**/
@isTest
public class MB_EmailsViewer_Test {
 
    @isTest static void testObtenerDatosparaComponente(){

        Account cuenta = new Account();
        cuenta.RUT__c = '1-9';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        cuenta.FirstName='Juan';
        cuenta.LastName = 'Perez';
        cuenta.phone = '1333333222';
        cuenta.PersonEmail = 'test@test.cl';
        insert cuenta;

                //Create a new Opportunity
        Opportunity opp01 = new Opportunity();
        opp01.AccountId = cuenta.Id;
        opp01.Name = 'Test';
        opp01.StageName = 'Contacto';
        opp01.CloseDate = Date.today();
        opp01.PF_Correo_Electronico_Digital__c = 'consorio.informa@consorcio.cl';
        insert opp01;

        MB_EmailsViewer.ParameterLWC parameterLWC = new MB_EmailsViewer.ParameterLWC();
        parameterLWC.fieldApiName = 'PF_Correo_Electronico_Digital__c';
        parameterLWC.objectApiName = 'Opportunity';
        parameterLWC.recordId = opp01.Id;
        parameterLWC.subjectTextFilter = 'Portabilidad Financiera - Información importante sobre tu Solicitud de Portabilidad;Comprobante de recepción de portabilidad N° Caso;Rechazo solicitud portabilidad;Presentación ejecutivo - Portabilidad Financiera Banco Consorcio';

        Test.startTest();
        String jsonSummary = '{"Data":{"PageDetail":{"TotalRecords":4,"CurrentPage":1,"TotalPages":1},"Mails":[{"Id":"W5E11ade471810924027bcee9dd6118eef0401","RuleId":0,"Subject":"Rechazo solicitud portabilidad","From":"consorio.informa@consorcio.cl","To":"mauricio.beltran.cl@gmail.com","UrlEmlOriginal":"https://out.filebunker.com/I1011/5fff4c593d7ac0001331aa7f/ra3dkhafdlejbs9qgoyu360vpmrrag4ci20we900hcv4u9whougeuk6qkhro67me3cqrgcj2b4k2ka9vfi0zr6g0ym92wn0sxc3w","UrlEmlProced":"https://out.filebunker.com/I1014/5fff4c614eb0600012497ee3/1t77zke3uhx1ar808k7c875pqfpqbktwnnr75n677yn55d0pl1uk74njv6drseumkwxusodm04e5vghrtxaw8ph0nvm9nsb69lyj","ReceptionDate":"2021-01-13T19:39:14.087","SendDate":"2021-01-13T19:39:06.523","Status":"250"},{"Id":"W5E164f0a339b1d34322b1ac75ced0fcc6a201","RuleId":0,"Subject":"Rechazo solicitud portabilidad","From":"consorio.informa@consorcio.cl","To":"mauricio.beltran.cl@gmail.com","UrlEmlOriginal":"https://out.filebunker.com/I1013/5fff4ba0ce972700103ae1c7/f7vnzpsgwm6bpsgbxzqumrc2vkfwdzcfmf0hiuu3pvgiqdducom3fpa8hbwestzaf690xcw1smvuyv6zxese9hzkz0k9es7vis4v","UrlEmlProced":"https://out.filebunker.com/I1013/5fff4bb40500ff00120c3071/9pu4aykitc9a0vzh6kegligvh5n0z4t3yms2pwdoecwrdx5z8tjm5tj7w9ktyl2890a1vo7fpdlk8n3ah7in4zctl50ezy4eg7sm","ReceptionDate":"2021-01-13T19:36:21.51","SendDate":"2021-01-13T19:36:01.007","Status":"250"},{"Id":"W5E02183ecd31ede456196ba8e44071871f901","RuleId":0,"Subject":"Comprobante de recepción de portabilidad N° Caso","From":"consorio.informa@consorcio.cl","To":"mauricio.beltran.cl@gmail.com","UrlEmlOriginal":"https://out.filebunker.com/I1011/5ffdfb814e32fc0012035044/ebccykom5wh9yelykbuu5u1ntv4oljnzfvedd8sx18an41qqsq5lygw1c19zpb4pi7olg529azd2srpfl47lj7jlh7700p2rjyb4","UrlEmlProced":"https://out.filebunker.com/I1012/5ffdfb963d7ac00013312587/z3eulrqryk5ymqpe33fa3yqcjg3eqdv6mcwkuwhkdm0ihk571p8c3fhrmufhu254lkmniq5fd5i1n3co708w7lhpf2fj1tty0x0p","ReceptionDate":"2021-01-12T19:42:14.69","SendDate":"2021-01-12T19:41:53.313","Status":"250"},{"Id":"W5D2edba2f7f461e439f86843d1236b51a8102","RuleId":0,"Subject":"Asunto del correo envío 3","From":"consorcio.informa@consorcio.cl","To":"mauricio.beltran.cl@gmail.com","UrlEmlOriginal":"https://out.filebunker.com/I1013/5feb3fdd8d15190012bf6905/swivdm3az87ak5343uga58n1trrx7f98dyr6p5p53wb9n5aifx6p8qe8apmaiymi3v5qt8sz85qnq9pxsk29ictxy9ngmnkgms0a","UrlEmlProced":"https://out.filebunker.com/I1014/5feb3fe23e6f73001081e963/iu4rxcowvjykgndo2eqjolt4tb64roeoqcosul6doqe4uztrmjjajmyy68ysjtucp2cd89sear1fndin6r43496fmhg5uaj0ddgx","ReceptionDate":"2020-12-29T14:40:34.283","SendDate":"2020-12-29T14:40:29.5","Status":"250"}]},"Service":"UniqueMail","Version":"1.1.0.0","TransactionId":"INSTANCIA 01_20210115_f04be0eb02a94278a65f54ffe5ba7a01","Status":{"Code":"200","Value":"OK"}}';
        PFCalloutMock fakeResponse = new PFCalloutMock(200, 'ok', jsonSummary, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

        String jsonStatistics = '{"Data":{"PageDetail":{"TotalRecords":"4","CurrentPage":"1","TotalPages":"4","RequestDate":"2021-01-15T15:37:07.540"},"Summary":{"Sents":"1","Opens":"0","Clicks":"0","Retries":"1","Accepteds":"1","AcceptedsRate":"100.0000","TACs":"0.0000","PCTRs":"0.0000","CTRs":"0.0000","PCTOs":"0.0000","CTOs":"0.0000"},"Mails":[{"MailId":"W5E11ade471810924027bcee9dd6118eef0401","Retry":"1","Sents":"1","Opens":"0","Clicks":"0","Accepteds":"1","AcceptedRate":"100.0000","TAC":"0.0000","PCTR":"0.0000","CTR":"0.0000","PCTO":"0.0000","CTO":"0.0000","Click":null}]},"Service":"UniqueMail","Version":"1.1.0.0","TransactionId":"INSTANCIA 02_20210115_6e96179b82824b94afa9bafc5fbec1bd","Status":{"Code":"200","Value":"OK"}}';
        fakeResponse = new PFCalloutMock(200, 'ok', jsonStatistics, null);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

        list<MB_EmailsViewer.EmailViewerRecord> lstRecords = MB_EmailsViewer.getEmailsList(parameterLWC); 

        MB_EmailsStatistics_JSON wrapperStatistics = new MB_EmailsStatistics_JSON();
        wrapperStatistics = (MB_EmailsStatistics_JSON)JSON.deserialize(jsonStatistics, MB_EmailsStatistics_JSON.class); 

        String version = wrapperStatistics.Version;
        String service = wrapperStatistics.Service;
        String transactionId= wrapperStatistics.TransactionId; 

        MB_EmailsStatistics_JSON.Status status = wrapperStatistics.Status;
        status.Code = wrapperStatistics.Status.Code;
        status.Value = wrapperStatistics.Status.Value;

        MB_EmailsStatistics_JSON.PageDetail pageDetail =  wrapperStatistics.Data.PageDetail;
        pageDetail.CurrentPage = pageDetail.CurrentPage;
        pageDetail.TotalPages = pageDetail.TotalPages;
        pageDetail.TotalRecords = pageDetail.TotalRecords;

        MB_EmailsSummary_JSON wrapperSummary = new MB_EmailsSummary_JSON();
        wrapperSummary = (MB_EmailsSummary_JSON)JSON.deserialize(jsonSummary, MB_EmailsSummary_JSON.class); 

        version = wrapperSummary.Version;
        service = wrapperSummary.Service;
        transactionId = wrapperSummary.TransactionId; 

        MB_EmailsSummary_JSON.Status statusSummary = wrapperSummary.Status;
        statusSummary.Code = wrapperSummary.Status.Code;
        statusSummary.Value = wrapperSummary.Status.Value;

        MB_EmailsSummary_JSON.PageDetail pageDetailSummary = wrapperSummary.Data.PageDetail;
        pageDetailSummary.CurrentPage = wrapperSummary.Data.PageDetail.CurrentPage;
        pageDetailSummary.TotalPages = wrapperSummary.Data.PageDetail.TotalPages;
        pageDetailSummary.TotalRecords = wrapperSummary.Data.PageDetail.TotalRecords;



        Test.stopTest();


        //list<MB_EmailsViewer.EmailViewerRecord> test =  createEmailViewerFromMasterbaseResponses(MB_EmailsSummary_JSON mb_EmailsSummary_JSON, MB_EmailsStatistics_JSON mb_EmailsStatistics_JSON, String subjectTextFilter

    }

}