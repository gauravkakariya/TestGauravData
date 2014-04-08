public with sharing class HandlerForParentForExpense
{
	static Boolean flag=true;
   // public Integer count=0;
     
	public void beforeExpenseInsert(List<Expense__c> lstExpense)
	{
		system.debug('==================================================' + lstExpense);
		Map<String , List<Expense__c>> mapPortalIdAndList = new Map<String , List<Expense__c> >();
		Map<String , List<Expense__c>> mapNewPortalIdAndList = new Map<String , List<Expense__c> >();
  
		for(Expense__c objExpense : lstExpense)
		{		
						if(objExpense.Portal_Parent_Entity__c != NULL )			
								{			   
					 				if(!mapPortalIdAndList.containsKey(objExpense.Portal_Parent_Entity__c))
									{
										mapPortalIdAndList.put(objExpense.Portal_Parent_Entity__c , new List<Expense__c>{objExpense});
										
									}
									else
									{
										mapPortalIdAndList.get(objExpense.Portal_Parent_Entity__c).add(objExpense);
										
									}

									if(!mapNewPortalIdAndList.containsKey(objExpense.Portal_Id__c))
									{
										mapNewPortalIdAndList.put(objExpense.Portal_Id__c , new List<Expense__c>{objExpense});
									}
									else
									{
										mapNewPortalIdAndList.get(objExpense.Portal_Id__c).add(objExpense);
									}
								}   
		}
		
		
		List<Account> lstAccount = new List<Account>([select id, Portal_Id__c , Name  from Account where Portal_Id__c IN: mapPortalIdAndList.keySet()]);
		List<Expense__c> lstExp = new List<Expense__c>([select Portal_Id__c from Expense__c where Portal_Id__c IN: mapNewPortalIdAndList.keySet()]);
		
		
			Set<String> foundIdSet = new Set<String>();
		    for(Expense__c exp:lstExp){
			foundIdSet.add(exp.Portal_Id__c);
		}
		
		
		//if(lstExp.isEmpty()){
		for(Account objAccount : lstAccount )
		{
			if(mapPortalIdAndList != null && mapPortalIdAndList.containsKey(objAccount.Portal_Id__c) && mapPortalIdAndList.get(objAccount.Portal_Id__c) != null)
			{
				for(Expense__c objExpense : mapPortalIdAndList.get(objAccount.Portal_Id__c))
				{
					if(foundIdSet.contains(objExpense.Portal_Id__c)){
						objExpense.Entity_Name__c =null;
					}	
					else {
				           if(objAccount.Id != null)
				   		   objExpense.Entity_Name__c = objAccount.Id;
					}
				   		
				} 
			}
		}
		//}
	}
	
	
	public void beforeUpdateExpense(List<Expense__c> lstNewExpense, List<Expense__c> lstOldExpense)
	{
		for(Expense__c objNewExpense : lstNewExpense)
		{
			for(Expense__c objOldExpense : lstOldExpense)
		    {
			   if(objOldExpense.From_Portal__c == 1 && objNewExpense.Synched_Date_Time__c >= objOldExpense.LastModifiedDate )
			   {
				  objNewExpense.From_Portal__c = 0;
				  objNewExpense.IsSynched__c = true;
			   }
			   else if(objOldExpense.From_Portal__c == 1 && objNewExpense.Synched_Date_Time__c < objOldExpense.LastModifiedDate )
			   {
				  objNewExpense.From_Portal__c = 0;
				  objNewExpense.IsSynched__c = false;
			   }
			   else if(objNewExpense.From_Portal__c == 0)
			   {
			   	 objNewExpense.IsSynched__c = false;
			   }
			   }
			
		   }
		   
	}
	
	
	 @IsTest(seealldata = true) 
      public static void testCoverage() 
      {
      	 TestData_Ffreedom testData = new TestData_Ffreedom();
      	 Account parent = new Account();
          parent = testData.initializeAccount();
          insert parent;
          Account child = new Account(); 
          child = testData.init_FamilyMember(parent);
          child.Portal_Id__c = '1';
          insert child;
      	  
          Expense__c objExp = new Expense__c();
          objExp.Annualized__c = 12563;
          objExp.Portal_Parent_Entity__c = '1';
          objExp.From_Portal__c = 0;
           objExp.Portal_Id__c ='5';
           //insert objExp;
          
          Expense__c objExp1 = new Expense__c();
          objExp1.Annualized__c = 12563;
          objExp1.Portal_Parent_Entity__c = '1';
          objExp1.From_Portal__c = 1;
          objExp1.Portal_Id__c ='6';   
             
          test.startTest();
              insert objExp;
              objExp.Annualized__c = 1253;
              update objExp;
              insert objExp1;
               objExp1.Annualized__c = 125345;
              objExp1.Synched_Date_Time__c = system.Now()+1;
              update objExp1;
              objExp1.Annualized__c = 125345;
              objExp1.Synched_Date_Time__c = system.Now();
              update objExp1;
          test.stopTest();
       }
	
	
}