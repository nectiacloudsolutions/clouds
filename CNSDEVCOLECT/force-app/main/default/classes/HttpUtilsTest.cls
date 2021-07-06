@isTest
public class HttpUtilsTest {
    
    private static final String DUMMY_URL = 'https://url';
    private static final String DUMMY_STATUS = 'status';
    private static final String DUMMY_BODY = 'body';
    private static final String DUMMY_CREDENTIAL = 'credential';
    private static final String DUMMY_HEADER_KEY = 'headerKey';
    private static final String DUMMY_HEADER_VALUE = 'headerValue';
    private static final String ASSERT_ERROR_INVALID_KEY = 'Invalid key-value set on HttpRequestHeader';

    @isTest
    static void shouldReturnResponseMessageOnGetMethodServiceCall() {
        HttpUtils utils = new HttpUtils(DUMMY_URL, DUMMY_BODY);
        Test.setMock(HttpCalloutMock.class, getMockEndpointOk(DUMMY_BODY));
        HttpResponse response = utils.sendGetRequest();
        System.assertEquals(DUMMY_BODY, response.getBody());
    }

    @isTest
    static void shouldReturnResponseMessageOnPostMethodServiceCall() {
        HttpUtils utils = new HttpUtils(DUMMY_URL, DUMMY_BODY);
        Test.setMock(HttpCalloutMock.class, getMockEndpointOk(DUMMY_BODY));
        HttpResponse response = utils.sendPostRequest();
        System.assertEquals(DUMMY_BODY, response.getBody());
    }

    @isTest
    static void shouldReturnResponseMessageOnPutMethodServiceCall() {
        HttpUtils utils = new HttpUtils(DUMMY_URL, DUMMY_BODY);
        Test.setMock(HttpCalloutMock.class, getMockEndpointOk(DUMMY_BODY));
        HttpResponse response = utils.sendPutRequest();
        System.assertEquals(DUMMY_BODY, response.getBody());
    }

    @isTest
    static void shouldInsertApplicationJsonAcceptHeaderOnHttpRequest() {
        HttpUtils utils = new HttpUtils(DUMMY_URL, DUMMY_BODY);
        utils.setApplicationJsonAcceptHeader();
        System.assert(checkIfKeyExistsOnRequest(HttpUtils.HEADER_KEY_ACCEPT, HttpUtils.HEADER_VALUE_APPLICATION_JSON, utils), ASSERT_ERROR_INVALID_KEY);
    }

    @isTest
    static void shouldInsertApplicationJsonContentTypeHeaderOnHttpRequest() {
        HttpUtils utils = new HttpUtils(DUMMY_URL, DUMMY_BODY);
        utils.setApplicationJsonContentTypeHeader();
        System.assert(checkIfKeyExistsOnRequest(HttpUtils.HEADER_KEY_CONTENT_TYPE, HttpUtils.HEADER_VALUE_APPLICATION_JSON, utils), ASSERT_ERROR_INVALID_KEY);
    }

    @isTest
    static void shouldInsertFormUrlEncodedContentTypeHeaderOnHttpRequest() {
        HttpUtils utils = new HttpUtils(DUMMY_URL, DUMMY_BODY);
        utils.setFormUrlEncodedContentTypeHeader();
        System.assert(checkIfKeyExistsOnRequest(HttpUtils.HEADER_KEY_CONTENT_TYPE, HttpUtils.HEADER_VALUE_FORM_URLENCODED, utils), ASSERT_ERROR_INVALID_KEY);
    }

    @isTest
    static void shouldInsertTextXmlContentTypeHeaderOnHttpRequest() {
        HttpUtils utils = new HttpUtils(DUMMY_URL, DUMMY_BODY);
        utils.setTextXmlContentTypeHeader();
        System.assert(checkIfKeyExistsOnRequest(HttpUtils.HEADER_KEY_CONTENT_TYPE, HttpUtils.HEADER_VALUE_TEXT_XML, utils), ASSERT_ERROR_INVALID_KEY);
    }

    @isTest
    static void shouldInsertBasicAuthenticationHeaderOnHttpRequest() {
        HttpUtils utils = new HttpUtils(DUMMY_URL, DUMMY_BODY);
        utils.setBasicAuthenticationHeader(DUMMY_CREDENTIAL);
        System.assert(checkIfKeyExistsOnRequest(HttpUtils.HEADER_KEY_AUTHORIZATION, HttpUtils.HEADER_VALUE_BASIC_AUTH + DUMMY_CREDENTIAL, utils), ASSERT_ERROR_INVALID_KEY);
    }

    @isTest
    static void shouldInsertBearerTokenAuthenticationHeaderOnHttpRequest() {
        HttpUtils utils = new HttpUtils(DUMMY_URL, DUMMY_BODY);
        utils.setBearerTokenAuthenticationHeader(DUMMY_CREDENTIAL);
        System.assert(checkIfKeyExistsOnRequest(HttpUtils.HEADER_KEY_AUTHORIZATION, HttpUtils.HEADER_VALUE_BEARER_TOKEN_AUTH + DUMMY_CREDENTIAL, utils), ASSERT_ERROR_INVALID_KEY);
    }

    @isTest
    static void shouldInsertAnyHeaderOnHttpRequest() {
        HttpUtils utils = new HttpUtils(DUMMY_URL, DUMMY_BODY);
        utils.setHeader(DUMMY_HEADER_KEY, DUMMY_HEADER_VALUE);
        System.assert(checkIfKeyExistsOnRequest(DUMMY_HEADER_KEY, DUMMY_HEADER_VALUE, utils), ASSERT_ERROR_INVALID_KEY);
    }
    
    private static HttpResponseMock getMockEndpointOk(String body) {
        return new HttpResponseMock(HttpUtils.HTTP_OK, DUMMY_STATUS, body, null);
    }

    private static Boolean checkIfKeyExistsOnRequest(String key, string value, HttpUtils utils) {
        return utils.request.getHeader(key) == value;
    }
}