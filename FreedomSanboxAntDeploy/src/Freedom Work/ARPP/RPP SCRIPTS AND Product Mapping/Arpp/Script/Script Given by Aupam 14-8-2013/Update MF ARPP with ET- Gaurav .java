
//Update LI type ARPP with ET 
List<ARPP_Detail__c> lstArppDetail = [Select Name, Id, Entity__c, Type__c, Product__c, Commission__c, Approve_Action_Plan__c, Action_Plan_Amount__c, Action_Plan_Upfront_Comm_Amount__c, Action_Plan_Trial_Comm_Amount__c,  Action_Amount_Revenue__c, Remark__c, Execution_Tracker_Actual_Product__c,  Actual_Commission__c, Execution_Tracker__c, Execution_Tracker_Amount__c, 
												Execution_Tracker_upfront_Comm_Amount__c, Execution_Tracker_Trial_Comm_Amount__c, Execution_Tracker_Total_Revenue__c, 
												Actual_Product_Name__c, ET_Remark__c  
									  From ARPP_Detail__c 
									  Where (Type__c='SIP' Or Type__c='Lumpsum') and
											  Execution_Tracker_Actual_Product__c = null) and 
											  Execution_Tracker__c != null and 
											  Execution_Tracker__r.Approve_Action_Plan__r.CreatedDate > 2013-06-23T11:34:41.00Z and
											  ET_Remark__c = 'Actual Product Commision not found'];

Map<Id,ARPP_Detail__c> mapApIdToARPP = new Map<Id, ARPP_Detail__c>();

for(ARPP_Detail__c objARPP : lstArppDetail)
{
	mapApIdToARPP.put(objARPP.Approve_Action_Plan__c, objARPP);
}

Map<Id, ARPP_Detail__c> mapETIdToARPP = new Map<Id, ARPP_Detail__c>();

for(Execution_Tracker__c objET : [Select Id, Approve_Action_Plan__c from Execution_Tracker__c where ParentExecutionTracker__c = NULL and Approve_Action_Plan__c IN: mapApIdToARPP.keySet()])
{
	mapETIdToARPP.put(objET.Id, mapApIdToARPP.get(objET.Approve_Action_Plan__c));	
}

AggregateResult[] aggr = [ Select sum(Executed_Amount__c), Approve_Action_Plan__c
                           FROM Execution_Tracker__c 
                           Where Application_Status__c ='Closed' and Approve_Action_Plan__r.Investment_Asset__c = null and Approve_Action_Plan__c IN: mapApIdToARPP.keySet() 
                           Group By Approve_Action_Plan__c ];

Map<string, Double> mapAPIdToEA = new Map<string, Double>();       
for (AggregateResult ar : aggr)  {
 mapAPIdToEA.put(string.valueOf(ar.get('Approve_Action_Plan__c')),Double.valueOf(ar.get('expr0'))); 
    System.debug('Approve_Action_Plan__c' + ar.get('Approve_Action_Plan__c'));
    System.debug('Average amount' + ar.get('expr0'));
}




map<String, List<Execution_Tracker__c>> mapLIExecutedProductNameTolstET = new map<String, List<Execution_Tracker__c>>();
Map<Id, Execution_Tracker__c> mapIdToET = new Map<Id, Execution_Tracker__c>([Select Id, Type__c, Approve_Action_Plan__r.Installments__c, Approve_Action_Plan__r.Item_Type__c, Execution_Tracker_Product__c,  Executed_Product_Name__c ,Approve_Action_Plan__r.Tenure_of_Insurance__c from Execution_Tracker__c where Id IN : mapETIdToARPP.keySet()]);
for(Execution_Tracker__c objET: mapIdToET.values())
{
	if(!mapLIExecutedProductNameTolstET.containsKey(objET.Executed_Product_Name__c))
		mapLIExecutedProductNameTolstET.put(objET.Executed_Product_Name__c , new List<Execution_Tracker__c>{objET});
	else
		mapLIExecutedProductNameTolstET.get(objET.Executed_Product_Name__c).add(objET);
}

