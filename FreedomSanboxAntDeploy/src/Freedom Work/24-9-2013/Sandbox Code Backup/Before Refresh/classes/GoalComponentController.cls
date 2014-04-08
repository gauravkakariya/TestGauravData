/*
	
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
    
	2.0			Niket Chandane	3/June/2011     Issue ID:F0009 :Added the If condition if goalMappingBean class object is not NUll
												when setting the 
												1] futureValueActual (Property)
												2] singleYearGoal (Property)
												3] pageReference output() (Method)
	2.0  		Manasi 			28/11/2011   	Issue Id: FS0309 : Code to Add Remark in the page
	2.0  		Manasi 			13/4/2012   	Issue Id: 00001590 : Commented the proprty remark to as not used on component
									 
*/

public class GoalComponentController{
    public GoalMappingBean objGoalMappingBean{get;set;}
  /*  public GoalComponentController()
    {
    	GoalOutputController objGoalOutputController = new GoalOutputController();
    	objGoalMappingBean = objGoalOutputController.goalMappingBean;
    	system.debug('**GoalComponentController***objGoalMappingBean****'+objGoalMappingBean);
    	system.debug('**GoalComponentController***objGoalMappingBean.isRemainingYear****'+objGoalMappingBean.isRemainingYear);
    }*/
    /* Prajakta - FP changes - 22-03-2013 */
    public List<String> lstAllocationMsg
    {
    	get
    	{
           // Goal__c objGoal = [Select Name, Id, Allocation_Message__c From Goal__c where Id =: objGoalMappingBean.goalObj.id];
            if(lstAllocationMsg == null)
            {
            	if(objGoalMappingBean.goalObj.Allocation_Message__c != null )
            	{            
            		System.debug('-----------------objGoalMappingBean------'+objGoalMappingBean);
            		lstAllocationMsg = objGoalMappingBean.goalObj.Allocation_Message__c.split('~~');
					System.debug('-----------------lstAllocationMsg------'+lstAllocationMsg.size());
            	}
            	else
            		return null;
            }
            return lstAllocationMsg;
    	}
    	set;
    }
    
    //FS0309 new property to show Remark
      /** Eternus Solutions      **/
	  /** Author  : Manasi Ranade 	**/
	  /** Issue Id: 00001590      	**/
	  /** Date    : 13/4/2012 	 	**/
	  /** Purpose : Commented the proprty remark to as not used on component
	  /****************************************************/
    /*public String Remark{
       get{
       		String goalId = '';
       		String strRemarks = '';
       		Goal__c objSelectedGoal;
       		if(objGoalMappingBean != null && objGoalMappingBean.goalObj != null)
       		{
		    	strRemarks = objGoalMappingBean.goalObj.Remark__c;
		    	//00001590
		    	if(strRemarks != null && strRemarks != '')
		    		strRemarks = strRemarks.replaceAll('\n','<br/>');
       		}
       		
            return strRemarks;
       }set;
   }*/
   
	   
    public double futureValueActual{
      get{
      	    /*Modification Made By Niket 
      	     	Change : Check for the could Not be Null.
      	     	Changes for : Change for the It give's ad Error on the Goal Calculation Page When we click on the Output Tag.
      	    */
      		if(objGoalMappingBean != null && objGoalMappingBean.goalDetailBeanList != null && objGoalMappingBean.goalDetailBeanList.size() >0)
      		{
      			return objGoalMappingBean.goalDetailBeanList[0].targetAmount;
      		}
      		else {
      			return 0.0;
      		}
      }set;
  }
  
  public boolean singleYearGoal{
       get{
       		if(objGoalMappingBean != null)
       		{
       			 /*Modification Made By Niket 
	      	     	Change : Check for the could Not be Null.
	      	     	Changes for : Change for the It give's ad Error on the Goal Calculation Page When we click on the Output Tag.
	      	     */
	/*      //===============================================Global Assumption Related changes===================================================================================================================
	      	     system.debug('*****objGoalMappingBean.goalObj*********'+objGoalMappingBean.goalObj);
	      	      Id EntityId = ApexPages.currentPage().getParameters().get('EntityId');
 	 	 
 	 	 system.debug('*********EntityId**: GlobalAssumptionService*****'+EntityId);
 	 	 Account objAcc = [select Id,Name,Related_To__c,Virtual_Partner__c,OwnerId from Account where Id = :  EntityId];
 	 	 	 system.debug('*********objAcc*******'+objAcc);
 	 	 Account FfreedomAcc = new Account();
 	 	 double Equity,Debt,Gold;
 	 	 double ReturnExpected;
 	 	 if(objAcc.Related_To__c == 'Ffreedom')
 	 	 {
 	 	 	FfreedomAcc = [select id,Expected_Return_on_Investment__c,Equity__c,Gold__c,Debt__c,Income_Growth_Rate__c,Inflation_Rate__c,
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
 	 	 
 	 	 
 	 	 
 	 	 
 	 	 List<Goal_Profile__c> GoalProfileList = new List<Goal_Profile__c>();
 	 	 GoalProfileList = [select Id,Equity_Allocation__c,Debt_Allocation__c,Gold_allocation__c,Returns_expected__c from Goal_Profile__c where id =:objGoalMappingBean.goalObj.SelectedGoalProfile__c];
 	 	 system.debug('***GoalProfileList***: in component**'+GoalProfileList);
 	 	for(Goal_Profile__c objGoalProfile :GoalProfileList )
		{
			ReturnExpected = ((objGoalProfile.Equity_Allocation__c * Equity) + 
							 (objGoalProfile.Debt_Allocation__c * Debt) + 	
							 (objGoalProfile.Gold_allocation__c * Gold)) /100;
			system.debug('****objGoalProfile.Equity_Allocation__c******'+objGoalProfile.Equity_Allocation__c);
			system.debug('******BusinessAcc.Equity__c****'+FfreedomAcc.Equity__c);
		    system.debug('*****BusinessAcc.objGoalProfile.Returns_expected__c*******Above : '+objGoalProfile.Returns_expected__c);
			objGoalMappingBean.goalObj.SelectedGoalProfile__r.Returns_expected__c = ReturnExpected;
			system.debug('*****BusinessAcc.objGoalProfile.Returns_expected__c*******Below : '+objGoalProfile.Returns_expected__c);
		}
 	 	
 	 	*///==================================================================================================================================================================
           		if((objGoalMappingBean.goalStartYear-objGoalMappingBean.goalEndYear)==1 || (objGoalMappingBean.goalStartYear == objGoalMappingBean.goalEndYear))
           		{
           			
		            
               		return true;
           		}
               	else
               		return false;	
       		}
           else
               return false;
       }set;
   }
     
     public pageReference output() 
     {
     	PageReference pr ;
     	system.debug('*****objGoalMappingBean.goalObj*********'+objGoalMappingBean.goalObj);
     	 /*Modification Made By Niket 
  	     	Change : Check for the could Not be Null.
  	     	Changes for : Change for the It give's ad Error on the Goal Calculation Page When we click on the Output Tag.
  	     */
     	if(objGoalMappingBean != null && objGoalMappingBean.goalObj != null && objGoalMappingBean.goalObj.entity__c != null)
        	pr = new PageReference('/apex/GoalCalculationPage?goalId='+objGoalMappingBean.goalObj.id+'&entityId='+objGoalMappingBean.goalObj.entity__c+'&tabname=Financial Planning');
        else
        	return null;
        return pr;
   	}
   
}