/*
	Revision History:
    Version     Version Author    Date          Comments
	2.0			Gaurav	 		  25/09/2013   1.Controller which is used for creating new Account, Lead and Deparment 
*/

public with sharing class CreateDepartmentController 
{
	private ApexPages.StandardController controller;
	public Business_Unit__c objBusinessUnit;
	
	String sfurl = '';
	String returnURL = '';
	
	//Constructor
	public CreateDepartmentController(ApexPages.StandardController controller)
	{
		this.controller = controller;
		objBusinessUnit = [Select Id,Is_Default__c, Name 
						   From Business_Unit__c Where Is_Default__c = true 
						  ];
	}
	
	
	//Redirect Url to New Deparment which will populate Business Unit
	public PageReference redirect() 
	{
		if(objBusinessUnit != null)
		{
			returnURL ='/a25/e?nooverride=1&CF00NW0000000ihX1='+objBusinessUnit.Name+'&CF00NW0000000ihX1_lkid='+objBusinessUnit.Id;
			
			PageReference returnDeptURL = New PageReference(returnURL);
			returnDeptURL.setRedirect(false);
			return returnDeptURL;
		}	
		return null;
	}
	
	//Redirect Url to New Account Which will populate Business Unit
	public PageReference redirectAccount() 
	{
		if(objBusinessUnit != null)
		{
			returnURL ='/001/e?nooverride=1&CF00NW0000000ihXp='+objBusinessUnit.Name+'&CF00NW0000000ihXp_lkid='+objBusinessUnit.Id+'&RecordType='+ApexPages.currentPage().getParameters().get('RecordType');
				
			PageReference returnAccountURL = New PageReference(returnURL);
			returnAccountURL.setRedirect(false);
			return returnAccountURL;
		}	
		return null;
	}
	
	
	//Redirect Url to NewLead Which will populate Business Unit
	public PageReference redirectLead() 
	{
		if(objBusinessUnit != null)
		{
			returnURL ='/00Q/e?nooverride=1&CF00NW0000000ihae='+objBusinessUnit.Name+'&CF00NW0000000ihae_lkid='+objBusinessUnit.Id;
				
			PageReference returnLeadURL = New PageReference(returnURL);
			returnLeadURL.setRedirect(false);
			return returnLeadURL;
		}	
		return null;
	}
	

}