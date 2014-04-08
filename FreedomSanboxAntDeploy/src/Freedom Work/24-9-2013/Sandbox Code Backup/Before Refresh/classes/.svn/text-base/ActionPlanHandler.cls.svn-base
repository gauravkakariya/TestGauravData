/*
  Revision History:
    Version     Version Author        Date          Comments
    1.0          Anupam Agrawal       09/05/2013     Initial Draft
*/
public class ActionPlanHandler
{
	public void onAfterInsertForARPPCalculation(Map<Id, Approve_Action_Plan__c> mapNewIdToActionPlan)
	{
		List<ARPP_Detail__c> lstARPPDetail = new List<ARPP_Detail__c>();
		Map<String, List<Approve_Action_Plan__c>> mapItemTypeTolstAAP = new Map<String, List<Approve_Action_Plan__c>>();
		Map<String, Product_Master__c> mapProductNameToPM = new Map<String, Product_Master__c>();
		List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
		
		
		String strQuery = ' Select Insurance__r.Policy_Type__c, ';
		Map<String, Schema.SObjectField> mapAAPFieldNameToFieldDescribe = Approve_Action_Plan__c.sObjectType.getDescribe().fields.getMap();
		for(String strField : mapAAPFieldNameToFieldDescribe.keySet())
		{
			strQuery += strField +',';
		}
		strQuery = strQuery.substring(0, strQuery.length() - 1);
		Set<Id>  setAAPId = new Set<Id>();
		setAAPId.addAll(mapNewIdToActionPlan.keySet());
		
		strQuery += ' from Approve_Action_Plan__c where Id IN: setAAPId  ';	
		
 		for(Approve_Action_Plan__c objAAP : Database.query(strQuery))
		{
			Boolean isET = objAAP.isSIPexecutionTracker__c || objAAP.isLumpsumExecTracker__c || objAAP.isInsuranceExecutionTracker__c;
			if(isET && objAAP.Item_Type__c != '' && objAAP.Item_Type__c != 'Recmmended Insurance')
			{
				if(!mapItemTypeTolstAAP.containsKey(objAAP.Item_Type__c))
					mapItemTypeTolstAAP.put(objAAP.Item_Type__c, new List<Approve_Action_Plan__c>{objAAP});
				else
					mapItemTypeTolstAAP.get(objAAP.Item_Type__c).add(objAAP);
			}
		}
		
		//SIP product 
		if(mapItemTypeTolstAAP.containsKey('SIP'))
		{
			List<String> lstSipProductName = new List<String>();
			for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('SIP'))
			{
				lstSipProductName.add(objAAP.Product_Name__c);
			}
			mapProductNameToPM = new Map<String, Product_Master__c>();
			for(Product_Master__c objPM : [Select Product_Name__c, ProductType__c, Investment_Type__c 
													From Product_Master__c where Product_Name__c IN: lstSipProductName and Investment_Type__c = 'SIP'])
			{
				mapProductNameToPM.put(objPM.Product_Name__c, objPM);
			}												
		
			
			for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('SIP'))	
			{
				Product_Master__c objPM = mapProductNameToPM.get(objAAP.Product_Name__c);
				
				ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
				objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
				objARPPDetail.Action_Plan_Amount__c = objAAP.Amount__c;
				objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null ? (objPM.Upfront_Commission__c * 12 * objAAP.Amount__c)/100 : 0;
				Double trailComm = 0;
				Double amount = objAAP.Amount__c;
				if(objPM != null )
					for(Integer i = 0; i < 12 ; i++)
					{
						trailComm += (amount * objPM.Trail_Commission__c)/100;
						amount += objAAP.Amount__c;
					}
				objARPPDetail.Action_Plan_Trial_Comm_Amount__c = trailComm;
				objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
				objARPPDetail.Entity__c = objAAP.Account__c;
				objARPPDetail.Type__c = objAAP.Item_Type__c;
				lstARPPDetail.add(objARPPDetail);
				
				objAAP.Product__c = objPM != null ? objPM.Id : null;
				lstApproveActionPlan.add(objAAP);
			}
		}
		
		//Lumpsum Product
		if(mapItemTypeTolstAAP.containsKey('Lumpsum'))
		{									
			List<String> lstLumpsumProductName = new List<String>();
			for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('Lumpsum'))
			{
				lstLumpsumProductName.add(objAAP.Product_Name__c);
			}
			mapProductNameToPM = new Map<String, Product_Master__c>();
			for(Product_Master__c objPM : [Select Upfront_Commission__c, Trail_Commission__c, Product_Name__c, ProductType__c, Investment_Type__c 
													From Product_Master__c where Product_Name__c IN: lstLumpsumProductName and Investment_Type__c = 'Lumpsum'])
			{
				mapProductNameToPM.put(objPM.Product_Name__c, objPM);
			}
			
			for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('Lumpsum'))	
			{
				Product_Master__c objPM = mapProductNameToPM.get(objAAP.Product_Name__c);
				
				ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
				objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
				objARPPDetail.Action_Plan_Amount__c = objAAP.Amount__c;
				objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null ? (objPM.Upfront_Commission__c * 12 * objAAP.Amount__c)/100 : 0;
				
				objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
				objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
				objARPPDetail.Entity__c = objAAP.Account__c;
				objARPPDetail.Type__c = objAAP.Item_Type__c;
				lstARPPDetail.add(objARPPDetail);
				
				objAAP.Product__c = objPM != null ? objPM.Id : null;
				lstApproveActionPlan.add(objAAP);
			}
		}
		
		
		//General Insurance Product
		if(mapItemTypeTolstAAP.containsKey('General Insurance'))
		{									
			mapProductNameToPM = new Map<String, Product_Master__c>();
			for(Product_Master__c objPM : [Select Upfront_Commission__c, Trail_Commission__c, Product_Name__c, ProductType__c, Investment_Type__c, Policy_Type__c
													From Product_Master__c where ProductType__c = 'General Insurance'])
			{
				mapProductNameToPM.put(objPM.Product_Name__c + '~' + objPM.Policy_Type__c, objPM);
			}
			
			for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('General Insurance'))	
			{
				Product_Master__c objPM = mapProductNameToPM.get(objAAP.Product_Name__c + '~' + objAAP.Policy_Type__c);
				ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
				objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
				objARPPDetail.Action_Plan_Amount__c = objAAP.Sum_Assured_Rs__c ;
				objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null ? (objAAP.Sum_Assured_Rs__c  != null ?(objPM.Upfront_Commission__c * objAAP.Sum_Assured_Rs__c )/100 : 0) : 0;
				
				objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
				objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
				objARPPDetail.Entity__c = objAAP.Account__c;
				objARPPDetail.Type__c = objAAP.Item_Type__c;
				lstARPPDetail.add(objARPPDetail);
				
				objAAP.Product__c = objPM != null ? objPM.Id : null;
				lstApproveActionPlan.add(objAAP);
			}
		}
		
		//General Insurance Product
		if(mapItemTypeTolstAAP.containsKey('Life Insurance'))
		{									
			mapProductNameToPM = new Map<String, Product_Master__c>();
			for(Product_Master__c objPM : [Select Upfront_Commission__c, Trail_Commission__c, Product_Name__c, ProductType__c, Investment_Type__c, Policy_Type__c 
													From Product_Master__c where ProductType__c = 'Life Insurance'])
			{
				mapProductNameToPM.put(objPM.Product_Name__c + '~' + objPM.Policy_Type__c, objPM);
			}
			
			for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('Life Insurance'))	
			{	
				Product_Master__c objPM = mapProductNameToPM.get(objAAP.Policy_Name__c + '~' + objAAP.Insurance__r.Policy_Type__c);
				
				ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
				objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
				objARPPDetail.Action_Plan_Amount__c = objAAP.Sum_Assured_Rs__c;
				
				objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null ?(objAAP.Sum_Assured_Rs__c != null ?(objPM.Upfront_Commission__c * objAAP.Sum_Assured_Rs__c)/100 : 0) : 0;
				
				objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
				objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
				objARPPDetail.Entity__c = objAAP.Account__c;
				objARPPDetail.Type__c = objAAP.Item_Type__c;
				lstARPPDetail.add(objARPPDetail);
				
				objAAP.Product__c = objPM != null ? objPM.Id : null;
				lstApproveActionPlan.add(objAAP);
			}
		}
		if(!lstARPPDetail.isEmpty())
			insert lstARPPDetail;
			
		if(!lstApproveActionPlan.isEmpty())
			update lstApproveActionPlan;
		
	}
	
	public void onBeforeDelete(Map<Id, Approve_Action_Plan__c> mapOldIdToActionPlan)
	{
		System.debug('--------------------------mapOldIdToActionPlan-----------------'+mapOldIdToActionPlan.size());
		List<ARPP_Detail__c> lstARPPDetail = [Select Id from ARPP_Detail__c where Approve_Action_Plan__c IN : mapOldIdToActionPlan.keySet()];
		if(!lstARPPDetail.isEmpty())
			delete lstARPPDetail;
	}
}