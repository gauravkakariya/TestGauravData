/*
	
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
    2.0			Manasi			   10/06/2011	Replaced hardcoded 2011 year by current year in getSurplus() function
    											Its reflection is on 'Cash flow - Projection' Page
    2.0			Manasi			   4/8/2011  	Issue Id : FS0090
    											Class Name : NewCashFlowBean
    											1. Added New function getSurplusForCashFlowPage() that will calculate surplus amount for cash flow page
												The function is same as getSurplus() function.
												But it will return negative surplus if Expense > income.
												But getSurplus() will not return negative surplus any case 
    											2. Called newly created function from getFirstYearDifference() frunction											
*/
	 	
		
public class NewCashFlowBean 
{
    public List<NewSummaryBean> summaryList { get;set;}            
    private Integer endYear {get; set;}
    public boolean isMonthlySurplusNegative{set;get;}
    
    public DatabaseSOQL dbQuery;
    public Integer planYear; 
    public Account objAccount{get;set;}
    public String entityId {get;set;}
    
    public NewCashFlowBean(List<NewSummaryBean> summaryBeanList, Integer endYear)
    {
    	//isMonthlySurplusNegative = false;
        summaryList = summaryBeanList;
        this.endYear = endYear;
        this.isMonthlySurplusNegative = false;
        
        dbQuery = new DatabaseSOQL();
        /* Prajakta - FP changes - 02-05-2013 */
        entityId = System.currentPageReference().getParameters().get('entityId');
        objAccount = dbQuery.getEntity(entityId);
        if(objAccount.Plan_Generation_Date__c != null) 
        	planYear = objAccount.Plan_Generation_Date__c.year();
        else
        	planYear = system.today().year();
    }
    
    public List<Double> getDifference 
    {
        get
        {
			List<Double> summaryDiffList = new List<Double>();
			System.debug('*******endYear:'+endYear);					            			            
            for(Integer index =0 ;index <= endYear ;index++) 
            {
		        summaryDiffList.add(getSurplus(index));
            }
            System.debug('*******summaryDiffList:'+summaryDiffList);
            return summaryDiffList;
		}
	} 
	
	private Double getSurplus(Integer index) 
	{
		NewSummaryBean incomeBean,expenseBean;
		Double surplus=0,totalIncome=0,totalExpense=0;
		Integer incomeIndex,expenseIndex;
		incomeBean  = summaryList.get(0);
        expenseBean = summaryList.get(1);
        //Previous code with hard coded value 
        
        //incomeIndex = incomeBean.totalValueMap.get(2011 + index); // need to remove hard coding
        //expenseIndex = expenseBean.totalValueMap.get(2011 +index);
        
        /** Eternus Solutions       **/
		/** Author  : Manasi		**/
		/** Issue Id: F0046      	**/
		/** Date    : 10/06/2011 	**/
		/** Purpose : Replaced hardcoded 2011 year by current year	**/
		/****************************************************/  
		//error.DebugLog('------planYear bean-------'+planYear);
		
		integer i= planYear + index;
        incomeIndex = incomeBean.totalValueMap.get(planYear + index); /* Prajakta - FP changes - 3-5-2013 - Date.today().year() */
        System.debug('****** index: ' + index);
        System.debug('****** incomeIndex: ' + incomeIndex);
        expenseIndex = expenseBean.totalValueMap.get(planYear + index);
        
        System.debug('****** totalValueMap: ' + expenseBean.totalValueMap);
        totalIncome  = incomeBean.totalValueByYear.get(incomeIndex);
        totalExpense = expenseBean.totalValueByYear.get(expenseIndex); 
        
		surplus = totalIncome  - totalExpense;
		if(totalIncome < totalExpense) {
			//surplus = totalExpense - totalIncome;  /* Case No : 00001592 : mahesh */
		}
		return math.floor(surplus);
	}
	
	public Double getMonthlyDifference 
	{
		get
		{
			isMonthlySurplusNegative = true;
			/*if(math.floor(getSurplus(0)/12) < 0)
				isMonthlySurplusNegative = true;
				isMonthlySurplusNegative = true;
				Error.debugLog('=== isMonthlySurplusNegative : ' + isMonthlySurplusNegative);	
				System.debug('=== isMonthlySurplusNegative : ' + isMonthlySurplusNegative);*/
			return 	math.floor(getSurplus(0)/12);
		}
	}
	
	/** Author  : Manasi - FS0090 - 4/8/2011  : Added New function that will calculate surplus amount for cash flow page	**/	
	public Double getFirstYearDifference 
	{
		get 
		{
			return getSurplusForCashFlowPage(0);
		}
	}
	 
	/** Author  : Manasi : FS0090 : 4/8/2011	 	**/
	/** Purpose : Added New function that will calculate surplus amount for cash flow page
				  The function is same as getSurplus() function.
				  But it will return negative surplus if Expense > income.
				  But getSurplus() will not return negative surplus any case **/

	private Double getSurplusForCashFlowPage(Integer index)
	{
		NewSummaryBean incomeBean,expenseBean;
		Double surplus=0,totalIncome=0,totalExpense=0;
		Integer incomeIndex,expenseIndex;
		incomeBean  = summaryList.get(0);
        expenseBean = summaryList.get(1);
		integer i= planYear + index;
        incomeIndex = incomeBean.totalValueMap.get(planYear + index); /* Prajakta - FP changes - 3-5-2013 - Date.today().year() */
        expenseIndex = expenseBean.totalValueMap.get(planYear + index);
        totalIncome  = incomeBean.totalValueByYear.get(incomeIndex);
        totalExpense = expenseBean.totalValueByYear.get(expenseIndex); 
		surplus = totalIncome  - totalExpense;
		
		return math.floor(surplus); 						
	}
}