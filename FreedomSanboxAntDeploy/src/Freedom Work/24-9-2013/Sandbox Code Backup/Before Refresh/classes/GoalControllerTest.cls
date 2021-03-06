/*
  Revision History:
  Version     Version Author     Date        Comments
    1.0         --                --        Initial Draft
    2.0      Manasi Ranade     21/06/2011  Issue id: F0057 :
                          1. Test class was throwing 'System.NullPointerException: Argument 1 cannot be null ' 
                              exception for totalAmount parameter.
                            2. So added querrystring parameter 'totalAmount' below with its value as '1234' 
                               for further calculation in testData() function.  
   2.0      Manasi Ranade     24/08/2011  Issue id: FS0129 :
                          Change in function :GoalControllerTest
                          Commented startTest from start of the function because it was crossing Governer Limits.
                        And added it after goalTestCon.singleYearGoal.
  3.0      Prajakta Sanap     19/04/2013  Created TestData_Ffreedom which contains all the test data for this test class.                      
*/
@isTest
private class GoalControllerTest 
{
  static GoalController goalTestCon;
  static Account acc;
  static GoalOutputController goalOutCon;
  static GoalComponentController goalCompCon;
  static GoalSummaryController goalSummary;
  static NewGoalService objNewGoalService;
  static GoalMappingBean objGoalBean;
  static  Goal__c gol;
  
  @isTest(seeAlldata=true) 
  public static void testData()
  {
    TestData_Ffreedom testData = new TestData_Ffreedom();
        acc = testData.initializeAccount();
        acc.PAN_ID__pc = 'ABCDF1234M'; 
      upsert acc;
      system.assertNotEquals(null,acc);
         
    Entity_Global_Assumption__c ega = testData.initialize_GlobalAssumptions(acc);
    upsert ega;
      system.assertNotEquals(null,ega.id);
         
      List<Goal_Profile__c> lstGoalProfile = testData.initialize_lstGoalProfile(acc);
      Database.insert(lstGoalProfile);
        
      List<Asset__c> lstAsset = testData.initialize_lstAsset(acc);
      Database.insert(lstAsset);
        
      Goal_Profile__c goalProfile2 = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
      insert goalProfile2;  
      gol = testData.initialize_Goal(acc, 'Marriage',goalProfile2);
      insert gol;
      system.assertNotEquals(null,gol.id);
      
      Asset__c asset = testData.initialize_Asset(acc,'EPF',AssetRecTypes__c.getInstance ('Retirement Accounts').RecordTypeId__c,'To be grown till maturity and continue saving');  
      insert asset;
      Asset__c asset1 = testData.initialize_Asset(acc,'PPF',AssetRecTypes__c.getInstance ('Govt. Saving Schemes').RecordTypeId__c,'To be grown till maturity and continue saving');
      insert asset1;
       
      List<GoalAssetAssociation__c> lstGoalAssetAssociation = new List<GoalAssetAssociation__c>();
      
      GoalAssetAssociation__c gasset1 = testData.intialize_GoalAssetAssociation(asset,gol);
      lstGoalAssetAssociation.add(gasset1);
      GoalAssetAssociation__c gasset2 = testData.intialize_GoalAssetAssociation(asset1,gol);
      lstGoalAssetAssociation.add(gasset2);
      Database.insert(lstGoalAssetAssociation);
       
      Insurance__c  insurance = testData.initialize_Insurance(acc);
      insert insurance;
      system.assertNotEquals(null,insurance.id);
      GoalInsuranceAssociation__c gasset3 = testData.initialize_GoalIA(insurance,gol);
      insert gasset3; 
      system.assertNotEquals(null,gasset3.id);
        
      GoalSIPAmount__c goalsip = testData.initialize_GoalSIPAmount(gol);
      upsert goalsip;
      system.assertNotEquals(null,goalsip.id);
        
      Apexpages.currentPage().getParameters().put('entityId',acc.id);
      ApexPages.currentPage().getParameters().put('goalId',gol.id);    
         /** Eternus Solutions       **/
       /** Author  : Manasi Ranade **/
       /** Issue Id: F0057        **/
       /** Date    : 21/06/2011    **/
       /** Purpose : 1. Test class was throwing 'System.NullPointerException: Argument 1 cannot be null ' 
                 exception for totalAmount parameter.
                2. So added querrystring parameter 'totalAmount' below with its value as '1234' for further calculation.
       /****************************************************/       
      ApexPages.currentPage().getParameters().put('totalAmount','1234');
      objGoalBean = new GoalMappingBean(gol.Id,2013,2060,2020,2013);
      goalTestCon=new GoalController();
        // boolean singleYearGoal=goalTestCon.singleYearGoal;
      goalMappingBean.GoalAssetMappingBean currentGoalAsset=goalTestCon.currentGoalAsset;
        //FS0196
      ApexPages.currentPage().getParameters().put('dblEquitySIP','12');
      ApexPages.currentPage().getParameters().put('dblGoldSIP','13');
      ApexPages.currentPage().getParameters().put('dblDebtSIP','14');
      ApexPages.currentPage().getParameters().put('dblTotalSIP','15');
          
      goalOutCon = new GoalOutputController();
      objNewGoalService = new NewGoalService();
      goalCompCon = new GoalComponentController();
     // goalSummary=new GoalSummaryController();
     
     
     //(integer Name, double equity,double gold,double debt) 
     GoalMappingBean.ChartDataItem objChart = new GoalMappingBean.ChartDataItem(5,4,3,1);
     objGoalBean.ClearSipBeanList(2035,gol.Id,2013);
     
     GoalMappingBean.GoalDetailBean detailBean1 = new GoalMappingBean.GoalDetailBean();
     objGoalBean.populateGoalDetailBeanList(2012,2020,5000,4000,true,detailBean1);
     
     GoalMappingBean.GoalFinancialDataBean objGoal = new GoalMappingBean.GoalFinancialDataBean(); 
     objGoal.financialYear = 2013;
     objGoal.futureValue = 5000;
     objGoal.futureValueActual = 4000;
     objGoal.goalPV = 2000;
     objGoal.goalPVActual = 2000;
     objGoal.pmt = 200;
     objGoal.pmtActual = 2000;
     objGoal.presentValue = 4000;
     objGoal.presentValueActual = 4000;
     
     //objGoalBean.populatePresentFutureValueAndSIPForLiquidate(2013,2020,objGoal,true);
     //objGoalBean.getIncrementFactor();
  }
  
