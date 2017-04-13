global class TwilioConnectApp extends TwilioResource.InstanceResource {
    
    private static final String SID_PROPERTY = 'sid';
    
    private static final String FRIENDLY_NAME_PROPERTY = 'friendly_name';

    public TwilioConnectApp(TwilioRestClient client) {
        super(client);
    }

    public TwilioConnectApp(TwilioRestClient client, String sid) {
        super(client);
        this.setProperty(SID_PROPERTY, sid);
    }

    public TwilioConnectApp(TwilioRestClient client, Map<String, Object> properties) {
        super(client, properties);
    }

    public override String getResourceLocation() {
        return '/' + TwilioRestClient.DEFAULT_VERSION + '/Accounts/'
                + this.getRequestAccountSid() + '/ConnectApps/' + this.getSid() + '.json';
    }

    public String getSid() {
        return this.getProperty(SID_PROPERTY);
    }
    
    public String getFriendlyName() {
        return this.getProperty(FRIENDLY_NAME_PROPERTY);
    }
    
    public Datetime getDateCreated() {
        return this.getPropertyDatetime('date_created');
    }

    public Datetime getDateUpdated() {
        return this.getPropertyDatetime('date_updated');
    }
    
    public String getAccountSid() {
        return this.getProperty('account_sid');
    }
    
    public String getDescription() {
        return this.getProperty('description');
    }
    
    public String getCompanyName() {
        return this.getProperty('company_name');
    }
    
    public String getHomepageUrl() {
        return this.getProperty('homepage_url');
    }
    
    public String getDeauthorizeCallbackUrl() {
        return this.getProperty('deauthorize_callback_url');
    }
    
    public String getAuthorizeRedirectUrl() {
        return this.getProperty('authorize_redirect_url');
    }
    
    public String getDeauthorizeCallbackMethod() {
        return this.getProperty('deauthorize_callback_method');
    }
    
    public List<String> getPermissions() {
        return this.getStringList('permissions');
    }
    
}