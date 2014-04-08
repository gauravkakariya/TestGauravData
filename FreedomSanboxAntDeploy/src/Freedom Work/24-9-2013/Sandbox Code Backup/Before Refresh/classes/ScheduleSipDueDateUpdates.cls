global class ScheduleSipDueDateUpdates implements Schedulable {
	global void execute(SchedulableContext SC) {
        //String email = 'tech@ffreedom.in';
        CalculateSipNextDueDates calSip = new CalculateSipNextDueDates();
        calSip.query ='Select s.Frequency__c, s.Due_Date__c From SIP_Tracker__c s';
        calSip.email= 'tech@ffreedom.in';
        database.executebatch(calSip); 
	} 
}