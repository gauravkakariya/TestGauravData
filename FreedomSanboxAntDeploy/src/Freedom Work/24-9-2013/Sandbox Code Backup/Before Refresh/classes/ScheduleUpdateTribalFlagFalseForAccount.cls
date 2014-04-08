global class ScheduleUpdateTribalFlagFalseForAccount implements Schedulable {
	global void execute(SchedulableContext SC) {
    UpdateTribalFlagToFalseForAccount tribalActivityFalse = new UpdateTribalFlagToFalseForAccount();
    tribalActivityFalse.query = 'Select Tribal_Activity_Flag__c From Account where RecordType.Name=\''+ 'Client' + '\' OR (RecordType.Name=\''+'Influencers' + '\'  AND Category__c != \'Press\')';
    tribalActivityFalse.email= 'tech@ffreedom.in';
    database.executebatch(tribalActivityFalse);   
	} 
}