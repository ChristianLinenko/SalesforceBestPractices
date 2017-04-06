/* the DEFAULT test data generator; all other test data generator type inherit from this base class */
public virtual class TestDataGenerator implements ITestDataGenerator { 

	public TestDataGenerator() {}
	
    public virtual List<sObject> createObjects(Schema.SObjectType targetType, Integer numberOfRecords, String recordTypeDeveloperName) {

        createDependentObjects();
        setSeedValues();
               
        List<sObject> sObjectList = new List<sObject>();
        Boolean isNameWriteable = targetType.getDescribe().fields.getMap().get('Name') != NULL ? targetType.getDescribe().fields.getMap().get('Name').getDescribe().isUpdateable() : FALSE;
            
            // TO DO: make this generic class smarter, by creating some sample data that can be used to fill in required fields; 
            // for now, such requirements must be handled with specific generator for the object. 
        Id recordTypeId = recordTypeDeveloperName == NULL ? NULL : utilities.recordTypeIdByDeveloperName(recordTypeDeveloperName);
            
        for (Integer i = 0;i < numberOfRecords;i++) {            
            sObject testSObject = targetType.newSObject();
            if (isNameWriteable) {
                testSObject.put('Name','Test sObject ' + i);
            }
            if (recordTypeId != NULL && String.valueOf(recordTypeId).length() > 4) {
                testSObject.put('RecordTypeId',recordTypeId);
            }         
            sObjectList.add(testSObject);
        }    
        return sObjectList; 
    
    }

// fulfilling interface requirements - in the default factory, we don't have seed values or dependencies

    public virtual void createDependentObjects() {
        // this is empty in the generic version, as it will only be used when there is not a specific factory

    }
    
    public virtual void setSeedValues() {
        // this is empty in the generic version, as it will only be used when there is not a specific factory
    }
    
    public Id getRecordTypeId(String recordTypeDeveloperName) {
        Id recordTypeId = recordTypeDeveloperName == NULL ? NULL : utilities.recordTypeIdByDeveloperName(recordTypeDeveloperName);   
        return recordTypeId;
    }
	
	public virtual void AfterInsert() {
	}
    
}