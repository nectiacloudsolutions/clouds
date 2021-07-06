/*********************************************************************************************************
@Author       eayalcor@everis.com
@name         SalesCalloutMock
@CreateDate   08/10/2019
@Description  Mock for SalesCallout
***********************************************************************************************************
History of changes: 
-----------------------------------------------------------------------------------------------------------
Date                               Developer                         Comments   
-----------------------------------------------------------------------------------------------------------
08/10/2019                    eayalcor@everis.com                Initial Version 
**********************************************************************************************************/
@isTest
public class SalesCalloutMock implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String bodyAsString;
    protected Blob bodyAsBlob;
    protected Map<String, String> responseHeaders;
    
    public SalesCalloutMock(Integer code, String status, String body,
                            Map<String, String> responseHeaders) {
                                this.code = code;
                                this.status = status;
                                this.bodyAsString = body;
                                this.bodyAsBlob = null;
                                this.responseHeaders = responseHeaders;
                            }
    
    
    public HTTPResponse respond(HTTPRequest req) {
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
}