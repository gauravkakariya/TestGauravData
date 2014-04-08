public with sharing class HandlerForBeforeUpdateOnAccount {
	
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
          Account child = new Account(); 
          child = testData.init_FamilyMember(parent);
          child.Portal_Id__c = '1';
          child.From_Portal__c = 1;
          insert child;
      	  
             
          test.startTest();
            
              child.Bank_2_Name__c = 'icici';
             // update child;
         	 //insert objGoal1;
              // objGoal1.aggressive_profile_years__c = 2.0;
              child.Synched_Date_Time__c = system.Now()+1;
              update child;
              /*objGoal1.aggressive_profile_years__c = 3.0;
              objGoal1.Synched_Date_Time__c = system.Now();
              update objGoal1;*/
          test.stopTest();
       }

}