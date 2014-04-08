/**
 * @Author: Dipak Nikam
 * @since :26th Dec 2011
 * @Description: KPIReportEvaluation is Service class which is creatad for
 * @Version 1.1 
 *       1)All calculation of KPI.
 *       2)This will create monthly KPI records if records are of same month then it will update same records.
 * @Version 1.2 
 *   Modified the class for below changes.
 *    -‘Meeting to Conversion’ and ‘Score to Meeting’ KPI Parameters should take Events of Type = Meeting and status = ‘Completed’ for calculations 
 */          
public with sharing class KPIReportEvaluation 	//implements Database.Batchable
{
	public ID UserID{set;get;}
	private List<Account> allNewEntities{set;get;}
	public List<Account> allEntitiesofUser{set;get;}
	private List<Account>lstofoldEntities{set;get;}
	private List<Account> allEntitiesofCurrentYear{set;get;} 
	private User m_objUser{set;get;}
	private Map<Id,Account> accountsMap {set;get;}
	private List<ID> execEntities {set;get;}
	private List<Lead> allLeads {set;get;}     
    List<Id> planApprovalEntites{set;get;} 
    List<Id> testimonialReceivedEntites {set;get;} 
    List<Id> lstLeadWithMeetingFixed {set;get;}
    List<Id> lstLeadWithConverted {set;get;}
    List<ID> refferralIds{set;get;}
    List<Lead> lstLeadReffersEntities{set;get;}
    List<Account> pApproveRequiredEntities{set;get;}
    public Date currentDate{set;get;}
    public Integer currentmonth{set;get;}
    public Integer currentYear{set;get;}
     
   
    Map<Integer,String> mapofMonth{set;get;}
 	Integer day1 = 1;
 	Integer day2 =31 ;
 	List<String> lstLeadSource{set;get;}
 	Double actualReferralReq{set;get;}
 	Map<ID,KPI_Reports__c> mapOfFpVersusKpi{set;get;}
 	Map<String,Planner_ID__c> userRoleMapOfPlanner = Planner_ID__c.getAll();
	Map<String,Manager_Role__c> userRoleMapOfMgr = Manager_Role__c.getAll();
	Map<String,Lead_Source__c> mapOfLeadSource = Lead_Source__c.getAll();
	
	
	/*public KPIReportEvaluation() //ID id
	{  
		this.UserID ='005200000017IwF' ;
		getUser();
	 	accountsMap = new Map<Id,Account>();
	 	Date dtCurrentDate = Date.newInstance(2011,12,31);
	 	currentDate= dtCurrentDate;
	 	currentYear = currentDate.year();
		currentmonth = currentDate.month();
	}*/
	
	public KPIReportEvaluation(ID id,Date dtCurrentDate) //ID id
	{  
		this.UserID = id ;
		getUser();
	 	accountsMap = new Map<Id,Account>();
	 	currentDate= dtCurrentDate;
	 	currentYear = currentDate.year();
		currentmonth = currentDate.month();
	}
	
	public Date formatDateRange(Integer year,Integer month ,Integer day)
	{
		Date startDate =Date.newInstance(year, month, day);
		return startDate;
	}
	public User getUser()
	{
		this.m_objUser = new User();
        this.m_objUser = [select Id, Name, UserRole.Name,UserRoleId, Workstations__c, CreatedDate,Organization_Joining_Date__c from User where Id = :UserID];
        return this.m_objUser;
    }
   
    public List<Account> getNewAccountListOfCurrentMonth()
    {
    	allNewEntities = new List<Account>();
    	Date startDate = currentDate.toStartOfMonth();
    	Date endDate = startDate.addMonths(1);
    	if(m_objUser != null)
    	{
    		allNewEntities =[select Id,Name,PA_PP__c,CreatedDate,Testimonial_received__c,Referred_by_Entity__c,
    								Referred_by_Lead__c,CreatedById from Account where OwnerId = :m_objUser.Id AND Entity_Status__c='Active' 
    							And RecordType.Name='Client' AND CreatedById =:m_objUser.Id  AND CreatedDate >= :startDate   
    							And CreatedDate <= :endDate ];
    	}
    	return  allNewEntities;
    }
    
   	public Double getEntitiesofCurrentMonth()
	{
		return allNewEntities.size();
	}
	
	public List<Account> getEntitiesCreatedTillDate()
    {
    	allEntitiesofUser = new List<Account>();
    	if(m_objUser != null)
    	{
    		 allEntitiesofUser =[select Id,Name,PA_PP__c,CreatedDate,Testimonial_received__c,Referred_by_Entity__c,
    		 					 Referred_by_Lead__c,CreatedById 
    		 					 from Account where OwnerId  =: m_objUser.Id AND Entity_Status__c='Active' 
    							 And RecordType.Name='Client' AND CreatedDate >= :m_objUser.Organization_Joining_Date__c	   
    							 And CreatedDate <= :currentDate.addDays(1)];
    	}
    	return  allEntitiesofUser;
    }
    
    public Double getEntitiesTillDate()
	{
		if(allEntitiesofUser != null) 
			return allEntitiesofUser.size();
		else 
			return 0;
	}

	public Double getTotalEntitiesOfCurrentYear()
	{
		if(allEntitiesofCurrentYear != null)
			return allEntitiesofCurrentYear.size();
		else
			return 0;
	}
	public List<Account> getNewEntitiesCurrentFinancialYear()
    {
    	allEntitiesofCurrentYear = new List<Account>();
    	if(m_objUser != null)
    	{
    		if(currentmonth==1 ||currentmonth==2 ||currentmonth==3 )
    		{
    			allEntitiesofCurrentYear =[select Id,Name,PA_PP__c,CreatedDate,Testimonial_received__c,CreatedById,Referred_by_Entity__c,Referred_by_Lead__c 
  										from Account where OwnerId = :m_objUser.Id AND Entity_Status__c='Active' AND CreatedById = :m_objUser.Id 
    									And RecordType.Name='Client' AND CreatedDate >= : formatDateRange(currentYear-1,4,day1) 
    									And CreatedDate <= :currentDate.addDays(1)];
    		}
    		else
    		{
    			allEntitiesofCurrentYear =[select Id,Name,PA_PP__c,CreatedDate,Testimonial_received__c,Referred_by_Entity__c,CreatedById,Referred_by_Lead__c 
  										from Account where OwnerId = :m_objUser.Id AND Entity_Status__c='Active' AND CreatedById = :m_objUser.Id 
    									And RecordType.Name='Client' AND CreatedDate >= : formatDateRange(currentYear,4,day1) 
    									And CreatedDate <= :currentDate.addDays(1)];
    		}	
    	}
    	return  allEntitiesofCurrentYear;
    }
    
    public Double getOldEntities()
	{
		if(lstofoldEntities != null)
			return lstofoldEntities.size();
		else
			return 0;
	}
	public Double getExecutionEntities()
	{
		if(execEntities != null)
			return execEntities.size();
		else 
			return 0;
	}
	
	public List<ID> getExecutionDetails()
	{
		execEntities = new List<ID>();
		lstofoldEntities = new List<Account>();
		List<Execution_Tracker__c> allExecutionTrackers = new List<Execution_Tracker__c>();
        Map<Id,Integer> accountTrackersMap = new Map<Id,Integer>();
        
       	if(allEntitiesofUser != null && allEntitiesofUser.size() > 0)
       	{
       		for(Account acc:allEntitiesofUser)
        	{
        		  Date AccountCreationDate = acc.CreatedDate.date();
        		  Integer ageOfEntity = AccountCreationDate.monthsBetween(currentDate);
        		  if(ageOfEntity >= 6)
        		  {
        		  	lstofoldEntities.add(acc);
        		  }
        	}
       	}
       
       if(lstofoldEntities != null && lstofoldEntities.size() > 0)
       	{
       		for(Account objAccount:lstofoldEntities)
       		{
       			accountsMap.put(objAccount.Id,objAccount);
       		}
       	}
       	
       	if(!accountsMap.isEmpty() && accountsMap.size() > 0)
        {
        	allExecutionTrackers = [select Id,Completion_Date__c,CreatedDate,Entity_Name__c from Execution_Tracker__c 
        							 where Entity_Name__c IN: accountsMap.keyset() And Completion_Date__c != Null];
		}
		
		if(allExecutionTrackers != null && allExecutionTrackers.size() > 0)
        {
        	Integer iCount;
        	DateTime entityCreationDate;
        	Datetime plusSixMonths ;
        	for(Execution_Tracker__c tracker: allExecutionTrackers)
        	{
	    		iCount =0;
	    		entityCreationDate =  accountsMap.get(tracker.Entity_Name__c).CreatedDate;
		        plusSixMonths =  entityCreationDate.addMonths(6);
	           if(tracker.Completion_Date__c <= plusSixMonths)
	           {
	           		if(!accountTrackersMap.isEmpty() && accountTrackersMap.containsKey(tracker.Entity_Name__c))
		             {
		             	iCount = accountTrackersMap.get(tracker.Entity_Name__c);
		             	iCount =iCount + 1;
		             	accountTrackersMap.put(tracker.Entity_Name__c,iCount);
		             }       
		             else
		             {
		             	iCount = iCount + 1;
		             	accountTrackersMap.put(tracker.Entity_Name__c,iCount);
		             }
				}
            }
        }
        if(accountTrackersMap != null && accountTrackersMap.size() > 0 )
    	{
    		for(Id entityId:accountTrackersMap.keySet())
        	{
        		Integer iCount = accountTrackersMap.get(entityId);
                if(iCount >= 2)
                {
                	execEntities.add(entityId);
            	}
        	}
        }
     return execEntities;       
	}
	
	
	public Double getPlanApprovalsEntities()
    {
    	if(planApprovalEntites != null)
			return planApprovalEntites.size();
		else 
			return 0;
	}
	
	public Double getPlanApproveRequiredEntities()
    {
    	if(pApproveRequiredEntities != null)
			return pApproveRequiredEntities.size();
		else
			return 0;
	}
	
	public void getPlanApprovalDetails()
    {
    	planApprovalEntites = new List<Id>();
    	pApproveRequiredEntities = new List<Account>();
    	Double noOfDays = 0;
    	if(allEntitiesofUser != null && allEntitiesofUser.size() > 0)
    	{
	    	for(Account entity:allEntitiesofUser)
		   	{
		   		Date accDate = entity.CreatedDate.date(); 
		   		noOfDays = accDate.daysBetween(currentDate);
		   		if(noOfDays >= 45)
		   		{
		   			pApproveRequiredEntities.add(entity);
		   		}
		    }
		}
		if(pApproveRequiredEntities != null && pApproveRequiredEntities.size() > 0)
		{
			for(Account entity: pApproveRequiredEntities)
		   	{
		   		if(entity.PA_PP__c <= 45)
		   		{
		   			System.debug('planApprovedOldEntity===='+entity.Id); 
		   			planApprovalEntites.add(entity.Id);
		   		}
		   	}
		}
    }
    
    public void getTestimonialDetails()
    {
    	testimonialReceivedEntites = new List<Id>();
    	if(allEntitiesofUser != null && allEntitiesofUser.size()> 0)
    	{
	    	for(Account entity:allEntitiesofUser)
		   	{
		   		if(entity.Testimonial_received__c == 'Yes')
	   			{
	   				testimonialReceivedEntites.add(entity.Id);
	   			}
		   	}
    	}
    }
    
    public Double getTestimonials()
    {
		return testimonialReceivedEntites.size();
	}
	
	public void  getLeadSource()
	{
		lstLeadSource =  new List<String>(); 
		if(!mapOfLeadSource.isEmpty() && mapOfLeadSource.size() > 0)
		{
			for(String strLeadSource :mapOfLeadSource.keySet())
			{
				String strName = mapOfLeadSource.get(strLeadSource).Lead_Source_Name__c;
				lstLeadSource.add(strName);
			}	
		}	
	}
	
	
	public List<Lead> getLead()
    {
    	getLeadSource();
    	allLeads = new List<Lead>();
    	if(m_objUser != null && lstLeadSource != null && lstLeadSource.size() > 0)
    	{
    			allLeads = [select Id,OwnerId,Appointment_Time__c,IsConverted,LeadSource,Status,CreatedDate  from Lead 
      					   where OwnerId = :m_objUser.Id And CreatedDate >= :m_objUser.Organization_Joining_Date__c   
    						And CreatedDate <= :currentDate.addDays(1) And Ffreedom_Score__c != null and LeadSource IN :lstLeadSource ];
    	}
    	 return allLeads;
	}
	
	
	public Double getLeadNumbers()
    {
		return allLeads.size();
	}
   
   public void getConversionLeads()
   {
   	    Map<ID,Lead> mapOFIdandLead = new Map<ID,Lead>();
   	    Map<ID,List<Event>> mapOfIdandlistofEvents = new Map<ID,List<Event>>();
   	    
   	    lstLeadWithMeetingFixed = new List<Id>();
    	lstLeadWithConverted = new List<Id>();
		
		if(allLeads != null && allLeads.size() > 0)
		{
	    	for(Lead objLead :allLeads)
		   	{
		   		mapOFIdandLead.put(objLead.Id,objLead);
		   	}
		   if(!mapOFIdandLead.isEmpty())
		   {
		   	  for(Event objEvent :[Select e.WhoId ,e.Subject_Category__c, e.Subject, e.Id, e.Event_Status__c,e.Event_Category__c From Event e where WhoId IN:mapOFIdandLead.keySet() and Event_Status__c = 'Complete' and Event_Category__c = 'Meeting'])
		   	  {
		   	  	 if(!mapOfIdandlistofEvents.isEmpty() && mapOfIdandlistofEvents.containsKey(objEvent.WhoId))
		   	  	 {
		   	  	 	List<Event> lstEvents = mapOfIdandlistofEvents.get(objEvent.WhoId);
		   	  	 	lstEvents.add(objEvent);
		   	  	 	mapOfIdandlistofEvents.put(objEvent.WhoId,lstEvents);
		   	  	 }
		   	  	 else
		   	  	 {
		   	  	 	List<Event> lstEvents = new List<Event>();
                    lstEvents.add(objEvent);
                    mapOfIdandlistofEvents.put(objEvent.WhoId,lstEvents);
		   	  	 }
		   	  }
		   }
		   
		   
		   
		   if(!mapOFIdandLead.isEmpty())
		   {
		   	  //mapOfIdandlistofEvents
		   	  for(ID strLeadId :mapOFIdandLead.keySet())
		   	  {
			   	  	Lead objLead = mapOFIdandLead.get(strLeadId);
			   	  	List<Event> lstEventsToCheck = mapOfIdandlistofEvents.get(strLeadId);
			   	  	if(!mapOfIdandlistofEvents.isEmpty() && mapOfIdandlistofEvents.containsKey(strLeadId))
			   	  	{
			   	  		if(lstEventsToCheck != null && lstEventsToCheck.size() > 0)
	                    {
	                    	lstLeadWithMeetingFixed.add(objLead.Id);
			   	  		}
			   	  	}
			   	  	if(objLead.IsConverted)
                    {
                    	lstLeadWithConverted.add(objLead.Id);
                        System.debug('lstLeadWithConverted=============='+lstLeadWithConverted);
                    }
		   	  }
		   }
		}
    }
    
    public Double getLeadWithMeetingFixed()
    {
		return lstLeadWithMeetingFixed.size();
	}
    
    public Double getLeadWithConverted()
    {
		return lstLeadWithConverted.size();
	}
	
	public Double getTotalReferralEntities()
    {
    	if(lstLeadReffersEntities != null) 
			return lstLeadReffersEntities.size();
		else
			return 0;	 
	}
	
	public void getReferralDetails()
    {
    	lstLeadReffersEntities = new List<Lead>();
    	actualReferralReq = 0;
    	if(allEntitiesofUser != null && allEntitiesofUser.size()>0)
    	{
	    	for(Account objAccount:allEntitiesofUser)
       		{
       			accountsMap.put(objAccount.Id,objAccount);
       		}
    	}
	    if(accountsMap.size() > 0)
    		lstLeadReffersEntities = [select Id,OwnerId,Appointment_Time__c,LeadSource,Status,CreatedDate,
    								  Referred_by_Entity__c  from Lead where Referred_by_Entity__c IN :accountsMap.keyset()];
		if(!accountsMap.isEmpty() && accountsMap.size() > 0)
    	{
    		refferralIds = new List<ID>();
    		Integer AgeInmonths = 0;
        	Date AccountCreatedDate;
    		Double sumOfmonths = 0;
    		for(ID entityId:accountsMap.keySet())
        	{
        		AccountCreatedDate = accountsMap.get(entityId).CreatedDate.date();
        		AgeInmonths = AccountCreatedDate.monthsBetween(currentDate);
        		sumOfmonths = sumOfmonths + AgeInmonths;
        	}
        	actualReferralReq = sumOfmonths * 0.5;
        	actualReferralReq = actualReferralReq.round();
        }
    }
    
   public void getExistingKpi()
   {
   		Date startDate = currentDate.toStartOfMonth();
    	Date endDate = startDate.addMonths(1).addDays(-1);
    	
    	mapOfFpVersusKpi = new Map<ID,KPI_Reports__c>();
   		for(KPI_Reports__c objKpi: [Select k.Planner_Name__c, k.Id, k.CreatedDate,k.Month__c From KPI_Reports__c k where Month__c = THIS_YEAR])//
   		{
   			Integer month= objKpi.Month__c.month();
   			if(month == currentmonth)
   			{	
   				mapOfFpVersusKpi.put(objKpi.Planner_Name__c,objKpi);
   			}
   		}
   }  
   
   public void getKPIReports()
   {
   		String NameofCurrentMonth = '';
   		Decimal executionPoints = 0;
   		Decimal testimonialPoints = 0;
   		Decimal planAppDurationPoints = 0;
   		Decimal leadMeetingFixedPoints = 0;
   		Decimal leadconvertedPoints = 0;
   		Decimal referalPoints = 0;
   		Decimal newEntityPoints = 0;
   		
   		Double executionRequired = 0;
   		Double planApprovalRequired = 0;
   		Double testimonialRequired = 0;
   		Double referralRequired = 0;
   		Double leadMeetingRequired = 0;
   		Double leadConvertedRequired = 0;
   		Double timeFrame;
   		Double defaultExecution =0;
   		Double defaultPlanApproval =0;
   		Double defaultTestimonial = 0;
   		Double defaultReferral = 0;
   		Double defaultLeadMeeting = 0;
   		Double defaultLeadConverted =0;
   		Double defaultEntities = 0;
   		
   	
   		Percentage__c  objPercentage;
   		KPI_Reports__c objKPIReport;
   		
   		getExistingKpi();
   		getEntitiesCreatedTillDate();
   		getNewEntitiesCurrentFinancialYear();
   		getNewAccountListOfCurrentMonth();
   		getLead();
   		getExecutionDetails();
   		getPlanApprovalDetails();
   		getTestimonialDetails();
   		getConversionLeads();
   		getReferralDetails();
   		
   		set<ID> idSetofPlanner = new set<ID>();
	 	set<ID> idSetofMgr = new set<ID>();
	 	if(userRoleMapOfPlanner.size() > 0)
		{
			for(String strName :userRoleMapOfPlanner.keySet())
			{
				Planner_ID__c objPlanner = userRoleMapOfPlanner.get(strName);
				idSetofPlanner.add(objPlanner.Id__c);
			}
		} 
		if(userRoleMapOfMgr.size() > 0)
		{
			for(String strName :userRoleMapOfMgr.keySet())
			{
				Manager_Role__c objMgr = userRoleMapOfMgr.get(strName);
				idSetofMgr.add(objMgr.Id__c);
			}
		}
		
		
		Double expectedEntities = 0;
   		Date startDateofYear;
   		if(currentmonth ==1 ||currentmonth == 2 || currentmonth == 3)
   		{
   			startDateofYear = formatDateRange(currentYear - 1,4,day1);
   		}
   		else
   		{
   			startDateofYear = formatDateRange(currentYear,4,day1);
   		}
   		
   		timeFrame = startDateofYear.monthsBetween(currentDate);
   		timeFrame =  timeFrame + 1;
   		if(m_objUser.Organization_Joining_Date__c != null)
   		{
   			Integer compareDay = m_objUser.Organization_Joining_Date__c.day();
	   		if(m_objUser.Organization_Joining_Date__c < startDateofYear)
	   		{
	   			expectedEntities = 4 * timeFrame;
	   		}
	   		else
	   		{
	   			timeFrame = m_objUser.Organization_Joining_Date__c.monthsBetween(currentDate);
	   			timeFrame = timeFrame + 1;
	   			for(Integer iCount = 1;iCount <= timeFrame;iCount++)
	   			{
	   				if(iCount == 1)
	   				{
	   					if(compareDay < 15)
	   					 	expectedEntities = expectedEntities + 2;
	   					 else
	   					 	expectedEntities = expectedEntities + 1;
	   				}
	   				else if(iCount == 2)
	   				{
	   					expectedEntities = expectedEntities + 2;
	   				}
	   				else if(iCount > 2) 
	   				{
	   					expectedEntities = expectedEntities + 4;
	   				}
	   			}
	   		}
   		}
   		
   		
   		Double entitiesOfCurrentMonth = getEntitiesofCurrentMonth();//total entity count created by User in current Month.
   		Double  totalEntities_FY = getTotalEntitiesOfCurrentYear();//total entity count created by User in current Year.
   		Double entityCountTillDate = getEntitiesTillDate();//total entity count created by User till date.
   		Double oldEntities = getOldEntities();//6 or greater than 6 older Entity count.
   		Double totalLeadCount = getLeadNumbers();//total lead count
   		Double totalExecution = getExecutionEntities(); //total execution count
   		Double planApprovedOldCount = getPlanApproveRequiredEntities(); //Entity  which are 45 or greater than 45 days old
   		Double totalPlanAppcount =  getPlanApprovalsEntities(); // total plan approval count
   		Double totalTestimonialCount = getTestimonials(); // total testimonial count
   		Double leadMeetingFixed = getLeadWithMeetingFixed(); // Total Lead count of meeting fixed
   		Double convertedLeadCount = getLeadWithConverted(); //Total lead count of converted
   		Double refferralCount = getTotalReferralEntities(); //Total refferrral count
   		
   		try
   		{	
   			if(idSetofPlanner.contains(m_objUser.UserRoleId))
   			{
	   			objPercentage = Percentage__c.getInstance('Financial Planner');
	   			
	   			defaultEntities = expectedEntities;
 				if(expectedEntities != 0)
   				{
	   				newEntityPoints = (25/expectedEntities) * totalEntities_FY;
	   				newEntityPoints = newEntityPoints.setScale(2);
	   			}
	   			executionRequired =((objPercentage.ExecutionsPercent__c/100) * oldEntities);
   				executionRequired = executionRequired.round();
   				defaultExecution = executionRequired;
   				if(executionRequired != 0)
   				{
   					executionPoints = ((objPercentage.Executions__c/executionRequired)*totalExecution);
   					executionPoints = executionPoints.setScale(2);
   				}
   				planApprovalRequired = (0.75* planApprovedOldCount).round();
   				defaultPlanApproval =planApprovalRequired;
   				if(planApprovalRequired != 0)
   				{	
   					planAppDurationPoints = (objPercentage.Plan_Approval_Duration__c/planApprovalRequired)*totalPlanAppcount;
   					planAppDurationPoints =planAppDurationPoints.setScale(2);
   				}
   				testimonialRequired = ((objPercentage.TestimonialPercent__c /100) * entityCountTillDate).round();
   				defaultTestimonial  = testimonialRequired;
   				if(testimonialRequired != 0)
   				{
   					testimonialPoints =((objPercentage.Testimonial__c/ testimonialRequired) * totalTestimonialCount);
   					testimonialPoints = testimonialPoints.setScale(2);
   				}
   				referralRequired = actualReferralReq;
   				defaultReferral  = referralRequired;
   				if(referralRequired != 0)
   				{
   					referalPoints =((objPercentage.Client_Referral__c/referralRequired)*refferralCount);
   					referalPoints = referalPoints.setScale(2);
   				}
   				leadMeetingRequired = ((objPercentage.LeadMeetingFixedPercent__c / 100) * totalLeadCount);
				leadMeetingRequired = leadMeetingRequired.round();
				defaultLeadMeeting  = leadMeetingRequired;
				if(leadMeetingRequired != 0)
				{
					leadMeetingFixedPoints = (objPercentage.ConversionratesWithMeetingFix__c/leadMeetingRequired)*leadMeetingFixed;
					leadMeetingFixedPoints = leadMeetingFixedPoints.setScale(2);
				}
				leadConvertedRequired = ((objPercentage.LeadConversionPercent__c / 100) * totalLeadCount);
				leadConvertedRequired =leadConvertedRequired.round();
				defaultLeadConverted  = leadConvertedRequired;
				if(leadConvertedRequired != 0)	
				{
					leadconvertedPoints = (objPercentage.ConversionratesforLeadconverted__c/leadConvertedRequired)*convertedLeadCount;
					leadconvertedPoints =leadconvertedPoints.setScale(2);
	   			}
			}
	   		else if(idSetofMgr.contains(m_objUser.UserRoleId))
	   		{
	   			objPercentage = Percentage__c.getInstance('Team Leader');
	   			
	   			defaultEntities = expectedEntities;
 				if(expectedEntities != 0)
   				{
	   				newEntityPoints = (25/expectedEntities) * totalEntities_FY;
	   				newEntityPoints = newEntityPoints.setScale(2);
	   			}
	   			executionRequired =((objPercentage.ExecutionsPercent__c/100) * oldEntities);
   				executionRequired = executionRequired.round();
   				defaultExecution = executionRequired;
   				if(executionRequired != 0)
   				{
   					executionPoints = ((objPercentage.Executions__c/executionRequired)*totalExecution);
   					executionPoints = executionPoints.setScale(2);
   				}
   				planApprovalRequired = (0.75* planApprovedOldCount).round();
   				defaultPlanApproval = planApprovalRequired;
   				if(planApprovalRequired != 0)
   				{	
   					planAppDurationPoints = (objPercentage.Plan_Approval_Duration__c/planApprovalRequired)*totalPlanAppcount;
   					planAppDurationPoints =planAppDurationPoints.setScale(2);
   				}
   				testimonialRequired = ((objPercentage.TestimonialPercent__c /100) * entityCountTillDate).round();
				defaultTestimonial  = testimonialRequired;
   				if(testimonialRequired != 0)
   				{
   					testimonialPoints =((objPercentage.Testimonial__c/ testimonialRequired) * totalTestimonialCount);
   					testimonialPoints = testimonialPoints.setScale(2);
   				}
   					
   				referralRequired = actualReferralReq;
   				defaultReferral  = referralRequired;
   				if(referralRequired != 0)
   				{
   					referalPoints =((objPercentage.Client_Referral__c/referralRequired)*refferralCount);
   					referalPoints = referalPoints.setScale(2);
   				}
   				leadMeetingRequired = ((objPercentage.LeadMeetingFixedPercent__c / 100) * totalLeadCount);
				leadMeetingRequired = leadMeetingRequired.round();
				defaultLeadMeeting  = leadMeetingRequired;
				if(leadMeetingRequired != 0)
				{
					leadMeetingFixedPoints = (objPercentage.ConversionratesWithMeetingFix__c/leadMeetingRequired)*leadMeetingFixed;
					leadMeetingFixedPoints = leadMeetingFixedPoints.setScale(2);
				}
				leadConvertedRequired = ((objPercentage.LeadConversionPercent__c / 100) * totalLeadCount);
				leadConvertedRequired =leadConvertedRequired.round();
				defaultLeadConverted  = leadConvertedRequired;
				if( leadConvertedRequired !=0)
				{
					leadconvertedPoints = (objPercentage.ConversionratesforLeadconverted__c/leadConvertedRequired)*convertedLeadCount;
					leadconvertedPoints =leadconvertedPoints.setScale(2);
				}
	   		}
	   		
   	        if(!mapOfFpVersusKpi.isEmpty() && mapOfFpVersusKpi.containsKey(m_objUser.Id))
   			{
   				objKPIReport = mapOfFpVersusKpi.get(m_objUser.Id);
   			}
   			else
   			{
   					objKPIReport = new KPI_Reports__c();
   			}
            
            objKPIReport.Planner_Name__c = m_objUser.Id;
   			objKPIReport.Role__c = m_objUser.UserRole.Name;
   			objKPIReport.Organization_Joining_Date__c = m_objUser.Organization_Joining_Date__c;
   			System.debug('objKPIReport.Organization_Joining_Date__c=============='+m_objUser.Organization_Joining_Date__c);
   			objKPIReport.OwnerId = m_objUser.Id;
   			
   			objKPIReport.Month__c = currentDate.toStartOfMonth().addMonths(1).addDays(-1);
   			
   			objKPIReport.Total_Entities_FY__c = totalEntities_FY;
	   		objKPIReport.Total_Entities_Till_Date__c = entityCountTillDate;
	   		objKPIReport.Total_Entities__c = entitiesOfCurrentMonth;
	   		objKPIReport.Total_Number_of_old_Entities__c = oldEntities;
	   		
	   		objKPIReport.Total_Testimonial__c = totalTestimonialCount;
	   		objKPIReport.Total_Plan_approvals__c = totalPlanAppcount;
	   		
	   		objKPIReport.Executions__c = totalExecution;	   		
	   		objKPIReport.Total_Client_Refferal__c = refferralCount;
	   	   	
	   	   	objKPIReport.Total_Leads_Score__c = totalLeadCount;
	   		objKPIReport.Total_Lead_Meetings__c = leadMeetingFixed;
	   		objKPIReport.Total_Lead_Conversion__c = convertedLeadCount; 
	   		
	   		objKPIReport.New_Entities__c = newEntityPoints;
	   		objKPIReport.Client_Referral__c = referalPoints;
	   		objKPIReport.Execution_per__c = executionPoints;
	   		objKPIReport.Lead_Conversion__c = leadconvertedPoints;
	   		objKPIReport.Lead_Meeting_Fixed__c =  leadMeetingFixedPoints;  
	   		objKPIReport.Plan_Approval__c = planAppDurationPoints;
	   		objKPIReport.Testimonial__c = testimonialPoints;
	   		
	   		objKPIReport.Executions_Required__c = defaultExecution ;
	   		objKPIReport.Lead_Conversion_Required__c =  defaultLeadConverted;
			objKPIReport.Lead_Meeting_Fixed_Required__c = defaultLeadMeeting;
			objKPIReport.Plan_Approval_Required__c= defaultPlanApproval ;
			objKPIReport.Testimonial_Required__c = defaultTestimonial ; 
			objKPIReport.Client_Referral_Required__c = defaultReferral ;
			objKPIReport.New_Entities_Required__c = defaultEntities;
			
			if(m_objUser.Organization_Joining_Date__c < currentDate)
			{
				Database.Upsertresult objectUpsertResult = Database.upsert(objKPIReport);
	   			if(objectUpsertResult.isSuccess())
	   			{
	   				system.debug('Record saved successfully===='+objectUpsertResult.getId());
	   			}
			}
			else
			{
				system.debug('Record not saved for User ===='+m_objUser.UserRoleId+'=====m_objUser.Id===='+m_objUser.Id);
			}
   		}
	   	catch(Exception e)
	   	{
	   		system.debug('Exception===='+e.getMessage());
	   	}
  }
}