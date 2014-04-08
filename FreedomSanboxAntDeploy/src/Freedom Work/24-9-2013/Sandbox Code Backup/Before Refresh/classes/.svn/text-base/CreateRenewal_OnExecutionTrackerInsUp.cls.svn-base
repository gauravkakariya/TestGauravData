public without sharing class CreateRenewal_OnExecutionTrackerInsUp extends ExecutionTrackerTrigger 
{
	public CreateRenewal_OnExecutionTrackerInsUp(Execution_Tracker__c[] Execution_TrackerOldList, Execution_Tracker__c[] Execution_TrackerList){
		super(Execution_TrackerOldList,Execution_TrackerList);
	}
	
	public override void execute()
	{
		system.debug('*********execute');
		//Execution_TrackerOldList : trigger.Old value will be stored 
		//Execution_TrackerNewList : trigger.New value will be stored
		List<Renewal_Tracker__c> lstRenewalTracker = new List<Renewal_Tracker__c>();
		Map<Id,Renewal_Tracker__c> mapETLIidToRenewalTracker = new Map<Id,Renewal_Tracker__c>();
		Map<Id,Renewal_Tracker__c> mapETGIidToRenewalTracker = new Map<Id,Renewal_Tracker__c>();
		if(Execution_TrackerNewList != null)
		{
			for(Renewal_Tracker__c objRenewalTracker : [select Id,Name,Execution_Tracker__c,Entity__c,Cheque_Submission_date__c,Insurance_Type__c,
						Next_renewal_date__c,Remark__c,Target_Revenue__c from Renewal_Tracker__c where ParentId__c = null])
			{
				if(objRenewalTracker.Insurance_Type__c == 'Life Insurance')
				{
					if(!mapETLIidToRenewalTracker.containsKey(objRenewalTracker.Execution_Tracker__c))
					mapETLIidToRenewalTracker.put(objRenewalTracker.Execution_Tracker__c,objRenewalTracker);
				}
				else if(objRenewalTracker.Insurance_Type__c == 'General Insurance')
				{
					if(!mapETGIidToRenewalTracker.containsKey(objRenewalTracker.Execution_Tracker__c))
					mapETGIidToRenewalTracker.put(objRenewalTracker.Execution_Tracker__c,objRenewalTracker);
				}
			}
			
		
			for(Execution_Tracker__c objET : Execution_TrackerNewList)
	       	{
	       		if(objET.Type__c == 'Life Insurance')
	       		{
	       			if(mapETLIidToRenewalTracker.containskey(objET.Id))
					{
						system.debug('*******in if**********');
			       		Renewal_Tracker__c objRT = mapETLIidToRenewalTracker.get(objET.Id);
		       			if(objET.Mode__c != null)
		       			{
			       			if(objET.Mode__c.equalsIgnoreCase('Monthly'))
			       			{
			       				if(objET.Risk_Commencement_Date__c != null)
			       				objRT.Next_renewal_date__c = objET.Risk_Commencement_Date__c.addDays(30);
			       			}
			       			else if(objET.Mode__c.equalsIgnoreCase('Quaterly'))
			       			{
			       				if(objET.Risk_Commencement_Date__c != null)
			       				objRT.Next_renewal_date__c = objET.Risk_Commencement_Date__c.addDays(90);
			       			}
			       			else if(objET.Mode__c.equalsIgnoreCase('Semi-Annual'))
			       			{
			       				if(objET.Risk_Commencement_Date__c != null)
			       				objRT.Next_renewal_date__c = objET.Risk_Commencement_Date__c.addDays(180);
			       			}
			       			else
			       			{
			       				if(objET.Risk_Commencement_Date__c != null)
			       				objRT.Next_renewal_date__c = objET.Risk_Commencement_Date__c.addDays(365);
			       			}	
			       			objRT.Renewal_Tracker_Name__c = objET.Policy_Name__c;
			       			lstRenewalTracker.add(objRT);
			       		}
		       		}
		       		else
					{
						system.debug('*******in else**********');
		       			Renewal_Tracker__c objRenewalTracker = new Renewal_Tracker__c();
		       			objRenewalTracker.Renewal_Tracker_Name__c = objET.Policy_Name__c;
		       			objRenewalTracker.Execution_Tracker__c = objET.Id;
		       			objRenewalTracker.Entity__c = objET.Entity_Name__c;
		       			objRenewalTracker.Insurance_Type__c = 'Life Insurance';
		       			if(objET.Term_No_Of_Years__c != null)
		       				objRenewalTracker.Tenure_of_Insurance__c = objET.Term_No_Of_Years__c - 1;
		       			lstRenewalTracker.add(objRenewalTracker);
					}
	       		}
	       		else if(objET.Type__c == 'General Insurance')
	       		{
	       			if(mapETGIidToRenewalTracker.containskey(objET.Id))
					{
						system.debug('*******in if**********');
			       		Renewal_Tracker__c objRT = mapETGIidToRenewalTracker.get(objET.Id);
		       			if(objET.Mode__c != null)
		       			{
			       			if(objET.Mode__c.equalsIgnoreCase('Monthly'))
			       			{
			       				if(objET.Risk_Commencement_Date__c != null)
			       				objRT.Next_renewal_date__c = objET.Risk_Commencement_Date__c.addDays(30);
			       			}
			       			else if(objET.Mode__c.equalsIgnoreCase('Quaterly'))
			       			{
			       				if(objET.Risk_Commencement_Date__c != null)
			       				objRT.Next_renewal_date__c = objET.Risk_Commencement_Date__c.addDays(90);
			       			}
			       			else if(objET.Mode__c.equalsIgnoreCase('Semi-Annual'))
			       			{
			       				if(objET.Risk_Commencement_Date__c != null)
			       				objRT.Next_renewal_date__c = objET.Risk_Commencement_Date__c.addDays(180);
			       			}
			       			else
			       			{
			       				if(objET.Risk_Commencement_Date__c != null)
			       				objRT.Next_renewal_date__c = objET.Risk_Commencement_Date__c.addDays(365);
			       			}	
			       			objRT.Renewal_Tracker_Name__c = objET.Policy_Name__c;
			       			lstRenewalTracker.add(objRT);
			       		}
		       		}
		       		else
					{
						system.debug('*******in else**********');
		       			Renewal_Tracker__c objRenewalTracker = new Renewal_Tracker__c();
		       			objRenewalTracker.Renewal_Tracker_Name__c = objET.Policy_Name__c;
		       			objRenewalTracker.Execution_Tracker__c = objET.Id;
		       			objRenewalTracker.Entity__c = objET.Entity_Name__c;
		       			objRenewalTracker.Insurance_Type__c = 'General Insurance';
	       				objRenewalTracker.Tenure_of_Insurance__c = 54;
		       			lstRenewalTracker.add(objRenewalTracker);
					}
	       		}
			}
       		system.debug('***lstRenewalTracker***'+lstRenewalTracker);
       		upsert lstRenewalTracker;
		}
		
	}
}