/* 
*   EntityHnadler class update the field on Account(Entity) for verifying Wellness Test is Taken or not
*
*   Revision History:
*
*   Version        Author          Date            Description
*   1.0            Gaurav      15/01/2013          Initial Draft
*   
*/

public with sharing class EntityHandler {
	
	public void onAfterInsert(List<Wellness_Score_Card__c> plstNewWellnessScoreCard){
		
		if(plstNewWellnessScoreCard[0].Account__c == NULL ) return;
		if(plstNewWellnessScoreCard[0].Account__r.IsTestTaken__c == false){
			
			plstNewWellnessScoreCard[0].Account__r.IsTestTaken__c = true;
		}  
		
		
		try{
			
		}
		catch(Exception e){
			system.debug('Exception while Updating Account'+e.getMessage());
			
		}
	}

}