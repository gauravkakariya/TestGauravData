/**
 *@Description: GoalVFPageController is the class used to create new goals for particular entity
  */
/*
	
	Revision History:
	
    Version     Version Author     Date        Comments
    1.0         --           	   --	  		Initial Draft
    2.0			Manasi			   19/12/2011	Issue ID : B0001 :Added List to store Ids of Family members
    
				Kiran			   22/05/2013	FP changes-part2 - issue 6 
*/

public class GoalVFPageController
{
    public GoalServices goalServicesInstance{get; set;}
    public GoalBean goalBeanInstance{get; set;} 
    public Boolean isAddednew = false;
    //Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
	 //Added on : 19/4/2013 : Gaurav : validate goal as per entity gloabal assumption record
	public Boolean isNumberOfGoal{get;set;}
	public List<SelectOption> lstGoalOptions{get;set;}
	public List<String> lstGoalAllowedList{get;set;}
	
	public Entity_Global_Assumption__c objEntityGlobalAssumption{get;set;}
	public Integer goalCount{get;set;}
	
    /** Eternus Solutions       **/
	/** Author  : Manasi Ranade **/
	/** Issue Id: B0001      	**/
	/** Date    : 19/12/2011 	**/
	/** Purpose : Added List to store Ids of Family members
	/****************************************************/
	public List<String> AccountIDList = new List<String>();
    public GoalVFPageController()
    {
    	//Code Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   		isDisplaySaveButton = true;
   		
        goalServicesInstance = new goalServices();
        goalBeanInstance = new goalBean();
        goalBeanInstance.EntityId = ApexPages.currentPage().getParameters().get('EntityId');
        goalBeanInstance.AccountNameList = goalServicesInstance.getAccountNames( goalBeanInstance.EntityId);
        
        /** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: B0001      	**/
		/** Date    : 19/12/2011 	**/
		/** Purpose : Added code to store Ids of Family members
		/****************************************************/
		DatabaseSOQL DatabaseSOQLObj = new DatabaseSOQL();
		List<Account> AccountList = DatabaseSOQLObj.getFamilyDetails(goalBeanInstance.EntityId);
		for(Account acc : Accountlist)
        {
           AccountIDList.add(acc.Id);
        }
        
        /*Previous Code:
        In previous code it was fetching the Goal List From Selected entity's Name .But it should consider the Entity ID instead of Name. So chnaged the code
        */
        //goalBeanInstance.goalList = [SELECT goal_type__c,Goal_Frequency__c,entity__c,Goal_Start_Year__c,RemoveCheckbox__c,Goal_End_Year__c,Inflation_Rate__c,Cost_of_Goal_Annual__c,Priority__c,Description__c FROM goal__c WHERE Entity__r.Name IN:goalBeanInstance.AccountNameList];
       
        /*
		  Updated By : Kiran Patil
		  Updated At : 5-Jun-2013
		  Summary    : FP changes-part2 - issue 6 
		*/
        if(AccountIDList != null && AccountIDList.size() > 0)
        	goalBeanInstance.goalList = [ //00001605//Added Is_Include_In_HLV__c in select statement
        						  select goal_type__c, Goal_Frequency__c, entity__c, Goal_Start_Year__c, RemoveCheckbox__c, Goal_End_Year__c
        							   , Inflation_Rate__c, Cost_of_Goal_Annual__c, Priority__c, Description__c, Is_Include_In_HLV__c, CreatedDate 
        							from goal__c 
        						   where entity__c IN:AccountIDList
        						order by CreatedDate
		];
		
      	if(goalBeanInstance.goalList.isEmpty())
        {
               this.isAddednew = true;
               goalBeanInstance.addNewListView = goalServicesInstance.addRow(goalBeanInstance.addNewListView ,goalBeanInstance.selGoalType, goalBeanInstance.EntityId); 
               goalBeanInstance.addNewListView = goalServicesInstance.addRow(goalBeanInstance.addNewListView ,goalBeanInstance.selGoalType, goalBeanInstance.EntityId); 
                        
               //goalBeanInstance.goalList= goalServicesInstance.addRow(goalBeanInstance.goalList,goalBeanInstance.selGoalType,goalBeanInstance.EntityId); 
               //goalBeanInstance.goalList= goalServicesInstance.addRow(goalBeanInstance.goalList,goalBeanInstance.selGoalType,goalBeanInstance.EntityId); 
        }  
        goalBeanInstance.goalTypeList=goalServicesInstance.getGoalType();
   	 	//goalBeanInstance.AggQueryResult = goalServicesInstance.getDBValues(goalBeanInstance.AccountNameList); 
  	 	//goalBeanInstance.goalTypeClassList= goalServicesInstance.initSummaryTableList( goalBeanInstance.AccountNameList,goalBeanInstance.goalTypeList);
	   	//goalBeanInstance.goalTypeClassList= goalServicesInstance.populateSummaryTableList( goalBeanInstance.AggQueryResult, goalBeanInstance.goalTypeClassList);
		//Added Code on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	    User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
	    if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
	    {
	    	isDisplaySaveButton = false;
	    }	
	    
	    //Get the Entity Global Assumtion from Entity Id
	    //Changes by Gaurav on 11/4/2013
	    objEntityGlobalAssumption= new Entity_Global_Assumption__c();
	    objEntityGlobalAssumption = [Select Name, No_of_Goals__c, Goals_Allowed_List__c,Account__c
															    	From Entity_Global_Assumption__c 
															    	Where Account__c =:goalBeanInstance.EntityId];
		  
		isNumberOfGoal = (objEntityGlobalAssumption.No_of_Goals__c != 0);
		lstGoalOptions = new List<SelectOption>();
		lstGoalOptions.add(new SelectOption('None','--None--'));
		 	
		String strGoalAllowed = objEntityGlobalAssumption.Goals_Allowed_List__c;
	    lstGoalAllowedList = new List<String>();
	    if(strGoalAllowed != Null)
	    	lstGoalAllowedList = strGoalAllowed.split(';');
	    Boolean isEmergencyGoal = true;
	    
	    //Display Goal on GoalVfPage
	    for(String strGoalAllowedList : lstGoalAllowedList)
	    {
	    	if(strGoalAllowedList.equals('Emergency Fund'))
	    		isEmergencyGoal = false;
	    	lstGoalOptions.add(new SelectOption(strGoalAllowedList,strGoalAllowedList));
	    }
	    
	    if(isEmergencyGoal)
	    {
	    	if(lstGoalOptions.size() == 1)
	    		lstGoalOptions.add(new SelectOption('Emergency Fund', 'Emergency Fund'));
	    	else
	    		lstGoalOptions.add(1, new SelectOption('Emergency Fund', 'Emergency Fund'));
	    }
		goalCount= goalBeanInstance.goalList.size();
		
        /*
		  Updated By : Kiran Patil
		  Updated At : 22-May-2013
		  Summary    : FP changes-part2 - issue 6 
		*/
        if(!(goalBeanInstance.goalList).isEmpty()) {
	        list<Goal__c> tempaddNewListView = new list<Goal__c>();
        	list<Goal__c> tempaddNewListViewRetirement = new list<Goal__c>();
        	for (Goal__c goal : goalBeanInstance.goalList) {
        		if (goal.Goal_Type__c.equalsIgnoreCase('Retirement'))
        		    tempaddNewListViewRetirement.add(goal);
        		else     
        		    tempaddNewListView.add(goal);
        	}
        	goalBeanInstance.goalList = new list<Goal__c>();
        	goalBeanInstance.goalList.addall(tempaddNewListView);
        	goalBeanInstance.goalList.addall(tempaddNewListViewRetirement);
        }
        
    }
    
