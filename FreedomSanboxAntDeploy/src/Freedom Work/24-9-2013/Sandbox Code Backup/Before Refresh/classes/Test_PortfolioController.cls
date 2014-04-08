@isTest
private class Test_PortfolioController {
  
  public static testMethod void testPortal()
  {
  	try
    {
    Test.startTest();
    
    Map<Id, Account> childMap = new Map<Id, Account>();
    List<Account> allEntities = new List<Account>();
    List<Account> updateEntities = new List<Account>();
    
    List<AccountShare> shares = new List<AccountShare>();
    List<Portfolio_Report__c> allPortfolios = new List<Portfolio_Report__c>();
    List<Purchase_Sales_Report__c> allPurchaseSales = new List<Purchase_Sales_Report__c>();
    List<PortfolioController.detailedReportWrapper> detailedReportWrapperList =new List<PortfolioController.detailedReportWrapper>();
    List<PortfolioController.childDetailedReportWrapper> childDetailedReportWrapperList=new List<PortfolioController.childDetailedReportWrapper>();
    List<PortfolioController.summaryReportWrapper>  parentSummaryDataList =new List<PortfolioController.summaryReportWrapper>();
    List<PortfolioController.childSummaryReportWrapper> childSummaryReportWrapperList=new List<PortfolioController.childSummaryReportWrapper> ();
    
    
        Account son = [select Id, Parent_Entity__c from Account where Parent_Entity__c != null and RecordTypeId !=:RecTypes__c.getInstance('General_Business').Record_Type_Value__c LIMIT 1 ];
        Account act = [select Id, PersonContactId from Account where Id =:son.Parent_Entity__c and RecordTypeId !=:RecTypes__c.getInstance('General_Business').Record_Type_Value__c];
      
        datetime t = System.now();
        date d = Date.newInstance(t.year(),t.month(),t.day());
       
      Portfolio_Report__c Parent_Portfolio2 = new Portfolio_Report__c( Entity__c=act.Id,UniqueName__c='UniqueName2',Asset_Class__c='Debt: Floating Rate ',  Scheme_Scrip_Name__c='Kotak Mahindra',Transaction_Type__c='SIP', Current_Value__c=2000,Portfolio_Type__c='MF',Units_Quanitity__c=100,Purchase_Amount__c=200,Folio_Number__c ='2',Absolute_Ret__c=10,Annualized_Ret__c=20,Dividend_Reivestment__c ='Yes',Nav_p__c=5,Gain__c=10,Date__c=d);
      allPortfolios.add(Parent_Portfolio2);
      
      Portfolio_Report__c son_Portfolio2 = new Portfolio_Report__c( Entity__c=son.Id,UniqueName__c='UniqueName4',Asset_Class__c='Debt: Floating Rate ',  Scheme_Scrip_Name__c='HDFC',Transaction_Type__c='NOR', Current_Value__c=2000,Portfolio_Type__c='EQ',Units_Quanitity__c=100,Purchase_Amount__c=200,Folio_Number__c ='4',Absolute_Ret__c=10,Annualized_Ret__c=20,Dividend_Reivestment__c ='Yes',Nav_p__c=5,Gain__c=10,Date__c=d);
      allPortfolios.add(son_Portfolio2);
      
      
      	 insert allPortfolios;
    ID ProfileID = [ Select id from Profile where name = 'Customer Portal Standard - Custom'].id;
    
    List<User> u1 = [select Id from User where contactid = :act.PersonContactId];
    User user;
    if(u1 == null || u1.isEmpty()){
      user = new User( email='test-user@fakeemail.com', contactid = act.PersonContactId, profileid = ProfileID, UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname' );
      insert user; 
    
    }
    else{
      user= u1[0];
    }
    
    
        Purchase_Sales_Report__c parentPS3=new Purchase_Sales_Report__c(Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='HDFC',NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=100, DividendReivestment__c='Yes', Transaction__c='Sales',NAV_Date__c=d,Current_Date__c=d);
      allPurchaseSales.add(parentPS3);
      Purchase_Sales_Report__c parentPS4=new Purchase_Sales_Report__c(Entity__c=act.Id,Unique_Name__c='UniqueName2',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Birla Sun Life',NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=100, DividendReivestment__c='Yes', Transaction__c='Sales',NAV_Date__c=d,Current_Date__c=d);
      allPurchaseSales.add(parentPS4);
      Purchase_Sales_Report__c sonPS1=new Purchase_Sales_Report__c(Entity__c=son.Id,Unique_Name__c='UniqueName3',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Kotak Mahindra',NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=100, DividendReivestment__c='Yes', Transaction__c='Sales',NAV_Date__c=d,Current_Date__c=d);
      allPurchaseSales.add(sonPS1);
      
      Purchase_Sales_Report__c sonPS4=new Purchase_Sales_Report__c(Entity__c=son.Id,Unique_Name__c='UniqueName4',Units__c=10,Absolute_Return__c=10,Type__c='MF',Scheme_Name__c='Kotak Mahindra',NAV__c=10,Folio_Number__c='1',Current_Value__c=1000,Annualized_Return__c=2, Amount__c=100, DividendReivestment__c='Yes', Transaction__c='Sales',NAV_Date__c=d,Current_Date__c=d);
      allPurchaseSales.add(sonPS4);
      
        
      insert   allPurchaseSales;
    
    
    AccountShare thisShare1 = new AccountShare(UserOrGroupId=user.Id,AccountId=son.Id,AccountAccessLevel='Read',OpportunityAccessLevel = 'Edit');
    shares.add(thisShare1);
    
    insert shares;
    
    System.runas(user){
      PortfolioController controller=new PortfolioController();
      User user2=controller.getCurrentUserDetails();
        detailedReportWrapperList=controller.getAllDataList();
        childDetailedReportWrapperList=controller.getAllChildDetailedRecords();
        parentSummaryDataList= controller.getSummaryDataList();
        childSummaryReportWrapperList=controller.getAllChildSummaryRecords();
        Planner_Details__c plan =controller.getPlannerDescription();
        String welcomeMessage=controller.getWelcomeMessage();
    }
    
      Test.stopTest();
       }
      catch(Exception e )
      {
      	system.debug('******error*****'+e);	
      }
  } 

}