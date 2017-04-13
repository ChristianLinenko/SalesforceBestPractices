global class TwilioOutgoingCallerIdList extends TwilioResource.ListResource {

    public TwilioOutgoingCallerIdList(TwilioRestClient client) {
        super(client);
    }

    public TwilioOutgoingCallerIdList(TwilioRestClient client,
            Map<String, String> filters) {
        super(client, filters);
    }

    public override String getResourceLocation() {
        return '/' + TwilioRestClient.DEFAULT_VERSION + '/Accounts/'
                + this.getRequestAccountSid() + '/OutgoingCallerIds.json';
    }

    public override Object makeNew(TwilioClient client, Map<String, Object> params) {
        TwilioOutgoingCallerId callerId = new TwilioOutgoingCallerId((TwilioRestClient)client, params);
        callerId.setRequestAccountSid(this.getRequestAccountSid());
        return callerId;
    }

    public override String getListKey() {
        return 'outgoing_caller_ids';
    }
    
    public TwilioCallerIdValidation create(Map<String,String> params) {
        TwilioRestResponse response = this.getClient().safeRequest(
                this.getResourceLocation(), 'POST', params);
        return new TwilioCallerIdValidation(response);
    }
    
    public List<TwilioOutgoingCallerId> getPageData() {
        List<TwilioOutgoingCallerId> returnList = new List<TwilioOutgoingCallerId>();
        
        for (Object o : this.getObjectPageData()) {
            if (o instanceof TwilioOutgoingCallerId) {
                returnList.add((TwilioOutgoingCallerId) o);
            }
        }
        return returnList;
    }
    
    global Iterator<TwilioOutgoingCallerId> iterator() {
        return new TwilioIterator.OutgoingCallerIdIterator(this);
    }
    
    public TwilioCallerIdValidation validate(String phoneNumber) {
        Map<String,String> params = new Map<String,String> {
            'PhoneNumber' => phoneNumber
        };
        return create(params);
    }
}