/*
	Revision History:
	Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
    2.0			Manasi Ranade	   21/06/2011	Issue id: F0058 :
    											Uncommented code which was throwing an exception.
	  											But now it is working properly.It get resolved in Issue ID F0052
	  											Change is in SetUpGeneralInsuranceData() function 	
	3.0  		Prajakta Sanap     22/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.		  											
*/	
  
@isTest
private class InsuranceSummaryPageControllerTest 
{
  	static InsuranceSummaryPageController InsuranceTest;
 	static Account acc;
	// static Insurance__c insurance;
 
 	public static void ClientsetupData()
 	{
 		TestData_Ffreedom testData = new TestData_Ffreedom();
       	acc = testData.initializeAccount();
      	upsert acc;
       	System.assertNotEquals(null,acc.id);
       	Apexpages.currentPage().getParameters().put('entityId',acc.id);
       	InsuranceTest=new InsuranceSummaryPageController ();
 	}
 	
 	public static testMethod  void SetUpLifeInsuranceData()
 	{
      	Test.startTest();
      	ClientsetupData();
		Insurance__c insurance=new Insurance__c(Entity__c=acc.id,Policy_Type__c='Term Life',Premium_Amount_Rs__c =1000,
                   Premium_Frequency__c='Semi Annual',Tenure_of_Insurance__c=23,Surrender_Cash_Value__c=1000,
                   Commencement_Date__c=system.today(),Next_Premium_Due_Date__c=system.today(), 
                   RecordTypeId=InsuranceRecTypes__c.getInstance ('Life Insurance').RecordTypeId__c); //Prajakta//'01220000000Do0vAAC');
      	insert insurance;
      	System.assertNotEquals(null,insurance);
      
      	Insurance__c insurance1 = new Insurance__c(Entity__c=acc.id,Policy_Type__c='Whole Life',Premium_Amount_Rs__c =1000,
                   Premium_Frequency__c='Semi Annual',Tenure_of_Insurance__c=23,Surrender_Cash_Value__c=1000,
                   Commencement_Date__c=system.today(),Next_Premium_Due_Date__c=system.today(), 
                   RecordTypeId=InsuranceRecTypes__c.getInstance ('Life Insurance').RecordTypeId__c); //Prajakta//'01220000000Do0vAAC');
      	insert insurance1;
      
       	AggregateResult aggregateObj=new DatabaseSOQL().getInsuranceSumByRecordType(acc.id,InsuranceRecTypes__c.getInstance ('Life Insurance').RecordTypeId__c);//Prajakta//'01220000000Do0vAAC');
      	// upsert aggregateObj;
      	system.assertNotEquals(null, aggregateObj);
       	InsuranceBean.getNetworthSummaryDetail(aggregateObj); 
       
      	InsuranceTest.InsuranceBeanObj.selRecordTypeName='Life Insurance';
      	InsuranceTest.InsuranceBeanObj.selRecordTypeId=InsuranceRecTypes__c.getInstance ('Life Insurance').RecordTypeId__c;//Prajakta//'01220000000Do0vAAC';
      	InsuranceTest.InsuranceBeanObj.InsuranceList =InsuranceTest.InsuranceServicesObj.getInsuranceRecords(InsuranceTest.InsuranceBeanObj.selRecordTypeId,InsuranceTest.InsuranceBeanObj.AccountList);
     	// InsuranceTest.InsuranceBeanObj.InsuranceList =new List<Insurance__c>();
      	InsuranceTest.showPopUp();
      	InsuranceTest.save();
      	InsuranceTest.addNewRow(); 
      	InsuranceTest.closePopUp();
      	InsuranceTest.Remove();
      	InsuranceTest.getOwnerItems();
      	test.stopTest();
 	}

