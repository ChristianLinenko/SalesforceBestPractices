global class TwilioAuthorizedConnectApp extends TwilioResource.InstanceResource {

    private static final String SID_PROPERTY = 'connect_app_sid';
    private static final String DATE_UPDATED_PROPERTY = 'date_updated';
    private static final String DATE_CREATED_PROPERTY = 'date_created';
    private static final String FRIENDLY_NAME_PROPERTY = 'connect_app_friendly_name';

    public TwilioAuthorizedConnectApp(TwilioRestClient client) {
        super(client);
    }

    public TwilioAuthorizedConnectApp(TwilioRestClient client, String sid) {
        super(client);
        this.setProperty(SID_PROPERTY, sid);
    }

    public TwilioAuthorizedConnectApp(TwilioRestClient client,
            Map<String, Object> properties) {
        super(client, properties);
    }

    public override String getResourceLocation() {
        return '/' + TwilioRestClient.DEFAULT_VERSION + '/Accounts/'
                + this.getRequestAccountSid() + '/AuthorizedConnectApps/' + this.getSid()
                + '.json';
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
        return this.getProperty('connect_app_description');
    }

    public String getCompanyName() {
        return this.getProperty('connect_app_company_name');
    }

    public String getHomepageUrl() {
        return this.getProperty('connect_app_homepage_url');
    }

    public List<String> getPermissions() {
        return this.getStringList('permissions');
    }
}