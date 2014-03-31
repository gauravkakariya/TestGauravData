/*
	
Revision History:

   Version     Version Author     Date          Comments
   1.0         Persistent         NA  		  	Initial Draft
   
   2.0         Niket Chandane	  10/06/2011     Added the two methods for the goal calculation
   												1]  calCompoundForAssetGrowth : 
   													Summry : To Calculate the future value of the asset when "To be grown till maturity and continous saving " 
				 											 is selected on "NewAssetAllocationPage"
				 								2] 	RaiseToPower :
				 									Summary : In apex it's not possible to get correct value for Math.Pow(1.009,0.083333) So this 
											                  function accepts the base and find out the correct raise to double value for the 
											                  base.
    1.0         Manasi Ranade     22/28/2011  	Issue Id :FS0118 : Change in function calCompoundForAssetGrowth:
    											Commmented previous logic.Added logic as per the excel provided by Haren
*/

public class FinancialUtil {

	public static Double calculateCompoundMonthly(Double pv,Double pmt,Integer totalNoOfPeriod, Double rate) {
		//Double timeValue=0,sum = 0,num = 100.0,divisor = 12 ;
		return pv * Math.pow(((100.0d + rate)/100.0d),1) + pmt 
					+ (pmt * Math.pow(((100.0d + rate)/100.0d),1.0d/12.0d))
					+ (pmt * Math.pow(((100.0d + rate)/100.0d),2.0d/12.0d))
					+ (pmt * Math.pow(((100.0d + rate)/100.0d),3.0d/12.0d))
					+ (pmt * Math.pow(((100.0d + rate)/100.0d),4.0d/12.0d))
					+ (pmt * Math.pow(((100.0d + rate)/100.0d),5.0d/12.0d))
					+ (pmt * Math.pow(((100.0d + rate)/100.0d),6.0d/12.0d))
					+ (pmt * Math.pow(((100.0d + rate)/100.0d),7.0d/12.0d))
					+ (pmt * Math.pow(((100.0d + rate)/100.0d),8.0d/12.0d))
					+ (pmt * Math.pow(((100.0d + rate)/100.0d),9.0d/12.0d))
					+ (pmt * Math.pow(((100.0d + rate)/100.0d),10.0d/12.0d))
					+ (pmt * Math.pow(((100.0d + rate)/100.0d),11.0d/12.0d)); 
					
		
		/*for(Integer i=1;i <=totalNoOfPeriod;i++){
			timeValue = (totalNoOfPeriod -i)/divisor;			
			if(i!= totalNoOfPeriod) {	
				sum = sum + (pmt * Math.pow(((num + rate)/num),timeValue));	
			}else {
				sum= sum +	pmt;
			}
			//System.debug('sum is ' + sum);						
		}*/
		/*if(pv != 0){
			sum = sum + pv *Math.pow(((100.0+ rate)/100.0),1);			
		}					
		return sum;*/
	}
	
	/*The Total Amount is calculated in this Function*/
		public static Double calculateCompound(Double principal,Integer totalNoOfPeriod, Double rate) {
		//error.debugLog('*****principal*****'+principal);
		//error.debugLog('*****totalNoOfPeriod*****'+totalNoOfPeriod);
		//error.debugLog('*****rate*****'+rate);
		//error.debugLog('in pmt function-principal * Math.pow(((100 + rate)/100),totalNoOfPeriod--->'+principal * Math.pow(((100 + rate)/100),totalNoOfPeriod));
		return principal * Math.pow(((100 + rate)/100),totalNoOfPeriod);
		
	}
	
	 /** Eternus Solutions  **/
	/** Author  : Niket  	**/
	/** Issue Id: F0036      	**/
	/** Date    : 08/06/2011 	**/
	/** Purpose : To Calculate the future value of the asset when "To be grown till maturity and continous saving " 
				  is selected on "NewAssetAllocationPage"
	**/
		