 	public static testMethod  void SetUpGeneralInsuranceData()
 	{
      	Test.startTest();
	      /** Eternus Solutions       **/
		  /** Author  : Manasi Ranade **/
		  /** Issue Id: F0058   	   **/
		  /** Date    : 21/06/2011    **/
		  /** Purpose : Uncommented code which was throwing an exception.
		  				But now it is working properly.It get resolved in Issue ID F0052 
		  /****************************************************/  
      	ClientsetupData();
      	Insurance__c insurance=new Insurance__c(Entity__c=acc.id,Policy_Type__c=null,Premium_Amount_Rs__c =1000,
                   Premium_Frequency__c='Semi Annual',Tenure_of_Insurance__c=23,
                   Commencement_Date__c=system.today(),Next_Premium_Due_Date__c=system.today(), 
                   RecordTypeId=InsuranceRecTypes__c.getInstance ('General Insurance').RecordTypeId__c);//Prajakta//'01220000000Do0uAAC');
      	upsert insurance;
      	System.assertNotEquals(null,insurance);
      	InsuranceTest.InsuranceBeanObj.selRecordTypeName='General Insurance';
      	InsuranceTest.InsuranceBeanObj.selRecordTypeId=InsuranceRecTypes__c.getInstance ('General Insurance').RecordTypeId__c;//Prajakta//'01220000000Do0uAAC';
     	InsuranceTest.InsuranceBeanObj.InsuranceList =InsuranceTest.InsuranceServicesObj.getInsuranceRecords(InsuranceTest.InsuranceBeanObj.selRecordTypeId,InsuranceTest.InsuranceBeanObj.AccountList);
      	InsuranceTest.InsuranceBeanObj.InsuranceList =new List<Insurance__c>();
      	InsuranceTest.showPopUp();
      	InsuranceTest.save();
      	InsuranceTest.addNewRow(); 
      	InsuranceTest.closePopUp();
      	InsuranceTest.Remove();
      	InsuranceTest.getOwnerItems();
      	test.stopTest();
 	}
  
  	public static testMethod  void SetUpGeneralInsuranceData1()
  	{
      	Test.startTest();
      	ClientsetupData();
      	Insurance__c insurance=new Insurance__c(Entity__c=acc.id,Policy_Type__c='Term Life',Premium_Amount_Rs__c =null,
                   Premium_Frequency__c='Semi Annual',Tenure_of_Insurance__c=23,
                   Commencement_Date__c=system.today(),Next_Premium_Due_Date__c=system.today(), 
                   RecordTypeId=InsuranceRecTypes__c.getInstance ('General Insurance').RecordTypeId__c);//Prajakta//'01220000000Do0uAAC');
      	upsert insurance;
      	System.assertNotEquals(null,insurance);
      	InsuranceTest.InsuranceBeanObj.selRecordTypeName='General Insurance';
      	InsuranceTest.InsuranceBeanObj.selRecordTypeId=InsuranceRecTypes__c.getInstance ('General Insurance').RecordTypeId__c;//Prajakta//'01220000000Do0uAAC';
     	InsuranceTest.InsuranceBeanObj.InsuranceList =InsuranceTest.InsuranceServicesObj.getInsuranceRecords(InsuranceTest.InsuranceBeanObj.selRecordTypeId,InsuranceTest.InsuranceBeanObj.AccountList);
      	InsuranceTest.InsuranceBeanObj.InsuranceList =new List<Insurance__c>();
      	InsuranceTest.showPopUp();
      	InsuranceTest.save();
      	InsuranceTest.addNewRow(); 
      	InsuranceTest.closePopUp();
      	InsuranceTest.Remove();
      	InsuranceTest.getOwnerItems();
      	InsuranceTest.getTestInsurance();
      	InsuranceTest.setTestInsurance(insurance);
      	test.stopTest();
 	} 
 	
 	public static testMethod  void SetUpGeneralInsuranceData2()
 	{
      	Test.startTest();
      	ClientsetupData();
      	Insurance__c insurance=new Insurance__c(Entity__c=acc.id,Policy_Type__c='Term Life',Premium_Amount_Rs__c =1000,
                   Premium_Frequency__c=null,Tenure_of_Insurance__c=23,
                   Commencement_Date__c=system.today(),Next_Premium_Due_Date__c=system.today(), 
                   RecordTypeId=InsuranceRecTypes__c.getInstance ('General Insurance').RecordTypeId__c);//Prajakta//'01220000000Do0uAAC');
      	upsert insurance;
      	System.assertNotEquals(null,insurance);
      	InsuranceTest.InsuranceBeanObj.selRecordTypeName='General Insurance';
      	InsuranceTest.InsuranceBeanObj.selRecordTypeId=InsuranceRecTypes__c.getInstance ('General Insurance').RecordTypeId__c;//Prajakta//'01220000000Do0uAAC';
     	InsuranceTest.InsuranceBeanObj.InsuranceList =InsuranceTest.InsuranceServicesObj.getInsuranceRecords(InsuranceTest.InsuranceBeanObj.selRecordTypeId,InsuranceTest.InsuranceBeanObj.AccountList);
      	InsuranceTest.InsuranceBeanObj.InsuranceList =new List<Insurance__c>();
      	InsuranceTest.showPopUp();
      	InsuranceTest.save();
      	InsuranceTest.addNewRow(); 
      	InsuranceTest.closePopUp();
      	InsuranceTest.Remove();
      	InsuranceTest.getOwnerItems();
      	test.stopTest();
 	}
 	
