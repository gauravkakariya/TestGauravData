public with sharing class FlowsTrackerHandler 
{
	/*
	private Map<Id, Map<Double, List<Flows_Tracker__c>>> mapFlowTemplateIdToMapSequenceTolstFlowTracker = new Map<Id, Map<Double, List<Flows_Tracker__c>>>();
	
	public void onAfterUpdateCreateNextFlowTracker(Map<Id, Flows_Tracker__c> newMapIdToFlowTracker, Map<Id, Flows_Tracker__c> oldMapIdToFlowTracker)
	{
		Set<Id> setFlowTemplateId = new Set<Id>();
		Map<Id, List<Flows_Tracker__c>> mapFlowTemplateTolstFlowTracker = new Map<Id, List<Flows_Tracker__c>>();
		for(Flows_Tracker__c objNewFT : newMapIdToFlowTracker.values())
		{
			Flows_Tracker__c objOldFT = oldMapIdToFlowTracker.get(objNewFT.Id);
			if(objNewFT.Status__c == 'Completed' &&  objOldFT.Status__c != 'Completed')
			{
				if(!mapFlowTemplateTolstFlowTracker.containsKey(objNewFT.Flows_Template__c))
					mapFlowTemplateTolstFlowTracker.put(objNewFT.Flows_Template__c, new List<Flows_Tracker__c>{objNewFT});
				else
				{
					Flows_Tracker__c objCurrentFT = mapFlowTemplateTolstFlowTracker.get(objNewFT.Flows_Template__c)[0];
					if(objCurrentFT.Task_Sequence__c < objNewFT.Task_Sequence__c)
						mapFlowTemplateTolstFlowTracker.get(objNewFT.Flows_Template__c).add(objNewFT);
				}
			}
		}
		
		for(Flows_Tracker__c objFTrack : [Select Name, Category__c, Subject__c, Days_After__c, Due_Date__c, Flows_Template__c,  
											Flows_Template__r.Account__c, Flows_Template__r.Account__r.OwnerId, Comments__c,
											Stage__c, Task_Sequence__c,  Priority__c, Status__c From Flows_Tracker__c 
											where Flows_Template__c IN: mapFlowTemplateTolstFlowTracker.keySet()])	
		{
			if(!mapFlowTemplateIdToMapSequenceTolstFlowTracker.containsKey(objFTrack.Flows_Template__c))
			{
				mapFlowTemplateIdToMapSequenceTolstFlowTracker.put(objFTrack.Flows_Template__c, new  Map<Double, List<Flows_Tracker__c>>());
				mapFlowTemplateIdToMapSequenceTolstFlowTracker.get(objFTrack.Flows_Template__c).put(objFTrack.Task_Sequence__c, new List<Flows_Tracker__c>{objFTrack});
			}
			else
			{
				if(!mapFlowTemplateIdToMapSequenceTolstFlowTracker.get(objFTrack.Flows_Template__c).containsKey(objFTrack.Task_Sequence__c))
					mapFlowTemplateIdToMapSequenceTolstFlowTracker.get(objFTrack.Flows_Template__c).put(objFTrack.Task_Sequence__c, new List<Flows_Tracker__c>{objFTrack});
				else
					mapFlowTemplateIdToMapSequenceTolstFlowTracker.get(objFTrack.Flows_Template__c).get(objFTrack.Task_Sequence__c).add(objFTrack);
			}
		}		
		
		map<Id, Workstation__c > mapEntityOwnerIdToWorkstation = new map<Id, Workstation__c >();
		for(Workstation__c objWorkstation : [Select Id, Member_Engagement__c, Financial_Planner__c, Operations__c, Manager__c, Advisory__c from Workstation__c ])
		{
			mapEntityOwnerIdToWorkstation.put(objWorkstation.Financial_Planner__c, objWorkstation);
		}
		
		List<Flows_Tracker__c> lstUpdateFlowTracker = new List<Flows_Tracker__c>();
		List<Task> lstTask = new List<Task>();
		for(Id flowTemplateId : mapFlowTemplateTolstFlowTracker.keySet())
		{
			List<Flows_Tracker__c> lstCurrentFlowTracker =  mapFlowTemplateTolstFlowTracker.get(flowTemplateId);
			
			if(mapFlowTemplateIdToMapSequenceTolstFlowTracker.get(flowTemplateId).containsKey(lstCurrentFlowTracker[0].Task_Sequence__c + 1))
			{
				List<Flows_Tracker__c> lstNewFlowTracker = mapFlowTemplateIdToMapSequenceTolstFlowTracker.get(flowTemplateId).get(lstCurrentFlowTracker[0].Task_Sequence__c + 1);
				
				for(Flows_Tracker__c objFlowsTracker : lstNewFlowTracker)
				{
					Task objTask = new Task();
					
					if(objFlowsTracker.Task_Owner__c == 'MST I')
						objTask.OwnerId = mapEntityOwnerIdToWorkstation.get(objFlowsTracker.Flows_Template__r.Account__r.OwnerId).Member_Engagement__c;
					else if(objFlowsTracker.Task_Owner__c == 'PFP')
						objTask.OwnerId = mapEntityOwnerIdToWorkstation.get(objFlowsTracker.Flows_Template__r.Account__r.OwnerId).Financial_Planner__c;
					else if(objFlowsTracker.Task_Owner__c == 'P&A')
						objTask.OwnerId = mapEntityOwnerIdToWorkstation.get(objFlowsTracker.Flows_Template__r.Account__r.OwnerId).Advisory__c;
					else if(objFlowsTracker.Task_Owner__c == 'MST II')
						objTask.OwnerId = mapEntityOwnerIdToWorkstation.get(objFlowsTracker.Flows_Template__r.Account__r.OwnerId).Operations__c;
						
					objTask.WhatId = objFlowsTracker.Flows_Template__r.Account__c;
					
					objTask.Subject = objFlowsTracker.Subject__c;
					objTask.Subject_Category__c = objFlowsTracker.Category__c;
					objTask.Priority = objFlowsTracker.Priority__c;
					objTask.ActivityDate = system.today().addDays(Integer.valueOf(objFlowsTracker.Days_After__c));
					objTask.Status = objFlowsTracker.Status__c;
					
					lstTask.add(objTask);
					lstUpdateFlowTracker.add(objFlowsTracker);
				}
			}
		}	
		
		if(!lstTask.isEmpty())
			insert lstTask;	
		
		Map<String, Task> mapKeyToTask = new Map<String, Task>();
		for(Task objTask : lstTask)
		{
			mapKeyToTask.put(objTask.WhatId + '~' + objTask.Subject, objTask);
		}
		
		for(Flows_Tracker__c objFTracker : lstUpdateFlowTracker)
		{
			Task objTask = mapKeyToTask.get(objFTracker.Flows_Template__r.Account__c + '~' + objFTracker.Subject__c);
			
			objFTracker.Status__c = 'In Progress';
			objFTracker.Task_Id__c = objTask.Id;
		}
			
	   	if(!lstUpdateFlowTracker.isEmpty())
	   		update lstUpdateFlowTracker;					
	}
	*/
	
}