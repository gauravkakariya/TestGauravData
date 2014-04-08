@isTest
private class ConveyanceControllerTest {
	
	static testmethod void testConveyanceManager(){
		test.startTest();
		/*
		// Use the vf page in my org named 'locatorDetails'
        PageReference pageRef = Page.locatorDetails;
        Test.setCurrentPage(pageRef);

        // Set the id of the current vf page to a Property__c record that I know has child Suite__c and Spec_Sheet__c records
        ApexPages.currentPage().getParameters().put('id', p.Id);
        TestMyPropertyExtension controller = new TestMyPropertyExtension();
		*/
		
		string strCOnManId = ConveyanceControllerTest.CreateTestDate();
		PageReference pageRef = Page.ConveyanceManager;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id', strCOnManId);
		
		ConveyanceController objConveyanceController = new ConveyanceController();
		objConveyanceController.save();
		objConveyanceController.AddMore();
		objConveyanceController.Remove();
		test.stopTest();
	}
	
	static testmethod void testConveyanceManagerSubmit(){
		test.startTest();
		string strConManagerData = ConveyanceControllerTest.CreateTestDate();
		PageReference pageRef = Page.ConveyanceManager;
        Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id', strConManagerData);
		
		ConveyanceController objConveyanceController = new ConveyanceController();
		objConveyanceController.Submit();
		objConveyanceController.Cancel();
		
		test.stopTest();
	}
	
	static testmethod void testConveyanceManagerConstructor(){
	 test.startTest();
	 	ConveyanceController objConveyanceController = new ConveyanceController();
	 test.stopTest();
	}
	
	private static string CreateTestDate()
	{
		string strManagerId;
		
		Event__c objEvent = New Event__c();
		insert objEvent;
		
		Conveyance_Manager__c objConManager = new Conveyance_Manager__c();
		objConManager.Amount_Reimbursed__c = 10;
		objConManager.Date_of_Travel__c = System.today();
		objConManager.Event__c = objEvent.id;
		objConManager.Remarks__c = 'Test Remark';
		insert objConManager;
		
		Conveyance_Detail__c objDetailPoint = new Conveyance_Detail__c(); 
		objDetailPoint.Amount__c = 1000;
		objDetailPoint.Bill_Details__c = 'Bill Details';
		objDetailPoint.Conveyance_Manager__c = objConManager.id;
		objDetailPoint.Is_Bill_Available__c = true;
		objDetailPoint.Remarks__c = 'My Test Remarks';
		insert objDetailPoint;
		
		Conveyance_Detail__c objDetailPoint2 = new Conveyance_Detail__c(); 
		objDetailPoint2.Amount__c = 1000;
		objDetailPoint2.Bill_Details__c = 'Bill Details';
		objDetailPoint2.Conveyance_Manager__c = objConManager.id;
		objDetailPoint2.Is_Bill_Available__c = true;
		objDetailPoint2.Remarks__c = 'My Test Remarks';
		insert objDetailPoint2;
		
		return objConManager.id;
	}
}