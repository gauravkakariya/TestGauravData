/**
 * @Author: Dipak Nikam
 * @since :26th Dec 2011
 * @Description: ServiceDeliverableScheduler is Scheduler class which run on 1st April of every Year which checks ServiceDeliverable records in BatchServiceDeliverableUpdateCompFlag batch.
 *				1)if the expiration date is greater than 31st March then it creates the new  ServiceDeliverable records. 
 * 				2)Get all records where end date is 31st March of that year and set the Completed flag to true	
 *  @Mahesh
 *	1.1         Mahesh Hirugade		  14/3/2012	    Added filters to query : Account Rec Type is Client & Account Status is Active. 	
 */
global class ServiceDeliverableScheduler implements Schedulable 
{
	public Date currentDate{set;get;}
	public ServiceDeliverableScheduler ()
	{
		currentDate = System.today();
	}
	global void execute(SchedulableContext SC) 
	{
		Date dtDate = Date.newInstance(currentDate.year(), 3, 31);
		String strDate = String.valueOf(dtDate);
		String strActive='Active'; 
		Id clientRecType = [Select r.Name, r.Id From RecordType r where r.Name = 'Client' limit 1].Id;
		String strQuery = 'Select s.Start_Date__c, s.RelatedAccount__c, s.RecordTypeId, s.Name, s.Meeting__c, s.Id, s.Expiration_Date__c, s.End_Date__c, s.Completed__c, s.Call__c,s.RelatedAccount__r.RecordTypeId  From Service_Deliverables__c s where Completed__c = false and End_Date__c ='+strDate+'and s.RelatedAccount__r.RecordTypeId ='+ '\''+clientRecType + '\'' + ' and s.RelatedAccount__r.Entity_Status__c = ' + '\'' +strActive +'\'';
		
		BatchServiceDeliverableUpdateCompFlag objSeviceDeliverable =  new BatchServiceDeliverableUpdateCompFlag();
		objSeviceDeliverable.Datecurrent = currentDate;
		objSeviceDeliverable.query = strQuery;
		Database.executeBatch(objSeviceDeliverable,10);
	}
}