/*
Revision History:

   Version     Version Author     Date          Comments
   
   1.0 		   Manasi Ranade	  1/12/2011	    Issue Id : FS0290 :
   												After Update:Trigger to create Execution Tracker record if suggested amount is not equal to actual 
   															 amount when Completion Date is entered
   												Before Update: Trigger will not allow user to update the ET record if close date is already filled
   2.0 		   Mahesh Hirugade	  25/04/2012    Issue Id : 00001594 : First execution date - by Praful
   												capture the first execution tracker achieved date as first execution date and can lock the field.
*/ 
trigger UpdateExecutionTracker on Execution_Tracker__c (after update, before update)
{
	Execution_Tracker__c objNewET;
	List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
	List<Execution_Tracker__c> lstUpdateUniqueExeRec = new List<Execution_Tracker__c>();
	Double dblSuggestedAmt = 0, dblActaulAmt = 0, dblRemainingAmt = 0;
	System.debug('******Trigger.new:'+Trigger.new);
	if(Trigger.isAfter && Trigger.isUpdate)//Trigger to create Execution Tracker record if suggested amount is not equal to actual amount when Completion Date is entered
   															 
	{
		for(Execution_Tracker__c objET : Trigger.new)
		{
			system.debug('If****objET.Suggested_Action_Amount__c :'+objET.Suggested_Action_Amount__c+'----------objET.Actual_Action_Amount__c:'+objET.Actual_Action_Amount__c);
			dblActaulAmt = (objET.Actual_Action_Amount__c == null) ? 0 :objET.Actual_Action_Amount__c;
			if(objET.Suggested_Action_Amount__c == null)
				dblSuggestedAmt = 0;
			else
				dblSuggestedAmt = objET.Suggested_Action_Amount__c;
			
			dblRemainingAmt = dblSuggestedAmt - dblActaulAmt;
			if(dblRemainingAmt > 0 && objET.Completion_Date__c != null)
			{
				objNewET = new Execution_Tracker__c();
				//objNewET = objET;
				//objNewET.Entity_Name__c = objET.Entity_Name__c;
				//objNewET.Suggested_Action_Amount__c = dblRemainingAmt;
				//objNewET.Opportunity_Name__c = (objET.Opportunity_Name__c != null) ? objET.Opportunity_Name__c: '';
				objNewET = objET.clone(false);
				System.debug('!!!!!!!!! OobjNewET :'+objNewET);
				System.debug('!!!!!!!!! OobjET    :'+objET);
				objNewET.Actual_Action_Amount__c = null;
				objNewET.Completion_Date__c = null;
				objNewET.Suggested_Action_Amount__c = dblRemainingAmt;
				objNewET.Unique_Execution__c = false;
				lstET.add(objNewET);
			}
			/*else
			{
				if(objET.Opportunity_Name__c == 'Lumpsum' || objET.Opportunity_Name__c == 'SIP')
				{
					if(objET.Asset_Class_Policy_Type__c.contains('Equity'))
						objET.Revenue_Booked__c = objNewET.Suggested_Action_Amount__c * 1.25/100;
					else if(objET.Asset_Class_Policy_Type__c.contains('debt'))
						objET.Revenue_Booked__c = objNewET.Suggested_Action_Amount__c * 0.35/100;
					else
						objET.Revenue_Booked__c = objNewET.Suggested_Action_Amount__c * 0.35/100;
				}
				else if(objET.Opportunity_Name__c == 'General Insurance')
				{
					if(objET.Asset_Class_Policy_Type__c != null)
					{
						strPolicyName = objGI.Asset_Class_Policy_Type__c;
						if(strPolicyName.contains('Motor'))
							dblPayOut = objGI.Suggested_Action_Amount__c * 10/100;
						else if(strPolicyName.contains('Critical Illness'))
							dblPayOut = objGI.Suggested_Action_Amount__c * 20/100;
						else if(strPolicyName.contains('Medical') || strPolicyName.contains('disability'))
							dblPayOut = objGI.Suggested_Action_Amount__c * 20/100;
						else if(strPolicyName.contains('Householder'))
							dblPayOut = objGI.Suggested_Action_Amount__c * 15/100;
						else if(strPolicyName.contains('Travel'))
							dblPayOut = objGI.Suggested_Action_Amount__c * 20/100;
						else if(strPolicyName.contains('vehicle') || strPolicyName.contains('Personal Accident'))
							dblPayOut = objGI.Suggested_Action_Amount__c * 15/100;
						else
							dblPayOut = objGI.Suggested_Action_Amount__c * 15/100; //Default
							//Critical Illness
							//Health - Medical,disability
							//Householder
							//PA
							//Travel
							//Risk - vehicle, Personal Accident
					}
					else
							dblPayOut = objGI.Suggested_Action_Amount__c * 15/100; //Default
				}
				else if(objET.Opportunity_Name__c == 'Life Insurance')
				{
					if(objLI.Insurance_Company__c != null && objLI.Insurance_Company__c != '')
					{
						objET.Scheme_Name_Policy_Name__c = objLI.Insurance_Company__c;
						if(objLI.Insurance_Company__c.contains('Birla Sun Life'))
							dblPayOut = objET.Suggested_Action_Amount__c * 28 / 100;
						else if(objLI.Insurance_Company__c.contains('HDFC'))
							dblPayOut = objET.Suggested_Action_Amount__c * 22 / 100;
						else if(objLI.Insurance_Company__c.contains('ICICI'))
							dblPayOut = objET.Suggested_Action_Amount__c * 8 / 100;
						else if(objLI.Insurance_Company__c.contains('Kotak'))
							dblPayOut = objET.Suggested_Action_Amount__c * 32 / 100;
						else if(objLI.Insurance_Company__c.contains('LIC'))
							dblPayOut = objET.Suggested_Action_Amount__c * 19 / 100;
						else
							dblPayOut = objET.Suggested_Action_Amount__c * 20 / 100; //Default
					}
					else
						dblPayOut = objET.Suggested_Action_Amount__c * 20 / 100;//Default
				}
			}*/
		}
		System.debug('!!!!!! List : '+lstET);
		if(lstET != null && lstET.size() > 0)
			List<Database.Saveresult> lstSaveResult = Database.insert(lstET);
	}
	else if(false)//Trigger will not allow user to update the ET record if close date is already filled
	{
		Map<Id,Execution_Tracker__c> ETOldMap = Trigger.oldMap;
		Map<Id,List<Account>> MapParentIdLstAcc = new Map<Id,List<Account>>();
		
		//FS0402 :  Uique Executions to be auto checked when Completion date is entered.
		//All ET records related to that entity
		//1. From Trigger.New create map as :EntityETMap :  Map<entityId , List<ET>>
		Map<ID,List<Execution_Tracker__c>> EntityToETListMap = new Map<ID,List<Execution_Tracker__c>>();
		for(Execution_Tracker__c objET : Trigger.new)
		{
			if(objET.Completion_Date__c != null)
			{
				if(EntityToETListMap.get(objEt.Entity_Name__c) == Null)
				{
					EntityToETListMap.put(objEt.Entity_Name__c,new List<Execution_Tracker__c>{objEt});
				}
				else
				{
					EntityToETListMap.get(objEt.Entity_Name__c).add(objEt);
				}
			}
		}
		system.debug('@@@@@@@@@@@@ EntityToETListMap==>'+EntityToETListMap);
		//2. Create List of accounts AccountList : [Select Id,Parent__c from Account where id in EntityToETListMap.keyset()];
		List<Account> AccountList = new List<Account>();
		if(EntityToETListMap != null) 
			AccountList = [Select Id,Parent_Entity__c from Account where id in: EntityToETListMap.keyset()];
		system.debug('@@@@@@@@@@@@ AccountList==>'+AccountList);
		/*3. Create a Map of Parent Vs List<Account> : FamilyMembersMap : Map<ParentID, List<FamilyMenbers>>
		We have AccountList from that create map as follows
		for(Account objAcc : AccountList)
		{
			if(objAcc.parent == null)
				then selected account is parent and add id in the keyset of map
			else 
				then selected account is child and add Parentid in the keyset of map
		}*/
		Map<Id, set<id>> FamilyMembersMap = new Map<Id, set<id>>();
		for(Account objAcc : AccountList)
		{
			if(objAcc.Parent_Entity__c == Null)
			{
				if(FamilyMembersMap.get(objAcc.Id) == Null)
				{
					FamilyMembersMap.put(objAcc.Id,new set<Id>{objAcc.Id});
				}
				else
				{
					FamilyMembersMap.get(objAcc.id).add(objAcc.id);
				}
			}
			else
			{
				if(FamilyMembersMap.get(objAcc.Parent_Entity__c) == Null)
				{
					FamilyMembersMap.put(objAcc.Parent_Entity__c,new set<Id>{objAcc.Parent_Entity__c});
				}
				else
				{
					FamilyMembersMap.get(objAcc.Parent_Entity__c).add(objAcc.Parent_Entity__c);
				}
			}
		}
		system.debug('@@@@@@@@@@@@ FamilyMembersMap==>'+FamilyMembersMap);
		/*4. Select All accounts of the selected parent from FamilyMembersMap keset();
		set<Account> RelatedAccountSet = [select id from Account where id in FamilyMembersMap keset() or parent__c in FamilyMembersMap keset()];
		Check the parent and and the accounts in respective account List of map : FamilyMembersMap*/
		List<Account> RelatedAccountSet = new List<Account>();
		if(FamilyMembersMap != null) 
			RelatedAccountSet = [select id,Parent_Entity__c from Account where id in: FamilyMembersMap.keyset() or Parent_Entity__c in: FamilyMembersMap.keyset()];
		for(Account objAcc : RelatedAccountSet)
		{
			if(FamilyMembersMap.get(objAcc.Parent_Entity__c) == Null && objAcc.Parent_Entity__c != Null)
			{
				FamilyMembersMap.put(objAcc.Parent_Entity__c,new set<Id>{objAcc.Id});
			}
			else
			{
				if(objAcc.Parent_Entity__c != Null)
					FamilyMembersMap.get(objAcc.Parent_Entity__c).add(objAcc.id);
				else
					FamilyMembersMap.get(objAcc.Id).add(objAcc.id);
			}
		}
		system.debug('@@@@@@@@@@@@ 2nd FamilyMembersMap==>'+FamilyMembersMap);
		//5. Create map of Account Id VS related ET Records .Take Accounts from above FamilyMembersMap map. ---- ET Records of all Family members
		Map<id,List<Execution_Tracker__c>> allEntitiesETRecordsMap = new Map<id,List<Execution_Tracker__c>> ();
		//List<Execution_Tracker__c> EtList = [Select id From Execution_Tracker__c where Entity_Name__c ]
		set<Id> idSet = new set<Id>();
		if(FamilyMembersMap != null)
		{
			for(Id actId : FamilyMembersMap.keyset())
			{
				Set<Id> acList = FamilyMembersMap.get(actId);
				for(Id objId :acList)
				{
					idSet.add(objId);
				}
			}
		}
		system.debug('@@@@@@@@@@@@ accSet==>'+idSet);
		List<Execution_Tracker__c> EtList = [Select Id,Entity_Name__c,Opportunity_Name__c,Completion_Date__c From Execution_Tracker__c where Entity_Name__c in:idSet];
		for(Execution_Tracker__c objET : EtList)
		{
			//mapQuesIdAnswers.isEmpty() && mapQuesIdAnswers.containsKey(objAnswer.Question_Bank_List__c)
			if(allEntitiesETRecordsMap.get(objET.Entity_Name__c) == Null)
			{
				allEntitiesETRecordsMap.put(objEt.Entity_Name__c,new List<Execution_Tracker__c>{objEt});
			}
			else
			{
				allEntitiesETRecordsMap.get(objEt.Entity_Name__c).add(objEt);
			}
		}
		system.debug('####### allEntitiesETRecordsMap==>'+allEntitiesETRecordsMap);
		
		Boolean isSelectedEntityInFamily = false;
		Map<Id,List<Execution_Tracker__c>> finalSelectedEntityToETList = new Map<Id,List<Execution_Tracker__c>>(); 
		Id IIIIDDDD;
		for(Id SelectedEntityId : EntityToETListMap.keySet())
		{
			IIIIDDDD = SelectedEntityId;
			for(Id ParentID : FamilyMembersMap.keySet())
			{
				Set<Id> familyMemberSet = FamilyMembersMap.get(ParentID);
				if(familyMemberSet != null && familyMemberSet.size() > 0 )
				{
					if(familyMemberSet.contains(SelectedEntityId))
					{
						for(Id objId : familyMemberSet)
						{
							List<Execution_Tracker__c> ETLst = allEntitiesETRecordsMap.get(objId);
							if(ETLst != null && ETLst.size() > 0)
							for(Execution_Tracker__c objET : ETLst)
							{
								if(!finalSelectedEntityToETList.isEmpty() && finalSelectedEntityToETList.containsKey(SelectedEntityId))
								{
									finalSelectedEntityToETList.get(SelectedEntityId).add(objEt);
									
								}
								else
								{
									finalSelectedEntityToETList.put(SelectedEntityId,new List<Execution_Tracker__c>{objEt});
								}
							}
							system.debug('############## finalSelectedEntityToETList::'+finalSelectedEntityToETList);
							//system.debug('############## ETlList::'+ETLst);
						}
					}
				}
			}
		}
		Execution_Tracker__c obj;
		Boolean isETClosed = true;
		Boolean isUniqueExecution = true;
		Set<Id> setParentIds = new Set<Id>();
		Map<Id, Date> mapParentAccToCloseDate = new Map<Id, Date>();//Parent Id vs first Close Date of ET to update on Account
		for(Execution_Tracker__c objET : Trigger.new)
		{
			isUniqueExecution = true;
			if(ETOldMap.ContainsKey(objET.Id))
			{
				if(ETOldMap.get(objET.Id).Completion_Date__c != null)
					objET.addError(Label.CantChangeCompletionDateOneItIsFilled);
				//FS0402 :  Uique Executions to be auto checked when Completion date is entered.
				if(objET.Completion_Date__c != null)
				{
					if(finalSelectedEntityToETList!= null && finalSelectedEntityToETList.size() > 0 && finalSelectedEntityToETList.containsKey(objET.Entity_Name__c))
					{
						List<Execution_Tracker__c> familyMembersETList;
						if(finalSelectedEntityToETList.get(objET.Entity_Name__c) != null)
						{
							familyMembersETList = finalSelectedEntityToETList.get(objET.Entity_Name__c);
							if(familyMembersETList != null && familyMembersETList.size() > 0)
							{
								
								for(Execution_Tracker__c ETRecord : familyMembersETList)
								{
									if(ETRecord.Opportunity_Name__c.equalsIgnoreCase(objET.Opportunity_Name__c) && ETRecord.Completion_Date__c != null)
									{
										isUniqueExecution = false;
										break;
									}
								}
								if(isUniqueExecution)
									objET.Unique_Execution__c = true;
								/** Eternus Solutions       	**/
								/** Author  : Mahesh Hirugade	**/
								/** Case No : 00001594			**/
								/** Date    : 25/4/2012 		**/
								/** Purpose : To update first execution tracker generated date of Entity page. If First Ex. Tracher Gen. date is not null then it 
											  shuold pick the value from first execution tracker's Completed date if it is not empty
								/****************************************************/
								for(Execution_Tracker__c ETRecord : familyMembersETList)
								{
									if(ETRecord.Completion_Date__c != null)
									{
										isETClosed = false;
										break;
									}
								}
								if(isETClosed == true)
								{
									for(Id objParentId : FamilyMembersMap.keySet())
									{
										mapParentAccToCloseDate.put(objParentId, objET.Completion_Date__c);
									}
								}
							}
						} 
					}
				}	
			}
		}
		/*
			Owner 	: mahesh Hirugade
			Case no : 00001594
			Comment : Collects parents to update for First Execution Completion Date
		*/
		for(Id ocjId : mapParentAccToCloseDate.keySet())
		{
			setParentIds.add(ocjId);
		}
		
		List<Account> lstAccountstoUpdate = new List<Account>(); 
		for(Account objAcc : [select Id, First_Execution_Completion_Date__c from Account where Id IN : setParentIds])
		{
			if(mapParentAccToCloseDate.containsKey(objAcc.Id))
			{
				if(objAcc.First_Execution_Completion_Date__c == null)
					lstAccountstoUpdate.add(new Account(Id = objAcc.Id, First_Execution_Completion_Date__c = mapParentAccToCloseDate.get(objAcc.Id)));
			}
		}
		List<Database.saveResult> lstResult = Database.update(lstAccountstoUpdate);
		//Mahesh
	}
}