global class ScheduleClassForPortal implements Schedulable {

   global void execute(SchedulableContext ctx) {
   	
   	ScheduleForPortal SFP = new ScheduleForPortal();
   	database.executeBatch(SFP);
   }   
}