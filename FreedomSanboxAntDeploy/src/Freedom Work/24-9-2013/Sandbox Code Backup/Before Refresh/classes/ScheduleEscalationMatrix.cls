/*
	
Revision History:

   Version     Version Author     Date          Comments
    2.0 	    Aditi Satpute	  02/07/2012	Issue id: 00001677 :Change in query:Added Stop_Escalation_Emails__c=false.
*/		

global class ScheduleEscalationMatrix implements schedulable
{
	global void execute(SchedulableContext SC)
	{
		String entityStatus = 'Active';
		BatchEscalationMatrix objBatchEscalationMatrix = new BatchEscalationMatrix();
		Id clientRecTypeId = [Select Name, Id From RecordType where Name = 'Client' limit 1].Id;
		/** Eternus Solutions  **/
		/** Author  : Aditi Satpute	**/
		/** Issue Id: 00001677   	**/
		/** Date    : 02/07/2012 	**/
		/** Purpose : Fetch only those records whose 'Stop_Escalation_Emails__c'  field is not selected, So added Stop_Escalation_Emails__c=false in the query**/
		/****************************************************/
		objBatchEscalationMatrix.query = 'Select OwnerId, Owner.Name, Owner.FirstName, Owner.Email, PersonContactId, CreatedDate, Plan__c, Email_Temp__c, Email_ID__c,Plan_Writing_Date__c, Plan_Approved_Date__c, Name, LastName, Id, FirstName, Execution_Completion_Dates__c,Data_Collection_Date__c, Action_Plan_Generation_Date__c, First_Execution_Completion_Date__c, Stop_Escalation_Emails__c From Account where Entity_Status__c != ' + '\'' +'Suspended' + '\'' + ' and RecordTypeId = ' +'\'' + clientRecTypeId + '\' and Stop_Escalation_Emails__c=false and Owner.Name!='+'\'' + 'Technology Support'+'\'';
		System.debug('**objBatchEscalationMatrix.query****'+objBatchEscalationMatrix.query );
		Database.ExecuteBatch(objBatchEscalationMatrix,50);
	}
}