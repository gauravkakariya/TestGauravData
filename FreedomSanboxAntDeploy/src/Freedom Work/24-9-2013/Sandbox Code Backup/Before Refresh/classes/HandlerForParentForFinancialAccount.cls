public with sharing class HandlerForParentForFinancialAccount 
{
     static Boolean flag=true;
     public Integer count=0;
     
	public void beforeFinancailAccountInsert(List<Financial_Account__c> lstFinancialAccount)
	{
		system.debug('----------------*****************'+lstFinancialAccount);
		Map<String , List<Financial_Account__c>> mapPortalIdAndList = new Map<String , List<Financial_Account__c> >();
		Map<String , List<Financial_Account__c>> mapNewPortalIdAndList = new Map<String , List<Financial_Account__c> >();
	
		for(Financial_Account__c objFAC : lstFinancialAccount)
		{
				if(objFAC.portal_parent_entity__c!= NULL )
				{
				  if(!mapPortalIdAndList.containsKey(objFAC.portal_parent_entity__c))
				   {
						mapPortalIdAndList.put(objFAC.portal_parent_entity__c , new List<Financial_Account__c>{objFAC});	
							
				   }
				   else
				   {
					   mapPortalIdAndList.get(objFAC.portal_parent_entity__c).add(objFAC);
					  
				   }
				   
				   if(!mapNewPortalIdAndList.containsKey(objFAC.Portal_Id__c))
				   {
				     	mapNewPortalIdAndList.put(objFAC.Portal_Id__c , new List<Financial_Account__c>{objFAC});
				   }
				   else
				   {
				   	    mapNewPortalIdAndList.put(objFAC.Portal_Id__c , new List<Financial_Account__c>{objFAC});	
				   }
			}
		}
		
		List<Account> lstAccount = new List<Account>([select id, Portal_Id__c , Name  from Account where Portal_Id__c IN: mapPortalIdAndList.keySet() ]);
		List<Financial_Account__c> lstFinAccount = new List<Financial_Account__c>([select Portal_Id__c from Financial_Account__c where Portal_Id__c IN: mapNewPortalIdAndList.keySet()]);
		
		system.debug('*****************************'+lstAccount);
		system.debug('*****************************'+lstAccount);
		
		
		Set<String> foundIdSet = new Set<String>();
		for(Financial_Account__c finAccount:lstFinAccount){
			foundIdSet.add(finAccount.Portal_Id__c);
		}
		
		
		//if(lstFinAccount.isEmpty()){ //15/05/2013
		for(Account objAccount : lstAccount )
		{
			if(mapPortalIdAndList != null && mapPortalIdAndList.containsKey(objAccount.Portal_Id__c) && mapPortalIdAndList.get(objAccount.Portal_Id__c) != null)
			{
				for(Financial_Account__c objFinancalAccount : mapPortalIdAndList.get(objAccount.Portal_Id__c))
				{
					if(foundIdSet.contains(objFinancalAccount.Portal_Id__c)){
						objFinancalAccount.Account__c =null;
					}	
					else {
				   if(objAccount.Id != null)
				   		objFinancalAccount.Account__c = objAccount.Id;
					}
					
				} 
			//}
		}
		}
	}
	
	public void beforeUpdateFinancialAccount(List<Financial_Account__c> lstNewFinancialAccount, List<Financial_Account__c> lstOldFinancialAccount)
	{
		for(Financial_Account__c objNewFinancialAccount : lstNewFinancialAccount)
		{
			for(Financial_Account__c objOldFinancialAccount : lstOldFinancialAccount)
		    {
			   if(objOldFinancialAccount.From_Portal__c == 1 && objNewFinancialAccount.Synched_Date_Time__c >= objOldFinancialAccount.LastModifiedDate )
			   {
				  objNewFinancialAccount.From_Portal__c = 0;
				  objNewFinancialAccount.IsSynched__c = true;
			   }
			   else if(objOldFinancialAccount.From_Portal__c == 1 && objNewFinancialAccount.Synched_Date_Time__c < objOldFinancialAccount.LastModifiedDate )
			   {
				  objNewFinancialAccount.From_Portal__c = 0;
				  objNewFinancialAccount.IsSynched__c = false;
			   }
			   else if(objNewFinancialAccount.From_Portal__c == 0)
			   {
			   	 objNewFinancialAccount.IsSynched__c = false;
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
      	  
          Financial_Account__c objFinancialAccount = new Financial_Account__c();
          objFinancialAccount.Bank_Name__c = '';
          objFinancialAccount.Portal_Parent_Entity__c = '1';
          objFinancialAccount.Account__c = child.id;
          objFinancialAccount.From_Portal__c = 0;
          objFinancialAccount.Portal_Id__c ='5';
           //insert objExp;
          
          Financial_Account__c objFinancialAccount1 = new Financial_Account__c();
          objFinancialAccount1.Bank_Name__c = '';
           objFinancialAccount.Account__c = child.id;
          objFinancialAccount.Portal_Parent_Entity__c = '1';
          objFinancialAccount1.From_Portal__c = 1;
          objFinancialAccount1.Portal_Id__c ='6';
          
             
          test.startTest();
              insert objFinancialAccount;
            	objFinancialAccount.Bank_Name__c = 'test dutuch';
              update objFinancialAccount;
               /*insert objFinancialAccount1;
                objFinancialAccount.Bank_Name__c = 'test dutuasj';
              	//objFinancialAccount1.Synched_Date_Time__c = system.Now()+1;
              update objFinancialAccount1;
               objFinancialAccount.Bank_Name__c = 'test icici';
              objFinancialAccount1.Synched_Date_Time__c = system.Now();
              update objFinancialAccount1;*/ 
          test.stopTest();
       }
	
}