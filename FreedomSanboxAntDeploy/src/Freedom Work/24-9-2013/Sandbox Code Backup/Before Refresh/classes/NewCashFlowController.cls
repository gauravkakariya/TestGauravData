/*
	
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
    2.0			Manasi			   03/06/2011	Added apex warning, if birthdate is null in setAction() and projection() function.
    2.0			Manasi			   4/8/2011 	Chnage in class NewCashFlowController:
    											1. Added new Property :
				  								IsSurplusNegative Boolean value will be true when Total expenseValue is greater than Total incomeValue
				  								2. IsSurplusNegative Boolean :assign false as default value in constructor 
				  								3. IsSurplusNegative Boolean value will be true when expenseValue is greater than incomeValue  
									 
*/
public class NewCashFlowController 
{
	//FS0309
	public Remarks__c objRemark {get;set;}
	public String strRemark {get;set;}
    public NewCashFlowService service;
    public String entityId {get;set;}
    //Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
	
    /** Eternus Solutions       **/
	/** Author  : Manasi		**/
	/** Issue Id: FS0090      	**/
	/** Date    : 4/8/2011	 	**/
	/** Purpose : Added new Property :
    IsSurplusNegative Boolean value will be true when Total expenseValue is greater than Total incomeValue **/
	/****************************************************/  
    public Boolean IsSurplusNegative {get;set;}
    public NewCashFlowBean cashFlowBean { get;set;}   
    private String chartData;
    public String getChartData(){ return chartData;}   
    private String chartPath ;
    private  double incrementFactor;
    public Static String eId {get;set;}
    public Boolean includeProjection {get;set;}
    
    //00001592
    public Boolean blnIsMonthlySurplusNegative {get; set;}
    
    public NewCashFlowController()
    {
    	//Code Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   		isDisplaySaveButton = true;
   		displayPageBlock = true;
    	includeProjection = false;
    	/** Eternus Solutions       **/
		/** Author  : Manasi		**/
		/** Issue Id: FS0090      	**/
		/** Date    : 4/8/2011	 	**/
		/** Purpose : IsSurplusNegative Boolean :assign false as default value in constructor **/
		/****************************************************/  
    	IsSurplusNegative = false;
        service = new NewCashFlowService();
        entityId = eId == null ? System.currentPageReference().getParameters().get('entityId'):eId;          
                     
        cashFlowBean = service.getCashFlowSnapshot(entityId);
        //cashFlowBean = service.getCashFlowProjection(entityId);        
        
        chartPath = 'http://chart.apis.google.com/chart?cht=bvs&chs=400x200&chco=458B00|6495ED|CD9B1D'; 
        List<ChartDataItem> items = new List<ChartDataItem>();
        incrementFactor=getIncrementFactor();//checkValue();
        //items.add(new ChartDataItem('TotalIncomes' , cashFlowBean.summaryList.get(0).totalValueList.get(0)));
        //items.add(new ChartDataItem('TotalExpenses' , cashFlowBean.summaryList.get(1).totalValueList.get(0)));
        items.add(new ChartDataItem('TotalIncomes',math.roundToLong(incomeValue)));
        items.add(new ChartDataItem('TotalExpenses',math.roundToLong(expenseValue)));
        items.add(new ChartDataItem('NetCashSurplus' ,math.roundToLong(netCash)));
        
  		/** Eternus Solutions       **/
		/** Author  : Manasi		**/
		/** Issue Id: FS0090      	**/
		/** Date    : 4/8/2011	 	**/
		/** Purpose : IsSurplusNegative Boolean value will be true when expenseValue is greater than incomeValue **/
		/****************************************************/  
       	if(math.roundToLong(expenseValue) > math.roundToLong(incomeValue))
    		IsSurplusNegative = true;
		else
			IsSurplusNegative = false;       	
        if(minValue != 0)
        {
            chartPath = chartPath + '&chxt=x,y&chf=bg,s,F0F0F0&chm=N,000000,0,,12,&chxr=1,'+(MinValue-incrementFactor)+','+maxValue+','+incrementFactor+'&chds='+(MinValue-incrementFactor)+','+maxValue;  
        }else{
            chartPath = chartPath + '&chxt=x,y&chf=bg,s,F0F0F0&chm=N,000000,0,,12,&chxr=1,'+MinValue+','+maxValue+','+incrementFactor+'&chds='+MinValue+','+maxValue;  
        }
        chartData = chartPath +  getChartInfo(items);
        //FS0309
        if(entityId != null)
	    {
	    	/* Map<String,Remarks__c > mapofRemarks = TestRemark.getRemark(entityId);
	    	if(!mapofRemarks.isEmpty() && mapofRemarks.containsKey('CashFlow'))
	    	{
	    	 	objRemark = mapofRemarks.get('CashFlow');
	    		strRemark = objRemark.Remark__c;
	    	}	*/
	    	for(Remarks__c obj:[select Remark__c from Remarks__c where entity__c =:entityId and recordtype.Name=:'CashFlow' limit 1])
	    	{
	    		objRemark = obj;
	    		strRemark = objRemark.Remark__c; 
	    	}
	    	//Added Code on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
		    User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
		    if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
		    {
		    	isDisplaySaveButton = false;
		    }	
	    }
	    //00001592
	    blnIsMonthlySurplusNegative = false;
	    
    }
    
