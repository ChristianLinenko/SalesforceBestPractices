@isTest
public class TestDataFactory implements ITestDataFactory
{
    private static Set<String> objectNames = null;
/* DEVELOPER NOTES

        - Syntax: (ObjectName)TestDataFactory.createRecords(ObjectName, NumberOfRecords, InsertOrNot, RecordTypeDeveloperName);
                  (ObjectName)TestDataFactory.createRecords(ObjectName, NumberOfRecords);
                  (ObjectName)TestDataFactory.createRecord(ObjectName, InsertOrNot);
                  (ObjectName)TestDataFactory.createRecord(ObjectName);
        - Usage examples:

            TestDataFactory.createRecords('Account',10);
            TestDataFactory.createRecords('Custom_Object__c',10, FALSE, NULL);

        - IF YOU ADD A CUSTOM GENERATOR:
            - follow the naming convention of CamelCase object name with no "_", no "__c", + "TDG"
               (e.g. "MyObject_TDG"), and you will get test coverage and the factory will pick it up and use it.
               Otherwise SmartFactory will be used.
            - Annotate your generator with @isTest at the top
            - Register your generator by adding it to the getGenerator method.
                (NOTE: you may need to change the syntax depending on whether or not your generator is a singleton)

        TO DO:
            // if there is no specific generator, we are using the modified SmartFactory to create the records
            // WITHOUT the field population option, as with many objects it will cause unique index errors or other problems
            // TO DO: tune SmartFactory to act more like the default generator, but with more seed value and unique index constraint considerations

*/

    public static ITestDataGenerator getGenerator(String sobjectName)
    {
        //TODO, find a way to get rid of big if/else statement below
        if (sobjectName == 'Account') { return Account_TDG.getInstance(); }
        return new TestDataGenerator(); // else go with the default */
    }

    public static List<sObject> createRecords(String sobjectName, Integer numberOfRecords, Boolean insertOrNot, String RecordTypeDeveloperName, Map<String,Object> fieldValueMap)
    {
    List<SObject> testSObjects = new List<SObject>();
        if (Schema.getGlobalDescribe().get(sobjectName) != NULL) {
            System.debug('Creating ' + numberOfRecords + ' records of type ' + sobjectName);
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sobjectName);
            String objectNameModified = sobjectName.toLowerCase().replace('__c','').replace('_','') + '_tdg';
            if (customGeneratorObjectNames().contains(objectNameModified)) {
                ITestDataGenerator generator = getGenerator(sobjectName);
                testSObjects = generator.createObjects(targetType,numberOfRecords,RecordTypeDeveloperName);
            } else {
                for (Integer i = 0; i < numberOfRecords; i++) {
                    sObject testsObject = SmartFactory.createSObject(sobjectName,false);
                    testSObjects.add(testsObject);
                }
            }

            if (fieldValueMap != NULL && fieldValueMap.size() > 0) {
                for (SObject s:testSObjects) {
                    for (String fieldName:fieldValueMap.keySet()) {
                       s.put(fieldName,fieldValueMap.get(fieldName));
                    }
                }
            }

            if (insertOrNot && testSObjects != NULL && testSObjects.size() > 0) {
                insertRecords(testSObjects);
                ITestDataGenerator generator = getGenerator(sobjectName);
                generator.AfterInsert();
            }
        }
        return testSObjects;

    }

    private static Set<String> customGeneratorObjectNames()
    {
        if(objectNames == null)
        {
            objectNames = new Set<String>();
            for (ApexClass ac:[SELECT Id, Name FROM ApexClass WHERE Name Like '%TDG' AND Name != 'ITestDataGenerator' AND Name != 'TestDataGenerator']) {
                objectNames.add(ac.Name.toLowerCase());
            }
        }
        return objectNames;
    }

    public static void insertRecords(List<SObject> sObjects) 
    {
        try {
            insert sObjects;
        } catch (System.DMLException e) {
            throw e;
        }
    }

    public static sObject createRecord(String sobjectName) {
        return createRecords(sObjectName, 1, TRUE, NULL, NULL)[0];
    }

    public static sObject createRecord(String sobjectName, Boolean insertOrNot) {
        return createRecords(sObjectName, 1, insertOrNot, NULL, NULL)[0];
    }

    public static sObject createRecord(String sobjectName, Boolean insertOrNot,Map<String,Object> fieldValueMap) {
        return createRecords(sObjectName, 1, insertOrNot, NULL, fieldValueMap)[0];
    }

    public static sObject createRecord(String sobjectName, Boolean insertOrNot,String recordTypeDeveloperName) {
        return createRecords(sObjectName, 1, insertOrNot, recordTypeDeveloperName, NULL)[0];
    }

    public static sObject createRecord(String sobjectName,String recordTypeDeveloperName) {
        return createRecords(sObjectName, 1, TRUE, RecordTypeDeveloperName, NULL)[0];
    }

    public static List<sObject> createRecords(String sobjectName, Integer numberOfRecords) {
        return createRecords(sObjectName, numberOfRecords, TRUE, NULL, NULL);
    }

    public static List<sObject> createRecords(String sobjectName, Integer numberOfRecords, Boolean insertOrNot, String recordTypeDeveloperName) {
        return createRecords(sObjectName, numberOfRecords, insertOrNot, recordTypeDeveloperName, NULL);
    }

    public static List<sObject> createRecords(String sobjectName, Integer numberOfRecords, Boolean insertOrNot) {
        return createRecords(sObjectName, numberOfRecords, insertOrNot, NULL, NULL);
    }

    public static List<sObject> createRecords(String sobjectName, Integer numberOfRecords, Boolean insertOrNot, Map<String,Object> fieldValueMap) {
        return createRecords(sObjectName, numberOfRecords, insertOrNot, NULL, fieldValueMap);
    }

}
