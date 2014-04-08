public with sharing class HandlerForBeforeUpdateOnEntityGlobalAssu 
{
	public void beforeUpdateEntityGlobalAssumption(List<Entity_Global_Assumption__c> lstNewEntityGlobal, List<Entity_Global_Assumption__c> lstOldEntityGlobal)
	{
		for(Entity_Global_Assumption__c objNewEntityGlobal :lstNewEntityGlobal)
		{
			for(Entity_Global_Assumption__c objOldEntityGlobal : lstOldEntityGlobal)
		    {
			   if(objOldEntityGlobal.From_Portal__c == 1 && objNewEntityGlobal.Synched_Date_Time__c > objOldEntityGlobal.LastModifiedDate )
			   {
				  objNewEntityGlobal.From_Portal__c = 0;
				  objNewEntityGlobal.IsSynched__c = true;
			   }
			   else if(objOldEntityGlobal.From_Portal__c == 1 && objNewEntityGlobal.Synched_Date_Time__c < objOldEntityGlobal.LastModifiedDate )
			   {
				  objNewEntityGlobal.From_Portal__c = 0;
				  objNewEntityGlobal.IsSynched__c = false;
			   }
			   else if(objNewEntityGlobal.From_Portal__c == 0)
			   {
			   	 objNewEntityGlobal.IsSynched__c = false;
			   }
			   }
			
		   }
	}
}