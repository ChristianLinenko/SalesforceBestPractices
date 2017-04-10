public without sharing class TriggerOverridesSelector  extends SObjectSelector {

	List<Schema.SObjectField> getSObjectFieldList()
	{
		return new List<Schema.SObjectField> {
			Trigger_Overrides__c.Id
		};
	}	

	Schema.SObjectType getSObjectType()
	{
		return Trigger_Overrides__c.sObjectType;
	}

	public List<Trigger_Overrides__c> selectById(Set<Id> idSet)
	{
		return (List<Trigger_Overrides__c>) selectSObjectsById(idSet);
	}

	public Boolean bypassTrigger(String objectName)
	{
		// this method checks the Trigger_Overrides__c custom setting and returns true
		// if the 'AllTriggers_Enabled' record is not null and Trigger_Enabled__c is false OR
		// if the objectName record is not null and Trigger_Enabled__c is false
		// method assumes you have stripped all underscores and __c from the string
		Map<String, Trigger_Overrides__c> configs = Trigger_Overrides__c.getAll();
		Trigger_Overrides__c masterSwitch = configs.get('AllTriggers_Enabled');
		Trigger_Overrides__c objSwitch = configs.get(objectName + '_Enabled');
		return (masterSwitch != null && !masterSwitch.Trigger_Enabled__c) || (objSwitch != null && !objSwitch.Trigger_Enabled__c);
	}
}