 	public static testMethod  void SetUpGeneralInsuranceData3()
 	{
      	Test.startTest();
      	ClientsetupData();
      	Insurance__c insurance=new Insurance__c(Entity__c=acc.id,Policy_Type__c='Term Life',Premium_Amount_Rs__c =1000,
                   Premium_Frequency__c='Semi Annual',Tenure_of_Insurance__c=23,
                   Commencement_Date__c=null,Next_Premium_Due_Date__c=null, 
                   RecordTypeId=InsuranceRecTypes__c.getInstance ('General Insurance').RecordTypeId__c);//Prajakta//'01220000000Do0uAAC');
      	upsert insurance;
      	System.assertNotEquals(null,insurance);
      	InsuranceTest.InsuranceBeanObj.selRecordTypeName='General Insurance';
      	InsuranceTest.InsuranceBeanObj.selRecordTypeId=InsuranceRecTypes__c.getInstance ('General Insurance').RecordTypeId__c;//Prajakta//'01220000000Do0uAAC';
     	InsuranceTest.InsuranceBeanObj.InsuranceList =InsuranceTest.InsuranceServicesObj.getInsuranceRecords(InsuranceTest.InsuranceBeanObj.selRecordTypeId,InsuranceTest.InsuranceBeanObj.AccountList);
      	InsuranceTest.InsuranceBeanObj.InsuranceList =new List<Insurance__c>();
      	InsuranceTest.showPopUp();
      	InsuranceTest.save();
      	InsuranceTest.addNewRow(); 
      	InsuranceTest.closePopUp();
      	InsuranceTest.Remove();
      	InsuranceTest.getOwnerItems();
      	test.stopTest();
 	}
 
 	public static testMethod  void SetUpLifeInsuranceDataEmpty()
 	{
      	Test.startTest();
      	ClientsetupData();
      	Insurance__c insurance=new Insurance__c(Entity__c=acc.id,Policy_Type__c=null,Premium_Amount_Rs__c =null ,
                   Premium_Frequency__c=null,Tenure_of_Insurance__c=null ,
                   Commencement_Date__c= null,Next_Premium_Due_Date__c=null, 
                   RecordTypeId=InsuranceRecTypes__c.getInstance ('Life Insurance').RecordTypeId__c);//Prajakta//'01220000000Do0vAAC');
   		insert insurance;
   		System.assertNotEquals(null,insurance);
      	InsuranceTest.InsuranceBeanObj.selRecordTypeName='Life Insurance';
      	InsuranceTest.InsuranceBeanObj.selRecordTypeId=InsuranceRecTypes__c.getInstance ('Life Insurance').RecordTypeId__c;//Prajakta//'01220000000Do0vAAC';
      	InsuranceTest.InsuranceBeanObj.InsuranceList =new List<Insurance__c>();
      	InsuranceTest.InsuranceBeanObj.AccountList=new list<Account>();
      	InsuranceTest.showPopUp();
      	InsuranceTest.save();
      	InsuranceTest.addNewRow(); 
      	InsuranceTest.closePopUp();
      	InsuranceTest.Remove();
      	InsuranceTest.getOwnerItems();
      	test.stopTest();
 	}

 	public static testMethod  void SetUpGeneralInsuranceDataEmpty()
 	{
      	Test.startTest();
      	ClientsetupData();
      	Insurance__c insurance=new Insurance__c(Entity__c=acc.id,Policy_Type__c=null,Premium_Amount_Rs__c =null ,
                   Premium_Frequency__c=null,Tenure_of_Insurance__c=null ,
                   Commencement_Date__c= null,Next_Premium_Due_Date__c=null, 
                   RecordTypeId=InsuranceRecTypes__c.getInstance ('General Insurance').RecordTypeId__c);//Prajakta//'01220000000Do0uAAC');
   		insert insurance;
   		System.assertNotEquals(null,insurance);
    
      	InsuranceTest.InsuranceBeanObj.selRecordTypeName='General Insurance';
      	InsuranceTest.InsuranceBeanObj.selRecordTypeId=InsuranceRecTypes__c.getInstance ('General Insurance').RecordTypeId__c;//Prajakta//'01220000000Do0uAAC';
      	InsuranceTest.InsuranceBeanObj.InsuranceList =new List<Insurance__c>();
      	InsuranceTest.InsuranceBeanObj.AccountList=new list<Account>();
      	InsuranceTest.showPopUp();
      	InsuranceTest.save();
      	InsuranceTest.addNewRow(); 
      	InsuranceTest.closePopUp();
      	InsuranceTest.Remove();
      	InsuranceTest.getOwnerItems();
      	test.stopTest();
 	}
    
}