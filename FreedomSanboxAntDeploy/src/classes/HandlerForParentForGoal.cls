public with sharing class HandlerForParentForGoal
{
	static Boolean flag=true;
    public Integer count=0;
     
	public void beforeGoalInsert(List<Goal__c> lstGoal)
	{
		system.debug('=================================================='+lstGoal);
		Map<String , List<Goal__c>> mapPortalIdAndList = new Map<String , List<Goal__c> >();
	    Map<String , List<Goal__c>> mapPortalIList = new Map<String , List<Goal__c> >();
	
		for(Goal__c objGoal : lstGoal)
		{
				system.debug('inside goal');
				if(objGoal.Portal_Parent_Entity__c != NULL )			
				{			
					
								if(!mapPortalIdAndList.containsKey(objGoal.Portal_Parent_Entity__c))
								{
								          mapPortalIdAndList.put(objGoal.Portal_Parent_Entity__c , new List<Goal__c>{objGoal});
								}
								else
								{
								         mapPortalIdAndList.get(objGoal.Portal_Parent_Entity__c).add(objGoal);
								}
							if(!mapPortalIList.containsKey(objGoal.Portal_Id__c))
							{
								mapPortalIList.put(objGoal.Portal_Id__c , new List<Goal__c>{objGoal});
							}
							else
							{
								mapPortalIList.get(objGoal.Portal_Id__c).add(objGoal);
							}					
		}
		}
		
		List<Account> lstAccount = new List<Account>([select id, Portal_Id__c , Name  from Account where Portal_Id__c IN: mapPortalIdAndList.keySet() ]);
		
		List<Goal__c> lstGol1 = new List<Goal__c>([select Portal_Id__c from Goal__c where Portal_Id__c  IN: mapPortalIList.keySet()]);
		
		
		Set<String> foundIdSet = new Set<String>();
		for(Goal__c goal:lstGol1){
			foundIdSet.add(goal.Portal_Id__c);
		}
		
		
		for(Account objAccount : lstAccount )
		{
			if(mapPortalIdAndList != null && mapPortalIdAndList.containsKey(objAccount.Portal_Id__c) && mapPortalIdAndList.get(objAccount.Portal_Id__c) != null)
			{
				for(Goal__c objGoal : mapPortalIdAndList.get(objAccount.Portal_Id__c))
				{				   	
					if(foundIdSet.contains(objGoal.Portal_Id__c)){
						objGoal.Entity__c =null;
					}	
					else {
						   if(objAccount.Id != null)
						   		objGoal.Entity__c = objAccount.Id;
					}
					system.debug('objContact======='+objGoal);
					count++;
				} 
			}
		}
		
		//}	
		
	}
	
	public void beforeUpdateGoal(List<Goal__c> lstNewGoal, List<Goal__c> lstOldGoal)
	{
		for(Goal__c objNewGoal : lstNewGoal)
		{
			for(Goal__c objOldGoal : lstOldGoal)
		    {
			   if(objOldGoal.From_Portal__c == 1 && objNewGoal.Synched_Date_Time__c >= objOldGoal.LastModifiedDate )
			   {
				  objNewGoal.From_Portal__c = 0;
				  objNewGoal.IsSynched__c = true;
			   }
			   else if(objOldGoal.From_Portal__c == 1 && objNewGoal.Synched_Date_Time__c < objOldGoal.LastModifiedDate )
			   {
				  objNewGoal.From_Portal__c = 0;
				  objNewGoal.IsSynched__c = false;
			   }
			   else if(objNewGoal.From_Portal__c == 0)
			   {
			   	 objNewGoal.IsSynched__c = false;
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
      	  
          Goal__c objGoal = new Goal__c();
          objGoal.aggressive_profile_years__c = 2.0;
          objGoal.Portal_Parent_Entity__c = '1';
          objGoal.From_Portal__c = 0;
          objGoal.Entity__c = parent.Id;
          objGoal.Portal_Id__c ='5';
           //insert objExp;
          
          Goal__c objGoal1 = new Goal__c();
          objGoal1.aggressive_profile_years__c = 4.0;
          objGoal1.Portal_Parent_Entity__c = '1';
          objGoal1.From_Portal__c = 1;
          objGoal1.Entity__c = parent.Id;
          objGoal1.Portal_Id__c ='6';
          
             
          test.startTest();
              insert objGoal;
              objGoal.aggressive_profile_years__c = 4.0;
              update objGoal;
         	 insert objGoal1;
               objGoal1.aggressive_profile_years__c = 2.0;
              objGoal1.Synched_Date_Time__c = system.Now()+1;
              update objGoal1;
              /*objGoal1.aggressive_profile_years__c = 3.0;
              objGoal1.Synched_Date_Time__c = system.Now();
              update objGoal1;*/
          test.stopTest();
       }
}