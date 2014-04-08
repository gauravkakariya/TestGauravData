public with sharing class HandlerForAfterUpdateFinAccount 

{
	public void AfterUpdateOnFinAccount(List<Financial_Account__c> lstFinancialAccount)
	{
		for(Financial_Account__c objFinAccount : lstFinancialAccount)
		{
			if(objFinAccount.From_Portal__c != 2)
			{
				//objFinAccount.IsSynched__c = false;
			}
		}
	}
}