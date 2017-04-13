global class TwilioApplication extends TwilioResource.InstanceResource {
    
    private static final String SID_PROPERTY = 'sid';    
    private static final String DATE_UPDATED_PROPERTY = 'date_updated';
    private static final String DATE_CREATED_PROPERTY = 'date_created';
    private static final String STATUS_PROPERTY = 'status';
    private static final String FRIENDLY_NAME_PROPERTY = 'friendly_name';

    public TwilioApplication(TwilioRestClient client) {
        super(client);
    }

    public TwilioApplication(TwilioRestClient client, String sid) {
        super(client);
        this.setProperty(SID_PROPERTY, sid);
    }

    public TwilioApplication(TwilioRestClient client, Map<String, Object> properties) {
        super(client, properties);
    }

    public override String getResourceLocation() {
        return '/' + TwilioRestClient.DEFAULT_VERSION + '/Accounts/'
                + this.getRequestAccountSid() + '/Applications/' + this.getSid() + '.json';
    }

    public String getSid() {
        return this.getProperty(SID_PROPERTY);
    }
    
    public String getFriendlyName() {
        return this.getProperty(FRIENDLY_NAME_PROPERTY);
    }
    
    public String getStatus() {
        return this.getProperty(STATUS_PROPERTY);
    }
    
    public Datetime getDateCreated() {
        return this.getPropertyDatetime(DATE_CREATED_PROPERTY);
    }

    public Datetime getDateUpdated() {
        return this.getPropertyDatetime(DATE_UPDATED_PROPERTY);
    }
    
    public String getAccountSid() {
        return this.getProperty('account_sid');
    }
    
    public String getApiVersion() {
        return this.getProperty('api_version');
    }
    
    public String getVoiceUrl() {
        return this.getProperty('voice_url');
    }
    
    public String getVoiceMethod() {
        return this.getProperty('voice_method');
    }
    
    public String getVoiceFallbackUrl() {
        return this.getProperty('voice_fallback_url');
    }
    
    public String getVoiceFallbackMethod() {
        return this.getProperty('voice_fallback_method');
    }
    
    public String getStatusCallback() {
        return this.getProperty('status_callback');
    }
    
    public String getStatusCallbackMethod() {
        return this.getProperty('status_callback_method');
    }
    
    public String getVoiceCallerIdLookup() {
        return this.getProperty('voice_caller_id_lookup');
    }
    
    public String getSmsUrl() {
        return this.getProperty('sms_url');
    }
    
    public String getSmsMethod() {
        return this.getProperty('sms_method_url');
    }
    
    public String getSmsFallbackUrl() {
        return this.getProperty('sms_fallback_url');
    }
    
    public String getSmsFallbackMethod() {
        return this.getProperty('sms_fallback_method');
    }
    
    public String getSmsStatusCallback() {
        return this.getProperty('sms_status_callback');
    }
    
    public String getUri() {
        return this.getProperty('uri');
    }
    
    public boolean deleteResource() {
        TwilioRestResponse response = this.getClient().safeRequest(
                this.getResourceLocation(), 'DELETE', null);

        return !response.isError();
    }
}