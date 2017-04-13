global class TwilioAvailablePhoneNumberList extends TwilioResource.ListResource
    implements Iterable<TwilioAvailablePhoneNumber> {

    public static final String TYPE_LOCAL = 'Local';
    public static final String TYPE_TOLLFREE = 'TollFree';
    
    private String isoCountry = 'US';
    
    private String type = TYPE_LOCAL;

    public TwilioAvailablePhoneNumberList(TwilioRestClient client) {
        super(client);
    }

    public TwilioAvailablePhoneNumberList(TwilioRestClient client,
            Map<String, String> filters) {
        super(client, filters);
    }

    public TwilioAvailablePhoneNumberList(TwilioRestClient client,
            String isoCountryCode, String type) {
        super(client);
        this.isoCountry = isoCountryCode;
        this.type = type;
    }
    
    public TwilioAvailablePhoneNumberList(TwilioRestClient client,
            Map<String, String> filters, String isoCountryCode, String type) {
        super(client, filters);
        this.isoCountry = isoCountryCode;
        this.type = type;
    }
    
    public override String getResourceLocation() {
        return '/' + TwilioRestClient.DEFAULT_VERSION + '/Accounts/'
                + this.getRequestAccountSid() + '/AvailablePhoneNumbers/'
                + this.isoCountry + '/' + this.type + '.json';
    }

    public override Object makeNew(TwilioClient client, Map<String, Object> params) {
        TwilioAvailablePhoneNumber available = new TwilioAvailablePhoneNumber((TwilioRestClient)client, params);
        available.setRequestAccountSid(this.getRequestAccountSid());
        return available;
    }
    
    public override String getListKey() {
        return 'available_phone_numbers';
    }

    public List<TwilioAvailablePhoneNumber> getPageData() {
        List<TwilioAvailablePhoneNumber> returnList = new List<TwilioAvailablePhoneNumber>();
        
        for (Object o : this.getObjectPageData()) {
            if (o instanceof TwilioAvailablePhoneNumber) {
                returnList.add((TwilioAvailablePhoneNumber) o);
            }
        }
        return returnList;
    }
    
    global Iterator<TwilioAvailablePhoneNumber> iterator() {
        return new TwilioIterator.AvailablePhoneNumberIterator(this);
    }
    
}