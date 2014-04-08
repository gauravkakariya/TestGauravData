public  class ValidateWorkstation 
{
		Workstation__c wstation {set;get;}
		public Map<ID,List<Workstation__c>>MapOfManagerAndWorkstations{set;get;} 
		public Map<ID,List<Workstation__c>>MapOfComplianceAndWorkstations{set;get;} 
		public Map<ID,List<Workstation__c>>MapOfBusinessDevAndWorkstations{set;get;}  
		public Map<ID,List<Workstation__c>>MapOfMemberEngageAndWorkstations{set;get;}  
		public Map<ID,List<Workstation__c>>MapOfTechAndWorkstations{set;get;}  
		ResourceUtilization__c objResource = ResourceUtilization__c.getInstance('Workstation Configuration');
		
		public void PopulateAllMaps()
		{
			MapOfManagerAndWorkstations = new Map<ID,List<Workstation__c>>();
			MapOfComplianceAndWorkstations = new Map<ID,List<Workstation__c>>();
			MapOfBusinessDevAndWorkstations = new Map<ID,List<Workstation__c>>();
			MapOfMemberEngageAndWorkstations = new Map<ID,List<Workstation__c>>();
			MapOfTechAndWorkstations = new Map<ID,List<Workstation__c>>();
				
			List<Workstation__c> lstExistingWorkstations = new List<Workstation__c>();
			lstExistingWorkstations = 	[Select w.Tech__c,
					   							 w.Name, 
											     w.Member_Engagement__c,
											     w.Manager__c, 
											     w.Id, 
											     w.Compliance__c, 
											     w.Business_Developer__c,
											     w.Financial_Planner__c 
											     From Workstation__c w];
			
			UpdateCurrentMap(lstExistingWorkstations);
		}
		
		public void validateAllWorkstations(Workstation__c workstation)
		{
			if(workstation.Financial_Planner__c == null)
			{
				throw new ValidationException('Financial planner:You must select value');
			}
			else if(workstation.Business_Developer__c  == null)
			{
				throw new ValidationException('Business Developer:You must select value');
			}
			else if(workstation.Compliance__c  == null)
			{
				throw new ValidationException('Compliance:You must select value');
			}
			else if(workstation.Tech__c == null)
			{
				throw new ValidationException('Technology:You must select value');
			}
			else if(workstation.Member_Engagement__c == null)
			{
				throw new ValidationException('Member Engagement:You must select value');
			}
			if(!MapOfManagerAndWorkstations.isEmpty() && MapOfManagerAndWorkstations.containsKey(workstation.Manager__c))
			{
				Double Utilization =0;
				List<Workstation__c>lstTempWorkstation = MapOfManagerAndWorkstations.get(workstation.Manager__c);
				if(lstTempWorkstation !=null && lstTempWorkstation.size() > 0)
					 Utilization = lstTempWorkstation.size();
				
				if(Utilization > objResource.Manager__c)
				{
					throw new ValidationException('Manager:Allocation is full.');
				}
			}
			if(!MapOfBusinessDevAndWorkstations.isEmpty() && MapOfBusinessDevAndWorkstations.containsKey(workstation.Business_Developer__c))
			{
				Double Utilization = 0;
				List<Workstation__c>lstTempWorkstation = MapOfBusinessDevAndWorkstations.get(workstation.Business_Developer__c);
				if(lstTempWorkstation !=null && lstTempWorkstation.size() > 0)
				 	Utilization = lstTempWorkstation.size();
				if(Utilization > objResource.Business_Dev__c)
				{
					throw new ValidationException('Business Developer:Allocation is full.');
				}
			}
			if(!MapOfComplianceAndWorkstations.isEmpty() && MapOfComplianceAndWorkstations.containsKey(workstation.Compliance__c))
			{
				Double Utilization = 0;
				List<Workstation__c>lstTempWorkstation = MapOfComplianceAndWorkstations.get(workstation.Compliance__c);
				if(lstTempWorkstation !=null && lstTempWorkstation.size() > 0)
				 	Utilization = lstTempWorkstation.size();
				if(Utilization > objResource.Compliance__c)
				{
					throw new ValidationException('Compliance:Allocation is full.');
				}
			}
			if(!MapOfTechAndWorkstations.isEmpty() && MapOfTechAndWorkstations.containsKey(workstation.Tech__c))
			{
				Double Utilization = 0;
				List<Workstation__c>lstTempWorkstation = MapOfTechAndWorkstations.get(workstation.Tech__c);
				
				if(lstTempWorkstation !=null && lstTempWorkstation.size() > 0)
				 	Utilization = lstTempWorkstation.size();
				
				if(Utilization > objResource.Technology__c)
				{
					throw new ValidationException('Technology:Allocation is full.');
				}
			}
			if(!MapOfMemberEngageAndWorkstations.isEmpty() && MapOfMemberEngageAndWorkstations.containsKey(workstation.Member_Engagement__c))
			{	
				Double Utilization = 0;
				List<Workstation__c>lstTempWorkstation = MapOfMemberEngageAndWorkstations.get(workstation.Member_Engagement__c);
				if(lstTempWorkstation !=null && lstTempWorkstation.size() > 0)
				 	Utilization = lstTempWorkstation.size();
				 	
				if(Utilization > objResource.Member_Engagement__c)
				{
					throw new ValidationException('Member Engagement: Allocation is full.');
				}
			}
	
		}
		
		public void UpdateCurrentMap(List<Workstation__c> lstExistingWorkstations)
		{
			
			if(lstExistingWorkstations != null && lstExistingWorkstations.size()>0)
			{
			   for(Workstation__c objWorkstation :lstExistingWorkstations)
				{
						/*====MapOfManagerAndWorkstations := This map hold the Manager and its workstations.====*/
					if(!MapOfManagerAndWorkstations.isEmpty() && MapOfManagerAndWorkstations.containsKey(objWorkstation.Manager__c))
					{
						List<Workstation__c>lstTempWorkstation = MapOfManagerAndWorkstations.get(objWorkstation.Manager__c);
						lstTempWorkstation.add(objWorkstation);
						MapOfManagerAndWorkstations.put(objWorkstation.Manager__c,lstTempWorkstation);
					}
					else
					{
						List<Workstation__c>lstTempWorkstation = new List<Workstation__c>();
						lstTempWorkstation.add(objWorkstation);
						MapOfManagerAndWorkstations.put(objWorkstation.Manager__c,lstTempWorkstation);
					}
					 
					/*=======MapOfComplianceAndWorkstations:=Map of Compliance and its workstations ============*/ 
					if(!MapOfComplianceAndWorkstations.isEmpty() && MapOfComplianceAndWorkstations.containsKey(objWorkstation.Compliance__c))
					{
						List<Workstation__c>lstTempWorkstation = MapOfComplianceAndWorkstations.get(objWorkstation.Compliance__c);
						lstTempWorkstation.add(objWorkstation);
						MapOfComplianceAndWorkstations.put(objWorkstation.Compliance__c,lstTempWorkstation);
					}
					else
					{
						List<Workstation__c>lstTempWorkstation = new List<Workstation__c>();
						lstTempWorkstation.add(objWorkstation);
						MapOfComplianceAndWorkstations.put(objWorkstation.Compliance__c,lstTempWorkstation);
					}
					
					/*======MapOfBusinessDevAndWorkstations:=Map of Business Developer and its workstations======*/ 
					if(!MapOfBusinessDevAndWorkstations.isEmpty() && MapOfBusinessDevAndWorkstations.containsKey(objWorkstation.Business_Developer__c))
					{
						List<Workstation__c>lstTempWorkstation = MapOfBusinessDevAndWorkstations.get(objWorkstation.Business_Developer__c);
						lstTempWorkstation.add(objWorkstation);
						MapOfBusinessDevAndWorkstations.put(objWorkstation.Business_Developer__c,lstTempWorkstation);
					}
					else
					{
						List<Workstation__c>lstTempWorkstation = new List<Workstation__c>();
						lstTempWorkstation.add(objWorkstation);
						MapOfBusinessDevAndWorkstations.put(objWorkstation.Business_Developer__c,lstTempWorkstation);
					}
					
					/*======MapOfMemberEngageAndWorkstations:= Map of Member Engagement and its Workstations======*/ 
					if(!MapOfMemberEngageAndWorkstations.isEmpty() && MapOfMemberEngageAndWorkstations.containsKey(objWorkstation.Member_Engagement__c))
					{
						List<Workstation__c>lstTempWorkstation = MapOfMemberEngageAndWorkstations.get(objWorkstation.Member_Engagement__c);
						lstTempWorkstation.add(objWorkstation);
						MapOfMemberEngageAndWorkstations.put(objWorkstation.Member_Engagement__c,lstTempWorkstation);
					}
					else
					{
						List<Workstation__c>lstTempWorkstation = new List<Workstation__c>();
						lstTempWorkstation.add(objWorkstation);
						MapOfMemberEngageAndWorkstations.put(objWorkstation.Member_Engagement__c,lstTempWorkstation);
					}
					
					/*======MapOfTechAndWorkstations:= Map of Technology and its Workstations======*/ 
					if(!MapOfTechAndWorkstations.isEmpty() && MapOfTechAndWorkstations.containsKey(objWorkstation.Tech__c))
					{
						List<Workstation__c>lstTempWorkstation = MapOfTechAndWorkstations.get(objWorkstation.Tech__c);
						lstTempWorkstation.add(objWorkstation);
						MapOfTechAndWorkstations.put(objWorkstation.Tech__c,lstTempWorkstation);
					}
					else
					{
						List<Workstation__c>lstTempWorkstation = new List<Workstation__c>();
						lstTempWorkstation.add(objWorkstation);
						MapOfTechAndWorkstations.put(objWorkstation.Tech__c,lstTempWorkstation);
					}
				}
			}			
		}
		
						

}