  @isTest(seeAlldata=true)     
  public static void testData1()
  {
      TestData_Ffreedom testData = new TestData_Ffreedom();
        acc = testData.initializeAccount(); 
      upsert acc;
      system.assertNotEquals(null,acc);
         
      List<Goal_Profile__c> lstGoalProfile = testData.initialize_lstGoalProfile(acc);
      Database.insert(lstGoalProfile);
             
      List<Asset__c> lstAsset = new List<Asset__c>(); 
        
      Asset__c asset3 = testData.initialize_Asset(acc,null,AssetRecTypes__c.getInstance ('Govt. Saving Schemes').RecordTypeId__c,'Liquidate (Sell)');
      lstAsset.add(asset3);
      Asset__c asset4 = testData.initialize_Asset(acc,'PPF',AssetRecTypes__c.getInstance ('Govt. Saving Schemes').RecordTypeId__c,'Hold');
      lstAsset.add(asset4);
      Asset__c asset5 = testData.initialize_Asset(acc,null,AssetRecTypes__c.getInstance ('Govt. Saving Schemes').RecordTypeId__c,'Sell');
      lstAsset.add(asset5);
      Asset__c asset6 = testData.initialize_Asset(acc,null,AssetRecTypes__c.getInstance ('Govt. Saving Schemes').RecordTypeId__c,'Liquidate (Align to goal)');
      lstAsset.add(asset6);
      Database.insert(lstAsset);
      
      Goal_Profile__c goalProfile2 = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
      insert goalProfile2;  
      gol = testData.initialize_Goal(acc, 'Retirement',goalProfile2);
      insert gol;
      system.assertNotEquals(null,gol.id);
        
      List<GoalAssetAssociation__c> lstGoalAssetAssociation = new List<GoalAssetAssociation__c>();
        
      GoalAssetAssociation__c gasset2 = testData.intialize_GoalAssetAssociation(asset3,gol);
      lstGoalAssetAssociation.add(gasset2);
      GoalAssetAssociation__c gasset3 = testData.intialize_GoalAssetAssociation(asset4,gol); 
      lstGoalAssetAssociation.add(gasset3);
      GoalAssetAssociation__c gasset4 = testData.intialize_GoalAssetAssociation(asset5,gol);
      lstGoalAssetAssociation.add(gasset4);
      GoalAssetAssociation__c gasset5 = testData.intialize_GoalAssetAssociation(asset6,gol);
      lstGoalAssetAssociation.add(gasset5);
      Database.insert(lstGoalAssetAssociation);
       
      Apexpages.currentPage().getParameters().put('entityId',acc.id);
      ApexPages.currentPage().getParameters().put('goalId',gol.id);    
      goalTestCon=new GoalController(); 
      goalMappingBean.GoalAssetMappingBean currentGoalAsset=goalTestCon.currentGoalAsset;
  }
   
