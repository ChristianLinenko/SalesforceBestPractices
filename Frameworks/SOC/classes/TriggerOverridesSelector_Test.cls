@IsTest
private with sharing class TriggerOverridesSelector_Test 
{
	private static String OBJECT_NAME = 'Account';

    @IsTest
    private static void testKillSwitchEnabled()
    {
        //arrange
        
        Trigger_Overrides__c t = new Trigger_Overrides__c(
            Name = OBJECT_NAME + '_Enabled',
            Trigger_Enabled__c = true
        );
        insert t;
        TriggerOverridesSelector tos = new TriggerOverridesSelector();
        
        //act
        Test.startTest();
        Boolean bypassTrigger = tos.bypassTrigger(OBJECT_NAME);
        Test.stopTest();

        //assert
        System.assert(!bypassTrigger, 'bypassTrigger should false: ' + bypassTrigger);
    }

    @IsTest
    private static void testKillSwitchDisabled()
    {
        //arrange
        
        Trigger_Overrides__c t = new Trigger_Overrides__c(
            Name = OBJECT_NAME + '_Enabled',
            Trigger_Enabled__c = false
        );
        insert t;
        TriggerOverridesSelector tos = new TriggerOverridesSelector();
        
        //act
        Test.startTest();
        Boolean bypassTrigger = tos.bypassTrigger(OBJECT_NAME);
        Test.stopTest();

        //assert
        System.assert(bypassTrigger, 'bypassTrigger should true: ' + bypassTrigger);
    }

    @IsTest
    private static void testKillSwitchRecordNotFound()
    {
        //arrange
        TriggerOverridesSelector tos = new TriggerOverridesSelector();
        
        //act
        Test.startTest();
        Boolean bypassTrigger = tos.bypassTrigger(OBJECT_NAME);
        Test.stopTest();

        //assert
        System.assert(!bypassTrigger, 'bypassTrigger should false: ' + bypassTrigger);
    }

    @IsTest
    private static void testMasterKillSwitch()
    {
        //arrange
        
        Trigger_Overrides__c t = new Trigger_Overrides__c(
            Name = 'AllTriggers_Enabled',
            Trigger_Enabled__c = true
        );
        insert t;
        TriggerOverridesSelector tos = new TriggerOverridesSelector();
        
        //act
        Test.startTest();
        Boolean bypassTrigger = tos.bypassTrigger(OBJECT_NAME);
        Test.stopTest();

        //assert
        System.assert(!bypassTrigger, 'bypassTrigger should false: ' + bypassTrigger);
    }

    @IsTest
    private static void testKillSwitchNull()
    {
        //arrange
        TriggerOverridesSelector tos = new TriggerOverridesSelector();
        
        //act
        Test.startTest();
        Boolean bypassTrigger = tos.bypassTrigger(null);
        Test.stopTest();

        //assert
        System.assert(!bypassTrigger, 'bypassTrigger should false: ' + bypassTrigger);
    }
}