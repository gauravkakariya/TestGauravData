/*
Revision History:

		Version     Version Author     Date        Comments
		1.0         --           	   --	  	   Initial Draft
		2.0  		Prajakta Sanap     23/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.	
													Added email field as it is required field						   				 					   
*/


@isTest
private with sharing class TestUpdateLeadOpptoAccount 
{
	
	public static testMethod void testLeadTrigger()
	{
		List<Lead> newLeads = new List<Lead>();
		List<Lead> updateLeads = new List<Lead>();
		List<Opportunity> newOppty = new List<Opportunity>();
			
		TestData_Ffreedom testData = new TestData_Ffreedom();
		Lead newLd = testData.init_Lead();	
		insert newLd;
		
		Opportunity opp = new Opportunity(Name='Test', CloseDate= System.today(), StageName='Interested', Lead__c=newLd.Id);
		insert opp;
		
		{
			 Database.LeadConvert lc = new database.LeadConvert();
	        lc.setLeadId(newLd.Id);
	        lc.setConvertedStatus('Converted');
		    Database.LeadConvertResult lcr = Database.convertLead(lc);
		}
	}
}