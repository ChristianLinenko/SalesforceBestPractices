global class TwilioApplicationList extends TwilioResource.ListResource
        implements Iterable<TwilioApplication> {

    public TwilioApplicationList(TwilioRestClient client) {
        super(client);
    }

    public TwilioApplicationList(TwilioRestClient client, Map<String, String> filters) {
        super(client, filters);
    }

    public override String getResourceLocation() {
        return '/' + TwilioRestClient.DEFAULT_VERSION + '/Accounts/'
                + this.getRequestAccountSid() + '/Applications.json';
    }

    public override Object makeNew(TwilioClient client, Map<String, Object> params) {
            TwilioApplication application = new TwilioApplication((TwilioRestClient)client, params);
            application.setRequestAccountSid(this.getRequestAccountSid());
            return application;
    }

    public override String getListKey() {
        return 'applications';
    }

    public TwilioApplication create(Map<String, String> params) {
        return (TwilioApplication)this.createInstance(params);
    }
    
    public List<TwilioApplication> getPageData() {
        List<TwilioApplication> returnList = new List<TwilioApplication>();
        
        for (Object o : this.getObjectPageData()) {
            if (o instanceof TwilioApplication) {
                returnList.add((TwilioApplication) o);
            }
        }
        return returnList;
    }
    
    global Iterator<TwilioApplication> iterator() {
        return new TwilioIterator.ApplicationIterator(this);
    }
    
    public boolean deleteResource(String sid) {
        TwilioAccount requestAccount = ((TwilioRestClient)getClient()).getAccount(getRequestAccountSid());
        TwilioApplication app = requestAccount.getApplication(sid);
        return app.deleteResource();
    }
}