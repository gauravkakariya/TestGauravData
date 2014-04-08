Id rtId = [Select Id from RecordType where sobjectType ='Account' and Name='Client'].Id;
List<Account> lstAccount = [Select id from Account where Entity_Status__c = 'Active' and RecordTypeId=:rtId and Id IN('0012000000qODPa')
];
List<Account> lstEntity = [SELECT Id,Name FROM Account WHERE Id IN: lstAccount OR Parent_Entity__c IN: lstAccount];

System.debug('---------------------lstEntity----'+lstEntity);
Map<Id, Execution_Tracker__c> mapNewIdToET = new Map<Id, Execution_Tracker__c>([Select Approve_Action_Plan__c,Entity_Name__c,ParentExecutionTracker__c From Execution_Tracker__c where Entity_Name__c IN:lstEntity and Approve_Action_Plan__r.Investment_Asset__c = null]);


List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
Set<Id> setAPId = new Set<Id>();
Map<Id, ARPP_Detail__c> mapAPIdToARPPDetail = new Map<Id, ARPP_Detail__c>();
List<ARPP_Detail__c> lstUpdateARPPDetail = new List<ARPP_Detail__c>();
Set<Id> setDuplicate = new Set<Id>();
Set<Id> setentityDuplicate = new Set<Id>();
//Collect Approve Action plan Id and Execution Tracker record
for(Execution_Tracker__c objET : mapNewIdToET.values())
{
	if(objET.ParentExecutionTracker__c == null)
	{
		lstET.add(objET);
		if(!setAPId.contains(objET.Approve_Action_Plan__c))
			setAPId.add(objET.Approve_Action_Plan__c);
		else
		{
			System.debug('---------------------Entity_Name__c--------------'+objET.Entity_Name__c);
			System.debug('---------------------Entity_Name__c--------------'+objET.Approve_Action_Plan__c);
			setentityDuplicate.add(objET.Entity_Name__c);
			setDuplicate.add(objET.Approve_Action_Plan__c);
		}
	}
}
System.debug('--------------------setDuplicate----------------'+setDuplicate.size());
System.debug('--------------------setDuplicate----------------'+setDuplicate);
System.debug('--------------------setentityDuplicate----------------'+setentityDuplicate);

List<ARPP_Detail__c> lstARPPDetail = [Select   
										Execution_Tracker_Actual_Product__c, Actual_Commission__c,
										Actual_Commission__r.Upfront_Commission__c,
										Actual_Commission__r.Trail_Commission__c,
										Product__r.Product_Name__c, Product__c, Name, Id, 
										Execution_Tracker_upfront_Comm_Amount__c, 
										Entity__c, Entity__r.Name, Approve_Action_Plan__c, Approve_Action_Plan__r.Item_Type__c, Action_Plan_Upfront_Comm_Amount__c, 
										Action_Plan_Trial_Comm_Amount__c, Action_Plan_Amount__c, Type__c,
										Approve_Action_Plan__r.Installments__c
										From ARPP_Detail__c Where Approve_Action_Plan__c IN: setAPId];	
										
//Create Map Approve Action Plan to ARPP Detail											
for(ARPP_Detail__c objAD : lstARPPDetail )
{
	mapAPIdToARPPDetail.put(objAD.Approve_Action_Plan__c , objAD);
} 
AggregateResult[] aggr = [ Select sum(Executed_Amount__c), Approve_Action_Plan__c
                           FROM Execution_Tracker__c 
                           Where Application_Status__c ='Closed' and Approve_Action_Plan__r.Investment_Asset__c = null
                           Group By Approve_Action_Plan__c ];

Map<string, Double> mapAPIdToEA = new Map<string, Double>();       
for (AggregateResult ar : aggr)  {
 mapAPIdToEA.put(string.valueOf(ar.get('Approve_Action_Plan__c')),Double.valueOf(ar.get('expr0'))); 
    System.debug('Approve_Action_Plan__c' + ar.get('Approve_Action_Plan__c'));
    System.debug('Average amount' + ar.get('expr0'));
}

