/* 
*  Controller class created for Personal Information Component
*
*   Revision History:
*
*   Version			Author             Date          Description
*   1.0         Prajakta Sanap		21/02/2013 	 	Initial Draft 
*  	2.0			Prajakta Sanap      01/04/2013      Added Gold Growth Rate for the new record type Gold in Investment Asset	
*/

public class PersonalInformationController 
{
	
	public string entityId{get;set;}
	public DatabaseSOQL dbSOQLObj {get; set;}
	public List<Account> lstAccount{get;set;}
	public List<PersonalInfo> lstPersonalInfo{get;set;}
	//public List<GlobalAssumptions> lstGlobalAssumptions{get;set;}		/*Prajakta - 28-03-2013*/
	public String isWill{get;set;}
	public List<Entity_Global_Assumption__c> lstGlobalAssumption{get;set;}
	public GlobalAssumptions newGlobalAssumptions{get;set;}
	
	/*Constructor*/
	public PersonalInformationController()
	{
		lstAccount = new List<Account>();
		dbSOQLObj = new DatabaseSOQL();
		Map<Id,Account> mapIdToAccount = new Map<Id,Account>();
		entityId = System.currentPageReference().getParameters().get('entityId');
		lstAccount = dbSOQLObj.getFamilyMembers(entityId);
		lstPersonalInfo = new List<PersonalInfo>();
		//lstGlobalAssumptions = new List<GlobalAssumptions>();			/*Prajakta - 28-03-2013*/
		//Prajakta 21-2-2013
    	
    	lstGlobalAssumption = new List<Entity_Global_Assumption__c>(); 
    	lstGlobalAssumption = [SELECT 
	                                  Expected_Return_on_Investment__c,Income_Growth_Rate__c,
	                                  Inflation_Rate__c,Account__c,Number_Of_Months__c ,Stock_Growth_Rate__c,
	                                  Gold_Growth_Rate__c,  /* Prajakta - FP changes - 01-04-2013 */
	                                  Default_Estimated_Life_Expectancy__c,Default_Retirement_Age__c
	                                  //,Account__r.Equity__c, Account__r.Debt__c, Account__r.Gold__c 		/*Prajakta - 28-03-2013*/
	                           FROM
	                                   Entity_Global_Assumption__c
	                           WHERE 
	                                    Account__c=:entityId];
	                                    
	                                    
		Account objAcc = [select Id, Name, Related_To__c, Virtual_Partner__c, OwnerId from Account where Id = :  entityId];
 	 	 	 
 	 	Account FfreedomAcc = new Account();
 	 	Account BusinessAcc = new Account();
 	 	Account VirtualAcc = new Account();
 	 	 	
 	 	List<Account> lstVirtualAcc = new List<Account>();
 	 	double Equity,Debt,Gold;
 	 	double ReturnExpected;
 	 	 
 	 	if(objAcc.Related_To__c == 'Ffreedom')
 	 	{
 	 	 	FfreedomAcc = [select id,Expected_Return_on_Investment__c,Equity__c,Gold__c,Debt__c,Income_Growth_Rate__c,Inflation_Rate__c,
 	 	 							Gold_Growth_Rate__c,  /* Prajakta - FP changes - 01-04-2013 */
 	 	 							Default_Estimated_Life_Expectancy__c,Number_Of_Months__c,Stock_Growth_Rate__c,Default_Retirement_Age__c 
 	 	 					from Account 
 	 	 					where Related_To__c = 'Ffreedom' 
 	 	 					and RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c 
 	 	 					limit 1];
 	 	 	Equity = FfreedomAcc.Equity__c;
 	 	 	Debt = FfreedomAcc.Debt__c;
 	 	 	Gold = FfreedomAcc.Gold__c;
 	 	}
 	 	else if(objAcc.Related_To__c == 'Business Partner')
 	 	{
 	 	 	map<id,User> mapUser = new map<id,User>([select Id,Name,ProfileId,ContactId,Profile.Name from User]);
 	 	 	map<id,Contact> mapContact = new map<id,Contact>([select id,AccountId from Contact]);
 	 	 	map<id,Account> BusinessAccMap = new map<id,Account>
													([select id,Expected_Return_on_Investment__c,Equity__c,Gold__c,Debt__c,Income_Growth_Rate__c,Inflation_Rate__c,
															Gold_Growth_Rate__c,  /* Prajakta - FP changes - 01-04-2013 */
						 	 	 							Default_Estimated_Life_Expectancy__c,Number_Of_Months__c,Stock_Growth_Rate__c,Default_Retirement_Age__c 
						 	 	 					from Account 
						 	 	 					where Related_To__c = 'Business Partner' 
						 	 	 					and RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c 
						 	 	 				    ]);
 	 	 	Account objBusinessAcc = new Account();
 	 	 	User objUser = new User();
 	 	 	Contact objContact = new Contact();
	 	 	 		
 	 	 	if(mapUser.containsKey(objAcc.OwnerId)) 
 	 	 	{
 	 	 		objUser = mapUser.get(objAcc.OwnerId);
 	 	 		if(objUser != Null)
 	 	 		{
					if(mapContact.containsKey(objUser.ContactId))
					{	
						objContact = mapContact.get(objUser.ContactId);
						if(objContact != Null)
						{
							if(BusinessAccMap.ContainsKey(objContact.AccountId))
							{
								objBusinessAcc = BusinessAccMap.get(objContact.AccountId);
								if(objBusinessAcc != null)
								{
									Equity = objBusinessAcc.Equity__c;
						 	 	 	Debt = objBusinessAcc.Debt__c;
						 	 	 	Gold = objBusinessAcc.Gold__c; 	 	
								}
							} 
						}
					}
 	 	 		}
 	 	 	}
	 	}
		 	 	 
 	 	else if(objAcc.Related_To__c == 'Virtual Partner')
 	 	{
 	 	 	 map<Id,Account> virtualAccMap = new map<Id,Account> 
						 	 	 					([select id,Expected_Return_on_Investment__c,Equity__c,Gold__c,Debt__c,Income_Growth_Rate__c,Inflation_Rate__c,
						 	 	 							Gold_Growth_Rate__c,  /* Prajakta - FP changes - 01-04-2013 */
						 	 	 							Default_Estimated_Life_Expectancy__c,Number_Of_Months__c,Stock_Growth_Rate__c,Default_Retirement_Age__c 
						 	 	 					from Account 
						 	 	 					where Related_To__c = 'Virtual Partner' 
						 	 	 					and RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c]);
 	 	 	Account objVirtualAcc = new Account();				
        	if(virtualAccMap.containsKey(objAcc.Virtual_Partner__c))
       		{
				objVirtualAcc = virtualAccMap.get(objAcc.Virtual_Partner__c);
				if(objVirtualAcc != null)
				{
					 Equity = objVirtualAcc.Equity__c;
		 	 	 	 Debt = objVirtualAcc.Debt__c;
		 	 	 	 Gold = objVirtualAcc.Gold__c;		
				}
       		}
 	 	}
 	 	
 	 	if(lstGlobalAssumption != null && lstGlobalAssumption.size() > 0)	                                    
			newGlobalAssumptions = new GlobalAssumptions(lstGlobalAssumption[0], Equity, Debt, Gold); 
		//---------------------------------------------------------
		
		for(Account objAccount : lstAccount)
		{
			if(!mapIdToAccount.ContainsKey(objAccount.Id))
			{
				mapIdToAccount.put(objAccount.Id,objAccount);
			}
		}
		for(Account objAccount : lstAccount)
		{
			String dependent = '';
			if(mapIdToAccount.ContainsKey(objAccount.Dependent__c))
			{
				Account objAcco = mapIdToAccount.get(objAccount.Dependent__c);
				dependent =objAcco.Name;
			}
			
			String strDate; 
			Datetime dtBirthdate = objAccount.PersonBirthdate;
			if(dtBirthdate != null)
				strDate = dtBirthdate.day() + '-' + dtBirthdate.month() + '-' + dtBirthdate.year();
			boolean isWill = false;
			String will = '';
			isWill = objAccount.Will__c;
			will = isWill ? 'Yes' : 'No';
			
			PersonalInfo objPersonalInfo = new PersonalInfo(objAccount, dependent, strDate, will);
			//objPersonalInfo.PersonalInfo(objAccount, dependent);
			lstPersonalInfo.add(objPersonalInfo);
		}
		system.debug('========lstPersonalInfo======='+lstPersonalInfo.size());
	}
	
	
	
	//Inner class
	public class PersonalInfo
	{
		public Account objAccount{get;set;}
		public String dependent{get;set;}
		public String strDate{get;set;}
		public String will{get;set;}
		
		public PersonalInfo(Account objAccount, String dependent, String strDate, String will)
		{
			this.objAccount = objAccount;
			this.dependent = dependent;
			this.strDate = strDate;
			this.will = will;
			
		}
	}
	
	/*Prajakta - 28-03-2013*/
	public class GlobalAssumptions
	{
		public Entity_Global_Assumption__c objGlobalAssumptions{get;set;}
		public Double Equity{get;set;}
		public Double Debt{get;set;}
		public Double Gold{get;set;}

		public GlobalAssumptions(Entity_Global_Assumption__c objGlobalAssumptions, Double Equity, Double Debt, Double Gold)
		{
			this.objGlobalAssumptions = objGlobalAssumptions;
			this.Equity = Equity;
			this.Debt = Debt;
			this.Gold = Gold;
		}
	}
}