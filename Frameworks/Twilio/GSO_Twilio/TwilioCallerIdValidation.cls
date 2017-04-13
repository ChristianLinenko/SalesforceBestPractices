global class TwilioCallerIdValidation {

    private Map<String, Object> properties;
    
    private boolean jsonKeys = true;
    
    public TwilioCallerIdValidation(TwilioRestResponse response) {
        this.properties = new Map<String, Object>(response.toMap());
        this.jsonKeys = response.isJson();
    }
    
    public String getAccountSid() {
        if (this.jsonKeys) {
            return getProperty('account_sid');
        }
        return getProperty('AccountSid');
    }
    
    public String getValidationCode() {
        //TODO better parsing here
        if (this.jsonKeys) {
            return getProperty('validation_code');
        }
        
        return getProperty('ValidationCode');
    }
    
    public String getPhoneNumber() {
        //TODO better parsing here
        if (this.jsonKeys) {
            return getProperty('phone_number');
        }
        
        return getProperty('PhoneNumber');
    }
    
    public String getFriendlyName() {
        if (this.jsonKeys) {
            return getProperty('friendly_name');
        }
        
        return getProperty('FriendlyName');
    }
    
    public String getProperty(String name) {
        Object prop = properties.get(name);
        prop = properties.get(name);

        if (prop == null) {
            throw new IllegalArgumentException('Property ' + name
                    + ' does not exist');
        }

        if (prop instanceof String) {
            return (String) prop;
        }

        throw new IllegalArgumentException('Property ' + name
                + ' is an object.  Use getOjbect() instead.');
    }
    
    public class IllegalArgumentException extends Exception {}
}