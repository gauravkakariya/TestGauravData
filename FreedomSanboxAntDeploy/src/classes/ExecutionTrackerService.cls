/*
	Revision History:
	
    Version     Version Author     Date           Comments
    1.0			Aditi	   		25/12/12		 Execution Tracker Controller for displaying Read only AP.
    2.0			Prajakta         01/04/2013      Added Gold Growth Rate for the new record type Gold in Investment Asset	
*/

public class ExecutionTrackerService
{
    public double SIPtotal{get;set;}
    public double Lumpsumtotal{get;set;}
    public double SIPSummaryTotal{get;set;}
    public DatabaseSOQL dbSOQLObj {get; set;}
    public DatabaseDML dbDMLObj {get; set;}
    public String currentLump = Label.CurrentLumpSumRecordType;
    public String currentSIP = Label.CurrentSIPRecordType;
    public String suggestedLump = Label.SuggestedLumpSumRecordType;
    public String suggestedSIP = Label.SuggestedSIPRecordType;
    public String entityName{get;set;}
    
    private Map<Id,Investment_Asset__c> mapIdToInvestmentAssetGold = new Map<Id,Investment_Asset__c>();
    private Map<Id,Investment_Asset__c> mapIdToInvestmentAsset = new Map<Id,Investment_Asset__c>();
    private Integer newCount = 0; 
    private Integer newInsuranceCount = 0; 
    private Account objAccount {get;set;}
    private Map<Id,Remarks__c> entityRemarkMap{get;set;}
    
