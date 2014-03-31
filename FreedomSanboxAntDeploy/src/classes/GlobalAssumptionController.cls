/*
	Revision History:
	
    Version     Version Author     Date         Comments
    1.0         Persistent         NA  		  	Initial Draft
   
	2.0			Manasi Ranade	   25/05/2011   Added two fields Default_Retirement_Age__c and Default_Estimated_Life_Expectancy__c
					  							in Entity_Global_Assumption__c object.
					  							so fetching those values in GlobalAssumptionController constructor.   
	2.0			Manasi Ranade	  30/05/2011	Added cancel button to cancel the operation.	
	3.0			Prajakta Sanap    01/04/2013    Added Gold Growth Rate for the new record type Gold in Investment Asset			  							 											
*/

public class GlobalAssumptionController 
{
    public GlobalAssumptionService globalAssService{get;set;}
    public Entity_Global_Assumption__c globalAssumption{get;set;}
    public Entity_Global_Assumption__c entityAssumption{get;set;}
    public List<GoalProfileBean>stdGoalProfileList{get;set;}
    //Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
	
    /* Commented Global Assumption Changes
	public List<Account> lstAcc
    {
    	get
    	{
    		if(lstAcc == null)
    		{
    			lstAcc = [select Id ,Equity__c,Debt__c,Gold__c from Account where id =: entityId];
    		}
    		return lstAcc;
    	}
    set; 
    } 
    public List<Account>  lstToUpdate
    {
    	get
    	{
    		if(lstToUpdate == null)
    			lstToUpdate = new List<Account>();
    		return lstToUpdate;
    	}
    	set;
    }*/
    public List<GoalProfileBean> customGoalProfileList{get;set;}
    public Boolean isDisplay{get;set;}
    public String entityId{get;set;} 
    public double Equity{get;set;}
    public double Debt{get;set;}
    public double Gold{get;set;}
    
    public String riskProfile{get;set;} 
    public String goalProfileTitle{get;set;}
 
