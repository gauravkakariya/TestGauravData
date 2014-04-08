global class SchedulePortfolioReport implements Schedulable{
    
     global void execute(SchedulableContext SC) {
        //String email = 'tech@ffreedom.in';
        CreatePortfolioReport crd = new CreatePortfolioReport();
        crd.query = 'Select p.Units__c,p.Unique_Name__c, p.Asset_Class__c,p.Type__c, p.Transaction__c, p.Scheme_Name__c, p.Product__c, p.Net_Gain__c, p.NAV__c, p.NAV_Date__c, p.Id, p.Folio_Number__c, p.Entity__c, p.Days__c, p.Current_Value__c, p.Current_Date__c, p.CurrencyIsoCode, p.Annualized_Return__c, p.Amount__c, p.Absolute_Return__c From Purchase_Sales_Report__c p where Transaction__c=\'Purchase\' ORDER BY Nav_Date__c ASC';
        crd.email= 'tech@ffreedom.in';
        
        database.executebatch(crd);
    } //close execute method
    
}