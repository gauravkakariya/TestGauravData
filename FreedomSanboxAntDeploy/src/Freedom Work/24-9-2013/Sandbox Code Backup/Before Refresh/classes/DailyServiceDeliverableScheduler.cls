/*  Version		Author				Date			Comments
 *	1.0			Dipak Niakm							Initial Draft
 *	1.1			Mahesh Hirugade		14/3/2012	    Added filters to query : Account Rec Type is Client & Account Status is Active.
*/

global class DailyServiceDeliverableScheduler implements Schedulable
{
	public Date currentDate{set;get;}
	public DailyServiceDeliverableScheduler()
	{
		
	}
	
	global void execute(SchedulableContext SC) 
	{
		currentDate = System.today();
		String strActive='Active';
		Id clientRecType = [Select r.Name, r.Id From RecordType r where r.Name = 'Client' limit 1].Id;
		String strQuery = 'Select s.Start_Date__c, s.RelatedAccount__c, s.RecordType.Name, s.RecordTypeId,s.RelatedAccount__r.OwnerId, s.Name, s.Meeting__c, s.Id, s.Expiration_Date__c, s.End_Date__c, s.Completed__c, s.Call__c, s.RelatedAccount__r.RecordTypeId, s.RelatedAccount__r.Entity_Status__c From Service_Deliverables__c s where Completed__c = false and s.RelatedAccount__r.RecordTypeId ='+ '\'' + clientRecType + '\'' + ' and s.RelatedAccount__r.Entity_Status__c = ' + '\'' + strActive + '\'';
		BatchDailyServiceDeliverableUpdate  objBatchDailyServiceDeliverableUpdate =  new BatchDailyServiceDeliverableUpdate();
		objBatchDailyServiceDeliverableUpdate.query = strQuery;
		objBatchDailyServiceDeliverableUpdate.dtCurrentDate = currentDate;
		Database.executeBatch(objBatchDailyServiceDeliverableUpdate,10); 
	}
}