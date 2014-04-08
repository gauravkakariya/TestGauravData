@isTest
private class BeforeDeleteOnAccountControllerTest 
{
    public static testMethod void productsInitialPageLoadTest()
    {
    	//Create an instance of the AddProducts controller
        BeforeDeleteOnAccountController Controller = new BeforeDeleteOnAccountController();
        
        Id clientRecId=RecTypes__c.getInstance('AccountClient').Record_Type_Value__c;
	 	Account act = new Account(FirstName='ABC',LastName='XYZ',RecordTypeId=clientRecId);
	 	insert act;
	 	
	 	Action_Plan__c objActionPlan = new Action_Plan__c();
	 	objActionPlan.Name= 'ac';
	 	objActionPlan.First_Holder_Name__c = act.Id;
	 	objActionPlan.Investment_Amount__c = 200;
	 	insert objActionPlan;
	 	
	 	Checklist__c checklist = new Checklist__c();
	 	checklist.Entity__c = act.Id;
	 	insert checklist;
	 	
	 	Client_Details__c objClientDetails  = new Client_Details__c();
	 	objClientDetails.Entity__c = act.Id;
	    insert 	objClientDetails;
	    
	    Conveyance_Expense__c objConveyanceExpense = new Conveyance_Expense__c();
	    objConveyanceExpense.Entity_Name__c = act.Id;
	    objConveyanceExpense.Expense_Date__c = Date.today();
	    objConveyanceExpense.Name= 'abcTest';
	    insert objConveyanceExpense;
	    
	    Expense__c objExepense = new Expense__c();
	    objExepense.Entity_Name__c = act.Id;
	    insert objExepense;
	    
	    Goal_Profile__c objGoalProfile = new Goal_Profile__c();
	    objGoalProfile.Account__c = act.Id;
	    insert objGoalProfile;
	    
	    Opportunity objOpportunity = new Opportunity ();
	    objOpportunity.AccountId = act.Id;
	    objOpportunity.Name = 'TestOPP';
	    objOpportunity.CloseDate = Date.today();
	    objOpportunity.StageName = 'Intersted';
	    insert objOpportunity;
	    
	    Case objCase  = new Case();
	    objOpportunity.AccountId = act.Id;
	    insert objCase;
	    
        //List<Sobject> lstObjToBeDelete = new List<Sobject>();
        
        test.startTest();	
        set<Id> accountId = new set<Id>();
        accountId.add(act.id);
        BeforeDeleteOnAccountController.DeleteEntityRelatedRecords(accountId);
       
        //Begin test
       
        
        //delete lstObjToBeDelete;
        //delete act;
       
        test.stopTest();			//End test
    }
}