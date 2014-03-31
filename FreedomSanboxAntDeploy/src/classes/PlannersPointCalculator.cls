/**
* 
* Author:  Ffreedom 
*
* Revision History:
*   Version     Version Author     Date           Comments
*   1.0          Ffreedom         --           Initial Draft
*  2.0      Eternus            14/06/2011    Issue Id: FS0001
*                          1. Created a Custom Label - Entity_Renewal_Fees that holds a value 11030, which are the
*                             Renewal Fees charged by Ffreedom to the client
*                           2. Updated the Entity_Non_Referral_Points Custom Label to contain a value of 40 from 35. The 
*                             value was changed due to an update in the business logic for calculating the Entity Renewal Points.   
*                          3. Updated the getEntityRenewalPointsPerWS() method to modify the logic to calculate the Entity
*                             Renewal Points based on the Renewal Fees i.e. 11030 instead of the Initial Fees - 16545
*                          4. Update the methods getEntityReferralPointsPerWS(), getEntityRenewalPointsPerWS() and 
*                               getEntityNonReferralPointsPerWS() to filter the Account(Entity) in SOQL based on the 
*                             Cheque_date__c instead of the Cheque_Received_Date__c and Cheque_Received_Date_2__c 
*                             as in the previous logic.
*                          5. Added values Client Referral and Lead Referral to the LeadSource picklist on Lead
*                          6. Added Custom Labels - Client_Referral_Points and Lead_Referral_Points which hold a value of 80
*                             to compute Entity Conversion points for Leads having LeadSource as Lead Referral and Client 
*                             Referral separately.
*                          7. Updated the getEntityNonReferralPointsPerWS() to compute the Entity Conversion Points 
*                             when LeadSource is Client Referral or Lead Referral.
*   2.1       Eternus            14/06/2011    Issue Id: FS0002
*                          1. Created a Custom Label - Entity_First_Time_Fees that holds a value 16545, which are the
*                             Renewal Fees charged by Ffreedom to the client. This value was hard coded in the existing 
*                             logic and assigned to amount variable. It is now fetched from the Custom Label.
  2.1        Eternus         28/06/2011  1. Update the method "getPlanLifecyclePointsPerWS"
                            Summary : Comment the if else condition for the if(act.Total_Cycle__c >=46 && act.Total_Cycle__c <=60)
                                  it's not required now for the point calculation.
  2.1       Eternus        29/06/2011  1. Update the method "getPlanLifecyclePointsPerWS"
                            Summary : Updated the labes's value for the as "Employee Referral (80 Points)"                                
*/


