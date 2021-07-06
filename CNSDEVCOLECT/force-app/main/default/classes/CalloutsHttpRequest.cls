/**
 * @description       : 
 * @author            : ggonzroj@everis.com
 * @group             : 
 * @last modified on  : 10-26-2020
 * @last modified by  : ggonzroj@everis.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   10-19-2020   ggonzroj@everis.com   Initial Version
**/
public without sharing class CalloutsHttpRequest {
    private String endpoint;
	private String httpMethod;
	private Map<String, String> queryParameters;
	private Map<String, String> headers;
	private String body;
    
    public CalloutsHttpRequest(String endpoint, String httpMethod, Map<String, String> queryParameters, Map<String, String> headers, String body){
		this.endpoint = endpoint;
		this.httpMethod = httpMethod;
		this.queryParameters = queryParameters;
		this.headers = headers;
		this.body = body;
	}

	public HttpResponse sendRequest(){
		HttpRequest request = new HttpRequest();
		request.setTimeout(120000);
		if (this.queryParameters != null){
			List<String> queryParameterKeys = new List<String>(this.queryParameters.keySet());
			for (Integer i = 0; i < queryParameterKeys.size(); i++){
				if (i == 0){
					this.endpoint += '?' + queryParameterKeys[i] + '=' + this.queryParameters.get(queryParameterKeys[i]);
				} else{
					this.endpoint += '&' + queryParameterKeys[i] + '=' + this.queryParameters.get(queryParameterKeys[i]);
				}
			}
		}
		request.setEndpoint(this.endpoint);
		request.setMethod(this.httpMethod);
		if (this.headers != null){
			for (String headerKey : this.headers.keySet()){
				request.setHeader(headerKey, this.headers.get(headerKey));
			}
		}
		if (this.body != null){
			request.setBody(this.body);
		}
		Http http = new Http();

		if (!Test.isRunningTest()) {
			return http.send(request);
		} else {
			return new HttpResponse();
		}
		
	}
}