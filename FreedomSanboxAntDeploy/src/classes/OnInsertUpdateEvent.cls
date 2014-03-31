/*
	Revision History:
	
    Version     Version Author     Date        	Comments
	1.0			-					-			Initial Draft
    2.0         Mahesh Hirugade	   16/12/2011	Added a logic of reflecting Meeting count i.e. Meeting__c from newly created Event to the related Leads Meeting__c field.
*/
public with sharing class OnInsertUpdateEvent {
	private ID strCurrLeadId;
	private ID strCurrOwnerId;
    private ID strCurrEventId;
    private Set<ID> LeadIDSet = new Set<ID>();
    private Set<ID> OwnerIDSet = new Set<ID>();
    private Set<ID> EventToUpdateIDSet = new Set<ID>();
    
    Map<Id, Lead> mapLead; //Mahesh 
    
    private List<Event> MeetingCountEventList = new List<Event>();
    private List<Lead> MeetingCountLeadList = new List<Lead>();
    
    /*This Set will becomes a key for the Combination of LeadId and OwnerId*/
    private Set<String> SetLeadIdQwnerId = new Set<String>();
    
	public void UpdateEvenMeetingCount(List<Event> lstNewEvent)
	{
         for(Event objEvent : lstNewEvent)
         {
            if(objEvent.WhoId <> NULL && objEvent.WhatId == NULL)
            {
                LeadIDSet.add(objEvent.WhoId);
                OwnerIDSet.add(objEvent.OwnerId);
                EventToUpdateIDSet.add(objEvent.Id);
                string setKey = String.valueOf(objEvent.WhoId) + String.valueOf(objEvent.OwnerId);
                SetLeadIdQwnerId.add(setKey);
            }
         }
       
       mapLead  = new Map<Id, Lead>([select Id, Status, Close_Date__c, Appointment_Time__c, Meeting__c from Lead where Id IN:LeadIDSet]);
	   
	   //Fetch all the Event records for the perticular Finacial Planner and Owner
		List<Event> ExistingEventList = [SELECT Id,
	    										Completion_Date__c,
	    										To_Time__c,
	    										From_Time__c,
	    									  	Meeting__c,
	    									  	Meeting_Start_Date__c,
	    									  	WhoId,Who.Type,OwnerId 
										 FROM Event 
										 WHERE WhoID IN :LeadIDSet 
        								 	AND Who.Type = 'lead' 
        								 	AND OwnerId IN :OwnerIDSet 
        								 	AND Event_Status__c ='Complete'];
	    
		List<Lead> lstLeads = [select Id, Status, Close_Date__c, Appointment_Time__c from Lead where Id IN : LeadIDSet];


	    // Need to fire the query here because in trigger.new 
	    // redord have read only access
        for(Event objEvent : [SELECT To_Time__c,Id,Meeting__c,From_Time__c,WhoId,Who.Type,OwnerId,Completion_Date__c,Meeting_Start_Date__c FROM Event
                                     WHERE ID IN :EventToUpdateIDSet])
		{
            Double dblMeetingCount = 0;
            strCurrLeadId = objEvent.WhoId;
            strCurrOwnerId = objEvent.OwnerId;
         	
         	for(Event objExistingEvent : ExistingEventList)
            {
            	//New Code to Update the Logic for Event Count Increment
            	String strKey = String.valueOf(objExistingEvent.WhoId) + String.valueOf(objExistingEvent.OwnerID);
                if(SetLeadIdQwnerId.contains(strKey))
                    dblMeetingCount++;
            }
            if(dblMeetingCount != 0)
            {
 				objEvent.Meeting__c = dblMeetingCount;
            	MeetingCountEventList.add(objEvent);
            	if(mapLead.containskey(strCurrLeadId))
            	{
            		Lead oLead = mapLead.get(strCurrLeadId);
            		oLead.Meeting__c = dblMeetingCount;
            		MeetingCountLeadList.add(oLead);
            	}
        	}
	    }
	    	        
	    //Update the Event list containing the Meeting # for each Event to the database
	    //Update MeetingCountEventList;
        Set<ID> setEventID = new Set<ID>();
        if(MeetingCountEventList != null && MeetingCountEventList.size() > 0)
        {
        	List<Database.SaveResult> lstSaveResult = database.update(MeetingCountEventList);
        	if(lstSaveResult != null && lstSaveResult.size() > 0){
                for(Database.SaveResult objSaveResult : lstSaveResult){
                    setEventID.add(objSaveResult.Id);
                }
                
                
                // Need to create the Custome Event object
                InsertCustomEventObject(setEventID);
        	}
    	}
    	if(MeetingCountLeadList != null && MeetingCountLeadList.size() > 0)
    		List<Database.SaveResult> lstLeadSaveResult = database.update(MeetingCountLeadList);//mahesh
	    
	}
	
	/*
	//Mahesh
	public void UpdateMeetingCountOnLead(Set<ID> setEventID)
	{
		Map<Id, Lead> mapOfLeads;
		Set<Id> setLeadID = new Set<Id>();
		List<Event> lstEvent = new List<Event>();
		List<Lead> MeetingCountLeadList = new List<Lead>();
		
		lstEvent = [SELECT Id, Completion_Date__c,To_Time__c, From_Time__c,Meeting__c,Meeting_Start_Date__c,WhoId,Who.Type,OwnerId 
					FROM Event WHERE ID IN :setEventID];
		for(Event objEvent : lstEvent)
		{
			setLeadID.add(objEvent.WhoId);
		}
		mapOfLeads = new Map<Id, Lead>([select Id, Status, Close_Date__c, Appointment_Time__c, Meeting__c from Lead where Id IN:setLeadID]);

		for(Event objEvent : lstEvent)
		{
			if(mapOfLeads.containskey(objEvent.WhoId))
			{
				Lead objLead = mapOfLeads.get(objEvent.WhoId);
				objLead.Meeting__c = objEvent.Meeting__c; 
           		MeetingCountLeadList.add(objLead);
			}
		}
		if(MeetingCountLeadList != null && MeetingCountLeadList.size() > 0)
    		List<Database.SaveResult> lstLeadSaveResult = database.update(MeetingCountLeadList);//mahesh
		
	}*/	
	public void InsertCustomEventObject(Set<ID> setEventID)
	{
		if(setEventID != null && setEventID.size() > 0)
		{
			List<Event> lstEvent = new List<Event>();
	                lstEvent = [Select e.StartDateTime, 
	                                   e.OwnerId,
	                                   e.Subject,
	                                   e.From_Time__c,
	                                   e.To_Time__c,
	                                   e.Meeting_Start_Date__c,
	                                   e.Meeting__c, e.Id,
	                                   e.Event_Status__c,
	                                   e.Event_Place__c,
	                                   e.Event_Category__c,
	                                   e.EndDateTime,e.Location,
	                                   e.Description,e.IsAllDayEvent,
	                                   e.Completion_Date__c
	                             From Event e where e.Id
	                             IN :setEventID ];
	       
            if(lstEvent != null && lstEvent.size()>0){
                List<Event__c> lstCustomEvent = new List<Event__c>();
                for(Event objEvent:lstEvent){
                	if(objEvent.Description != null && objEvent.Description != '')
                	{
	                    Event__c objCustomEvent = new Event__c();
	                    objCustomEvent.Name = (String.valueOf(objEvent.Description).length() > 80 ? String.valueOf(objEvent.Description).substring(0,76)+'...' : objEvent.Description);
	                    objCustomEvent.All_Day_Event__c = objEvent.IsAllDayEvent;
	                    objCustomEvent.Completion_Date__c =objEvent.Completion_Date__c; 
	                    objCustomEvent.Description__c = objEvent.Description;
	                    objCustomEvent.End__c = objEvent.EndDateTime;
	                    objCustomEvent.Event_Category__c = objEvent.Event_Category__c;
	                    objCustomEvent.Event_Status__c = objEvent.Event_Status__c;
	                    objCustomEvent.StartDateTime__c = objEvent.StartDateTime;
	                    objCustomEvent.Location__c = objEvent.Location;
	                    objCustomEvent.Event_Place__c = objEvent.Event_Place__c;
	                    objCustomEvent.Meeting__c = objEvent.Meeting__c;
	                    objCustomEvent.Completion_Date__c = objEvent.Completion_Date__c;
	                    objCustomEvent.To_Time__c = objEvent.To_Time__c;
	                    objCustomEvent.From_Time__c = objEvent.From_Time__c;
	                    objCustomEvent.Meeting_Start_Date__c = objCustomEvent.Meeting_Start_Date__c;
	                    lstCustomEvent.add(objCustomEvent);
                	}
                }
                List<Database.Upsertresult>lsttmpSaveResult = Database.upsert(lstCustomEvent);
        	}
		}
	}
}