trigger FlowsTrackerTrigger on Flows_Tracker__c (after update) 
{
	FlowsTrackerHandler objFlowsTrackerHandler = new FlowsTrackerHandler();
	if(trigger.isAfter && trigger.isUpdate)
	{
		objFlowsTrackerHandler.onAfterUpdateCreateNextFlowTracker(trigger.newMap, trigger.oldMap);
	}
}