public with sharing class TaskHandler 
{
	public void onAfterUpdateToCreateNotificaitonQueue(map<Id, Task> mapOldTaskIdToTask, map<Id, Task> mapNewTaskIdToTask)
	{
		List<Flows_Tracker__c> lstFlowsTracker = new List<Flows_Tracker__c>();
		List<Notification_Queue__c> lstNotificationQueue = new List<Notification_Queue__c>();
		MAP<Id, String> mapTaskIdToStatus = new MAP<Id, String>();
		MAP<Id, Id> mapTaskIdToAccountId = new MAP<Id, String>();
		
		Map<String, Flows_Tracker__c> mapSubjectToFlowTracker = new Map<String, Flows_Tracker__c>([Select Id, Subject__c 
																								   From Flows_Tracker__c 
																								   Where Flows_Template__c = 'MST Flow Master']);
														 
		for(Task objTask : mapNewTaskIdToTask.values())
		{
			if(mapOldTaskIdToTask.get(objTask.Id).Status != 'Completed'
				&& objTask.Status == 'Completed' && mapSubjectToFlowTracker.containsKey(objTask.subject))
			{
				mapTaskIdToAccountId.put(objTask.Id, objTask.WhatId);
				mapTaskIdToStatus.put(objTask.Id, objTask.Status);
			}	
			
		}
		
		List<Flows_Tracker__c> lstFirstTaskFlowTracker = [Select Name, Category__c, Subject__c, Task_Id__c, Days_After__c, Due_Date__c, 
															 	 Flows_Template__c, Flows_Template__r.Account__r.OwnerId, Comments__c, Priority__c, Stage__c, 
															 	 Task_Sequence__c, Flows_Template__r.Account__c,
															 	 Status__c 
														  From Flows_Tracker__c
														  Where Task_Id__c IN :mapTaskIdToStatus.keySet()];
		
	
		
		for(Flows_Tracker__c objFlowsTracker  : lstFlowsTracker)
		{
			Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
			objNotificationQueue.Status__c = objFlowsTracker.Status__c;
			objNotificationQueue.Reject_Reason__c = '';
			objNotificationQueue.Member_Id__c = objFlowsTracker.Flows_Template__r.Account__c;
			objNotificationQueue.Notification_Type__c = 'Both';
			objNotificationQueue.Partner_Id__c = objFlowsTracker.Flows_Template__r.Account__r.OwnerId;
			
			lstNotificationQueue.add(objNotificationQueue);
		}
		
		if(!lstNotificationQueue.isEmpty())
			insert lstNotificationQueue;
		
		/*
		
		List<Flows_Tracker__c> lstFirstTaskFlowTracker = [Select Name, Category__c, Subject__c, Task_Id__c, Days_After__c, Due_Date__c, 
															 	 Flows_Template__c, Comments__c, Priority__c, Stage__c, 
															 	 Task_Sequence__c, Flows_Template__r.Account__c,
															 	 Status__c 
														  From Flows_Tracker__c 
														  Where Task_Id__c IN :mapTaskIdToStatus.keySet()];
		
		for(Flows_Tracker__c objFlowTracker : lstFirstTaskFlowTracker)
		{
			if(objFlowTracker.Flows_Template__r.Account__c == mapTaskIdToAccountId.get(objFlowTracker.Task_Id__c))
			{
				objFlowTracker.Status__c = mapTaskIdToStatus.get(objFlowTracker.Task_Id__c);
				lstFlowsTracker.add(objFlowTracker);
			}
		}
		
		if(!lstFlowsTracker.isEmpty())
			update lstFlowsTracker;
			
		*/	
	}
	
}