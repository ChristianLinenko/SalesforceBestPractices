/* NOTE: Class truncated from original: 
    https://github.com/twilio/twilio-salesforce/blob/master/src/classes/TwilioLookupsPhoneNumber.cls
    BR, GSO Salesforce, 4/25/16
*/
global class TwilioLookupsPhoneNumber extends TwilioResource.InstanceResource {

    public enum PhoneType {LANDLINE, MOBILE, VOIP}

    private String phoneNumber;

    public TwilioLookupsPhoneNumber(TwilioLookupsRestClient client) {
        super(client);
    }
    
    public TwilioLookupsPhoneNumber(TwilioLookupsRestClient client, String phoneNumber) {
        super(client);
        this.phoneNumber = phoneNumber;
    }


    public TwilioLookupsPhoneNumber(TwilioLookupsRestClient client, String phoneNumber, Map<String, String> params) {
        super(client, params);
        this.phoneNumber = phoneNumber;
    }

    public override String getResourceLocation() {
        return '/' + TwilioLookupsRestClient.DEFAULT_VERSION + '/PhoneNumbers/' + this.phoneNumber;
    }
    
    //Property getters
    public String getPhoneNumber() {
        return this.getProperty('phone_number');
    }

    //@return The ISO 3166-1 alpha-2 country code for this phone number's country.
    public String getCountryCode() {
        return getProperty('country_code');
    }

    // @return The phone number in localized format, e.g. "(415) 867-5309"
    public String getFormattedNumber() {
        return getProperty('national_format');
    }

    public String getUrl() {
        return getProperty('url');
    }

}