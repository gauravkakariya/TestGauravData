/*
	Revision History:
	
    Version     Version Author      Date            Comments
    1.0			Prajakta	   	  08/03/2013	  Edit Execution Tracker Controller for Mutual Fund Switch Action
*/

public with sharing class EditETforSwitchController 
{
	//Public variables.
	public String strType{get;set;}
	public String userType{get;set;}
	public Boolean isSipOrLumpsum {get;set;}
	public Boolean isSipOrLumpsumForOps {get;set;}
	public Boolean isError{get;set;}
	public Execution_Tracker__c objExecutionTracker {get;set;}
	public Boolean isReadOnly {get;set;}
	public Boolean isClosed {get;set;}
	//Local variables
	private DatabaseSOQL objDatabaseSOQL;
	private Set<Id> setEntityFamilyMemberId ;
	private String entityId;
	private String executionTrackerId;
	private String strApproveActionPlanId;
	
	public String strProductName{get;set;}
	private ActionPlanUtility objActionPlanUtility;
	private Map<String,String> mapTypeToProductNames;
	 
	//Constructor
	public EditETforSwitchController()
	{
		//Variable initialization
		objDatabaseSOQL = new DatabaseSOQL();
		setEntityFamilyMemberId = new Set<Id>();
		objExecutionTracker = new Execution_Tracker__c();
		isSipOrLumpsum = false;
		isSipOrLumpsumForOps = false;
		isError = false;
		
		entityId = Apexpages.currentPage().getParameters().get('eid');
		executionTrackerId = Apexpages.currentPage().getParameters().get('etid');
		strApproveActionPlanId = Apexpages.currentPage().getParameters().get('id');
		strType = Apexpages.currentPage().getParameters().get('type');
		userType = Apexpages.currentPage().getParameters().get('userType');
		objActionPlanUtility =  new ActionPlanUtility();
		//Collect Entity Id and family memberId.
		for(Account objAccount :[SELECT Id FROM Account WHERE (isPersonAccount =: true AND Parent_Entity__c =: entityId) OR (Id =: entityId) order by Id])
		{
			setEntityFamilyMemberId.add(objAccount.Id);
		}
		
		if(userType != null)
		{
			if(userType.equalsIgnoreCase('opsTeam'))
			{
				Map<String, Schema.SObjectType> mapGlobalDescribe = Schema.getGlobalDescribe();
				Schema.SObjectType stdETObject = mapGlobalDescribe.get('Execution_Tracker__c');
				Schema.DescribeSObjectResult descStdET = stdETObject.getDescribe();
				Map<String, Schema.SObjectField> stdETfields = descStdET.fields.getMap();
				if(strType.equalsIgnoreCase('Lumpsum') || strType.equalsIgnoreCase('GoalSIP') || strType.equalsIgnoreCase('GoalLumpsum') )
				{
					String strQuery = 'Select Approve_Action_Plan__r.Account__r.Name,Approve_Action_Plan__r.Investment_Asset__r.Scheme_Name_Text__c,Approve_Action_Plan__r.Lumpsum_Action__c, ';
					strQuery += 'Approve_Action_Plan__r.Policy_Name__c,Approve_Action_Plan__r.Insurance__r.Policy_Type__c,Approve_Action_Plan__r.Premium_Amount_Rs__c, ';
					strQuery += 'Approve_Action_Plan__r.Amount__c,Approve_Action_Plan__r.Investment_Asset__r.Asset_Type__c,Approve_Action_Plan__r.Action_Amount__c, ';
					strQuery += 'Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name,Approve_Action_Plan__r.Investment_Asset__r.Asset_Name__c,';
					strQuery += 'Goal__r.Description__c,Approve_Action_Plan__r.Product_Name__c ,Approve_Action_Plan__r.Transaction_Type__c,Approve_Action_Plan__r.Installments__c, ';
					strQuery += 'Approve_Action_Plan__r.Category__c,Approve_Action_Plan__r.Option__c ,Approve_Action_Plan__r.Amount_Per_Installment__c,Approve_Action_Plan__r.Fund__c, ';
					
					for(String strField : stdETfields.keySet())
					{
						strQuery += strField + ',';
					}
					strQuery = strQuery.substring(0, strQuery.length() - 1);
					
					strQuery += ' from Execution_Tracker__c where Id =: executionTrackerId';
					for(Execution_Tracker__c objET : Database.query(strQuery))
					{
						objExecutionTracker = objET;
					}
					system.debug('*****objExecutionTracker********'+objExecutionTracker);
					isReadOnly = objExecutionTracker.Application_Status__c == 'Processed';
					isSipOrLumpsumForOps = true;
				}
			}
		}
		else if(strType.equalsIgnoreCase('Lumpsum') || strType.equalsIgnoreCase('GoalSIP') || strType.equalsIgnoreCase('GoalLumpsum') )
		{
			showMutualFundPopUp();
			isSipOrLumpsum = true;
		}
				
		strProductName  = objActionPlanUtility.getProductName('Mutual Fund');	
		mapTypeToProductNames = new Map<String,String>{'Mutual Fund' => strProductName };
				
	}
	public void showMutualFundPopUp()
	{
		 String strQuery ='select Id, Agreed_Amount__c, Approve_Action_Plan__c,Type__c,Approve_Action_Plan__r.Investment_Asset__r.Scheme_Name_Text__c,Approve_Action_Plan__r.Account__r.Name,'+
	    			'Approve_Action_Plan__r.Investment_Asset__r.Monthly_SIP_Amount__c,Approve_Action_Plan__r.SIP_Action_Amount__c,Approve_Action_Plan__r.Amount__c,'+
	    			'Approve_Action_Plan__r.SIP_Action__c,Approve_Action_Plan__r.Investment_Asset__r.Asset_Type__c,Approve_Action_Plan__r.Lumpsum_Action__c,'+
	    			'Approve_Action_Plan__r.Action_Amount__c , Completion_Date__c ,  STP_Installments__c ,Account_Type__c,PAN_No_Third_holder__c ,'+
					'Mode_of_holding__c, Status__c, Investor_Name_as_in_PAN_card__c, Communication_Address__c, Mobile__c, Email__c, Account_Number__c ,'+
 					'DOB__c, PAN__c, Guardian_Name_as_PAN_card__c, PAN_No_Guardian__c, DOB_Guardian__c, ET_Status__c , STP_Amount_per_transfer__c,'+
					'Target_Revenue__c ,Booked_Revenue__c , Send_SMS__c ,Send_Email__c , Send_SMS_Datetime__c ,Send_Email_Datetime__c ,Suggested_Amount__c ,AssignToOps__c , '+
					'Executed_Amount__c , Cancelled_Reason__c , IFSC_Code__c , MICR_Code__c , Bank_Name__c ,Branch_Address__c ,Investor_Name_As_in_bank_record__c,'+
					'Nominee_s_Name__c ,Nominee_s_DOB__c,Guardian_Name_In_case_nominee_is_minor__c ,Name_of_Second_holder__c ,DOB_Second_holder__c,isAssignedToOps__c,'+
					'PAN_No_Second_holder__c , Name_of_Third_holder__c ,DOB_Third_holder__c,  Goal__r.Description__c , Holder_Name__c ,Application_Status__c, '+
					'Remarks__c,Agreed_Amount_Per_Installment__c,Agreed_Installments__c,Agreed_Scheme_Name_From__c,Agreed_Scheme_Name_to__c,  '+
					'Units__c,Folio_No__c,Total_Remaining_Balance__c,'+
					//SIP Fields
					'Approve_Action_Plan__r.Installments__c,Approve_Action_Plan__r.Option__c,Approve_Action_Plan__r.Remarks__c, Approve_Action_Plan__r.Category__c, '+
					'Approve_Action_Plan__r.Product_Name__c,Approve_Action_Plan__r.Transaction_Type__c, Executed_Product_Name__c, Balance_Remaining__c,' +
					//Lumpsum Fields
					'Approve_Action_Plan__r.Fund__c, Approve_Action_Plan__r.Amount_Per_Installment__c, ' +
					'Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name,Approve_Action_Plan__r.Investment_Asset__r.Asset_Name__c '+
					'from Execution_Tracker__c where Entity_Name__c IN :setEntityFamilyMemberId and Approve_Action_Plan__c = :strApproveActionPlanId ';
		
		if(strType.equalsIgnoreCase('Lumpsum') || strType.equalsIgnoreCase('SIP'))// || strType.equalsIgnoreCase('GoalLumpsum'))
		{
			strQuery += ' and Type__c =: strType';
			//strQuery += ' and ((Approve_Action_Plan__r.Lumpsum_Action__c = \'STP To\' or Approve_Action_Plan__r.Lumpsum_Action__c = \'STP From\')';
			//strQuery +=	' or (Approve_Action_Plan__r.Transaction_Type__c = \'STP From\' or Approve_Action_Plan__r.Transaction_Type__c = \'STP To\' or Approve_Action_Plan__r.Transaction_Type__c = \'Lumpsum\')';
			//strQuery +=	' or (Approve_Action_Plan__r.Transaction_Type__c = \'New SIP\'))';
		}
		for(Execution_Tracker__c objET : Database.query(strQuery))
        {
	    	objExecutionTracker = objET;
        }		
		
		isReadOnly = objExecutionTracker.Application_Status__c == 'Processed';
		if(objExecutionTracker.Application_Status__c == 'Closed')
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Execution Tracker Record has been "Closed"'));
			isClosed = true;
			return ;
		}
		
	}
	
	public void updateExecutionTracker()
	{
		/*Changes by Gaurav (6-8-2013):  To validate product name from SIP/Lumpsum objExecutionTracker.Approve_Action_Plan__r.Investment_Asset__c == null &&*/  
    	if(objExecutionTracker.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Mutual Fund'  && 
    		!(mapTypeToProductNames.get('Mutual Fund').contains('"'+objExecutionTracker.Executed_Product_Name__c+'"')))
    	{
    		if(strType.equalsIgnoreCase('SIP') || strType.equalsIgnoreCase('GoalSIP')|| strType.equalsIgnoreCase('Lumpsum') || strType.equalsIgnoreCase('GoalLumpsum'))
           	{
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,Label.EditET_SwitchSIP_Message));
	            return;
           	}
    		
        }
        /* End Changes*/	
        
		//if((objExecutionTracker.Agreed_Amount__c == 0 || objExecutionTracker.Agreed_Amount__c == null) && objExecutionTracker.isAssignedToOps__c == true)
			//objExecutionTracker.isAssignedToOps__c = false;
		updateARPPDetail();	
	 	//Added on 13/9/13 : Aditi Satpute : After AP Clone Removal changes
        if(objExecutionTracker.Total_Remaining_Balance__c < objExecutionTracker.Agreed_Amount__c)
		{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Agreed Amount may not Exceed Remaining Balance.'));
            return;
       	}
		update objExecutionTracker;
		isError = true;
	}
	
	private void updateARPPDetail()
	{
		List<Product_Master__c> lstProductMaster = [Select Id, Product_Name__c, ProductType__c, Investment_Type__c,
														(Select Id, Active__c From Commissions__r Where Active__c = true) 
													 From Product_Master__c Where   
														Product_Name__c =: objExecutionTracker.Executed_Product_Name__c and
														ProductType__c = 'Mutual Fund' limit 1];
														
		Product_Master__c objProductMaster = lstProductMaster.isEmpty() ? null : lstProductMaster[0];												
		objExecutionTracker.Execution_Tracker_Product__c = objProductMaster == null ? null : objProductMaster.Id;	
		
		List<ARPP_Detail__c> lstARPPDetails  = [Select Product__r.Product_Manufacturer__c, 								
													Product__r.ProductType__c,
													Product__r.Product_Name__c, Product__c, Name, Id, 
													Execution_Tracker_upfront_Comm_Amount__c,Execution_Tracker_Amount__c,
													Revenue_Difference__c, Actual_Commission__c, 
													Actual_Commission__r.Upfront_Commission__c,Actual_Commission__r.Trail_Commission__c,
													Execution_Tracker__c, Execution_Tracker_Trial_Comm_Amount__c,
													Execution_Tracker__r.Name, ET_Remark__c,
													Type__c, Action_Amount_Revenue__c,
													Entity__c, Entity__r.Name,Approve_Action_Plan__c, Action_Plan_Upfront_Comm_Amount__c, 
													Action_Plan_Trial_Comm_Amount__c, Action_Plan_Amount__c, 
													Approve_Action_Plan__r.Name,
													Execution_Tracker_Total_Revenue__c,Remark__c
												From ARPP_Detail__c Where Approve_Action_Plan__c =: objExecutionTracker.Approve_Action_Plan__c];
		Boolean isType = false;
		if(!lstARPPDetails.isEmpty())
		{
			ARPP_Detail__c objARPPDetails = new ARPP_Detail__c();
			for(Integer i = 0 ; i < lstARPPDetails.size(); i++)
			{
				if(lstARPPDetails[i].Type__c == objExecutionTracker.Type__c)
				{
					objARPPDetails = lstARPPDetails[i]; 
					isType = true;
				}
					
			}
			if(isType)
			{
				objARPPDetails.Execution_Tracker_Actual_Product__c = objProductMaster != null ? objProductMaster.Id : null;
				objARPPDetails.Actual_Commission__c = objProductMaster != null &&  objProductMaster.Commissions__r.size() > 0 ? objProductMaster.Commissions__r[0].Id : null;
				objARPPDetails.ET_Remark__c = objProductMaster != null &&  objProductMaster.Commissions__r.size() == 0 ? Label.Actual_Commission : '';
				update objARPPDetails ;
			}	
		}	
	}
	
	 /**
    * @Description: redirect to assign a Task
    * return type: PageReference
    * Date : 20/3/13 : Aditi Satpute
    */ 
	public PageReference assignTask() 
	{
		String url ='';
		ID etid = ApexPages.currentPage().getParameters().get('etid');
		String strType = ApexPages.currentPage().getParameters().get('type');
		ID eid = ApexPages.currentPage().getParameters().get('eid');
		String userType = ApexPages.currentPage().getParameters().get('userType');
		if(userType != null)
			url = '/apex/EditETforSwitch?etid='+etid+'%26type='+strType+'%26eid='+eid+'%26userType=opsTeam';
		else
		{
			ID approveActionPlanId = ApexPages.currentPage().getParameters().get('id');
			url = '/apex/EditETforSwitch?eid='+eid+'%26id='+approveActionPlanId+'%26type='+strType;
		}
	    PageReference redirect = new PageReference('/00T/e?retURL='+url); 
	    redirect.setRedirect(true); 
	    return redirect;
	}
	
	
	 /**
    * @Description: Get family details for parent entity
    * param: None 
    * return type: List<selectOption>
    */ 
    public List<selectOption> getEntities()
    {
        List<selectOption> options = new List<selectOption>();
        system.debug('***entityId****'+entityId);
        if(entityId != null)
        {
        	List<Account> lstAllMembers = objDatabaseSOQL.getFamilyDetails(entityId);
	        options.add(new selectOption('', '--None--'));
	        for(Account acc: lstAllMembers) 
	            options.add(new selectOption(acc.FirstName + ' '+ acc.LastName,acc.FirstName + ' '+ acc.LastName));
	        return options;
        }
        return null;
        
    }
	
	public List<selectOption> getApplicationStatus()
    {
    	List<selectOption> options = new List<selectOption>();
    	options.add(new selectOption(Label.Forms_Provided,Label.Forms_Provided));
    	options.add(new selectOption(Label.Forms_Handed,Label.Forms_Handed));
    	return options;
    }
	

}