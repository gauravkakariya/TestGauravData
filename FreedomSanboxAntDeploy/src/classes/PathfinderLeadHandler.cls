/*
	Revision History:
    Version     Version Author    Date          Comments
	1.0			Prajakta Sanap	 07/10/2013   1. Handler class for LeadTrigger
	
*/

public class PathfinderLeadHandler 
{
	/* Function to convert Lead to entity */
	public void convertLeadToEntity(List<Lead> newList, map<Id,Lead> oldMap)
	{
		set<Id> updatedLeads = new set<Id>();
		List<Lead> lstLeadToConvert = new List<Lead>();
		
		//Get the set of leads which are to be converted
		for(Lead objLead : newList)
		{
			/*if(oldMap != null && (objLead.is_Pathfinder__c != oldMap.get(objLead.Id).is_Pathfinder__c))
			{
	        	updatedLeads.add(objLead.Id);
	        }
	        else*/ if(oldMap == null)
	        {
	        	updatedLeads.add(objLead.Id);
	        }
		}
		
		List<Database.LeadConvert> leadConversionList = new List<Database.LeadConvert>();
        List<Lead> leadToConvertList = new List<Lead>(); 
		system.debug('--------updatedLeads---------:'+updatedLeads);
		
		if(updatedLeads.size() != 0)
		{
			lstLeadToConvert = [Select Id, Name, IsConverted, Status, is_Pathfinder__c, OwnerId 
								from Lead 
								where Id IN: updatedLeads and IsConverted = false];
			system.debug('--------lstLeadToConvert---------:'+lstLeadToConvert);
			
			for(Lead objLead : lstLeadToConvert)
			{
				system.debug('--------in for---------:'+objLead.Id);
				//objLead.IsConverted = true;
				if(objLead.is_Pathfinder__c == true)
				{
					system.debug('--------is_Pathfinder__c---------:'+objLead.is_Pathfinder__c);
					Database.LeadConvert lc = new database.LeadConvert();
                    lc.setLeadId(objLead.id);
                    lc.setDoNotCreateOpportunity(True);
                    lc.setConvertedStatus('Converted');
                    
                    leadConversionList.add(lc);
                    
				}
			}
			Database.LeadConvertResult[] lcr = Database.convertLead(leadConversionList, false);
			system.debug('--------lcr---------:'+lcr);
		}
	}
}