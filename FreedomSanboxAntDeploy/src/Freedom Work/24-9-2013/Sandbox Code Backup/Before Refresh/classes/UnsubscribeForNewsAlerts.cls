public without sharing class UnsubscribeForNewsAlerts {
	/*Test Method Start*/
	public static testMethod void UnsubscribeForNewsAlertsTest()
	{
		Test.startTest();
		// Test Senario for Lead
		Lead objLead = new Lead();
		objLead.Company = 'TestComp';
		objLead.LastName = 'Last Name';
		insert objLead;
		
		Map<String,String> parameters = ApexPages.currentPage().getParameters();
        parameters.put('id',objLead.id);
        parameters.put('objectName','user');
        UnsubscribeForNewsAlerts objUnsubscribeForNewsAlerts = new UnsubscribeForNewsAlerts();
        objUnsubscribeForNewsAlerts.strObjectId = objLead.id;
        objUnsubscribeForNewsAlerts.strObjectName = 'lead';
        objUnsubscribeForNewsAlerts.UnsubscribeForNewsLetter();
		
		Account objAccount = new Account();
		objAccount.LastName = 'TestLastName';
		insert objAccount;
		
		UnsubscribeForNewsAlerts objUnsubscribeForNewsAlerts2 = new UnsubscribeForNewsAlerts();
        objUnsubscribeForNewsAlerts2.strObjectId = objAccount.id;
        objUnsubscribeForNewsAlerts2.strObjectName = 'account';
        objUnsubscribeForNewsAlerts2.UnsubscribeForNewsLetter();
		
		List<User> lstUser = [Select u.IsActive, u.Id From User u Where u.IsActive = True]; 
		UnsubscribeForNewsAlerts objUnsubscribeForNewsAlerts3 = new UnsubscribeForNewsAlerts();
        objUnsubscribeForNewsAlerts3.strObjectId = lstUser[0].id;
        objUnsubscribeForNewsAlerts3.strObjectName = 'user';
        objUnsubscribeForNewsAlerts3.UnsubscribeForNewsLetter();
		
		Test.stopTest();
	}
	/*Test Method Ends*/
	
	String strObjectId {get;set;}
	String strObjectName{get;set;}
	public Boolean IsUnsubscribe{get;set;}
	
	public UnsubscribeForNewsAlerts()
	{
		IsUnsubscribe = false;
		//https://ffreedom--ffreedomqa--c.cs13.visual.force.com/apex/UnsubscribenewsLetters?id=00520000001MO8D&objectName=user
		//http://www.ffreedom.in/UnsubscribenewsLettersid={!User.Id}&objectName=user
		if(ApexPages.currentPage().getParameters().get('id') != null && ApexPages.currentPage().getParameters().get('id') != '')
			strObjectId = ApexPages.currentPage().getParameters().get('id');
		if(ApexPages.currentPage().getParameters().get('objectName') != null && ApexPages.currentPage().getParameters().get('objectName') != '')	
			strObjectName = ApexPages.currentPage().getParameters().get('objectName');
		if(strObjectId == null || strObjectId == '')
			IsUnsubscribe = true;
	}
	
	
	public Pagereference UnsubscribeForNewsLetter()
	{
		Pagereference pgReference ;
		if(strObjectName != null && strObjectName != '' && strObjectName.equalsIgnoreCase('lead') && strObjectId != null && strObjectId !='')
		{
			
			Lead objLead = [Select l.IsUnsubscribe__c, l.Id From Lead l where l.Id =:strObjectId limit 1];
			if(objLead != null)
			{	    
	    		objLead.IsUnsubscribe__c = true;
	    		Database.Saveresult saveResult = database.update(objLead);	
		    	if(saveResult.isSuccess())
		    	{
		    		IsUnsubscribe = saveResult.isSuccess();
		    		pgReference = new Pagereference('/apex/UnsubscribenewsLetters');
		    	}
		    	else
		    		Error.DebugLog('You are not able to unsubscribe. Please contact to tech@ffreedom.in');
		    	
			}
		}
		if(strObjectName.equalsIgnoreCase('account') && strObjectId != null && strObjectId !='')
		{
			Account objAccount = [Select a.IsUnsubscribe__c, a.Id From Account a where a.Id =:strObjectId limit 1];
			objAccount.IsUnsubscribe__c = true;
			Database.Saveresult saveResult = database.update(objAccount);
			if(saveResult.isSuccess())
			{
		    	IsUnsubscribe = saveResult.isSuccess();
		    		pgReference = new Pagereference('/apex/UnsubscribenewsLetters');
		    }
		    else
		    	Error.DebugLog('You are not able to unsubscribe. Please contact to tech@ffreedom.in');
		}
		if(strObjectName.equalsIgnoreCase('user') && strObjectId != null && strObjectId !='')
		{
			User objUser = [Select u.IsUnsubscribe__c From User u where u.Id =:strObjectId limit 1];
			objUser.IsUnsubscribe__c = true;
			Database.Saveresult saveResult = database.update(objUser);
			if(saveResult.isSuccess())
			{
		    	IsUnsubscribe = saveResult.isSuccess();
		    		pgReference = new Pagereference('/apex/UnsubscribenewsLetters');
		    }
		    else
		    	Error.DebugLog('You are not able to unsubscribe. Please contact to tech@ffreedom.in');
		}
		
		pgReference.setRedirect(true);
		return pgReference;
	}
	
}