	/** Eternus Solutions  **/
	/** Author  : Manasi  	**/
	/** Issue Id: FS0118      	**/
	/** Date    : 22/28/2011	**/
	/** Purpose : Commmented previous logic.Added logic as per the excel provided by Haren
	**/
	public static Double calCompoundForAssetGrowth(Double dbAllocatedAmount,Integer totalNoOfPeriod, Double rate,Decimal dblAnnualDepositContribution, Decimal decGrowthAnuualContri,String description) 
	{
		/*if(description.equals('Fixed Deposit'))
		{
			rate = rate/100;	
		}*/
		Double dbMaturityAmount = dbAllocatedAmount,dbIntermediateCalculation = 0;
		try
		{
			Integer iNoMonths = (totalNoOfPeriod) * 12;  // totalNoOfPeriod is in years so calculate no of months
			double dbAnnualDepositContribution = dblAnnualDepositContribution;
			double dbGrowthAnuualContri = decGrowthAnuualContri;
			double decMonthlyContribution = dbAnnualDepositContribution/12; //dblAnnualDepositContribution is yearly contribution.So calculate monthly amount
			/*Interest Rate : 1. Following are the steps of calculation of Interest rate
							2. Formula for Interest rate is : [(1 + Interest Rate)^(1/12)] - 1
							3. Eg: if Interest rate is 8% then formula will be: here 8% = 0.08 and 1/12 = 0.08333333333
							   	  [(1 + 0.08)^(0.08333333333)] - 1 =  0.00643403 */
			
			Double dbIntermediateRate = (rate/100) + 1;
			Double dbCalculatedRate = (RaiseToPower(dbIntermediateRate ,0.08333333333)) - 1; // 1/12 = 0.08333333333
			if(dbGrowthAnuualContri != null)
				dbGrowthAnuualContri = dbGrowthAnuualContri/100;
			else
				dbGrowthAnuualContri = 0;
			for(Integer iIndex = 1 ; iIndex <= iNoMonths ; iIndex ++)
			{
				dbMaturityAmount = dbMaturityAmount * (1 + dbCalculatedRate) + decMonthlyContribution;
				if(Math.mod(iIndex,12) == 0 )// || iIndex == 36)
				{
					double dbCurrentDepositContribution = 0;
					if(dbAnnualDepositContribution != null && dbGrowthAnuualContri != null)
					{
						dbCurrentDepositContribution = decMonthlyContribution * (dbGrowthAnuualContri + 1) ;
						decMonthlyContribution = dbCurrentDepositContribution;
					}
				}
			}
		}
		catch(Exception ex)
		{
			System.debug('*****ex'+ex);
		}
		return dbMaturityAmount;
		
		//Original Code By Niket
		/*Double TempCalc = 0;
		Integer iNoMonths = (totalNoOfPeriod) * 12;
		double decMonthlyContribution = dblAnnualDepositContribution/12;
		Double dbMaruredRate = (rate+100)/100;
		Double dbCalculatedRate = RaiseToPower(dbMaruredRate,0.08333333333);
		Double intTempAmount; 
		for(Integer iIndex = 1;iIndex <= iNoMonths ;iIndex++)
		{
			if(iIndex == 1)
				TempCalc = (dbAllocatedAmount + 0)*dbCalculatedRate;
			else
			{
				intTempAmount = (TempCalc + decMonthlyContribution) * dbCalculatedRate;
				TempCalc = intTempAmount;
				if(iIndex == iNoMonths)
					TempCalc = TempCalc +	decMonthlyContribution;
				if(Math.mod(iIndex,12) == 0 && decGrowthAnuualContri != null && decGrowthAnuualContri > 0)
				{
					intTempAmount = FinancialUtil.calculateCompound(TempCalc,1,Double.Valueof(decGrowthAnuualContri));
					TempCalc = intTempAmount;
				}
			}
		}
		return TempCalc; */
	}
	/*
		Method Created By : Niket Chandane.
		Method Name       : RaiseToPower(double a, Decimal b)
		Summary			  : In apex it's not possible to get correct value for Math.Pow(1.009,0.083333)
		                   So this function accepts the base and find out the correct raise to double value for the 
		                   base.
	   Return Type 		  : double.
		                    
	*/
	
