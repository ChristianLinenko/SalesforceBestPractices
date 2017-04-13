global class TwilioCallList extends TwilioResource.ListResource
    implements Iterable<TwilioCall> {  
    
    public TwilioCallList(TwilioClient client) {
        super(client);
    }
    
    public TwilioCallList(TwilioClient client, Map<String, String> filters) {
        super(client, filters);
    }

    public override String getResourceLocation() {
        return '/' + TwilioRestClient.DEFAULT_VERSION + '/Accounts/'
                + this.getRequestAccountSid() + '/Calls.json';
    }

    public override Object makeNew(TwilioClient client, 
        Map<String, Object> params) {
            TwilioCall call = new TwilioCall((TwilioRestClient)client, params);
            call.setRequestAccountSid(this.getRequestAccountSid());
            return call;
    }

    public override String getListKey() {
        return 'calls';
    }
    
    public TwilioCall create(Map<String,String> params) {
        return (TwilioCall)this.createInstance(params);
    }

    public TwilioCall create(List<TwilioNameValuePair> params) {
        return (TwilioCall)this.createInstance(params);
    }  
        
    public List<TwilioCall> getPageData() {
        List<TwilioCall> returnList = new List<TwilioCall>();
        
        for (Object o : this.getObjectPageData()) {
            if (o instanceof TwilioCall) {
                returnList.add((TwilioCall) o);
            }
        }
        return returnList;
    }

    global Iterator<TwilioCall> iterator() {
        return new TwilioIterator.CallIterator(this);
    }
}