  @isTest(seeAlldata=true)     
  public static void GoalControllerTest()
  {
      //
      /** Eternus Solutions       **/
    /** Author  : Manasi Ranade **/
    /** Issue Id: FS0129        **/
    /** Date    : 24/08/2011   **/
    /** Purpose : Commented startTest from here because it was crossing Governer Limits.
            And added it after goalTestCon.singleYearGoal.
            
    /****************************************************/
    testData();
      
      boolean singleYearGoal = goalTestCon.singleYearGoal;
      Test.startTest();
      List<SelectOption> savingTypeList = goalTestCon.savingTypeList;
      test.stopTest();
      goalTestCon.customized();
      goalTestCon.save();
      goalTestCon.cancel();
      goalTestCon.output();
      goalTestCon.getSipStartYear();
      
     
  }
  
  @isTest(seeAlldata=true) 
  public static void GoalComponentTest(){
      Test.startTest();
      testData();
      goalCompCon.objGoalMappingBean=goalTestCon.goalMappingBean;
      boolean singleYearGoal=goalCompCon.singleYearGoal;
      double futureValueActual=goalCompCon.futureValueActual;
      goalCompCon.output();
      
      test.stopTest();
  }
  
  @isTest(seeAlldata=true)     
  public static void GoalControllerTestService()
  {
      
      TestData_Ffreedom testData = new TestData_Ffreedom();
        acc = testData.initializeAccount();
        acc.PAN_ID__pc = 'ABDDF1234M'; 
        acc.Plan_Generation_Date__c = System.today();
      insert acc;
      system.assertNotEquals(null,acc);
      
      Test.startTest();
      
      Apexpages.currentPage().getParameters().put('entityId',acc.id);
      objNewGoalService = new NewGoalService();
      objNewGoalService.getTotalExpenses(acc.Id);
      Test.stopTest();
     
  }
  
  
  @isTest(seeAlldata=true) 
  public static void GoalComponentTest1()
  {
      
      TestData_Ffreedom testData = new TestData_Ffreedom();
    User partnerUser = testData.initBusinessUser();           
      
      acc = testData.initBusinessAccount(partnerUser);
    insert acc;
    acc.Related_To__c = 'Business Partner';
    update acc;
    
    Entity_Global_Assumption__c ega = testData.initialize_GlobalAssumptions(acc);
      insert ega;
         
      List<Goal_Profile__c> lstGoalProfile = testData.initialize_lstGoalProfile(acc);
      Database.insert(lstGoalProfile);
         
        
      List<Asset__c> lstAsset = testData.initialize_lstAsset(acc);
      Database.insert(lstAsset);
        
        
      Goal_Profile__c goalProfile2 = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
      insert goalProfile2;  
      gol = testData.initialize_Goal(acc, 'Marriage',goalProfile2);
      insert gol;
      system.assertNotEquals(null,gol.id);
      
    Asset__c asset = testData.initialize_Asset(acc, 'EPF', AssetRecTypes__c.getInstance ('Retirement Accounts').RecordTypeId__c,
                           'To be grown till maturity and continue saving');
      insert asset;

    Asset__c asset1 = testData.initialize_Asset(acc, 'PPF', AssetRecTypes__c.getInstance ('Govt. Saving Schemes').RecordTypeId__c,
                           'To be grown till maturity and continue saving');
      insert asset1;        

        List<GoalAssetAssociation__c> lstGoalAssetAssociation = new List<GoalAssetAssociation__c>();
      GoalAssetAssociation__c gasset1 =  testData.intialize_GoalAssetAssociation(asset,gol);
      lstGoalAssetAssociation.add(gasset1);
      GoalAssetAssociation__c gasset2 =  testData.intialize_GoalAssetAssociation(asset1,gol);
      lstGoalAssetAssociation.add(gasset2);
      Database.insert(lstGoalAssetAssociation);
       
      
      Insurance__c  insurance = testData.initialize_Insurance(acc);
      insert insurance;
      system.assertNotEquals(null,insurance.id);
      GoalInsuranceAssociation__c gasset3 = testData.initialize_GoalIA(insurance, gol);
      insert gasset3;
      system.assertNotEquals(null,gasset3.id);
      
      GoalSIPAmount__c goalsip = testData.initialize_GoalSIPAmount(gol);
      upsert goalsip;
      system.assertNotEquals(null,goalsip.id);
      Apexpages.currentPage().getParameters().put('entityId',acc.id);
      ApexPages.currentPage().getParameters().put('goalId',gol.id);    
         /** Eternus Solutions       **/
       /** Author  : Manasi Ranade **/
       /** Issue Id: F0057        **/
       /** Date    : 21/06/2011    **/
       /** Purpose : 1. Test class was throwing 'System.NullPointerException: Argument 1 cannot be null ' 
                 exception for totalAmount parameter.
                2. So added querrystring parameter 'totalAmount' below with its value as '1234' for further calculation.
       /****************************************************/       
      ApexPages.currentPage().getParameters().put('totalAmount','1234');
      goalTestCon=new GoalController();
        // boolean singleYearGoal=goalTestCon.singleYearGoal;
      goalMappingBean.GoalAssetMappingBean currentGoalAsset=goalTestCon.currentGoalAsset;
        //FS0196
      ApexPages.currentPage().getParameters().put('dblEquitySIP','12');
      ApexPages.currentPage().getParameters().put('dblGoldSIP','13');
      ApexPages.currentPage().getParameters().put('dblDebtSIP','14');
      ApexPages.currentPage().getParameters().put('dblTotalSIP','15');
       
       Test.startTest();   
      //goalOutCon=new GoalOutputController();
      goalCompCon=new GoalComponentController();
     // goalSummary=new GoalSummaryController();
      
      
      goalCompCon.objGoalMappingBean=goalTestCon.goalMappingBean;
      boolean singleYearGoal=goalCompCon.singleYearGoal;
      double futureValueActual=goalCompCon.futureValueActual;
      goalCompCon.output();
      
      test.stopTest();
  }
  
