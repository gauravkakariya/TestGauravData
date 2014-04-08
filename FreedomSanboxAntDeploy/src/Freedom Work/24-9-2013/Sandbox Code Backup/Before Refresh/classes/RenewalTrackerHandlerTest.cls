/**
*  Test class for Handler class RenewalTrackerHandler of RenewalTrackerTrigger
*
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Aditi    		11/04/2013      Initial Draft
*/


public class RenewalTrackerHandlerTest 
{
    //test Method
	@isTest(SeeAllData=true)
	public static  void testRenewalTrackerForGeneralInsurance() 
	{
		 
		RecordType objRT = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
		Account objAccount = new Account(LastName='Test',FirstName='Test',Adjustment_Factor__c='2',
	                       PersonTitle='TestData', PersonBirthdate= system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463711111',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034, Residential_Status_del__c='own', Retirement_Age__c='58', Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041, Relationship_to_Entity__pc='husband', RecordTypeId = objRT.Id);
	    insert objAccount;
	    
	   
	    Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c(Account__c = objAccount.Id);
	    insert objAAP1;
	    
	    Approve_Action_Plan__c objAAP2 = new Approve_Action_Plan__c(Account__c = objAccount.Id);
	    insert objAAP2;
        
        List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
        Execution_Tracker__c objET1 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Risk_Commencement_Date__c = system.today(),Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP1.Id, Type__c = 'General Insurance');
        lstET.add(objET1);
        Execution_Tracker__c objET2 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Risk_Commencement_Date__c = system.today(),Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP2.Id, Type__c = 'General Insurance');
        lstET.add(objET2);
        Execution_Tracker__c objET3 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Risk_Commencement_Date__c = system.today(),Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP1.Id, Type__c = 'General Insurance');
        lstET.add(objET3);
        Execution_Tracker__c objET4 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Risk_Commencement_Date__c = system.today(),Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP2.Id, Type__c = 'General Insurance');
        lstET.add(objET4);
        insert lstET;
        
        List<Renewal_Tracker__c> lstRenewalRracker = new List<Renewal_Tracker__c>();
        Renewal_Tracker__c objRenewalTracker1 = new Renewal_Tracker__c(Execution_Tracker__c=objET1.Id,Entity__c = objAccount.id,Tenure_of_Insurance__c=12,Insurance_Type__c='General Insurance');
        lstRenewalRracker.add(objRenewalTracker1);
      	Renewal_Tracker__c objRenewalTracker2 = new Renewal_Tracker__c(Execution_Tracker__c=objET2.Id,Entity__c = objAccount.id,Tenure_of_Insurance__c=12,Insurance_Type__c='General Insurance');
      	lstRenewalRracker.add(objRenewalTracker2);
        Renewal_Tracker__c objRenewalTracker3 = new Renewal_Tracker__c(Execution_Tracker__c=objET3.Id,Entity__c = objAccount.id,Tenure_of_Insurance__c=12,Insurance_Type__c='General Insurance');
        lstRenewalRracker.add(objRenewalTracker3);
  		Renewal_Tracker__c objRenewalTracker4 = new Renewal_Tracker__c(Execution_Tracker__c=objET4.Id,Entity__c = objAccount.id,Tenure_of_Insurance__c=12,Insurance_Type__c='General Insurance');
  		lstRenewalRracker.add(objRenewalTracker4);
        insert lstRenewalRracker;
        
        Renewal_Tracker__c objRenewalTracker5 = new Renewal_Tracker__c(Execution_Tracker__c=objET4.Id,Entity__c = objAccount.id,Insurance_Type__c='General Insurance',
        				ParentId__c = objRenewalTracker4.Id,Tenure_of_Insurance__c=12);
  		insert objRenewalTracker5;
        
	    objET1.Mode__c = 'Quaterly';
    	objET2.Mode__c = 'Monthly';	
    	objET3.Mode__c = 'Annual';
    	objET4.Mode__c = 'Semi-Annual';
    	update lstET;
    	
    	
    	List<Renewal_Tracker__c> lstUpdateRT = new List<Renewal_Tracker__c>();
    	objRenewalTracker1.Next_renewal_date__c = system.today();
    	objRenewalTracker1.Target_Revenue__c = 200;
    	objRenewalTracker1.Cheque_Submission_date__c = system.today();
    	lstUpdateRT.add(objRenewalTracker1);
    	
    	objRenewalTracker2.Next_renewal_date__c = system.today();
    	objRenewalTracker2.Target_Revenue__c = 200;
    	objRenewalTracker2.Cheque_Submission_date__c = system.today();
    	lstUpdateRT.add(objRenewalTracker2);
    	
    	objRenewalTracker3.Next_renewal_date__c = system.today();
    	objRenewalTracker3.Target_Revenue__c = 200;
    	objRenewalTracker3.Cheque_Submission_date__c = system.today();
    	lstUpdateRT.add(objRenewalTracker3);
    	
    	objRenewalTracker4.Next_renewal_date__c = system.today();
    	objRenewalTracker4.Target_Revenue__c = 200;
    	objRenewalTracker4.Cheque_Submission_date__c = system.today();
    	lstUpdateRT.add(objRenewalTracker4);
    	
    	objRenewalTracker5.Next_renewal_date__c = system.today();
    	objRenewalTracker5.Target_Revenue__c = 200;
    	objRenewalTracker5.Cheque_Submission_date__c = system.today();
    	lstUpdateRT.add(objRenewalTracker5);
    	
    	update lstUpdateRT;
    	
	}
	
	
	@isTest(SeeAllData=true)
	public static  void testRenewalTrackerForLifeInsurance()
	{
		 
		RecordType objRT = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
		Account objAccount = new Account(LastName='Test',FirstName='Test',Adjustment_Factor__c='2',
	                       PersonTitle='TestData', PersonBirthdate= system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034, Residential_Status_del__c='own', Retirement_Age__c='58', Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041, Relationship_to_Entity__pc='husband', RecordTypeId = objRT.Id);
	    insert objAccount;
	    
	   
	    Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c(Account__c = objAccount.Id);
	    insert objAAP1;
	    
	    Approve_Action_Plan__c objAAP2 = new Approve_Action_Plan__c(Account__c = objAccount.Id);
	    insert objAAP2;
        
        List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
        Execution_Tracker__c objET1 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,Term_No_Of_Years__c=12,
        									Risk_Commencement_Date__c = system.today(),Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP1.Id, Type__c = 'Life Insurance');
        lstET.add(objET1);
        Execution_Tracker__c objET2 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,Term_No_Of_Years__c=12,
        									Risk_Commencement_Date__c = system.today(),Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP2.Id, Type__c = 'Life Insurance');
        lstET.add(objET2);
        Execution_Tracker__c objET3 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,Term_No_Of_Years__c=12,
        									Risk_Commencement_Date__c = system.today(),Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP1.Id, Type__c = 'Life Insurance');
        lstET.add(objET3);
        Execution_Tracker__c objET4 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,Term_No_Of_Years__c=12,
        									Risk_Commencement_Date__c = system.today(),Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP2.Id, Type__c = 'Life Insurance');
        lstET.add(objET4);
        insert lstET;
    	objET1.Mode__c = 'Quaterly';
    	objET2.Mode__c = 'Monthly';
    	objET3.Mode__c = 'Annual';
    	objET4.Mode__c = 'Semi-Annual';
    	update lstET;
        
      	List<Renewal_Tracker__c> lstRenewalRracker = new List<Renewal_Tracker__c>();
        Renewal_Tracker__c objRenewalTracker1 = new Renewal_Tracker__c(Execution_Tracker__c=objET1.Id,Entity__c = objAccount.id,Tenure_of_Insurance__c=12,Insurance_Type__c='Life Insurance');
        lstRenewalRracker.add(objRenewalTracker1);
      	Renewal_Tracker__c objRenewalTracker2 = new Renewal_Tracker__c(Execution_Tracker__c=objET2.Id,Entity__c = objAccount.id,Tenure_of_Insurance__c=12,Insurance_Type__c='Life Insurance');
      	lstRenewalRracker.add(objRenewalTracker2);
        Renewal_Tracker__c objRenewalTracker3 = new Renewal_Tracker__c(Execution_Tracker__c=objET3.Id,Entity__c = objAccount.id,Tenure_of_Insurance__c=12,Insurance_Type__c='Life Insurance');
        lstRenewalRracker.add(objRenewalTracker3);
  		Renewal_Tracker__c objRenewalTracker4 = new Renewal_Tracker__c(Execution_Tracker__c=objET4.Id,Entity__c = objAccount.id,Tenure_of_Insurance__c=12,Insurance_Type__c='Life Insurance');
  		lstRenewalRracker.add(objRenewalTracker4);
        
        insert lstRenewalRracker;
       
    	objRenewalTracker1.Next_renewal_date__c = system.today();
    	objRenewalTracker1.Target_Revenue__c = 200;
    	objRenewalTracker1.Cheque_Submission_date__c = system.today();
    	
    	objRenewalTracker2.Next_renewal_date__c = system.today();
    	objRenewalTracker2.Target_Revenue__c = 200;
    	objRenewalTracker2.Cheque_Submission_date__c = system.today();
    	
    	objRenewalTracker3.Next_renewal_date__c = system.today();
    	objRenewalTracker3.Target_Revenue__c = 200;
    	objRenewalTracker3.Cheque_Submission_date__c = system.today();
    	
    	objRenewalTracker4.Next_renewal_date__c = system.today();
    	objRenewalTracker4.Target_Revenue__c = 200;
    	objRenewalTracker4.Cheque_Submission_date__c = system.today();
    	update objRenewalTracker1;
	}
}