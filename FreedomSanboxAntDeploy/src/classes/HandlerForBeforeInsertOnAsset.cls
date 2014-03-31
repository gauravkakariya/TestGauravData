public with sharing class HandlerForBeforeInsertOnAsset {

	static Boolean flag=true;
     public Integer count=0;
     
	public void beforeAssetInsert(List<Asset__c> lstAsset)
	{
		system.debug('=================================================='+lstAsset);
		Map<String , List<Asset__c>> mapPortalIdAndList = new Map<String , List<Asset__c> >();
	
		for(Asset__c objAsset : lstAsset)
		{
			if(objAsset.Portal_Id__c!= NULL )
			
			{
			   
				  if(!mapPortalIdAndList.containsKey(objAsset.Portal_Id__c))
				   {
					mapPortalIdAndList.put(objAsset.Portal_Id__c , new List<Asset__c>{objAsset});
				   }
				   else
				   {
					   mapPortalIdAndList.get(objAsset.Portal_Id__c).add(objAsset);
				   }
			}
		}
		
		List<Account> lstAccount = new List<Account>([select id, Portal_Id__c , Name  from Account where Portal_Id__c IN: mapPortalIdAndList.keySet() ]);
		
		
		for(Account objAccount : lstAccount )
		{
			if(mapPortalIdAndList != null && mapPortalIdAndList.containsKey(objAccount.Portal_Id__c) && mapPortalIdAndList.get(objAccount.Portal_Id__c) != null)
			{
				for(Asset__c objAsset : mapPortalIdAndList.get(objAccount.Portal_Id__c))
				{
				   	
				   if(objAccount.Id != null)
				   		objAsset.Entity__c = objAccount.Id;
					system.debug('objContact======='+objAsset);
					count++;
				} 
			}
		}
		
	}
}