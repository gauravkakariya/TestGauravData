/**
*  Test class for Controller class CreateRenewal_OnExecutionTrackerInsUp
*
*   Revision History:
*
*   Version        Author             Date            Description
*   1.0            Aditi           11/04/2013      Initial Draft
*/


public class CreateRenewal_OnETInsUpTest 
{
    //test Method
	@isTest
	public static  void testRenewalTrackerForGeneralInsurance()
	{
		Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
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
    	
    	//Insert smagicbasic SMS Template record 
    	List<smagicbasic__SMS_Template__c> lstTemplate = new List<smagicbasic__SMS_Template__c>();
    	
    	smagicbasic__SMS_Template__c template= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Discontinuation Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	
    	smagicbasic__SMS_Template__c template1= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Renewal Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	lstTemplate.add(template);
    	lstTemplate.add(template1);
    	
    	insert lstTemplate;
    	 
		//RecordType objRT = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
		
		   //Insert Account record
    	Account objBPAccount = new Account(Name='Parner Account Test',
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	insert 	objBPAccount;
    	
		Account objAccount = new Account(LastName='Test',FirstName='Test',Adjustment_Factor__c='2',
	                       PersonTitle='TestData', PersonBirthdate= system.today(),PersonHomePhone='54623676',PersonMobilePhone='54637',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034, Residential_Status_del__c='own', Retirement_Age__c='58', Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041, Relationship_to_Entity__pc='husband', RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId());
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
        Renewal_Tracker__c objRenewalTracker1 = new Renewal_Tracker__c(Execution_Tracker__c=objET1.Id,Entity__c = objAccount.id);
        lstRenewalRracker.add(objRenewalTracker1);
      	Renewal_Tracker__c objRenewalTracker2 = new Renewal_Tracker__c(Execution_Tracker__c=objET2.Id,Entity__c = objAccount.id);
      	lstRenewalRracker.add(objRenewalTracker2);
        Renewal_Tracker__c objRenewalTracker3 = new Renewal_Tracker__c(Execution_Tracker__c=objET3.Id,Entity__c = objAccount.id);
        lstRenewalRracker.add(objRenewalTracker3);
  		Renewal_Tracker__c objRenewalTracker4 = new Renewal_Tracker__c(Execution_Tracker__c=objET4.Id,Entity__c = objAccount.id);
  		lstRenewalRracker.add(objRenewalTracker4);
        
        insert lstRenewalRracker;
        
	    objET1.Mode__c = 'Quaterly';
    	objET2.Mode__c = 'Monthly';
    	objET3.Mode__c = 'Annual';
    	objET4.Mode__c = 'Semi-Annual';
    	update lstET;
	}
	
	
	@isTest
	public static  void testRenewalTrackerForLifeInsurance()
	{
		 Schema.DescribeSObjectResult DESCRIBE_RESULT = Account.SobjectType.getDescribe();
    	Map<String, Schema.RecordTypeInfo> RECORD_TYPE_INFO_MAP = DESCRIBE_RESULT.getRecordTypeInfosByName();
    	
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
    	
    	//Insert smagicbasic SMS Template record 
    	List<smagicbasic__SMS_Template__c> lstTemplate = new List<smagicbasic__SMS_Template__c>();
    	
    	smagicbasic__SMS_Template__c template= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Discontinuation Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	
    	smagicbasic__SMS_Template__c template1= new smagicbasic__SMS_Template__c(smagicbasic__Name__c= 'Renewal Template', 
    																			smagicbasic__ObjectName__c = 'Account');
    	lstTemplate.add(template);
    	lstTemplate.add(template1);
    	
    	insert lstTemplate;
    	 
		//RecordType objRT = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
		
		   //Insert Account record
    	Account objBPAccount = new Account(Name='Parner Account Test',
    								RecordTypeId= RECORD_TYPE_INFO_MAP.get('General').getRecordTypeId());
    	insert 	objBPAccount;
    	
		//RecordType objRT = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
		
		Account objAccount = new Account(LastName='Test',FirstName='Test',Adjustment_Factor__c='2',
	                       PersonTitle='TestData', PersonBirthdate= system.today(),PersonHomePhone='54623676',PersonMobilePhone='54637',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034, Residential_Status_del__c='own', Retirement_Age__c='58', Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041, Relationship_to_Entity__pc='husband', RecordTypeId = RECORD_TYPE_INFO_MAP.get('Client').getRecordTypeId());
	    insert objAccount;
	    
	   
	    Approve_Action_Plan__c objAAP1 = new Approve_Action_Plan__c(Account__c = objAccount.Id);
	    insert objAAP1;
	    
	    Approve_Action_Plan__c objAAP2 = new Approve_Action_Plan__c(Account__c = objAccount.Id);
	    insert objAAP2;
        
        List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
        Execution_Tracker__c objET1 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,Term_No_Of_Years__c=12,
        									Risk_Commencement_Date__c = system.today(),Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP1.Id, Type__c = 'Life Insurance');
        lstET.add(objET1);
        Execution_Tracker__c objET2 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Risk_Commencement_Date__c = system.today(),Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP2.Id, Type__c = 'Life Insurance');
        lstET.add(objET2);
        Execution_Tracker__c objET3 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Risk_Commencement_Date__c = system.today(),Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP1.Id, Type__c = 'Life Insurance');
        lstET.add(objET3);
        Execution_Tracker__c objET4 = new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = false,
        									Risk_Commencement_Date__c = system.today(),Application_Status__c = 'Opened', Approve_Action_Plan__c = objAAP2.Id, Type__c = 'Life Insurance');
        lstET.add(objET4);
        insert lstET;
        
      	List<Renewal_Tracker__c> lstRenewalRracker = new List<Renewal_Tracker__c>();
        Renewal_Tracker__c objRenewalTracker1 = new Renewal_Tracker__c(Execution_Tracker__c=objET1.Id,Entity__c = objAccount.id);
        lstRenewalRracker.add(objRenewalTracker1);
      	Renewal_Tracker__c objRenewalTracker2 = new Renewal_Tracker__c(Execution_Tracker__c=objET2.Id,Entity__c = objAccount.id);
      	lstRenewalRracker.add(objRenewalTracker2);
        Renewal_Tracker__c objRenewalTracker3 = new Renewal_Tracker__c(Execution_Tracker__c=objET3.Id,Entity__c = objAccount.id);
        lstRenewalRracker.add(objRenewalTracker3);
  		Renewal_Tracker__c objRenewalTracker4 = new Renewal_Tracker__c(Execution_Tracker__c=objET4.Id,Entity__c = objAccount.id);
  		lstRenewalRracker.add(objRenewalTracker4);
        
        insert lstRenewalRracker;
       
    	objET1.Mode__c = 'Quaterly';
    	objET2.Mode__c = 'Monthly';
    	objET3.Mode__c = 'Annual';
    	objET4.Mode__c = 'Semi-Annual';
    	update lstET;
	}
	
}