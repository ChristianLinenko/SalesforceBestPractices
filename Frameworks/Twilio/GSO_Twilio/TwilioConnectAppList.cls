global class TwilioConnectAppList extends TwilioResource.ListResource
    implements Iterable<TwilioConnectApp> {

    public TwilioConnectAppList(TwilioRestClient client) {
        super(client);
    }

    public TwilioConnectAppList(TwilioRestClient client, Map<String, String> filters) {
        super(client, filters);
    }

    public override String getResourceLocation() {
        return '/' + TwilioRestClient.DEFAULT_VERSION + '/Accounts/'
                + this.getRequestAccountSid() + '/ConnectApps.json';
    }

    public override Object makeNew(TwilioClient client, Map<String, Object> params) {
        TwilioConnectApp connect = new TwilioConnectApp((TwilioRestClient)client, params);
        connect.setRequestAccountSid(this.getRequestAccountSid());
        return connect;
    }

    public override String getListKey() {
        return 'connect_apps';
    }
    
    public List<TwilioConnectApp> getPageData() {
        List<TwilioConnectApp> returnList = new List<TwilioConnectApp>();
        
        for (Object o : this.getObjectPageData()) {
            if (o instanceof TwilioConnectApp) {
                returnList.add((TwilioConnectApp) o);
            }
        }
        return returnList;
    }
    
    global Iterator<TwilioConnectApp> iterator() {
        return new TwilioIterator.ConnectAppIterator(this);
    }

}