public with sharing class HandlerForBeforeUpdateOnAccount 
{
	
	public void beforeUpdateAccount(List<Account> lstNewAccount, List<Account> lstOldAccount)
	{
		for(Account objNewAccount : lstNewAccount)
		{
			for(Account objOldAccount : lstOldAccount)
		    {
			   if(objOldAccount.From_Portal__c == 1 && objNewAccount.Synched_Date_Time__c >= objOldAccount.LastModifiedDate )
			   {
				  objNewAccount.From_Portal__c = 0;
				  objNewAccount.IsSynched__c = true;
			   }
			   else if(objOldAccount.From_Portal__c == 1 && objNewAccount.Synched_Date_Time__c < objOldAccount.LastModifiedDate )
			   {
				  objNewAccount.From_Portal__c = 0;
				   objNewAccount.IsSynched__c = false;
			   }
			   else if(objNewAccount.From_Portal__c == 0)
			   {
			   	 objNewAccount.IsSynched__c = false;
			   }
			   }
			
		   }
	}
	
	 @IsTest(seealldata = true) 
      public static void testCoverage() 
      {
      	 TestData_Ffreedom testData = new TestData_Ffreedom();
      	 Account parent = new Account();
         parent = testData.initializeAccount();
         insert parent;
         List<Account> lstChildAcc = new List<Account>();
         Account child = new Account(); 
         child = testData.init_FamilyMember(parent);
         child.Portal_Id__c = '1';
         child.From_Portal__c = 1;
         Account child1 = new Account(); 
         child1 = testData.init_FamilyMember(parent);
         child1.Portal_Id__c = '1';
         child1.From_Portal__c = 1;
         lstChildAcc.add(child); 
         lstChildAcc.add(child1); 
         insert lstChildAcc;
      	  
         lstChildAcc = new List<Account>();
         test.startTest();
	     child.Bank_2_Name__c = 'icici';
         // update child;
         //insert objGoal1;
         // objGoal1.aggressive_profile_years__c = 2.0;
         child.Synched_Date_Time__c = system.Now()+1;
         lstChildAcc.add(child);
         child1.Bank_2_Name__c = 'icici';
         // update child;
         //insert objGoal1;
         // objGoal1.aggressive_profile_years__c = 2.0;
         child1.Synched_Date_Time__c = system.Now()-1;
         lstChildAcc.add(child1);
         update lstChildAcc;
         
          /*objGoal1.aggressive_profile_years__c = 3.0;
          objGoal1.Synched_Date_Time__c = system.Now();
          update objGoal1;*/
          test.stopTest();
       }

}