    public List<String> getYearList{
        get{
            return service.getYearList();
        }
    }

    public PageReference setAction() 
    {
    	/** Eternus Solutions      **/
		/** Author  : Manasi Ranade*/
		/** Issue Id: F0029      **/
		/** Date    : 03/06/2011 **/
		/** Purpose : Added warning to the page, if Age is null**/ 
    	try
    	{
	        String operation = System.currentPageReference().getParameters().get('operation');
	        if('Snapshot'.equals(operation)) 
	        {
	            cashFlowBean = service.getCashFlowSnapshot(entityId);
	        }
	        else 
	        {
	            cashFlowBean = service.getCashFlowProjection(entityId);
	        }
    	}
        catch(system.exception e)
 	    {
 	    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
 	    } 
        return null;
    } 
    
    public Double netCash 
    {
        get 
        {
           Double totalIncome = 0, totalExpense = 0;
                
           if(!cashFlowBean.summaryList.isEmpty()) 
           {
               if(!cashFlowBean.summaryList.get(0).totalValueList.isEmpty())
                   totalIncome  = cashFlowBean.summaryList.get(0).totalValueList.get(0);
                   if(!cashFlowBean.summaryList.get(1).totalValueList.isEmpty())
                       totalExpense = cashFlowBean.summaryList.get(1).totalValueList.get(0);
                       system.debug('------cashFlowBean.summaryList.get(1)--------'+cashFlowBean.summaryList.get(1));
           }
                                
           if(totalIncome > totalExpense ) 
           {
                return totalIncome - totalExpense;
           }
           else 
           {
                return  (totalExpense - totalIncome) * (-1);
           }                                   
        }
    }
    public String getCashFlowChart 
    {
        get 
        {
            Double totalIncomes =  0,totalExpenses = 0,yAxisMaxValue = 0;
            List<String> xAxisDataList =  new String[] {'Total Incomes','Total Expenses', 'Net cash - Surplus/(Shortage)'};
            List<String> yAxisDataList = new String[]{};
            
            if(!cashFlowBean.summaryList.isEmpty()) 
            {
                if(!cashFlowBean.summaryList.get(0).totalValueList.isEmpty())
                    totalIncomes  = cashFlowBean.summaryList.get(0).totalValueList.get(0);
                if(!cashFlowBean.summaryList.get(1).totalValueList.isEmpty())   
                    totalExpenses = cashFlowBean.summaryList.get(1).totalValueList.get(0);
            }                                                
            yAxisDataList.add('' + totalIncomes);
            yAxisDataList.add('' + totalExpenses);                                
            yAxisDataList.add('' +  netCash);
            
            yAxisMaxValue = totalIncomes ;  
            if( totalExpenses > totalIncomes )
                 yAxisMaxValue = totalExpenses;
                  
            return GraphMarkUpGenerator.get2DGraph('', '', ''+yAxisMaxValue, xAxisDataList,
                                                                             yAxisDataList, 'Cash Flow');                    
        }       
        set;
    }
  	public Boolean displayPageBlock {get;set;}
  	
