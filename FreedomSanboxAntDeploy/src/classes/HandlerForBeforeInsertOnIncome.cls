public with sharing class HandlerForBeforeInsertOnIncome 
{
    static Boolean flag=true;
    public Integer count=0;
         
    public void beforeIncomeInsert(List<Income__c> lstIncome)
    {
        system.debug('=================================================='+lstIncome);
        Map<String , List<Income__c>> mapPortalIdAndList = new Map<String , List<Income__c> >();
     	Map<String , List<Income__c>> mapNewPortalIdAndList = new Map<String , List<Income__c> >();
        for(Income__c objIncome : lstIncome)        
        {
        	if(objIncome.Portal_Parent_Entity__c!= NULL )           
            {              
                if(!mapPortalIdAndList.containsKey(objIncome.Portal_Parent_Entity__c))
                {
                     mapPortalIdAndList.put(objIncome.Portal_Parent_Entity__c , new List<Income__c>{objIncome});
                    
                }
                else
                {
                    mapPortalIdAndList.get(objIncome.Portal_Parent_Entity__c).add(objIncome);
                   
                }
                if(!mapNewPortalIdAndList.containsKey(objIncome.Portal_Id__c))
                {
                     mapNewPortalIdAndList.put(objIncome.Portal_Id__c , new List<Income__c>{objIncome});
                }
                else
                {
                    mapNewPortalIdAndList.get(objIncome.Portal_Id__c).add(objIncome);
                }
        	}
        }
        
        
        List<Account> lstAccount = new List<Account>([select id, Portal_Id__c , Name  from Account where Portal_Id__c IN: mapPortalIdAndList.keySet() ]);
        List<Income__c> lstInc = new List<Income__c>([select  Portal_Id__c   from Income__c  where Portal_Id__c IN: mapNewPortalIdAndList.keySet() ]);
        
        
        Set<String> foundIdSet = new Set<String>();
        for(Income__c inc:lstInc ){
            foundIdSet.add(inc.Portal_Id__c);
        }
        
        
            
        //if(lstInc.isEmpty()){
        for(Account objAccount : lstAccount )
        {
            if(mapPortalIdAndList != null && mapPortalIdAndList.containsKey(objAccount.Portal_Id__c) && mapPortalIdAndList.get(objAccount.Portal_Id__c) != null)
            {
                for(Income__c objIncome : mapPortalIdAndList.get(objAccount.Portal_Id__c))
                {    
                	if(foundIdSet.contains(objIncome.Portal_Id__c)){
                        objIncome.Entity__c =null;
                    }   
                    else {                 
                   		if(objAccount.Id != null)
                        	objIncome.Entity__c = objAccount.Id;
                    	system.debug('objIncome======='+objIncome);
                    	count++;
                    }
                } 
            }
        }
       // }               
    }
    
    public void beforeUpdateIncome(List<Income__c> lstNewIncome, List<Income__c> lstOldIncome)
    {
        for(Income__c objNewIncome : lstNewIncome)
        {
            for(Income__c objOldIncome : lstOldIncome)
            {
               if(objOldIncome.From_Portal__c == 1 && objNewIncome.Synched_Date_Time__c > objOldIncome.LastModifiedDate )
               {
                  objNewIncome.From_Portal__c = 0;
                  objNewIncome.IsSynched__c = true;
               }
               else if(objOldIncome.From_Portal__c == 1 && objNewIncome.Synched_Date_Time__c < objOldIncome.LastModifiedDate )
               {
                  objNewIncome.From_Portal__c = 0;
                   objNewIncome.IsSynched__c = false;
               }
               else if(objOldIncome.From_Portal__c == 0)
               {
                 objNewIncome.IsSynched__c = false;
               }
               }
            
           }
    }
    
    
    @IsTest(SeeAlldata = true) 
      public static void testCoverage() 
      {
         TestData_Ffreedom testData = new TestData_Ffreedom();
         Account parent = new Account();
          parent = testData.initializeAccount();
          insert parent;
          Account child = new Account(); 
          child = testData.init_FamilyMember(parent);
          child.Portal_Id__c = '1';
         // insert child;
          List<Income__c> lstIncome = new List<Income__c>();
          Income__c objIncome = new Income__c();
          objIncome.Income_Amount__c = 150000;
          objIncome.Portal_Parent_Entity__c = '1';
          objIncome.From_Portal__c = 0;
          objIncome.Entity__c = parent.Id;
          objIncome.Portal_Id__c = '6';
           //insert objExp;
          lstIncome.add(objIncome);
          Income__c objIncome1 = new Income__c();
          objIncome1.Income_Amount__c = 180000;
          objIncome1.Portal_Parent_Entity__c = '1';
          objIncome1.From_Portal__c = 1;
          objIncome1.Entity__c = parent.Id;
          objIncome1.Portal_Id__c ='7';
            lstIncome.add(objIncome1);
             
          test.startTest();
          insert lstIncome;
          objIncome.Income_Amount__c = 200000;
          update objIncome;
          //insert objIncome1;
          objIncome1.Income_Amount__c = 240000;
          objIncome1.Synched_Date_Time__c = system.Now()+1;
          update objIncome1;
          objIncome1.Income_Amount__c = 280000;
          objIncome1.Synched_Date_Time__c = system.Now();
          update objIncome1;
          HandlerForBeforeInsertOnIncome objHandlerForBeforeInsertOnIncome = new HandlerForBeforeInsertOnIncome();
          objHandlerForBeforeInsertOnIncome.beforeIncomeInsert(lstIncome);
          objHandlerForBeforeInsertOnIncome.beforeUpdateIncome(lstIncome,lstIncome);
          test.stopTest();
       }
}