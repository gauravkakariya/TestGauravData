public with sharing class LoanAnalyticsController {

public Loan__c Loanobj {get; set;}
public List<Loan__c> lstLoans {get;set;}
public NewCashFlowController CashFlow;
public LoanAnalyticsController()
    {
    	lstLoans=[Select l.Loan_Type__c, l.EMI__c, l.Financial_Institution__c, l.Interest_Rate__c, l.Balance_No_of_Years__c, l.Term_No_of_years__c From Loan__c l];
    	system.debug('--------lstLoans-------------'+lstLoans);
    	
    }
}