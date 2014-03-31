/** BatchInsertDefaultEmergencyFundGoal class is One time run script.
	It creates Goal records for Entities which does not contains Goal_Type__c = 'Emergency Fund'
    and whose Parent_Entity__c =NULL.
*
* Author:  Manasi Ranade 
*
* Revision History:
*   Version     Version Author     Date        Comments
*   1.0         Manasi Ranade      05-20-2011  Initial Draft.Issue ID:F0006
*
*/
public class BatchInsertDefaultEmergencyFundGoal
{
	public List<Account> EntitiesWithoutEmergencyFundList = new List<Account>();
	public List<Goal__c> NewGoalsList = new List<Goal__c>();
	
	//Methods
	public void createMissingEmergencyFundGoals()
	{
			//Selects entites whose Parent_Entity__c  is NULL and entities that does not present in goal of type='Emergency Fund'
			this.selectEntitiesWithoutEmergencyFundList();
			//Creates new goals list with type='Emergency Fund' and for entities with Parent_Entity__c =NULL
			this.createNewGoalsList();
			//Inserts newly created Goals
			if(NewGoalsList != Null && NewGoalsList.size() > 0){
				try
				{
					insert NewGoalsList;
				}
				catch(Exception e)
				{
					system.debug('*****Error*****'+e);
				}				
			}
	}
	
	private void selectEntitiesWithoutEmergencyFundList()
	{
	    Set<Id> goalsIdWithTypeEmergencyFundSet = new Set<Id>();
	    for(Goal__c Goal:[SELECT Entity__c 
	    				  FROM Goal__c 
	    				  WHERE Goal_Type__c =: 'Emergency Fund'])
	    {
	    	goalsIdWithTypeEmergencyFundSet.add(Goal.Entity__c);
	    }
	    
	    if(goalsIdWithTypeEmergencyFundSet != Null && goalsIdWithTypeEmergencyFundSet.size() > 0){
		    EntitiesWithoutEmergencyFundList = [SELECT Id 
		    									FROM Account 
		    									WHERE Id NOT IN : goalsIdWithTypeEmergencyFundSet AND 
		    										  Parent_Entity__c = NULL ];
	    }
	    else
	    	EntitiesWithoutEmergencyFundList=[SELECT id FROM Account WHERE Parent_Entity__c = NULL ]; 
	}
	//Creates new goals list with type='Emergency Fund' and for entities with Parent_Entity__c = NULL
	private void createNewGoalsList()
	{
		if(EntitiesWithoutEmergencyFundList != Null && EntitiesWithoutEmergencyFundList.size() > 0)
		for(Account EntityId : EntitiesWithoutEmergencyFundList)
		{
			System.debug('***************Entity ID:'+EntityId.Id);
			Goal__c Goal = new Goal__c();
			Goal.Entity__c = EntityId.Id;
			Goal.Goal_Type__c = 'Emergency Fund';
			Goal.Description__c = 'Emergency Fund';
			Goal.Goal_Start_Year__c =String.valueOf(Date.today().year());
			Goal.Goal_End_Year__c = String.valueOf(Date.today().addMonths(12).year());
			Goal.Priority__c='High';
			NewGoalsList.add(Goal);
		}
		System.debug('***************size of NewGoalsList:'+NewGoalsList.size());
	}
}