public with sharing class InsertUpdateDeleteOnTaskHelperClass
{
	public static boolean alreadyCreatedTasks = false;
	public static boolean alreadyUpdatedTasks = false;
	public static boolean alreadyDeletedTasks = false;
	public static boolean hasAlreadyCreatedFollowUpTasks() 
   	{
    	return alreadyCreatedTasks;
    }
    public static boolean hasAlreadyUpdatedFollowUpTasks() 
   	{
    	return alreadyUpdatedTasks;
    }
    public static boolean hasAlreadyDeletedFollowUpTasks() 
   	{
    	return alreadyDeletedTasks;
    }
    //Insert Duplicate Task
	public static void insertDuplicateTask(List<Task> newTaskList)
	{
		set<Id> whoIdSet = new set<Id>();
		for(Task objTask : newTaskList)
		{
			if(objTask.WhoId != null)
			whoIdSet.add(objTask.WhoId);
		}
		Map<Id,Lead> leadIdVsLeadMap = new Map<Id,Lead>([select Id from Lead where id in : whoIdSet and Platform_User_Lead__c != null]);
		List<Task> taskToCloneForCustomLead = new List<Task>();
		List<Task> taskToCloneForStandardLead = new List<Task>();
		List<Task> TaskClonedListForCustomStandardLeads = new List<Task>();
		set<Id> leadWhoIdSet = new set<Id>();
		set<Id> customLeadWhatIdSet = new set<Id>();
		system.debug('#####################==>newTaskList'+newTaskList);
		if(newTaskList != null && newTaskList.size() > 0)
		{
			for(Task objTask : newTaskList)
			{
				String whoId,whatId;
				if(objTask.WhoId != null)
					whoId = objTask.WhoId;
				else if(objTask.whatId != null)
				{
					whatId = objTask.whatId;
				}
				String strPrefix;
				if(whoId != null)
					strPrefix = whoId.substring(0,3);
				else if(whatId != null)
					strPrefix = whatId.substring(0,3);
				system.debug('############# strPrefix:'+strPrefix);
				if(strPrefix != null && strPrefix != '' && strPrefix.equals('00Q')) //standard Lead Prefix
				{
					if(objTask != null && objTask.Parent_Activity_ID_Platform_User__c == null && objTask.whoId != null && leadIdVsLeadMap.containsKey(objTask.whoId))
					{	
						taskToCloneForCustomLead.add(objTask);
						leadWhoIdSet.add(objTask.WhoId);
					}
				}
				else if(strPrefix != null && strPrefix != '' && strPrefix.equals('a1H'))
				{
					if(objTask != null && objTask.Parent_Activity_ID_Platform_User__c == null)
					{
						Schema.DescribeSObjectResult sObjectResult = Lead_Platform_User__c.SObjectType.getDescribe();
						String strCustomLeadPrefix = sObjectResult.getKeyPrefix(); //custom Lead Prefix
						system.debug('############# strCustomLeadPrefix:'+strCustomLeadPrefix);
						if(strPrefix.equals(strCustomLeadPrefix))
						{
							taskToCloneForCustomLead.add(objTask);
							customLeadWhatIdSet.add(objTask.WhatId);
						}
					}
						
				}
			}
			//alreadyCreatedTasks = true;
			system.debug('#############3 customLeadWhatIdSet :'+customLeadWhatIdSet );
			Map<Id,Lead> LeadIdVsLeadTobeClonedMap = new Map<Id,Lead>([select id,Platform_User_Lead__c from lead where id in : leadWhoIdSet]);
			Map<Id,Lead> customLeadIdVsLeadTobeClonedMap = new Map<Id,Lead>();
			for(Lead obj : [select id,Platform_User_Lead__c from lead where Platform_User_Lead__c in : customLeadWhatIdSet])
			{
				if(!customLeadIdVsLeadTobeClonedMap.containsKey(obj.Platform_User_Lead__c))
					customLeadIdVsLeadTobeClonedMap.put(obj.Platform_User_Lead__c,obj);
			}
			system.debug('DDDDDDDDDDDDDDDDDDDDDDDDDD LeadIdVsLeadTobeClonedMap :'+LeadIdVsLeadTobeClonedMap );
			system.debug('DDDDDDDDDDDDDDDDDDDDDDDDDD customLeadIdVsLeadTobeClonedMap :'+customLeadIdVsLeadTobeClonedMap );
			for(Task objTask : taskToCloneForCustomLead) //Task to be created from std task to  
			{
				Task objClone = objTask.clone(false);
				if(LeadIdVsLeadTobeClonedMap.containsKey(objTask.WhoId))
				{
					Lead objLead = LeadIdVsLeadTobeClonedMap.get(objTask.WhoId);
					objClone.whoId = null;
					objClone.WhatId = objLead.Platform_User_Lead__c;
					objClone.Parent_Activity_ID_Platform_User__c = objTask.Id;
				}
				else if(customLeadIdVsLeadTobeClonedMap.containsKey(objTask.WhatId))
				{
					Lead objLead = customLeadIdVsLeadTobeClonedMap.get(objTask.WhatId);
					objClone.WhatId = null;
					objClone.whoId = objLead.id;
					objClone.Parent_Activity_ID_Platform_User__c = objTask.Id;
				}
				TaskClonedListForCustomStandardLeads.add(objClone);
			}
			
			system.debug('*****************88 TaskClonedListForCustomStandardLeads :'+TaskClonedListForCustomStandardLeads );
			insert TaskClonedListForCustomStandardLeads;
			Map<id,id> taskIdVsParentTaskIdMap = new Map<id,id>(); 
			for(Task objTask : TaskClonedListForCustomStandardLeads)
			{
				if(!taskIdVsParentTaskIdMap.containsKey(objTask.Parent_Activity_ID_Platform_User__c))
					taskIdVsParentTaskIdMap.put(objTask.Parent_Activity_ID_Platform_User__c,objTask.Id);
			}
			List<task> updateParentId = new List<task>();
			Map<id,Task> newTaskMap = new Map<id,Task>([select id,Parent_Activity_ID_Platform_User__c
														from Task where id in : taskIdVsParentTaskIdMap.keySet()]);
			if(newTaskMap != null && taskIdVsParentTaskIdMap != null)
			{
				for(Id taskId : newTaskMap.keySet())
				{
					if(taskIdVsParentTaskIdMap.containsKey(taskId))
					{
						Id parentTaskId = taskIdVsParentTaskIdMap.get(taskId);
						Task newmapTask = newTaskMap.get(taskId);
						newmapTask.Parent_Activity_ID_Platform_User__c = parentTaskId;
						updateParentId.add(newmapTask);
					}
				}
			}
			update updateParentId;
		}
	}
	//Update Duplicate Task
	public static void UpdateDuplicateTask(List<Task> newTaskList)
	{
		Map<id,Task> parentIdTaskVsActualTask = new Map<id,Task>(); //Id of the parent Task and actual task
		for(Task objTask : newTaskList)
		{
			if(objTask.Parent_Activity_ID_Platform_User__c != null)
			{
				if(!parentIdTaskVsActualTask.containsKey(objTask.Parent_Activity_ID_Platform_User__c))
					parentIdTaskVsActualTask.put(objTask.Parent_Activity_ID_Platform_User__c,objTask);
			}
		}
		//Task.sObjectType.getDescribe().fields.getMap().keySet()
		//taskFields.addAll(Task.getDescribe().fields.getMap().keySet());
		
		/*
		List<String> taskFields = new List<String>{};
		system.debug('HHHHHHHHHHHHHHH:'+Task.sObjectType.getDescribe());
		taskFields.addAll(Task.sObjectType.getDescribe().fields.getMap().keySet());
		Integer iTaskPhoneIndex = 0;
		if(taskFields != null)
		{
			for(iTaskPhoneIndex = 0;iTaskPhoneIndex < taskFields.size() ;iTaskPhoneIndex++)
			{
				if(taskFields[iTaskPhoneIndex].equalsIgnoreCase('Phone'))
					break;
			}
		}
		if(iTaskPhoneIndex != taskFields.size())
			taskFields.Remove(iTaskPhoneIndex);
		List<Id> taskIdList = new list<Id>();
		taskIdList.addAll(parentIdTaskVsActualTask.keySet());
		String allSObjectFieldsQuery = 'SELECT ' + taskFields.get(0); 
		    
	    for(Integer i=1 ; i < taskFields.size() ; i++)
	    {
	    	allSObjectFieldsQuery += ', ' + taskFields.get(i);
	    }
	    
	    allSObjectFieldsQuery += ' FROM ' + 
	                               Task.sObjectType.getDescribe().getName() + 
	                               ' WHERE ID IN (\'' +taskIdList.get(0)+ 
        	                       '\'';
		 for(Integer i=1 ; i < taskIdList.size() ; i++)
		 {
		    allSObjectFieldsQuery += ', \'' + taskIdList.get(i) + '\'';
		 }
		    
		 allSObjectFieldsQuery += ')';
		 system.debug('@!@@@@@@@@@@@@@@@@@@@@@@@@ allSObjectFieldsQuery:'+allSObjectFieldsQuery);
	     List<Task> taskTobeupdated = Database.query(allSObjectFieldsQuery);  */ 
	     List<Id> taskIdList = new list<Id>();
		 taskIdList.addAll(parentIdTaskVsActualTask.keySet());
	     List<Task> taskTobeupdated = [select Activity_No__c,ActivityDate,CallDisposition,CallDurationInSeconds,CallObject,CallType,Completion_Date__c
										,Context__c,Description,Event_Category__c,Event_Place__c,Event_Status__c,
										From_Time__c,IsReminderSet,Login_Once__c,Marketing_Owner__c,Meeting__c,Meeting_Start_Date__c
										,Priority,RecurrenceDayOfMonth,RecurrenceDayOfWeekMask,RecurrenceEndDateOnly,RecurrenceInstance,
										RecurrenceInterval,RecurrenceMonthOfYear,RecurrenceStartDateOnly,RecurrenceTimeZoneSidKey
										,RecurrenceType,ReminderDateTime,Seq_Day__c,/*Setty:SMS Magic uninstall 19/09/2012 ,smsmagicvc1__SendSMS__c */ Stage1__c,
										Stage__c,Status,Subject,Subject_Category__c,To_Time__c from Task where Id in: taskIdList];
										
										
										
	     Map<id,Task> taskToBeUpdatedIdVsTask = new Map<id,Task>();
	     for(Task objTask : taskTobeupdated)
	     {
	     	if(!taskToBeUpdatedIdVsTask.containsKey(objTask.id))
	     		taskToBeUpdatedIdVsTask.put(objTask.id,objTask);
	     }
	     List<Task> updateRelatedTaskList = new List<Task>();
	    for(Id relatedTaskId : taskToBeUpdatedIdVsTask.keySet())
	     {
	     	Task currentActualTask,needToBeUpdatedTask;
	     	if(parentIdTaskVsActualTask.containsKey(relatedTaskId))
	     		currentActualTask = parentIdTaskVsActualTask.get(relatedTaskId);
	     	needToBeUpdatedTask = taskToBeUpdatedIdVsTask.get(relatedTaskId);
	     	//needToBeUpdatedTask.AccountId = currentActualTask.AccountId;
	     	needToBeUpdatedTask.Activity_No__c = currentActualTask.Activity_No__c;
	     	needToBeUpdatedTask.ActivityDate = currentActualTask.ActivityDate;
	     	needToBeUpdatedTask.CallDisposition = currentActualTask.CallDisposition;
	     	needToBeUpdatedTask.CallDurationInSeconds = currentActualTask.CallDurationInSeconds;
	     	needToBeUpdatedTask.CallObject = currentActualTask.CallObject;
	     	needToBeUpdatedTask.CallType = currentActualTask.CallType;
	     	needToBeUpdatedTask.Completion_Date__c = currentActualTask.Completion_Date__c;
	     	needToBeUpdatedTask.Context__c = currentActualTask.Context__c;
	     	needToBeUpdatedTask.Description = currentActualTask.Description;
	     	needToBeUpdatedTask.Event_Category__c = currentActualTask.Event_Category__c;
	     	needToBeUpdatedTask.Event_Place__c = currentActualTask.Event_Place__c;
	     	needToBeUpdatedTask.Event_Status__c = currentActualTask.Event_Status__c;
	     	needToBeUpdatedTask.From_Time__c = currentActualTask.From_Time__c;
	     	//needToBeUpdatedTask.IsArchived = currentActualTask.IsArchived;
	     	//needToBeUpdatedTask.IsClosed = currentActualTask.IsClosed;
	     	//needToBeUpdatedTask.IsRecurrence = currentActualTask.IsRecurrence;
	     	needToBeUpdatedTask.IsReminderSet = currentActualTask.IsReminderSet;
	     	needToBeUpdatedTask.Login_Once__c = currentActualTask.Login_Once__c;
	     	needToBeUpdatedTask.Marketing_Owner__c = currentActualTask.Marketing_Owner__c;
	     	needToBeUpdatedTask.Meeting__c = currentActualTask.Meeting__c;
	     	needToBeUpdatedTask.Meeting_Start_Date__c = currentActualTask.Meeting_Start_Date__c;
	     	needToBeUpdatedTask.Priority = currentActualTask.Priority;
	     	//needToBeUpdatedTask.RecurrenceActivityId = currentActualTask.RecurrenceActivityId;
	     	needToBeUpdatedTask.RecurrenceDayOfMonth = currentActualTask.RecurrenceDayOfMonth;
	     	needToBeUpdatedTask.RecurrenceDayOfWeekMask = currentActualTask.RecurrenceDayOfWeekMask;
	     	needToBeUpdatedTask.RecurrenceEndDateOnly = currentActualTask.RecurrenceEndDateOnly;
	     	needToBeUpdatedTask.RecurrenceInstance = currentActualTask.RecurrenceInstance;
	     	needToBeUpdatedTask.RecurrenceInterval = currentActualTask.RecurrenceInterval;
	     	needToBeUpdatedTask.RecurrenceMonthOfYear = currentActualTask.RecurrenceMonthOfYear;
	     	needToBeUpdatedTask.RecurrenceStartDateOnly = currentActualTask.RecurrenceStartDateOnly;
	     	needToBeUpdatedTask.RecurrenceTimeZoneSidKey = currentActualTask.RecurrenceTimeZoneSidKey;
	     	needToBeUpdatedTask.RecurrenceType = currentActualTask.RecurrenceType;
	     	needToBeUpdatedTask.ReminderDateTime = currentActualTask.ReminderDateTime;
	     	needToBeUpdatedTask.Seq_Day__c = currentActualTask.Seq_Day__c;
	     	/*Setty:SMS Magic uninstall 19/09/2012 needToBeUpdatedTask.smsmagicvc1__SendSMS__c = currentActualTask.smsmagicvc1__SendSMS__c;*/
	     	needToBeUpdatedTask.Stage1__c = currentActualTask.Stage1__c;
	     	needToBeUpdatedTask.Stage__c = currentActualTask.Stage__c;
	     	needToBeUpdatedTask.Status = currentActualTask.Status;
	     	needToBeUpdatedTask.Subject = currentActualTask.Subject;
	     	needToBeUpdatedTask.Subject_Category__c = currentActualTask.Subject_Category__c;
	     	needToBeUpdatedTask.To_Time__c = currentActualTask.To_Time__c;
	     	//needToBeUpdatedTask.WhatId = currentActualTask.WhatId;
	     	//needToBeUpdatedTask.WhoId = currentActualTask.WhoId;
	     	updateRelatedTaskList.add(needToBeUpdatedTask);
	     }
		 //system.debug('###########:'+allSObjectFieldsQuery);
		 alreadyUpdatedTasks = true;
		 update updateRelatedTaskList;
		//Map<id,Task> parentTaskMap = new Map<id,Task>([select])
	}
	//Delete Duplicate Task
	public static void DeleteDuplicateTask(Map<Id,Task> TaskTodeleteMap)
	{
		system.debug('Trigger.new::::::::::TaskTodeleteMap:'+TaskTodeleteMap);
		List<Task> relatedTaskToBeDeleted = new List<Task>(); 
		if(TaskTodeleteMap != null)
			relatedTaskToBeDeleted = [select Id from Task where 
									 Parent_Activity_ID_Platform_User__c in: TaskTodeleteMap.keySet()];
		system.debug('relatedTaskToBeDeleted============>'+relatedTaskToBeDeleted);
		alreadyDeletedTasks = true; 
		delete relatedTaskToBeDeleted;
	}
}