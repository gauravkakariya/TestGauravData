/********************************************************************************************************** 
         Eternus Solutions 
		   Author  : Dipak Nikam
		   Date    : 15/09/2011
		   Purpose : Controller for create workstation functionality .
		   Summary :  			 	 

         Eternus Solutions 
		   Author  : Mahesh Hirugade
		   Date    : 09/02/2012
		   Purpose : To add new field "Advisor" to workstation object.
		   Summary : According to workstation hierarchy and assignment sheet sent by Swati Thakkar, new field "Advisory" is added to Workstation object.
		   			 So added getAdvosor() property to show the picklist on create workstation page.
		   			 
		 Eternus Solutions 
		   Author  : Anupam Agrawal
		   Date    : 28/12/2012
		   Purpose : To add new field "Operations" to workstation object.
		   Summary : 

*********************************************************************************************************/


public with sharing class CreateWorkstationController 
{
	public List<Workstation__c>lstWorkstations {set;get;}
	public List<Workstation__c>lstExistingWorkstations{set;get;}
	public String FinancialPlanner{get;set;}
	private List<Workstation__c>lstWorkstationsDelete{set;get;}
	public List<User> lstFinancialPlanners{get;set;}
	private List<User> lstBusinessDeveloper{get;set;}
	private List<User> lstCompliance{get;set;}
	private List<User> lstTechnology{get;set;}
	private List<User> lstMemberEngagement{get;set;}
	private List<User> lstAdvosor{get;set;}
	
	public Map<String,User> MapofIdAndUser{set;get;}
	public Map<String,String> MapofRoleIdAndParentId {set;get;}
	public Map<ID,User> MapUserRoleIdandUser{set;get;}
	private set<ID> idSetofPlanner{set;get;}
	private set<ID> idSetofComplaince{set;get;}
	private set<ID> idSetOfTech{set;get;}
	private set<ID> idSetOfBDev{set;get;}
	private set<ID> idSetOfMember{set;get;}
	private set<ID> idSetofAdvisor{set;get;}
	Map<String,Planner_ID__c> userRoleMapOfPlanner = Planner_ID__c.getAll();
	Map<String,Compliance_ID__c> userRoleMapOfComplaince = Compliance_ID__c.getAll();
	Map<String,Tech__c> userRoleMapOfTech = Tech__c.getAll();
	Map<String,Member_Engagement__c> userRoleMapOfMember= Member_Engagement__c.getAll();
	Map<String,Bussiness_Dev__c> userRoleMapOfBDev= Bussiness_Dev__c.getAll();
	Map<String,Advisory__c> userRoleMapOfAdvisor = Advisory__c.getAll();
	
	public List<SelectOption> lstOperationTeamMember {get;set;}
	 
	public CreateWorkstationController()
	{
		lstWorkstations = new List<Workstation__c>();
		Workstation__c workstation = new Workstation__c();
		lstWorkstations.add(workstation);
		lstFinancialPlanners = new List<User>();
		lstBusinessDeveloper = new List<User>();
		lstCompliance = new List<User>();
		lstTechnology = new List<User>();
		lstMemberEngagement = new List<User>();
		lstAdvosor = new List<User>();
		lstWorkstationsDelete= new List<Workstation__c>();
		lstOperationTeamMember = new List<SelectOption>();
		
	}
	
	
	public void Init()
	{
		idSetofPlanner = new set<ID>();
		idSetofComplaince = new set<ID>();
		idSetOfTech = new set<ID>();
		idSetOfBDev = new set<ID>();
		idSetOfMember = new set<ID>();
		idSetofAdvisor = new set<ID>();
		if(userRoleMapOfPlanner.size() > 0)
		{
			for(String strName :userRoleMapOfPlanner.keySet())
			{
				Planner_ID__c objPlanner = userRoleMapOfPlanner.get(strName);
				idSetofPlanner.add(objPlanner.Id__c);
			}
		}
		
		if(userRoleMapOfComplaince.size() >0 )
		{
			for(String strName :userRoleMapOfComplaince.keySet())
			{
				Compliance_ID__c objComplaince = userRoleMapOfComplaince.get(strName);
				idSetofComplaince.add(objComplaince.Id__c);
			}
		}
		
		if(userRoleMapOfTech.size() >0 )
		{
			for(String strName :userRoleMapOfTech.keySet())
			{
				Tech__c objTech = userRoleMapOfTech.get(strName);
				idSetOfTech.add(objTech.Id__c);
			}
		}
		
		if(userRoleMapOfMember.size() >0 )
		{
			for(String strName :userRoleMapOfMember.keySet())
			{
				Member_Engagement__c objMember = userRoleMapOfMember.get(strName);
				idSetOfMember.add(objMember.Id__c);
			}
		}
		if(userRoleMapOfBDev.size() >0 )
		{
			for(String strName :userRoleMapOfBDev.keySet())
			{
				Bussiness_Dev__c objBdev = userRoleMapOfBDev.get(strName);
				idSetOfBDev.add(objBdev.Id__c);
			}
		}
		if(userRoleMapOfAdvisor.size() >0)
		{
			for(String strName :userRoleMapOfAdvisor.keySet())
			{
				Advisory__c objAdvisor = userRoleMapOfAdvisor.get(strName);
				idSetofAdvisor.add(objAdvisor.Id__c);
			}
		}
	}
	
	
	
	
	public List<SelectOption> getFinancialPlanners()
	{
		List<SelectOption> FinancialPlanners = new List<SelectOption>();
		List<Workstation__c>lstExistingWorkstations = new List<Workstation__c>(); 
		Set<ID> setOfFinPlannerId = new set<ID>();
		lstExistingWorkstations = [Select w.Manager__c, 
							      		  w.Id, 
							      		  w.Financial_Planner__c 
							              From Workstation__c w];
							              
		if(lstExistingWorkstations != null && lstExistingWorkstations.size()>0)
		{
			for(Workstation__c workstation :lstExistingWorkstations)
			{
				setOfFinPlannerId.add(workstation.Financial_Planner__c);
			}
		}
						     
		lstFinancialPlanners = [Select u.ProfileId, 
						  	          u.Name, 
						  			  u.IsActive, 
						  			  u.Id,
						 			  u.UserRoleId ,
						  			  u.UserRole.ParentRoleId,
						  			  u.Manager.Name, u.ManagerId,
						  			  u.UserRole.Name, u.Profile.Name 
						  			  From User u Where u.IsActive = true 
						  			  and u.Id Not IN :setOfFinPlannerId 
						  			  and u.UserRoleId IN:idSetofPlanner 
						  			  Order By Name];
						  			   
						  			   
		FinancialPlanners.add(new SelectOption('','None'));
		if(lstFinancialPlanners != null && lstFinancialPlanners.size()>0)
		{
			// for assigning the manager to FP
			MapofIdAndUser = new Map<String,User>();
			for(User user :lstFinancialPlanners)
			{
				MapofIdAndUser.put(user.Id,user);
			}
			for(User objUser : lstFinancialPlanners)
			{
				FinancialPlanners.add(new SelectOption(objUser.Id,objUser.Name));
			}
		}
	return FinancialPlanners;
	}
	
	public List<SelectOption> getBusinessDeveloper()
	{
		List<SelectOption> options = new List<SelectOption>();
		lstBusinessDeveloper = [Select u.ProfileId, 
						  	          u.Name, 
						  			  u.IsActive, 
						  			  u.Id,
						 			  u.UserRoleId ,
						  			  u.UserRole.ParentRoleId,
						  			  u.Manager.Name, u.ManagerId,
						  			  u.UserRole.Name, u.Profile.Name 
						  			  From User u Where u.IsActive = true 
						  			  and u.UserRoleId IN :idSetOfBDev 
						  			  Order By Name ];
		options.add(new SelectOption('','None'));
		if(lstBusinessDeveloper != null && lstBusinessDeveloper.size()>0)
		{ 
			for(User objUser : lstBusinessDeveloper)
			{
				options.add(new SelectOption(objUser.Id,objUser.Name));
			}
		}
		return options;
	}
	public List<SelectOption> getAdvosor()
	{
		List<SelectOption> options = new List<SelectOption>();
		lstAdvosor = [Select u.ProfileId, 
						  	          u.Name, 
						  			  u.IsActive, 
						  			  u.Id,
						 			  u.UserRoleId ,
						  			  u.UserRole.ParentRoleId,
						  			  u.Manager.Name, u.ManagerId,
						  			  u.UserRole.Name, u.Profile.Name 
						  			  From User u Where u.IsActive = true 
						  			  and u.UserRoleId IN :idSetofAdvisor 
						  			  Order By Name ];
		options.add(new SelectOption('','None'));
		if(lstAdvosor != null && lstAdvosor.size()>0)
		{ 
			for(User objUser : lstAdvosor)
			{
				options.add(new SelectOption(objUser.Id,objUser.Name));
			}
		}
		return options;
	}
	
	public List<SelectOption> getCompliance()
	{
		List<SelectOption> options = new List<SelectOption>();
		
		lstCompliance = [Select u.ProfileId, 
						  	          u.Name, 
						  			  u.IsActive, 
						  			  u.Id,
						 			  u.UserRoleId ,
						  			  u.UserRole.ParentRoleId,
						  			  u.Manager.Name, u.ManagerId,
						  			  u.UserRole.Name, u.Profile.Name 
						  			  From User u  
						  			  Where u.IsActive = true 
						  			  and u.UserRoleId IN: idSetofComplaince
						  			  Order By Name ];
		options.add(new SelectOption('','None'));
		if(lstCompliance != null && lstCompliance.size()>0)
		{ 
			for(User objUser : lstCompliance)
			{
				options.add(new SelectOption(objUser.Id,objUser.Name));
			}
		}
		return options;
	} 
	
	public List<SelectOption> getTech()
	{
		List<SelectOption> options = new List<SelectOption>();
		lstTechnology = [Select u.ProfileId,
						  	          u.Name, 
						  			  u.IsActive, 
						  			  u.Id,
						 			  u.UserRoleId ,
						  			  u.UserRole.ParentRoleId,
						  			  u.Manager.Name, u.ManagerId,
						  			  u.UserRole.Name, u.Profile.Name 
						  			  From User u Where u.IsActive = true 
						  			  and u.UserRoleId IN : idSetOfTech 
						  			  Order By Name ]; 
						  			  
		options.add(new SelectOption('','None'));
		if(lstTechnology != null && lstTechnology.size()>0)
		{ 
			for(User objUser : lstTechnology)
			{
				options.add(new SelectOption(objUser.Id,objUser.Name));
			}
		}
		return options;
	}
	
	public List<SelectOption> getMemberEngagement()
	{
		List<SelectOption> options = new List<SelectOption>();
		lstMemberEngagement = [Select u.ProfileId, 
						  	    u.Name, 
						  		u.IsActive, 
						  		u.Id,
						 		u.UserRoleId ,
						  		u.UserRole.ParentRoleId,
						  		u.Manager.Name, u.ManagerId,
						  		u.UserRole.Name, u.Profile.Name 
						  		From User u Where u.IsActive = true 
						  		and u.UserRoleId IN :idSetOfMember
						  	    Order By Name ]; 
		
		options.add(new SelectOption('','None'));
		
		if(lstMemberEngagement != null && lstMemberEngagement.size()>0)
		{ 
			for(User objUser : lstMemberEngagement)
			{
				options.add(new SelectOption(objUser.Id,objUser.Name));
			}
		}
		
		//Code for Operation Team Member
		lstOperationTeamMember = new List<SelectOption>();
		lstOperationTeamMember.add(new SelectOption('','None'));
		for(User objUser : [Select Name, Profile.Name, ProfileId From User where Profile.Name='Operations-Compliance'])
			lstOperationTeamMember.add(new SelectOption(objUser.Id,objUser.Name));
		return options;
	}
	
	
	
	public void Addrow()
	{
		Workstation__c objWorkstation = new Workstation__c ();
		lstWorkstations.add(objWorkstation);
	}
	
	public void Remove()
	{
		if(lstWorkstations != null && lstWorkstations.size()>1)
		{
			Workstation__c objWorkstation = lstWorkstations.get(lstWorkstations.size()-1);
			lstWorkstationsDelete.add(objWorkstation);
			lstWorkstations.remove(lstWorkstations.size()-1);
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'There atleast one record should require to save'));
		}
	}
	
	
	public void AssignManager()
	{
		for(Workstation__c workstation:lstWorkstations)
		{
			if(MapofIdAndUser != null && MapofIdAndUser.size()>0)
			{
				if(MapofIdAndUser.containsKey(workstation.Financial_Planner__c))
				{
					User tempUser = MapofIdAndUser.get(workstation.Financial_Planner__c);
					workstation.Manager__c = tempUser.ManagerId;
				}
			}
			
		}
	}
		   
	
	public Pagereference Save()                           
	{
		Boolean successflag=true;
		Pagereference pgRef = null;
		List<Workstation__c> lstWorkstationstoUpdate = new List<Workstation__c>();
		if(lstWorkstations != null && lstWorkstations.size()> 0)
		{ 
			
			/*Commented code is for validation of Workstation */
			
			//ValidateWorkstation objValidate = new ValidateWorkstation();
			//objValidate.PopulateAllMaps();
			//objValidate.UpdateCurrentMap(lstWorkstations);
			for(Workstation__c workstation:lstWorkstations)
			{
				//objValidate.validateAllWorkstations(workstation);
				lstWorkstationstoUpdate.add(workstation);
			}
			List<Database.Upsertresult>lstupsertResult = Database.upsert(lstWorkstationstoUpdate);
			pgRef = new Pagereference('/apex/ViewAllWorkstations');
			
		}
		pgRef.setRedirect(true);
		return pgRef;
	}
	
	public Pagereference Close()
	{
		Pagereference pgRef = new Pagereference('/apex/WorkstationModel');
		pgRef.setRedirect(true);
		return pgRef;
	}
	
	public Pagereference ViewWorkstation()
	{
		Pagereference pgRef = new Pagereference('/apex/ViewAllWorkstations');
		pgRef.setRedirect(true);
		return pgRef;
	}
}