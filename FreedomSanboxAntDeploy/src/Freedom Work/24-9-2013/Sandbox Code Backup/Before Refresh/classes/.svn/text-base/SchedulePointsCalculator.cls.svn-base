/*
	Revision History:
	
    Version     Version Author     Date        	Comments
    1.0         Mahesh Hirugade	   18/11/2011	This schedular gets the roles of financial planners from FP_Roles__c custom setting and collect the list of 
    											Financial Planners by the query. The list of FPs is provided to BatchPointsCalculator batch class.
    
*/
global class SchedulePointsCalculator implements Schedulable
{
	public Date scheduleDate {set;get;}
	public SchedulePointsCalculator()
	{
		scheduleDate = System.today();
	}
	
	global void execute(SchedulableContext SC)
	{
		Map<String,FP_Roles__c> userRoleMapOfPlanner = FP_Roles__c.getAll();
		
		set<ID> idSetofPlanner = new set<ID>();
		if(userRoleMapOfPlanner.size() > 0)
		{
			for(String strName :userRoleMapOfPlanner.keySet())
			{
				FP_Roles__c objPlanner = userRoleMapOfPlanner.get(strName);
				idSetofPlanner.add(objPlanner.Id__c);
			}
		}
		String strQuery ='';
		String strQuery_1 ='';
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
		
		strQuery = 'Select u.UserRole.Name, u.UserRole.Id, u.UserRoleId, u.Name, u.Id From User u where u.IsActive = true and UserRoleId  IN'+strQuery_1;
		BatchPointsCalculator objBatchPointsCalculator = new BatchPointsCalculator();
		objBatchPointsCalculator.query =strQuery;
		objBatchPointsCalculator.dtDate = scheduleDate;
		Database.executeBatch(objBatchPointsCalculator);
	}
}