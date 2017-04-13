global class TwilioIncomingPhoneNumberList extends TwilioResource.ListResource
        implements Iterable<TwilioIncomingPhoneNumber> {

    public TwilioIncomingPhoneNumberList(TwilioRestClient client) {
        super(client);
    }

    public TwilioIncomingPhoneNumberList(TwilioRestClient client,
            Map<String, String> filters) {
        super(client, filters);
    }

    public override String getResourceLocation() {
        return '/' + TwilioRestClient.DEFAULT_VERSION + '/Accounts/'
                + this.getRequestAccountSid() + '/IncomingPhoneNumbers.json';
    }

    public override Object makeNew(TwilioClient client, Map<String, Object> params) {
        TwilioIncomingPhoneNumber incoming = new TwilioIncomingPhoneNumber((TwilioRestClient)client, params);
        incoming.setRequestAccountSid(this.getRequestAccountSid());
        return incoming;
    }

    public override String getListKey() {
        return 'incoming_phone_numbers';
    }
    
    public TwilioIncomingPhoneNumber create(Map<String, String> params) {
        return (TwilioIncomingPhoneNumber)this.createInstance(params);
    }
    
    public List<TwilioIncomingPhoneNumber> getPageData() {
        List<TwilioIncomingPhoneNumber> returnList = new List<TwilioIncomingPhoneNumber>();
        
        for (Object o : this.getObjectPageData()) {
            if (o instanceof TwilioIncomingPhoneNumber) {
                returnList.add((TwilioIncomingPhoneNumber) o);
            }
        }
        return returnList;
    }
    
    global Iterator<TwilioIncomingPhoneNumber> iterator() {
        return new TwilioIterator.IncomingPhoneNumberIterator(this);
    }
}