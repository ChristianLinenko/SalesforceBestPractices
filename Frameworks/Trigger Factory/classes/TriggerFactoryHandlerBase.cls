public virtual class TriggerFactoryHandlerBase implements ITrigger{
	public static boolean firstRun = true;
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    
    public TriggerFactoryHandlerBase()
	{
		firstRun = true;
		BatchSize = 0;
	}
    
    public void setParameters(boolean isExecuting, integer size)
    {
        this.m_isExecuting = isExecuting;
        this.BatchSize = size;
    }
	
	public virtual Boolean GetIsExecuting() { return m_isExecuting; }
	public virtual void SetIsExecuting(Boolean bExecuting) { m_isExecuting = bExecuting; }
	
	public virtual Integer GetBatchSize() { return BatchSize; }
	public virtual void SetBatchSize(Integer bSize) { BatchSize = bSize; }
              
    public virtual void OnBeforeInsert(List<SObject> newMappings){}
    
    public virtual void OnAfterInsert(List<SObject> newMappings){}
    
    @future 
    public static void OnAfterInsertAsync(Set<ID> newMappingIDs){}
    
    public virtual void OnBeforeUpdate(List<SObject> oldMappings, List<SObject> updatedMappings, Map<ID, SObject> mappingOldMap, Map<ID, SObject> mappingNewMap){}
    
    public virtual void OnAfterUpdate(List<SObject> oldMappings, List<SObject> updatedMappings, Map<ID, SObject> mappingOldMap, Map<ID, SObject> mappingMap){}
    
    @future 
    public static void OnAfterUpdateAsync(Set<ID> updatedMappingIDs){}
    
    public virtual void OnBeforeDelete(List<SObject> MappingsToDelete, Map<ID, SObject> MappingMap){}
    
    public void OnAfterDelete(List<SObject> deletedMappings, Map<ID, SObject> MappingMap){}
    
    @future 
    public static void OnAfterDeleteAsync(Set<ID> deletedMappingIDs){}
    
    public virtual void OnUndelete(List<SObject> restoredMappings){}
    
    public virtual void BulkBefore(){}      
    
    public virtual void BulkAfter(){}       
    
    public virtual void cleanUp(){}    
    
    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    }
    
    public boolean IsVisualforcePageContext{
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsWebServiceContext{
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsExecuteAnonymousContext{
        get{ return !IsTriggerContext;}
    }
}