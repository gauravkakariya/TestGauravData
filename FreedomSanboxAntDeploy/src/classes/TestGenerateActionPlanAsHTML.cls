/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     24/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class TestGenerateActionPlanAsHTML 
{
    public static testMethod void testGenerateActionPlanAsHtml()
    {
        TestData_Ffreedom testData = new TestData_Ffreedom();
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
		
		
		Account objGeneralAccount = new Account(Name='Test',Expected_Return_on_Investment__c=10,Equity__c=10,Gold__c=10,Debt__c=10,
							         Income_Growth_Rate__c=10,Inflation_Rate__c=10,Default_Estimated_Life_Expectancy__c='58',Number_Of_Months__c=10,
							         Gold_Growth_Rate__c=10, Stock_Growth_Rate__c=10,Default_Retirement_Age__c='60', 
							         Related_To__c ='Ffreedom',RecordTypeId = RecTypes__c.getInstance('General_Business').Record_Type_Value__c);
    	insert objGeneralAccount;
		
        Account objacc = new Account(LastName='Test Freedom', Adjustment_Factor__c='2',
    									Entity_Status__c='Active', PersonTitle='TestData', Plan_Generation_Date__c=system.today(),
    									PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='9423230175',
				                       	Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', PAN_ID__pc='abcde4567M',
				                       	Alternate_E_Mail_Address__c='fdgr@test.com',PersonMailingStreet='aa',
				                       	PersonMailingCity='bbb',Retirement_Year__c=2034,Residential_Status_del__c='own',
				                       	Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
				                       	Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', 
				                       	Related_To__c ='Ffreedom',Email_Temp__c='abc@gmail.com',
				                       	Data_Collection_Date__c = date.today(),
				                       	RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c,Will__c = true);
        insert objacc;
        Test.StartTest();
        Apexpages.currentPage().getParameters().put('entityId',objacc.Id);
        GenerateActionPlanAsHTML Gplan= new GenerateActionPlanAsHTML();
        //Test.setCurrentPageReference(Page.GeneratePlanInHtml);
        Gplan.Save();
        Gplan.sendEmail();
        Gplan.selectAccount();
        
        //Gplan.sendEmail();
        Pagereference obj1 = Gplan.selectEmailIdToSendEmail();
        Pagereference obj2 = Gplan.sendEmailToOwner();
        Test.stopTest();
    }
}