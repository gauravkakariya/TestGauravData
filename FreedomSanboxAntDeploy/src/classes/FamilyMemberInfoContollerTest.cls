/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     23/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class FamilyMemberInfoContollerTest 
{
    
 	static FamilyMemberInfoContoller fmInfoCon;
 	static FamilyMemberDetailController fmDetailCon;
 	static  DatabaseDML dmlobj;
 	static Account acc;
 	static Account acc1;
 	static Account child;
 	static String childId;
 // static Account account;
	static FamilyMemberInfoService fmService;

	public static void parentData()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
		acc = testData.initializeAccount();
		acc.PAN_ID__pc = 'ABCDS5555M';
    	upsert acc;
    	system.assertNotEquals(null,acc);
     	Apexpages.currentPage().getParameters().put('entityId',acc.id);
     	
     	child = testData.init_FamilyMember(acc);
    	upsert child;
    	system.assert(child!=null);
 	}
	
	
	
	public static void testParent1()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
		acc1 = testData.initializeAccount();
		acc1.PAN_ID__pc = 'adlaa5455D';
    	upsert acc1;
    	system.assertNotEquals(null,acc1);
     	Apexpages.currentPage().getParameters().put('entityId',acc1.id);
 	}
	
	public static void testParent2()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
		acc1 = testData.initializeAccount();
		acc1.PAN_ID__pc = 'aaaaa5455S';
    	upsert acc1;
    	system.assertNotEquals(null,acc1);
    	Apexpages.currentPage().getParameters().put('entityId',acc1.id);
 	}
 	
 	public static void testParent3()
 	{
 		TestData_Ffreedom testData = new TestData_Ffreedom();
		acc1 = testData.initializeAccount();
		acc1.PAN_ID__pc = 'aaa6a5455R';
    	upsert acc1;
    	system.assertNotEquals(null,acc1);
      	Apexpages.currentPage().getParameters().put('entityId',acc1.id);
 	}
 	
 	public static void testParent4()
 	{
 		TestData_Ffreedom testData = new TestData_Ffreedom();
		acc1 = testData.initializeAccount();
		acc1.PAN_ID__pc = 'aaada5455T';
    	upsert acc1;
    	system.assertNotEquals(null,acc1);
      	Apexpages.currentPage().getParameters().put('entityId',acc1.id);
 	}
 
 	public static void ClientsetupData()
 	{
 		TestData_Ffreedom testData = new TestData_Ffreedom();
		acc1 = testData.initializeAccount();
		acc1.PAN_ID__pc = 'aaaaa5555H';
	    upsert acc1;
	    system.assertNotEquals(null,acc1); // Samir
	    
	    
	    dmlobj=new DatabaseDML();
    	ApexPages.StandardController stdController= new ApexPages.StandardController(acc1);
    	Apexpages.currentPage().getParameters().put('RecType',RecTypes__c.getInstance('AccountClient').Record_Type_Value__c);
    	Apexpages.currentPage().getParameters().put('entityId',acc1.Id);
    	fmInfoCon=new FamilyMemberInfoContoller(stdController);
    	fmDetailCon=new FamilyMemberDetailController(stdController);
    	fmService = new FamilyMemberInfoService();
     }

	public static void childSetupData()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
		acc = testData.initializeAccount();
		acc.PAN_ID__pc = 'aahfa5455J';
	    upsert acc;
	    system.assertNotEquals(null,acc); // Samir
	    child = testData.init_FamilyMember(acc);
	    upsert child;
	    system.assert(child!=null);
	    Apexpages.currentPage().getParameters().put('fentityId',child.id);
	    //Apexpages.currentPage().getParameters().put('RecType','family');
	    Apexpages.currentPage().getParameters().put('RecType',RecTypes__c.getInstance('AccountFamily').Record_Type_Value__c);
	    Apexpages.currentPage().getParameters().put('entityId',acc.Id);
	    ApexPages.StandardController stdController= new ApexPages.StandardController(child);
	    fmInfoCon=new FamilyMemberInfoContoller(stdController);
	    fmDetailCon=new FamilyMemberDetailController(stdController);
	    fmDetailCon.acc.add(new Account());
	     
	    fmInfoCon.DeleteRecords(); 
	     
	    
	    
    }
     
  	public static testMethod void saveTest1()
  	{
   		Test.startTest();
   		testParent1(); 
   		ClientsetupData();   
     	fmInfoCon.save();
     	test.stopTest();
   	}
	public static testMethod void saveTest2(){
	   	Test.startTest();
   		testParent2();
	    ClientsetupData();   
     	fmInfoCon.save();
     	test.stopTest();
   	} 
    public static testMethod void saveTest3(){
   		Test.startTest();
   		testParent3();
   		ClientsetupData();   
     	fmInfoCon.save();
     	test.stopTest();
   	}