  @isTest(seeAlldata=true) 
  public static void GoalComponentTest11()
  {
      
      TestData_Ffreedom testData = new TestData_Ffreedom();    
    User partnerUser = testData.initBusinessUser();           
      
      acc = testData.initBusinessAccount(partnerUser);
    insert acc;
    acc.Related_To__c = 'Business Partner';
    update acc;
    
    Entity_Global_Assumption__c ega = testData.initialize_GlobalAssumptions(acc);
      insert ega;
         
      List<Goal_Profile__c> lstGoalProfile = testData.initialize_lstGoalProfile(acc);
      Database.insert(lstGoalProfile);
         
        
      List<Asset__c> lstAsset = testData.initialize_lstAsset(acc);
      Database.insert(lstAsset);
        
        
      Goal_Profile__c goalProfile2 = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
      insert goalProfile2;  
      gol = testData.initialize_Goal(acc, 'Marriage',goalProfile2);
      insert gol;
      system.assertNotEquals(null,gol.id);
      
    Asset__c asset = testData.initialize_Asset(acc, 'EPF', AssetRecTypes__c.getInstance ('Retirement Accounts').RecordTypeId__c,
                           'To be grown till maturity and continue saving');
      insert asset;

    Asset__c asset1 = testData.initialize_Asset(acc, 'PPF', AssetRecTypes__c.getInstance ('Govt. Saving Schemes').RecordTypeId__c,
                           'To be grown till maturity and continue saving');
      insert asset1;        

        List<GoalAssetAssociation__c> lstGoalAssetAssociation = new List<GoalAssetAssociation__c>();
      GoalAssetAssociation__c gasset1 =  testData.intialize_GoalAssetAssociation(asset,gol);
      lstGoalAssetAssociation.add(gasset1);
      GoalAssetAssociation__c gasset2 =  testData.intialize_GoalAssetAssociation(asset1,gol);
      lstGoalAssetAssociation.add(gasset2);
      Database.insert(lstGoalAssetAssociation);
       
      
      Insurance__c  insurance = testData.initialize_Insurance(acc);
      insert insurance;
      system.assertNotEquals(null,insurance.id);
      GoalInsuranceAssociation__c gasset3 = testData.initialize_GoalIA(insurance, gol);
      insert gasset3;
      system.assertNotEquals(null,gasset3.id);
      
      GoalSIPAmount__c goalsip = testData.initialize_GoalSIPAmount(gol);
      upsert goalsip;
      system.assertNotEquals(null,goalsip.id);
      Apexpages.currentPage().getParameters().put('entityId',acc.id);
      ApexPages.currentPage().getParameters().put('goalId',gol.id);    
         /** Eternus Solutions       **/
       /** Author  : Manasi Ranade **/
       /** Issue Id: F0057        **/
       /** Date    : 21/06/2011    **/
       /** Purpose : 1. Test class was throwing 'System.NullPointerException: Argument 1 cannot be null ' 
                 exception for totalAmount parameter.
                2. So added querrystring parameter 'totalAmount' below with its value as '1234' for further calculation.
       /****************************************************/       
      ApexPages.currentPage().getParameters().put('totalAmount','1234');
      goalTestCon=new GoalController();
        // boolean singleYearGoal=goalTestCon.singleYearGoal;
      goalMappingBean.GoalAssetMappingBean currentGoalAsset=goalTestCon.currentGoalAsset;
        //FS0196
      ApexPages.currentPage().getParameters().put('dblEquitySIP','12');
      ApexPages.currentPage().getParameters().put('dblGoldSIP','13');
      ApexPages.currentPage().getParameters().put('dblDebtSIP','14');
      ApexPages.currentPage().getParameters().put('dblTotalSIP','15');
       
       Test.startTest();   
      //goalOutCon=new GoalOutputController();
      goalCompCon=new GoalComponentController();
      goalSummary=new GoalSummaryController();
      
      
      goalCompCon.objGoalMappingBean=goalTestCon.goalMappingBean;
      boolean singleYearGoal=goalCompCon.singleYearGoal;
      double futureValueActual=goalCompCon.futureValueActual;
      goalCompCon.output();
      
      test.stopTest();
  }
  
