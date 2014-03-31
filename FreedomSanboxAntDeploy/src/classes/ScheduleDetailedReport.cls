global class ScheduleDetailedReport implements Schedulable{
    
     global void execute(SchedulableContext SC) {
        //String email = 'tech@ffreedom.in';
        CalculateReturnsforDetailReport crd = new CalculateReturnsforDetailReport();
        crd.query = 'Select p.Units__c, p.Unique_Name__c, p.Type__c, p.Transaction__c, p.Scheme_Name__c, p.Product__c, p.Net_Gain__c, p.NAV__c, p.NAV_Date__c, p.Id, p.Folio_Number__c, p.Entity__c, p.Days__c, p.Current_Value__c, p.Current_Date__c, p.CurrencyIsoCode, p.Annualized_Return__c, p.Amount__c, p.Absolute_Return__c From Purchase_Sales_Report__c p';
        crd.email= 'tech@ffreedom.in';
        
        database.executebatch(crd);
    } //close execute method
    
}