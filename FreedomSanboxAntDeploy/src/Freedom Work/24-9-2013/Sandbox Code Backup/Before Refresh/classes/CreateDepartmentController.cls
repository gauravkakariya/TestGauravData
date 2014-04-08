public with sharing class CreateDepartmentController 
{
	public Department__c deptObj{get;set;} 
	
	private ApexPages.StandardController controller;
	public Business_Unit__c objBusinessUnit;
	
	String sfurl = '';
	String Url1 = '';
	
	//Constructor
	public CreateDepartmentController(ApexPages.StandardController controller)
	{
		this.controller = controller;
		sfurl = URL.getSalesforceBaseUrl().toExternalForm();
		system.debug('**********sfurl*******'+sfurl);
		
		objBusinessUnit = [Select Id, Name From Business_Unit__c limit 1];
		
		deptObj = new Department__c();
	}
	
	
	//Constructor
	public CreateDepartmentController()
	{
		
		objBusinessUnit = [Select Id, Name From Business_Unit__c limit 1];
	}
	
	//Redirect Url to New Deparment which will populate Business Unit
	public PageReference redirect() 
	{
		if(objBusinessUnit != null)
		{
			//string recordPrefix = ApexPages.currentPage().getParameters().get('retURL');
			//system.debug('**********recordPrefix*******'+recordPrefix);
			
			//deptObj.Business_Unit__c =objBusinessUnit.Id;
		
			//if(recordPrefix == '/a25')
				Url1 ='/a25/e?nooverride=1&CF00NW0000000ihX1='+objBusinessUnit.Name+'&CF00NW0000000ihX1_lkid='+objBusinessUnit.Id;
			
			PageReference returnURL = New PageReference(Url1);
			returnURL.setRedirect(false);
			return returnURL;
		}	
		return null;
	}
	
	//Redirect Url to New Account Which will populate Business Unit
	public PageReference redirectAccount() 
	{
		if(objBusinessUnit != null)
		{
			Url1 ='/001/e?nooverride=1&CF00NW0000000ihXp='+objBusinessUnit.Name+'&CF00NW0000000ihXp_lkid='+objBusinessUnit.Id+'&RecordType='+ApexPages.currentPage().getParameters().get('RecordType');
				
			PageReference returnURL = New PageReference(Url1);
			returnURL.setRedirect(false);
			return returnURL;
		}	
		return null;
	}
	
	
	//Redirect Url to NewLead Which will populate Business Unit
	public PageReference redirectLead() 
	{
		if(objBusinessUnit != null)
		{
			Url1 ='/00Q/e?nooverride=1&CF00NW0000000ihae='+objBusinessUnit.Name+'&CF00NW0000000ihae_lkid='+objBusinessUnit.Id;
				
			PageReference returnURL = New PageReference(Url1);
			returnURL.setRedirect(false);
			return returnURL;
		}	
		return null;
	}
	
	public void assignBusinessUnit(List<Account> lstAccount)
	{
		for(Account objAccount: lstAccount)
		{
			if(objAccount.Business_Unit__c == null)
				objAccount.Business_Unit__c = objBusinessUnit.Id;
		}
	
	}

}