    /**
    *@Description: getIsAddedNew method to return true to add new goals
    * Return Type: Boolean
    */
    public Boolean getIsAddedNew()
    {
        return this.isAddednew ;
    }
    
    /*
    	public void showPopUp()
    	{
        	goalBeanInstance.displayPopUp=true;
        	goalBeanInstance.goalList= goalServicesInstance.getGoalRecords(goalBeanInstance.selGoalType,goalBeanInstance.AccountNameList);
          
          	if(goalBeanInstance.goalList.isEmpty())
          	{
                goalBeanInstance.goalList= goalServicesInstance.addRow(goalBeanInstance.goalList,goalBeanInstance.selGoalType); 
                goalBeanInstance.goalList= goalServicesInstance.addRow(goalBeanInstance.goalList,goalBeanInstance.selGoalType); 
        	}  
    	}
    */
    
    /**
    * @Description: closePopUp() is used to render goal read only page after adding new goal
    * Return Type: pageReference 
    */
     
    public pageReference closePopUp()
    {
        pageReference pagevf = new pageReference('/apex/GoalVFPage?entityId='+goalBeanInstance.EntityId);
        pagevf.setRedirect(true);
        return pagevf;
    }
     
    /**
    * @Description: addNewRow() adds a new row
    * Return Type: void
    */
     
