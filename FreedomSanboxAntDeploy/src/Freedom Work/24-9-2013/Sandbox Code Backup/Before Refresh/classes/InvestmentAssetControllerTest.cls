/*
	Revision History:
	Version     Version Author     Date        Comments

	2.0  		Prajakta Sanap     22/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.											
*/

@isTest
private class InvestmentAssetControllerTest 
{
  	static Account parent;
  	static Account child;
  	static Investment_Asset__c investAsset;
  	static InvestmentAssetBean.InvestmentWrapper wrapper;
  	static AMC_Name__c amc;
  	static Fund__c fund;
  	static InvestmentAssetController investAssetCon;
  	
  	public static void setupData()
  	{
  		TestData_Ffreedom testData = new TestData_Ffreedom();
  		
	  	parent = testData.initializeAccount();
	  	upsert parent;
	  	child = testData.init_FamilyMember(parent);
	    upsert child;
	    investAsset=new Investment_Asset__c();
	    ApexPages.currentPage().getParameters().put('EntityId',parent.id);
	    amc =new AMC_Name__c(Name='Reliance',AMC_Field__c='Reliance');
	  	upsert amc;
	  	fund=new Fund__c(Scheme_Name__c='Scheme1',AMCName__c=amc.id);
	  	upsert fund;
	    ApexPages.currentPage().getParameters().put('Index','0'); 
	    ApexPages.currentPage().getParameters().put('selectedAMCName',amc.id);  
	    ApexPages.StandardController stdController= new ApexPages.StandardController(investAsset);
	    investAssetCon= new InvestmentAssetController(stdController);
	}
	
	public static  testMethod void stockTestData()
	{
	  	Test.startTest();
	  	setupData();
		list<Investment_Asset__c> lstInvAsset = new list<Investment_Asset__c>();
		TestData_Ffreedom testData = new TestData_Ffreedom();
		Investment_Asset__c invAsset1 = testData.init_InvestmentAsset(parent,InvestmentAsset__c.getInstance ('Stocks').RecordTypeId__c);
	  	/*Investment_Asset__c invAsset1=new Investment_Asset__c(	Entity__c=parent.id,Script_Name__c='ABCD',
	  	                                                       RecordTypeId=InvestmentAsset__c.getInstance ('Stocks').RecordTypeId__c //Prajakta//'01220000000HYx5AAG'
	  	                                                       ,Quantity__c =100, Current_Price__c=1000);*/
	  	lstInvAsset.add(invAsset1);
	    upsert lstInvAsset;
	    
	  	investAssetCon.selRecordTypeId=InvestmentAsset__c.getInstance ('Stocks').RecordTypeId__c;//Prajakta//'01220000000HYx5AAG';
	  	investAssetCon.selRecordTypeName='Stocks';
	    List<OuterClass>lst=investAssetCon.summaryTableList;
	  	AggregateResult aggregateObj=new DatabaseSOQL().getInvestmentAssetByClass(parent.id,InvestmentAsset__c.getInstance ('Stocks').RecordTypeId__c);//Prajakta//'01220000000HYx5AAG');
	    //system.assertNotEquals(null, aggregateObj);
	    InvestmentAssetBean.getNetworthSummaryDetail(aggregateObj,'Equity Stocks'); 
	  	investAssetCon.showPopUp();
	  	investAssetCon.dummy();
	  	investAssetCon.addNewRow();
	  	investAssetCon.save();
	  	investAssetCon.getOwnerItems();
	  	investAssetCon.closePopUp();
	  	test.stopTest();
	}
	
