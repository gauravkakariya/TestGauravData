global class ScheduleSummaryReturnCalculation implements Schedulable{
 	global void execute(SchedulableContext SC) {
        CalculateReturnsforSummaryReport cal = new CalculateReturnsforSummaryReport();
        cal.email= 'tech@ffreedom.in';
        cal.query='Select Gain__c, Units_Quanitity__c, Scheme_Scrip_Name__c, Product__c, Purchase_Amount__c, Portfolio_Type__c, Folio_Number__c, Current_Value__c,Absolute_Ret__c,Annualized_Ret__c,UniqueName__c,Nav_p__c From Portfolio_Report__c';
        database.executebatch(cal);
    } //close execute method
}