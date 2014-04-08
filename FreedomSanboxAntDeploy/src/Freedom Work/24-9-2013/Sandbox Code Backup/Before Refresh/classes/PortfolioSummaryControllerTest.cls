/*
Revision History:

Version     Version Author     Date        Comments
1.0         --           	   --	  	   Initial Draft
2.0			Manasi			   29/06/2011  Issue Id : F0064 :
										   1) Previous Code is commented from testData() function.
	   				 					   2) And added after Test.startTest(); in portfolioSummaryTest() method 
	   				 					   to remove 'Too many SOQL queries' related exception. 
2.0  		Prajakta Sanap     22/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/
@isTest
private class PortfolioSummaryControllerTest 
{
    
	static NewPortfolioSummaryController pfCon;
	static Account acc;
 
	public static void testData()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
		acc = testData.initializeAccount();
    	upsert acc;
    	system.assertNotEquals(null,acc);
    
    	Goal_Profile__c goalProfile = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
      	insert goalProfile;
      	Goal__c gl = testData.initialize_Goal(acc, 'Emergency Fund', goalProfile);
    	insert gl;
    	system.assertNotEquals(null,gl.id);
     
     	List<Asset__c> lstAsset = new List<Asset__c>();
		
		Asset__c asset1 = testData.initialize_Asset(acc, '', AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c, '');     
	    lstAsset.add(asset1);
	    
	    Asset__c asset2 = testData.initialize_Asset(acc, '', AssetRecTypes__c.getInstance('Real Estate Assets').RecordTypeId__c, '');                       
	    lstAsset.add(asset2);
	    
	    Asset__c asset3 = testData.initialize_Asset(acc, '', AssetRecTypes__c.getInstance('Cash and Cash Equivalents').RecordTypeId__c, '');     
	    lstAsset.add(asset3);  
	    
	    Asset__c asset4 = testData.initialize_Asset(acc, '', AssetRecTypes__c.getInstance('Cash and Cash Equivalents').RecordTypeId__c, '');               
      	lstAsset.add(asset4);
      	
      	Asset__c asset5 = testData.initialize_Asset(acc, '', AssetRecTypes__c.getInstance('Deposits With Bank').RecordTypeId__c, '');               
     	lstAsset.add(asset5);
     	insert lstAsset;
     
     	GoalAssetAssociation__c ga = testData.intialize_GoalAssetAssociation(lstAsset[0], gl);
      	insert ga;
     	system.assertNotEquals(null,ga.id);
     
		ga = testData.intialize_GoalAssetAssociation(lstAsset[1], gl);      
      	insert ga;
      	system.assertNotEquals(null,ga.id);
     	ga = testData.intialize_GoalAssetAssociation(lstAsset[2], gl);
     	insert ga;
     	system.assertNotEquals(null,ga.id);
     	
		ga = testData.intialize_GoalAssetAssociation(lstAsset[4], gl);
     	insert ga;
     	system.assertNotEquals(null,ga.id);
     
     	Investment_Asset__c inv = testData.init_InvestmentAsset(acc, InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c);
     	inv.Asset_Type__c = 'Equity-index';
	    insert inv;
	    system.assertNotEquals(null,inv.id);
	     
	    GoalInvestmentAssetAssociation__c ginv = testData.init_GoalInvAsset(inv, gl); 
	    insert ginv;
	    system.assertNotEquals(null,ginv.id);
		
		inv = testData.init_InvestmentAsset(acc, InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c);
		inv.Asset_Type__c = 'Debt-short';
		upsert inv;
		system.assertNotEquals(null,inv.id);
	    
	    inv = testData.init_InvestmentAsset(acc, InvestmentAsset__c.getInstance('Mutual Fund').RecordTypeId__c);
	    insert inv;
	    system.assertNotEquals(null,inv.id);
	      
	    ginv = testData.init_GoalInvAsset(inv, gl);
	    insert ginv;
	    system.assertNotEquals(null,ginv.id);
	     
	    inv = testData.init_InvestmentAsset(acc, InvestmentAsset__c.getInstance('Stocks').RecordTypeId__c);
	    insert inv;
	    system.assertNotEquals(null,inv.id);
	      
	    ginv = testData.init_GoalInvAsset(inv, gl);
	    insert ginv;
	    system.assertNotEquals(null,ginv.id);
	    
	    inv = testData.init_InvestmentAsset(acc, InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c);
	    insert inv;
	    system.assertNotEquals(null,inv.id);
	    
	    ginv = testData.init_GoalInvAsset(inv, gl);
	    insert ginv;
	    system.assertNotEquals(null,ginv.id);
	    
	    Insurance__c  insurance = testData.initialize_Insurance(acc);
	    insert insurance;
	    system.assertNotEquals(null,insurance.id);
	    
	    GoalInsuranceAssociation__c gins = testData.initialize_GoalIA(insurance, gl);  
	    insert gins;
	    system.assertNotEquals(null,gins.id);
	      
	    GoalSIPAmount__c objSIPAmount1 = testData.initialize_GoalSIPAmount(gl);
	      insert objSIPAmount1;
      
	}

	public static testMethod void portfolioSummaryTest()
	{
	    testData();
	    Test.startTest();
	    Apexpages.currentPage().getParameters().put('entityId',acc.id);
	    pfCon=new NewPortfolioSummaryController();
	    //pfCon.getChartData();
	   	//pfCon.getSuggestedChartData();
	   	test.stopTest();
	} 
	
	
	
	public static testMethod void portfolioSummaryTestasset()
	{
	    
		TestData_Ffreedom testData = new TestData_Ffreedom();
		acc = testData.initializeAccount();    	
    	upsert acc;
    	system.assertNotEquals(null,acc);
    	
    	Goal_Profile__c goalProfile = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
      	insert goalProfile;
      	Goal__c gl = testData.initialize_Goal(acc, 'Emergency Fund', goalProfile);
    	insert gl;
    	system.assertNotEquals(null,gl.id);
     	List<Asset__c> lstAsset = new List<Asset__c>();
		
		Asset__c asset1 = testData.initialize_Asset(acc, '', AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c, '');  
		asset1.Asset_Types__c = 'Gold';   
	    lstAsset.add(asset1);    
	    
	    Asset__c asset2 = testData.initialize_Asset(acc, '', AssetRecTypes__c.getInstance('Real Estate Assets').RecordTypeId__c, '');
	    asset2.Asset_Types__c = 'SECONDARY';                 
	    lstAsset.add(asset2);
     	insert lstAsset;
     	
     	GoalSIPAmount__c objSIPAmount = testData.initialize_GoalSIPAmount(gl);
	    insert objSIPAmount;
     	
     	Test.startTest();
     	Apexpages.currentPage().getParameters().put('entityId',acc.id);
	    pfCon=new NewPortfolioSummaryController();
	    pfCon.getChartData();
	   	pfCon.getSuggestedChartData();
	   	test.stopTest();
	}
}