  @isTest(seeAlldata=true) 
  public static void GoalComponentTest2()
  {
     
    TestData_Ffreedom testData = new TestData_Ffreedom(); 
    Account objAccount = testData.initVirtualAccount();                  
    insert objAccount;
    objAccount.Related_To__c = 'Virtual Partner';
    update objAccount;
      acc = testData.initVirtualAccount(objAccount);
    insert acc;
    acc.Related_To__c = 'Virtual Partner';
    acc.PAN_ID__pc = 'HJKLK1324L';
    update acc;
      
      Entity_Global_Assumption__c ega=new Entity_Global_Assumption__c(Account__c=acc.id,Expected_Return_on_Investment__c=30,Income_Growth_Rate__c=3,Inflation_Rate__c=6,Number_Of_Months__c=5);
      insert ega;
         
      List<Goal_Profile__c> lstGoalProfile = testData.initialize_lstGoalProfile(acc);
      Database.insert(lstGoalProfile);
        
      List<Asset__c> lstAsset = testData.initialize_lstAsset(acc);
      Database.insert(lstAsset);
       
      Goal_Profile__c goalProfile2 = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
      insert goalProfile2;  
      gol = testData.initialize_Goal(acc, 'Marriage',goalProfile2);
      insert gol;
      system.assertNotEquals(null,gol.id);
       
      Insurance__c  insurance = testData.initialize_Insurance(acc);
      insert insurance;
      system.assertNotEquals(null,insurance.id);
      
      GoalSIPAmount__c goalsip = testData.initialize_GoalSIPAmount(gol);
      upsert goalsip;
      system.assertNotEquals(null,goalsip.id);
      Apexpages.currentPage().getParameters().put('entityId',acc.id);
      ApexPages.currentPage().getParameters().put('goalId',gol.id);    
         /** Eternus Solutions       **/
       /** Author  : Manasi Ranade **/
       /** Issue Id: F0057        **/
       /** Date    : 21/06/2011    **/
       /** Purpose : 1. Test class was throwing 'System.NullPointerException: Argument 1 cannot be null ' 
                 exception for totalAmount parameter.
                2. So added querrystring parameter 'totalAmount' below with its value as '1234' for further calculation.
       /****************************************************/       
      ApexPages.currentPage().getParameters().put('totalAmount','1234');
      goalTestCon=new GoalController();
      goalMappingBean.GoalAssetMappingBean currentGoalAsset=goalTestCon.currentGoalAsset;
        //FS0196
      ApexPages.currentPage().getParameters().put('dblEquitySIP','12');
      ApexPages.currentPage().getParameters().put('dblGoldSIP','13');
      ApexPages.currentPage().getParameters().put('dblDebtSIP','14');
      ApexPages.currentPage().getParameters().put('dblTotalSIP','15');
       
       Test.startTest();   
     // goalOutCon=new GoalOutputController();
      goalCompCon=new GoalComponentController();
     // goalSummary=new GoalSummaryController();
      
       
      goalCompCon.objGoalMappingBean=goalTestCon.goalMappingBean;
      boolean singleYearGoal=goalCompCon.singleYearGoal;
      double futureValueActual=goalCompCon.futureValueActual;
      goalCompCon.output();
      
      test.stopTest();
  }
  
