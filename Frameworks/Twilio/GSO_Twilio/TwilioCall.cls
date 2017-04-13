global class TwilioCall extends TwilioResource.InstanceResource {

    public TwilioCall(TwilioRestClient client) {
        super(client);
    }
    
    public TwilioCall(TwilioRestClient client, String sid) {
        super(client);
        this.setProperty('sid', sid);
    }

    public TwilioCall(TwilioRestClient client, Map<String, Object> properties) {
        super(client, properties);
    }

    public override String getResourceLocation() {
        return '/' + TwilioRestClient.DEFAULT_VERSION + '/Accounts/'
                + this.getRequestAccountSid() + '/Calls/' + this.getSid()
                + '.json';
    }
    
    public String getSid() {
        return this.getProperty('sid');
    }
    
    public String getParentCallSid() {
        return this.getProperty('parent_call_sid');
    }

    public Datetime getDateCreated() {
        return this.getPropertyDatetime('date_created');
    }

    public Datetime getDateUpdated() {
        return this.getPropertyDatetime('date_updated');
    }

    public String getAccountSid() {
        return this.getProperty('account_sid');
    }

    public String getTo() {
        return this.getProperty('to');
    }

    public String getFrom() {
        return this.getProperty('from');
    }

    public String getPhoneNumberSid() {
        return this.getProperty('phone_number_sid');
    }

    public String getStatus() {
        return this.getProperty('status');
    }

    public Datetime getStartTime() {
        return this.getPropertyDatetime('start_time');
    }

    public Datetime getEndTime() {
        return this.getPropertyDatetime('end_time');
    }

    public Integer getDuration() {
        return this.getPropertyInteger('duration');
    }

    public Decimal getPrice() {
        return this.getPropertyDecimal('price');
    }

    public String getDirection() {
        return this.getProperty('direction');
    }

    /**
     * Gets the answered by phone number.
     */
    public String getAnsweredBy() {
        return this.getProperty('answered_by');
    }

    public String getForwardedFrom() {
        return this.getProperty('forwarded_from');
    }
    
    public String getUri() {
        return this.getProperty('uri');
    }

    public String getCallerName() {
        return this.getProperty('caller_name');
    }
    
    /*public TwilioNotificationList getNotifications() {
        TwilioNotificationList twlist = new TwilioNotificationList((TwilioRestClient)this.getClient(), this.getSid());
        twlist.setRequestAccountSid(this.getRequestAccountSid());
        return twlist;
    }
    
    public TwilioRecordingList getRecordings() {
        TwilioRecordingList twlist = new TwilioRecordingList((TwilioRestClient)this.getClient(), this.getSid());
        twlist.setRequestAccountSid(this.getRequestAccountSid());
        return twlist;
    }*/


    public Map<String,Object> getSubresourceUris() {
        return (Map<String,Object>)this.getObject('subresource_uris');
    }
    
    public TwilioCall redirect(String url, String method) {
        Map<String, String> vars = new Map<String, String>{
            'Method' => method,
            'Url' => url};
        TwilioRestResponse response = this.getClient().safeRequest(
                this.getResourceLocation(), 'POST', vars);

        TwilioCall c = new TwilioCall((TwilioRestClient)this.getClient(), response.toMap());
        c.setRequestAccountSid(this.getRequestAccountSid());
        return c;
    }
    
    public TwilioCall hangup() {
        Map<String, String> vars = new Map<String, String>();
        vars.put('Status', 'completed');

        TwilioRestResponse response = this.getClient().safeRequest(
                this.getResourceLocation(), 'POST', vars);

        TwilioCall c = new TwilioCall((TwilioRestClient)this.getClient(), response.toMap());
        c.setRequestAccountSid(this.getRequestAccountSid());
        return c;
    }

    public TwilioCall cancel() {
        Map<String, String> vars = new Map<String, String>();
        vars.put('Status', 'canceled');

        TwilioRestResponse response = this.getClient().safeRequest(
                this.getResourceLocation(), 'POST', vars);

        TwilioCall c = new TwilioCall((TwilioRestClient)this.getClient(), response.toMap());
        c.setRequestAccountSid(this.getRequestAccountSid());
        return c;
    }

    public boolean deleteCall() {
        TwilioRestResponse response = this.getClient().safeRequest(
                this.getResourceLocation(), 'DELETE', null);
        
        return !response.isError();
    }
}