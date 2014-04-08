/*
    This trigger executes after a new Entity record is inserted and creates default records 
    associated with the new Entity, for the Entity_Global_Assumption__c and Goal__c objects. 
    A new goal of type Emergency Fund is created by default for the new Entity if it does 
    not have a Parent Entity. 
    
    Revision History:
    
    Version     Version Author     Date         Comments
    1.0         Persistent         NA           Initial Draft
    2.0         Eternus            20/05/2011   Added 2 new fields Start_Year__c and End_Year__c during the default 
                                                Goal record creation. The default value for the fields are,
                                                Start_Year__c = Date.today().year i.e. current year and
                                                End_Year__c = Date.today().addMonths(12).year i.e. Year after 12 months 
    2.0         Manasi Ranade      23/05/2011   Added Priority to the Goal by default as 'High'. 
                                                And replaced Start_Year__c to Goal_Start_Year__c,End_Year__c to Goal_End_Year__c
                                                At the time of assigning defual values to the fields
    3.0         Manasi Ranade      25/05/2011   Added two fields Default_Retirement_Age__c and Default_Estimated_Life_Expectancy__c
                                                in Entity_Global_Assumption__c object.And assigned default values using this trigger.
    3.0         Manasi Ranade      3/4/2012     Create EntityRelatedAttachment__c  for parent entity after insert
*/

