/************** Tested  update ARPP with ET product detail******************/
Id rtId = [Select Id from RecordType where sobjectType ='Account' and Name='Client'].Id;
List<Account> lstAccount = [Select id from Account where Entity_Status__c = 'Active' and RecordTypeId=:rtId and CALENDAR_YEAR(createddate) = 2013 and Id IN ('0012000000yK1z0AAC')];

List<Account> lstEntity = [SELECT Id,Name FROM Account WHERE Id IN: lstAccount OR Parent_Entity__c IN: lstAccount];


Map<Id, Approve_Action_Plan__c> mapNewIdToActionPlan = new Map<Id, Approve_Action_Plan__c>([Select Id From Approve_Action_Plan__c where Account__c IN: lstEntity and Investment_Asset__c = null]);


Map<Id, Product_Master__c> mapProductNameToPM = new Map<Id, Product_Master__c>([Select (Select Upfront_Commission__c, Trail_Commission__c, Min_Year_Value__c, Max_Year_Value__c from Commissions__r where 
												Active__c = true limit 1), 
												Product_Name__c, ProductType__c, Investment_Type__c 
												From Product_Master__c  where Is_Active__c = true]);


map<Id, ARPP_Detail__c> mapActionPlanIdToARPP = new map<Id, ARPP_Detail__c>(); 
for(ARPP_Detail__c objAD : [Select  Actual_Commission__c, Execution_Tracker_Actual_Product__c,
										Approve_Action_Plan__r.Installments__c
										From ARPP_Detail__c Where Approve_Action_Plan__c IN: mapNewIdToActionPlan.keySet()])
{
	mapActionPlanIdToARPP.put(objAD.Approve_Action_Plan__c, objAD);
}	

map<Id, Execution_Tracker__c> mapActionPlanIdToET = new map<Id, Execution_Tracker__c>();	
for(Execution_Tracker__c objET : [Select Type__c,Execution_Tracker_Product__c , Approve_Action_Plan__c, Approve_Action_Plan__r.Tenure_of_Insurance__c from Execution_Tracker__c Where Approve_Action_Plan__c IN: mapNewIdToActionPlan.keySet() and ParentExecutionTracker__c = NULL])
{
	mapActionPlanIdToET.put(objET.Approve_Action_Plan__c, objET);
}	
List<ARPP_Detail__c> lstARPPDetail = new List<ARPP_Detail__c>();
for(Id apId : mapNewIdToActionPlan.keySet())
{		
	Execution_Tracker__c objET = mapActionPlanIdToET.get(apId);	
	if(objET != null)
	{
		//ARPP record on SIP product 
		if(objET.Type__c == 'SIP' || objET.Type__c == 'Lumpsum' ||objET.Type__c == 'General Insurance')
		{
			if(objET.Execution_Tracker_Product__c != null)
			{
				
				Product_Master__c objPM = mapProductNameToPM.get(objET.Execution_Tracker_Product__c);
				Commission__c objComm = objPM != null && objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null ;
				ARPP_Detail__c objARPPDetail = mapActionPlanIdToARPP.get(apId);
				if(objET.Type__c == 'General Insurance')
				System.debug('---------------objPM-------------'+objPM);
				objARPPDetail.Execution_Tracker_Actual_Product__c = objPM != null ? objPM.Id : null;
				objARPPDetail.Actual_Commission__c = objComm != null? objComm.Id : null;
				objARPPDetail.Execution_Tracker__c = objET.Id;
				lstARPPDetail.add(objARPPDetail);
			}
		}
		else if(objET.Type__c == 'Life Insurance')
		{	
				Product_Master__c objPM = mapProductNameToPM.get(objET.Execution_Tracker_Product__c);
				List<Commission__c> lstCommission = objPM != null ? objPM.Commissions__r : null;
				Commission__c objComm;
				if(lstCommission != null)
				{
					for(Commission__c comm : lstCommission)
					{
						if(comm.Min_Year_Value__c <= objET.Approve_Action_Plan__r.Tenure_of_Insurance__c && objET.Approve_Action_Plan__r.Tenure_of_Insurance__c < comm.Max_Year_Value__c)
						{
							objComm = comm;
							break;
						}
					}
				}
				ARPP_Detail__c objARPPDetail = mapActionPlanIdToARPP.get(apId);
				objARPPDetail.Execution_Tracker_Actual_Product__c = objPM != null ? objPM.Id : null;
				objARPPDetail.Actual_Commission__c = objComm != null? objComm.Id : null;
				objARPPDetail.Execution_Tracker__c = objET.Id;				
				lstARPPDetail.add(objARPPDetail);
			
		}
	}
}
//Insert Arpp Detail Record
if(!lstARPPDetail.isEmpty())
	update lstARPPDetail;


/**************End Script to Create ARPP Detail records******************/