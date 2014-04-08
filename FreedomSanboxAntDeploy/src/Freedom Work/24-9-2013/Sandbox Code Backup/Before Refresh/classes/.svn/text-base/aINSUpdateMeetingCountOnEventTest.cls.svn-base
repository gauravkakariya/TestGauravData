/*
	
Revision History:

   Version     Version Author     Date          Comments
   1.0         Persistent         NA  		  	Initial Draft
   
   2.0 		   Manasi Ranade	  15/09/2011	Issue id: FS0152 :
   											    Change in function OnInsertEvetnt():
   											    Assigned required field values.
*/		
@isTest
private class aINSUpdateMeetingCountOnEventTest{
	/*Test Method start*/
	static testmethod void OnInsertEvetnt()
	{
		List<User> lstUser = [Select u.IsActive, u.Id From User u Where u.IsActive = True and u.Profile.Name = 'System Administrator'];
		Lead objLead = new Lead();
		objLead.LastName = 'TestLead';
		insert objLead;
		
		Event objEvent = new Event();
		objEvent.OwnerId = lstUser[0].Id;
		objEvent.WhoId = objLead.id;
		objEvent.DurationInMinutes = 10;
		objEvent.Event_Status__c = 'complete';
		objEvent.Description = 'Test Description';
		objEvent.ActivityDateTime = System.today();
		objEvent.Completion_Date__c = System.today().addDays(2);
		objEvent.StartDateTime = System.today();
		objEvent.Event_Place__c = 'place';
		objEvent.Event_Category__c ='Meeting';
		objEvent.To_Time__c = '10';
        objEvent.From_Time__c = '20';
		insert objEvent;
		
		Event objEvent2 = new Event();
		objEvent2.OwnerId = lstUser[0].Id;
		objEvent2.WhoId = objLead.id;
		objEvent2.DurationInMinutes = 10;
		objEvent2.Event_Category__c ='Meeting';
		objEvent2.To_Time__c = '10';
        objEvent2.From_Time__c = '11';
        //Manasi to remove following error:
        /** Eternus Solutions  **/
		/** Author  : Manasi Ranade	**/
		/** Issue Id: FS0152      	**/
		/** Date    : 15/09/2011 	**/
		/** Purpose : Asigned the required fields before inserting record**/
		/****************************************************/
        objEvent2.Event_Place__c = 'place';
		objEvent2.Completion_Date__c = System.today().addDays(2);
		objEvent2.ActivityDateTime = System.today();
		insert objEvent2;
		
		objEvent2.Event_Status__c = 'complete';
		objEvent2.Description ='test';
		update objEvent2;
	}
	/*Test Method ends*/
}