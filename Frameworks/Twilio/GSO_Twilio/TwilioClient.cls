public abstract class TwilioClient {

    private static final String VERSION = '4.0.0';
    private String endpoint = 'https://api.twilio.com';
    protected String accountSid;
    protected String authToken;
    private Integer numRetries = 3;
 
  
    public TwilioClient(String accountSid, String authToken) {
        this(accountSid, authToken, null);
    }

    public TwilioClient(String accountSid, String authToken, String endpoint) {

        validateAccountSid(accountSid);
        validateAuthToken(authToken);

        this.accountSid = accountSid;
        this.authToken = authToken;

        if ((endpoint != null) && (!endpoint.equals(''))) {
            this.endpoint = endpoint;
        }
    }
    
    public Integer getNumRetries() {
        return numRetries;
    }

    public void setNumRetries(Integer numRetries) {
        this.numRetries = numRetries;
    }

    private void validateAuthToken(String authToken) {
        if (authToken == null || authToken.length() != 32)
            throw new TwilioRestException('AuthToken \'' + authToken + '\' is not valid.');
    }

    private void validateAccountSid(String accountSid) {
        if (accountSid == null || !accountSid.startsWith('AC') || accountSid.length() != 34)
            throw new TwilioRestException('AccountSid \'' + accountSid + '\' is not valid.  It should be the 34 character unique identifier starting with \'AC\'');
    }

    private HttpRequest buildMethod(String method, String path,
            Map<String,String> params) {
        if (method.equalsIgnoreCase('GET')) {
            return generateGetRequest(path, params);
        } else if (method.equalsIgnoreCase('POST')) {
            return generatePostRequest(path, params);
        } else if (method.equalsIgnoreCase('PUT')) {
            return generatePutRequest(path, params);
        } else if (method.equalsIgnoreCase('DELETE')) {
            return generateDeleteRequest(path, params);
        } else {
            throw new TwilioRestException('Unknown Method: ' + method);
        }
    }
    
    private HttpRequest buildMethod(String method, String path, List<TwilioNameValuePair> params)
    {
        if (method.equalsIgnoreCase('GET')) {
            return generateGetRequest(path, params);
        } else if (method.equalsIgnoreCase('POST')) {
            return generatePostRequest(path, params);
        } else if (method.equalsIgnoreCase('PUT')) {
            return generatePutRequest(path, params);
        } else if (method.equalsIgnoreCase('DELETE')) {
            return generateDeleteRequest(path, params);
        } else {
            throw new TwilioRestException('Unknown Method: ' + method);
        }
    }

    private HttpRequest generateGetRequest(String path, Map<String,String> params) {

        URL uri = buildUri(path, params);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('GET');
        return req;
    }
    
    private HttpRequest generateGetRequest(String path, List<TwilioNameValuePair> params) {

        URL uri = buildUri(path, params);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('GET');
        return req;
    }

    private HttpRequest generatePostRequest(String path, Map<String,String> params) {
        URL uri = buildUri(path);

        String entity = buildEntityBody(params);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('POST');
        req.setBody(entity);

        return req;
    }

    private HttpRequest generatePostRequest(String path, List<TwilioNameValuePair> params) {
        URL uri = buildUri(path);

        String entity = buildEntityBody(params);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('POST');
        req.setBody(entity);

        return req;
    }

    private HttpRequest generatePutRequest(String path, Map<String,String> params) {
        URL uri = buildUri(path);

        String entity = buildEntityBody(params);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('PUT');
        req.setBody(entity);

        return req;
    }

    private HttpRequest generatePutRequest(String path, List<TwilioNameValuePair> params) {
        URL uri = buildUri(path);

        String entity = buildEntityBody(params);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('PUT');
        req.setBody(entity);

        return req;
    }

    private HttpRequest generateDeleteRequest(String path,
            Map<String,String> params) {
        URL uri = buildUri(path);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('DELETE');
        return req;
    }

    private HttpRequest generateDeleteRequest(String path,List<TwilioNameValuePair> params) {
        URL uri = buildUri(path);

        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri.toExternalForm());
        req.setMethod('DELETE');
        return req;
    }

    private String buildEntityBody(Map<String,String> params) {
        String entityBody='';
        if (params != null) {
            for (String key : params.keySet()) {
                try {
                    entityBody += (entityBody=='' ? '' : '&')
                                    + key + '=' + EncodingUtil.urlEncode(params.get(key), 'UTF-8');
                } catch (Exception e) {
                    System.debug('ERROR: ' + e);
                }
            }
        }
        return entityBody;
    }

    private String buildEntityBody(List<TwilioNameValuePair> params) {
        String entityBody='';
        if (params != null) {
            for (TwilioNameValuePair param : params) {
                try {
                    entityBody += (entityBody=='' ? '' : '&')
                                    + param.getName() + '=' + EncodingUtil.urlEncode(param.getValue(), 'UTF-8');
                } catch (Exception e) {
                    System.debug('ERROR: ' + e);
                }
            }
        }
        return entityBody;
    }

    private URL buildUri(String path) {
        return buildUri(path, new Map<String,String>());
    }

    private URL buildUri(String path, Map<String,String> queryStringParams) {
        String sb = path;

        if (queryStringParams != null && queryStringParams.size() > 0) {
            sb += '?';
            sb += buildEntityBody(queryStringParams);
        }

        URL uri;
        try {
            uri = new URL(sb);
        } catch (Exception e) {
            throw new TwilioRestException('Invalid uri: '+sb, e);
        }

        return uri;
    }

    private URL buildUri(String path, List<TwilioNameValuePair> queryStringParams) {
        String sb = path;

        if (queryStringParams != null && queryStringParams.size() > 0) {
            sb += '?';
            sb += buildEntityBody(queryStringParams);
        }

        URL uri;
        try {
            uri = new URL(sb);
        } catch (Exception e) {
            throw new TwilioRestException('Invalid uri: '+sb, e);
        }

        return uri;
    }

    public TwilioRestResponse request(String path, String method,
            Map<String, String> vars) {

        HttpRequest request = setupRequest(path, method, vars);

        String responseBody;
        Integer statusCode;
        String contentType;
        if (Test.isRunningTest()) {
            // can't execute HTTP requests during test execution
            system.debug('Request :'+request);
            Twilio_TestHTTPMock.Response responseMock = Twilio_TestHTTPMock.getInstance().send(request);
            system.debug(responseMock);
            responseBody = (responseMock.getBody()==null)?'':responseMock.getBody();
            statusCode = responseMock.getStatusCode();
            contentType = responseMock.getHeader('Content-Type');
        } else {
            // execute HTTP request
            HttpResponse response = (new Http()).send(request);
            responseBody = (response.getBody()==null)?'':response.getBody();
            system.debug(responseBody+'-----------------------------------------'+response);
            statusCode = response.getStatusCode();
            contentType = response.getHeader('Content-Type');
        }
        TwilioRestResponse restResponse = new TwilioRestResponse(request.getEndpoint(),
                     responseBody, statusCode);
        restResponse.setContentType(contentType);
            
        return restResponse;
    }

    private static List<TwilioNameValuePair> generateParameters(Map<String, String> vars) 
    {
        List<TwilioNameValuePair> qparams = new List<TwilioNameValuePair>();

        if (vars != null) 
        {
            for (String var : vars.keySet()) 
            {
                qparams.add(new TwilioNameValuePair(var, vars.get(var)));
            }
        }

        return qparams;
    }
        
    public TwilioRestResponse request(String path, String method,List<TwilioNameValuePair> paramList) {
    
        HttpRequest request = setupRequest(path, method, paramList);

                String responseBody;
                Integer statusCode;
                String contentType;
                if (Test.isRunningTest()) {
                        // can't execute HTTP requests during test execution
                        system.debug('Request :'+request);
                        Twilio_TestHTTPMock.Response responseMock = Twilio_TestHTTPMock.getInstance().send(request);
                        responseBody = (responseMock.getBody()==null)?'':responseMock.getBody();
                        statusCode = responseMock.getStatusCode();
                        contentType = responseMock.getHeader('Content-Type');
                        system.debug('Response Mock :'+responseMock);
                } else {
                        // execute HTTP request
                        HttpResponse response = (new Http()).send(request);
                        responseBody = (response.getBody()==null)?'':response.getBody();
                        system.debug(responseBody+'-----------------------------------------'+response);
                        statusCode = response.getStatusCode();
                        contentType = response.getHeader('Content-Type');
                }
                TwilioRestResponse restResponse = new TwilioRestResponse(request.getEndpoint(),
                                         responseBody, statusCode);
                restResponse.setContentType(contentType);
                        
                return restResponse;
    }

    private HttpRequest setupRequest(String path, String method,
            Map<String, String> params) {
        
        String normalizedPath = path.toLowerCase();
        String sb = '';

        // If we've given a fully qualified uri then skip building the endpoint
        if (normalizedPath.startsWith('http://')
                || normalizedPath.startsWith('https://')) {
            sb += path;
        } else {
            sb += this.getEndpoint();

            if (!normalizedPath.startsWith('/')) {
                sb += '/';
            }
            sb += path;
        }

        path = sb;
        
        HttpRequest request = buildMethod(method, path, params);

        request.setHeader('X-Twilio-Client', 'salesforce-' + VERSION);
        request.setHeader('User-Agent', 'twilio-salesforce/' + VERSION);
        request.setHeader('Accept', 'application/json');
        request.setHeader('Accept-Charset', 'utf-8');
        request.setHeader('Authorization',
                    'Basic '+EncodingUtil.base64Encode(Blob.valueOf(this.accountSid + ':' + this.authToken)));
        
        return request;
    }
    
    private HttpRequest setupRequest(String path, String method,
            List<TwilioNameValuePair> params) {
        
        String normalizedPath = path.toLowerCase();
        String sb = '';

        // If we've given a fully qualified uri then skip building the endpoint
        if (normalizedPath.startsWith('http://')
                || normalizedPath.startsWith('https://')) {
            sb += path;
        } else {
            sb += this.getEndpoint();

            if (!normalizedPath.startsWith('/')) {
                sb += '/';
            }
            sb += path;
        }

        path = sb;
        
        HttpRequest request = buildMethod(method, path, params);

        request.setHeader('X-Twilio-Client', 'salesforce-' + VERSION);
        request.setHeader('User-Agent', 'twilio-salesforce-' + VERSION);
        request.setHeader('Accept', 'application/json');
        
        request.setHeader('Authorization',
                    'Basic '+EncodingUtil.base64Encode(Blob.valueOf(this.accountSid + ':' + this.authToken)));
        
        return request;
    }

    public TwilioRestResponse safeRequest(String path, String method,
            Map<String, String> vars) {
        TwilioRestResponse response = null;
        for (Integer retry = 0; retry < this.numRetries; retry++) {
            response = request(path, method, vars);
            if (response.isClientError()) {
                System.debug('Twilio REST API Client Error: '+response.getResponseText());
                throw new TwilioRestException(response);
            } else if (response.isServerError()) {
                // TODO handle backoff scenario
                //try {
                //  Thread.sleep(100 * retry); // Backoff on our sleep
                //} catch (Exception e) {
                //}
                continue;
            }

            return response;
        }
        Integer errorCode = response == null ? -1 : response.getHttpStatus();
        throw new TwilioRestException('Cannot fetch: ' + method + ' ' + path,
                errorCode);
    }

    public TwilioRestResponse safeRequestPair(String path, String method,
            List<TwilioNameValuePair> paramList) 
    {
        TwilioRestResponse response = null;
        for (Integer retry = 0; retry < this.numRetries; retry++) 
        {
            response = request(path, method, paramList);    
        if (response.isClientError()) {
                System.debug('Twilio REST API Client Error: '+response.getResponseText());
                throw new TwilioRestException(response);
            } else if (response.isServerError()) {
                 continue;
            }

            return response;
        }
        Integer errorCode = response == null ? -1 : response.getHttpStatus();
        throw new TwilioRestException('Cannot fetch: ' + method + ' ' + path,
                errorCode);
    }
    
    public TwilioRestResponse get(String fullUri) {
        TwilioRestResponse response = null;

        for (Integer retry = 0; retry < this.numRetries; retry++) {
            response = request(fullUri, 'GET', new Map<String,String>());
            if (response.isClientError()) {
                throw new TwilioRestException(response);
            } else if (response.isServerError()) {
                //try {
                //  Thread.sleep(100 * retry); // Backoff on our sleep
                //} catch (InterruptedException e) {
                //}
                continue;
            }

            return response;
        }
        Integer errorCode = response == null ? -1 : response.getHttpStatus();
        throw new TwilioRestException('Cannot fetch: ' + fullUri + ' ',
                errorCode);
    }

    public String getEndpoint() {
        return endpoint;
    }

    public void setEndpoint(String endpoint) {
        this.endpoint = endpoint;
    }

    public boolean validateRequest(String expectedSignature, String url, Map<String,String> params) {
        try {
            // sort the params alphabetically, and append the key and value of each to the url
            String data = url;        
            if(params!=null){
                List<String> sortedKeys = new List<String>(params.keySet());
                sortedKeys.sort();
                
                for (String s: sortedKeys) {
                    data += s;
                    String v='';
                    if (params.get(s)!=null)
                        v=params.get(s);
                    data += v;
                }
            }

            //compute the hmac on input data bytes, with AuthToken as key
            Blob mac = Crypto.generateMac('hmacSHA1', Blob.valueOf(data), Blob.valueOf(authToken));
           
            //base64-encode the hmac
            String signature = EncodingUtil.base64Encode(mac);
            
            return signature.equals(expectedSignature);
        } catch (Exception e) {
            return false;
        }
    }
}