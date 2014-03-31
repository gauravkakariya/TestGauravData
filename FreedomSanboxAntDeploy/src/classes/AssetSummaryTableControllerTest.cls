/*
Revision History:

Version     Version Author     Date        Comments
1.0         --           	   --	  	   Initial Draft
2.0  		Prajakta Sanap     22/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class AssetSummaryTableControllerTest 
{
 	static Account parent;
  	static Account child;
  	static Asset__c asset1;
  	static Asset__c asset2;
  	static AssetSummaryTableController assetCon;
  
  	public static void setupData()
  	{
    	TestData_Ffreedom testData = new TestData_Ffreedom();
		parent = testData.initializeAccount();
    	upsert parent;
    	child = testData.init_FamilyMember(parent);
    	upsert child;
    
    	ApexPages.currentPage().getParameters().put('EntityId',parent.id);
    	assetCon= new AssetSummaryTableController();
  	}
 
 	public static testMethod void  setBussinessAssetData()
 	{
    	Test.startTest();
    	setupData();
    	List<Asset__c> lstAsset = new List<Asset__c>(); 
    	assetCon.AssetBeanObj.selRecordTypeId=AssetRecTypes__c.getInstance('Business Assets').RecordTypeId__c;//'01220000000HYzTAAW'; Samir
	    assetCon.AssetBeanObj.selRecordTypeName='Business Assets';
	    assetCon.showPopUp();
	    assetCon.addNewRow();
	    assetCon.getOwnerItems();
	    assetCon.Save();
	    assetCon.Remove();
	    assetCon.closePopUp();
	    
	    test.stopTest();
	}
  
  	public static testMethod void setCashAssetData()
  	{
	    Test.startTest();
	    setupData();
	    List<Asset__c> lstCashAsset = new List<Asset__c>();
	    assetCon.AssetBeanObj.selRecordTypeId=AssetRecTypes__c.getInstance('Cash and Cash Equivalents').RecordTypeId__c; //'01220000000HYzUAAW'; Samir
	    assetCon.AssetBeanObj.selRecordTypeName='Cash and Cash Equivalents';
	    assetCon.showPopUp();
	    assetCon.addNewRow();
	    assetCon.getOwnerItems();
	    assetCon.Save();
	    assetCon.Remove();
	    assetCon.closePopUp();
	    test.stopTest();
	}
	
  	public static testMethod void setDepositAssetData()
  	{
	    Test.startTest();
	    setupData();
	    List<Asset__c> lstDepositAsset = new List<Asset__c>();
	    
	    assetCon.AssetBeanObj.selRecordTypeId=AssetRecTypes__c.getInstance('Deposits With Bank').RecordTypeId__c; //'01220000000HYzVAAW'; samir
	    assetCon.AssetBeanObj.selRecordTypeName='Deposits With Bank';
	    String gwthLabel=assetCon.AssetBeanObj.growthRateLabel;
	    String annualLabel=assetCon.AssetBeanObj.annualContributionLabel;
	    String endYrlbl=assetCon.AssetBeanObj.endYearlabel;
	    assetCon.showPopUp();
	    assetCon.addNewRow();
	    assetCon.getOwnerItems();
	    assetCon.Save();
	     assetCon.Remove();
	    assetCon.closePopUp();
	    test.stopTest();
	}
	  
	public static testMethod  void setPersonalAssetData()
	{
	    Test.startTest();
	    setupData();
	    list<Asset__c> lstPersonalAsset = new List<Asset__c>();
	    
	    assetCon.AssetBeanObj.selRecordTypeId=AssetRecTypes__c.getInstance('Personal Assets').RecordTypeId__c; //'01220000000HYzWAAW';
	    assetCon.AssetBeanObj.selRecordTypeName='Personal Assets';
	    String gwthLabel=assetCon.AssetBeanObj.growthRateLabel;
	    String annualLabel=assetCon.AssetBeanObj.annualContributionLabel;
	    String endYrlbl=assetCon.AssetBeanObj.endYearlabel;
	    assetCon.showPopUp();
	    assetCon.addNewRow();
	    assetCon.getOwnerItems();
	    assetCon.Save();
	    assetCon.Remove();
	    assetCon.closePopUp();
	    test.stopTest();
	}
	
	public static testMethod void setPOsavingsAssetData()
	{
	    Test.startTest();
	    setupData();
	    assetCon.AssetBeanObj.selRecordTypeId=AssetRecTypes__c.getInstance('Govt. Saving Schemes').RecordTypeId__c; //'01220000000HYzXAAW'; Samir
	    assetCon.AssetBeanObj.selRecordTypeName='Govt. Saving Schemes';
	    String gwthLabel=assetCon.AssetBeanObj.growthRateLabel;
	    String annualLabel=assetCon.AssetBeanObj.annualContributionLabel;
	    assetCon.showPopUp();
	    assetCon.addNewRow();
	    assetCon.getOwnerItems();
	    assetCon.Save();
	     assetCon.Remove();
	    assetCon.closePopUp();
	    test.stopTest();
	}
	
	public static testMethod void setRealEstateAssetData()
	{
	    Test.startTest();
	    setupData();
	    
	    TestData_Ffreedom testData = new TestData_Ffreedom();
	    //asset1 = testData.initialize_Asset(parent, 'EPF', AssetRecTypes__c.getInstance('Real Estate Assets').RecordTypeId__c, '');
	    
	    asset1=new Asset__c(Entity__c=parent.id,Account_Type__c='EPF',Accumulated_Value__c=20000,
	                       Annual_Contribution__c=1000,Asset_Types__c='Land',Current_Value__c=100000,
	                        Current_Balance__c=10000,RecordTypeId=AssetRecTypes__c.getInstance('Real Estate Assets').RecordTypeId__c); //'01220000000HYzYAAW');samir
	    upsert asset1;
	    
	    List<AggregateResult>aggregateList=new DatabaseSOQL().getAssetListByClass(parent.id);
	    AssetBean.getNetworthSummaryDetail(aggregateList.get(0));
	    assetCon.AssetBeanObj.selRecordTypeId=AssetRecTypes__c.getInstance('Real Estate Assets').RecordTypeId__c; //'01220000000HYzYAAW';samir
	    assetCon.AssetBeanObj.selRecordTypeName='Real Estate Assets';
	    String gwthLabel=assetCon.AssetBeanObj.growthRateLabel;
	    String annualLabel=assetCon.AssetBeanObj.annualContributionLabel;
	    assetCon.showPopUp();
	    assetCon.addNewRow();
	    assetCon.getOwnerItems();
	    assetCon.Save();
	     assetCon.Remove();
	    assetCon.closePopUp();
	    test.stopTest();
	}
	
	public static testMethod void setRetirementAssetData()
	{
	    Test.startTest();
	    setupData();
		list<Asset__c> lstRetireAsset = new List<Asset__c>();    
	    
	    TestData_Ffreedom testData = new TestData_Ffreedom();
	    asset1 = testData.initialize_Asset(parent, 'EPF', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, '');
	    
	    lstRetireAsset.add(asset1);
	    
	    Asset__c asset3 = asset2 = testData.initialize_Asset(parent, 'EPF', AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c, '');
	    lstRetireAsset.add(asset2);
	    upsert lstRetireAsset;
	    
	    assetCon.AssetBeanObj.selRecordTypeId=AssetRecTypes__c.getInstance('Retirement Accounts').RecordTypeId__c; //'01220000000HYzZAAW';Samir
	    assetCon.AssetBeanObj.selRecordTypeName='Retirement Accounts';
	    String gwthLabel=assetCon.AssetBeanObj.growthRateLabel;
	    String annualLabel=assetCon.AssetBeanObj.annualContributionLabel;
	    assetCon.showPopUp();
	    assetCon.addNewRow();
	    assetCon.getOwnerItems();
	    assetCon.Save();
	     assetCon.Remove();
	    assetCon.closePopUp();
	    test.stopTest();
	}
}