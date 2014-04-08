global class ScheduleKPIReportEvaluation implements Schedulable 
{
	public Date dtDate{set;get;}
	public ScheduleKPIReportEvaluation ()
	{
		dtDate = System.today();
	}
	
	global void execute(SchedulableContext SC)
	 {
	 	dtDate = System.today();
	 	set<ID> idSetofPlanner = new set<ID>();
	 	set<ID> idSetofMgr = new set<ID>();
	 	String strQuery='';
	 	Map<String,Planner_ID__c> userRoleMapOfPlanner = Planner_ID__c.getAll();
	 	Map<String,Manager_Role__c> userRoleMapOfMgr = Manager_Role__c.getAll();
		if(userRoleMapOfPlanner.size() > 0)
		{
			for(String strName :userRoleMapOfPlanner.keySet())
			{
				if(strName !='Mgr[GALAXY DELHI]'&& strName!= 'Mgr[GALAXY MUMBAI 1]'&& strName!='Mgr[GALAXY MUMBAI II ]')
				{
					Planner_ID__c objPlanner = userRoleMapOfPlanner.get(strName);
					idSetofPlanner.add(objPlanner.Id__c);
				} 
			}
		}
		if(userRoleMapOfMgr.size() > 0)
		{
			for(String strName :userRoleMapOfMgr.keySet())
			{
				Manager_Role__c objMgr = userRoleMapOfMgr.get(strName);
				idSetofMgr.add(objMgr.Id__c);
			}
		}
		
		Integer iCount;
		String strQuery_1 ='';
		String strQuery_2='';
		if(idSetofPlanner!= null && idSetofPlanner.size() > 0)
		{
			strQuery_1 ='(';
			for(ID id: idSetofPlanner)
			{
				strQuery_1 += '\'' + id + '\',';
			}
			strQuery_1 = strQuery_1.substring(0, strQuery_1.length() -1);
			strQuery_1 +=')';
		}
		
		if(idSetofMgr!= null && idSetofMgr.size() > 0)
		{
			strQuery_2='(';
			for(ID id: idSetofMgr)
			{
				strQuery_2 += '\'' + id + '\',';
			}
			strQuery_2 = strQuery_2.substring(0, strQuery_2.length()-1);
			strQuery_2 +=')';
		}
		
		System.debug('=====dtDate====='+dtDate);
		System.debug('=====strQuery_1====='+strQuery_1);
		strQuery = 'Select u.UserRole.Name, u.UserRole.Id, u.UserRoleId, u.Name, u.Id From User u where UserRoleId  IN '+strQuery_1+' or UserRoleId IN '+strQuery_2;
		System.debug('=====strQuery====='+strQuery);
		KPIReportBatch kpiBatch = new KPIReportBatch();
		kpiBatch.query = strQuery;
		kpiBatch.currentDate = dtDate;
        database.executebatch(kpiBatch,1);
    } 

}