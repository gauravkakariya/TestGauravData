
//Update LI type ARPP with Action Plan 
List<ARPP_Detail__c> lstArppDetail = [Select Name, Id, Entity__c, Type__c, Product__c, Commission__c, Approve_Action_Plan__c, Action_Plan_Amount__c, Action_Plan_Upfront_Comm_Amount__c, Action_Plan_Trial_Comm_Amount__c,  Action_Amount_Revenue__c, Remark__c, Execution_Tracker_Actual_Product__c,  Actual_Commission__c, Execution_Tracker__c, Execution_Tracker_Amount__c, Execution_Tracker_upfront_Comm_Amount__c, Execution_Tracker_Trial_Comm_Amount__c, Execution_Tracker_Total_Revenue__c, Actual_Product_Name__c, ET_Remark__c  From ARPP_Detail__c where Type__c='Life Insurance' 
and CreatedById ='00520000001MO8D' and Id !='a3L200000000BeXEAU'];

Map<Id,ARPP_Detail__c> mapApIdToARPP = new Map<Id, ARPP_Detail__c>();

for(ARPP_Detail__c objARPP : lstArppDetail)
{
	mapApIdToARPP.put(objARPP.Approve_Action_Plan__c, objARPP);
}
Map<String, List<Approve_Action_Plan__c>> mapLIpolicyNameTolstAP = new Map<String, List<Approve_Action_Plan__c>>();
Map<Id, Approve_Action_Plan__c> mapIdToActionPlan = new Map<Id, Approve_Action_Plan__c>([Select Id, Tenure_of_Insurance__c,Policy_Name__c, Product__c, Sum_Assured_Rs__c from Approve_Action_Plan__c where Id IN : mapApIdToARPP.keySet()]);
for(Approve_Action_Plan__c objAP: mapIdToActionPlan.values())
{
	if(!mapLIpolicyNameTolstAP.containsKey(objAP.policy_Name__c))
		mapLIpolicyNameTolstAP.put(objAP.policy_Name__c , new List<Approve_Action_Plan__c>{objAP});
	else
		mapLIpolicyNameTolstAP.get(objAP.policy_Name__c).add(objAP);
}

//MAP Action Plan Proudct with Actual Product Name
Map<String, String> mapActionPlanProductNameToProductMasterName = new Map<String, String>();
for(Action_Plan_Product__c objActionPlanProduct : [select Action_Plan_Product_Name__c, Product_Name__c from Action_Plan_Product__c where Action_Plan_Product_Name__c IN: 				mapLIpolicyNameTolstAP.keySet() and  CreatedDate = TODAY ])
	mapActionPlanProductNameToProductMasterName.put(objActionPlanProduct.Action_Plan_Product_Name__c, objActionPlanProduct.Product_Name__c);
	
//Fetch Insurance Product
List<Product_Master__c> lstPM = [Select Product_Name__c, ProductType__c, Investment_Type__c, Policy_Type__c,
										(Select Upfront_Commission__c, Trail_Commission__c, Min_Year_Value__c, Max_Year_Value__c from Commissions__r where Active__c = true )
										From Product_Master__c where  ProductType__c = 'Life Insurance'];
Map<String, Product_Master__c> mapProductNameToPM = new Map<String, Product_Master__c>();
for(Product_Master__c objPM : lstPM)
	mapProductNameToPM.put(objPM.Product_Name__c, objPM);
	
List<Approve_Action_Plan__c> lstAAPUpdate = new List<Approve_Action_Plan__c>();
List<ARPP_Detail__c> lstARPPUpdate = new List<ARPP_Detail__c>();
for(String strPolicyName : mapLIpolicyNameTolstAP.keySet())
{
	Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(strPolicyName));
	
	if(objPM != null)
	{
		for(Approve_Action_Plan__c objAAP : mapLIpolicyNameTolstAP.get(strPolicyName))
		{
			List<Commission__c> lstCommission = objPM != null ? objPM.Commissions__r : null;
			Commission__c objComm;
			if(lstCommission != null)
			{
				for(Commission__c comm : lstCommission)
				{
					if(comm.Min_Year_Value__c <= objAAP.Tenure_of_Insurance__c && objAAP.Tenure_of_Insurance__c < comm.Max_Year_Value__c)
					{
						objComm = comm;
						break;
					}
				}
			}
			objAAP.product__c = objPM.Id;
			lstAAPUpdate.add(objAAP);
			ARPP_Detail__c objARPP = mapApIdToARPP.get(objAAP.Id);
			objARPP.Action_Plan_Upfront_Comm_Amount__c = objComm != null ? (objARPP.Action_Plan_Amount__c * objComm.Upfront_Commission__c)/100.0 : 0;
			objARPP.Action_Plan_Trial_Comm_Amount__c = 0;
			objARPP.product__c = objPM.Id;
			objARPP.Commission__c = objComm != null ?  objComm.Id : null;
			objARPP.Remark__c = '';
			lstARPPUpdate.add(objARPP);
		}
	}
}

if(lstAAPUpdate.size() > 0)
{
	update lstAAPUpdate;
	update lstARPPUpdate;
}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
