@isTest
private class TestDataFactoryTest {

    static testMethod void testCustomGenerators() {

    // because the framework depends on reliable custom generators, we test them even though they are test classes and don't require coverage
    // As long as your class follows the naming convention of object name with no '_' or '__c' + 'TestDataGenerator', it will be tested by this method
        Set<String> generatorNames = new Set<String>();
        for (ApexClass ac:[SELECT Id, Name FROM ApexClass WHERE Name Like '%_TDG' AND Name != 'ITestDataGenerator' AND Name != 'TestDataGenerator']) {
            generatorNames.add(ac.Name.toLowerCase());
        }

        String[] specificGenerators = new String[]{};
        integer maxGeneratorSize = 10;
        integer i = 0;
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        for (String objectName:gd.KeySet()) {
        	if(i>=maxGeneratorSize) break;
            if (objectName == 'AssignmentRule') continue; // HACK for now, need to figure out how best to handle custom/standard object naming overlap
            String className = objectName.toLowerCase().replace('__c','').replace('_','') + '_tdg';
            if (generatorNames.contains(className)) {
                specificGenerators.add(objectName);
            }
            i++;
        }

    // try each generator out, and see that it produces the correct number of results
        for (String objectName:specificGenerators) {
        	System.debug('Testing the ' + objectName + ' Test Data Generator');
            List<SObject> testRecords = TestDataFactory.createRecords(objectName,10);
            System.assertEquals(testRecords.size(),10);
        }

    }

    static testMethod void testDefaultGeneratorBehavior() {

        Schema.SObjectType acctType = Schema.getGlobalDescribe().get('Account');
        TestDataGenerator generator = new TestDataGenerator();
        List<SObject> genericGeneratorObjects = generator.createObjects(acctType,10,NULL);
        System.assertEquals(genericGeneratorObjects.size(),10);

    }

    static testMethod void testObjectCreationByRecordType() {

        List<SObject> testRecords = TestDataFactory.createRecords('Account',10,TRUE,'AccountHotelLead',NULL);
        // this needs to be customized per org
    }

    static testMethod void testObjectCreationWithFieldMap() {

        Map<String,Object> testFieldValueMap = new Map<String,Object>();
        testFieldValueMap.put('Number_of_rooms__c',100);
        List<SObject> testAccounts = TestDataFactory.createRecords('Account',10,TRUE,'AccountHotelLead',testFieldValueMap);
        System.assertEquals(100,testAccounts[0].get('Number_of_rooms__c'));

    }

    static testMethod void testSmartFactory() {
        List<SObject> testRecords = TestDataFactory.createRecords('Contact',10);
        System.assertEquals(testRecords.size(),10);
    }


}
