public with sharing class ObjectInformation_Dashboard
{
	public Integer leadCount
	{	get;set;	}
	public Integer accountCount
	{	get;set;	}
	public Integer campaignCount
	{	get;set;	}
	public Integer openTaskCount
	{	get;set;	}
	
	public ObjectInformation_Dashboard()
	{
		leadCount = (Integer) [SELECT Count(ID)leadcount FROM Lead][0].get('leadcount');
		accountCount = (Integer) [SELECT Count(ID)accountcount FROM Account][0].get('accountcount');
		campaignCount = (Integer) [SELECT Count(ID)campaigncount FROM Campaign][0].get('campaigncount');
		openTaskCount = (Integer) [Select Count(ID)openTasks From Task where Status != 'Completed'][0].get('openTasks');
	}
}