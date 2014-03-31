/*
  
  Revision History:
  
    Version     Version Author     Date        Comments
    1.0         --                --         Initial Draft
    2.0     Manasi Ranade    28/12/2011   Issue Id : FS0386 :
                                              Code to create a new Service Deliverables record of type ‘New Member’ whenever ‘cheque received date 1’ is added.
   3.0          Dipak Nikam       1/04/2012     Issue Id :
                                                Code to create a new Service Deliverables record of type ‘New Member’ whenever new Entity get creates.            
*/

trigger CreateFirstRenewal on Account (after insert,after update) 
{
  /* Commented on 02Mar 2012 : because Cheque_Received_Date__c will be removed from Account object */
  /** Eternus Solutions - Manasi Ranade -FS0386 - 28/12/2011   **/
  /** Purpose : Code to create a new Service Deliverables record of type ‘New Member’ whenever ‘cheque received date 1’ is added. **/
  
  	List<Service_Deliverables__c> serviceDeliverableLst = new List<Service_Deliverables__c>();
  	String strStartOfFinancialYear = Label.StartOfFinancialYear,strEndOfFinancialYear = Label.EndOfFinancialYear;
  	Integer iCheckReceivedYear; 
  	ServiceDeliverablesCreation objServiceDeliverablesCreation = new ServiceDeliverablesCreation();
  	Date startOfFinYearDt,endOfFinYearDt;
  	List<Account> lstAccount = new List<Account>();
 
  	if(Trigger.isInsert && trigger.isAfter)
  	{
	    for(Account acc:Trigger.new)
    	{
			/** Eternus Solutions : Dipak Nikam : 4/1/2012  **/
            /** Purpose : to create a new Service Deliverables record of type ‘New Member’ whenever Enity ‘Created ’. **/
	      	if(acc.CreatedDate != null)
	      	{
	        	Date expirationDate = acc.CreatedDate.date();
	        	serviceDeliverableLst.add(objServiceDeliverablesCreation.createServiceDeliverables(expirationDate,acc.Id,strStartOfFinancialYear,strEndOfFinancialYear,Label.NewMemberRecType));
      		}
    	}
  	}
  
  	/*  Prajakta - FP changes - 10-04-2013 
    - To update the goal start and end year of Emergency Fund Goal according to Plan Generation Date */
    
  	List<Goal__c> goalList = new List<Goal__c>();
  	static Schema.DescribeFieldResult fieldResult = Goal__c.Goal_Type__c.getDescribe();
  	static List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
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
    
    lstAccount = trigger.new;
  	system.Debug('----------lstAccount--------'+lstAccount);
  	system.debug('------StaticMethodClass.isAccountUpsertFired-------'+StaticMethodClass.isAccountUpsertFired);

  	if(trigger.isAfter && trigger.isUpdate && StaticMethodClass.isAccountUpsertFired)  /* Prajakta - 9-6-2013 */
  	{
	    system.debug('------StaticMethodClass.isAccountUpsertFired--after-----'+StaticMethodClass.isAccountUpsertFired); 
	    Map<Id,List<Goal__c>> mapAccountTolstGoal = new Map<Id,List<Goal__c>>();
	    List<Goal__c> listGoal = [Select Priority__c, Id, Goal_Type__c, Goal_Start_Year__c, Goal_End_Year__c, Entity__c, Description__c 
				                  From Goal__c//];
				                  where Entity__c IN : lstAccount];
    
      	for(Goal__c objGoal : listGoal)
    	{
      		List<Goal__c> lstGoal = new List<Goal__c>();
        	if(mapAccountTolstGoal.containsKey(objGoal.Entity__c))
          	{
              	lstGoal = mapAccountTolstGoal.get(objGoal.Entity__c);
              	lstGoal.add(objGoal);
          	}
          	else
          	{
              	lstGoal.add(objGoal);
          	}
          	mapAccountTolstGoal.put(objGoal.Entity__c,lstGoal);
      	}
    
	    for(Account objAcc : trigger.new)
	    {
	      	if(mapAccountTolstGoal.containsKey(objAcc.Id))
	      	{
        		List<Goal__c> lstGoals = mapAccountTolstGoal.get(objAcc.Id);
        		for(Goal__c objGoal : lstGoals)
        		{
          			if(objAcc.Plan_Generation_Date__c != null )
          			{
            			if(objGoal.Goal_Type__c == goalType && objGoal.Description__c == goalDesc)
            			{
                      		objGoal.Goal_Start_Year__c = String.valueOf(objAcc.Plan_Generation_Date__c.year());
                      		objGoal.Goal_End_Year__c = String.valueOf(objAcc.Plan_Generation_Date__c.year()); //.addMonths(12).year());
                      		system.Debug('----------goal.Goal_Start_Year__c---------'+objGoal.Goal_Start_Year__c);
                      		system.Debug('----------goal.Goal_End_Year__c---------'+objGoal.Goal_End_Year__c);
                      		goalList.add(objGoal);
                      		system.Debug('----------goalList--------'+goalList);
            			}
          			}
        		}  
      		}  
    	}
    	update goalList;
  	}
  
      
  //Service Deliverables
  /** Eternus Solutions      **/
  /** Author  : Manasi Ranade*/
  /** Issue Id: FS0386      **/
  /** Date    : 28/12/2011  **/
  /** Purpose : to create a new Service Deliverables record of type ‘New Member’ whenever ‘cheque received date 1’ is added. **/
  /*if(Trigger.isUpdate && Trigger.isAfter) 
  {
    List<Account> lsAcc = trigger.new;
    for(Account objAcc : lsAcc)
    {
      Account objAccOld = trigger.oldMap.get(objAcc.Id);
      
      if(objAccOld.Cheque_Received_Date__c == null && objAcc.Cheque_Received_Date__c != null && objAcc.Cheque_date__c != objAccOld.Cheque_date__c)
      {
        serviceDeliverableLst.add(objServiceDeliverablesCreation.createServiceDeliverables(objAcc.Cheque_Received_Date__c,objAcc.Id,strStartOfFinancialYear,strEndOfFinancialYear,Label.NewMemberRecType));
      }
    }
  }*/
  	system.debug('***serviceDeliverableLst***'+serviceDeliverableLst);
  	insert serviceDeliverableLst;
}