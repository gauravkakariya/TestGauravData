public with sharing class HandlerForAnyDMLOnAccount {
	
		public void afterDeleteAccount(list<Account> lstAccount)
	{
		system.debug('************************81.1'+lstAccount);
		PortalSyncStaging__c objPSS = new PortalSyncStaging__c();
		
	     list<PortalSyncStaging__c> lstPSS = new List<PortalSyncStaging__c>();
	     
	    for(Account objAccount : lstAccount)
	    {
	    	objPSS.ObjectId__c = objAccount.Id;
	    	objPSS.ObjectType__c = 'Account';
	    	objPSS.Name = objAccount.Name;
	    	objPSS.LastModDatetime__c = objAccount.LastModifiedDate;
	        objPSS.OperationType__c = 'Delete';
	    	
	    } 	
	
	}
	
	
	public void afterInserORUpdateAccount(list<Account> lstAccount,Boolean isInsert,Boolean isUpdate)
	{
		
		PortalSyncStaging__c objPSS =null;
		
	    List<PortalSyncStaging__c> lstPSS = new List<PortalSyncStaging__c>();
	     
	    for(Account objAccount : lstAccount)
	    {
	    	
	    	objPSS = new PortalSyncStaging__c();
	    	objPSS.ObjectId__c = objAccount.Id;
	    	objPSS.ObjectType__c = 'Account';
	    	objPSS.Name = objAccount.Name;
	    	objPSS.LastModDatetime__c = objAccount.LastModifiedDate;
	    	if(isInsert == true)
	    	{
	    		objPSS.OperationType__c = 'insert';
	    	}
	    	else if(isUpdate == true)
	    	{
	    		objPSS.OperationType__c = 'Update';
	    	}
	  
	    	lstPSS.add(objPSS);
	    } 	
	   upsert lstPSS;
	
	}
	

}