    public pageReference projection() 
    {
    	/** Eternus Solutions      **/
		/** Author  : Manasi Ranade*/
		/** Issue Id: F0029      **/ 
		/** Date    : 03/06/2011 **/
		/** Purpose : Added warning to the page, if Age is null**/ 
 	    // try
 	    // {
 	    cashFlowBean = service.getCashFlowProjection(entityId);
	    cashFlowBean.isMonthlySurplusNegative = true;
       
	    //00001592
        Double dblTotalIncomes = 0, dblTotalExpenses = 0;
        if(cashFlowBean.summaryList != null)
        {
        	system.debug('**cashFlowBean.summaryList[0].monthlySummary*******'+cashFlowBean.summaryList[0].monthlySummary);
        	
        	if(cashFlowBean.summaryList[0].monthlySummary == 0 && cashFlowBean.summaryList[1].monthlySummary == 0)
        	{
        		displayPageBlock = false;
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please Enter Incomes & Expenses for this Entity'));
        		return null;
        	}
        	if(cashFlowBean.summaryList[0].monthlySummary == 0)
        	{
        		displayPageBlock = false;
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please Enter Incomes'));
        		return null;
        	}
        	if(cashFlowBean.summaryList[1].monthlySummary == 0)
        	{
        		displayPageBlock = false;
        		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please Enter Expenses'));
        		return null;
        	}
        	
        	if(cashFlowBean.summaryList != null &&  cashFlowBean.summaryList[0] != null && cashFlowBean.summaryList.size() >= 1 && cashFlowBean.summaryList[0].monthlySummary != null)
	        {
	        	dblTotalIncomes = cashFlowBean.summaryList[0].monthlySummary;
	        }
	        
	        if(cashFlowBean.summaryList.size() >= 2 && cashFlowBean.summaryList[1].monthlySummary != null)
	        {
	        	dblTotalExpenses = cashFlowBean.summaryList[1].monthlySummary;
	        }
	        if(dblTotalIncomes < dblTotalExpenses)
	        	blnIsMonthlySurplusNegative = true;
	        else
	        	blnIsMonthlySurplusNegative = false;
        }
    	
       /*
       		Added by : Aditi Satpute
       		Date: 20/6/13 :  FP changes part-2 : issue-23
       		Purpose: Store All projection details in CashFlow Projection object 
       */ 
   	   List<Integer> yearList = new List<Integer>();
       List<CashFlow_Projection__c> lstCF = new List<CashFlow_Projection__c>();
       Map<Integer,List<String>> mapYearTodetails = new  Map<Integer,List<String>>();
       for(Integer i=0 ; i <= service.intPendingLifeExpectancyYears ; i++) {
            yearList.add(service.todayDate.addYears(i).year());  
       }     
       Map<Decimal,CashFlow_Projection__c>  mapYearToCFdetails = new  Map<Decimal,CashFlow_Projection__c>();
       List<CashFlow_Projection__c> lstCashFlowUpsert = [Select Year__c,  Saving__c, Salary_Income__c, Recreation_Entertainment__c
       													, Loan_Repayments_EMI__c, Insurance__c, Entity__c,Business_Income__c,isProjectionDisplayed__c  
       													From CashFlow_Projection__c
       													where Entity__c =: entityId];
       if(!lstCashFlowUpsert.isEmpty())		
       {
       		for(CashFlow_Projection__c objCashFlow : lstCashFlowUpsert)
       		{
       			if(!mapYearToCFdetails.containsKey(objCashFlow.Year__c))
       			{
       				mapYearToCFdetails.put(objCashFlow.Year__c,objCashFlow);
       			}
       			/*
			       		Added by : Aditi Satpute
			       		Date: 2/8/13 :  FP changes part-2 : issue-23
			       		Purpose: on tick of checkbox CashFlow Projection should be includedd in FP
			    */ 
       			includeProjection = objCashFlow.isProjectionDisplayed__c;
       		}
       }											
       													
       
       for(NewSummaryBean obj : cashFlowBean.summaryList)
	   {
       		for(NewSummaryBean.SummaryRecordTypeBean objSummary : obj.summaryRecordTypeBeanMap.values())
	    	{
	    		Integer counter = 0;
	    		//error.DebugLog('*******objSummary.monthlySummary**'+objSummary.monthlySummary);
	    		for(Double amount : objSummary.totalValueList)
	    		{
	    			if(counter <= service.intPendingLifeExpectancyYears)
	    			{
	    				Integer year = service.todayDate.addYears(counter).year();
	    				counter++; 
	    				List<String> lstCashFlowDetails = new List<String>(); 
				        if(mapYearTodetails.containsKey(year))
				        {
				        	lstCashFlowDetails = mapYearTodetails.get(year);
				            //lstCashFlowDetails.add(obj.header+':'+objSummary.name+':'+ amount);//+':'+startYear+':'+endYear);
				            lstCashFlowDetails.add(objSummary.name+':'+ amount);
				        }
				        else
				            lstCashFlowDetails.add(objSummary.name+':'+ amount);
	    				
	    				mapYearTodetails.put(year,lstCashFlowDetails);
	    			}
	    		}
	    	}
	    }
	    
	    for(Integer year : yearList)
	    {
	    	if(mapYearTodetails.containsKey(year))
	    	{
	    		List<String> lstDetails = mapYearTodetails.get(year);
	    		if(lstDetails.isEmpty() || lstDetails == null)
        			continue;
    			CashFlow_Projection__c objCashFlow = new CashFlow_Projection__c();
        		if(mapYearToCFdetails.containsKey(year))
        		{
        			objCashFlow = mapYearToCFdetails.get(year);
        		}
        		else
        		{
	    			objCashFlow.Year__c = year;
	    			objCashFlow.Entity__c = entityId;
        		}
	    		for(String strDetails : lstDetails)
	    		{
	    			if(strDetails != null)
	            	{
	            		List<String> lst = strDetails.split(':');
	            		if(lst.isEmpty() || lst == null)
	            			continue;
	            		String name = lst[0];
	            		Decimal amount = Decimal.ValueOf(lst[1]);
	            		if(name.equalsIgnoreCase(Label.Business_Income) && name != null)
	            		{
	            			objCashFlow.Business_Income__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.Salary_Income) && name != null)
	            		{
	            			objCashFlow.Salary_Income__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.Saving) && name != null)
	            		{
	            			objCashFlow.Saving__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.CashFlowInsurance) && name != null)
	            		{
	            			objCashFlow.Insurance__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.LoanRepayments) && name != null)
	            		{
	            			objCashFlow.Loan_Repayments_EMI__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.RecreationEntertainment) && name != null)
	            		{
	            			objCashFlow.Recreation_Entertainment__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.Rental_Income) && name != null)
	            		{
	            			objCashFlow.Rental_Income__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.Pension_Income) && name != null)
	            		{
	            			objCashFlow.Pension_Income__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.Other_Income) && name != null)
	            		{
	            			objCashFlow.Other_Income__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.Family_care) && name != null)
	            		{
	            			objCashFlow.Family_care__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.Food) && name != null)
	            		{
	            			objCashFlow.Food__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.Healthcare) && name != null)
	            		{
	            			objCashFlow.Healthcare__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.Housing) && name != null)
	            		{
	            			objCashFlow.Housing__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.Transportation) && name != null)
	            		{
	            			objCashFlow.Transportation__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.CashFlowOther) && name != null)
	            		{
	            			objCashFlow.Other__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.Utilities) && name != null)
	            		{
	            			objCashFlow.Utilities__c = amount;
	            		}
	            		else if(name.equalsIgnoreCase(Label.Personal) && name != null)
	            		{
	            			objCashFlow.Personal__c = amount;
	            		}
	            	}
	    		}
	    		lstCF.add(objCashFlow);
	    	}
	    }
	    
	    upsert lstCF;
	    //error.debugLog('****lstCF.size()****'+lstCF.size());
        pageReference pageRef = new pageReference('/apex/NewCashFlowProjection?entityId=' +entityId + '&tabname=Financial Planning');   
        pageRef.setRedirect(false);     
        return pageRef; 
		//} 	 
 	    return null;
    }
    public pageReference newCashFlow() 
    {
        //cashFlowBean = service.getCashFlowPage(entityId);
        //entityId = System.currentPageReference().getParameters().get('entityId');
        pageReference pageRef = new pageReference('/apex/NewCashFlowPage?entityId=' +entityId + '&tabname=Financial Planning');   
        pageRef.setRedirect(true);     
        return pageRef;     
    }
    
    
     public Double incomeValue
     {
         get 
         {
             if(!cashFlowBean.summaryList.isEmpty()) 
             {
                 if(!cashFlowBean.summaryList.get(0).totalValueList.isEmpty())
                     return cashFlowBean.summaryList.get(0).totalValueList.get(0); 
             }
             return 0;
         }
     }
     public Double expenseValue 
     {
         get 
         {
              if(!cashFlowBean.summaryList.isEmpty()) 
              {
                  if(!cashFlowBean.summaryList.get(1).totalValueList.isEmpty())
                      return cashFlowBean.summaryList.get(1).totalValueList.get(0);    
              }
              return 0;       
         }
    }
     /**
    For generation google chart
    */
    
    public double MinValue
    {
       set;
       get
       {
           MinValue=0;
           /* Double totalIncome, totalExpense;
           try{
               if(!cashFlowBean.summaryList.isEmpty()){
                   if(!cashFlowBean.summaryList.get(0).totalValueList.isEmpty())
                       totalIncome  = cashFlowBean.summaryList.get(0).totalValueList.get(0);
                   if(!cashFlowBean.summaryList.get(1).totalValueList.isEmpty())  
                       totalExpense = cashFlowBean.summaryList.get(1).totalValueList.get(0);
                    system.debug('====================='+totalIncome  + totalExpense );    
               }
                system.debug('===========min=========='+cashFlowBean.summaryList);
           }catch(Exception e)
           {
               system.debug(e.getMessage());
           }*/
           if(incomeValue<expenseValue && incomeValue<netCash)
               MinValue=incomeValue;
           else if(expenseValue<incomeValue&& expenseValue<netCash)
               MinValue=expenseValue ;
           else
               MinValue=netCash;
           return math.roundToLong(minValue);
       }
   }
  public double getIncrementFactor()
  {
       double prevValue;
       if(MinValue<0)
       {
           MinValue=MinValue*(-1);
       }
       double value=0;
       //if(MinValue!=0)
       value=(maxValue-MinValue)/10;
       //if(value<=MinValue)    
       //return MinValue;
       //else
       return math.roundToLong(value);
   }
    public double maxValue
    {
       set;
       get
       {
           maxValue=0;
           /*  Double totalIncome, totalExpense;
           try{
               if(!cashFlowBean.summaryList.isEmpty()){
                    if(!cashFlowBean.summaryList.get(0).totalValueList.isEmpty())
                       totalIncome  = cashFlowBean.summaryList.get(0).totalValueList.get(0);
                    if(!cashFlowBean.summaryList.get(1).totalValueList.isEmpty())  
                       totalExpense = cashFlowBean.summaryList.get(1).totalValueList.get(0);
                   system.debug('====================='+totalIncome  + totalExpense ); 
               }
                system.debug('========max============='+cashFlowBean.summaryList);
           }catch(Exception e)
           {
               system.debug(e.getMessage());
           }*/
           if(incomeValue<expenseValue)
               maxValue=expenseValue;
           else 
               maxValue=incomeValue;
           return math.roundToLong(maxValue);
       }
    }    
    private String getChartInfo(List<ChartDataItem> items)
    {
         String chd = ''; 
         String chl = ''; 
         for(ChartDataItem citem : items) {
             chd += citem.Value + ',';
             chl += citem.Name+ '|'; 
         } 
         chd = chd.substring(0, chd.length() -1); 
         chl = chl.substring(0, chl.length() -1); 
         String result = '&chbh=a,50,20&chd=t:' + chd + '&chl=' + chl+'&chtt='+'Cash Flow'; 
         return result;
    }
    
    public class ChartDataItem
    { 
        public String Name{get;set;} 
        public Double Value {get;set;} 
        public ChartDataItem(String Name, Double Value) 
        {
            this.Name = Name;    
            this.Value = Value; 
        }
    }
    
    //FS0309
    public void save()
	{
		if(objRemark == null)
    	{
    		objRemark =new Remarks__c();
    		//ID RecTypeId = [select id from RecordType where Name= 'CashFlow'][0].id;
    		//objRemark.RecordTypeId = RecTypeId;
    		
    		Map<String, Schema.RecordTypeInfo> remarksRecordTypeInfo = Schema.SObjectType.Remarks__c.getRecordTypeInfosByName();
        	String remarksCashFlowRecordTypeId = remarksRecordTypeInfo.get('CashFlow').getRecordTypeId();
        	
    		objRemark.RecordTypeId = remarksCashFlowRecordTypeId;
    		objRemark.Entity__c = entityId;
    		objRemark.Remark__c = strRemark;
    		insert objRemark;
    	}
    	else
    	{
    		objRemark.Remark__c = strRemark;
    		update objRemark;
    	}
		//objRemark.Entity__c = entityId;
		//objRemark.recordtype.Name = 'Networth';
		//upsert objRemark;
	}
	
	/*
       		Added by : Aditi Satpute
       		Date: 2/8/13 :  FP changes part-2 : issue-23
       		Purpose: on Click of Save button checks the checkbox value and decides whether CashFlow Projection should be includedd in FP
    */ 
	public void saveDisplayProjection()
	{
		//error.debugLog('**includeProjection*'+includeProjection);
		List<CashFlow_Projection__c> lstCashFlow = [Select Year__c,  Saving__c, Salary_Income__c, Recreation_Entertainment__c,Other_Income__c,
       													Loan_Repayments_EMI__c, Insurance__c, Entity__c,Business_Income__c,Rental_Income__c,
       													Pension_Income__c,Family_care__c,Food__c,Healthcare__c,Housing__c,Transportation__c,
       													Other__c,Utilities__c,Personal__c,isProjectionDisplayed__c  
       													From CashFlow_Projection__c
       													where Entity__c =: entityId];
       	List<CashFlow_Projection__c> lstUpdateCF = new List<CashFlow_Projection__c>();
       	if(!lstCashFlow.isEmpty())
       	{
	       	for(CashFlow_Projection__c objCashFlowProjection : lstCashFlow)
	       	{
	       		objCashFlowProjection.isProjectionDisplayed__c = includeProjection;
	       		lstUpdateCF.add(objCashFlowProjection);
	       	}
       	}
       	if(!lstUpdateCF.isEmpty())
			update lstUpdateCF;
	}
	
	public List<ProjectionDetail> lstProjectionDetail {get;set;}
	public class ProjectionDetail
	{
		public List<Integer> lstYear {get;set;}
		public List<NewSummaryBean> lstNewSummaryBean { get;set;}
		public List<Double> lstIncomeSurplus {get;set;}
		
		public ProjectionDetail(list<Integer> plstYear, List<NewSummaryBean> plstNewSummaryBean, List<Double> plstIncomeSurplus)
		{	
			lstYear = new list<Integer>();
			lstNewSummaryBean = new List<NewSummaryBean>();
			lstIncomeSurplus = new List<Double>();
			lstYear.addAll(plstYear);
			lstNewSummaryBean.addAll(plstNewSummaryBean);
			lstIncomeSurplus.addAll(plstIncomeSurplus);
		}
	}
}