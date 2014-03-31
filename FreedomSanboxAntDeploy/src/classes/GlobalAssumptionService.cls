/*
	Revision History:
	
    Version     Version Author     Date         Comments
    1.0         Persistent         NA  		  	Initial Draft
   
	2.0			Manasi Ranade	   30/05/2011   On the global assumption page, Customization of goal profile was compulsory.
												So added functionality of customization of goal profile as per user requirement.   
	3.0			Prajakta Sanap     01/04/2013   Added Gold Growth Rate for the new record type Gold in Investment Asset												 											
*/
public class GlobalAssumptionService 
{
	public boolean isDisplay{get;set;}
	public boolean flag =false;
   DatabaseDML databaseAccess=new DatabaseDML();
   DatabaseSOQL databaseObj = new DatabaseSOQL(); 
   List<GoalProfileBean> stdGoalProfileList=new List<GoalProfileBean>();
   List<GoalProfileBean>customGoalProfileList=new List<GoalProfileBean>();
   
 	public Entity_Global_Assumption__c  getEntityGlobalAssumption(String entitiId){
 		return databaseObj.getEntityGlobalAssumption(entitiId);
 	}
 	 public List<GoalProfileBean> getStdGoalProfileList(String riskProfile)
 	 {
 	 	 system.debug('*********riskProfile Global*****'+riskProfile);
 	 	 List<Goal_Profile__c>GoalProfileList = databaseObj.getStdGoalProfileList(riskProfile);
 	 	 
 	 	 Id EntityId = ApexPages.currentPage().getParameters().get('EntityId');
 	 	 
 	 	 system.debug('*********EntityId**: GlobalAssumptionService*****'+EntityId);
 	 	 Account objAcc = [select Id,Name,Related_To__c, Virtual_Partner__c, OwnerId, Risk_profile__c,
 	 	 					Plan_Generation_Date__c
 	 	 					from Account where Id = :  EntityId];
 	 	 system.debug('*********objAcc*******'+objAcc);
 	 	 Integer currentYear = objAcc.Plan_Generation_Date__c != null ? objAcc.Plan_Generation_Date__c.year() : system.today().year();
 	 	 
 	 	 Account FfreedomAcc = new Account();
 	 	 Account BusinessAcc = new Account();
 	 	 Account VirtualAcc = new Account();
 	 	 List<Account> lstVirtualAcc = new List<Account>();
 	 	 double Equity,Debt,Gold;
 	 	 double ReturnExpected;
 	 	 
 	 	 if(objAcc.Related_To__c == 'Ffreedom')
 	 	 {
 	 	 	FfreedomAcc = [select id,Expected_Return_on_Investment__c,Equity__c,Gold__c,Debt__c,Income_Growth_Rate__c,Inflation_Rate__c,
 	 	 							Gold_Growth_Rate__c,
 	 	 							Default_Estimated_Life_Expectancy__c,Number_Of_Months__c,Stock_Growth_Rate__c,Default_Retirement_Age__c 
 	 	 					from Account 
 	 	 					where Related_To__c = 'Ffreedom' 
 	 	 					and RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c 
 	 	 					limit 1];
 	 	 	Equity = FfreedomAcc.Equity__c;
 	 	 	Debt = FfreedomAcc.Debt__c;
 	 	 	//Gold = FfreedomAcc.Gold__c;
 	 	 	if(currentYear > 2013)
             {
             	system.debug('--in if-');
             	Gold = FfreedomAcc.Gold__c;
             }
             else
             {
             	system.debug('--in else-');
             	Gold = Double.valueOf(Label.Gold_Interest_Rate);
             }
 	 	 }
 	 	 else if(objAcc.Related_To__c == 'Business Partner')
 	 	 {
 	 	 	map<id,User> mapUser = new map<id,User>([select Id,Name,ProfileId,ContactId,Profile.Name from User]);
 	 	 	map<id,Contact> mapContact = new map<id,Contact>([select id,AccountId from Contact]);
 	 	 	map<id,Account> BusinessAccMap = new map<id,Account>
							([select id,Expected_Return_on_Investment__c,Equity__c,Gold__c,Debt__c,Income_Growth_Rate__c,Inflation_Rate__c,
									Gold_Growth_Rate__c,
 	 	 							Default_Estimated_Life_Expectancy__c,Number_Of_Months__c,Stock_Growth_Rate__c,Default_Retirement_Age__c 
 	 	 					from Account 
 	 	 					where Related_To__c = 'Business Partner' 
 	 	 					and RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c 
 	 	 				    ]);
 	 	 	Account objBusinessAcc = new Account();
 	 	 	User objUser = new User();
 	 	 	Contact objContact = new Contact();
 	 	 		system.debug('============objAcc.OwnerId=============='+objAcc.OwnerId);
 	 	 	if(mapUser.containsKey(objAcc.OwnerId))
 	 	 	{
 	 	 		objUser = mapUser.get(objAcc.OwnerId);
 	 	 		if(objUser != Null)
 	 	 		{
					if(mapContact.containsKey(objUser.ContactId))
					{	
						objContact = mapContact.get(objUser.ContactId);
						system.debug('============objContact=====in if========='+objContact);
						if(objContact != Null)
						{
							if(BusinessAccMap.ContainsKey(objContact.AccountId))
							{
								objBusinessAcc = BusinessAccMap.get(objContact.AccountId);
								if(objBusinessAcc != null)
								{
									system.debug('============objBusinessAcc=====in if========='+objBusinessAcc);
									Equity = objBusinessAcc.Equity__c;
						 	 	 	Debt = objBusinessAcc.Debt__c;
						 	 	 	//Gold = objBusinessAcc.Gold__c;
						 	 	 	if(currentYear > 2013)
				                     {
				                     	Gold = objBusinessAcc.Gold__c;
				                     }
				                     else
				                     {
				                     	Gold = Double.valueOf(Label.Gold_Interest_Rate);
				                     } 	 	 		
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
 	 	 							Gold_Growth_Rate__c,
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
		 	 	 	 if(currentYear > 2013)
                     {
                     	Gold = objVirtualAcc.Gold__c;
                     }
                     else
                     {
                     	Gold = Double.valueOf(Label.Gold_Interest_Rate);
                     } 
		 	 	 	 system.debug('============Debt=============='+Debt);
		 	 	 	 system.debug('============Gold=============='+Gold);
					 system.debug('============objVirtualAcc=============='+objVirtualAcc);
				}
        	 }
 	 	 }
 	 	 
 	 	for(Goal_Profile__c objGoalProfile :GoalProfileList )
		{
			System.debug('-------------------------------------'+ objGoalProfile.Equity_Allocation__c);
			System.debug('-------------------------------------'+ objGoalProfile.Debt_Allocation__c);
			System.debug('-------------------------------------'+ objGoalProfile.Gold_allocation__c);
			System.debug('-------------------------------------'+ Debt);
			System.debug('-------------------------------------'+ Gold);
			
			ReturnExpected = ((objGoalProfile.Equity_Allocation__c * Equity) + 
							 (objGoalProfile.Debt_Allocation__c * Debt) + 	
							 (objGoalProfile.Gold_allocation__c * Gold)) /100;
			system.debug('****objGoalProfile.Equity_Allocation__c******'+objGoalProfile.Equity_Allocation__c);
			system.debug('******BusinessAcc.Equity__c****'+FfreedomAcc.Equity__c);
		    system.debug('*****BusinessAcc.objGoalProfile.Returns_expected__c*******Above : '+objGoalProfile.Returns_expected__c);
			objGoalProfile.Returns_expected__c = ReturnExpected;
			system.debug('*****BusinessAcc.objGoalProfile.Returns_expected__c*******Below : '+objGoalProfile.Returns_expected__c);
		}
 	 	 
 	 	 if(GoalProfileList!=null && GoalProfileList.size()>0){
 	 	 	  stdGoalProfileList= getGoalProfileList(GoalProfileList);
 	 	 }
 	 	 	
 	 	 return stdGoalProfileList;
 	 }
      public List<GoalProfileBean> getGoalProfileList( List<Goal_Profile__c> GoalProfileList){
 	 	 GoalProfileBean golaProfile;
 	 	 List<GoalProfileBean>goalProfileTempList=new List<GoalProfileBean>();
 	 	 for(Goal_Profile__c gp:GoalProfileList){
 	 	 	GoalProfileBean gpBean=new GoalProfileBean();
 	 	 	gpBean.goalProfile=gp;
            if(gp.Equity_Allocation__c!=0 || gp.debt_Allocation__c!=0 || gp.Gold_allocation__c!=0){
 	 	 		flag=true;
 	 	 	}
 	 	 	
 	 	 	
 	 	 	gpBean.index=''+goalProfileTempList.size();
 	 	 	goalProfileTempList.add(gpBean);
 	 	 } 
 	 	 return goalProfileTempList;
 	 }
 	 public List<GoalProfileBean> getCustomGoalProfileList(String EntityId)
 	 {
 	 	    customGoalProfileList.clear();
 	 	    List<Goal_Profile__c> GoalProfileList=databaseObj.getCustomGoalProfileList(EntityId);
 	 	    //=========================================================================================
 	 	    Account objAcc = [select Id, Name, OwnerId, Related_To__c, Virtual_Partner__c from Account where Id = :  EntityId];
 	 	 	system.debug('*********objAcc*******'+objAcc);
 	 		Account FfreedomAcc = new Account();
 	 	 	Account BusinessAcc = new Account();
 	 	 	Account VirtualAcc = new Account();
 	 	 	List<Account> lstVirtualAcc = new List<Account>();
 	 	 	double Equity,Debt,Gold;
 	 	 	double ReturnExpected;
 	 	 
 	 	if(objAcc.Related_To__c == 'Ffreedom')
 	    {
 	 		FfreedomAcc = [select id,Expected_Return_on_Investment__c,Equity__c,Gold__c,Debt__c,Income_Growth_Rate__c,Inflation_Rate__c,
 	 								Gold_Growth_Rate__c,
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
									Gold_Growth_Rate__c,
 	 	 							Default_Estimated_Life_Expectancy__c,Number_Of_Months__c,Stock_Growth_Rate__c,Default_Retirement_Age__c 
 	 	 					from Account 
 	 	 					where Related_To__c = 'Business Partner' 
 	 	 					and RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c 
 	 	 				    ]);
 	 	 	Account objBusinessAcc = new Account();
 	 	 	User objUser = new User();
 	 	 	Contact objContact = new Contact();
 	 	 		system.debug('============objAcc.OwnerId=============='+objAcc.OwnerId);
 	 	 	if(mapUser.containsKey(objAcc.OwnerId))
 	 	 	{
 	 	 		objUser = mapUser.get(objAcc.OwnerId);
 	 	 		if(objUser != Null)
 	 	 		{
					if(mapContact.containsKey(objUser.ContactId))
					{	
						objContact = mapContact.get(objUser.ContactId);
						system.debug('============objContact=====in if========='+objContact);
						if(objContact != Null)
						{
							if(BusinessAccMap.ContainsKey(objContact.AccountId))
							{
								objBusinessAcc = BusinessAccMap.get(objContact.AccountId);
								if(objBusinessAcc != null)
								{
									system.debug('============objBusinessAcc=====in if========='+objBusinessAcc);
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
 	 	 							Gold_Growth_Rate__c,
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
					 system.debug('============objVirtualAcc=============='+objVirtualAcc);
				}
        	 }
 	 	 }
 	 	 
 	 	 	
 	 	    for(Goal_Profile__c objGoalProfile :GoalProfileList )
			{
				ReturnExpected = ((objGoalProfile.Equity_Allocation__c * Equity) + 
							 (objGoalProfile.Debt_Allocation__c * Debt) + 	
							 (objGoalProfile.Gold_allocation__c * Gold)) /100;
				system.debug('****objGoalProfile.Equity_Allocation__c******'+objGoalProfile.Equity_Allocation__c);
				system.debug('******BusinessAcc.Equity__c****'+FfreedomAcc.Equity__c);
		    	system.debug('*****BusinessAcc.objGoalProfile.Returns_expected__c*******Above : '+objGoalProfile.Returns_expected__c);
				objGoalProfile.Returns_expected__c = ReturnExpected;
				system.debug('*****BusinessAcc.objGoalProfile.Returns_expected__c*******Below : '+objGoalProfile.Returns_expected__c);
			}
 	 	    
 	 	    
 	 	    //=========================================================================================
 	 	    
 	 	    
 	 	    
 	 	    if(GoalProfileList!=null && GoalProfileList.size()>0)
 	 	    {
 	 	    	system.debug('*****isDisplay******upper : '+isDisplay);
 	 	    	customGoalProfileList= getGoalProfileList(GoalProfileList);
 	 	    	isDisplay=flag;
 	 	    }
 	 	    else{
 	 	    	system.debug('*****isDisplay******Below : '+isDisplay);
 	 	    	isDisplay=false;
 	 	    	customGoalProfileList.add(addGoalProfileList('Aggressive','Customized',0,0,0));
 	 	    	customGoalProfileList.add(addGoalProfileList('Moderately Aggressive','Customized',0,0,0));
 	 	    	customGoalProfileList.add(addGoalProfileList('Moderate','Customized',0,0,0));
 	 	    	customGoalProfileList.add(addGoalProfileList('Moderately Conservative','Customized',0,0,0));
 	 	    	customGoalProfileList.add(addGoalProfileList('Conservative','Customized',0,0,0));
 	 	    }
 	 	    return customGoalProfileList;
 	 }
 	 public GoalProfileBean addGoalProfileList(String name,String profileType,Double equity,Double bond,Double gold){
 	 		GoalProfileBean gpBean=new GoalProfileBean();
 	 		gpBean.goalProfile.Name=name;
     		gpBean.goalProfile.Goal_Profile_Type__c=profileType;
     		gpBean.goalProfile.Equity_Allocation__c=equity;
            gpBean.goalProfile.debt_Allocation__c=bond;
     		gpBean.goalProfile.Gold_allocation__c=gold; 
     		gpBean.index=''+customGoalProfileList.size();
     		return gpBean;
 	 }
 	 public void saveAssumption(Entity_Global_Assumption__c entityAssumption,String entityId){
 	 	try{
 	 	  IF(entityAssumption!=NULL){
 	 	  databaseAccess.upsertObject(entityAssumption);
 	 	  }
 	 	}catch(Exception e){
 	 		Apexpages.addMessages(e);
 	 	}
 	 }
 	 public void saveGoalProfile(List<GoalProfileBean> stdGoalProfileList,List<GoalProfileBean> customGoalProfileList,String entityId)
 	 {
 	    try
 	    {
	 	  	if(customGoalProfileList!=null && customGoalProfileList.size()>0)
	 	    {
	 	    /** Eternus Solutions      **/
			/** Author  : Manasi Ranade*/
			/** Issue Id: F0023      **/
			/** Date    : 30/05/2011 **/
			/** Purpose : called IsValidCustomProfile function to check the custom goals are valid or not.It should not contain all zeros**/
			/****************************************************/
 	
	 	       if(IsValidCustomProfile(customGoalProfileList))
	 	       	{
		 	       	List <Goal_Profile__c> goalProfileList=new List <Goal_Profile__c>();
		 	       	for(GoalProfileBean gpBean:customGoalProfileList){
		 	       		if(gpBean!=null){
		 	       			gpBean.goalProfile.Account__c=entityId;
		 	       			goalProfileList.add(gpBean.goalProfile);
		 	       		}
		 	       	}
		 	       	 if(goalProfileList.size()>0){
		 	       	 databaseAccess.upsertObject(goalProfileList);
		 	       	 }
		 	     }
	 	    }
	 	      
 	    }
 	    catch(Exception e){
 	    	Apexpages.addMessages(e);
 	    }
 	 }
 	 
 	 	    /** Eternus Solutions      **/
			/** Author  : Manasi Ranade*/
			/** Issue Id: F0023      **/
			/** Date    : 30/05/2011 **/
			/** Purpose : Added function to check the custom goals are valid or not.It should not contain all zeros**/
			/****************************************************/
 	
 	 
 	 private Boolean IsValidCustomProfile(List<GoalProfileBean> customGoalProfileList)
 	 {
 	 	Boolean IsValid = True;
 	 	for(GoalProfileBean objGoalProfile : customGoalProfileList)
 	 	{
 	 		if(objGoalProfile != null)
 	 		{
 	 			if(objGoalProfile.goalProfile.Equity_Allocation__c == 0.0 && objGoalProfile.goalProfile.Gold_allocation__c == 0.0 && objGoalProfile.goalProfile.Debt_Allocation__c == 0.0)
 	 			 return IsValid = False;
 	 		}
 	 	}
 	 	return IsValid;
 	 }
 	 
}