trigger CreateGlobalAssumptions on Account (after insert) //,before update
{

    if(trigger.isAfter && trigger.isInsert)
    {          
        List<Entity_Global_Assumption__c> globalAssumptionList = new List<Entity_Global_Assumption__c>();
        List<Goal__c>goalList = new List<Goal__c>();
        
        //Create EntityRelatedAttachment__c  for parent entity after insert
        List<EntityRelatedAttachment__c> insertEntityRelatedAttachmentList = new List<EntityRelatedAttachment__c>(); 
        
        Schema.DescribeFieldResult fieldResult = Goal__c.Goal_Type__c.getDescribe();
        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        String goalType;
        String goalDesc;
        
        for(Schema.PicklistEntry f : ple) 
        {
            if (f.getLabel().equalsIgnoreCase('Emergency Fund')) 
            {
                goalType = f.getValue();
                goalDesc = f.getLabel();
                break;
            }
        }
                
        //start of VirtualPartner related changes
        //Code Added By : Aditi
        //Date : 03/09/12
        //======================================================================================================================
        //need to comment below
        Map<Id,Account> mapVirtualIdToAccount = new Map<Id,Account>();
        List<Account> lstVirtualAcc = new List<Account>();
        Account FfreedomAcc = new Account();
        //lstVirtualAcc = [select id,Expected_Return_on_Investment__c,Income_Growth_Rate__c,Inflation_Rate__c,Default_Estimated_Life_Expectancy__c,Number_Of_Months__c,Default_Retirement_Age__c from Account where Related_To__c = 'Virtual Partner' and RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c];
         Account objAcc = new Account(); 
         
        //start of Partner Portal related changes
        //Code Added By : Aditi
        //Date : 31/07/12
        List<Account> lstAcc = trigger.new;
        //commented on 18/12/12
        /*    Set<Id> accOwnerId;
            //To fetch the current User through the OwnerId 
        	for(Account acc : lstAcc)
        	{
        		accOwnerId.add(acc.OwnerId);
        	}
        
        */
         User user = [select Id,Name,ProfileId,ContactId,Profile.Name from User where Id=:lstAcc[0].OwnerId];
         //commented on 18/12/12
         //    List<User> lstUser=[select Id,Name,ProfileId,ContactId,Profile.Name from User where Id=:accOwnerId];
         //	Map<Id,User> mapAccOwnerIdToUser;
                Contact con;
                Account acc;
              /*  
                for(User objUser : lstUser)
                {
                	
                }*/
                if(user.ContactId!=null)
                {
                    //To fetch Contact of that particular User
                    System.debug('--- user.ContactId --->' + user.ContactId);
                    con=[select id, AccountId from Contact where id =: user.ContactId];
                    System.debug('--- con --->' + con);
                    //To fetch Account with previously fetched Contact
                    acc=[select Id,Logo__c, Email_ID__c,IsCreatedByPartner__c,Expected_Return_on_Investment__c,Income_Growth_Rate__c,
                    			Gold_Growth_Rate__c,	   /* Prajakta - FP changes - 01-04-2013 */	
                    			Stock_Growth_Rate__c,Inflation_Rate__c,Default_Estimated_Life_Expectancy__c,Number_Of_Months__c,Company_Address__c,Default_Retirement_Age__c,Phone,Name from account where id =: con.AccountId];
                    system.debug('*******acc**********'+acc);			    
                }
                else 
                {
                    lstVirtualAcc = [select id,Expected_Return_on_Investment__c,Income_Growth_Rate__c,Inflation_Rate__c,
                    Gold_Growth_Rate__c,	   /* Prajakta - FP changes - 01-04-2013 */	
                    Default_Estimated_Life_Expectancy__c,Number_Of_Months__c,Stock_Growth_Rate__c,Default_Retirement_Age__c 
                    from Account where Related_To__c = 'Virtual Partner' and RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c];
                            
                }
                
                Entity_Global_Assumption__c globalAspt=new Entity_Global_Assumption__c();
                Goal_Profile__c objUpdateGoalProfile = new Goal_Profile__c();
                
                List<Account> lstAccTemp = new List<Account>();
   				lstAccTemp = [select id,Expected_Return_on_Investment__c,Income_Growth_Rate__c,Inflation_Rate__c,Default_Estimated_Life_Expectancy__c,
   										Number_Of_Months__c,Gold_Growth_Rate__c,	   /* Prajakta - FP changes - 01-04-2013 */	
   										Stock_Growth_Rate__c,Default_Retirement_Age__c from Account where Related_To__c = 'Ffreedom' 
   										and RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c];
   				if(!lstAcc.IsEmpty())	
   					FfreedomAcc = lstAccTemp[0];
   				
                for(account a : lstAcc)
                {
                	system.debug('--------aaaa- -------'+a);
                    globalAssumptionList = new List<Entity_Global_Assumption__c>();
                    if(a.Parent_Entity__c == null)
                    {
                        //Condition added to distinguish Partner Portal 
                        if(user.ContactId!=null)
                        {
                            globalAspt.Account__c = a.id;
                            globalAspt.Expected_Return_on_Investment__c = acc.Expected_Return_on_Investment__c;
                            globalAspt.Income_Growth_Rate__c = acc.Income_Growth_Rate__c;
                            globalAspt.Inflation_Rate__c = acc.Inflation_Rate__c;
                            globalAspt.Number_Of_Months__c = acc.Number_Of_Months__c;
                            globalAspt.Default_Retirement_Age__c = acc.Default_Retirement_Age__c;
                            globalAspt.Default_Estimated_Life_Expectancy__c = acc.Default_Estimated_Life_Expectancy__c;
                            globalAspt.Stock_Growth_Rate__c = acc.Stock_Growth_Rate__c;
                            globalAspt.Gold_Growth_Rate__c = acc.Gold_Growth_Rate__c;	   /* Prajakta - FP changes - 01-04-2013 */
                        }      
                    //Code added for VirtualPartner related changes By Aditi
                    //Date : 03/09/12
                    //======================================================================================================================
                        else if(a.Related_To__c == 'Virtual Partner' && 
                        	a.RecordTypeId != RecTypes__c.getInstance('General_Business').Record_Type_Value__c )
                        {
                              if(lstVirtualAcc != null && lstVirtualAcc.size() > 0){
                                for(Account objAccount : lstVirtualAcc)
                                    mapVirtualIdToAccount.put(objAccount.Id,objAccount);
                              }
                            if(mapVirtualIdToAccount.containsKey(a.Virtual_Partner__c)){
                                objAcc = mapVirtualIdToAccount.get(a.Virtual_Partner__c);
                            }
                            system.debug('--------a--------'+a);
                            globalAspt.Account__c = a.id;
                            globalAspt.Expected_Return_on_Investment__c = objAcc.Expected_Return_on_Investment__c;
                            globalAspt.Income_Growth_Rate__c = objAcc.Income_Growth_Rate__c;
                            globalAspt.Inflation_Rate__c = objAcc.Inflation_Rate__c;
                            globalAspt.Number_Of_Months__c = objAcc.Number_Of_Months__c;
                            globalAspt.Default_Retirement_Age__c = objAcc.Default_Retirement_Age__c;
                            globalAspt.Default_Estimated_Life_Expectancy__c = objAcc.Default_Estimated_Life_Expectancy__c;
                            globalAspt.Stock_Growth_Rate__c = objAcc.Stock_Growth_Rate__c;
                            globalAspt.Gold_Growth_Rate__c = objAcc.Gold_Growth_Rate__c;	   /* Prajakta - FP changes - 01-04-2013 */	
                        }
                        else
                        {
                        	system.debug('***in else*FfreedomAcc*****'+FfreedomAcc);
                           	globalAspt.Account__c = a.id;
	                        globalAspt.Expected_Return_on_Investment__c = FfreedomAcc.Expected_Return_on_Investment__c;
	                        globalAspt.Income_Growth_Rate__c=FfreedomAcc.Income_Growth_Rate__c;
	                        globalAspt.Inflation_Rate__c=FfreedomAcc.Inflation_Rate__c;
	                        globalAspt.Number_Of_Months__c=FfreedomAcc.Number_Of_Months__c;
	                        /** Eternus Solutions      **/
	                        /** Author  : Manasi Ranade*/
	                        /** Issue Id: F0018      **/
	                        /** Date    : 25/05/2011 **/
	                        /** Purpose : Added two fields Default_Retirement_Age__c and Default_Estimated_Life_Expectancy__c
	                                                in Entity_Global_Assumption__c object.Here we are assigning default values to those fields**/
	                        /****************************************************/
	                        globalAspt.Default_Retirement_Age__c = FfreedomAcc.Default_Retirement_Age__c;
	                        globalAspt.Default_Estimated_Life_Expectancy__c = FfreedomAcc.Default_Estimated_Life_Expectancy__c; 
	                        globalAspt.Stock_Growth_Rate__c = FfreedomAcc.Stock_Growth_Rate__c;
	                        globalAspt.Gold_Growth_Rate__c = FfreedomAcc.Gold_Growth_Rate__c;	   /* Prajakta - FP changes - 01-04-2013 */	
                        }
                        
                        //End of Partner Portal Related Changes.
                        Goal__c goal = new Goal__c();
                        goal.Entity__c = a.id;
                        goal.Goal_Type__c = goalType;
                        goal.Description__c = goalDesc;
                        
                        /* **** 20/05/2011 - Eternus **** */
                        //Commented and Replaced Start_Year__c and End_Year__c to Goal_Start_Year__c and Goal_End_Year__c respectively
                        //goal.Start_Year__c = Date.today().year();
                        //goal.End_Year__c = Date.today().addMonths(12).year();
                        
                        /** Eternus Solutions      **/
                        /** Author  : Manasi Ranade*/
                        /** Issue Id: F0006      **/
                        /** Date    : 23/05/2011 **/
                        /** Purpose :  Added Priority to the Goal by default as 'High'. 
                                      And replaced Start_Year__c to Goal_Start_Year__c,End_Year__c to Goal_End_Year__c
                                      At the time of assigning defual values to the fields **/
                        /****************************************************/
                        Goal.Priority__c='High';
                        
                        /*  Prajakta - FP changes - 10-04-2013 */
                       /* goal.Goal_Start_Year__c = String.valueOf(a.Plan_Generation_Date__c.year());
                        goal.Goal_End_Year__c = String.valueOf(a.Plan_Generation_Date__c.addMonths(12).year());*/
                        goal.Goal_Start_Year__c = String.valueOf(Date.today().year());
                        goal.Goal_End_Year__c = String.valueOf(Date.today().addMonths(12).year());
                        goalList.add(goal);
                        globalAssumptionList.add(globalAspt);
                        //Create EntityRelatedAttachment__c  for parent entity after insert
                        EntityRelatedAttachment__c relatedAttachment = new EntityRelatedAttachment__c();
                        relatedAttachment.Related_Entity__c = a.Id;
                        insertEntityRelatedAttachmentList.add(relatedAttachment);
                    }
                }
                
	            insert globalAssumptionList;
	            insert goalList;
	            //Create EntityRelatedAttachment__c  for parent entity after insert
	            insert insertEntityRelatedAttachmentList;
    }
}
    //Code Added By : Aditi Satpute
    //Purpose : Update global Assumptions on change of Virtual Partner's i.e : on entity update
    //Date : 14/12/12
 /*   if(trigger.isBefore && trigger.isUpdate)
    {
    	          
		List<Entity_Global_Assumption__c> lstGlobalAssump = [select Expected_Return_on_Investment__c,Account__c,Income_Growth_Rate__c,Inflation_Rate__c,Stock_Growth_Rate__c
							,Gold_Growth_Rate__c,	  
							Number_Of_Months__c,Default_Retirement_Age__c,Default_Estimated_Life_Expectancy__c from Entity_Global_Assumption__c
							where Account__c =: trigger.newMap.keyset()];			
		
    	Map<Id,Entity_Global_Assumption__c>	EntityIdToEntityGlobalAssumption = new 	Map<Id,Entity_Global_Assumption__c>();
    	
    	for(Entity_Global_Assumption__c objEntityGlobalAssumption : lstGlobalAssump)		
    	{
    		if(!EntityIdToEntityGlobalAssumption.containsKey(objEntityGlobalAssumption.Account__c))
		 		EntityIdToEntityGlobalAssumption.put(objEntityGlobalAssumption.Account__c,objEntityGlobalAssumption);
    	}			
          
      	List<Entity_Global_Assumption__c> globalAssumptionList=new List<Entity_Global_Assumption__c>();
        
        //============================================================================================================
     
        List<Goal__c>goalList=new List<Goal__c>();
        //Create EntityRelatedAttachment__c  for parent entity after insert
        List<EntityRelatedAttachment__c> insertEntityRelatedAttachmentList = new List<EntityRelatedAttachment__c>(); 
        Schema.DescribeFieldResult fieldResult = Goal__c.Goal_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        String goalType,goalDesc;
  
        //start of VirtualPartner related changes
        //Code Added By : Aditi
        //Date : 03/09/12
        //need to comment below
        Map<Id,Account> mapVirtualIdToAccount = new Map<Id,Account>();
        List<Account> lstVirtualAcc = new List<Account>();
        Account FfreedomAcc = new Account();
        //lstVirtualAcc = [select id,Expected_Return_on_Investment__c,Income_Growth_Rate__c,Inflation_Rate__c,Default_Estimated_Life_Expectancy__c,Number_Of_Months__c,Default_Retirement_Age__c from Account where Related_To__c = 'Virtual Partner' and RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c];
         Account objAcc; 
        //start of Partner Portal related changes
        //Code Added By : Aditi
        //Date : 31/07/12
        List<Account> lstAcc=trigger.new;
        system.debug('******lstAcc******'+lstAcc);
        //To fetch the current User through the OwnerId 
        
                //================================================================================================================================
                
                User user=[select Id,Name,ProfileId,ContactId,Profile.Name from User where Id=:lstAcc[0].OwnerId];
                Contact con;
                Account acc;
                if(user.ContactId!=null)
                {
                    //To fetch Contact of that particular User
                    con=[select AccountId from Contact where id =: user.ContactId];
                    //To fetch Account with previously fetched Contact
                    acc=[select Id,Logo__c, Email_ID__c,IsCreatedByPartner__c,Expected_Return_on_Investment__c,Income_Growth_Rate__c,Stock_Growth_Rate__c,Inflation_Rate__c,Default_Estimated_Life_Expectancy__c,Number_Of_Months__c,Company_Address__c,Default_Retirement_Age__c,Phone,Name from account where id =: con.AccountId];    
                }
                else 
                {
                    lstVirtualAcc = [select id,Expected_Return_on_Investment__c,Income_Growth_Rate__c,Inflation_Rate__c,Default_Estimated_Life_Expectancy__c,Number_Of_Months__c,Stock_Growth_Rate__c,Default_Retirement_Age__c from Account where Related_To__c = 'Virtual Partner' and RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c];
                            
                }
                
                Entity_Global_Assumption__c globalAspt=new Entity_Global_Assumption__c();
                Goal_Profile__c objUpdateGoalProfile = new Goal_Profile__c();
 				 FfreedomAcc = [select id,Expected_Return_on_Investment__c,Income_Growth_Rate__c,Inflation_Rate__c,Default_Estimated_Life_Expectancy__c,Number_Of_Months__c,Stock_Growth_Rate__c,Default_Retirement_Age__c from Account where Related_To__c = 'Ffreedom' and RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c limit 1];
                          
                system.debug('DDDDDDDDDDDDDD :)   :'+lstAcc);
                for(account a:lstAcc){
                    globalAssumptionList=new List<Entity_Global_Assumption__c>();
                    Entity_Global_Assumption__c GlobalAssump;
                    
                if(EntityIdToEntityGlobalAssumption.containsKey(a.Id))
 				{
 				//obj[0].IsCreatedByPartner__c =true;
 					system.debug('@@@@@@@@@@@@22 :'+GlobalAssump);
 					GlobalAssump = EntityIdToEntityGlobalAssumption.get(a.Id);
 					
        
               	 if(a.Parent_Entity__c==null)
               	 {
                    system.debug('In if++++++a : '+a);
                    System.debug('********* After Insert CreateGlobalAssumptions trigger: Goal Creation Logic *************');
                    //Condition added to distinguish Partner Portal 
                    if(user.ContactId!=null)
                    {
                        if(GlobalAssump != null)
                        {
                        	//GlobalAssump.Account__c= a.id;
                            GlobalAssump.Expected_Return_on_Investment__c=acc.Expected_Return_on_Investment__c;
                            GlobalAssump.Income_Growth_Rate__c=acc.Income_Growth_Rate__c;
                            GlobalAssump.Inflation_Rate__c=acc.Inflation_Rate__c;
                            GlobalAssump.Number_Of_Months__c=acc.Number_Of_Months__c;
                            GlobalAssump.Default_Retirement_Age__c = acc.Default_Retirement_Age__c;
                            GlobalAssump.Default_Estimated_Life_Expectancy__c = acc.Default_Estimated_Life_Expectancy__c;
                            GlobalAssump.Stock_Growth_Rate__c = acc.Stock_Growth_Rate__c;
                        }
                        
                    }      
                //Code added for VirtualPartner related changes By Aditi
                //Date : 03/09/12
                //======================================================================================================================
                //need to comment below
                    else if(a.Related_To__c == 'Virtual Partner' && a.RecordTypeId != RecTypes__c.getInstance('General_Business').Record_Type_Value__c )
                    {
                            if(lstVirtualAcc != null && lstVirtualAcc.size() > 0 )
                          {
                            for(Account objAccount : lstVirtualAcc)
                            {
                                mapVirtualIdToAccount.put(objAccount.Id,objAccount);
                            }
                          }
                        system.debug('In else if : a.Related_To__c == Virtual Partner');
                        if(mapVirtualIdToAccount.containsKey(a.Virtual_Partner__c))
                        {
                            objAcc = mapVirtualIdToAccount.get(a.Virtual_Partner__c);
                        }
                        system.debug('****Virtual Acc*****'+objAcc);
                        if(GlobalAssump != null)
                        {                            
                            //GlobalAssump.Account__c= a.id;
                            GlobalAssump.Expected_Return_on_Investment__c=objAcc.Expected_Return_on_Investment__c;
                            GlobalAssump.Income_Growth_Rate__c=objAcc.Income_Growth_Rate__c;
                            GlobalAssump.Inflation_Rate__c=objAcc.Inflation_Rate__c;
                            GlobalAssump.Number_Of_Months__c=objAcc.Number_Of_Months__c;
                            GlobalAssump.Default_Retirement_Age__c = objAcc.Default_Retirement_Age__c;
                            GlobalAssump.Default_Estimated_Life_Expectancy__c = objAcc.Default_Estimated_Life_Expectancy__c;
                            GlobalAssump.Stock_Growth_Rate__c = objAcc.Stock_Growth_Rate__c;
                        }
                    }
                //======================================================================================================================
                else
                {
                    if(GlobalAssump != null)
                    { 
                       // GlobalAssump.Account__c= a.id;
                        GlobalAssump.Expected_Return_on_Investment__c=FfreedomAcc.Expected_Return_on_Investment__c;
                        GlobalAssump.Income_Growth_Rate__c=FfreedomAcc.Income_Growth_Rate__c;
                        GlobalAssump.Inflation_Rate__c=FfreedomAcc.Inflation_Rate__c;
                        GlobalAssump.Number_Of_Months__c=FfreedomAcc.Number_Of_Months__c;
                     
                        GlobalAssump.Default_Retirement_Age__c = FfreedomAcc.Default_Retirement_Age__c;
                        GlobalAssump.Default_Estimated_Life_Expectancy__c = FfreedomAcc.Default_Estimated_Life_Expectancy__c; 
                        GlobalAssump.Stock_Growth_Rate__c = FfreedomAcc.Stock_Growth_Rate__c;
                    }
                    
                }
               
                globalAssumptionList.add(GlobalAssump);
                    
                	}
            	}
              }
	        system.debug('******globalAssumptionList in update********'+globalAssumptionList);
	        update globalAssumptionList;
	        //Create EntityRelatedAttachment__c  for parent entity after insert
	        //upsert insertEntityRelatedAttachmentList;
    }
}*/