global class TwilioAvailablePhoneNumber extends TwilioResource.InstanceResource {

    public TwilioAvailablePhoneNumber(TwilioRestClient client) {
        super(client);
    }

    public TwilioAvailablePhoneNumber(TwilioRestClient client, Map<String, Object> properties) {
        super(client, properties);
    }

    public override String getResourceLocation() {
        throw new TwilioRestException('AvailablePhoneNumbers do not have an instance resource location');
    }

    public String getFriendlyName() {
        return this.getProperty('friendly_name');
    }
    
    public String getPhoneNumber() {
        return this.getProperty('phone_number');
    }
    
    public String getLata() {
        return this.getProperty('lata');
    }
    
    public String getRateCenter() {
        return this.getProperty('rate_center');
    }
    
    public String getLatitude() {
        return this.getProperty('latitude');
    }
    
    public String getLongitude() {
        return this.getProperty('longitude');
    }
    
    public String getRegion() {
        return this.getProperty('region');
    }
    
    public String getPostalCode() {
        return this.getProperty('postal_code');
    }
    
    public String getIsoCountry() {
        return this.getProperty('iso_country');
    }

    public map<string,object> getCapabilities() {
        return (Map<String,Object>)this.getObject('capabilities');
    }

    public boolean getBeta() {
        return this.getPropertyBoolean('beta');
    }

    public String getAddressRequirements() {
        return this.getProperty('address_requirements');
    }

    private boolean purchased = false;
    
    public TwilioIncomingPhoneNumber purchase() {
        if (this.purchased) {
            throw new AlreadyPurchasedException('You have already purchased this number: '+getPhoneNumber());
        }
        Map<String,String> props = new Map<String,String>();
        props.put('PhoneNumber', getPhoneNumber());
        
        TwilioAccount requestAccount = ((TwilioRestClient)getClient()).getAccount(getRequestAccountSid());
        TwilioIncomingPhoneNumber incoming = requestAccount.getIncomingPhoneNumbers().create(props);
        this.purchased = true;
        return incoming;
    }
    
    private class AlreadyPurchasedException extends Exception {}
}