/*    public static testMethod void saveTest4(){
	   	Test.startTest();
	   	testParent4();
	   	ClientsetupData(); 
	   	
	   	TestData_Ffreedom testData = new TestData_Ffreedom();
		acc = testData.initializeAccount();
		Account fm = testData.init_FamilyMember(acc);
		acc.PAN_ID__pc = 'aahfa5435J';
	   	acc.Retirement_Year__c = 0;
	   	acc.Estimated_Life_EndYear__c = 0;
	   	fm.Dependent__c = acc.id;
	   	//acc.Retirement_Age__c = null;
	   	upsert fm;
	   	upsert acc;
     	fmInfoCon.save();
     	fmInfoCon.getFamilyMembers();	//Prajakta
     	test.stopTest();
   	}*/
  /*	public static testMethod  void clientTest(){
        Test.startTest();
        parentData();
        ClientsetupData();   
        fmInfoCon.save();
        fmDetailCon.save();
        fmDetailCon.cancel();   
        fmInfoCon.Cancel();
         //Apexpages.currentPage().getParameters().put('fentityId',child.id);
        //Please Uncomment fmInfoCon.saveNext();
        fmDetailCon.Next();
        fmDetailCon.AddNewMember();
        test.stopTest();
  	}*/
 	public static testMethod  void childTest(){
        Test.startTest();
        childSetupData();   
        fmInfoCon.save();
        //Please Uncomment 
        //fmInfoCon.saveNext();
        test.stopTest();
  	}
  	public static testMethod  void childTest_1(){
        Test.startTest();
        childSetupData();   
        //fmInfoCon.save();
          fmInfoCon.saveNext();
        test.stopTest();
  	}
  /*	public static testMethod  void chlidSaveNextTest(){
        Test.startTest();
        parentData();
        //ClientsetupData();  
        Apexpages.currentPage().getParameters().put('entityId',acc.id);
        Apexpages.currentPage().getParameters().put('fentityId',child.id);
        fmInfoCon.saveNext();
        //fmService.saveNext(acc.id, child.Id);
        test.stopTest();
  	}*/
  	/*public static testMethod  void chlidSaveNextTest_1(){
        Test.startTest();
        parentData();
        //ClientsetupData();  
        Apexpages.currentPage().getParameters().put('entityId',acc.id);
        Apexpages.currentPage().getParameters().put('fentityId',child.id);
       // fmInfoCon.saveNext();
        fmService.saveNext(acc.id, child.Id);
        test.stopTest();
  	}*/
  	
  	
  	public static testMethod void FA()
  	{
  		Test.startTest();
  		TestData_Ffreedom testData = new TestData_Ffreedom();
      	Account parent = new Account();
        parent = testData.initializeAccount();
        insert parent;
        List<Financial_Account__c> lstFA = new List<Financial_Account__c>();
        Financial_Account__c objFinancialAccount = new Financial_Account__c(Account__c=parent.Id, Bank_Name__c = 'HDFC');
        lstFA.add(objFinancialAccount);
        system.debug('-----objFinancialAccount------'+objFinancialAccount);
        insert lstFA;
	    system.debug('-----lstFA------'+lstFA);
    	fmService = new FamilyMemberInfoService();
        fmService.assignAccountIds(parent.id, lstFA);
        
        test.stopTest(); 
  	}
          
  /*  public static testMethod  void clientSaveNextTest(){
        Test.startTest();
        parentData();
        ClientsetupData();  
        fmInfoCon.saveNext();
        test.stopTest();
  	}*/
  /*	public static testMethod void setDetailSave(){
  		Test.startTest();
  		parentData();
  		//ClientsetupData(); 	
  		//fmDetailCon.acc.add(account);
  	 	fmDetailCon.acc.add(new Account(FirstName='First',LastName='last')); 
  		fmDetailCon.save();
  		Test.stopTest();
  	}*/
   	public static testMethod void setDetailSave1(){
	  	Test.startTest();
	  	//parentData();
	  	ClientsetupData(); 	
	  	//fmDetailCon.acc.add(account);
  	 	fmDetailCon.acc.add(new Account(LastName='last')); 
  		fmDetailCon.save();
  		Test.stopTest();
  	}
 /* 	public static testMethod  void AddDetailsTest(){
	    Test.startTest();
     	ClientsetupData(); 
     	//childSetupData();
     	//Apexpages.currentPage().getParameters().put('accid',child.id);
     	Apexpages.currentPage().getParameters().put('parentAcc',acc.id);
     	//fmDetailCon.AddDetails();
      	test.stopTest();
  	}*/
  	public static testMethod  void AddDetailsTest1(){
	    Test.startTest();
     	//ClientsetupData(); 
     	childSetupData();
     	Apexpages.currentPage().getParameters().put('accid',child.id);
     	//Apexpages.currentPage().getParameters().put('parentAcc',acc.id);
     	fmDetailCon.AddDetails();
      	test.stopTest();
  	}
   	public static testMethod  void addNewRowBankTest(){
        	Test.startTest();
        ClientsetupData();  
        Apexpages.currentPage().getParameters().put('financialRecordType',Label.bankAccount);  
        fmInfoCon.addNewRow();
        test.stopTest();
  	}	
   	public static testMethod  void addNewRowDematTest(){
        Test.startTest();
        ClientsetupData();    
        Apexpages.currentPage().getParameters().put('financialRecordType',Label.dematAccount);
        fmInfoCon.addNewRow();
        test.stopTest();
	}
	public static void ClientsetupDataClient()
 	{
 		TestData_Ffreedom testData = new TestData_Ffreedom();
		acc1 = testData.initializeAccount();
		acc1.PAN_ID__pc = 'aaaaa5555H';
	    upsert acc1;
	    system.assertNotEquals(null,acc1); // Samir
	    
	    
	    dmlobj=new DatabaseDML();
    	ApexPages.StandardController stdController= new ApexPages.StandardController(acc1);
    	Apexpages.currentPage().getParameters().put('RecType','client');
        Apexpages.currentPage().getParameters().put('entityId',acc1.Id);
    	fmInfoCon=new FamilyMemberInfoContoller(stdController);
    	fmDetailCon=new FamilyMemberDetailController(stdController);
    	fmService = new FamilyMemberInfoService();
     }
	public static testMethod  void rctypeClient(){
        Test.startTest();
        ClientsetupDataClient();    
        test.stopTest();
        
	}
}