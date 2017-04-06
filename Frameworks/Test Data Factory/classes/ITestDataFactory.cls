public virtual interface ITestDataFactory {

    List<sObject> createRecords(String sobjectName, Integer numberOfRecords, Boolean insertOrNot, Map<String,Object> fieldValueMap);

    sObject createRecord(String sobjectName);
    
    void insertRecords(List<SObject> sobjects);

    List<sObject> createRecords(String sobjectName, Integer numberOfRecords);

    ITestDataGenerator getGenerator(String sobjectName);
    
}