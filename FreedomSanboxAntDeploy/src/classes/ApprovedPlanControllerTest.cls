@isTest
private class ApprovedPlanControllerTest {
    
static ApprovedPlanController approvedPlan;
static Account acc;
 
public static void testData(){
       acc=new Account(LastName='ABC',FirstName='PQR',Adjustment_Factor__c='2',
                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='54637',
                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
                       Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband',RecordTypeId='01220000000DnK3AAK');
       upsert acc;
       system.assertNotEquals(null,acc);
    
       Goal__c gl=new Goal__c(Entity__c=acc.id,Goal_Type__c='Education',Start_Year__c=2003,End_Year__c=2016,Inflation_Rate__c=3,
                              Cost_of_Goal_Annual__c=23015,Priority__c='High',Goal_Frequency__c=56,Goal_Start_Year__c='2004',
                              Goal_End_Year__c='2031',Description__c='ABC');
       insert gl;
       system.assertNotEquals(null,gl.id);
     
      Investment_Asset__c inv=new   Investment_Asset__c(Entity__c=acc.id,action__c='yes',RecordTypeId=InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c);//RecordTypeId='01220000000HYx5AAG'
      insert inv;
      system.assertNotEquals(null,inv.id);
      Goal__c goal1=new Goal__c(Entity__c=acc.id,Goal_Type__c='Emergency Fund');
      insert goal1;
      system.assertNotEquals(null,goal1.id);
      GoalInvestmentAssetAssociation__c gasset1=new GoalInvestmentAssetAssociation__c(Investment_Asset__c=inv.id,Goal__c=goal1.id,allocated__c=45);
      insert gasset1;
      system.assertNotEquals(null,gasset1.id);
    
      Asset__c asset=new Asset__c(Expected_Growth_Rate__c=4,End_Year__c='2034',Start_Year__c='2001',
                              Entity__c=acc.id,action__c='yes',Asset_Types__c='Gold',RecordTypeId='01220000000HYzWAAW');
      insert asset;
      system.assertNotEquals(null,asset.id);
      GoalAssetAssociation__c gasset2=new GoalAssetAssociation__c(Asset__c=asset.id,Goal__c=goal1.id,Allocated__c=30);
      insert gasset2;
      system.assertNotEquals(null,gasset2.id);
  
      Insurance__c  insurance=new Insurance__c(Flag__c = 'Analysis',Entity__c=acc.id,action__c ='yes', RecordTypeId='01220000000Do0vAAC' );
      insert insurance;
      system.assertNotEquals(null,insurance.id);
      GoalInsuranceAssociation__c gasset3=new GoalInsuranceAssociation__c(Insurance__c=insurance.id,Goal__c=goal1.id,Allocated__c=30);
      insert gasset3;
      system.assertNotEquals(null,gasset3.id);
       AMC_Name__c amc=new AMC_Name__c(  AMC_Field__c='abcd');
      insert amc;
      system.assertNotEquals(null,amc.id);
      Fund__c fund=new Fund__c(Scheme_Name__c='Reliance',  AMC_Name__c='abc',AMCName__c=amc.id);   
      insert fund;
      system.assertNotEquals(null,fund.id);
      
      
      Investment_Asset__c inv1=new   Investment_Asset__c(Entity__c=acc.id,Asset_Class__c='debt',Asset_Type__c='Equity-index',Monthly_SIP_Amount__c=23561,RecordTypeId='01220000000HYx4AAG',Fund__c=fund.id );
      insert inv1;
      system.assertNotEquals(null,inv1.id);
  
      Investment_Asset__c inv2=new   Investment_Asset__c(Entity__c=acc.id,Asset_Class__c='debt',Monthly_SIP_Amount__c=23561,Asset_Type__c='RBI Bonds',RecordTypeId='01220000000HYx4AAG' ,Fund__c=fund.id  );
      insert inv2;
      system.assertNotEquals(null,inv2.id);
       Investment_Asset__c inv4=new   Investment_Asset__c(Entity__c=acc.id,action__c='Liquidate (Align to goal)',RecordTypeId='01220000000HYx4AAG',Asset_Type__c='Debt-LongTerm',Fund__c=fund.id  );
      insert inv4;
      system.assertNotEquals(null,inv4.id);
      
      Goal__c goal2=new Goal__c(Entity__c=acc.id,Description__c='test',
                                Goal_Type__c='Emergency Fund');
      insert goal2;
      system.assertNotEquals(null,goal2.id);
      Approved_Action_Plan__c app=new Approved_Action_Plan__c(  Entity__c=acc.id,Investment_Asset__c=inv1.id,Goal__c=goal2.id,Allocated_Amount__c=4563,Lumpsum_Action__c='Hold - Change of broker',Notes__c='testing',Scheme_Name__c='Birla Dividend Yield',SIP_Action__c='Stop & Increase',
                                                              Suggested_LumpSum_Action__c='STP To',RecordTypeId='012200000005u5Z');
      upsert app;
      system.assertNotEquals(null,app.id);
      app=new Approved_Action_Plan__c(  Entity__c=acc.id,Investment_Asset__c=inv4.id,Goal__c=goal2.id,Allocated_Amount__c=4563,Lumpsum_Action__c='Hold - Change of broker',Notes__c='testing',Scheme_Name__c='Birla Dividend Yield',SIP_Action__c='Stop & Increase',
                                                              Suggested_LumpSum_Action__c='STP To',RecordTypeId='012200000005u5W');
      upsert app;
      system.assertNotEquals(null,app.id);
     
       app=new Approved_Action_Plan__c(  Entity__c=acc.id,Investment_Asset__c=inv2.id,Goal__c=goal2.id,Allocated_Amount__c=4563,Lumpsum_Action__c='Hold - Change of broker',Notes__c='testing',Scheme_Name__c='Birla Dividend Yield',SIP_Action__c='Stop & Increase',
                                                              Suggested_LumpSum_Action__c='STP To',RecordTypeId='012200000005u5X');
      upsert app;
      system.assertNotEquals(null,app.id);
       app=new Approved_Action_Plan__c(  Entity__c=acc.id,Investment_Asset__c=inv2.id,Goal__c=goal2.id,Allocated_Amount__c=4563,Lumpsum_Action__c='Hold - Change of broker',Notes__c='testing',Scheme_Name__c='Birla Dividend Yield',SIP_Action__c='Stop & Increase',
                                                              Suggested_LumpSum_Action__c='STP To',RecordTypeId='012200000005u5Y');
      upsert app;
      system.assertNotEquals(null,app.id);
      
      Insurance__c insurance1=new Insurance__c(Flag__c = 'Analysis',Entity__c=acc.id,Suggested_Cover_General_Insurance__c=45665,Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,RecordTypeId='01220000000Do0vAAC');
      insert insurance1;
      system.assertNotEquals(null,insurance1.id);
      
     inv4=new   Investment_Asset__c(Entity__c=acc.id,action__c='Liquidate (Align to goal)',RecordTypeId='01220000000HYx4AAG',Asset_Type__c='gold',Fund__c=fund.id );
      insert inv4;
      system.assertNotEquals(null,inv4.id);
      app=new Approved_Action_Plan__c(  Entity__c=acc.id,Investment_Asset__c=inv4.id,Goal__c=goal2.id,Allocated_Amount__c=4563,Lumpsum_Action__c='Hold - Change of broker',Notes__c='testing',Scheme_Name__c='Birla Dividend Yield',SIP_Action__c='Stop & Increase',
                                                              Suggested_LumpSum_Action__c='STP To',RecordTypeId='012200000005u5Y');
      upsert app;
      system.assertNotEquals(null,app.id);
     
      Goal__c goal5=new Goal__c(Entity__c=acc.id,Goal_Type__c='Emergency Fund');
      insert goal5;
      system.assertNotEquals(null,goal5.id);
      GoalInvestmentAssetAssociation__c gasset5=new GoalInvestmentAssetAssociation__c(Investment_Asset__c=inv4.id,Goal__c=goal5.id,allocated__c=55);
      insert gasset5;
      system.assertNotEquals(null,gasset5.id);
      
     
      GoalInsuranceAssociation__c gasset6=new GoalInsuranceAssociation__c(Insurance__c=insurance1.id,Goal__c=goal5.id,Allocated__c=30);
      insert gasset6;
      system.assertNotEquals(null,gasset6.id);
      
      Asset__c asset6=new Asset__c(Entity__c=acc.id,action__c ='Liquidate (Align to goal)',RecordTypeId='01220000000HYzWAAW');
      insert asset6;
      system.assertNotEquals(null,asset6.id);
      GoalAssetAssociation__c gasset7=new GoalAssetAssociation__c(Asset__c=asset6.id,Goal__c=goal5.id,Allocated__c=30);
      insert gasset7;
      system.assertNotEquals(null,gasset7.id);
     
      
      
      Apexpages.currentPage().getParameters().put('entityId',acc.id);
      approvedPlan=new ApprovedPlanController();
}
public static void testData1(){
     acc=new Account(LastName='ABC',FirstName='PQR',Adjustment_Factor__c='2',
                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='54637',
                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
                       Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband',RecordTypeId='01220000000DnK3AAK');
       upsert acc;
       system.assertNotEquals(null,acc.id);
    
      
      Insurance__c insurance4=new Insurance__c(Flag__c = 'Approved',Entity__c=acc.id, Suggested_Cover_General_Insurance__c=45665,Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,RecordTypeId='01220000000Do0vAAC');
      insert insurance4;
      system.assertNotEquals(null,insurance4.id);
      Apexpages.currentPage().getParameters().put('entityId',acc.id);
      approvedPlan=new ApprovedPlanController();
     
     
      
}

public static testMethod void approvedPlanTest(){
    Test.startTest();
   /* testData();
    System.debug('@@@@@@@@@@@@@@222 2');
    approvedPlan.upsertData();
    approvedPlan.addNewSuggLump();
    approvedPlan.addNewSuggSIP();
    approvedPlan.Approved();
    approvedPlan.RemoveRecordLump();
    approvedPlan.RemoveRecordSIP();
    approvedPlan.SummaryActionPlan();
    approvedPlan.getEntities();
    approvedPlan.getAssetClass();
    approvedPlan.getLumpActions();
    approvedPlan.getSugLumpActions();
    approvedPlan.getSipActions();
    approvedPlan.getSchemeNames();
   */
    test.stopTest();
}
public static testMethod void approvedPlanTest1(){
    Test.startTest();
    testData1();
    approvedPlan.upsertData();
    approvedPlan.addNewSuggLump();
    approvedPlan.addNewSuggSIP();
    approvedPlan.Approved();
    approvedPlan.RemoveRecordLump();
    approvedPlan.RemoveRecordSIP();
    approvedPlan.SummaryActionPlan();
    approvedPlan.getEntities();
    approvedPlan.getAssetClass();
    approvedPlan.getLumpActions();
    approvedPlan.getSugLumpActions();
    approvedPlan.getSipActions();
    approvedPlan.getSchemeNames();
   
    test.stopTest();
}

}