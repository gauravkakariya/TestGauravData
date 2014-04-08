/**
Revision History:
 
    Version     Version Author     Date           Comments
    1.0         Aditi Satpute     27/09/2012     New Action Plan Creation
 * @Description:SumActionPlanServices is class to prepare the data as per the business logic. 
 * This is act as service class for the SumActionPlanController
 */
 
public with sharing class SumActionPlanServices 
{
	private DatabaseSOQL dbSOQLObj {get; set;}
    private DatabaseDML dbDMLObj {get; set;}
    public Date planDate{get; set;}
    
    public SumActionPlanServices()
    {
        dbSOQLObj = new DatabaseSOQL();
        dbDMLObj = new DatabaseDML();
    }
    
    /**
    * @Description: Get family details for particular entity
    * param: None 
    * return type: void
    */  
    
    public void getFamilyDetails(SummaryActionPlanBean beanObj)
    {
        beanObj.accList = dbSOQLObj.getFamilyDetails(beanObj.entityId);
        planDate = system.today();
        system.debug('***beanObj.accList'+beanObj.accList);
        for(Account acc : beanObj.accList)
        {
        	if(acc.Id == beanObj.entityId)
        	{
        		system.debug('***acc.Plan_Generation_Date__c***'+acc.Plan_Generation_Date__c);
        		planDate = acc.Plan_Generation_Date__c != null ? acc.Plan_Generation_Date__c : system.today();
        		return;
        	}
        	
        }
    }
   
    /**
    * @Description: getAsset details for particular entity
    * 
    * return type: void
    */  
    
    public void getAsset(SummaryActionPlanBean beanObj)
    {
        List<GoalInvestmentAssetAssociation__c> giaList = dbSOQLObj.getGoalInvestmentAssociationList(beanObj.entityId);
        List<GoalAssetAssociation__c> gaaList = dbSOQLObj.getGoalAssetAllocationList(beanObj.entityId);
        List<GoalInsuranceAssociation__c> ginaList = dbSOQLObj.getGoalInsuranceAllocationList(beanObj.entityId);
        
        //Unallocated assets
        List<Asset__c> assetList = dbSOQLObj.getAssets(beanObj.entityId);
        List<Investment_asset__c> investmentList = dbSOQLObj.getInvestmentAsset(beanObj.entityId,true);
        List<Insurance__c> insuranceList = dbSOQLObj.getInsuranceListByRecordType(beanObj.entityId);
        
        Set<Id> recIds = new Set<Id>();
        Set<String> processId = new set<String>();
        
        for(GoalInsuranceAssociation__c ginaObj: ginaList){
            recIds.add(ginaObj.Insurance__r.RecordTypeId);
        }
        List<RecordType> recList = dbSOQLObj.getRecordTypeNames(recIds);
        Map<Id,String> recMap = new Map<Id,String>();
        for(RecordType recObj: recList){
            recMap.put(recObj.Id, recObj.Name);
        }
        
        for(GoalAssetAssociation__c gaaObj: gaaList)
        {
            if(gaaObj.Asset__r.Action__c != '---None----')
            {
                //if(!processId.contains(gaaObj.Asset__c))
                {
                    processId.add(gaaObj.Asset__c);
                    SummaryActionPlanBean.SAssetAllocationBean tmpObj = new SummaryActionPlanBean.SAssetAllocationBean();
                    tmpObj.entityName = gaaObj.Asset__r.Entity__r.FirstName + ' ' + gaaObj.Asset__r.Entity__r.LastName;
                    tmpObj.action = gaaObj.Asset__r.Action__c;
                     System.debug('-------------------Allocation__c-----------'+ gaaObj.Allocation__c);
                    tmpObj.allocatedAmount = Math.Round(gaaObj.Allocation__c != null ? gaaObj.Allocation__c: 0);
                    tmpObj.allocatedPercent = Math.Round(gaaObj.Allocated__c != null ? gaaObj.Allocated__c: 0);  /* Prajakta - FP changes - 21-03-2013 */
                    tmpObj.goalName = gaaObj.Goal__r.Description__c;
                    
                    String description = '';
                    if(gaaObj.Asset__r.RecordType.Name == 'Govt. Saving Schemes' ||
               			gaaObj.Asset__r.RecordType.Name == 'Retirement Accounts'|| 
               			gaaObj.Asset__r.RecordType.Name == 'Deposits With Bank')
              		{
                		description = (gaaObj.Asset__r.RecordType.Name == 'Deposits With Bank') ? 
                      					((gaaObj.Asset__r.Bank_Name__c != null) ? (gaaObj.Asset__r.Bank_Name__c + ' - ' + gaaObj.Asset__r.Account_Number__c)
                       					: (gaaObj.Asset__r.Account_Number__c)) : (gaaObj.Asset__r.Account_Number__c);
              		}
              		else
                		description = (gaaObj.Asset__r.Description__c);
                    
                    if(gaaObj.Asset__r.Asset_Types__c!=null && gaaObj.Asset__r.Asset_Types__c!='')
                    {
                        tmpObj.Assets = gaaObj.Asset__r.Asset_Types__c +' / '+description;
                    }
                    else
                    {
                        tmpObj.Assets = gaaObj.Asset__r.Account_Type__c +' / '+description;
                    }
                    
                	beanObj.aaBeanList.add(tmpObj);
                }
            }
        }
        
        /*
        	Added By : Aditi Satpute
        	Date : 26/6/13
        	Purpose : Summary Action Plan page should display Mutual Fund,Stocks and Goal & Silver allocated values with its combined amount
        */
        
        Map<String,List<GoalInvestmentAssetAssociation__c>> mapNameToInvestmentAsset = new Map<String,List<GoalInvestmentAssetAssociation__c>>();
        Map<String,List<GoalInvestmentAssetAssociation__c>> mapNameToFixedIncomeAsset = new Map<String,List<GoalInvestmentAssetAssociation__c>>();
        
        for(GoalInvestmentAssetAssociation__c giaObj: giaList)
        {
        	
        	System.debug('-------------------Goal Name----------'+ giaObj.Goal__r.Description__c);
          /*  if(giaObj.Investment_Asset__r.Action__c != '---None----')
            {
                //if(!processId.contains('' + giaObj.Investment_Asset__r.Entity__c + giaObj.Investment_Asset__r.RecordTypeId))
                {
                    processId.add('' + giaObj.Investment_Asset__r.Entity__c + giaObj.Investment_Asset__r.RecordTypeId);
                    
                    SummaryActionPlanBean.SAssetAllocationBean tmpObj = new SummaryActionPlanBean.SAssetAllocationBean();
                    tmpObj.entityName = giaObj.Investment_Asset__r.Entity__r.FirstName + ' ' +giaObj.Investment_Asset__r.Entity__r.LastName;
                    tmpObj.action = giaObj.Investment_Asset__r.Action__c;
                    tmpObj.Assets = giaObj.Investment_Asset__r.RecordType.Name;
                    System.debug('-------------------Allocation__c-----------'+ giaObj.Allocation__c);
                    if(giaObj.investment_Asset__r.recordType.Name == 'Fixed Income')
			        	tmpObj.allocatedAmount = (giaObj.Investment_asset__r.TotalAsset__c *  giaObj.Allocated__c)/100;
                    else
                    	tmpObj.allocatedAmount = Math.Round(giaObj.Allocation__c != null ? giaObj.Allocation__c: 0);
                    
                    tmpObj.allocatedPercent = Math.Round(giaObj.Allocated__c != null ? giaObj.Allocated__c: 0);		// Prajakta - FP changes - 21-03-2013 
                    tmpObj.goalName = giaObj.Goal__r.Description__c;
                    beanObj.aaBeanList.add(tmpObj);
                }
            }*/
            
            System.debug('----------------giaObj.Investment_asset__r.RecordType.Name ---------'+ giaObj.Investment_asset__r.RecordType.Name );
            if(giaObj.Investment_asset__r.RecordType.Name == 'Fixed Income')
            {
            	
            	System.debug('------------------in if----------');
            	 if(giaObj.Investment_asset__r.Action__c != '---None----')
              	 { 
              		// if(!processId.contains('' + giaObj.Investment_Asset__r.Entity__c + giaObj.Investment_Asset__r.RecordTypeId))
                	 {
                    	 processId.add('' + giaObj.Investment_Asset__r.Entity__c + giaObj.Investment_Asset__r.RecordTypeId);
                    
                    	 String strKey = giaObj.Goal__c;
                    	 System.debug('-----------------giaObj---------'+giaObj);
	                	 if(mapNameToFixedIncomeAsset.containsKey(strKey))
	               		 {
		                     List<GoalInvestmentAssetAssociation__c> lstRelatedInvAsset = new List<GoalInvestmentAssetAssociation__c>(); 
		                     lstRelatedInvAsset = mapNameToFixedIncomeAsset.get(strKey);
		                     lstRelatedInvAsset.add(giaObj);
		                     mapNameToFixedIncomeAsset.put(strKey,lstRelatedInvAsset);
	               		 }
	              		 else
	                   	 {
	                     	 List<GoalInvestmentAssetAssociation__c> lstRelatedInvAsset = new List<GoalInvestmentAssetAssociation__c>();
	                     	 lstRelatedInvAsset.add(giaObj);
	                     	 mapNameToFixedIncomeAsset.put(strKey,lstRelatedInvAsset);
	                   	 }
	             	 }
	               }
	              
               }
               else
           	   {
             		if(giaObj.Investment_asset__r.Action__c != '---None----')
          	  		{ 
	          	  		String strKey = giaObj.Investment_asset__r.Entity__r.FirstName+':'+giaObj.Investment_asset__r.Entity__r.LastName+':'+giaObj.Investment_asset__r.RecordType.Name+':'+giaObj.Goal__c;
	                	if(mapNameToInvestmentAsset.containsKey(strKey))
	               		{
		                     List<GoalInvestmentAssetAssociation__c> lstRelatedInvAsset = new List<GoalInvestmentAssetAssociation__c>(); 
		                     lstRelatedInvAsset = mapNameToInvestmentAsset.get(strKey);
		                     lstRelatedInvAsset.add(giaObj);
		                     mapNameToInvestmentAsset.put(strKey,lstRelatedInvAsset);
	               		}
	              		else
	                   	{
	                     	 List<GoalInvestmentAssetAssociation__c> lstRelatedInvAsset = new List<GoalInvestmentAssetAssociation__c>();
	                     	 lstRelatedInvAsset.add(giaObj);
	                     	 mapNameToInvestmentAsset.put(strKey,lstRelatedInvAsset);
	                   	}
          			}
           	   }
         }
         System.debug('-----------------mapNameToFixedIncomeAsset---------'+mapNameToFixedIncomeAsset);
         List<GoalInvestmentAssetAssociation__c> lstGoalFixedIncomeAsset = new List<GoalInvestmentAssetAssociation__c>();
         for(String strEntityName : mapNameToFixedIncomeAsset.keySet())
         {
         	 lstGoalFixedIncomeAsset = mapNameToFixedIncomeAsset.get(strEntityName);
          	 system.debug('***lstGoalFixedIncomeAsset****'+lstGoalFixedIncomeAsset);
          	 for(GoalInvestmentAssetAssociation__c objGoalInvest : lstGoalFixedIncomeAsset )
          	 {
          	 	 SummaryActionPlanBean.SAssetAllocationBean tmpObj = new SummaryActionPlanBean.SAssetAllocationBean();
                	    
            	 if(objGoalInvest.Investment_asset__r.entity__r.LastName == null)
              	 {
                	 tmpObj.entityName = objGoalInvest.Investment_asset__r.entity__r.FirstName;
              	 }
              	 else if(objGoalInvest.Investment_asset__r.entity__r.FirstName == null )
              	 {
                	 tmpObj.entityName = objGoalInvest.Investment_asset__r.entity__r.LastName;
              	 }
              	 else if(objGoalInvest.Investment_asset__r.entity__r.LastName != null && objGoalInvest.Investment_asset__r.entity__r.FirstName != null)
              	 {
                	 tmpObj.entityName = objGoalInvest.Investment_asset__r.entity__r.FirstName +' '+ objGoalInvest.Investment_asset__r.entity__r.LastName;
              	 }
              	 else
              	 {
                	 tmpObj.entityName = '';
              	 }
            
            	 tmpObj.allocatedAmount = (objGoalInvest.Investment_asset__r.TotalAsset__c *  objGoalInvest.Allocated__c)/100;
            	 tmpObj.action = objGoalInvest.Investment_Asset__r.Action__c;
            	 tmpObj.goalName = objGoalInvest.Goal__r.Description__c;
            	 tmpObj.allocatedPercent = Math.Round(objGoalInvest.Allocated__c != null ? objGoalInvest.Allocated__c: 0);		
            	 
            	 Datetime dtReport = objGoalInvest.Investment_asset__r.Maturity_Date__c;
            	 String strDate = '';
            	 if(dtReport != null)
          			strDate = dtReport.day() + '-' + dtReport.month() + '-' + dtReport.year();
            	 String description = objGoalInvest.Investment_asset__r.Description__c + ' / ' + strDate;
            	 tmpObj.Assets = objGoalInvest.Investment_asset__r.RecordType.Name+' / '+description;
            	 beanObj.aaBeanList.add(tmpObj);	
          	 }
         }
         
         
         
		 Boolean isNotIncome = false;
		 String strInvestmentOwner = '';
         String strInvestmentAction = '';
	     double dblAllocatedAmt = 0;    
	     double dblAmountAllocated = 0;
	     String strInvestmentRecordType = '';
	     double dblInvestmentCurrentValue = 0;
	     double allocatedPercent = 0;
	     String goalName = '';
	     List<GoalInvestmentAssetAssociation__c> lstGoalInvestmentAsset = new List<GoalInvestmentAssetAssociation__c>();
         for(String strEntityName : mapNameToInvestmentAsset.keySet())
         {
             dblAmountAllocated = 0;
          	 lstGoalInvestmentAsset = mapNameToInvestmentAsset.get(strEntityName);
          	 system.debug('***strEntityName****'+strEntityName);
          	 system.debug('***lstGoalInvestmentAsset****'+lstGoalInvestmentAsset);
          	 for(GoalInvestmentAssetAssociation__c objGoalInvest : lstGoalInvestmentAsset )
          	 {
              	     isNotIncome = true;
              	  	 if(objGoalInvest.Investment_asset__r.entity__r.LastName == null)
	              	 {
	                 	 strInvestmentOwner = objGoalInvest.Investment_asset__r.entity__r.FirstName;
	              	 }
	              	 else if(objGoalInvest.Investment_asset__r.entity__r.FirstName == null )
	              	 {
	                  	 strInvestmentOwner = objGoalInvest.Investment_asset__r.entity__r.LastName;
	              	 }
	              	 else if(objGoalInvest.Investment_asset__r.entity__r.LastName != null && objGoalInvest.Investment_asset__r.entity__r.FirstName != null)
	              	 {
	                	  strInvestmentOwner = objGoalInvest.Investment_asset__r.entity__r.FirstName +' '+ objGoalInvest.Investment_asset__r.entity__r.LastName;
	              	 }
	              	 else
	              	 {
	                	  strInvestmentOwner = '';
	              	 }
		             dblAllocatedAmt = objGoalInvest.Allocated__c;
		             strInvestmentAction = objGoalInvest.Investment_asset__r.action__c;
		             strInvestmentRecordType =  objGoalInvest.investment_Asset__r.recordType.Name;
		             dblInvestmentCurrentValue = objGoalInvest.Investment_asset__r.TotalAsset__c ;
		             dblAmountAllocated = dblAmountAllocated + (dblInvestmentCurrentValue *  dblAllocatedAmt)/100;
		             allocatedPercent = Math.Round(objGoalInvest.Allocated__c != null ? objGoalInvest.Allocated__c: 0);
		             goalName = objGoalInvest.Goal__r.Description__c;
             }
	         if(isNotIncome)
	         {    
	             system.debug('****in isNotIncome****');
	             SummaryActionPlanBean.SAssetAllocationBean tmpIAObj = new SummaryActionPlanBean.SAssetAllocationBean();
	             
	             tmpIAObj.entityName = strInvestmentOwner;
                 tmpIAObj.action = strInvestmentAction;
                 tmpIAObj.Assets = strInvestmentRecordType;
               	 tmpIAObj.allocatedAmount = dblAmountAllocated;
                 tmpIAObj.allocatedPercent = allocatedPercent;
                 tmpIAObj.goalName = goalName;
                 beanObj.aaBeanList.add(tmpIAObj);
	         }
        } 
        
        for(GoalInsuranceAssociation__c ginaObj: ginaList)
        {
        	
            if(ginaObj.Insurance__r.Action__c != '---None----')
            {
                //if(!processId.contains(ginaObj.Insurance__c))
                {
                    processId.add(ginaObj.Insurance__c);
                    SummaryActionPlanBean.SAssetAllocationBean tmpObj = new SummaryActionPlanBean.SAssetAllocationBean();
                    tmpObj.entityName = ginaObj.Insurance__r.Entity__r.FirstName + ' ' + ginaObj.Insurance__r.Entity__r.LastName;
                    tmpObj.action = ginaObj.Insurance__r.Action__c;
                    if(recMap.get(ginaObj.Insurance__r.RecordTypeId)!=null){
                        tmpObj.Assets = recMap.get(ginaObj.Insurance__r.RecordTypeId);
                    }
                    if(ginaObj.Insurance__r.Insurance_Company__c != null){
                        tmpObj.Assets = tmpObj.Assets + ' / ' + ginaObj.Insurance__r.Insurance_Company__c;
                    }
                    if(ginaObj.Insurance__r.Policy_Type__c != null){
                        tmpObj.Assets = tmpObj.Assets + ' / ' + ginaObj.Insurance__r.Policy_Type__c;
                    }
                    if(ginaObj.Insurance__r.Policy_Name__c != null){
                        tmpObj.Assets = tmpObj.Assets + ' / ' + ginaObj.Insurance__r.Policy_Name__c;
                    }
                    if(ginaObj.Insurance__r.Policy_Number__c != null){
                        tmpObj.Assets = tmpObj.Assets + ' / ' + ginaObj.Insurance__r.Policy_Number__c;
                    }
                    System.debug('-------------------Allocation__c-----------'+ ginaObj.Allocation__c);
                    tmpObj.allocatedAmount = Math.round(ginaObj.Allocation__c != null ? ginaObj.Allocation__c: 0);
                    tmpObj.allocatedPercent = Math.round(ginaObj.Allocated__c != null ? ginaObj.Allocated__c: 0);	/* Prajakta - FP changes - 21-03-2013 */
                    tmpObj.goalName = ginaObj.Goal__r.Description__c;
                    beanObj.aaBeanList.add(tmpObj);
                }
            }
        }
        
        /* ---------------------------- Prajakta - FP changes II - 22-05-2013 - For Unallocated Assets ------------------------------------------- */
        //Map to store all AssetId's and its allocations 
        Map<String,Double> Assetpercentage = new Map<String,Double>(); 
        
        for(GoalAssetAssociation__c gaObj: gaaList)
        {
          	//Assetpercentage returns a map of AssetId to Sum of particular Asset allocated to different goals
            if(Assetpercentage.containsKey(gaObj.asset__c))
            {
              	Double dblPercentage = 0;
              	if(Assetpercentage.get(gaObj.asset__c) != null)
                	dblPercentage = Assetpercentage.get(gaObj.asset__c);
              	Assetpercentage.put(gaObj.asset__c,dblPercentage + gaObj.allocated__c);    //If same asset allocated for different goal, then it gets added to the first allocated percentage
            }
            else
            {
                Assetpercentage.put(gaObj.asset__c, gaObj.allocated__c);          //If asset allocated for some goal
            }
        }
        
        Double allocatedAmountAsset = 0;
      	//String strType = '';
      	//String description = '';
        
        for(Asset__c objAssets : assetList)
      	{
      		if(Assetpercentage.containsKey(objAssets.Id))
      		{
      			if(objAssets.Action__c != '---None----')
      			{
	      			SummaryActionPlanBean.UnallocatedAssets unObj = new SummaryActionPlanBean.UnallocatedAssets();
	      			allocatedAmountAsset = Assetpercentage.get(objAssets.Id);
	      			
	              	if(objAssets.Asset_Types__c!=null && objAssets.Asset_Types__c!='')
	                  	unObj.Assets = objAssets.Asset_Types__c;
	                else
	                    unObj.Assets = objAssets.Account_Type__c;
	                
	                unObj.entityName = objAssets.Entity__r.FirstName + ' ' + objAssets.Entity__r.LastName;
	                
	                if(objAssets.RecordType.Name == 'Govt. Saving Schemes' ||
	               		objAssets.RecordType.Name == 'Retirement Accounts'|| 
	               		objAssets.RecordType.Name == 'Deposits With Bank')
	              	{
	                	unObj.description = (objAssets.RecordType.Name == 'Deposits With Bank') ? 
	                      					((objAssets.Bank_Name__c != null) ? (objAssets.Bank_Name__c + ' - ' + objAssets.Account_Number__c)
	                       					: (objAssets.Account_Number__c)) : (objAssets.Account_Number__c);
	              	}
	              	else
	                	unObj.description = (objAssets.Description__c);
	                
	                if(objAssets.Monthly_Asset__c != null && allocatedAmountAsset < 100)
	              	{
	                	unObj.currentValue = 0.0;
	                	unObj.balanceRemaining = 0;
	                	unObj.currentValue = objAssets.Monthly_Asset__c;
	                	
	                	if(unObj.currentValue != null)
	                	{
	                  		allocatedAmountAsset = (unObj.currentValue * allocatedAmountAsset) / 100;
	                  		unObj.balanceRemaining = unObj.currentValue - allocatedAmountAsset;
	                	}
	                	else
	                  		unObj.balanceRemaining = 0;
	                  		
	                	if(Math.floor(unObj.balanceRemaining) > 0)
	                		beanObj.unallocatedList.add(unObj);
	              	}
	      		}
      		}
      		else if(objAssets.Allocated_Amount__c == 0.0)
      		{
      			if(objAssets.Action__c == '---None----')
	      		{
	      			SummaryActionPlanBean.UnallocatedAssets unObj = new SummaryActionPlanBean.UnallocatedAssets();
	      			
	              	if(objAssets.Asset_Types__c!=null && objAssets.Asset_Types__c!='')
	                  	unObj.Assets = objAssets.Asset_Types__c;
	                else
	                    unObj.Assets = objAssets.Account_Type__c;
	                
	                unObj.entityName = objAssets.Entity__r.FirstName + ' ' + objAssets.Entity__r.LastName;
	                
	                if(objAssets.RecordType.Name == 'Govt. Saving Schemes' ||
	               		objAssets.RecordType.Name == 'Retirement Accounts'|| 
	               		objAssets.RecordType.Name == 'Deposits With Bank')
	              	{
	                	unObj.description = (objAssets.RecordType.Name == 'Deposits With Bank') ? 
	                      					((objAssets.Bank_Name__c != null) ? (objAssets.Bank_Name__c + ' - ' + objAssets.Account_Number__c)
	                       					: (objAssets.Account_Number__c)) : (objAssets.Account_Number__c);
	              	}
	              	else
	                	unObj.description = (objAssets.Description__c);
	                
	                if(objAssets.Monthly_Asset__c != null)
	              	{
	                	unObj.currentValue = 0.0;
	                	unObj.balanceRemaining = 0;
	                	unObj.currentValue = objAssets.Monthly_Asset__c;
	                	
	                	if(unObj.currentValue != null)
	                	{
	                  		allocatedAmountAsset = 0;
	                  		unObj.balanceRemaining = unObj.currentValue - allocatedAmountAsset;
	                	}
	                	else
	                  		unObj.balanceRemaining = 0;
	                  		
	                	if(Math.floor(unObj.balanceRemaining) > 0)
	                		beanObj.unallocatedList.add(unObj);
	              	}
	      		}  	
      		}
      	}
        /*-------------------------------------- -------------------------------------- --------------------------------------- */
        
        /* ---------------------------- Prajakta - FP changes II - 22-05-2013 - For Unallocated Investment Assets ------------------------------------------- */
         
        Map<String,List<Investment_Asset__c>> mapNameToInvestment = new Map<String,List<Investment_Asset__c>>();
        Double allocatedAmountInvestment = 0;
		Double CurrentTotalValue = 0;
		Double amountAllocatedInvestment = 0;
        		
        for(GoalInvestmentAssetAssociation__c giObj: giaList)
      	{
            if(Assetpercentage.containsKey(giObj.Investment_asset__c))
            { 
               	Double dblPercentage = 0;
               	if(Assetpercentage.get(giObj.Investment_asset__c) != null)
                 	dblPercentage = Assetpercentage.get(giObj.Investment_asset__c);        //IA : Investment Asset
               	Assetpercentage.put(giObj.Investment_asset__c,dblPercentage + giObj.allocated__c);  //If IA id is already present in map then sum up all the percentage allocated for diff goals
            }
            else
            {
            	Assetpercentage.put(giObj.Investment_asset__c, giObj.allocated__c);    //If IA Id is not present in the map, put it in the map
            }
        }
        
        system.debug('-------Assetpercentage-----'+Assetpercentage.keySet());
        List<Investment_Asset__c>   lstInvestmentAsset = new List<Investment_Asset__c>();
        for(Investment_Asset__c objInvestment : investmentList)
        {
    		SummaryActionPlanBean.UnallocatedAssets unObj = new SummaryActionPlanBean.UnallocatedAssets();
    		unObj.Assets = objInvestment.RecordType.Name;
    		
    		if(Assetpercentage.containsKey(objInvestment.Id))
    		{
    			if(objInvestment.Action__c != '---None----')
    			{
        			system.debug('-------in if-----');
        			allocatedAmountInvestment = Assetpercentage.get(objInvestment.Id);
        			if(unObj.Assets == 'Fixed Income')
        			{
        				system.debug('-------in if--FixedIncome---');
        				unObj.currentValue = objInvestment.TotalAsset__c ;
        				unObj.entityName = objInvestment.Entity__r.FirstName + ' ' + objInvestment.Entity__r.LastName;
        				
        				CurrentTotalValue = CurrentTotalValue + unObj.currentValue;
                    	amountAllocatedInvestment = (unObj.currentValue *  allocatedAmountInvestment)/100;
                    	
                    	Datetime dtReport = objInvestment.Maturity_Date__c;
                    	String strDate = '';
                    	if(dtReport != null)
                  			strDate = dtReport.day() + '-' + dtReport.month() + '-' + dtReport.year();
                    	unObj.description = objInvestment.Description__c + ' / ' + strDate;
                    	
                    	if(unObj.currentValue != null)
                      		unObj.balanceRemaining = unObj.currentValue - amountAllocatedInvestment;
                		else
                      		unObj.balanceRemaining = 0;
                      		
                  		if(allocatedAmountInvestment < 100 && (Math.floor(unObj.balanceRemaining) > 0))
                  			beanObj.unallocatedList.add(unObj);
        			}
        			else
        			{
        				system.debug('-------in else---objInvestment-RecordType-'+objInvestment.RecordType.Name);
        				system.debug('-------in else---objInvestment-FirstName-'+objInvestment.Entity__r.FirstName);
        				//Key is created to uniquely identify stocks and mutual fund of entity and its family members
	                 	if(mapNameToInvestment.containsKey(objInvestment.Entity__r.FirstName + ' ' + objInvestment.Entity__r.LastName + objInvestment.RecordType.Name))
	                  	{
	                     	List<Investment_Asset__c> lstRelatedInvAsset = new List<Investment_Asset__c>(); 
	                     	lstRelatedInvAsset = mapNameToInvestment.get(objInvestment.Entity__r.FirstName +' '+ objInvestment.Entity__r.LastName + objInvestment.RecordType.Name);
	                     	lstRelatedInvAsset.add(objInvestment);
	                     	mapNameToInvestment.put(objInvestment.Entity__r.FirstName +' '+ objInvestment.Entity__r.LastName + objInvestment.RecordType.Name,lstRelatedInvAsset);
	                  	}
	                  	else
	                  	{
	                     	List<Investment_Asset__c> lstRelatedInvAsset = new List<Investment_Asset__c>();
	                     	lstRelatedInvAsset.add(objInvestment);
	                     	mapNameToInvestment.put(objInvestment.Entity__r.FirstName + ' ' + objInvestment.Entity__r.LastName + objInvestment.RecordType.Name,lstRelatedInvAsset);
	                  	}
        			}
    			}
    		}
    		else if(objInvestment.Allocated_Amount__c == 0.0)
    		{
    			if(objInvestment.Action__c == '---None----')
    			{
        			system.debug('-----else--in if-----');
        			if(unObj.Assets == 'Fixed Income')
        			{
        				system.debug('-------in if--FixedIncome---');
        				unObj.currentValue = objInvestment.TotalAsset__c ;
        				unObj.entityName = objInvestment.Entity__r.FirstName + ' ' + objInvestment.Entity__r.LastName;
        				
        				CurrentTotalValue = CurrentTotalValue + unObj.currentValue;
                    	amountAllocatedInvestment = 0.0;
                    	
                    	Datetime dtReport = objInvestment.Maturity_Date__c;
                    	String strDate = '';
                    	if(dtReport != null)
                  			strDate = dtReport.day() + '-' + dtReport.month() + '-' + dtReport.year();
                    	unObj.description = objInvestment.Description__c + ' / ' + strDate;
                    	
                    	if(unObj.currentValue != null)
                      		unObj.balanceRemaining = unObj.currentValue - amountAllocatedInvestment;
                		else
                      		unObj.balanceRemaining = 0;
                      		
                  		if((Math.floor(unObj.balanceRemaining) > 0))
                  			beanObj.unallocatedList.add(unObj);
        			}
        			else
        			{
        				system.debug('-------in else---objInvestment-RecordType-'+objInvestment.RecordType.Name);
        				system.debug('-------in else---objInvestment-FirstName-'+objInvestment.Entity__r.FirstName);
        				//Key is created to uniquely identify stocks and mutual fund of entity and its family members
	                 	if(mapNameToInvestment.containsKey(objInvestment.Entity__r.FirstName + ' ' + objInvestment.Entity__r.LastName + objInvestment.RecordType.Name))
	                  	{
	                     	List<Investment_Asset__c> lstRelatedInvAsset = new List<Investment_Asset__c>(); 
	                     	lstRelatedInvAsset = mapNameToInvestment.get(objInvestment.Entity__r.FirstName +' '+ objInvestment.Entity__r.LastName + objInvestment.RecordType.Name);
	                     	lstRelatedInvAsset.add(objInvestment);
	                     	mapNameToInvestment.put(objInvestment.Entity__r.FirstName +' '+ objInvestment.Entity__r.LastName + objInvestment.RecordType.Name,lstRelatedInvAsset);
	                  	}
	                  	else
	                  	{
	                     	List<Investment_Asset__c> lstRelatedInvAsset = new List<Investment_Asset__c>();
	                     	lstRelatedInvAsset.add(objInvestment);
	                     	mapNameToInvestment.put(objInvestment.Entity__r.FirstName + ' ' + objInvestment.Entity__r.LastName + objInvestment.RecordType.Name,lstRelatedInvAsset);
	                  	}
        			}
    			}
    		}
        }
        
        Integer temp = 0 ;
        for(String strEntityName : mapNameToInvestment.keySet())
        {      
        	system.debug('***strEntityName**Unalocated*'+strEntityName);
           	CurrentTotalValue = 0;
        	lstInvestmentAsset = mapNameToInvestment.get(strEntityName);
        
			SummaryActionPlanBean.UnallocatedAssets unObj = new SummaryActionPlanBean.UnallocatedAssets();
	        for(Investment_Asset__c objInvest : lstInvestmentAsset)
	        {
		    	unObj.Assets = objInvest.RecordType.Name;
		    	unObj.description = '-';
		    	unObj.entityName = objInvest.Entity__r.FirstName + ' ' + objInvest.Entity__r.LastName;
		        unObj.currentValue = objInvest.TotalAsset__c ;

		        allocatedAmountInvestment = Assetpercentage.get(objInvest.Id);
		        CurrentTotalValue = CurrentTotalValue + unObj.currentValue;
		        unObj.currentValue = CurrentTotalValue;
		        if(objInvest.Allocated_Amount__c != 0.0) 
         			amountAllocatedInvestment = (CurrentTotalValue *  allocatedAmountInvestment)/100;
         		else
         			amountAllocatedInvestment = 0.0;
	        }
              
          	if(CurrentTotalValue != null)
            	unObj.balanceRemaining = CurrentTotalValue - amountAllocatedInvestment;
        	else
            	unObj.balanceRemaining = 0;

          	if((Math.floor(unObj.balanceRemaining) > 0) && allocatedAmountInvestment < 100)
          		beanObj.unallocatedList.add(unObj);
          	else if((Math.floor(unObj.balanceRemaining) > 0))
          		beanObj.unallocatedList.add(unObj);
        }
      
        /* ---------------------------- Prajakta - FP changes II - 22-05-2013 - For Unallocated Insurances ------------------------------------------- */
        
        AssetAllocationService objAssetAllocation = new AssetAllocationService();
        
        //Assetpercentage map returns InsuranceId vs Particular insurance allocated for different goals
        for(GoalInsuranceAssociation__c ginObj: ginaList)
        {
            if(Assetpercentage.containsKey(ginObj.Insurance__c))
            {
              Double dblPercentage = 0;
              if(Assetpercentage.get(ginObj.Insurance__c) != null)
                dblPercentage = Assetpercentage.get(ginObj.Insurance__c);
              Assetpercentage.put(ginObj.Insurance__c,dblPercentage + ginObj.allocated__c);
            }
            else
            {
                Assetpercentage.put(ginObj.Insurance__c, ginObj.allocated__c);
            }
        }
        
        for(Insurance__c objInsurance : insuranceList)
    	{
    		if(Assetpercentage.containsKey(objInsurance.Id))
	    	{
	    		if(objInsurance.Action__c != '---None----')
	    		{
	    			SummaryActionPlanBean.UnallocatedAssets unObj = new SummaryActionPlanBean.UnallocatedAssets();
	    			
	    			//unObj.Assets = objInsurance.Policy_Type__c;
					if(recMap.get(objInsurance.RecordTypeId)!=null){
	                    unObj.Assets = recMap.get(objInsurance.RecordTypeId);
	                }
	                if(objInsurance.Policy_Type__c != null){
	                    unObj.Assets = unObj.Assets + ' / ' + objInsurance.Policy_Type__c;
	                }
	                
	                unObj.entityName = objInsurance.Entity__r.FirstName + ' ' + objInsurance.Entity__r.LastName;
					
					if(objInsurance.Insurance_Company__c != null){
	                    unObj.description = objInsurance.Insurance_Company__c;
	                }
	                if(objInsurance.Policy_Name__c != null){
	                    unObj.description = unObj.description + ' / ' + objInsurance.Policy_Name__c;
	                }
	                if(objInsurance.Policy_Number__c != null){
	                    unObj.description = unObj.description + ' / ' + objInsurance.Policy_Number__c;
	                }
					
					Double allocatedAmountInsurance = 0;
					Double dblOneInstallmentAmount = 0;
					Double currentInsuranceValue = 0;
					Integer iMaturityYear = 0;
					Integer iCurrentYearForCalculation = 0;
					Integer startYear = planDate != null ? planDate.year() : Date.today().year();
					Integer iTenureOfInsurance = 0 ;
					unObj.currentValue = 0.0;
	                unObj.balanceRemaining = 0;
	                Double allocatedAmount = 0;
											
					allocatedAmountInsurance = Assetpercentage.get(objInsurance.Id);
					
					if(objInsurance.Premium_Amount_Rs__c != null)
	               		dblOneInstallmentAmount = objInsurance.Premium_Amount_Rs__c;
					if(objInsurance.Tenure_of_Insurance__c != null)
	             		iTenureOfInsurance = Integer.valueOf(objInsurance.Tenure_of_Insurance__c);
	         		iMaturityYear = iTenureOfInsurance + objInsurance.Commencement_Date__c.year();
	         
	         		if(startYear > iMaturityYear)
	           			iCurrentYearForCalculation = iMaturityYear;
	         		else
	           			iCurrentYearForCalculation = startYear;
	         		Integer totalPeriodInYears =  iCurrentYearForCalculation - objInsurance.Commencement_Date__c.year();
	        
	        		if(objInsurance.Surrender_Cash_Value__c == null)
	          			currentInsuranceValue = objAssetAllocation.GetInsuranceAmountForPeriod(objInsurance,totalPeriodInYears, dblOneInstallmentAmount);
	        		else
	          			currentInsuranceValue = objInsurance.Surrender_Cash_Value__c;
	          		
	          		unObj.currentValue = currentInsuranceValue; 
	           		allocatedAmount = (allocatedAmountInsurance * currentInsuranceValue)/100 ;
	           			
	         		if(currentInsuranceValue != null)
	            		unObj.balanceRemaining = currentInsuranceValue - allocatedAmount;
	          		else
	            		unObj.balanceRemaining = 0;
	          		
	          		if(Math.floor(unObj.balanceRemaining) > 0 && allocatedAmountInsurance < 100)
						beanObj.unallocatedList.add(unObj);
	    		}
    		}
    		else
    		{
    			if(objInsurance.Action__c == '---None----')
				{	    			
	    			SummaryActionPlanBean.UnallocatedAssets unObj = new SummaryActionPlanBean.UnallocatedAssets();
	    			
	    			//unObj.Assets = objInsurance.Policy_Type__c;
					if(recMap.get(objInsurance.RecordTypeId)!=null){
	                    unObj.Assets = recMap.get(objInsurance.RecordTypeId);
	                }
	                if(objInsurance.Policy_Type__c != null){
	                    unObj.Assets = unObj.Assets + ' / ' + objInsurance.Policy_Type__c;
	                }
	                
	                unObj.entityName = objInsurance.Entity__r.FirstName + ' ' + objInsurance.Entity__r.LastName;
					
					if(objInsurance.Insurance_Company__c != null){
	                    unObj.description = objInsurance.Insurance_Company__c;
	                }
	                if(objInsurance.Policy_Name__c != null){
	                    unObj.description = unObj.description + ' / ' + objInsurance.Policy_Name__c;
	                }
	                if(objInsurance.Policy_Number__c != null){
	                    unObj.description = unObj.description + ' / ' + objInsurance.Policy_Number__c;
	                }
					
					Double allocatedAmountInsurance = 0;
					Double dblOneInstallmentAmount = 0;
					Double currentInsuranceValue = 0;
					Integer iMaturityYear = 0;
					Integer iCurrentYearForCalculation = 0;
					Integer startYear = planDate != null ? planDate.year() : Date.today().year();
					Integer iTenureOfInsurance = 0 ;
					unObj.currentValue = 0.0;
	                unObj.balanceRemaining = 0;
											
					//allocatedAmountInsurance = Assetpercentage.get(objInsurance.Id);
					
					if(objInsurance.Premium_Amount_Rs__c != null)
	               		dblOneInstallmentAmount = objInsurance.Premium_Amount_Rs__c;
					if(objInsurance.Tenure_of_Insurance__c != null)
	             		iTenureOfInsurance = Integer.valueOf(objInsurance.Tenure_of_Insurance__c);
	         		iMaturityYear = iTenureOfInsurance + objInsurance.Commencement_Date__c.year();
	         
	         		if(startYear > iMaturityYear)
	           			iCurrentYearForCalculation = iMaturityYear;
	         		else
	           			iCurrentYearForCalculation = startYear;
	         		Integer totalPeriodInYears =  iCurrentYearForCalculation - objInsurance.Commencement_Date__c.year();
	        
	        		if(objInsurance.Surrender_Cash_Value__c == null)
	          			currentInsuranceValue = objAssetAllocation.GetInsuranceAmountForPeriod(objInsurance,totalPeriodInYears, dblOneInstallmentAmount);
	        		else
	          			currentInsuranceValue = objInsurance.Surrender_Cash_Value__c;
	          		
	          		unObj.currentValue = currentInsuranceValue;
	           
	         		if(currentInsuranceValue != null)
	            		unObj.balanceRemaining = currentInsuranceValue;
	          		else
	            		unObj.balanceRemaining = 0;
	          		
	          		if(Math.floor(unObj.balanceRemaining) > 0 )
						beanObj.unallocatedList.add(unObj);
    			}
    		}
    	}
        
        /*-------------------------------------- -------------------------------------- --------------------------------------- */
        
    }
     
     
    /**
    * @Description: getGenerelInsurance details 
    * 
    * return type: List<Insurance__c>
    */  
        
    public List<Insurance__c> getGenerelInsurance(List<Account> accList){
        return dbSOQLObj.getAnalysisInsurances(InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c, accList);
    }
    
    
    /**
    * @Description: getLifeInsurance details 
    * 
    * return type: List<Insurance__c>
    */  
    
    public List<Insurance__c> getLifeInsurance(List<Account> accList){
        return dbSOQLObj.getAnalysisInsurances(InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c, accList);
    }
    
  /*  public void saveInsurence(SummaryActionPlanBean beanObj){
        dbDMLObj.upsertObject(beanObj.giList);
        dbDMLObj.upsertObject(beanObj.liList);
    }*/
   
    /**
    * @Description: getGoals details 
    * 
    * return type: void
    */
   
    
    public void getGoals(SummaryActionPlanBean beanObj){
         beanObj.goalList = dbSOQLObj.getAllGoals(beanObj.entityId);
    	system.debug('****beanObj.goalList**in SumActionPlanServices***'+beanObj.goalList);
    }
    
    /**
    * @Description: prepareData to display goal-profile wise insurance, asset details 
    * 
    * return type: void
    */
    
    public void prepareData(SummaryActionPlanBean beanObj){
        List<AggregateResult> goalInassetList = dbSOQLObj.getInvestAssociationSum(beanObj.accList);
        List<AggregateResult> goalAssetList = dbSOQLObj.getInsuranceAssociationSum(beanObj.accList);
        List<AggregateResult> goalInsurList = dbSOQLObj.getAssetAssociationSum(beanObj.accList);
        
        Set<Id> profileSet = new set<id>();
        Map<Id,Id> golProfileMap = new Map<Id,Id>();
        Map<Id,double> golAmountMap = new Map<Id,double>();
        for(AggregateResult agObj: goalInassetList)
        {
             if((Double)agObj.get('expr0')!=null)
             {
                 golAmountMap.put((Id)agObj.get('Goal__c'),(Double)agObj.get('expr0'));  
             }
        }
        for(AggregateResult agObj: goalAssetList)
        {
           if((Double)agObj.get('expr0')!=null){  
                 if(golAmountMap.get((Id)agObj.get('Goal__c'))!=null){
                     golAmountMap.put((Id)agObj.get('Goal__c'),golAmountMap.get((Id)agObj.get('Goal__c'))+(Double)agObj.get('expr0'));  
                 }else{
                     golAmountMap.put((Id)agObj.get('Goal__c'),(Double)agObj.get('expr0'));  
                 }
           }
        }
        for(AggregateResult agObj: goalInsurList)
        {
             if((Double)agObj.get('expr0')!=null){
                 if(golAmountMap.get((Id)agObj.get('Goal__c'))!=null){
                     golAmountMap.put((Id)agObj.get('Goal__c'),golAmountMap.get((Id)agObj.get('Goal__c'))+(Double)agObj.get('expr0'));  
                 }else{
                     golAmountMap.put((Id)agObj.get('Goal__c'),(Double)agObj.get('expr0'));  
                 }
             }
        }
        for(Goal__c golObj: beanObj.goalList)
        {
            profileSet.add(golObj.SelectedGoalProfile__c);
            golProfileMap.put(golObj.Id,golObj.SelectedGoalProfile__c); 
        }
        
        List<goal_Profile__c> lstProfile = dbSOQLObj.getProfileList(profileSet);
                                                 
        
        //beanObj.asetList 'expr0'
        Map<Id,Double> golProfileDebtMap = new Map<Id,Double>();
        Map<Id,Double> golProfileGoldMap = new Map<Id,Double>();
        Map<Id,Double> golProfileEquityMap = new Map<Id,Double>();
        
        for(goal_Profile__c prObj: lstProfile){
            golProfileDebtMap.put(prObj.Id, prObj.debt_Allocation__c);
            golProfileGoldMap.put(prObj.Id, prObj.Gold_allocation__c);
            golProfileEquityMap.put(prObj.Id, prObj.Equity_Allocation__c);
            
        }
        Map<Id, List<double>> classWiseGoal = new Map<Id, List<double>>();
        //beanObj.asetList
        //SummaryActionPlanBean.AssetClass asetDebt = new SummaryActionPlanBean.AssetClass();
        Datetime cDT = System.now();  /*Praj*/
        Integer currentYear = Integer.valueOf(cDT.format('yyyy'));
       
        List<Id> golIds = new List<Id>();
        for(Goal__c golObj: beanObj.goalList)
        {
            golIds.add(golObj.Id);
        }
        /** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: 00001470     	**/
		/** Date    : 1/2/2012  	**/
		/** Purpose : Code to use SIP's Equity,Debt,Gold % for Lumpsum
		/****************************************************/
        Map<Id, double> debtValMap = new  Map<Id, double>();
        Map<Id, double> equityValMap = new  Map<Id, double>();
        Map<Id, double> goldValMap = new  Map<Id, double>();
        Map<Id, double> totValMap = new  Map<Id, double>();
        double dblTotalPerc = 0,dblDebtPerc = 0,dblEquityPerc = 0,dblGoldPerc = 0;
        List<GoalSIPAmount__c> goalSips = dbSOQLObj.getGoalSIP(currentYear, golIds);
        Double dblTotalSIP = 0; 
        /*if(goalSips != null && goalSips.size() > 0)
        {
        	GoalSIPAmount__c objSIPAmt = new GoalSIPAmount__c();
        	objSIPAmt = goalSips[0];
        	dblTotalSIP = objSIPAmt.EquityCurrentYear__c + objSIPAmt.DebtCurrentYear__c + objSIPAmt.GoldCurrentYear__c;
        }*/
        double tempDebt = 0,tempEquity = 0,tempGold = 0;
        for(GoalSIPAmount__c sipObj: goalSips)
        {
        	tempEquity = (sipObj.EquityCurrentYear__c == null ? 0 : sipObj.EquityCurrentYear__c);
        	tempDebt = (sipObj.DebtCurrentYear__c == null ? 0 : sipObj.DebtCurrentYear__c);
        	tempGold = (sipObj.GoldCurrentYear__c == null ? 0 : sipObj.GoldCurrentYear__c);
        	
        	dblTotalSIP = tempEquity + tempDebt + tempGold;
			if(dblTotalSIP > 0)
			{
				
				dblDebtPerc = tempDebt / dblTotalSIP * 100;
				dblEquityPerc = tempEquity / dblTotalSIP * 100;
				dblGoldPerc = tempGold / dblTotalSIP * 100;
			}
			else
			{
				dblDebtPerc = 0;
				dblEquityPerc = 0;
				dblGoldPerc = 0;
			}
			
            debtValMap.put(sipObj.Goal__c, dblDebtPerc);
            equityValMap.put(sipObj.Goal__c, dblEquityPerc);
            goldValMap.put(sipObj.Goal__c, dblGoldPerc);
            //totValMap.put(sipObj.Goal__c, sipObj.SIP_Total__c);
        }
        /** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: 00001470     	**/
		/** Date    : 1/2/2012  	**/
		/** Purpose : Added debtValMap,equityValMap,goldValMap in following function
		/****************************************************/
        List<double> debtVals = prepareProfileWiseData(beanObj.goalList,golProfileMap,golProfileDebtMap, golAmountMap,beanObj,debtValMap);
        List<double> equityVals = prepareProfileWiseData(beanObj.goalList,golProfileMap,golProfileEquityMap, golAmountMap,beanObj,equityValMap);
        List<double> goldVals = prepareProfileWiseData(beanObj.goalList,golProfileMap,golProfileGoldMap, golAmountMap,beanObj,goldValMap);

        SummaryActionPlanBean.AssetClass asetDebt = new SummaryActionPlanBean.AssetClass('Debt', debtVals);
        SummaryActionPlanBean.AssetClass asetEquity = new SummaryActionPlanBean.AssetClass('Equity', equityVals);
        SummaryActionPlanBean.AssetClass asetGold = new SummaryActionPlanBean.AssetClass('Gold', goldVals);
        beanObj.asetList.add(asetDebt);
        beanObj.asetList.add(asetEquity);
        beanObj.asetList.add(asetGold);
        calculateTotal(beanObj);
        prepareSIPData(beanObj);
    }
    /** Eternus Solutions       **/
	/** Author  : Manasi Ranade **/
	/** Issue Id: 00001470     	**/
	/** Date    : 1/2/2012  	**/
	/** Purpose : Added percentageAllocationMap in prepareProfileWiseData function
	/****************************************************/
    private List<double> prepareProfileWiseData(List<Goal__c> goalListP, Map<Id, Id>golProfileMapP, Map<Id, double>golProfileClassMapP
    												, Map<Id, double>golAmountMapP,SummaryActionPlanBean beanObj, Map<Id, double> percentageAllocationMap){
    	//Original Code
        /*List<double> classVals = new List<double>();
        for(Goal__c golObj: goalListP){
            Id goalId = golObj.Id;
            double sumMF = golAmountMapP.get(goalId);
            double Perc = 0;
            double amount = 0;
            if(golProfileMapP.get(goalId)!=null && golProfileClassMapP.get(golProfileMapP.get(goalId))!=null){
                Perc = golProfileClassMapP.get(golProfileMapP.get(goalId));
                if(sumMF !=null && sumMF!=0){
                    amount = (sumMF * Perc)/100;
                }
            }
            classVals.add(amount);
            
         }
         return classVals; */
        List<double> classVals = new List<double>();
        for(Goal__c golObj: goalListP)
        {
            Id goalId = golObj.Id;
            double sumMF = golAmountMapP.get(goalId);
            double Perc = 0;
            double amount = 0;
            /** Eternus Solutions       **/
			/** Author  : Manasi Ranade **/
			/** Issue Id: 00001470     	**/
			/** Date    : 1/2/2012  	**/
			/** Purpose : Commented original Code
			/****************************************************/
            /*if(golProfileMapP.get(goalId)!=null && golProfileClassMapP.get(golProfileMapP.get(goalId))!=null){
                Perc = golProfileClassMapP.get(golProfileMapP.get(goalId));
                if(sumMF !=null && sumMF!=0){
                    amount = (sumMF * Perc)/100;
                }
            }*/
            if(percentageAllocationMap != null & percentageAllocationMap.get(goalId) != null){
                Perc = percentageAllocationMap.get(goalId);
                if(sumMF !=null && sumMF!=0){
                    amount = (sumMF * Perc)/100;
                }
            }
            classVals.add(amount);
            
         }
         return classVals;
    }
    
    private void calculateTotal(SummaryActionPlanBean beanObj){
        for(Integer i =0; i<beanObj.goalList.size();i++){
            double Total = 0;
            for(Integer j =0; j< beanObj.asetList.size(); j++){
                Total  = Total + beanObj.asetList[j].golListVals[i];
            }
            beanObj.totLumpSumList.add(Total);
        }
    }
 
 
  
    /**
    * @Description:  to prepare SIPData
    * 
    * return type: void
    */
       
    public void prepareSIPData(SummaryActionPlanBean beanObj)
    {
        Datetime cDT = System.now(); /*Praj*/
        Integer currentYear = Integer.valueOf(cDT.format('yyyy'));
       
        List<Id> golIds = new List<Id>();
        for(Goal__c golObj: beanObj.goalList)
        {
            golIds.add(golObj.Id);
        }
        Map<Id, double> debtValMap = new  Map<Id, double>();
        Map<Id, double> equityValMap = new  Map<Id, double>();
        Map<Id, double> goldValMap = new  Map<Id, double>();
        Map<Id, double> totValMap = new  Map<Id, double>();
        
        List<GoalSIPAmount__c> goalSips = dbSOQLObj.getGoalSIP(currentYear, golIds);
        for(GoalSIPAmount__c sipObj: goalSips)
        {
            debtValMap.put(sipObj.Goal__c, sipObj.SIP_Debt__c);
            equityValMap.put(sipObj.Goal__c, sipObj.SIP_Equity__c); 
            goldValMap.put(sipObj.Goal__c, sipObj.SIP_Gold__c);
            totValMap.put(sipObj.Goal__c, sipObj.SIP_Total__c);
        }
        List<double> debtVal = new List<double>();
        List<double> equityVal = new List<double>();
        List<double> goldVal = new List<double>();
        
        for(Goal__c golObj: beanObj.goalList)
        {
            if(debtValMap.get(golObj.Id)!=null){
                debtVal.add(debtValMap.get(golObj.Id));
            }else{
                debtVal.add(0);
            }
            if(equityValMap.get(golObj.Id)!=null){
                equityVal.add(equityValMap.get(golObj.Id));
            }else{
                equityVal.add(0);
            }
            if(goldValMap.get(golObj.Id)!=null){
                goldVal.add(goldValMap.get(golObj.Id));
            }else{
                goldVal.add(0);
            }
            if(totValMap.get(golObj.Id)!=null){
                beanObj.totSIPList.add(totValMap.get(golObj.Id));
            }else{
                beanObj.totSIPList.add(0);
            }
        } 
        
        SummaryActionPlanBean.SIPClass debtObj = new  SummaryActionPlanBean.SIPClass('Debt', debtVal);
        beanObj.sipList.add(debtObj);
        SummaryActionPlanBean.SIPClass equityObj = new  SummaryActionPlanBean.SIPClass('Equity', equityVal);
        beanObj.sipList.add(equityObj);
        SummaryActionPlanBean.SIPClass goldObj = new  SummaryActionPlanBean.SIPClass('Gold', goldVal);
        beanObj.sipList.add(goldObj);
    }    

}