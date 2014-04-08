/*
    Revision History:
    
    Version     Version Author     Date           Comments
    1.0         Aditi Satpute     15/03/2013     Display field on new window launched from ET readonly page for 
    											 Life Insurance Pop up for MET and Ops Team
*/

public with sharing class EditETforLifeInsurance 
{
	//Public variables.
	public String strType{get;set;}
	public Boolean isLifeInsurance {get;set;}
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
	public Boolean isLifeInsuranceForOps{get;set;}
	
	public String strProductName{get;set;}
	private ActionPlanUtility objActionPlanUtility; 
	private Map<String,String> mapTypeToProductNames;
	
	//Constructor
	public EditETforLifeInsurance()
	{
		//Variable initialization
		objDatabaseSOQL = new DatabaseSOQL();
		setEntityFamilyMemberId = new Set<Id>();
		objExecutionTracker = new Execution_Tracker__c();
		isLifeInsurance = false;
		isLifeInsuranceForOps = false;
		isError = false;
		entityId = Apexpages.currentPage().getParameters().get('eid');
		executionTrackerId = Apexpages.currentPage().getParameters().get('etid');
		strApproveActionPlanId = Apexpages.currentPage().getParameters().get('id');
		strType = Apexpages.currentPage().getParameters().get('type');
		objActionPlanUtility =  new ActionPlanUtility();
		
		//Collect Entity Id and family memberId.
		for(Account objAccount :[SELECT Id FROM Account WHERE (isPersonAccount =: true AND Parent_Entity__c =: entityId) OR (Id =: entityId) order by Id])
		{
			setEntityFamilyMemberId.add(objAccount.Id);
		}
		if(strType.equalsIgnoreCase('Life Insurance'))
		{
			showMutualFundPopUp();
			isLifeInsurance = true;
		}
		//strType "other" is used for distinguishing Ops team
		if(strType.equalsIgnoreCase('other'))
		{
			Map<String, Schema.SObjectType> mapGlobalDescribe = Schema.getGlobalDescribe();
			Schema.SObjectType stdETObject = mapGlobalDescribe.get('Execution_Tracker__c');
			Schema.DescribeSObjectResult descStdET = stdETObject.getDescribe();
			Map<String, Schema.SObjectField> stdETfields = descStdET.fields.getMap();
			String strQuery = 'Select Goal__r.Description__c,Approve_Action_Plan__r.Insurance__r.Entity__r.Name,Approve_Action_Plan__r.Insurance__r.Suggested_Cover_General_Insurance__c, ';
			strQuery += 'Approve_Action_Plan__r.Policy_Name__c,Approve_Action_Plan__r.Insurance__r.Policy_Type__c,Approve_Action_Plan__r.Premium_Amount_Rs__c, ';
			strQuery += 'Approve_Action_Plan__r.Tenure_of_Insurance__c,Approve_Action_Plan__r.Sum_Assured_Rs__c, ';
			for(String strField : stdETfields.keySet())
			{
				strQuery += strField + ',';
			}
			strQuery = strQuery.substring(0, strQuery.length() - 1);
			
			strQuery += ' from Execution_Tracker__c where Id =: executionTrackerId ';
			for(Execution_Tracker__c objET : Database.query(strQuery))
			{
				objExecutionTracker = objET;
			}
			isReadOnly = objExecutionTracker.Application_Status__c == 'Processed';
			isLifeInsuranceForOps = true;
		}
			
       		getProductName();
	}
	
	public void getProductName()
	{
       	strProductName  = objActionPlanUtility.getProductName(objExecutionTracker.Type__c);
       	mapTypeToProductNames = new Map<String,String>{'Life Insurance' => strProductName };
	}
	
	
	public void showMutualFundPopUp()
	{
   	 	String strInsuranceQuery = 'select Id, Type__c, Agreed_Amount__c, Approve_Action_Plan__c,Approve_Action_Plan__r.Insurance__r.Policy_Type__c,Suggested_Amount__c ,' + 
			      'Approve_Action_Plan__r.Insurance__r.Tenure_of_Insurance__c,Approve_Action_Plan__r.Insurance__r.Entity__r.Name,Asset_Class_Policy_Type__c,' +
			      'Approve_Action_Plan__r.Insurance__r.Suggested_Cover_General_Insurance__c,Approve_Action_Plan__r.Insurance__r.Premium_Amount_Rs__c ,'+
			      'Login_Date__c ,  Policy_Name__c ,Policy_Number__c ,Previous_Policy_Number__c ,Risk_Commencement_Date__c ,Sum_Assured__c ,Mode__c , '+
			      'Annualised_Premium_Amount__c ,Remarks__c ,Renewal_Alert__c ,Renewal_Status__c ,Renewal_Date__c ,Gross_Premium__c ,Net_Premium__c ,'+
			      'Nominee__c ,Cheque_Amount__c ,Cheque_No__c ,Term_No_Of_Years__c ,Application_No__c ,Mode_Of_Payment__c ,Policy_Status__c ,' +
			      'Renewal_Remark__c ,Pol_Doc_Recd_Status__c ,Target_Revenue__c ,Booked_Revenue__c , Send_SMS__c ,Send_Email__c , Send_SMS_Datetime__c ,' +
		      	  'Executed_Amount__c , Cancelled_Reason__c ,Completion_Date__c ,Communication_Address__c, Mobile__c, Email__c ,Send_Email_Datetime__c ,' +
		      	  'Other_Insured_1_Name__c ,Other_Insured_2_Name__c ,Other_Insured_3_Name__c ,Other_Insured_4_Name__c ,Other_Insured_5_Name__c,' +
		      	  'Other_Insured_1_DOB__c ,Other_Insured_2_DOB__c ,Other_Insured_3_DOB__c ,Other_Insured_4_DOB__c ,Other_Insured_5_DOB__c,AssignToOps__c ,' +
		      	  'Other_Insured_1_Gender__c ,Other_Insured_2_Gender__c ,Other_Insured_3_Gender__c ,Other_Insured_4_Gender__c ,Other_Insured_5_Gender__c,isAssignedToOps__c, ' +
		      	  'Approve_Action_Plan__r.Policy_Name__c, Application_Status__c, Executed_Product_Name__c, Balance_Remaining__c,Insured__c,'+
		      	  'Insured_Name__c,Premium__c,Policy_Punch_date__c,Agreed_Life_Insurance_Company_Name__c,Preferable_Medical_date__c ,'+
		      	  //General Insurance fields
		      	  'Approve_Action_Plan__r.Insurance__r.Policy_Name__c,Approve_Action_Plan__r.Product_Name__c,Approve_Action_Plan__r.Insurance__r.Sum_Assured_Rs__c,'+
		      	  //Added on:18/02/2013 : Aditi Satpute : AP changes 
		      	  'Approve_Action_Plan__r.Sum_Assured_Rs__c,Approve_Action_Plan__r.Premium_Amount_Rs__c,Approve_Action_Plan__r.Tenure_of_Insurance__c, '+
		      	  'Approve_Action_Plan__r.Insured__c,Approve_Action_Plan__r.Policy_Type__c '+
		      	  
		      	  'from Execution_Tracker__c where Entity_Name__c IN :setEntityFamilyMemberId '+
		      	  'and Approve_Action_Plan__c = :strApproveActionPlanId '+
		      	  'and Type__c =: strType';
		
		for(Execution_Tracker__c objET : Database.query(strInsuranceQuery))
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
		//if((objExecutionTracker.Agreed_Amount__c == 0 || objExecutionTracker.Agreed_Amount__c == null) && objExecutionTracker.isAssignedToOps__c == true)
			//objExecutionTracker.isAssignedToOps__c = false;
		/*Changes by Gaurav (6-8-2013):  To validate product name from SIP/Lumpsum*/  
    	if(!(mapTypeToProductNames.get('Life Insurance').contains('"'+objExecutionTracker.Executed_Product_Name__c+'"')))
    	{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.EditET_Agreed_Product_Name_Message));
            return;
        }
        /* End Changes*/
        	
		updateARPPDetail();	
		update objExecutionTracker;
		isError = true;
	}
	
	private void updateARPPDetail()
	{
		List<Product_Master__c> lstProductMaster = [Select Id, Product_Name__c, ProductType__c, Investment_Type__c,
														(Select Id, Active__c,Min_Year_Value__c,Max_Year_Value__c  From Commissions__r Where Active__c = true) 
													From Product_Master__c Where   
														Product_Name__c =: objExecutionTracker.Executed_Product_Name__c and
														ProductType__c = 'Life Insurance' and Is_Active__c = true];
				
		Product_Master__c objProductMaster = lstProductMaster.isEmpty() ? null : lstProductMaster[0];												
		objExecutionTracker.Execution_Tracker_Product__c = objProductMaster == null ? null : objProductMaster.Id;	
		
		List<ARPP_Detail__c> lstARPPDetails = [Select Product__r.Product_Manufacturer__c, 								
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
		
		List<Commission__c> lstCommission = objProductMaster != null ? objProductMaster.Commissions__r : null;
		Commission__c objComm;
		if(lstCommission != null)
		{
			for(Commission__c comm : lstCommission)
			{
				if(comm.Min_Year_Value__c <= objExecutionTracker.Approve_Action_Plan__r.Tenure_of_Insurance__c && objExecutionTracker.Approve_Action_Plan__r.Tenure_of_Insurance__c < comm.Max_Year_Value__c)
				{
					objComm = comm;
					break;
				}
			}
		}
		if(!lstARPPDetails.isEmpty())
		{
			ARPP_Detail__c objARPPDetails = lstARPPDetails[0]; 
			objARPPDetails.Execution_Tracker_Actual_Product__c = objProductMaster != null ? objProductMaster.Id : null;
			objARPPDetails.Actual_Commission__c = objProductMaster != null && objComm != null ? objComm.Id : null;
			objARPPDetails.ET_Remark__c = objProductMaster != null &&  objProductMaster.Commissions__r.size() == 0 ? Label.Actual_Commission : '';
			
			update objARPPDetails ;
		}
			 					 
	}
	
	 /**
    * @Description: redirect to assign a Task
    * return type: PageReference
    * Date : 19/3/13 : Aditi Satpute
    */ 
	public PageReference assignTask() 
	{
		String url ='';
	    ID etid = ApexPages.currentPage().getParameters().get('etid');
		String strType = ApexPages.currentPage().getParameters().get('type');
		ID eid = ApexPages.currentPage().getParameters().get('eid');
		if(strType == 'other')
			url = '/apex/EditETforLifeInsurance?etid='+etid+'%26type='+strType+'%26eid='+eid;
		else
		{
			ID approveActionPlanId = ApexPages.currentPage().getParameters().get('id');
			url = 'apex/EditETforLifeInsurance?eid='+eid+'%26id='+approveActionPlanId+'%26type='+strType;
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
        List<Account> lstAllMembers = objDatabaseSOQL.getFamilyDetails(entityId);
        options.add(new selectOption('', '--None--'));
        for(Account acc: lstAllMembers) 
            options.add(new selectOption(acc.FirstName + ' '+ acc.LastName,acc.FirstName + ' '+ acc.LastName));
        return options;
    }
    
    public List<selectOption> getApplicationStatus()
    {
    	List<selectOption> options = new List<selectOption>();
    	options.add(new selectOption(Label.Forms_Provided,Label.Forms_Provided));
    	options.add(new selectOption(Label.Forms_Handed,Label.Forms_Handed));
    	return options;
    }
}