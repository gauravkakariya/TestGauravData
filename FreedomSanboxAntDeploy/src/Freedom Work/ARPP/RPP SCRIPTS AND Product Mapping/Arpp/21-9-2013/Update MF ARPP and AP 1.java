Integer mon = 1;
Integer yer = 2000;
//Update Mf type ARPP with Action Plan 
List<ARPP_Detail__c> lstArppDetail = [Select Name, Id, Entity__c, Type__c, Product__c, Commission__c, Approve_Action_Plan__c,  
											  Action_Plan_Amount__c, Action_Plan_Upfront_Comm_Amount__c,  	
											 Action_Plan_Trial_Comm_Amount__c,  Action_Amount_Revenue__c, Remark__c, Execution_Tracker_Actual_Product__c,  Actual_Commission__c, Execution_Tracker__c,Execution_Tracker_Amount__c, Execution_Tracker_upfront_Comm_Amount__c, Execution_Tracker_Trial_Comm_Amount__c, Execution_Tracker_Total_Revenue__c, Actual_Product_Name__c, ET_Remark__c  From ARPP_Detail__c 
									  where (Remark__c = 'Product Detail is not Found' or Product__c = null) and
									  Approve_Action_Plan__r.Investment_Asset__c = null and Entity__c = '0012000000qXNzM' and
									  Approve_Action_Plan__r.Item_Type__c != '']; 
									  


Map<Id,ARPP_Detail__c> mapApIdToARPP = new Map<Id, ARPP_Detail__c>();

for(ARPP_Detail__c objARPP : lstArppDetail)
{
	mapApIdToARPP.put(objARPP.Approve_Action_Plan__c, objARPP);
}
system.debug('********mapApIdToARPP*******************'+mapApIdToARPP);

Map<String, List<Approve_Action_Plan__c>> mapMFproductNameTolstAP = new Map<String, List<Approve_Action_Plan__c>>();
Map<String, List<Approve_Action_Plan__c>> mapLIpolicyNameTolstAP = new Map<String, List<Approve_Action_Plan__c>>();

Map<Id, Approve_Action_Plan__c> mapIdToActionPlan = new Map<Id, Approve_Action_Plan__c>([Select Id, Item_Type__c,																								 Installments__c,
																								Tenure_of_Insurance__c,Product_Name__c, Product__c, Sum_Assured_Rs__c ,
																								policy_Name__c
																						 from Approve_Action_Plan__c 
																						 where Id IN : mapApIdToARPP.keySet()]);

for(Approve_Action_Plan__c objAP: mapIdToActionPlan.values())
{
	if(objAP.Product_Name__c != null)
	{
		if(!mapMFproductNameTolstAP.containsKey(objAP.Product_Name__c.trim().toLowerCase()))
			mapMFproductNameTolstAP.put(objAP.Product_Name__c.trim().toLowerCase(), new List<Approve_Action_Plan__c>{objAP});
		else
			mapMFproductNameTolstAP.get(objAP.Product_Name__c.trim().toLowerCase()).add(objAP);
	}	
	if(objAP.policy_Name__c != null)	
	{
		if(!mapLIpolicyNameTolstAP.containsKey(objAP.policy_Name__c.trim().toLowerCase()))
			mapLIpolicyNameTolstAP.put(objAP.policy_Name__c.trim().toLowerCase(), new List<Approve_Action_Plan__c>{objAP});
		else
			mapLIpolicyNameTolstAP.get(objAP.policy_Name__c.trim().toLowerCase()).add(objAP);	
			
	}	
}

system.debug('********mapMFproductNameTolstAP*******************'+mapMFproductNameTolstAP);
system.debug('********mapLIpolicyNameTolstAP*******************'+mapLIpolicyNameTolstAP);




//MAP Action Plan Proudct with Actual Product Name
Map<String, String> mapActionPlanProductNameToProductMasterName = new Map<String, String>();
for(Action_Plan_Product__c objActionPlanProduct : [select Action_Plan_Product_Name__c, Product_Name__c 
												   from  Action_Plan_Product__c
												   where CreatedDate = TODAY ])
												   
mapActionPlanProductNameToProductMasterName.put(String.valueOf(objActionPlanProduct.Action_Plan_Product_Name__c).trim().toLowerCase(), objActionPlanProduct.Product_Name__c);
	
system.debug('********mapActionPlanProductNameToProductMasterName*******************'+mapActionPlanProductNameToProductMasterName.get('IDFC MM treasury A'));
	
