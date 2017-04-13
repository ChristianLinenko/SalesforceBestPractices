public abstract class TwilioResource
{

    private TwilioClient client;

    private String requestAccountSid;

    protected Map<String, String> filters;

    public TwilioResource(TwilioClient client) {
        this.client = client;
    }
    
    protected TwilioClient getClient() {
        return this.client;
    }
    
    protected String getRequestAccountSid() {
        return this.requestAccountSid;
    }

    public void setRequestAccountSid(String sid) {
        this.requestAccountSid = sid;
    }
    
    
    protected void load(Map<String, String> params) {
        String path = this.getResourceLocation();
        TwilioRestResponse response = this.getClient().safeRequest(path, 'GET', params);
        this.parseResponse(response);
        this.loaded = true;
    }
    
    // flags whether or not the HTTP request to popluate
    // this data has occured. We can construct resources
    // that are lazily loaded
    private Boolean loaded = false;

    protected boolean isLoaded() {
        return loaded;
    }
    
    protected void setLoaded(boolean loaded) {
        this.loaded = loaded;
    }
    
    protected abstract String getResourceLocation();
    
    protected abstract void parseResponse(TwilioRestResponse response);

    public abstract class InstanceResource extends TwilioResource {
        
        private Map<String, Object> properties;
    
        private Map<String, String> params;

        public InstanceResource(TwilioClient client) {
            super(client);
            this.properties = new Map<String, Object>();
            this.params = new Map<String, String>();
        }
    
        public InstanceResource(TwilioClient client,
                Map<String, Object> properties) {
            super(client);
            this.properties = new Map<String, Object>(properties);
            this.params = new Map<String, String>();
            this.setLoaded(true);
        }

        public InstanceResource(TwilioClient client, Map<String, String> params) {
            super(client);
            this.properties = new Map<String, Object>();
            this.params = new Map<String, String>(params);
        }

        public String getProperty(String name) {
            Object prop = properties.get(name);
    
            if (prop == null && !this.isLoaded()) {
                this.load(params);
            }
    
            prop = properties.get(name);
    
            if (prop == null) {
                return null;
            }
    
            if (prop instanceof String) {
                return (String) prop;
            }
    
            throw new TwilioRestException('Property ' + name
                    + ' is an object.  Use getObject() instead.');
        }
        
        protected Decimal getPropertyDecimal(String name) {
            String prop = getProperty(name);
            if (prop==null) {
                return null;
            }
            return Decimal.valueOf(prop);
        }
        
        protected Integer getPropertyInteger(String name) {
            String prop = getProperty(name);
            if (prop==null) {
                return null;
            }
            return Integer.valueOf(prop);
        }
        
        protected Datetime getPropertyDatetime(String name) {
            string gmtDT = getProperty(name);
            return TwilioParser.parseDatetime(getProperty(name));
        }

        protected Datetime getPropertyISODatetime(String name) {
            DateTime dt = (DateTime) JSON.deserialize('"' + getProperty(name) + '"', DateTime.class);
            return DateTime.newInstance( dt.getTime());
        }

        protected Boolean getPropertyBoolean(String name) {
            String prop = getProperty(name);
            if (prop==null) {
                return null;
            }
            return Boolean.valueOf(prop);
        }
    
        protected Object getObject(String name) {
            Object prop = properties.get(name);
            if (prop == null && !this.isLoaded()) {
                this.load(params);
            }

            prop = properties.get(name);
            
            if (prop == null) {
                throw new TwilioRestException('Property ' + name
                        + ' does not exist');
            }
            return prop;
        }
        
        protected List<String> getStringList(String name) {
            List<String> s = new List<String>();
            for(Object o : (List<Object>)this.getObject(name)) {
                s.add(string.valueof(o));
            } 
            return s;
        }
        
        protected void setProperty(String name, String value) {
            properties.put(name, value);
        }
        
        protected String uri {
            get {
                return this.getProperty('uri');
            }
        }
        
        public void updateResource(Map<String, String> params) {
            this.getClient().safeRequest(this.getResourceLocation(), 'POST', params);
        }
        
        public void updateResource(List<TwilioNameValuePair> params)
        {
            this.getClient().safeRequestPair(this.getResourceLocation(), 'POST',params);   
        }
        protected override void parseResponse(TwilioRestResponse response) {
            Map<String, Object> properties = response.toMap();
            this.properties = new Map<String, Object>(properties);
        }
    }
    

    public abstract class TwilioListResource extends TwilioResource {

        public List<Object> pageData;

        public TwilioListResource(TwilioClient client) {
            this(client, new Map<String, String>());
        }
    
        public TwilioListResource(TwilioClient client, Map<String, String> filters) {
            super(client);
            this.filters = filters;
        }

        public abstract Integer getPage();
    
        public abstract boolean hasNextPage();
    
        public abstract void fetchNextPage();
        
        public abstract boolean hasPrevPage();
    
        public abstract void fetchPrevPage();

        private Integer getIntValue(Object data) {
            if (data instanceof Integer) {
                return (Integer) data;
            }
            if (data instanceof String) {
                return Integer.valueOf((String) data);
            }
    
            return -1;
        }
        
        protected List<Object> toList(TwilioRestResponse response) {
            List<Object> returnList = new List<Object>();
    
            // Right now only json responses are used
            Map<String, Object> m = response.toMap();
    
            if (m.get(this.getListKey()) instanceof List<Object>) {
                List<Object> objs = (List<Object>) m.get(this.getListKey());
                system.debug(m+'----------------------------'+this.getListKey());
                for (Object o : objs) {
                    if (o instanceof Map<String,Object>) {
                        Object instance = this.makeNew(this.getClient(),
                                (Map<String, Object>) o);
                        returnList.add(instance);
                    }
                }
            }
            return returnList;
        }
        
        public Object createInstance(Map<String, String> params) {
            TwilioRestResponse response = this.getClient().safeRequest(
                    this.getResourceLocation(), 'POST', params);
            return makeNew(this.getClient(), response.toMap());
        }
        
        public Object createInstance(List<TwilioNameValuePair> params) {
                TwilioRestResponse response = this.getClient().safeRequestPair(
                                this.getResourceLocation(), 'POST', params);
                return makeNew(this.getClient(), response.toMap());
        }
    
        public List<Object> getObjectPageData() {
            if (!this.isLoaded()) {
                this.load(this.filters);
            }
            
            return this.pageData;
        }
        
        /**
         * Returns the string key for finding this list of objects in the response.
         * For example:
         * 
         * <TwilioResponse> <Accounts> <Account> </Account> <Account> </Account>
         * </Accounts> </TwilioResponse>
         * 
         * this should return "Accounts"
         * 
         * @return the string key for finding this list objects in the response
         */
        protected abstract String getListKey();
        
        protected abstract Object makeNew(TwilioClient client,
                Map<String, Object> params);
    }

    public abstract class ListResource extends TwilioListResource {
        private final String PREV_PAGE_URI_KEY_JSON = 'previous_page_uri';      
        private final String NEXT_PAGE_URI_KEY_JSON = 'next_page_uri';
        private final String START_KEY_JSON = 'start';
        private final String END_KEY_JSON = 'end';
        private final String PAGE_KEY_JSON = 'page';
        
        private String prevUri = null;

        private String nextUri = null;
        
        private Integer startIx = 0;
        
        private Integer endIx = 0;
        
        private Integer page = 0;
                
        public ListResource(TwilioClient client) {
            this(client, new Map<String, String>());
        }
    
        public ListResource(TwilioClient client, Map<String, String> filters) {
            super(client);
            this.filters = filters;
        }
        
        public String getNextUri() {
            return nextUri;
        }
    
        public Integer getStart() {
            return startIx;
        }
    
        public Integer getEnd() {
            return endIx;
        }
    
        public override Integer getPage() {
            return page;
        }
    
        public override boolean hasNextPage() {
            return nextUri != null && this.nextUri.length() > 0;
        }

        public override boolean hasPrevPage() {
            return prevUri != null && this.prevUri.length() > 0;
        }

        public override void fetchNextPage() {
            // Fetch the next page and reset accounts
            TwilioRestResponse response = this.getClient().get(nextUri);
            this.parseResponse(response);
        }

        public override void fetchPrevPage() {
            // Fetch the next page and reset accounts
            TwilioRestResponse response = this.getClient().get(prevUri);
            this.parseResponse(response);
        }

        protected override void parseResponse(TwilioRestResponse response) {
            this.nextUri = null;
            // Setup paging
            Map<String, Object> data = response.toMap();
            this.nextUri = (String) data.get(NEXT_PAGE_URI_KEY_JSON);
            this.prevUri = (String) data.get(PREV_PAGE_URI_KEY_JSON);       
            this.startIx = this.getIntValue(data.get(START_KEY_JSON));
            this.endIx = this.getIntValue(data.get(END_KEY_JSON));
            this.page = this.getIntValue(data.get(PAGE_KEY_JSON));
    
            // Setup data
            this.pageData = this.toList(response);
        }
    }

    public abstract class NextGenListResource extends TwilioListResource {      
        private final String FIRST_PAGE_URL_JSON = 'first_page_url';
        private final String NEXT_PAGE_URL_JSON = 'next_page_url';
        private final String PREV_PAGE_URL_JSON = 'previous_page_url';
        private final String PAGE_JSON = 'page';
        private final String PAGE_SIZE_JSON = 'page_size';
        private final String URL_JSON = 'url';
        private final String KEY_JSON = 'key';

        private String firstUrl = null;

        private String nextUrl = null;

        private String prevUrl = null;
        
        private Integer page = 0;
        
        private Integer pageSize = 0;
        
        private String pageUrl = null;

        private String key = null;
        
        public NextGenListResource(TwilioClient client) {
            this(client, new Map<String, String>());
        }
    
        public NextGenListResource(TwilioClient client, Map<String, String> filters) {
            super(client);
            this.filters = filters;
        }
        
        public String getNextUrl() {
            return nextUrl;
        }
    
        public override Integer getPage() {
            return page;
        }
    
        public override boolean hasNextPage() {
            return nextUrl != null && this.nextUrl.length() > 0;
        }
    
        public override void fetchNextPage() {
            // Fetch the next page and reset accounts
            TwilioRestResponse response = this.getClient().get(nextUrl);
            this.parseResponse(response);
        }

        public override boolean hasPrevPage() {
            return prevUrl != null && this.prevUrl.length() > 0;
        }
    
        public override void fetchPrevPage() {
            // Fetch the next page and reset accounts
            TwilioRestResponse response = this.getClient().get(prevUrl);
            this.parseResponse(response);
        }

        protected override void parseResponse(TwilioRestResponse response) {
            this.nextUrl = null;

            // Setup paging
            Map<String, Object> data = response.toMap();
            Map<String, Object>  meta = (Map<String, Object>) data.get('meta');             
            this.firstUrl = (String) meta.get(FIRST_PAGE_URL_JSON);         
            this.nextUrl = (String) meta.get(NEXT_PAGE_URL_JSON);
            this.prevUrl = (String) meta.get(PREV_PAGE_URL_JSON);
            this.page = this.getIntValue(meta.get(PAGE_JSON));
            this.pageSize = this.getIntValue(meta.get(PAGE_SIZE_JSON));
            this.pageUrl = (String) meta.get(URL_JSON);
            this.key = (String) meta.get(KEY_JSON);
            // Setup data
            this.pageData = this.toList(response);
        }
    }
}