/*
    Revision History:
    
    Version     Version Author     Date           Comments
    1.0         Gaurav  Kakariya   5/16/2013       To Show ARPP Detail record when action plan or execution tracker record saved. 
    
*/
public class ARPPDetailController 
{
	public String entityId{get;set;}
	public String strEntityName{get;set;}
	public Double orderAmount{get;set;}
	public List<ARPP_Detail__c>	lstARPPDetails{get;set;}
	public List<Order_Detail__c> lstOrderDetails{get;set;}
	public Double actionAmountRevenue{get;set;}
	public Double executionTrackerAmountRevenue{get;set;}
	public Double revenueDiffernece{get;set;}
	
	//public String strRevenueDifference{get;set;}
	//public List<WrapperARPP> lstWrapperARPP{get;set;}
	
	public Boolean isRender{get;set;}
	
	//Constructor
	public ARPPDetailController()
	{
		isRender = true;
		actionAmountRevenue = 0;
		executionTrackerAmountRevenue = 0;
		revenueDiffernece = 0;
		if(!ApexPages.currentPage().getParameters().containsKey('entityid') || ApexPages.currentPage().getParameters().get('entityid') == '')
		{
			isRender = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid or Insufficient Parameter(s)'));
            return;
		}   
		 
		initialise();
	}
	
	
	//This method initialise and collect the ARPP Detail Record
	private void initialise()
	{
		List<Account> lstEntity = new List<Account>();
		//lstWrapperARPP = new List<WrapperARPP>();
		Set<Id> setEntityId = new Set<Id>();
	 	entityId = ApexPages.currentPage().getParameters().get('entityid');
	 	
	 	lstEntity = [SELECT Id,Name, (Select Id,Name,Order_Number__c,Payable_Amount__c From Order_Details__r Order by CreatedDate Desc limit 1) FROM Account WHERE Id =: entityId OR Parent_Entity__c =: entityId];
	 	//lstOrderDetails = [Select Id,Name,Order_Number__c,Payable_Amount__c From Order_Detail__c Where Account__c =: entityId];
	 	lstOrderDetails =new List<Order_Detail__c>();
	 	//Collect EntityId from list of Entity
	 	for(Account objAccount : lstEntity)
	 	{
	 		if(objAccount.Id == entityId )
	 		{
	 			strEntityName = objAccount.Name;
	 			if (objAccount.Order_Details__r.size() != 0)
	 			    lstOrderDetails.add(objAccount.Order_Details__r[0]);
	 		}	
	 		setEntityId.add(objAccount.Id);
	 	}
	 	
	 	//Call to getARPPDetailRecord Method to collect ARPP Details Record
	 	getARPPDetailsRecord(setEntityId);
		
	}
	
	
	//Collect the ARPP Details Record
	private void getARPPDetailsRecord(Set<Id> setEntityId)
	{
		lstARPPDetails = new List<ARPP_Detail__c>();
		
	  	lstARPPDetails = [Select Product__r.Product_Manufacturer__c, 								
								Product__r.ProductType__c,ET_Remark__c,
								Product__r.Product_Name__c, Product__c, Name, Id, 
								Execution_Tracker_upfront_Comm_Amount__c,Execution_Tracker_Amount__c,
								Revenue_Difference__c, Execution_Tracker_Actual_Product__r.Product_Name__c,
								Execution_Tracker__c, Execution_Tracker_Trial_Comm_Amount__c,
								Execution_Tracker__r.Name, 
								Type__c, Action_Amount_Revenue__c,Execution_Tracker_Actual_Product__c,
								Entity__c, Entity__r.Name,Approve_Action_Plan__c, Action_Plan_Upfront_Comm_Amount__c, 
								Action_Plan_Trial_Comm_Amount__c, Action_Plan_Amount__c, 
								Approve_Action_Plan__r.Name,
								Execution_Tracker_Total_Revenue__c,Remark__c
						  From ARPP_Detail__c Where Entity__c IN: setEntityId order by Type__c];
						  
		for(ARPP_Detail__c objARPP : lstARPPDetails)
		{
			actionAmountRevenue += objARPP.Action_Amount_Revenue__c;
			executionTrackerAmountRevenue +=  objARPP.Execution_Tracker_Total_Revenue__c;
			revenueDiffernece +=  objARPP.Revenue_Difference__c;
		}				  
						  
	}
	//Method call from Recalcualte ARPP button
	public PageReference recalculateARPP()
	{
		actionAmountRevenue = 0;
		executionTrackerAmountRevenue = 0;
		revenueDiffernece = 0;
		initialise();
		return null;
	} 

