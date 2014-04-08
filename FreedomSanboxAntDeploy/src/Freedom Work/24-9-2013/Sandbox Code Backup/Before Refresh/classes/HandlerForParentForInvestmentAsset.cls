public with sharing class HandlerForParentForInvestmentAsset {
	static Boolean flag=true;
    public Integer count=0;
     
	public void beforeInvestmentAssetInsert(List<Investment_Asset__c> lstInvestmentAsset)
	{
		//system.debug('==================================================' + lstInvestmentAsset);
		Map<String , List<Investment_Asset__c>> mapPortalIdAndList = new Map<String , List<Investment_Asset__c> >();
		Map<String , List<Investment_Asset__c>> mapNewPortalIdAndList = new Map<String , List<Investment_Asset__c> >();
	
		for(Investment_Asset__c objInvestmentAsset : lstInvestmentAsset)
		{
			//List<Investment_Asset__c> listInvestAsset = new List<Investment_Asset__c>([select Portal_Id__c from Investment_Asset__c where Portal_Id__c = :objInvestmentAsset.Portal_Id__c]);
			//if(listInvestAsset.size() == 0 )
			//{
				if(objInvestmentAsset.Portal_Parent_Entity__c != NULL )			
				{			   
					if(!mapPortalIdAndList.containsKey(objInvestmentAsset.Portal_Parent_Entity__c))
					{
					    mapPortalIdAndList.put(objInvestmentAsset.Portal_Parent_Entity__c , new List<Investment_Asset__c>{objInvestmentAsset});
					    
					}
					else
					{
					    mapPortalIdAndList.get(objInvestmentAsset.Portal_Parent_Entity__c).add(objInvestmentAsset);
					   
					}
					
					if(!mapNewPortalIdAndList.containsKey(objInvestmentAsset.Portal_Id__c))
					{
						 mapNewPortalIdAndList.put(objInvestmentAsset.Portal_Id__c , new List<Investment_Asset__c>{objInvestmentAsset});
					}
					else
					{
						 mapNewPortalIdAndList.get(objInvestmentAsset.Portal_Id__c).add(objInvestmentAsset);
					}
				//}
			}
		}
		
		List<Account> lstAccount = new List<Account>([select id, Portal_Id__c , Name  from Account where Portal_Id__c IN: mapPortalIdAndList.keySet()]);
		List<Investment_Asset__c> lstInvAsset = new List<Investment_Asset__c>([select Portal_Id__c  from Investment_Asset__c where Portal_Id__c IN: mapNewPortalIdAndList.keySet()]);
		
		
		Set<String> foundIdSet = new Set<String>();
		for(Investment_Asset__c InvAsset :lstInvAsset){
			foundIdSet.add(InvAsset.Portal_Id__c);
		}
		 
		
		//system.debug('==================================================' + lstAccount);
		
		//if(lstInvAsset.isEmpty()){
		for(Account objAccount : lstAccount )
		{
			if(mapPortalIdAndList != null && mapPortalIdAndList.containsKey(objAccount.Portal_Id__c) && mapPortalIdAndList.get(objAccount.Portal_Id__c) != null)
			{
				for(Investment_Asset__c objInvestmentAsset : mapPortalIdAndList.get(objAccount.Portal_Id__c))
				{
					if(foundIdSet.contains(objInvestmentAsset.Portal_Id__c)){
						objInvestmentAsset.Entity__c =null;
					}	
					else {
				   if(objAccount.Id != null)
				   		objInvestmentAsset.Entity__c = objAccount.Id;
					system.debug('objInvestment=======' + objInvestmentAsset);
					count++;
					}
				} 
			}
		}
		//}
	}
	
	public void beforeUpdateInvestmentAsset(List<Investment_Asset__c> lstNewInvestmentAsset, List<Investment_Asset__c> lstOldInvestmentAsset)
	{
		for(Investment_Asset__c objNewInvestmentAsset : lstNewInvestmentAsset)
		{
			for(Investment_Asset__c objOldInvestmentAsset : lstOldInvestmentAsset)
		    {
			   if(objOldInvestmentAsset.From_Portal__c == 1 && objNewInvestmentAsset.Synched_Date_Time__c >= objOldInvestmentAsset.LastModifiedDate )
			   {
				  objNewInvestmentAsset.From_Portal__c = 0;
				  objNewInvestmentAsset.IsSynched__c = true;
			   }
			   else if(objOldInvestmentAsset.From_Portal__c == 1 && objNewInvestmentAsset.Synched_Date_Time__c < objOldInvestmentAsset.LastModifiedDate )
			   {
				  objNewInvestmentAsset.From_Portal__c = 0;
				  objNewInvestmentAsset.IsSynched__c = false;
			   }
			   else if(objNewInvestmentAsset.From_Portal__c == 0)
			   {
			   	 objNewInvestmentAsset.IsSynched__c = false;
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
      	  
          Investment_Asset__c objInvestmentAsset = new Investment_Asset__c();
          objInvestmentAsset.Asset_Name__c = 'Test Investment Asset';
          objInvestmentAsset.Portal_Parent_Entity__c = '1';
          objInvestmentAsset.From_Portal__c = 0;
          objInvestmentAsset.Entity__c = parent.Id;
          objInvestmentAsset.Portal_Id__c ='5';
           //insert objExp;
          
          Investment_Asset__c objInvestmentAsset1 = new Investment_Asset__c();
          objInvestmentAsset1.Asset_Name__c = 'Test Investment Asset1';
          objInvestmentAsset1.Portal_Parent_Entity__c = '1';
          objInvestmentAsset1.From_Portal__c = 1;
          objInvestmentAsset1.Entity__c = parent.Id;
          objInvestmentAsset1.Portal_Id__c='6';
             
          test.startTest();
              insert objInvestmentAsset;
              objInvestmentAsset.Asset_Name__c = 'Test Investment Asset 2';
              update objInvestmentAsset;
              insert objInvestmentAsset1;
               objInvestmentAsset1.Asset_Name__c = 'Test Investment Asset 3';
              objInvestmentAsset1.Synched_Date_Time__c = system.Now()+1;
              update objInvestmentAsset1;
              objInvestmentAsset1.Asset_Name__c = 'Test Investment Asset 4';
              objInvestmentAsset1.Synched_Date_Time__c = system.Now();
              update objInvestmentAsset1;
          test.stopTest();
       }
	
}