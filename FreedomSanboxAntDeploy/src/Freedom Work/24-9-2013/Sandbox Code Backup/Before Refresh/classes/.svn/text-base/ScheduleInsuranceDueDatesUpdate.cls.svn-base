global class ScheduleInsuranceDueDatesUpdate implements Schedulable {
	global void execute(SchedulableContext SC) {
        //String email = 'tech@ffreedom.in';
        CalculateInsuranceNextDueDates calIns = new CalculateInsuranceNextDueDates();
        calIns.query ='Select i.Premium_Frequency__c,  i.Premium_Due_date__c From Insurance__c i';
        calIns.email= 'tech@ffreedom.in';
        database.executebatch(calIns); 
    } //close execute method
}