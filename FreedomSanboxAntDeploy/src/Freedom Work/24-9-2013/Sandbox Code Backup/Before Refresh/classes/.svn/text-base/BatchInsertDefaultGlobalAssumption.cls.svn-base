/** BatchInsertDefaultGlobalAssumption class is One time run script.
Author:  Manasi Ranade 

Revision History:
*   Version     Version Author     Date        Comments
*   1.0         Manasi Ranade      28-05-2011  Initial Draft.Issue ID:F0021
											   1) Function InsertGlobalAssumptionForParentEntity(): It creates Global Assumption 
											      for the entities which are not present in Global Assumption object
											      and whose Parent_Entity__c field is null				 
											
											   2) Function UpdateGlobalAssumptions(): We have added two new fields Default_Estimated_Life_Expectancy__c 
											      and Default_Retirement_Age__c in Entity_Global_Assumption__c object. 
												  So in UpdateGlobalAssumptions function we are assigning default values for the 
												  existing records of global assumptions objects	
*/
public class BatchInsertDefaultGlobalAssumption 
{
	public List<Entity_Global_Assumption__c> updatedGlobalAssumptionList = new List<Entity_Global_Assumption__c>();
	public List<Entity_Global_Assumption__c> insertMissingGlobalAssumptions = new List<Entity_Global_Assumption__c>();
	//methods
	/*
		UpdateGlobalAssumptions():
		We have added two new fields Default_Estimated_Life_Expectancy__c and Default_Retirement_Age__c in Entity_Global_Assumption__c object.
		So in UpdateGlobalAssumptions function we are assigning default values for the existing records of global assumptions objects
	*/
	public void UpdateGlobalAssumptions()
	{
		for(Entity_Global_Assumption__c objEntityGlobalAssumption:[SELECT Default_Estimated_Life_Expectancy__c,
								Default_Retirement_Age__c,Account__c FROM Entity_Global_Assumption__c])
		{
			objEntityGlobalAssumption.Default_Estimated_Life_Expectancy__c = '85';
			objEntityGlobalAssumption.Default_Retirement_Age__c = '60';
			updatedGlobalAssumptionList.add(objEntityGlobalAssumption);
			System.debug('*********Entity ID:'+objEntityGlobalAssumption.Account__c);
		}
		update updatedGlobalAssumptionList;
		System.debug('********No Of Global Assumptions:'+updatedGlobalAssumptionList.size());
	}
	/*
		InsertGlobalAssumptionForParentEntity():
		It creates Global Assumption for the entities which are not present in Global Assumption object
		and whose Parent_Entity__c field is null
	*/
	public void InsertGlobalAssumptionForParentEntity()
	{
		List<Account> dummyAccount = [SELECT Id FROM Account WHERE Id NOT IN (SELECT Account__c FROM Entity_Global_Assumption__c)
								  AND Parent_Entity__c = null ];
		Integer iCount = dummyAccount.size();
		System.debug('***********Count:' + iCount);
		for(Account objAccount : [SELECT Id FROM Account WHERE Id NOT IN (SELECT Account__c FROM Entity_Global_Assumption__c)
								  AND Parent_Entity__c = null ])
		{
			Entity_Global_Assumption__c objEntityGlobalAssumption = new Entity_Global_Assumption__c();
			objEntityGlobalAssumption.Account__c = objAccount.Id;
			objEntityGlobalAssumption.Expected_Return_on_Investment__c = 9;
			objEntityGlobalAssumption.Income_Growth_Rate__c = 10;
			objEntityGlobalAssumption.Inflation_Rate__c = 6;
			objEntityGlobalAssumption.Number_Of_Months__c = 12;
			objEntityGlobalAssumption.Default_Retirement_Age__c = '60';
			objEntityGlobalAssumption.Default_Estimated_Life_Expectancy__c = '85';	
			insertMissingGlobalAssumptions.add(objEntityGlobalAssumption);
			System.debug('***********Account ID:' + objAccount.Id );
		}
		System.debug('***********insertMissingGlobalAssumptions size:' + insertMissingGlobalAssumptions.size() );
		insert insertMissingGlobalAssumptions;
	}
	
	
	
}