	/*	
	//Wrapper Class
	public class WrapperARPP
	{
		public Double revenueDifference{get;set;}
		public ARPP_Detail__c objARPPDetail{get;set;} 
		
		public WrapperARPP( ARPP_Detail__c objARPPDetail)
		{
			this.objARPPDetail = objARPPDetail;
			revenueDifference = objARPPDetail.Action_Amount_Revenue__c - objARPPDetail.Execution_Tracker_Total_Revenue__c;
		}	
	}//end WrapperARPP Class
	
	*/
	
	/*Test method for ARPP Details*/
	@isTest
	public static void testARPPDetail()
	{
		Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
    	Schema.DescribeSObjectResult DESCRIBE_RESULT_INSURANCE = Insurance__c.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP_INSURANCE = DESCRIBE_RESULT_INSURANCE.getRecordTypeInfosByName();
    	
    	TestData_Ffreedom testData = new TestData_Ffreedom();
    	
    	//Insert RecordType record
    	List<RecTypes__c> lstRecTypes = new List<RecTypes__c>();
    	RecTypes__c objRecType = new RecTypes__c(Name='General_Business', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	
    	RecTypes__c objRecType1 = new RecTypes__c(Name='AccountFamily', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('Family Member').getRecordTypeId());
    	RecTypes__c objRecType2 = new RecTypes__c(Name='AccountClient', 
    											 Record_Type_Value__c=RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId());
    	
    	lstRecTypes.add(objRecType);										 
    	lstRecTypes.add(objRecType1);
    	lstRecTypes.add(objRecType2);	
    	insert lstRecTypes;
    	
    	InsuranceRecTypes__c objInsuranceRecType = new InsuranceRecTypes__c(Name='Life Insurance', 
    											RecordTypeId__c=RECORD_TYPE_INFO_MAP_INSURANCE.get('Life Insurance').getRecordTypeId());
    							
    	insert 	objInsuranceRecType;
    										 											 										 
    	List<Account> lstAccount = new List<Account>();
    	
    	//Insert smagicbasic SMS Template record 
    	List<smagicbasic__SMS_Template__c> lstTemplate = new List<smagicbasic__SMS_Template__c>();
    	
    	smagicbasic__SMS_Template__c template= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Discontinuation Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	
    	smagicbasic__SMS_Template__c template1= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Renewal Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	lstTemplate.add(template);
    	lstTemplate.add(template1);
    	
    	insert lstTemplate;
    	
    	ID ProfileID = [ Select Id from Profile where name = 'Financial Planner'].Id;
      	User objUser = new User(email='test-user@fakeemail1.com', profileid = ProfileID, UserName='test-user@fakeemail1.com', 
      	 							alias='tuser11', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', 
      	 							LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname1',
      	 						    LastName = 'Test_Parent_Lname1' );

        insert objUser;
        
    	//Insert Account record
    	Account objGeneralAccount = new Account(Name='Parner Account Test',
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	
        Account objAccount1 = new Account(LastName='Test Freedom', Adjustment_Factor__c='2', OwnerId = objUser.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
	                       PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Ffreedom',
	                       RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId(),Will__c = true);
	                       
	    lstAccount.add(objAccount1);
	    lstAccount.add(objGeneralAccount);               
		insert lstAccount;
      			
      	//Call without passing Url parameter(s)	
	    ARPPDetailController objARPP = new ARPPDetailController();
	                  											
		ApexPages.currentPage().getParameters().put('entityid',objAccount1.Id);
		
		//Insert ARPP Detail record
		ARPP_Detail__c objARPPDetail = new ARPP_Detail__c(Entity__c = objAccount1.Id );
		//insert objARPPDetail;
		
		ARPPDetailController objARPP1 = new ARPPDetailController();
		objARPP1.recalculateARPP();
		
	}
	
}//end of ARPPDetailController class