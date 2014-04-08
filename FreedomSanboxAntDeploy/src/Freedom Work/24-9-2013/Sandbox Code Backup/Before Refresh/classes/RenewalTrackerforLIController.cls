public with sharing class RenewalTrackerforLIController 
{
	DatabaseSOQL dbSOQLObj {get; set;}
	public Map<Id,List<Renewal_Tracker__c>> mapIdToRenewalTracker {get;set;}
	public List<BaseRenewalTrackers> lstBaseRenewalTrackers {get;set;}
	public List<BaseRenewalTrackers> lstBaseRenewalGITrackers {get;set;}
	public Id renewalTrackerId {get;set;}
	public Id entityId {get;set;}
	public Boolean isLifeInsuranceTracker {get;set;}
	public Boolean isGeneralInsuranceTracker {get;set;}
	public Boolean isShowCancelButton {get;set;}
	
	public RenewalTrackerforLIController() 
	{
		dbSOQLObj = new DatabaseSOQL();
		isShowCancelButton = true;
		mapIdToRenewalTracker = new Map<Id,List<Renewal_Tracker__c>>();
		lstBaseRenewalTrackers = new List<BaseRenewalTrackers>();
		entityId = System.currentPageReference().getParameters().get('entityId');
		lstBaseRenewalGITrackers = new  List<BaseRenewalTrackers>();
		isLifeInsuranceTracker = false;
		isGeneralInsuranceTracker = false;
		for(Renewal_Tracker__c objAllChildRecs : [select Id,Name,Execution_Tracker__c,Entity__c,Cheque_Submission_date__c,Insurance_Type__c ,Tenure_of_Insurance__c,
						Next_renewal_date__c,Remark__c,Cheque_Number__c,Bank_Name__c,Premium_Amount__c,Target_Revenue__c,ParentId__c  from Renewal_Tracker__c 
						where Entity__c =: entityId order by CreatedDate desc])
		{
			system.debug('***objAllChildRecs****'+objAllChildRecs);
          	List<Renewal_Tracker__c> lstRenewal = new List<Renewal_Tracker__c>(); 
	          
      		if(objAllChildRecs.ParentId__c == null)
      		{
      			if(mapIdToRenewalTracker.containsKey(objAllChildRecs.Id))
      			{
      				lstRenewal = mapIdToRenewalTracker.get(objAllChildRecs.Id);
      				lstRenewal.add(objAllChildRecs);
      			}
      			else
            		lstRenewal.add(objAllChildRecs);
        		mapIdToRenewalTracker.put(objAllChildRecs.Id,lstRenewal);	
      		}
      		else
      		{
      			if(mapIdToRenewalTracker.containsKey(objAllChildRecs.ParentId__c))
      			{
      			
      				lstRenewal = mapIdToRenewalTracker.get(objAllChildRecs.ParentId__c);
      				lstRenewal.add(objAllChildRecs);
      			}
      			else
            		lstRenewal.add(objAllChildRecs);
    			mapIdToRenewalTracker.put(objAllChildRecs.ParentId__c,lstRenewal);
      		}
	 	}
		
	    for(Renewal_Tracker__c objRT : [select Id,Name,Execution_Tracker__c,Entity__c,Cheque_Submission_date__c,Execution_Tracker__r.Mode__c,Tenure_of_Insurance__c,
							Next_renewal_date__c,Remark__c,Cheque_Number__c,Bank_Name__c,Premium_Amount__c,Target_Revenue__c,Renewal_Tracker_Name__c,Insurance_Type__c  from Renewal_Tracker__c 
							where Entity__c =: entityId and ParentId__c = null])
	    {
	    	if(objRT.Insurance_Type__c != null && objRT.Insurance_Type__c.equalsIgnoreCase('Life Insurance'))
	    	{
		    	if(objRT.Execution_Tracker__r != null && objRT.Execution_Tracker__r.Mode__c != null && objRT.Next_renewal_date__c != null )
		     		lstBaseRenewalTrackers.add(new BaseRenewalTrackers(objRT.Id,objRT.Tenure_of_Insurance__c,objRT.Renewal_Tracker_Name__c, objRT, mapIdToRenewalTracker));
	    	}
	    	else if(objRT.Insurance_Type__c != null && objRT.Insurance_Type__c.equalsIgnoreCase('General Insurance'))
	    	{
	    		if(objRT.Execution_Tracker__r != null && objRT.Execution_Tracker__r.Mode__c != null && objRT.Next_renewal_date__c != null )
		     		lstBaseRenewalGITrackers.add(new BaseRenewalTrackers(objRT.Id,objRT.Tenure_of_Insurance__c,objRT.Renewal_Tracker_Name__c, objRT, mapIdToRenewalTracker));
	    	}
	    }
		
	}
	
	
	public class BaseRenewalTrackers
	{
		public Id renewalTrackerId{get;set;}
		public String policyName{get;set;}
		public Decimal totalNoOfTrackers {get;set;}
		public Renewal_Tracker__c objRenewalTracker{get;set;}
		public Map<Id,List<Renewal_Tracker__c>> mapIdToRenewalTracker{get;set;}
		public List<RenewalTrackerDetails> lstRenewalTrackerDetails{get;set;}
		public List<RenewalTrackerDetails> lstGIRenewalTrackerDetails{get;set;}
		public BaseRenewalTrackers(Id renewalTrackerId,Decimal totalNoOfTrackers,String policyName,Renewal_Tracker__c objRenewalTracker,Map<Id,List<Renewal_Tracker__c>> mapIdToRenewalTracker)
		{
			this.renewalTrackerId = renewalTrackerId;
			this.policyName = policyName;
			this.totalNoOfTrackers = totalNoOfTrackers;
			this.mapIdToRenewalTracker = mapIdToRenewalTracker;
			system.debug('**** **'+mapIdToRenewalTracker);
			
			lstRenewalTrackerDetails = new List<RenewalTrackerDetails>();
			lstGIRenewalTrackerDetails = new List<RenewalTrackerDetails>();
			
			if(mapIdToRenewalTracker.containsKey(objRenewalTracker.Id))
			{
				List<Renewal_Tracker__c> lstRenewalChildRecs = mapIdToRenewalTracker.get(objRenewalTracker.Id);
				system.debug('**lstRenewalChildRecs****'+lstRenewalChildRecs);
				
				for(Renewal_Tracker__c objChildET : lstRenewalChildRecs)
				{
					if( objChildET.Insurance_Type__c != null && objChildET.Insurance_Type__c == 'Life Insurance')
					{
						lstRenewalTrackerDetails.add(new RenewalTrackerDetails(objChildET.Id, objChildET));
					}
					else if(objChildET.Insurance_Type__c != null && objChildET.Insurance_Type__c == 'General Insurance')
					{
						lstGIRenewalTrackerDetails.add(new RenewalTrackerDetails(objChildET.Id, objChildET));
					}
				}
			}
		}
	}
	
	public class RenewalTrackerDetails
	{
		
		public Id childRenewalTrackerId{get;set;}
		public Renewal_Tracker__c objchildRenewalTracker{get;set;}
				
		public RenewalTrackerDetails(Id childRenewalTrackerId,Renewal_Tracker__c objchildRenewalTracker){
			this.childRenewalTrackerId = childRenewalTrackerId;
			this.objchildRenewalTracker = objchildRenewalTracker;
		}
		
	}
	
	public pagereference saveRenewalTracker()
	{
		try
		{
			List<Renewal_Tracker__c> lstLIRenewalTracker = new List<Renewal_Tracker__c>();
			List<Renewal_Tracker__c> lstGIRenewalTracker = new List<Renewal_Tracker__c>();
			for(BaseRenewalTrackers objBaseRenewalTrackers: lstBaseRenewalTrackers)
			{
				for(RenewalTrackerDetails objRenewalTrackerDetails : objBaseRenewalTrackers.lstRenewalTrackerDetails)
				{
					system.debug('*****=============>'+objRenewalTrackerDetails.objchildRenewalTracker);
					lstLIRenewalTracker.add(new Renewal_Tracker__c(Id = objRenewalTrackerDetails.objchildRenewalTracker.Id, 
																		Cheque_Submission_date__c = objRenewalTrackerDetails.objchildRenewalTracker.Cheque_Submission_date__c, 
																		Remark__c = objRenewalTrackerDetails.objchildRenewalTracker.Remark__c,
																		Target_Revenue__c = objRenewalTrackerDetails.objchildRenewalTracker.Target_Revenue__c,
																		Cheque_Number__c = objRenewalTrackerDetails.objchildRenewalTracker.Cheque_Number__c,
																		Bank_Name__c = objRenewalTrackerDetails.objchildRenewalTracker.Bank_Name__c,
																		Premium_Amount__c = objRenewalTrackerDetails.objchildRenewalTracker.Premium_Amount__c));
				}
			}
			
			for(BaseRenewalTrackers objBaseRenewalTrackers: lstBaseRenewalGITrackers)
			{
				for(RenewalTrackerDetails objRenewalTrackerDetails : objBaseRenewalTrackers.lstGIRenewalTrackerDetails)
				{
					system.debug('*****=GI============>'+objRenewalTrackerDetails.objchildRenewalTracker);
					lstGIRenewalTracker.add(new Renewal_Tracker__c(Id = objRenewalTrackerDetails.objchildRenewalTracker.Id, 
																		Cheque_Submission_date__c = objRenewalTrackerDetails.objchildRenewalTracker.Cheque_Submission_date__c, 
																		Remark__c = objRenewalTrackerDetails.objchildRenewalTracker.Remark__c,
																		Target_Revenue__c = objRenewalTrackerDetails.objchildRenewalTracker.Target_Revenue__c,
																		Cheque_Number__c = objRenewalTrackerDetails.objchildRenewalTracker.Cheque_Number__c,
																		Bank_Name__c = objRenewalTrackerDetails.objchildRenewalTracker.Bank_Name__c,
																		Premium_Amount__c = objRenewalTrackerDetails.objchildRenewalTracker.Premium_Amount__c));
				}
			}
			
			if(!lstLIRenewalTracker.isEmpty())
				update lstLIRenewalTracker;
			if(!lstGIRenewalTracker.isEmpty())
				update lstGIRenewalTracker;
			pageReference pageRef = new pageReference('/apex/RenewalTrackerforLi?entityId='+entityId);
			pageRef.setRedirect(true);
			return pageRef;
		}
		catch(Exception e)
		{
			if(e.getMessage().Contains(Label.ChequeSubmissionDate_RT)){
				error.LogError(Label.ChequeSubmissionDate_RT);
			}
			else if(e.getMessage().Contains(Label.TargetRevenue_RT))
				error.LogError(Label.TargetRevenue_RT);
			return null;
		}
	
	}
	
	public pagereference ViewRecords()
	{
	 	pageReference pageRef = new pageReference('/'+renewalTrackerId);
        return pageRef;
        
       /* String url = '';
        ID etid = ApexPages.currentPage().getParameters().get('entityId');
		url = 'apex/RenewalTrackerforLI?entityId='+etid;
	 	pageReference pageRef = new pageReference('/'+renewalTrackerId+'?retURL='+url);
	 	pageRef.setRedirect(true); 
	 	return pageRef;*/
	}
	
	public void lifeInsuranceTracker()
	{
 		isLifeInsuranceTracker = true;
	 	isGeneralInsuranceTracker = false;
	 	isShowCancelButton = false;
	}
	
	public void generalInsuranceTracker()
	{
	    isGeneralInsuranceTracker = true;
	 	isLifeInsuranceTracker = false;
	 	isShowCancelButton = false;
	}
	
	public PageReference cancel()
	{
		pageReference pageRef = new pageReference('/apex/RenewalTrackerforLI?entityId='+ entityId);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	public PageReference closeRT()
	{
		pageReference pageRef = new pageReference('/'+ entityId);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
}