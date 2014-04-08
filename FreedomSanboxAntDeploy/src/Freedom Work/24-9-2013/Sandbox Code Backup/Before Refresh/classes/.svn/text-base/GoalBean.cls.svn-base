/**
 * @Description: GoalBean class is used to populate data of goalVFpage associated with goals
 */

public class GoalBean
{
    public List<String> AccountNameList{get;set;}
    public String EntityId{get; set;}
    public list<goal__c>goalList{get;set;}
    public list<goal__c>addNewListView{get;set;}
    
    // public list<goalTypeClass> goalTypeClassList{get;set;}
    public list<string> goalTypeList{get;set;}
    public List<AggregateResult> AggQueryResult {get; set;}
    public string selGoalType{get;set;}
    public Boolean displayPopUp{get; set;}
    
    public GoalBean()
    {
        addNewListView = new list<goal__c>();
    }
    
    
    /* public class goalTypeClass
    {
        public String goalType{get; set;}
        public List<InnerClass> InnerClassList {get; set;}  
         
        //GeneralExpensesClass Constructor        
        public goalTypeClass()
        {
            InnerClassList  = new List<InnerClass>();
        }
    }
    public class InnerClass
    {
        public String AccountName {get; set;}
        public Double AmountValue {get; set;}  
              
        //InnerClass Constructor      
        public InnerClass(String AccName, Double Amt)
        {
            AccountName = AccName;
            AmountValue = Amt;
        }
    }*/
    /**
     * @Description: isRowEmpty is used to check whether row is empty or not before save function is called
     */
     
    public Boolean isRowEmpty(Goal__c goal)
    {
        if(goal.Goal_Type__c == null && goal.Description__c == null && goal.Priority__c == null && 
        	goal.Goal_Start_Year__c==null && goal.Goal_End_Year__c==null && goal.Inflation_Rate__c==null && 
        	goal.Cost_of_Goal_Annual__c==null && goal.Goal_Frequency__c==null)
            return true;
        else
            return false;
    }
    
    /**
     * @Description: validate function is used to check mandatory fields to be added and through error if required
     */
    public void validate(Goal__c goal) 
    {                                       
        if(goal.Goal_Type__c==null)
             throw new ValidationException(Label.GoalTypeValidation);    
                                                  
        if(goal.Description__c==null)
             throw new ValidationException(label.GoalDescriptionValidation);  
        if(goal.Cost_of_Goal_Annual__c==null)
             throw new ValidationException(Label.CostOfGoalValidation); 
              
        if(goal.Goal_End_Year__c==null)
             throw new ValidationException(Label.EndYearRequired);  
             
        if(goal.Goal_Start_Year__c==null)
             throw new ValidationException(Label.StartYearRequired);  
             
        if((goal.Goal_End_Year__c!=null && goal.Goal_Start_Year__c!=null && goal.Goal_End_Year__c < goal.Goal_Start_Year__c))
             throw new ValidationException(Label.EndYearValidation);
    }
     
}