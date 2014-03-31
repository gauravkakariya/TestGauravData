trigger aINSUpdateMeetingCountOnEvent on Event (after insert,after update)
{
	List<Event> lstevent = new List<Event>();
	if(Trigger.isAfter)
	{
		if(Trigger.isInsert)
		{
			System.debug('trigger.new =========>'+trigger.new.size());
			for(Event objEvent : trigger.new)
			{
				if(objEvent.Event_Status__c != null && objEvent.Event_Status__c != '' && objEvent.Event_Category__c != null && objEvent.Event_Category__c != '') 
					if((objEvent.Event_Status__c.equalsIgnoreCase('complete')) && objEvent.Event_Category__c.equalsIgnoreCase('meeting'))
					lstevent.add(objEvent);
			}
		}
		if(Trigger.isUpdate)
		{
			for(Event objEvent : trigger.new)
			{
				if(objEvent != null && objEvent.Meeting__c != null)
				{
					if(objEvent.Meeting__c == 0 && objEvent.Event_Status__c != null && objEvent.Event_Status__c != '' && objEvent.Event_Status__c.equalsIgnoreCase('complete'))
						if( objEvent.Event_Category__c != null && objEvent.Event_Category__c != '' && objEvent.Event_Category__c.equalsIgnoreCase('meeting'))
							lstevent.add(objEvent);
				}
			}
		}
	    OnInsertUpdateEvent objInsertUpdateEvent = new OnInsertUpdateEvent();
	    
	    if(lstevent != null && lstevent.size() >0)
	    	objInsertUpdateEvent.UpdateEvenMeetingCount(lstevent);
	}
}