/*  NOTE: Class truncated from original: 
    https://github.com/twilio/twilio-salesforce/blob/master/src/classes/TwilioLookupsRestClient.cls
    BR, GSO Salesforce, 4/25/16
*/
public class TwilioLookupsRestClient extends TwilioClient{

   public static final String DEFAULT_VERSION = 'v1';

    public TwilioLookupsRestClient(String accountSid, String authToken) {
        super(accountSid, authToken, 'https://lookups.twilio.com');
    }

    public TwilioLookupsRestClient(String accountSid, String authToken, String endpoint) {
        super(accountSid, authToken, endpoint);
    }

    public TwilioLookupsPhoneNumber getPhoneNumber(final String phoneNumber) {
        TwilioLookupsPhoneNumber pn = getPhoneNumber(phoneNumber, null, false);
        pn.getPhoneNumber();
        return pn;
    }

    public TwilioLookupsPhoneNumber getPhoneNumber(final String phoneNumber, final Boolean includeCarrierInfo) {
        TwilioLookupsPhoneNumber pn =  getPhoneNumber(phoneNumber, null, includeCarrierInfo);
        pn.getPhoneNumber();
        return pn;
    }

    public TwilioLookupsPhoneNumber getPhoneNumber(final String phoneNumber, final String countryCode, final Boolean includeCarrierInfo) {
        Map<String, String> params = new Map<String, String>();
        if (includeCarrierInfo) {
            params.put('Type', 'carrier');
        }

        if (countryCode != null) {
            params.put('CountryCode', countryCode);
        }
        TwilioLookupsPhoneNumber pn = new TwilioLookupsPhoneNumber(this, phoneNumber, params);
        pn.getPhoneNumber();
        return pn;
    }
}