/** 
Revision History:
 
*   Version     Version Author     Date         Comments
*   1.0         Manasi Ranade      19-06-2011   GlobalAssumption Insertion related test class
*/

@isTest
private class BatchInsertDefaultGlobalAssumption_Test 
{    
	static BatchInsertDefaultGlobalAssumption_Test objBatchInsertDefaultGlobalAssumption_Test;
	static Account objAccTest;
	static Id idAccount; 
	static List<Entity_Global_Assumption__c> objGlobalAssumptionList;
	static BatchInsertDefaultGlobalAssumption objBatchInsertDefaultGlobalAssumption =new BatchInsertDefaultGlobalAssumption();
	static Id goalId; 
    public static void InsertGlobalAssumptionForParentEntityTestDate()
	{	
		objAccTest = new Account(FirstName='Test_Fname1',LastName='Test_Lname',Entity_Status__c='Active');
		upsert objAccTest;
		system.assertNotEquals(null,objAccTest.id);
		idAccount = objAccTest.id;
		objGlobalAssumptionList = [SELECT Id FROM Entity_Global_Assumption__c WHERE Account__c =: objAccTest.id]; 
		delete objGlobalAssumptionList;
	}
	
	public static void UpdateGlobalAssumptionsTestData()
	{	
		objAccTest = new Account(FirstName='Test_Fname1',LastName='Test_Lname',Entity_Status__c='Active');
		upsert objAccTest;
		system.assertNotEquals(null,objAccTest.id);
		idAccount = objAccTest.id;
		objGlobalAssumptionList = [SELECT Id,Default_Estimated_Life_Expectancy__c,Default_Retirement_Age__c FROM Entity_Global_Assumption__c WHERE Account__c =: objAccTest.id]; 
		for(Entity_Global_Assumption__c objGlobulAssumption : objGlobalAssumptionList)
		{
			objGlobulAssumption.Default_Estimated_Life_Expectancy__c = '0';
			objGlobulAssumption.Default_Retirement_Age__c = '0';
		}
		update objGlobalAssumptionList;
        
	}
	
    static testMethod void BatchInsertDefaultGlobalAssumptionTest() 
    { 
    	 Test.startTest();
    	 //Test Missing Global Assumptions
		 InsertGlobalAssumptionForParentEntityTestDate();
		 objGlobalAssumptionList = [SELECT Id FROM Entity_Global_Assumption__c WHERE Account__c =: idAccount];
		 system.assert(objGlobalAssumptionList.size()==0);
		
		 objBatchInsertDefaultGlobalAssumption.InsertGlobalAssumptionForParentEntity();
		 objGlobalAssumptionList = [SELECT Id FROM Entity_Global_Assumption__c WHERE Account__c =: idAccount];
    	 system.assert(objGlobalAssumptionList.size()==1);
    	 
    	 //Test Updation of Default_Estimated_Life_Expectancy__c and Default_Retirement_Age__c
    	 UpdateGlobalAssumptionsTestData();
    	 objGlobalAssumptionList = [SELECT Id,Default_Estimated_Life_Expectancy__c,Default_Retirement_Age__c FROM Entity_Global_Assumption__c WHERE Account__c =: objAccTest.id];
    	 for(Entity_Global_Assumption__c objGlobulAssumption : objGlobalAssumptionList)
		 {
			System.assert(objGlobulAssumption.Default_Estimated_Life_Expectancy__c == '0');
    	 	System.assert(objGlobulAssumption.Default_Retirement_Age__c == '0');
		 }
		 objBatchInsertDefaultGlobalAssumption.UpdateGlobalAssumptions();
		 objGlobalAssumptionList = [SELECT Id,Default_Estimated_Life_Expectancy__c,Default_Retirement_Age__c FROM Entity_Global_Assumption__c WHERE Account__c =: objAccTest.id];
    	 for(Entity_Global_Assumption__c objGlobulAssumption : objGlobalAssumptionList)
		 {
			System.assert(objGlobulAssumption.Default_Estimated_Life_Expectancy__c == '85');
    	 	System.assert(objGlobulAssumption.Default_Retirement_Age__c == '60');
		 }
    	 Test.stopTest(); 
    }
    
}