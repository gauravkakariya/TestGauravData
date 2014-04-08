global class ScheduleUpdateTribalFlagToFalseForLead implements Schedulable{
	global void execute(SchedulableContext SC) {
    
   
    UpdateTribalFlagToFalseForLead tribalActivityFalse = new UpdateTribalFlagToFalseForLead();
    tribalActivityFalse.query =' Select Tribal_Activity_Flag__c From Lead where Status != \'Converted\'';
    tribalActivityFalse.email= 'tech@ffreedom.in';
    database.executebatch(tribalActivityFalse);   
	} 
}