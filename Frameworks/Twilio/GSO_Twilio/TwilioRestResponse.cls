public class TwilioRestResponse {
    
    private String responseText;

    /** field accessor for response for backward compatibility
     *  @deprecated
     */
    public String responseBody { get { return getResponseText(); } }

    public Integer httpStatus { public get; private set;}
    
    private String url;

    private String queryString;

    public Boolean error { public get; private set; }

    private String contentType;

    public TwilioRestResponse(String url, String text, Integer status) {
        Pattern p = Pattern.compile('([^?]+)\\??(.*)');
        Matcher m = p.matcher(url);
        m.matches();
        this.url = m.group(1);
        this.queryString = m.group(2);
        this.responseText = text;
        this.httpStatus = status;
        this.error = (status >= 400);
    }
    
    public TwilioRestResponse(String text, Integer status) {
        this.url = null;
        this.queryString = null;
        this.responseText = text;
        this.httpStatus = status;
        this.error = (status >= 400);
    }
    
    public String getResponseText() {
        return responseText;
    }

    public void setResponseText(String responseText) {
        this.responseText = responseText;
    }

    public Integer getHttpStatus() {
        return httpStatus;
    }

    public void setHttpStatus(Integer httpStatus) {
        this.httpStatus = httpStatus;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getQueryString() {
        return queryString;
    }

    public void setQueryString(String queryString) {
        this.queryString = queryString;
    }

    public boolean isError() {
        return error;
    }

    public void setError(boolean error) {
        this.error = error;
    }

    public boolean isClientError() {
        return (this.getHttpStatus() >= 400 && this.getHttpStatus() < 500);
    }

    public boolean isServerError() {
        return this.getHttpStatus() >= 500;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public boolean isJson() {
        return (this.contentType!=null && this.contentType.startsWithIgnoreCase('application/json'));
    }

    public boolean isXml() {
        return (this.contentType!=null && (this.contentType.equalsIgnoreCase('text/xml') || this.contentType
                .equalsIgnoreCase('application/xml')));
    }

    public Map<String, Object> toMap() {
        Map<String,Object> mapped;
        
        if (isJson()) {
            mapped = TwilioParser.jsonToMap(responseText);
        } else {
            throw new TwilioRestException('This method currently only supports JSON responses, not XML');
        }
        return mapped;
    }
}