for(Execution_Tracker__c objET : lstET)
{

	//Calcualte Execution Tracker trail Commission
	
	ARPP_Detail__c objARPPDetail = mapAPIdToARPPDetail.get(objET.Approve_Action_Plan__c);
	System.debug('-------------objARPPDetail-----------------------'+objARPPDetail);
	System.debug('-------------mapAPIdToEA.containsKey(objET.Approve_Action_Plan__c)-----------------------'+mapAPIdToEA.containsKey(objET.Approve_Action_Plan__c));
	
	if(objARPPDetail != null)
	{
		objARPPDetail.Execution_Tracker_Amount__c = mapAPIdToEA.containsKey(objET.Approve_Action_Plan__c)? mapAPIdToEA.get(objET.Approve_Action_Plan__c) : 0;
		if(objARPPDetail.Type__c == 'SIP')
		{
			objARPPDetail.Execution_Tracker_upfront_Comm_Amount__c = objARPPDetail.Execution_Tracker_Actual_Product__c != null && objARPPDetail.Actual_Commission__c!= null? (objARPPDetail.Actual_Commission__r.Upfront_Commission__c * 12 * objARPPDetail.Execution_Tracker_Amount__c)/100 : 0;
			Double trailComm = 0;
			Double amount = objARPPDetail.Execution_Tracker_Amount__c;
			Integer installment = objARPPDetail.Approve_Action_Plan__r.Installments__c <= 12  ? Integer.valueOf(objARPPDetail.Approve_Action_Plan__r.Installments__c) : 12;			
			if(objARPPDetail.Execution_Tracker_Actual_Product__c != null && objARPPDetail.Actual_Commission__c != null)
			{
				for(Integer i = 0; i < installment ; i++)
				{
					trailComm += (amount * objARPPDetail.Actual_Commission__r.Trail_Commission__c)/100;
					amount += objARPPDetail.Execution_Tracker_Amount__c;
				}
			}
			objARPPDetail.Execution_Tracker_Trial_Comm_Amount__c = trailComm;
		}
		else if(objARPPDetail.Type__c == 'Lumpsum')
		{
			
			objARPPDetail.Execution_Tracker_upfront_Comm_Amount__c = objARPPDetail.Execution_Tracker_Actual_Product__c != null  && objARPPDetail.Actual_Commission__c != null ? (objARPPDetail.Actual_Commission__r.Upfront_Commission__c  * objARPPDetail.Execution_Tracker_Amount__c)/100 : 0;
			objARPPDetail.Execution_Tracker_Trial_Comm_Amount__c = objARPPDetail.Execution_Tracker_Actual_Product__c != null  && objARPPDetail.Actual_Commission__c != null ? (objARPPDetail.Actual_Commission__r.Trail_Commission__c * objARPPDetail.Execution_Tracker_Amount__c)/100 : 0;
		}
		else if(objARPPDetail.Type__c == 'Life Insurance' || objARPPDetail.Type__c == 'General Insurance')
		{
			objARPPDetail.Execution_Tracker_upfront_Comm_Amount__c = objARPPDetail.Execution_Tracker_Actual_Product__c != null  && objARPPDetail.Actual_Commission__c != null ? (objARPPDetail.Actual_Commission__r.Upfront_Commission__c * objARPPDetail.Execution_Tracker_Amount__c)/100 : 0;
			objARPPDetail.Execution_Tracker_Trial_Comm_Amount__c = 0;
		}
		if(objET.ParentExecutionTracker__c == null)
			objARPPDetail.Execution_Tracker__c = objET.Id;			
		lstUpdateARPPDetail.add(objARPPDetail);
	}
}

//Update ARPP Detail Record
if(!lstUpdateARPPDetail.isEmpty())
{
	update lstUpdateARPPDetail;
}
