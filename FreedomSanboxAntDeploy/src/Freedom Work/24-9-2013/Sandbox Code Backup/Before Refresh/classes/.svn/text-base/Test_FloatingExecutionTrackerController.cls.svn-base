/*
	Revision History:
	
    Version     Version Author     Date           Comments
    1.0			Anupam	          2/01/13		 Test Class for FloatingExecutionTrackerController 
*/
public with sharing class Test_FloatingExecutionTrackerController 
{
	@isTest(SeeAllData=true)
	public static  void testFloatingExecutionTrackerController()
	{
		//BB USer
		Profile prof = [select id  from profile where usertype = 'PowerPartner' limit 1];
        User partnerUser = [select Id,ContactId from User where profileid =: prof.id and IsActive = true limit 1];
        system.debug('**********partnerUser**********'+partnerUser);
		RecordType objRT = [Select Id from RecordType where Name = 'Client' and SobjectType = 'Account'];
		List<Account> lstAcc = new List<Account>();
		Account objAccount = new Account(LastName='Test',FirstName='Test',Adjustment_Factor__c='2',
	                       PersonTitle='TestData', PersonBirthdate= system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034, Residential_Status_del__c='own', Retirement_Age__c='58', Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041, Relationship_to_Entity__pc='husband', RecordTypeId = objRT.Id);
	    lstAcc.add(objAccount);
	    
	    Account objBPAccount = new Account(LastName='Test BP',Adjustment_Factor__c='2', OwnerId = partnerUser.Id,
	                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='5463712345',
	                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
	                       Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
	                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband', Related_To__c ='Business Partner',
	                       RecordTypeId = RecTypes__c.getInstance('AccountClient').Record_Type_Value__c);
	    lstAcc.add(objBPAccount);
	    
	    Account addressAcc1 = new Account(LastName='Test1',FirstName='Test1', Retirement_Year__c=20, PersonMailingStreet='aa',PersonMailingState='bb',
	    						PersonMailingCountry='cc',PersonMailingPostalCode='2132');
	    						
	    lstAcc.add(addressAcc1);
	    
	    Account addressAcc2 = new Account(LastName='Test1',FirstName='Test1', Retirement_Year__c=20, PersonMailingStreet='aa',PersonMailingCity='bb',
	    						PersonMailingCountry='cc',PersonMailingPostalCode='2132');
	    lstAcc.add(addressAcc2);
	    
	    Account addressAcc3 = new Account(LastName='Test1',FirstName='Test1', Retirement_Year__c=20, PersonMailingState='aa',PersonMailingCity='bb',
	    						PersonMailingCountry='cc',PersonMailingPostalCode='2132');
	    lstAcc.add(addressAcc3);
	    
	    Account addressAcc4 = new Account(LastName='Test1',FirstName='Test1', Retirement_Year__c=20, PersonMailingState='aa',PersonMailingCity='bb',
	    						PersonMailingStreet='cc',PersonMailingPostalCode='2132');
	    lstAcc.add(addressAcc4);
	    
	    Account addressAcc5 = new Account(LastName='Test1',FirstName='Test1', Retirement_Year__c=20, PersonMailingState='aa',PersonMailingCity='bb',
	    						PersonMailingStreet='cc',PersonMailingCountry='2132');
	    lstAcc.add(addressAcc5);
	    
	    Account addressAcc6 = new Account(LastName='Test1',FirstName='Test1', Retirement_Year__c=20, PersonMailingState='aa',PersonMailingCity='bb',
	    						PersonMailingStreet='cc',PersonMailingPostalCode='2132',PersonMailingCountry='2132');
	    lstAcc.add(addressAcc6);
	    
	    insert lstAcc;
	    lstAcc[1].Related_To__c = 'Business Partner';
	    update lstAcc[1];
        
        List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
        lstET.add(new Execution_Tracker__c(Entity_Name__c = objAccount.id,  ET_Status__c = 'Assigned to Operations',Is_Floating__c = true));
        lstET.add(new Execution_Tracker__c(Entity_Name__c = objBPAccount.id,  ET_Status__c = 'Assigned to Operations', Is_Floating__c = true));
        
        insert lstET;
  
        Test.startTest();
        ApexPages.currentPage().getParameters().put('eid', objAccount.id);
        FloatingExecutionTrackerController objFETC = new FloatingExecutionTrackerController(); 
        
        ApexPages.currentPage().getParameters().put('eid', addressAcc1.id);
        FloatingExecutionTrackerController objFETC1 = new FloatingExecutionTrackerController(); 
        
        ApexPages.currentPage().getParameters().put('eid', addressAcc2.id);
        FloatingExecutionTrackerController objFETC2 = new FloatingExecutionTrackerController(); 
        
        ApexPages.currentPage().getParameters().put('eid', addressAcc3.id);
        FloatingExecutionTrackerController objFETC3 = new FloatingExecutionTrackerController(); 
        
        ApexPages.currentPage().getParameters().put('eid', addressAcc4.id);
        FloatingExecutionTrackerController objFETC4 = new FloatingExecutionTrackerController(); 
        
        ApexPages.currentPage().getParameters().put('eid', addressAcc5.id);
        FloatingExecutionTrackerController objFETC5 = new FloatingExecutionTrackerController(); 
        
        ApexPages.currentPage().getParameters().put('eid', addressAcc6.id);
        FloatingExecutionTrackerController objFETC6 = new FloatingExecutionTrackerController(); 
        
        
        System.assertEquals('Assigned to Operations', lstET[0].ET_Status__c);
        System.assertEquals(true, lstET[0].Is_Floating__c);
        
        objFETC.back();
        objFETC.create();
        ApexPages.currentPage().getParameters().put('etId', lstET[0].Id);
        objFETC.editExecutionTracker();
        objFETC.updateExecutionTracker();
        objFETC.cancel();
        objFETC.selectedProductType = 'General Insurance';
        objFETC.saveExecutionTracker();
        objFETC.create();
        objFETC.selectedProductType = 'Life Insurance';
        objFETC.saveExecutionTracker();
        objFETC.deleteExecutionTracker();
        objFETC.create();
        objFETC.selectedProductType = 'Mutual Fund';
        objFETC.saveExecutionTracker();
        
        ApexPages.currentPage().getParameters().put('eid', objBPAccount.id);
        FloatingExecutionTrackerController objBPFETC = new FloatingExecutionTrackerController();
        objBPFETC.back();
        objBPFETC.create();
        ApexPages.currentPage().getParameters().put('etId', lstET[1].Id);
        objBPFETC.selectedProductType = 'General Insurance';
        objBPFETC.saveExecutionTracker();
        objFETC.create();
        objFETC.selectedProductType = 'Life Insurance';
        objFETC.saveExecutionTracker();
        objFETC.create();
        objFETC.selectedProductType = 'Mutual Fund';
        objFETC.saveExecutionTracker();
        objFETC.getEntities();
        Test.stopTest();
        
        
       
	}

}