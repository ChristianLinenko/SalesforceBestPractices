@isTest
private class Utilities_Test
{
    static testMethod void testRecordTypesMethods()
    {
        Map<String,RecordType> testRecordTypeMap = utilities.getRecordTypes();

        List<String> rtNames = new List<String>();
        Set<String> developerNamesSet = new Set<String>();
        for (RecordType rt:[Select Name FROM RecordType LIMIT 5]) {
            developerNamesSet.add(rt.Name);
            rtNames.add(rt.Name);
        }

        Id testRecordTypeId = utilities.recordTypeIdByDeveloperName(rtNames[0]);

        Map<String, Schema.RecordTypeInfo> recordTypeSchemaMap = Utilities.getObjectRecordTypeInfo('Account');
        System.assert(recordTypeSchemaMap.values().size() > 0, 'There should be record types for the Account object.');

        recordTypeSchemaMap = Utilities.getObjectRecordTypeInfo('BlahBlah');
        System.assert(recordTypeSchemaMap == NULL, 'There should be no record type map for the BlahBlah object.');

        Id recordTypeTest = Utilities.getRecordTypeIdByLabel('Account', 'Hotel');
        System.assert(recordTypeTest != NULL, 'There shouuld be a Hotel record type.');

        recordTypeTest = Utilities.getRecordTypeIdByLabel('Account', 'Blah Blah');
        System.assert(recordTypeTest == NULL, 'There should not be a Blah Blah record type.');

        List<RecordType> recordTypeList = Utilities.getRecordTypesList('Account');
        System.assert(recordTypeList.size() > 0, 'There should be record types for the Account object.');

        recordTypeList = Utilities.getRecordTypesList('BlahBlah');
        System.assert(recordTypeList == NULL, 'There should be no record types for the BlahBlah object.');

        Map<String, RecordType> recordTypeMap = Utilities.getRecordTypes();
        System.assert(recordTypeMap.containsKey('Hotel'), 'There should be a Hotel record type.');

        Id recordTypeId = Utilities.recordTypeIdByDeveloperName('Hotel');
        System.assert(recordTypeId != NULL, 'There should be a Hotel record type Id.');

        recordTypeId = Utilities.recordTypeIdByDeveloperName('Blah Blah');
        System.assert(recordTypeId == NULL, 'There should not be a Blah Blah record type.');
    }

    static testMethod void testGetRecordType()
    {
        RecordType rt = Utilities.GetRecordTypeByDeveloperName('Fake_Record_Type');
        //Returns null RecordType
        System.Assert(rt != null, 'rt should not be null: ' + rt);
        rt = Utilities.GetRecordTypeByDeveloperName('Generic_Case');
        System.Assert(rt != null, 'rt should not be null: ' + rt);
    }

    static testMethod void testGetRecordTypeWithObject()
    {
        RecordType rt = Utilities.GetRecordTypeByDeveloperName('Fake_Record_Type', 'Case');
        System.Assert(rt == null, 'rt should be null: ' + rt);
        rt = Utilities.GetRecordTypeByDeveloperName('Generic_Case', 'Case');
        System.Assert(rt != null, 'rt should not be null: ' + rt);
    }
}