	public GlobalAssumptionController()
	{
		isDisplay=false; 
		//Code Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   		isDisplaySaveButton = true;
   		
		entityAssumption = new Entity_Global_Assumption__c();
		stdGoalProfileList = new List<GoalProfileBean>();
		globalAssService = new GlobalAssumptionService();
	 	entityId = Apexpages.currentPage().getParameters().get('entityId');
	    //globalAssumption = globalAssService.getEntityGlobalAssumption(entityId);
	    List<Entity_Global_Assumption__c> globalAssumptionList=[
                                                               SELECT 
                                                                      Expected_Return_on_Investment__c,Income_Growth_Rate__c,
                                                                      Inflation_Rate__c,Account__c,Number_Of_Months__c ,Stock_Growth_Rate__c,
                                                                      Gold_Growth_Rate__c,	   /* Prajakta - FP changes - 01-04-2013 */
                                                                      Default_Estimated_Life_Expectancy__c,Default_Retirement_Age__c,
                                                                      Data_Collection_Analysis_Control__c, //Gaurav- 09-04-2013
                                                                      Financial_Planing_Output_Report__c,
                                                                      CashFlow_Projection_End_Year__c ,/* Aditi - FP enhancement changes - 15-10-2013 */
                                                                      Goals_Allowed_List__c,
                                                                      No_of_Goals__c
                                                               FROM
                                                                       Entity_Global_Assumption__c
                                                               WHERE 
                                                                        Account__c=:entityId
                                                                        
                                                               ORDER BY CreatedDate desc
                                                               ];
        //globalAssumption = globalAssumptionList[0];   
        entityAssumption = globalAssumptionList[0];                                                     
		//entityAssumption.Account__c = entityId;
	/*	entityAssumption.No_of_Goals__c = globalAssumption.No_of_Goals__c;
		entityAssumption.Data_Collection_Analysis_Control__c = globalAssumption.Data_Collection_Analysis_Control__c;
		entityAssumption.Financial_Planing_Output_Report__c = globalAssumption.Financial_Planing_Output_Report__c;
		entityAssumption.Goals_Allowed_List__c = globalAssumption.Goals_Allowed_List__c;
	*/	
		//Added Code on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	    User objBPUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
	    if(objBPUser.UserType.equalsIgnoreCase('PowerPartner'))
	    {
	    	isDisplaySaveButton = false;
	    }	
		
		//if(globalAssumption != null )
		//{
			/*//entityAssumption.id = globalAssumption.id;
			if(globalAssumption.Expected_Return_on_Investment__c!=null)
			{
				entityAssumption.Expected_Return_on_Investment__c = globalAssumption.Expected_Return_on_Investment__c;
			}
			if(globalAssumption.Income_Growth_Rate__c!=null)
			{
				entityAssumption.Income_Growth_Rate__c=globalAssumption.Income_Growth_Rate__c;
			}
			if(globalAssumption.Inflation_Rate__c!=null)
			{
				entityAssumption.Inflation_Rate__c=globalAssumption.Inflation_Rate__c;
			}
			if(globalAssumption.Number_Of_Months__c!=null)
			{
				entityAssumption.Number_Of_Months__c=globalAssumption.Number_Of_Months__c;
			}
			// Eternus Solutions      
			// Author  : Manasi Ranade
			// Issue Id: F0018      
			// Date    : 27/05/2011
			// Purpose : Added two fields Default_Retirement_Age__c and Default_Estimated_Life_Expectancy__c
		  	//						in Entity_Global_Assumption__c object.
			
			if(globalAssumption.Default_Retirement_Age__c!=null)
			{
				entityAssumption.Default_Retirement_Age__c = globalAssumption.Default_Retirement_Age__c;
			}
			if(globalAssumption.Default_Estimated_Life_Expectancy__c!=null)
			{
				entityAssumption.Default_Estimated_Life_Expectancy__c = globalAssumption.Default_Estimated_Life_Expectancy__c;
			}
			if(globalAssumption.Stock_Growth_Rate__c!=null)
			{
				entityAssumption.Stock_Growth_Rate__c = globalAssumption.Stock_Growth_Rate__c;
			}
			// Prajakta - FP changes - 01-04-2013 
			if(globalAssumption.Gold_Growth_Rate__c!=null)	   
			{
				entityAssumption.Gold_Growth_Rate__c = globalAssumption.Gold_Growth_Rate__c;
			}
			if(globalAssumption.CashFlow_Projection_End_Year__c!=null)	   
			{
				entityAssumption.CashFlow_Projection_End_Year__c = globalAssumption.CashFlow_Projection_End_Year__c;
			}
		*/
			//Commented Global Assumption Changes
			//==================================================================================================================================
			 system.debug('*********EntityId**: GlobalAssumptionController*****'+entityId);
			 
 	 	 Account objAcc = [select Id, Name, Related_To__c, Virtual_Partner__c, Risk_profile__c, OwnerId,
 	 	 							Plan_Generation_Date__c
 	 	 							from Account where Id = :  entityId];
 	 	 system.debug('****controller*****objAcc*******'+objAcc);
 	 	 
 	 	 Integer currentYear = objAcc.Plan_Generation_Date__c != null ? objAcc.Plan_Generation_Date__c.year() : system.today().year();
 	 	 riskProfile = objAcc.Risk_profile__c;
		 //error.debugLog('============riskProfile=============='+riskProfile);
		 
		 goalProfileTitle = 'Standard Goal Profile';
		 if(riskProfile != null)
		 {
		 	if(riskProfile == 'High')
		 		goalProfileTitle = 'High Goal Profile'; 
		 	else if(riskProfile == 'Medium')
		 		goalProfileTitle = 'Medium Goal Profile';
		 	else if(riskProfile == 'Low')
		 		goalProfileTitle = 'Low Goal Profile';
		 	/*else if(riskProfile == '' || riskProfile == null)
		 		goalProfileTitle = 'Standard Goal Profile';*/
		 }
		 
 	 	 Account FfreedomAcc = new Account();
 	 	 Account BusinessAcc = new Account();
 	 	 Account VirtualAcc = new Account();
 	 	 List<Account> lstVirtualAcc = new List<Account>();
 	 
 	 	 double ReturnExpected;
 	 	 system.debug('**objAcc.Related_To__c**'+objAcc.Related_To__c);
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
             	Gold = FfreedomAcc.Gold__c;
            }
            else
            {
             	Gold = Double.valueOf(Label.Gold_Interest_Rate);
            }
 	 	 }
 	 	 else if(objAcc.Related_To__c == 'Business Partner')
 	 	 {
 	 	 	map<id,User> mapUser = new map<id,User>([select Id, Name, ProfileId, ContactId, Profile.Name from User]);
 	 	 	system.debug('**mapUser**' + mapUser);
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
		 	 	 	 //Gold = objVirtualAcc.Gold__c;		
					 system.debug('============objVirtualAcc=============='+objVirtualAcc);
				}
        	 }
 	 	 }
 	 	 
		//==================================================================================================================================
	  	//}
	 
       stdGoalProfileList = globalAssService.getStdGoalProfileList(riskProfile); 
       customGoalProfileList=globalAssService.getCustomGoalProfileList(entityId);
  }
   
     public Pagereference display(){
     	globalAssService.isDisplay = !(globalAssService.isDisplay);
     	return null;
     } 
     public Pagereference save(){
     	/*Commented Global Assumption Changes
     	for(Account objAcc : lstAcc)
		{
			objAcc.Equity__c = equity;
			objAcc.Debt__c = debt;
			objAcc.Gold__c = gold;
			system.debug('*****new objAcc****'+objAcc);
			lstToUpdate.add(objAcc);
		}	
		update lstToUpdate;
     	*/
     	globalAssService.saveAssumption(entityAssumption,entityId);
     	system.debug('****customGoalProfileList**in save ****'+customGoalProfileList);
      	globalAssService.saveGoalProfile(stdGoalProfileList,customGoalProfileList,entityId);
      	Pagereference pageRef=new pageReference ('/apex/GlobalAssumptionPage?entityId='+entityId+'&tabname=Financial Planning');
      	pageRef.setRedirect(true);
     	return pageRef; 
     }	  
     
   /* public List<selectOption> getCashFlowProjectionPicklist()
    { 
       List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult field = Schema.sObjectType.Entity_Global_Assumption__c.fields.CashFlow_Projection_End_Year__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        //options.add(new selectOption('', '--None--'));
        for(Schema.PicklistEntry p : picklist) 
        {
            options.add(new selectOption(p.getLabel(), p.getLabel()));
        }
        
        return options;
    }*/
     
    /** Eternus Solutions      **/
	/** Author  : Manasi Ranade*/
	/** Issue Id: F0023      **/
	/** Date    : 30/05/2011 **/
	/** Purpose : Added cancel button to cancel the operation.	**/
	/****************************************************/
 	public Pagereference Cancel(){
 		Pagereference PageGlobalAssumption = new pageReference ('/apex/GlobalAssumptionPage?entityId='+entityId+'&tabname=Financial Planning');
 		PageGlobalAssumption.setRedirect(true);
 		return PageGlobalAssumption;
 	}	
}