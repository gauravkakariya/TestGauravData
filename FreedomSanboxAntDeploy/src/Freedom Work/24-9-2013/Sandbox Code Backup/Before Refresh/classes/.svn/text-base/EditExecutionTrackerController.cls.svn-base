/*
	Revision History:
	
    Version     Version Author     Date           Comments
    1.0			Anupam	          2/01/13		 Display field on new window launched from ET readonly page.
*/

public with sharing class EditExecutionTrackerController 
{
	//Public variables.
	public String strType{get;set;}
	public Boolean isSipOrLumpsum {get;set;}
	public Boolean isGeneralOrLife {get;set;}
	public Boolean isError{get;set;}
	public Execution_Tracker__c objExecutionTracker {get;set;}
	public String MFlumpsumHolder {get;set;}
	public String lumpsumHolder {get;set;}
	public String MFSIPHolder {get;set;}
	public String SIPHolder {get;set;}
	public String lifeInsuranceHolder {get;set;}
	public String generalInsuranceHolder {get;set;}
	public Boolean isReadOnly {get;set;}
	public Boolean isClosed {get;set;}
	//Local variables
	private DatabaseSOQL objDatabaseSOQL;
	private Set<Id> setEntityFamilyMemberId ;
	private String entityId;
	private String strApproveActionPlanId;
	
	//Constructor
	public EditExecutionTrackerController()
	{
		//Variable initialization
		objDatabaseSOQL = new DatabaseSOQL();
		setEntityFamilyMemberId = new Set<Id>();
		objExecutionTracker = new Execution_Tracker__c();
		isSipOrLumpsum = false;
		isGeneralOrLife = false;
		isError = false;
		
		entityId = Apexpages.currentPage().getParameters().get('eid');
		strApproveActionPlanId = Apexpages.currentPage().getParameters().get('id');
		strType = Apexpages.currentPage().getParameters().get('type');
		
		//Collect Entity Id and family memberId.
		for(Account objAccount :[SELECT Id FROM Account WHERE (isPersonAccount =: true AND Parent_Entity__c =: entityId) OR (Id =: entityId) order by Id])
		{
			setEntityFamilyMemberId.add(objAccount.Id);
		}
		
		if(strType.equalsIgnoreCase('Lumpsum') || strType.equalsIgnoreCase('sip') || strType.equalsIgnoreCase('GoalSIP') || strType.equalsIgnoreCase('GoalLumpsum') )
		{
			showMutualFundPopUp();
			isSipOrLumpsum = true;
		}
		if(strType.equalsIgnoreCase('General Insurance') || strType.equalsIgnoreCase('Life Insurance'))
		{
			showMutualFundPopUp();
			isGeneralOrLife = true;
		}
		
	}
	public void showMutualFundPopUp()
	{
		//Life Insurance and General Insurance
        if(strType.equalsIgnoreCase('General Insurance') || strType.equalsIgnoreCase('Life Insurance'))
		{
       	 	String strInsuranceQuery = 'select Id, Agreed_Amount__c, Approve_Action_Plan__c,Approve_Action_Plan__r.Insurance__r.Policy_Type__c,Suggested_Amount__c ,' + 
				      'Approve_Action_Plan__r.Insurance__r.Tenure_of_Insurance__c,Approve_Action_Plan__r.Insurance__r.Entity__r.Name,' +
				      'Approve_Action_Plan__r.Insurance__r.Suggested_Cover_General_Insurance__c,Approve_Action_Plan__r.Insurance__r.Premium_Amount_Rs__c ,'+
				      'Login_Date__c ,  Policy_Name__c ,Policy_Number__c ,Previous_Policy_Number__c ,Risk_Commencement_Date__c ,Sum_Assured__c ,Mode__c , '+
				      'Annualised_Premium_Amount__c ,Remarks__c ,Renewal_Alert__c ,Renewal_Status__c ,Renewal_Date__c ,Gross_Premium__c ,Net_Premium__c ,'+
				      'Nominee__c ,Cheque_Amount__c ,Cheque_No__c ,Term_No_Of_Years__c ,Application_No__c ,Mode_Of_Payment__c ,Policy_Status__c ,' +
				      'Renewal_Remark__c ,Pol_Doc_Recd_Status__c ,Target_Revenue__c ,Booked_Revenue__c , Send_SMS__c ,Send_Email__c , Send_SMS_Datetime__c ,' +
			      	  'Executed_Amount__c , Cancelled_Reason__c ,Completion_Date__c ,Communication_Address__c, Mobile__c, Email__c ,Send_Email_Datetime__c ,' +
			      	  'Other_Insured_1_Name__c ,Other_Insured_2_Name__c ,Other_Insured_3_Name__c ,Other_Insured_4_Name__c ,Other_Insured_5_Name__c,' +
			      	  'Other_Insured_1_DOB__c ,Other_Insured_2_DOB__c ,Other_Insured_3_DOB__c ,Other_Insured_4_DOB__c ,Other_Insured_5_DOB__c,' +
			      	  'Other_Insured_1_Gender__c ,Other_Insured_2_Gender__c ,Other_Insured_3_Gender__c ,Other_Insured_4_Gender__c ,Other_Insured_5_Gender__c, ' +
			      	  'Approve_Action_Plan__r.Policy_Name__c, Application_Status__c, Executed_Product_Name__c, Balance_Remaining__c,'+
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
		}
		else
		{
	    	String strQuery ='select Id, Agreed_Amount__c, Approve_Action_Plan__c,Type__c,Approve_Action_Plan__r.Investment_Asset__r.Scheme_Name_Text__c,Approve_Action_Plan__r.Account__r.Name,'+
	    			'Approve_Action_Plan__r.Investment_Asset__r.Monthly_SIP_Amount__c,Approve_Action_Plan__r.SIP_Action_Amount__c,Approve_Action_Plan__r.Amount__c,'+
	    			'Approve_Action_Plan__r.SIP_Action__c,Approve_Action_Plan__r.Investment_Asset__r.Asset_Type__c,Approve_Action_Plan__r.Lumpsum_Action__c,'+
	    			'Approve_Action_Plan__r.Action_Amount__c , Completion_Date__c ,  STP_Installments__c ,Account_Type__c,PAN_No_Third_holder__c ,'+
					'Mode_of_holding__c, Status__c, Investor_Name_as_in_PAN_card__c, Communication_Address__c, Mobile__c, Email__c, Account_Number__c ,'+
 					'DOB__c, PAN__c, Guardian_Name_as_PAN_card__c, PAN_No_Guardian__c, DOB_Guardian__c, ET_Status__c , STP_Amount_per_transfer__c,'+
					'Target_Revenue__c ,Booked_Revenue__c , Send_SMS__c ,Send_Email__c , Send_SMS_Datetime__c ,Send_Email_Datetime__c ,Suggested_Amount__c , '+
					'Executed_Amount__c , Cancelled_Reason__c , IFSC_Code__c , MICR_Code__c , Bank_Name__c ,Branch_Address__c ,Investor_Name_As_in_bank_record__c,'+
					'Nominee_s_Name__c ,Nominee_s_DOB__c,Guardian_Name_In_case_nominee_is_minor__c ,Name_of_Second_holder__c ,DOB_Second_holder__c,'+
					'PAN_No_Second_holder__c , Name_of_Third_holder__c ,DOB_Third_holder__c,  Goal__r.Description__c , Holder_Name__c ,Application_Status__c, '+
					//SIP Fields
					'Approve_Action_Plan__r.Installments__c,Approve_Action_Plan__r.Option__c,Approve_Action_Plan__r.Remarks__c, Approve_Action_Plan__r.Category__c, '+
					'Approve_Action_Plan__r.Product_Name__c,Approve_Action_Plan__r.Transaction_Type__c, Executed_Product_Name__c, Balance_Remaining__c,' +
					//Lumpsum Fields
					'Approve_Action_Plan__r.Fund__c, Approve_Action_Plan__r.Amount_Per_Installment__c ' +
					'from Execution_Tracker__c where Entity_Name__c IN :setEntityFamilyMemberId and Approve_Action_Plan__c = :strApproveActionPlanId ';
		
			if(strType.equalsIgnoreCase('Lumpsum') || strType.equalsIgnoreCase('SIP'))
			{
				strQuery += ' and Type__c =: strType';
			}
			for(Execution_Tracker__c objET : Database.query(strQuery))
	        {
		    	objExecutionTracker = objET;
	        }		
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
		update objExecutionTracker;
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
}