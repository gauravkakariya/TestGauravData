/*
	Revision History:
    Version     Version Author    Date          Comments
	1.0			Prajakta Sanap	 02/01/2014   1. Handler for AccountTrigger
	
*/

public class AccountRiskProfileHandler 
{
	/* Function to dispaly pop up on update of Risk Profile */
    public static void checkRiskProfile(List<Account>accountNewList, map<Id,Account> oldMap)
    {
    	set<Id> AccountIdSet = new set<Id>();
    	map<Id, List<Goal__c>> mapAccountTolstGoal = new map<Id, List<Goal__c>>();
    	List<Goal__c> lstNewGoalList = new List<Goal__c>();
    	//set<Id> teamMemberIdSet = new set<Id>();
        
        //Get the set of members whose risk profile has been changed.
        for(Account acc : accountNewList)
        {
        	system.debug('--------Score----------'+accountNewList+' - '+acc.Finametrica_Score__c+' - '+oldMap.get(acc.Id).Finametrica_Score__c);
        	//if(acc.Finametrica_Score__c != null)
        	//if(acc.Finametrica_Score__c != oldMap.get(acc.Id).Finametrica_Score__c)
        	{
            	AccountIdSet.add(acc.Parent_Entity__c);
        	}
        }
        system.debug('--------newMemberSet----------'+AccountIdSet+' - '+AccountIdSet.size());
        
        if(AccountIdSet.size() > 0)
        {
        	List<Goal__c> listGoal = [Select Id, Entity__c, Risk_Profile__c from Goal__c 
        							  where Entity__c IN: AccountIdSet and Risk_Profile__c != null];
        	system.debug('--------listGoal----------'+listGoal);
        	
        	for(Goal__c objGoal : listGoal)
			{
				List<Goal__c> lstGoal = new List<Goal__c>();
		    	if(mapAccountTolstGoal.containsKey(objGoal.Entity__c))
		        {
		            lstGoal = mapAccountTolstGoal.get(objGoal.Entity__c);
		            lstGoal.add(objGoal);
		        }
		        else
		        {
		            lstGoal.add(objGoal);
		        }
		        mapAccountTolstGoal.put(objGoal.Entity__c,lstGoal);
		    }
		    system.debug('--------mapAccountTolstGoal----------'+mapAccountTolstGoal);
		    
		    
		    for(Account acc : accountNewList)
		    {
		    	if(acc.Risk_profile__c != oldMap.get(acc.Id).Risk_profile__c)
        		{
        			if(mapAccountTolstGoal.containsKey(acc.Id))
        			{
        				List<Goal__c> lstGoal = mapAccountTolstGoal.get(acc.Id);
        				system.debug('--------lstGoal----------'+lstGoal);
        				
        				for(Goal__c objNewGoal : lstGoal)
        				{
        					objNewGoal.Risk_Profile__c = acc.Risk_profile__c;
        					lstNewGoalList.add(objNewGoal);
        				}
        				system.debug('--------lstNewGoalList----------'+lstNewGoalList);
        			}
        		}
		    }
        }
        if(! lstNewGoalList.isEmpty())
        	database.update(lstNewGoalList,true);
    }
}