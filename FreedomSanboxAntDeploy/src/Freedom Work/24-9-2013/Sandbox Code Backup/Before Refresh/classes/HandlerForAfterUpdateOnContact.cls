public with sharing class HandlerForAfterUpdateOnContact 
{
	public void beforeUpdateAccount(List<Account> lstNewAccount, List<Account> lstOldAccount)
		{
		for(Account objNewAccount : lstNewAccount)
		{
			for(Account objOldAccount : lstOldAccount)
		    {
			   if(objOldAccount.From_Portal__c == 1 && objNewAccount.Synched_Date_Time__c > objOldAccount.LastModifiedDate )
			   {
				  objNewAccount.From_Portal__c = 0;
				  objNewAccount.IsSynched__c = true;
			   }
			   else if(objOldAccount.From_Portal__c == 1 && objNewAccount.Synched_Date_Time__c < objOldAccount.LastModifiedDate )
			   {
				  objNewAccount.From_Portal__c = 0;
			   }
			   else if(objOldAccount.From_Portal__c == 0)
			   {
			   	 objNewAccount.IsSynched__c = false;
			   }
			   }
			
		   }
	}

}