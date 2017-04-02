@isTest
public with sharing class TriggerFactory_Test {
	private static testMethod void TriggerFactory_getHandler_ReturnsDefaultHandler() {
		//INSERT
		ITrigger insertHandler = TriggerFactory.getHandler(null, new List<Account>{new Account(Name='Test')});
		System.Assert(insertHandler!=NULL, 'Handler Should not be null');
		//UPDATE
		ITrigger updateHandler = TriggerFactory.getHandler(new List<Account>{new Account(Name='Test')}, new List<Account>{new Account(Name='Test')});
		System.Assert(updateHandler!=NULL, 'Handler Should not be null');
		//DELETE
		ITrigger deleteHandler = TriggerFactory.getHandler(new List<Account>{new Account(Name='Test')}, null);
		System.Assert(deleteHandler!=NULL, 'Handler Should not be null');
	}
}