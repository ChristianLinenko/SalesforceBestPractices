public class TwilioRestException extends Exception {

    @TestVisible private Integer errorCode;
    
    @TestVisible private String message;
    
    @TestVisible private String moreInfo;
    
    @TestVisible private Integer status;

    public TwilioRestException(String message, Integer errorCode) {
        this(message, errorCode, null);
    }

    public TwilioRestException(String message, Integer errorCode, String moreInfo) {
        this.message = message;
        this.errorCode = errorCode;
        this.moreInfo = moreInfo;
    }

    public override String getMessage() {
        return  this.message;
    }

    public String getMoreInfo() {
        return this.moreInfo;
    }

    public String getErrorCode() {
        return String.valueOf(this.errorCode);
    }

    public TwilioRestException(TwilioRestResponse response) {
        Map<String, Object> data = response.toMap();
        String message = '';
        String moreInfo = null;
        Integer errorCode = null;
        if (response.isJson()) {
            message = (String) data.get('message');
            
            if (data.get('code') != null) {
                errorCode = Integer.valueOf(data.get('code'));
            }
            if (data.get('more_info') != null) {
                moreInfo = (String) data.get('more_info');
            }
            if (data.get('status') != null) {
                status = Integer.valueOf(data.get('status'));
            }
            this.setMessage(message + ' more info: ' + moreInfo);
        }
        else if (response.isXML()) {
            // TODO add XML support some day
        }
        
        this.message = message;
        this.errorCode = errorCode;
        this.moreInfo = moreInfo;
    }
}