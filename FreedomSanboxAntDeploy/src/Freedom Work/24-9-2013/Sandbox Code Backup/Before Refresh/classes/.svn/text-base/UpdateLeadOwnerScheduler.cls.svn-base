global with sharing class UpdateLeadOwnerScheduler implements Schedulable{
	
	public static string cronString = '0 53 * * * ?';
	public static string jobName = 'UpdateLeadOwnerScheduler'+system.now();
	
	global void execute(SchedulableContext sc) {
      UpdateLeadOwnerBatch updateLeadOwner = new UpdateLeadOwnerBatch(); 
      database.executebatch(updateLeadOwner);
   }
	
}