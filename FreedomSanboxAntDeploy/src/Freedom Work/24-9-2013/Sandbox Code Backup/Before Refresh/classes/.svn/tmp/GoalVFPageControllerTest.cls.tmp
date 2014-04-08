/*
	Revision History:
	Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
	2.0  		Prajakta Sanap     19/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.		  											
*/

@isTest
private class GoalVFPageControllerTest {

    static GoalVFPageController GoalTest;
    static DatabaseDML dmlobj;
    static DatabaseSOQL soqlobj;
    static Account acc;
    static Goal__c goal;
    
    public static void ClientsetupData()
    {
    	TestData_Ffreedom testData = new TestData_Ffreedom();
    	dmlobj = new DatabaseDML();
        soqlobj = new DatabaseSOQL();
        acc = testData.initializeAccount();
        upsert acc;
        System.assertNotEquals(null,acc);
        
        Goal_Profile__c goalProfile = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
        insert goalProfile;
        goal = testData.initialize_Goal(acc, 'Marriage', goalProfile);
        upsert goal;
        System.assertNotEquals(null,goal);
        Apexpages.currentPage().getParameters().put('entityId',acc.id);
       	Entity_Global_Assumption__c objGA = [select Id, No_of_Goals__c from Entity_Global_Assumption__c where Account__c =: acc.Id limit 1];
	   	objGA.No_of_Goals__c = 2;
	   	update objGA;
        GoalTest = new GoalVFPageController ();
    }
    
    public static void ClientSetUpDataEmptyNullRecord()
    {
    	TestData_Ffreedom testData = new TestData_Ffreedom();
        dmlobj = new DatabaseDML();
        soqlobj=new DatabaseSOQL();
        acc = testData.initializeAccount();
        upsert acc;
        System.assertNotEquals(null,acc);
       
        Apexpages.currentPage().getParameters().put('entityId',acc.id);
        Entity_Global_Assumption__c objGA = [select Id, No_of_Goals__c from Entity_Global_Assumption__c where Account__c =: acc.Id limit 1];
	   	objGA.No_of_Goals__c = 2;
	   	update objGA;
        GoalTest=new GoalVFPageController ();
    } 
	
	public static void ClientSetUpDataEmptyNullRecord1()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
        dmlobj=new DatabaseDML();
        soqlobj=new DatabaseSOQL();
        acc = testData.initializeAccount();
        upsert acc;
        System.assertNotEquals(null,acc);
        
        Goal_Profile__c goalProfile = testData.initialize_GoalProfile(acc, 'Aggressive', 'Customized');
        insert goalProfile;
        goal = testData.initialize_Goal(acc, 'Marriage', goalProfile);
        upsert goal;
        System.assertNotEquals(null,goal);
        
        Apexpages.currentPage().getParameters().put('entityId',acc.id);
        Entity_Global_Assumption__c objGA = [select Id, No_of_Goals__c from Entity_Global_Assumption__c where Account__c =: acc.Id limit 1];
	   	objGA.No_of_Goals__c = 2;
	   	update objGA;
        GoalTest=new GoalVFPageController ();
    } 
    
    public static testMethod void goalVfTest()
    {
        Test.startTest();
        ClientsetupData();    
        GoalTest.getIsAddedNew();
        GoalTest.addNewRow();
        GoalTest.addNewRowFromView();
        GoalTest.Save();
        GoalTest.SaveFromView();
        goalTest.Remove();
        goaltest.edit();
        GoalTest.closePopUp();
        test.stopTest();
    }
    
    public static testMethod void goalVfTest1()
    {
            Test.startTest();
           ClientSetUpDataEmptyNullRecord();    
            GoalTest.getIsAddedNew();
            GoalTest.addNewRow();
            GoalTest.addNewRowFromView();
            GoalTest.Save();
            GoalTest.SaveFromView();
            goalTest.Remove();
            goaltest.edit();
            GoalTest.closePopUp();
            test.stopTest();
       }
         public static testMethod void goalVfTest2(){
            Test.startTest();
           ClientSetUpDataEmptyNullRecord1();    
            GoalTest.getIsAddedNew();
            GoalTest.addNewRow();
            GoalTest.addNewRowFromView();
            GoalTest.Save();
            GoalTest.SaveFromView();
            goalTest.Remove();
            goaltest.edit();
            GoalTest.closePopUp();
            test.stopTest();
       }
   
      /* public static testMethod void ClientSetUpDataEmptyNullRecordEmpty(){
            Test.startTest();
            ClientSetUpDataEmptyNullRecord();    
            GoalTest.closePopUp();
            test.stopTest();
       }
      public static testMethod  void saveTest(){
            Test.startTest();
            ClientsetupData();    
            GoalTest.save();
            test.stopTest();
       } 
   
      public static testMethod  void ClientSetUpDataNullRecordTest(){
            Test.startTest();
            ClientSetUpDataEmptyNullRecord();    
            GoalTest.save();
            test.stopTest();
      } 
      public static testMethod  void savefromViewTest(){
            Test.startTest();
            ClientsetupData();    
            GoalTest.SaveFromView();
            test.stopTest();
       } 
  
      public static testMethod  void ClientSetUpDataEmptyNullRecordTest(){
            Test.startTest();
            ClientSetUpDataEmptyNullRecord();    
            GoalTest.SaveFromView();
            test.stopTest();
      }  
      public static testMethod  void addNewRowTest(){
            Test.startTest();
            ClientsetupData();    
            GoalTest.addNewRow();
            test.stopTest();
      }
   
      public static testMethod  void ClientSetUpDataEmptyNullRecordEmptyTest(){
            Test.startTest();
            ClientSetUpDataEmptyNullRecord();    
            GoalTest.addNewRow();
            test.stopTest();
      }
      public static testMethod  void addNewRowFromViewTest(){
            Test.startTest();
            ClientsetupData();    
            GoalTest.addNewRowFromView();
            test.stopTest();
      }
   
      public static testMethod  void ClientSetUpDataNullRecordEmptyTest(){
            Test.startTest();
            ClientSetUpDataEmptyNullRecord();    
            GoalTest.addNewRowFromView();
            test.stopTest();
      }
      public static testMethod  void editTest(){
            Test.startTest();
            ClientsetupData();    
            GoalTest.edit();
            test.stopTest();
      }
   
      public static testMethod  void ClientSetUpDataNullRecordDataTest(){
            Test.startTest();
            ClientSetUpDataEmptyNullRecord();    
            GoalTest.edit();
            test.stopTest();
      }
      public static testMethod  void RemoveTest(){
            Test.startTest();
            ClientsetupData();    
            GoalTest.Remove();
            test.stopTest();
      }
   
      public static testMethod  void ClientSetUpDataEmptyNullRecordEmptyDataTest(){
            Test.startTest();
            ClientSetUpDataEmptyNullRecord();    
            GoalTest.Remove();
            test.stopTest();
      }*/
 }