public with sharing class PlannersPointCalculator {        
        private Map<Id, String> idList = new Map<Id, String>();
        private User loggedInUser;
        private List<String> workstation ;
        private static final Integer amount = Integer.valueOf(Label.Entity_First_Time_Fees);
        
        private List<String> roles = new List<String>{'Mgr.-Financial Planning[AMETHYST MUMBAI]','Sr.Mgr.FP-AMETHYST','Sr.Mgr.FP - GALAXY'};
        private String startDate;
        private String endDate;  
        
        //private Map<String, Double> opportunityPointsPerWS = new Map<String, Double>();
        //private Map<String, Double> entityReferralPointsPerWS = new Map<String, Double>();
        private Map<String, Double> entityRenewalPointsPerWS = new Map<String, Double>();
        private Map<String, Double> entityNonReferralPointsPerWS = new Map<String, Double>();
        private Map<String, Double> planLifecyclePointsPerWS = new Map<String, Double>();
        private Map<String, Integer> planLifecyclePointsHighPerWS = new Map<String, Integer>();
        private Map<String, Integer> planLifecyclePointsMediumPerWS = new Map<String, Integer>();
        private Map<String, Integer> planLifecyclePointsLowPerWS = new Map<String, Integer>();
        //private Map<String, Integer> planLifecycleNoPointsPerWS = new Map<String, Integer>();
        private Map<String, Integer> planLifecyclePointsVeryLowPerWS = new Map<String, Integer>();
        private Map<String, Double> LIpointsPerWs = new Map<String, Double>();
        private Map<String, Double> GIpointsPerWs = new Map<String, Double>();
        private Map<String, Double> RPpointsPerWs = new Map<String, Double>();
        private Map<String, Double> EPpointsPerWs = new Map<String, Double>();
        private Map<String, Double> ITpointsPerWs = new Map<String, Double>();
        private Map<String, Double> SIPpointsPerWs = new Map<String, Double>();
        //private Map<String, Double> SIpointsPerWs = new Map<String, Double>();
        private Map<String, Double> InvestmentspointsPerWs = new Map<String, Double>();
        private Map<String, Double> BPpointsPerWs = new Map<String, Double>();
        private Map<String, Double> ABPpointsPerWs = new Map<String, Double>();
        private List<pointDetailsPerWs> pointDetailsList = new List<pointDetailsPerWs>();
        
        public Map<Id, User> mapUserIds = new Map<Id, User>(); // added by Shailesh Deshpande on 10th Oct 2011
        
        public PlannersPointCalculator()
        {
            getLoggedInUser();
            getUserList();
        }
        public String getStartDate()
        {
            return this.startDate;
        }
        
      
        public void setStartDate(String startDate){
                this.startDate = startDate;
        }
        
        public Date formateDate(String dateString)
        {
	    	  String[] stringDate = dateString.split('/');
	          Integer m =  Integer.valueOf(stringDate[0]);
	          Integer d = Integer.valueOf(stringDate[1]);
	          Integer y = Integer.valueOf(stringDate[2]);
	          return date.newInstance(y,m,d);
        }    
        
        public String getEndDate()
        {
            return this.endDate;
        }
        
        public void setEndDate(String endDate)
        {
            this.endDate = endDate;
        }
        
        public User getLoggedInUser()
        {
            this.loggedInUser = [select Id, Name, UserRoleId, Workstations__c from User where Id = :Userinfo.getUserId()];
            return this.loggedInUser;
        }
        public Map<Id, Id> getPlannerRoles()
        {
        	//Map<Id,Id> roleList = new Map<Id,Id>();
            Map<Id,Id> roleMap = new Map<Id,Id>(); //Change roleList to roleMap
            for(UserRole ur: [select Id, Name from UserRole where Name IN :roles])
            {
                    roleMap.put(ur.Id, ur.Id);
            }
            return roleMap;
        }
        
        
 /**********************************************************************************************************
        Eternus Solutions 
       Author  : Jigar Shah
       Issue Id: 
       Method Updated By : Dipak Nikam
       Updated On : 10 Aug 2011.
       Summary    : Handled the Null Pointer Exception 
        
**********************************************************************************************************/        
        
        public void getUserList()
        {
        	/*  
       			 Eternus Solutions 
      			 Author  : 
      			 Issue Id: 
     		 	 Method Updated By : Dipak Nikam
      			 Updated On : 11 Dec 2011.
       			Summary    : For showing only Financial Planners on report.    	
        	*/
        	set<Id> setUserId = new set<Id>();
        	 Map<String,FP_Roles__c> userRoleMapOfPlanner = FP_Roles__c.getAll();
			 set<ID> idSetofPlanner = new set<ID>();
			
	         for(UsersToRemove__c u: UsersToRemove__c.getall().values())
	         {
	            	setUserId .add(u.UserId__c);
	         }
	         if(userRoleMapOfPlanner.size() > 0)
			 {
			 	 for(String strName :userRoleMapOfPlanner.keySet())
				 {
				 	FP_Roles__c objPlanner = userRoleMapOfPlanner.get(strName);
					idSetofPlanner.add(objPlanner.Id__c);
				 }
			 }
			 
			 for(User u: [select Id, Name, Workstations__c from User where UserRoleId In:idSetofPlanner and Id Not In :setUserId  and isActive=true ])
	         {
	         	idList.put(u.Id, u.Name);
	            mapUserIds.put(u.Id, u);
	         }
        }
	         
        	///////////////////////////////////////////////////////////////
        	/************  Eternus Solutions  ******************
      			 Author  : 
      			 Issue Id: 
     		 	 Method Updated By : Dipak Nikam
      			 Updated On : 11 Dec 2011.
       			Summary    : Below commented code queries users according to workstation and we need only those users which are Financial planners.   
			**************/
			//////////////////////////////////////////////////////////////////
        	/*if(idList == null || idList.isEmpty())
        	{
            	if(this.loggedInUser.Workstations__c != null)
           	 	{
           			 if(this.loggedInUser.Workstations__c.equals(Label.Workstation_All) || getPlannerRoles().containsKey(this.loggedInUser.UserRoleId ))
                     {
                     	Map<String,FP_Roles__c> userRoleMapOfPlanner = FP_Roles__c.getAll();
						set<ID> idSetofPlanner = new set<ID>();
						if(userRoleMapOfPlanner.size() > 0)
						{
							for(String strName :userRoleMapOfPlanner.keySet())
							{
								FP_Roles__c objPlanner = userRoleMapOfPlanner.get(strName);
								idSetofPlanner.add(objPlanner.Id__c);
							}
						}
                        if(this.loggedInUser.Workstations__c.equals(Label.Workstation_All))
                         {            
                                workstation = new List<String>{Label.Workstation_1,Label.Workstation_2,Label.Workstation_3};
                            }
                            else
                            {
                                workstation = new List<String>{this.loggedInUser.Workstations__c};
                            }
                            
                            /*  Change by Mahesh
                              Removed Sunitha, Vinita, Amit and Vivek from the List using custom setting.>
                            */
                            
                       	/*  set<Id> setUserId = new set<Id>();
	                      for(UsersToRemove__c u: UsersToRemove__c.getall().values())
	                      {
	                         setUserId .add(u.UserId__c);
	                      }
	                      
	                      for(User u: [select Id, Name, Workstations__c from User where Id Not In :setUserId  and isActive=true ] )
	                      {
	                            idList.put(u.Id, u.Name);
	                            mapUserIds.put(u.Id, u);
	                      }
	                  }
                  else 
                    {
                        idList.put(this.loggedInUser.Id,this.loggedInUser.Name);
                        mapUserIds.put(this.loggedInUser.Id,this.loggedInUser);
                   		// workstation = new List<String>{loggedInUser.Workstations__c}; 
                 	   //System.debug('Inside else '+workstation);
                 	  // Error.debuglog('**********'+workstation);
                  	}
            }
           
            /*for(User u: [select Id, Workstations__c from User where Workstations__c IN :workstation]){
                            idList.put(u.Id, u.Workstations__c);
                    }
            }*/
       // }
        
        
       /* public void getOpportunityPointsPerWS(){
                System.debug('query String'+formateDate(this.startDate)+formateDate(this.endDate)+idList.keySet());
                for(Lead ld:[select Id,
                                            OwnerId,
                                            Probability__c
                                            from Lead 
                                            where OwnerId IN :idList.keySet() 
                                            and Appointment_Time__c != null
                                            and Appointment_Time__c >= :formateDate(this.startDate)
                                            and Appointment_Time__c <= :formateDate(this.endDate)
                                            and Probability__c != null]){
                    if(!opportunityPointsPerWS.isEmpty() && opportunityPointsPerWS.containsKey(idList.get(ld.OwnerId))){
                            Double i = opportunityPointsPerWS.get(idList.get(ld.OwnerId))+Double.valueOf(Label.Oppty_Points);
                            opportunityPointsPerWS.put(idList.get(ld.OwnerId),i);
                    }                               
                    else {
                            opportunityPointsPerWS.put(idList.get(ld.OwnerId),Double.valueOf(Label.Oppty_Points));
                    }
                }
                System.debug('opp points '+opportunityPointsPerWS);
                
        }*/

        /********************************************************************************************************** 
           Eternus Solutions 
       Author  : Jigar Shah
       Issue Id: FS0001
       Date    : 14/06/2011
       Purpose : 1. Updated the Cheque_Received_Date__c to Cheque_date__c in SOQL
              2. Added a condition to compute Entity Conversion Points when LeadSource is 
                Client Referral or Lead Referral 
       Method Updated By : Niket Chandane
             Updated On : 29 June 2011.
             Summary    : Updated the labes's value for the as "Employee Referral (80 Points)"           
    *********************************************************************************************************/
        public void getEntityNonReferralPointsPerWS()
        {
          /*for(Account a: [select Id,Name,OwnerId,Amount_Received__c,PersonLeadSource,NDC_Payout__c,Cheque_date__c from Account 
                                  where OwnerId IN :idList.keySet()
                                  and Cheque_date__c >= :formateDate(this.startDate)  
                                  and Cheque_date__c <= :formateDate(this.endDate)    
                                  and Amount_Received__c != null
                                  and PersonLeadSource != null ])*/
             for(Account a: [select Id,Name,OwnerId,Amount_Received__c,PersonLeadSource,NDC_Payout__c,Cheque_date__c from Account 
                                  where OwnerId IN :idList.keySet()
                                  and Cheque_Received_Date__c >= :formateDate(this.startDate)  
                                  and Cheque_Received_Date__c <= :formateDate(this.endDate)    
                                  and Amount_Received__c != null
                                  and PersonLeadSource != null ])                       
                 {
                  
                    if(!entityNonReferralPointsPerWS.isEmpty() && entityNonReferralPointsPerWS.containsKey(idList.get(a.OwnerId)))
                        {
                        if(a.PersonLeadSource.equals(Label.Client_Lead_Referral))
                          {
                            Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Client_Lead_Referral_Points)*(a.Amount_Received__c/amount));
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                              }
                              if(a.PersonLeadSource.equals(Label.Client_Referral)){
                                Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Client_Referral_Points)*(a.Amount_Received__c/amount));
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                              }
                              if(a.PersonLeadSource.equals(Label.Lead_Referral)){
                                Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Lead_Referral_Points)*(a.Amount_Received__c/amount));
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                              }
                              if(a.PersonLeadSource.equals(Label.BNI)){
                                Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.BNI_Points)*(a.Amount_Received__c/amount));
                                entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                              }  
                              if(a.PersonLeadSource.equals(Label.NDC)){
                                if(a.NDC_Payout__c == null){
                                  a.NDC_Payout__c = 0;
                              }
                              Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.NDC_Points)*((a.Amount_Received__c - a.NDC_Payout__c)/amount));
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                              }
                              if(a.PersonLeadSource.equals(Label.Corp_Comm)){
                                Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Corp_Comm_Points)*(a.Amount_Received__c/amount));
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                              }
                              if(a.PersonLeadSource.equals(Label.Seminar_MKT)){
                                Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Seminar_MKT_Points)*(a.Amount_Received__c/amount));
                               entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                              }
                              if(a.PersonLeadSource.equals(Label.Seminar_WS))
                              {    
                                Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Seminar_WS_Points)*(a.Amount_Received__c/amount));
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                              }
                              if(a.PersonLeadSource.equals(Label.Web)){
                                Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Web_Points)*(a.Amount_Received__c/amount));
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                              }
                              if(a.PersonLeadSource.equals(Label.Lead_Engines)){
                                Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Lead_Engines_Points)*(a.Amount_Received__c/amount));
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                              } 
                              if(a.PersonLeadSource.equals(Label.Employee_Referral)){
                                Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Employee_Referral_Points)*(a.Amount_Received__c/amount));
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                              }
                              
                              if(a.PersonLeadSource.equals(Label.Database_MF)){
                                Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Database_MF_Points)*(a.Amount_Received__c/amount));
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                              
                              }
                               if(a.PersonLeadSource.equals(Label.Database)){
                                 
                                Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Database_Point)*(a.Amount_Received__c/amount));
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                              }
                             System.debug('=======entityNonReferralPointsPerWS lOOP 1====='+entityNonReferralPointsPerWS); 
                        }                        
                        else 
                        {
                          if(a.PersonLeadSource.equals(Label.Client_Lead_Referral))
                            {
                    entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Client_Lead_Referral_Points)*(a.Amount_Received__c/amount)));
                            }
                            if(a.PersonLeadSource.equals(Label.Client_Referral))
                            {
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId), (Double.valueOf(Label.Client_Referral_Points)*(a.Amount_Received__c/amount)));
                          }
                          if(a.PersonLeadSource.equals(Label.Lead_Referral)){
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),Double.valueOf(Label.Lead_Referral_Points)*(a.Amount_Received__c/amount));
                          }
                          if(a.PersonLeadSource.equals(Label.BNI)){
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.BNI_Points)*(a.Amount_Received__c/amount)));
                          }  
                          if(a.PersonLeadSource.equals(Label.NDC)){
                            if(a.NDC_Payout__c == null){
                                a.NDC_Payout__c = 0;
                                 }
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.NDC_Points)*((a.Amount_Received__c - a.NDC_Payout__c)/amount)));
                            }
                            if(a.PersonLeadSource.equals(Label.Corp_Comm)){
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Corp_Comm_Points)*(a.Amount_Received__c/amount)));
                                }
                            if(a.PersonLeadSource.equals(Label.Seminar_MKT)){
                              entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Seminar_MKT_Points)*(a.Amount_Received__c/amount)));
                            }
                              if(a.PersonLeadSource.equals(Label.Seminar_WS))
                              {  
                                  entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Seminar_WS_Points)*(a.Amount_Received__c/amount)));
                              }
                              if(a.PersonLeadSource.equals(Label.Web)){
                                    entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Web_Points)*(a.Amount_Received__c/amount)));
                              }
                              if(a.PersonLeadSource.equals(Label.Lead_Engines)){
                                    entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Lead_Engines_Points)*(a.Amount_Received__c/amount)));
                              } 
                              if(a.PersonLeadSource.equals(Label.Employee_Referral))
                              {  
                                  entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Employee_Referral_Points)*(a.Amount_Received__c/amount)));
                              }
                              if(a.PersonLeadSource.equals(Label.Database_MF)){
                                    entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Database_MF_Points)*(a.Amount_Received__c/amount)));
                              }
                              if(a.PersonLeadSource.equals(Label.Database)){
                                    entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Database_Point)*(a.Amount_Received__c/amount)));
                              }
                               
                             System.debug('=======entityNonReferralPointsPerWS Else lOOP 1====='+entityNonReferralPointsPerWS); 
                        }
                }
                
                /*for(Account a: [select Id,
                                       OwnerId,
                                       Amount_2nd_Installment__c,
                                       PersonLeadSource,
                                       NDC_Payout__c
                                       from Account 
                                       where OwnerId IN :idList.keySet() 
                                       and Cheque_date__c >= :formateDate(this.startDate) 
                                       and Cheque_date__c <= :formateDate(this.endDate)   
                                       and Amount_2nd_Installment__c != null
                                       and PersonLeadSource != null ]) */
       for(Account a: [select Id,
                                       OwnerId,
                                       Amount_2nd_Installment__c,
                                       PersonLeadSource,
                                       NDC_Payout__c
                                       from Account 
                                       where OwnerId IN :idList.keySet() 
                                       and Cheque_Received_Date_2__c >= :formateDate(this.startDate) 
                                       and Cheque_Received_Date_2__c <= :formateDate(this.endDate)   
                                       and Amount_2nd_Installment__c != null
                                       and PersonLeadSource != null ])                                   
              {
                                                                
                        if(!entityNonReferralPointsPerWS.isEmpty() && entityNonReferralPointsPerWS.containsKey(idList.get(a.OwnerId))){
                                  if(a.PersonLeadSource.equals(Label.Client_Lead_Referral)){
                                        Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Client_Lead_Referral_Points)*(a.Amount_2nd_Installment__c/amount));
                                entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                                 
                                  }
                                  /*Eternus Solutions
                                    Author  : Pravin Patil
                                    Issue Id: FS0138
                                    Date    : 2/09/2011
                                    Purpose : Error In Query (Changed Account.Amount_Received_c To Amount_2nd_Installment__c )*/
                                  if(a.PersonLeadSource.equals(Label.Client_Referral)){                                    
                                    Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Client_Referral_Points)*(a.Amount_2nd_Installment__c/amount));
                                entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                                }
                                /*Eternus Solutions
                                    Author  : Pravin Patil  
                                    Issue Id: FS0138
                                    Date    : 2/09/2011   
                                    Purpose : Error In Query (Changed Account.Amount_Received_c To Amount_2nd_Installment__c )*/
                                if(a.PersonLeadSource.equals(Label.Lead_Referral)){
                                      Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Lead_Referral_Points)*(a.Amount_2nd_Installment__c/amount));
                                  entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                                }
                                if(a.PersonLeadSource.equals(Label.BNI)){
                                          Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.BNI_Points)*(a.Amount_2nd_Installment__c/amount));
                                  entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                                    }  
                                  if(a.PersonLeadSource.equals(Label.NDC)){
                                        if(a.NDC_Payout__c == null){
                                                a.NDC_Payout__c = 0;
                                        }
                                        Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.NDC_Points)*((a.Amount_2nd_Installment__c-a.NDC_Payout__c)/amount));
                                    entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                                  }
                                  if(a.PersonLeadSource.equals(Label.Corp_Comm)){
                                        Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Corp_Comm_Points)*(a.Amount_2nd_Installment__c/amount));
                                    entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                                  }
                                  if(a.PersonLeadSource.equals(Label.Seminar_MKT)){
                                        Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Seminar_MKT_Points)*(a.Amount_2nd_Installment__c/amount));
                                    entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                                  }
                                  if(a.PersonLeadSource.equals(Label.Seminar_WS)){
                                        Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Seminar_WS)*(a.Amount_2nd_Installment__c/amount));
                                    entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                                  }
                                  if(a.PersonLeadSource.equals(Label.Web)){
                                        Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Web_Points)*(a.Amount_2nd_Installment__c/amount));
                                    entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                                  }
                                  if(a.PersonLeadSource.equals(Label.Lead_Engines)){
                                        Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Lead_Engines_Points)*(a.Amount_2nd_Installment__c/amount));
                                    entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                                  } 
                                  if(a.PersonLeadSource.equals(Label.Employee_Referral)){
                                        Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Employee_Referral_Points)*(a.Amount_2nd_Installment__c/amount));
                                    entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                                  }
                                  if(a.PersonLeadSource.equals(Label.Database_MF)){
                                        Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Database_MF_Points)*(a.Amount_2nd_Installment__c/amount));
                                    entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                                  }
                          System.debug('=======entityNonReferralPointsPerWS lOOP 2====='+entityNonReferralPointsPerWS);        
                        }                               
                        else {
                                 if(a.PersonLeadSource.equals(Label.Client_Lead_Referral)){
                                    entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Client_Lead_Referral_Points)*(a.Amount_2nd_Installment__c/amount)));
                                  }
                                  /*Eternus Solutions
                                    Author  : Pravin Patil
                                    Issue Id: FS0138
                                    Date    : 2/09/2011
                                    Purpose : Error In Query (Changed Account.Amount_Received_c To Amount_2nd_Installment__c )*/
                                  if(a.PersonLeadSource.equals(Label.Client_Referral)){
                                entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Client_Referral_Points)*(a.Amount_2nd_Installment__c/amount)));
                                }
                                /*Eternus Solutions
                                  Author  : Pravin Patil  
                                    Issue Id: FS0138
                                    Date    : 2/09/2011   
                                    Purpose : Error In Query (Changed Account.Amount_Received_c To Amount_2nd_Installment__c )*/
                                if(a.PersonLeadSource.equals(Label.Lead_Referral)){
                                entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Lead_Referral_Points)*(a.Amount_2nd_Installment__c/amount)));
                                }
                                 if(a.PersonLeadSource.equals(Label.BNI)){
                                    entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.BNI_Points)*(a.Amount_2nd_Installment__c/amount)));
                                  }  
                                  if(a.PersonLeadSource.equals(Label.NDC)){
                                        if(a.NDC_Payout__c == null){
                                                a.NDC_Payout__c = 0;
                                        }
                                  entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.NDC_Points)*((a.Amount_2nd_Installment__c - a.NDC_Payout__c)/amount)));
                                  }
                                  if(a.PersonLeadSource.equals(Label.Corp_Comm)){
                                        entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Corp_Comm_Points)*(a.Amount_2nd_Installment__c/amount)));
                                  }
                                  if(a.PersonLeadSource.equals(Label.Seminar_MKT)){
                                        entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Seminar_MKT_Points)*(a.Amount_2nd_Installment__c/amount)));
                                  }
                                  if(a.PersonLeadSource.equals(Label.Seminar_WS)){
                                        entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Seminar_WS_Points)*(a.Amount_2nd_Installment__c/amount)));
                                  }
                                  if(a.PersonLeadSource.equals(Label.Web)){
                                        entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Web_Points)*(a.Amount_2nd_Installment__c/amount)));
                                  }
                                  if(a.PersonLeadSource.equals(Label.Lead_Engines)){
                                        entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Lead_Engines_Points)*(a.Amount_2nd_Installment__c/amount)));
                                  } 
                                  if(a.PersonLeadSource.equals(Label.Employee_Referral)){
                                        entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Employee_Referral_Points)*(a.Amount_2nd_Installment__c/amount)));
                                  }
                                  if(a.PersonLeadSource.equals(Label.Database_MF)){
                                        entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Database_MF_Points)*(a.Amount_2nd_Installment__c/amount)));
                                  }
                                  System.debug('=======entityNonReferralPointsPerWS Else lOOP 2====='+entityNonReferralPointsPerWS);
                                
                        }
                   }
                  
    
        }
        
        /********************************************************************************************************** 
           Eternus Solutions 
       Author  : Jigar Shah
       Issue Id: FS0001
       Date    : 14/06/2011
       Purpose : 1. Updated the logic to caculate Entity Renewal Points basis the Renewal fees (11030)
           instead of the Actual fees (16545) paid initially. 
           2. Updated the points considered for calculation in 
           Label.Entity_Non_Referral_Points from 35 to 40.
    *********************************************************************************************************/ 
        public void getEntityRenewalPointsPerWS(){
                 for(Renewal__c a: [select Id,
                                   Entity__r.OwnerId,
                                   Amount_Received__c
                                   from Renewal__c 
                                   where Entity__r.OwnerId IN :idList.keySet() 
                                   and Cheque_Received_Date__c >= :formateDate(this.startDate)
                                   and Cheque_Received_Date__c <= :formateDate(this.endDate)
                                   and Amount_Received__c != null]) {
                  if(!entityRenewalPointsPerWS.isEmpty() && entityRenewalPointsPerWS.containsKey(idList.get(a.Entity__r.OwnerId))){
                        Double i = entityRenewalPointsPerWS.get(idList.get(a.Entity__r.OwnerId))+(Double.valueOf(Label.Entity_Non_Referral_Points)*(a.Amount_Received__c/(Double.valueOf(Label.Entity_Renewal_Fees))));
                        entityRenewalPointsPerWS.put(idList.get(a.Entity__r.OwnerId),i);
                  }                               
                  else {
                        entityRenewalPointsPerWS.put(idList.get(a.Entity__r.OwnerId),(Double.valueOf(Label.Entity_Non_Referral_Points)*(a.Amount_Received__c/(Double.valueOf(Label.Entity_Renewal_Fees)))));
                  }
           }
        }
        
         /********************************************************************************************************** 
           Eternus Solutions 
       Author  : Jigar Shah
       Issue Id: FS0001
       Date    : 14/06/2011
       Purpose : Updated the Cheque_Received_Date__c to Cheque_date__c in SOQL 
    *********************************************************************************************************/ 
        /*public void getEntityReferralPointsPerWS(){
                for(Account a: [select Id,
                                       OwnerId,
                                       Amount_Received__c
                                       from Account 
                                       where OwnerId IN :idList.keySet() 
                                       and Cheque_date__c >= :formateDate(this.startDate)
                                       and Cheque_date__c <= :formateDate(this.endDate)
                                       and Amount_Received__c != null
                                       and (Referred_By_Entity__c != null OR Referred_By_Lead__c != null)]) {
                                                                
                        if(!entityReferralPointsPerWS.isEmpty() && entityReferralPointsPerWS.containsKey(idList.get(a.OwnerId))){
                                Double i = entityReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Entity_Referral_Points)*(a.Amount_Received__c/amount));
                                entityReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                        }                               
                        else {
                                entityReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Entity_Referral_Points)*(a.Amount_Received__c/amount)));
                        }
                }
                for(Account a: [select Id,
                                       OwnerId,
                                       Amount_2nd_Installment__c
                                       from Account 
                                       where OwnerId IN :idList.keySet() 
                                       and Cheque_date__c >= :formateDate(this.startDate)
                                       and Cheque_date__c <= :formateDate(this.endDate)
                                       and Amount_2nd_Installment__c != null
                                       and (Referred_By_Entity__c != null OR Referred_By_Lead__c != null)]) {
                                                                
                        if(!entityReferralPointsPerWS.isEmpty() && entityReferralPointsPerWS.containsKey(idList.get(a.OwnerId))){
                                Double i = entityReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Entity_Referral_Points)*(a.Amount_2nd_Installment__c/amount));
                                entityReferralPointsPerWS.put(idList.get(a.OwnerId),i);
                        }                               
                        else {
                                entityReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Entity_Referral_Points)*(a.Amount_2nd_Installment__c/amount)));
                        }
                }
                
    
        }*/
        
        
        
        /*public void getExecutionPoints(){
                for(Execution_Tracker__c ext: [select Id,
                                                      Opportunity_Name__c,
                                                      Entity_Name__r.OwnerId
                                                      from Execution_Tracker__c
                                                      where Entity_Name__r.OwnerId IN :idList.keySet() 
                                                      and Completion_Date__c >= :formateDate(this.startDate)
                                                      and Completion_Date__c <= :formateDate(this.endDate)]){
                      System.debug('Ext tRacker '+ext.Id+' '+ext.Opportunity_Name__c);
                  if(ext.Opportunity_Name__c == 'Life Insurance'){
                          if(!LIpointsPerWs.isEmpty() && LIpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId))){
                                        Double i = LIpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_Life_Insurance_Points);
                                LIpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
                          }
                          else{
                                        LIpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_Life_Insurance_Points));
                          }
                  }
                  else if(ext.Opportunity_Name__c == 'General Insurance'){
                         if(!GIpointsPerWs.isEmpty() && GIpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId))){
                                        Double i = GIpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_GI_Points);
                                GIpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
                          }
                          else{
                                        GIpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_GI_Points));
                          }
                  } 
                  else if(ext.Opportunity_Name__c == 'Income Tax Planning'){
                          if(!ITpointsPerWs.isEmpty() && ITpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId))){
                                Double i = ITpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_IT_Points);
                                ITpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
                          }
                          else{
                                        ITpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_IT_Points));
                          }
                  } 
                  else if(ext.Opportunity_Name__c == 'Real Estate'){
                          if(!RPpointsPerWs.isEmpty() && RPpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId))){
                                Double i = RPpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_RP_Points);
                                RPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
                          }
                          else{
                                RPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_RP_Points));
                          }
                  }
                  else if(ext.Opportunity_Name__c == 'SIP'){
                         if(!SIPpointsPerWs.isEmpty() && SIPpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId))){
                                Double i = SIPpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_SIP_Points);
                                SIPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
                          }
                          else{
                                SIPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_SIP_Points));
                          }
                        
                  }                             
                  else if(ext.Opportunity_Name__c == 'Succession Planning'){
                         if(!EPpointsPerWs.isEmpty() && EPpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId))){
                                        Double i = EPpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_EP_Points);
                                EPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
                          }
                          else{
                                EPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_EP_Points));
                          }     
                  }*/
                  /*else if(ext.Opportunity_Name__c == 'Subsequent Investments'){
                         if(!SIpointsPerWs.isEmpty() && SIpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId))){
                                        Double i = SIpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_SI_Points);
                                SIpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
                          }
                          else{
                                SIpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_SI_Points));
                          }     
                  }*/
                  /*else if(ext.Opportunity_Name__c == 'Investments'){
                         if(!InvestmentspointsPerWs.isEmpty() && InvestmentspointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId))){
                                        Double i = InvestmentspointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_Investments_Points);
                                InvestmentspointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
                          }
                          else{
                                InvestmentspointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_Investments_Points));
                          }     
                  }
                  else if(ext.Opportunity_Name__c == 'Business Planning'){
                         if(!BPpointsPerWs.isEmpty() && BPpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId))){
                                Double i = BPpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_BP_Points);
                                BPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
                          }
                          else{
                                BPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_BP_Points));
                          }     
                  }
                  else if(ext.Opportunity_Name__c == 'Accounts & Book Keeping'){
                         if(!ABPpointsPerWs.isEmpty() && BPpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId))){
                                Double i = ABPpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_BP_Points);
                                ABPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
                          }
                          else{
                                ABPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_BP_Points));
                          }     
                  }
           }
        }*/
        
        /*
          Modified By : Niket Chandane.
          Modified At : 29 June 2011.
          Summary : Point calculation for the Plan Completion Points.
          OwnerId IN :idList.keySet()
        */
        public void getPlanLifecyclePointsPerWS(){
                for(Account act: [select Total_Cycle__c,Name,Plan_Approved_Date__c,
                                         Plan_Lifecycle_Points__c,
                                         Amount_Received__c,
                                         Amount_2nd_Installment__c,
                                         Execution_Completion_Dates__c,
                                         OwnerId,
                                         Id
                                         from Account 
                                         where Total_Cycle__c != null 
                                         and OwnerId IN :idList.keySet()
                                         and Amount_Received__c != null /*change is here*/
                                         and Plan_Approved_Date__c >= :formateDate(this.startDate)
                                         and Plan_Approved_Date__c <= :formateDate(this.endDate)])
        {
              //Error.debuglog('1] Name of Entity :'+act.Name+'=Plan_Approved_Date__c :' +act.Plan_Approved_Date__c+'=Amount_2nd_Installment__c :'+act.Amount_2nd_Installment__c+'== Total_Cycle__c ==>'+act.Total_Cycle__c);
                    Double amountReceived = act.Amount_Received__c;
                    //Double amountReceived = 0.0;
                        if(act.Amount_2nd_Installment__c != null){
                                amountReceived += act.Amount_2nd_Installment__c;
                        }
                       // Error.DebugLog('1] Plan Life Cycle Points for ==>'+act.Name+'act.Plan_Lifecycle_Points__c :'+act.Plan_Lifecycle_Points__c+'== Total_Cycle__c ==>'+act.Total_Cycle__c+'== amountReceived =='+amountReceived);
                        if(act.Plan_Lifecycle_Points__c != null )
                        {
                              if(!planLifecyclePointsPerWS.isEmpty() && planLifecyclePointsPerWS.containsKey(idList.get(act.OwnerId)))
                              {
                                        Double i = planLifecyclePointsPerWS.get(idList.get(act.OwnerId))+(act.Plan_Lifecycle_Points__c*(amountReceived/amount));
                                       // Error.DebugLog('## Point For the ::'+act.Name+' == for the Plan_Lifecycle_Points__c :'+act.Plan_Lifecycle_Points__c+'== Points :: '+i);
                                        planLifecyclePointsPerWS.put(idList.get(act.OwnerId),i);
                                }
                                else {
                                    //Error.DebugLog('## Point For the ::'+act.Name+' == for the Plan_Lifecycle_Points__c :'+act.Plan_Lifecycle_Points__c+'== Points :: '+act.Plan_Lifecycle_Points__c*(amountReceived/amount));
                                        planLifecyclePointsPerWS.put(idList.get(act.OwnerId),act.Plan_Lifecycle_Points__c*(amountReceived/amount));
                                }
                                if(act.Total_Cycle__c >0 && act.Total_Cycle__c <=30)
                                {  
                                    if(!planLifecyclePointsHighPerWS.isEmpty() && planLifecyclePointsHighPerWS.containsKey(idList.get(act.OwnerId))){
                                                Integer i = planLifecyclePointsHighPerWS.get(idList.get(act.OwnerId))+1;
                                                planLifecyclePointsHighPerWS.put(idList.get(act.OwnerId),i);
                                        }
                                        else {
                                            planLifecyclePointsHighPerWS.put(idList.get(act.OwnerId), 1);
                                        }
                                       // Error.debuglog('*** planLifecyclePointsHighPerWS'+planLifecyclePointsHighPerWS);
                                }
                                else if(act.Total_Cycle__c >=31 && act.Total_Cycle__c <= 45)
                                {    
                                    if(!planLifecyclePointsMediumPerWS.isEmpty() && planLifecyclePointsMediumPerWS.containsKey(idList.get(act.OwnerId))){
                                          Integer i = planLifecyclePointsMediumPerWS.get(idList.get(act.OwnerId))+1;
                                          planLifecyclePointsMediumPerWS.put(idList.get(act.OwnerId),i);
                                        }
                                        else {
                                                planLifecyclePointsMediumPerWS.put(idList.get(act.OwnerId), 1);
                                        }
                                       // Error.debuglog('planLifecyclePointsMediumPerWS'+planLifecyclePointsMediumPerWS);
                                }
                                
                                else if(act.Total_Cycle__c >=46 && act.Total_Cycle__c <=60){
                                        if(!planLifecyclePointsLowPerWS.isEmpty() && planLifecyclePointsLowPerWS.containsKey(idList.get(act.OwnerId))){
                                                Integer i = planLifecyclePointsLowPerWS.get(idList.get(act.OwnerId))+1;
                                                planLifecyclePointsLowPerWS.put(idList.get(act.OwnerId),i);
                                        }
                                        else {
                                                planLifecyclePointsLowPerWS.put(idList.get(act.OwnerId), 1);
                                        } 
                                }
                                /*else if(act.Total_Cycle__c >=51 && act.Total_Cycle__c <=60){
                                        if(!planLifecycleNoPointsPerWS.isEmpty() && planLifecycleNoPointsPerWS.containsKey(idList.get(act.OwnerId))){
                                                Integer i = planLifecycleNoPointsPerWS.get(idList.get(act.OwnerId))+1;
                                                planLifecycleNoPointsPerWS.put(idList.get(act.OwnerId),i);
                                        }
                                        else {
                                                planLifecycleNoPointsPerWS.put(idList.get(act.OwnerId), 1);
                                        }
                                       System.debug('planLifecyclePointsLowPerWS'+planLifecycleNoPointsPerWS);
                                        
                                }*/
                                else if(act.Total_Cycle__c >60){
                                        if(!planLifecyclePointsVeryLowPerWS.isEmpty() && planLifecyclePointsVeryLowPerWS.containsKey(idList.get(act.OwnerId))){
                                                Integer i = planLifecyclePointsVeryLowPerWS.get(idList.get(act.OwnerId))+1;
                                                        planLifecyclePointsVeryLowPerWS.put(idList.get(act.OwnerId),i);
                                        }
                                        else {
                                                planLifecyclePointsVeryLowPerWS.put(idList.get(act.OwnerId), 1);
                                        }
                                       // Error.DebugLog('planLifecyclePointsVeryLowPerWS ==>'+planLifecyclePointsVeryLowPerWS);
                                }    
                        }   
           }
           
        }
        
        public Double getMonthsInBetween(){
                return (formateDate(this.startDate).monthsBetween(formateDate(this.endDate))+1);
        }
        public PageReference calculatePoints(){
                pointDetailsList = new List<pointDetailsPerWs>(); 
                //opportunityPointsPerWS = new Map<String, Double>();
                        entityRenewalPointsPerWS = new Map<String, Double>();
                        entityNonReferralPointsPerWS = new Map<String, Double>();
                        planLifecyclePointsPerWS = new Map<String, Double>();
                        planLifecyclePointsHighPerWS = new Map<String, Integer>();
                        planLifecyclePointsMediumPerWS = new Map<String, Integer>();
                        planLifecyclePointsLowPerWS = new Map<String, Integer>();
                        planLifecyclePointsVeryLowPerWS = new Map<String, Integer>();
                        //planLifecycleNoPointsPerWS = new Map<String, Integer>();
                        LIpointsPerWs = new Map<String, Double>();
                        GIpointsPerWs = new Map<String, Double>();
                        RPpointsPerWs = new Map<String, Double>();
                        EPpointsPerWs = new Map<String, Double>();
                        ITpointsPerWs = new Map<String, Double>();
                        SIPpointsPerWs = new Map<String, Double>();
                        //SIpointsPerWs = new Map<String, Double>();
                        InvestmentspointsPerWs = new Map<String, Double>();
                        BPpointsPerWs = new Map<String, Double>();
                        ABPpointsPerWs = new Map<String, Double>();
                        //getOpportunityPointsPerWS();
                        System.debug('====Inside Point calculation====');
                        getEntityNonReferralPointsPerWS();
                        getEntityRenewalPointsPerWS();
                        getPlanLifecyclePointsPerWS();
                       //getExecutionPoints(); /////commented since no execution points needed
               /* if(flagforWorkstation)
                {
                  ApexPages.Message ErrorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please fill the workstation for the current user');  
           ApexPages.addMessage(ErrorMsg);
                }*/
                // commented by Shailesh Deshpande on 10th October 2011
                /*for(String s: idList.values()){
                        if(entityRenewalPointsPerWS.get(s) != null){
                                entityRenewalPointsPerWS.put(s, Math.roundToLong(entityRenewalPointsPerWS.get(s)));
                        }
                        if(entityNonReferralPointsPerWS.get(s) != null){
                                entityNonReferralPointsPerWS.put(s, Math.roundToLong(entityNonReferralPointsPerWS.get(s)));
                        }
                        if(planLifecyclePointsPerWS.get(s) != null){
                                planLifecyclePointsPerWS.put(s, Math.roundToLong(planLifecyclePointsPerWS.get(s)));
                        }
                        pointDetailsPerWs pD = new pointDetailsPerWs(s,entityRenewalPointsPerWS.get(s),
                                                                    entityNonReferralPointsPerWS.get(s),planLifecyclePointsPerWS.get(s), 
                                                                    LIpointsPerWs.get(s),GIpointsPerWs.get(s),
                                                                    RPpointsPerWs.get(s),EPpointsPerWs.get(s),
                                                                    SIPpointsPerWs.get(s),ITpointsPerWs.get(s),
                                                                    InvestmentspointsPerWs.get(s),BPpointsPerWs.get(s),
                                                                    BPpointsPerWs.get(s),
                                                                    planLifecyclePointsHighPerWS.get(s), planLifecyclePointsMediumPerWS.get(s),
                                                                    planLifecyclePointsLowPerWS.get(s), planLifecyclePointsVeryLowPerWS.get(s));   
                         
                        this.pointDetailsList.add(pd);
                }*/
                
                // added by Shailesh Deshpande on 10th October 2011
                for(User s: mapUserIds.values()){
                        if(entityRenewalPointsPerWS.get(s.Name) != null){
                                entityRenewalPointsPerWS.put(s.Name, Math.roundToLong(entityRenewalPointsPerWS.get(s.Name)));
                        }
                        if(entityNonReferralPointsPerWS.get(s.Name) != null){
                                entityNonReferralPointsPerWS.put(s.Name, Math.roundToLong(entityNonReferralPointsPerWS.get(s.Name)));
                        }
                        if(planLifecyclePointsPerWS.get(s.Name) != null){
                                planLifecyclePointsPerWS.put(s.Name, Math.roundToLong(planLifecyclePointsPerWS.get(s.Name)));
                        }
                        pointDetailsPerWs pD = new pointDetailsPerWs(s.Name,entityRenewalPointsPerWS.get(s.Name),
                                                                    entityNonReferralPointsPerWS.get(s.Name),planLifecyclePointsPerWS.get(s.Name), 
                                                                    LIpointsPerWs.get(s.Name),GIpointsPerWs.get(s.Name),
                                                                    RPpointsPerWs.get(s.Name),EPpointsPerWs.get(s.Name),
                                                                    SIPpointsPerWs.get(s.Name),ITpointsPerWs.get(s.Name),
                                                                    InvestmentspointsPerWs.get(s.Name),BPpointsPerWs.get(s.Name),
                                                                    BPpointsPerWs.get(s.Name),
                                                                    planLifecyclePointsHighPerWS.get(s.Name), planLifecyclePointsMediumPerWS.get(s.Name),
                                                                    planLifecyclePointsLowPerWS.get(s.Name), planLifecyclePointsVeryLowPerWS.get(s.Name));   
                        pd.objUser = s; 
                        this.pointDetailsList.add(pd);
                }
                
                
                return null;
        }
        
        public List<pointDetailsPerWs> getPointDetailsList(){
                return this.pointDetailsList;
        }
        
        public class pointDetailsPerWs{
                public String workstaion {get; set;}
                //public Double opportunityPoints{get;set;}
                public Double entityRenewalPoints {get;set;}
                public Double entityNonReferralPoints {get;set;}
                public Double planLifeCyclePoints {get;set;}
                public Double exeLIPoints {get;set;}
                public Double exeGIPoints {get;set;}
                public Double exeRPPoints {get;set;}
                public Double exeEPPoints {get;set;}
                public Double exeSIPPoints {get;set;}
                public Double exeITPoints {get;set;}
                public Double exeInvestmentsPoints {get;set;}
                //public Double exeSIPoints {get;set;}
                public Double exeBPPoints {get;set;}
                public Double exeABPPoints {get;set;}
                public Integer planLifeCyclePointsHigh {get;set;}
                public Integer planLifeCyclePointsMedium {get;set;}
                public Integer planLifeCyclePointsLow {get;set;}
                public Integer planLifeCyclePointsVeryLow {get;set;}
                //public Integer planLifecycleNoPoints {get;set;}
                
                public Double totalPoints{get;set;}
                
                public User objUser {  get;set;  }// added by Shailesh Deshpande on 10th October 2011
                
                public pointDetailsPerWs(String workstaion, Double entityRenewalPoints,
                                        Double entityNonReferralPoints, Double planLifeCyclePoints, 
                                        Double exeLIPoints, Double exeGIPoints,
                                        Double exeRPPoints, Double exeEPPoints,
                                        Double exeSIPPoints, Double exeITPoints,
                                        Double exeInvestmentsPoints, Double exeBPPoints,
                                        Double exeABPPoints,
                                        Integer planLifeCyclePointsHigh, Integer planLifeCyclePointsMedium, 
                                        Integer planLifeCyclePointsLow, Integer planLifeCyclePointsVeryLow){
                        objUser = new User();
                        this.workstaion = workstaion;
                       // this.opportunityPoints = opportunityPoints;
                        this.entityRenewalPoints = entityRenewalPoints;
                        this.entityNonReferralPoints = entityNonReferralPoints;
                        this.exeLIPoints = exeLIPoints;
                        this.exeGIPoints = exeGIPoints;
                        this.exeSIPPoints = exeSIPPoints;
                        this.exeEPPoints = exeEPPoints;
                        this.exeRPPoints = exeRPPoints;
                        this.exeITPoints = exeITPoints;
                        this.exeInvestmentsPoints = exeInvestmentsPoints;
                        //this.exeSIPoints = exeSIPoints;
                        this.exeBPPoints = exeBPPoints;
                        this.exeABPPoints = exeABPPoints;
                        this.planLifeCyclePoints = planLifeCyclePoints;
                        this.planLifeCyclePointsHigh = planLifeCyclePointsHigh;
                        this.planLifeCyclePointsMedium = planLifeCyclePointsMedium;
                        this.planLifeCyclePointsLow = planLifeCyclePointsLow;
                        this.planLifeCyclePointsVeryLow = planLifeCyclePointsVeryLow;
                        //this.planLifecycleNoPoints = planLifecycleNoPoints;
                        this.totalPoints = 0;
                        /*if(this.opportunityPoints != null){
                            this.totalPoints += this.opportunityPoints;
                        }*/
                        if(this.entityRenewalPoints != null){
                            this.totalPoints += this.entityRenewalPoints;
                        }
                        if(this.entityNonReferralPoints != null){
                            this.totalPoints += this.entityNonReferralPoints;
                        }
                        if(this.planLifeCyclePoints != null){
                            this.totalPoints += this.planLifeCyclePoints;
                        }
                        if(this.exeLIPoints != null){
                                this.totalPoints += this.exeLIPoints;
                        }
                        else{
                                this.exeLIPoints=0;
                        }
                        if(this.exeGIPoints != null){
                                this.totalPoints += this.exeGIPoints;
                        }
                        else{
                                this.exeGIPoints=0;
                        }
                        if(this.exeRPPoints != null){
                                this.totalPoints += this.exeRPPoints;
                        }
                        else{
                                this.exeRPPoints=0;
                        }
                        if(this.exeEPPoints != null){
                                this.totalPoints += this.exeEPPoints;
                        }
                        else{
                                this.exeEPPoints=0;
                        }
                        if(this.exeSIPPoints != null){
                                this.totalPoints += this.exeSIPPoints;
                        }
                        else{
                                this.exeSIPPoints=0;
                        }
                        if(this.exeITPoints != null){
                                this.totalPoints += this.exeITPoints;
                        }
                        else{
                                this.exeITPoints=0;
                        }
                        if(this.exeInvestmentsPoints != null){
                                this.totalPoints += this.exeInvestmentsPoints;
                        }
                        else{
                                this.exeInvestmentsPoints=0;
                        }
                        /*if(this.exeSIPoints != null){
                                this.totalPoints += this.exeSIPoints;
                        }
                        else{
                                this.exeSIPoints=0;
                        }*/
                        if(this.exeBPPoints != null){
                                this.totalPoints += this.exeBPPoints;
                        }
                        else{
                                this.exeBPPoints=0;
                        }
                        if(this.exeABPPoints != null){
                                this.totalPoints += this.exeABPPoints;
                        }
                        else{
                                this.exeABPPoints=0;
                        }
                }
        }
}