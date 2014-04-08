/*
	Revision History:
	
    Version     Version Author     Date           Comments
    1.0			Anupam	   		14/01/13		 Executon Tracker controller for operation Team Member.
    1.1 		Gaurav 			08/02/2013 		 Replace aggreedAmount to SuggestedAmount and totalagreedAmount = totalsuggestedamount
    											 as per discussion with Vinita
 */

public with sharing class ExecutionTrackerForOpsTeamController 
{
	//public variables.
	public List<ExecutionTrackerGroupDetail> lstExecutionTrackerGroupDetail {get;set;}
	
	//Local variables.
	private String entityId{get;set;}
	private Map<Id, Execution_Tracker__c> mapIdToExecutionTracker;
	private Map<Id,Workstation__c> mapFPtoWorkstation {get;set;}
	private Map<Id,Account> mapIdToAccount {get;set;}
	private Map<Id,User> mapIdToUser {get;set;}
	private Map<Id,Contact> mapIdContact {get;set;}
	private Map<Id, List<Execution_Tracker__c>> mapApplicationIdToEt {get;set;}
	
	//Inner Class to hold render on Page
	public class ExecutionTrackerGroupDetail
	{
		//public variable
		public String schemeNameOrPolicyName {get;set;}
		//public Decimal totalAgreedAmount {get;set;}
		public Decimal totalRemainingBalance {get;set;}
		public String firstHolderName {get;set;}
		public String secondHolderName {get;set;}
		public List<ExecutionTrackerDetail> lstExecutionTrackerDetail {get;set;}
		public Boolean isInsurance {get;set;}
		public Boolean isMutualFund {get;set;}
		public String actionName{get;set;}
		public String strTransactionType {get;set;}
		public Decimal installments {get;set;}
		//Constructor of Inner class
		public ExecutionTrackerGroupDetail(String strTransactionType, Decimal installments, String schemeNameOrPolicyName, String firstHolderName,
											String secondHolderName, List<Execution_Tracker__c> lstExecutionTracker)
		{
			this.schemeNameOrPolicyName = schemeNameOrPolicyName;
			//this.totalAgreedAmount = 0;
			this.totalRemainingBalance = 0;
			this.firstHolderName = firstHolderName;
			this.secondHolderName = secondHolderName;
			this.strTransactionType = strTransactionType;
			this.installments = installments;
			this.isInsurance = false;
			this.isMutualFund= false;
			this.lstExecutionTrackerDetail = new List<ExecutionTrackerDetail>();
			for(Execution_Tracker__c objET : lstExecutionTracker)
			{
				/*if(objET.Type__c.equalsIgnoreCase('Life Insurance') || objET.Type__c.equalsIgnoreCase('General Insurance'))
				{
					if(objET.Sum_Assured__c != null)
						this.totalSuggestedAmount += objET.Sum_Assured__c;
				}
				else
				{
					//Changed on : 20/3/13 : Aditi Satpute : ET screen Changes
					if(objET.Agreed_Amount__c != null)
					this.totalSuggestedAmount += objET.Agreed_Amount__c;
				}*/
				//this.totalSuggestedAmount += objET.Agreed_Amount__c;
				String goalDescription;
				String strTypeforOps = '';
				Decimal agreedAmount = objET.Agreed_Amount__c;
			/*	if(objET.Transaction_Type__c != null)
				{
					actionName = objET.Transaction_Type__c;
				}
				else
				{
					actionName = objET.Action__c;
				}
				
				if(objET.Goal__c != null)
					goalDescription = objET.Goal__r.Description__c;
				else if(objET.Type__c.equalsIgnoreCase('Life Insurance') || objET.Type__c.equalsIgnoreCase('General Insurance'))
				{
					goalDescription = objET.Asset_Class_Policy_Type__c;
					isInsurance = true;
					suggestedAmount = objET.Sum_Assured__c;
				}
				else
				{
					goalDescription = 'Mutual Fund';
					isMutualFund = true;
				}*/
				
				
				//Added on : 22/3/13 - Aditi Satpute : To uniquely distinguish between records depending on Action for Ops Team.
				if(objET.Approve_Action_Plan__r.Investment_Asset__c != null && objET.Type__c == 'Lumpsum')
				{
					strTypeforOps = 'Lumpsum';
					goalDescription = 'Mutual Fund';
					isMutualFund = true;
					actionName = objET.Action__c;
				}
				else if(objET.Approve_Action_Plan__r.Investment_Asset__c == null && objET.Type__c == 'Lumpsum')
				{
					strTypeforOps = 'GoalLumpsum';
					goalDescription = objET.Goal__r.Description__c;
					actionName = objET.Transaction_Type__c;
				}	
				else if(objET.Approve_Action_Plan__r.Investment_Asset__c == null && objET.Type__c == 'SIP')
				{
					strTypeforOps = 'GoalSIP';
					goalDescription = objET.Goal__r.Description__c;
					actionName = objET.Transaction_Type__c;
				}
				else if(objET.Approve_Action_Plan__r.Investment_Asset__c != null && objET.Type__c == 'SIP')	
				{
					strTypeforOps = 'SIP';
					goalDescription = 'Mutual Fund';
					isMutualFund = true;
					actionName = objET.Action__c;
				}
				else if(objET.Type__c.equalsIgnoreCase('Life Insurance') || objET.Type__c.equalsIgnoreCase('General Insurance'))
				{
					goalDescription = objET.Asset_Class_Policy_Type__c;
					system.debug('-----------goalDescription----------'+goalDescription);
					isInsurance = true;
					//suggestedAmount = objET.Sum_Assured__c;
				}
				else if(objET.Type__c.equalsIgnoreCase('Recommended Insurance'))
				{
					goalDescription = objET.Policy_Name__c != null ? objET.Policy_Name__c : objET.Asset_Class_Policy_Type__c;
					isInsurance = true;
				}			
				Id entityId = objET.Approve_Action_Plan__r.Account__c;
				
				system.debug('*****entityId in ops team********'+entityId);
				Decimal recommendedAmount = objET.Actual_Action_Amount__c != null ? objET.Actual_Action_Amount__c : 0.0; // this amount comes from Action Plan
				Decimal balanceRemaining = objET.Total_Remaining_Balance__c != null ? objET.Total_Remaining_Balance__c : 0.0;
				Decimal executedAmount = objET.Executed_Amount__c;
				this.totalRemainingBalance += balanceRemaining;
				
				lstExecutionTrackerDetail.add(new ExecutionTrackerDetail(objET.Id, goalDescription, //objET.Agreed_Amount__c, 
												//objET.Suggested_Amount__c,
												recommendedAmount,balanceRemaining,
												agreedAmount,executedAmount, objET.Application_Status__c, 
												objET.Type__c,actionName,entityId,strTypeforOps,
												//objET.Agreed_Amount_Base_Amount__c
												objET.Approve_Action_Plan__r.AP_Status__c));// != null?objET.Agreed_Amount_Base_Amount__c : objET.Actual_Action_Amount__c));
			}
			system.debug('*****lstExecutionTrackerDetail********'+lstExecutionTrackerDetail);
			
		}
	}
	
	//Class hold Record value
	public class ExecutionTrackerDetail
	{
		public Id executionTrackerId {get;set;}
		public String goalName {get;set;}
		public Decimal agreedAmount {get;set;}
		public Decimal recommendedAmount {get;set;}
		public Decimal balanceRemaining {get;set;}
		public Decimal executedAmount {get;set;}
		public String applicationStatus {get;set;}
		public String strType {get;set;}
		public String actionType {get;set;}
		public Id entityId{get;set;}
		public String strTypeforOps {get;set;}
		public String APStatus {get;set;}
		//Constructor of Inner class  										  // Decimal agreedAmount
		public ExecutionTrackerDetail(Id executionTrackerId, String goalName, Decimal recommendedAmount, Decimal balanceRemaining,
										Decimal agreedAmount,Decimal executedAmount, String applicationStatus, String strType,
										String actionType,Id entityId,String strTypeforOps,String APStatus)
		{
			this.executionTrackerId = executionTrackerId;
			this.goalName = goalName;
			this.agreedAmount = agreedAmount;
			this.recommendedAmount = recommendedAmount;
			this.executedAmount = executedAmount;
			this.applicationStatus = applicationStatus;
			this.strType = strType;
			this.actionType = actionType;
			this.entityId = entityId;
			this.strTypeforOps = strTypeforOps; 
			this.APStatus = APStatus;
			this.balanceRemaining = balanceRemaining;
		}
	}
	
	//Constructor of Outer Inner class
	public ExecutionTrackerForOpsTeamController(ApexPages.StandardController stdController)
	{
		//Local variables.
		Map<String, List<Execution_Tracker__c>> mapGroupConditionTolstExecutionTracker = new Map<String, List<Execution_Tracker__c>>();
		mapApplicationIdToEt = new Map<Id, List<Execution_Tracker__c>>();
		Set<Id> setEntityFamilyMemberId = new Set<Id>();
		//Collect Entity Id and family memberId.
		entityId = ApexPages.currentPage().getParameters().get('eid');
		for(Account objAccount :[SELECT Id FROM Account WHERE (isPersonAccount =: true AND Parent_Entity__c =: entityId) OR (Id =: entityId) order by Id])
		{
			setEntityFamilyMemberId.add(objAccount.Id);
		}
		
		lstExecutionTrackerGroupDetail = new List<ExecutionTrackerGroupDetail>();
		
		//Account objAccount = [Select Id, Name,Related_To__c, OwnerId, owner.name from Account where Id =: objCloneRejectedExecutionTracker.Entity_Name__c];
	 	List<Workstation__c> lstWorkstation = [Select Member_Engagement__c, Member_Engagement__r.Name, Financial_Planner__c 
                                                         From Workstation__c];
                                                         //where Financial_Planner__c = : objAccount.Owner.Id];
		mapFPtoWorkstation = new Map<Id,Workstation__c>();
		for(Workstation__c objWorkstation : lstWorkstation)
		{
			if(!mapFPtoWorkstation.containsKey(objWorkstation.Financial_Planner__c))
			{
				mapFPtoWorkstation.put(objWorkstation.Financial_Planner__c,objWorkstation);
			}
		}
		
		
		mapIdToAccount = new Map<Id,Account>([Select Id, Name,Related_To__c,Channel_Manager__c, OwnerId, owner.name 
											from Account where (Id IN:setEntityFamilyMemberId and RecordType.Name = 'General')]);
		mapIdToUser = new Map<Id,User>([select Id,Name,ContactId , ManagerId, Email from User where ContactId != null and isActive = true]);
		Set<Id> setContact = new Set<Id>();
		for(User objUser : mapIdToUser.values())
		{
			setContact.add(objUser.ContactId);
		}
		mapIdContact = new Map<Id,Contact>([select AccountId from Contact where Id IN: setContact]);
		
		Map<Id, Approve_Action_Plan__c> mapIdToApproveActionPlan = new Map<Id, Approve_Action_Plan__c>([Select Id from Approve_Action_Plan__c where Account__c =: setEntityFamilyMemberId]);
		 
		//Describe object to collect all fields.
		Map<String, Schema.SObjectType> mapGlobalDescribe = Schema.getGlobalDescribe();
		Schema.SObjectType stdETObject = mapGlobalDescribe.get('Execution_Tracker__c');
		Schema.DescribeSObjectResult descStdET = stdETObject.getDescribe();
		Map<String, Schema.SObjectField> stdETfields = descStdET.fields.getMap();
		String strQuery = 'Select Goal__r.Description__c,Approve_Action_Plan__r.Account__c,Approve_Action_Plan__r.Investment_Asset__c,Approve_Action_Plan__r.AP_Status__c,';
		
		for(String strField : stdETfields.keySet())
		{
			strQuery += strField + ',';
		}
		strQuery = strQuery.substring(0, strQuery.length() - 1);
		String strFormProvided = Label.Forms_Provided;
		//strQuery += ' from Execution_Tracker__c where Entity_Name__c IN: setEntityFamilyMemberId and  ((Agreed_Amount__c != null and Agreed_Amount__c != 0) or (Sum_Assured__c != null and Sum_Assured__c != 0)) and Application_Status__c != \'Closed\' and Application_Status__c != \'\' and Application_Status__c != \'Rejected\' and Application_Status__c !=: strFormProvided and isAssignedToOps__c = true and Is_Floating__c = false order by LastModifiedDate';
		strQuery += ' from Execution_Tracker__c where Entity_Name__c IN: setEntityFamilyMemberId and  ((Agreed_Amount__c != null and Agreed_Amount__c != 0) or (Sum_Assured__c != null and Sum_Assured__c != 0))  and isAssignedToOps__c = true and Is_Floating__c = false order by LastModifiedDate';
		
		mapIdToExecutionTracker = new Map<Id, Execution_Tracker__c>();
		
		//Create map of Execution record
		for(Execution_Tracker__c objET : Database.query(strQuery))
		{
			
			if(objET.Application_Status__c != 'Closed' && objET.Application_Status__c != '' && objET.Application_Status__c != 'Rejected' && objET.Application_Status__c != strFormProvided)
			{
				mapIdToExecutionTracker.put(objET.Id, objET);
			}
			if(mapApplicationIdToEt.get(objET.Approve_Action_Plan__c) == null)
          	{
	            List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
	            lstET.add(objET);
	            mapApplicationIdToEt.put(objET.Approve_Action_Plan__c, lstET);
          	}
          	else
          	{
           		mapApplicationIdToEt.get(objET.Approve_Action_Plan__c).add(objET);
          	}
			
		}
		
		//Create List to render on page based on Combination of Scheme Name, First Holder and Second Holder
		for(Execution_Tracker__c objET : mapIdToExecutionTracker.values())
		{
			//String strSchemeOrPolicyName = objET.Goal__c != null ? objET.Scheme_Name_Policy_Name__c : 'Mutual Fund';
			// Below  is commented by gaurav on 8/2/2013 and Use Executed Policy Name instead of Scheme_Name_Policy_Name__c
			//String strSchemeOrPolicyName = objET.Scheme_Name_Policy_Name__c != null ? objET.Scheme_Name_Policy_Name__c : objET.Asset_Class_Policy_Type__c;
			String strSchemeOrPolicyName = objET.Executed_Product_Name__c != null ? objET.Executed_Product_Name__c :objET.Asset_Class_Policy_Type__c;
			//String strTransactionType = objET.Action__c;
			//String strInstallments = objET.Agreed_Installments__c;
			String firstHolderName = '';
			String secondHolder = '';
			if((objET.Type__c.equalsIgnoreCase('Life Insurance') || objET.Type__c.equalsIgnoreCase('General Insurance') || objET.Type__c.equalsIgnoreCase('Recommended Insurance')) && objET.Type__c != null)
			{
				system.debug('****in if ****objET.Insured_Name__c****'+objET.Insured_Name__c);
				firstHolderName =  objET.Insured_Name__c != null ? objET.Insured_Name__c : '';
				secondHolder = ' ';
		
			}
			else
			{
				firstHolderName =  objET.Holder_Name__c != null ? objET.Holder_Name__c : ' ';
				secondHolder = objET.Name_of_Second_holder__c != null ? objET.Name_of_Second_holder__c : ' ';
			}
			String strKey = '';
			String strTransactionType = '';
			Decimal installments = 0;
			
			if(objET.Goal__c != null)
			{ 
				strTransactionType = objET.Transaction_Type__c;
				installments = objET.Agreed_Installments__c != null ? objET.Agreed_Installments__c : 0;
				//installments = objET.Agreed_Installments__c;
				strKey = strTransactionType + '~~' + installments + '~~' + strSchemeOrPolicyName + '~~' + firstHolderName +  '~~' + secondHolder;
			}
			else
			{
				strKey = strTransactionType + '~~' + installments + '~~' + strSchemeOrPolicyName + '~~' + firstHolderName +  '~~' + secondHolder;
			}	
			
			if(strKey.equalsIgnoreCase('')) continue;
			
			if(!mapGroupConditionTolstExecutionTracker.containsKey(strKey))
				mapGroupConditionTolstExecutionTracker.put(strKey, new List<Execution_Tracker__c>{objET});
			else
				mapGroupConditionTolstExecutionTracker.get(strKey).add(objET);
		}
		
		for(String strKey : mapGroupConditionTolstExecutionTracker.keySet())
		{
			System.debug('strKey=================================>'+strKey);
			List<String> lstSplitGroupValue = strKey.split('~~');
			system.debug('******lstSplitGroupValue**********'+lstSplitGroupValue);
			system.debug('******lstSplitGroupValue[1]**********'+lstSplitGroupValue[1]);
			system.debug('******lstSplitGroupValue[2]**********'+lstSplitGroupValue[2]);
			system.debug('******lstSplitGroupValue[3]**********'+lstSplitGroupValue[3]);
			
			system.debug('******lstSplitGroupValue[4]**********'+lstSplitGroupValue[4]);
			
			if(!lstSplitGroupValue.IsEmpty() && lstSplitGroupValue[1] != null && lstSplitGroupValue[2] != null && lstSplitGroupValue[3] != null && (lstSplitGroupValue[4] != null && !lstSplitGroupValue.IsEmpty()))
				lstExecutionTrackerGroupDetail.add(new ExecutionTrackerGroupDetail(lstSplitGroupValue[0],decimal.valueOf(lstSplitGroupValue[1]),lstSplitGroupValue[2], lstSplitGroupValue[3].trim(), lstSplitGroupValue[4], 
												mapGroupConditionTolstExecutionTracker.get(strKey)));
		}
	}
	
	//Collect Application Status Picklist value.
	public List<SelectOption> getApplicationStatus()
	{
		List<SelectOption> lstSelectOption = new List<SelectOption>();
        for(Schema.PicklistEntry p : Execution_Tracker__c.Application_Status__c.getDescribe().getPicklistValues())
        	lstSelectOption.add(new SelectOption(p.getValue(), p.getValue()));
        return lstSelectOption;
	}
	
	//Update Execution Record and Clone it If Agreed Amount > Executed Amount where Application Status = Processed.
	public PageReference updateExecutionTracker()
	{	
		List<Execution_Tracker__c> lstUpdateExecutionTracker = new List<Execution_Tracker__c>();
		List<Execution_Tracker__c> lstCloneExecutionTracker = new List<Execution_Tracker__c>();
		List<Execution_Tracker__c> lstCloneRejectedExecutionTracker = new List<Execution_Tracker__c>();
		List<Execution_Tracker__c> lstAssignToMET = new List<Execution_Tracker__c>();
		
		for(ExecutionTrackerGroupDetail objETGroupDetail: lstExecutionTrackerGroupDetail)
		{
			for(ExecutionTrackerDetail objExecutionTrackerDetail : objETGroupDetail.lstExecutionTrackerDetail)
			{
				if(objExecutionTrackerDetail.executedAmount != null && Math.floor(objExecutionTrackerDetail.executedAmount) > 0 
						&& 	objExecutionTrackerDetail.applicationStatus == Label.Forms_Handed)
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Application Status should be Processed If Executed Amount is filled'));
					return null;
				}
				if((objExecutionTrackerDetail.executedAmount != null && Math.floor(objExecutionTrackerDetail.executedAmount) > 0 
						&& 	objExecutionTrackerDetail.applicationStatus == 'Opened') 
						&& (objExecutionTrackerDetail.strType == 'Life Insurance' || objExecutionTrackerDetail.strType == 'General Insurance'))
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Application Status should be Processed If Executed Amount is filled'));
					return null;
				}
				if((objExecutionTrackerDetail.executedAmount == null || Math.floor(objExecutionTrackerDetail.executedAmount) == 0) 
						&& 	objExecutionTrackerDetail.applicationStatus == 'Processed')
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Please enter Executed Amount where Application Status is Processed'));
					return null;
				}
				Decimal difference = 0;
				if(objExecutionTrackerDetail.agreedAmount != null && objExecutionTrackerDetail.executedAmount != null)
				    difference = Math.floor(objExecutionTrackerDetail.agreedAmount) - Math.floor(objExecutionTrackerDetail.executedAmount);
				
				//Decimal difference = Math.floor(objExecutionTrackerDetail.agreedAmount) - Math.floor(objExecutionTrackerDetail.executedAmount);
				if(difference < 0)
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Executed Amount can not be greater than Agreed Amount'));
					return null;
				}
				
				system.debug('-------Math.floor(objExecutionTrackerDetail.agreedAmount)---------'+Math.floor(objExecutionTrackerDetail.agreedAmount));
				system.debug('-------Math.floor(objExecutionTrackerDetail.executedAmount)---------'+Math.floor(objExecutionTrackerDetail.executedAmount));
				
				system.debug('-----objExecutionTrackerDetail.APStatus---------'+objExecutionTrackerDetail.APStatus);
				if(objExecutionTrackerDetail.APStatus != null)
				{
					if(objExecutionTrackerDetail.APStatus.equalsIgnoreCase('Closed'))
					{
						if(objExecutionTrackerDetail.strType != 'Life Insurance' || objExecutionTrackerDetail.strType != 'General Insurance' || objExecutionTrackerDetail.strType != 'Recommended Insurance')
						{
							if(Math.floor(objExecutionTrackerDetail.agreedAmount) != Math.floor(objExecutionTrackerDetail.executedAmount) && Math.floor(objExecutionTrackerDetail.executedAmount) > 0)
							{
								ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Executed Amount of Old Record must be equal to Agreed Amount as new Action Plan has been Generated'));
								return null;
							}
						}
						
					}
				}
				Id mainParentId;
				
				lstUpdateExecutionTracker.add(new Execution_Tracker__c(Id = objExecutionTrackerDetail.executionTrackerId, 
																	Executed_Amount__c = objExecutionTrackerDetail.executedAmount, 
																	Application_Status__c = objExecutionTrackerDetail.applicationStatus));
				//error.debugLog('********lstUpdateExecutionTracker**********'+lstUpdateExecutionTracker);
				if(objExecutionTrackerDetail.executedAmount != null &&
						Math.floor(objExecutionTrackerDetail.executedAmount) != 0 &&
						objExecutionTrackerDetail.applicationStatus == 'Closed' &&
						Math.floor(objExecutionTrackerDetail.balanceRemaining) > Math.floor(objExecutionTrackerDetail.executedAmount))
						//Math.floor(objExecutionTrackerDetail.agreedAmount) > Math.floor(objExecutionTrackerDetail.executedAmount))
				{
					Execution_Tracker__c objOldExecutionTracker = mapIdToExecutionTracker.get(objExecutionTrackerDetail.executionTrackerId);
					//Commented on : 18/3/13 : Aditi Satpute : All details should not be cloned for Ops Team.
					//Execution_Tracker__c objCloneExecutionTracker = objOldExecutionTracker.clone();
					system.debug('----objOldExecutionTracker-------'+objOldExecutionTracker);
					Decimal executedAmount_Client_Child = 0.0;
					if(mapApplicationIdToEt.containsKey(objOldExecutionTracker.Approve_Action_Plan__c))
					{
						List<Execution_Tracker__c> lstExecutionTracker = mapApplicationIdToEt.get(objOldExecutionTracker.Approve_Action_Plan__c);
						system.debug('----lstExecutionTracker-------'+lstExecutionTracker.size());
						for(Execution_Tracker__c objEt : lstExecutionTracker)
						{
							if(objEt.ParentExecutionTracker__c == null && objEt.Type__c == objOldExecutionTracker.Type__c)
							{
								system.debug('****objEt****'+objEt);
								mainParentId = objEt.Id;
								
							}
							/*if(objEt.Type__c == objOldExecutionTracker.Type__c)
							{
								executedAmount_Client_Child += objEt.Executed_Amount__c;
							}*/
						}
					}
					Execution_Tracker__c objCloneExecutionTracker = new Execution_Tracker__c();
            		if(objExecutionTrackerDetail.strType == 'Life Insurance' || objExecutionTrackerDetail.strType == 'General Insurance' || objExecutionTrackerDetail.strType == 'Recommended Insurance')
					{
						objCloneExecutionTracker = objOldExecutionTracker.clone();
					}
					else
					{
						objCloneExecutionTracker.Insured_Name__c = objOldExecutionTracker.Insured_Name__c;
						objCloneExecutionTracker.Policy_Name__c = objOldExecutionTracker.Policy_Name__c;
						objCloneExecutionTracker.Sum_Assured__c = objOldExecutionTracker.Sum_Assured__c;
						objCloneExecutionTracker.Term_No_Of_Years__c = objOldExecutionTracker.Term_No_Of_Years__c;
						objCloneExecutionTracker.Agreed_Life_Insurance_Company_Name__c = objOldExecutionTracker.Agreed_Life_Insurance_Company_Name__c;
						objCloneExecutionTracker.Agreed_General_Insurance_Company_Name__c = objOldExecutionTracker.Agreed_General_Insurance_Company_Name__c;
						objCloneExecutionTracker.Executed_Product_Name__c = objOldExecutionTracker.Executed_Product_Name__c;
						objCloneExecutionTracker.Asset_Class_Policy_Type__c = objOldExecutionTracker.Asset_Class_Policy_Type__c;
						objCloneExecutionTracker.Approve_Action_Plan__c = objOldExecutionTracker.Approve_Action_Plan__c;
						objCloneExecutionTracker.Entity_Name__c = objOldExecutionTracker.Entity_Name__c;
						objCloneExecutionTracker.Application_Status__c = objOldExecutionTracker.Application_Status__c;
						objCloneExecutionTracker.Type__c = objOldExecutionTracker.Type__c;
						objCloneExecutionTracker.ET_Status__c = objOldExecutionTracker.ET_Status__c;
						objCloneExecutionTracker.Agreed_Amount__c = objOldExecutionTracker.Agreed_Amount__c;
						objCloneExecutionTracker.Scheme_Name_Policy_Name__c = objOldExecutionTracker.Scheme_Name_Policy_Name__c;
						objCloneExecutionTracker.Suggested_Amount__c = objOldExecutionTracker.Suggested_Amount__c;
						//objCloneExecutionTracker.Agreed_Amount_Per_Installment__c = objOldExecutionTracker.Agreed_Amount_Per_Installment__c;
						objCloneExecutionTracker.Agreed_Installments__c = objOldExecutionTracker.Agreed_Installments__c;
						objCloneExecutionTracker.Mobile__c = objOldExecutionTracker.Mobile__c;
	                    objCloneExecutionTracker.Email__c = objOldExecutionTracker.Email__c;
	                    objCloneExecutionTracker.DOB__c =  objOldExecutionTracker.DOB__c;
	                    objCloneExecutionTracker.PAN__c = objOldExecutionTracker.PAN__c;
	                    objCloneExecutionTracker.Account_Number__c = objOldExecutionTracker.Account_Number__c;
	                    objCloneExecutionTracker.Bank_Name__c = objOldExecutionTracker.Bank_Name__c;
	                    objCloneExecutionTracker.Branch_Address__c = objOldExecutionTracker.Branch_Address__c;
	                    objCloneExecutionTracker.Account_Type__c = objOldExecutionTracker.Account_Type__c;
	                    objCloneExecutionTracker.MICR_Code__c =  objOldExecutionTracker.MICR_Code__c ;
	                    objCloneExecutionTracker.IFSC_Code__c = objOldExecutionTracker.IFSC_Code__c;
	                    objCloneExecutionTracker.Renewal_Date__c = objOldExecutionTracker.Renewal_Date__c;
	                    objCloneExecutionTracker.Goal__c = objOldExecutionTracker.Goal__c;
	                    objCloneExecutionTracker.Mode_of_holding__c = objOldExecutionTracker.Mode_of_holding__c;
	                    objCloneExecutionTracker.Holder_Name__c = objOldExecutionTracker.Holder_Name__c;
	                    objCloneExecutionTracker.Name_of_Second_holder__c = objOldExecutionTracker.Name_of_Second_holder__c;
	                   	objCloneExecutionTracker.Option__c = objOldExecutionTracker.Option__c;
	                	objCloneExecutionTracker.Transaction_Type__c = objOldExecutionTracker.Transaction_Type__c;
	            		objCloneExecutionTracker.Status__c = objOldExecutionTracker.Status__c;
	            		objCloneExecutionTracker.Action__c = objOldExecutionTracker.Action__c;
	            		objCloneExecutionTracker.Folio_No__c = objOldExecutionTracker.Folio_No__c;
	                	objCloneExecutionTracker.Policy_Number__c = objOldExecutionTracker.Policy_Number__c;
	            		objCloneExecutionTracker.Nominee__c = objOldExecutionTracker.Nominee__c;
	            		objCloneExecutionTracker.Owner__c = objOldExecutionTracker.Owner__c;
	            		//objCloneExecutionTracker.Communication_Address__c = objOldExecutionTracker.Communication_Address__c;
	            		objCloneExecutionTracker.Actual_Action_Amount__c = objOldExecutionTracker.Actual_Action_Amount__c;
	            		objCloneExecutionTracker.Agreed_Amount_Base_Amount__c = objOldExecutionTracker.Agreed_Amount_Base_Amount__c;
					}
					objCloneExecutionTracker.ParentExecutionTracker__c = mainParentId; //objOldExecutionTracker.Id; 
					objCloneExecutionTracker.AssignToOps__c = true;
            		objCloneExecutionTracker.isAssignedToOps__c = true;
            		//if(objOldExecutionTracker.ParentExecutionTracker__c == null)
            		objCloneExecutionTracker.Total_Remaining_Balance__c = objOldExecutionTracker.Total_Remaining_Balance__c - Math.floor(objExecutionTrackerDetail.executedAmount);
            	/*	else
            		{
            			executedAmount_Client_Child
            			//need to add all executed amt and then subtract from balance remaining
            		}*/
					//Added condition on 18/3/13 : Aditi Satpute: ET Changes : Tracker is mainted for Sum Assured in Life Insurance
					/*if(objExecutionTrackerDetail.strType == 'Life Insurance' || objExecutionTrackerDetail.strType == 'General Insurance')
					{
						objCloneExecutionTracker.Sum_Assured__c = Math.floor(objExecutionTrackerDetail.suggestedAmount) - Math.floor(objExecutionTrackerDetail.executedAmount);
						objCloneExecutionTracker.Suggested_Amount__c = Math.floor(objExecutionTrackerDetail.suggestedAmount) - Math.floor(objExecutionTrackerDetail.executedAmount);
					}
					else
					{*/
						//objCloneExecutionTracker.Agreed_Amount__c = Math.floor(objExecutionTrackerDetail.suggestedAmount) - Math.floor(objExecutionTrackerDetail.executedAmount);
						//objCloneExecutionTracker.Suggested_Amount__c = Math.floor(objExecutionTrackerDetail.suggestedAmount) - Math.floor(objExecutionTrackerDetail.executedAmount);
						//objCloneExecutionTracker.Total_Remaining_Balance__c = Math.floor(objExecutionTrackerDetail.balanceRemaining) - Math.floor(objExecutionTrackerDetail.executedAmount);
						objCloneExecutionTracker.Agreed_Amount__c = Math.floor(objExecutionTrackerDetail.balanceRemaining) - Math.floor(objExecutionTrackerDetail.executedAmount);
						//objCloneExecutionTracker.Suggested_Amount__c = Math.floor(objExecutionTrackerDetail.balanceRemaining) - Math.floor(objExecutionTrackerDetail.executedAmount);
					//}
					
					//objCloneExecutionTracker.Agreed_Amount__c = Math.floor(objExecutionTrackerDetail.agreedAmount) - Math.floor(objExecutionTrackerDetail.executedAmount);
					objCloneExecutionTracker.Application_Status__c = 'Opened';
					objCloneExecutionTracker.Executed_Amount__c = 0; 
					lstCloneExecutionTracker.add(objCloneExecutionTracker);
				}
				
				if(objExecutionTrackerDetail.applicationStatus == 'Rejected')
				{
					Execution_Tracker__c objOldExecutionTracker = mapIdToExecutionTracker.get(objExecutionTrackerDetail.executionTrackerId);
					if(mapApplicationIdToEt.containsKey(objOldExecutionTracker.Approve_Action_Plan__c))
					{
						List<Execution_Tracker__c> lstExecutionTracker = mapApplicationIdToEt.get(objOldExecutionTracker.Approve_Action_Plan__c);
						for(Execution_Tracker__c objEt : lstExecutionTracker)
						{
							if(objEt.ParentExecutionTracker__c == null && objEt.Type__c == objOldExecutionTracker.Type__c)
							{
								system.debug('****objEt****'+objEt);
								mainParentId = objEt.Id;
							}
						}
					}
					//error.debugLog('*****mainParentId*****'+mainParentId);
					Execution_Tracker__c objCloneRejectedExecutionTracker = new Execution_Tracker__c();
					objCloneRejectedExecutionTracker.Insured_Name__c = objOldExecutionTracker.Insured_Name__c;
					objCloneRejectedExecutionTracker.Policy_Name__c = objOldExecutionTracker.Policy_Name__c;
					objCloneRejectedExecutionTracker.Application_Status__c = '';
					objCloneRejectedExecutionTracker.Executed_Amount__c = 0; 
					objCloneRejectedExecutionTracker.Approve_Action_Plan__c = objOldExecutionTracker.Approve_Action_Plan__c;
					objCloneRejectedExecutionTracker.ParentExecutionTracker__c = mainParentId; //objOldExecutionTracker.Id; 
					objCloneRejectedExecutionTracker.Entity_Name__c = objOldExecutionTracker.Entity_Name__c;
					objCloneRejectedExecutionTracker.Type__c = objOldExecutionTracker.Type__c;
					objCloneRejectedExecutionTracker.Sum_Assured__c = objOldExecutionTracker.Sum_Assured__c;
					objCloneRejectedExecutionTracker.Term_No_Of_Years__c = objOldExecutionTracker.Term_No_Of_Years__c;
					objCloneRejectedExecutionTracker.Agreed_Life_Insurance_Company_Name__c = objOldExecutionTracker.Agreed_Life_Insurance_Company_Name__c;
					objCloneRejectedExecutionTracker.Agreed_General_Insurance_Company_Name__c = objOldExecutionTracker.Agreed_General_Insurance_Company_Name__c;
					objCloneRejectedExecutionTracker.Executed_Product_Name__c = objOldExecutionTracker.Executed_Product_Name__c;
					objCloneRejectedExecutionTracker.Asset_Class_Policy_Type__c = objOldExecutionTracker.Asset_Class_Policy_Type__c;
					objCloneRejectedExecutionTracker.ET_Status__c = 'Assigned to MET';
					objCloneRejectedExecutionTracker.Agreed_Amount__c = objOldExecutionTracker.Agreed_Amount__c;
					objCloneRejectedExecutionTracker.Scheme_Name_Policy_Name__c = objOldExecutionTracker.Scheme_Name_Policy_Name__c;
					objCloneRejectedExecutionTracker.Suggested_Amount__c = objOldExecutionTracker.Suggested_Amount__c;
					//objCloneRejectedExecutionTracker.Agreed_Amount_Per_Installment__c = objOldExecutionTracker.Agreed_Amount_Per_Installment__c;
					objCloneRejectedExecutionTracker.Agreed_Installments__c = objOldExecutionTracker.Agreed_Installments__c;
					objCloneRejectedExecutionTracker.Mobile__c = objOldExecutionTracker.Mobile__c;
                    objCloneRejectedExecutionTracker.Email__c = objOldExecutionTracker.Email__c;
                    objCloneRejectedExecutionTracker.DOB__c =  objOldExecutionTracker.DOB__c;
                    objCloneRejectedExecutionTracker.PAN__c = objOldExecutionTracker.PAN__c;
                    //objCloneRejectedExecutionTracker.Communication_Address__c = objOldExecutionTracker.Communication_Address__c;
                    objCloneRejectedExecutionTracker.Account_Number__c = objOldExecutionTracker.Account_Number__c;
                    objCloneRejectedExecutionTracker.Bank_Name__c = objOldExecutionTracker.Bank_Name__c;
                    objCloneRejectedExecutionTracker.Branch_Address__c = objOldExecutionTracker.Branch_Address__c;
                    objCloneRejectedExecutionTracker.Account_Type__c = objOldExecutionTracker.Account_Type__c;
                    objCloneRejectedExecutionTracker.MICR_Code__c =  objOldExecutionTracker.MICR_Code__c ;
                    objCloneRejectedExecutionTracker.IFSC_Code__c = objOldExecutionTracker.IFSC_Code__c;
                    objCloneRejectedExecutionTracker.Renewal_Date__c = objOldExecutionTracker.Renewal_Date__c;
                    objCloneRejectedExecutionTracker.Goal__c = objOldExecutionTracker.Goal__c;
                    objCloneRejectedExecutionTracker.Mode_of_holding__c = objOldExecutionTracker.Mode_of_holding__c;
                    objCloneRejectedExecutionTracker.Holder_Name__c = objOldExecutionTracker.Holder_Name__c;
                    objCloneRejectedExecutionTracker.Name_of_Second_holder__c = objOldExecutionTracker.Name_of_Second_holder__c;
                   	objCloneRejectedExecutionTracker.Option__c = objOldExecutionTracker.Option__c;
                	objCloneRejectedExecutionTracker.Transaction_Type__c = objOldExecutionTracker.Transaction_Type__c;
            		objCloneRejectedExecutionTracker.Status__c = objOldExecutionTracker.Status__c;
            		objCloneRejectedExecutionTracker.Action__c = objOldExecutionTracker.Action__c;
            		objCloneRejectedExecutionTracker.Folio_No__c = objOldExecutionTracker.Folio_No__c;
                	objCloneRejectedExecutionTracker.Policy_Number__c = objOldExecutionTracker.Policy_Number__c;
            		objCloneRejectedExecutionTracker.Nominee__c = objOldExecutionTracker.Nominee__c;
            		objCloneRejectedExecutionTracker.Agreed_Amount_Base_Amount__c = objOldExecutionTracker.Agreed_Amount_Base_Amount__c;
            		objCloneRejectedExecutionTracker.AssignToOps__c = false;
            		objCloneRejectedExecutionTracker.isAssignedToOps__c = false;
            		objCloneRejectedExecutionTracker.Actual_Action_Amount__c = objOldExecutionTracker.Actual_Action_Amount__c;
            		objCloneRejectedExecutionTracker.Rejected_Tracker__c = objExecutionTrackerDetail.executionTrackerId;
            		if(mapIdToAccount.containsKey(objOldExecutionTracker.Entity_Name__c))
            		{
            			Account objAcc = mapIdToAccount.get(objOldExecutionTracker.Entity_Name__c);
            			
            			if(objAcc.Related_To__c.equalsIgnoreCase('Business Partner'))
                    	{
                    		if(mapIdToUser.containsKey(objAcc.OwnerId))
                        	{
                            	User objBPEntityOwnerUser = mapIdToUser.get(objAcc.OwnerId);
                            	if(mapIdContact.containsKey(objBPEntityOwnerUser.ContactId))
                            	{
                            		Contact objContact = mapIdContact.get(objBPEntityOwnerUser.ContactId);
                            		if(mapIdToAccount.containsKey(objContact.AccountId))
                            		{
                            			Account objBPAccount = mapIdToAccount.get(objContact.AccountId);
                            			if(mapFPtoWorkstation.containsKey(objBPAccount.Channel_Manager__c))
	            						{
	            							Workstation__c objBPWorkstation = mapFPtoWorkstation.get(objBPAccount.Channel_Manager__c);
	            							objCloneRejectedExecutionTracker.Owner__c = objBPWorkstation.Member_Engagement__c;
	            						}
                            		}
                            	}
                        	}
                    	}
                    	else
                    	{
	            			if(objAcc.OwnerId != null)
	            			{
	            				if(mapFPtoWorkstation.containsKey(objAcc.OwnerId))
	            				{
	            					Workstation__c objWorkstation = mapFPtoWorkstation.get(objAcc.OwnerId);
	            					objCloneRejectedExecutionTracker.Owner__c = objWorkstation.Member_Engagement__c;
	            				}
	            			}
                    	}  
            		}
            		 
            		
					
					lstCloneRejectedExecutionTracker.add(objCloneRejectedExecutionTracker);
					
				}
				if(objExecutionTrackerDetail.applicationStatus.equalsIgnoreCase(Label.Forms_Provided) && objExecutionTrackerDetail.applicationStatus != null)
				{
					Execution_Tracker__c objOldExecutionTracker = mapIdToExecutionTracker.get(objExecutionTrackerDetail.executionTrackerId);
					system.debug('******objOldExecutionTracker********'+objOldExecutionTracker);
					objOldExecutionTracker.ET_Status__c = 'Assigned to MET';
					objOldExecutionTracker.Application_Status__c = objExecutionTrackerDetail.applicationStatus;
					objOldExecutionTracker.isFormProvidedToMET__c = true;
					objOldExecutionTracker.AssignToOps__c = false;
					objOldExecutionTracker.isAssignedToOps__c = false;
					Id ownerId;
					if(mapIdToAccount.containsKey(objOldExecutionTracker.Entity_Name__c))
            		{
            			Account objAcc = mapIdToAccount.get(objOldExecutionTracker.Entity_Name__c);
            			
            			if(objAcc.Related_To__c.equalsIgnoreCase('Business Partner'))
                    	{
                    		if(mapIdToUser.containsKey(objAcc.OwnerId))
                        	{
                            	User objBPEntityOwnerUser = mapIdToUser.get(objAcc.OwnerId);
                            	if(mapIdContact.containsKey(objBPEntityOwnerUser.ContactId))
                            	{
                            		Contact objContact = mapIdContact.get(objBPEntityOwnerUser.ContactId);
                            		if(mapIdToAccount.containsKey(objContact.AccountId))
                            		{
                            			Account objBPAccount = mapIdToAccount.get(objContact.AccountId);
                            			if(mapFPtoWorkstation.containsKey(objBPAccount.Channel_Manager__c))
	            						{
	            							Workstation__c objBPWorkstation = mapFPtoWorkstation.get(objBPAccount.Channel_Manager__c);
	            							objOldExecutionTracker.Owner__c = objBPWorkstation.Member_Engagement__c;
	            						}
                            		}
                            	}
                        	}
                    	}
                    	else
                    	{
	            			if(objAcc.OwnerId != null)
	            			{
	            				if(mapFPtoWorkstation.containsKey(objAcc.OwnerId))
	            				{
	            					Workstation__c objWorkstation = mapFPtoWorkstation.get(objAcc.OwnerId);
	            					objOldExecutionTracker.Owner__c = objWorkstation.Member_Engagement__c;
	            				}
	            			}
                    	}  
            		}
            	//	lstUpdateExecutionTracker.add(new Execution_Tracker__c(Id = objExecutionTrackerDetail.executionTrackerId,ET_Status__c =  'Assigned to MET',
					//												isAssignedToOps__c = false,Owner__c = ownerId
					//												));
					lstAssignToMET.add(objOldExecutionTracker);
				}
			}
		}
		system.debug('*******lstAssignToMET******'+lstAssignToMET);
		if(!lstUpdateExecutionTracker.isEmpty())
		{
			update lstUpdateExecutionTracker;
		}
		if(!lstCloneExecutionTracker.isEmpty())
		{
			insert lstCloneExecutionTracker;
		}
		if(!lstCloneRejectedExecutionTracker.isEmpty())
			insert lstCloneRejectedExecutionTracker;
		if(!lstAssignToMET.isEmpty())
			update  lstAssignToMET;
		pageReference pageRef = new pageReference('/apex/ExecutionTrackerForOperationTeam?eid='+ entityId);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	public PageReference cancel()
	{
		return new PageReference('/'+ entityId);
	}
}