/*
	Revision History:
    Version     Version Author    Date          Comments
	2.0			Gaurav	 		  25/09/2013   1.Handler for Business Unit Trigger used for set Dafault Business Unit

*/

public with sharing class BusinessUnitHandler 
{
	//Set Default BusinessUnit -Only one active Business Unit is set to Default
	public void onBeforeInsertCheckActiveBusinessUnit(List<Business_Unit__c> lstNewBusinessUnit)
	{
		List<Business_Unit__c> lstDefaultBusinessUnit = new List<Business_Unit__c>();
		List<Business_Unit__c> lstUpdateBusinessUnit = new List<Business_Unit__c>();
		
		//Collect all Bussines unit where IsDefault to true
		Map<Id, Business_Unit__c> mapIdToBusinessUnit = new Map<Id, Business_Unit__c>([Select Id, Name, Is_Default__c 
																					   From Business_Unit__c 
																					   Where Is_Default__c= true]);
		//Make all Old Bussiness Unit to false 				
		for(Business_Unit__c objBusinessUnit : mapIdToBusinessUnit.values())	
		{
			if(objBusinessUnit.Is_Default__c == true)
			{
				objBusinessUnit.Is_Default__c = false;
				lstUpdateBusinessUnit.add(objBusinessUnit);
			}
		}
		
		//Make all Bussiness Unit to false 																			   
		for(Business_Unit__c objBusinessUnit : lstNewBusinessUnit)	
		{
			if(objBusinessUnit.Is_Default__c == true)
			{
				objBusinessUnit.Is_Default__c = false;
				lstDefaultBusinessUnit.add(objBusinessUnit);
			}
		}
		
		//Insert Bussines Unit set IsDefault to true
		if(lstDefaultBusinessUnit.size() > 0)
		{
			Business_Unit__c objBusinessUnit = lstDefaultBusinessUnit[0];
			objBusinessUnit.Is_Default__c = true;
		}
		
		//Update Old Bussines Unit set IsDefault to false 
		if(lstUpdateBusinessUnit.size() > 0 && lstDefaultBusinessUnit.size() > 0)
			update lstUpdateBusinessUnit;
	}
	
}