    @isTest(seeAlldata=true) 
  public static void GoalComponentTest4()
  {
     
    TestData_Ffreedom testData = new TestData_Ffreedom(); 
    Account objAccount = testData.initVirtualAccount();                  
    insert objAccount;
    objAccount.Related_To__c = 'Virtual Partner';
    update objAccount;
      acc = testData.initVirtualAccount(objAccount);
    insert acc;
    acc.Related_To__c = 'Virtual Partner';
    acc.PAN_ID__pc = 'HJVLK1324B';
    update acc;
      
      Entity_Global_Assumption__c ega=new Entity_Global_Assumption__c(Account__c=acc.id,Expected_Return_on_Investment__c=30,Income_Growth_Rate__c=3,Inflation_Rate__c=6,Number_Of_Months__c=5);
      insert ega;
         
      List<Goal_Profile__c> lstGoalProfile = testData.initialize_lstGoalProfile(acc);
      Database.insert(lstGoalProfile);
        
      List<Asset__c> lstAsset = testData.initialize_lstAsset(acc);
      Database.insert(lstAsset);
       
      Goal_Profile__c goalProfile2 = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
      insert goalProfile2;  
      gol = testData.initialize_Goal(acc, 'Marriage',goalProfile2);
      insert gol;
      system.assertNotEquals(null,gol.id);
       
      Insurance__c  insurance = testData.initialize_Insurance(acc);
      insert insurance;
      system.assertNotEquals(null,insurance.id);
      
      GoalSIPAmount__c goalsip = testData.initialize_GoalSIPAmount(gol);
      upsert goalsip;
      system.assertNotEquals(null,goalsip.id);
      Apexpages.currentPage().getParameters().put('entityId',acc.id);
      ApexPages.currentPage().getParameters().put('goalId',gol.id);    
         /** Eternus Solutions       **/
       /** Author  : Manasi Ranade **/
       /** Issue Id: F0057        **/
       /** Date    : 21/06/2011    **/
       /** Purpose : 1. Test class was throwing 'System.NullPointerException: Argument 1 cannot be null ' 
                 exception for totalAmount parameter.
                2. So added querrystring parameter 'totalAmount' below with its value as '1234' for further calculation.
       /****************************************************/       
      ApexPages.currentPage().getParameters().put('totalAmount','1234');
      goalTestCon=new GoalController();
      goalMappingBean.GoalAssetMappingBean currentGoalAsset=goalTestCon.currentGoalAsset;
        //FS0196
      ApexPages.currentPage().getParameters().put('dblEquitySIP','12');
      ApexPages.currentPage().getParameters().put('dblGoldSIP','13');
      ApexPages.currentPage().getParameters().put('dblDebtSIP','14');
      ApexPages.currentPage().getParameters().put('dblTotalSIP','15');
       
       Test.startTest();   
      goalOutCon=new GoalOutputController();
      goalCompCon=new GoalComponentController();
      //goalSummary=new GoalSummaryController();
      
       
      goalCompCon.objGoalMappingBean=goalTestCon.goalMappingBean;
      boolean singleYearGoal=goalCompCon.singleYearGoal;
      double futureValueActual=goalCompCon.futureValueActual;
      goalCompCon.output();
      
      test.stopTest();
  }
  
