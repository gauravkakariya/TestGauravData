global class TaskEscalationScheduler implements Schedulable 
{
	global void execute(SchedulableContext sc)
   {
      BatchTaskEscalation b = new BatchTaskEscalation(); 
      database.executebatch(b);
   }


	/*TaskEscalationScheduler m = new TaskEscalationScheduler();
	String sch = '0 06 18 * * ?';
	String jobID = system.schedule('Task Job', sch, m);*/
}