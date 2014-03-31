public with sharing class HandlerForParentForInsurance
{
	static Boolean flag=true;
    public Integer count=0;
     
	public void beforeInsuranceInsert(List<Insurance__c> lstInsurance)
	{
		system.debug('==================================================' + lstInsurance);
		Map<String , List<Insurance__c>> mapPortalIdAndList = new Map<String , List<Insurance__c> >();
		Map<String , List<Insurance__c>> mapNewPortalIdAndList = new Map<String , List<Insurance__c> >();
	
		for(Insurance__c objInsurance : lstInsurance)
		{
			//List<Insurance__c> listInsurance = new List<Insurance__c>([select Portal_Id__c from Insurance__c where Portal_Id__c = :objInsurance.Portal_Id__c]);
			//if(listInsurance.size() == 0 )
			//{
				if(objInsurance.Portal_Parent_Entity__c != NULL )			
				{			   
					if(!mapPortalIdAndList.containsKey(objInsurance.Portal_Parent_Entity__c))
					{
					    mapPortalIdAndList.put(objInsurance.Portal_Parent_Entity__c , new List<Insurance__c>{objInsurance});
					    
					}
					else
					{
					    mapPortalIdAndList.get(objInsurance.Portal_Parent_Entity__c).add(objInsurance);
					    
					}
					
					if(!mapNewPortalIdAndList.containsKey(objInsurance.Portal_Id__c))
					{
						mapNewPortalIdAndList.put(objInsurance.Portal_Id__c , new List<Insurance__c>{objInsurance});
					}
					else
					{
						mapNewPortalIdAndList.get(objInsurance.Portal_Id__c).add(objInsurance);
					}
					
					
					
				//}
			}
			
		}
		
		if(mapPortalIdAndList.size() > 0)
		{
		List<Account> lstAccount = new List<Account>([select id, Portal_Id__c , Name  from Account where Portal_Id__c IN: mapPortalIdAndList.keySet()]);
		List<Insurance__c> lstIns = new List<Insurance__c>([select Portal_Id__c from Insurance__c where Portal_Id__c IN: mapNewPortalIdAndList.keySet()]);
		//if(lstIns.isEmpty()){
		
			Set<String> foundIdSet = new Set<String>();
		for(Insurance__c insurance : lstIns){
			foundIdSet.add(insurance.Portal_Id__c);
		}
		
		
		for(Account objAccount : lstAccount )
		{
			if(mapPortalIdAndList != null && mapPortalIdAndList.containsKey(objAccount.Portal_Id__c) && mapPortalIdAndList.get(objAccount.Portal_Id__c) != null)
			{
				for(Insurance__c objInsurance : mapPortalIdAndList.get(objAccount.Portal_Id__c))
				{
					if(foundIdSet.contains(objInsurance.Portal_Id__c)){
						objInsurance.Entity__c =null;
					}	
					else {
				   if(objAccount.Id != null)
				   		objInsurance.Entity__c = objAccount.Id;
					system.debug('objContact=======' + objInsurance);
					count++;
				} 
				}
			}
		//}
		}
		}
	}
	
	public void beforeUpdateInsurance(List<Insurance__c> lstNewInsurance, List<Insurance__c> lstOldInsurance)
	{
		/*for(Insurance__c objNewInsurance : lstNewInsurance)
		{
			for(Insurance__c objOldInsurance : lstOldInsurance)
		    {
			   if(objOldInsurance.From_Portal__c == 1 && objNewInsurance.Synched_Date_Time__c >= objOldInsurance.LastModifiedDate )
			   {
				  objNewInsurance.From_Portal__c = 0;
				  objNewInsurance.IsSynched__c = true;
			   }
			   else if(objOldInsurance.From_Portal__c == 1 && objNewInsurance.Synched_Date_Time__c < objOldInsurance.LastModifiedDate )
			   {
				  objNewInsurance.From_Portal__c = 0;
				  objNewInsurance.IsSynched__c = false;
			   }
			   else if(objNewInsurance.From_Portal__c == 0)
			   {
			   	 objNewInsurance.IsSynched__c = false;
			   }
			   }
			
		   }*/
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
      	  
          Insurance__c objInsurance = new Insurance__c();
          objInsurance.Agent_Name__c = 'TestAgent';
          objInsurance.Portal_Parent_Entity__c = '1';
          objInsurance.From_Portal__c = 0;
          objInsurance.Entity__c = parent.Id;
           objInsurance.Portal_Id__c ='6';
           //insert objExp;
             
          test.startTest();
              insert objInsurance;
              objInsurance.Agent_Name__c = 'TestABC';
              update objInsurance;
            
              /*objInsurance1.Active_Status__c = true;
              objInsurance1.Synched_Date_Time__c = system.Now();
              update objInsurance1;*/
          test.stopTest();
       }
}