	public static double RaiseToPower(double a, Decimal b){
        return Math.Exp(b * Math.Log(a));
    }
	
	public static Double calculatePrincipal(Double futureValue,Integer totalNoOfPeriod, Double rate) {
		Double divisor = Math.pow((100+ rate)/100,totalNoOfPeriod);
		return futureValue / divisor;					
	}	 	
	
	public static Double calculateFutureValue(Double principal,Double[] rateList,Integer endIndex){
		Decimal futureValue= principal;
		for(Integer index=0; index < endIndex ; index++){
			if(rateList.Size() > index)
				futureValue =(futureValue * Math.pow(((100 + rateList.get(index))/100),1));
		}
		return futureValue;
	}
	
	public static Double calculateRate(Double futureValue,Double presentValue,Integer years) 
	{
		System.debug('===========Inside the calculateRate ====');
		System.debug('=========== futureValue ===='+futureValue);
		System.debug('=========== presentValue ===='+presentValue);
		System.debug('=========== years ===='+years);
				
		Double calculatedRate = 0;
		if(presentValue != null && presentValue != 0 && years != null && years != 0)
		{
			calculatedRate = ((Math.pow((futureValue/presentValue),1.0d/years) * 100) - 100);
			System.debug('=========== calculatedRate ===='+calculatedRate);
			
		}
		else
			calculatedRate = 0;
		return calculatedRate; 
	}
	
