/* the account test data generator */
@isTest
public class Account_TDG extends TestDataGenerator
{
    // This is a singleton; getInstance enforces the creation of this class only one time during a test, so we don't hit duplicate value issues on the seed values
    private static Account_TDG instance = null;
    private static Integer uniqueVal;
    //private static Custom_Object__c customObj = null;

    private Account_TDG()
    {
        setSeedValues();
    }

    public static Account_TDG getInstance()
    {
        if(instance == null) instance = new Account_TDG();
        return instance;
    }

    public override List<sObject> createObjects(Schema.SObjectType targetType, Integer numberOfRecords, String recordTypeDeveloperName)
    {

        createDependentObjects();

        List<sObject> sObjectList = new List<sObject>();

        Id recordTypeId = recordTypeDeveloperName == NULL ? NULL : Utilities.GetRecordTypeByDeveloperName(recordTypeDeveloperName, 'Account').Id;

        for (Integer i = 0;i < numberOfRecords;i++) {
            sObject testSObject = targetType.newSObject();
            if (recordTypeId != NULL && String.valueOf(recordTypeId).length() > 4) {
                testSObject.put('RecordTypeId',recordTypeId);
            }
            testSObject.put('Name','Test Account ' + i);
            //testSObject.put('Unique_Field__c', uniqueVal);
            //testSObject.put('Custom_Object_Lookup__c', customObj.Id);
            sObjectList.add(testSObject);
            uniqueVal++;
        }
        return sObjectList;
    }

    public override void createDependentObjects()
    {
        // add custom object relations here
        //customObj = (Custom_Object__c)TestDataFactory.createRecord('Custom_Object__c');
    }

    public override void setSeedValues()
    {
        uniqueVal = 1111111;
    }

    public override void AfterInsert() {}
}
