global class TwilioOutgoingCallerId extends TwilioResource.InstanceResource {
    
    private static final String SID_PROPERTY = 'sid';

    public TwilioOutgoingCallerId(TwilioRestClient client) {
        super(client);
    }

    public TwilioOutgoingCallerId(TwilioRestClient client, String sid) {
        super(client);
        this.setProperty(SID_PROPERTY, sid);
    }

    public TwilioOutgoingCallerId(TwilioRestClient client, Map<String, Object> properties) {
        super(client, properties);
    }

    public override String getResourceLocation() {
        return '/' + TwilioRestClient.DEFAULT_VERSION + '/Accounts/'
                + this.getRequestAccountSid() + '/OutgoingCallerIds/' + this.getSid() + '.json';
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
    
    public String getValidationCode() {
        return this.getProperty('validation_code');
    }
    
    public boolean deleteOutgoingCallerid() {
        TwilioRestResponse response = this.getClient().safeRequest(
                this.getResourceLocation(), 'DELETE', null);

        return !response.isError();
    }
}