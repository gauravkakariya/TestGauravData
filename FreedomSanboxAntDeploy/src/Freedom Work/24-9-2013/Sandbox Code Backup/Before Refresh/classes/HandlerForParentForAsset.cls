public without sharing class HandlerForParentForAsset extends AssetTrigger
{
	static Boolean flag=true;
    public Integer count=0;
    
    public HandlerForParentForAsset(Asset__c[] AssetOldList, Asset__c[] AssetNewList){
		super(AssetOldList,AssetNewList);
	}
	
    public void beforeAssetInsert()
	{
		
		system.debug('******************'+assetNewList);
		Map<String , List<Asset__c>> mapPortalIdAndList = new Map<String , List<Asset__c> >();
		Map<String , List<Asset__c>> mapNewPortalIdAndList = new Map<String , List<Asset__c> >();
	
		for(Asset__c objAsset : assetNewList){
			if(objAsset.Portal_Parent_Entity__c == null) continue;
			
			if(!mapPortalIdAndList.containsKey(objAsset.Portal_Parent_Entity__c))
				mapPortalIdAndList.put(objAsset.Portal_Parent_Entity__c , new List<Asset__c>{objAsset});
			else
				mapPortalIdAndList.get(objAsset.Portal_Parent_Entity__c).add(objAsset);
			if(!mapNewPortalIdAndList.containsKey(objAsset.Portal_Id__c))
				mapNewPortalIdAndList.put(objAsset.Portal_Id__c , new List<Asset__c>{objAsset});
			else
				mapPortalIdAndList.get(objAsset.Portal_Id__c).add(objAsset);
				
		}
		
		List<Account> lstAccount = new List<Account>([select id, Portal_Id__c , Name  from Account where Portal_Id__c IN: mapPortalIdAndList.keySet() ]);
		List<Asset__c> lstasse = new List<Asset__c>([select Portal_Id__c from Asset__c where Portal_Id__c IN: mapNewPortalIdAndList.keySet()]);
		
		system.debug('****************'+lstAccount);
		
		
		Set<String> foundIdSet = new Set<String>();
		for(Asset__c asset :lstasse){
			foundIdSet.add(asset.Portal_Id__c);
		}
		
		
		for(Account objAccount : lstAccount ){
			if(mapPortalIdAndList != null && mapPortalIdAndList.containsKey(objAccount.Portal_Id__c) && mapPortalIdAndList.get(objAccount.Portal_Id__c) != null)
			{
				for(Asset__c objAsset : mapPortalIdAndList.get(objAccount.Portal_Id__c)){	
					
					if(foundIdSet.contains(objAsset.Portal_Id__c)){
						objAsset.Entity__c =null;
					}	
					else {			   	
				   if(objAccount.Id != null)
				   		objAsset.Entity__c = objAccount.Id;
					count++;
				} 
				}
			}
		}		
	}
	
	public void beforeUpdateAsset()
	{
		/*for(Asset__c objNewAsset : assetNewList){
			Asset__c objOldAsset = assetOldListMap.get(objNewAsset.Id);
	       if(objOldAsset.From_Portal__c == 1 && objNewAsset.Synched_Date_Time__c > objOldAsset.LastModifiedDate ){
			  objNewAsset.From_Portal__c = 0;
			  objNewAsset.IsSynched__c = true;
		   }
		   else if(objOldAsset.From_Portal__c == 1 && objNewAsset.Synched_Date_Time__c < objOldAsset.LastModifiedDate )
		   {
			  objNewAsset.From_Portal__c = 0;
			   objNewAsset.IsSynched__c = false;
		   }
		   else if(objNewAsset.From_Portal__c == 0)
		   	 objNewAsset.IsSynched__c = false;
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
      	  
          Asset__c objasset = new Asset__c();
          objasset.Account_Number__c = '87654670';
          objasset.Portal_Parent_Entity__c = '7';
          objasset.From_Portal__c = 0;
          objasset.Entity__c = parent.Id;
          objasset.Portal_Id__c ='85';
           //insert objExp;
          
          
             
          test.startTest();
              insert objasset;
          test.stopTest();
       }
	
	
}