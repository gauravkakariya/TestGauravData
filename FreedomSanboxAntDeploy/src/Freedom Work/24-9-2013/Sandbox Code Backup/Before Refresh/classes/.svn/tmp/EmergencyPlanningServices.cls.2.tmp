/**
*
* Author:  Manasi Ranade 
*
* Revision History:
*   Version     Version Author     Date       		Comments
*   1.0        	Samruddhi P  	   17/2/2011		EmergencyPlanningServices is service class for EmergencyPlanningPage in Analysis Section
	2.0			Manasi			   31/1/2012	    Issue ID : 00001486 : Added code to avoid duplication in the list while upserting it to the database
* 				Prajakta		   21-05-2013  		FP changes II - Changed query in DatabaseSOQL as expense total is needed without vacation expense
*/
public class EmergencyPlanningServices {
    DatabaseSOQL dbSOQL {get; set;}
    DatabaseDML dbDML {get; set;}
	private Entity_Global_Assumption__c globalAssumptions;
	public Integer currentYearnew{get;set;}	/* Prajakta - FP changes - 30-04-2013 */
	public Account objAccount{get;set;}		/* Prajakta - FP changes - 12-04-2013 */
    public String entityId {get;set;}		/* Prajakta - FP changes - 12-04-2013 */
	
    public EmergencyPlanningServices()
    {
        dbSOQL = new DatabaseSOQL();
        dbDML = new DatabaseDML();
        
         /* Prajakta - FP changes - 12-04-2013 */
        //Integer currentYearnew;
        entityId = System.currentPageReference().getParameters().get('entityId');
        objAccount = dbSOQL.getEntity(entityId);
        if(objAccount.Plan_Generation_Date__c != null) 
        	currentYearnew = objAccount.Plan_Generation_Date__c.year();
        else
        	currentYearnew = System.today().year();
        //error.DebugLog('----currentYearnew-----'+currentYearnew);
    }
    
