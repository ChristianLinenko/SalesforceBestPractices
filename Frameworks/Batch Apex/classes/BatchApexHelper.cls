public with sharing class BatchApexHelper
{
	private static final Integer maxAsyncSize = 5;
	private static Integer jobSpace = 0;

	private static void GatherData()
	{

		Integer count = [SELECT COUNT()
							FROM AsyncApexJob
							WHERE Status IN ('Queued', 'Preparing', 'Processing')
								AND JobType = 'BatchApex'
							LIMIT 1];

		jobSpace = maxAsyncSize - count;
	}

	public static IBatchHelper getBatchHelper(String batchHelperName)
	{
		IBatchHelper batchHelper = null;
    	Type t = Type.forName(batchHelperName + (batchHelperName.containsIgnoreCase('BatchHelper') ? '' : 'BatchHelper'));
        if (t == null) {
            //create instance of the default class
            t = Type.forName('BatchHelperBase');
        }
        batchHelper = (IBatchHelper)t.newInstance();
        return batchHelper;
	}

	public static void startJob(String batchHelperName)
	{
		IBatchHelper batchHelper = getBatchHelper(batchHelperName);
		GatherData();
		batchHelper.startJob(jobSpace);
	}

	public static void continueJob(String batchName)
	{
		Map<String, Batch_Apex_Governors__c> batchGovernors = Batch_Apex_Governors__c.GetAll();
		if(batchGovernors.get(batchName) != null && batchGovernors.get(batchName).Chain_Together_Batches__c == true)
			startJob(batchGovernors.get(batchName).Helper_Name__c);
	}
}
