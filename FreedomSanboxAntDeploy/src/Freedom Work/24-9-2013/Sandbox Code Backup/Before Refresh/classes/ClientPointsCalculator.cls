/*
	Revision History:
	
    Version     Version Author     Date        	Comments
    1.0         Mahesh Hirugade	   18/11/2011	This class is used to calculate points of Planners and their reated clients. Calculated points are sent to 
    											BatchPointsCalculator and then inserted on Planner_Points__c and Related_Entity_Points__c objects in batch class. 
    
*/
public with sharing class ClientPointsCalculator
{
        public Map<Id, String> idList = new Map<Id, String>();
        private User loggedInUser;
        private List<String> workstation;
        private static final Integer amount = Integer.valueOf(Label.Entity_First_Time_Fees);
        
        public String startDate;
        public String endDate;
        
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
        
       //* Added by Dipak Nikam 
       //Date : 15/11/2011
       Map<ID,Map<ID,Double>> MapOfEntityConversionPoints{set;get;} 
       Map<ID,Map<ID,Double>> MapOfPlanLifeCyclePoints{set;get;} 
       Map<ID,Map<ID,Double>> MapOfEntityRenewalPoints{set;get;}
      
	   Map<ID,Map<ID,Double>> mapOfLIPoints{set;get;}
	   Map<ID,Map<ID,Double>> mapOfGIPoints{set;get;}
	   Map<ID,Map<ID,Double>> mapOfSIPPoints{set;get;}
	   Map<ID,Map<ID,Double>> mapOfBusinessPlanPoints{set;get;}
	   Map<ID,Map<ID,Double>> mapOfRealEstatePoints{set;get;} 
	   Map<ID,Map<ID,Double>> mapOfInvestmentPoints{set;get;}
	   Map<ID,Map<ID,Double>> mapOfSuccessionPlanPoints{set;get;}
	   Map<ID,Map<ID,Double>> mapOfIncomeTaxPoints{set;get;} 
	   Map<ID,Map<ID,Double>> mapOfAccBookPoints{set;get;}
       
		public Map<Id, List<String>> mapChildEntityConversionPoints = new Map<Id, List<String>>();
		public Map<Id, List<string>> mapChildLIPoints = new Map<Id, List<string>>();//Mahesh
		public Map<Id, List<String>> mapChildGIPoints = new Map<Id, List<String>>();//Mahesh
		public Map<Id, List<String>> mapChildSIPPoints = new Map<Id, List<String>>();//Mahesh
		public Map<Id, List<String>> mapChildInvestmentPoints = new Map<Id, List<String>>();//Mahesh
		public Map<Id, List<String>> mapChildBPPoints = new Map<Id, List<String>>();//Mahesh
		public Map<Id, List<String>> mapChildREPoints = new Map<Id, List<String>>();//Mahesh
		public Map<Id, List<String>> mapChildSPPoints = new Map<Id, List<String>>();//Mahesh
		public Map<Id, List<String>> mapChildITPPoints = new Map<Id, List<String>>();//Mahesh
		public Map<Id, List<String>> mapChildABPPoints = new Map<Id, List<String>>();//Mahesh
       
       //List Of Inner Classes 
       private List<childPointDetails> ChildPointDetailsList = new List<childPointDetails>();
       private List<pointDetailsPerWs> pointDetailsList = new List<pointDetailsPerWs>();
       
       private set<Id> setRemoveUId = new set<Id>();
       //Constructor
       public ClientPointsCalculator()
        {
        	for(UsersToRemove__c u: UsersToRemove__c.getall().values())
				setRemoveUId.add(u.UserId__c);
				
        	MapOfEntityConversionPoints = new Map<ID,Map<ID,Double>>();
            MapOfPlanLifeCyclePoints = new Map<ID,Map<ID,Double>>(); 
            MapOfEntityRenewalPoints =  new Map<ID,Map<ID,Double>>(); 
            
            mapOfLIPoints = new Map<ID,Map<ID,Double>>();
            mapOfGIPoints = new Map<ID,Map<ID,Double>>(); 
            mapOfSIPPoints =  new Map<ID,Map<ID,Double>>();
            
            mapOfBusinessPlanPoints = new Map<ID,Map<ID,Double>>();
            mapOfRealEstatePoints  = new Map<ID,Map<ID,Double>>(); 
            mapOfInvestmentPoints  =  new Map<ID,Map<ID,Double>>(); 
            
            mapOfSuccessionPlanPoints = new Map<ID,Map<ID,Double>>();
            mapOfIncomeTaxPoints = new Map<ID,Map<ID,Double>>(); 
            mapOfAccBookPoints  =  new Map<ID,Map<ID,Double>>();  
        }
        
        public String getStartDate()
        {
                return this.startDate;
        }
      
        public void setStartDate(String startDate)
        {
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
    
    public void getCurrentEntityPoints(String pId, String pOwnerId, Double pdblCurrentEntityConversionPoints)
	{
		Map<ID,Double> mapOfTempPoints = new Map<ID,Double>();
		if(!MapOfEntityConversionPoints.isEmpty() && MapOfEntityConversionPoints.containsKey(pOwnerId))
		{
			mapOfTempPoints = MapOfEntityConversionPoints.get(pOwnerId);
			if(!mapOfTempPoints.isEmpty() && mapOfTempPoints.ContainsKey(pId))
			{
				Double tempPoints = mapOfTempPoints.get(pId) + pdblCurrentEntityConversionPoints ;
				mapOfTempPoints.put(pId,tempPoints);
				MapOfEntityConversionPoints.put(pOwnerId,mapOfTempPoints);
			}
			else
			{
				mapOfTempPoints.put(pId,pdblCurrentEntityConversionPoints);
				MapOfEntityConversionPoints.put(pOwnerId,mapOfTempPoints);
			}
		}
		else
		{
			mapOfTempPoints.put(pId,pdblCurrentEntityConversionPoints);
			MapOfEntityConversionPoints.put(pOwnerId,mapOfTempPoints);
		}
	}
	
	
		public void getEntityNonReferralPointsPerWS()
		{
			/*for(Account a: [select Id,Name,OwnerId,Amount_Received__c,PersonLeadSource,NDC_Payout__c,Cheque_date__c from Account 
	                              where OwnerId IN :idList.keySet()
	                              and Cheque_Received_Date__c >= :formateDate(this.startDate)  
	                              and Cheque_Received_Date__c <= :formateDate(this.endDate)    
	                              and Amount_Received__c != null
	                              and PersonLeadSource != null ])*/
	                              
	       /*==========Changes done to use new object ChequeDetails==============*/
	       for(Cheque_Details__c a: [select Account__r.Id,Account__r.OwnerId,Amount_Received__c,Account__r.PersonLeadSource,Account__r.NDC_Payout__c,Cheque_Date__c from Cheque_Details__c 
	                              where Account__r.OwnerId IN :idList.keySet()
	                              and Cheque_Date__c >= :formateDate(this.startDate)  
	                              and Cheque_Date__c <= :formateDate(this.endDate)    
	                              and Amount_Received__c != null
	                              and Account__r.PersonLeadSource != null])
	        /*==============================================================*/
			{
				if(!entityNonReferralPointsPerWS.isEmpty() && entityNonReferralPointsPerWS.containsKey(idList.get(a.Account__r.OwnerId)))
				{
					if(a.Account__r.PersonLeadSource.equals(Label.Client_Lead_Referral)){
						Double i = entityNonReferralPointsPerWS.get(idList.get(a.Account__r.OwnerId))+(Double.valueOf(Label.Client_Lead_Referral_Points)*(a.Amount_Received__c/amount));
						Double dblCurrentEntityConversionPoints = (Double.valueOf(Label.Client_Lead_Referral_Points)*(a.Amount_Received__c/amount));
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),i);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
						
						/* Mahesh *
				      	if(mapNonReferalPoints.containsKey(a.OwnerId)){
				      		mapNonReferalPoints.get(a.OwnerId).put(a.Id,dblCurrentEntityConversionPoints);
				      	}
				      	else{
				      		mapNonReferalPointsInner.put(a.Id,dblCurrentEntityConversionPoints);
							mapNonReferalPoints.put(a.OwnerId, mapNonReferalPointsInner);
				      	}*/
					}
				    if(a.Account__r.PersonLeadSource.equals(Label.Client_Referral)){
				   		Double i = entityNonReferralPointsPerWS.get(idList.get(a.Account__r.OwnerId))+(Double.valueOf(Label.Client_Referral_Points)*(a.Amount_Received__c/amount));
				      	entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),i);
				      	Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Client_Referral_Points)*(a.Amount_Received__c/amount);
				      	getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
				      	/* Mahesh *
				      	if(mapNonReferalPoints.containsKey(a.OwnerId)){
				      		mapNonReferalPoints.get(a.OwnerId).put(a.Id,dblCurrentEntityConversionPoints);
				      	}
				      	else{
				      		mapNonReferalPointsInner.put(a.Id,dblCurrentEntityConversionPoints);
							mapNonReferalPoints.put(a.OwnerId, mapNonReferalPointsInner);
				      	}*/
				    }
				    if(a.Account__r.PersonLeadSource.equals(Label.Lead_Referral)){
				        Double i = entityNonReferralPointsPerWS.get(idList.get(a.Account__r.OwnerId))+(Double.valueOf(Label.Lead_Referral_Points)*(a.Amount_Received__c/amount));
				      	entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),i);
				      	Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Lead_Referral_Points)*(a.Amount_Received__c/amount);
				      	getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
				    }
				    if(a.Account__r.PersonLeadSource.equals(Label.BNI)){
				        Double i = entityNonReferralPointsPerWS.get(idList.get(a.Account__r.OwnerId))+(Double.valueOf(Label.BNI_Points)*(a.Amount_Received__c/amount));
				        entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),i);
				        Double dblCurrentEntityConversionPoints = Double.valueOf(Label.BNI_Points)*(a.Amount_Received__c/amount);
				        getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
				    }  
				    if(a.Account__r.PersonLeadSource.equals(Label.NDC)){
				        if(a.Account__r.NDC_Payout__c == null)
				        	a.Account__r.NDC_Payout__c = 0;
				        	
				      	Double i = entityNonReferralPointsPerWS.get(idList.get(a.Account__r.OwnerId))+(Double.valueOf(Label.NDC_Points)*((a.Amount_Received__c - a.Account__r.NDC_Payout__c)/amount));
				      	entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),i);
				      	
				      	Double dblCurrentEntityConversionPoints = Double.valueOf(Label.NDC_Points)*((a.Amount_Received__c - a.Account__r.NDC_Payout__c)/amount);
				      	getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
				    }
					if(a.Account__r.PersonLeadSource.equals(Label.Corp_Comm)){
						Double i = entityNonReferralPointsPerWS.get(idList.get(a.Account__r.OwnerId))+(Double.valueOf(Label.Corp_Comm_Points)*(a.Amount_Received__c/amount));
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),i);
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Corp_Comm_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.Seminar_MKT)){
						Double i = entityNonReferralPointsPerWS.get(idList.get(a.Account__r.OwnerId))+(Double.valueOf(Label.Seminar_MKT_Points)*(a.Amount_Received__c/amount));
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),i);
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Seminar_MKT_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.Seminar_WS))
					{    
						Double i = entityNonReferralPointsPerWS.get(idList.get(a.Account__r.OwnerId))+(Double.valueOf(Label.Seminar_WS_Points)*(a.Amount_Received__c/amount));
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),i);
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Seminar_WS_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.Web)){
						Double i = entityNonReferralPointsPerWS.get(idList.get(a.Account__r.OwnerId))+(Double.valueOf(Label.Web_Points)*(a.Amount_Received__c/amount));
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),i);
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Web_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.Lead_Engines)){
						Double i = entityNonReferralPointsPerWS.get(idList.get(a.Account__r.OwnerId))+(Double.valueOf(Label.Lead_Engines_Points)*(a.Amount_Received__c/amount));
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),i);
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Lead_Engines_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					} 
					if(a.Account__r.PersonLeadSource.equals(Label.Employee_Referral)){
						Double i = entityNonReferralPointsPerWS.get(idList.get(a.Account__r.OwnerId))+(Double.valueOf(Label.Employee_Referral_Points)*(a.Amount_Received__c/amount));
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),i);
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Employee_Referral_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					
					if(a.Account__r.PersonLeadSource.equals(Label.Database_MF)){
						Double i = entityNonReferralPointsPerWS.get(idList.get(a.Account__r.OwnerId))+(Double.valueOf(Label.Database_MF_Points)*(a.Amount_Received__c/amount));
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),i);
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Database_MF_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.Database)){
						Double i = entityNonReferralPointsPerWS.get(idList.get(a.Account__r.OwnerId))+(Double.valueOf(Label.Database_Point)*(a.Amount_Received__c/amount));
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),i);
						Double dblCurrentEntityConversionPoints = (Double.valueOf(Label.Database_Point)*(a.Amount_Received__c/amount));
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
				}            
                else 
				{
					if(a.Account__r.PersonLeadSource.equals(Label.Client_Lead_Referral))
					{
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),(Double.valueOf(Label.Client_Lead_Referral_Points)*(a.Amount_Received__c/amount)));
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Client_Lead_Referral_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.Client_Referral))
					{
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId), (Double.valueOf(Label.Client_Referral_Points)*(a.Amount_Received__c/amount)));
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Client_Referral_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.Lead_Referral))
					{
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),Double.valueOf(Label.Lead_Referral_Points)*(a.Amount_Received__c/amount));
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Lead_Referral_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.BNI))
					{
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),(Double.valueOf(Label.BNI_Points)*(a.Amount_Received__c/amount)));
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.BNI_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.NDC)){
						if(a.Account__r.NDC_Payout__c == null){
							a.Account__r.NDC_Payout__c = 0;
						}
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),(Double.valueOf(Label.NDC_Points)*((a.Amount_Received__c - a.Account__r.NDC_Payout__c)/amount)));
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.NDC_Points)*((a.Amount_Received__c - a.Account__r.NDC_Payout__c)/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.Corp_Comm))
					{
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),(Double.valueOf(Label.Corp_Comm_Points)*(a.Amount_Received__c/amount)));
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Corp_Comm_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.Seminar_MKT))
					{
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),(Double.valueOf(Label.Seminar_MKT_Points)*(a.Amount_Received__c/amount)));
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Seminar_MKT_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.Seminar_WS))
					{
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),(Double.valueOf(Label.Seminar_WS_Points)*(a.Amount_Received__c/amount)));
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Seminar_WS_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.Web))
					{
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),(Double.valueOf(Label.Web_Points)*(a.Amount_Received__c/amount)));
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Web_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.Lead_Engines))
					{
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),(Double.valueOf(Label.Lead_Engines_Points)*(a.Amount_Received__c/amount)));
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Lead_Engines_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.Employee_Referral))
					{
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),(Double.valueOf(Label.Employee_Referral_Points)*(a.Amount_Received__c/amount)));
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Employee_Referral_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.Database_MF))
					{
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),(Double.valueOf(Label.Database_MF_Points)*(a.Amount_Received__c/amount)));
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Database_MF_Points)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
					if(a.Account__r.PersonLeadSource.equals(Label.Database))
					{
						entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),(Double.valueOf(Label.Database_Point)*(a.Amount_Received__c/amount)));
						Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Database_Point)*(a.Amount_Received__c/amount);
						getCurrentEntityPoints(a.Account__r.Id, a.Account__r.OwnerId, dblCurrentEntityConversionPoints);
					}
				}
			}
			
		/*	for(Account a: [select Id,
                                       OwnerId,Name,
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
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Client_Lead_Referral_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								/*Eternus Solutions
								Author  : Pravin Patil
								Issue Id: FS0138
								Date    : 2/09/2011
								Purpose : Error In Query (Changed Account.Amount_Received_c To Amount_2nd_Installment__c )*/
	/*							if(a.PersonLeadSource.equals(Label.Client_Referral)){                                    
									Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Client_Referral_Points)*(a.Amount_2nd_Installment__c/amount));
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Client_Referral_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								/*Eternus Solutions
								Author  : Pravin Patil  
								Issue Id: FS0138
								Date    : 2/09/2011   
								Purpose : Error In Query (Changed Account.Amount_Received_c To Amount_2nd_Installment__c )*/
	/*							if(a.PersonLeadSource.equals(Label.Lead_Referral)){
									Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Lead_Referral_Points)*(a.Amount_2nd_Installment__c/amount));
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Lead_Referral_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								if(a.PersonLeadSource.equals(Label.BNI)){
									Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.BNI_Points)*(a.Amount_2nd_Installment__c/amount));
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.BNI_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}  
								if(a.PersonLeadSource.equals(Label.NDC)){
									if(a.NDC_Payout__c == null){
										a.NDC_Payout__c = 0;
									}
									Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.NDC_Points)*((a.Amount_2nd_Installment__c-a.NDC_Payout__c)/amount));
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.NDC_Points)*((a.Amount_2nd_Installment__c-a.NDC_Payout__c)/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								if(a.PersonLeadSource.equals(Label.Corp_Comm)){
									Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Corp_Comm_Points)*(a.Amount_2nd_Installment__c/amount));
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Corp_Comm_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								if(a.PersonLeadSource.equals(Label.Seminar_MKT)){
									Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Seminar_MKT_Points)*(a.Amount_2nd_Installment__c/amount));
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Seminar_MKT_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								if(a.PersonLeadSource.equals(Label.Seminar_WS)){
									Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Seminar_WS)*(a.Amount_2nd_Installment__c/amount));
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Seminar_WS)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								if(a.PersonLeadSource.equals(Label.Web)){
									Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Web_Points)*(a.Amount_2nd_Installment__c/amount));
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Web_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								if(a.PersonLeadSource.equals(Label.Lead_Engines)){
									Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Lead_Engines_Points)*(a.Amount_2nd_Installment__c/amount));
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Lead_Engines_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								} 
								if(a.PersonLeadSource.equals(Label.Employee_Referral)){
									Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Employee_Referral_Points)*(a.Amount_2nd_Installment__c/amount));
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Employee_Referral_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								if(a.PersonLeadSource.equals(Label.Database_MF)){
									Double i = entityNonReferralPointsPerWS.get(idList.get(a.OwnerId))+(Double.valueOf(Label.Database_MF_Points)*(a.Amount_2nd_Installment__c/amount));
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),i);
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Database_MF_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}       
						}
						else {
								if(a.PersonLeadSource.equals(Label.Client_Lead_Referral)){
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Client_Lead_Referral_Points)*(a.Amount_2nd_Installment__c/amount)));
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Client_Lead_Referral_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								/*Eternus Solutions
								Author  : Pravin Patil
								Issue Id: FS0138
								Date    : 2/09/2011
								Purpose : Error In Query (Changed Account.Amount_Received_c To Amount_2nd_Installment__c )*/
	/*							if(a.PersonLeadSource.equals(Label.Client_Referral)){
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Client_Referral_Points)*(a.Amount_2nd_Installment__c/amount)));
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Client_Referral_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								/*Eternus Solutions
								Author  : Pravin Patil  
								Issue Id: FS0138
								Date    : 2/09/2011   
								Purpose : Error In Query (Changed Account.Amount_Received_c To Amount_2nd_Installment__c )*/
	/*							if(a.PersonLeadSource.equals(Label.Lead_Referral)){
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Lead_Referral_Points)*(a.Amount_2nd_Installment__c/amount)));
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Lead_Referral_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								if(a.PersonLeadSource.equals(Label.BNI)){
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.BNI_Points)*(a.Amount_2nd_Installment__c/amount)));
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.BNI_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}  
								if(a.PersonLeadSource.equals(Label.NDC)){
									if(a.NDC_Payout__c == null){
										a.NDC_Payout__c = 0;
									}
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.NDC_Points)*((a.Amount_2nd_Installment__c - a.NDC_Payout__c)/amount)));
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.NDC_Points)*((a.Amount_2nd_Installment__c - a.NDC_Payout__c)/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								if(a.PersonLeadSource.equals(Label.Corp_Comm)){
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Corp_Comm_Points)*(a.Amount_2nd_Installment__c/amount)));
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Corp_Comm_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								if(a.PersonLeadSource.equals(Label.Seminar_MKT)){
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Seminar_MKT_Points)*(a.Amount_2nd_Installment__c/amount)));
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Seminar_MKT_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								if(a.PersonLeadSource.equals(Label.Seminar_WS)){
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Seminar_WS_Points)*(a.Amount_2nd_Installment__c/amount)));
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Seminar_WS_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								if(a.PersonLeadSource.equals(Label.Web)){
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Web_Points)*(a.Amount_2nd_Installment__c/amount)));
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Web_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								if(a.PersonLeadSource.equals(Label.Lead_Engines)){
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Lead_Engines_Points)*(a.Amount_2nd_Installment__c/amount)));
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Lead_Engines_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								} 
								if(a.PersonLeadSource.equals(Label.Employee_Referral)){
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Employee_Referral_Points)*(a.Amount_2nd_Installment__c/amount)));
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Employee_Referral_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
								if(a.PersonLeadSource.equals(Label.Database_MF)){
									entityNonReferralPointsPerWS.put(idList.get(a.OwnerId),(Double.valueOf(Label.Database_MF_Points)*(a.Amount_2nd_Installment__c/amount)));
									Double dblCurrentEntityConversionPoints = Double.valueOf(Label.Database_MF_Points)*(a.Amount_2nd_Installment__c/amount);
									getCurrentEntityPoints(a.Id, a.OwnerId, dblCurrentEntityConversionPoints);
								}
						}
			}
	*/}
	
		/* 
		Comments ====Dipak Nikam
		Create a custom setting Point Holder which has 2 fields as 
		1. Name 
		2. Points   
		So that your above code will be optimised
		
		Your code should be look like this
		pseudo code: 
		Map<String,PointHolder__c> mapOfPointHolder = PointHolder__c.getAll();  
		
		for(query on Checkdetails same as above)
		{
			PointHolder__c objPointHolder;
			if(mapOfPointHolder.containsKey(a.PersonLeadSource))
			    objPointHolder = mapOfPointHolder.get(a.PersonLeadSource);
			
				if(!entityNonReferralPointsPerWS.isEmpty() && entityNonReferralPointsPerWS.containsKey(idList.get(a.Account__r.OwnerId)))
				{
					entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),(Double.valueOf(objPointHolder.Points__c)*(a.Amount_Received__c/amount)));
					Double dblCurrentEntityConversionPoints = Double.valueOf(objPointHolder.Points__c)*(a.Amount_Received__c/amount);
					getCurrentEntityPoints(a.Account__r.Id,a.Account__r.OwnerId,dblCurrentEntityConversionPoints);
				}
				else
				{
					entityNonReferralPointsPerWS.put(idList.get(a.Account__r.OwnerId),(Double.valueOf(objPointHolder.Points__c)*(a.Amount_Received__c/amount)));
					Double dblCurrentEntityConversionPoints = Double.valueOf(objPointHolder.Points__c)*(a.Amount_Received__c/amount);
					getCurrentEntityPoints(a.Account__r.Id,a.Account__r.OwnerId,dblCurrentEntityConversionPoints);
				}
		}*/
		
		public void fillMapRenewalPoints(String pId, String pOwnerId, Double pdblChildRenewalPoints)
		{
			Map<ID,Double> mapOfTempPoints = new Map<ID,Double>();
			if(!MapOfEntityRenewalPoints.isEmpty() && MapOfEntityRenewalPoints.containsKey(pOwnerId))
			{
				mapOfTempPoints = MapOfEntityRenewalPoints.get(pOwnerId);
				if(!mapOfTempPoints.isEmpty() && mapOfTempPoints.ContainsKey(pId))
				{
					Double tempPoints = mapOfTempPoints.get(pId) + pdblChildRenewalPoints ;
					mapOfTempPoints.put(pId,tempPoints);
					MapOfEntityRenewalPoints.put(pOwnerId,mapOfTempPoints);
				}
				else
				{
					mapOfTempPoints.put(pId,pdblChildRenewalPoints);
					MapOfEntityRenewalPoints.put(pOwnerId,mapOfTempPoints);
				}
				
			}
			else
			{
				mapOfTempPoints.put(pId,pdblChildRenewalPoints);
				MapOfEntityRenewalPoints.put(pOwnerId,mapOfTempPoints);
			}
		}
	
        /* Calculate Entity Renewal Points and put them in appropriate maps */
        public void getEntityRenewalPointsPerWS()
        {
                 for(Renewal__c a: [select Id,
                                   Entity__r.OwnerId,
                                   Entity__r.Id,Entity__c,
                                   Amount_Received__c
                                   from Renewal__c 
                                   where Entity__r.OwnerId IN :idList.keySet()
                                   and Entity__r.OwnerId NOT IN : setRemoveUId
                                   and Cheque_Received_Date__c >= :formateDate(this.startDate)
                                   and Cheque_Received_Date__c <= :formateDate(this.endDate)
                                   and Amount_Received__c != null])
                 
				{
					 Double dblCurrentEntityRenewalPoints = (Double.valueOf(Label.Entity_Non_Referral_Points)*(a.Amount_Received__c/(Double.valueOf(Label.Entity_Renewal_Fees))));
                  	if(!entityRenewalPointsPerWS.isEmpty() && entityRenewalPointsPerWS.containsKey(idList.get(a.Entity__r.OwnerId)))
                  	{
                        Double i = entityRenewalPointsPerWS.get(idList.get(a.Entity__r.OwnerId))+(Double.valueOf(Label.Entity_Non_Referral_Points)*(a.Amount_Received__c/(Double.valueOf(Label.Entity_Renewal_Fees))));
                        //Double dblCurrentEntityRenewalPoints = (Double.valueOf(Label.Entity_Non_Referral_Points)*(a.Amount_Received__c/(Double.valueOf(Label.Entity_Renewal_Fees))));
                        entityRenewalPointsPerWS.put(idList.get(a.Entity__r.OwnerId),i);
                       	//fillMapRenewalPoints(a.Entity__c,a.Entity__r.OwnerId,dblCurrentEntityRenewalPoints);
                 	 }                               
                  	else
                  	 {
                        entityRenewalPointsPerWS.put(idList.get(a.Entity__r.OwnerId),(Double.valueOf(Label.Entity_Non_Referral_Points)*(a.Amount_Received__c/(Double.valueOf(Label.Entity_Renewal_Fees)))));
                       // Double dblCurrentEntityRenewalPoints = (Double.valueOf(Label.Entity_Non_Referral_Points)*(a.Amount_Received__c/(Double.valueOf(Label.Entity_Renewal_Fees))));
                       // fillMapRenewalPoints(a.Entity__c,a.Entity__r.OwnerId,dblCurrentEntityRenewalPoints);
                 	 }
                  fillMapRenewalPoints(a.Entity__c,a.Entity__r.OwnerId,dblCurrentEntityRenewalPoints);
           	}
        }
        
        ///Life Insurance Points
        public void fillMapOfLifeInsurancePoints(String pId, String pOwnerId, Double lifeInsurancePoints)
        {
        	Map<ID,Double> mapOfTempPoints = new Map<ID,Double>();
			if(!mapOfLIPoints.isEmpty() && mapOfLIPoints.containsKey(pOwnerId))
			{
				mapOfTempPoints = mapOfLIPoints.get(pOwnerId);
				if(!mapOfTempPoints.isEmpty() && mapOfTempPoints.ContainsKey(pId))
				{
					Double tempPoints = mapOfTempPoints.get(pId) + lifeInsurancePoints ;
					mapOfTempPoints.put(pId,tempPoints);
					mapOfLIPoints.put(pOwnerId,mapOfTempPoints);
				}
				else
				{
					mapOfTempPoints.put(pId,lifeInsurancePoints);
					mapOfLIPoints.put(pOwnerId,mapOfTempPoints);
				}
			}
			else
			{
				mapOfTempPoints.put(pId,lifeInsurancePoints);
				mapOfLIPoints.put(pOwnerId,mapOfTempPoints);
			}
		}
        
        ///GeneralInsurance Points
        public void fillMapOfGeneralInsurancePoints(String pId, String pOwnerId, Double generalInsurancePoints)
        {
        	Map<ID,Double> mapOfTempPoints = new Map<ID,Double>();
			if(!mapOfGIPoints.isEmpty() && mapOfGIPoints.containsKey(pOwnerId))
			{
				mapOfTempPoints = mapOfGIPoints.get(pOwnerId);
				if(!mapOfTempPoints.isEmpty() && mapOfTempPoints.ContainsKey(pId))
				{
					Double tempPoints = mapOfTempPoints.get(pId) + generalInsurancePoints ;
					mapOfTempPoints.put(pId,tempPoints);
					mapOfGIPoints.put(pOwnerId,mapOfTempPoints);
				}
				else
				{
					mapOfTempPoints.put(pId,generalInsurancePoints);
					mapOfGIPoints.put(pOwnerId,mapOfTempPoints);
				}
			}
			else
			{
				mapOfTempPoints.put(pId,generalInsurancePoints);
				mapOfGIPoints.put(pOwnerId,mapOfTempPoints);
			}
		}
        
        //SIP Points
        public void fillMapOfSIPPoints(String pId, String pOwnerId, Double pSIPPoints)
        {
        	Map<ID,Double> mapOfTempPoints = new Map<ID,Double>();
			if(!mapOfSIPPoints.isEmpty() && mapOfSIPPoints.containsKey(pOwnerId))
			{
				
				mapOfTempPoints = mapOfSIPPoints.get(pOwnerId);
				if(!mapOfTempPoints.isEmpty() && mapOfTempPoints.ContainsKey(pId))
				{
					Double tempPoints = mapOfTempPoints.get(pId) + pSIPPoints ;
					mapOfTempPoints.put(pId,tempPoints);
					mapOfSIPPoints.put(pOwnerId,mapOfTempPoints);
				}
				else
				{
					mapOfTempPoints.put(pId,pSIPPoints);
					mapOfSIPPoints.put(pOwnerId,mapOfTempPoints);
				}
			}
			else
			{
				mapOfTempPoints.put(pId,pSIPPoints);
				mapOfSIPPoints.put(pOwnerId,mapOfTempPoints);
			}
		}
        
        //Investment Points
        public void fillMapOfInvestmentPoints(String pId, String pOwnerId, Double pInvestmentPoints)
        {
        	Map<ID,Double> mapOfTempPoints = new Map<ID,Double>();
			if(!mapOfInvestmentPoints.isEmpty() && mapOfInvestmentPoints.containsKey(pOwnerId))
			{
				
				mapOfTempPoints = mapOfInvestmentPoints.get(pOwnerId);
				if(!mapOfTempPoints.isEmpty() && mapOfTempPoints.ContainsKey(pId))
				{
					Double tempPoints = mapOfTempPoints.get(pId) + pInvestmentPoints ;
					mapOfTempPoints.put(pId,tempPoints);
					mapOfInvestmentPoints.put(pOwnerId,mapOfTempPoints);
				}
				else
				{
					mapOfTempPoints.put(pId,pInvestmentPoints);
					mapOfInvestmentPoints.put(pOwnerId,mapOfTempPoints);
				}
			}
			else
			{
				mapOfTempPoints.put(pId,pInvestmentPoints);
				mapOfInvestmentPoints.put(pOwnerId,mapOfTempPoints);
			}
		}
        
        //Business Planning Points
        public void fillMapOfBusinessPlanningPoints(String pId, String pOwnerId, Double BusinessPoints)
        {
        	Map<ID,Double> mapOfTempPoints = new Map<ID,Double>();
			if(!mapOfBusinessPlanPoints.isEmpty() && mapOfBusinessPlanPoints.containsKey(pOwnerId))
			{
				
				mapOfTempPoints = mapOfBusinessPlanPoints.get(pOwnerId);
				if(!mapOfTempPoints.isEmpty() && mapOfTempPoints.ContainsKey(pId))
				{
					Double tempPoints = mapOfTempPoints.get(pId) + BusinessPoints ;
					mapOfTempPoints.put(pId,tempPoints);
					mapOfBusinessPlanPoints.put(pOwnerId,mapOfTempPoints);
				}
				else
				{
					mapOfTempPoints.put(pId,BusinessPoints);
					mapOfBusinessPlanPoints.put(pOwnerId,mapOfTempPoints);
				}
			}
			else
			{
				mapOfTempPoints.put(pId,BusinessPoints);
				mapOfBusinessPlanPoints.put(pOwnerId,mapOfTempPoints);
			}
		}
        
        //Real Estate Points
        public void fillMapOfRealEstatePoints(String pId, String pOwnerId, Double RealEstatePoints)
        {
        	Map<ID,Double> mapOfTempPoints = new Map<ID,Double>();
			if(!mapOfRealEstatePoints.isEmpty() && mapOfRealEstatePoints.containsKey(pOwnerId))
			{
				
				mapOfTempPoints = mapOfRealEstatePoints.get(pOwnerId);
				if(!mapOfTempPoints.isEmpty() && mapOfTempPoints.ContainsKey(pId))
				{
					Double tempPoints = mapOfTempPoints.get(pId) + RealEstatePoints ;
					mapOfTempPoints.put(pId,tempPoints);
					mapOfRealEstatePoints.put(pOwnerId,mapOfTempPoints);
				}
				else
				{
					mapOfTempPoints.put(pId,RealEstatePoints);
					mapOfRealEstatePoints.put(pOwnerId,mapOfTempPoints);
				}
			}
			else
			{
				mapOfTempPoints.put(pId,RealEstatePoints);
				mapOfRealEstatePoints.put(pOwnerId,mapOfTempPoints);
			}
		}
        
        //Succession Planning  Points
        public void fillMapOfSuccessionPlanningPoints(String pId, String pOwnerId, Double SuccessionPlannPoints)
        {
        	Map<ID,Double> mapOfTempPoints = new Map<ID,Double>();
			if(!mapOfSuccessionPlanPoints.isEmpty() && mapOfSuccessionPlanPoints.containsKey(pOwnerId))
			{
				
				mapOfTempPoints = mapOfSuccessionPlanPoints.get(pOwnerId);
				if(!mapOfTempPoints.isEmpty() && mapOfTempPoints.ContainsKey(pId))
				{
					Double tempPoints = mapOfTempPoints.get(pId) + SuccessionPlannPoints ;
					mapOfTempPoints.put(pId,tempPoints);
					mapOfSuccessionPlanPoints.put(pOwnerId,mapOfTempPoints);
				}
				else
				{
					mapOfTempPoints.put(pId,SuccessionPlannPoints);
					mapOfSuccessionPlanPoints.put(pOwnerId,mapOfTempPoints);
				}
			}
			else
			{
				mapOfTempPoints.put(pId,SuccessionPlannPoints);
				mapOfSuccessionPlanPoints.put(pOwnerId,mapOfTempPoints);
			}
		}
        
         //Income Tax Planning  Points
        public void fillMapOfIncomeTaxPoints(String pId, String pOwnerId, Double IncomeTaxPoints)
        {
        	Map<ID,Double> mapOfTempPoints = new Map<ID,Double>();
			if(!mapOfIncomeTaxPoints.isEmpty() && mapOfIncomeTaxPoints.containsKey(pOwnerId))
			{
				mapOfTempPoints = mapOfIncomeTaxPoints.get(pOwnerId);
				if(!mapOfTempPoints.isEmpty() && mapOfTempPoints.ContainsKey(pId))
				{
					Double tempPoints = mapOfTempPoints.get(pId) + IncomeTaxPoints ;
					mapOfTempPoints.put(pId,tempPoints);
					mapOfIncomeTaxPoints.put(pOwnerId,mapOfTempPoints);
				}
				else
				{
					mapOfTempPoints.put(pId,IncomeTaxPoints);
					mapOfIncomeTaxPoints.put(pOwnerId,mapOfTempPoints);
				}
			}
			else
			{
				mapOfTempPoints.put(pId,IncomeTaxPoints);
				mapOfIncomeTaxPoints.put(pOwnerId,mapOfTempPoints);
			}
		}
        
         //Income Tax Planning  Points
        public void fillMapOfAccountAndBookPoints(String pId, String pOwnerId, Double AccountBookPoints)
        {
        	Map<ID,Double> mapOfTempPoints = new Map<ID,Double>();
			if(!mapOfAccBookPoints.isEmpty() && mapOfAccBookPoints.containsKey(pOwnerId))
			{
				mapOfTempPoints = mapOfAccBookPoints.get(pOwnerId);
				if(!mapOfTempPoints.isEmpty() && mapOfTempPoints.ContainsKey(pId))
				{
					Double tempPoints = mapOfTempPoints.get(pId) + AccountBookPoints ;
					mapOfTempPoints.put(pId,tempPoints);
					mapOfAccBookPoints.put(pOwnerId,mapOfTempPoints);
				}
				else
				{
					mapOfTempPoints.put(pId,AccountBookPoints);
					mapOfAccBookPoints.put(pOwnerId,mapOfTempPoints);
				}
			}
			else
			{
				mapOfTempPoints.put(pId,AccountBookPoints);
				mapOfAccBookPoints.put(pOwnerId,mapOfTempPoints);
			}
		}
        
        
        public void getExecutionPoints()
		{
			for(Execution_Tracker__c ext: [select Id,Opportunity_Name__c,Entity_Name__r.OwnerId,Entity_Name__c
										   from Execution_Tracker__c
                                           where Entity_Name__r.OwnerId IN :idList.keySet() 
                                           and Completion_Date__c >= :formateDate(this.startDate)
                                           and Completion_Date__c <= :formateDate(this.endDate)])
                {
                	if(ext.Opportunity_Name__c == 'Life Insurance')
                	{
						if(!LIpointsPerWs.isEmpty() && LIpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId)))
						{
							Double i = LIpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_Life_Insurance_Points);
							LIpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
							fillMapOfLifeInsurancePoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_Life_Insurance_Points));
						}
						else
						{
							LIpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_Life_Insurance_Points));
							fillMapOfLifeInsurancePoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_Life_Insurance_Points));
						}
					}
					else if(ext.Opportunity_Name__c == 'General Insurance')
					{
						if(!GIpointsPerWs.isEmpty() && GIpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId)))
						{
							Double i = GIpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_GI_Points);
							GIpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
							fillMapOfGeneralInsurancePoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_GI_Points));
						}
						else
						{
							GIpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_GI_Points));
							fillMapOfGeneralInsurancePoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_GI_Points));
						}
					}
					else if(ext.Opportunity_Name__c == 'SIP')
					{
						if(!SIPpointsPerWs.isEmpty() && SIPpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId)))
						{
							Double i = SIPpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_SIP_Points);
							SIPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
							fillMapOfSIPPoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_SIP_Points));
						}
						else
						{
							SIPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_SIP_Points));
							fillMapOfSIPPoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_SIP_Points));
						}
					} 
					else if(ext.Opportunity_Name__c == 'Investments')
					{
						if(!InvestmentspointsPerWs.isEmpty() && InvestmentspointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId)))
						{
							Double i = InvestmentspointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_Investments_Points);
							InvestmentspointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
							fillMapOfInvestmentPoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_SIP_Points));
						}
						else
						{
							InvestmentspointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_Investments_Points));
							fillMapOfInvestmentPoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_SIP_Points));
						}     
					}
					else if(ext.Opportunity_Name__c == 'Business Planning')
					{
						if(!BPpointsPerWs.isEmpty() && BPpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId)))
						{
							Double i = BPpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_BP_Points);
							BPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
							fillMapOfBusinessPlanningPoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_BP_Points));
						}
						else
						{
							BPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_BP_Points));
							fillMapOfBusinessPlanningPoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_BP_Points));
						}     
					}
					else if(ext.Opportunity_Name__c == 'Real Estate')
					{
						if(!RPpointsPerWs.isEmpty() && RPpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId)))
						{
							Double i = RPpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_RP_Points);
							RPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
							fillMapOfRealEstatePoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_RP_Points));
						}
						else
						{
							RPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_RP_Points));
							fillMapOfRealEstatePoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_RP_Points));
						}
					}
					                                               
					else if(ext.Opportunity_Name__c == 'Succession Planning'){
						if(!EPpointsPerWs.isEmpty() && EPpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId)))
						{
							Double i = EPpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_EP_Points);
							EPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
							fillMapOfSuccessionPlanningPoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_EP_Points));
						}
						else
						{
							EPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_EP_Points));
							fillMapOfSuccessionPlanningPoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_EP_Points));
						}     
					}
					else if(ext.Opportunity_Name__c == 'Income Tax Planning'){
						if(!ITpointsPerWs.isEmpty() && ITpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId)))
						{
							Double i = ITpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_IT_Points);
							ITpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
							fillMapOfIncomeTaxPoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_IT_Points));
						}
						else
						{
							ITpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_IT_Points));
							fillMapOfIncomeTaxPoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_IT_Points));
						}
					}
					else if(ext.Opportunity_Name__c == 'Accounts & Book Keeping')
					{
						if(!ABPpointsPerWs.isEmpty() && BPpointsPerWS.containsKey(idList.get(ext.Entity_Name__r.OwnerId)))
						{
							Double i = ABPpointsPerWs.get(idList.get(ext.Entity_Name__r.OwnerId))+Double.valueOf(Label.Exe_BP_Points);
							ABPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),i);
							fillMapOfAccountAndBookPoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_BP_Points));
						}
						else
						{
							ABPpointsPerWs.put(idList.get(ext.Entity_Name__r.OwnerId),Double.valueOf(Label.Exe_BP_Points));
							fillMapOfAccountAndBookPoints(ext.Entity_Name__c,ext.Entity_Name__r.OwnerId,Double.valueOf(Label.Exe_BP_Points));
						}     
					}
				}
		}
	public void FillMapChildPlanLifeCyclePoints(String pId, String pOwnerId, Double pdblChildPlanLifeCyclePoints)
	{
		Map<ID,Double> mapOfTempPoints = new Map<ID,Double>();
		if(!MapOfPlanLifeCyclePoints.isEmpty() && MapOfPlanLifeCyclePoints.containsKey(pOwnerId))
		{
			mapOfTempPoints = MapOfPlanLifeCyclePoints.get(pOwnerId);
			if(!mapOfTempPoints.isEmpty() && mapOfTempPoints.ContainsKey(pId))
			{
				Double tempPoints = mapOfTempPoints.get(pId) + pdblChildPlanLifeCyclePoints ;
				mapOfTempPoints.put(pId,tempPoints);
				MapOfPlanLifeCyclePoints.put(pOwnerId,mapOfTempPoints);
			}
			else
			{
				mapOfTempPoints.put(pId,pdblChildPlanLifeCyclePoints);
				MapOfPlanLifeCyclePoints.put(pOwnerId,mapOfTempPoints);
			}
		}
		else
		{
			mapOfTempPoints.put(pId,pdblChildPlanLifeCyclePoints);
			MapOfPlanLifeCyclePoints.put(pOwnerId,mapOfTempPoints);
		}
	}
	
	/***********************************/
    public void getPlanLifecyclePointsPerWS()
    {
        /*for(Account act: [select Total_Cycle__c,Name, Plan_Approved_Date__c,
                                         Plan_Lifecycle_Points__c, Amount_Received__c,
                                         Amount_2nd_Installment__c, Execution_Completion_Dates__c,
                                         OwnerId, Id
                                         from Account
                                         where Total_Cycle__c != null
                                         and OwnerId IN :idList.keySet()
                                         and Amount_Received__c != null 
                                         and Plan_Approved_Date__c >= :formateDate(this.startDate)
                                         and Plan_Approved_Date__c <= :formateDate(this.endDate)])*/
                                         
        /*==========Changes done to use new object ChequeDetails==============*/
	    for(Cheque_Details__c act: [select Account__r.Total_Cycle__c,Account__r.Name,Account__r.Plan_Approved_Date__c,Account__r.Plan_Lifecycle_Points__c,
	    							Amount_Received__c,Account__r.Execution_Completion_Dates__c,Account__r.OwnerId,Account__r.Id from Cheque_Details__c 
	                              where Account__r.Total_Cycle__c != null
	                              and Account__r.OwnerId IN :idList.keySet()
	                              and Amount_Received__c != null
	                              and Account__r.Plan_Approved_Date__c >= :formateDate(this.startDate)  
	                              and Account__r.Plan_Approved_Date__c <= :formateDate(this.endDate)])
	    /*==============================================================*/
		{
			Double amountReceived = act.Amount_Received__c;
			/*if(act.Amount_2nd_Installment__c != null)
			{
				amountReceived += act.Amount_2nd_Installment__c;
			}*/
			if(act.Account__r.Plan_Lifecycle_Points__c != null )
			{
				if(!planLifecyclePointsPerWS.isEmpty() && planLifecyclePointsPerWS.containsKey(idList.get(act.Account__r.OwnerId)))
				{
					Double i = planLifecyclePointsPerWS.get(idList.get(act.Account__r.OwnerId))+(act.Account__r.Plan_Lifecycle_Points__c*(amountReceived/amount));
					planLifecyclePointsPerWS.put(idList.get(act.Account__r.OwnerId),i);
					Double pdblChildPlanLifeCyclePoints = act.Account__r.Plan_Lifecycle_Points__c*(amountReceived/amount);
					FillMapChildPlanLifeCyclePoints(act.Account__r.Id, act.Account__r.OwnerId, pdblChildPlanLifeCyclePoints);
				}
				else 
				{
					Double pdblChildPlanLifeCyclePoints = act.Account__r.Plan_Lifecycle_Points__c*(amountReceived/amount);
					planLifecyclePointsPerWS.put(idList.get(act.Account__r.OwnerId),act.Account__r.Plan_Lifecycle_Points__c*(amountReceived/amount));
					FillMapChildPlanLifeCyclePoints(act.Account__r.Id, act.Account__r.OwnerId, pdblChildPlanLifeCyclePoints);
				}
				if(act.Account__r.Total_Cycle__c >0 && act.Account__r.Total_Cycle__c <=30)
				{ 
					if(!planLifecyclePointsHighPerWS.isEmpty() && planLifecyclePointsHighPerWS.containsKey(idList.get(act.Account__r.OwnerId)))
					{
						Integer i = planLifecyclePointsHighPerWS.get(idList.get(act.Account__r.OwnerId))+1;
						planLifecyclePointsHighPerWS.put(idList.get(act.Account__r.OwnerId),i);
					}
					else 
					{
						planLifecyclePointsHighPerWS.put(idList.get(act.Account__r.OwnerId), 1);
					}
				}
				else if(act.Account__r.Total_Cycle__c >=31 && act.Account__r.Total_Cycle__c <= 45)
				{    
					if(!planLifecyclePointsMediumPerWS.isEmpty() && planLifecyclePointsMediumPerWS.containsKey(idList.get(act.Account__r.OwnerId)))
					{
						Integer i = planLifecyclePointsMediumPerWS.get(idList.get(act.Account__r.OwnerId))+1;
						planLifecyclePointsMediumPerWS.put(idList.get(act.Account__r.OwnerId),i);
					}
					else 
					{
						planLifecyclePointsMediumPerWS.put(idList.get(act.Account__r.OwnerId), 1);
					}
				}
				
				else if(act.Account__r.Total_Cycle__c >=46 && act.Account__r.Total_Cycle__c <=60)
				{
					if(!planLifecyclePointsLowPerWS.isEmpty() && planLifecyclePointsLowPerWS.containsKey(idList.get(act.Account__r.OwnerId)))
					{
						Integer i = planLifecyclePointsLowPerWS.get(idList.get(act.Account__r.OwnerId))+1;
						planLifecyclePointsLowPerWS.put(idList.get(act.Account__r.OwnerId),i);
					}
					else
					{
						planLifecyclePointsLowPerWS.put(idList.get(act.Account__r.OwnerId), 1);
					} 
				}
				else if(act.Account__r.Total_Cycle__c >60)
				{
					if(!planLifecyclePointsVeryLowPerWS.isEmpty() && planLifecyclePointsVeryLowPerWS.containsKey(idList.get(act.Account__r.OwnerId)))
					{
						Integer i = planLifecyclePointsVeryLowPerWS.get(idList.get(act.Account__r.OwnerId))+1;
						planLifecyclePointsVeryLowPerWS.put(idList.get(act.Account__r.OwnerId),i);
					}
					else 
					{
						planLifecyclePointsVeryLowPerWS.put(idList.get(act.Account__r.OwnerId), 1);
					}
				}    
			}   
		}
	}

        public Double getMonthsInBetween(){
                return (formateDate(this.startDate).monthsBetween(formateDate(this.endDate))+1);
        }
        public PageReference calculatePoints()
        {
        		pointDetailsList = new List<pointDetailsPerWs>(); 
                childPointDetailsList = new List<childPointDetails>();
                Map<Id, User> mapFPUsers = new Map<Id, User>();
                Date EndDate = formateDate(this.endDate);
                List<User> lstUser = new List<User>();
                set<Id> setUId = new set<Id>();
				
				for(UsersToRemove__c u: UsersToRemove__c.getall().values())
					setUId.add(u.UserId__c);
				lstUser = [select Id, Name, Workstations__c from User where Id IN :idList.keySet() and Id NOT IN :setUId];
                if(!lstUser.isEmpty() && lstUser.size()>0)
                {
                	for(User objUser : lstUser)
	                {
	                	mapFPUsers.put(objUser.Id, objUser);
	                }
                }
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
                getEntityNonReferralPointsPerWS();
                getEntityRenewalPointsPerWS();
                getPlanLifecyclePointsPerWS();
                getExecutionPoints(); /////commented since no execution points needed // Uncommented by Mahesh to get Execution Points
     
             if(!mapFPUsers.isEmpty() && mapFPUsers.size() > 0)
                {
	                for(User s: mapFPUsers.values())
	                {
	                        if(entityRenewalPointsPerWS.get(s.Name) != null){
	                                entityRenewalPointsPerWS.put(s.Name, Math.roundToLong(entityRenewalPointsPerWS.get(s.Name)));
	                        }
	                        if(entityNonReferralPointsPerWS.get(s.Name) != null){
	                                entityNonReferralPointsPerWS.put(s.Name, Math.roundToLong(entityNonReferralPointsPerWS.get(s.Name)));
	                        }
	                        if(planLifecyclePointsPerWS.get(s.Name) != null){
	                                planLifecyclePointsPerWS.put(s.Name, Math.roundToLong(planLifecyclePointsPerWS.get(s.Name)));
	                        }
	                        pointDetailsPerWs pD = new pointDetailsPerWs(s.Name,entityRenewalPointsPerWS.get(s.Name),mapChildEntityConversionPoints.get(s.Id),
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
                }
                for(Id FPid: idList.keySet())
                {
                	childPointDetails objChildPointDetails = new childPointDetails(FPid,MapOfEntityConversionPoints.get(FPid),MapOfEntityRenewalPoints.get(FPid),
                																   MapOfPlanLifeCyclePoints.get(FPid),mapOfLIPoints.get(FPid),mapOfGIPoints.get(FPid),
                																   mapOfSIPPoints.get(FPid),mapOfInvestmentPoints.get(FPid), mapOfBusinessPlanPoints.get(FPid), 
                																   mapOfRealEstatePoints.get(FPid), mapOfSuccessionPlanPoints.get(FPid), mapOfIncomeTaxPoints.get(FPid), 
                																   mapOfAccBookPoints.get(FPid));
                	ChildPointDetailsList.add(objChildPointDetails);
                }
                return null;
        }
        
        public List<pointDetailsPerWs> getPointDetailsList(){
                return this.pointDetailsList;
        }
        public List<ChildPointDetails> getChildDetailsPointList(){
        	return this.ChildPointDetailsList;
        }
        
        //Inner Class New
        public class childPointDetails
        {
        	/* Mahesh */
        		public Id idfinacialPlanner{get;set;}
                public Map<ID,Double> ChildEntityConversionPoints{get; set;}//Mahesh
		        public  Map<ID,Double> ChildEntityRenewalPoints {get;set;}//Mahesh
		        public Map<ID,Double> ChildPlanLifeCyclePoints {get;set;}//Mahesh
		        public Map<ID,Double>  ChildLIPoints {get;set;}//Mahesh
		        public Map<ID,Double>  ChildGIPoints {get;set;}//Mahesh
		        public Map<ID,Double> ChildSIPPoints {get;set;}//Mahesh
		        public Map<ID,Double>  ChildInvestmentPoints {get;set;}//Mahesh
		        public Map<ID,Double>  ChildBPPoints {get;set;}//Mahesh
		        public Map<ID,Double>  ChildREPoints {get;set;}//Mahesh
		        public Map<ID,Double>  ChildSPPoints {get;set;}//Mahesh
		        public Map<ID,Double>  ChildITPPoints {get;set;}//Mahesh
		        public Map<ID,Double>  ChildABPPoints {get;set;}//Mahesh
		        //Inner class Constructor
		        public childPointDetails(Id FinacialPlannerId ,Map<ID,Double> pChildEntityConversionPoints,  Map<ID,Double> pMapOfEntityRenewalPoints,Map<ID,Double>  pChildPlanLifeCyclePoints,
                                       Map<ID,Double>  pChildLIPoints, Map<ID,Double> pChildGIPoints,Map<ID,Double> pChildSIPPoints, Map<ID,Double>  pChildInvestmentPoints,
                                        Map<ID,Double>  pChildBPPoints, Map<ID,Double> pChildREPoints, Map<ID,Double> pChildSPPoints, Map<ID,Double>  pChildITPPoints, Map<ID,Double> pChildABPPoints)
				{
		        	
		        	this.idfinacialPlanner = FinacialPlannerId;
		        	this.ChildEntityConversionPoints = pChildEntityConversionPoints;
		        	this.ChildEntityRenewalPoints = pMapOfEntityRenewalPoints;
		        	this.ChildPlanLifeCyclePoints = pChildPlanLifeCyclePoints;
		        	this.ChildLIPoints = pChildLIPoints;
		        	this.ChildGIPoints = pChildGIPoints;
		        	this.ChildSIPPoints = pChildSIPPoints;
		        	this.ChildInvestmentPoints = pChildInvestmentPoints;
		        	this.ChildBPPoints = pChildBPPoints;
		        	this.ChildREPoints = pChildREPoints;
		        	this.ChildSPPoints = pChildSPPoints;
		        	this.ChildITPPoints = pChildITPPoints;
		        	this.ChildABPPoints = pChildABPPoints;
		        }
        }
        
        public class pointDetailsPerWs
        {
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
                public List<string> lstChild {set;get;}
                public Double exeABPPoints {get;set;}
                public Integer planLifeCyclePointsHigh {get;set;}
                public Integer planLifeCyclePointsMedium {get;set;}
                public Integer planLifeCyclePointsLow {get;set;}
                public Integer planLifeCyclePointsVeryLow {get;set;}
                //public Integer planLifecycleNoPoints {get;set;}
                
                public Double totalPoints{get;set;}
                public User objUser {get;set;}// added by Shailesh Deshpande on 10th October 2011
                
                public pointDetailsPerWs(String workstaion, Double entityRenewalPoints,List<String> lstChilds,
                                        Double entityNonReferralPoints, Double planLifeCyclePoints, 
                                        Double exeLIPoints, Double exeGIPoints,
                                        Double exeRPPoints, Double exeEPPoints,
                                        Double exeSIPPoints, Double exeITPoints,
                                        Double exeInvestmentsPoints, Double exeBPPoints,
                                        Double exeABPPoints,
                                        Integer planLifeCyclePointsHigh, Integer planLifeCyclePointsMedium,
                                        Integer planLifeCyclePointsLow, Integer planLifeCyclePointsVeryLow){
                        objUser = new User();
                        this.lstChild = lstChilds;
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