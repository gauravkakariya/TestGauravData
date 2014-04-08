public with sharing class WellnessTabController 
{
	public static List<Question_Bank__c> lstQuestionBank{get;set;}
	public static List<Question_Bank_List__c> lstQuestionList{get;set;}
	public static List<Questionnaire__c> lstQuestionnaire{get;set;}
	
	public WellnessTabController()
	{
		lstQuestionBank = [Select q.Name, q.IsActive__c, q.Description__c From Question_Bank__c q limit 3];
		lstQuestionList = [Select q.Question_Number__c, q.Name From Question_Bank_List__c q limit 50];
		lstQuestionnaire = [Select q.Name, q.Display_Sequence__c From Questionnaire__c q limit 5];
	}
	
	public Pagereference addNewQuestionnaire()
	{
		PageReference pageRef = new PageReference('apex/IudOnWellness');
		return pageRef;
	}
	
	/*public Pagereference save()
	{
		try  
		{
			upsert lstQuestionnaire;
		}
		catch ( DmlException exc) 
		{
	      	ApexPages.addMessages(exc);
	      	return null;
		}
		return null;
	}
*/
	public Pagereference cancel()
	{
		return null;
	}
		//system.debug('=======questionList======='+questionList);
}