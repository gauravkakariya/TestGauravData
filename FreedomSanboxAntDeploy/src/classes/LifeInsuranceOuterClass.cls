/**
 * @Author: Samruddhi P
 * @since : 18th Feb 2011
 * @Description: LifeInsuranceouterClass is class used for LifeInsurancePlanningPage in Analysis Section
 */
/*

TODO :
     1) For Life Insurance Planning Page, when we select last entity from dropdownList 
     	'Select Entity for Insurance calculation' and click on 'calculate' button,It displays error as :
     	'List index out of bounds : 2' .
     2)	This error is coming from function : getExpensetotal for the value : summary.detailList[2].amountValue
     3) The logic behind the calculation is not known.Hence issue is not resolved yet

Issue ID : F0016
     	
      
*/
/*

  Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
    2.0			Manasi			 06/06/2011	 Checked size of List before fetching elements in getExpensetotal() function
    2.0			Manasi			 06/06/2011	 Case No: 00001616 
    										 Throw Exception if Spouce or Dependent entity is not Specified in Validate Account Function
   
      
*/
/*
	Need verification : 
	Issue Id 		: F0016 
	Function Name	: getExpensetotal()
	Description 	: When size of the list summary.detailList is less than 3, need to verify the calculation.
*/
public class LifeInsuranceOuterClass
{
    public Double total 
    {
        get
        {
            if(total == 0 && detailList!=null)
            {
                total=0;
                for(InnerClass innerClassObj: detailList)
                {
                    if(innerClassObj.amountValue!=null)
                        total=total+innerClassObj.amountValue;
                }
            }    
            if(total == null) 
                total = 0;
        	return total;
        } 
        set;
    }  
    
    public Double presentValue
    {
        get
        {
            if(presentValue == null)
            {
                presentValue = 0;
            }
            return presentValue;
        }
        set;
    } 
      
    public List<InnerClass> detailList
    {
        get
        {
            if(detailList == null)
            {
                detailList  = new List<InnerClass>();
            }
            return detailList;
        }
        set;
    }  
    /**
    * @Description: Constructor to initialise the class
    * @param: None 
    */     
    public LifeInsuranceOuterClass(){
        presentValue = 0;
        total = 0;
    }
    
    /**
    * @calculatepresentValue() function returns the Present Value (PV)
    * @params:Double rate,Integer noOfYears,Double premiumAmount
    * @Return Type:Double 
    */   
    public static Double calculatepresentValue(Double rate,Integer noOfYears,Double premiumAmount){
    	Long intermediateValue = 0;
    	Long divisorValue = 0;
    	Double pv = 0;
    	if(rate != 0)
        intermediateValue=math.roundToLong( ( ( math.pow((1+rate),noOfYears) ) -1 )/rate );
        divisorValue=math.roundToLong( math.pow( (1+rate),noOfYears-1 ) );
       
        if(rate != 0 && math.pow( (1+rate),noOfYears-1 ) != 0)
        pv=( ( premiumAmount* ( ( math.pow((1+rate),noOfYears) ) -1 ) /rate ) / (math.pow( (1+rate),noOfYears-1 )) );
        
       
        return pv;
    }

    /**
    * @calculateAdjustedRate() function adjusted rate
    * @params:Double rate1,Double rate2
    * @Return Type:Double 
    */ 
    public static Double calculateAdjustedRate(Double rate1, Double rate2){
        Double AdjustedRate=( ( rate1 - rate2 )/ ( 1 + rate2 ) );
        return AdjustedRate;
    }
    
    /**
    * @validateAccount() function used for validation of entity and spouse account
    * @params:Account entity, Account spouse
    * @Return Type:void
    */
    /** Eternus Solutions  **/
  /** Author  : Manasi Ranade	**/
  /** Issue Id: 00001616      **/
  /** Date    : 07/05/2012 	**/
  /** Purpose : Throw Exception if Spouce or Dependent entity is not Specified**/
  /****************************************************/
    public static void validateAccount(Account entity, Account spouse)
    {
        if(entity.PersonBirthdate==null){
            throw new GeneralException(entity.Name+' '+Label.BirthdateValidation); 
        }    
        if(entity.Retirement_Age__c==null){
            throw new GeneralException(entity.Name+' '+Label.RetirementAgeValidation); 
        }
        if(spouse == null)
        	throw new GeneralException(Label.SpouceDependentNotSpecified);
        if(spouse != null)
        {
	        if(spouse.PersonBirthdate==null){
	            throw new GeneralException(spouse.Name+' '+Label.BirthdateValidation); 
	        }
	        if(spouse.Estimated_Life_Expectancy__c==null){
	            throw new GeneralException(spouse.Name+' '+Label.LifeExpectancyValidation); 
	        }
        }
    }
    
    /**
    * @validateAssumptions() function used for validation of global assumptions
    * @params:Entity_Global_Assumption__c assumption
    * @Return Type:void
    */
    public static void validateAssumptions(Entity_Global_Assumption__c assumption)
    {
        if(assumption.Expected_Return_on_Investment__c==null)
        {
            throw new GeneralException(Label.ReturnOnInvestmentValidation); 
        }    
        if(assumption.Inflation_Rate__c==null)
        {
            throw new GeneralException(Label.InflationRateValidation); 
        }
        if(assumption.Income_Growth_Rate__c==null)
        {
            throw new GeneralException(Label.IncomeGrowthRateValidation); 
        }
    }
    
    /**
    * @getExpensetotal() function used for calculating total of expense according to adjustment factor
    * @params:LifeInsuranceOuterClass 
    * @Return Type:void
    */
    public void getExpensetotal(LifeInsuranceOuterClass summary)
    {
        Double total;
		/** Eternus Solutions       **/
		/** Author  : Manasi			**/
		/** Issue Id: F0016      	**/
		/** Date    : 06/06/2011 	**/
		/** Purpose : Checked size of List before fetching elements**/
		/****************************************************/ 
		/*When size of the summary.detailList is less than 3, need to verify the calculation.*/
        if(summary.detailList.size() >= 3)
        { 
	        total=((summary.detailList[0].amountValue*(1+(summary.detailList[1].amountValue/100)))-summary.detailList[2].amountValue);
	        summary.total=total;
        }
        else if(summary.detailList.size() >= 2)
        {
        	total=(summary.detailList[0].amountValue*(1+(summary.detailList[1].amountValue/100)));
        	summary.total=total;
        }
        else if(summary.detailList.size() >= 1)
        {
        	total=(summary.detailList[0].amountValue);
        	summary.total=total;
        }
    }

}