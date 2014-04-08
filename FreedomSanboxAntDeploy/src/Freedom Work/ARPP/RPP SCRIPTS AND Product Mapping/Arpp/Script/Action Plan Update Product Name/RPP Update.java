
//Fetch the All Acount of Client RecordType
Id rtId = [Select Id from RecordType where sobjectType ='Account' and Name='Client'].Id;
List<Account> lstAccount = [Select id,Expected_Upfront_Comm__c, Expected_Trail_Comm__c ,
							Actual_Upfront_Comm__c , Actual_Trail_Comm__c
							from Account where Entity_Status__c = 'Active' and RecordTypeId=:rtId ];

Map<Id, Account> mapEntityIdToEntity = new MapMap<Id, Account>();
for(Account objAccount: lstAccount)
{
	mapEntityIdToEntity.put(objAccount.Id, objAccount);
}

//Get All RPP Record from All Entity
List<ARPP_Detail__c> lstArppDetail = [Select Name, Id, Entity__c, Type__c, Product__c, Commission__c, Approve_Action_Plan__c, A
										ction_Plan_Amount__c, Action_Plan_Upfront_Comm_Amount__c, 
										Action_Plan_Trial_Comm_Amount__c,  Action_Amount_Revenue__c, Remark__c, Execution_Tracker_Actual_Product__c,  
										Actual_Commission__c, Execution_Tracker__c, Execution_Tracker_Amount__c, Execution_Tracker_upfront_Comm_Amount__c, 
										Execution_Tracker_Trial_Comm_Amount__c, Execution_Tracker_Total_Revenue__c, Actual_Product_Name__c, ET_Remark__c  
										From ARPP_Detail__c where Entity__c IN :mapEntityIdToEntity.keySet()];

//Create Map of EntityId to List Of Rpp Details
Map<Id, List<ARPP_Detail__c>> mapEntityIdTolstARPPDetails = new Map<Id, List<ARPP_Detail__c>>();
for(ARPP_Detail__c objArpp : lstArppDetail)
{
	if(!mapEntityIdTolstARPPDetails.containsKey(objArpp.Entity__c)
		mapEntityIdTolstARPPDetails.put(objArpp.Entity__c, new List<ARPP_Detail__c> {objArpp});
	else
		mapEntityIdTolstARPPDetails.get(objArpp.Entity__c).add(objArpp);			
}

//Calcaulate All Commission related with Acion Plan And Execution Tracker 
//and Add it into Account Field 

List<Account> lstUpdateAccount = new List<Account>();
for(Id accId : mapEntityIdToEntity.keySet())
{	
	Account objAccount = mapEntityIdToEntity.get(accId)
	for(ARPP_Detail__c objArpp : mapEntityIdTolstARPPDetails.get(objAccount))
	{
		objAccount.Expected_Upfront_Comm__c += objArpp.Action_Plan_Upfront_Comm_Amount__c;
		objAccount.Expected_Trail_Comm__c += objArpp.Action_Plan_Trial_Comm_Amount__c;
		objAccount.Actual_Upfront_Comm__c += objArpp.Execution_Tracker_upfront_Comm_Amount__c;
		objAccount.Actual_Trail_Comm__c += objArpp.Execution_Tracker_Trial_Comm_Amount__c;
	}
	lstUpdateAccount.add(objAccount);
}

//Update Account 
if(!lstUpdateAccount.isEmpty())
//update lstUpdateAccount;
