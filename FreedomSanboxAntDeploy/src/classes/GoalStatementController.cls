public class GoalStatementController {
        private Account act;
        Map<Goal__c,Portfolio_Report__c[]> goalPortfolioMap =new Map<Goal__c,Portfolio_Report__c[]>();
        Map<Id,GoalIAULIPAssociation__c[]> goalUlipMap =new Map<Id,GoalIAULIPAssociation__c[]>();
        private Planner_Details__c  detail;
       
        List<GoalIAULIPAssociation__c> GoalULIPAssociationList = new  List<GoalIAULIPAssociation__c>();
        List<Portfolio_Report__c> portfolioRecords = new  List<Portfolio_Report__c>();
        List<Goal__c> goalList = new  List<Goal__c>();
        List<goalPortfolioReportWrapper> goalPortfolioReportWrapperList = new List<goalPortfolioReportWrapper>();
        
        Map<Id, Goal__c> goalMap = new Map<Id, Goal__c>();
        Map<Id, Portfolio_Report__c> portfolioMap = new Map<Id, Portfolio_Report__c>();
        Map<GoalIAULIPAssociation__c,Id> ulipPortfolioMap = new Map<GoalIAULIPAssociation__c,Id>();
        Map<Goal__c,Portfolio_Report__c> summaryMap =new Map<Goal__c,Portfolio_Report__c>();
        
        public User getCurrentUserDetails(){
           return [select Id, AccountId, Email from User where Id=:UserInfo.getUserId()];
     }
        
      public GoalStatementController(){
          getAccount();
          getGoals();
          getGoalIAULIPAssociationMap();
         // getUlipPortfolioMap();  
          getPortfolioRecords();
          getGoalPortfolioMap();
     }
     
     public  Account getAccount(){
        if(act==null){
                String accId=System.currentPageReference().getParameters().get('Id');
                List<Account>  parentEntities;
                if(accId == null){
                    parentEntities = [select Id,
                                       Name,
                                       BillingStreet,
                                       BillingCity,
                                       BillingState,
                                       OwnerId,
                                       PersonEmail from Account
                                       where Id =:getCurrentUserDetails().AccountId];
                }   
                else{
                        parentEntities = [select Id,
                                       Name,
                                       BillingStreet,
                                       BillingCity,
                                       BillingState,
                                       OwnerId,
                                       PersonEmail from Account
                                       where Id =:accId];
                }                    
           if(parentEntities != null && !parentEntities.isEmpty()){
                 act= parentEntities[0];
           }
        }  
        return act;
     }
     
     public Map<Id, Goal__c> getGoals(){
        if(goalMap.isEmpty() && goalList.size() == 0)
        {
                if(getAccount() != null && getAccount().Id != null)
                {
	                goalList = [select Id, 
	                           Goal_Type__c,
	                           Description__c,
	                           Name 
	                           from Goal__c 
	                           where Entity__c = :getAccount().Id];
                }
                for(Goal__c goal:goalList){
                        goalMap.put(goal.Id,goal);
                }
        }
        return goalMap;
     }
     
     public void getGoalIAULIPAssociationMap(){
      
        for(GoalIAULIPAssociation__c GoalIAULIPAssociation:[select Id,
                                                           Portfolio_Report__c,
                                                           Allocation__c,
                                                           Goal__c  
                                                           from GoalIAULIPAssociation__c 
                                                           where Goal__c IN: goalMap.keySet() AND Allocation__c != 0]){
                if(!goalUlipMap.isEmpty() && goalUlipMap.containsKey(GoalIAULIPAssociation.Goal__c)){
                        goalUlipMap.get(GoalIAULIPAssociation.Goal__c).add(GoalIAULIPAssociation);
                }
                else{
                        List<GoalIAULIPAssociation__c> ulipList=new List<GoalIAULIPAssociation__c>();
                        ulipList.add(GoalIAULIPAssociation);
                        goalUlipMap.put(GoalIAULIPAssociation.Goal__c,ulipList);
                }
                ulipPortfolioMap.put(GoalIAULIPAssociation,GoalIAULIPAssociation.Portfolio_Report__c);  
        }
     }
   
     public Map<Id, Portfolio_Report__c> getPortfolioRecords(){
        if(!ulipPortfolioMap.isEmpty()){
                                                                   
                for(Portfolio_Report__c portfolio:[select Id,
                                                  Name, 
                                                  Scheme_Scrip_Name__c,
                                                  Transaction_Type__c,
                                                  Current_Value__c,
                                                  Portfolio_Type__c,
                                                  Units_Quanitity__c,
                                                  Purchase_Amount__c,
                                                  Folio_Number__c ,
                                                  Absolute_Ret__c,
                                                  Annualized_Ret__c,
                                                  Dividend_Reivestment__c,
                                                  Nav_p__c,
                                                  Product__c,
                                                  Date__c,
                                                  Gain__c From Portfolio_Report__c where Id IN:ulipPortfolioMap.values()]){
                        portfolioMap.put(portfolio.Id,portfolio);
                }                              
        }
        
        return portfolioMap;
     }
     
     public void getGoalPortfolioMap(){
        if(!goalMap.isEmpty() && !goalUlipMap.isEmpty() && !portfolioMap.isEmpty() && goalPortfolioMap.isEmpty()){
                for(Id goalId:goalUlipMap.keySet()){
                        Goal__c goal= goalMap.get(goalId);
                        List<Portfolio_Report__c> portList=new List<Portfolio_Report__c>();
                        Double summaryProduct = 0.0;
                        Portfolio_Report__c portfolioSummary =new Portfolio_Report__c(Entity__c=act.Id,Current_Value__c=0,Purchase_Amount__c=0,Nav_p__c=0,Units_Quanitity__c=0,Gain__c=0,Absolute_Ret__c=0,Annualized_Ret__c=0);
                      
                        for(GoalIAULIPAssociation__c gUAssociation:goalUlipMap.get(goal.Id)){
                                Double cagr = 0.0;
                                Double product = 0.0;
                                double allocated_Amount = gUAssociation.Allocation__c;
                                Portfolio_Report__c portfolio_Report=portfolioMap.get(gUAssociation.Portfolio_Report__c);
                               Portfolio_Report__c pr = new Portfolio_Report__c(Entity__c=act.Id);
                               	
                               	if(portfolio_Report.Scheme_Scrip_Name__c!=null){
                               		pr.Scheme_Scrip_Name__c=portfolio_Report.Scheme_Scrip_Name__c;
                               	}						
                               	if(portfolio_Report.Transaction_Type__c!=null){
                               		pr.Transaction_Type__c=portfolio_Report.Transaction_Type__c;
                               	}							
                               	if(portfolio_Report.Date__c !=null){
                               		pr.Date__c=portfolio_Report.Date__c;
                               	}
                               	if(portfolio_Report.Absolute_Ret__c!=null){
                               		pr.Absolute_Ret__c=portfolio_Report.Absolute_Ret__c;
                               	}
                               	if(portfolio_Report.Folio_Number__c!=null){
                               		pr.Folio_Number__c=portfolio_Report.Folio_Number__c;
                               	}
                               	if(portfolio_Report.Portfolio_Type__c!=null){
                               		pr.Portfolio_Type__c=portfolio_Report.Portfolio_Type__c;
                               	}							
                                if(portfolio_Report.Units_Quanitity__c != null){
                                	pr.Units_Quanitity__c=portfolio_Report.Units_Quanitity__c*allocated_Amount/100;
                                	portfolioSummary.Units_Quanitity__c +=pr.Units_Quanitity__c;
                                }
                                if(portfolio_Report.Current_Value__c != null){
                                      pr.Current_Value__c=portfolio_Report.Current_Value__c*allocated_Amount/100;
                                      portfolioSummary.Current_Value__c += pr.Current_Value__c;
                                }
                                if(portfolio_Report.Purchase_Amount__c != null){
                                      pr.Purchase_Amount__c=portfolio_Report.Purchase_Amount__c*allocated_Amount/100;
                                      portfolioSummary.Purchase_Amount__c +=pr.Purchase_Amount__c;
                                }
                                if(portfolio_Report.Gain__c != null){
                                	pr.Gain__c=portfolio_Report.Gain__c*allocated_Amount/100;
                                	portfolioSummary.Gain__c += pr.Gain__c;
                                }
                                if(portfolio_Report.Nav_p__c !=null){
                                	pr.Nav_p__c = portfolio_Report.Nav_p__c;
                               		portfolioSummary.Nav_p__c += pr.Nav_p__c;
                                }
                                if(portfolio_Report.Product__c !=null){
                               		summaryProduct += portfolio_Report.Product__c*allocated_Amount/100;
                                }
                                if(portfolio_Report.Purchase_Amount__c!=null && portfolio_Report.Product__c!=null && portfolio_Report.Absolute_Ret__c!=null){
	                                if(portfolio_Report.Purchase_Amount__c!=0){
	                                	Double avgDays = portfolio_Report.Product__c/portfolio_Report.Purchase_Amount__c;
	                                	Double d = (1+portfolio_Report.Absolute_Ret__c/100);
	                                	if(avgDays!=0){
	                                		cagr=(Math.pow(d,(365/avgDays))-1)*100;
	                                	}
	                                } 
                                }
                                pr.Annualized_Ret__c = cagr;
                                portList.add(pr);
                               
                        }
                        
                        if(portfolioSummary.Purchase_Amount__c !=null && portfolioSummary.Purchase_Amount__c != 0){
                                portfolioSummary.Absolute_Ret__c = ((portfolioSummary.Current_Value__c - portfolioSummary.Purchase_Amount__c)/portfolioSummary.Purchase_Amount__c * 100);
                              
                                }
                		if(portfolioSummary.Purchase_Amount__c!=null && portfolioSummary.Absolute_Ret__c!=null){
                			if(portfolioSummary.Purchase_Amount__c!=0){
	                			Double avgDays = summaryProduct/portfolioSummary.Purchase_Amount__c;
	                			Double d = (1+portfolioSummary.Absolute_Ret__c/100);
	                			if(avgDays!=0){
	                				portfolioSummary.Annualized_Ret__c = (Math.pow(d,(365/avgDays))-1)*100;
	                			} 
                			}
                		}
                        goalPortfolioMap.put(goal,portList);
                        summaryMap.put(goal,portfolioSummary);
                }
        }
        
     } 
     
     public List<goalPortfolioReportWrapper> getGoalPortfolioReportWrapper(){
        for(Goal__c goal:goalPortfolioMap.keySet()){
                goalPortfolioReportWrapper GPr = new goalPortfolioReportWrapper(goal,goalPortfolioMap.get(goal),summaryMap.get(goal));
                goalPortfolioReportWrapperList.add(GPr);
        }
        return goalPortfolioReportWrapperList;
     }
     
     public Planner_Details__c getPlannerDescription(){
         if(detail==null){
                List<Planner_Details__c> planDetail = new List<Planner_Details__c>();
                if(getAccount() != null && getAccount().OwnerId != null)
                {
	                 planDetail= [select Name,
                                         Email__c,
                                         MobilePhone__c,
                                         Description__c 
                                         from Planner_Details__c  
                                         where OwnerId = :getAccount().OwnerId LIMIT 1];
            
            	
            	}
            if(planDetail != null && !planDetail.isEmpty() ){
                detail = planDetail[0];
            }
         } 
         return detail;
    }
     
     public class goalPortfolioReportWrapper {
        public Goal__c goal {get; set;}
        public List<Portfolio_Report__c> PortfolioReportList {get; set;}
        public Portfolio_Report__c summary {get; set;}
        public goalPortfolioReportWrapper(Goal__c goal,List<Portfolio_Report__c> PortfolioReportList,Portfolio_Report__c summary){
        this.goal=goal;
        this.PortfolioReportList=PortfolioReportList;
        this.summary=summary;
        }
    } 
     
}