//Product Master records for MF, LI, GI
Map<String, Product_Master__c> mapProductNameToPM = new Map<String, Product_Master__c>();
List<Product_Master__c> lstPM = [Select Product_Name__c, ProductType__c, Investment_Type__c, Policy_Type__c,
										(Select Upfront_Commission__c, Trail_Commission__c, Min_Year_Value__c, Max_Year_Value__c from Commissions__r where Active__c = true )
								From Product_Master__c where  (ProductType__c = 'Mutual Fund' Or ProductType__c = 'Life Insurance'    
								     or ProductType__c = 'General Insurance') and Is_Active__c = true];										

for(Product_Master__c objPM : lstPM)
{
	system.debug('********objPM*******************'+objPM);
	mapProductNameToPM.put(objPM.Product_Name__c, objPM);
}	
List<Approve_Action_Plan__c> lstAAPUpdate = new List<Approve_Action_Plan__c>();
List<ARPP_Detail__c> lstARPPUpdate = new List<ARPP_Detail__c>();

for(String strProductName : mapMFproductNameTolstAP.keySet())
{
	system.debug('********strProductName*******************'+strProductName);
	Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(strProductName.trim().toLowerCase()));
	system.debug('********objPM*******************'+objPM);
	if(objPM != null)
	{
		system.debug('********objPM11*******************');
		
		Commission__c objComm = objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null;
		for(Approve_Action_Plan__c objAAP : mapMFproductNameTolstAP.get(strProductName))
		{
			system.debug('********objAAP*******************'+objAAP);
			objAAP.product__c = objPM.Id;
			lstAAPUpdate.add(objAAP);
			ARPP_Detail__c objARPP = mapApIdToARPP.get(objAAP.Id);
			if(objAAP.Item_type__c == 'SIP')
			{
				system.debug('********sip*******************');
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
				system.debug('********Lumpsum*******************');
				objARPP.Action_Plan_Upfront_Comm_Amount__c = objComm != null ? (objARPP.Action_Plan_Amount__c * objComm.Upfront_Commission__c )/100.0 : 0;
				objARPP.Action_Plan_Trial_Comm_Amount__c = objComm != null ? (objARPP.Action_Plan_Amount__c * objComm.Trail_Commission__c)/100.0 : 0;
			}
			
			if(objAAP.Item_type__c == 'General Insurance')
			{
				system.debug('********General Insurance*******************');
				system.debug('*****objAAP*********'+objAAP.Id);
				system.debug('*****objAAP.Item_type__c*********'+objAAP.Item_type__c);
				
				
				
				objARPP.Action_Plan_Upfront_Comm_Amount__c = objComm != null ?(objARPP.Action_Plan_Amount__c != null ?(objComm.Upfront_Commission__c * objARPP.Action_Plan_Amount__c)/100 : 0) : 0;
				objARPP.Action_Plan_Trial_Comm_Amount__c = 0;
				system.debug('*****Action_Plan_Upfront_Comm_Amount__c *********'+objARPP.Action_Plan_Upfront_Comm_Amount__c );
			}
			objARPP.product__c = objPM.Id;
			objARPP.Commission__c = objComm != null ?  objComm.Id : null;
			objARPP.Remark__c = '';
			lstARPPUpdate.add(objARPP);
		}
	}
}

for(String strProductName : mapLIpolicyNameTolstAP.keySet())
{
	Product_Master__c objPM = mapProductNameToPM.get(mapActionPlanProductNameToProductMasterName.get(strProductName.trim().toLowerCase()));
	
	if(objPM != null)
	{
		Commission__c objComm;
		List<Commission__c> lstCommission = objPM != null ? objPM.Commissions__r : null;
		for(Approve_Action_Plan__c objAAP : mapLIpolicyNameTolstAP.get(strProductName))
		{
			objAAP.product__c = objPM.Id;
			lstAAPUpdate.add(objAAP);
			ARPP_Detail__c objARPP = mapApIdToARPP.get(objAAP.Id);
			if(objAAP.Item_type__c == 'Life Insurance')
			{
				system.debug('********Life Insurance*******************');
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
				objARPP.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null ?(objARPP.Action_Plan_Amount__c != null ?(objComm.Upfront_Commission__c * objARPP.Action_Plan_Amount__c)/100 : 0) : 0;
				objARPP.Action_Plan_Trial_Comm_Amount__c = 0;
			
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
	update lstAAPUpdate;
	update lstARPPUpdate;
}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
