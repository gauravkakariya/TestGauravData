/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class GenerateActionPlanForETControllerTest {

    static Account acc;
    static GenerateActionPlanForETController objGenerateETFromAP;
	public static void testData()
	{
	   User user;
	   ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
	   user = new User( email='test-user@fakeemail.com', profileid = ProfileID, UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1',TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US', FirstName = 'Test_Parent_Fname', LastName = 'Test_Parent_Lname' );
	   insert user;
	    
	   Workstation__c workstation = new Workstation__c();
	   workstation.Financial_Planner__c = user.Id;
	   workstation.Compliance__c = user.Id;
	   workstation.Business_Developer__c = user.Id;
	   workstation.Tech__c = user.Id;
	   workstation.Manager__c = user.Id;
	   workstation.Member_Engagement__c = user.Id;
	   workstation.Location__c='pune';
	   insert workstation;
       acc=new Account(LastName='ABC',FirstName='PQR',Adjustment_Factor__c='2',
                       PersonTitle='TestData',PersonBirthdate=system.today(),PersonHomePhone='54623676',PersonMobilePhone='54637',
                       Alternate_Mobile__c='356475',PersonEmail='sgdh@test.com', Alternate_E_Mail_Address__c='fdgr@test.com',
                       Retirement_Year__c=2034,Residential_Status_del__c='own',Retirement_Age__c='58',Estimated_Life_Expectancy__c='67',
                       Estimated_Life_EndYear__c=2041,Relationship_to_Entity__pc='husband',OwnerId=user.id,
                       RecordTypeId=RecTypes__c.getInstance ('AccountClient').Record_Type_Value__c); //Prajakta//'01220000000DnK3AAK');
       upsert acc;
       system.assertNotEquals(null,acc);
    
       /*Goal__c gl=new Goal__c(Entity__c=acc.id,Goal_Type__c='Education',Start_Year__c=2003,End_Year__c=2016,Inflation_Rate__c=3,
                              Cost_of_Goal_Annual__c=23015,Priority__c='High',Goal_Frequency__c=56,Goal_Start_Year__c='2004',
                              Goal_End_Year__c='2031',Description__c='ABC');
       insert gl;
       system.assertNotEquals(null,gl.id);*/
     
      /*Investment_Asset__c inv=new   Investment_Asset__c(Entity__c=acc.id,action__c='yes',RecordTypeId='01220000000HYx5AAG' );
      insert inv;
      system.assertNotEquals(null,inv.id);*/
      Goal__c goal1=new Goal__c(Entity__c=acc.id,Goal_Type__c='Emergency Fund');
      insert goal1;
      system.assertNotEquals(null,goal1.id);
      /*GoalInvestmentAssetAssociation__c gasset1=new GoalInvestmentAssetAssociation__c(Investment_Asset__c=inv.id,Goal__c=goal1.id,allocated__c=45);
      insert gasset1;
      system.assertNotEquals(null,gasset1.id);*/
    
      /*Asset__c asset=new Asset__c(Expected_Growth_Rate__c=4,End_Year__c='2034',Start_Year__c='2001',
                              Entity__c=acc.id,action__c='yes',Asset_Types__c='Gold',RecordTypeId='01220000000HYzWAAW');
      insert asset;
      system.assertNotEquals(null,asset.id);
      GoalAssetAssociation__c gasset2=new GoalAssetAssociation__c(Asset__c=asset.id,Goal__c=goal1.id,Allocated__c=30);
      insert gasset2;
      system.assertNotEquals(null,gasset2.id);*/
  
      /*Insurance__c  insurance=new Insurance__c(Flag__c = 'Analysis',Entity__c=acc.id,action__c ='yes', RecordTypeId='01220000000Do0vAAC' );
      insert insurance;
      system.assertNotEquals(null,insurance.id);
      GoalInsuranceAssociation__c gasset3=new GoalInsuranceAssociation__c(Insurance__c=insurance.id,Goal__c=goal1.id,Allocated__c=30);
      insert gasset3;
      system.assertNotEquals(null,gasset3.id);*/
       AMC_Name__c amc=new AMC_Name__c(  AMC_Field__c='abcd');
      insert amc;
      system.assertNotEquals(null,amc.id);
      Fund__c fund=new Fund__c(Scheme_Name__c='Reliance',  AMC_Name__c='abc',AMCName__c=amc.id);   
      insert fund;
      system.assertNotEquals(null,fund.id);
      
      List<Investment_Asset__c> lstInvestmentAsset = new List<Investment_Asset__c>();
      Investment_Asset__c inv1=new   Investment_Asset__c(Entity__c=acc.id,Asset_Class__c='debt',Asset_Type__c='Equity-index',Monthly_SIP_Amount__c=23561,
      							RecordTypeId=InvestmentAsset__c.getInstance ('Mutual Fund').RecordTypeId__c //Prajakta//'01220000000HYx4AAG'
      							,Fund__c=fund.id );
      lstInvestmentAsset.add(inv1);
      //insert inv1;
      //system.assertNotEquals(null,inv1.id);
  
      Investment_Asset__c inv2=new   Investment_Asset__c(Entity__c=acc.id,Asset_Class__c='debt',Monthly_SIP_Amount__c=23561,Asset_Type__c='RBI Bonds',
      							RecordTypeId=InvestmentAsset__c.getInstance ('Mutual Fund').RecordTypeId__c //Prajakta//'01220000000HYx4AAG' 
      							,Fund__c=fund.id  );
      lstInvestmentAsset.add(inv2);
      //insert inv2;
      //system.assertNotEquals(null,inv2.id);
       Investment_Asset__c inv4=new   Investment_Asset__c(Entity__c=acc.id,action__c='Liquidate (Align to goal)',
       							RecordTypeId=InvestmentAsset__c.getInstance ('Mutual Fund').RecordTypeId__c //Prajakta//'01220000000HYx4AAG'
       							,Asset_Type__c='Debt-LongTerm',Fund__c=fund.id  );
      lstInvestmentAsset.add(inv4);
      //insert inv4;
      //system.assertNotEquals(null,inv4.id);
      Database.insert(lstInvestmentAsset);
      
      Goal__c goal2=new Goal__c(Entity__c=acc.id,Description__c='test',
                                Goal_Type__c='Emergency Fund');
      insert goal2;
      system.assertNotEquals(null,goal2.id);
      
      
      List<Approved_Action_Plan__c> lstApprovedActionPlan = new List<Approved_Action_Plan__c>(); 
      
      Approved_Action_Plan__c app=new Approved_Action_Plan__c(  Entity__c=acc.id,Investment_Asset__c=inv1.id,Goal__c=goal2.id,Allocated_Amount__c=4563,Lumpsum_Action__c='Hold - Change of broker',Notes__c='testing',Scheme_Name__c='Birla Dividend Yield',SIP_Action__c='Stop & Increase',
                                                              Suggested_LumpSum_Action__c='STP To',Allocated__c=20
                                                              ,RecordTypeId='012200000005u5Z');
      lstApprovedActionPlan.add(app);
      //upsert app;
      //system.assertNotEquals(null,app.id);
      app=new Approved_Action_Plan__c(  Entity__c=acc.id,Investment_Asset__c=inv4.id,Goal__c=goal2.id,Allocated_Amount__c=4563,Lumpsum_Action__c='Hold - Change of broker',Notes__c='testing',Scheme_Name__c='Birla Dividend Yield',SIP_Action__c='Stop & Increase',
                                                              Suggested_LumpSum_Action__c='STP To',Allocated__c=30
                                                              ,RecordTypeId='012200000005u5W');
      lstApprovedActionPlan.add(app);
      //upsert app;
      //system.assertNotEquals(null,app.id);
     
       app=new Approved_Action_Plan__c(  Entity__c=acc.id,Investment_Asset__c=inv2.id,Goal__c=goal2.id,Allocated_Amount__c=4563,Lumpsum_Action__c='Hold - Change of broker',Notes__c='testing',Scheme_Name__c='Birla Dividend Yield',SIP_Action__c='Stop & Increase',
                                                              Suggested_LumpSum_Action__c='STP To',Allocated__c=40
                                                              ,RecordTypeId='012200000005u5X');
      lstApprovedActionPlan.add(app);
      //upsert app;
      //system.assertNotEquals(null,app.id);
       app=new Approved_Action_Plan__c(  Entity__c=acc.id,Investment_Asset__c=inv2.id,Goal__c=goal2.id,Allocated_Amount__c=4563,Lumpsum_Action__c='Hold - Change of broker',Notes__c='testing',Scheme_Name__c='Birla Dividend Yield',SIP_Action__c='Stop & Increase',
                                                              Suggested_LumpSum_Action__c='STP To',Allocated__c=50
                                                              ,RecordTypeId='012200000005u5Y');
      lstApprovedActionPlan.add(app);
      //upsert app;
      //system.assertNotEquals(null,app.id);
      database.upsert(lstApprovedActionPlan);
      
      
      List<Insurance__c> lstInsurance = new List<Insurance__c>();
      Insurance__c insurance1=new Insurance__c(Flag__c = 'Approved',Entity__c=acc.id,Suggested_Cover_General_Insurance__c=45665,Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,RecordTypeId='01220000000Do0vAAC');
      lstInsurance.add(insurance1);
      //insert insurance1;
      //system.assertNotEquals(null,insurance1.id);
      
      Insurance__c insurance2=new Insurance__c(Flag__c = 'Approved',Entity__c=acc.id,Suggested_Cover_General_Insurance__c=45665,Insurance_Company__c='ICICI',Policy_Type__c='Term Life',Premium_Amount_Rs__c=2351,RecordTypeId='01220000000Do0uAAC');
      lstInsurance.add(insurance2);
      //insert insurance2;
      Database.insert(lstInsurance);
      
      inv4=new   Investment_Asset__c(Entity__c=acc.id,action__c='Liquidate (Align to goal)',
      								RecordTypeId=InvestmentAsset__c.getInstance ('Mutual Fund').RecordTypeId__c //Prajakta//'01220000000HYx4AAG'
      								,Asset_Type__c='gold',Fund__c=fund.id );
      insert inv4;
      system.assertNotEquals(null,inv4.id);
      app=new Approved_Action_Plan__c(  Entity__c=acc.id,Investment_Asset__c=inv4.id,Goal__c=goal2.id,Allocated_Amount__c=4563,Lumpsum_Action__c='Hold - Change of broker',Notes__c='testing',Scheme_Name__c='Birla Dividend Yield',SIP_Action__c='Stop & Increase',
                                                              Suggested_LumpSum_Action__c='STP To',Allocated__c=60
                                                              ,RecordTypeId='012200000005u5Y');
      upsert app;
      system.assertNotEquals(null,app.id);
     
      /*Goal__c goal5=new Goal__c(Entity__c=acc.id,Goal_Type__c='Emergency Fund');
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
     */
      
      
      Apexpages.currentPage().getParameters().put('entityId',acc.id);
      objGenerateETFromAP = new GenerateActionPlanForETController();
	}
	public static testMethod void approvedPlanTest1()
	{
	    Test.startTest();
	    testData();
	    objGenerateETFromAP.init();
	    objGenerateETFromAP.generateAPForET();
	    Test.stopTest();
	}
}