    private void setInfoMessage(String str){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,str));                                                                                                                               
    }
    
    Public ExecutionTrackerService(){
        dbSOQLObj = new DatabaseSOQL();
        dbDMLObj = new DatabaseDML();
    }
    
    //Created By : Aditi for new Action Plan
    public ApprovedPlanBean fetchGoalDetails(ApprovedPlanBean approvedPlanBean) 
 	{   
        List<Goal__c> goalList = dbSOQLObj.getAllGoals(approvedPlanBean.entityId);
        //Map<Id,Execution_Tracker__c> mapIdToExecutionTracker = new Map<Id,Execution_Tracker__c>();
        Map<Id,List<Execution_Tracker__c>> mapIdTolstExecutionTracker = new Map<Id,List<Execution_Tracker__c>>();
        Map<String,List<Approve_Action_Plan__c>> mapIdTolstActionPlan = new Map<String,List<Approve_Action_Plan__c>>();
        //Added on 24/12/2012 : for Retrieving Family member
		Set<Id> familyIdSet = new Set<Id>(); 
		List<Account> lstAcc = dbSOQLObj.getFamilyMembers(approvedPlanBean.entityId);
		
		for(Account objAcc : lstAcc)
			familyIdSet.add(objAcc.Id);
		List<Execution_Tracker__c> lstExecutionTracker = [select Id,isAssignedToOps__c,AssignToOps__c,Approve_Action_Plan__c,Type__c, Application_Status__c,isFormProvidedToMET__c,
															Agreed_Amount_Base_Amount__c,Balance_Remaining__c,Agreed_Amount__c,Executed_Amount__c,
															Total_Remaining_Balance__c,Suggested_Amount__c    
															from Execution_Tracker__c where Entity_Name__c IN: familyIdSet order by CreatedDate];
		 
		/*for(Execution_Tracker__c objET : lstExecutionTracker)
		{
			if(!mapIdToExecutionTracker.containsKey(objET.Approve_Action_Plan__c))
			{
				mapIdToExecutionTracker.put(objET.Approve_Action_Plan__c,objET);
			}
		}*/
		
		for(Execution_Tracker__c objET : lstExecutionTracker)
		{
			system.debug('***************objET****'+objET);
			
			if(!mapIdTolstExecutionTracker.containsKey(objET.Approve_Action_Plan__c))
			{
				List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
        		lstET.add(objET);
				mapIdTolstExecutionTracker.put(objET.Approve_Action_Plan__c,lstET);
			}
			else
			{
				mapIdTolstExecutionTracker.get(objET.Approve_Action_Plan__c).add(objET);
			}
		}
		
		List<Approve_Action_Plan__c> lstApproveActionPlan = [Select  Transaction_Type__c, Action_Amount__c, Insurance__c, Remarks__c, Scheme_Name__c, Goal__c , Asset_Class__c, 
	                                     isInsuranceExecutionTracker__c,Amount__c, Investment_Asset__c, isSIPexecutionTracker__c, isETcreated__c,Policy_Name__c ,
	                                     Fund__c, Lumpsum_Action__c,Amount_Per_Installment__c, SIP_Action__c, Product_Name__c, 
	                                   	 Account__c, Option__c,  isExecutionTracker__c ,Installments__c,  Account__r.FirstName, CreatedDate,Suggested_Cover__c, 
	                                   	 Account__r.LastName,Category__c,Insured__c, Policy_Type__c,Sum_Assured_Rs__c,Premium_Amount_Rs__c,Item_Type__c ,
	                                   	 Tenure_of_Insurance__c,InsuranceRemark__c,isNewLI__c,isAddOnExecutionTracker__c,Loan_Type__c,Company_Name__c,Company_Name__r.Name,
	                                   	 Goal_Type__c,Period_in_Months__c,Bond_Type__c,Investment_Asset__r.RecordType.Name,isNewGoldSilver__c, isGSsip_ExecutionTracker__c, isGSsipETCreated__c, 
										 isGS_ExecutionTracker__c, isGSETcreated__c, Id,GS_SIPRemark__c, Multiple_Products__c ,Goal__r.Goal_Type__c,
								       	 GS_LumpsumRemark__c, Asset_Type__c, Asset_Name__c,SIP_Action_Amount__c,Goal__r.Description__c,isLumpsumExecTracker__c ,
								       	 isMFsipETCreated__c,MF_SIPRemark__c,MF_LumpsumRemark__c,isNewMutualFund__c,Lumpsum_Equity__c ,Lumpsum_Debt__c,Lumpsum_Gold__c         
	                                   From Approve_Action_Plan__c
	                                   where  Account__c IN: familyIdSet and  (Item_Type__c = : 'General Insurance' 
	                                   or Item_Type__c = 'Life Insurance' or Item_Type__c = : Label.Surrender_Insurance or Item_Type__c =: 'Loan'
	                                   or Item_Type__c =:'Fixed Deposit' or Item_Type__c =:'Bond' or Item_Type__c =:'SIP' or Item_Type__c =:'Lumpsum' 
	                                   or Investment_Asset__c != null) 
	                                   and AP_Status__c = 'Opened' order by CreatedDate];
	                                   
		for(Approve_Action_Plan__c objAP : lstApproveActionPlan)
		{
			if(objAP.Investment_Asset__c == null)
			{
				if(!mapIdTolstActionPlan.containsKey(objAP.Item_Type__c))
				{
					List<Approve_Action_Plan__c> lstAP = new List<Approve_Action_Plan__c>();
	        		lstAP.add(objAP);
					mapIdTolstActionPlan.put(objAP.Item_Type__c,lstAP);
				}
				else
				{
					mapIdTolstActionPlan.get(objAP.Item_Type__c).add(objAP);
				}
			}
			else
			{
				if(objAP.Investment_Asset__r.RecordType.Name == 'Gold and Silver')
				{
					if(!mapIdTolstActionPlan.containsKey('Gold and Silver'))
					{
						List<Approve_Action_Plan__c> lstAP = new List<Approve_Action_Plan__c>();
		        		lstAP.add(objAP);
						mapIdTolstActionPlan.put('Gold and Silver',lstAP);
					}
					else
					{
						mapIdTolstActionPlan.get('Gold and Silver').add(objAP);
					}
				}
				else if (objAP.Investment_Asset__r.RecordType.Name == 'Mutual Fund')
				{
					if(!mapIdTolstActionPlan.containsKey('Mutual Fund'))
					{
						List<Approve_Action_Plan__c> lstAP = new List<Approve_Action_Plan__c>();
		        		lstAP.add(objAP);
						mapIdTolstActionPlan.put('Mutual Fund',lstAP);
					}
					else
					{
						mapIdTolstActionPlan.get('Mutual Fund').add(objAP);
					}
				}
			}
		}
		
        getCurrentMutualFunds(approvedPlanBean,familyIdSet,mapIdTolstExecutionTracker,mapIdTolstActionPlan);
        getCurrentGoldSilver(approvedPlanBean,familyIdSet,mapIdTolstExecutionTracker,mapIdTolstActionPlan);
        //Access goal values;
        getGoalAssetAllocation(approvedPlanBean, goalList,familyIdSet,mapIdTolstExecutionTracker);
        getLifeInsurances(approvedPlanBean,familyIdSet,mapIdTolstExecutionTracker,mapIdTolstActionPlan);
        getGeneralInsurances(approvedPlanBean,familyIdSet,mapIdTolstExecutionTracker,mapIdTolstActionPlan);
        getRecommendedInsurances(approvedPlanBean,familyIdSet,mapIdTolstExecutionTracker,mapIdTolstActionPlan);
        getLoanDetails(approvedPlanBean,familyIdSet,mapIdTolstExecutionTracker,mapIdTolstActionPlan);
        getFixedDepositDetails(approvedPlanBean,familyIdSet,mapIdTolstExecutionTracker,mapIdTolstActionPlan);
        getBondDetails(approvedPlanBean,familyIdSet,mapIdTolstExecutionTracker,mapIdTolstActionPlan);
        
        return approvedPlanBean;       
    }
    
     /**
    * @Description: Retrieve Loan Details of New Action Plan
    * param: ApprovedPlanBean,Family Members,ExecutionTracker Records 
    * return type: None 
    */  
    public void getLoanDetails(ApprovedPlanBean approvedPlanBean,Set<Id> familyIdSet,Map<Id,List<Execution_Tracker__c>> mapIdToExecutionTracker,
    									Map<String,List<Approve_Action_Plan__c>> mapIdTolstActionPlan)
    {
    	ApprovedPlanBean.Loan objLoan = new ApprovedPlanBean.Loan();
    	List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
    	List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
    	
    	String ETStatus = '';
    	String applicant = '';
    	String vendorName = '';
    	Long loanAmount = 0;
    	String loanAPid = '';
    	String loanType = '';
    	String AddOnExecutionTracker = '';
    	Boolean isAddOnExecTracker = false;
    	String strAssignedToOps = '';
    	if(mapIdTolstActionPlan.containsKey('Loan'))
	    {
	    	lstApproveActionPlan = mapIdTolstActionPlan.get('Loan');
	    }     
    	lstApproveActionPlan.sort();
    	for(Approve_Action_Plan__c objApproveActionPlan : lstApproveActionPlan )
     	{
     		ETStatus = Label.ET_NotCreated;
     		applicant = objApproveActionPlan.Insured__c; 
	        isAddOnExecTracker = objApproveActionPlan.isAddOnExecutionTracker__c;
	        vendorName = objApproveActionPlan.Product_Name__c;
	        AddOnExecutionTracker = isAddOnExecTracker ? 'Yes' : 'No';
           	loanType = objApproveActionPlan.Loan_Type__c;
           	if(objApproveActionPlan.Amount__c != null) 
       			loanAmount = objApproveActionPlan.Amount__c.round();
       		loanAPid = objApproveActionPlan.Id;
       		if(mapIdToExecutionTracker.containsKey(objApproveActionPlan.Id))
		  	{
				lstET = mapIdToExecutionTracker.get(objApproveActionPlan.Id);
				for(Execution_Tracker__c objET : lstET)
				{
					strAssignedToOps = objET.AssignToOps__c ? 'Yes' : 'No';
					if((objET.Executed_Amount__c == null || objET.Executed_Amount__c == 0 || objET.Executed_Amount__c > 0) && objET.Application_Status__c != 'Closed')
						ETStatus = Label.ET_NotExecuted;
					else if(objET.Executed_Amount__c != null && objET.Executed_Amount__c > 0 && objET.Application_Status__c == 'Closed')
						ETStatus = Label.ET_FullyExecuted;
						
					/*if(objET.Suggested_Amount__c == objET.Total_Remaining_Balance__c && objET.Application_Status__c != 'Closed')
						ETStatus = Label.ET_NotExecuted; 
				 	else if(objET.Suggested_Amount__c > objET.Total_Remaining_Balance__c  && objET.Application_Status__c != 'Closed')
				  	 	ETStatus = Label.ET_PartiallyExecuted;
			  		else if(objET.Total_Remaining_Balance__c == objET.Agreed_Amount__c && objET.Executed_Amount__c == objET.Agreed_Amount__c )
				  	 	ETStatus = Label.ET_FullyExecuted;*/			
				}
		  	}	
       		objLoan = approvedPlanBean.populateLoan(applicant,loanType,vendorName,loanAmount,isAddOnExecTracker,AddOnExecutionTracker,loanAPid,ETStatus,strAssignedToOps);
     	}
    }
     /**
    * Added on : 11/12/13
    * @Description: Retrieve Fixed Deposit Details of New Action Plan
    * param: ApprovedPlanBean,Family Members,ExecutionTracker Records 
    * return type: None 
    */ 
    public void getFixedDepositDetails(ApprovedPlanBean approvedPlanBean,Set<Id> familyIdSet,Map<Id,List<Execution_Tracker__c>> mapIdToExecutionTracker,
    									Map<String,List<Approve_Action_Plan__c>> mapIdTolstActionPlan)
    {
    	ApprovedPlanBean.FixedDeposit objFixedDeposit = new ApprovedPlanBean.FixedDeposit();
    	List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
    	List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
    	
    	String ETStatus = '';
    	Approve_Action_Plan__c actionPlanFDobj = new Approve_Action_Plan__c();
    	String AddOnExecutionTracker = '';
    	String strAssignedToOps = '';
    	String companyName = '';
    	if(mapIdTolstActionPlan.containsKey('Fixed Deposit'))
	    {
	    	lstApproveActionPlan = mapIdTolstActionPlan.get('Fixed Deposit');
	    }     
    	lstApproveActionPlan.sort();
    	for(Approve_Action_Plan__c objApproveActionPlan : lstApproveActionPlan )
     	{
     		actionPlanFDobj = new Approve_Action_Plan__c();
     		ETStatus = Label.ET_NotCreated;
     		actionPlanFDobj = objApproveActionPlan;
     		actionPlanFDobj.Insured__c =  objApproveActionPlan.Insured__c; 
     		actionPlanFDobj.isAddOnExecutionTracker__c = objApproveActionPlan.isAddOnExecutionTracker__c;
     		actionPlanFDobj.Product_Name__c = objApproveActionPlan.Product_Name__c;
     		actionPlanFDobj.Company_Name__c = objApproveActionPlan.Company_Name__c;
     		companyName = objApproveActionPlan.Company_Name__r.Name;
     		actionPlanFDobj.Goal_Type__c = objApproveActionPlan.Goal_Type__c;
     		AddOnExecutionTracker = actionPlanFDobj.isAddOnExecutionTracker__c ? 'Yes' : 'No';
           	if(objApproveActionPlan.Amount__c != null) 
       			actionPlanFDobj.Amount__c = objApproveActionPlan.Amount__c.round();
       		actionPlanFDobj.Period_in_Months__c = objApproveActionPlan.Period_in_Months__c;
       		if(mapIdToExecutionTracker.containsKey(objApproveActionPlan.Id))
		  	{ 
				lstET = mapIdToExecutionTracker.get(objApproveActionPlan.Id);
				for(Execution_Tracker__c objET : lstET)
				{
					strAssignedToOps = objET.AssignToOps__c ? 'Yes' : 'No';
					if((objET.Executed_Amount__c == null || objET.Executed_Amount__c == 0 || objET.Executed_Amount__c > 0) && objET.Application_Status__c != 'Closed')
						ETStatus = Label.ET_NotExecuted;
					else if(objET.Executed_Amount__c != null && objET.Executed_Amount__c > 0 && objET.Application_Status__c == 'Closed')
						ETStatus = Label.ET_FullyExecuted;
				} 
		  	}	
       		objFixedDeposit = approvedPlanBean.populateFixedDeposit(actionPlanFDobj,companyName,AddOnExecutionTracker,ETStatus, strAssignedToOps);
     	}
    }
     /**
    * Added on : 17/12/13
    * @Description: Retrieve Fixed Deposit Details of New Action Plan
    * param: ApprovedPlanBean,Family Members,ExecutionTracker Records 
    * return type: None 
    */ 
    public void getBondDetails(ApprovedPlanBean approvedPlanBean,Set<Id> familyIdSet,Map<Id,List<Execution_Tracker__c>> mapIdToExecutionTracker,
    									Map<String,List<Approve_Action_Plan__c>> mapIdTolstActionPlan)
    {
    	ApprovedPlanBean.Bond objBond = new ApprovedPlanBean.Bond();
    	List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
    	List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
    	
    	String ETStatus = '';
    	Approve_Action_Plan__c actionPlanBondObj = new Approve_Action_Plan__c();
    	String AddOnExecutionTracker = '';
	 	String strAssignedToOps = '';
    	String companyName = '';
    	
    	if(mapIdTolstActionPlan.containsKey('Bond'))
	    {
	    	lstApproveActionPlan = mapIdTolstActionPlan.get('Bond');
	    }     
    	lstApproveActionPlan.sort();
    	for(Approve_Action_Plan__c objApproveActionPlan : lstApproveActionPlan )
     	{
     		actionPlanBondObj = new Approve_Action_Plan__c();
     		ETStatus = Label.ET_NotCreated;
     		actionPlanBondObj= objApproveActionPlan;
     		actionPlanBondObj.Insured__c =  objApproveActionPlan.Insured__c; 
     		actionPlanBondObj.isAddOnExecutionTracker__c = objApproveActionPlan.isAddOnExecutionTracker__c;
     		actionPlanBondObj.Product_Name__c = objApproveActionPlan.Product_Name__c;
     		actionPlanBondObj.Company_Name__c = objApproveActionPlan.Company_Name__c;
     		actionPlanBondObj.Goal_Type__c = objApproveActionPlan.Goal_Type__c;
     		companyName = objApproveActionPlan.Company_Name__r.Name;
     		AddOnExecutionTracker = actionPlanBondObj.isAddOnExecutionTracker__c ? 'Yes' : 'No';
           	if(objApproveActionPlan.Amount__c != null) 
       			actionPlanBondObj.Amount__c = objApproveActionPlan.Amount__c.round();
       		actionPlanBondObj.Bond_Type__c = objApproveActionPlan.Bond_Type__c;
       		
       		if(mapIdToExecutionTracker.containsKey(objApproveActionPlan.Id))
		  	{
				lstET = mapIdToExecutionTracker.get(objApproveActionPlan.Id);
				for(Execution_Tracker__c objET : lstET)
				{
					strAssignedToOps = objET.AssignToOps__c ? 'Yes' : 'No';
					if((objET.Executed_Amount__c == null || objET.Executed_Amount__c == 0 || objET.Executed_Amount__c > 0) && objET.Application_Status__c != 'Closed')
						ETStatus = Label.ET_NotExecuted;
					else if(objET.Executed_Amount__c != null && objET.Executed_Amount__c > 0 && objET.Application_Status__c == 'Closed')
						ETStatus = Label.ET_FullyExecuted;
				} 
		  	}	
       		objBond = approvedPlanBean.populateBond(actionPlanBondObj,companyName,AddOnExecutionTracker,ETStatus, strAssignedToOps);
     	}
    }
    
    
    
    /**
    * @Description: Retrieve Execution Tracker Details of New Action Plan
    * param: ApprovedPlanBean 
    * return type: None 
    */ 
    public void getWillExecTrackerDetails(ApprovedPlanBean approvedPlanBean)
    {
    	if(approvedPlanBean == null) return;
    	
    	try{
    		for(Approve_Action_Plan__c objActionPlan : [Select Account__c, isWillExecTracker__c From Approve_Action_Plan__c 
															  where  Account__c =: approvedPlanBean.entityId and  isWill__c = : true ])
		 		approvedPlanBean.isWillExecutionTracker = objActionPlan.isWillExecTracker__c ? 'Yes' : 'No';
    	}catch(Exception Ex)
    	{
    		Error.LogError(''+Ex.getMessage());
    	}
    	 	
    }
    
     /**
    * @Description: Retrieve General Insurance Details of New Action Plan
    * param: ApprovedPlanBean 
    * return type: None  
    */ 
    public void getGeneralInsurances(ApprovedPlanBean approvedPlanBean,Set<Id> familyIdSet,Map<Id,List<Execution_Tracker__c>> mapIdToExecutionTracker,
    												Map<String,List<Approve_Action_Plan__c>> mapIdTolstActionPlan)
    {
    	if(approvedPlanBean == null || familyIdSet.isEmpty() || mapIdToExecutionTracker == null) return;
    	
    	ApprovedPlanBean.GeneralInsurance objGeneralInsurance = new ApprovedPlanBean.GeneralInsurance();
    	ApprovedPlanBean.GeneralInsurance objNewGeneralInsurance = new ApprovedPlanBean.GeneralInsurance();
    	List<Insurance__c> lstGeneralInsurance = dbSOQLObj.getAnalysisInsurances(InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c, approvedPlanBean.accList);
    	Map<Id,Insurance__c> MapIdToInsurance = new Map<Id,Insurance__c>();
    	Map<Id,Approve_Action_Plan__c> mapIdToApprovePlan = new Map<Id,Approve_Action_Plan__c>();
		Approve_Action_Plan__c objApprovePlan = new Approve_Action_Plan__c();
		List<Execution_Tracker__c> lstET = new  List<Execution_Tracker__c>();
		String insured = '';
		String policyName = '';
		String productName = '';
		Long premiumAmount = 0;
		String policyType = '';
		Long sumAssured = 0;
		boolean execTracker = false;
		String executionTracker = '';
		String actionPlanGeneralInsuranceID = '';
		Id insuranceId;
		String strAssignedToOps = '';
		//String strFormsProvided = '';
		String ETStatus = '';
    	for(Insurance__c objInsurance : lstGeneralInsurance)
    	{
    		if(!MapIdToInsurance.containsKey(objInsurance.Id))
    		{
    			MapIdToInsurance.put(objInsurance.Id,objInsurance);
    		}
    	}
    	
    	/*List<Approve_Action_Plan__c> lstApproveActionPlan = [Select  Transaction_Type__c, Action_Amount__c, Insurance__c, Remarks__c, Scheme_Name__c, Goal__c , Asset_Class__c, 
    																 isInsuranceExecutionTracker__c,Amount__c, Investment_Asset__c, isSIPexecutionTracker__c, 
    																 Fund__c, Lumpsum_Action__c,SIP_Action_Amount__c,Amount_Per_Installment__c, SIP_Action__c, Product_Name__c, 
																	 Account__c, Option__c,  isExecutionTracker__c ,Installments__c,  Account__r.FirstName, CreatedDate, 
																	 Account__r.LastName,Category__c,Insured__c, Policy_Type__c,Sum_Assured_Rs__c,Premium_Amount_Rs__c
																	 From Approve_Action_Plan__c
																	 where  Account__c =: familyIdSet and  Item_Type__c = : 'General Insurance'
																	 and AP_Status__c = 'Opened'];*/
		List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
		if(mapIdTolstActionPlan.containsKey('General Insurance'))
	    {
	    	lstApproveActionPlan = mapIdTolstActionPlan.get('General Insurance');
	    }  
			
		for(Approve_Action_Plan__c objApproveActionPlan : lstApproveActionPlan )
    	{
    	 	ETStatus = '';
    	 	if(objApproveActionPlan.Insurance__c == null)
    	 	{
    	 		execTracker = objApproveActionPlan.isInsuranceExecutionTracker__c;
				productName = objApproveActionPlan.Product_Name__c;
				system.debug('*****productName*********'+productName);
				executionTracker = execTracker ? 'Yes' : 'No';
    	 		insured = objApproveActionPlan.Insured__c; 
    	 		//policyName = '';
    	 		policyType = objApproveActionPlan.Policy_Type__c; 
    	 		if(objApproveActionPlan.Sum_Assured_Rs__c != null)
    	 			sumAssured = objApproveActionPlan.Sum_Assured_Rs__c.round();
    	 		if(objApproveActionPlan.Premium_Amount_Rs__c != null)	
    	 			premiumAmount = objApproveActionPlan.Premium_Amount_Rs__c.round();
    	 		actionPlanGeneralInsuranceID = objApproveActionPlan.Id;
	 		 	if(mapIdToExecutionTracker.containsKey(objApproveActionPlan.Id))
			  	{
					lstET = mapIdToExecutionTracker.get(objApproveActionPlan.Id);
					for(Execution_Tracker__c objET : lstET)
					{
						strAssignedToOps = objET.AssignToOps__c ? 'Yes' : 'No';
						if(objET.Suggested_Amount__c == objET.Total_Remaining_Balance__c && objET.Application_Status__c != 'Closed')
						  	ETStatus = Label.ET_NotExecuted; 
				 	  	else if(objET.Suggested_Amount__c > objET.Total_Remaining_Balance__c  && objET.Application_Status__c != 'Closed')
					  	  	ETStatus = Label.ET_PartiallyExecuted;
				  	  	else if(objET.Total_Remaining_Balance__c == objET.Agreed_Amount__c && objET.Executed_Amount__c == objET.Agreed_Amount__c )
					  	  	ETStatus = Label.ET_FullyExecuted;	
					  		
						//strFormsProvided = objET.isFormProvidedToMET__c ? 'Yes' : 'No';
					}
			  	} 
    	 		objNewGeneralInsurance = approvedPlanBean.populateNewGeneralInsurance( insured,  premiumAmount,  policyType,  sumAssured
    		 																	,  execTracker,  executionTracker , productName, actionPlanGeneralInsuranceID
    		 																	,strAssignedToOps,ETStatus);//,strFormsProvided);
    		 	system.debug('*****objNewGeneralInsurance*********'+objNewGeneralInsurance);
    	 	}
    		if(!mapIdToApprovePlan.containsKey(objApproveActionPlan.Insurance__c))
    		{
    			mapIdToApprovePlan.put(objApproveActionPlan.Insurance__c,objApproveActionPlan);
    		}
    		
    	 }
		 Insurance__c objInsurance = new Insurance__c();
    	 for(Id idInsurance : MapIdToInsurance.keySet())
    	 {
    	 		ETStatus = '';
    		    objInsurance = MapIdToInsurance.get(idInsurance);
    		    if(objInsurance.Entity__r.LastName == null)
          		{
          			insured = objInsurance.Entity__r.FirstName;
          		}
          		else if(objInsurance.Entity__r.FirstName == null )
          		{
          			insured = objInsurance.Entity__r.LastName;
          		}
          		else if(objInsurance.Entity__r.LastName != null && objInsurance.Entity__r.FirstName != null)
          		{
          			insured = objInsurance.Entity__r.FirstName +' '+ objInsurance.Entity__r.LastName;
          		}
          		else
          		{
          			insured = '';
          		}
			    policyName = objInsurance.Policy_Name__c;
			    if(objInsurance.Premium_Amount_Rs__c != null)
			    	premiumAmount = objInsurance.Premium_Amount_Rs__c.round();
			    policyType = objInsurance.Policy_Type__c;
			    if(objInsurance.Sum_Assured_Rs__c != null)
			    	sumAssured = objInsurance.Sum_Assured_Rs__c.round();
			    insuranceId = objInsurance.Id;
				if(mapIdToApprovePlan.containsKey(idInsurance))
	    		{
	    			  objApprovePlan = mapIdToApprovePlan.get(idInsurance);
	    			  if(mapIdToExecutionTracker.containsKey(objApprovePlan.Id))
				  	  {
    					  lstET = mapIdToExecutionTracker.get(objApprovePlan.Id);
    					  for(Execution_Tracker__c objET : lstET)
						  {
    					  	  strAssignedToOps = objET.AssignToOps__c ? 'Yes' : 'No';
    					  	  system.debug('*objET.Suggested_Amount__c'+objET.Suggested_Amount__c);
    					  	   system.debug('*objET.Total_Remaining_Balance__c'+objET.Total_Remaining_Balance__c);
    					  	  
    					  	  if(objET.Suggested_Amount__c == objET.Total_Remaining_Balance__c && objET.Application_Status__c != 'Closed')
								 ETStatus = Label.ET_NotExecuted; 
					 	  	  else if(objET.Suggested_Amount__c > objET.Total_Remaining_Balance__c  && objET.Application_Status__c != 'Closed')
							  	 ETStatus = Label.ET_PartiallyExecuted;
						  	  else if(objET.Total_Remaining_Balance__c == objET.Agreed_Amount__c && objET.Executed_Amount__c == objET.Agreed_Amount__c )
							  	 ETStatus = Label.ET_FullyExecuted;	
    					  	  //strFormsProvided = objET.isFormProvidedToMET__c ? 'Yes' : 'No';
						  }
				  	  }
					  execTracker = objApprovePlan.isInsuranceExecutionTracker__c;
					  productName = objApprovePlan.Product_Name__c;
					  if(objApprovePlan.Premium_Amount_Rs__c != null)
					  	premiumAmount = objApprovePlan.Premium_Amount_Rs__c.round();
					  actionPlanGeneralInsuranceID = objApprovePlan.Id;
					  system.debug('****actionPlanGeneralInsuranceID******'+actionPlanGeneralInsuranceID);
					  executionTracker = execTracker ? 'Yes' : 'No';
	    		}
	    		else
	    		{
					  execTracker = false;
					  executionTracker = 'No';
	    		}
	    		 objGeneralInsurance = approvedPlanBean.populateGeneralInsurance( insured,  policyName,  premiumAmount,  policyType,  sumAssured
	    		 																	,  execTracker,  executionTracker,  insuranceId, productName
	    		 																	,actionPlanGeneralInsuranceID,strAssignedToOps,ETStatus);//,strFormsProvided);
	    	 }
    	 
    	
    }
    
    /**
    * @Description: Retrieve Life Insurance Details of New Action Plan
    * param: ApprovedPlanBean 
    * return type: None 
    */ 
    public void getLifeInsurances(ApprovedPlanBean approvedPlanBean,Set<Id> familyIdSet,Map<Id,List<Execution_Tracker__c>> mapIdToExecutionTracker,
    									Map<String,List<Approve_Action_Plan__c>> mapIdTolstActionPlan)
    {
    	ApprovedPlanBean.LifeInsurance objLifeInsurance = new ApprovedPlanBean.LifeInsurance();
    	List<Insurance__c> lstInsurance = dbSOQLObj.getAnalysisInsurances(InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c, approvedPlanBean.accList);
    	Map<Id,Insurance__c> MapIdToInsurance = new Map<Id,Insurance__c>();
    	Map<Id,List<Approve_Action_Plan__c>> mapIdToApprovePlan = new Map<Id,List<Approve_Action_Plan__c>>();
    	List<Approve_Action_Plan__c> lstApprovePlan = new  List<Approve_Action_Plan__c>();
    	List<Execution_Tracker__c> lstET = new  List<Execution_Tracker__c>();
		//Approve_Action_Plan__c objApprovePlan = new Approve_Action_Plan__c();
		String insured = '';
		Long suggestedCover = 0;
		String strSuggestedCover = ''; //Praj
		String policyName = '';
		Long premiumAmount = 0;
		String policyType = '';
		double tenureOfInsurance = 0;
		boolean execTracker = false;
		String executionTracker = '';
		//Added on:22/02/2013 : Aditi Satpute : AP changes
		String insuranceRemark = '';
		//Added on:06/02/2013 : Aditi Satpute : AP changes
		Long sumAssured = 0;
		Id insuranceId;
		String actionPlanLifeInsuranceID = '';
		Boolean isNewLI = false;
		String strAssignedToOps = '';
		String ETStatus = '';
		//String strFormsProvided = '';
	    entityRemarkMap = new Map<Id,Remarks__c>();
    	for(Insurance__c objInsurance : lstInsurance)
    	{
    		if(!MapIdToInsurance.containsKey(objInsurance.Id))
    		{
    			MapIdToInsurance.put(objInsurance.Id,objInsurance);
    		}
    	}
    	//Added on:22/02/2013 : Aditi Satpute : AP changes : Life Insurance Remark
    	for(Remarks__c objRemark : [select Entity__c,Remark__c from Remarks__c where entity__c 
											IN : familyIdSet and recordtype.Name =: 'LifeInsurancePlanning'])
		{
			if(entityRemarkMap.get(objRemark.entity__c) == null)
				entityRemarkMap.put(objRemark.entity__c,objRemark);
		}
    	/*List<Approve_Action_Plan__c> lstApproveActionPlan = [Select  Transaction_Type__c, Action_Amount__c, Insurance__c,Remarks__c, Scheme_Name__c, Goal__c , InsuranceRemark__c,
    																 Asset_Class__c,  isInsuranceExecutionTracker__c,Amount__c, Investment_Asset__c, isSIPexecutionTracker__c,
																	 Fund__c, Lumpsum_Action__c,SIP_Action_Amount__c,Amount_Per_Installment__c, SIP_Action__c, Policy_Name__c,
																	 Product_Name__c,  Account__c, Option__c,  isExecutionTracker__c ,Installments__c,  Account__r.FirstName, 
																	 CreatedDate,  Account__r.LastName,Category__c, Sum_Assured_Rs__c,Premium_Amount_Rs__c, Tenure_of_Insurance__c,
																	 isNewLI__c,Suggested_Cover__c,Insured__c,Policy_Type__c From Approve_Action_Plan__c  
																	 where  Account__c =: familyIdSet and  Item_Type__c = : 'Life Insurance'
																	 and AP_Status__c = 'Opened' order by isNewLI__c];*/
																	 
		
		/* for(Approve_Action_Plan__c objApproveActionPlan : lstApproveActionPlan )
    	 {
    		if(!mapIdToApprovePlan.containsKey(objApproveActionPlan.Insurance__c))
    		{
    			mapIdToApprovePlan.put(objApproveActionPlan.Insurance__c,objApproveActionPlan);
    		}
    		
    	 }*/
    	 List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();             
       	 if(mapIdTolstActionPlan.containsKey('Life Insurance'))
	     {
	    	  lstApproveActionPlan = mapIdTolstActionPlan.get('Life Insurance');
	   	 } 
    	 lstApproveActionPlan.sort();
    	 for(Approve_Action_Plan__c objApproveActionPLan : lstApproveActionPlan )
         {
 			 ETStatus = '';	
         	 if(objApproveActionPlan.Insurance__c == null)
    	 	 {
	    		 lstET = new  List<Execution_Tracker__c>();
    			 if(mapIdToExecutionTracker.containsKey(objApproveActionPlan.Id))
    			 {
	    			 lstET = mapIdToExecutionTracker.get(objApproveActionPlan.Id);
	    			 for(Execution_Tracker__c objET : lstET)
	    			 {
	    			  	 strAssignedToOps = objET.AssignToOps__c ? 'Yes' : 'No';
	    				 if(objET.Suggested_Amount__c == objET.Total_Remaining_Balance__c && objET.Application_Status__c != 'Closed')
						   	 ETStatus = Label.ET_NotExecuted; 
						 else if(objET.Suggested_Amount__c > objET.Total_Remaining_Balance__c  && objET.Application_Status__c != 'Closed')
						   	 ETStatus = Label.ET_PartiallyExecuted;
						 else if(objET.Total_Remaining_Balance__c == objET.Agreed_Amount__c && objET.Executed_Amount__c == objET.Agreed_Amount__c )
							 ETStatus = Label.ET_FullyExecuted;
	    						//strFormsProvided = objET.isFormProvidedToMET__c ? 'Yes' : 'No';
	    			}
    			}
    			insured = objApproveActionPLan.Insured__c;
		    	
          		if(objApproveActionPlan.Suggested_Cover__c != null )
	    			suggestedCover = objApproveActionPlan.Suggested_Cover__c.round();
	    		
			    policyType = objApproveActionPlan.Policy_Type__c;
			    actionPlanLifeInsuranceID = objApproveActionPlan.Id;
				execTracker = objApproveActionPlan.isInsuranceExecutionTracker__c;
				policyName = objApproveActionPlan.Policy_Name__c;
				executionTracker = execTracker ? 'Yes' : 'No';
				if(objApproveActionPlan.Sum_Assured_Rs__c != null)
			 		sumAssured = objApproveActionPlan.Sum_Assured_Rs__c.round();
				if(objApproveActionPlan.Premium_Amount_Rs__c != null)
					premiumAmount = objApproveActionPlan.Premium_Amount_Rs__c.round();
				tenureOfInsurance = objApproveActionPlan.Tenure_of_Insurance__c;
				 
				objLifeInsurance = approvedPlanBean.populateLifeInsurance( insured,  suggestedCover, policyName,  premiumAmount,  policyType
																			, tenureOfInsurance,  execTracker,  executionTracker,  insuranceId
																			, sumAssured, actionPlanLifeInsuranceID,strAssignedToOps,ETStatus);//,strFormsProvided);
    	 	 }
         	
        	 if(mapIdToApprovePlan.get(objApproveActionPLan.Insurance__c) == null)
        	 {
        		 lstApproveActionPlan = new List<Approve_Action_Plan__c>();
        		 lstApproveActionPlan.add(objApproveActionPLan);
        		 mapIdToApprovePlan.put(objApproveActionPLan.Insurance__c, lstApproveActionPlan);
        	 }
        	 else
        	 {
        		 mapIdToApprovePlan.get(objApproveActionPLan.Insurance__c).add(objApproveActionPLan);
        	 }
         }
    	  Map<String,List<ApprovedPlanBean.LifeInsurance>> mapIdToInnerClass = new Map<String,List<ApprovedPlanBean.LifeInsurance>>();
     	
    	 Insurance__c objInsurance = new Insurance__c();
    	 Remarks__c objRemarks = new Remarks__c();
    	 for(Id idInsurance : MapIdToInsurance.keySet())
    	 {
    	 		List<ApprovedPlanBean.LifeInsurance> lstLifeInsurance = new List<ApprovedPlanBean.LifeInsurance>();
    		    objInsurance = MapIdToInsurance.get(idInsurance);
    		  	if(mapIdToApprovePlan.containsKey(idInsurance))
	    		{
	    			lstApprovePlan = mapIdToApprovePlan.get(idInsurance);
	    			system.debug('**lstApprovePlan*****'+lstApprovePlan);
	    			system.debug('**lstApprovePlan.size()*****'+lstApprovePlan.size());
	    			
	    			for(Approve_Action_Plan__c  objApprovePlan : lstApprovePlan)
	    			{
	    				ETStatus = '';	
	    				lstET = new  List<Execution_Tracker__c>();
    				  	if(mapIdToExecutionTracker.containsKey(objApprovePlan.Id))
    				  	{
	    					lstET = mapIdToExecutionTracker.get(objApprovePlan.Id);
	    					for(Execution_Tracker__c objET : lstET)
	    					{
	    						strAssignedToOps = objET.AssignToOps__c ? 'Yes' : 'No';
	    						if(objET.Suggested_Amount__c == objET.Total_Remaining_Balance__c && objET.Application_Status__c != 'Closed')
								  	ETStatus = Label.ET_NotExecuted; 
						 	  	else if(objET.Suggested_Amount__c > objET.Total_Remaining_Balance__c  && objET.Application_Status__c != 'Closed')
							  	  	ETStatus = Label.ET_PartiallyExecuted;
						  	  	else if(objET.Total_Remaining_Balance__c == objET.Agreed_Amount__c && objET.Executed_Amount__c == objET.Agreed_Amount__c )
							  	  	ETStatus = Label.ET_FullyExecuted;
	    						//strFormsProvided = objET.isFormProvidedToMET__c ? 'Yes' : 'No';
	    					}
    				  	}
		    		    if(objInsurance.Entity__r.LastName == null)
		          		{
		          			insured = objInsurance.Entity__r.FirstName;
		          		}
		          		else if(objInsurance.Entity__r.FirstName == null )
		          		{
		          			insured = objInsurance.Entity__r.LastName;
		          		}
		          		else if(objInsurance.Entity__r.LastName != null && objInsurance.Entity__r.FirstName != null)
		          		{
		          			insured = objInsurance.Entity__r.FirstName +' '+ objInsurance.Entity__r.LastName;
		          		}
		          		else
		          		{
		          			insured = '';
		          		}
		          		if(objApprovePlan.Suggested_Cover__c != null )
			    			suggestedCover = objApprovePlan.Suggested_Cover__c.round();
			    		//Praj
			    		if(suggestedCover != null && suggestedCover != 0)
                     		strSuggestedCover = suggestedCover.format();
					    //Commented on:18/02/2013 : Aditi Satpute : AP changes
					    //premiumAmount = objInsurance.Premium_Amount_Rs__c;
					    policyType = objInsurance.Policy_Type__c;
					    actionPlanLifeInsuranceID = objApprovePlan.Id;
					    //Commented on:18/02/2013 : Aditi Satpute : AP changes
					    //tenureOfInsurance = objInsurance.Tenure_of_Insurance__c;
					    insuranceId = objInsurance.Id;
				
		    			//objApprovePlan = mapIdToApprovePlan.get(idInsurance);
						execTracker = objApprovePlan.isInsuranceExecutionTracker__c;
						policyName = objApprovePlan.Policy_Name__c;
						executionTracker = execTracker ? 'Yes' : 'No';
						//Added on:06/02/2013 : Aditi Satpute : AP changes
						if(objApprovePlan.Sum_Assured_Rs__c != null)
					 		sumAssured = objApprovePlan.Sum_Assured_Rs__c.round();
						//Added on:18/02/2013 : Aditi Satpute : AP changes
						if(objApprovePlan.Premium_Amount_Rs__c != null)
							//premiumAmount = Math.log(objApprovePlan.Premium_Amount_Rs__c);//.round();
							premiumAmount = objApprovePlan.Premium_Amount_Rs__c.round();
						tenureOfInsurance = objApprovePlan.Tenure_of_Insurance__c;
						insuranceRemark = objApprovePlan.InsuranceRemark__c;
						isNewLI = objApprovePlan.isNewLI__c;
						 
						objLifeInsurance = approvedPlanBean.populateLifeInsurance( insured,  suggestedCover, strSuggestedCover //Praj
																			, policyName,  premiumAmount,  policyType
																			, tenureOfInsurance,  execTracker,  executionTracker,  insuranceId
																			, sumAssured, actionPlanLifeInsuranceID, insuranceRemark,isNewLI, --newInsuranceCount
																			,strAssignedToOps,ETStatus);//,strFormsProvided);
	    	 	 		lstLifeInsurance.add(objLifeInsurance);
	    			}
					 
	    		}
	    		else
	    		{
	    			if(objInsurance.Entity__r.LastName == null)
	          		{
	          			insured = objInsurance.Entity__r.FirstName;
	          		}
	          		else if(objInsurance.Entity__r.FirstName == null )
	          		{
	          			insured = objInsurance.Entity__r.LastName;
	          		}
	          		else if(objInsurance.Entity__r.LastName != null && objInsurance.Entity__r.FirstName != null)
	          		{
	          			insured = objInsurance.Entity__r.FirstName +' '+ objInsurance.Entity__r.LastName;
	          		}
	          		else
	          		{
	          			insured = '';
	          		}
	          		if(objInsurance.Suggested_Cover_General_Insurance__c != null)
				    	suggestedCover = objInsurance.Suggested_Cover_General_Insurance__c.round();
				    //Praj
				    if(suggestedCover != null ||  suggestedCover != 0)
              			strSuggestedCover = suggestedCover.format();
				    //Commented on:18/02/2013 : Aditi Satpute : AP changes
				    //premiumAmount = objInsurance.Premium_Amount_Rs__c;
				    policyType = objInsurance.Policy_Type__c;
			        insuranceId = objInsurance.Id;
					execTracker = false;
				  	executionTracker = 'No';
				  	policyName = '';
				  	sumAssured = 0;
				  	//Added on:18/02/2013 : Aditi Satpute : AP changes
				  	if(objInsurance.Premium_Amount_Rs__c != null)
				  		//premiumAmount = Math.log(objInsurance.Premium_Amount_Rs__c);//.round();
				  		premiumAmount = objInsurance.Premium_Amount_Rs__c.round();
				  	//Added on:18/02/2013 : Aditi Satpute : AP changes
				  	if(objInsurance.Tenure_of_Insurance__c != null)
				  		tenureOfInsurance = objInsurance.Tenure_of_Insurance__c;
			  	  	if(entityRemarkMap.containsKey(objInsurance.Entity__c))
    		      	{
    		    	 	objRemarks = entityRemarkMap.get(objInsurance.Entity__c);
		    	   	 	insuranceRemark = objRemarks.Remark__c;
		    	   	 	system.debug('**********insuranceRemark***in if******'+insuranceRemark);
    		      	} 
    			 
		 		  	objLifeInsurance = approvedPlanBean.populateLifeInsurance( insured,  suggestedCover, strSuggestedCover //Praj
		 		  														, policyName,  premiumAmount,  policyType
																		, tenureOfInsurance,  execTracker,  executionTracker,  insuranceId
																		, sumAssured, null,insuranceRemark,false,0,'No','');//,'No');
    	 	 	  	lstLifeInsurance.add(objLifeInsurance);
	    		}
	    	 	if(!mapIdToInnerClass.containsKey(insuranceId))
		    	{
	    			mapIdToInnerClass.put(insuranceId,lstLifeInsurance);
		    	}
		    	approvedPlanBean.mapIdToLifeInsuranceInnerClass = mapIdToInnerClass;
	    	 }
    	 
    	
    }
    
     /*/*--------------------------------------------------------------Prajakta - 16-7-2013-----------------------------------------------------
    * @Description: Retrieve the Current Mutual Funds of New Action Plan
    * param: ApprovedPlanBean 
    * return type: None 
    */ 
    public void getCurrentGoldSilver(ApprovedPlanBean approvedPlanBean,Set<Id> familyIdSet,Map<Id,List<Execution_Tracker__c>> mapIdToExecutionTracker,
    										Map<String,List<Approve_Action_Plan__c>> mapIdTolstActionPlan)
    { 
    	 Map<Id,List<Approve_Action_Plan__c>> mapIdToApprovePlan = new Map<Id,List<Approve_Action_Plan__c>>();
    	 Investment_Asset__c objInvestmentAsset = new Investment_Asset__c();
    	 List<Approve_Action_Plan__c> lstApprovePlan = new  List<Approve_Action_Plan__c>();
    	 List<Approve_Action_Plan__c> upsertList = new List<Approve_Action_Plan__c>();
    	 ApprovedPlanBean.CurrentGoldSilver objCurrentGoldSilver = new ApprovedPlanBean.CurrentGoldSilver();
       	 ApprovedPlanBean.CurrentGoldSilver objCurrentGoldSilverSIP = new ApprovedPlanBean.CurrentGoldSilver();
     	 
     	 //mapIdToInnerClass map returns the InvestmentID vs list of CurrentGoldSilver inner class to store splitting of individual records together with same ID 
         Map<Id,List<ApprovedPlanBean.CurrentGoldSilver>> mapIdToInnerClassGS = new Map<Id,List<ApprovedPlanBean.CurrentGoldSilver>>();
     	 
    	 double actionAmount = 0;
		 double amount = 0;
		 String assetClass = '';
		 String lumpsumAction = '';
		 String account = '';
		 String owner = '';
		 String schemeName = '';
		 boolean execTracker = false;
		 boolean SIPexecTracker = false;
		 String executionTracker = '';
		 String SIPexecutionTracker = '';
		 double currentSIP = 0;
		 String SIPaction = '';
		 double SIPactionAmount;
		 Id investmentId ;
		 String strSIPAssignedToOps = '';
		 String strLumpsumAssignedToOps = '';
		 String strLumpsumFormsPrivided = '';
		 String strSIPFormsPrivided = '';
		 String ETLumupsumStatus = '';
	  	 String ETSipStatus = '';
	  	 Boolean isNewGoldSilver = false;
		 //Execution_Tracker__c obj = new Execution_Tracker__c();
		 List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
		 //Added on:18/02/2013 : Aditi Satpute : AP changes
		 //String mfLumpsumRemark = '';
		 //String mfSIPRemark = '';
		 	
		 //mapIdToInvestmentAssetGold map returns all records from Investment Assets which are mutual fund 
       	mapIdToInvestmentAssetGold = new  Map<Id,Investment_Asset__c>
                                  ([Select Monthly_SIP_Amount__c, Entity__c, Asset_Type__c, 
											Entity__r.FirstName, Entity__r.LastName, Asset_Name__c, TotalAsset__c ,
											RecordType.Name, Allocated_Amount__c,  Action__c 
									From Investment_Asset__c  
									where  Entity__c =: familyIdSet
									and  RecordType.Name = 'Gold and Silver']);
                                      
       	//lstApproveActionPlan list returns all the records for current Gold and Silver
       	/*List<Approve_Action_Plan__c> lstApproveActionPlan = 
       								[Select isNewGoldSilver__c, isGSsip_ExecutionTracker__c, isGSsipETCreated__c, 
											isGS_ExecutionTracker__c, isGSETcreated__c, Id, Goal__c,GS_SIPRemark__c, 
									       	GS_LumpsumRemark__c, Amount__c, Asset_Type__c, Action_Amount__c, Asset_Name__c, 
									       	Account__c, AP_Status__c ,  Account__r.FirstName,  Account__r.LastName,
									       	SIP_Action_Amount__c,Investment_Asset__c,Lumpsum_Action__c, SIP_Action__c  
                                 	From Approve_Action_Plan__c 
                                    where  Account__c =: familyIdSet
                                    and  Investment_Asset__c != null and AP_Status__c = 'Opened' order by isNewGoldSilver__c]; */
         List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();             
       	 if(mapIdTolstActionPlan.containsKey('Gold and Silver'))
	   	 {
	    	 lstApproveActionPlan = mapIdTolstActionPlan.get('Gold and Silver');
	   	 }                            
         lstApproveActionPlan.sort();                           
    	 for(Approve_Action_Plan__c objApproveActionPLan : lstApproveActionPlan )
         {
        	if(mapIdToApprovePlan.get(objApproveActionPLan.Investment_Asset__c) == null)
        	{
        		lstApproveActionPlan = new List<Approve_Action_Plan__c>();
        		lstApproveActionPlan.add(objApproveActionPLan);
        		mapIdToApprovePlan.put(objApproveActionPLan.Investment_Asset__c, lstApproveActionPlan);
        	}
        	else
        	{
        		mapIdToApprovePlan.get(objApproveActionPLan.Investment_Asset__c).add(objApproveActionPLan);
        	}
         }
    	  
    	 
    	 for(Id idInvestment : mapIdToInvestmentAssetGold.keySet())
    	 {
    	 	ETLumupsumStatus = '';
 		    ETSipStatus = '';
    	 	List<ApprovedPlanBean.CurrentGoldSilver> lstCurrentGoldSilver = new List<ApprovedPlanBean.CurrentGoldSilver>();
    		objInvestmentAsset = mapIdToInvestmentAssetGold.get(idInvestment);
    		System.debug('----------------------mapIdToApprovePlan.containsKey(idInvestment)--------------------'+mapIdToApprovePlan.containsKey(idInvestment));
    		if(mapIdToApprovePlan.containsKey(idInvestment))
    		{
    			lstApprovePlan = mapIdToApprovePlan.get(idInvestment);
    			for(Approve_Action_Plan__c objApprovePlan : lstApprovePlan)
    			{
    				lstET = new List<Execution_Tracker__c>();
    				strSIPAssignedToOps = '';
		 		    strLumpsumAssignedToOps = '';
		 		    strLumpsumFormsPrivided = '';
		 		    strSIPFormsPrivided = '';
		 		    ETLumupsumStatus = '';
		 		    ETSipStatus = '';
	    			actionAmount = objApprovePlan.Action_Amount__c;
	    			SIPactionAmount = objApprovePlan.SIP_Action_Amount__c;
	    			lumpsumAction = objApprovePlan.Lumpsum_Action__c;
	    			amount = objApprovePlan.Amount__c;
	    			assetClass = objInvestmentAsset.Asset_Type__c;
	    			if(objApprovePlan.Account__r.LastName == null)
	          		{
	          			owner = objApprovePlan.Account__r.FirstName;
	          		}
	          		else if(objApprovePlan.Account__r.FirstName == null )
	          		{
	          			owner = objApprovePlan.Account__r.LastName;
	          		}
	          		else if(objApprovePlan.Account__r.LastName != null && objApprovePlan.Account__r.FirstName != null)
	          		{
	          			owner = objApprovePlan.Account__r.FirstName +' '+ objApprovePlan.Account__r.LastName;
	          		}
	          		else
	          		{
	          			owner = '';
	          		}
	    			account = objApprovePlan.Account__c;
	    			schemeName = objInvestmentAsset.Asset_Name__c;
	    			execTracker = objApprovePlan.isGS_ExecutionTracker__c;
	    			SIPexecTracker = objApprovePlan.isGSsip_ExecutionTracker__c;
	    			currentSIP = objInvestmentAsset.Monthly_SIP_Amount__c;
	    			SIPaction = objApprovePlan.SIP_Action__c;
	    			isNewGoldSilver = objApprovePlan.isNewGoldSilver__c;
	    			executionTracker = execTracker ? 'Yes' : 'No';
	    			SIPexecutionTracker = SIPexecTracker ? 'Yes' : 'No';
	    			investmentId = idInvestment;
	    			//Added on:18/02/2013 : Aditi Satpute : AP changes
	    			//mfLumpsumRemark = objApprovePlan.MF_LumpsumRemark__c;
	    			//mfSIPRemark = objApprovePlan.MF_SIPRemark__c;
	    			if(objApprovePlan.isGS_ExecutionTracker__c == true || (objApprovePlan.isGSsip_ExecutionTracker__c && objApprovePlan.Investment_Asset__c != null))
	    			{
	    				system.debug('*isGS_ExecutionTracker__c*********'+objApprovePlan.isGS_ExecutionTracker__c);
	    				system.debug('*Investment_Asset__c*********'+objApprovePlan.Investment_Asset__c);
	    				
	    				if(mapIdToExecutionTracker.containsKey(objApprovePlan.Id))
	    					lstET = mapIdToExecutionTracker.get(objApprovePlan.Id);
	    					system.debug('*********lstET*********'+lstET);
	    				if(lstET.size() > 0)
	    				{
		    				//Ta assign last records assignToOps Status
			    			for(Execution_Tracker__c obj : lstET)
			    			{
			    				if(obj.Type__c != null && obj.Type__c.equalsIgnoreCase('Lumpsum'))
				    			{
				    				strLumpsumAssignedToOps = obj.AssignToOps__c ? 'Yes' : 'No';
				    				system.debug('******obj.Application_Status__c********'+obj.Application_Status__c);
				    				//if(obj.Application_Status__c != null)
				    				 // strLumpsumFormsPrivided = obj.Application_Status__c != null ? (obj.Application_Status__c.equalsIgnoreCase(Label.Forms_Provided) ? 'Yes' : 'No') : 'No';
				    				 strLumpsumFormsPrivided = obj.isFormProvidedToMET__c ? 'Yes' : 'No';
				    				 if(obj.Suggested_Amount__c == obj.Total_Remaining_Balance__c && obj.Application_Status__c != 'Closed')
										ETLumupsumStatus = Label.ET_NotExecuted; 
									 else if(obj.Suggested_Amount__c > obj.Total_Remaining_Balance__c && obj.Application_Status__c != 'Closed')
								  	 	ETLumupsumStatus = Label.ET_PartiallyExecuted;
								  	 else if(obj.Total_Remaining_Balance__c == obj.Agreed_Amount__c && obj.Executed_Amount__c == obj.Agreed_Amount__c )
								  	 	ETLumupsumStatus = Label.ET_FullyExecuted;
				    				  
				    			}
				    			else if(obj.Type__c != null && obj.Type__c.equalsIgnoreCase('SIP'))
				    			{
				    				strSIPAssignedToOps = obj.AssignToOps__c ? 'Yes' : 'No';
				    				strSIPFormsPrivided = obj.isFormProvidedToMET__c ? 'Yes' : 'No';
				    				 if(obj.Suggested_Amount__c == obj.Total_Remaining_Balance__c && obj.Application_Status__c != 'Closed')
										ETSipStatus = Label.ET_NotExecuted; 
									 else if(obj.Suggested_Amount__c > obj.Total_Remaining_Balance__c && obj.Application_Status__c != 'Closed')
								  	 	ETSipStatus = Label.ET_PartiallyExecuted;
								  	 else if(obj.Total_Remaining_Balance__c == obj.Agreed_Amount__c && obj.Executed_Amount__c == obj.Agreed_Amount__c )
								  	 	ETSipStatus = Label.ET_FullyExecuted;
				    			}
			    			}
	    				}
	    				else
	    				{
	    					ETLumupsumStatus = ''; 
	    				}	
	    			}
	    			
	    			
	    			system.debug('*********ETLumupsumStatus*********'+ETLumupsumStatus);
	    			system.debug('*********ETSipStatus*********'+ETSipStatus);
	    			system.debug('*********lumpsumAction*********'+lumpsumAction);
	    			objCurrentGoldSilver = approvedPlanBean.populateCurrentGoldSilver
	    													(schemeName, assetClass, 
	    													 amount,owner, account, 
	    													 lumpsumAction, actionAmount,
	    													 execTracker,investmentId,
	    													 executionTracker,isNewGoldSilver, --newCount, objApprovePlan.Id,
	    													 strLumpsumAssignedToOps,strLumpsumFormsPrivided,ETLumupsumStatus);//, mfLumpsumRemark);
	    			
	    							 
	    			if(currentSIP != null && !isNewGoldSilver  && currentSIP > 0)
	    				objCurrentGoldSilverSIP = approvedPlanBean.populateSIPCurrentGoldSilver
	    													(schemeName, assetClass,
	    													 amount,owner, account,
	    													 lumpsumAction, actionAmount, SIPactionAmount,
	    													 execTracker,SIPexecTracker,investmentId,
	    													 executionTracker,SIPexecutionTracker,currentSIP,
	    													 SIPaction, isNewGoldSilver,objApprovePlan.Id,strSIPAssignedToOps,strSIPFormsPrivided,ETSipStatus);//, mfSIPRemark);
	    													 
	    			lstCurrentGoldSilver.add(objCurrentGoldSilver);						
    			}
    		}
    		else
    		{
    			actionAmount = 0;
    			lumpsumAction = 'Hold - Change of broker';
    			amount = objInvestmentAsset.TotalAsset__c;
    			assetClass = objInvestmentAsset.Asset_Type__c;
    			account = objInvestmentAsset.Entity__c;
    			if(objInvestmentAsset.Entity__r.LastName == null)
          		{
          			owner = objInvestmentAsset.Entity__r.FirstName;
          		}
          		else if(objInvestmentAsset.Entity__r.FirstName == null )
          		{
          			owner = objInvestmentAsset.Entity__r.LastName;
          		}
          		else if(objInvestmentAsset.Entity__r.LastName != null && objInvestmentAsset.Entity__r.FirstName != null)
          		{
          			owner = objInvestmentAsset.Entity__r.FirstName +' '+ objInvestmentAsset.Entity__r.LastName;
          		}
          		else
          		{
          			owner = '';
          		} 
    			schemeName = objInvestmentAsset.Asset_Name__c;
    			SIPactionAmount = 0;
    			currentSIP = objInvestmentAsset.Monthly_SIP_Amount__c;
    			SIPaction = 'Continue';
    			execTracker = false;
    			executionTracker = 'No';
    			SIPexecTracker = false;
    			SIPexecutionTracker = 'No';
    			investmentId = idInvestment;
    			objCurrentGoldSilver = approvedPlanBean.populateCurrentGoldSilver
    													(schemeName, assetClass, 
    													 amount,owner, account, 
    													 lumpsumAction, actionAmount,
    													 execTracker,investmentId,
    													 executionTracker,false, 0, '','No','No','');
    													 
    			if(currentSIP != null  && !isNewGoldSilver  && currentSIP > 0)
    				objCurrentGoldSilverSIP = approvedPlanBean.populateSIPCurrentGoldSilver
    													(schemeName, assetClass,
    													 amount,owner, account,
    													 lumpsumAction, actionAmount, SIPactionAmount,
    													 execTracker,SIPexecTracker,investmentId,
    													 executionTracker,SIPexecutionTracker,currentSIP,
    													 SIPaction,false, '','No','No','');
    			
    			lstCurrentGoldSilver.add(objCurrentGoldSilver);
    		}
    		
    		if(!mapIdToInnerClassGS.containsKey(idInvestment))
    		{
    			mapIdToInnerClassGS.put(idInvestment,lstCurrentGoldSilver);
    		}
    		
    		approvedPlanBean.mapIdToCurrentGold = mapIdToInnerClassGS ;
    	 }
    	
    }
    
    /*--------------------------------------------------------End------Prajakta - 16-7-2013-----------------------------------------------------*/
    
    
    /**
    * @Description: Retrieve the Current Mutual Funds of New Action Plan
    * param: ApprovedPlanBean 
    * return type: None 
    */ 
    public void getCurrentMutualFunds(ApprovedPlanBean approvedPlanBean,Set<Id> familyIdSet,Map<Id,List<Execution_Tracker__c>> mapIdToExecutionTracker,
    									Map<String,List<Approve_Action_Plan__c>> mapIdTolstActionPlan)
    { 
    	 Map<Id,List<Approve_Action_Plan__c>> mapIdToApprovePlan = new Map<Id,List<Approve_Action_Plan__c>>();
    	 Investment_Asset__c objInvestmentAsset = new Investment_Asset__c();
    	 List<Approve_Action_Plan__c> lstApprovePlan = new  List<Approve_Action_Plan__c>();
    	 List<Approve_Action_Plan__c> upsertList = new List<Approve_Action_Plan__c>();
    	 ApprovedPlanBean.CurrentMutualFunds objCurrentMutualFunds = new ApprovedPlanBean.CurrentMutualFunds();
    	 ApprovedPlanBean.CurrentMutualFunds objCurrentMutualFundsRunningSIP = new ApprovedPlanBean.CurrentMutualFunds();
     	 
     	 //mapIdToInnerClass map returns the InvestmentID vs list of CurrentMutualFunds inner class to store splitting of individual records together with same ID 
     	 Map<Id,List<ApprovedPlanBean.CurrentMutualFunds>> mapIdToInnerClass = new Map<Id,List<ApprovedPlanBean.CurrentMutualFunds>>();
     	 
    	 double actionAmount = 0;
		 double amount = 0;
		 String assetClass = '';
		 String lumpsumAction = '';
		 String account = '';
		 String owner = '';
		 String schemeName = '';
		 boolean execTracker = false;
		 boolean SIPexecTracker = false;
		 String executionTracker = '';
		 String SIPexecutionTracker = '';
		 double currentSIP = 0;
		 String SIPaction = '';
		 double SIPactionAmount;
		 Id investmentId ;
		 Boolean isNewMutualFund = false;
		 String strSIPAssignedToOps = '';
		 String strLumpsumAssignedToOps = '';
		 String strLumpsumFormsPrivided = '';
		 String strSIPFormsPrivided = '';
		 String ETLumupsumStatus = '';
	  	 String ETSipStatus = '';
		 //Execution_Tracker__c obj = new Execution_Tracker__c();
		 List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
		 //Added on:18/02/2013 : Aditi Satpute : AP changes
		 //String mfLumpsumRemark = '';
		 //String mfSIPRemark = '';
		 	
		 //mapIdToInvestmentAsset map returns all records from Investment Assets which are mutual fund 
    	 mapIdToInvestmentAsset = new  Map<Id,Investment_Asset__c>
    	 													 ([Select  Entity__c, Entity__r.FirstName, Entity__r.LastName, Scheme_Name_Text__c , TotalAsset__c ,
								         					   RecordType.Name,  Asset_Type__c,  Allocated_Amount__c,  Action__c , Monthly_SIP_Amount__c 
								         					   From Investment_Asset__c  
								         					   where  Entity__c =: familyIdSet //Added on 30/11/2012
								         					   and  RecordType.Name = 'Mutual Fund' ]);
								         					   
    	 //lstApproveActionPlan list returns all the records for current mutual funds  
    	 /*List<Approve_Action_Plan__c> lstApproveActionPlan = [Select Transaction_Type__c,Action_Amount__c,Remarks__c,Scheme_Name__c, Goal__c , Asset_Class__c,
															  Amount__c, Investment_Asset__c, isSIPexecutionTracker__c,Fund__c, Lumpsum_Action__c,SIP_Action_Amount__c,
															  Amount_Per_Installment__c, SIP_Action__c, Product_Name__c,  Account__c, Option__c,  isExecutionTracker__c, 
															  isNewMutualFund__c,Installments__c,  Account__r.FirstName,CreatedDate,  Account__r.LastName,Category__c,
															  MF_LumpsumRemark__c, MF_SIPRemark__c From Approve_Action_Plan__c 
														//	  where  Account__c =: approvedPlanBean.entityId and  Investment_Asset__c != null];
    	 													  where  Account__c =: familyIdSet //Added on 30/11/2012 
    	 													  and  Investment_Asset__c != null and AP_Status__c = 'Opened'  order by isNewMutualFund__c]; */
    	 List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();             
   		 if(mapIdTolstActionPlan.containsKey('Mutual Fund'))
	   	 {
	    	 lstApproveActionPlan = mapIdTolstActionPlan.get('Mutual Fund');
	   	 } 
    	 lstApproveActionPlan.sort();
    	 for(Approve_Action_Plan__c objApproveActionPLan : lstApproveActionPlan )
         {
        	if(mapIdToApprovePlan.get(objApproveActionPLan.Investment_Asset__c) == null)
        	{
        		lstApproveActionPlan = new List<Approve_Action_Plan__c>();
        		lstApproveActionPlan.add(objApproveActionPLan);
        		mapIdToApprovePlan.put(objApproveActionPLan.Investment_Asset__c, lstApproveActionPlan);
        	}
        	else
        	{
        		mapIdToApprovePlan.get(objApproveActionPLan.Investment_Asset__c).add(objApproveActionPLan);
        	}
         }
    	  
    	 
    	 for(Id idInvestment : mapIdToInvestmentAsset.keySet())
    	 {
    	 	ETLumupsumStatus = '';
 		    ETSipStatus = '';
    	 	List<ApprovedPlanBean.CurrentMutualFunds> lstCurrentMutualFunds = new List<ApprovedPlanBean.CurrentMutualFunds>();
    		objInvestmentAsset = mapIdToInvestmentAsset.get(idInvestment);
    		System.debug('----------------------mapIdToApprovePlan.containsKey(idInvestment)--------------------'+mapIdToApprovePlan.containsKey(idInvestment));
    		if(mapIdToApprovePlan.containsKey(idInvestment))
    		{
    			lstApprovePlan = mapIdToApprovePlan.get(idInvestment);
    			for(Approve_Action_Plan__c objApprovePlan : lstApprovePlan)
    			{
    				lstET = new List<Execution_Tracker__c>();
    				strSIPAssignedToOps = '';
		 		    strLumpsumAssignedToOps = '';
		 		    strLumpsumFormsPrivided = '';
		 		    strSIPFormsPrivided = '';
		 		    ETLumupsumStatus = '';
		 		    ETSipStatus = '';
	    			actionAmount = objApprovePlan.Action_Amount__c;
	    			SIPactionAmount = objApprovePlan.SIP_Action_Amount__c;
	    			lumpsumAction = objApprovePlan.Lumpsum_Action__c;
	    			amount = objApprovePlan.Amount__c;
	    			assetClass = objInvestmentAsset.Asset_Type__c;
	    			if(objApprovePlan.Account__r.LastName == null)
	          		{
	          			owner = objApprovePlan.Account__r.FirstName;
	          		}
	          		else if(objApprovePlan.Account__r.FirstName == null )
	          		{
	          			owner = objApprovePlan.Account__r.LastName;
	          		}
	          		else if(objApprovePlan.Account__r.LastName != null && objApprovePlan.Account__r.FirstName != null)
	          		{
	          			owner = objApprovePlan.Account__r.FirstName +' '+ objApprovePlan.Account__r.LastName;
	          		}
	          		else
	          		{
	          			owner = '';
	          		}
	    			account = objApprovePlan.Account__c;
	    			schemeName = objInvestmentAsset.Scheme_Name_Text__c;
	    			execTracker = objApprovePlan.isExecutionTracker__c;
	    			SIPexecTracker = objApprovePlan.isSIPexecutionTracker__c;
	    			currentSIP = objInvestmentAsset.Monthly_SIP_Amount__c;
	    			SIPaction = objApprovePlan.SIP_Action__c;
	    			isNewMutualFund = objApprovePlan.isNewMutualFund__c;
	    			executionTracker = execTracker ? 'Yes' : 'No';
	    			SIPexecutionTracker = SIPexecTracker ? 'Yes' : 'No';
	    			investmentId = idInvestment;
	    			//Added on:18/02/2013 : Aditi Satpute : AP changes
	    			//mfLumpsumRemark = objApprovePlan.MF_LumpsumRemark__c;
	    			//mfSIPRemark = objApprovePlan.MF_SIPRemark__c;
	    			if(objApprovePlan.isExecutionTracker__c == true || (objApprovePlan.isSIPexecutionTracker__c && objApprovePlan.Investment_Asset__c != null))
	    			{
	    				if(mapIdToExecutionTracker.containsKey(objApprovePlan.Id))
	    					lstET = mapIdToExecutionTracker.get(objApprovePlan.Id);
	    					system.debug('*********lstET*********'+lstET);
	    				if(lstET.size() > 0)
	    				{
		    				//Ta assign last records assignToOps Status
			    			for(Execution_Tracker__c obj : lstET)
			    			{
			    				if(obj.Type__c != null && obj.Type__c.equalsIgnoreCase('Lumpsum'))
				    			{
				    				strLumpsumAssignedToOps = obj.AssignToOps__c ? 'Yes' : 'No';
				    				system.debug('******obj.Application_Status__c********'+obj.Application_Status__c);
				    				//if(obj.Application_Status__c != null)
				    				 // strLumpsumFormsPrivided = obj.Application_Status__c != null ? (obj.Application_Status__c.equalsIgnoreCase(Label.Forms_Provided) ? 'Yes' : 'No') : 'No';
				    				 strLumpsumFormsPrivided = obj.isFormProvidedToMET__c ? 'Yes' : 'No';
				    				 if(obj.Suggested_Amount__c == obj.Total_Remaining_Balance__c && obj.Application_Status__c != 'Closed')
										ETLumupsumStatus = Label.ET_NotExecuted; 
									 else if(obj.Suggested_Amount__c > obj.Total_Remaining_Balance__c && obj.Application_Status__c != 'Closed')
								  	 	ETLumupsumStatus = Label.ET_PartiallyExecuted;
								  	 else if(obj.Total_Remaining_Balance__c == obj.Agreed_Amount__c && obj.Executed_Amount__c == obj.Agreed_Amount__c )
								  	 	ETLumupsumStatus = Label.ET_FullyExecuted;
								  	 	
				    			}
				    			else if(obj.Type__c != null && obj.Type__c.equalsIgnoreCase('SIP'))
				    			{
				    				strSIPAssignedToOps = obj.AssignToOps__c ? 'Yes' : 'No';
				    				strSIPFormsPrivided = obj.isFormProvidedToMET__c ? 'Yes' : 'No';
				    				if(obj.Suggested_Amount__c == obj.Total_Remaining_Balance__c && obj.Application_Status__c != 'Closed')
										ETSipStatus = Label.ET_NotExecuted; 
								 	else if(obj.Suggested_Amount__c > obj.Total_Remaining_Balance__c && obj.Application_Status__c != 'Closed')
								  	 	ETSipStatus = Label.ET_PartiallyExecuted;
							  	 	else if(obj.Total_Remaining_Balance__c == obj.Agreed_Amount__c && obj.Executed_Amount__c == obj.Agreed_Amount__c )
								  	 	ETSipStatus = Label.ET_FullyExecuted;
				    			}
			    			}
	    				}
	    				else
	    				{
	    					ETLumupsumStatus = '';
	    					//error.debugLog('******ETLumupsumStatus***in Mutual Fund**else*'+ETLumupsumStatus);
	    				}		
	    			}
	    			
	    			
	    			system.debug('*********ETLumupsumStatus*********'+ETLumupsumStatus);
	    			system.debug('*********ETSipStatus*********'+ETSipStatus);
	    			objCurrentMutualFunds = approvedPlanBean.populateCurrentMutualFunds
	    													(schemeName, assetClass, 
	    													 amount,owner, account, 
	    													 lumpsumAction, actionAmount,
	    													 execTracker,investmentId,
	    													 executionTracker,isNewMutualFund, --newCount, objApprovePlan.Id,
	    													 strLumpsumAssignedToOps,strLumpsumFormsPrivided,ETLumupsumStatus);//, mfLumpsumRemark);
	    			
	    													 
	    			if(currentSIP != null && !isNewMutualFund  && currentSIP > 0)
	    				objCurrentMutualFundsRunningSIP = approvedPlanBean.populateSIPCurrentMutualFunds
	    													(schemeName, assetClass,
	    													 amount,owner, account,
	    													 lumpsumAction, actionAmount, SIPactionAmount,
	    													 execTracker,SIPexecTracker,investmentId,
	    													 executionTracker,SIPexecutionTracker,currentSIP,
	    													 SIPaction, isNewMutualFund,objApprovePlan.Id,strSIPAssignedToOps,strSIPFormsPrivided,ETSipStatus);//, mfSIPRemark);
	    													 
	    			lstCurrentMutualFunds.add(objCurrentMutualFunds);
    			}
    		}
    		else
    		{
    			actionAmount = 0;
    			lumpsumAction = 'Hold - Change of broker';
    			amount = objInvestmentAsset.TotalAsset__c;
    			assetClass = objInvestmentAsset.Asset_Type__c;
    			account = objInvestmentAsset.Entity__c;
    			if(objInvestmentAsset.Entity__r.LastName == null)
          		{
          			owner = objInvestmentAsset.Entity__r.FirstName;
          		}
          		else if(objInvestmentAsset.Entity__r.FirstName == null )
          		{
          			owner = objInvestmentAsset.Entity__r.LastName;
          		}
          		else if(objInvestmentAsset.Entity__r.LastName != null && objInvestmentAsset.Entity__r.FirstName != null)
          		{
          			owner = objInvestmentAsset.Entity__r.FirstName +' '+ objInvestmentAsset.Entity__r.LastName;
          		}
          		else
          		{
          			owner = '';
          		} 
    			schemeName = objInvestmentAsset.Scheme_Name_Text__c;
    			SIPactionAmount = 0;
    			currentSIP = objInvestmentAsset.Monthly_SIP_Amount__c;
    			SIPaction = 'Continue';
    			execTracker = false;
    			executionTracker = 'No';
    			SIPexecTracker = false;
    			SIPexecutionTracker = 'No';
    			investmentId = idInvestment;
    			objCurrentMutualFunds = approvedPlanBean.populateCurrentMutualFunds
    													(schemeName, assetClass, 
    													 amount,owner, account, 
    													 lumpsumAction, actionAmount,
    													 execTracker,investmentId,
    													 executionTracker,false, 0, '','No','No','');
    													 
    			if(currentSIP != null  && !isNewMutualFund  && currentSIP > 0)
    				objCurrentMutualFunds = approvedPlanBean.populateSIPCurrentMutualFunds
    													(schemeName, assetClass,
    													 amount,owner, account,
    													 lumpsumAction, actionAmount, SIPactionAmount,
    													 execTracker,SIPexecTracker,investmentId,
    													 executionTracker,SIPexecutionTracker,currentSIP,
    													 SIPaction,false, '','No','No','');
    			
    			lstCurrentMutualFunds.add(objCurrentMutualFunds);
    		}
    		
    		if(!mapIdToInnerClass.containsKey(idInvestment))
    		{
    			mapIdToInnerClass.put(idInvestment,lstCurrentMutualFunds);
    		}
    		
    		approvedPlanBean.mapIdToCurrentFunds = mapIdToInnerClass ;
    	 }
    	
    }
    
    /**
    * @Description: Retrieve the Recommended Insurances of New Action Plan
    * param: ApprovedPlanBean 
    * return type: None 
    */ 
    public void getRecommendedInsurances(ApprovedPlanBean approvedPlanBean,Set<Id> familyIdSet,Map<Id,List<Execution_Tracker__c>> mapIdToExecutionTracker,
    							Map<String,List<Approve_Action_Plan__c>> mapIdTolstActionPlan)
    {
		List<Insurance__c> insuranceList = dbSOQLObj.getInsuranceListByRecordTypeForIncludeActionPlan(approvedPlanBean.entityId);
		ApprovedPlanBean.RecommendedInsurance objRecommendedInsurance = new ApprovedPlanBean.RecommendedInsurance();
		Map<Id,Approve_Action_Plan__c> mapIdToApprovePlan = new Map<Id,Approve_Action_Plan__c>();
		Approve_Action_Plan__c objApprovePlan = new Approve_Action_Plan__c();
		Account objAcc = new Account();
		List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
		Map<Id,Account> mapIdToAccount = new Map<Id,Account>([select Id,Name,LastName,FirstName from Account]);
	 	//Added on : 02/04/13 : Aditi Satpute : Purpose - need to save execution tracker details for this section : ET Screen Changes
    	/*List<Approve_Action_Plan__c> lstApproveActionPlan = [Select  Transaction_Type__c, Action_Amount__c, Insurance__c, Remarks__c, Scheme_Name__c, Goal__c , Asset_Class__c, 
                                 isInsuranceExecutionTracker__c,Amount__c, Investment_Asset__c, isSIPexecutionTracker__c, isETcreated__c,
                                 Fund__c, Lumpsum_Action__c,SIP_Action_Amount__c,Amount_Per_Installment__c, SIP_Action__c, Product_Name__c, 
                               	 Account__c, Option__c,  isExecutionTracker__c ,Installments__c,  Account__r.FirstName, CreatedDate, 
                                 Account__r.LastName,Category__c,Insured__c, Policy_Type__c,Sum_Assured_Rs__c,Premium_Amount_Rs__c
                               From Approve_Action_Plan__c
                               where  Account__c IN: familyIdSet and  Item_Type__c = : Label.Surrender_Insurance
                               and AP_Status__c = 'Opened'];*/
        List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
     	if(mapIdTolstActionPlan.containsKey(Label.Surrender_Insurance))
   	 	{
		     lstApproveActionPlan = mapIdTolstActionPlan.get(Label.Surrender_Insurance);
   		}                         
                               
                               
    	system.debug('***********lstApproveActionPlan in rec Ins**********'+lstApproveActionPlan);
       	for(Approve_Action_Plan__c objApproveActionPlan : lstApproveActionPlan )
       	{
           	if(!mapIdToApprovePlan.containsKey(objApproveActionPlan.Insurance__c))
       	 	{
          		mapIdToApprovePlan.put(objApproveActionPlan.Insurance__c,objApproveActionPlan);
        	}
       	}
    		
    		
		for(Insurance__c objInsurance : insuranceList)
		{
			String insured = '';
    		String nominee = '';
    		String insuranceCompany = '';
    		String policyType = '';
    		String policyName = '';
    		String policyNumber = ''; 
   		 	Date commencementDate;
   		 	Date nextPremiumDueDate; 
   			double deathBenefitRs = 0;
   			double premiumAmountRs = 0;
   			String premiumPaymentFrequency = '';
   			double tenureofInsurance = 0;
   		    double premiumPayingTerm = 0;
   			double surrenderCashValue = 0;
   			double currentAmount = 0;
   			double maturityAmount = 0;
   		 	String action = '';
   		 	Boolean execTracker = false;
            String executionTracker = '';
            String insuranceId = '';
            String approveActionPlanId = '';
            String strAssignedToOps = '';
            String ETStatus = '';
            //String strFormsProvided = '';
			if(mapIdToAccount.containsKey(objInsurance.Nominee__c))
			{
				objAcc = mapIdToAccount.get(objInsurance.Nominee__c);
				nominee = objAcc.Name;
			}
			insured = objInsurance.Entity__r.Name;
			insuranceCompany = objInsurance.Insurance_Company__c;
			policyType = objInsurance.Policy_Type__c;
			policyName = objInsurance.Policy_Name__c;
			policyNumber = objInsurance.Policy_Number__c;
			commencementDate = objInsurance.Commencement_Date__c;
			nextPremiumDueDate = objInsurance.Next_Premium_Due_Date__c;
			deathBenefitRs = objInsurance.Death_Benefit_Rs__c;
			premiumAmountRs = objInsurance.Premium_Amount_Rs__c;
			premiumPaymentFrequency = objInsurance.Premium_Frequency__c;
			tenureofInsurance = objInsurance.Tenure_of_Insurance__c;
			premiumPayingTerm = objInsurance.Premium_Paying_Term__c;
			surrenderCashValue = objInsurance.Surrender_Cash_Value__c;
			currentAmount = objInsurance.Current_Amount__c;
			/* Prajakta - FP changes - 13-03-2013 */
			if(objInsurance.Maturity_Amount__c != null && objInsurance.Revised_Maturity_Amount__c == 0)
				maturityAmount = objInsurance.Maturity_Amount__c;
    		else
    			maturityAmount = objInsurance.Revised_Maturity_Amount__c;
			action = objInsurance.Action__c;
			//Added on : 02/04/13 : Aditi Satpute : Purpose - need to save execution tracker details for this section : ET Screen Changes
           	if(mapIdToApprovePlan.containsKey(objInsurance.Id))
           	{
               objApprovePlan = mapIdToApprovePlan.get(objInsurance.Id);
               if(mapIdToExecutionTracker.containsKey(objApprovePlan.Id))
		  	   {
				   lstET = mapIdToExecutionTracker.get(objApprovePlan.Id);
				   for(Execution_Tracker__c objET : lstET)
				   {
				   		strAssignedToOps = objET.AssignToOps__c ? 'Yes' : 'No';
				   		if(objET.Type__c.equalsIgnoreCase(Label.Surrender_Insurance) && objET.Type__c != null)
				   		{
				   			if(objET.Application_Status__c != 'Closed')
							  	ETStatus = Label.ET_NotExecuted; 
					 	  	else 
						  	  	ETStatus = Label.ET_FullyExecuted;
				   		}
				   		else
				   		{
					   		if(objET.Suggested_Amount__c == objET.Total_Remaining_Balance__c && objET.Application_Status__c != 'Closed')
							  	ETStatus = Label.ET_NotExecuted; 
					 	  	else if(objET.Suggested_Amount__c > objET.Total_Remaining_Balance__c  && objET.Application_Status__c != 'Closed')
						  	  	ETStatus = Label.ET_PartiallyExecuted;
					  	  	else if(objET.Total_Remaining_Balance__c == objET.Agreed_Amount__c && objET.Executed_Amount__c == objET.Agreed_Amount__c )
						  	  	ETStatus = Label.ET_FullyExecuted;
				   		}
				   		//strFormsProvided = objET.isFormProvidedToMET__c ? 'Yes' : 'No';
				   }
		  	   } 
        	   execTracker = objApprovePlan.isInsuranceExecutionTracker__c;
               executionTracker = execTracker ? 'Yes' : 'No';
               system.debug('********objApprovePlan.Id********'+objApprovePlan.Id);
               approveActionPlanId = objApprovePlan.Id;
           	}
           	insuranceId = objInsurance.Id;
           	
           	
			objRecommendedInsurance = approvedPlanBean.populateRecommendedInsurance (insured,nominee,insuranceCompany,policyType,policyName,
									  policyNumber,commencementDate,nextPremiumDueDate,deathBenefitRs,premiumAmountRs,premiumPaymentFrequency,tenureofInsurance,
									  premiumPayingTerm,surrenderCashValue,currentAmount,maturityAmount,action,executionTracker,execTracker,insuranceId,
									  approveActionPlanId,strAssignedToOps,ETStatus);//,strFormsProvided);
		
		}
    }
    /**
    * @Description: Retrieve all Goal Related Details of New Action Plan
    * param: ApprovedPlanBean & List<Goal__c>
    * return type: None 
    */ 
    public void getGoalAssetAllocation(ApprovedPlanBean approvedPlanBean, List<Goal__c> goalList, Set<Id> familyIdSet,Map<Id,List<Execution_Tracker__c>> mapIdToExecutionTracker)
    {
         system.debug('---------approvedPlanBean---'+approvedPlanBean);
         system.debug('--------goalList'+goalList);
         system.debug('--------familyIdSet'+familyIdSet);
         system.debug('--------mapIdToExecutionTracker'+mapIdToExecutionTracker);
              
        ApprovedPlanBean.GoalDetails objActionPlanGoalDetails = new ApprovedPlanBean.GoalDetails();
        ApprovedPlanBean.GoalDetails objEmergencyLumpsumActionPlanGoalDetails = new ApprovedPlanBean.GoalDetails();
        ApprovedPlanBean.AllocatedAssets objActionPlanAllocatedAssets = new ApprovedPlanBean.AllocatedAssets();
       // ApprovedPlanBean.UnAllocatedAssets objUnAllocatedAssets = new ApprovedPlanBean.UnAllocatedAssets();
   
        List<Insurance__c> insuranceList = dbSOQLObj.getInsuranceListByRecordType(approvedPlanBean.entityId);
        system.debug('---------insuranceList---'+insuranceList);
         
        List<Investment_asset__c> investmentList = dbSOQLObj.getInvestmentAsset(approvedPlanBean.entityId,true);
         system.debug('---------investmentList---'+investmentList);
         
      	List<Asset__c>assetList = dbSOQLObj.getAssets(approvedPlanBean.entityId);
      	 system.debug('---------assetList---'+assetList);
      	 
      	Entity_Global_Assumption__c globalAssumptions = dbSOQLObj.getEntityGlobalAssumption(approvedPlanBean.entityId);
      
     	List<GoalAssetAssociation__c> goalAssetAssociationList;
     	List<GoalAssetAssociation__c> lstGoalAssetAssociation;
     
     	List<GoalInsuranceAssociation__c> goalInsuranceAssociationList; 
      	List<GoalInsuranceAssociation__c> lstGoalInsuranceAssociation;
      
       	List<GoalInvestmentAssetAssociation__c> goalInvestmentAssetAssociationList; 
      	List<GoalInvestmentAssetAssociation__c> lstGoalInvestmentAssetAssociation;
      	
       	goalAssetAssociationList = new List<GoalAssetAssociation__c>();
     	goalInsuranceAssociationList = new List<GoalInsuranceAssociation__c>(); 
     	goalInvestmentAssetAssociationList = new  List<GoalInvestmentAssetAssociation__c>();
     //==============================================================================================
      
        
     //===========AssetAssociation============================================================================================================
        Map<ID,List<GoalAssetAssociation__c>> goalAssetMappingMap = new Map<ID,List<GoalAssetAssociation__c>>();
        String entityId = approvedPlanBean.entityId;
        objAccount = dbSOQLObj.getEntity(entityId);
        
         system.debug('---------entityId---'+entityId);
         system.debug('--------dbSOQLObj'+dbSOQLObj.getGoalAssetAllocationList(entityId));
        //Query which returns all Allocated Goal Assets (Only assets, Not investment and insurance) 
        goalAssetAssociationList = dbSOQLObj.getGoalAssetAllocationList(entityId);
        
        system.debug('goalAssetAssociationList'+goalAssetAssociationList);
        
        //Map to store all AssetId's and its allocations 
        Map<String,Double> Assetpercentage = new Map<String,Double>(); 
        
        for(GoalAssetAssociation__c gaObj: goalAssetAssociationList)
        {
        	//Assetpercentage returns a map of AssetId to Sum of particular Asset allocated to different goals
            if(Assetpercentage.containsKey(gaObj.asset__c))
            {
            	Double dblPercentage = 0;
            	if(Assetpercentage.get(gaObj.asset__c) != null)
            		dblPercentage = Assetpercentage.get(gaObj.asset__c);
            	Assetpercentage.put(gaObj.asset__c,dblPercentage + gaObj.allocated__c);		//If same asset allocated for different goal, then it gets added to the first allocated percentage
            }
            else
            {
                Assetpercentage.put(gaObj.asset__c, gaObj.allocated__c);					//If asset allocated for some goal
            }
            
        }
        
    	double allocatedAmountAsset = 0;
    	string strType = '';
    	String strAssetDescription = '';
    	String entityName = '';
    	Integer currentYear = 0;
    	//goalAssetMappingMap returns map of GoalId to different assets allocated for particular goal
    	for(GoalAssetAssociation__c goalAssetAssociation : goalAssetAssociationList)
    	{
    		List<GoalAssetAssociation__c> lstGoalAsset = new List<GoalAssetAssociation__c>(); 
        	if(goalAssetMappingMap.containsKey(goalAssetAssociation.Goal__c))
        	{
        		lstGoalAsset = goalAssetMappingMap.get(goalAssetAssociation.Goal__c);
        		lstGoalAsset.add(goalAssetAssociation);
        	}
        	else
        		lstGoalAsset.add(goalAssetAssociation);
        		
        	goalAssetMappingMap.put(goalAssetAssociation.Goal__c,lstGoalAsset);
    	}
    	
    	//For unallocated assets only
    	for(Asset__c objAssets : assetList)
    	{
    		if(Assetpercentage.containsKey(objAssets.Id))
            {
            	if(objAssets.Action__c != '---None----')
            	{
	            	allocatedAmountAsset = Assetpercentage.get(objAssets.Id);
	            	if(objAssets.RecordType.Name == 'Govt. Saving Schemes' ||
	        			 objAssets.RecordType.Name == 'Retirement Accounts'|| 
	        			 objAssets.RecordType.Name == 'Deposits With Bank')
	            	{
	            		strAssetDescription = (objAssets.RecordType.Name == 'Deposits With Bank') ? 
	            					((objAssets.Bank_Name__c != null) ? (objAssets.Bank_Name__c + ' - ' + objAssets.Account_Number__c)
	            					 : (objAssets.Account_Number__c)) : (objAssets.Account_Number__c);
	            	}
	            	else
	            		strAssetDescription = (objAssets.Description__c);
	  				
	  				entityName = objAssets.Entity__r.FirstName +' '+ objAssets.Entity__r.LastName;			          			
	          		if(objAssets.Asset_Types__c!=null && objAssets.Asset_Types__c!='')
	          		{
	                	strType = objAssets.Asset_Types__c;
	                }
	                else
	                {
	                    strType = objAssets.Account_Type__c;
	                }
	            	if(objAssets.Monthly_Asset__c != null && allocatedAmountAsset < 100)
	          		{
	          			double CurrentValue = 0.0;
	          			CurrentValue = objAssets.Monthly_Asset__c;
		          		double remainingBalance = 0;
		          		if(CurrentValue != null)
		          		{
		          			allocatedAmountAsset = (CurrentValue * allocatedAmountAsset) / 100;
			          		remainingBalance = CurrentValue - allocatedAmountAsset;
		          		}
		          		else
		          			remainingBalance = 0;
		          		/*if(Math.floor(remainingBalance) > 0)
	          	  			objUnAllocatedAssets =  approvedPlanBean.populateUnAllocatedAssets(entityName,strType,strAssetDescription,CurrentValue,remainingBalance);
	          	  		*/
	          		}
            	}
            }
            /*--------------------------Prajakta - Displaying 100% Unallocated asset - 6/8/2013-------------------------------------------*/
            else if(objAssets.Allocated_Amount__c == 0.0)
      		{
      			if(objAssets.Action__c == '---None----')
      			{
	      			//allocatedAmountAsset = Assetpercentage.get(objAssets.Id);
	              	if(objAssets.RecordType.Name == 'Govt. Saving Schemes' ||
	               		objAssets.RecordType.Name == 'Retirement Accounts'|| 
	           			objAssets.RecordType.Name == 'Deposits With Bank')
	              	{
	                	strAssetDescription = (objAssets.RecordType.Name == 'Deposits With Bank') ? 
	                      ((objAssets.Bank_Name__c != null) ? (objAssets.Bank_Name__c + ' - ' + objAssets.Account_Number__c)
	                       : (objAssets.Account_Number__c)) : (objAssets.Account_Number__c);
	              	}
	              	else
	                	strAssetDescription = (objAssets.Description__c);
	                	
	                entityName = objAssets.Entity__r.FirstName +' '+ objAssets.Entity__r.LastName;
	                                
	              	if(objAssets.Asset_Types__c!=null && objAssets.Asset_Types__c!='')
	              	{
	                  	strType = objAssets.Asset_Types__c;
	                }
	                else
	                {
	                    strType = objAssets.Account_Type__c;
	                }
	              	if(objAssets.Monthly_Asset__c != null)
	              	{
	                	double CurrentValue = 0.0;
	                	CurrentValue = objAssets.Monthly_Asset__c;
	                	double remainingBalance = 0;
	                	if(CurrentValue != null)
	                	{
	                  		allocatedAmountAsset = 0.0;
	                  		remainingBalance = CurrentValue - allocatedAmountAsset;
	                	}
		                else
		                  remainingBalance = 0;
		                /*if((Math.floor(remainingBalance) > 0))
		                    objUnAllocatedAssets =  approvedPlanBean.populateUnAllocatedAssets(entityName,strType,strAssetDescription,CurrentValue,remainingBalance);
		                */    
	              	}
      			}
      		}
    	}
         
//===========InvestmentAssets============================================================================================================      
       String strInvestmentType = '';
       double CurrentTotalValue = 0;
       double amountAllocatedInvestment = 0;
       double allocatedAmt = 0;
       double CurrentValue;
       double allocatedAmountInvestment=0;
       string strInvestmentDescription = '';
       double availableAmount = 0; 
       double balanceRemaining = 0;
	   entityName = '';	
		
       Map<ID,List<GoalInvestmentAssetAssociation__c>> goalInvestmentAssetMappingMap = new Map<ID,List<GoalInvestmentAssetAssociation__c>>();
       goalInvestmentAssetAssociationList = dbSOQLObj.getGoalInvestmentAssociationList(entityId);
       Map<String,List<Investment_Asset__c>> mapNameToInvestment = new Map<String,List<Investment_Asset__c>>();
       Integer i = 0;
       List<Investment_Asset__c> lstInvestment = new List<Investment_Asset__c>();

      //Assetpercentage map returns Investment_assetId vs particular InvestmentAsset aalocated for diff goals 
      for(GoalInvestmentAssetAssociation__c giObj: goalInvestmentAssetAssociationList)
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
       
      //goalInvestmentAssetMappingMap map returns GoalId vs different IA allocated for the same goal
      	for(GoalInvestmentAssetAssociation__c goalInvestmentAssetAssociation : goalInvestmentAssetAssociationList) 
      	{
          	List<GoalInvestmentAssetAssociation__c> lstInvestmentAssetAssociation = new List<GoalInvestmentAssetAssociation__c>();
          	if(goalInvestmentAssetMappingMap.containsKey(goalInvestmentAssetAssociation.Goal__c)) 
          	{
              	lstInvestmentAssetAssociation = goalInvestmentAssetMappingMap.get(goalInvestmentAssetAssociation.Goal__c);
                lstInvestmentAssetAssociation.add(goalInvestmentAssetAssociation);
          	}
          	else
            	lstInvestmentAssetAssociation.add(goalInvestmentAssetAssociation);
          	goalInvestmentAssetMappingMap.put(goalInvestmentAssetAssociation.Goal__c,lstInvestmentAssetAssociation);       
    	} 
    
        List<Investment_Asset__c>   lstInvestmentAsset = new List<Investment_Asset__c>();
        for(Investment_Asset__c objInvestment : investmentList)
        {
        	strInvestmentType = objInvestment.RecordType.Name;
        	if(Assetpercentage.containsKey(objInvestment.Id))
          	{
          		if(objInvestment.Action__c != '---None----')
          		{
                  	allocatedAmountInvestment = Assetpercentage.get(objInvestment.Id);
            		if(strInvestmentType == 'Fixed Income')
              		{
                    	CurrentValue = objInvestment.TotalAsset__c ;
                    	CurrentTotalValue = CurrentTotalValue + CurrentValue;
                    	amountAllocatedInvestment = (CurrentValue *  allocatedAmountInvestment)/100;
                    	entityName = objInvestment.Entity__r.FirstName +' '+ objInvestment.Entity__r.LastName;
                    	//Prajakta - FP changes - 25-02-2013
                    	if(objInvestment.Maturity_Date__c != null)
                    	{
                   	 		Datetime dtReport = objInvestment.Maturity_Date__c;
                    		String strDate = '';
                    		if(dtReport != null)
                  				strDate = dtReport.day() + '-' + dtReport.month() + '-' + dtReport.year();
                    		strInvestmentDescription = objInvestment.Description__c + ' -- ' + strDate; 
                    	}
                    	else
                    	{
                    		strInvestmentDescription = objInvestment.Description__c;
                    	}
                    	//strInvestmentDescription = '-';        
                    	
                       	if(CurrentValue != null)
                      		balanceRemaining = CurrentValue - amountAllocatedInvestment;
                		else
                      		balanceRemaining = 0;
                  		/*if((Math.floor(balanceRemaining) > 0) && allocatedAmountInvestment < 100)
                      		objUnAllocatedAssets =  approvedPlanBean.populateUnAllocatedAssets(entityName,strInvestmentType,strInvestmentDescription,CurrentValue,balanceRemaining);
                      	*/	
              		}       
                  	else
              		{
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
        	/*--------------------------Prajakta - Displaying 100% Unallocated investment asset - 6/8/2013-------------------------------------------*/
        	else if(objInvestment.Allocated_Amount__c == 0.0)
        	{
        		system.debug('*****11111111 :  ');
        		if(objInvestment.Action__c == '---None----')
          		{
          			system.debug('*****2222222222 :  ');
                  	//allocatedAmountInvestment = Assetpercentage.get(objInvestment.Id);
            		if(strInvestmentType == 'Fixed Income')
              		{
                    	CurrentValue = objInvestment.TotalAsset__c ;
                    	CurrentTotalValue = CurrentTotalValue + CurrentValue;
                    	//amountAllocatedInvestment = (CurrentValue *  allocatedAmountInvestment)/100;
                    	system.debug('*****CurrentTotalValue :  '+CurrentTotalValue);  
                    	//Prajakta - FP changes - 25-02-2013
                    	if(objInvestment.Maturity_Date__c != null)
                    	{
	                   	 	Datetime dtReport = objInvestment.Maturity_Date__c;
	                    	String strDate = '';
	                    	entityName = objInvestment.Entity__r.FirstName +' '+ objInvestment.Entity__r.LastName;
	                    	if(dtReport != null)
	                  			strDate = dtReport.day() + '-' + dtReport.month() + '-' + dtReport.year();
	                    	strInvestmentDescription = objInvestment.Description__c + ' -- ' + strDate; 
                    	}
                    	else
                    	{
                    		strInvestmentDescription = objInvestment.Description__c;
                    	}
                    	//strInvestmentDescription = '-';        
                       	if(CurrentValue != null)
                      		balanceRemaining = CurrentValue;
                		else
                      		balanceRemaining = 0;
                      	system.debug('*****balanceRemaining :  '+balanceRemaining);  
                  		/*if((Math.floor(balanceRemaining) > 0))
                      		objUnAllocatedAssets =  approvedPlanBean.populateUnAllocatedAssets(entityName,strInvestmentType,strInvestmentDescription,CurrentValue,balanceRemaining);
                      	*/	
              		}       
                  	else
              		{
              			system.debug('*****in else----------- :  ');
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
            system.debug('*****objInvestment :  '+objInvestment);  
            //system.debug('*****mapNameToInvestment :  '+mapNameToInvestment.values());    
        }
        Integer temp = 0 ;
        for(String strEntityName : mapNameToInvestment.keySet())
        {      
           	system.debug('*****strEntityName :  '+strEntityName);    
           	CurrentValue = 0;
           	CurrentTotalValue = 0;
        	lstInvestmentAsset = mapNameToInvestment.get(strEntityName);
        
        	for(Investment_Asset__c objInvest : lstInvestmentAsset)
        	{
          		system.debug('****objInvest*****'+objInvest);
          		strInvestmentDescription = '-';      
          		CurrentValue = objInvest.TotalAsset__c ;
          		entityName = objInvest.Entity__r.FirstName + ' ' + objInvest.Entity__r.LastName;
          		system.debug('****CurrentValue*****'+CurrentValue);
          		allocatedAmountInvestment = Assetpercentage.get(objInvest.Id);
          		CurrentTotalValue = CurrentTotalValue + CurrentValue;
          		system.debug('****CurrentTotalValue*****'+CurrentTotalValue);
          		system.debug('****allocatedAmountInvestment*in stock****'+allocatedAmountInvestment);
           		strInvestmentDescription = '-';        
          		strInvestmentType = objInvest.RecordType.Name;  
          		if(objInvest.Allocated_Amount__c != 0.0) 
         			amountAllocatedInvestment = (CurrentTotalValue *  allocatedAmountInvestment)/100;
         		else
         			amountAllocatedInvestment = 0.0;       
          	}
          	//amountAllocatedInvestment = (CurrentTotalValue *  allocatedAmountInvestment)/100;
          	if(CurrentTotalValue != null)
            	balanceRemaining = CurrentTotalValue - amountAllocatedInvestment;
        	else
            	balanceRemaining = 0;
        	system.debug('****balanceRemaining****Stock n Mutual**'+balanceRemaining);
          	/*if((Math.floor(balanceRemaining) > 0) && allocatedAmountInvestment < 100)
             	objUnAllocatedAssets =  approvedPlanBean.populateUnAllocatedAssets(entityName,strInvestmentType,strInvestmentDescription,CurrentTotalValue,balanceRemaining);
          	else if(Math.floor(balanceRemaining) > 0)
          		objUnAllocatedAssets =  approvedPlanBean.populateUnAllocatedAssets(entityName,strInvestmentType,strInvestmentDescription,CurrentTotalValue,balanceRemaining);
          	*/	
          	
         }  
       //============================================================================================   
       
  //===========Insurance============================================================================================================
        
        Map<ID,List<GoalInsuranceAssociation__c>> goalInsuranceMappingMap = new Map<ID,List<GoalInsuranceAssociation__c>>();
        
    	goalInsuranceAssociationList = dbSOQLObj.getGoalInsuranceAllocationList(entityId);
        double allocatedAmountInsurance = 0;
        double currentInsuranceValue = 0;
        double calculateAllocatedAmount = 0;
        double remainingInsuranceBalance = 0;
       	string strInsuranceType = '';
       	string strInsuranceDescription = '';
        entityName = '';	
        //Assetpercentage map returns InsuranceId vs Particular insurance allocated for different goals
        for(GoalInsuranceAssociation__c ginObj: goalInsuranceAssociationList)
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

		//goalInsuranceMappingMap map returns different insurances allocated for particular goal
		for(GoalInsuranceAssociation__c goalInsuranceAssociation : goalInsuranceAssociationList) 
		{
	    	List<GoalInsuranceAssociation__c> lstInsuranceAssociation = new List<GoalInsuranceAssociation__c>();
	    	if(goalInsuranceMappingMap.containsKey(goalInsuranceAssociation.Goal__c)) 
	    	{
	        	lstInsuranceAssociation = goalInsuranceMappingMap.get(goalInsuranceAssociation.Goal__c);
	        	lstInsuranceAssociation.add(goalInsuranceAssociation);
	    	}
	    	else
	    		lstInsuranceAssociation.add(goalInsuranceAssociation);
	    	goalInsuranceMappingMap.put(goalInsuranceAssociation.Goal__c,lstInsuranceAssociation);       
		} 
		AssetAllocationService objAssetAllocation = new AssetAllocationService();
			
		for(Insurance__c objInsurance : insuranceList)
		{
			if(Assetpercentage.containsKey(objInsurance.Id))
            {
            	if(objInsurance.Action__c != '---None----')
            	{
	            	if(objInsurance.Insurance_Company__c != null)
					{
						if(objInsurance.Policy_Name__c != null)
						{
							strInsuranceDescription = objInsurance.Policy_Number__c != null ? 
												(objInsurance.Insurance_Company__c + ' -- ' + objInsurance.Policy_Name__c + ' -- ' + objInsurance.Policy_Number__c)
												:(objInsurance.Insurance_Company__c + ' -- ' + objInsurance.Policy_Name__c);
						}
						else
							strInsuranceDescription = objInsurance.Policy_Number__c != null ? 
												 (objInsurance.Insurance_Company__c + ' -- ' + objInsurance.Policy_Number__c) : (objInsurance.Insurance_Company__c);
					}
					else
					{
						if(objInsurance.Policy_Name__c != null)
							strInsuranceDescription = objInsurance.Policy_Number__c != null ? 
													(objInsurance.Policy_Name__c + ' -- ' + objInsurance.Policy_Number__c) : objInsurance.Policy_Name__c;
						else if(objInsurance.Policy_Number__c != null)
							strInsuranceDescription = objInsurance.Policy_Number__c;
					}
	
	                strInsuranceType = objInsurance.Policy_Type__c;
	            	allocatedAmountInsurance = Assetpercentage.get(objInsurance.Id);
	            	Double dblOneInstallmentAmount = 0;
	        		Integer iTenureOfInsurance = 0 ;
	        		Integer iMaturityYear = 0;
	        		if(!objInsurance.Premium_Frequency__c.equals('One Time Premium'))
	 					dblOneInstallmentAmount = objInsurance.Premium_Amount_Rs__c;
	 					
	 				if(objInsurance.Tenure_of_Insurance__c != null)
		 					iTenureOfInsurance = Integer.valueOf(objInsurance.Tenure_of_Insurance__c);
	 				iMaturityYear = iTenureOfInsurance + objInsurance.Commencement_Date__c.year();
	 				Integer iCurrentYearForCalculation = 0;
	 				/* Aditi - FP changes - 04-03-2013 - Changed Date.Today() to Plan_Generation_Date__c*/
	     	 		currentYear = objAccount.Plan_Generation_Date__c != null ? objAccount.Plan_Generation_Date__c.year() : Date.today().year();
	 				if(currentYear > iMaturityYear)
	 					iCurrentYearForCalculation = iMaturityYear;
	 				else
	 					iCurrentYearForCalculation = currentYear;
	 				system.debug('********iCurrentYearForCalculation*******'+iCurrentYearForCalculation);
	 				Integer totalPeriodInYears =  iCurrentYearForCalculation - objInsurance.Commencement_Date__c.year();
					
					if(objInsurance.Surrender_Cash_Value__c == null)
						currentInsuranceValue = objAssetAllocation.GetInsuranceAmountForPeriod(objInsurance,totalPeriodInYears, dblOneInstallmentAmount);
					else
						currentInsuranceValue = objInsurance.Surrender_Cash_Value__c;
						calculateAllocatedAmount = (allocatedAmountInsurance * currentInsuranceValue)/100 ; 
						 
				 	if(currentInsuranceValue != null)
	  					remainingInsuranceBalance= currentInsuranceValue - calculateAllocatedAmount;
	  				else
	  					remainingInsuranceBalance = 0;
					/*if(Math.floor(remainingInsuranceBalance) > 0)
	      				objUnAllocatedAssets =  approvedPlanBean.populateUnAllocatedAssets(entityName,strInsuranceType,strInsuranceDescription,currentInsuranceValue,remainingInsuranceBalance);
	      				*/
            	}		
			}
			/*--------------------------Prajakta - Displaying 100% Unallocated insurance - 6/8/2013-------------------------------------------*/
		    else 
		    {
		    	if(objInsurance.Action__c == '---None----')
		    	{
		      		if(objInsurance.Insurance_Company__c != null)
		        	{
		          		if(objInsurance.Policy_Name__c != null)
			          	{
				            strInsuranceDescription = objInsurance.Policy_Number__c != null ? 
				                      (objInsurance.Insurance_Company__c + ' -- ' + objInsurance.Policy_Name__c + ' -- ' + objInsurance.Policy_Number__c)
				                      :(objInsurance.Insurance_Company__c + ' -- ' + objInsurance.Policy_Name__c);
			          	}
		          		else
		           	 		strInsuranceDescription = objInsurance.Policy_Number__c != null ? 
		                       (objInsurance.Insurance_Company__c + ' -- ' + objInsurance.Policy_Number__c) : (objInsurance.Insurance_Company__c);
		        	}
			        else
			        {
			          	if(objInsurance.Policy_Name__c != null)
			            	strInsuranceDescription = objInsurance.Policy_Number__c != null ? 
			                        (objInsurance.Policy_Name__c + ' -- ' + objInsurance.Policy_Number__c) : objInsurance.Policy_Name__c;
			          	else if(objInsurance.Policy_Number__c != null)
			            	strInsuranceDescription = objInsurance.Policy_Number__c;
			        }
		
					entityName = objInsurance.Entity__r.FirstName +' '+ objInsurance.Entity__r.LastName;
		            strInsuranceType = objInsurance.Policy_Type__c;
		          	allocatedAmountInsurance = 0.0;
		          	Double dblOneInstallmentAmount = 0;
		            Integer iTenureOfInsurance = 0 ;
		            Integer iMaturityYear = 0;
		            //if(!objInsurance.Premium_Frequency__c.equals('One Time Premium'))
		            if(objInsurance.Premium_Amount_Rs__c != null)
		               dblOneInstallmentAmount = objInsurance.Premium_Amount_Rs__c;
		           
		         	if(objInsurance.Tenure_of_Insurance__c != null)
		             	iTenureOfInsurance = Integer.valueOf(objInsurance.Tenure_of_Insurance__c);
			     	iMaturityYear = iTenureOfInsurance + objInsurance.Commencement_Date__c.year();
			     	Integer iCurrentYearForCalculation = 0;
				     /* Aditi - FP changes - 04-03-2013 - Changed Date.Today() to Plan_Generation_Date__c*/
			 	 	Integer startYear = objAccount.Plan_Generation_Date__c != null ? objAccount.Plan_Generation_Date__c.year() : Date.today().year();
			     	if(startYear > iMaturityYear)
				       iCurrentYearForCalculation = iMaturityYear;
			     	else
		           		iCurrentYearForCalculation = startYear;
		         	Integer totalPeriodInYears =  iCurrentYearForCalculation - objInsurance.Commencement_Date__c.year();
		        
			        if(objInsurance.Surrender_Cash_Value__c == null)
			        {  
			          	currentInsuranceValue = objAssetAllocation.GetInsuranceAmountForPeriod(objInsurance,totalPeriodInYears, dblOneInstallmentAmount);
			        }  
			        else
			          currentInsuranceValue = objInsurance.Surrender_Cash_Value__c;
		          	
		          	calculateAllocatedAmount = currentInsuranceValue; 
		           
		         	if(currentInsuranceValue != null)
			            remainingInsuranceBalance = currentInsuranceValue;
		          	else
		            	remainingInsuranceBalance = 0;
		         /* 	if(Math.floor(remainingInsuranceBalance) > 0)
		        	{
		              	objUnAllocatedAssets =  approvedPlanBean.populateUnAllocatedAssets(entityName,strInsuranceType,strInsuranceDescription,currentInsuranceValue,remainingInsuranceBalance);
		        	}
		        	*/
		    	}
	      	}
		}
		
       //======================================================================================================================================
       
  
       //============================================================================================   
       
       Map<Id,Insurance__c> goalInsuranceMap = new Map<Id,Insurance__c>();
   		goalInsuranceMap = dbSOQLObj.getInsuranceDetails(entityId);           
       
      
       ///////////////SIP MANASI
       List<Id> golIds = new List<Id>();
        for(Goal__c golObj: goalList)
        {
            golIds.add(golObj.Id);
        }
        //List<GoalSIPAmount__c> goalSips = dbSOQLObj.getGoalSIP(system.today().year(), golIds);
        List<GoalSIPAmount__c> goalSips = [select  Goal__c,Goal__r.SIP_Start_Year__c, Goal_Year__c, SIP_Debt__c, SIP_Equity__c, SIP_Gold__c, SIP_Total__c,
                          GoldCurrentYear__c,EquityCurrentYear__c,DebtCurrentYear__c
                                from GoalSIPAmount__c 
                                where SIP_Outflow__c = true 
                                AND
                                Goal__c In: golIds];
        Map<Id,GoalSIPAmount__c> goalIdVsGoalSIPAmount = new Map<Id,GoalSIPAmount__c>();
        
        for(GoalSIPAmount__c objGoalSIPAmount : goalSips)
        {
        	if(objGoalSIPAmount.Goal__r.SIP_Start_Year__c != null)  	
	        {
	        	if(Decimal.valueOf(objGoalSIPAmount.Goal__r.SIP_Start_Year__c) == objGoalSIPAmount.Goal_Year__c)
	         	{
		        	if(!goalIdVsGoalSIPAmount.containsKey(objGoalSIPAmount.Goal__c))
		        		goalIdVsGoalSIPAmount.put(objGoalSIPAmount.Goal__c,objGoalSIPAmount);
	         	}
	        }
        		
        } 
        //////////////////////SIP Funds/
        
        List<Approve_Action_Plan__c> lstApprove_Action_Plan  = [Select  Transaction_Type__c, a.Remarks__c,a.Goal__c ,a.isSIPexecutionTracker__c ,
        												a.Amount__c,a.Product_Name__c, a.Option__c, a.Installments__c, a.CreatedDate, a.Category__c 
        												From Approve_Action_Plan__c a where a.Account__c IN: familyIdSet and a.Item_Type__c = 'SIP'
        												and AP_Status__c = 'Opened'];
       Map<Id,List<Approve_Action_Plan__c>> mapGoalIdToAppActionPlan = new Map<Id,List<Approve_Action_Plan__c>>();
        for(Approve_Action_Plan__c objApproveActionPLan :lstApprove_Action_Plan )
        {
        	lstApprove_Action_Plan = mapGoalIdToAppActionPlan.get(objApproveActionPLan.Goal__c);
        	if(lstApprove_Action_Plan == null)
        	{
        		lstApprove_Action_Plan = new List<Approve_Action_Plan__c>();
        		mapGoalIdToAppActionPlan.put(objApproveActionPLan.Goal__c,lstApprove_Action_Plan);
        	}
        	lstApprove_Action_Plan.add(objApproveActionPLan);
        }
        //LumpsumFunds==================================
        List<Approve_Action_Plan__c> lstLumpsumApproveActionPlan  = [Select a.Transaction_Type__c, a.Remarks__c,a.Goal__c ,a.Goal__r.Description__c ,a.Lumpsum_Equity__c,
        															a.Amount__c,a.Fund__c,a.Amount_Per_Installment__c,a.Product_Name__c,a.Lumpsum_Debt__c,a.isLumpsumExecTracker__c,
        															a.Option__c, a.Installments__c, a.CreatedDate, a.Category__c ,a.Lumpsum_Gold__c,Goal__r.Goal_Type__c 
        															From Approve_Action_Plan__c a where a.Account__c IN: familyIdSet and a.Item_Type__c = 'Lumpsum'
        															and AP_Status__c = 'Opened'];
       	Map<Id,List<Approve_Action_Plan__c>> mapGoalIdToLumpsumAppActionPlan = new Map<Id,List<Approve_Action_Plan__c>>();
        Map<Id,List<Approve_Action_Plan__c>> mapGoalIdToEmergencyLumpsumAppActionPlan = new Map<Id,List<Approve_Action_Plan__c>>();
        for(Approve_Action_Plan__c objApproveActionPLan :lstLumpsumApproveActionPlan )
        {
        	//if(objApproveActionPLan.Goal__r.Description__c == 'Emergency Fund')
        	if(objApproveActionPLan.Goal__r.Goal_Type__c == 'Emergency Fund')
        	{
        		lstLumpsumApproveActionPlan = mapGoalIdToEmergencyLumpsumAppActionPlan.get(objApproveActionPLan.Goal__c);
	        	if(lstLumpsumApproveActionPlan == null)
	        	{
	        		lstLumpsumApproveActionPlan = new List<Approve_Action_Plan__c>();
	        		mapGoalIdToEmergencyLumpsumAppActionPlan.put(objApproveActionPLan.Goal__c,lstLumpsumApproveActionPlan);
	        	}
	        	lstLumpsumApproveActionPlan.add(objApproveActionPLan);
        		
        	}
        	else
        	{
	        	lstLumpsumApproveActionPlan = mapGoalIdToLumpsumAppActionPlan.get(objApproveActionPLan.Goal__c);
	        	if(lstLumpsumApproveActionPlan == null)
	        	{
	        		lstLumpsumApproveActionPlan = new List<Approve_Action_Plan__c>();
	        		mapGoalIdToLumpsumAppActionPlan.put(objApproveActionPLan.Goal__c,lstLumpsumApproveActionPlan);
	        	}
	        	lstLumpsumApproveActionPlan.add(objApproveActionPLan);
        	}
        }
        
        ///Lumpsum===================================================
         Map<id,List<Double>> goalIdVsListDoubleMap = new Map<id,List<Double>>(); 
		For(Goal__c objGoal : approvedPlanBean.goalList)
		{
			if(!goalIdVsListDoubleMap.containsKey(objGoal.id))
			{
				goalIdVsListDoubleMap.put(objGoal.id,new List<Double>{0,0,0});
			}
		}
		for(ApprovedPlanBean.DoneClass objDone : approvedPlanBean.suggestedLumpSum)
		{
			String className = objDone.className;
			List<Double> dblLumsumVals = objDone.golListVals;
			for(Integer iCount = 0; iCount < dblLumsumVals.size(); iCount++)
			{
				List<Double> lstLumpsumVals;
				Goal__c objGoal = approvedPlanBean.goalList.get(iCount);
				if(goalIdVsListDoubleMap.containsKey(objGoal.id))
				{
					if(className == 'Equity')
					{
						lstLumpsumVals = goalIdVsListDoubleMap.get(objGoal.id);
						lstLumpsumVals[0] = dblLumsumVals[iCount];
						goalIdVsListDoubleMap.put(objGoal.id,lstLumpsumVals);
					}
					else if(className == 'Debt')
					{
						lstLumpsumVals = goalIdVsListDoubleMap.get(objGoal.id);
						lstLumpsumVals[1] = dblLumsumVals[iCount];
						goalIdVsListDoubleMap.put(objGoal.id,lstLumpsumVals);
					}
					else if(className == 'Gold')
					{
						lstLumpsumVals = goalIdVsListDoubleMap.get(objGoal.id);
						lstLumpsumVals[2] = dblLumsumVals[iCount];
						goalIdVsListDoubleMap.put(objGoal.id,lstLumpsumVals);
					}
				}
			}
			
			
		}
        
        //=======================================================
  		 Map<String,List<GoalInvestmentAssetAssociation__c>> mapNameToInvestmentAsset = new Map<String,List<GoalInvestmentAssetAssociation__c>>();
		 SIPSummaryTotal = 0;
         
         String strRemark = '';
         List<Remarks__c> lstRemark = [select Remark__c from Remarks__c where entity__c =:entityId and recordtype.Name=:'EmergencyPlanning' limit 1];
         if(!lstRemark.isEmpty())
         {
            for(Remarks__c obj : lstRemark)
	       	{
	         	strRemark = obj.Remark__c;
	       	}
         }
     
         for(Goal__c goal: goalList) 
         { 
		   	  lstGoalAssetAssociation = new  List<GoalAssetAssociation__c>();
 			  GoalSIPAmount__c objGoalSIPAmount;
 			  mapNameToInvestmentAsset = new Map<String,List<GoalInvestmentAssetAssociation__c>>();
   			  lstGoalInsuranceAssociation = new List<GoalInsuranceAssociation__c>();
  			  lstGoalInvestmentAssetAssociation = new List<GoalInvestmentAssetAssociation__c>();
  			  List<Approve_Action_Plan__c> lstPlan = new List<Approve_Action_Plan__c>();
  			  List<Approve_Action_Plan__c> lstPlanForLumpsum = new List<Approve_Action_Plan__c>();
  			  List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
  			  String strAssignedToOps = ''; 
  			  String strFormsProvided = ''; 
  			  String ETStatus = '';
  			  
  			  double installments=0;
  			  String option ='';
  			  String remarks = '';
  			  String productName='' ;
  			  String transactionType='';
  			  String category='';
  			  double amount=0;
  			  double AssetsTotal = 0;
  			
	          string description = goal.Description__c;
	          String startYear = goal.Goal_Start_Year__c;
	          String endYear = goal.Goal_End_Year__c;
	          double annualGoalCost = goal.Cost_of_Goal_Annual__c;
	          //String goalProfile = goal.SelectedGoalProfile__r.Name;
              // String goalProfile = goal.Description__c == 'Emergency Fund'? 'Conservative' : goal.SelectedGoalProfile__r.Name;
              String goalProfile = goal.Goal_Type__c == 'Emergency Fund'? 'Conservative' : goal.SelectedGoalProfile__r.Name;
         	  //String remark = goal.Remark__c;
	          //String remark = goal.Description__c == 'Emergency Fund'? strRemark : goal.Remark__c;
              String remark = goal.Goal_Type__c == 'Emergency Fund'? strRemark : goal.Remark__c;
              String goalType = goal.Goal_Type__c;

	          //SIP declaration
	          string strEquityAmt;
	          double debtAmt = 0;
	          double SIP = 0;
	       	  double equityAmt = 0;
	    	  double goldAmt = 0;
	    	  double equityPerc = 0;
	    	  double debtPerc = 0;
	    	  double goldPerc = 0;
	    	  boolean execTracker = false;
	    	  String executionTracker = '';
	    	  
	    	  
	    	  //Lumpsum declaration
	    	  double lumpsumDebtAmt = 0;
	          double lumpsum = 0;
	       	  double lumpsumEquityAmt = 0;
	    	  double lumpsumGoldAmt = 0;
	    	  double lumpsumEquityPerc = 0;
	    	  double lumpsumDebtPerc = 0;
	    	  double lumpsumGoldPerc = 0;
	    	  
	    	  //Lumpsum Funds declaration
	    	  double lumpsumInstallments=0;
  			  String lumpsumOption ='';
  			  String lumpsumRemarks = '';
  			  String lumpsumProductName='' ;
  			  String lumpsumTransactionType='';
  			  String lumpsumCategory='';
  			  double lumpsumAmount=0;
  			  String lumpsumFund='';
  			  double lumpsumAmountPerInstall=0;
	    	  String lumpsumExecutionTracker = '';
	    	  boolean lumpsumExecTracker = false;
	    	  
		    	  
	          if(goalIdVsGoalSIPAmount.containsKey(goal.Id))
	          {
	          	
	          		objGoalSIPAmount = goalIdVsGoalSIPAmount.get(goal.Id);
	          		if(objGoalSIPAmount != null)
	          		{
	          			//strDebtAmt = string.valueOf(objGoalSIPAmount.SIP_Debt__c);
	          			SIP = objGoalSIPAmount.SIP_Total__c;
	          			equityAmt = objGoalSIPAmount.SIP_Equity__c;
	          			debtAmt = objGoalSIPAmount.SIP_Debt__c;
	          			goldAmt = objGoalSIPAmount.SIP_Gold__c;
	          			if(SIP !=0)
	          			{
	          				equityPerc = (equityAmt * 100)/SIP;
	          				debtPerc = (debtAmt * 100)/SIP;
	          				goldPerc = (goldAmt * 100)/SIP;
	          			}
	          		}
	          }
	         
	         //=========================Emergency Funds Lumpsum=======================
	       List<Approve_Action_Plan__c> lstLumpsum = new  List<Approve_Action_Plan__c>();
	       //if(goal.Description__c == 'Emergency Fund')
	       if(goal.Goal_Type__c == 'Emergency Fund')
	       {
      			if(mapGoalIdToEmergencyLumpsumAppActionPlan.containsKey(goal.Id))
      			{
      				lstLumpsum = mapGoalIdToEmergencyLumpsumAppActionPlan.get(goal.Id);
      				for(Approve_Action_Plan__c objLumpsum : lstLumpsum)
      				{
      					if(objLumpsum.Lumpsum_Equity__c != null)
      					{
	          				lumpsumEquityAmt = objLumpsum.Lumpsum_Equity__c;
		          			lumpsumDebtAmt = objLumpsum.Lumpsum_Debt__c;
		          			lumpsumGoldAmt = objLumpsum.Lumpsum_Gold__c;
		          			lumpsum = lumpsumEquityAmt+lumpsumDebtAmt+lumpsumGoldAmt;
		          			if(lumpsum !=0)
		          			{
		          				lumpsumEquityPerc = (lumpsumEquityAmt * 100)/lumpsum;
		          				lumpsumDebtPerc = (lumpsumDebtAmt * 100)/lumpsum;
		          				lumpsumGoldPerc = (lumpsumGoldAmt * 100)/lumpsum;
		          			}
		          			objEmergencyLumpsumActionPlanGoalDetails = approvedPlanBean.populateEmergencyLumpsumDetails(goal.Id,lumpsumEquityAmt,
         												lumpsumDebtAmt,lumpsumGoldAmt,lumpsum,lumpsumEquityPerc,lumpsumDebtPerc,lumpsumGoldPerc); 
      					}
      				}
      			}
      			else
      			{
      				    lumpsumEquityAmt = 0;
	          			lumpsumDebtAmt = 0;
	          			lumpsumGoldAmt = 0;
	          			lumpsum = 0;
          				lumpsumEquityPerc = 0;
          				lumpsumDebtPerc = 0;
          				lumpsumGoldPerc = 0;
	          			
	          			objEmergencyLumpsumActionPlanGoalDetails = approvedPlanBean.populateEmergencyLumpsumDetails(goal.Id,lumpsumEquityAmt,
     												lumpsumDebtAmt,lumpsumGoldAmt,lumpsum,lumpsumEquityPerc,lumpsumDebtPerc,lumpsumGoldPerc); 
      			}
	         }
	       
	         //========================================================================
	         //Lumpsum
	         List<Double> objLumpsums = new List<Double>();
	         if(goalIdVsListDoubleMap.containsKey(goal.Id))
	         {
	          		objLumpsums = goalIdVsListDoubleMap.get(goal.Id);
	          		if(objLumpsums != null)
	          		{
		          			lumpsumEquityAmt = objLumpsums[0];
		          			lumpsumDebtAmt = objLumpsums[1];
		          			lumpsumGoldAmt = objLumpsums[2];
		          			lumpsum = lumpsumEquityAmt+lumpsumDebtAmt+lumpsumGoldAmt;
		          			if(lumpsum !=0)
		          			{
		          				lumpsumEquityPerc = (lumpsumEquityAmt * 100)/lumpsum;
		          				lumpsumDebtPerc = (lumpsumDebtAmt * 100)/lumpsum;
		          				lumpsumGoldPerc = (lumpsumGoldAmt * 100)/lumpsum;
		          			}
	          		}
	          }
	          
	          objActionPlanGoalDetails = approvedPlanBean.populateGoalList (goal.IRR__c,goal.Id,description,startYear,endYear,
																		          annualGoalCost,goalProfile,remark,equityAmt,debtAmt,goldAmt,SIP,equityPerc,debtPerc,goldPerc,lumpsumEquityAmt,
																		          lumpsumDebtAmt,lumpsumGoldAmt,lumpsum,lumpsumEquityPerc,lumpsumDebtPerc,lumpsumGoldPerc,goalType); 
	          
	          //=============SIP Funds & Lumpsum Funds========================================================== 	
		        SIPtotal = 0;
		       	if(mapGoalIdToAppActionPlan.containsKey(goal.id))
      			{
      			 	lstPlan = mapGoalIdToAppActionPlan.get(goal.id);
      			 	for(Approve_Action_Plan__c objPlan : lstPlan)
      			 	{
      			 		 ETStatus = '';
      			 		 if(mapIdToExecutionTracker.containsKey(objPlan.Id))
					  	 {
							 lstET = mapIdToExecutionTracker.get(objPlan.Id);
							 for(Execution_Tracker__c objET : lstET)
							 {
							 	strAssignedToOps = objET.AssignToOps__c ? 'Yes' : 'No';
							 	strFormsProvided = objET.isFormProvidedToMET__c ? 'Yes' : 'No';
							 	if(objET.Suggested_Amount__c == objET.Total_Remaining_Balance__c && objET.Application_Status__c != 'Closed')
								  	ETStatus = Label.ET_NotExecuted; 
						 	  	else if(objET.Suggested_Amount__c > objET.Total_Remaining_Balance__c  && objET.Application_Status__c != 'Closed')
							  	  	ETStatus = Label.ET_PartiallyExecuted;
						  	  	else if(objET.Total_Remaining_Balance__c == objET.Agreed_Amount__c && objET.Executed_Amount__c == objET.Agreed_Amount__c )
							  	  	ETStatus = Label.ET_FullyExecuted;
							 }
					  	 }
      			 		 installments = objPlan.Installments__c;
				         option = objPlan.Option__c;
				         remarks = objPlan.Remarks__c;
				         productName = objPlan.Product_Name__c;
				         transactionType = objPlan.Transaction_Type__c;
				         category = objPlan.Category__c;
				         amount = objPlan.Amount__c;
				         execTracker = objPlan.isSIPexecutionTracker__c;
				         if(execTracker)
		    				executionTracker = 'Yes';
		    			 else
		    				executionTracker = 'No';
				         SIPtotal = SIPtotal + amount;
				         SIPSummaryTotal = SIPSummaryTotal + amount;
	      			 	 objActionPlanGoalDetails.populateSIPFunds(productName,transactionType,amount,installments,
	      			 	 					category,option,remarks,execTracker,executionTracker,objPlan.Id,strAssignedToOps,strFormsProvided,ETStatus);
      			 	}
      			}
      			
      			approvedPlanBean.SIPSummaryTotal = SIPSummaryTotal;
      			double Lumpsumtotal = 0;
      			strAssignedToOps = '';
      			strFormsProvided = '';
      			ETStatus = '';
      			if(mapGoalIdToLumpsumAppActionPlan.containsKey(goal.id))
      			{
      			 	lstPlanForLumpsum = mapGoalIdToLumpsumAppActionPlan.get(goal.id);
      			 	for(Approve_Action_Plan__c objPlan : lstPlanForLumpsum)
      			 	{
      			 	   ETStatus = '';
  			 		   lumpsumInstallments = objPlan.Installments__c;
		        	   lumpsumOption = objPlan.Option__c;
		       		   lumpsumRemarks = objPlan.Remarks__c;
		        	   lumpsumProductName = objPlan.Product_Name__c;
		         	   lumpsumTransactionType = objPlan.Transaction_Type__c;
		        	   lumpsumCategory = objPlan.Category__c;
		        	   lumpsumAmount = objPlan.Amount__c;
		        	   lumpsumFund = objPlan.Fund__c;
		        	   lumpsumAmountPerInstall = objPlan.Amount_Per_Installment__c;
		        	   lumpsumExecTracker = objPlan.isLumpsumExecTracker__c;
		        	   if(mapIdToExecutionTracker.containsKey(objPlan.Id))
				  	   {
						   lstET = mapIdToExecutionTracker.get(objPlan.Id);
						   for(Execution_Tracker__c objET : lstET)
						   {
						   		strAssignedToOps = objET.AssignToOps__c ? 'Yes' : 'No';
						   		strFormsProvided = objET.isFormProvidedToMET__c ? 'Yes' : 'No';
						   		if(objET.Suggested_Amount__c == objET.Total_Remaining_Balance__c && objET.Application_Status__c != 'Closed')
								  	ETStatus = Label.ET_NotExecuted; 
						 	  	else if(objET.Suggested_Amount__c > objET.Total_Remaining_Balance__c  && objET.Application_Status__c != 'Closed')
							  	  	ETStatus = Label.ET_PartiallyExecuted;
						  	  	else if(objET.Total_Remaining_Balance__c == objET.Agreed_Amount__c && objET.Executed_Amount__c == objET.Agreed_Amount__c )
							  	  	ETStatus = Label.ET_FullyExecuted;
						   		
						   }
				  	   }
			           if(lumpsumExecTracker)
		    			   lumpsumExecutionTracker = 'Yes';
		    		   else
		    			   lumpsumExecutionTracker = 'No';
		        	   Lumpsumtotal = Lumpsumtotal + lumpsumAmount;
  			 		   objActionPlanGoalDetails.populateLumpsumFunds(lumpsumProductName,lumpsumTransactionType,lumpsumAmount,lumpsumInstallments,lumpsumCategory,lumpsumOption,lumpsumRemarks,lumpsumFund,lumpsumAmountPerInstall
  			 		   												,lumpsumExecTracker,lumpsumExecutionTracker,objPlan.Id,strAssignedToOps,strFormsProvided,ETStatus);
  			   	  	}
  			 	}
  			 	else if(mapGoalIdToEmergencyLumpsumAppActionPlan.containsKey(goal.Id))
  			 	{
  			 		lstPlanForLumpsum = mapGoalIdToEmergencyLumpsumAppActionPlan.get(goal.id);
      			 	for(Approve_Action_Plan__c objPlan : lstPlanForLumpsum)
      			 	{
      			 		ETStatus = '';
      			 		if(objPlan.Amount__c != null)
      			 		{  
		  			 		   lumpsumInstallments = objPlan.Installments__c;
				        	   lumpsumOption = objPlan.Option__c;
				       		   lumpsumRemarks = objPlan.Remarks__c;
				        	   lumpsumProductName = objPlan.Product_Name__c;
				         	   lumpsumTransactionType = objPlan.Transaction_Type__c;
				        	   lumpsumCategory = objPlan.Category__c;
				        	   lumpsumAmount = objPlan.Amount__c;
				        	   lumpsumFund = objPlan.Fund__c;
				        	   lumpsumAmountPerInstall = objPlan.Amount_Per_Installment__c;
				        	   lumpsumExecTracker = objPlan.isLumpsumExecTracker__c;
				        	   if(mapIdToExecutionTracker.containsKey(objPlan.Id))
					  	   	   {	
							   		lstET = mapIdToExecutionTracker.get(objPlan.Id);
							   		for(Execution_Tracker__c objET : lstET)
							   		{
							   			strAssignedToOps = objET.AssignToOps__c ? 'Yes' : 'No';
							   			strFormsProvided = objET.isFormProvidedToMET__c ? 'Yes' : 'No';
							   			if(objET.Suggested_Amount__c == objET.Total_Remaining_Balance__c && objET.Application_Status__c != 'Closed')
										  	ETStatus = Label.ET_NotExecuted; 
								 	  	else if(objET.Suggested_Amount__c > objET.Total_Remaining_Balance__c  && objET.Application_Status__c != 'Closed')
									  	  	ETStatus = Label.ET_PartiallyExecuted;
								  	  	else if(objET.Total_Remaining_Balance__c == objET.Agreed_Amount__c && objET.Executed_Amount__c == objET.Agreed_Amount__c )
									  	  	ETStatus = Label.ET_FullyExecuted;
							   		}
					  	   	   }
						       if(lumpsumExecTracker)
				    		   		lumpsumExecutionTracker = 'Yes';
				    		   else
				    				lumpsumExecutionTracker = 'No';
				        	   Lumpsumtotal = Lumpsumtotal + lumpsumAmount;
		  			 		   objActionPlanGoalDetails.populateLumpsumFunds(lumpsumProductName,lumpsumTransactionType,lumpsumAmount,lumpsumInstallments,lumpsumCategory,lumpsumOption,lumpsumRemarks,lumpsumFund,lumpsumAmountPerInstall
		  			 		   												 ,lumpsumExecTracker,lumpsumExecutionTracker,objPlan.Id,strAssignedToOps,strFormsProvided,ETStatus);
      			 		}
  			   	  	}
  			 	}
  			 	objActionPlanGoalDetails.SIPTotal = SIPtotal;
  				objActionPlanGoalDetails.LumpsumTotal = Lumpsumtotal;
  				
      		  //=========================================================================================================================
	        
	          //AssetAssociation
	          strAssetDescription = '';
	          double dblAssetExpectedGrowthRate = 10.0d;
	          double dblAssetInterestRate = 0;
	          double dblAssetGoalYearValue = 0;
	          String strAssetAction = '';
	          String strAssetType = '';
	          String strAssetOwner = '';
	          
	          //goalAssetMappingMap returns map of GoalId to different assets allocated for particular goal
	          if(goalAssetMappingMap.containsKey(goal.id))
	          {
	          	  	Map<Id,Asset__c> mapIdToAsset = new Map<Id,Asset__c>();
	          		lstGoalAssetAssociation = goalAssetMappingMap.get(goal.id);
		          	if(lstGoalAssetAssociation != null)
	    	      	{
	        	  		for(GoalAssetAssociation__c objGoalAssetAssociation : lstGoalAssetAssociation)
	          			{
	          				for(Asset__c asset : assetList) 
	          			 	{      
	          					if(!mapIdToAsset.containsKey(asset.Id))
		          				{
		          					mapIdToAsset.put(asset.Id,asset);
		          				}
	          			 	}

			          		if(objGoalAssetAssociation.asset__r.Action__c != '---None----')
			          		{
			          			
				          		if(mapIdToAsset.ContainsKey(objGoalAssetAssociation.Asset__r.Id))
			          			{
			          				
				          			if(objGoalAssetAssociation.Asset__r.RecordType.Name == 'Govt. Saving Schemes' ||
				          			    objGoalAssetAssociation.Asset__r.RecordType.Name == 'Retirement Accounts'|| 
				          			    objGoalAssetAssociation.Asset__r.RecordType.Name == 'Deposits With Bank')
						            {
						            	strAssetDescription = (objGoalAssetAssociation.Asset__r.RecordType.Name == 'Deposits With Bank') ? 
						            					((objGoalAssetAssociation.Asset__r.Bank_Name__c != null) ? 
						            					(objGoalAssetAssociation.Asset__r.Bank_Name__c + ' - ' + objGoalAssetAssociation.Asset__r.Account_Number__c) 
						            					: (objGoalAssetAssociation.Asset__r.Account_Number__c))	
						            					: (objGoalAssetAssociation.Asset__r.Account_Number__c);
						            }
						            else
						            	strAssetDescription = (objGoalAssetAssociation.Asset__r.Description__c);
				          				
				          			
					          		if(objGoalAssetAssociation.Asset__r.Asset_Types__c!=null && objGoalAssetAssociation.Asset__r.Asset_Types__c!='')
					          		{
					                	strAssetType = objGoalAssetAssociation.Asset__r.Asset_Types__c;
					                }
					                else
					                {
					                    strAssetType = objGoalAssetAssociation.Asset__r.Account_Type__c;
					                }
					                
					          		if(objGoalAssetAssociation.asset__r.entity__r.LastName == null)
					          		{
					          			strAssetOwner = objGoalAssetAssociation.asset__r.entity__r.FirstName;
					          		}
					          		else if(objGoalAssetAssociation.asset__r.entity__r.FirstName == null )
					          		{
					          			strAssetOwner = objGoalAssetAssociation.asset__r.entity__r.LastName;
					          		}
					          		else if(objGoalAssetAssociation.asset__r.entity__r.LastName != null && objGoalAssetAssociation.asset__r.entity__r.FirstName != null)
					          		{
					          			strAssetOwner = objGoalAssetAssociation.asset__r.entity__r.FirstName +' '+objGoalAssetAssociation.asset__r.entity__r.LastName;
					          		}
					          		else
					          		{
					          			strAssetOwner = '';
					          		}
					          		double allocatedAmount = 0;
					          		availableAmount = 0; 
					          		double amountAllocated = 0;
					          		
						          	strAssetAction = objGoalAssetAssociation.asset__r.action__c;
						          	dblAssetGoalYearValue = objGoalAssetAssociation.GoalYearValue__c;
						          	amountAllocated =objGoalAssetAssociation.Allocation__c ;
					                AssetsTotal = AssetsTotal + amountAllocated;
					          		dblAssetExpectedGrowthRate = (objGoalAssetAssociation.asset__r.Expected_Growth_Rate__c != null ? 
					          										objGoalAssetAssociation.asset__r.Expected_Growth_Rate__c : 0 );
					          		
								    if(objGoalAssetAssociation.asset__r.RecordType.Name.equals('Deposits With Bank') || 
								    	objGoalAssetAssociation.asset__r.RecordType.Name.equals('Retirement Accounts')||
								    	objGoalAssetAssociation.asset__r.RecordType.Name.equals('Govt. Saving Schemes'))
				                    {
			                           	if(objGoalAssetAssociation.asset__r.Interest_Rate__c != null)
				                              dblAssetInterestRate = Double.valueOf(String.valueOf(objGoalAssetAssociation.asset__r.Interest_Rate__c));
				                        else
			                            {
			                                 dblAssetInterestRate = 0;
			                                 setInfoMessage('Please fill the Interest rate for allocated asset: '+objGoalAssetAssociation.asset__r.RecordType.Name);
			                            }
			                        }
			                        else
			                            	 dblAssetInterestRate = Double.valueOf(String.valueOf(objGoalAssetAssociation.asset__r.CalculatedInterestRate__c));
					                if(dblAssetInterestRate == null) 
				                    {
		                                  	setInfoMessage('Interest Rate is not valid for some assets.');
				                    		continue;
				                	}
			                  	 	if(objGoalAssetAssociation.asset__r.RecordType.Name.equals('Real Estate Assets') || 
			                     	objGoalAssetAssociation.asset__r.RecordType.Name.equals('Business Assets') || 
				                    objGoalAssetAssociation.asset__r.RecordType.Name.equals('Personal Assets'))
				                   	{
				                    	 	dblAssetInterestRate = dblAssetExpectedGrowthRate;
				                   	}
					          		objActionPlanAllocatedAssets = objActionPlanGoalDetails.populateAllocatedAssets(strAssetDescription,strAssetType,strAssetOwner,amountAllocated,availableAmount,dblAssetGoalYearValue,strAssetAction,dblAssetInterestRate);
			          			}
				         	}	
	          	 	 	}
	          		}
	          }	
	         //End of Asset ============================================================================================================
	         //Insurance =========================================================================================================================
             strInsuranceDescription = '';
	         strInsuranceType = '';
	         String strPolicyType = '';
	         String strInsuranceOwner = '';
	         double dblInsuranceExpectedGrowthRate = 0;
	         double dblInsuranceGoalYearValue = 0;
	         string strInsuranceAction = '';
	         if(goalInsuranceMappingMap.containsKey(goal.id))
	         {
	          	 lstGoalInsuranceAssociation = goalInsuranceMappingMap.get(goal.id);
	          	 if(lstGoalInsuranceAssociation != null)
	          	 {
	          	 	 for(GoalInsuranceAssociation__c objGoalInsuranceAssociation : lstGoalInsuranceAssociation)
	          	 	 {
		          		if(objGoalInsuranceAssociation.Insurance__r.Action__c != '---None----')
		          		{
			              	strInsuranceType = objGoalInsuranceAssociation.Insurance__r.Policy_Type__c;
			          		String InsuranceDescription = null;
			          		Map<Id,Insurance__c> MapIdToInsurance = new Map<Id,Insurance__c>();
		       				for(Insurance__c insurance : insuranceList) 
		       				{
		       				 	
		       				 	if(!MapIdToInsurance.ContainsKey(insurance.Id))
		       				 	{
		       				 		MapIdToInsurance.put(insurance.Id,insurance);
		       				 	}
		       				}
		       				if(MapIdToInsurance.ContainsKey(objGoalInsuranceAssociation.Insurance__r.Id))
		       				{	
						        if(objGoalInsuranceAssociation.Insurance__r.Insurance_Company__c != null)
								{
									if(objGoalInsuranceAssociation.Insurance__r.Policy_Name__c != null)
									{
										strInsuranceDescription = objGoalInsuranceAssociation.Insurance__r.Policy_Number__c != null ? 
																(objGoalInsuranceAssociation.Insurance__r.Insurance_Company__c + ' -- ' + objGoalInsuranceAssociation.Insurance__r.Policy_Name__c + ' -- ' + objGoalInsuranceAssociation.Insurance__r.Policy_Number__c)
																:(objGoalInsuranceAssociation.Insurance__r.Insurance_Company__c + ' -- ' + objGoalInsuranceAssociation.Insurance__r.Policy_Name__c);
									}
									else
									{
										strInsuranceDescription = objGoalInsuranceAssociation.Insurance__r.Policy_Number__c != null ? 
																(objGoalInsuranceAssociation.Insurance__r.Insurance_Company__c + ' -- ' + objGoalInsuranceAssociation.Insurance__r.Policy_Number__c) 
																: (objGoalInsuranceAssociation.Insurance__r.Insurance_Company__c);
									}							
								}
								else
								{
									if(objGoalInsuranceAssociation.Insurance__r.Policy_Name__c != null)
									{
										strInsuranceDescription = objGoalInsuranceAssociation.Insurance__r.Policy_Number__c != null ? 
																(objGoalInsuranceAssociation.Insurance__r.Policy_Name__c + ' -- ' + objGoalInsuranceAssociation.Insurance__r.Policy_Number__c) 
																: objGoalInsuranceAssociation.Insurance__r.Policy_Name__c;
									}
									else if(objGoalInsuranceAssociation.Insurance__r.Policy_Number__c != null)
									{
										strInsuranceDescription = objGoalInsuranceAssociation.Insurance__r.Policy_Number__c;
									}											
								}
	       				 	}
       				 		if(objGoalInsuranceAssociation.Insurance__r.entity__r.LastName == null)
			          		{
			          			strInsuranceOwner = objGoalInsuranceAssociation.Insurance__r.entity__r.FirstName;
			          		}
			          		else if(objGoalInsuranceAssociation.Insurance__r.entity__r.FirstName == null )
			          		{
			          			strInsuranceOwner = objGoalInsuranceAssociation.Insurance__r.entity__r.LastName;
			          		}
			          		else if(objGoalInsuranceAssociation.Insurance__r.entity__r.LastName != null && objGoalInsuranceAssociation.Insurance__r.entity__r.FirstName != null)
			          		{
			          			strInsuranceOwner = objGoalInsuranceAssociation.Insurance__r.entity__r.FirstName +' '+ objGoalInsuranceAssociation.Insurance__r.entity__r.LastName;
			          		}
			          		else
			          		{
			          			strInsuranceOwner = '';
			          		}
	       				 
			          		double allocatedAmount = 0;
			          		availableAmount = 0; 
			          		allocatedAmount = objGoalInsuranceAssociation.Allocated__c;
			          		strInsuranceAction = objGoalInsuranceAssociation.Insurance__r.action__c;
			          		dblInsuranceGoalYearValue = objGoalInsuranceAssociation.GoalYearValue__c;
			          		
			          		Double CurrentVal;
			          		double amountAllocated = 0;
			          		balanceRemaining = 0;
			          		Integer iTenureOfInsurance = 0;
			          		if(goalInsuranceMap.containsKey(objGoalInsuranceAssociation.Insurance__c))
	                        {
	                        	AssetAllocationService objAssetAllocationService = new AssetAllocationService();
		                		Insurance__c objInsurance =goalInsuranceMap.get(objGoalInsuranceAssociation.Insurance__c);
		                		Double dblOneInstallmentPremiumAmount = 0;
		                		
		                		if(!objInsurance.Premium_Frequency__c.equals('One Time Premium'))
				 				{
				 					dblOneInstallmentPremiumAmount = objInsurance.Premium_Amount_Rs__c;
				 				}
				 				if(objInsurance.Tenure_of_Insurance__c != null)
					 			{
					 				iTenureOfInsurance = Integer.valueOf(objInsurance.Tenure_of_Insurance__c);
					 			}
					 			
					 			Integer iMaturityYear = iTenureOfInsurance + objInsurance.Commencement_Date__c.year();
					 			Integer iCurrentYearForCalculation = 0;
					 			 /* Aditi - FP changes - 04-03-2013 - Changed Date.Today() to Plan_Generation_Date__c - currentYear*/
				 				if(currentYear > iMaturityYear)
				 				{
				 					iCurrentYearForCalculation = iMaturityYear;
				 				}
				 				else
				 				{
				 					iCurrentYearForCalculation = currentYear;
				 				}
				 				Integer totalPeriodInYears =  iCurrentYearForCalculation - objInsurance.Commencement_Date__c.year();//
				 				if(objInsurance.Surrender_Cash_Value__c == null)
							 	{
							 		CurrentVal = objAssetAllocationService.GetInsuranceAmountForPeriod(objInsurance,totalPeriodInYears, dblOneInstallmentPremiumAmount);
							 	}else
							 	{
							 		CurrentVal = objInsurance.Surrender_Cash_Value__c;
							 	}
							 	
							 	Double dblAllocated = allocatedAmount;
							 	amountAllocated = (dblAllocated * CurrentVal)/100 ; 
							 	
							 	if(CurrentVal != null)
			          			{
			          				balanceRemaining = CurrentVal - amountAllocated;
			          			}else
			          			{
			          				balanceRemaining = 0;
			          			}
			          			
			          			strPolicyType = objInsurance.Policy_Type__c;
								dblInsuranceExpectedGrowthRate  = LifeInsuranceInterest__c.getInstance(strPolicyType).Rate__c;	
	                        }
	                        else
	                        	CurrentVal = 0; 
	                       
			          		AssetsTotal = AssetsTotal + amountAllocated;
			          		objActionPlanAllocatedAssets = objActionPlanGoalDetails.populateAllocatedAssets(strInsuranceDescription,strInsuranceType,strInsuranceOwner,amountAllocated,availableAmount,dblInsuranceGoalYearValue,strInsuranceAction,dblInsuranceExpectedGrowthRate);
			          		
	          	 		}
	          		
	         		  }
	          	
	          		}
	        
	           }
	   		//End of Insurance ===============================================================================================================          
	      
	   		//InvestmentAsset===============================================================================================================          
		   		 strInvestmentType = '';
   				 strInvestmentDescription = '';
   				 String strInvestmentOwner = '';
   				 String strInvestmentAction = '';
   				 double dblInvestmentExpectedGrowthRate = 0;
   				 double dblInvestmentGoalYearValue = 0;
	          	 double dblAllocatedAmt = 0;		
	          	 double dblAmountAllocated = 0;
	          	 String strInvestmentRecordType = '';
	          	 double dblInvestmentCurrentValue = 0;
	          	 boolean isNotIncome = false;
	   			 if(goalInvestmentAssetMappingMap.containsKey(goal.id))
	   			 {
	   				 
		   				lstGoalInvestmentAssetAssociation = goalInvestmentAssetMappingMap.get(goal.id);
		   				if(lstGoalInvestmentAssetAssociation != null)
		   				{
		   					for(GoalInvestmentAssetAssociation__c objGoalInvestmentAssetAssociation : lstGoalInvestmentAssetAssociation)
		          	 		{
		          	 			if(objGoalInvestmentAssetAssociation.Investment_asset__r.RecordType.Name == 'Fixed Income')
		          	 			{
			   						if(objGoalInvestmentAssetAssociation.Investment_asset__r.Action__c != '---None----')
							        { 
							        	strInvestmentType = objGoalInvestmentAssetAssociation.Investment_asset__r.RecordType.Name;
							        	if(objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.LastName == null)
						          		{
						          			strInvestmentOwner = objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.FirstName;
						          		}
						          		else if(objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.FirstName == null )
						          		{
						          			strInvestmentOwner = objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.LastName;
						          		}
						          		else if(objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.LastName != null && objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.FirstName != null)
						          		{
						          			strInvestmentOwner = objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.FirstName +' '+ objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.LastName;
						          		}
						          		else
						          		{
						          			strInvestmentOwner = '';
						          		}
							        	
							        	dblAllocatedAmt = objGoalInvestmentAssetAssociation.Allocated__c;
							        	dblInvestmentCurrentValue = objGoalInvestmentAssetAssociation.Investment_asset__r.TotalAsset__c ;
							        	dblAmountAllocated = (dblInvestmentCurrentValue *  dblAllocatedAmt)/100;
							        	/* Prajakta - FP changes - 26-02-2013 */
							        	if(objGoalInvestmentAssetAssociation.Investment_asset__r.Maturity_Date__c != null)
							        	{
							        		Datetime dtReport = objGoalInvestmentAssetAssociation.Investment_asset__r.Maturity_Date__c;
											String strDate = dtReport.day() + '-' + dtReport.month() + '-' + dtReport.year();
					                		strInvestmentDescription = objGoalInvestmentAssetAssociation.Investment_asset__r.Description__c + ' -- ' + strDate; 
							        	}
					                	else
					                	{
					                		strInvestmentDescription = objGoalInvestmentAssetAssociation.Investment_asset__r.Description__c;
					                	}
							        	
							        	dblInvestmentGoalYearValue = objGoalInvestmentAssetAssociation.GoalYearValue__c;
							        	strInvestmentAction = objGoalInvestmentAssetAssociation.Investment_asset__r.action__c;
							        	strInvestmentRecordType =  objGoalInvestmentAssetAssociation.investment_Asset__r.recordType.Name;
					                    if(strInvestmentRecordType.equals('Stocks'))
					                    {   
				                           	dblInvestmentExpectedGrowthRate =  globalAssumptions.Stock_Growth_Rate__c;
					                    }
					                    /* Prajakta - FP changes - 01-04-2013 */
			                            else if(strInvestmentRecordType.equals('Gold'))    
			                            {   
			                            	dblInvestmentExpectedGrowthRate =  globalAssumptions.Gold_Growth_Rate__c;
			                            }
					                    else
				                            dblInvestmentExpectedGrowthRate = globalAssumptions.Income_Growth_Rate__c;
							        }
							        AssetsTotal = AssetsTotal + dblAmountAllocated;
		          	 				objActionPlanAllocatedAssets = objActionPlanGoalDetails.populateAllocatedAssets(strInvestmentDescription,strInvestmentType,strInvestmentOwner,dblAmountAllocated,availableAmount,dblInvestmentGoalYearValue,strInvestmentAction,dblInvestmentExpectedGrowthRate);
		   			
		          	 			}
		          	 			else
		          	 			{
		          	 				if(objGoalInvestmentAssetAssociation.Investment_asset__r.Action__c != '---None----')
							        { 
			          	 				 if(mapNameToInvestmentAsset.containsKey(objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.FirstName+' '+objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.LastName+objGoalInvestmentAssetAssociation.Investment_asset__r.RecordType.Name))
							             {
							             	List<GoalInvestmentAssetAssociation__c> lstRelatedInvAsset = new List<GoalInvestmentAssetAssociation__c>(); 
							             	lstRelatedInvAsset = mapNameToInvestmentAsset.get(objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.FirstName+' '+objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.LastName+objGoalInvestmentAssetAssociation.Investment_asset__r.RecordType.Name);
							             	lstRelatedInvAsset.add(objGoalInvestmentAssetAssociation);
							             	mapNameToInvestmentAsset.put(objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.FirstName+' '+objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.LastName+objGoalInvestmentAssetAssociation.Investment_asset__r.RecordType.Name,lstRelatedInvAsset);
							             }
							             else
							             {
							             	List<GoalInvestmentAssetAssociation__c> lstRelatedInvAsset = new List<GoalInvestmentAssetAssociation__c>();
							             	lstRelatedInvAsset.add(objGoalInvestmentAssetAssociation);
							             	mapNameToInvestmentAsset.put(objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.FirstName+' '+objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.LastName+objGoalInvestmentAssetAssociation.Investment_asset__r.RecordType.Name,lstRelatedInvAsset);
							             }
							             
							        }
		          	 			}
		          	 			
		          	 		}
		   				system.debug('***mapNameToInvestmentAsset****'+mapNameToInvestmentAsset.keySet());
		          	 		List<GoalInvestmentAssetAssociation__c> lstGoalInvestmentAsset = new List<GoalInvestmentAssetAssociation__c>();
		          	 		for(String strEntityName : mapNameToInvestmentAsset.keySet())
					        {
			         			CurrentValue = 0;
			         			CurrentTotalValue = 0;
			         			dblAmountAllocated = 0;
			  					lstGoalInvestmentAsset = mapNameToInvestmentAsset.get(strEntityName);
			  					system.debug('***strEntityName****'+strEntityName);
			  					system.debug('***lstGoalInvestmentAsset****'+lstGoalInvestmentAsset);
			  					for(GoalInvestmentAssetAssociation__c objGoalInvest : lstGoalInvestmentAsset )
			  					{
			  						if(objGoalInvest.Goal__c == goal.id)
			  						{
			  							isNotIncome = true;
				  						strInvestmentDescription = '-';      
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
						              	strInvestmentDescription = '-';    	
					          			strInvestmentType = objGoalInvest.Investment_asset__r.RecordType.Name;	    
					          			strInvestmentAction = objGoalInvest.Investment_asset__r.action__c;
							        	strInvestmentRecordType =  objGoalInvest.investment_Asset__r.recordType.Name;
							        	dblInvestmentCurrentValue = objGoalInvest.Investment_asset__r.TotalAsset__c ;
					        			dblAmountAllocated = dblAmountAllocated + (dblInvestmentCurrentValue *  dblAllocatedAmt)/100;
					                    if(strInvestmentRecordType.equals('Stocks'))
					                    {   
				                           	dblInvestmentExpectedGrowthRate =  globalAssumptions.Stock_Growth_Rate__c;
					                    }
					                    /* Prajakta - FP changes - 01-04-2013 */
			                            else if(strInvestmentRecordType.equals('Gold'))    
			                            {   
			                            	dblInvestmentExpectedGrowthRate =  globalAssumptions.Gold_Growth_Rate__c;
			                            }
					                    else
				                            dblInvestmentExpectedGrowthRate = globalAssumptions.Income_Growth_Rate__c;   
						      			
						      			dblInvestmentGoalYearValue = objGoalInvest.GoalYearValue__c;
			  						}
			        			}
			        			if(isNotIncome)
			        			{
			        				system.debug('****in isNotIncome****');
				        			AssetsTotal = AssetsTotal + dblAmountAllocated;
	          	 					objActionPlanAllocatedAssets = objActionPlanGoalDetails.populateAllocatedAssets(strInvestmentDescription,strInvestmentType,strInvestmentOwner,dblAmountAllocated,availableAmount,dblInvestmentGoalYearValue,strInvestmentAction,dblInvestmentExpectedGrowthRate);
			        			}
					        } 
		          	 		
	   					}
	   		 }
	       //End of InvestmentAsset ===============================================================================================================          
	       		objActionPlanGoalDetails.AssetsTotal = AssetsTotal;
	       }
    }
    
    
    /**
    * @Description: Get family details for parent entity
    * param: None 
    * return type: void
    */  
    public void getFamilyDetails(ApprovedPlanBean beanObj){
        beanObj.accList = dbSOQLObj.getFamilyDetails(beanObj.entityId);
    }
    
    /**
    * @Description: Get goals for the parent entity
    * param: void
    * return type: void
    */ 
    public void getGoals(ApprovedPlanBean beanObj){
         beanObj.goalList = dbSOQLObj.getAllGoals(beanObj.entityId);
    }
    
    
    /**
    * @Description: Prpeare Lumpsum total and SIP Total
    * param: ApprovedPlanBean 
    * return type: void
    */
    public void PrpeareSuggested(ApprovedPlanBean beanObj){
        List<AggregateResult> goalInassetList = dbSOQLObj.getInvestAssociationSum(beanObj.accList);
        List<AggregateResult> goalAssetList = dbSOQLObj.getInsuranceAssociationSum(beanObj.accList);
        List<AggregateResult> goalInsurList = dbSOQLObj.getAssetAssociationSum(beanObj.accList);
        
        Set<Id> profileSet = new set<id>();
        List<String> strGoalNames = new List<String>();
        
        Map<Id,Id> golProfileMap = new Map<Id,Id>();
        Map<Id,double> golAmountMap = new Map<Id,double>();
        for(AggregateResult agObj: goalInassetList){
             if((Double)agObj.get('expr0')!=null){  
                 golAmountMap.put((Id)agObj.get('Goal__c'),(Double)agObj.get('expr0'));
                 
             }
        }
        for(AggregateResult agObj: goalAssetList){
             if((Double)agObj.get('expr0')!=null){      
                 if(golAmountMap.get((Id)agObj.get('Goal__c'))!=null){
                     golAmountMap.put((Id)agObj.get('Goal__c'),golAmountMap.get((Id)agObj.get('Goal__c'))+(Double)agObj.get('expr0'));  
                 }else{
                     golAmountMap.put((Id)agObj.get('Goal__c'),(Double)agObj.get('expr0'));  
                 }
             }
        }
        for(AggregateResult agObj: goalInsurList){
             if((Double)agObj.get('expr0')!=null){  
                 if(golAmountMap.get((Id)agObj.get('Goal__c'))!=null){
                     golAmountMap.put((Id)agObj.get('Goal__c'),golAmountMap.get((Id)agObj.get('Goal__c'))+(Double)agObj.get('expr0'));  
                 }else{
                     golAmountMap.put((Id)agObj.get('Goal__c'),(Double)agObj.get('expr0'));  
                 }
             }
        }
        for(Goal__c golObj: beanObj.goalList){
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
        /** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: 00001470     	**/
		/** Date    : 1/2/2012  	**/
		/** Purpose : Code to find out the Equity,Debt,Gold percentages
		/****************************************************/
        Datetime cDT = System.now();
        Integer currentYear = Integer.valueOf(cDT.format('yyyy'));
       
        List<Id> golIds = new List<Id>();
        for(Goal__c golObj: beanObj.goalList){
            golIds.add(golObj.Id);
        }
        /** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: 00001470     	**/
		/** Date    : 1/2/2012  	**/
		/** Purpose : Code to find out the Equity,Debt,Gold percentages
		/****************************************************/
        Map<Id, double> debtValMap = new  Map<Id, double>();
        Map<Id, double> equityValMap = new  Map<Id, double>();
        Map<Id, double> goldValMap = new  Map<Id, double>();
        Map<Id, double> totValMap = new  Map<Id, double>();
        double dblTotalPerc = 0,dblDebtPerc = 0,dblEquityPerc = 0,dblGoldPerc = 0;
        //List<GoalSIPAmount__c> goalSips = dbSOQLObj.getGoalSIP(currentYear, golIds);
        List<GoalSIPAmount__c> goalSips = [select  Goal__c,Goal__r.SIP_Start_Year__c, Goal_Year__c, SIP_Debt__c, SIP_Equity__c, SIP_Gold__c, SIP_Total__c,
                          GoldCurrentYear__c,EquityCurrentYear__c,DebtCurrentYear__c
                                from GoalSIPAmount__c 
                                where SIP_Outflow__c = true 
                                AND
                                Goal__c In: golIds];
        Double dblTotalSIP = 0; 
        double tempDebt = 0,tempEquity = 0,tempGold = 0;
        for(GoalSIPAmount__c sipObj: goalSips)
        {
        	if(sipObj.Goal__r.SIP_Start_Year__c != null)  	
	        {
	        	if(Decimal.valueOf(sipObj.Goal__r.SIP_Start_Year__c) == sipObj.Goal_Year__c)
	        	{
		        	tempEquity = (sipObj.EquityCurrentYear__c == null ? 0 : sipObj.EquityCurrentYear__c);
		        	tempDebt = (sipObj.DebtCurrentYear__c == null ? 0 : sipObj.DebtCurrentYear__c);
		        	tempGold = (sipObj.GoldCurrentYear__c == null ? 0 : sipObj.GoldCurrentYear__c);
		        	dblTotalSIP = tempEquity + tempDebt + tempGold;
		        	if(dblTotalSIP > 0)
		        	{
						dblDebtPerc = sipObj.DebtCurrentYear__c / dblTotalSIP * 100;
						dblEquityPerc = sipObj.EquityCurrentYear__c / dblTotalSIP * 100;
						dblGoldPerc = sipObj.GoldCurrentYear__c / dblTotalSIP * 100;
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
	        	}
	        }
        }
        
        List<double> debtVals = prepareProfileWiseData(beanObj.goalList,golProfileMap,golProfileDebtMap, golAmountMap,debtValMap);
        List<double> equityVals = prepareProfileWiseData(beanObj.goalList,golProfileMap,golProfileEquityMap, golAmountMap,equityValMap);
        List<double> goldVals = prepareProfileWiseData(beanObj.goalList,golProfileMap,golProfileGoldMap, golAmountMap,goldValMap);
        
        ApprovedPlanBean.DoneClass asetDebt = new ApprovedPlanBean.DoneClass('Debt', debtVals);
        ApprovedPlanBean.DoneClass asetEquity = new ApprovedPlanBean.DoneClass('Equity', equityVals);
        ApprovedPlanBean.DoneClass asetGold = new ApprovedPlanBean.DoneClass('Gold', goldVals);
        beanObj.suggestedLumpSum.add(asetDebt);
        beanObj.suggestedLumpSum.add(asetEquity);
        beanObj.suggestedLumpSum.add(asetGold);   
        prepareSIPData(beanObj,goalSips);
    }
    
     /** Eternus Solutions       **/
	 /** Author  : Manasi Ranade **/
	 /** Issue Id: 00001470     	**/
	 /** Date    : 1/2/2012  	**/
	 /** Purpose : Code to find out the Equity,Debt,Gold percentages
	 /****************************************************/
     private List<double> prepareProfileWiseData(List<Goal__c> goalListP, Map<Id, Id>golProfileMapP, Map<Id, double>golProfileClassMapP
     												, Map<Id, double>golAmountMapP, Map<Id, double> percentageAllocationMap){
       
         List<double> classVals = new List<double>();
        for(Goal__c golObj: goalListP){
            Id goalId = golObj.Id;
            double sumMF = golAmountMapP.get(goalId);
            
            double Perc = 0;
            double amount = 0;
            
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
    
    public void prepareSIPData(ApprovedPlanBean beanObj,List<GoalSIPAmount__c> goalSips)
    {
        Datetime cDT = System.now();
        Integer currentYear = Integer.valueOf(cDT.format('yyyy'));
       
        List<Id> golIds = new List<Id>();
        for(Goal__c golObj: beanObj.goalList){
            golIds.add(golObj.Id);
        }
        Map<Id, double> debtValMap = new  Map<Id, double>();
        Map<Id, double> equityValMap = new  Map<Id, double>();
        Map<Id, double> goldValMap = new  Map<Id, double>();
        
        //List<GoalSIPAmount__c> goalSips = dbSOQLObj.getGoalSIP(currentYear, golIds);
        for(GoalSIPAmount__c sipObj: goalSips)
        {
        	if(sipObj.Goal__r.SIP_Start_Year__c != null)  	
	        {
	        	if(Decimal.valueOf(sipObj.Goal__r.SIP_Start_Year__c) == sipObj.Goal_Year__c)
	        	{
		            debtValMap.put(sipObj.Goal__c, sipObj.SIP_Debt__c);
		            equityValMap.put(sipObj.Goal__c, sipObj.SIP_Equity__c); 
		            goldValMap.put(sipObj.Goal__c, sipObj.SIP_Gold__c);
	        	}
	        }
        }
        List<double> debtVal = new List<double>();
        List<double> equityVal = new List<double>();
        List<double> goldVal = new List<double>();
        
        for(Goal__c golObj: beanObj.goalList){
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
            if(goldValMap.get(golObj.Id)!=null)
            {
                goldVal.add(goldValMap.get(golObj.Id));
            }else{
                goldVal.add(0);
            }
        } 
        
        ApprovedPlanBean.DoneClass debtObj = new  ApprovedPlanBean.DoneClass('Debt', debtVal);
        beanObj.SuggestedSIP.add(debtObj);
        ApprovedPlanBean.DoneClass equityObj = new  ApprovedPlanBean.DoneClass('Equity', equityVal);
        beanObj.SuggestedSIP.add(equityObj);
        ApprovedPlanBean.DoneClass goldObj = new  ApprovedPlanBean.DoneClass('Gold', goldVal);
        beanObj.SuggestedSIP.add(goldObj);
    }
    
}