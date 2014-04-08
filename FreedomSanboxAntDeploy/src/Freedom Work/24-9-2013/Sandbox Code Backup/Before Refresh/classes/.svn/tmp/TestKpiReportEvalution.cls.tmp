/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     23/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class TestKpiReportEvalution 
{
	static testMethod void KpiReportEvalutionTest() 
    {
    	Test.startTest();
    	ID ProfileID = [ Select id from Profile where name = 'Financial Planner'].id;
    	ID RoleID = [ Select id from UserRole  where name = 'Fps [MAEGAN MUMBAI]'].id;
    	ID ProfileID1 = [ Select id from Profile where name = 'Financial Planner'].id;
    	User objUser = [select id,Name,UserRoleId, ProfileId from User where UserRoleId = : RoleID and ProfileId = :ProfileID  limit 1];
    	
    	TestData_Ffreedom testData = new TestData_Ffreedom();
		
    	List<Account> updateList= new List<Account>();
		List<Account> accounts =new List<Account>();
		
		Account act1 = testData.initializeAccount();
		act1.PAN_ID__pc = '1212w2asas';
		accounts.add(act1);
		Account act2 = testData.initializeAccount();
		act2.PAN_ID__pc = '1212e2asas';
		accounts.add(act2);
		Account act3 = testData.initializeAccount();
		act3.PAN_ID__pc = '1212r2asas';
		accounts.add(act3);
		Account act4 = testData.initializeAccount();
		act4.PAN_ID__pc = '121t12asas';
		accounts.add(act4);
		Account act5 = testData.initializeAccount();
		act5.PAN_ID__pc = '1212y2asas';
		accounts.add(act5);
		Account act6 = testData.initializeAccount();
		act6.PAN_ID__pc = '1f121uasas';
		accounts.add(act6);
        
        insert accounts;
        
        Date dtDate = System.today();
    	
    	
    	KPIReportEvaluation testObjKpi = new  KPIReportEvaluation(objUser.Id,dtDate);
       	testObjKpi.getKPIReports();
       	
       	Test.stopTest();
    }
    
}