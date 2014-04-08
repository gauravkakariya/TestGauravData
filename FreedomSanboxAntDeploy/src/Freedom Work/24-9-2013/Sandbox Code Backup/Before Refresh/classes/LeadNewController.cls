public with sharing class LeadNewController {
					
	//Lead_Platform_User__c				
	public String leadValue{get;set;}				
					
	public list<Lead_Platform_User__c>listLead				
	{				
		get{			
		if(listLead == null)			
			{		
				listLead = [Select l.Name, l.Name__c, l.Mobile__c, l.Lead_Status__c, l.Company_Name__c From Lead_Platform_User__c l ];	
			}		
			return listLead;		
		}set;			
	}				
					
	public PageReference go() 				
    {					
    	listLead = new List<Lead_Platform_User__c>();				
    	if(leadValue=='RecentlyModified')				
			{		
					
				system.debug('======inside========campValue'+leadValue);	
				listLead = [Select l.Name, l.Name__c, l.Mobile__c, l.Lead_Status__c, l.Company_Name__c From Lead_Platform_User__c l order by l.LastModifiedDate Desc];	
				system.debug('==============listCamp'+listLead);	
					
			}		
			else if(leadValue=='AllCampaigns')		
			{		
				listLead = [Select l.Name, l.Name__c, l.Mobile__c, l.Lead_Status__c, l.Company_Name__c From Lead_Platform_User__c l];	
			}		
			/*		
			else if (listLead == null || listLead.size() == 0)		
			{		
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No data found to be shown.'));	
			}*/		
    	return null;				
    }					
    /*					
	public List<Lead_Platform_User__c> listNewLead				
	{				
		get			
		{			
		  		if(listNewLead == null)	
		  		{	
		  			listNewLead = new List<Lead_Platform_User__c>();
		  		}	
		  		return listNewLead;	
		}			
		set;			
	}				
	*/				
					
	  public PageReference newpage()				
   	{				
   		PageReference reference = new PageReference('/a1H/e?retURL=%2Fa1H%2Fo');			
   		reference.setRedirect(true);			
   		return reference;			
  	}				

}