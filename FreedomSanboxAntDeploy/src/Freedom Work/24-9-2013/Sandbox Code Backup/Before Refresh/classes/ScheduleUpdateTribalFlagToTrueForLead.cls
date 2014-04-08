global class ScheduleUpdateTribalFlagToTrueForLead implements Schedulable {
	global void execute(SchedulableContext SC) {
    
   
    UpdateTribalFlagToTrueForLead tribalActivityTrue = new UpdateTribalFlagToTrueForLead();
    tribalActivityTrue.query =' Select Tribal_Activity_Flag__c From Lead where Status != \'Converted\'';
    tribalActivityTrue.email= 'tech@ffreedom.in';
    database.executebatch(tribalActivityTrue);   
	} 
}