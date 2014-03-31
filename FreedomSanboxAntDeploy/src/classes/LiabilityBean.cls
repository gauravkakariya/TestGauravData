/*
Revision History:

   Version     Version Author     Date          Comments
   1.0         Persistent         NA  		  	Initial Draft
   
   2.0         Niket Chandane	  05/06/2011    added the method getNetworthSummaryDetail() to fix the Issue F0035 for the NewworthPage
   												This method accept the AggregateResult and gets the Liability Type and it's value and set in the the
       						 					SummaryBean.SummaryDetail to show the List of liabilities on the NetworthPage
*/

public class LiabilityBean {
    
    public List<Loan__c> loanList { 
        get {
            if(loanList== null){
                loanList = new List<Loan__c>();
            }
            return loanList;
        } set;
    } 
     
    public static SummaryBean.SummaryDetail getSummary(AggregateResult result){
        Double totalLoan;       
        ID entityId;
        
        totalLoan = (Double)result.get('liabilities');
        SummaryBean.SummaryDetail summary = new SummaryBean.SummaryDetail('Liabilities',totalLoan);
        return summary;     
    }
    public static DataEntrySummaryBean getDataEntrySummary(DataEntrySummaryBean dataEntrySummaryBean,Map<ID,integer> indexMap,AggregateResult result){
                
        ID entityId;
        dataEntrySummaryBean.linkField = result.get('Loan_Type__c');    
        entityId = (ID) result.get('Entity__c');                        
        dataEntrySummaryBean.fieldList.set(indexMap.get(entityId),(Double)result.get('liabilities'));                                               
        return dataEntrySummaryBean;            
    }
    /**
        validate() function is used to check all required field are filled or not
    */
    public static void validate(Loan__c loanInstance) {                         
          
        if(loanInstance.Entity__c == null) {              
            throw new ValidationException(Label.EntityValidation);                           
        }      
        if((loanInstance.EMI__c == null) || loanInstance.EMI__c <=0) {              
            throw new ValidationException(Label.LoanEMIValidation);                           
        }
        if(loanInstance.Loan_Type__c == null) {             
            throw new ValidationException(Label.LoanTypeValidation);                         
        }
        /**
        * Modified by = Dipak Nikam
		* Case Subject = Need mandatory field for rate of interest in Liabilities Page
        * Case number  =  00001499 
        * Case owner =  Shewta Karia
        * Comment = Added below if loop for validation of Interest Rate %.
        **/
        if(((loanInstance.Interest_Rate__c== null) || (loanInstance.Interest_Rate__c <=0))) {
            throw new ValidationException(Label.InterrestRateValidation);
         }   
        if(((loanInstance.Balance_No_of_Years__c == null) || (loanInstance.Balance_No_of_Years__c <=0))) {
            throw new ValidationException(Label.BalanceNumberOfYearValidation);
        }   
    }
     /**
        isRowEmpty() function is used to check record is empty or not 
    */
    public static Boolean isRowEmpty(Loan__c loanInstance) {
                
        if((loanInstance.EMI__c == null) || (loanInstance.EMI__c == 0)) {
            if((loanInstance.Loan_Type__c == null)) {
                if(loanInstance.Financial_Institution__c == null) {
                    if(((loanInstance.Principal_Amount_Outstanding__c == null) || (loanInstance.Principal_Amount_Outstanding__c ==0))) {
                        if((loanInstance.Fixed_Floating__c == null) || (loanInstance.Fixed_Floating__c.trim().equals(''))){
                            if((loanInstance.Interest_Rate__c == null)) {
                                if((loanInstance.Balance_No_of_Years__c == null) || (loanInstance.Balance_No_of_Years__c == 0))
                                    if((loanInstance.Term_No_of_years__c== null) || (loanInstance.Term_No_of_years__c == 0))
                                        if((loanInstance.Prepayment_terms__c==null) || (loanInstance.Prepayment_terms__c.trim().equals('')))
                                            return true;        
                            }               
                        }               
                    }   
                }
            }
        }
        return false;            
    }
    /*
       Function Created By : Niket Chandane.
       Created On		   : 05 June 2011
       Summary 			   : This method accept the AggregateResult and gets the Liability Type and it's value and set in the the
       						 SummaryBean.SummaryDetail to show the List of liabilities on the NetworthPage [Issue F0035]
    */
    
     public static SummaryBean.SummaryDetail getNetworthSummaryDetail(AggregateResult liability){
        SummaryBean.SummaryDetail networthSummary;
        String liablityType;
        Double liablityValue;
        
        liablityType = (String)liability.get('Loan_Type__c');
        liablityValue = (Double) liability.get('liabilities');
        
        networthSummary = new SummaryBean.SummaryDetail(liablityType,liablityValue);  
        return networthSummary;
    }
}