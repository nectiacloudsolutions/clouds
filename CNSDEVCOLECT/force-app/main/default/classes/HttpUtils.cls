public class HttpUtils {

	@testVisible private HttpRequest request;
	private HttpResponse response;

	public static final String METHOD_GET = 'GET';
	public static final String METHOD_POST = 'POST';
	public static final String METHOD_PUT = 'PUT';

	public static final Integer HTTP_OK = 200;
	public static final Integer HTTP_CREATED = 201;
	public static final Integer HTTP_ACCEPTED = 202;
	public static final Integer HTTP_UPDATED = 204;
	public static final Integer HTTP_BAD_REQUEST = 400;
	public static final Integer HTTP_UNAUTHORIZED = 401;
	public static final Integer HTTP_FORBIDDEN = 403;
	public static final Integer HTTP_NOT_FOUND = 404;
	public static final Integer HTTP_CONFLICT = 409;
	public static final Integer HTTP_SERVER_ERROR = 500;
	public static final Integer HTTP_BAD_GATEWAY = 502;
	public static final Integer HTTP_SERVICE_UNAVAILABLE = 503;
	public static final Integer HTTP_GATEWAY_TIMEOUT = 504;

	public static final String HEADER_KEY_CONTENT_TYPE = 'content-type';
	public static final String HEADER_KEY_AUTHORIZATION = 'authorization';
	public static final String HEADER_KEY_ACCEPT = 'accept';
	public static final String HEADER_KEY_X_INTROSPECT_BASIC_AUTHORIZATION_HEADER = 'x-introspect-basic-authorization-header';

	public static final String HEADER_VALUE_APPLICATION_JSON = 'application/json';
	public static final String HEADER_VALUE_FORM_URLENCODED = 'application/x-www-form-urlencoded';
	public static final String HEADER_VALUE_TEXT_XML = 'text/xml';
	public static final String HEADER_VALUE_BASIC_AUTH = 'Basic ';
	public static final String HEADER_VALUE_BEARER_TOKEN_AUTH = 'Bearer ';

	private static final Integer MAX_TIMEOUT_IN_MSEC = 120000;

	public HttpUtils(String url, String body) {
		this.request = new HttpRequest();
		this.setBaseRequest(url, body);
	}

	private void setBaseRequest(String url, String body) {
		this.request.setTimeout(MAX_TIMEOUT_IN_MSEC);
		this.request.setEndpoint(url);
		this.request.setBody(body);
	}

	public void setHeader(String key, String value) {
		this.request.setHeader(key, value);
	}

	public void setApplicationJsonContentTypeHeader() {
		this.setHeader(HEADER_KEY_CONTENT_TYPE, HEADER_VALUE_APPLICATION_JSON);
	}

	public void setFormUrlEncodedContentTypeHeader() {
		this.setHeader(HEADER_KEY_CONTENT_TYPE, HEADER_VALUE_FORM_URLENCODED);
	}

	public void setTextXmlContentTypeHeader() {
		this.setHeader(HEADER_KEY_CONTENT_TYPE, HEADER_VALUE_TEXT_XML);
	}

	public void setApplicationJsonAcceptHeader() {
		this.setHeader(HEADER_KEY_ACCEPT, HEADER_VALUE_APPLICATION_JSON);
	}

	public void setBasicAuthenticationHeader(String credential) {
		this.setHeader(HEADER_KEY_AUTHORIZATION, HEADER_VALUE_BASIC_AUTH + credential);
	}

	public void setBearerTokenAuthenticationHeader(String credential) {
		this.setHeader(HEADER_KEY_AUTHORIZATION, HEADER_VALUE_BEARER_TOKEN_AUTH + credential);
    }
    
	private HttpResponse sendRequest() {
        Http httpHandler = new Http();
        return httpHandler.send(this.request);
	}

	public HttpResponse sendGetRequest() {
		this.request.setMethod(METHOD_GET);
		return sendRequest();
	}

	public HttpResponse sendPostRequest() {
		this.request.setMethod(METHOD_POST);
		return sendRequest();
	}

	public HttpResponse sendPutRequest() {
		this.request.setMethod(METHOD_PUT);
		return sendRequest();
	}
}