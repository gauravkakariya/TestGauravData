/*
*
*	@ Author				- Shailesh .P. Deshpande
*	@ Class					- PointsCalculatorReport
*	@ Description			- This class is basically used for reporting purpose. This queries all the "Points Calculator" records and displays them in a
*							  tabular format on a visulaforce page. This page is later used as a source to the Dashboard.
*	@ Created Date			- 13th October 2011
*	@ Last Modified Date	- 13th October 2011
*	@ Last Modified by		- Shailesh. P. Deshpande
*
*	@ Modifications Done	- None
*
*/
public with sharing class PointsCalculatorReport
{
	/* Start - Variable Declaration */
	
	public List<Points_Calculator__c> lstPC {	get;set;	}
	Map<Id, User> mapUser = new Map<Id, User>();
	
	/* End - Variable Declaration */
		
	// Constructor
	public PointsCalculatorReport()
	{
		lstPC = new List<Points_Calculator__c>();
		
		PlannersPointCalculator ppc = new PlannersPointCalculator();
		mapUser = ppc.mapUserIds; // will give the User records based on which we will query the Points calculator records
		
		// get all the points calculator records whose "User__c" is present in the maps keyset.
		for(Points_Calculator__c pc : [Select Id, Name, User__c, User__r.Name, Points__c from Points_Calculator__c where User__c in: mapUser.keySet() order by Points__c DESC, User__r.Name])
		{
			lstPC.add(pc);// add them to the list
		}
	}
}