	public static  testMethod void goldTestData()
	{
	  	Test.startTest();
	  	setupData();
	  	TestData_Ffreedom testData = new TestData_Ffreedom();
		list<Investment_Asset__c> lstInvAsset = new list<Investment_Asset__c>();
		Investment_Asset__c invAsset1 = testData.init_InvestmentAsset(parent,InvestmentAsset__c.getInstance ('Gold and Silver').RecordTypeId__c);
	  	/*Investment_Asset__c invAsset1=new Investment_Asset__c(Entity__c=parent.id,Script_Name__c='ABCD',
	  	                                                       RecordTypeId=InvestmentAsset__c.getInstance ('Gold and Silver').RecordTypeId__c //Prajakta//'01220000000HYx5AAG'
	  	                                                       ,Quantity__c =100, Current_Price__c=1000);*/
	  	lstInvAsset.add(invAsset1);
	    upsert lstInvAsset;
	    
	  	investAssetCon.selRecordTypeId=InvestmentAsset__c.getInstance ('Gold and Silver').RecordTypeId__c;//Prajakta//'01220000000HYx5AAG';
	  	investAssetCon.selRecordTypeName='Gold and Silver';
	    List<OuterClass>lst=investAssetCon.summaryTableList;
	  	AggregateResult aggregateObj=new DatabaseSOQL().getInvestmentAssetByClass(parent.id,InvestmentAsset__c.getInstance ('Gold and Silver').RecordTypeId__c);//Prajakta//'01220000000HYx5AAG');
	    //system.assertNotEquals(null, aggregateObj);
	    InvestmentAssetBean.getNetworthSummaryDetail(aggregateObj,'Equity Gold'); 
	  	investAssetCon.showPopUp();
	  	investAssetCon.dummy();
	  	investAssetCon.addNewRow();
	  	investAssetCon.save();
	  	investAssetCon.getOwnerItems();
	  	investAssetCon.closePopUp();
	  	test.stopTest();
	}
	
	public static  testMethod void mutualFundTestData()
	{
	  	Test.startTest();
	  	setupData();
	  /*	list<Investment_Asset__c> lstFundAsset = new list<Investment_Asset__c>();
	  	Investment_Asset__c invAsset1=new Investment_Asset__c(	Entity__c=parent.id,AMC_Name__c=amc.id,	Fund__c=fund.id,
	  	                                                       RecordTypeId='01220000000HYx4AAG');
	  	lstFundAsset.add(invAsset1);
	  	//upsert invAsset1;
	  	//system.assertNotEquals(null, invAsset1.id);
	  	Investment_Asset__c invAsset2=new Investment_Asset__c(	Entity__c=parent.id,AMC_Name__c=amc.id,	
	  	                                                       RecordTypeId='01220000000HYx4AAG');
	  	lstFundAsset.add(invAsset2);
	  	//upsert invAsset2;
	  	//system.assertNotEquals(null, invAsset2.id);
	  	Investment_Asset__c invAsset3=new Investment_Asset__c(	Entity__c=parent.id,Fund__c=fund.id,
	  	                                                       RecordTypeId='01220000000HYx4AAG');
	  	lstFundAsset.add(invAsset3);
	  	//upsert invAsset3;
	  	//system.assertNotEquals(null, invAsset3.id);
	  	upsert lstFundAsset;
	  	*/
	  	investAssetCon.selRecordTypeId=InvestmentAsset__c.getInstance ('Mutual Fund').RecordTypeId__c;
	  	investAssetCon.selRecordTypeName='Mutual Fund';
	  	List<OuterClass>lst=investAssetCon.summaryTableList;
	    investAssetCon.showPopUp();
	  	investAssetCon.dummy();
	  	investAssetCon.addNewRow();
	  	investAssetCon.save();
	  	investAssetCon.getOwnerItems();
	  	investAssetCon.closePopUp();
	  	test.stopTest();
	}
	
	public static  testMethod void fixedIncomeTestData()
	{
	  	Test.startTest();
	  	setupData();

	  	investAssetCon.selRecordTypeId=InvestmentAsset__c.getInstance('Fixed Income').RecordTypeId__c;
	  	investAssetCon.selRecordTypeName='Fixed Income';
	  	List<OuterClass>lst=investAssetCon.summaryTableList;
	  	investAssetCon.showPopUp();
	  	investAssetCon.dummy();
	  	investAssetCon.addNewRow();
	  	investAssetCon.save();
	  	investAssetCon.getOwnerItems();
	  	investAssetCon.closePopUp();
	  	test.stopTest();
	}
}