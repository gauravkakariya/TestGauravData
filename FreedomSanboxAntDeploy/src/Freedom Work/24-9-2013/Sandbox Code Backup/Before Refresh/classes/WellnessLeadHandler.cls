/*
    Revision History:
    
    Version     Version Author     Date           Comments
    1.0         Gaurav             09/1/2012     This Class is used to transfer lead to Entity which is created from Wellness Test 
    
*/


public with sharing class WellnessLeadHandler {

		private Set<Id> leadIds = new Set<Id>();
		private Map<Id, List<Wellness_Score_Card__c>> mapWellnessScoreCardId = new Map<Id, List<Wellness_Score_Card__c>>();

		//Convert Wellness Crated Lead to Entity 
        public void onAfterUpdate(List<Lead> pNewLeadList, List<Lead> pOldLeadList){
        	
        	List<Wellness_Score_Card__c> lstWellnessScoreCardTobeUpdate = new List<Wellness_Score_Card__c> ();
        
			if(pNewLeadList.size() > 0)
			{
				for (Integer i = 0; i < Trigger.new.size(); i++)
			 	{
			       if (pNewLeadList[i].IsConverted == true && pOldLeadList[i].isConverted == false)
			       {
			       		leadIds.add(pNewLeadList[i].Id);
			       }
			 	}
			}
	        
	        for(Wellness_Score_Card__c objWellnessScoreCardDetails :[Select Name, Lead__c, Id, Account__c From Wellness_Score_Card__c  where Lead__c IN :leadIds])
	        {
	        	system.debug('***objWellnessScoreCardDetails'+objWellnessScoreCardDetails);
	        	if(!mapWellnessScoreCardId.isEmpty() && mapWellnessScoreCardId.containsKey(objWellnessScoreCardDetails.Lead__c))
	        	{
	        		List<Wellness_Score_Card__c> lstScoreCardDetails = mapWellnessScoreCardId.get(objWellnessScoreCardDetails.Lead__c);
	        		lstScoreCardDetails.add(objWellnessScoreCardDetails);
	        		mapWellnessScoreCardId.put(objWellnessScoreCardDetails.Lead__c,lstScoreCardDetails);
	        		
	        	}
	        	else
	        	{
	        		List<Wellness_Score_Card__c> lstScoreCardDetails = new List<Wellness_Score_Card__c>();
	        		lstScoreCardDetails.add(objWellnessScoreCardDetails);
	        		mapWellnessScoreCardId.put(objWellnessScoreCardDetails.Lead__c,lstScoreCardDetails);
	        	}
	        }
	        
	       	       
	       	if(!pNewLeadList.isEmpty()) 
		    {
		    	for (Lead objLead : pNewLeadList)  
		    	{
		            
		            if(!mapWellnessScoreCardId.isEmpty() && mapWellnessScoreCardId.containsKey(objLead.Id))
		            {
		            	List<Wellness_Score_Card__c> lstWellnessScoreCardDetails = mapWellnessScoreCardId.get(objLead.Id);
		            	if(lstWellnessScoreCardDetails.size() > 0)
		            	{
		            		for(Wellness_Score_Card__c objWellnessScoreCardDetails :lstWellnessScoreCardDetails)
		            		{
		            			objWellnessScoreCardDetails.Lead__c = null;
		            			objWellnessScoreCardDetails.Account__c = objLead.ConvertedAccountId; 
		            			lstWellnessScoreCardTobeUpdate.add(objWellnessScoreCardDetails);
		            		}
		            	}
		            }
		            
		         }
		   	}
		   
		    if(!lstWellnessScoreCardTobeUpdate.isEmpty())
		   {
		   		List<Database.Saveresult> lstUpdateScoreCardResult = Database.update(lstWellnessScoreCardTobeUpdate);
		   }
        }
}