public virtual interface ITestDataGenerator {

    // note:
    // the number of records exists at the generator level so that dependent objects can be shared across created records,
    // rather than initialized with every creation of a new object;
    // record type is passed in so that it can be used in tailoring object creation by record type at the generator level
    List<sObject> createObjects(Schema.SObjectType targetType, Integer numberOfRecords, String recordTypeDeveloperName);
        
    void createDependentObjects();
    
    void setSeedValues();
	void AfterInsert();
}