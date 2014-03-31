/* Scheduler for class BatchForCreatingTaskAndAssignToMST*/
global class CreateTaskAssignToMstScheduler implements Schedulable{

	global void execute(SchedulableContext SC)
	{
		BatchForCreatingTaskAndAssignToMST batchTask = new BatchForCreatingTaskAndAssignToMST();
		Database.executeBatch(batchTask);
	}
}