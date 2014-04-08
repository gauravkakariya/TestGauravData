@isTest
private class SumActionPlanControllerTest 
{
	static SumActionPlanController sumActionPlan;
	static Account acc;
	
	public static void testData()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
		acc = testData.initializeAccount();
        upsert acc;
        system.assertNotEquals(null,acc);
    
    	Goal_Profile__c goalProfile = testData.initialize_GoalProfile(acc, 'Moderately Conservative', 'Customized'); 
        insert goalProfile;
        
        Goal__c gl = testData.initialize_Goal(acc, 'Education', goalProfile);
        insert gl;
        system.assertNotEquals(null,gl.id);
       
        Investment_Asset__c inv = testData.init_InvestmentAsset(acc, InvestmentAsset__c.getInstance ('Stocks').RecordTypeId__c);
        insert inv;
        system.assertNotEquals(null,inv.id);
        
        Goal__c goal1 = testData.initialize_Goal(acc, 'Emergency Fund', goalProfile);
        insert goal1;
        system.assertNotEquals(null,goal1.id);
        
        GoalInvestmentAssetAssociation__c gasset1 = testData.init_GoalInvAsset(inv, goal1);
        insert gasset1;
        system.assertNotEquals(null,gasset1.id);
      
        Asset__c asset = testData.initialize_Asset(acc, '', AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c, '');
      	insert asset;
      	system.assertNotEquals(null,asset.id);
      	
      	GoalAssetAssociation__c gasset2 = testData.intialize_GoalAssetAssociation(asset, goal1);
      	insert gasset2;
      	system.assertNotEquals(null,gasset2.id);
  
  		Insurance__c  insurance = testData.initialize_Insurance(acc);
      	insert insurance;
      	system.assertNotEquals(null,insurance.id);
      	
      	GoalInsuranceAssociation__c gasset3 = testData.initialize_GoalIA(insurance, goal1);
      	insert gasset3;
      	system.assertNotEquals(null,gasset3.id);
      
        Apexpages.currentPage().getParameters().put('entityId',acc.id);
		sumActionPlan=new SumActionPlanController();
	}
	
	public static testMethod void SumActionPlanTest()
	{
	    Test.startTest();
	    testData();
	    sumActionPlan.actionPlan();
	   	sumActionPlan.actionPlanPDF();
	    test.stopTest();
	}
}