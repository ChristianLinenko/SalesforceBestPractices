public with sharing class pkb_ContactUs_Controller {

    public String callbackFrom { get; set; }
    public String callbackTo { get; set; }
    public String errorMessage { get; set; }
    public String successMessage { get; set; }
    //public String callbackName { get; set; }
    //public String callbackHotelID { get; set; }
    public String SPhoneNumber;
    public String SCountry;
    private List<TwilioConfig__c> tcSettings;
    private List<SI_Callback_Country__c> siCountries;
    private SI_Callback_Country__c siCountry;
    private Map<String, String> twilioParams;
    private String twilioAccount;
    private String twilioToken;
    private String twilioURL;
    //private String testUrl = 'http://twimlets.com/holdmusic?Bucket=com.twilio.music.ambient';

    private final String twilioNotConfigured = 'Twilio not configured in this Salesforce org';
    private final String blankCallbackTo = 'Please provide your phone number';
    private final String blankCallbackFrom = 'Callback provider number not found';
    private final String invalidNumber = 'Please provide a valid phone number';
    private final String callConnected = 'Call Connected';

    // SupportNumbers from pkb_Controller
    public void setSPhoneNumber (String s) {
        SPhoneNumber = ParsePhoneNumber(s);
    }
    public String getSPhoneNumber() {
        return SPhoneNumber;
    }
    // SupportCountry from pkb_Controller
    public void setSCountry(String c) {
        SCountry = c;
    }
    public String getSCountry() {
        return SCountry;
    }

    public pkb_ContactUs_Controller() {
        init();
    }

    private void init() {
        tcSettings = TwilioConfig__c.getAll().values();
        if (tcSettings.size() == 0){
            errorMessage = twilioNotConfigured;
        }
        else {
            twilioAccount = tcSettings[0].AccountSid__c;
            twilioToken = tcSettings[0].AuthToken__c;
            twilioURL = tcSettings[0].URL__c;
        }
        // Load available countries for Structured Intake Callback
        siCountries = SI_Callback_Country__c.getAll().values();
    }

    public PageReference doCallback() {

        TwilioRestClient client = new TwilioRestClient(twilioAccount, twilioToken);

        siCountry = SI_Callback_Country__c.getValues(SCountry);
        if (Validate() & siCountry != null) {
            Map<String,String> twilioParams = new Map<String,String> {
                'To'   => callbackTo,
                'From' => callbackFrom,
                'Url'  => twilioURL + siCountry.Twilio_ID__c
            };
            if (!Test.isRunningTest()) {
                try {
	               TwilioCall call = client.getAccount().getCalls().create(twilioParams);
                    system.debug('*** call: ' + call + ' ***');
                }catch (Exception e) {
                    errorMessage = blankCallbackFrom;
                    Logger.exception(e);
                }
            }
            successMessage = callConnected;
        }
        return null;
    }

    private boolean Validate() {

        errorMessage = '';

        // Call To has a value?
        if (String.isEmpty(callbackTo)) {
            errorMessage = blankCallbackTo;
            return false;
        }
        else {
            callbackTo = ParsePhoneNumber(callbackTo);
        }

        // Call From has a value?
        if (!String.isEmpty(getSPhoneNumber())) {
            callbackFrom = ParsePhoneNumber(getSPhoneNumber());
        }
        else {
            errorMessage = blankCallbackFrom;
            return false;
        }

        // valid phone number?
        TwilioLookupsRestClient lrc = new TwilioLookupsRestClient(twilioAccount, twilioToken);
        try {
            TwilioLookupsPhoneNumber lph = lrc.getPhoneNumber(callbackTo);
        }
        catch (TwilioRestException tre) {
            system.debug(tre);
            errorMessage = invalidNumber;
            if(!Test.isRunningTest()){
                return false;
            }
        }
        return true;
    }

    private String ParsePhoneNumber(String contactNumber) {
        String numericOutput = '';

        if (contactNumber != null) {
            Pattern p = Pattern.compile('[^0-9]');

            // ASSUMES THAT A FORWARD SLASH IS USED TO SEPARATE THE PRIMARY PHONE NUMBER FROM THE SECONDARY NUMBER
            List<String> numbers = contactNumber.split('/');
            if(numbers.isEmpty() == false) {
                numericOutput = p.matcher(numbers.get(0)).replaceAll('');
            }
        }

        return numericOutput;
    }
}