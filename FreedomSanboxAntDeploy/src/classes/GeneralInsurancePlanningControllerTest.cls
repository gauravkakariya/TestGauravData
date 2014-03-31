@isTest
private class GeneralInsurancePlanningControllerTest 
{
	static GeneralInsurancePlanningController generalInsurancePlanning;
	static Account acc;
 	TestData_Ffreedom testData = new TestData_Ffreedom();
 	
	public static void testData()
	{
       	TestData_Ffreedom testData = new TestData_Ffreedom();
        acc = testData.initializeAccount(); 
    	upsert acc;
       	system.assertNotEquals(null,acc);
       
       	Insurance__c ins = testData.initialize_GeneralInsurance(acc,'Medical', 'Data Entry');
        upsert ins;
        system.assertNotEquals(null,ins.id);
        Apexpages.currentPage().getParameters().put('entityId',acc.id);
        generalInsurancePlanning=new GeneralInsurancePlanningController();
	}
	
	public static void testUsedData()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
       	acc = testData.initializeAccount();
       	upsert acc;
       	system.assertNotEquals(null,acc);
       
       	List<Insurance__c> lstGI = new List<Insurance__c>();
       	Insurance__c insurance1 = testData.initialize_GeneralInsurance(acc,'Medical', 'Data Entry');
        lstGI.add(insurance1);
        Insurance__c insurance2 = testData.initialize_GeneralInsurance(acc,'Vehicle', 'Data Entry');
        lstGI.add(insurance2);
        Insurance__c insurance3 = testData.initialize_GeneralInsurance(acc,'Medical', 'Analysis');
        lstGI.add(insurance3);
        Insurance__c insurance4 = testData.initialize_GeneralInsurance(acc,'Vehicle', 'Analysis');
        lstGI.add(insurance4);
        upsert lstGI; 
        system.assertNotEquals(null,insurance1.id);
        system.assertNotEquals(null,insurance2.id);
        system.assertNotEquals(null,insurance3.id);
        system.assertNotEquals(null,insurance4.id);
        
      	Apexpages.currentPage().getParameters().put('entityId',acc.id);
      	generalInsurancePlanning=new GeneralInsurancePlanningController();
	}
	
	public static testMethod void generalInsurancePlanTest()
	{
	    Test.startTest();
	    testData();
	    generalInsurancePlanning.getInsuredItems();
	    generalInsurancePlanning.getPolicyTypeItems();
	    generalInsurancePlanning.save();
	    generalInsurancePlanning.cancel();
	    
	    test.stopTest();
	}
	
	public static testMethod void generalInsurancePlan2Test()
	{
	    Test.startTest();
	    testUsedData();
	    generalInsurancePlanning.getInsuredItems();
	    generalInsurancePlanning.getPolicyTypeItems();
	    generalInsurancePlanning.save();
	    generalInsurancePlanning.cancel();
	    
	    test.stopTest();
	}
}