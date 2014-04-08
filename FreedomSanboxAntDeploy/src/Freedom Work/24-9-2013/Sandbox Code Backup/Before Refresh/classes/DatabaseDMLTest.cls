/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     25/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class DatabaseDMLTest {

    static testMethod void myUnitTest1() {
       Account acc;
       List<Account>accList;
       try{
       new DatabaseDML().insertObject(acc);
       }
       catch(Exception e){
         ApexPages.addMessages(e);
       }
    }
    static testMethod void myUnitTest2() {
      
       List<Account>accList;
       try{
      
       new DatabaseDML().upsertObject(accList);
       
       }
       catch(Exception e){
         ApexPages.addMessages(e);
       }
    }
        static testMethod void myUnitTest3() {
      
        Account acc;
       try{
      
       new DatabaseDML().upsertObject( acc);
       
       }
       catch(Exception e){
         ApexPages.addMessages(e);
       }
    }
    
     static testMethod void myUnitTest4() {
     	TestData_Ffreedom testData = new TestData_Ffreedom();
		Account acc = testData.initializeAccount();
      
       try{
       new DatabaseDML().insertObject(acc);
        new DatabaseDML().upsertObject( acc);
       }
       catch(Exception e){
         ApexPages.addMessages(e);
       }
    }
  static testMethod void myUnitTest5() {
  	TestData_Ffreedom testData = new TestData_Ffreedom();
		Account acc = testData.initializeAccount();
      
       try{
       new DatabaseDML().insertObject(acc);
        new DatabaseDML().upsertObject( acc);
       }
       catch(Exception e){
         ApexPages.addMessages(e);
       }
    }
  static testMethod void myUnitTest6() {
       List<Account> acc= new List<Account>();
      
       try{
        new DatabaseDML().upsertObject( acc);
       }
       catch(Exception e){
         ApexPages.addMessages(e);
       }
    }
  static testMethod void myUnitTest7() {
       List<Account> acc= new List<Account>();
       TestData_Ffreedom testData = new TestData_Ffreedom();
		Account account = testData.initializeAccount();
       acc.add(account);
      
       try{
        new DatabaseDML().upsertObject( acc);
       }
       catch(Exception e){
         ApexPages.addMessages(e);
       }
    }
  static testMethod void myUnitTest8() {
		TestData_Ffreedom testData = new TestData_Ffreedom();
		Account account = testData.initializeAccount();      
       try{
        new DatabaseDML().upsertObject(account);
       }
       catch(Exception e){
         ApexPages.addMessages(e);
       }
    }
  static testMethod void myUnitTest9() {
       List<Account> acc= new List<Account>();
      
       try{
        new DatabaseDML().upsertObject( acc);
        new DatabaseDML().deleteRecords(acc);
       }
       catch(Exception e){
         ApexPages.addMessages(e);
       }
    }
  static testMethod void myUnitTest10() {
       List<Account> acc;
      
       try{
        new DatabaseDML().deleteRecords(acc);
       }
       catch(Exception e){
         ApexPages.addMessages(e);
       }
    }
}