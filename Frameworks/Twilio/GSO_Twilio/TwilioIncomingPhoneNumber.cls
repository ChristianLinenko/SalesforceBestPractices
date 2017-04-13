global class TwilioIncomingPhoneNumber extends TwilioResource.InstanceResource {

    private static final String SID_PROPERTY = 'sid';

    public TwilioIncomingPhoneNumber(TwilioRestClient client) {
        super(client);
    }

    public TwilioIncomingPhoneNumber(TwilioRestClient client, String sid) {
        super(client);
        this.setProperty(SID_PROPERTY, sid);
    }

    public TwilioIncomingPhoneNumber(TwilioRestClient client,
            Map<String, Object> properties) {
        super(client, properties);
    }

    public override String getResourceLocation() {
        return '/' + TwilioRestClient.DEFAULT_VERSION + '/Accounts/'
                + this.getRequestAccountSid() + '/IncomingPhoneNumbers/'
                + this.getSid() + '.json';
    }

    public boolean deleteIncomingPhoneNumber() {
        TwilioRestResponse response = this.getClient().safeRequest(
                this.getResourceLocation(), 'DELETE', null);
        
        return !response.isError();
    }

    public String getSid() {
        return this.getProperty(SID_PROPERTY);
    }

    public Datetime getDateCreated() {
        return this.getPropertyDatetime('date_created');
    }

    public Datetime getDateUpdated() {
        return this.getPropertyDatetime('date_updated');
    }

    public String getFriendlyName() {
        return this.getProperty('friendly_name');
    }

    public String getAccountSid() {
        return this.getProperty('account_sid');
    }

    public String getPhoneNumber() {
        return this.getProperty('phone_number');
    }

    public String getVoiceApplicationSid() {
        return this.getProperty('voice_application_sid');
    }

    public String getSmsApplicationSid() {
        return this.getProperty('sms_application_sid');
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

    /*public String getSmsUrl() {
        return this.getProperty('sms_url');
    }

    public String getSmsMethod() {
        return this.getProperty('sms_method');
    }

    public String getSmsFallbackUrl() {
        return this.getProperty('sms_fallback_url');
    }

    public String getSmsFallbackMethod() {
        return this.getProperty('sms_fallback_method');
    }

    public String getSmsStatusCallback() {
        return this.getProperty('sms_status_callback');
    }*/
    
    public map<string,object> getcapabilities() {
        return (Map<String,Object>)this.getObject('capabilities');
    }

    /**
     * Indicates whether this number requires an Address to be on file with Twilio.
     * Potential values are "any", "local", "foreign", or "none".
     */
    public String getAddressRequirements() {
        return this.getProperty('address_requirements');
    }

    /**
     * Whether this number is new to the Twilio platform.
     * @return Beta status
     */
    public boolean getBeta() {
        return  this.getPropertyBoolean('beta');
    }

}