    /**
    * getTotalExpenses() function returns the total family expenses for a particular entity
    * param:id of particular Account (Entity)
    * returns:Double
    */
    public Double getTotalExpenses(String entityId)
    {
        Double expenseValue = 0;
        try{
        	
	        
	        /*AggregateResult aggResult = dbSOQL.getTotalExpenses(entityId);    
            if(aggResult.get('expenses') != null)
                expenseValue = (Double)aggResult.get('expenses');
                Error.DebugLog('expenseValue====>>>>'+expenseValue);
            aggResult=dbSOQL.getTotalFamilyLiabilities(entityId);
            Error.DebugLog('(Emi====>>>>'+(Double)aggResult.get('emi'));    
            if(aggResult.get('emi')!=null)
            {
            	expenseValue = expenseValue + (Double)aggResult.get('emi');
            }
            //FS0244
            List<Insurance__c> objInsuranceList = dbSOQL.getInsurances(entityId,'Data Entry');
            //////////
            Date tempDate;
            Integer startYear,endYear;
            double dblAnnualTotalInsurance = 0;
            for(Insurance__c result : objInsuranceList) 
            {
                  tempDate  = (result.Commencement_Date__c);
            
	            if(result.Commencement_Date__c != null) {
	                startYear = tempDate.year(); 
	            } else {
	                startYear = Date.today().year();
	            }
				if(result.Tenure_of_Insurance__c != null) {				
					endYear = startYear + Integer.valueof(String.valueOf(result.Tenure_of_Insurance__c).trim());
					endYear = endYear - 1;
	            } else {
	                endYear = Date.today().year(); 
	            }
	            if(endYear>=Date.today().year()){
	            	//summaryRecordTypeBean  = summaryBean.getSummaryRecordTypeBean('Insurance');
	            	dblAnnualTotalInsurance = dblAnnualTotalInsurance + result.Annual_Premium_amount__c;
	            	//summaryRecordTypeBean.populateSummaryDetailList(startYear,endYear,result.Annual_Premium_amount__c,0); 
	            }
	        }
	         Error.DebugLog('(Insurance====>>>>'+dblAnnualTotalInsurance); 
	         expenseValue = expenseValue + (dblAnnualTotalInsurance/12);*/
	         
		    /*
	    	Modified By : Dipak Nikam.
	    	Modified At : 29 Feb 2012
	    	Case Number : 00001522
	    	Summary 	: Commented the above  code and also added code below code,Expense value should be Total Expense page less savings.  
	    	*/	
		    List<Expense__c> expenseList; 
	        List<Loan__c> loanList;
	        List<Insurance__c> insuranceList;     
    		NewCashFlowService objNewCashFlowService = new NewCashFlowService();
   			List<NewSummaryBean> summaryList = new List<NewSummaryBean>();                                                  
    		NewSummaryBean summaryBean;                
    		Integer currentYear = currentYearnew; //Date.today().year()/*Praj*/
    		Integer defaultStartYear = currentYear,defaultEndYear = defaultStartYear;
    
	        globalAssumptions = dbSOQL.getEntityGlobalAssumption(entityId);
	        summaryBean = new NewSummaryBean('Expenses',currentYear,currentYear);
	        summaryList.add(summaryBean);
	        //expenseList = dbSOQL.getMonthlyExpenseForCashFlow(entityId);
	        /* Prajakta - FP changes II - 21-05-2013 - Changed query in DatabaseSOQL as expense total is needed without vacation expense*/
	        expenseList = dbSOQL.getMonthlyExpenseForCashFlowWithoutVacation(entityId);
	        objNewCashFlowService.setExpensesSummaryDetails(expenseList,defaultStartYear,defaultEndYear,summaryBean);
	       
	        loanList = dbSOQL.getLoanList(entityId);
	        objNewCashFlowService.setLoanSummaryDetails(loanList,defaultStartYear,defaultEndYear,summaryBean);
	      	
	      	insuranceList = dbSOQL.getInsurances(entityId,'Data Entry');
	        objNewCashFlowService.setInsuranceSummaryDetails(insuranceList,defaultStartYear,defaultEndYear,summaryBean);
		    objNewCashFlowService.setYearList(1);
		    
		   	NewCashFlowBean objCashFlowBean = new NewCashFlowBean(summaryList,1);
		   	if(objCashFlowBean.summaryList != null && objCashFlowBean.summaryList.size() > 0)
		   	{
			   	for(NewSummaryBean objNewSummaryBean :objCashFlowBean.summaryList)
			   	{
			   		List<Double>lstDouble = objNewSummaryBean.totalValueByYear;
			   		if(lstDouble != null && lstDouble.size() > 0)
			   		{
			   			for(Double dbleValue :lstDouble )
			   			{
			   				expenseValue = expenseValue + dbleValue;
			   			}
			   		} 
			   	}
			}
			if(expenseValue != 0)
				expenseValue =expenseValue/12;
	   }
        catch(System.Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage())); 
        }
        return expenseValue;
     } 
     
   
       
    
    /**
    * getNoOfMonths() function returns the no fo emeregncy fund months for a particular entity
    * param:id of particular Account (Entity)
    * returns:Double 
    */ 
    public Double getNoOfMonths(String entityId){
        Double months;
        try{
            Entity_Global_Assumption__c assumption=dbSOQL.getGlobalAssumptions(entityId);
            if(assumption!=null && assumption.Number_Of_Months__c!=null)
                months=(Double)assumption.Number_Of_Months__c;
            else   
                months=0;
        }
        catch(System.Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage())); 
        }
        return months;
    }
    
    /**
    * getAssetAllocation() function returns the assets allocated to emergency fund for a particular entity
    * param:id of particular Account (Entity),List<EmergencyActionPlanBean>
    * returns:void
    */
    public void getAssetAllocation(String entityId,List<EmergencyActionPlanBean> beanList){
        try{
            List<AggregateResult> goalAsset=dbSOQL.getTotalAssetsForEmergencyFund(entityId);
            system.debug('==goalAsset=='+goalAsset);
            if(goalAsset !=null){
                for(AggregateResult ar: goalAsset ){
                    EmergencyActionPlanBean apbean= new EmergencyActionPlanBean();
                    if(ar.get('amount')!=null && ar.get('amount')!=0){
                        if(ar.get('accounttype')!=null)
                            apbean.Name=(String)ar.get('accounttype');
                        if(ar.get('assettype')!=null)
                            apbean.Name=(String)ar.get('assettype');
                        apbean.Owner=(String)ar.get('entity');
                        apbean.Amount=(Double)ar.get('amount');
                        apbean.Action=(String)ar.get('action');
                        apbean.ObjectName=Label.Asset;
                        beanList.add(apbean);
                    }
                }
            }
        }
        catch(System.Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage())); 
        }
    }  
   
    /**
    * getInsuranceAllocation() function returns the insurance allocated to emergency fund for a particular entity
    * param:id of particular Account (Entity),List<EmergencyActionPlanBean>
    * returns:void
    */
    public void getInsuranceAllocation(String entityId,List<EmergencyActionPlanBean> beanList){
        try{
            List<AggregateResult> goalInsurance=dbSOQL.getTotalInsuranceForEmergencyFund(entityId);
            system.debug('==goalInsurance=='+goalInsurance);
            if(goalInsurance!=null){
                for(AggregateResult ar: goalInsurance){
                    EmergencyActionPlanBean apbean= new EmergencyActionPlanBean();
                    if(ar.get('amount')!=null && ar.get('amount')!=0){
                        apbean.Name=(String)ar.get('recordtype');
                        apbean.Owner=(String)ar.get('entity');
                        apbean.Amount=(Double)ar.get('amount');
                        apbean.Action=(String)ar.get('action');
                        apbean.ObjectName=Label.Insurance;
                        beanList.add(apbean);
                    }    
                }
            }
        }
        catch(System.Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage())); 
        }
    }
    
    /**
    * getInvestmentAssetAllocation() function returns the investment assets allocated to emergency fund for a particular entity
    * param:id of particular Account (Entity),List<EmergencyActionPlanBean>
    * returns:void
    */
    public void getInvestmentAssetAllocation(String entityId,List<EmergencyActionPlanBean> beanList){
        try{
            List<AggregateResult> goalInvAsset=dbSOQL.getTotalInvestmentAssetsForEmergencyFund(entityId);
            system.debug('=========goalInvAsset =='+goalInvAsset );
            if(goalInvAsset!=null){
                for(AggregateResult ar:goalInvAsset){
                    EmergencyActionPlanBean apbean= new EmergencyActionPlanBean();
                    if(ar.get('amount')!=null && ar.get('amount')!=0){
                        apbean.Name=(String)ar.get('recordtype');
                        apbean.Owner=(String)ar.get('entity');
                        apbean.Amount=(Double)ar.get('amount');
                        apbean.Action=(String)ar.get('action');
                        apbean.ObjectName=Label.Investment_Asset;
                        beanList.add(apbean);
                    }
                }
            }
        }
        catch(System.Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage())); 
        }
    }
    
    /**
    * save() function saves the action to be taken
    * param:id of particular Account (Entity),List<EmergencyActionPlanBean>
    * returns:void
    */
    public void save(String entityId,List<EmergencyActionPlanBean> beanList){
        try{
            List<Insurance__c> insuranceList=new List<Insurance__c>();
            List<Asset__c> assetList=new List<Asset__c>();
            List<Investment_Asset__c> invassetList=new List<Investment_Asset__c>();
    
            List<Insurance__c> insurances=dbSOQL.getInsurancesForEmergencyFund(entityId);
            system.debug('==insurances=='+insurances);
            List<Asset__c> assets=dbSOQL.getAssetsForEmergencyFund(entityId);
            system.debug('==assets=='+assets);
            List<Investment_Asset__c> investmentassets=dbSOQL.getInvestmentAssetsForEmergencyFund(entityId);
            system.debug('==investmentassets=='+investmentassets );
            /** Eternus Solutions     **/
			/** Author  : Manasi Ranade **/
			/** Issue Id: 00001486    **/
			/** Date    : 31/1/2012   **/
			/** Purpose : Added code to avoid duplication in the list while upserting it to the database
			/****************************************************/
            Set<String> checkDuplicateInsuranceSet = new Set<string>();
            Set<String> checkDuplicateAssetSet = new Set<string>();
            Set<String> checkDuplicateInvAssetSet = new Set<string>();
    
            for(EmergencyActionPlanBean bean: beanList){
                if(bean.ObjectName==Label.Insurance && bean.Action!=null){
                	//00001486 //Added code to avoid duplication in the list while upserting it to the database
                    for(Insurance__c insurance: insurances){
                        if(insurance.Entity__r.Name==bean.Owner && insurance.RecordType.Name==bean.Name && !checkDuplicateInsuranceSet.contains(insurance.id)){
                            insurance.EmergencyFundAction__c=bean.Action;
                            system.debug('==insuranceLis=='+insurance);
                            //00001486 //Added code to avoid duplication in the list while upserting it to the database
                            insuranceList.add(insurance);
                            checkDuplicateInsuranceSet.add(insurance.Id);
                        }    
                    }
                }
                if(bean.ObjectName==Label.Asset && bean.Action!=null){
                    for(Asset__c asset: assets){
                    	//00001486 //Added code to avoid duplication in the list while upserting it to the database
                        if( asset.Entity__r.Name==bean.Owner && (asset.Asset_Types__c==bean.Name || asset.Account_Type__c==bean.Name) 
                        					&& !checkDuplicateAssetSet.contains(asset.id)){
                            asset.EmergencyFundAction__c=bean.Action;
                            system.debug('==assetList=='+asset);
                            //00001486 //Added code to avoid duplication in the list while upserting it to the database
                            assetList.add(asset);
                            checkDuplicateAssetSet.add(asset.id);
                        }    
                    }
                }
                if(bean.ObjectName==Label.Investment_Asset && bean.Action!=null){
                	//00001486 //Added code to avoid duplication in the list while upserting it to the database
                    for(Investment_Asset__c invasset: investmentassets){
                        if(invasset.Entity__r.Name==bean.Owner && invasset.RecordType.Name==bean.Name && !checkDuplicateInvAssetSet.contains(invasset.id)){
                            invasset.EmergencyFundAction__c=bean.Action;
                            system.debug('==invassetList=='+invasset);
                            //00001486 //Added code to avoid duplication in the list while upserting it to the database
                            invassetList.add(invasset);
                            checkDuplicateInvAssetSet.add(invasset.id);
                        }    
                    }
                }
            }
            dbDML.upsertObject(assetList);
            dbDML.upsertObject(invassetList);
            dbDML.upsertObject(insuranceList);
        }
        catch(System.Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage())); 
        }
    }
}