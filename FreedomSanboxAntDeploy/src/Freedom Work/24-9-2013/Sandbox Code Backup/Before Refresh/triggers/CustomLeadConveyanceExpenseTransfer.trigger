trigger CustomLeadConveyanceExpenseTransfer on Conveyance_Expense__c (before insert, before update) 
{
		List<Conveyance_Expense__c> lstConveyance = trigger.new;
		Map<Id,Conveyance_Expense__c> MapConveyance = new Map<Id,Conveyance_Expense__c>();
		Map<Id,Lead_Platform_User__c> MapPlatformUser = new Map<Id,Lead_Platform_User__c>();
		Map<Id,Lead> MapStandardLead = new Map<Id,Lead>();
		boolean flag1,flag2,flag3 ;
		for(Conveyance_Expense__c objConveyance : lstConveyance )
		{
			if(objConveyance.Platform_User_Lead__c != null)
			{
				if(!(MapConveyance.containsKey(objConveyance.Platform_User_Lead__c)))
       			{
       					MapConveyance.put(objConveyance.Platform_User_Lead__c,objConveyance);
       					flag1 = true;
       			}
			}
			else
			{
				if(!(MapConveyance.containsKey(objConveyance.Lead__c)))
       			{
       					MapConveyance.put(objConveyance.Lead__c,objConveyance);
       					flag1 = false;
       			}
			}
		}
		List<Lead_Platform_User__c> lstPlatformUser = new List<Lead_Platform_User__c>();
		List<Lead> lstStandardLead = new List<Lead>();
		Set<Id> StdSet = new Set<Id>();
		system.debug('flag ==1:":'+flag1);
		
		if(flag1)
		{
		 	lstPlatformUser = [select Id from Lead_Platform_User__c where id in : MapConveyance.keySet()];
			system.debug('*******lstPlatformUser******'+lstPlatformUser);
			for(Lead_Platform_User__c objPlatformUser : lstPlatformUser )
			{
				if(!(MapPlatformUser.containsKey(objPlatformUser.Id)))
       			{
					MapPlatformUser.put(objPlatformUser.Id,objPlatformUser);
					flag2 = true;
       			}
			}
		
		}
		else
		{
		 	lstStandardLead = [select Id,Status,Platform_User_Lead__c from Lead where id  in : MapConveyance.keySet()];
		 	if(lstStandardLead.size() > 0)
		 	{
			 	for(Lead objStandardLead : lstStandardLead )
				{
					if(objStandardLead.Platform_User_Lead__c != null )
					{
						if(!(MapStandardLead.containsKey(objStandardLead.Platform_User_Lead__c)))
		       			{
							MapStandardLead.put(objStandardLead.Id,objStandardLead);
							StdSet.add(objStandardLead.Platform_User_Lead__c);
							flag2 = false;
		       			}
					}
					else
					{
							flag2 = false;
					}
				}
		 	}
		 	else
		 	{
		 		flag2 = false;
		 	}
		 	
		}
		
		system.debug('flag ==2:":'+flag2);
		if(flag2)
		{
			lstStandardLead = [select Id,Status,Platform_User_Lead__c from Lead where Platform_User_Lead__c  in : MapPlatformUser.keySet()];
			
			for(Lead objStandardLead : lstStandardLead )
			{
				if(!(MapStandardLead.containsKey(objStandardLead.Platform_User_Lead__c)))
	       		{
					MapStandardLead.put(objStandardLead.Platform_User_Lead__c,objStandardLead);
					flag3 = true;
	       		}
			}
		}
		else
		{
			lstPlatformUser = [select Id from Lead_Platform_User__c where id in : StdSet];
			if(lstPlatformUser.size() > 0)
			{
				
				for(Lead_Platform_User__c objPlatformUser : lstPlatformUser )
				{
					if(!(MapPlatformUser.containsKey(objPlatformUser.Id)))
	       			{
						MapPlatformUser.put(objPlatformUser.Id,objPlatformUser);
						flag3 = false; 
	       			}
				}
			}
			else
			{
				flag3 = false; 
			}
		}
	/*	if(!(mapLeadStandardUser.containsKey(lead.Platform_User_Lead__c)))
       		{
            	 mapLeadStandardUser.put(lead.Platform_User_Lead__c,lead);
        	}
		*/
				system.debug('flag ==3:":'+flag3);
		List<Conveyance_Expense__c> lstConveyanceExpense = new List<Conveyance_Expense__c>();
		Lead_Platform_User__c objCustomLead = new Lead_Platform_User__c();
		Lead objStdLead = new Lead();
		for(Conveyance_Expense__c objConveyanceExpense :  lstConveyance)
		{
			if(flag3)
			{
				if(MapConveyance.containsKey(objConveyanceExpense.Platform_User_Lead__c))
				{
					objCustomLead = MapPlatformUser.get(objConveyanceExpense.Platform_User_Lead__c);
					if(objCustomLead != null)
					{
							
						if(MapStandardLead.containsKey(objCustomLead.Id))
						{
							objStdLead = MapStandardLead.get(objCustomLead.Id);
							if(objStdLead != null)
							{
								objConveyanceExpense.Lead__c = objStdLead.Id;
								lstConveyanceExpense.add(objConveyanceExpense);
							}
						}
					}
				}
			}
			else
			{
				if(MapConveyance.containsKey(objConveyanceExpense.Lead__c))
				{
					if(MapStandardLead.containsKey(objConveyanceExpense.Lead__c))
					{
						objStdLead = MapStandardLead.get(objConveyanceExpense.Lead__c);
					}
					if(objStdLead != null)
					{
						
						if(MapPlatformUser.containsKey(objStdLead.Platform_User_Lead__c))
						{
							objCustomLead = MapPlatformUser.get(objStdLead.Platform_User_Lead__c);
							if(objCustomLead != null)
							{
								objConveyanceExpense.Platform_User_Lead__c = objCustomLead.Id;
								lstConveyanceExpense.add(objConveyanceExpense);
							}
						}
					}
				}
			}
		}
}