    public void addNewRow()
    {
    	//Added on : 19/4/2013 : Gaurav : validate goal as per entity gloabal assumption record
    	if(goalBeanInstance.goalList.size() < (objEntityGlobalAssumption.No_of_Goals__c + 1))
    	{
        	goalBeanInstance.goalList= goalServicesInstance.addRow(goalBeanInstance.goalList,goalBeanInstance.selGoalType, goalBeanInstance.EntityId); 
        	//goalBeanInstance.goalList= goalServicesInstance.addRow(goalBeanInstance.goalList,goalBeanInstance.selGoalType, goalBeanInstance.EntityId);
    	}	
        else
        {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'You cannot add more Goals'));
        }	
        return; 
    }
    
    /**
    * @Description: addNewRowFromView is used to add two bydefault new rows
    * Return Type: pageReference 
    */
     
    public pageReference addNewRowFromView()
    {
    	if(goalCount < (objEntityGlobalAssumption.No_of_Goals__c + 1))
    	{
	        this.isAddednew = true;
	        goalBeanInstance.addNewListView = goalServicesInstance.addRow(goalBeanInstance.addNewListView ,goalBeanInstance.selGoalType, goalBeanInstance.EntityId);
	        //goalBeanInstance.addNewListView = goalServicesInstance.addRow(goalBeanInstance.addNewListView ,goalBeanInstance.selGoalType, goalBeanInstance.EntityId);
	        goalCount ++; 
    	}
        else
	        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'You Cannot add more Goals'));
	        //goalBeanInstance.addNewListView = goalServicesInstance.addRow(goalBeanInstance.addNewListView ,goalBeanInstance.selGoalType, goalBeanInstance.EntityId); 
	        return null;
       
    }
    // getOwnerItems() populates values of Owner picklist  
    // public List<SelectOption> getOwnerItems() 
    // {
    //     List<SelectOption> options = goalServicesInstance.getOwnerItems(goalBeanInstance.EntityId);    
    //     return options;
    // }
    
    /* public pageReference Save() 
    {
        goalServicesInstance.saveGoals(goalBeanInstance.goalList); 
        goalBeanInstance.AggQueryResult = goalServicesInstance.getDBValues(); 
        goalBeanInstance.goalTypeClassList= goalServicesInstance.populateSummaryTableList( goalBeanInstance.AggQueryResult, goalBeanInstance.goalTypeClassList);
        goalBeanInstance.displayPopUp=false; 
        return null;
    }*/
    
    /**
    * @Description: Save function is used to save newly added goals on edit page
    * Return Type: pageReference 
    */
     
    public pageReference Save() 
    {
        pageReference pagevf ;
        pagevf = null;
        ApexPages.getMessages().clear();
        List<Goal__c> goalobjlist = new List<Goal__c>();
        for(Goal__c goal:goalBeanInstance.goalList)
        {
            if(!goalBeanInstance.isRowEmpty(goal))
                goalobjlist.add(goal);
        }    
        Integer flag = 0;   
        
        for(Goal__c gol:goalobjlist)
        {
            try
            {
                goalBeanInstance.validate(gol);
                gol.RemoveCheckbox__c=false;
            }    
            catch(ValidationException e)
            {
                flag = 1;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
            }    
        }    
        if(flag==0)
        {
             upsert goalobjlist;
             //goalBeanInstance.AggQueryResult = goalServicesInstance.getDBValues(goalBeanInstance.AccountNameList); 
             //goalBeanInstance.goalTypeClassList= goalServicesInstance.populateSummaryTableList( goalBeanInstance.AggQueryResult, goalBeanInstance.goalTypeClassList);
             //goalBeanInstance.displayPopUp=false;

             pagevf = new pageReference('/apex/GoalVFPage?entityId='+goalBeanInstance.EntityId);
             pagevf.setRedirect(true);
        }
        return pagevf;   
     }
     
     /**
     * @Description: SaveFromView function is used to save newly added goals on read only page
     * Return Type: pageReference 
     */
     
     public pageReference SaveFromView()
     {
        pageReference pagevf ;
        pagevf = null;
        
        if(goalBeanInstance.addNewListView.size()>0)
        {
        	
            ApexPages.getMessages().clear();
            List<Goal__c> goalobjlist = new List<Goal__c>();
            for(Goal__c goal:goalBeanInstance.addNewListView)
            {
            	if(!goalBeanInstance.isRowEmpty(goal))
                {
                    goalobjlist.add(goal);
                }
            }
   
            Integer flag = 0;  
             
            for(Goal__c gol : goalobjlist)
            {
                try
                {
                    goalBeanInstance.validate(gol);
                }    
                catch(ValidationException e)
                {
                    flag=1;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getMessage()));
                }    
            }
            if(flag==0)
            {   
                upsert goalobjlist;
                this.isAddednew = false;
                goalBeanInstance.addNewListView = new List<Goal__c>();
                pagevf = new pageReference('/apex/GoalVFPage?entityId='+goalBeanInstance.EntityId);
                pagevf.setRedirect(true);
            }
        }
        return pagevf; 
        
     }
     
     /**
     * @Description: edit function is used to direct to edit view fromreadonly view to edit as well as add new goals
     * Return Type: pageReference 
     */
      
     public pageReference edit()
     {
         this.isAddednew = false;
         goalBeanInstance.addNewListView = new List<Goal__c>();
         pageReference pagevf = new pageReference('/apex/GoalEditPage?entityId='+goalBeanInstance.EntityId);
         pagevf.setRedirect(true);
         return pagevf;
     }

	 /**
	 * @Description: Remove function is used to remove the row and associated record
	 */
     public void Remove()
     {
     	goalServicesInstance.removeRecords(goalBeanInstance.goalList);
     }
}