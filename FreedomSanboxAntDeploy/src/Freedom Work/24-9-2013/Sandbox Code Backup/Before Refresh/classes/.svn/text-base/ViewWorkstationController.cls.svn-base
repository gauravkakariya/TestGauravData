/********************************************************************************************************** 
           Eternus Solutions 
		   Author  : Dipak Nikam
		   Date    : 15/09/2011
		   Purpose : Controller for View all workstation functionality .
		   Summary :  	
		   
		   Eternus Solutions 
		   Author  : Mahesh Hirugade
		   Date    : 09/02/2012
		   Purpose : To add new field "Advisor" to workstation object.
		   Summary : According to workstation hierarchy and assignment sheet sent by Swati Thakkar, new field "Advisory" is added to Workstation object.
		   			 So added w.Advisory__c and w.Advisory__r.Name fields to query to show on page, and shown this field on ViewAllWorkstations page.
		   			 
		   Eternus Solutions 
		   Author  : Anupam Agrawal
		   Date    : 28/12/2012
		   Purpose : To add new field "Operations" to workstation object.
		   Summary : 			 
		*********************************************************************************************************/



public with sharing class ViewWorkstationController 
{
	public List<Workstation__c> lstWorkstations {get;set;}
	public String Wid{set;get;}
	public ViewWorkstationController()
	{
		lstWorkstations = new List<Workstation__c> ();
	}
	
	
	public void Init()
	{
		lstWorkstations = [Select Tech__c,
	   							 Tech__r.Name, 
	   							 Name, 
							     Member_Engagement__c,
							     Member_Engagement__r.Name, 
							     Manager__c, 
							     Location__c, Id, 
							     Compliance__c, 
							     Compliance__r.Name,
							     Business_Developer__c,
							     Business_Developer__r.Name,
							     Advisory__c,
							     Advisory__r.Name,
							     Manager__r.Name,
							     Financial_Planner__c ,
							     Financial_Planner__r.Name,
							     Operations__c,
							     Operations__r.Name 
							     From Workstation__c 
							     Order By Financial_Planner__r.Name];
	}
	
	public Pagereference Close()
	{
		Pagereference pgRef = new Pagereference('/apex/WorkstationModel');
		pgRef.setRedirect(true);
		return pgRef;
	}
	
	public Pagereference CreateWorkstation()
	{
		Pagereference pgRef = new Pagereference('/apex/CreateWorkstation');
		pgRef.setRedirect(true);
		return pgRef;
	}
	
	public Pagereference Edit()
	{
		Pagereference pgRef = null;
		System.debug('Workstation Id======='+Wid);
		Wid = ApexPages.currentPage().getParameters().get('Wid');
		System.debug('Workstation Id======='+Wid);
		
		if(Wid != null && Wid != '')
		{
			pgRef = new Pagereference('/apex/EditWorkstation?wid='+Wid);
		}
		return pgRef;
	}
	
}