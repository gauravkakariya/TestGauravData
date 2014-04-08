/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     24/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

public with sharing class ViewHTMLPlanLinksController 
{
	public List<Attachment> lstAttachment {get;set;}
	public Account objAccount {get;set;}
	EntityRelatedAttachment__c objRelatedAttachment{get;set;} 
	String entityID {set;get;}  
	public ViewHTMLPlanLinksController()
	{
		String entityID = ApexPages.currentPage().getParameters().get('EntityId');
		objAccount = [Select Id, Name from Account where Id=:entityID];
		if(entityID != null && entityID !='')
			objRelatedAttachment = [select Id,Related_Entity__c from EntityRelatedAttachment__c where Related_Entity__c = : entityID limit 1];
		lstAttachment = [Select Id, Name, CreatedDate from Attachment where ParentId =: objRelatedAttachment.Id And Name like '%.htm' order by CreatedDate desc];
	}
	
	@isTest
	static void TestViewHTMLPlanLinksController()
	{
		Test.StartTest();
		Account acc = new Account(FirstName='ACD',LastName='GHJ');
		insert acc;
		ApexPages.currentPage().getParameters().put('EntityId', acc.id);
		ViewHTMLPlanLinksController objController = new ViewHTMLPlanLinksController();
		Test.StopTest();
	}
}