public interface ITrigger {
	
	void BulkBefore();
	
	void BulkAfter();
	
	void OnBeforeInsert(List<SObject> soNew);
		
	void OnBeforeUpdate(List<SObject> soOld, List<Sobject> soNew, Map<ID, SObject> soOldMap, Map<ID, SObject> soNewMap);
	
	void OnBeforeDelete(List<SObject> soOld, Map<ID, SObject> soOldMap);
	
	void OnAfterInsert(List<SObject> soNew); 
	
	void OnAfterUpdate(List<SObject> soOld, List<Sobject> soNew, Map<ID, SObject> soOldMap, Map<ID, SObject> soNewMap); 
	
	void OnAfterDelete(List<SObject> soOld, Map<ID, SObject> soOldMap); 
	
	void OnUnDelete(List<SObject> soNew);
	
	void cleanUp(); 
	
	void setParameters(boolean isExecuting, integer size);
}