/*
  Revision History:
  
    Version     Version Author     Date          Comments
    1.0         Mahesh Hirugade     18/11/2011  This class receives the list of Financial Planners and provides it to ClientPointsCalculator class which returns the calculation 
                           of points as per FPs and their clients. Points of financial planner's are Inserted on Planner_Details__c object and the points 
                           of related clients of FPs are inserted on Related_Entity_Points__c object.
                           
                           The batch is running at 11.00pm every day. It creates one record for one month. If the date finds the same month, the record of 
                           this moth will get updated and it the date finds the new month, new record will be inserted on both objects.
   
   1.1         Dipak Nikam       2/1/2011      Modified the query so that duplication of records can handle.                  
*/
global class BatchPointsCalculator implements Database.Batchable<Sobject> 
{
  global String query;
  private Date startDate{set;get;}
  public  Date dtDate{set;get;}
  private Date endDate{set;get;}
  private Planner_Points__c objPlannerPoints;
  private Related_Entity_Points__c objREPoints;
  private Map <Id, Planner_Points__c> mapPC =  new Map<Id, Planner_Points__c>();
  private List<Planner_Points__c> lstPlannerPoints = new List<Planner_Points__c>();
  private Map<Id, Map<Id, Double>> mapEntityConversionPtPerFP = new Map<Id, Map<Id, Double>>();
  private Map<Id, Double> mapClientPoints = new Map<Id, Double>();
  private Map<Id, List<Related_Entity_Points__c>> mapRelatedEntityPoints = new Map<Id, List<Related_Entity_Points__c>>();
  private set<Id> setUId = new set<Id>();
  public set<string> setParentId = new set<string>();
  public BatchPointsCalculator()
  {
    dtDate = System.today();
  }
  global Database.Querylocator start(Database.BatchableContext BC)
  {
    return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext BC, List<User> scope)
  {
    startDate = dtDate.toStartOfMonth();
    endDate = dtDate;
    
    List<Related_Entity_Points__c> lstUpdateRelatedEntityPoints = new List<Related_Entity_Points__c>(); 
    List<ClientPointsCalculator.pointDetailsPerWs> lstpsDetailClass = new List<ClientPointsCalculator.pointDetailsPerWs>();
    List<ClientPointsCalculator.childPointDetails> lstChildPointDetailClass = new List<ClientPointsCalculator.childPointDetails>();
    Map<Id, String> mapOfNameandUser = new Map<Id, String>();
  
    if(scope != null && scope.size()> 0)
    {
      Integer removeUserListSize = UsersToRemove__c.getall().values().size();
      for(User objUser: scope)
      {
        Integer removeCount = 0;
        for(UsersToRemove__c u: UsersToRemove__c.getall().values())
        {
          if(u.Id != objUser.Id)
            removeCount++;
        }
        if(removeCount == removeUserListSize)
          mapOfNameandUser.put(objUser.Id, objUser.Name);
      }
    }
  
    List<Planner_Points__c> lstExistingPlannerPoints = new List<Planner_Points__c>();
    lstExistingPlannerPoints = [select Planner_Name__c, Entity_Renewal_Points__c, Entity_Conversion_Points__c, Plan_Completion_Points__c, 
                                        Life_Insurance_Points__c, General_Insurance_Points__c, SIP_Points__c, Investment_Points__c, 
                                        Business_Planning_Points__c, Real_Estate_Points__c, Succession_Planning_Points__c, 
                                        Income_Tax_Planning_Points__c, Accounts_and_Book_Keeping__c, PlanLifeCycle_30Days__c, 
                                        PlanLifeCycle_45Days__c, PlanLifeCycle_60Days__c, PlanLifeCycle_GreaterThan_60Days__c, Month__c 
                                     from Planner_Points__c where Month__c = this_Year];//where Month__c = this_month
    
    if(lstExistingPlannerPoints != null && lstExistingPlannerPoints.size()> 0)
    {  
      for(Planner_Points__c objplannerpt: lstExistingPlannerPoints)
      {
        if(objplannerpt.Month__c.month() == startDate.month())
          mapPC.put(objplannerpt.Planner_Name__c, objplannerpt);  
      }
    }
      
      ClientPointsCalculator objPlannersPointCalculator = new ClientPointsCalculator();
    String strStartDate = String.valueOf(startDate.month())+'/'+String.valueOf(startDate.day())+'/'+String.valueOf(startDate.year());
    String strEndDate = String.valueOf(endDate.month())+'/'+String.valueOf(endDate.day())+'/'+String.valueOf(endDate.year());
    objPlannersPointCalculator.startDate = strStartDate;
    objPlannersPointCalculator.endDate = strEndDate;
    objPlannersPointCalculator.idList = mapOfNameandUser;
    objPlannersPointCalculator.calculatePoints();
    lstpsDetailClass = objPlannersPointCalculator.getPointDetailsList();
    lstChildPointDetailClass = objPlannersPointCalculator.getChildDetailsPointList();
    
      if(lstpsDetailClass.size() > 0)
    {
      for(ClientPointsCalculator.pointDetailsPerWs objPsDetail :lstpsDetailClass )
      {
        if(!mapPC.isEmpty() && mapPC.containsKey(objPsDetail.objUser.Id))
        {
          objPlannerPoints = mapPC.get(objPsDetail.objUser.Id);
        }
        else
        {
          objPlannerPoints = new Planner_Points__c();
          objPlannerPoints.Planner_Name__c = objPsDetail.objUser.Id;
        }
        objPlannerPoints.OwnerId = objPsDetail.objUser.Id;
        objPlannerPoints.Entity_Renewal_Points__c = objPsDetail.entityRenewalPoints;
        objPlannerPoints.Entity_Conversion_Points__c = objPsDetail.entityNonReferralPoints;
        objPlannerPoints.Plan_Completion_Points__c = objPsDetail.planLifeCyclePoints;
        
        objPlannerPoints.PlanLifeCycle_30Days__c = objPsDetail.planLifeCyclePointsHigh;
        objPlannerPoints.PlanLifeCycle_45Days__c = objPsDetail.planLifeCyclePointsMedium;
        objPlannerPoints.PlanLifeCycle_60Days__c = objPsDetail.planLifeCyclePointsLow;
        objPlannerPoints.PlanLifeCycle_GreaterThan_60Days__c = objPsDetail.planLifeCyclePointsVeryLow;
        objPlannerPoints.Month__c = startDate;
        
        /* Commented to remove execution points */
        //objPlannerPoints.Life_Insurance_Points__c = objPsDetail.exeLIPoints;
        //objPlannerPoints.General_Insurance_Points__c = objPsDetail.exeGIPoints;
        //objPlannerPoints.SIP_Points__c = objPsDetail.exeSIPPoints;
        //objPlannerPoints.Investment_Points__c = objPsDetail.exeInvestmentsPoints;
        //objPlannerPoints.Business_Planning_Points__c = objPsDetail.exeBPPoints;
        //objPlannerPoints.Real_Estate_Points__c = objPsDetail.exeRPPoints;
        //objPlannerPoints.Succession_Planning_Points__c = objPsDetail.exeEPPoints;
        //objPlannerPoints.Income_Tax_Planning_Points__c = objPsDetail.exeITPoints;
        //objPlannerPoints.Accounts_and_Book_Keeping__c = objPsDetail.exeABPPoints;
        
        lstPlannerPoints.add(objPlannerPoints);
      }
            
      if(lstPlannerPoints.size() > 0)
      {
        
        List<Database.Upsertresult> lstUpsertResult = Database.upsert(lstPlannerPoints,false);
        for(Database.Upsertresult UpsertResult : lstUpsertResult)
        {
          if(UpsertResult.getId() != null)
          {
            setParentId.add(UpsertResult.getId());
          }
        }
          
        Date dtDate = System.today().toStartOfMonth();
        Map<ID,Planner_Points__c>mapOfPlannerpts = new Map<ID,Planner_Points__c>(); 
            
        List<Planner_Points__c> lstPlannerPts = [select Planner_Name__c, Entity_Renewal_Points__c, Entity_Conversion_Points__c, Plan_Completion_Points__c, 
                                Life_Insurance_Points__c, General_Insurance_Points__c, SIP_Points__c, Investment_Points__c, 
                                Business_Planning_Points__c, Real_Estate_Points__c, Succession_Planning_Points__c, 
                                Income_Tax_Planning_Points__c, Accounts_and_Book_Keeping__c, PlanLifeCycle_30Days__c, 
                                PlanLifeCycle_45Days__c, PlanLifeCycle_60Days__c, PlanLifeCycle_GreaterThan_60Days__c, Month__c 
                             from Planner_Points__c where Id IN : setParentId];
        
        if(lstPlannerPts != null && lstPlannerPts.size() > 0)
        {
          for(Planner_Points__c objPlannerPts : lstPlannerPts)
          {
            mapOfPlannerpts.put(objPlannerPts.Planner_Name__c,objPlannerPts);
          }
        }
        
        Map<ID,Related_Entity_Points__c> mapEntityRelatedPoints =new Map<ID,Related_Entity_Points__c>();        
        List<Related_Entity_Points__c> lstRelatedEntityPoints = [Select Id, Planner_Points__c, Total_Points__c, Total_Execution_Points__c,
                                        Succession_Planning_Points__c, SIP_Points__c, Real_Estate_Points__c, 
                                        Plan_Completion_Points__c, Name, Life_Insurance_Points__c, 
                                        Investment_Points__c, Income_Tax_Planning_Points__c, 
                                        General_Insurance_Points__c, Entity_Renewal_Points__c, Entity_Name__c, 
                                        Entity_Conversion_Points__c, Business_Planning_Points__c,
                                        Accounts_and_Book_Keeping__c From Related_Entity_Points__c where Planner_Points__c IN :setParentId ];//where Planner_Points__c IN : mapOfPlannerpts.keySet()
        
        if(lstRelatedEntityPoints.size() > 0)
        {
          for(Related_Entity_Points__c objRelatedPoints : lstRelatedEntityPoints)
          {
            mapEntityRelatedPoints.put(objRelatedPoints.Entity_Name__c,objRelatedPoints);
          }
        }
        
        //List<Related_Entity_Points__c> lstOfRelatedPoints = new List<Related_Entity_Points__c>(); // To update
        
          if(lstChildPointDetailClass != null && lstChildPointDetailClass.size() > 0)
          {
          for(ClientPointsCalculator.childPointDetails objRelatedEntityPoints : lstChildPointDetailClass)
          {
            Planner_Points__c objPts;
            Related_Entity_Points__c objRelatedPoints ;
            if(!mapOfPlannerpts.isEmpty() && mapOfPlannerpts.containsKey(objRelatedEntityPoints.idfinacialPlanner))
            {
              objPts = mapOfPlannerpts.get(objRelatedEntityPoints.idfinacialPlanner);
            }
            // Conversion Points
            Map<ID,Double> MapEntityConversionPoints = objRelatedEntityPoints.ChildEntityConversionPoints;
            
            if(MapEntityConversionPoints != null)
            {
              for(ID idEntity : MapEntityConversionPoints.keySet())
              {
                if(MapEntityConversionPoints.get(idEntity) != null)
                {
                  Double points = MapEntityConversionPoints.get(idEntity);
                  if(!mapEntityRelatedPoints.isEmpty() && mapEntityRelatedPoints.containsKey(idEntity))
                  {
                    objRelatedPoints = mapEntityRelatedPoints.get(idEntity);
                  }
                  else
                  {
                    objRelatedPoints = new Related_Entity_Points__c();
                    objRelatedPoints.Entity_Name__c = idEntity;
                    objRelatedPoints.Planner_Points__c = objPts.Id;
                  }
                  objRelatedPoints.Entity_Conversion_Points__c = points;
                  
                  mapEntityRelatedPoints.put(idEntity,objRelatedPoints);
                }
              }
            }
            // Renewal Points
            Map<ID,Double> mapOfEntityRenewalPoints = objRelatedEntityPoints.ChildEntityRenewalPoints;
            if(mapOfEntityRenewalPoints != null)
            {
              for(ID idEntity : mapOfEntityRenewalPoints.keySet())
              {
                if(mapOfEntityRenewalPoints.get(idEntity) != null)
                {
                  Double renewalPoints = mapOfEntityRenewalPoints.get(idEntity);
                  
                  if(!mapEntityRelatedPoints.isEmpty() && mapEntityRelatedPoints.containsKey(idEntity))
                  {
                    objRelatedPoints = mapEntityRelatedPoints.get(idEntity);
                  }
                  else
                  {
                    objRelatedPoints = new Related_Entity_Points__c();
                    objRelatedPoints.Entity_Name__c = idEntity;
                    objRelatedPoints.Planner_Points__c = objPts.Id;
                  }
                  objRelatedPoints.Entity_Renewal_Points__c = renewalPoints;
                  mapEntityRelatedPoints.put(idEntity,objRelatedPoints);
                }
              }
            }
                            
            //Plan Completion Points
            Map<ID,Double> mapOfLifeCyclePoints = objRelatedEntityPoints.ChildPlanLifeCyclePoints;
            if(mapOfLifeCyclePoints != null)
            {
              for(ID idEntity : mapOfLifeCyclePoints.keySet())
              {
                if(mapOfLifeCyclePoints.get(idEntity) != null)
                {
                  Double planCompletionPoints = mapOfLifeCyclePoints.get(idEntity);
                  if(!mapEntityRelatedPoints.isEmpty() && mapEntityRelatedPoints.containsKey(idEntity))
                  {
                    objRelatedPoints = mapEntityRelatedPoints.get(idEntity);
                  }
                  else
                  {
                    objRelatedPoints = new Related_Entity_Points__c();
                    objRelatedPoints.Entity_Name__c = idEntity;
                    objRelatedPoints.Planner_Points__c = objPts.Id;
                  }
                  objRelatedPoints.Plan_Completion_Points__c = planCompletionPoints;
                  mapEntityRelatedPoints.put(idEntity,objRelatedPoints);
                }
              }
            }
            /*
            // Life Insurance Points
            Map<ID,Double> mapLifeInsurancePoints = objRelatedEntityPoints.ChildLIPoints;
            if(mapLifeInsurancePoints != null)
            {
              for(ID idEntity : mapLifeInsurancePoints.keySet())
              {
                if(mapLifeInsurancePoints.get(idEntity) != null)
                {
                  Double LIPoints = mapLifeInsurancePoints.get(idEntity);
                  if(!mapEntityRelatedPoints.isEmpty() && mapEntityRelatedPoints.containsKey(idEntity))
                  {
                    objRelatedPoints = mapEntityRelatedPoints.get(idEntity);
                  }
                  else
                  {
                    objRelatedPoints = new Related_Entity_Points__c();
                    objRelatedPoints.Entity_Name__c = idEntity;
                    objRelatedPoints.Planner_Points__c = objPts.Id;
                  }
                  objRelatedPoints.Investment_Points__c = LIPoints;
                  mapEntityRelatedPoints.put(idEntity,objRelatedPoints);
                }
              }
            }
            
            // General Insurance Points
            Map<ID,Double>mapGeneralInsurancePoints = objRelatedEntityPoints.ChildGIPoints;
            if(mapGeneralInsurancePoints != null)
            {
              for(ID idEntity : mapGeneralInsurancePoints.keySet())
              {
                if(mapGeneralInsurancePoints.get(idEntity) != null)
                {
                  Double GIPoints = mapGeneralInsurancePoints.get(idEntity);
                  if(!mapEntityRelatedPoints.isEmpty() && mapEntityRelatedPoints.containsKey(idEntity))
                  {
                    objRelatedPoints = mapEntityRelatedPoints.get(idEntity);
                  }
                  else
                  {
                    objRelatedPoints = new Related_Entity_Points__c();
                    objRelatedPoints.Entity_Name__c = idEntity;
                    objRelatedPoints.Planner_Points__c = objPts.Id;
                  }
                  objRelatedPoints.General_Insurance_Points__c = GIPoints;
                  mapEntityRelatedPoints.put(idEntity,objRelatedPoints);
                }
              }
            }
            
            Map<ID,Double>mapSIPPoints = objRelatedEntityPoints.ChildSIPPoints;
            if(mapSIPPoints != null)
            {
              for(ID idEntity : mapSIPPoints.keySet())
              {
                if(mapSIPPoints.get(idEntity) != null)
                {
                  Double SIPPoints = mapSIPPoints.get(idEntity);
                  if(!mapEntityRelatedPoints.isEmpty() && mapEntityRelatedPoints.containsKey(idEntity))
                  {
                    objRelatedPoints = mapEntityRelatedPoints.get(idEntity);
                  }
                  else
                  {
                    objRelatedPoints = new Related_Entity_Points__c();
                    objRelatedPoints.Entity_Name__c = idEntity;
                    objRelatedPoints.Planner_Points__c = objPts.Id;
                  }
                  objRelatedPoints.SIP_Points__c = SIPPoints ;
                  mapEntityRelatedPoints.put(idEntity,objRelatedPoints);
                }
              }
            }
            
            Map<ID,Double>mapInvestmentPoints = objRelatedEntityPoints.ChildInvestmentPoints;
            if(mapInvestmentPoints != null)
            {
              for(ID idEntity : mapInvestmentPoints.keySet())
              {
                if(mapInvestmentPoints.get(idEntity) != null)
                {
                  Double investMentPoints  = mapInvestmentPoints.get(idEntity);
                  if(!mapEntityRelatedPoints.isEmpty() && mapEntityRelatedPoints.containsKey(idEntity))
                  {
                    objRelatedPoints = mapEntityRelatedPoints.get(idEntity);
                  }
                  else
                  {
                    objRelatedPoints = new Related_Entity_Points__c();
                    objRelatedPoints.Entity_Name__c = idEntity;
                    objRelatedPoints.Planner_Points__c = objPts.Id;
                  }
                  objRelatedPoints.Investment_Points__c= investMentPoints ;
                  mapEntityRelatedPoints.put(idEntity,objRelatedPoints);
                }
              }
            }
            
            // Business Planning Points   
            Map<ID,Double>mapBusinessPlanningPoints = objRelatedEntityPoints.ChildBPPoints;
            if(mapBusinessPlanningPoints != null)
            {
              for(ID idEntity : mapBusinessPlanningPoints.keySet())
              {
                if(mapBusinessPlanningPoints.get(idEntity) != null)
                {
                  Double BPPoints  = mapBusinessPlanningPoints.get(idEntity);
                  if(!mapEntityRelatedPoints.isEmpty() && mapEntityRelatedPoints.containsKey(idEntity))
                  {
                    objRelatedPoints = mapEntityRelatedPoints.get(idEntity);
                  }
                  else
                  {
                    objRelatedPoints = new Related_Entity_Points__c();
                    objRelatedPoints.Entity_Name__c = idEntity;
                    objRelatedPoints.Planner_Points__c = objPts.Id;
                  }
                  objRelatedPoints.Business_Planning_Points__c= BPPoints ;
                  mapEntityRelatedPoints.put(idEntity,objRelatedPoints);
                }
              }
            }
            
            // Real Estate Points
            Map<ID,Double>mapREPoints = objRelatedEntityPoints.ChildREPoints;
            if(mapREPoints != null)
            {
              for(ID idEntity : mapREPoints.keySet())
              {
                if(mapREPoints.get(idEntity) != null)
                {
                  Double REPoints  = mapREPoints.get(idEntity);
                  if(!mapEntityRelatedPoints.isEmpty() && mapEntityRelatedPoints.containsKey(idEntity))
                  {
                    objRelatedPoints = mapEntityRelatedPoints.get(idEntity);
                  }
                  else
                  {
                    objRelatedPoints = new Related_Entity_Points__c();
                    objRelatedPoints.Entity_Name__c = idEntity;
                    objRelatedPoints.Planner_Points__c = objPts.Id;
                  }
                  objRelatedPoints.Real_Estate_Points__c= REPoints ;
                  mapEntityRelatedPoints.put(idEntity,objRelatedPoints);
                }
              }
            }
            
            // Succession Planning Points
            Map<ID,Double>mapSuccessionPoints = objRelatedEntityPoints.ChildSPPoints;
            if(mapSuccessionPoints  != null)
            {
              for(ID idEntity : mapSuccessionPoints .keySet())
              {
                if(mapSuccessionPoints .get(idEntity) != null)
                {
                  Double SuccessionPoints  = mapSuccessionPoints .get(idEntity);
                  if(!mapEntityRelatedPoints.isEmpty() && mapEntityRelatedPoints.containsKey(idEntity))
                  {
                    objRelatedPoints = mapEntityRelatedPoints.get(idEntity);
                  }
                  else
                  {
                    objRelatedPoints = new Related_Entity_Points__c();
                    objRelatedPoints.Entity_Name__c = idEntity;
                    objRelatedPoints.Planner_Points__c = objPts.Id;
                  }
                  objRelatedPoints.Real_Estate_Points__c= SuccessionPoints ;
                  mapEntityRelatedPoints.put(idEntity,objRelatedPoints);
                }
              }
            }
            
            // Income Tax Points
            Map<ID,Double>mapIncometax = objRelatedEntityPoints.ChildITPPoints;
            if(mapIncometax  != null)
            {
              for(ID idEntity : mapIncometax .keySet())
              {
                if(mapIncometax .get(idEntity) != null)
                {
                  Double ITPoints  = mapIncometax .get(idEntity);
                  if(!mapEntityRelatedPoints.isEmpty() && mapEntityRelatedPoints.containsKey(idEntity))
                  {
                    objRelatedPoints = mapEntityRelatedPoints.get(idEntity);
                  }
                  else
                  {
                    objRelatedPoints = new Related_Entity_Points__c();
                    objRelatedPoints.Entity_Name__c = idEntity;
                    objRelatedPoints.Planner_Points__c = objPts.Id;
                  }
                  objRelatedPoints.Income_Tax_Planning_Points__c= ITPoints ;
                  mapEntityRelatedPoints.put(idEntity,objRelatedPoints);
                }
              }
            }
            
            // Account and Book Keeping Points
            Map<ID,Double>mapAccountBook = objRelatedEntityPoints.ChildABPPoints;
            if(mapAccountBook  != null)
            {
              for(ID idEntity : mapAccountBook .keySet())
              {
                if(mapAccountBook .get(idEntity) != null)
                {
                  Double ABPoints  = mapAccountBook .get(idEntity);
                  if(!mapEntityRelatedPoints.isEmpty() && mapEntityRelatedPoints.containsKey(idEntity))
                  {
                    objRelatedPoints = mapEntityRelatedPoints.get(idEntity);
                  }
                  else
                  {
                    objRelatedPoints = new Related_Entity_Points__c();
                    objRelatedPoints.Entity_Name__c = idEntity;
                    objRelatedPoints.Planner_Points__c = objPts.Id;
                  }
                  objRelatedPoints.Accounts_and_Book_Keeping__c = ABPoints ;
                  mapEntityRelatedPoints.put(idEntity,objRelatedPoints);
                }
              }
            }
            */
          }
        }
        if(mapEntityRelatedPoints.size() > 0)
        {
          for(ID entityId :mapEntityRelatedPoints.keySet())
          {
            lstUpdateRelatedEntityPoints.add(mapEntityRelatedPoints.get(entityId));
          }
        }
        
        if(lstUpdateRelatedEntityPoints != null &&  lstUpdateRelatedEntityPoints.size() > 0)
        {
          List<Database.Upsertresult> lstUserList = Database.upsert(lstUpdateRelatedEntityPoints,false);
        }
      }
    }
  }
  //EXECUTE
  global void finish(Database.BatchableContext BC)
  {
  	if(!Test.isRunningTest())
  	{
	    AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email
	              FROM AsyncApexJob WHERE Id =:BC.getJobId()];
	    // Send an email to the Apex job's submitter notifying of job completion. 
	    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	    String[] toAddresses = new String[] {'tech@ffreedom.in'};
	    mail.setToAddresses(toAddresses);
	    mail.setSubject('Batch Points Calculator ' + a.Status);
	    mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
	    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  	}
  }
}