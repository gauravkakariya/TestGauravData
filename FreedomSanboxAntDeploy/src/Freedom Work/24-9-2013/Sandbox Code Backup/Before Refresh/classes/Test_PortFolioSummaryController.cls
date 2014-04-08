/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     02/05/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/


@isTest
public with sharing class Test_PortFolioSummaryController 
{
	public static testMethod void testPortal()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
		
 		List<Account> lstAccount = new List<Account>();
 		Account act = testData.initializeAccount();
 		lstAccount.add(act);
  		Account son = testData.init_FamilyMember(act);
  		lstAccount.add(son);
    	insert lstAccount;
    	
    	List<Asset__c> lstAsset = new List<Asset__c>();
    	Asset__c asset1 = testData.initialize_Asset(act, 'EPF', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, '');
    	lstAsset.add(asset1);
   	    
    	Asset__c asset2 = testData.initialize_Asset(act, 'EPF', AssetRecTypes__c.getInstance('Cash and Cash Equivalents').RecordTypeId__c, '');
    	lstAsset.add(asset2);
    	
    	Asset__c asset4 = testData.initialize_Asset(act, 'EPF', AssetRecTypes__c.getInstance('Govt. Saving Schemes').RecordTypeId__c, '');
    	lstAsset.add(asset4);
    	
    	Asset__c asset5 = testData.initialize_Asset(act, 'EPF', AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c, '');
    	lstAsset.add(asset5);
    	
    	Asset__c asset6 = testData.initialize_Asset(act, 'EPF', AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c, '');
    	lstAsset.add(asset6);
   	    insert lstAsset;
   	    
   	    List<Investment_Asset__c> lstInvest = new List<Investment_Asset__c>();
   	    
   	    Investment_Asset__c inss1 = testData.init_InvestmentAsset(act, InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c);
   	    inss1.Asset_Type__c = 'Equity';
        lstInvest.add(inss1);
        
        Investment_Asset__c inss2 = testData.init_InvestmentAsset(act, InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c);
   	    inss2.Asset_Type__c = 'Debt';
        lstInvest.add(inss2);
        
        Investment_Asset__c inv = testData.init_InvestmentAsset(act, InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c);
        lstInvest.add(inv);
 
   	    insert lstInvest; 
   	    
   	    Goal_Profile__c goalProfile = testData.initialize_GoalProfile(act, 'Aggressive', 'Customized');
      	insert goalProfile;
      	Goal__c goalObj = testData.initialize_Goal(act, 'Emergency Fund', goalProfile);
    	insert goalObj;
    	system.assertNotEquals(null,goalObj.id);
   	    
    	GoalAssetAssociation__c goalAsset = testData.intialize_GoalAssetAssociation(asset1, goalObj);
    	insert goalAsset;
    	
     	Insurance__c insurance4 = testData.initialize_Insurance(act);
     	insurance4.Flag__c = 'Approved';
     	insert insurance4;
   	    
    	ApexPages.currentPage().getParameters().put('entityId',act.id);
   	   	test.startTest();
   	   	PortFolioSummaryController objPortFolio = new PortFolioSummaryController();
   	   	objPortFolio.getChartData();
   	   	objPortFolio.getSuggestedChartData();
   	   	/*objPortFolio.addAggregateInvestmentAssetToMap();
   	   	objPortFolio.addAggregateInsuranceToMap();
   	   	objPortFolio.addAggregateSuggestedToMap();
   	   	objPortFolio.addAggregateAssetToMap();*/
		test.stopTest();
	}
	
}