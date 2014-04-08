public with sharing class InsertUpdateDeleteOnEventHelperClass 
{
	public static boolean alreadyCreatedEvents = false;
	public static boolean alreadyUpdatedEvents = false;
	public static boolean alreadyDeletedEvents = false;
	public static boolean hasAlreadyCreatedFollowUpEvents() 
   	{
    	return alreadyCreatedEvents;
    }
    public static boolean hasAlreadyUpdatedFollowUpEvents() 
   	{
    	return alreadyUpdatedEvents;
    }
     public static boolean hasAlreadyDeletedFollowUpEvents() 
   	{
    	return alreadyDeletedEvents;
    }
    
    //Insert Duplicate Event
	public static void insertDuplicateEvent(List<Event> newEventList)
	{
		set<Id> whoIdSet = new set<Id>();
		for(Event objEvent : newEventList)
		{
			if(objEvent.WhoId != null)
			whoIdSet.add(objEvent.WhoId);
		}
		Map<Id,Lead> leadIdVsLeadMap = new Map<Id,Lead>([select Id from Lead where id in : whoIdSet and Platform_User_Lead__c != null]);
		List<Event> EventToCloneForCustomLead = new List<Event>();
		List<Event> EventToCloneForStandardLead = new List<Event>();
		List<Event> EventClonedListForCustomStandardLeads = new List<Event>();
		set<Id> leadWhoIdSet = new set<Id>();
		set<Id> customLeadWhatIdSet = new set<Id>();
		system.debug('#####################==>newEventList'+newEventList);
		if(newEventList != null && newEventList.size() > 0)
		{
			for(Event objEvent : newEventList)
			{
				String whoId,whatId;
				if(objEvent.WhoId != null)
					whoId = objEvent.WhoId;
				else if(objEvent.whatId != null)
				{
					whatId = objEvent.whatId;
				}
				String strPrefix;
				if(whoId != null)
					strPrefix = whoId.substring(0,3);
				else if(whatId != null)
					strPrefix = whatId.substring(0,3);
				system.debug('############# strPrefix:'+strPrefix);
				if(strPrefix != null && strPrefix != '' && strPrefix.equals('00Q')) //standard Lead Prefix
				{
					if(objEvent != null && objEvent.Parent_Activity_ID_Platform_User__c == null && objEvent.whoId != null && leadIdVsLeadMap.containsKey(objEvent.whoId))
					{
						EventToCloneForCustomLead.add(objEvent);
						leadWhoIdSet.add(objEvent.WhoId);
					}
				}
				else if(strPrefix != null && strPrefix != '' && strPrefix.equals('a1H'))
				{
					if(objEvent != null && objEvent.Parent_Activity_ID_Platform_User__c == null)
					{
						Schema.DescribeSObjectResult sObjectResult = Lead_Platform_User__c.SObjectType.getDescribe();
						String strCustomLeadPrefix = sObjectResult.getKeyPrefix(); //custom Lead Prefix
						system.debug('############# strCustomLeadPrefix:'+strCustomLeadPrefix);
						if(strPrefix.equals(strCustomLeadPrefix))
						{
							EventToCloneForCustomLead.add(objEvent);
							customLeadWhatIdSet.add(objEvent.WhatId);
						}
					}
						
				}
			}
			//alreadyCreatedEvents = true;
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
			for(Event objEvent : EventToCloneForCustomLead) //Event to be created from std Event to  
			{
				Event objClone = objEvent.clone(false);
				if(LeadIdVsLeadTobeClonedMap.containsKey(objEvent.WhoId))
				{
					Lead objLead = LeadIdVsLeadTobeClonedMap.get(objEvent.WhoId);
					objClone.whoId = null;
					objClone.WhatId = objLead.Platform_User_Lead__c;
					objClone.Parent_Activity_ID_Platform_User__c = objEvent.Id;
				}
				else if(customLeadIdVsLeadTobeClonedMap.containsKey(objEvent.WhatId))
				{
					Lead objLead = customLeadIdVsLeadTobeClonedMap.get(objEvent.WhatId);
					objClone.WhatId = null;
					objClone.whoId = objLead.id;
					objClone.Parent_Activity_ID_Platform_User__c = objEvent.Id;
				}
				EventClonedListForCustomStandardLeads.add(objClone);
			}
			
			system.debug('*****************88 EventClonedListForCustomStandardLeads :'+EventClonedListForCustomStandardLeads );
			insert EventClonedListForCustomStandardLeads;
			Map<id,id> EventIdVsParentEventIdMap = new Map<id,id>(); 
			for(Event objEvent : EventClonedListForCustomStandardLeads)
			{
				if(!EventIdVsParentEventIdMap.containsKey(objEvent.Parent_Activity_ID_Platform_User__c))
					EventIdVsParentEventIdMap.put(objEvent.Parent_Activity_ID_Platform_User__c,objEvent.Id);
			}
			List<Event> updateParentId = new List<Event>();
			Map<id,Event> newEventMap = new Map<id,Event>([select id,Parent_Activity_ID_Platform_User__c
														from Event where id in : EventIdVsParentEventIdMap.keySet()]);
			if(newEventMap != null && EventIdVsParentEventIdMap != null)
			{
				for(Id EventId : newEventMap.keySet())
				{
					if(EventIdVsParentEventIdMap.containsKey(EventId))
					{
						Id parentEventId = EventIdVsParentEventIdMap.get(EventId);
						Event newmapEvent = newEventMap.get(EventId);
						newmapEvent.Parent_Activity_ID_Platform_User__c = parentEventId;
						updateParentId.add(newmapEvent);
					}
				}
			}
			update updateParentId;
		}
	}
	
	//Update Duplicate Event
	public static void UpdateDuplicateEvent(List<Event> newEventList)
	{
		Map<id,Event> parentIdEventVsActualEvent = new Map<id,Event>(); //Id of the parent Event and actual Event
		for(Event objEvent : newEventList)
		{
			if(objEvent.Parent_Activity_ID_Platform_User__c != null)
			{
				if(!parentIdEventVsActualEvent.containsKey(objEvent.Parent_Activity_ID_Platform_User__c))
					parentIdEventVsActualEvent.put(objEvent.Parent_Activity_ID_Platform_User__c,objEvent);
			}
		}
		//Event.sObjectType.getDescribe().fields.getMap().keySet()
		//EventFields.addAll(Event.getDescribe().fields.getMap().keySet());
		
	/*Setty : SMS Magic uninstall 19/09/2012
		
		/*List<String> EventFields = new List<String>{};
		system.debug('HHHHHHHHHHHHHHH:'+Event.sObjectType.getDescribe());
		EventFields.addAll(Event.sObjectType.getDescribe().fields.getMap().keySet());
		List<Id> EventIdList = new list<Id>();
		EventIdList.addAll(parentIdEventVsActualEvent.keySet());
		String allSObjectFieldsQuery = 'SELECT ' + EventFields.get(0); 
		    
	    for(Integer i=1 ; i < EventFields.size() ; i++)
	    {
	    	allSObjectFieldsQuery += ', ' + EventFields.get(i);
	    }
	    
	    allSObjectFieldsQuery += ' FROM ' + 
	                               Event.sObjectType.getDescribe().getName() + 
	                               ' WHERE ID IN (\'' +EventIdList.get(0)+ 
        	                       '\'';
		 for(Integer i=1 ; i < EventIdList.size() ; i++)
		 {
		    allSObjectFieldsQuery += ', \'' + EventIdList.get(i) + '\'';
		 }
		    
		 allSObjectFieldsQuery += ')';
	     List<Event> EventTobeupdated = Database.query(allSObjectFieldsQuery);*/
	     
	
	  
	     ////////////
	     List<Id> EventIdList = new list<Id>();
		 EventIdList.addAll(parentIdEventVsActualEvent.keySet());
	     List<Event> EventTobeupdated = [select Activity_No__c,ActivityDate,
										Completion_Date__c,Context__c,Description,Event_Category__c,Event_Place__c,Event_Status__c,
										From_Time__c,IsReminderSet,Login_Once__c,Marketing_Owner__c,Meeting__c,Meeting_Start_Date__c,RecurrenceInstance,
										RecurrenceInterval,RecurrenceMonthOfYear,RecurrenceTimeZoneSidKey
										,RecurrenceType,ReminderDateTime,Seq_Day__c,/*Setty:SMS Magic uninstall 19/09/2012 ,smsmagicvc1__SendSMS__c */Stage1__c,
										Stage__c,Subject,Subject_Category__c,To_Time__c from Event where Id in: EventIdList];
	     ///////////
	     Map<id,Event> EventToBeUpdatedIdVsEvent = new Map<id,Event>();
	     for(Event objEvent : EventTobeupdated)
	     {
	     	if(!EventToBeUpdatedIdVsEvent.containsKey(objEvent.id))
	     		EventToBeUpdatedIdVsEvent.put(objEvent.id,objEvent);
	     }
	     List<Event> updateRelatedEventList = new List<Event>();
	    for(Id relatedEventId : EventToBeUpdatedIdVsEvent.keySet())
	     {
	     	Event currentActualEvent,needToBeUpdatedEvent;
	     	if(parentIdEventVsActualEvent.containsKey(relatedEventId))
	     		currentActualEvent = parentIdEventVsActualEvent.get(relatedEventId);
	     	needToBeUpdatedEvent = EventToBeUpdatedIdVsEvent.get(relatedEventId);
	     	//needToBeUpdatedEvent.AccountId = currentActualEvent.AccountId;
	     	needToBeUpdatedEvent.Activity_No__c = currentActualEvent.Activity_No__c;
	     	needToBeUpdatedEvent.ActivityDate = currentActualEvent.ActivityDate;
	     	//needToBeUpdatedEvent.CallDisposition = currentActualEvent.CallDisposition;
	     	//needToBeUpdatedEvent.CallDurationInSeconds = currentActualEvent.CallDurationInSeconds;
	     	//needToBeUpdatedEvent.CallObject = currentActualEvent.CallObject;
	     	//needToBeUpdatedEvent.CallType = currentActualEvent.CallType;
	     	needToBeUpdatedEvent.Completion_Date__c = currentActualEvent.Completion_Date__c;
	     	needToBeUpdatedEvent.Context__c = currentActualEvent.Context__c;
	     	needToBeUpdatedEvent.Description = currentActualEvent.Description;
	     	needToBeUpdatedEvent.Event_Category__c = currentActualEvent.Event_Category__c;
	     	needToBeUpdatedEvent.Event_Place__c = currentActualEvent.Event_Place__c;
	     	needToBeUpdatedEvent.Event_Status__c = currentActualEvent.Event_Status__c;
	     	needToBeUpdatedEvent.From_Time__c = currentActualEvent.From_Time__c;
	     	//needToBeUpdatedEvent.IsArchived = currentActualEvent.IsArchived;
	     	//needToBeUpdatedEvent.IsClosed = currentActualEvent.IsClosed;
	     	//needToBeUpdatedEvent.IsRecurrence = currentActualEvent.IsRecurrence;
	     	needToBeUpdatedEvent.IsReminderSet = currentActualEvent.IsReminderSet;
	     	needToBeUpdatedEvent.Login_Once__c = currentActualEvent.Login_Once__c;
	     	needToBeUpdatedEvent.Marketing_Owner__c = currentActualEvent.Marketing_Owner__c;
	     	needToBeUpdatedEvent.Meeting__c = currentActualEvent.Meeting__c;
	     	needToBeUpdatedEvent.Meeting_Start_Date__c = currentActualEvent.Meeting_Start_Date__c;
	     	//needToBeUpdatedEvent.Priority = currentActualEvent.Priority;
	     	//needToBeUpdatedEvent.RecurrenceActivityId = currentActualEvent.RecurrenceActivityId;
	     	needToBeUpdatedEvent.RecurrenceDayOfMonth = currentActualEvent.RecurrenceDayOfMonth;
	     	needToBeUpdatedEvent.RecurrenceDayOfWeekMask = currentActualEvent.RecurrenceDayOfWeekMask;
	     	needToBeUpdatedEvent.RecurrenceEndDateOnly = currentActualEvent.RecurrenceEndDateOnly;
	     	needToBeUpdatedEvent.RecurrenceInstance = currentActualEvent.RecurrenceInstance;
	     	needToBeUpdatedEvent.RecurrenceInterval = currentActualEvent.RecurrenceInterval;
	     	needToBeUpdatedEvent.RecurrenceMonthOfYear = currentActualEvent.RecurrenceMonthOfYear;
	     	//needToBeUpdatedEvent.RecurrenceStartDateOnly = currentActualEvent.RecurrenceStartDateOnly;
	     	needToBeUpdatedEvent.RecurrenceTimeZoneSidKey = currentActualEvent.RecurrenceTimeZoneSidKey;
	     	needToBeUpdatedEvent.RecurrenceType = currentActualEvent.RecurrenceType;
	     	needToBeUpdatedEvent.ReminderDateTime = currentActualEvent.ReminderDateTime;
	     	needToBeUpdatedEvent.Seq_Day__c = currentActualEvent.Seq_Day__c;
	     	/*Setty:SMS Magic uninstall 19/09/2012 needToBeUpdatedEvent.smsmagicvc1__SendSMS__c = currentActualEvent.smsmagicvc1__SendSMS__c; */
	     	needToBeUpdatedEvent.Stage1__c = currentActualEvent.Stage1__c;
	     	needToBeUpdatedEvent.Stage__c = currentActualEvent.Stage__c;
	     	//needToBeUpdatedEvent.Status = currentActualEvent.Status;
	     	needToBeUpdatedEvent.Subject = currentActualEvent.Subject;
	     	needToBeUpdatedEvent.Subject_Category__c = currentActualEvent.Subject_Category__c;
	     	needToBeUpdatedEvent.To_Time__c = currentActualEvent.To_Time__c;
	     	//needToBeUpdatedEvent.WhatId = currentActualEvent.WhatId;
	     	//needToBeUpdatedEvent.WhoId = currentActualEvent.WhoId;
	     	updateRelatedEventList.add(needToBeUpdatedEvent);
	     }
		 //system.debug('###########:'+allSObjectFieldsQuery);
		 alreadyUpdatedEvents = true;
		 update updateRelatedEventList;
		//Map<id,Event> parentEventMap = new Map<id,Event>([select])
	}
	
	//Delete Duplicate Event
	public static void DeleteDuplicateEvent(Map<Id,Event> EventTodeleteMap)
	{
		List<Event> relatedEventToBeDeleted = new List<Event>(); 
		if(EventTodeleteMap != null)
			relatedEventToBeDeleted = [select Id from Event where 
									 Parent_Activity_ID_Platform_User__c in: EventTodeleteMap.keySet()];
		alreadyDeletedEvents = true;
		delete relatedEventToBeDeleted;
	}
	
}