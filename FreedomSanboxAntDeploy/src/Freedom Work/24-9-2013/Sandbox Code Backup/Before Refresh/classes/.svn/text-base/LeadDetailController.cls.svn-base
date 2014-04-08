public with sharing class LeadDetailController 
{
	public String leadID{get;set;}								
								
	public LeadDetailController()							
	{							
		leadID = ApexPages.currentPage().getParameters().get('leadId');						
		system.debug('-------------leadID------------>'+leadID);						
	}							
	public Lead_Platform_User__c leadDetails							
	{							
		get{						
			if(leadDetails == null)					
			{					
				leadDetails = new Lead_Platform_User__c();				
				leadDetails = [Select /*l.Salutation__c,l.First_Name__c, l.Mobile__c, l.Lead_Status__c, l.Lead_Source__c,l.Company_Name__c, l.Age__c */ 				
								l.LastModifiedDate, l.Id,  l.OwnerId,  l.Name, l.CreatedDate
								From Lead_Platform_User__c l where Id =: leadID];
			}					
			return leadDetails;					
		}						
		set;						
	}							
								
//Lead_Platform_User__c								
	
}