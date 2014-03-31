public class WorkstationInTemplate_Controller {
	
	public String userId{get;set;}
	public String AccountName{get;set;}
	
	public String FPName{get;set;}
	public String FinancialAdvisor{get;set;}
	public String Manager{get;set;}
	public String MET{get;set;}
	
	public String FPEmail{get;set;}
	public String mgrEmail{get;set;}
	public String FAEmail{get;set;}
	public String METEmail{get;set;}
	
	public String FPMobile{get;set;}
	public String mgrMobile{get;set;}
	public String FAMobile{get;set;}
	public String METMobile{get;set;}
	
	public WorkstationInTemplate_Controller(){
	}

	private List<Workstation__c> getWorkstation()
	{
		List<Workstation__c> lstWorkstation = [Select OwnerId, Name, Member_Engagement__c, Manager__c, Id, Financial_Planner__c, Compliance__c, 
													  Business_Developer__c, Advisory__c 
											   From Workstation__c where Financial_Planner__c =: userId limit 1];
						
			system.debug('******lstWorkstation***in getWorkStation*****'+lstWorkstation);					   
		return lstWorkstation;
	}
	
	public String getMergeFields()
	{
		User objUser;
		List<Workstation__c> lstWorkstation = getWorkstation();
		
		if(lstWorkstation.size() > 0)
		{
			system.debug('******lstWorkstation********'+lstWorkstation);
			objUser = [Select Id, Name, Email, MobilePhone From User where Id =: lstWorkstation[0].Financial_Planner__c limit 1];
			FPName = objUser.Name;
			FPEmail = objUser.Email;
			FPMobile = objUser.MobilePhone;
	
			objUser = [Select Id, Name, Email, MobilePhone From User where Id =: lstWorkstation[0].Advisory__c limit 1];
			FinancialAdvisor = objUser.Name;
			FAEmail = objUser.Email;
			FAMobile = objUser.MobilePhone;
			
			objUser = [Select Id, Name, Email, MobilePhone From User where Id =: lstWorkstation[0].Manager__c limit 1];
			Manager = objUser.Name;
			mgrEmail = objUser.Email;
			mgrMobile = objUser.MobilePhone;
			
			objUser = [Select Id, Name, Email, MobilePhone From User where Id =: lstWorkstation[0].Member_Engagement__c limit 1];
			MET = objUser.Name;
			METEmail = objUser.Email;
			METMobile = objUser.MobilePhone;
		}

		return null;
	}
	
/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     23/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/	
	
	
	@isTest
	static void TestWorkstationInTemplate_Controller()
	{
		Test.StartTest();
		User user;
		
		TestData_Ffreedom testData = new TestData_Ffreedom();
		user = testData.initializeUser();
	    insert user;
	    
		WorkstationInTemplate_Controller Testworkstation = new WorkstationInTemplate_Controller();
		Workstation__c workstation = testData.init_workstation(user);
		List<Workstation__c> lstTestWorkstation = new List<Workstation__c>();
		lstTestWorkstation.add(workstation);
		insert lstTestWorkstation;
		Testworkstation.getMergeFields();
		Test.stopTest();
	}
}