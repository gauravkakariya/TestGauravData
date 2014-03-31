/*
	Revision History:
	
    Version     Version Author     Date           Comments
    1.0         Aditi Satpute     27/09/2012     New Action Plan Creation
    1.1         Aditi Satpute     27/12/2012     Add new method showExecutionTracker() to create ET records on click 
    											 Executon Tracker button from Action Plan page.
*/
public with sharing class ETController 
{
	/*public Boolean isPreview {get;set;}
    private ActionPlanServices serviceObj;
    public Boolean isMailSent{get;set;}
    public Boolean isSave{get;set;}
    
 	//Action Plan : Aditi Satpute=20-9-2012=
 	public EstatePlanningBean bean {get; set;}
  	private EstatePlanningServices service {get; set;}
  	public boolean toDisplayFields {get;set;}
  	public double SIPSummaryTotal{get;set;}
  	public double LumpsumSummaryTotal{get;set;}
  	public Integer counter {get;set;}
  	public Goal_Profile__c objGoalProfile{get;set;}
    public Boolean blnIsETAlreadyGenerated{get;set;}
    public String strEntityName {get;set;}
    public String strOwnerName {get;set;}
    public String strGeneratedDate {get;set;}
    public ApprovedPlanBean beanObj {get;set;}
	public Boolean isFreedomUser{get;set;}
	public Boolean isFreedomUserProp{get;set;}
	public Account Partnerlogo{get;set;}
	public Account Logo_partner{get;set;}
	public Id AccOwnerId{get;set;}
	public String addNewGoalId{get;set;}
    public String addNewLumpsumGoalId{get;set;}
    public String addNewInvestId{get;set;}
	public List<List<ApprovedPlanBean.RecommendedInsurance>> lstRecommendedInsurancePDF{get;set;}
	public Boolean isSidebar{get;set;}
	public string entity{get;set;}
    public string owner{get;set;}			//Prajakta
    public String emailBody {get; set;}
    public boolean isFPLimitedAccess{get;set;}
    public Map<String, ApprovedPlanBean.SIPFunds> mapStringToSIPFunds{get;set;}	
    
	//Added By : Aditi Satpute : to render Execution Tracker button
    public boolean isExecutionTrackerOpened{get;set;}
    
    
	public string openMutualFundPopup{get;set;}
	
	
	public DatabaseSOQL dbSOQLObj {get; set;}
  	public List<Goal__c> lstGoal{get;set;}
  	
  	 public List<Approve_Action_Plan__c> lstSIPApproveActionPlan
  	 {
  		get
  		{
  			if(lstSIPApproveActionPlan == null)
  			{
  				SIPSummaryTotal = 0;
  				lstSIPApproveActionPlan = [Select Transaction_Type__c, Remarks__c, Goal__c ,isSIPexecutionTracker__c, Amount__c,
  											Product_Name__c, Option__c, Installments__c, CreatedDate, Category__c 
  											From Approve_Action_Plan__c where Item_Type__c = 'SIP' and Account__c = : beanObj.entityId];
  				for(Approve_Action_Plan__c obj : lstSIPApproveActionPlan)
  				{
  					SIPSummaryTotal = SIPSummaryTotal + obj.Amount__c;
  				}
  			}
  			return lstSIPApproveActionPlan;
  		}
  		set;
  	}
    public List<Approve_Action_Plan__c> lstLumpsumApproveActionPlan{get;set;}
   // public List<ApprovedPlanBean.SIPFunds> lstSummarySIPFunds{get;set;}
 	public List<ApprovedPlanBean.SIPFunds> lstSummarySIPFunds
    {
    	get
    	{
    		lstSummarySIPFunds = new List<ApprovedPlanBean.SIPFunds>();
    		
    		 mapStringToSIPFunds = new Map<String, ApprovedPlanBean.SIPFunds>();
    		
	    	for(ApprovedPlanBean.SIPFunds objSF : beanObj.objEmergencyFundGoalDetails.lstSIPFunds)
	    	{
	    		String strKey = objSF.productName + '-' + objSF.transactionType + '-' + objSF.installments + '-' + objSF.option;
	  			if(!mapStringToSIPFunds.containsKey(strKey))
	  			{
	  				ApprovedPlanBean.SIPFunds objNewSIPFunds = new ApprovedPlanBean.SIPFunds();
	  				objNewSIPFunds.productName = objSF.productName;
	  				objNewSIPFunds.transactionType = objSF.transactionType;
	  				objNewSIPFunds.installments = objSF.installments;
	  				objNewSIPFunds.option = objSF.option;
			        objNewSIPFunds.remarks = objSF.remarks; 
			        objNewSIPFunds.category = objSF.category ;
			        objNewSIPFunds.amount = objSF.amount;
			       	// Date : 12/12/12 : Commented due to Removal of Execution Tacker from SIP Summary Table & Added to individual SIP Funds  
			      
	  				mapStringToSIPFunds.put(strKey, objNewSIPFunds);		
	  			}
	  			else
	  			{
	  				ApprovedPlanBean.SIPFunds objSIPFunds = mapStringToSIPFunds.get(strKey);
	  				if(objSF.amount != null )
	  				{
	  					objSIPFunds.amount +=  objSF.amount;
	  					mapStringToSIPFunds.put(strKey, objSIPFunds);
	  				}
	  			}
	    	}
	    	
	    	for(ApprovedPlanBean.GoalDetails objGoals: beanObj.lstGoalDetails)
		    {
		    	for(ApprovedPlanBean.SIPFunds objSIPs: objGoals.lstSIPFunds)
		       	{    
		        	String strKey = objSIPs.productName + '-' + objSIPs.transactionType + '-' + objSIPs.installments + '-' + objSIPs.option;
		  			if(!mapStringToSIPFunds.containsKey(strKey))
		  			{		
		  				ApprovedPlanBean.SIPFunds objNewSIPFunds = new ApprovedPlanBean.SIPFunds();
		  				objNewSIPFunds.productName = objSIPs.productName;
		  				objNewSIPFunds.transactionType = objSIPs.transactionType;
		  				objNewSIPFunds.installments = objSIPs.installments;
		  				objNewSIPFunds.option = objSIPs.option;
				        objNewSIPFunds.remarks = objSIPs.remarks; 
				        objNewSIPFunds.category = objSIPs.category ;
				        objNewSIPFunds.amount = objSIPs.amount;
				       
				        objNewSIPFunds.execTracker = objSIPs.execTracker;
				        if(objNewSIPFunds.execTracker)
		    				objNewSIPFunds.executionTracker = 'Yes';
		    			else
		    				objNewSIPFunds.executionTracker = 'No';
		  				mapStringToSIPFunds.put(strKey, objNewSIPFunds);		
		  			}
		  			else
		  			{
		  				ApprovedPlanBean.SIPFunds objSIPFunds = mapStringToSIPFunds.get(strKey);
		  				if(objSIPs.amount != null)
		  				{
			  				objSIPFunds.amount +=  objSIPs.amount;
			  				mapStringToSIPFunds.put(strKey, objSIPFunds);
		  				}
		  			} 
		      	}
		    }
	    	
	  		lstSummarySIPFunds.addAll(mapStringToSIPFunds.values());	
	  		return lstSummarySIPFunds;
    	}
    	set;
    }

    public ETController()
    {
    	lstGoal = new List<Goal__c>();
    	dbSOQLObj = new DatabaseSOQL();
    	isPreview = false;
        isFPLimitedAccess = false;
        isMailSent = false;
        isSave = true;
        isSidebar = true;
       // isExecutionTrackerOpened = false;
     	entity = System.currentPageReference().getParameters().get('entityId');
     	
    	
     	User objUser = [Select Profile.Name, ProfileId, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
     	if(objUser.Profile.Name == 'Financial Planner(Limited Access)' || objUser.Profile.Name == 'System Administrator')//Financial Planner(Limited Access) and System Administrator
     		isFPLimitedAccess = true;
       
       
       toDisplayFields = true;
       counter = 0;
       serviceObj = new ActionPlanServices();
       beanObj = new  ApprovedPlanBean();
       beanObj.entityId = Apexpages.currentPage().getParameters().get('entityId');
       serviceObj.getRecType(beanObj);
       blnIsETAlreadyGenerated = false;
       serviceObj.getFamilyDetails(beanObj);
       if(beanObj.accList != null)
	   {
	   	   for(Account objAccout : beanObj.accList)
	   	   {
	   	   		if(objAccout.Id == beanObj.entityId)
	   	   		{
            		AccOwnerId = objAccout.OwnerId; //Added for Partner Portal implementation Use ,Date : 31/7/12
	   	   			blnIsETAlreadyGenerated = objAccout.IsExecutionTrackerGenerated__c;
	   	   			if(objAccout.FirstName != null && objAccout.LastName != null)
	   	   				strEntityName = objAccout.FirstName + ' '+ objAccout.LastName;
	   	   			else if(objAccout.FirstName == null && objAccout.LastName != null)
	   	   				strEntityName = objAccout.LastName;
	   	   			else if(objAccout.FirstName != null && objAccout.LastName == null)
	   	   				strEntityName = objAccout.FirstName;
	   	   			else
	   	   				strEntityName = '';
	   	   			strOwnerName = objAccout.Owner.Name;
	   	   			strGeneratedDate = system.NOW().format('dd-MM-yyyy');
	   	   		}
	   	   }	
	   }
	   
       serviceObj.getGoals(beanObj);
       //serviceObj.getAssetAllocation(beanObj);
       beanObj.investment = serviceObj.getMFInvestmentAsset(beanObj.accList);
       beanObj.approvedPlanList = serviceObj.getdbApprovedPlans(beanObj.accList);
       serviceObj.getCurMFLumpSumApprovedPlans(beanObj);
       serviceObj.getCurMFSIPApprovedPlans(beanObj);
       serviceObj.getSuggMFSIPApprovedPlans(beanObj);
       serviceObj.getSuggMFLumpApprovedPlans(beanObj);
       
       beanObj.giList = serviceObj.getGenerelInsurance(beanObj.accList);
       if(beanObj.giList != null && beanObj.giList.size()>0)
       {
           beanObj.isGeneralInsExist = true;
       }
       
       beanObj.liList = serviceObj.getLifeInsurance(beanObj.accList);
       if(beanObj.liList != null && beanObj.liList.size()>0)
       {
           beanObj.isLifeInsExist = true;
       }
       
       serviceObj.getApprGenerelInsurance(beanObj);
       serviceObj.getApprLifeInsurance(beanObj);
       serviceObj.PrpeareSummary(beanObj);
       serviceObj.PrpeareSuggested(beanObj);
        //Code Added for Partner Portal related changes i.e Logo,Name etc.
        //Date :31/07/12  Code Added By :Aditi

         //Action Plan : Aditi Satpute   
        //============================================================================    
      	Id entityId = ApexPages.currentPage().getParameters().get('EntityId');
      	
        if(entityId!=null)
        {
            bean = new EstatePlanningBean();
            service = new EstatePlanningServices();
            bean.entity = service.getEntityDetails(entityId);
            if(bean.entity.Will__c==false)
                bean.spouse = service.getSpouseDetails(entityId);
            else
            	serviceObj.getWillExecTrackerDetails(beanObj); // for execution tracker
        }   
          
	   	lstGoal = beanObj.goalList;
  	    if(beanObj.entityId != null && beanObj.entityId != '')
		{  
			lstRecommendedInsurancePDF = new List<List<ApprovedPlanBean.RecommendedInsurance>>();
			
    		beanObj = serviceObj.fetchGoalDetails(beanObj);
			List<ApprovedPlanBean.RecommendedInsurance> lstRIForPDF = new List<ApprovedPlanBean.RecommendedInsurance>();
    		for(Integer i = 0;  i < beanObj.lstRecommendedInsurance.size() ; i++)
    		{
    			lstRIForPDF.add(beanObj.lstRecommendedInsurance[i]);
    			if(Math.mod((i+1), 5) == 0)
    			{
    				lstRecommendedInsurancePDF.add(lstRIForPDF);
    				lstRIForPDF = new List<ApprovedPlanBean.RecommendedInsurance>();
    			}
    		}
    		
    		if(Math.mod(beanObj.lstRecommendedInsurance.size(), 5) != 0)
    		{
    			lstRecommendedInsurancePDF.add(lstRIForPDF);
    		}
		}
		
        blnIsETAlreadyGenerated = false;
        
        lstLumpsumApproveActionPlan = new List<Approve_Action_Plan__c>();
    	getLumpsumApproveActionPlans();
    	lstSummarySIPFunds = new List<ApprovedPlanBean.SIPFunds>();
    	getSummarySIPFunds();
    	List<Account> lstAcc = dbSOQLObj.getFamilyMembers(beanObj.entityId);
		set<Id> familyIdSet = new set<Id>(); 
		for(Account objAcc : lstAcc)
		{
			familyIdSet.add(objAcc.Id);
		}
    	List<Execution_Tracker__c> lstExecutionTracker = [select Id from Execution_Tracker__c where Entity_Name__c =: familyIdSet];
    	if(lstExecutionTracker.size() == 0)
    	{
    		isSave = true;
    	}
    	else
    	{
    		if(Label.LockSave.equalsIgnoreCase('false'))
    		{
    			isSave = true;
    		}
    		else
    			isSave = false;
    	}
    }

    public void getSummarySIPFunds()
    {
    	lstSummarySIPFunds = new List<ApprovedPlanBean.SIPFunds>();
    	mapStringToSIPFunds = new Map<String, ApprovedPlanBean.SIPFunds>();
    	//beanObj = serviceObj.fetchGoalDetails(beanObj);
    	for(ApprovedPlanBean.SIPFunds objSF : beanObj.objEmergencyFundGoalDetails.lstSIPFunds)
    	{
    		String strKey = objSF.productName + '-' + objSF.transactionType + '-' + objSF.installments + '-' + objSF.option;
  			if(!mapStringToSIPFunds.containsKey(strKey))
  			{		
  				ApprovedPlanBean.SIPFunds objNewSIPFunds = new ApprovedPlanBean.SIPFunds();
  				objNewSIPFunds.productName = objSF.productName;
  				objNewSIPFunds.transactionType = objSF.transactionType;
  				objNewSIPFunds.installments = objSF.installments;
  				objNewSIPFunds.option = objSF.option;
		        objNewSIPFunds.remarks = objSF.remarks; 
		        objNewSIPFunds.category = objSF.category ;
		        objNewSIPFunds.amount = objSF.amount;
		      	// Date : 12/12/12 : Commented due to Removal of Execution Tacker from SIP Summary Table & Added to individual SIP Funds   
		 
  				mapStringToSIPFunds.put(strKey, objNewSIPFunds);		
  			}
  			else
  			{
  				ApprovedPlanBean.SIPFunds objSIPFunds = mapStringToSIPFunds.get(strKey);
  				objSIPFunds.amount +=  objSF.amount;
  				mapStringToSIPFunds.put(strKey, objSIPFunds);
  			}
    	}
    	
    	for(ApprovedPlanBean.GoalDetails objGoals: beanObj.lstGoalDetails)
	    {
	    	for(ApprovedPlanBean.SIPFunds objSIPs: objGoals.lstSIPFunds)
	       	{    
	        	String strKey = objSIPs.productName + '-' + objSIPs.transactionType + '-' + objSIPs.installments + '-' + objSIPs.option;
	  			if(!mapStringToSIPFunds.containsKey(strKey))
	  			{		
	  				ApprovedPlanBean.SIPFunds objNewSIPFunds = new ApprovedPlanBean.SIPFunds();
	  				objNewSIPFunds.productName = objSIPs.productName;
	  				objNewSIPFunds.transactionType = objSIPs.transactionType;
	  				objNewSIPFunds.installments = objSIPs.installments;
	  				objNewSIPFunds.option = objSIPs.option;
			        objNewSIPFunds.remarks = objSIPs.remarks; 
			        objNewSIPFunds.category = objSIPs.category ;
			        objNewSIPFunds.amount = objSIPs.amount;
			     // Date : 12/12/12 : Commented due to Removal of Execution Tacker from SIP Summary Table & Added to individual SIP Funds 
		
	  				mapStringToSIPFunds.put(strKey, objNewSIPFunds);		
	  			}
	  			else
	  			{
	  				ApprovedPlanBean.SIPFunds objSIPFunds = mapStringToSIPFunds.get(strKey);
	  				objSIPFunds.amount +=  objSIPs.amount;
	  				mapStringToSIPFunds.put(strKey, objSIPFunds);
	  			} 
	      	}
	    }
    	lstSummarySIPFunds = new List<ApprovedPlanBean.SIPFunds>();
  		lstSummarySIPFunds.addAll(mapStringToSIPFunds.values());
    }
    

    public void getLumpsumApproveActionPlans()
    {
    	Map<String, Approve_Action_Plan__c> mapStringToActionPlan = new Map<String, Approve_Action_Plan__c>();
    	lstLumpsumApproveActionPlan = [Select Transaction_Type__c, Remarks__c, Goal__c , Amount__c, Fund__c, Amount_Per_Installment__c,
  														 Product_Name__c, Option__c, Installments__c, CreatedDate, Category__c From Approve_Action_Plan__c 
  														 where Item_Type__c = 'Lumpsum' and Account__c = : beanObj.entityId and Amount__c != null];
  		LumpsumSummaryTotal = 0;
  		
  		for(Approve_Action_Plan__c objApprovedActionPlan : lstLumpsumApproveActionPlan)
  		{
  			String strKey = objApprovedActionPlan.Product_Name__c + '-' + objApprovedActionPlan.Transaction_Type__c + '-' + 
  							objApprovedActionPlan.Amount_Per_Installment__c + '-' + objApprovedActionPlan.Installments__c + '-' + objApprovedActionPlan.Option__c;
  			if(!mapStringToActionPlan.containsKey(strKey))
  			{
  				mapStringToActionPlan.put(strKey, objApprovedActionPlan);		
  			}
  			else
  			{
  				Approve_Action_Plan__c objAAP = mapStringToActionPlan.get(strKey);
  				objAAP.Amount__c +=  objApprovedActionPlan.Amount__c;
  				mapStringToActionPlan.put(strKey, objAAP);
  			}
  			if(objApprovedActionPlan.Amount__c != null )
  			{
  				LumpsumSummaryTotal = LumpsumSummaryTotal + objApprovedActionPlan.Amount__c;
  			}
  		}
  		lstLumpsumApproveActionPlan = new List<Approve_Action_Plan__c>();
  		lstLumpsumApproveActionPlan.addAll(mapStringToActionPlan.values());
    }
    
 
    public pageReference upsertData()
    {
       	Double dblAssetAmount = 0,dblActionAmount = 0,dblSIPChange = 0,dblCurrentSIP = 0;
	    Boolean blnIsActionAmountGreater = false,blnIsSIPChangeGreater = false;
	    String strSIPScheme ='',strLumpsumScheme ='';
	  
        for(ApprovedPlanBean.CurrentMFLumpSum tmpObj: beanObj.currentMFLumpSumList)
	    {
	    	if(tmpObj.assetAmount != null)
	        	dblAssetAmount = tmpObj.assetAmount;
	        	
        	if(tmpObj.actionAmount != null)
	        	dblActionAmount = tmpObj.actionAmount;
	        	
        	if(dblAssetAmount < dblActionAmount)
        	{
        		blnIsActionAmountGreater = true;
        		
        		if(strLumpsumScheme == '')
        			strLumpsumScheme = tmpObj.schemeName;
        		else
        			strLumpsumScheme = strLumpsumScheme + ',' + tmpObj.schemeName;
        	}
        }
    
        if(blnIsActionAmountGreater)
        {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ActionAmountGreater+'. For the schemes: '+strLumpsumScheme));
            return null;
        }
        
   		serviceObj.upsertData(beanObj);
   		pageReference pageRef = new pageReference('/apex/ApprovedPlan?entityId='+beanObj.entityId+'&tabname=Financial Planning');
   		return pageRef ;
    } 
   

    public void saveActionPlan()
    { 
   		//Added on 24/12/2012 : for Retrieving Family member
		Set<Id> setFamilyMemberId = new Set<Id>(); 
		for(Account objAcc : dbSOQLObj.getFamilyMembers(beanObj.entityId))
		{
		    setFamilyMemberId.add(objAcc.Id);
		}
       	//serviceObj.saveActionPlan(beanObj,mapStringToSIPFunds);
       	isExecutionTrackerOpened = true;
       	getLumpsumApproveActionPlans();
       	getSummarySIPFunds();
       	List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
       	for(Approve_Action_Plan__c objApproveActionPlan : [select isNewMutualFund__c,isSIPexecutionTracker__c 
       															from Approve_Action_Plan__c where Account__c IN: setFamilyMemberId and isNewMutualFund__c = true])
      	{
      		objApproveActionPlan.isSIPexecutionTracker__c = false;
      		lstApproveActionPlan.add(objApproveActionPlan);
      	}
      	if(!lstApproveActionPlan.isEmpty())
      		update lstApproveActionPlan;
    } 
   

    public pageReference addNewSuggLump()
    {
       ApprovedPlanBean.SuggestedMFLumpSum tmpObj = serviceObj.AddNewSuggMFLump(beanObj);
       beanObj.SuggestedMFLumpSumList.add(tmpObj);
       return null;
    } 
    

    public pageReference addNewSIPFund()
    {
       
       addNewGoalId = apexPages.currentPage().getParameters().get('addNewGoalId');
       
       for(ApprovedPlanBean.GoalDetails obj : beanObj.lstGoalDetails)
       {
       		if(addNewGoalId == obj.goalId)
       		{
       			for(Integer iCount = 0; iCount < 2 ;iCount ++)
        		{
	       			ApprovedPlanBean.SIPFunds objSIPFunds = serviceObj.AddNewSIPFunds(beanObj);
	       			obj.lstSIPFunds.add(objSIPFunds);
	       			//obj.lstSIPFunds.add(objSIPFunds);
	       			//obj.lstSIPFunds.add(objSIPFunds);
        		}
        		break;
       		}
       }
       
       if(addNewGoalId == beanObj.objEmergencyFundGoalDetails.goalId)
   	   {
   	   		for(Integer iCount = 0; iCount < 2 ;iCount ++)
        	{
	   	   		ApprovedPlanBean.SIPFunds objAddNewSIPFunds = serviceObj.AddNewSIPFunds(beanObj);
	   			beanObj.objEmergencyFundGoalDetails.lstSIPFunds.add(objAddNewSIPFunds);
        	}
   	   }
       return null;
    } 
   

    public pageReference addNewLumpsumFund()
    {
       ApprovedPlanBean.LumpsumFunds objLumpsumFunds = serviceObj.AddNewLumpsumFunds(beanObj);
       
       addNewLumpsumGoalId = apexPages.currentPage().getParameters().get('addNewLumpsumGoalId');
       for(ApprovedPlanBean.GoalDetails obj : beanObj.lstGoalDetails)
       {
       		if(addNewLumpsumGoalId == obj.goalId)
       		{
       			obj.lstLumpsumFunds.add(objLumpsumFunds);
       			break;
       		}
       }
       
       if(addNewLumpsumGoalId == beanObj.objEmergencyFundGoalDetails.goalId)
   	   {
   			beanObj.objEmergencyFundGoalDetails.lstLumpsumFunds.add(objLumpsumFunds);
   	   }
       return null;
    } 
   
 
    public pageReference addNewSuggSIP()
    {
       ApprovedPlanBean.SuggestedMFSIP tmpObj = serviceObj.AddNewSuggMFSIP(beanObj);
       beanObj.suggestedMFSIPList.add(tmpObj);
       return null;
    } 
   
   public pageReference Approved()
   {
       return null;
   }

   public pageReference RemoveRecordLump()
   {
        serviceObj.RemoveRecordLump(beanObj);
        return null;
   }
   
      
  
   public void RemoveRecordSIP()
   {
        serviceObj.RemoveRecordSIPFunds(beanObj);
   }
   
 
   public List<selectOption> getSchemeNames()
   {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult field = Schema.sObjectType.Approved_Action_Plan__c.fields.Scheme_Name__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        for(Schema.PicklistEntry p : picklist) 
        {
            options.add(new selectOption(p.getLabel(), p.getLabel()));
        }
        
        return options;
    }
 
    public List<selectOption> getSipActions()
    {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult field = Schema.sObjectType.Approved_Action_Plan__c.fields.SIP_Action__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        for(Schema.PicklistEntry p : picklist) 
        {
            options.add(new selectOption(p.getLabel(), p.getLabel()));
        }
        
        return options;
    }
  
    public List<selectOption> getSugLumpActions()
    {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult field = Schema.sObjectType.Approved_Action_Plan__c.fields.Suggested_LumpSum_Action__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        
        for(Schema.PicklistEntry p : picklist) 
        {
            options.add(new selectOption(p.getLabel(), p.getLabel()));
        }
        
        return options;
    }
 
    public List<selectOption> getLumpActions()
    {
       List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult field = Schema.sObjectType.Approve_Action_Plan__c.fields.Lumpsum_Action__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        for(Schema.PicklistEntry p : picklist) 
        {
            options.add(new selectOption(p.getLabel(), p.getLabel()));
        }
        
        return options;
    }
   
    public List<selectOption> getAssetClass()
    {
         List<selectOption> options = new List<selectOption>();
	     options.add(new selectOption('Gold', 'Gold'));        
	     options.add(new selectOption('Equity', 'Equity'));
	     options.add(new selectOption('Debt', 'Debt'));
	     options.add(new selectOption('Hybrid', 'Hybrid'));
         return options;
    }
    
 
    public List<selectOption> getEntities()
    {
        List<selectOption> options = new List<selectOption>();
        for(Account acc: beanObj.accList) 
        {
            options.add(new selectOption(acc.Id, acc.FirstName + ' '+ acc.LastName));
        }
        
        return options;
        
    }
    
  
    public List<selectOption> getSIPTransactionType()
    {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('Existing SIP- COB', 'Existing SIP- COB'));
        options.add(new selectOption('New SIP', 'New SIP'));
        
        return options;
    }
    
 
    public List<selectOption> getLumpsumTransactionType()
    {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('Lumpsum', 'Lumpsum'));
        options.add(new selectOption('STP From', 'STP From'));
        options.add(new selectOption('STP To', 'STP To'));  
        options.add(new selectOption('Hold - COB', 'Hold - COB'));  
        options.add(new selectOption('Switch From', 'Switch From'));  
        options.add(new selectOption('Switch To', 'Switch To'));  
        return options;
    }
    
   
    public List<selectOption> getExecutionTracker()
    {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('Yes', 'Yes'));
        options.add(new selectOption('No', 'No'));
        
        return options;
    }
    
  
    public List<selectOption> getOptions()
    {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('Growth', 'Growth'));
        options.add(new selectOption('Dividend Reinvestment', 'Dividend Reinvestment'));
         options.add(new selectOption('Dividend Payout', 'Dividend Payout'));
        return options;
    }
    
  
     public pageReference SummaryActionPlanPage()
     {
        pageReference pageRef = new pageReference('/apex/SummaryActionPlanPage?entityId='+beanObj.entityId+'&tabname=Financial Planning');
        return pageRef ;
     }
    
     public pageReference actionPlanPDF()
     {
        pageReference pageRef = new pageReference('/apex/ActionPlanPDF?entityId='+beanObj.entityId+'&tabname=Financial Planning');
        return pageRef ;
     }
    
    
     //Adding new blank Row in current mutual fund
    
     private Integer countNewRecord = 1;
     public void addCurrentMutualFundRow()
     {
     	toDisplayFields = false;
      	ApprovedPlanBean.CurrentMutualFunds objAddNewCurrentMutualFunds = new ApprovedPlanBean.CurrentMutualFunds();
      	
      	ApprovedPlanBean.CurrentMutualFunds objlastRecordCurrentMutualFunds = new ApprovedPlanBean.CurrentMutualFunds();
      	
      	List<ApprovedPlanBean.CurrentMutualFunds> lstAddNewCurrentMutualFunds = new List<ApprovedPlanBean.CurrentMutualFunds>();
      	
      	//===========Added on 30/11/2012 : for Retrieving Family member
	  	List<Account> lstAcc = dbSOQLObj.getFamilyMembers(beanObj.entityId);
		set<Id> familyIdSet = new set<Id>(); 
		for(Account objAcc : lstAcc)
		{
			familyIdSet.add(objAcc.Id);
		}
		//==============================================================
      	Map<Id,Investment_Asset__c> mapIdToInvestmentAsset = new  Map<Id,Investment_Asset__c>
    	 													 ([Select Entity__c, Entity__r.FirstName, Entity__r.LastName, Scheme_Name_Text__c , TotalAsset__c,
								         					   RecordType.Name, Asset_Type__c, Allocated_Amount__c, Action__c , Monthly_SIP_Amount__c 
								         					   From Investment_Asset__c  
								         					   where Entity__c =: familyIdSet //Added on 30/11/2012
								         					   //where Entity__c =: beanObj.entityId 
								         					   and RecordType.Name = 'Mutual Fund' ]);
      
      	Investment_Asset__c objInvestment = new Investment_Asset__c();
      	
      	Integer lastRecord = 0;
      	List<ApprovedPlanBean.CurrentMutualFunds> lstCMF = new List<ApprovedPlanBean.CurrentMutualFunds>();
      	Double totalAmount = 0.0;
        for(Id investmentId : beanObj.mapIdToCurrentFunds.keySet())
        {
        	
       		if(investmentId == addNewInvestId)
       		{
       			
       			if(mapIdToInvestmentAsset.containsKey(investmentId))
		      	{
		      		lstCMF = beanObj.mapIdToCurrentFunds.get(investmentId);
		      		objInvestment = mapIdToInvestmentAsset.get(investmentId);
		      		for(ApprovedPlanBean.CurrentMutualFunds objMF : lstCMF)
		      		{
		      			totalAmount += objMF.actionAmount;
		      		}
		      		if(Math.ceil(objInvestment.TotalAsset__c) <= Math.ceil(totalAmount))
	           		{
                		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Action Amount total should not be greater than Amount'));
                		return;
	           		}
		      		objlastRecordCurrentMutualFunds = lstCMF[lstCMF.size() - 1];
		      		
   					objAddNewCurrentMutualFunds.amount = objlastRecordCurrentMutualFunds.amount - objlastRecordCurrentMutualFunds.actionAmount;
		      		objAddNewCurrentMutualFunds.schemeName = objlastRecordCurrentMutualFunds.schemeName;
   					objAddNewCurrentMutualFunds.assetClass = objlastRecordCurrentMutualFunds.assetClass;
   					objAddNewCurrentMutualFunds.actionAmount = 0.0;
   					//objAddNewCurrentMutualFunds.SIPexecutionTracker = 'No';
   					//objAddNewCurrentMutualFunds.amount = objInvestment.TotalAsset__c;
   					objAddNewCurrentMutualFunds.lumpsumAction = 'Hold - Change of broker';
   					objAddNewCurrentMutualFunds.account = objlastRecordCurrentMutualFunds.account;
   					objAddNewCurrentMutualFunds.investmentId = investmentId;
   					objAddNewCurrentMutualFunds.owner = objlastRecordCurrentMutualFunds.owner;
   					objAddNewCurrentMutualFunds.newCount = countNewRecord++;
   					objAddNewCurrentMutualFunds.isNewMutualFund = true;
   					
   					if(objlastRecordCurrentMutualFunds.actionAmount <= 0.0)
	           		{
                		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Mutual Fund Action Amount should be greater than Zero'));
                		return;
	           		}
	           		
   					else
   					{
   						if(beanObj.mapIdToCurrentFunds.containsKey(investmentId))
		       			{
		       				lstAddNewCurrentMutualFunds = beanObj.mapIdToCurrentFunds.get(investmentId);
		       				lstAddNewCurrentMutualFunds.add(objAddNewCurrentMutualFunds);
		       				beanObj.mapIdToCurrentFunds.put(investmentId,lstAddNewCurrentMutualFunds);
		       			}
   					}
   					
		      	}
       			break;
       		}
       }
    }
     
     
    public String removeInvestmentId {get;set;}
    public Integer recordNumber {get;set;}
   
    	//Remove the new add row of current mutual fund
   
    public void removeCurrentMutualFundRow()
    {
    	List<ApprovedPlanBean.CurrentMutualFunds> lstAddNewCurrentMutualFunds = new List<ApprovedPlanBean.CurrentMutualFunds>();
    	lstAddNewCurrentMutualFunds = beanObj.mapIdToCurrentFunds.get(removeInvestmentId);
    	Integer index = 0;
    	for(ApprovedPlanBean.CurrentMutualFunds objCMF: lstAddNewCurrentMutualFunds)
    	{
    		if(objCMF.newCount == recordNumber && objCMF.isNewMutualFund)
    		{
    			break;
    		}
    		index++;
    	}
    	
    	ApprovedPlanBean.CurrentMutualFunds objCurrentMutualFunds = new ApprovedPlanBean.CurrentMutualFunds();
    	objCurrentMutualFunds = lstAddNewCurrentMutualFunds[index];
    	
    	for(Integer i = index +1 ; i < lstAddNewCurrentMutualFunds.size() ; i++)
    	{
    		lstAddNewCurrentMutualFunds[i].amount += objCurrentMutualFunds.actionAmount;
    	}
    	
    	lstAddNewCurrentMutualFunds.remove(index);
    	beanObj.mapIdToCurrentFunds.put(removeInvestmentId, lstAddNewCurrentMutualFunds);
    }
    
     
    // Purpose : Created Function and added FistName and LastName in the select statement. 
	public Account selectAccount()
	{
		Account objSelectedAcc = [select id,PlanGenerationDateFromSystem__c,LastName,FirstName from Account where Id =: beanObj.entityId];
		return objSelectedAcc;
	}
	
	public Map<ID,EntityRelatedAttachment__c>  getRelatedAttachmentMap(String idEntity)
	{
		Map<ID,EntityRelatedAttachment__c> MapofIdRelatedAttachment = new Map<ID,EntityRelatedAttachment__c>();
		for(EntityRelatedAttachment__c objRelatedAttachment :[select Id,Related_Entity__c from EntityRelatedAttachment__c where Related_Entity__c = : idEntity])
		{
			MapofIdRelatedAttachment.put(objRelatedAttachment.Related_Entity__c,objRelatedAttachment); 
		}
		return MapofIdRelatedAttachment; 
	}
    
    public pageReference saveActionPlanPDF()
    {
     	Blob htmlBody;
		Blob pdfBody;
        PageReference AttachmentPlan;
        Attachment PlanAttachment;
        Account objSelectedAcc;
        String strEntityName;
        String strRelatedId;
        EntityRelatedAttachment__c objRelatedAttachment;
        
        if(beanObj.entityId != null)
     	{	
     		objSelectedAcc = selectAccount();
     		Map<ID,EntityRelatedAttachment__c> MapofIdRelatedAttachment  = getRelatedAttachmentMap(beanObj.entityId);
     		
     		if(!MapofIdRelatedAttachment.isEmpty() && MapofIdRelatedAttachment.containsKey(beanObj.entityId))
     			objRelatedAttachment =  MapofIdRelatedAttachment.get(beanObj.entityId);
     			
     		strEntityName = objSelectedAcc.FirstName; 
     		
     		if(objSelectedAcc.LastName != null)
     			strEntityName  +=  '_' + objSelectedAcc.LastName;
     	}
		try
		{
			AttachmentPlan = Page.ActionPlanPDF; //Page name
   		 	AttachmentPlan.getParameters().put('entityId',beanObj.entityId);
   		 	AttachmentPlan.getParameters().put('displayButtons','0');
   		 	AttachmentPlan.getParameters().put('isSendEmail','true');
	   		 	
			String strPlanName = 'Action_Plan_' + strEntityName + '_'+ system.NOW().format('dd-MM-yyyy hh:mm:ss');
			if(!Test.isRunningTest())
				pdfBody = AttachmentPlan.getContentAsPDF(); //get content in pdf format
			
			// Attach content as pdf file
			PlanAttachment = new Attachment();
			if(objRelatedAttachment != null)
			PlanAttachment.ParentId = objRelatedAttachment.Id;
	       	PlanAttachment.Name = strPlanName + '.pdf';	//Name format of the PDF: Plan_EntityName_Date.pdf  
			PlanAttachment.Body = pdfBody;
			PlanAttachment.ContentType = '';
			insert PlanAttachment;
			
			PageReference pr = Page.ActionPlanHtml; //Page name
   		 	pr.getParameters().put('entityId',entity);
   		 	pr.getParameters().put('displayButtons','2');
   		 	pr.getParameters().put('attachmentId',PlanAttachment.Id);
   		 	
   		 	htmlBody = pr.getContent(); //get content in html format
   		 	

			// Attach content as html file		
			PlanAttachment = new Attachment();
			if(objRelatedAttachment != null)
	      	PlanAttachment.ParentId = objRelatedAttachment.Id;
			PlanAttachment.Name = strPlanName + '.htm';	//Name format of the HTML: Plan_EntityName_Date.htm  
			PlanAttachment.Body = htmlBody;
			PlanAttachment.ContentType = '';
			insert PlanAttachment;
			if(objSelectedAcc != null)
			{
				objSelectedAcc.PlanGenerationDateFromSystem__c = Date.today();
	     		update objSelectedAcc;	   
			}
		}
		catch(System.Exception e)
		{
			error.DebugLog('==Error=='+e.getMessage());
        }
        return null ;
    }
    
    public void makeRequiredOnSTPFrom()
    {
    	//do nothing
    }
    
    public void showPreview()
    {
    	isPreview = true;
    }
    
    public void showActionPlan()
    {
    	isPreview = false;
    	isSidebar = true;
    }
    public Pagereference sendEmail()
	{
		try
		{
			PageReference AttachmentPlan;
			Blob pdfBody;
			Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
			AttachmentPlan = Page.ActionPlanPDF; //Page name
   		 	AttachmentPlan.getParameters().put('entityId',entity);
   		 	AttachmentPlan.getParameters().put('displayButtons','0');
			AttachmentPlan.getParameters().put('isSendEmail','true');
			pdfBody = AttachmentPlan.getContentAsPDF();
			efa.setFileName('Plan_'+system.NOW().format('dd-MM-yyyy hh:mm:ss')+'.pdf');
         	efa.setBody(pdfBody);
			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
	        // Create the email attachment 
	       
	        List<String> toAddresses = new List<String>();
	        //toAddresses.add('');
	        //00001598 Add sender display name as entity owner
	        Account objAccount = [Select Id, Name,PersonEmail,Email_Temp__c,OwnerId,owner.name from Account where Id =: entity];
	        // Sets the paramaters of the email
	         if(objAccount.PersonEmail != null)
	        	toAddresses.add(objAccount.PersonEmail);
	         else
	         	toAddresses.add(objAccount.Email_Temp__c);
	        
	
	        email.setSubject( 'Plan for ' + objAccount.Name);		
	        email.setToAddresses( toAddresses );
	      
	       
	        if(emailBody != null && emailBody != '')
	        	email.setHtmlBody(emailBody.replaceAll('\n','<br/>'));
			else
				email.setHtmlBody('Dear '+objAccount.Name+'<br/><br/>Kindly find the attached pdf.');
				email.setSenderDisplayName(objAccount.Owner.Name);
       			email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
	        
	        // Sends the email 
            Messaging.SendEmailResult [] arrResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            isMailSent = true;
		}
		catch(Exception e)
		{
			//strMessage = e.getMessage();
		}
		return null;
	}
	
	
	
     public pageReference showExecutionTracker()
     {
     	 String strEntityId = Apexpages.currentPage().getParameters().get('entityId');
     	 
     	 List<Approve_Action_Plan__c> lstApproveActionPlan = [select Id from Approve_Action_Plan__c where Account__c =: strEntityId];
 		 if(lstApproveActionPlan.isEmpty())
 		 {
 		 	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'There is no Action Plan generated for this Entity'));
 		 	isSidebar = false;
 		 }
     	 else
     	 {
     	 	 isSave = false;
	     	 List<Execution_Tracker__c> lstExistingETrecords = [SELECT Id FROM Execution_Tracker__c where Entity_Name__c =: strEntityId  and  Is_Floating__c = false];
			 if(lstExistingETrecords.size() == 0)
			 {
			 	 isSidebar = true;
		     	 //Added on 24/12/2012 : for Retrieving Family member
				 Set<Id> familyIdSet = new Set<Id>(); 
				 List<Account> lstAcc = dbSOQLObj.getFamilyMembers(beanObj.entityId);
				
				 for(Account objAcc : lstAcc)
				 {
					familyIdSet.add(objAcc.Id);
				 }
				 
				 //Retieve all records from Action Plan whose ET to be opened is "Yes""
		     	 List<Approve_Action_Plan__c> lstActionPlanETrecords = [Select Transaction_Type__c, isExecutionTracker__c, isInsuranceExecutionTracker__c,
		   		 																Remarks__c, Goal__c , isLumpsumExecTracker__c, Action_Amount__c,Scheme_Name__c,
		   		 																Amount__c, Product_Name__c, Account__c , SIP_Action_Amount__c,Current_SIP__c ,
		   		 																Option__c, Installments__c, Item_Type__c , Insurance__r.Premium_Amount_Rs__c,
		   		 																CreatedDate, Category__c, isSIPexecutionTracker__c ,Investment_Asset__c,
		   		 																Account__r.FirstName, Account__r.LastName ,Account__r.PersonMobilePhone, Account__r.PersonEmail,
		   		 																Account__r.PersonBirthdate, Account__r.PAN_ID__pc, Policy_Name__c, Insurance__r.Policy_Name__c,
		   		 																Insurance__r.Sum_Assured_Rs__c, Insurance__r.Policy_Number__c, Account__r.Bank_Account_Number2__c,
		   		 																Account__r.Bank_Name__c, Account__r.Branch_details__c,Account__r.Bank_Account_Type__c,Account__r.MICR_Number__c,
		   		 																Account__r.IFSC_Number__c, Account__r.Renewal_Date__c, Insurance__r.Policy_Type__c
		   		 													 	From Approve_Action_Plan__c
	   		 													 		where Account__c IN : familyIdSet
		   		 																and (isSIPexecutionTracker__c = true or isLumpsumExecTracker__c = true 
		   		 																or isInsuranceExecutionTracker__c = true or isExecutionTracker__c = true)];
		   		 							
			   	List<Execution_Tracker__c>  lstETrecords = new List<Execution_Tracker__c>();
			   	for(Approve_Action_Plan__c objActionPlan : lstActionPlanETrecords)	
			   	{
			   		//Mutual Fund Lumpsum
			   		if(objActionPlan.isExecutionTracker__c)
			   		{
			   			Execution_Tracker__c objActionPlanMF = new Execution_Tracker__c();
			   			objActionPlanMF.Approve_Action_Plan__c = objActionPlan.Id;
			   			objActionPlanMF.Entity_Name__c = 	objActionPlan.Account__c;
			   			objActionPlanMF.Goal__c = objActionPlan.Goal__c;
			   			objActionPlanMF.ET_Status__c = 'Assigned to MET';
			   			objActionPlanMF.Type__c = 'Lumpsum';
			   			objActionPlanMF.Suggested_Amount__c = objActionPlan.Action_Amount__c;
			   			objActionPlanMF.Amount__c = objActionPlan.Amount__c;
			   			objActionPlanMF.Investor_Name_as_in_PAN_card__c = objActionPlan.Account__r.FirstName +' '+ objActionPlan.Account__r.LastName;
			   			objActionPlanMF.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
			   			objActionPlanMF.Email__c = objActionPlan.Account__r.PersonEmail;
			   			objActionPlanMF.DOB__c = objActionPlan.Account__r.PersonBirthdate;
			   			objActionPlanMF.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
			   			objActionPlanMF.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
			   			objActionPlanMF.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
			   			objActionPlanMF.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
			   			objActionPlanMF.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
			   			objActionPlanMF.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
			   			objActionPlanMF.Scheme_Name_Policy_Name__c = objActionPlan.Scheme_Name__c;
			   			objActionPlanMF.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c; 
			   			objActionPlanMF.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
			   			//objActionPlanMF.Communication_Address__c = strAddress;
			   			lstETrecords.add(objActionPlanMF); 
			   		}
			   		//Mutual Fund Running SIP & SIP Funds
			   		if(objActionPlan.isSIPexecutionTracker__c)
			   		{
			   			Execution_Tracker__c objActionPlanMF = new Execution_Tracker__c();
			   			objActionPlanMF.Approve_Action_Plan__c = objActionPlan.Id;
			   			objActionPlanMF.Entity_Name__c = 	objActionPlan.Account__c;
			   			objActionPlanMF.Goal__c = objActionPlan.Goal__c;
			   			objActionPlanMF.ET_Status__c = 'Assigned to MET';
			   			objActionPlanMF.Type__c = 'SIP';
			   			objActionPlanMF.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
			   			objActionPlanMF.Email__c = objActionPlan.Account__r.PersonEmail;
			   			objActionPlanMF.DOB__c = objActionPlan.Account__r.PersonBirthdate;
			   			objActionPlanMF.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
			   			objActionPlanMF.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
			   			objActionPlanMF.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
			   			objActionPlanMF.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
			   			objActionPlanMF.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
			   			objActionPlanMF.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
			   			objActionPlanMF.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
			   			objActionPlanMF.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
			   			if(objActionPlan.Investment_Asset__c != null)
			   			{
			   				objActionPlanMF.Suggested_Amount__c = objActionPlan.SIP_Action_Amount__c;
			   				objActionPlanMF.Amount__c = objActionPlan.Current_SIP__c;
			   				objActionPlanMF.Investor_Name_as_in_PAN_card__c = objActionPlan.Account__r.FirstName +' '+ objActionPlan.Account__r.LastName;
			   				objActionPlanMF.Scheme_Name_Policy_Name__c = objActionPlan.Scheme_Name__c;
			   			}
			   			else//SIP Funds
			   			{
			   				objActionPlanMF.Suggested_Amount__c = objActionPlan.Amount__c;
			   				objActionPlanMF.Option__c = objActionPlan.Option__c;
			   				objActionPlanMF.Transaction_Type__c = objActionPlan.Transaction_Type__c;
			   				objActionPlanMF.SIP_Installments__c = objActionPlan.Installments__c;
			   				objActionPlanMF.Scheme_Name_Policy_Name__c = objActionPlan.Product_Name__c;
			   			}
			   			lstETrecords.add(objActionPlanMF);
			   		} 
			   		//Lumpsum Funds
			   		if(objActionPlan.isLumpsumExecTracker__c)
			   		{
			   			Execution_Tracker__c objActionPlanMF = new Execution_Tracker__c();
			   			objActionPlanMF.Approve_Action_Plan__c = objActionPlan.Id;
			   			objActionPlanMF.Entity_Name__c = 	objActionPlan.Account__c;
			   			objActionPlanMF.Goal__c = objActionPlan.Goal__c;
			   			objActionPlanMF.ET_Status__c = 'Assigned to MET';
			   			objActionPlanMF.Type__c = 'Lumpsum';
			   			objActionPlanMF.Suggested_Amount__c = objActionPlan.Amount__c;
			   			objActionPlanMF.Option__c = objActionPlan.Option__c;
			   			objActionPlanMF.Transaction_Type__c = objActionPlan.Transaction_Type__c;
			   			objActionPlanMF.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
			   			objActionPlanMF.Email__c = objActionPlan.Account__r.PersonEmail;
			   			objActionPlanMF.DOB__c = objActionPlan.Account__r.PersonBirthdate;
			   			objActionPlanMF.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
			   			objActionPlanMF.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
			   			objActionPlanMF.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
			   			objActionPlanMF.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
			   			objActionPlanMF.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
			   			objActionPlanMF.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
			   			objActionPlanMF.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
			   			objActionPlanMF.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
			   			objActionPlanMF.Scheme_Name_Policy_Name__c = objActionPlan.Product_Name__c;
			   			
			   			lstETrecords.add(objActionPlanMF);
			   		}
			   		//Life Insurance & General Insurance
			   		if(objActionPlan.isInsuranceExecutionTracker__c)
			   		{
			   			Execution_Tracker__c objActionPlanMF = new Execution_Tracker__c();
			   			objActionPlanMF.Approve_Action_Plan__c = objActionPlan.Id;
			   			objActionPlanMF.Entity_Name__c = objActionPlan.Account__c;
			   			objActionPlanMF.Goal__c = objActionPlan.Goal__c;
			   			objActionPlanMF.ET_Status__c = 'Assigned to MET';
			   			objActionPlanMF.Type__c = objActionPlan.Item_Type__c;
			   			objActionPlanMF.Asset_Class_Policy_Type__c = objActionPlan.Insurance__r.Policy_Type__c;
			   			if(objActionPlan.Item_Type__c.equals('Life Insurance'))
			   			{
			   				objActionPlanMF.Policy_Name__c = objActionPlan.Policy_Name__c;
			   				objActionPlanMF.Scheme_Name_Policy_Name__c = objActionPlan.Policy_Name__c;
			   			}
						else
						{
							objActionPlanMF.Policy_Name__c = objActionPlan.Insurance__r.Policy_Name__c;
							objActionPlanMF.Scheme_Name_Policy_Name__c = objActionPlan.Insurance__r.Policy_Name__c;
							objActionPlanMF.Sum_Assured__c = objActionPlan.Insurance__r.Sum_Assured_Rs__c;
						}
			   			objActionPlanMF.Suggested_Amount__c = objActionPlan.Insurance__r.Premium_Amount_Rs__c;
			   			objActionPlanMF.Policy_Number__c = objActionPlan.Insurance__r.Policy_Number__c;
			   			objActionPlanMF.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
			   			objActionPlanMF.Email__c = objActionPlan.Account__r.PersonEmail;
			   			objActionPlanMF.DOB__c = objActionPlan.Account__r.PersonBirthdate;
			   			objActionPlanMF.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
			   			objActionPlanMF.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
			   			objActionPlanMF.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
			   			objActionPlanMF.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
			   			objActionPlanMF.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
			   			objActionPlanMF.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
			   			objActionPlanMF.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
			   			objActionPlanMF.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
			   		
			   			lstETrecords.add(objActionPlanMF);
			   		}
			   	}	
		     
				Messaging.SingleEmailMessage emailToEntity = new Messaging.SingleEmailMessage();
				Messaging.SingleEmailMessage emailToMet = new Messaging.SingleEmailMessage();
				Account objBPAccount = new Account();
				Contact objContact = new Contact();
			    List<String> lstToEntityOwnerAddresses = new List<String>();
				List<String> lstToMetAddresses = new List<String>();
				List<Execution_Tracker__c> lstETrecordsWithMETowner = new List<Execution_Tracker__c>();
				
			   	Account objAccount = [Select Id, Name,Related_To__c, OwnerId, owner.name from Account where Id =: beanObj.entityId];
			   	Map<Id,User> mapIdToUser = new Map<Id,User>([select Id,Name,ContactId , ManagerId, Email from User]);
			   	
			   	if(objAccount != null)
			    {
			        //Send Email to Entity Owner & MET - If Entity is Business Partner Entity
			        if(objAccount.Related_To__c.equalsIgnoreCase('Business Partner'))
			        {
			        	lstToMetAddresses = new List<String>();
			        	lstToEntityOwnerAddresses = new List<String>();
			        	lstETrecordsWithMETowner = new List<Execution_Tracker__c>();
			        	
			        	emailToMet = new Messaging.SingleEmailMessage();
			        	emailToEntity = new Messaging.SingleEmailMessage();
			        	
			        	//Send Email to Entity Owner
				    	if(mapIdToUser.containsKey(objAccount.OwnerId))
				    	{
				    		User objBPEntityOwnerUser = mapIdToUser.get(objAccount.OwnerId);
				    		
			                if(objBPEntityOwnerUser.ContactId != null)
			                {
			                    //To fetch Contact of that particular BP User
			                    objContact = [select AccountId from Contact where id =: objBPEntityOwnerUser.ContactId];
			                    //To fetch Account with previously fetched Contact
			                    objBPAccount = [select Id, Email_ID__c, OwnerId, Channel_Manager__c , Channel_Manager__r.Name , IsCreatedByPartner__c, Phone, Name from Account where id =: objContact.AccountId];    
			                }
				    		//User objBPAccountUser = mapIdToUser.get(objBPAccount.OwnerId);
				    		
					    	if(objBPEntityOwnerUser.Email != null)
				    			lstToEntityOwnerAddresses.add(objBPEntityOwnerUser.Email);
				    		if(!lstToEntityOwnerAddresses.isEmpty())
					        	emailToEntity.setToAddresses( lstToEntityOwnerAddresses );
					        	
					        emailToEntity.setSubject( 'Execution Tracker Generated for ' + objAccount.Name);		
					      	emailToEntity.setHtmlBody('Dear '+objAccount.Owner.Name+',<br/><br/>Action Plan is being generated and Execution Tracker records of "'
					      								+objAccount.Name+'" are being created for the Member Engagement Team.<br/><br/>'
					      								+'Thanks<br/>'+ objBPAccount.Channel_Manager__r.Name);
							emailToEntity.setSenderDisplayName(objBPAccount.Channel_Manager__r.Name);
							
					        // Sends the email to Entity Owner
					        Messaging.SendEmailResult [] arrBPEntityOwnerResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToEntity});
					        
					        //Send Chatter Notification to Entity Owner
						 
				    	}
				    	
			        	//Send Email to Bussiness Partner's MET
			        	if(mapIdToUser.containsKey(objAccount.OwnerId))
			    		{
				        	User objBusinessEntityUser = mapIdToUser.get(objAccount.OwnerId);
				        	
				        	List<Workstation__c> lstBPWorkstation = [Select Member_Engagement__c, Member_Engagement__r.Name, Financial_Planner__c 
				        										From Workstation__c 
				        										where Financial_Planner__c = : objBPAccount.Channel_Manager__c];
				        	if(lstBPWorkstation.isEmpty())
		   					{
								ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Please add Entity Owner as Financial Planner in Workstation'));
	            				return null;
				   			}									
				        	if(mapIdToUser.containsKey(objBPAccount.Channel_Manager__c))	
				        	{								
					        	User objChannelManagerUser = mapIdToUser.get(objBPAccount.Channel_Manager__c);
					        	
							   	if(lstBPWorkstation[0].Member_Engagement__c != null)
							    {
							    	if(mapIdToUser.containsKey(lstBPWorkstation[0].Member_Engagement__c))
							    	{
							    		User objBusinessPartnerMetUser = mapIdToUser.get(lstBPWorkstation[0].Member_Engagement__c);
							    		if(objBusinessPartnerMetUser.Email != null)
						    				lstToMetAddresses.add(objBusinessPartnerMetUser.Email);
						    			if(!lstToMetAddresses.isEmpty())
						    			 emailToMet.setToAddresses( lstToMetAddresses );
							    	}
							    }
							    
							   	emailToMet.setSubject( 'Execution Tracker Generated for ' + objAccount.Name);		
						        String domain = URL.getSalesforceBaseUrl().toExternalForm();
						     	String TargetLink = domain + '/' + objAccount.Id;
						     	
						      	emailToMet.setHtmlBody('Dear '+lstBPWorkstation[0].Member_Engagement__r.Name+',<br/><br/>Action Plan has been generated for "'
						      								  +objAccount.Name+'" and executions can be done. Please go through the related Execution Trackers.<br/>Click here : <a href=\''
						      								  +TargetLink+'\'>'+TargetLink+'</a> <br/><br/> Thanks,<br/>'+objChannelManagerUser.Name);
								emailToMet.setSenderDisplayName(objChannelManagerUser.Name);
								
								for(Execution_Tracker__c objAssignMetOwner : lstETrecords)
								{
									objAssignMetOwner.Owner__c = lstBPWorkstation[0].Member_Engagement__c;
									objAssignMetOwner.Send_Email__c = true;
									objAssignMetOwner.Send_Email_Datetime__c = System.now();
									objAssignMetOwner.Send_SMS__c = true;
									objAssignMetOwner.Send_SMS_Datetime__c = System.now();
									lstETrecordsWithMETowner.add(objAssignMetOwner);
									
								}
								
								//insert ET records  into data base with Owner as MET
								if(!lstETrecordsWithMETowner.isEmpty())			
									insert lstETrecordsWithMETowner;
									
								//Sends the mail to MET
							   	Messaging.SendEmailResult [] arrBusinessPartnerMetResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToMet});
							   
						   	  	//Send Chatter Notification to MET
								FeedItem post = new FeedItem();
								post.ParentId = lstBPWorkstation[0].Member_Engagement__c;
								post.Body = 'Action Plan has been generated for "' +objAccount.Name+ '" and executions can be done.'+
								 			 'Please go through the related Execution Trackers.';
								insert post;
				        	}
			    		}
			        }
			        //if Entity is Ffreedom Entity or Virtual PArtner Entity
			        else 
			        {
			        	lstToMetAddresses = new List<String>();
			        	lstToEntityOwnerAddresses = new List<String>();
			        	emailToMet = new Messaging.SingleEmailMessage();
			        	emailToEntity = new Messaging.SingleEmailMessage();
			        	
			        	//Send Email to Entity Owner
				  		
				    	
				    	//Send Email to Ffreedom/Virtual Partner Entity's MET 
				        //Query to fetch MET record from workstation
					   	List<Workstation__c> lstWorkstation = [Select Member_Engagement__c, Member_Engagement__r.Name, Financial_Planner__c 
					   									 From Workstation__c 
					   									 where Financial_Planner__c = : objAccount.Owner.Id];
					   									 
					   	if(lstWorkstation.isEmpty())
			   			{
							ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Please add Entity Owner as Financial Planner in Workstation'));
	            			return null;
				   		}
					   	if(lstWorkstation[0].Member_Engagement__c != null)
					    {
					    	if(mapIdToUser.containsKey(lstWorkstation[0].Member_Engagement__c))
							{
						    	User objMetUser = mapIdToUser.get(lstWorkstation[0].Member_Engagement__c);
						    	if(objMetUser.Email != null)
					    			lstToMetAddresses.add(objMetUser.Email);
					    		if(!lstToMetAddresses.isEmpty())
					    			emailToMet.setToAddresses( lstToMetAddresses );
							}
					    }
					    
					   	emailToMet.setSubject( 'Execution Tracker Generated for ' + objAccount.Name);		
				        String domain = URL.getSalesforceBaseUrl().toExternalForm();
				     	String TargetLink = domain + '/' + objAccount.Id;
				     	
				      	emailToMet.setHtmlBody('Dear '+lstWorkstation[0].Member_Engagement__r.Name+',<br/><br/>Action Plan has been generated for "'
				      								  +objAccount.Name+'" and executions can be done. Please go through the related Execution Trackers.<br/>Click here : <a href=\''
				      								  +TargetLink+'\'>'+TargetLink+'</a> <br/><br/> Thanks,<br/>'+objAccount.Owner.Name);
						emailToMet.setSenderDisplayName(objAccount.Owner.Name);
						
						for(Execution_Tracker__c objAssignMetOwner : lstETrecords)
						{
							objAssignMetOwner.Send_Email__c = true;
							objAssignMetOwner.Send_Email_Datetime__c = System.now();
							objAssignMetOwner.Send_SMS__c = true;
							objAssignMetOwner.Send_SMS_Datetime__c = System.now();
							objAssignMetOwner.Owner__c = lstWorkstation[0].Member_Engagement__c;
							lstETrecordsWithMETowner.add(objAssignMetOwner);
						}
						system.debug('*********lstETrecordsWithMETowner**********'+lstETrecordsWithMETowner);
						//insert ET records  into data base with Owner as MET
						if(!lstETrecordsWithMETowner.isEmpty())			
							insert lstETrecordsWithMETowner;
							
						//Sends the email Notification to MET
					   	Messaging.SendEmailResult [] arrMetResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToMet});
					   	
					   	//Send Chatter Notification to MET
					 	FeedItem post = new FeedItem();
						post.ParentId = lstWorkstation[0].Member_Engagement__c;
						post.Body = 'Action Plan has been generated for "' +objAccount.Name+ '" and executions can be done.'+
						 			 'Please go through the related Execution Trackers.';
						insert post;
					   	
			        }
			    }
			}
        	pageReference pageRef = new pageReference('/apex/ExecutionTracker?entityId='+beanObj.entityId+'&tabname=Financial Planning');
        	return pageRef ;
		}
		return null;
    }*/
}