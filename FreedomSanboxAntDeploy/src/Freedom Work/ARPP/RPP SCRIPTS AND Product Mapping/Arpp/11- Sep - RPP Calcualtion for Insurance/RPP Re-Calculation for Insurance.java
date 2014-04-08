
List<ARPP_Detail__c> lstARPPDetail = [Select   Execution_Tracker__c,Execution_Tracker__r.Premium__c,
										Execution_Tracker_Actual_Product__c, Actual_Commission__c,
										Actual_Commission__r.Upfront_Commission__c,
										Actual_Commission__r.Trail_Commission__c,
										Product__r.Product_Name__c, Product__c, Name, Id, 
										Execution_Tracker_upfront_Comm_Amount__c, 
										Entity__c, Entity__r.Name, Approve_Action_Plan__c, Approve_Action_Plan__r.Item_Type__c, Action_Plan_Upfront_Comm_Amount__c, 
										Action_Plan_Trial_Comm_Amount__c, Action_Plan_Amount__c, Type__c,
										Approve_Action_Plan__r.Installments__c
										From ARPP_Detail__c Where Approve_Action_Plan__c != null
										and Execution_Tracker__c != null and Actual_Commission__c != null
										and Type__c IN ('Life Insurance', 'General Insurance')
										and Entity__c IN ('00120000012CbhU',
														'0012000000s2Uym',
														'00120000012AHtu',
														'0012000000wCla0',
														'0012000000js6uc',
														'00120000012CrsL',
														'001w00000138gYA',
														'0012000000zFWKd',
														'001w00000139M2B',
														'0012000000wmSUu',
														'0012000000jbf5V',
														'0012000000na1Ej')];	
																									
Set<Id> setAPId = new Set<Id>();
List<ARPP_Detail__c> lstUpdateARPPDetail = new List<ARPP_Detail__c>();

//Collect Approve Action plan Id and Execution Tracker record
for(ARPP_Detail__c objRPP : lstARPPDetail)
{
	setAPId.add(objRPP.Approve_Action_Plan__c);
}

AggregateResult[] aggr = [ Select sum(Premium__c), Approve_Action_Plan__c
                           FROM Execution_Tracker__c 
                           Where Application_Status__c ='Closed' and Approve_Action_Plan__c IN: setAPId
                           Group By Approve_Action_Plan__c ];

Map<string, Double> mapAPIdToEA = new Map<string, Double>();       
for (AggregateResult ar : aggr)  
{
	mapAPIdToEA.put(string.valueOf(ar.get('Approve_Action_Plan__c')),Double.valueOf(ar.get('expr0'))); 
    System.debug('Average amount' + ar.get('expr0'));
}

for(ARPP_Detail__c objARPPDetail : lstARPPDetail)
{
	objARPPDetail.Execution_Tracker_Amount__c = mapAPIdToEA.containsKey(objARPPDetail.Approve_Action_Plan__c)? mapAPIdToEA.get(objARPPDetail.Approve_Action_Plan__c) : 0;
	if(objARPPDetail.Type__c == 'Life Insurance' || objARPPDetail.Type__c == 'General Insurance')
	{
		objARPPDetail.Execution_Tracker_upfront_Comm_Amount__c = objARPPDetail.Execution_Tracker_Actual_Product__c != null  && objARPPDetail.Actual_Commission__c != null ? (objARPPDetail.Actual_Commission__r.Upfront_Commission__c * objARPPDetail.Execution_Tracker_Amount__c)/100 : 0;
		objARPPDetail.Execution_Tracker_Trial_Comm_Amount__c = 0;
	}
	lstUpdateARPPDetail.add(objARPPDetail);
}

//Update ARPP Detail Record
if(!lstUpdateARPPDetail.isEmpty())
{
	update lstUpdateARPPDetail;
}
