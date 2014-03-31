/*
  Revision History:
  Version     Version Author     Date        Comments
    1.0         --                --        Initial Draft
    2.0      Niket Chandane  15/06/2011    Update the logic to calculate the futureValueActual which will be comes from the Goal 
                          calculation page.
  	2.0      Niket Chandane  06/07/2011      Add the if statement before converting the totalAmount in to the double.
                        New Code :
                          if(ApexPages.currentPage().getParameters().get('totalAmount') != null || ApexPages.currentPage().getParameters().get('totalAmount') !='')
  	2.0      Manasi Ranade  13/10/2011    1)Issue Id:FS0194 : Change in Function :GoalOutputController
                          Passed the Sip data to the Goal output page
*/

public class GoalOutputController{
     public NewGoalService goalService {get;set;}
     public Double dblReturnExpected {get;set;}
     public Map<String,GoalMappingBean> goalMappingBeanMap { get;set;}
    public GoalMappingBean goalMappingBean { get {
                                                  if(goalMappingBeanMap != null && goalMappingBeanMap.size() > 0)
                                                  {
                                                       if(goalMappingBeanMap.ContainsKey(goalByUrl))
                                                           return goalMappingBeanMap.get(goalByUrl);
                                                       else
                                                          return null;
                                                  }
                                                  return null;
                                              }
                      set;}
    
    public String goalByUrl{get;set;}
    public String entityId{get;set;}
    public list<goal__c> goalList{get;set;}
    public double dbInflactionRate{get;set;}
    DatabaseSOQL dbsoql{get;set;}
    public double futureValueActual{get;set;}
    /** Eternus Solutions      **/
  /** Author  : Manasi Ranade*/
  /** Issue Id: FS0194      **/
  /** Date    : 13/10/2011 **/
  /** Purpose : Added properties to fetch on output page**/
    public Double dblEquitySIP {get;set;}
    public Double dblGoldSIP{get;set;}
    public Double dblDebtSIP {get;set;}
    public Double dblTotalSIP {get;set;}
    