//MAP Action Plan Proudct with Actual Product Name
Map<String, String> mapActionPlanProductNameToProductMasterName = new Map<String, String>();
for(Action_Plan_Product__c objActionPlanProduct : [select Action_Plan_Product_Name__c, Product_Name__c from Action_Plan_Product__c where Action_Plan_Product_Name__c IN: mapLIExecutedProductNameTolstET.keySet()])
	mapActionPlanProductNameToProductMasterName.put(objActionPlanProduct.Action_Plan_Product_Name__c, objActionPlanProduct.Product_Name__c);
	
//Fetch MF Product
List<Product_Master__c> lstPM = [Select Product_Name__c, ProductType__c, Investment_Type__c, Policy_Type__c,
										(Select Upfront_Commission__c, Trail_Commission__c, Min_Year_Value__c, Max_Year_Value__c from Commissions__r where Active__c = true )
										From Product_Master__c where  ProductType__c = 'Mutual Fund'];
Map<String, Product_Master__c> mapProductNameToPM = new Map<String, Product_Master__c>();
for(Product_Master__c objPM : lstPM)
	mapProductNameToPM.put(objPM.Product_Name__c, objPM);
	
List<Execution_Tracker__c> lstETUpdate = new List<Execution_Tracker__c>();
List<ARPP_Detail__c> lstARPPUpdate = new List<ARPP_Detail__c>();
for(String strExecutedProudctName : mapLIExecutedProductNameTolstET.keySet())
{
	Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(strExecutedProudctName));
	
	if(objPM != null)
	{
		Commission__c objComm = objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null;
		for(Execution_Tracker__c objET : mapLIExecutedProductNameTolstET.get(strExecutedProudctName))
		{
			System.debug('--------------objET.Approve_Action_Plan__c---------------------'+ mapETIdToARPP.get(objET.Id));
			ARPP_Detail__c objARPP = mapETIdToARPP.get(objET.Id);
			objARPP.Execution_Tracker_Amount__c = mapAPIdToEA.containsKey(objET.Approve_Action_Plan__c)? mapAPIdToEA.get(objET.Approve_Action_Plan__c) : 0;
			
			if(objET.Approve_Action_Plan__r.Item_Type__c == 'SIP')
			{
				objARPP.Execution_Tracker_upfront_Comm_Amount__c = objComm != null ? (objARPP.Execution_Tracker_Amount__c * objComm.Upfront_Commission__c)/100.0 : 0;
				Double trailComm = 0;
				Double amount = objARPP.Execution_Tracker_Amount__c != null ? objARPP.Execution_Tracker_Amount__c : 0;
				Integer installment = objET.Approve_Action_Plan__r.Installments__c <= 12  ? Integer.valueOf(objET.Approve_Action_Plan__r.Installments__c) : 12;
				if(objComm != null )
					for(Integer i = 0; i < installment ; i++)
					{
						trailComm += (amount * objComm.Trail_Commission__c)/100;
						amount += objARPP.Execution_Tracker_Amount__c;
					}
				objARPP.Execution_Tracker_Trial_Comm_Amount__c = trailComm;
			}
			if(	objET.Approve_Action_Plan__r.Item_Type__c == 'Lumpsum')
			{
				objARPP.Execution_Tracker_upfront_Comm_Amount__c = objComm != null ? (objARPP.Execution_Tracker_Amount__c * objComm.Upfront_Commission__c * 12)/100.0 : 0;
				objARPP.Execution_Tracker_Trial_Comm_Amount__c = objComm != null ? (objARPP.Execution_Tracker_Amount__c * objComm.Trail_Commission__c * 12)/100.0 : 0;
			}
			
			objARPP.Execution_Tracker_Actual_Product__c = objPM.Id;
			objARPP.Actual_Commission__c = objComm != null ?  objComm.Id : null;
			objARPP.ET_Remark__c = '';
			lstARPPUpdate.add(objARPP);
			
			objET.Execution_Tracker_Product__c = objPM.Id;
			lstETUpdate.add(objET);
		}
	}
}

if(lstETUpdate.size() > 0)
{
	update lstETUpdate;
	update lstARPPUpdate;
}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
