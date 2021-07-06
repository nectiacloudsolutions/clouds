/*********************************************************************************************************
@Author       cagonzle@everis.com
@name         PFCalloutMock
@CreateDate   19/11/2020
@Description  Mock for PF Callout
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
19/11/2020                    cagonzle@everis.com                Initial Version 
**********************************************************************************************************/
@isTest
public class PFCalloutMock implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String bodyAsString;
    protected Blob bodyAsBlob;
    protected Map<String, String> responseHeaders;
    
    public PFCalloutMock(Integer code, String status, String body,
                         Map<String, String> responseHeaders) {
                             this.code = code;
                             this.status = status;
                             this.bodyAsString = body;
                             this.bodyAsBlob = null;
                             this.responseHeaders = responseHeaders;
                         }
    
    
    public HTTPResponse respond(HTTPRequest req) {
        System.debug('PFCalloutMock->'+req);
        bodyAsString = getBody((String) req.getEndpoint()); 
        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(code);
        resp.setStatus(status);
        resp.setBody(bodyAsString);
        
        if (responseHeaders != null) {
            for (String key : responseHeaders.keySet()) {
                resp.setHeader(key, responseHeaders.get(key));
            }
        }
        return resp;
    }
    
    private String getBody(String endPoint){
        if(endPoint.contains('portabilidad/segmento')){
            return '{"codigo":"1","mensaje":"OK", "respuesta" : {"hipotecario":true,"hipotecarioConCNS":false,"segmentacionCliente":"texto"}}';
        } else if(endPoint.contains('/Summary')){
            System.debug('contiene Summary');
            return '{"Data":{"PageDetail":{"TotalRecords":4,"CurrentPage":1,"TotalPages":1},"Mails":[{"Id":"W5E11ade471810924027bcee9dd6118eef0401","RuleId":0,"Subject":"Rechazo solicitud portabilidad","From":"consorio.informa@consorcio.cl","To":"mauricio.beltran.cl@gmail.com","UrlEmlOriginal":"https://out.filebunker.com/I1011/5fff4c593d7ac0001331aa7f/ra3dkhafdlejbs9qgoyu360vpmrrag4ci20we900hcv4u9whougeuk6qkhro67me3cqrgcj2b4k2ka9vfi0zr6g0ym92wn0sxc3w","UrlEmlProced":"https://out.filebunker.com/I1014/5fff4c614eb0600012497ee3/1t77zke3uhx1ar808k7c875pqfpqbktwnnr75n677yn55d0pl1uk74njv6drseumkwxusodm04e5vghrtxaw8ph0nvm9nsb69lyj","ReceptionDate":"2021-01-13T19:39:14.087","SendDate":"2021-01-13T19:39:06.523","Status":"250"},{"Id":"W5E164f0a339b1d34322b1ac75ced0fcc6a201","RuleId":0,"Subject":"Rechazo solicitud portabilidad","From":"consorio.informa@consorcio.cl","To":"mauricio.beltran.cl@gmail.com","UrlEmlOriginal":"https://out.filebunker.com/I1013/5fff4ba0ce972700103ae1c7/f7vnzpsgwm6bpsgbxzqumrc2vkfwdzcfmf0hiuu3pvgiqdducom3fpa8hbwestzaf690xcw1smvuyv6zxese9hzkz0k9es7vis4v","UrlEmlProced":"https://out.filebunker.com/I1013/5fff4bb40500ff00120c3071/9pu4aykitc9a0vzh6kegligvh5n0z4t3yms2pwdoecwrdx5z8tjm5tj7w9ktyl2890a1vo7fpdlk8n3ah7in4zctl50ezy4eg7sm","ReceptionDate":"2021-01-13T19:36:21.51","SendDate":"2021-01-13T19:36:01.007","Status":"250"},{"Id":"W5E02183ecd31ede456196ba8e44071871f901","RuleId":0,"Subject":"Comprobante de recepción de portabilidad N° Caso","From":"consorio.informa@consorcio.cl","To":"mauricio.beltran.cl@gmail.com","UrlEmlOriginal":"https://out.filebunker.com/I1011/5ffdfb814e32fc0012035044/ebccykom5wh9yelykbuu5u1ntv4oljnzfvedd8sx18an41qqsq5lygw1c19zpb4pi7olg529azd2srpfl47lj7jlh7700p2rjyb4","UrlEmlProced":"https://out.filebunker.com/I1012/5ffdfb963d7ac00013312587/z3eulrqryk5ymqpe33fa3yqcjg3eqdv6mcwkuwhkdm0ihk571p8c3fhrmufhu254lkmniq5fd5i1n3co708w7lhpf2fj1tty0x0p","ReceptionDate":"2021-01-12T19:42:14.69","SendDate":"2021-01-12T19:41:53.313","Status":"250"},{"Id":"W5D2edba2f7f461e439f86843d1236b51a8102","RuleId":0,"Subject":"Asunto del correo envío 3","From":"consorcio.informa@consorcio.cl","To":"mauricio.beltran.cl@gmail.com","UrlEmlOriginal":"https://out.filebunker.com/I1013/5feb3fdd8d15190012bf6905/swivdm3az87ak5343uga58n1trrx7f98dyr6p5p53wb9n5aifx6p8qe8apmaiymi3v5qt8sz85qnq9pxsk29ictxy9ngmnkgms0a","UrlEmlProced":"https://out.filebunker.com/I1014/5feb3fe23e6f73001081e963/iu4rxcowvjykgndo2eqjolt4tb64roeoqcosul6doqe4uztrmjjajmyy68ysjtucp2cd89sear1fndin6r43496fmhg5uaj0ddgx","ReceptionDate":"2020-12-29T14:40:34.283","SendDate":"2020-12-29T14:40:29.5","Status":"250"}]},"Service":"UniqueMail","Version":"1.1.0.0","TransactionId":"INSTANCIA 01_20210115_f04be0eb02a94278a65f54ffe5ba7a01","Status":{"Code":"200","Value":"OK"}}';
        } else if(endPoint.contains('/Statistics')){
            System.debug('contiene Summary');
            return '{"Data":{"PageDetail":{"TotalRecords":"4","CurrentPage":"1","TotalPages":"4","RequestDate":"2021-01-15T15:37:07.540"},"Summary":{"Sents":"1","Opens":"0","Clicks":"0","Retries":"1","Accepteds":"1","AcceptedsRate":"100.0000","TACs":"0.0000","PCTRs":"0.0000","CTRs":"0.0000","PCTOs":"0.0000","CTOs":"0.0000"},"Mails":[{"MailId":"W5E11ade471810924027bcee9dd6118eef0401","Retry":"1","Sents":"1","Opens":"0","Clicks":"0","Accepteds":"1","AcceptedRate":"100.0000","TAC":"0.0000","PCTR":"0.0000","CTR":"0.0000","PCTO":"0.0000","CTO":"0.0000","Click":null}]},"Service":"UniqueMail","Version":"1.1.0.0","TransactionId":"INSTANCIA 02_20210115_6e96179b82824b94afa9bafc5fbec1bd","Status":{"Code":"200","Value":"OK"}}';
        }
        return bodyAsString;
    }
}