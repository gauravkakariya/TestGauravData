/* 
	Revision History:
	
    Version     Version Author     Date           Comments
    1.0         Prajakta Sanap     29/08/2013     Handler class for Account Trigger - 
												  Used to update RPP Revenue Details from Client Entities 
												  to Busniess entities and its corresponding Manager's Account 
*/

public with sharing class AccountRevenueHandler 
{
	public static void updateField (List<Account>accountNewList,map<Id,Account> accountOldMap)
    {
        map<Id,List<Account>> mapUserTolstAccount = new map<Id,List<Account>>();
        set<Id> accountUpdatedIdSet = new set<Id>();
        list<Account> accountUpdatedList = new list<Account>();
        
        for (Account account : accountNewList)
        {
        	//To collect the accounts  in the list whose respective field is updated
            if ((/*account.Recommended_Revenue__c != accountOldMap.get(account.Id).Recommended_Revenue__c 
            	|| account.Actual_Revenue__c != accountOldMap.get(account.Id).Actual_Revenue__c
            	|| */account.Expected_Upfront_Commission__c != accountOldMap.get(account.Id).Expected_Upfront_Commission__c
            	|| account.Expected_Trail_Commission__c != accountOldMap.get(account.Id).Expected_Trail_Commission__c
            	|| account.Actual_Upfront_Commission__c != accountOldMap.get(account.Id).Actual_Upfront_Commission__c
            	|| account.Actual_Trail_Commission__c != accountOldMap.get(account.Id).Actual_Trail_Commission__c)
            	&& account.Parent_User__c == null)
            {
                accountUpdatedList.add(account);
            	system.debug('accountUpdatedList------------>'+accountUpdatedList);
            }    
        }
        
        //Created map of User to respective list of accounts
        for(Account objAcc : accountUpdatedList)
        {
        	system.debug('in for------------>');
            List<Account> lstAccount = new List<Account>();
            if(mapUserTolstAccount.containsKey(objAcc.OwnerId))
            {
                lstAccount = mapUserTolstAccount.get(objAcc.OwnerId);
                lstAccount.add(objAcc);
            }
            else
            {
                lstAccount.add(objAcc);
            }
            mapUserTolstAccount.put(objAcc.OwnerId, lstAccount);
        }
        system.debug('mapUserTolstAccount------------>'+mapUserTolstAccount);
        
        //Fetch the list of accounts which are the general record type - business accounts corrsponding to user
        List<Account> accountList = [Select isUserAccount__c, Parent_User__c,
        							/*Recommended_Revenue__c,  Actual_Revenue__c,*/
        							Expected_Upfront_Commission__c, Expected_Trail_Commission__c,
        							Actual_Upfront_Commission__c, Actual_Trail_Commission__c
        							From Account
        							where Parent_User__c in : mapUserTolstAccount.keyset()];
        
        List<Account> lstA = new List<Account>();
        for(Account objAccount : accountList )
        {
            /*Decimal totalRecRevenue = 0.0;
            Decimal oldRecRevenue = 0.0;
            Decimal revenueToMinus = 0.0;
            Decimal totalActualRevenue = 0.0;
            Decimal oldActualRevenue = 0.0;
            Decimal actualRevenueToMinus = 0.0;
            */
            Decimal totalExpUpfront = 0.0;
            Decimal oldExpUpfront = 0.0;
            Decimal expUpfrontToMinus = 0.0;
            Decimal totalExpTrail = 0.0;
            Decimal oldExpTrail = 0.0;
            Decimal expTrailToMinus = 0.0;
            
            Decimal totalAUpfront = 0.0;
            Decimal oldAUpfront = 0.0;
            Decimal aUpfrontToMinus = 0.0;
            Decimal totalATrail = 0.0;
            Decimal oldATrail = 0.0;
            Decimal aTrailToMinus = 0.0;
            
            /*if (objAccount.Recommended_Revenue__c != null)
                oldRecRevenue = objAccount.Recommended_Revenue__c;
			if (objAccount.Actual_Revenue__c != null)
				oldActualRevenue = objAccount.Actual_Revenue__c; 
			*/
			if (objAccount.Expected_Upfront_Commission__c != null)
                oldExpUpfront = objAccount.Expected_Upfront_Commission__c;
			if (objAccount.Expected_Trail_Commission__c != null)
				oldExpTrail = objAccount.Expected_Trail_Commission__c;
			if (objAccount.Actual_Upfront_Commission__c != null)
                oldAUpfront = objAccount.Actual_Upfront_Commission__c;
			if (objAccount.Actual_Trail_Commission__c != null)
				oldATrail = objAccount.Actual_Trail_Commission__c;
			
            if(mapUserTolstAccount.containsKey(objAccount.Parent_User__c ))
            {
                List<Account> lstAccount = mapUserTolstAccount.get(objAccount.Parent_User__c);
                //For all the entities having same owner
                for(Account A : lstAccount )
                {
                    //totalRecRevenue += A.Recommended_Revenue__c;
                    //totalActualRevenue += A.Actual_Revenue__c;
                    totalExpUpfront += A.Expected_Upfront_Commission__c;
                    totalExpTrail += A.Expected_Trail_Commission__c;
                    totalAUpfront += A.Actual_Upfront_Commission__c;
                    totalATrail += A.Actual_Trail_Commission__c;
                    
                    Account oldAccount = (Account)trigger.oldMap.get(A.Id);
                    //revenueToMinus += oldAccount.Recommended_Revenue__c == null ?  0.0 : oldAccount.Recommended_Revenue__c;
                    //actualRevenueToMinus += oldAccount.Actual_Revenue__c == null ? 0.0 : oldAccount.Actual_Revenue__c;
                    expUpfrontToMinus += oldAccount.Expected_Upfront_Commission__c == null ? 0.0 : oldAccount.Expected_Upfront_Commission__c;
                    expTrailToMinus += oldAccount.Expected_Trail_Commission__c == null ? 0.0 : oldAccount.Expected_Trail_Commission__c;
                    aUpfrontToMinus += oldAccount.Actual_Upfront_Commission__c == null ? 0.0 : oldAccount.Actual_Upfront_Commission__c;
                    aTrailToMinus += oldAccount.Actual_Trail_Commission__c == null ? 0.0 : oldAccount.Actual_Trail_Commission__c;
                    
                }
                
                /*To check if there is already any total value present in the field and 
                then if updated any value, add the new one and subtract the old one to get the actual total */
                
//                system.debug('totalRecRevenue --->'+totalRecRevenue +'---revenueToMinus --->'+revenueToMinus + '---oldRecRevenue --->'+oldRecRevenue );
               // objAccount.Recommended_Revenue__c = oldRecRevenue + totalRecRevenue - revenueToMinus;
                //objAccount.Actual_Revenue__c = oldActualRevenue + totalActualRevenue - actualRevenueToMinus;
                objAccount.Expected_Upfront_Commission__c = oldExpUpfront + totalExpUpfront - expUpfrontToMinus;
                objAccount.Expected_Trail_Commission__c = oldExpTrail + totalExpTrail - expTrailToMinus;
                objAccount.Actual_Upfront_Commission__c = oldAUpfront + totalAUpfront - aUpfrontToMinus;
                objAccount.Actual_Trail_Commission__c = oldATrail + totalATrail - aTrailToMinus;
                
                lstA.add(objAccount);
            }
            system.debug('-------objAccount------------>'+objAccount);
        }
        update lstA;
        system.debug('-------lstA------------>'+lstA);
        
        
        //===================Recursive Function to update the Manager corresponding Accounts RPP fields.========================================================
        
        List<Account> userAccountList = new List<Account>();
        set<id>userIdSet = new set<id>();
        map<Id, Account> mapUserIdToAccount = new map<Id, Account>();
        
        for (Account account : accountNewList) 
        {
        	if ((/*account.Recommended_Revenue__c != accountOldMap.get(account.id).Recommended_Revenue__c 
        		|| account.Actual_Revenue__c != accountOldMap.get(account.Id).Actual_Revenue__c
        		||*/ account.Expected_Upfront_Commission__c != accountOldMap.get(account.Id).Expected_Upfront_Commission__c
            	|| account.Expected_Trail_Commission__c != accountOldMap.get(account.Id).Expected_Trail_Commission__c
            	|| account.Actual_Upfront_Commission__c != accountOldMap.get(account.Id).Actual_Upfront_Commission__c
            	|| account.Actual_Trail_Commission__c != accountOldMap.get(account.Id).Actual_Trail_Commission__c)
        		&& account.Parent_User__c != null)
        	{
        		mapUserIdToAccount.put(account.Parent_User__c, account);
        		userAccountList.add(account);
        		userIdSet.add(account.Parent_User__c);
        	}	
        }
        
        if (userAccountList.size() != 0) 
        {
        	set <Id> managerIdSet = new Set<Id>();
        	map <Id,list<User>> mapIdTolstUser = new map <Id,list<User>>();
        	
        	list<User> userList = [Select u.Name, u.ManagerId, u.IsActive, u.Id From User u 
        	                       where u.IsActive = true and u.id in :userIdSet and u.ManagerId != null];
        	
        	//Map of User to it's corresponding general record type - business account.
        	for (User user : userList) 
        	{
        		if(mapIdTolstUser.containsKey(user.ManagerId))
        		{
        			mapIdTolstUser.get(user.ManagerId).add(user);
        		}
        		else
        		{
        			mapIdTolstUser.put(user.ManagerId,new List<User>{user});
        		}
        		managerIdSet.add(user.ManagerId);
        	}
        	List<Account> managerAccountList = [Select a.isUserAccount__c, a.Parent_User__c,a.Name, a.Id, 
        										/*a.Actual_Revenue__c, a.Recommended_Revenue__c,*/  
        										a.Expected_Upfront_Commission__c, a.Expected_Trail_Commission__c,
        										a.Actual_Upfront_Commission__c, a.Actual_Trail_Commission__c
        								        From Account a 
        								        where a.Parent_User__c in : managerIdSet];	
        								        
        	for(Account acc : managerAccountList)
        	{
        		/*Decimal oldValue = acc.Recommended_Revenue__c == null ? 0.0 : acc.Recommended_Revenue__c;					        
        		Decimal oldToMinus = 0.0;
        		Decimal totalRecRevenueFinal = 0.0; 
        		
        		Decimal oldActualValue = acc.Actual_Revenue__c == null ? 0.0 : acc.Actual_Revenue__c;					        
        		Decimal oldActualToMinus = 0.0;
        		Decimal totalActualRevenueFinal = 0.0;
        		*/
        		Decimal oldExpUpfront = acc.Expected_Upfront_Commission__c == null ? 0.0 : acc.Expected_Upfront_Commission__c;					        
        		Decimal oldExpUpfrontToMinus = 0.0;
        		Decimal totalExpUpfrontFinal = 0.0; 
        		
        		Decimal oldExpTrail = acc.Expected_Trail_Commission__c == null ? 0.0 : acc.Expected_Trail_Commission__c;					        
        		Decimal oldExpTrailToMinus = 0.0;
        		Decimal totalExpTrailFinal = 0.0;
        		
        		Decimal oldAUpfront = acc.Actual_Upfront_Commission__c == null ? 0.0 : acc.Actual_Upfront_Commission__c;					        
        		Decimal oldAUpfrontToMinus = 0.0;
        		Decimal totalAUpfrontFinal = 0.0; 
        		
        		Decimal oldATrail = acc.Actual_Trail_Commission__c == null ? 0.0 : acc.Actual_Trail_Commission__c;					        
        		Decimal oldATrailToMinus = 0.0;
        		Decimal totalATrailFinal = 0.0;
        		
        		for(User u : mapIdTolstUser.get(acc.Parent_User__c))
        		{
        			Account userAcc = mapUserIdToAccount.get(u.Id);
        			Account userAccOld = accountOldMap.get(userAcc.id);
        			
        			/*oldToMinus += userAccOld.Recommended_Revenue__c == null? 0.0 : userAccOld.Recommended_Revenue__c;
        			totalRecRevenueFinal += userAcc.Recommended_Revenue__c == null? 0.0 : userAcc.Recommended_Revenue__c;
        			
        			oldActualToMinus += userAccOld.Actual_Revenue__c == null? 0.0 : userAccOld.Actual_Revenue__c;
        			totalActualRevenueFinal += userAcc.Actual_Revenue__c == null? 0.0 : userAcc.Actual_Revenue__c;
        			*/
        			oldExpUpfrontToMinus += userAccOld.Expected_Upfront_Commission__c == null? 0.0 : userAccOld.Expected_Upfront_Commission__c;
        			totalExpUpfrontFinal += userAcc.Expected_Upfront_Commission__c == null? 0.0 : userAcc.Expected_Upfront_Commission__c;
        			
        			oldExpTrailToMinus += userAccOld.Expected_Trail_Commission__c == null? 0.0 : userAccOld.Expected_Trail_Commission__c;
        			totalExpTrailFinal += userAcc.Expected_Trail_Commission__c == null? 0.0 : userAcc.Expected_Trail_Commission__c;
        			
        			oldAUpfrontToMinus += userAccOld.Actual_Upfront_Commission__c == null? 0.0 : userAccOld.Actual_Upfront_Commission__c;
        			totalAUpfrontFinal += userAcc.Actual_Upfront_Commission__c == null? 0.0 : userAcc.Actual_Upfront_Commission__c;
        			
        			oldATrailToMinus += userAccOld.Actual_Trail_Commission__c == null? 0.0 : userAccOld.Actual_Trail_Commission__c;
        			totalATrailFinal += userAcc.Actual_Trail_Commission__c == null? 0.0 : userAcc.Actual_Trail_Commission__c;
				}
				
				//acc.Recommended_Revenue__c = oldValue + totalRecRevenueFinal - oldToMinus;
				//acc.Actual_Revenue__c = oldActualValue + totalActualRevenueFinal - oldActualToMinus;
				acc.Expected_Upfront_Commission__c = oldExpUpfront + totalExpUpfrontFinal - oldExpUpfrontToMinus;
				acc.Expected_Trail_Commission__c = oldExpTrail + totalExpTrailFinal - oldExpTrailToMinus;
				acc.Actual_Upfront_Commission__c = oldAUpfront + totalAUpfrontFinal - oldAUpfrontToMinus;
				acc.Actual_Trail_Commission__c = oldATrail + totalATrailFinal - oldATrailToMinus;
        	}
        	update managerAccountList;
        	
        }
    }
}