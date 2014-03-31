/*
	Revision History:
    Version     Version Author    Date          Comments
	2.0			Prajakta Sanap	 25/09/2013   1.Trigger for Department
*/

trigger DepartmentTrigger on Department__c (before delete) 
{
	if(trigger.isBefore && trigger.isDelete)
    {
    	
    }
}