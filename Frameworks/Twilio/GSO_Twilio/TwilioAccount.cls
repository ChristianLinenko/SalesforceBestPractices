global class TwilioAccount extends TwilioResource.InstanceResource {

    /* property keys */
    private static final String DATE_UPDATED_PROPERTY = 'date_updated';
    private static final String DATE_CREATED_PROPERTY = 'date_created';
    private static final String STATUS_PROPERTY = 'status';
    private static final String FRIENDLY_NAME_PROPERTY = 'friendly_name';
    private static final String ACCOUNT_SID_PROPERTY = 'sid';
    private static final String AUTH_TOKEN_PROPERTY = 'auth_token';
    private static final String TYPE_PROPERTY = 'type';
    private static final String OWNER_ACCOUNT_SID_PROPERTY = 'owner_account_sid';
    private static final String CONNECT_APP_SID_PROPERTY = 'connect_app_sid';

    /* Constructor */
    public TwilioAccount(TwilioRestClient client) {
       super(client);
    }

    /* Constructor, using predefined set of property values */
    public TwilioAccount(TwilioRestClient client, Map<String, Object> properties) {
        super(client, properties);
        Object ac = properties.get(ACCOUNT_SID_PROPERTY);
        if (ac != null && ac instanceof String) {
            String accountSid = (String) ac;
            this.setRequestAccountSid(accountSid);
        }
    }

    /* Sid field accessor */
    public String getSid() {
        if (this.getRequestAccountSid() != null)
            return this.getRequestAccountSid();
        else
            return this.getProperty(ACCOUNT_SID_PROPERTY);
    }

    /* Sid field accessor */
    public void setSid(String accountSid) {
        this.setRequestAccountSid(accountSid);
        this.setProperty(ACCOUNT_SID_PROPERTY, accountSid);
        
    }
    
    /** Returns the sid for the ConnectApp using this Account */
    public String getConnectAppSid() {
        return this.getProperty(CONNECT_APP_SID_PROPERTY);
    }
    
    /** Returns the AccountSid of the primary account */
    public String getOwnerAccountSid() {
        return this.getProperty(OWNER_ACCOUNT_SID_PROPERTY);
    }

    /** Returns the API auth token (secret) for this account */
    public String getAuthToken() {
        return this.getProperty(AUTH_TOKEN_PROPERTY);
    }

    /** Sets the API auth token (secret) for this account */
    public void setAuthToken(String authToken) {
        this.setProperty(AUTH_TOKEN_PROPERTY, authToken);
    }

    /** Returns the human-readable label for this account */
    public String getFriendlyName() {
        return this.getProperty(FRIENDLY_NAME_PROPERTY);
    }

    /** Returns the status value for this account */
    public String getStatus() {
        return this.getProperty(STATUS_PROPERTY);
    }

    /** Returns the date and time this account was created */
    public Datetime getDateCreated() {
        return this.getPropertyDatetime(DATE_CREATED_PROPERTY);
    }

    /** Returns the date and time this account was last updated */
    public Datetime getDateUpdated() {
        return this.getPropertyDatetime(DATE_UPDATED_PROPERTY);
    }
     
    /** Returns the account type */
    public String getType() {
        return this.getProperty(TYPE_PROPERTY);
    }
    
    /** Return the Twilio URI for this resource. */
    public String getUri() {
        return this.getProperty('uri');
    }
    
    /** Returns the URIs for resources under this account */
    public Map<String,Object> getSubresourceUris() {
        return (Map<String,Object>)this.getObject('subresource_uris');
    }

    /** Constructs a Twilio API resource URI for this Account. Overrides method from TwilioResource. */
    public override String getResourceLocation() {
        return '/' + TwilioRestClient.DEFAULT_VERSION + '/Accounts/'
                + this.getRequestAccountSid() + '.json';
    }


    /* SUBRESOURCE METHODS */

    /* Returns the calls list resource without any filters.
     * See http://www.twilio.com/docs/api/rest/call
     */
    public TwilioCallList getCalls() {
        return this.getCalls(new Map<String, String>());
    }

    /* Returns the calls list resource with the given filters.
     * See http://www.twilio.com/docs/api/rest/call
     */
    public TwilioCallList getCalls(Map<String, String> filters) {
        TwilioCallList calls = new TwilioCallList((TwilioRestClient)this.getClient(), filters);
        calls.setRequestAccountSid(this.getRequestAccountSid());
        
        return calls;
    }
    
    /** Returns a given call instance by sid */
    public TwilioCall getCall(String sid) {
        TwilioCall call = new TwilioCall((TwilioRestClient)this.getClient(), sid);
        call.setRequestAccountSid(this.getRequestAccountSid());
        return call;
    }


    /*public TwilioSmsList getSmsMessages() {
        return this.getSmsMessages(new Map<String, String>());
    }

    public TwilioSmsList getSmsMessages(Map<String, String> filters) {
        TwilioSmsList sms = new TwilioSmsList((TwilioRestClient)this.getClient(), filters);
        sms.setRequestAccountSid(this.getRequestAccountSid());

        return sms;
    }
    
    public TwilioSms getSms(String sid) {
        TwilioSms sms = new TwilioSms((TwilioRestClient)this.getClient(), sid);
        sms.setRequestAccountSid(this.getRequestAccountSid());
        return sms;
    }*/
    
    /*public TwilioMessageList getMessages() {
        return this.getMessages(new Map<String, String>());
    }

    public TwilioMessageList getMessages(Map<String, String> filters) {
        TwilioMessageList message = new TwilioMessageList((TwilioRestClient)this.getClient(), filters);
        message.setRequestAccountSid(this.getRequestAccountSid());

        return message;
    }
    
    public TwilioMessage getMessage(String sid) {
        TwilioMessage message = new TwilioMessage((TwilioRestClient)this.getClient(), sid);
        message.setRequestAccountSid(this.getRequestAccountSid());
        return message;
    }*/
    
    /*public TwilioQueueList getQueues() 
    {
        TwilioQueueList Queuelist = new TwilioQueueList((TwilioRestClient)this.getClient(), filters);
        Queuelist.setRequestAccountSid(this.getRequestAccountSid());
        return Queuelist;
    }

     public TwilioQueue getQueue(String sid) 
     {
         TwilioQueue queue = new TwilioQueue((TwilioRestClient)this.getClient(), sid);
         queue.setRequestAccountSid(this.getRequestAccountSid());
         return queue;
     }*/
        
    /**
     * Suspend a subaccount.
     *
     * @return the account
     * @throws TwilioRestException the twilio rest exception
     */
    public TwilioAccount suspend() {
        Map<String, String> vars = new Map<String, String>
                { 'Status'=> 'suspended' };

        TwilioRestResponse response = this.getClient().safeRequest(
                this.getResourceLocation(), 'POST', vars);

        TwilioAccount a = new TwilioAccount((TwilioRestClient)this.getClient(), response.toMap());
        a.setRequestAccountSid(this.getRequestAccountSid());
        return a;
    }
    
    /**
     * Activate a suspended subaccount.
     *
     * @return the account
     * @throws TwilioRestException the twilio rest exception
     */
    public TwilioAccount activate() {
        Map<String, String> vars = new Map<String, String>
                { 'Status'=> 'active' };

        TwilioRestResponse response = this.getClient().safeRequest(
                this.getResourceLocation(), 'POST', vars);

        TwilioAccount a = new TwilioAccount((TwilioRestClient)this.getClient(), response.toMap());
        a.setRequestAccountSid(this.getRequestAccountSid());
        return a;
    }
    
    /**
     * Close a subaccount. WARNING: This cannot be undone.
     *
     * @return the account
     * @throws TwilioRestException the twilio rest exception
     */
    public TwilioAccount close() {
        Map<String, String> vars = new Map<String, String>
                { 'Status'=> 'closed' };

        TwilioRestResponse response = this.getClient().safeRequest(
                this.getResourceLocation(), 'POST', vars);

        TwilioAccount a = new TwilioAccount((TwilioRestClient)this.getClient(), response.toMap());
        a.setRequestAccountSid(this.getRequestAccountSid());
        return a;
    }
    
    public TwilioApplicationList getApplications() {
        return this.getApplications(new Map<String, String>());
    }

    public TwilioApplicationList getApplications(Map<String, String> filters) {
        TwilioApplicationList twlist = new TwilioApplicationList((TwilioRestClient)this.getClient(), filters);
        twlist.setRequestAccountSid(this.getRequestAccountSid());
        return twlist;
    }
    
    /**
     * Returns a given Application instance by sid.
     */
    public TwilioApplication getApplication(String sid) {
        TwilioApplication app = new TwilioApplication((TwilioRestClient)this.getClient(), sid);
        app.setRequestAccountSid(this.getRequestAccountSid());
        return app;
    }
    
    /**
     * Returns the available phone numbers. Defaults to US/Local.
     * See http://www.twilio.com/docs/api/rest/available-phone-numbers
     */
    public TwilioAvailablePhoneNumberList getAvailablePhoneNumbers() {
        return this.getAvailablePhoneNumbers(new Map<String, String>());
    }

    /**
     * Returns the available phone numbers. With the given search filters. Defaults
     * to US/Local numbers.
     * See http://www.twilio.com/docs/api/rest/available-phone-numbers
     */
    public TwilioAvailablePhoneNumberList getAvailablePhoneNumbers(Map<String, String> filters) {
        TwilioAvailablePhoneNumberList twlist = new TwilioAvailablePhoneNumberList(
                (TwilioRestClient)this.getClient(), filters);
        twlist.setRequestAccountSid(this.getRequestAccountSid());
        return twlist;
    }

    /**
     * Returns the available phone numbers with the given iso country and type.
     * See http://www.twilio.com/docs/api/rest/available-phone-numbers
     * 
     * @param filters
     *            the filters
     * @param isoCountry
     *            the Iso Country code you are searching in
     * @param type
     *            the type of phone number. Possible values are
     *            AvailablePhoneNumber.TYPE_LOCAL or
     *            AvailablePhoneNumber.TYPE_TOLLFREE
     * 
     * @return the available phone numbers
     */
    public TwilioAvailablePhoneNumberList getAvailablePhoneNumbers(
            Map<String, String> filters, String isoCountry, String type) {
        TwilioAvailablePhoneNumberList twlist = new TwilioAvailablePhoneNumberList(
                (TwilioRestClient)this.getClient(), filters, isoCountry, type);
        twlist.setRequestAccountSid(this.getRequestAccountSid());

        return twlist;
    }

    /*public TwilioConferenceList getConferences() {
        return this.getConferences(new Map<String, String>());
    }

    public TwilioConferenceList getConferences(Map<String, String> filters) {
        TwilioConferenceList twlist = new TwilioConferenceList((TwilioRestClient)this.getClient(), filters);
        twlist.setRequestAccountSid(this.getRequestAccountSid());
        return twlist;
    }
    
    public TwilioConference getConference(String sid) {
        TwilioConference conf = new TwilioConference((TwilioRestClient)this.getClient(), sid);
        conf.setRequestAccountSid(this.getRequestAccountSid());
        return conf;
    }*/
    
    /*public TwilioParticipantList getParticipants(String conferenceSid) {
        TwilioParticipantList twlist = new TwilioParticipantList((TwilioRestClient)this.getClient(), conferenceSid);
        twlist.setRequestAccountSid(this.getRequestAccountSid());
        return twlist;
    }

    public TwilioParticipant getParticipant(String conferenceSid, string callSid) {
        TwilioParticipant twparticipant = new TwilioParticipant((TwilioRestClient)this.getClient(), conferenceSid, callSid);
        twparticipant.setRequestAccountSid(this.getRequestAccountSid());
        return twparticipant;  
    }*/
    
    /**
     * Returns the incoming phone numbers list.
     * See http://www.twilio.com/docs/api/rest/incoming-phone-numbers
     */
    public TwilioIncomingPhoneNumberList getIncomingPhoneNumbers() {
        return this.getIncomingPhoneNumbers(new Map<String, String>());
    }

    /**
     * Returns the incoming phone numbers list with the given filters.
     * See http://www.twilio.com/docs/api/rest/incoming-phone-numbers
     */
    public TwilioIncomingPhoneNumberList getIncomingPhoneNumbers(
            Map<String, String> filters) {
        TwilioIncomingPhoneNumberList twlist = new TwilioIncomingPhoneNumberList(
                (TwilioRestClient)this.getClient(), filters);
        twlist.setRequestAccountSid(this.getRequestAccountSid());
        return twlist;
    }
    
    /**
     * Returns a given incoming phone number instance by sid.
     */
    public TwilioIncomingPhoneNumber getIncomingPhoneNumber(String sid) {
        TwilioIncomingPhoneNumber pn = new TwilioIncomingPhoneNumber((TwilioRestClient)this.getClient(), sid);
        pn.setRequestAccountSid(this.getRequestAccountSid());
        return pn;
    }
    
    /*public TwilioShortCodeList getShortCodes() {
        return this.getShortCodes(new Map<String, String>());
    }

    public TwilioShortCodeList getShortCodes(Map<String, String> filters) {
        TwilioShortCodeList twlist = new TwilioShortCodeList((TwilioRestClient)this.getClient(), filters);
        twlist.setRequestAccountSid(this.getRequestAccountSid());
        return twlist;
    }

    public TwilioShortCode getShortCode(String sid) {
        TwilioShortCode sc = new TwilioShortCode((TwilioRestClient)this.getClient(), sid);
        sc.setRequestAccountSid(this.getRequestAccountSid());
        return sc;
    }*/
    
    /*public TwilioNotificationList getNotifications() {
        return this.getNotifications(new Map<String, String>());
    }

    public TwilioNotificationList getNotifications(Map<String, String> filters) {
        TwilioNotificationList twlist = new TwilioNotificationList((TwilioRestClient)this.getClient(), filters);
        twlist.setRequestAccountSid(this.getRequestAccountSid());
        return twlist;
    }

    public TwilioNotification getNotification(String sid) {
        TwilioNotification n = new TwilioNotification((TwilioRestClient)this.getClient(), sid);
        n.setRequestAccountSid(this.getRequestAccountSid());
        return n;
    }*/

    /*public TwilioOutgoingCallerIdList getOutgoingCallerIds() {
        return this.getOutgoingCallerIds(null);
    }

    public TwilioOutgoingCallerIdList getOutgoingCallerIds(Map<String, String> filters) {
        TwilioOutgoingCallerIdList twlist;
        if (filters==null) {
            twlist = new TwilioOutgoingCallerIdList((TwilioRestClient)this.getClient());
        } else {
            twlist = new TwilioOutgoingCallerIdList((TwilioRestClient)this.getClient(), filters);
        }
        twlist.setRequestAccountSid(this.getRequestAccountSid());
        return twlist;
    }

    public TwilioOutgoingCallerId getOutgoingCallerId(String sid) {
        TwilioOutgoingCallerId cid = new TwilioOutgoingCallerId((TwilioRestClient)this.getClient(), sid);
        cid.setRequestAccountSid(this.getRequestAccountSid());
        return cid;
    }*/
    
    
    /*
    public TwilioRecordingList getRecordings() {
        return this.getRecordings(new Map<String, String>());
    }

    public TwilioRecordingList getRecordings(Map<String, String> filters) {
        TwilioRecordingList twlist = new TwilioRecordingList((TwilioRestClient)this.getClient(), filters);
        twlist.setRequestAccountSid(this.getRequestAccountSid());
        return twlist;
    }

    public TwilioRecording getRecording(String sid) {
        TwilioRecording r = new TwilioRecording((TwilioRestClient)this.getClient(), sid);
        r.setRequestAccountSid(this.getRequestAccountSid());
        return r;
    }*/
    
    /*
    public TwilioTranscriptionList getTranscriptions() {
        return this.getTranscriptions(new Map<String, String>());
    }

    public TwilioTranscriptionList getTranscriptions(Map<String, String> filters) {
        TwilioTranscriptionList twlist = new TwilioTranscriptionList((TwilioRestClient)this.getClient(),
                filters);
        twlist.setRequestAccountSid(this.getRequestAccountSid());
        return twlist;
    }
    
    public TwilioTranscription getTranscription(String sid) {
        TwilioTranscription tr = new TwilioTranscription((TwilioRestClient)this.getClient(), sid);
        tr.setRequestAccountSid(this.getRequestAccountSid());
        return tr;
    }
     */
    

    /**
     * Returns the connect app list with the given filters.
     * See http://www.twilio.com/docs/api/rest/connect-apps
     */
    public TwilioConnectAppList getConnectApps(Map<String, String> filters) {
        TwilioConnectAppList twlist = new TwilioConnectAppList((TwilioRestClient)this.getClient(),
                filters);
        twlist.setRequestAccountSid(this.getRequestAccountSid());
        return twlist;
    }
    
    /**
     * Returns a given connect app instance by sid
     */
    public TwilioConnectApp getConnectApp(String sid) {
        TwilioConnectApp cn = new TwilioConnectApp((TwilioRestClient)this.getClient(), sid);
        cn.setRequestAccountSid(this.getRequestAccountSid());
        return cn;
    }
    
    public TwilioAuthorizedConnectAppList getAuthorizedConnectApps(Map<String, String> filters) {
        TwilioAuthorizedConnectAppList twlist = new TwilioAuthorizedConnectAppList((TwilioRestClient)this.getClient(),
                filters);
        twlist.setRequestAccountSid(this.getRequestAccountSid());
        return twlist;
    }
    
    public TwilioAuthorizedConnectApp getAuthorizedConnectApp(String sid) {
        TwilioAuthorizedConnectApp cn = new TwilioAuthorizedConnectApp((TwilioRestClient)this.getClient(), sid);
        cn.setRequestAccountSid(this.getRequestAccountSid());
        return cn;
    }
    
    /*public TwilioSandbox getSandbox() {
        TwilioSandbox sb = new TwilioSandbox((TwilioRestClient)this.getClient());
        sb.setRequestAccountSid(this.getRequestAccountSid());
        return sb;
    }*/
}