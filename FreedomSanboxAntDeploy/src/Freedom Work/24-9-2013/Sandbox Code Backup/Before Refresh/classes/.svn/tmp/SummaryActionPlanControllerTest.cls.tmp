@isTest
private class SummaryActionPlanControllerTest 
{
    
	static SummaryActionPlanController summaryActionPlan;
	static Account acc;
 
	public static void testData()
	{
       	TestData_Ffreedom testData = new TestData_Ffreedom();
		acc = testData.initializeAccount();
       	upsert acc;
       	system.assertNotEquals(null,acc);
    
       	Goal_Profile__c goalProfile = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
      	insert goalProfile;
      	Goal__c gl = testData.initialize_Goal(acc, 'Education', goalProfile);
    	insert gl;
    	system.assertNotEquals(null,gl.id);
       	
      	Investment_Asset__c inv = testData.init_InvestmentAsset(acc, InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c);
      	insert inv;
      	system.assertNotEquals(null,inv.id);
      	
      	gl = testData.initialize_Goal(acc, 'Emergency Fund', goalProfile);
    	insert gl;
    	system.assertNotEquals(null,gl.id);
    	
    	GoalInvestmentAssetAssociation__c gasset1 = testData.init_GoalInvAsset(inv, gl);
      	insert gasset1;
      	system.assertNotEquals(null,gasset1.id);
    
      	Asset__c asset = testData.initialize_Asset(acc, '', AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c, '');
      	insert asset;
      	system.assertNotEquals(null,asset.id);
      	
      	GoalAssetAssociation__c gasset2 = testData.intialize_GoalAssetAssociation(asset, gl);
      	insert gasset2;
      	system.assertNotEquals(null,gasset2.id);
  
		Insurance__c  insurance = testData.initialize_Insurance(acc);  
      	insert insurance;
      	system.assertNotEquals(null,insurance.id);
      	
      	GoalInsuranceAssociation__c gasset3 = testData.initialize_GoalIA(insurance, gl);
      	insert gasset3;
      	system.assertNotEquals(null,gasset3.id);
      
      	Insurance__c insurance1 = testData.initialize_Insurance(acc);
      	insert insurance1;
      	system.assertNotEquals(null,insurance1.id);
      
		Insurance__c insurance2 = testData.initialize_Insurance(acc);
      	insert insurance2;
      	system.assertNotEquals(null,insurance2.id);
      
		Investment_Asset__c inv1 = testData.init_InvestmentAsset(acc, InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c);      
      	insert inv1;
      	system.assertNotEquals(null,inv1.id);
      	
      	Goal__c goal2 = testData.initialize_Goal(acc, 'Emergency Fund', goalProfile);
      	insert goal2;
      	system.assertNotEquals(null,goal2.id);
      	
      	GoalInvestmentAssetAssociation__c gasset4 = testData.init_GoalInvAsset(inv1, goal2);
      	insert gasset4;
      	system.assertNotEquals(null,gasset4.id);
      
		Insurance__c  insurance4 = testData.initialize_Insurance(acc);      
      	insert insurance4;
      	system.assertNotEquals(null,insurance4.id);
      	
      	GoalInsuranceAssociation__c gasset5 = testData.initialize_GoalIA(insurance4, goal2);
      	insert gasset5;
      	system.assertNotEquals(null,gasset5.id);
      
		Asset__c asset3 = testData.initialize_Asset(acc, '', AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c, 'Liquidate (Align to goal)');      
      	insert asset3;
      	system.assertNotEquals(null,asset3.id);
      	
      	GoalAssetAssociation__c gasset6 = testData.intialize_GoalAssetAssociation(asset3, goal2);
      	insert gasset6;
      	system.assertNotEquals(null,gasset6.id);
      
      	Apexpages.currentPage().getParameters().put('entityId',acc.id);
      	summaryActionPlan=new SummaryActionPlanController();
	}
	
	public static testMethod void SummaryActionPlanTest()
	{
	    Test.startTest();
    	testData();
    	summaryActionPlan.approvedPlan();
   
    	test.stopTest();
	}	

}