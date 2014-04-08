
//Update Mf type ARPP with Action Plan 
List<ARPP_Detail__c> lstArppDetail = [Select Name, Id, Entity__c, Type__c, Product__c, Commission__c, Approve_Action_Plan__c, Action_Plan_Amount__c, Action_Plan_Upfront_Comm_Amount__c, Action_Plan_Trial_Comm_Amount__c,  Action_Amount_Revenue__c, Remark__c, Execution_Tracker_Actual_Product__c,  Actual_Commission__c, Execution_Tracker__c, Execution_Tracker_Amount__c, Execution_Tracker_upfront_Comm_Amount__c, Execution_Tracker_Trial_Comm_Amount__c, Execution_Tracker_Total_Revenue__c, Actual_Product_Name__c, ET_Remark__c  From ARPP_Detail__c where (Type__c='SIP' Or Type__c='Lumpsum') and CreatedById ='00520000001MO8D' and LastModifiedDate=TODAY];

Map<Id,ARPP_Detail__c> mapApIdToARPP = new Map<Id, ARPP_Detail__c>();

for(ARPP_Detail__c objARPP : lstArppDetail)
{
	mapApIdToARPP.put(objARPP.Approve_Action_Plan__c, objARPP);
}
Map<String, List<Approve_Action_Plan__c>> mapMFproductNameTolstAP = new Map<String, List<Approve_Action_Plan__c>>();

Map<Id, Approve_Action_Plan__c> mapIdToActionPlan = new Map<Id, Approve_Action_Plan__c>([Select Id, Item_Type__c,Installments__c,  Tenure_of_Insurance__c,Product_Name__c, Product__c, Sum_Assured_Rs__c from Approve_Action_Plan__c where Id IN : mapApIdToARPP.keySet()]);

for(Approve_Action_Plan__c objAP: mapIdToActionPlan.values())
{
	if(!mapMFproductNameTolstAP.containsKey(objAP.Product_Name__c))
		mapMFproductNameTolstAP.put(objAP.Product_Name__c , new List<Approve_Action_Plan__c>{objAP});
	else
		mapMFproductNameTolstAP.get(objAP.Product_Name__c).add(objAP);
}

//MAP Action Plan Proudct with Actual Product Name
Map<String, String> mapActionPlanProductNameToProductMasterName = new Map<String, String>();
for(Action_Plan_Product__c objActionPlanProduct : [select Action_Plan_Product_Name__c, Product_Name__c from Action_Plan_Product__c where Action_Plan_Product_Name__c IN: 				mapMFproductNameTolstAP.keySet() and  CreatedDate = TODAY ])
	mapActionPlanProductNameToProductMasterName.put(objActionPlanProduct.Action_Plan_Product_Name__c, objActionPlanProduct.Product_Name__c);
	
//Fetch Insurance Product
List<Product_Master__c> lstPM = [Select Product_Name__c, ProductType__c, Investment_Type__c, Policy_Type__c,
										(Select Upfront_Commission__c, Trail_Commission__c, Min_Year_Value__c, Max_Year_Value__c from Commissions__r where Active__c = true )
										From Product_Master__c where  ProductType__c = 'Mutual Fund' and CreatedDate = YESTERDAY and LastModifiedDate = YESTERDAY];
										
Map<String, Product_Master__c> mapProductNameToPM = new Map<String, Product_Master__c>();
for(Product_Master__c objPM : lstPM)
	mapProductNameToPM.put(objPM.Product_Name__c, objPM);
	
List<Approve_Action_Plan__c> lstAAPUpdate = new List<Approve_Action_Plan__c>();
List<ARPP_Detail__c> lstARPPUpdate = new List<ARPP_Detail__c>();
for(String strProductName : mapMFproductNameTolstAP.keySet())
{
	Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(strProductName));
	
	if(objPM != null)
	{
		Commission__c objComm = objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null;
		for(Approve_Action_Plan__c objAAP : mapMFproductNameTolstAP.get(strProductName))
		{
			objAAP.product__c = objPM.Id;
			lstAAPUpdate.add(objAAP);
			ARPP_Detail__c objARPP = mapApIdToARPP.get(objAAP.Id);
			if(objAAP.Item_type__c == 'SIP')
			{
				objARPP.Action_Plan_Upfront_Comm_Amount__c = objComm != null ? (objARPP.Action_Plan_Amount__c * objComm.Upfront_Commission__c * 12)/100.0 : 0;
				Double trailComm = 0;
				Double amount = objARPP.Action_Plan_Amount__c != null ? objARPP.Action_Plan_Amount__c : 0;
				Integer installment = objAAP.Installments__c <= 12  ? Integer.valueOf(objAAP.Installments__c) : 12;
				if(objComm != null )
					for(Integer i = 0; i < installment ; i++)
					{
						trailComm += (amount * objComm.Trail_Commission__c)/100;
						amount += objARPP.Action_Plan_Amount__c;
					}
				objARPP.Action_Plan_Trial_Comm_Amount__c = trailComm;
			}
			if(	objAAP.Item_type__c == 'Lumpsum')
			{
				objARPP.Action_Plan_Upfront_Comm_Amount__c = objComm != null ? (objARPP.Action_Plan_Amount__c * objComm.Upfront_Commission__c )/100.0 : 0;
				objARPP.Action_Plan_Trial_Comm_Amount__c = objComm != null ? (objARPP.Action_Plan_Amount__c * objComm.Trail_Commission__c)/100.0 : 0;
			}
			objARPP.product__c = objPM.Id;
			objARPP.Commission__c = objComm != null ?  objComm.Id : null;
			objARPP.Remark__c = '';
			lstARPPUpdate.add(objARPP);
		}
	}
}

if(lstAAPUpdate.size() > 0)
{
	//update lstAAPUpdate;
	//update lstARPPUpdate;
}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
