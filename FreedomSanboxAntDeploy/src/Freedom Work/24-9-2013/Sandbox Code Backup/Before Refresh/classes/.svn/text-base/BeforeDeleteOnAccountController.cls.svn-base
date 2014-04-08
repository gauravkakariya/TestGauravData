/*
	Revision History:
	
  	Version     Version Author     Date        Comments
   	1.0			Manasi Ranade	   23/1/2012	Issue id : 00001447: Code to add delete entity 
   												button related functionality
   												
*/
public with sharing class BeforeDeleteOnAccountController
{
	public static Void DeleteEntityRelatedRecords(Set<Id> accountIdSet)
	{
		DatabaseSOQL objSOQL = new DatabaseSOQL();
		List<Sobject> lstObjToBeDelete = new List<Sobject>();
		for(Action_Plan__c objActionPlan : [SELECT id FROM Action_Plan__c 
											WHERE First_Holder_Name__c IN: accountIdSet])
		{
			lstObjToBeDelete.add(objActionPlan);
		}
		for(Checklist__c objChecklist : [SELECT id FROM Checklist__c WHERE Entity__c IN: accountIdSet])
		{
			lstObjToBeDelete.add(objChecklist);
		}
		for(Client_Details__c objClientDetails : [SELECT id FROM Client_Details__c WHERE Entity__c IN: accountIdSet])
		{
			lstObjToBeDelete.add(objClientDetails);
		}
		for(Conveyance_Expense__c objConveyanceExpense : [SELECT id FROM Conveyance_Expense__c WHERE Entity_Name__c IN: accountIdSet])
		{
			lstObjToBeDelete.add(objConveyanceExpense);
		}
		for(Expense__c objExpense : [SELECT id FROM Expense__c WHERE Entity_Name__c IN: accountIdSet])
		{
			lstObjToBeDelete.add(objExpense);
		}
		for(Goal_Profile__c objGoalProfile : [SELECT id FROM Goal_Profile__c WHERE Account__c IN: accountIdSet])
		{
			lstObjToBeDelete.add(objGoalProfile);
		}
		for(VCSSA__VCSEmail__c objVCSSAVCSEmail : [SELECT id FROM VCSSA__VCSEmail__c WHERE VCSSA__Account__c IN: accountIdSet])
		{
			lstObjToBeDelete.add(objVCSSAVCSEmail);
		}
	/*Setty : SMS Magic uninstall 19/09/2012
		
		for(smsmagicvc1__smsMagic__c objsmsmagicvc1smsMagic : [SELECT id FROM smsmagicvc1__smsMagic__c WHERE Account__c IN: accountIdSet])
		{
			lstObjToBeDelete.add(objsmsmagicvc1smsMagic);
		}
		
	End:Setty	*/
//	/*Setty:NewCode
		for(smagicbasic__smsMagic__c objsmagicbasicsmsMagic : [SELECT id FROM smagicbasic__smsMagic__c WHERE Account__c IN: accountIdSet])
		{
			lstObjToBeDelete.add(objsmagicbasicsmsMagic);
		}
	//*/
		
		/*//error: INVALID_PERSON_ACCOUNT_OPERATION, cannot reference person contact:
		for(Contact objContact : [SELECT id FROM Contact WHERE AccountId IN: accountIdSet])
		{
			lstObjToBeDelete.add(objContact);
		}*/
		for(Opportunity objOpportunity : [SELECT id FROM Opportunity WHERE AccountId IN: accountIdSet])
		{
			lstObjToBeDelete.add(objOpportunity);
		}
		/*//Didn't find any account related field 
		for(Quote objQuote : [SELECT id FROM Quote. WHERE AccountId IN: accountIdSet])
		{
			lstObjToBeDelete.add(objQuote);
		}*/
		for(Case objCase : [SELECT id FROM Case WHERE AccountId IN: accountIdSet])
		{
			lstObjToBeDelete.add(objCase);
		}
		for(Contract objContract : [SELECT id FROM Contract WHERE AccountId IN: accountIdSet])
		{
			lstObjToBeDelete.add(objContract);
		}
		for(Asset objAsset : [SELECT id FROM Asset WHERE AccountId IN: accountIdSet])
		{
			lstObjToBeDelete.add(objAsset);
		}
		for(Account objChildAccounts : [SELECT Id,Parent_Entity__c  FROM Account WHERE Parent_Entity__c IN: accountIdSet])
		{
			lstObjToBeDelete.add(objChildAccounts);
		}
		System.debug('======LstTOBe deleted======'+lstObjToBeDelete);
		delete lstObjToBeDelete;
	}
}