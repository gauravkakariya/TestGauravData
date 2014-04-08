/**
 * @Author: Samruddhi P
 * @since : 18th Feb 2011
 * @Description: LifeInsurancePlanningBean is bean class for LifeInsurancePlanningPage in Analysis Section
 */
/*
	Revision History:
	
    Version     Version Author     Date         Comments
    1.0         Persistent/        18/02/2011  	Initial Draft : LifeInsurancePlanningBean is bean class for LifeInsurancePlanningPage in Analysis Section
   				Samruddhi P
	
	2.0			Manasi Ranade	   17/04/2012    Issue Id : 00001597 : Added Property for Remark. Need to add different remark on each entity
	2.0  		Manasi Ranade	   07/05/2012    Issue Id : 00001616 : Created Property ObjRemark
	2.0			Manasi Ranade	   7/6/2012      Issue Id : 00001673 : Added insurance related Property that will hold analysis related Insurances
*/
public class LifeInsurancePlanningBean
{
	/** Eternus Solutions       **/
	/** Author  : Manasi Ranade **/
	/** Issue Id: 00001597     	**/
	/** Date    : 17/04/2012 	**/
	/** Purpose : Added Property for Remark. Need to add different remark on each entity
	/****************************************************/ 
    public String strRemark{get;set;}
    /** Eternus Solutions       **/
	/** Author  : Manasi Ranade **/
	/** Issue Id: 00001616      **/
	/** Date    : 07/05/2012 	**/
	/** Purpose : Created Property ObjRemark
	/****************************************************/
    public Remarks__c ObjRemark{get;set;}
    public String entityId {get; set;}
	/** Eternus Solutions      **/
	/** Author  : Manasi Ranade*/
	/** Issue Id: 00001673      **/
	/** Date    : 7/6/2012 **/
	/** Purpose : Added insurance related Property that will hold analysis related Insurances**/
			/****************************************************/
    public Insurance__c insuranceObj {get; set;}
    public Account entity {get; set;}
	//00001556 //Added property Spouse
	public Account spouse {get; set;}
	
    public Double liabilitiesTotal 
    {
        get{
            if(liabilitiesTotal == null){
                liabilitiesTotal = 0;
            }
            return liabilitiesTotal;
        }    
        set;
    } 
    
    public Double existingInsuranceTotal 
    {
        get{
            if(existingInsuranceTotal== null){
                existingInsuranceTotal= 0;
            }
            return existingInsuranceTotal;
        }
        set;
    }
    public Insurance__c insurance {get; set;} 
    public LifeInsuranceOuterClass goal 
    {
        get{
            if(goal == null){
                goal = new LifeInsuranceOuterClass();
            }
            return goal;
        }
        set;
    } 
                    
    public LifeInsuranceOuterClass expense
    { 
        get{
            if(expense == null){
                expense = new LifeInsuranceOuterClass();
            }
            return expense;
        }
        set;
    } 
                    
    public LifeInsuranceOuterClass asset
    { 
        get{
            if(asset == null){
                asset = new LifeInsuranceOuterClass();
            }
            return asset;
        }
        set;
    } 
    public LifeInsuranceOuterClass income
    {
        get{
            if(income == null){
                income = new LifeInsuranceOuterClass();
            }
            return income;
        }
        set;
    } 
    public LifeInsuranceOuterClass incomeAssumptions 
    {
        get{
            if(incomeAssumptions == null){
                incomeAssumptions = new LifeInsuranceOuterClass();
            }
            return incomeAssumptions ;
        }
        set;
    } 
    public LifeInsuranceOuterClass investAssumptions 
    {
        get{
            if(investAssumptions == null){
                investAssumptions = new LifeInsuranceOuterClass();
            }
            return investAssumptions ;
        }
        set;
    }
     
    public LifeInsuranceOuterClass entityAssumptions 
    {
        get{
            if(entityAssumptions == null){
                entityAssumptions = new LifeInsuranceOuterClass();
            }
            return entityAssumptions ;
        }
        set;
    } 
    
    public LifeInsuranceOuterClass spouseAssumptions 
    {
        get{
            if(spouseAssumptions == null){
                spouseAssumptions = new LifeInsuranceOuterClass();
            }
            return spouseAssumptions ;
        }
        set;
    } 
    
   public Double grossLifeInsRequired 
   {
        get{
            grossLifeInsRequired = 0;  
            if(expense.presentValue!=null && goal.total!=null)
            grossLifeInsRequired = liabilitiesTotal+expense.presentValue+goal.total;
        	return grossLifeInsRequired;
        }
        set;
    }

    public Double addLifeInsRequired 
    {
        get{
            Double totalSum = 0;
            if(existingInsuranceTotal!=null && income.presentValue!=null && asset.total!=null)
                totalSum = existingInsuranceTotal + income.presentValue + asset.total;
            addLifeInsRequired = grossLifeInsRequired - totalSum;
            return addLifeInsRequired;
        }
        set;
    }

    public Long roundTotalLifeInsRequired 
    {
        get
        {
            roundTotalLifeInsRequired = 0;  
            if(addLifeInsRequired!=null)
            {
                Decimal decValue=Decimal.valueOf(addLifeInsRequired);
                if(addLifeInsRequired > 1000000)
                    roundTotalLifeInsRequired = (decValue.divide(1000000,0,System.RoundingMode.HALF_EVEN)*1000000).longValue();
                else if(addLifeInsRequired < 1000000 && addLifeInsRequired > 1000)
                    roundTotalLifeInsRequired = (decValue.divide(1000,0, System.RoundingMode.HALF_EVEN) * 1000).longValue();
                else if(addLifeInsRequired < 1000 && addLifeInsRequired > 0)
                    roundTotalLifeInsRequired = (decValue.divide(10,0, System.RoundingMode.HALF_EVEN) * 10).longValue();
            }  
            return roundTotalLifeInsRequired;    
        }
        set;
    }
    
    /**
    * @Description: Constructor to initialise the service class
    * @param: None 
    */
    public LifeInsurancePlanningBean()
    {
    	roundTotalLifeInsRequired = 0;
        addLifeInsRequired = 0;
        grossLifeInsRequired = 0;
        existingInsuranceTotal = 0;
        liabilitiesTotal = 0;
    }
}