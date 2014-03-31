/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     23/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/

@isTest
private class EstatePlanningControllerTest 
{
    
	static EstatePlanningController estatePlanning;
	static Account acc;
	static Account spouse;
 
	public static void testData()
	{
       	TestData_Ffreedom testData = new TestData_Ffreedom();
		acc = testData.initializeAccount();
       	/*acc=new Account(LastName='ABC',FirstName='PQR',Adjustment_Factor__c='2',PersonBirthdate=system.today(),Alternate_Mobile__c='653698',PersonEmail='dgh@hj.com',Alternate_E_Mail_Address__c='bvhu@ldsf.com', Fax='6343784',Office_Phone_2__c='634553',
                          Retirement_Year__c=2030,Residential_Status_del__c='yes',Retirement_Age__c='56',Estimated_Life_Expectancy__c='85',Estimated_Life_EndYear__c=2010,BillingCity='hgft',BillingCountry='gdfjey',BillingPostalCode='6756',BillingState='gfsjy',PersonMailingCity='sey',PersonMailingCountry='sgdsh',
                          PersonMailingPostalCode='746347',PersonMailingState='dgsd',PersonOtherCity='fghrty',PersonOtherCountry='hdfsgd',PersonOtherPostalCode='6347',PersonOtherState='dgjhe',
                          BillingStreet='fhgdhgf',PersonMailingStreet='sdfhsgd',Relationship_to_Entity__pc='husband',PersonOtherStreet='hfdgs',Will__c=false,
                          RecordTypeId=RecTypes__c.getInstance ('AccountClient').Record_Type_Value__c); //Prajakta//'01220000000DnK3AAK');*/
       	upsert acc;
       	system.assertNotEquals(null,acc);
    }
	
	public static testMethod void estatePlanningTest()
	{
	    Test.startTest();
	    testData();
	    Apexpages.currentPage().getParameters().put('entityId',acc.id);
	    estatePlanning=new EstatePlanningController();
	    TestData_Ffreedom testData = new TestData_Ffreedom();
		//spouse = testData.init_FamilyMember(acc);
		//spouse.Relationship_to_Entity__pc = 'Wife';
	    spouse=new Account(FirstName='ACD',LastName='GHJ',Estimated_Life_Expectancy__c='67',Relationship_to_Entity__pc='wife',PersonBirthdate=system.today());
	    upsert spouse;
	    system.assertNotEquals(null,spouse);
	    test.stopTest();
    }
    
    public static testMethod void estatePlanningTest1()
    {
	    Test.startTest();
	  //  testData();
	    Apexpages.currentPage().getParameters().put('entityId',null);
	     
	    estatePlanning=new EstatePlanningController();
	    //system.assertEquals(null,estatePlanning.entityId);
	   // spouse=new Account(FirstName='ACD',LastName='GHJ',Estimated_Life_Expectancy__c='67',Relationship_to_Entity__pc='wife',PersonBirthdate=system.today());
	   // upsert spouse;
	   // system.assertNotEquals(null,spouse);
	   test.stopTest();
	}
}