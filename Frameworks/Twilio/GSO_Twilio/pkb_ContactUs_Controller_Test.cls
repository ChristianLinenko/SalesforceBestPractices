@isTest
private class pkb_ContactUs_Controller_Test {
    
    // Twilio Test Credentials from https://www.twilio.com/user/account/settings
    // See External Logins for Twilio Credentials
    private static String testAccountSID = 'AC2ebc95010be398d1e62728641cb33100';
    private static String testAuthToken = '204faa5b60fc593c2cbe8f7a3d122f4f';
    private static String testURL = 'http://twimlets.com/holdmusic?Bucket=com.twilio.music.ambient';
    private static String kbUrl = 'kb/?cu=1&fs=ContactUs&l=en_US';
    private static String testPhone = '*425A441zz1335';

    @testSetup static void setupTestData() {

        SI_Callback_Country__c siCountry = new SI_Callback_Country__c(Name = 'Bahamas');
        insert siCountry;

        TwilioConfig__c tc = new TwilioConfig__c(Name = 'TwilioCreds', AccountSid__c = testAccountSID, AuthToken__c = testAuthToken, URL__c = testURL);
        insert tc;
    }

    @isTest static void testContactUsController() {

        // get Expedient URL. Example: http://gorn-expediagso.cs40.force.com/kb/?cu=1&fs=ContactUs&l=en_US
        String host = System.URL.getSalesforceBaseUrl().getHost().remove('-api' ).remove('https://').remove('c.');
        String expedientURL =   'https://' + UserInfo.getUserName().substringAfterLast('.') + 
                                '-expediagso.' + host + kbUrl;
        system.debug('expUrl: ' + expedientURL);

        PageReference p = new PageReference(expedientURL);
        Test.setCurrentPage(p);

        test.startTest();

        pkb_ContactUs_Controller controller = new pkb_ContactUs_Controller();
        controller.setSCountry('Bahamas');

        // check for blanks AND validity
        controller.doCallback();
        system.debug(controller.errorMessage);
        system.assert(controller.errorMessage == 'Please provide your phone number');

        controller.callbackTo = testPhone;
        controller.doCallback();
        system.assert(controller.errorMessage == 'Callback provider number not found');

        controller.setSPhoneNumber(testPhone);
        controller.doCallback();
        system.debug(controller.errorMessage == 'Please provide a valid phone number');

        TwilioConfig__c tc = [SELECT Id, Name from TwilioConfig__c LIMIT 1][0];
        delete tc;

        // Delete config
        controller = new pkb_ContactUs_Controller();
        controller.setSCountry('Bahamas');
        system.assert(controller.errorMessage == 'Twilio not configured in this Salesforce org');

        test.stopTest();
    }
    
}