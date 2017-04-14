global class BatchScheduler Implements Schedulable
{
	private String batchType;
	global BatchScheduler(String type)
	{
		batchType = type;
	}

 	global void execute(SchedulableContext SC)
	{
		System.debug('batchType:' + batchType);
    BatchApexHelper.startJob(batchType);
  }
}