      /*get{
          return goalMappingBean.goalDetailBeanList[0].targetAmount;
      }set;
  }*/
    public GoalOutputController()
    {
        dbsoql = new DatabaseSOQL ();
        entityId = ApexPages.currentPage().getParameters().get('EntityId');
        goalByUrl = ApexPages.currentPage().getParameters().get('GoalId');
        
        List<Account> accountList = dbsoql.getFamilyDetails(entityId); //Prajakta - 4-6-2013
        
        if(ApexPages.currentPage().getParameters().get('totalAmount') != null && ApexPages.currentPage().getParameters().get('totalAmount') !='')
          futureValueActual = Double.valueOf(ApexPages.currentPage().getParameters().get('totalAmount'));
        else
          futureValueActual = 0.0;
        /** Eternus Solutions      **/
    	/** Author  : Manasi Ranade*/
    	/** Issue Id: FS0194      **/
    	/** Date    : 13/10/2011 **/
    	/** Purpose : Added properties to fetch on output page**/
        dblEquitySIP = Double.valueOf(ApexPages.currentPage().getParameters().get('dblEquitySIP'));
        dblGoldSIP = Double.valueOf(ApexPages.currentPage().getParameters().get('dblGoldSIP'));
        dblDebtSIP = Double.valueOf(ApexPages.currentPage().getParameters().get('dblDebtSIP'));
        dblTotalSIP = Double.valueOf(ApexPages.currentPage().getParameters().get('dblTotalSIP'));

        /*String strTotalAmount = ApexPages.currentPage().getParameters().get('totalAmount');
        system.debug('88888888888totalAmount:'+strTotalAmount);
        if(strTotalAmount == null || strTotalAmount =='')
          futureValueActual = 0.0;
        else
          futureValueActual = Double.valueOf(strTotalAmount);*/
        try {
            goalList = dbsoql.getEntityGoal(entityId);
                goalService = new NewGoalService();
                //goalService.getFamilyMembers(accountList);		//Prajakta - 4-6-2013
                
                List<String> goalIdList = new List<String>();
                for(goal__c goal:goalList)
                {
                  goalIdList.add(goal.Id);
                }
                
                
                /*
                  Modified By : Niket Chandane.
                  Modified At : 14 June 2011
                  Summary     : Update the target amount that is amount will be comes from the Goal calculation page.
                */
                  //===============================================Global Assumption Related changes===================================================================================================================
              //  Id EntityId = ApexPages.currentPage().getParameters().get('EntityId');
       
       system.debug('*********EntityId**: GlobalAssumptionService*****'+EntityId);
       Account objAcc = [select Id,Name,Related_To__c,Plan_Generation_Date__c,Virtual_Partner__c,OwnerId from Account where Id = :  entityId];
       Integer CurrentYear = objAcc.Plan_Generation_Date__c != null ? objAcc.Plan_Generation_Date__c.year() : system.today().year();
          system.debug('*********objAcc*******'+objAcc);
       Account FfreedomAcc = new Account();
       double Equity,Debt,Gold;
       
       if(objAcc.Related_To__c == 'Ffreedom')
       {
          	FfreedomAcc = [select id,Expected_Return_on_Investment__c,Equity__c,Gold__c,Debt__c,Income_Growth_Rate__c,Inflation_Rate__c,
         				 Gold_Growth_Rate__c,	   /* Prajakta - FP changes - 01-04-2013 */
                     Default_Estimated_Life_Expectancy__c,Number_Of_Months__c,Stock_Growth_Rate__c,Default_Retirement_Age__c 
                 from Account 
                 where Related_To__c = 'Ffreedom' 
                 and RecordTypeId =: RecTypes__c.getInstance('General_Business').Record_Type_Value__c 
                 limit 1];
         	Equity = FfreedomAcc.Equity__c;
         	Debt = FfreedomAcc.Debt__c;
         	if(CurrentYear > 2013)
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
         	map<id,User> mapUser = new map<id,User>([select Id,Name,ProfileId,ContactId,Profile.Name from User]);
	        map<id,Contact> mapContact = new map<id,Contact>([select id,AccountId from Contact]);
	        map<id,Account> BusinessAccMap = new map<id,Account>
              ([select id,Expected_Return_on_Investment__c,Equity__c,Gold__c,Debt__c,Income_Growth_Rate__c,Inflation_Rate__c,
              			 Gold_Growth_Rate__c,	   /* Prajakta - FP changes - 01-04-2013 */
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
                     				if(CurrentYear > 2013)
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
                 		 Gold_Growth_Rate__c,	   /* Prajakta - FP changes - 01-04-2013 */
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
              		if(CurrentYear > 2013)
            		{
            			Gold = objVirtualAcc.Gold__c;
            		}
            		else
            		{
            			Gold = Double.valueOf(Label.Gold_Interest_Rate);
            		}       
           			system.debug('============objVirtualAcc=============='+objVirtualAcc);
        		}
           	}
       	}
          //=========================================================================================================      
                
     	goalMappingBeanMap  = goalService.getGoalDetailsForOutput(goalIdList,entityID);
        // goalService.getGoalDetails(goalIdList,entityID);			//Niket C
        System.debug('============ Check Point ===================>');
                 
       //==========================================================
       GoalMappingBean objGoalBean;
       if(goalMappingBeanMap.containsKey(goalByUrl))
       {
       		objGoalBean = goalMappingBeanMap.get(goalByUrl);
       		if(objGoalBean != null && objGoalBean.goalObj.SelectedGoalProfile__c != null)
      		{
        		Goal_Profile__c objGoalProfile = [select Id,Equity_Allocation__c
                               ,Debt_Allocation__c,Gold_allocation__c
                               ,Returns_expected__c 
                               from Goal_Profile__c 
                               where id =:objGoalBean.goalObj.SelectedGoalProfile__c];
               if(objGoalProfile != null)
               {
             		Double ReturnExpected = ((objGoalProfile.Equity_Allocation__c * Equity) + 
              								 (objGoalProfile.Debt_Allocation__c * Debt) +   
               									(objGoalProfile.Gold_allocation__c * Gold)) /100;
                     System.debug('LLLLLLLLLLLLLLLLL ==>'+objGoalBean.goalObj.SelectedGoalProfile__c);
                     if(objGoalBean.goalObj.SelectedGoalProfile__c != null)
                       	dblReturnExpected = objGoalBean.goalObj.SelectedGoalProfile__r.Returns_expected__c = ReturnExpected;
                     
               }
           }
       }
                 
     //==============================================================
                 
 	   if(goalMappingBeanMap != null && goalMappingBean.goalDetailBeanList != null && goalMappingBean.goalDetailBeanList[0]!= null)
       {
           if(futureValueActual != null)
              goalMappingBean.goalDetailBeanList[0].targetAmount = futureValueActual;
       }
    }
    catch(Exception ex) {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
    }
}
  
 public boolean singleYearGoal{
       get{
           if((goalMappingBean.goalStartYear-goalMappingBean.goalEndYear)==1 || (goalMappingBean.goalStartYear == goalMappingBean.goalEndYear))
               return true;
           else
               return false;
       }set;
   }
 
    public pageReference output() {
        PageReference pr = new PageReference('/apex/GoalCalculationPage?goalId='+goalByUrl+'&entityId='+entityID+'&tabname=Financial Planning');
        return pr;
   }
}