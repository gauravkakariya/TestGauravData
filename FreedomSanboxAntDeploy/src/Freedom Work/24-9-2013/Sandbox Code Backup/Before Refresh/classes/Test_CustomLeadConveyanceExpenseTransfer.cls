@isTest
private class Test_CustomLeadConveyanceExpenseTransfer {

    static testMethod void myUnitTest() 
    {
        test.startTest();
        //==========================================PlatformUserXRayDetail=========================================================================
    	List<Conveyance_Expense__c> lstConveyanceExpense = new List<Conveyance_Expense__c>();
    	
    	Lead_Platform_User__c Custlead1 = new Lead_Platform_User__c(First_Name__c = 'Platform', Name = 'User', Lead_Status__c = 'Open', Lead_Source__c = 'Web', Mobile__c = '9898989898', Age__c = 23);
    	insert Custlead1;
    	
    	Conveyance_Expense__c objConveyanceExpense1 = new Conveyance_Expense__c();
    	objConveyanceExpense1.Name = 'TestConveyance1';
    	objConveyanceExpense1.Expense_Date__c =  date.today();
    	objConveyanceExpense1.Platform_User_Lead__c = Custlead1.Id;
    	lstConveyanceExpense.add(objConveyanceExpense1);
    	
        Conveyance_Expense__c objConveyanceExpense2 = new Conveyance_Expense__c();
    	objConveyanceExpense2.Name = 'TestConveyance2';
    	objConveyanceExpense2.Expense_Date__c =  date.today();
    	objConveyanceExpense2.Platform_User_Lead__c = Custlead1.Id;
      	lstConveyanceExpense.add(objConveyanceExpense2);
      	
      	Conveyance_Expense__c objConveyanceExpense3 = new Conveyance_Expense__c();
    	objConveyanceExpense3.Name = 'TestConveyance3';
    	objConveyanceExpense3.Expense_Date__c =  date.today();
    	objConveyanceExpense3.Platform_User_Lead__c = Custlead1.Id;
      	lstConveyanceExpense.add(objConveyanceExpense3);
      	
      	insert lstConveyanceExpense;
      	//===================================================================================================================
   	
        //=============================================StandardUserXRayDetail======================================================================
        
        List<Conveyance_Expense__c> lstConveyanceExpense1 = new List<Conveyance_Expense__c>();
    	
    	list<Lead> Leadlst = new list<Lead>();
    	Lead Lead_1 = new Lead(FirstName = 'Original', LastName = 'Lead',Status = 'Open',LeadSource = 'Web', MobilePhone = '9898989898',Platform_User_Lead__c = Custlead1.Id,  Age__c = 23);
    	insert Lead_1;
    	
    	Conveyance_Expense__c objConveyanceExpense4 = new Conveyance_Expense__c();
    	objConveyanceExpense4.Name = 'TestConveyance1';
    	objConveyanceExpense4.Expense_Date__c =  date.today();
    	objConveyanceExpense4.Lead__c = Lead_1.Id;
      	lstConveyanceExpense1.add(objConveyanceExpense4);
      	
      	Conveyance_Expense__c objConveyanceExpense5 = new Conveyance_Expense__c();
    	objConveyanceExpense5.Name = 'TestConveyance1';
    	objConveyanceExpense5.Expense_Date__c =  date.today();
    	objConveyanceExpense5.Lead__c = Lead_1.Id;
    	lstConveyanceExpense1.add(objConveyanceExpense5);
    	
    	Conveyance_Expense__c objConveyanceExpense6 = new Conveyance_Expense__c();
    	objConveyanceExpense6.Name = 'TestConveyance1';
    	objConveyanceExpense6.Expense_Date__c = date.today();
    	objConveyanceExpense6.Lead__c = Lead_1.Id;
    	lstConveyanceExpense1.add(objConveyanceExpense6);
      	
      	insert lstConveyanceExpense1;
    	//===================================================================================================================

        List<Conveyance_Expense__c> lstConveyanceExpense22 = new List<Conveyance_Expense__c>();
    	
    	list<Lead> Leadlst1 = new list<Lead>();
    	Lead Lead_11 = new Lead(FirstName = 'Original', LastName = 'Lead',Status = 'Open',LeadSource = 'Web', MobilePhone = '9898989898', Age__c = 23);
    	insert Lead_11;
    	
    	Conveyance_Expense__c objConveyanceExpense44 = new Conveyance_Expense__c();
    	objConveyanceExpense44.Name = 'TestConveyance1';
    	objConveyanceExpense44.Expense_Date__c =  date.today();
    	//objConveyanceExpense44.Lead__c = Lead_1.Id;
      	lstConveyanceExpense22.add(objConveyanceExpense44);
      	
      	Conveyance_Expense__c objConveyanceExpense55 = new Conveyance_Expense__c();
    	objConveyanceExpense55.Name = 'TestConveyance1';
    	objConveyanceExpense55.Expense_Date__c =  date.today();
    	//objConveyanceExpense55.Lead__c = Lead_1.Id;
    	lstConveyanceExpense22.add(objConveyanceExpense55);
    	
    	Conveyance_Expense__c objConveyanceExpense66 = new Conveyance_Expense__c();
    	objConveyanceExpense66.Name = 'TestConveyance1';
    	objConveyanceExpense66.Expense_Date__c = date.today();
    	//objConveyanceExpense66.Lead__c = Lead_1.Id;
    	lstConveyanceExpense22.add(objConveyanceExpense66);
      	
      	insert lstConveyanceExpense22;
    	//===================================================================================================================


       	test.stopTest();
    }
}