public with sharing class FlowFactory 
{
	// State Parent
	public virtual class FlowState
	{
		public List<Step> steps {get; set;}
		public FlowState()
		{
			this.steps = new List<Step>();
		}
	}

	// Flow Parent
	public virtual class FlowParent
	{
		protected void processSteps(Step step, FlowState state)
		{
			Boolean keepGoing = true;
			while(keepGoing)
			{
				step = step.processStep(state);
				if(step == null) 
					keepGoing = false;
			}

			for(Step s : state.steps) 
			{
				s.finish();
				s.finish(state);
			}
		}
	}
	
	// Step Parent
	public virtual class Step
	{
		protected Step nextStep {get; set;}
		public String stepName {get; set;}

		// Create next step 
		protected Step createInstance(String className)
		{
	        Type t = Type.forName(className);
	        this.nextStep = (Step) t.newInstance();
	        this.nextStep.stepName = className;
	        return this.nextStep;
		}
		// Step children override with unique processing
		public virtual Step processStep(FlowState fs){return null;}
		public virtual void finish(){}
		public virtual void finish(FlowState fs){}
	}
}