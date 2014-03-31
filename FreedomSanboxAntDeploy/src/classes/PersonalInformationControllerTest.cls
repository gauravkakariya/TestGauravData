/* 
*  Test class created for PersonalInformationController
*
*   Revision History:
*
*   Version			Author             Date          Description
*   1.0         Prajakta Sanap		06/03/2013 	 	Initial Draft 
*   2.0  		Prajakta Sanap      22/04/2013		Created TestData_Ffreedom which contains all the test data for this test class.	
*/

@isTest
private class PersonalInformationControllerTest 
{
    static testMethod void freedomEntityTest() 
    {
    	Test.startTest();
    	TestData_Ffreedom testData = new TestData_Ffreedom();
    	List<Account> lstAccount = new List<Account>();
    	
    	Account objAccount = testData.initializeAccount();
	    lstAccount.add(objAccount);
	    
	    Account objFamily = testData.init_FamilyMember(objAccount);
	    lstAccount.add(objFamily);
	    insert lstAccount;
	    
	    Entity_Global_Assumption__c objGlobal = testData.initialize_GlobalAssumptions(objAccount);
	    insert objGlobal;                              			
	    
	    Apexpages.currentPage().getParameters().put('entityId',objAccount.id);
	    PersonalInformationController personalInfo = new PersonalInformationController();
	    
		test.stopTest();
    }
    
    static testMethod void virtualEntityTest() 
    {
    	Test.startTest();
    	TestData_Ffreedom testData = new TestData_Ffreedom();
    	
    	Account partnerAcc1 = testData.initVirtualAccount();
        insert partnerAcc1;
	       	
    	List<Account> lstAccount = new List<Account>();
    	Account objAccount = testData.initVirtualAccount(partnerAcc1);
	    insert objAccount;
	    //lstAccount.add(objAccount);
	    
	    Account objFamily = testData.init_FamilyMember(objAccount);
	    lstAccount.add(objFamily);
	    insert lstAccount;
	    objAccount.Related_To__c = 'Virtual Partner';
	    objAccount.Virtual_Partner__c = partnerAcc1.Id;
	    update objAccount;
	    
	    Entity_Global_Assumption__c objGlobal = testData.initialize_GlobalAssumptions(objAccount);
	    insert objGlobal;                              			
	    
	    Apexpages.currentPage().getParameters().put('entityId',objAccount.id);
	    PersonalInformationController personalInfo = new PersonalInformationController();
	    
		test.stopTest();
    }
    
    
    static testMethod void businessEntityTest() 
    {
    	Test.startTest();
    	TestData_Ffreedom testData = new TestData_Ffreedom();

       	Account objGeneralAccount = testData.init_GeneralAccount();
	    insert objGeneralAccount;
	    Contact objBizContact = testData.init_BizContact(objGeneralAccount);
	    insert objBizContact;
       	User partnerUser = testData.initBusinessUser(objBizContact);
       	insert partnerUser;
			       	
    	List<Account> lstAccount = new List<Account>();
    	Account objAccount = testData.initBusinessAccount(partnerUser);
    	objAccount.Related_To__c = 'Business Partner';
	    lstAccount.add(objAccount);
	    
	    Account objFamily = testData.init_FamilyMember(objAccount);
	    lstAccount.add(objFamily);
	    insert lstAccount;

	    Entity_Global_Assumption__c objGlobal = testData.initialize_GlobalAssumptions(objAccount);
	    insert objGlobal;                              			
	    
	    Apexpages.currentPage().getParameters().put('entityId',objAccount.id);
	    PersonalInformationController personalInfo = new PersonalInformationController();
	    
		test.stopTest();
    }
}