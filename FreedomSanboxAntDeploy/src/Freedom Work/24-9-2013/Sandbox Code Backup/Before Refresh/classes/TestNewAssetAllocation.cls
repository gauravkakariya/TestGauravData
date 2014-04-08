/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     23/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/


public with sharing class TestNewAssetAllocation 
{
	@isTest(SeeAllData = true)
 	public static void testData()
 	{
 		TestData_Ffreedom testData = new TestData_Ffreedom();
 		User partnerUser = testData.initBusinessUser();
 		List<Account> lstAcc = new List<Account>();
		Account acc = testData.initializeAccount();
	    lstAcc.add(acc);
	    Account objBPAccount = testData.initBusinessAccount(partnerUser);
	    objBPAccount.PAN_ID__pc='a1b2c3d465';
	    lstAcc.add(objBPAccount);
	    insert lstAcc;
	    
	    lstAcc[1].Related_To__c = 'Business Partner';
	    update lstAcc[1];
	    
	    Goal_Profile__c goalProfile = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
      	insert goalProfile;
      	Goal__c objGoal = testData.initialize_Goal(acc, 'Emergency Fund', goalProfile);
    	insert objGoal;
    	system.assertNotEquals(null,objGoal.id);

	    List<Asset__c> lstAsset = new List<Asset__c>();
	    Asset__c asset1 = testData.initialize_Asset(acc, 'EPF', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, 'ABC');
	    lstAsset.add(asset1);
	    
	    Asset__c asset3 = testData.initialize_Asset(acc, 'EPF', AssetRecTypes__c.getInstance('Cash and Cash Equivalents').RecordTypeId__c, 'ABC');
	    lstAsset.add(asset3);
	    
	    Asset__c asset2 = testData.initialize_Asset(acc, 'EPF', AssetRecTypes__c.getInstance('Business Assets').RecordTypeId__c, 'ABC');
	   	lstAsset.add(asset2);
	    insert lstAsset;
	    
	    //RecordType objRecType = [Select Name, Id From RecordType  where Name = 'Fixed Income'];
	    
	    List<Investment_Asset__c> lstInvestmentAsset = new List<Investment_Asset__c>();
	    Investment_Asset__c insv = testData.init_InvestmentAsset(acc,InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c);
	   	lstInvestmentAsset.add(insv);
	   	Investment_Asset__c insv1 = testData.init_InvestmentAsset(acc,InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c);
	   	lstInvestmentAsset.add(insv1);
	   	Investment_Asset__c insv2 = testData.init_InvestmentAsset(acc,InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c);
	   	lstInvestmentAsset.add(insv2);
	   	
	   	insert lstInvestmentAsset;
	   	
	   	Insurance__c ins = testData.initialize_Insurance(acc);
	    insert ins; 	    
      	
      	
      	List<GoalAssetAssociation__c> lstGoalAssetAssociation = new List<GoalAssetAssociation__c>();
      	GoalAssetAssociation__c gasset = testData.intialize_GoalAssetAssociation(asset1,objGoal);
        lstGoalAssetAssociation.add(gasset);
        GoalAssetAssociation__c gasset1 = testData.intialize_GoalAssetAssociation(asset2,objGoal);
        lstGoalAssetAssociation.add(gasset1); 
   
        insert lstGoalAssetAssociation;
        
        List<GoalInvestmentAssetAssociation__c> lstGoalInvestmentAssetAssociation = new List<GoalInvestmentAssetAssociation__c>();
      	GoalInvestmentAssetAssociation__c ginv = testData.init_GoalInvAsset(insv,objGoal);
        lstGoalInvestmentAssetAssociation.add(ginv);
        insert lstGoalInvestmentAssetAssociation;
        
      	GoalInsuranceAssociation__c gins = testData.initialize_GoalIA(ins,objGoal);
       	insert gins;
      	
    	Test.startTest();
       
      	Apexpages.currentPage().getParameters().put('entityId',acc.id);
      	
      	NewAssetAllocationController assetAllCon = new NewAssetAllocationController();
       	assetAllCon.save();
       	
       	AssetAllocationBean assetAllocationBean = new assetAllocationBean();
		MAP<ID,Asset__c> assetMap  = assetAllocationBean.assetMap;
    	AssetAllocationBean.AssetDetailBean objAssetDetailBean = new AssetAllocationBean.AssetDetailBean ();
    	AssetAllocationBean.GoalAssetMapping mappingBean = new AssetAllocationBean.GoalAssetMapping();
    	objAssetDetailBean.populateGoalAssetMappingList(mappingBean);
        
    
      	/*Apexpages.currentPage().getParameters().put('entityId',objBPAccount.Id);
      	System.runAs(partnerUser)
      	{
      		//assetAllCon = new NewAssetAllocationController();
       		assetAllCon.save();
      	}
      	
      	Apexpages.currentPage().getParameters().put('entityId','001R000000');
      	//assetAllCon = new NewAssetAllocationController();
       	assetAllCon.save();*/
       	
       	Test.stopTest();
    }
}