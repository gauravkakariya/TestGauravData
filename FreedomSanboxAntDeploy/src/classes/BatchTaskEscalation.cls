global with sharing class BatchTaskEscalation implements Database.Batchable<sObject> 
{
	global Database.QueryLocator start(Database.BatchableContext BC) 
    { 
    	//Get All Task Whose Due Date = Yesterday and Status not Completed
    	return Database.getQueryLocator('Select WhoId, WhatId, Subject, Status, Stage__c, Priority, OwnerId, ActivityDate,LastModifiedDate, Id, Description, AccountId From Task  Where ActivityDate = YESTERDAY and Status !=\'Completed\' ');
    	
    }
     global void execute(Database.BatchableContext BC, List<Task> lstTask) 
    {
    	Map<Id,Task> mapTaskIdToTask = new Map<Id,Task> ();
    	Map<Id,Id> mapTaskIdToAccountId = new Map<Id,Id> ();
    	Map<Id, Workflows_Tracker_Details__c> mapTaskIdToWFlowTrackerDetails = new Map<Id, Workflows_Tracker_Details__c> ();
    	List<Notification_Queue__c> lstNotificationQueue = new List<Notification_Queue__c>();
    	List<Task> lstEscalatedTask = new List<Task>();
    	
    	//Iterate All task and Create Map TaskId to Account
    	for(Task objTask : lstTask)
    	{
    		mapTaskIdToTask.put(objTask.Id, objTask);
    		mapTaskIdToAccountId.put(objTask.Id, objTask.WhatId);
    	}
    	
    	//Get all the Entity Workflow Tracker Details Where Task Id and Account id will be present
    	if(mapTaskIdToAccountId != null && mapTaskIdToAccountId.keySet() != null)
    	{
	    	List<Workflows_Tracker_Details__c> lstWFlowTrackerDetails = [Select Task_Sequence__c, 
														    					Task_Id__c, Subject__c, Status__c, 
														    					Related_Workflow_Details_Date__c, Priority__c,
														    					Event_Master__r.Escalation_Event_Master__c,Workflows_Tracker_Master__c,
																				Parent_Workflows_Tracker_Details__c, Name, Id, Event_Master__c, 
																				Due_Date__c, Department__c, Department__r.Business_Unit__c,Days_After__c, Comments__c, 
																				Channel_Type__c ,Workflows_Tracker_Master__r.Parent_Account__c
																		 From Workflows_Tracker_Details__c 
																		 Where Task_Id__c IN: mapTaskIdToAccountId.keyset()
																		 and Workflows_Tracker_Master__r.Parent_Account__c IN: mapTaskIdToAccountId.values()];
			
			system.debug('***************lstWFlowTrackerDetails'+lstWFlowTrackerDetails);																	
			
			//if WFlow Tracker Details is not Empty																	
			if(lstWFlowTrackerDetails.size() > 0)
			{
		        for(Workflows_Tracker_Details__c objEntityWFlowTrackerDetails : lstWFlowTrackerDetails)		
		        {
		        	//Collect All TaskId and There WFlow Tracker Detail Object
		        	mapTaskIdToWFlowTrackerDetails.put(objEntityWFlowTrackerDetails.Task_Id__c, objEntityWFlowTrackerDetails);
		        }
			
			
				if(mapTaskIdToWFlowTrackerDetails.keySet() != null)
				{
					 //Collect All Escalated Task
			       	 lstEscalatedTask = [Select WhoId, WhatId, Subject, Status, Stage__c, Priority, OwnerId, 
			        										ActivityDate,LastModifiedDate, Id, Description, AccountId
			        							   From Task  Where ActivityDate =YESTERDAY and Status !=: Label.Completed and 
			        										Id IN: mapTaskIdToWFlowTrackerDetails.keySet()];
			        system.debug('***************lstEscalatedTask'+lstEscalatedTask);										
				}				
			}
			
			//Insert Notification Queue Record
	        if(lstEscalatedTask.size() > 0 )
	        {									
		        for(Task objEscatedTask :lstEscalatedTask )
		        {
		        	Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
		        	Id eventMasterId = mapTaskIdToWFlowTrackerDetails.get(objEscatedTask.Id).Event_Master__r.Escalation_Event_Master__c;
		        	if(eventMasterId != null && mapTaskIdToAccountId.get(objEscatedTask.Id) != null)
		        	{
			        	objNotificationQueue.Department__c = mapTaskIdToWFlowTrackerDetails.get(objEscatedTask.Id).Department__c;
			        	objNotificationQueue.Event__c =  eventMasterId;
			        	objNotificationQueue.Member_Id__c = mapTaskIdToAccountId.get(objEscatedTask.Id);
			        	objNotificationQueue.Channel_Type__c = 'Email';
			        	objNotificationQueue.Priority__c = 'High';
			        	objNotificationQueue.Custom_Object_Type__c = 'Task';
			        	objNotificationQueue.Custom_ID__c = objEscatedTask.id;
			        	objNotificationQueue.Biz_Unit__c = mapTaskIdToWFlowTrackerDetails.get(objEscatedTask.Id).Department__r.Business_Unit__c;
			        	lstNotificationQueue.add(objNotificationQueue);
			        	system.debug('***************lstNotificationQueue'+lstNotificationQueue);		
		        	}	
		        }	
		        									                                                 													
				//Insert Notification Queue Record	
				if(lstNotificationQueue.size() > 0)
					insert lstNotificationQueue;
	        }		
    	}					
																			
    }
    
    global void finish(Database.BatchableContext BC)
    {
    	//Do Nothing
    }

}//end Class