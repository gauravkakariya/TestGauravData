/*
 * @Author: Samruddhi P
 * @Description:IncomeBean is bean class for IncomeSummaryPage
 */
public class IncomeBean{
    public String selRecordTypeId {get; set;}
    public String selRecordTypeName {get; set;}
    public List<Income__c> incomeList {get; set;}
    public List<Account> accountList {get; set;}
    public List<OuterClass> summaryTableList{
        get{
            if(summaryTableList == null)
                    summaryTableList=new List<OuterClass>();                      
            return summaryTableList;
        }    
        set;
    }
    public Boolean displayPopUp {get; set;}
    public Boolean displaySalaryFields {get; set;}
    public Boolean displayBusinessFields {get; set;}
    public Boolean displayRentalFields {get; set;}
    public Boolean displayPensionFields {get; set;}
    public Boolean displayIncomeTypeField {get; set;}
    
    /**
    * Description: Constructor to initialise the bean
    */
    public IncomeBean(){
        displaySalaryFields = false;
        displayBusinessFields = false;
        displayRentalFields = false;
        displayPensionFields = false;
        displayIncomeTypeField  = false;
    }    
    
    /** 
    * This method is to check whether row is empty
    * Param: Income__c
    * Returns: Boolean               
    */
    public Boolean isRowEmpty(Income__c income){
        Boolean result = false;
        if(income.Start_Year__c==null)
            if(income.End_Year__c==null)
                if(income.Income_Growth_Rate__c==null)
                    if(income.Income_Amount__c==null)
                        if(income.Employer__c==null)
                            if(income.Business_Name__c==null)
                                if(income.Income_Type__c==null)
                                    if(income.Property_Name__c==null)
                                        if(income.Beneficiary__c==null)
                                            result = true;
                                                               
        return result;
    }
    
    /** 
    * validate() function validates data entered
    * Parameter: Income__c object
    * Returns: void              
    */
    public static void validate(Income__c incomeInstance){                                       
         if(incomeInstance.Income_Growth_Rate__c==null){
             throw new ValidationException(Label.GrowthRateRequired); 
         }
         if(incomeInstance.Income_Amount__c==null){
             throw new ValidationException(Label.IncomeAmountRequired); 
         }
         if(incomeInstance.End_Year__c != null && incomeInstance.Start_Year__c !=null  &&  (integer.valueOf(incomeInstance.End_Year__c) < integer.valueOf(incomeInstance.Start_Year__c))){
             throw new ValidationException(Label.EndYearValidation);
         }     
    }
}