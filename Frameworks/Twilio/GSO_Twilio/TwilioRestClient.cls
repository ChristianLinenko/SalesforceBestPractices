public class TwilioRestClient extends TwilioClient{
    public static final String DEFAULT_VERSION = '2010-04-01';

    private TwilioAccount authAccount;

    public TwilioRestClient(String accountSid, String authToken) {
        super(accountSid, authToken, 'https://api.twilio.com');
        this.authAccount = new TwilioAccount(this);
        this.authAccount.setSid(accountSid);
        this.authAccount.setAuthToken(authToken);  
    }

    /**
     * Explcitly construct a TwilioRestClient with the given API credentials and
     * endpoint.
     * 
     * @param accountSid
     *            the 34 character Account identifier (starting with 'AC'). This
     *            can be found on your Twilio dashboard page.
     * @param authToken
     *            the 32 character AuthToken. This can be found on your Twilio
     *            dashboard page.
     * @param endpoint
     *            the url of API endpoint you wish to use. (e.g. -
     *            'https://api.twilio.com')
     */
    public TwilioRestClient(String accountSid, String authToken, String endpoint) {
        super(accountSid, authToken, endpoint);
        this.authAccount = new TwilioAccount(this);
        this.authAccount.setSid(accountSid);
        this.authAccount.setAuthToken(authToken);        
    }
    

    public TwilioAccountList getAccounts(Map<String, String> params) {
        TwilioAccountList aclist = new TwilioAccountList(this, params);
        aclist.setRequestAccountSid(this.accountSid);
        return aclist;
    }

    public TwilioAccountList getAccounts() {
        return this.getAccounts(new Map<String, String>());
    }

    public TwilioAccount getAccount() {
        return this.authAccount;
    }

    public TwilioAccount getAccount(String sid) {
        TwilioAccount account = new TwilioAccount(this);
        account.setSid(sid);
        account.setRequestAccountSid(sid);

        return account;
    }

    public String getAccountSid() {
        return this.accountSid;
    }
    
}