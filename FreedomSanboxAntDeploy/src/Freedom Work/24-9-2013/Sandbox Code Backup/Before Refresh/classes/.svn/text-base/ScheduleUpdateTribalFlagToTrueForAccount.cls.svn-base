global class ScheduleUpdateTribalFlagToTrueForAccount implements Schedulable {
	global void execute(SchedulableContext SC) {
    UpdateTribalFlagToTrueForAccount tribalActivityTrue = new UpdateTribalFlagToTrueForAccount();
    tribalActivityTrue.query ='Select Tribal_Activity_Flag__c From Account where RecordType.Name=\''+ 'Client' + '\' OR (RecordType.Name=\''+'Influencers' + '\'  AND Category__c != \'Press\')';
    tribalActivityTrue.email= 'tech@ffreedom.in';
    database.executebatch(tribalActivityTrue);  
	} 
}