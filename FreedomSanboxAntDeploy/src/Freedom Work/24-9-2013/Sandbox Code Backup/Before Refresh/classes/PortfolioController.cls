public class PortfolioController{
        
     private Planner_Details__c  detail;
     private Account act;
     public Map<Id, Account> childEntitiesList = new Map<Id, Account>();
     List<Purchase_Sales_Report__c> purchase_Sales_List = new List<Purchase_Sales_Report__c>();
     List<Portfolio_Report__c> portfolio_List = new List<Portfolio_Report__c>();
     List<Portfolio_Report__c> Summary_Portfolio_List = new List<Portfolio_Report__c>();
     List<Portfolio_Report__c> child_portfolio_List =new List<Portfolio_Report__c>();
         
     Map<String, Purchase_Sales_Report__c[]> map_Purchase_Sales = new    Map<String, Purchase_Sales_Report__c[]>();
     Map<String, Purchase_Sales_Report__c[]> child_map_Purchase_Sales = new    Map<String, Purchase_Sales_Report__c[]>();
     
     Map<String, Portfolio_Report__c> map_portfolio = new    Map<String, Portfolio_Report__c>();
     Map<Account, Portfolio_Report__c[]> map_Entity_portfolio = new    Map<Account, Portfolio_Report__c[]>();
     Map<String, Portfolio_Report__c[]> map_Summary = new    Map<String, Portfolio_Report__c[]>();
     Map<String, Portfolio_Report__c[]> child_map_Summary = new    Map<String, Portfolio_Report__c[]>();
     Map<Portfolio_Report__c, String> portfolio_AssetClass = new    Map<Portfolio_Report__c, String>();
      
     List<detailedReportWrapper> allDataList=new List<detailedReportWrapper>();
     List<summaryReportWrapper> SummaryDataList=new List<summaryReportWrapper>(); 
     List<childDetailedReportWrapper> childDetailedReportWrapperList=new List<childDetailedReportWrapper>();
     List<childSummaryReportWrapper> childSummaryReportWrapperList=new List<childSummaryReportWrapper>();
     detailedReportWrapper wrapper_detail;
     summaryReportWrapper wrapper_Summary;
    
     public PortfolioController(){
           getAccount();
            getPurchaseSalesReports();
            getPortfolioReport();
            getChildEntities();
            getChildPortfolioReport();
            getChildPurchaseSalesReports();
     }
    
     public User getCurrentUserDetails(){
       User user=[select ID,Email,AccountId,Name from User where Id=:UserInfo.getUserId()];
           system.debug('UserId='+ user.Name);
          // return [select ID,Email,AccountId from User where Id=:UserInfo.getUserId()];
        return user;
           
     }
              
    
    public  Account getAccount(){
        if(act==null){
                String accId=System.currentPageReference().getParameters().get('Id');
                List<Account>  parentEntities;
            if(accId != null){
                parentEntities = [select Id,
                               Name,
                               FirstName,
                               BillingStreet,
                               OwnerId,
                               BillingCity,
                               BillingState,
                               PersonEmail from Account
                               where Id =:accId];
                   
            }
            else{
                parentEntities = [select Id,
                               Name,
                               FirstName,
                               BillingStreet,
                               OwnerId,
                               BillingCity,
                               BillingState,
                               PersonEmail from Account
                               where Id =:getCurrentUserDetails().AccountId];
            }
                  //System.debug('ParentName='+ parentEntities[0].Name);
                  //System.debug('parentSize='+parentEntities.size());                                     
                if(parentEntities != null){
                     act= parentEntities[0];
                }        
        }  

        return act;
                   
     }
           
    public String getWelcomeMessage() {
         String display;
         Datetime cDT = System.now();
                 Integer hour=cDT.hour();
                 if(hour>16){
                        display='Good Evening';
                 }      
                 else if(hour>=12 && hour<=16){
                        display='Good Afternoon';
                 }
                 else if(hour<12){
                        display='Good Morning';
                 }
                 return display;
    }
    public Map<Id,Account> getChildEntities() {
        if(childEntitiesList.isEmpty() && getAccount() != null)
        {
            for(Account a: [select Id,
                                   Relationship_to_Entity__pc,
                                   Name 
                                   from Account 
                                   where Parent_Entity__c = :getAccount().Id]){
                                     
                childEntitiesList.put(a.Id, a);  
            }                  
             
        }
       System.debug('childList='+childEntitiesList.size());
        return childEntitiesList;
    }
  
    public void getChildPurchaseSalesReports(){
        if(child_map_Purchase_Sales.isEmpty()&& !childEntitiesList.isEmpty()){
           for (Purchase_Sales_Report__c psr : [Select   Units__c,
                                                Absolute_Return__c,
                                                Type__c, 
                                                Scheme_Name__c, 
                                                Net_Gain__c,
                                                NAV__c,
                                                NAV_Date__c,
                                                Folio_Number__c, 
                                                Current_Value__c,
                                                Annualized_Return__c,
                                                Amount__c,
                                                Current_Date__c ,
                                                DividendReivestment__c,
                                                Transaction__c,
                                                Unique_Name__c
                                                From Purchase_Sales_Report__c 
                                                where Entity__c IN :childEntitiesList.keySet()]){
                if(child_map_Purchase_Sales.containsKey(psr.Unique_Name__c) ){
                        child_map_Purchase_Sales.get(psr.Unique_Name__c).add(psr);
                }
                else{
                        List<Purchase_Sales_Report__c> psList=new List<Purchase_Sales_Report__c>();
                        psList.add(psr);
                        child_map_Purchase_Sales.put(psr.Unique_Name__c,psList);
                }       
                            
            }
                System.debug('Purchase Map'+child_map_Purchase_Sales);
        }                                                          
    }                    
  
    public void getPurchaseSalesReports(){
        if(map_Purchase_Sales.isEmpty()){
           for (Purchase_Sales_Report__c psr : [Select   Units__c,
                                                Absolute_Return__c,
                                                Type__c, 
                                                Scheme_Name__c, 
                                                Net_Gain__c,
                                                NAV__c,
                                                Current_Date__c ,
                                                Folio_Number__c, 
                                                Current_Value__c,
                                                NAV_Date__c,
                                                Annualized_Return__c,
                                                Amount__c,
                                                DividendReivestment__c,
                                                Transaction__c,
                                                Unique_Name__c
                                                From Purchase_Sales_Report__c 
                                                where Entity__c = :act.Id]){
                if(map_Purchase_Sales.containsKey(psr.Unique_Name__c) ){
                        map_Purchase_Sales.get(psr.Unique_Name__c).add(psr);
                }
                else{
                            List<Purchase_Sales_Report__c> psList=new List<Purchase_Sales_Report__c>();
                            psList.add(psr);
                            map_Purchase_Sales.put(psr.Unique_Name__c,psList);
                 }       
                        
             }
        }                                                          
    }                                                 
    public void getPortfolioReport(){      
       if(map_portfolio.isEmpty()){
           for(Portfolio_Report__c pr: [Select Gain__c, 
                                        Units_Quanitity__c,
                                        Scheme_Scrip_Name__c, 
                                        Purchase_Amount__c, 
                                        Portfolio_Type__c, 
                                        Folio_Number__c, 
                                        Current_Value__c,
                                        Absolute_Ret__c,
                                        Annualized_Ret__c, 
                                        UniqueName__c,
                                        Transaction_Type__c,
                                        Current_Price__c,
                                        Nav_p__c,
                                        Asset_Class__c,
                                        Date__c,
                                        STP_Switch__c,
                                        Dividend__c, 
                                        Dividend_Reivestment__c,
                                        Dividend_Reinvested__c,
                                        Entity__c
                                        From Portfolio_Report__c 
                                        where Entity__c = :getAccount().Id]){
                                                                    
                 map_portfolio.put(pr.UniqueName__c,pr);
                 
                 if(map_Summary.containsKey(pr.Asset_Class__c) ){
                    map_Summary.get(pr.Asset_Class__c).add(pr);
                }
                else{
                List<Portfolio_Report__c> portList=new List<Portfolio_Report__c>();
                portList.add(pr);
                map_Summary.put(pr.Asset_Class__c,portList);
                }    
           }                                                                                
        }
    }
        
    public void getChildPortfolioReport(){
    	Map<string,Portfolio_Report__c> MapAddedPortFolio= new Map<String,Portfolio_Report__c>();//Added by mahesh to resolve an issue of Duplicating child records on report
        if(map_Entity_portfolio.isEmpty()&& !childEntitiesList.isEmpty()){
            for(Portfolio_Report__c ps: [Select Gain__c, 
                                        Units_Quanitity__c,
                                        Scheme_Scrip_Name__c, 
                                        Purchase_Amount__c, 
                                        Portfolio_Type__c, 
                                        Folio_Number__c, 
                                        Current_Value__c,
                                        Current_Price__c,
                                        Absolute_Ret__c,
                                        Annualized_Ret__c, 
                                        UniqueName__c,
                                        Transaction_Type__c,
                                        Nav_p__c,
                                        Asset_Class__c,
                                        Date__c,
                                        STP_Switch__c,
                                        Dividend__c, 
                                        Dividend_Reivestment__c,
                                        Dividend_Reinvested__c,
                                        Entity__c
                                        From Portfolio_Report__c 
                                        where Entity__c IN :childEntitiesList.keySet()]){
                           if(!map_Entity_portfolio.isEmpty() && map_Entity_portfolio.containsKey(childEntitiesList.get(ps.Entity__c)))
                           {
	                           	if(!MapAddedPortFolio.containsKey(ps.Asset_Class__c))
								{	
									MapAddedPortFolio.put(ps.Asset_Class__c,ps);
									map_Entity_portfolio.get(childEntitiesList.get(ps.Entity__c)).add(ps);
								}
                           }
                           else
                           {
                                List<Portfolio_Report__c> portfolioList = new List<Portfolio_Report__c>();
                                MapAddedPortFolio.put(ps.Asset_Class__c,ps);//
                                portfolioList.add(ps);
                                map_Entity_portfolio.put(childEntitiesList.get(ps.Entity__c),portfolioList);
                           }
                           
                           if(child_map_Summary.containsKey(ps.Asset_Class__c) ){
                                child_map_Summary.get(ps.Asset_Class__c).add(ps);
                           }
                           else{
                           List<Portfolio_Report__c> portList=new List<Portfolio_Report__c>();
                           portList.add(ps);
                           child_map_Summary.put(ps.Asset_Class__c,portList);
                   }   
                                                                                       
              }
                                                     
        }     
                                                      
    }
         
    public List<detailedReportWrapper> getAllDataList(){
        if(allDataList.isEmpty()&& !map_portfolio.isEmpty()&& !map_Purchase_Sales.isEmpty()){
                for(Portfolio_Report__c portfolio:map_portfolio.values()){
                      String navDate;
                        purchase_Sales_List= map_Purchase_Sales.get(portfolio.UniqueName__c);
                        date var= portfolio.Date__c;
                        if(var != null){
                          navDate= (var.day().format() + '/' + var.month().format() + '/' + var.year().format().replace(',', ''));
                        }
                        wrapper_detail = new detailedReportWrapper(portfolio.Scheme_Scrip_Name__c,portfolio.Folio_Number__c,purchase_Sales_List,portfolio,navDate);
                        allDataList.add(wrapper_detail);
                }
        }
        return allDataList;
     }
                
     public List<childDetailedReportWrapper> getAllChildDetailedRecords() {
          for(Account e: map_Entity_portfolio.keySet()){
                    List<detailedReportWrapper> detailReportWrapperList= new List<detailedReportWrapper >();
                    if(map_Entity_portfolio.containsKey(e)){
                      for (Portfolio_Report__c p: map_Entity_portfolio.get(e)){
                            String navDate;
                              Purchase_Sales_Report__c[] ps = child_map_Purchase_Sales.get(p.UniqueName__c);
                              date var= p.Date__c;
                              if(var != null){
                                 navDate= (var.day().format() + '/' + var.month().format() + '/' + var.year().format().replace(',', ''));
                              }
                              detailedReportWrapper dL = new detailedReportWrapper (p.Scheme_Scrip_Name__c, p.Folio_Number__c,ps,p,navDate);
                              detailReportWrapperList.add(dl);
                      }
                      childDetailedReportWrapper cl = new childDetailedReportWrapper (e, detailReportWrapperList);
                      childDetailedReportWrapperList.add(cl);   
                    }  
           }
                return childDetailedReportWrapperList;
    }              
          
    public List<childSummaryReportWrapper> getAllChildSummaryRecords() {
         for(Account e: map_Entity_portfolio.keySet()){
                List<summaryReportWrapper> summaryList=new List<summaryReportWrapper>();
                if(map_Entity_portfolio.containsKey(e)){
                  for (Portfolio_Report__c p: map_Entity_portfolio.get(e)){
                          summaryReportWrapper summaryWrapper=new summaryReportWrapper(p.Asset_Class__c,child_map_Summary.get(p.Asset_Class__c));
                          summaryList.add(summaryWrapper);
                  }
                  childSummaryReportWrapper csrw=new childSummaryReportWrapper(e,summaryList);
                  childSummaryReportWrapperList.add(csrw);
                }
         }
        return childSummaryReportWrapperList;
     }
     
     public List<summaryReportWrapper> getSummaryDataList(){
        if(SummaryDataList.isEmpty()&& !map_Summary.isEmpty()){
            for(String assetClass:map_Summary.keySet()){
                    Summary_Portfolio_List= map_Summary.get(assetClass);
                    wrapper_Summary = new summaryReportWrapper(assetClass,Summary_Portfolio_List );
                    SummaryDataList.add(wrapper_Summary);
            }
        }
        return SummaryDataList;
     }   
      
    public Planner_Details__c getPlannerDescription(){
         if(detail==null){
                List<Planner_Details__c> planDetail= [select Name,
                                                    
                                                     Email__c,
                                                     MobilePhone__c,
                                                     Description__c 
                                                     from Planner_Details__c  
                                                     where OwnerId = :getAccount().OwnerId LIMIT 1];
            if(planDetail != null && !planDetail.isEmpty() ){
                detail = planDetail[0];
            }
         } 
         return detail;
    }
       
    public class detailedReportWrapper{
        public List<Purchase_Sales_Report__c> purchaseSalesList {get; set;}
        public  Portfolio_Report__c portfolioReport {get;set;}
        public String scheme_Name{get;set;}
        public String folio_Number{get;set;}
        public String current_Date{get;set;}
        public detailedReportWrapper(String scheme_Name, String folio_Number, List<Purchase_Sales_Report__c> Purchase_SalesList, Portfolio_Report__c portfolio_Report,String current_Date){
                 this.current_Date = current_Date;
                 this.scheme_Name=scheme_Name;
                 this.folio_Number=folio_Number;
                 purchaseSalesList = Purchase_SalesList;
                 portfolioReport = portfolio_Report;
        }
    }
  
    public class summaryReportWrapper{
        public List<Portfolio_Report__c> portfolioList {get; set;}
        public String asset_Class{get;set;}
        public summaryReportWrapper(String asset_Class, List<Portfolio_Report__c> portfolio_List){
             this.asset_Class=asset_Class;
             portfolioList = portfolio_List;
         }
    }
 
    public class childDetailedReportWrapper{
        public Account childEntity {get; set;}
        public List<detailedReportWrapper> DetailedReportWrapperList {get; set;}
        public childDetailedReportWrapper(Account childEntity,List<detailedReportWrapper> DetailedReportWrapperList){
                 this.childEntity=childEntity;
                 this.DetailedReportWrapperList=DetailedReportWrapperList;
       }
    }
    public class childSummaryReportWrapper {
        public Account childEntity {get; set;}
        public List<summaryReportWrapper> summaryReportWrapperList {get; set;}
        public childSummaryReportWrapper(Account childEntity,List<summaryReportWrapper> summaryReportWrapperList){
           this.childEntity=childEntity;
           this.summaryReportWrapperList=summaryReportWrapperList;
        }
    } 
}