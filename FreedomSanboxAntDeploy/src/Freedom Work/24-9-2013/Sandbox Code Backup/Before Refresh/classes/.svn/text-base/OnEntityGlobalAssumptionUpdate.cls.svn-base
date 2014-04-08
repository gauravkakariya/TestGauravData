public without sharing class OnEntityGlobalAssumptionUpdate {
	
	public static void UpdateEntityGlobalAssumptionFlag(List<Entity_Global_Assumption__c> lstEntityGlobalAssumption, Map<Id,Entity_Global_Assumption__c> MapEntityGlobalAssumption)
	{
		for(Entity_Global_Assumption__c globalAspt : lstEntityGlobalAssumption)
		{
			Entity_Global_Assumption__c globalAsptOld = MapEntityGlobalAssumption.get(globalAspt.Id);
			
			if(globalAspt.IsChanged__c) continue;
			
			If((globalAspt.Expected_Return_on_Investment__c != globalAsptOld.Expected_Return_on_Investment__c)
				|| globalAspt.Income_Growth_Rate__c != globalAsptOld.Income_Growth_Rate__c
				|| globalAspt.Inflation_Rate__c != globalAsptOld.Inflation_Rate__c
				|| globalAspt.Number_Of_Months__c != globalAsptOld.Number_Of_Months__c
				|| globalAspt.Number_Of_Months__c != globalAsptOld.Number_Of_Months__c
				|| globalAspt.Default_Retirement_Age__c != globalAsptOld.Default_Retirement_Age__c
				|| globalAspt.Default_Estimated_Life_Expectancy__c != globalAsptOld.Default_Estimated_Life_Expectancy__c
				|| globalAspt.Stock_Growth_Rate__c != globalAsptOld.Stock_Growth_Rate__c
				|| globalAspt.Gold_Growth_Rate__c != globalAsptOld.Gold_Growth_Rate__c)
				{
					globalAspt.IsChanged__c = true;
				}
		}
	}
}