  @isTest(seeAlldata=true) 
  public static void GoalComponentTest3()
  {
     
    TestData_Ffreedom testData = new TestData_Ffreedom(); 
    Account objAccount = testData.initVirtualAccount();                  
    insert objAccount;
    objAccount.Related_To__c = 'Virtual Partner';
    update objAccount;
      acc = testData.initVirtualAccount(objAccount);
    insert acc;
    acc.Related_To__c = 'Virtual Partner';
    acc.PAN_ID__pc = 'HJKLK1324B';
    update acc;
      
      Entity_Global_Assumption__c ega=new Entity_Global_Assumption__c(Account__c=acc.id,Expected_Return_on_Investment__c=30,Income_Growth_Rate__c=3,Inflation_Rate__c=6,Number_Of_Months__c=5);
      insert ega;
         
      List<Goal_Profile__c> lstGoalProfile = testData.initialize_lstGoalProfile(acc);
      Database.insert(lstGoalProfile);
        
      List<Asset__c> lstAsset = testData.initialize_lstAsset(acc);
      Database.insert(lstAsset);
       
      Goal_Profile__c goalProfile2 = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
      insert goalProfile2;  
      gol = testData.initialize_Goal(acc, 'Marriage',goalProfile2);
      insert gol;
      system.assertNotEquals(null,gol.id);
       
      Insurance__c  insurance = testData.initialize_Insurance(acc);
      insert insurance;
      system.assertNotEquals(null,insurance.id);
      
      GoalSIPAmount__c goalsip = testData.initialize_GoalSIPAmount(gol);
      upsert goalsip;
      system.assertNotEquals(null,goalsip.id);
      Apexpages.currentPage().getParameters().put('entityId',acc.id);
      ApexPages.currentPage().getParameters().put('goalId',gol.id);    
         /** Eternus Solutions       **/
       /** Author  : Manasi Ranade **/
       /** Issue Id: F0057        **/
       /** Date    : 21/06/2011    **/
       /** Purpose : 1. Test class was throwing 'System.NullPointerException: Argument 1 cannot be null ' 
                 exception for totalAmount parameter.
                2. So added querrystring parameter 'totalAmount' below with its value as '1234' for further calculation.
       /****************************************************/       
      ApexPages.currentPage().getParameters().put('totalAmount','1234');
      goalTestCon=new GoalController();
      goalMappingBean.GoalAssetMappingBean currentGoalAsset=goalTestCon.currentGoalAsset;
        //FS0196
      ApexPages.currentPage().getParameters().put('dblEquitySIP','12');
      ApexPages.currentPage().getParameters().put('dblGoldSIP','13');
      ApexPages.currentPage().getParameters().put('dblDebtSIP','14');
      ApexPages.currentPage().getParameters().put('dblTotalSIP','15');
       
       Test.startTest();   
     // goalOutCon=new GoalOutputController();
      goalCompCon=new GoalComponentController();
      goalSummary=new GoalSummaryController();
      
       
      goalCompCon.objGoalMappingBean=goalTestCon.goalMappingBean;
      boolean singleYearGoal=goalCompCon.singleYearGoal;
      double futureValueActual=goalCompCon.futureValueActual;
      goalCompCon.output();
      
      test.stopTest();
  }
  
  @isTest(seeAlldata=true) 
  public static void  goalOutputTest()
  {
      Test.startTest();
      testData();
      GoalMappingBean goalMappingBean =goalOutCon.goalMappingBean;
        
      double futureValueActual=goalOutCon.futureValueActual;
      boolean singleYearGoal = false;
      GoalMappingBean golMappingBean=new GoalMappingBean(gol.id,2011,2018,2018,2013);
      double minValue = 10;
      String chartData = '';
      GoalSIPAmount__c currentSIP=golMappingBean.currentSIP;
      List<SelectOption> goalProfileList=golMappingBean.goalProfileList;
      List<List<DataEntrySummaryBean>> getPresentFutureValueList=golMappingBean.getPresentFutureValueList;
      goalOutCon.output();
      test.stopTest();
  }
  
  @isTest(seeAlldata=true) 
  public static void GoalControllerTest1()
  {
      Test.startTest();
      TestData_Ffreedom testData = new TestData_Ffreedom();    
      acc = testData.initializeAccount();
      acc.PAN_ID__pc = 'TYUII7898B';
       insert acc;
      testData();
      
      Insurance__c  insurance = testData.initialize_Insurance(acc);
      insert insurance;
      system.assertNotEquals(null,insurance.id);
      GoalInsuranceAssociation__c gins = new GoalInsuranceAssociation__c(Insurance__c=insurance.id,Goal__c=gol.id,Allocated__c=30);
      insert gins;
      system.assertNotEquals(null,gins.id);
      goalTestCon.save();
      test.stopTest();
  }
}