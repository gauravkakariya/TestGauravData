public with sharing class CaseTriggerHandler 
{
	public void onBeforeInsert(List<Case> lstNewCase)
	{
		//updatating Assigned Owner Manager Id of Assinged user @Case internal Record Type@:Setty 26/10/2012
		Map<Id, User> mapIdToUser  = new Map<Id, User>([select Id, ManagerId from User ]);
		for(Case objCase : lstNewCase)
		{
			if(objCase.AsssignedTo__c != null)
				objCase.Case_Owenr_Manager__c = mapIdToUser.get(objCase.AsssignedTo__c).ManagerId;
			
		}
	}
	
	public void onAfterInsert(List<Case> lstCase)
	{
		//Sharing Record To Assigned user @Case internal Record Type@:Setty 26/10/2012
		List<CaseShare> lstCaseShare = new List<CaseShare>();
		Map<Id, RecordType> mapIdToRecordType = new Map<Id, RecordType>([select Id ,Name from RecordType where SobjectType='Case']);
		for(Case objCase : lstCase)
		{
			if(mapIdToRecordType.get(objCase.RecordTypeId).Name.equalsIgnoreCase('Ffreedom Internal'))
			{
				CaseShare objCaseShare = new CaseShare();
				objCaseShare.CaseAccessLevel = 'edit';
				objCaseShare.CaseId = objCase.Id; 
				objCaseShare.UserOrGroupId = objCase.AsssignedTo__c;
				lstCaseShare.add(objCaseShare);
			}
		}
		if(!lstCaseShare.isEmpty())
			insert lstCaseShare;
	}

	static testMethod void myUnitTest()
    {           
      //Test Class for  Case Tigger handler
        RecordType objRT = [select Id from RecordType where SobjectType='Case' and name='Ffreedom Internal'];
        Case testCase = new Case(RecordTypeId = objRT.Id);
        User objUse = [Select u.UserType, u.FederationIdentifier From User u where UserType = 'Standard' 
        				and name != 'Technology Support' and IsActive = true limit 1];
        testCase.AsssignedTo__c = objUse.Id;
        insert testCase;
    }
}