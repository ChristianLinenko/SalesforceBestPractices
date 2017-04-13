global class TwilioAuthorizedConnectAppList extends TwilioResource.ListResource
    implements Iterable<TwilioAuthorizedConnectApp> {

    public TwilioAuthorizedConnectAppList(TwilioRestClient client) {
        super(client);
    }

    public TwilioAuthorizedConnectAppList(TwilioRestClient client, Map<String, String> filters) {
        super(client, filters);
    }

    public override String getResourceLocation() {
        return '/' + TwilioRestClient.DEFAULT_VERSION + '/Accounts/'
                + this.getRequestAccountSid() + '/AuthorizedConnectApps.json';
    }

    public override Object makeNew(TwilioClient client, Map<String, Object> params) {
        TwilioAuthorizedConnectApp connectApp = new TwilioAuthorizedConnectApp((TwilioRestClient)client, params);
        connectApp.setRequestAccountSid(this.getRequestAccountSid());
        return connectApp;
    }

    public override String getListKey() {
        return 'authorized_connect_apps';
    }
    
    public List<TwilioAuthorizedConnectApp> getPageData() {
        List<TwilioAuthorizedConnectApp> returnList = new List<TwilioAuthorizedConnectApp>();
        
        for (Object o : this.getObjectPageData()) {
            if (o instanceof TwilioAuthorizedConnectApp) {
                returnList.add((TwilioAuthorizedConnectApp) o);
            }
        }
        return returnList;
    }
    
    global Iterator<TwilioAuthorizedConnectApp> iterator() {
        return new TwilioIterator.AuthorizedConnectAppIterator(this);
    }

}