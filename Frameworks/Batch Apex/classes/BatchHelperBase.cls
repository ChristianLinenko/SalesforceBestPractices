// this class is designed to make it easier for developers to create and schedule batch apex.
// All of this funnels through batchapexhelpers which acts as a factory
// All derived classes should follow the naming convention BatchNameBatchHelper (ie: CustomBatchHelper)
public virtual class BatchHelperBase implements IBatchHelper
{
	public BatchHelperBase() { }

	public virtual Id startJob(Integer jobSpace) { return null; }
	public virtual Boolean shouldIRun() { return null; }
	public virtual Integer batchSize() { return 200; }
}
