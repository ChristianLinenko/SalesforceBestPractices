/* This state is specifically for the purpose of passing a list of sobjects through a flow, as the 
base state class only controls the passing of the steps state, but not the data to be passed in those steps */
public with sharing class SObjectFlowState extends FlowFactory.FlowState 
{
   public List<SObject> flowSobjects {get; private set;}
   
   public SObjectFlowState(List<SObject> flowSobjects) 
   {
      this.flowSobjects = flowSobjects; 
   }

}