	 //FS0245 , FS0281 
	 //Copied following method from LifeInsurancePlanningPageController to this Class
    public static Double CalculateContinuingIncomeSources(String strSpouceID,Id ParententityId)
    {
    	system.debug('***strSpouceID*****'+strSpouceID);
    	system.debug('***ParententityId*****'+ParententityId);
    	
    	Double dblPresentValue = 0;
    	try
    	{
    	/*
			Method Mpdified By : Dipak Nikam
			Method Name       : CalculateContinuingIncomeSources
			Summary			  : Added in query RecordTypeId=: '01220000000HYzaAAG' i.e. for Business income as well.
		*/
    		
    		
    		 List<Income__c> objIncomeListspouce = [select Income_Amount__c,Frequency__c,Income_Growth_Rate__c,End_Year__c 
    		 										from Income__c 
    		 										where (RecordTypeId=:  IncomeRecTypes__c.getInstance ('Salary Income').RecordTypeId__c //Prajakta//'01220000000HYzeAAG' 
    		 										or RecordTypeId=: IncomeRecTypes__c.getInstance ('Business Income').RecordTypeId__c)
    		 										//or RecordTypeId=: IncomeRecTypes__c.getInstance ('Other Income').RecordTypeId__c)
                									and Entity__c=:strSpouceID];
               
                Double TotalIncomeOfSpouce = 0; //A
                Double SalGrowthRateOfSpouce = 0; //g
                Integer EndYearSpouce = 0 ; //n
                String strEndyear = '0';
                for(Income__c objIncome : objIncomeListspouce)
                {
                	if(objIncome.Frequency__c.equals('Annual'))
                	{
                		TotalIncomeOfSpouce = TotalIncomeOfSpouce + (objIncome.Income_Amount__c);
                	}
                	else if(objIncome.Frequency__c.equals('Quarterly'))
                		TotalIncomeOfSpouce = TotalIncomeOfSpouce + (objIncome.Income_Amount__c * 4);
                	else if(objIncome.Frequency__c.equals('Half-Yearly'))
                		TotalIncomeOfSpouce = TotalIncomeOfSpouce + (objIncome.Income_Amount__c * 2);
                	else if(objIncome.Frequency__c.equals('Monthly'))
                		TotalIncomeOfSpouce = TotalIncomeOfSpouce + (objIncome.Income_Amount__c * 12);
                	else if(objIncome.Frequency__c.equals('Quarterly, Monthly'))
                		TotalIncomeOfSpouce = TotalIncomeOfSpouce + (objIncome.Income_Amount__c * 12);
                	SalGrowthRateOfSpouce = objIncome.Income_Growth_Rate__c/100;
                
                	if(objIncome.End_Year__c != null)
                	{
                		strEndyear = objIncome.End_Year__c;
                	}
                }
                EndYearSpouce = Integer.valueOf(strEndyear);
                Integer iRetirementYear = 0;
                if(EndYearSpouce - Date.today().year() > 0) /*Praj*/
                 iRetirementYear = EndYearSpouce - Date.today().year(); //n
                //error.debugLog('***EndYearSpouce*****'+EndYearSpouce);
                //error.debugLog('***iRetirementYear*****'+iRetirementYear);
                //error.debugLog('***TotalIncomeOfSpouce*****'+TotalIncomeOfSpouce);
                DatabaseSOQL objSOQL = new DatabaseSOQL();
                Entity_Global_Assumption__c objGlobalAssumption = objSOQL.getEntityGlobalAssumption(ParententityId);
                Double dblRateOnInvestment = 9;
                if(objGlobalAssumption.Expected_Return_on_Investment__c != null)
                	dblRateOnInvestment = objGlobalAssumption.Expected_Return_on_Investment__c/100;//i
                
                if(dblRateOnInvestment == SalGrowthRateOfSpouce)
                {
                	dblPresentValue = (TotalIncomeOfSpouce * EndYearSpouce)/(1 + dblRateOnInvestment);
                	//error.debugLog('**if *TotalIncomeOfSpouce*****'+TotalIncomeOfSpouce);
                	//error.debugLog('**if *dblRateOnInvestment*****'+dblRateOnInvestment);
                }
                else
                {
                	//Previous Formula
                	//dblPresentValue = (TotalIncomeOfSpouce/dblRateOnInvestment-SalGrowthRateOfSpouce)*(1-((1+SalGrowthRateOfSpouce)/(1+dblRateOnInvestment))*iRetirementYear);
                	Double dblBase = (1+SalGrowthRateOfSpouce)/(1+dblRateOnInvestment);
                	Double dblPower = iRetirementYear;
                	dblPresentValue = (TotalIncomeOfSpouce/(dblRateOnInvestment-SalGrowthRateOfSpouce))*(1-(Math.Exp(dblPower * Math.Log(dblBase))));
                	  //error.debugLog('*else**SalGrowthRateOfSpouce*****'+SalGrowthRateOfSpouce);
                	  //error.debugLog('**else *dblRateOnInvestment*****'+dblRateOnInvestment);
                //error.debugLog('***dblBase*****'+dblBase);
                }
                //bean.income.presentValue = dblPresentValue;
                //error.debugLog('***dblPresentValue*****'+dblPresentValue);
    	}
    	catch(system.exception e){
             System.debug('=====CalculateContinuingIncomeSources##======'+e.getMessage());
        }
        return dblPresentValue;
    }
     @isTest
    static void testFinancial()
    {
    	list<Double> ratelist = new Double[]{10,20};
    	FinancialUtil objFinancialUtil=new FinancialUtil();
    	FinancialUtil.calCompoundForAssetGrowth(100,2, 200,2000, 200,'aaa');
	    FinancialUtil.calculateCompound(200, 3, 100);
	    FinancialUtil.calculateCompoundMonthly(100, 100, 2, 100);
	    FinancialUtil.calculateRate(100, 100, 2);
	    FinancialUtil.RaiseToPower(100, 100);
		FinancialUtil.calculatePrincipal(100, 2, 10);
  		FinancialUtil.CalculateContinuingIncomeSources ('001W0000005xb5F','001W0000005xb4U');
  		FinancialUtil.calculateFutureValue(10,ratelist,1);
  		//inancialUtil.
    }
}