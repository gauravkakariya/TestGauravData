/*
*
*	@ Author				- Shailesh .P. Deshpande
*	@ Class					- PointsCalculator
*	@ Description			- This class is basically used for reporting purpose. This class will get the individual FP's points which are being calculated in the
*							  PlannersPointCalculator class. The points are calculated in the CalculatePoints Method. The list returned by this method contained								  individual member and their total points for a specified date range(In this case Jan 1, 2011 till date). For each of the element in the								  list a new Point Calclulator(custom object) record is created(if a points calculator record for thst user does not exist) or is									  updated(if record already exist). This class is invoked via a schedular which is scheduled to run once everyday, thus changing the end								  date every time it is run.
*	@ Created Date			- 10th October 2011
*	@ Last Modified Date	- 11th October 2011
*	@ Last Modified by		- Shailesh. P. Deshpande
*
*	@ Modifications Done	- Added a custom setting(DateRange) which will store the Date Range(Start Date, End Date). Referenced this Custom Setting in the class.
*
*/
public with sharing class PointsCalculator
{
	/*	Start - Variable Declaration */
	Date startDate;
	Date endDate;
	Map <Id, Points_Calculator__c> mapPC =  new Map<Id, Points_Calculator__c>();
	List<Points_Calculator__c> lstPC = new List<Points_Calculator__c>();
	/*	End - Variable Declaration*/

	// Constructor.
	public PointsCalculator()
	{
		
		DateRange__c objDT =  DateRange__c.getValues('Financial Year 2011'); // added on 11th October, 2011
		
		// added on 11th October, 2011
		/*if(objDT != null)
		{
			startDate = objDT.Start_Date__c != null ? objDT.Start_Date__c : (Date.today() < Date.newInstance(Date.today().year(), 4, 1) ? Date.newInstance(Date.today().addYears(-1).year(), 4, 1) : Date.newInstance(Date.today().year(), 4, 1) );
			endDate = Date.today();
		}
		else
		{
			startDate = Date.today() < Date.newInstance(Date.today().year(), 4, 1) ? Date.newInstance(Date.today().addYears(-1).year(), 4, 1) : Date.newInstance(Date.today().year(), 4, 1) ;
			endDate = Date.today();
		}*/ // commented by Shailesh. P. Deshpande as per conversation with Bishnu. 
		
		// added by Shailesh. P. Deshpande on 18th October 2011
		startDate = Date.today().addDays(-120);
		endDate = Date.today();
		
		String strStartDate = Date.today().addDays(-120).month() + '/' + Date.today().addDays(-120).day() + '/' + Date.today().addDays(-120).year(); 
		String strEndDate = Date.today().month() +'/'+ Date.today().day() +'/'+ Date.today().year();
		
		
		// Query all the existing Points Calculator records. Add them to a Map.
		for(Points_Calculator__c pc: [Select Id, User__c, Start_Date__c, End_Date__c, Points__c from Points_Calculator__c])
		{
			mapPC.put(pc.User__c, pc);
		}

		// Instantiate the PlannersPointCalculator class.
		PlannersPointCalculator objPPC =  new PlannersPointCalculator();
		
		objPPC.setStartDate(strStartDate); // pass in the start date
		objPPC.setEndDate(strEndDate); // pass in the end date
		objPPC.calculatePoints(); // calculate the points
		
		// for all the records returned create a Point Calculator record
		for(Integer i=0; i < objPPC.getPointDetailsList().size(); i++)
		{
			Points_Calculator__c objPC;

			// if the Point Calculator record for the same user already exist, update that record
			if(mapPC != null && mapPC.containsKey(objPPC.getPointDetailsList()[i].objUser.Id))
			{
				objPC =  new Points_Calculator__c(Id = mapPC.get(objPPC.getPointDetailsList()[i].objUser.Id).Id);
				objPC.Name = objPPC.getPointDetailsList()[i].objUser.Name;
				objPC.User__c = objPPC.getPointDetailsList()[i].objUser.Id;
				objPC.Start_Date__c = startDate;
				objPC.End_Date__c = endDate;
				objPC.Points__c = objPPC.getPointDetailsList()[i].TotalPoints;	
			}
			else 			// if the Point Calculator record for the user does not exist, create a new record
			{
				objPC =  new Points_Calculator__c();
				objPC.Name = objPPC.getPointDetailsList()[i].objUser.Name;
				objPC.User__c = objPPC.getPointDetailsList()[i].objUser.Id;
				objPC.Start_Date__c = startDate;
				objPC.End_Date__c = endDate;
				objPC.Points__c = objPPC.getPointDetailsList()[i].TotalPoints;
			}
			lstPC.add(objPC);
		}
		
		//system.debug('===='+ lstPC);
		//system.debug('===='+ lstPC.size());
		
		if(!lstPC.isEmpty())
		{
			upsert lstPC; // upsert
		}

	}	
}