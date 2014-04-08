/*
	Revision History:
	
    Version     Version Author     Date           Comments
    1.0			Aditi	   		  9/4/13	 Renewal Tracker Trigger - To create child record once submission date is entered.
*/

trigger RenewalTrackerTrigger on Renewal_Tracker__c (before update) 
{
	if (trigger.isBefore && trigger.isUpdate) 
	{
		new RenewalTrackerHandler (trigger.old,trigger.new).execute();
	}
}