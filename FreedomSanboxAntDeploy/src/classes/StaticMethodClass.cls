//00001556
/*
	Revision History:
	
  	Version     Version Author     Date        Comments
   	1.0			Eternus			   28/3/2012   This class will contain the static methods.To avoid repeatation of SOQL in code
*/
public with sharing class StaticMethodClass {
	public static Entity_Global_Assumption__c globalAssumptObj;
	public static Account accountObj;
	public static List<Account> EntitiesList;
	public static Map<Id,List<Goal__c>> entityGoalMap = new Map<Id,List<Goal__c>>();
	public static Map<Id,List<GoalSIPAmount__c>> goalSipAmountMap = new Map<Id,List<GoalSIPAmount__c>>();
	public static Id entityId;
	public static Integer iTemp ;
	public static Boolean isAccountUpsertFired = true; /* Prajakta - 6-9-2013 */
	public static Boolean isUpdateFired = true; /* Prajakta - 29-10-2013 - To avoid the Too Many SOQL while making the Team Member change for the partner*/
	public static Boolean isAccountSubmitHandlerFired = true; /* Aditi - 3-12-2013 */
	public static boolean isFlatCommissionUpateforPartner = true;
	
	
	public static Entity_Global_Assumption__c getEntityGlobalAssumption
	{
		get
		{
			if(globalAssumptObj == null)
			{
					   List<Entity_Global_Assumption__c> globalAssumptionList=[
                       SELECT 
                              Expected_Return_on_Investment__c,Income_Growth_Rate__c,
                              Inflation_Rate__c,Account__c,Number_Of_Months__c , Stock_Growth_Rate__c,
                              Gold_Growth_Rate__c,	   /* Prajakta - FP changes - 01-04-2013 */
                              Default_Estimated_Life_Expectancy__c,Default_Retirement_Age__c
                       FROM
                               Entity_Global_Assumption__c
                       WHERE 
                                Account__c =: entityId
                       ];
                       if(globalAssumptionList != null && globalAssumptionList.size() > 0)
                      	globalAssumptObj =  globalAssumptionList[0];
			}
			return globalAssumptObj;
		}
		Set;
	}
	public static Account getEntity
	{
		get
		{
			
			if(accountObj == null)
			{
				
					    List<Account> accList = [ SELECT 
                                    isPersonAccount, RecordTypeId, FirstName, LastName, Name,owner.name,Adjustment_Factor__c,
                                    PersonTitle, PersonContactId, PersonBirthdate, PersonHomePhone,Salutation,
                                    PersonMobilePhone, Alternate_Mobile__c, PersonEmail, Alternate_E_Mail_Address__c,
                                    Health_History_del__c, Fax, Office_Phone_2__c, Parent_Entity__c,Retirement_Year__c,
                                    Residential_Status_del__c,Retirement_Age__c,Estimated_Life_Expectancy__c,Estimated_Life_EndYear__c,
                                    BillingCity, BillingCountry, BillingPostalCode,BillingState,PersonMailingCity,PersonMailingCountry, 
                                    PersonMailingPostalCode,PersonMailingState,PersonOtherCity,PersonOtherCountry, 
                                    PersonOtherPostalCode,PersonOtherState, BillingStreet,PersonMailingStreet, PersonOtherStreet, 
                                    Relationship_to_Entity__pc,PAN_ID__pc,Passport__pc,Middle_Name__pc,Marital_Status__pc,Gender__pc,Will__c,Description,OwnerId,
                                    IsExecutionTrackerGenerated__c //Added new field in select Statement
                            FROM 
                                account 
                            WHERE 
                                isPersonAccount = :true
                            AND id=:entityId
                        ];  
                       if(accList != null && accList.size() > 0)
                      	accountObj =  accList[0];
			}
			
			return accountObj;
		}
		Set;
	}
	public static Account getSpouseEntity
	{
		get
		{
			if(accountObj == null)
			{
					    List<Account> accList = [
                                SELECT 
                                    Name,Parent_Entity__c, FirstName, LastName,Estimated_Life_Expectancy__c,
                                    Relationship_to_Entity__pc,PersonBirthdate
                                FROM 
                                    Account  
                                WHERE 
                                    isPersonAccount =: true 
                                AND 
                                    Parent_Entity__c =: entityId 
                                AND 
                                    Relationship_to_Entity__pc IN ('Wife','Husband')
                                ORDER BY 
                                    Id 
                        ];  
                       if(accList != null && accList.size() > 0)
                      	accountObj =  accList[0];
			}
			return accountObj;
		}
		Set;
	}
	public static List<Account> getFamilyDetails
	{
		get
		{
			if(EntitiesList == null)
			{
					    List<Account> accList = [SELECT Id, Name, isPersonAccount, Parent_Entity__c, FirstName, LastName,Total_Assets__c,Total_Income__c, 
                            Total_Investment_Assets__c,Total_Liabilities__c,Investment_Asset_Rollup__c,
                            RecordTypeId,Adjustment_Factor__c,
                            PersonTitle, PersonContactId, PersonBirthdate, PersonHomePhone,Salutation,
                            PersonMobilePhone, Alternate_Mobile__c, PersonEmail, Alternate_E_Mail_Address__c,
                            Retirement_Year__c,Residential_Status_del__c,Retirement_Age__c,Estimated_Life_Expectancy__c,
                            Estimated_Life_EndYear__c,Relationship_to_Entity__pc,	
							IsExecutionTrackerGenerated__c,owner.name,Earning_member__c
        FROM Account WHERE isPersonAccount =: true AND (Id =: entityId OR Parent_Entity__c =: entityId)order by Id  ];
        EntitiesList = accList;
			}
			return EntitiesList;
		}
		Set;
	}
	public static Map<Id,List<GoalSIPAmount__c>> getgoalSIPAmtMap
	{
		get
		{
			if(iTemp == null)
					iTemp = 0;
				iTemp++;
				
			if(goalSipAmountMap.size() == 0)
			{
				List<Goal__c> goalList = [select id from Goal__c where Entity__c =: entityId];
				//List<GoalSIPAmount__c> goalSipAmtList = [Select GoldCurrentYear__c,EquityCurrentYear__c,DebtCurrentYear__c,goal__c From GoalSIPAmount__c 
										//Where goal__c in : goalList
										//and Goal_Year__c =: system.today().Year()];
				for(GoalSIPAmount__c goalSIPAmtObj : [Select GoldCurrentYear__c,EquityCurrentYear__c,DebtCurrentYear__c,goal__c From GoalSIPAmount__c 
										Where goal__c in : goalList
										and Goal_Year__c =: system.today().Year()])
				{
					if(goalSipAmountMap.get(goalSIPAmtObj.goal__c) == null)
			        {
			            goalSipAmountMap.put(goalSIPAmtObj.goal__c, new list<GoalSIPAmount__c>{goalSIPAmtObj});
			        }
			        else
			        {
			            goalSipAmountMap.get(goalSIPAmtObj.goal__c).add(goalSIPAmtObj);
			        }
				}
			}
			return goalSipAmountMap;
		}
		set;
	}
	
	public static List<Goal__c> getAllGoals(String strentityId)
	{
		if(entityGoalMap.ContainsKey(strentityId))
		{
			return entityGoalMap.get(strentityId);
		}
		else if(entityId != null)
		{
			   List<goal__c> lstgoal = [
                        SELECT 
                                entity__c,Goal_Type__c,RemoveCheckbox__c,Start_Year__c,
                                End_Year__c,Inflation_Rate__c,Cost_of_Goal_Annual__c,
                                Priority__c,Description__c,SelectedGoalProfile__c,
                                Goal_Frequency__c,Goal_Start_Year__c,Goal_End_Year__c  
                        FROM 
                            goal__c 
                        WHERE 
                            Entity__c  = :strentityId                              
                        OR
                            Entity__r.Parent_Entity__c = :strentityId];
              if(lstgoal != null && lstgoal.size() > 0)
              {
              	entityGoalMap.put(strentityId,lstgoal);
              }
		}
			return entityGoalMap.get(strentityId);
	}
	@isTest
	static void testStaticmethode()
	{
		test.startTest();
		TestData_Ffreedom testData = new TestData_Ffreedom();
		Account act = testData.initializeAccount();
	 	insert act;
	   	Account son = testData.init_FamilyMember(act);
	    insert son;
	   
	   	StaticMethodClass.entityId = act.id;
		List<Goal__c> lstGoals = StaticMethodClass.getAllGoals(act.Id);
		Map<Id,List<GoalSIPAmount__c>> goalSipMap = new Map<Id,List<GoalSIPAmount__c>>();
		goalSipMap = StaticMethodClass.getgoalSIPAmtMap;
		List<Account> actList = StaticMethodClass.getFamilyDetails;
		Account objAccountTest = StaticMethodClass.getSpouseEntity;
		Account objEntityTest =  StaticMethodClass.getEntity;
		Entity_Global_Assumption__c objGlobalAssumptionTest = StaticMethodClass.getEntityGlobalAssumption;
		test.stopTest();
	}
}