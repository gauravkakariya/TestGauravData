/*
  Revision History:
    Version     Version Author        Date          Comments
    1.0         Anupam Agrawal       09/05/2013     Initial Draft : Create ARRP record after creating Action plan and ET.
    1.1         Aditi Satpute        19/8/2013      On AP Updation Et records should be updated
    
*/

public with sharing class ARPPCalculationHandler 
{
	//public static Boolean isRecursive = false;
	
	public void onAfterUpdateForARPPCalculation(List<Approve_Action_Plan__c> lstNewAAP, List<Approve_Action_Plan__c> lstOldAAP, Map<Id, Approve_Action_Plan__c> mapNewIdToActionPlan)
	{
		System.debug('----------------lstNewAAP-------------------'+lstNewAAP.size());
		List<Approve_Action_Plan__c> lstAAPforCurrentRunningSIP = new List<Approve_Action_Plan__c>();
		List<Approve_Action_Plan__c> lstAAPforCurrentRunningLumpsum = new List<Approve_Action_Plan__c>();
		List<Approve_Action_Plan__c> lstAAPforSIP = new List<Approve_Action_Plan__c>();
		List<Approve_Action_Plan__c> lstAAPforLumpsum = new List<Approve_Action_Plan__c>();
		List<Approve_Action_Plan__c> lstAAPforLI = new List<Approve_Action_Plan__c>();
		List<Approve_Action_Plan__c> lstAAPforGI = new List<Approve_Action_Plan__c>();
		
		List<ARPP_Detail__c> lstUpdateARPP = new List<ARPP_Detail__c>();
		List<ARPP_Detail__c> lstDeleteARPP = new List<ARPP_Detail__c>();
		
		Map<Id, Approve_Action_Plan__c> mapIdToAAPtoCreateNewARPP = new Map<Id, Approve_Action_Plan__c>();
		Map<Id, List<ARPP_Detail__c>> mapAPIdTolstARPPDetail = new Map<Id, List<ARPP_Detail__c>>();
      											
      	
		List<ARPP_Detail__c> lstARPP = [select Id, Action_Amount_Revenue__c, Entity__c, Type__c, Execution_Tracker_Total_Revenue__c,Approve_Action_Plan__c,
											Action_Plan_Amount__c,  Action_Plan_Upfront_Comm_Amount__c, Action_Plan_Trial_Comm_Amount__c,
											Execution_Tracker_Amount__c, Execution_Tracker_upfront_Comm_Amount__c, Execution_Tracker_Trial_Comm_Amount__c from ARPP_Detail__c
											where Approve_Action_Plan__c IN : mapNewIdToActionPlan.keySet()];
			
		for(ARPP_Detail__c objARPP : lstARPP)
		{
			if(!mapAPIdTolstARPPDetail.containsKey(objARPP.Approve_Action_Plan__c))
				mapAPIdTolstARPPDetail.put(objARPP.Approve_Action_Plan__c , new List<ARPP_Detail__c>{objARPP});
			else
				mapAPIdTolstARPPDetail.get(objARPP.Approve_Action_Plan__c).add(objARPP);
		}
		
		//retrieve all Products where Investment type either SIP or Lumpsum 
		map<Id, Product_Master__c> mapIdToProductMaster = new map<Id, Product_Master__c>([Select (Select Min_Year_Value__c, Max_Year_Value__c, Upfront_Commission__c, Trail_Commission__c from Commissions__r where Active__c = true), 
														Product_Name__c, ProductType__c, Investment_Type__c 
												   	From Product_Master__c 
												   	where  Is_Active__c = true]);
		
		for(Integer i = 0 ; i < lstNewAAP.size() ; i++)
		{
			Approve_Action_Plan__c objNewAAP = lstNewAAP[i];
			Approve_Action_Plan__c objOldAAP = lstOldAAP[i];
			
			
			/*if((objNewAAP.isInsuranceExecutionTracker__c == true && objOldAAP.isInsuranceExecutionTracker__c == false) 
				|| (objNewAAP.isLumpsumExecTracker__c == true && objOldAAP.isLumpsumExecTracker__c == false)
				|| (objNewAAP.isExecutionTracker__c == true && objOldAAP.isExecutionTracker__c == false) 
				|| (objNewAAP.isSIPExecutionTracker__c == true && objOldAAP.isSIPExecutionTracker__c == false)
				|| (objNewAAP.isExecutionTracker__c && ((objOldAAP.Lumpsum_Action__c == null || objOldAAP.Lumpsum_Action__c == 'Switch Out' 
					|| objOldAAP.Lumpsum_Action__c == 'Hold - Change of Broker' || objOldAAP.Lumpsum_Action__c == 'Redeem' || objOldAAP.Lumpsum_Action__c == 'Hold - Existing Fund') 
				   && ( objNewAAP.Lumpsum_Action__c != null && objNewAAP.Lumpsum_Action__c != 'Switch Out' && objNewAAP.Lumpsum_Action__c != 'Hold - Change of Broker'
					   && objNewAAP.Lumpsum_Action__c != 'Redeem' && objNewAAP.Lumpsum_Action__c != 'Hold - Existing Fund')))
				|| (objNewAAP.isSIPexecutionTracker__c && ((objOldAAP.SIP_Action__c == 'Stop' || objOldAAP.SIP_Action__c == 'Continue - Existing SIP')
											           && (objNewAAP.SIP_Action__c != 'Stop' &&  objNewAAP.SIP_Action__c != 'Continue - Existing SIP'))))
			{
				if(objNewAAP.isExecutionTracker__c && ((objOldAAP.Lumpsum_Action__c == null || objOldAAP.Lumpsum_Action__c == 'Switch Out' 
					|| objOldAAP.Lumpsum_Action__c == 'Hold - Change of Broker' || objOldAAP.Lumpsum_Action__c == 'Redeem' || objOldAAP.Lumpsum_Action__c == 'Hold - Existing Fund') 
				   && ( objNewAAP.Lumpsum_Action__c != null && objNewAAP.Lumpsum_Action__c != 'Switch Out' && objNewAAP.Lumpsum_Action__c != 'Hold - Change of Broker'
					 && objNewAAP.Lumpsum_Action__c != 'Redeem' && objNewAAP.Lumpsum_Action__c != 'Hold - Existing Fund')))
				{
					if(mapAPIdTolstARPPDetail.containskey(objNewAAP.Id))
					{
						Boolean isAvailable = false;
						for(ARPP_Detail__c objARPP : mapAPIdTolstARPPDetail.get(objNewAAP.Id))
							if(objARPP.Type__c == 'Lumpsum')
							{
								isAvailable = true;
								break;
							}
						if(!isAvailable)
						{
							mapIdToAAPtoCreateNewARPP.put(objNewAAP.Id, objNewAAP);
							continue;
						}
					}
					else
					{
						mapIdToAAPtoCreateNewARPP.put(objNewAAP.Id, objNewAAP);
						continue;
					}
				}
				else if(objNewAAP.isSIPexecutionTracker__c && ((objOldAAP.SIP_Action__c == 'Stop' || objOldAAP.SIP_Action__c == 'Continue - Existing SIP')
											           && (objNewAAP.SIP_Action__c != 'Stop' &&  objNewAAP.SIP_Action__c != 'Continue - Existing SIP')))
				{
					if(mapAPIdTolstARPPDetail.containskey(objNewAAP.Id))
					{
						Boolean isAvailable = false;	
						for(ARPP_Detail__c objARPP : mapAPIdTolstARPPDetail.get(objNewAAP.Id))
							if(objARPP.Type__c == 'SIP')
							{
								isAvailable = true;
								break;
							}
						if(!isAvailable)
						{
							mapIdToAAPtoCreateNewARPP.put(objNewAAP.Id, objNewAAP);
							continue;
						}
					}
					else
					{
						mapIdToAAPtoCreateNewARPP.put(objNewAAP.Id, objNewAAP);
						continue;
					}
				}
				else
				{
					mapIdToAAPtoCreateNewARPP.put(objNewAAP.Id, objNewAAP);
					continue;
				}
				
			}*/
			
			if((objNewAAP.isInsuranceExecutionTracker__c == true && objOldAAP.isInsuranceExecutionTracker__c == false) 
				|| (objNewAAP.isLumpsumExecTracker__c == true && objOldAAP.isLumpsumExecTracker__c == false)
				|| (objNewAAP.isExecutionTracker__c == true && objOldAAP.isExecutionTracker__c == false) 
				|| (objNewAAP.isSIPExecutionTracker__c == true && objOldAAP.isSIPExecutionTracker__c == false))
			{
				mapIdToAAPtoCreateNewARPP.put(objNewAAP.Id, objNewAAP);
				continue;
				
			}
			//Delete Insurance based RPP
			if(objNewAAP.isInsuranceExecutionTracker__c == false && objOldAAP.isInsuranceExecutionTracker__c == true)
			{
				if(mapAPIdTolstARPPDetail.containskey(objNewAAP.Id))
				{
					ARPP_Detail__c objARPPDetail;
					for(ARPP_Detail__c objARPP : mapAPIdTolstARPPDetail.get(objNewAAP.Id))
					{
						objARPPDetail = objARPP;
						break;
					}
					lstDeleteARPP.add(objARPPDetail);
				}
				continue;
			}
			
			//Delete Goal wise Lumpsum based RPP
			if(objNewAAP.isLumpsumExecTracker__c == false && objOldAAP.isLumpsumExecTracker__c == true)
			{
				if(mapAPIdTolstARPPDetail.containskey(objNewAAP.Id))
				{
					ARPP_Detail__c objARPPDetail;
					for(ARPP_Detail__c objARPP : mapAPIdTolstARPPDetail.get(objNewAAP.Id))
					{
						objARPPDetail = objARPP;
						break;
					}
					lstDeleteARPP.add(objARPPDetail);
				}
				continue;
			}
			System.debug('--------------------------objNewAAP.isExecutionTracker__c---------'+objNewAAP.isExecutionTracker__c);
			System.debug('--------------------------objOldAAP.isExecutionTracker__c---------'+objOldAAP.isExecutionTracker__c);
			
			System.debug('--------------------------objNewAAP.isSIPExecutionTracker__c---------'+objNewAAP.isSIPExecutionTracker__c);
			System.debug('--------------------------objOldAAP.isSIPExecutionTracker__c---------'+objOldAAP.isSIPExecutionTracker__c);
			if((objNewAAP.isExecutionTracker__c == false && objOldAAP.isExecutionTracker__c == true) ||
				(objNewAAP.isSIPExecutionTracker__c == false && objOldAAP.isSIPExecutionTracker__c == true))
			{
				if((objNewAAP.isExecutionTracker__c == false && objOldAAP.isExecutionTracker__c == true) && mapAPIdTolstARPPDetail.containskey(objNewAAP.Id))
				{
					ARPP_Detail__c objARPPDetail;
					for(ARPP_Detail__c objARPP : mapAPIdTolstARPPDetail.get(objNewAAP.Id))
					{
						if(objARPP.Type__c == 'Lumpsum')
						{
							objARPPDetail = objARPP;
							break;
						}
					}
					if(objARPPDetail != null)
						lstDeleteARPP.add(objARPPDetail);
				}
				
				if( (objNewAAP.isSIPExecutionTracker__c == false && objOldAAP.isSIPExecutionTracker__c == true) && mapAPIdTolstARPPDetail.containskey(objNewAAP.Id))
				{
					ARPP_Detail__c objARPPDetail;
					for(ARPP_Detail__c objARPP : mapAPIdTolstARPPDetail.get(objNewAAP.Id))
					{
						if(objARPP.Type__c == 'SIP')
						{
							objARPPDetail = objARPP;
							break;
						}
					}
					if(objARPPDetail != null)
						lstDeleteARPP.add(objARPPDetail);
				}
				continue;
			}
			System.debug('-----------------lstDeleteARPP 1------'+lstDeleteARPP.size());
			
			if(objNewAAP.Investment_Asset__c != null && (objNewAAP.Lumpsum_Action__c != objOldAAP.Lumpsum_Action__c 
													    || objNewAAP.Action_Amount__c != objOldAAP.Action_Amount__c))
			{
			
				lstAAPforCurrentRunningLumpsum.add(objNewAAP);
			}
			if(objNewAAP.Investment_Asset__c != null && (objNewAAP.SIP_Action__c != objOldAAP.SIP_Action__c 
														 || objNewAAP.SIP_Action_Amount__c != objOldAAP.SIP_Action_Amount__c))
			{
				lstAAPforCurrentRunningSIP.add(objNewAAP);
			}
			else if(objNewAAP.Item_Type__c == 'SIP' && (objNewAAP.Product_Name__c != objOldAAP.Product_Name__c || objNewAAP.Amount__c != objOldAAP.Amount__c))
			{
				lstAAPforSIP.add(objNewAAP);
			}
			if(objNewAAP.Item_Type__c == 'Lumpsum' && (objNewAAP.Product_Name__c != objOldAAP.Product_Name__c || objNewAAP.Amount__c != objOldAAP.Amount__c))
			{
				lstAAPforLumpsum.add(objNewAAP);
			}
			if(objNewAAP.Item_Type__c == 'Life Insurance' && 
				(objNewAAP.Policy_Name__c != objOldAAP.Policy_Name__c || objNewAAP.Tenure_of_Insurance__c != objOldAAP.Tenure_of_Insurance__c 
				|| objNewAAP.Premium_Amount_Rs__c != objOldAAP.Premium_Amount_Rs__c))
			{
				lstAAPforLI.add(objNewAAP);
			}
			else if(objNewAAP.Item_Type__c == 'General Insurance' && 
				(objNewAAP.Product_Name__c != objOldAAP.Product_Name__c || objNewAAP.Premium_Amount_Rs__c != objOldAAP.Premium_Amount_Rs__c))
			{
				lstAAPforGI.add(objNewAAP);
			}
			
		}
		System.debug('---------------------------lstAAPforCurrentRunningLumpsum---------------'+lstAAPforCurrentRunningLumpsum.size());
		for(Approve_Action_Plan__c objAAP: lstAAPforCurrentRunningLumpsum)
		{
			
			if(mapAPIdTolstARPPDetail.containskey(objAAP.Id))
			{
				ARPP_Detail__c objARPPDetail;
				for(ARPP_Detail__c objARPP : mapAPIdTolstARPPDetail.get(objAAP.Id))
				{
					if(objARPP.Type__c == 'Lumpsum')
					{
						objARPPDetail = objARPP;
						break;
					}
				}
				
				if(objARPPDetail != null)
				{
					Product_Master__c objPM = mapIdToProductMaster.get(objAAP.Product__c);
					if(objPM != null)
					{
						Commission__c objComm = objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null;
						if(objAAP.Lumpsum_Action__c == 'STP From')
						{
							objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null  
																				? (objAAP.Action_Amount__c  != null ?
																				   (objComm.Upfront_Commission__c * objAAP.Action_Amount__c )/100 
																				   : 0) 
																				: 0;
							objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
						}
						else if(objAAP.Lumpsum_Action__c == 'STP To' || objAAP.Lumpsum_Action__c ==  'Switch In')
						{
							objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null  
																				? (objAAP.Action_Amount__c  != null ?
																				   (objComm.Upfront_Commission__c * objAAP.Action_Amount__c )/100
																				   : 0) 
																				: 0;
							
							objARPPDetail.Action_Plan_Trial_Comm_Amount__c = objPM != null && objComm != null  
																			 ? (objAAP.Action_Amount__c  != null ?
																			   (objComm.Trail_Commission__c * objAAP.Action_Amount__c)/100 : 0) 
																			 : 0;
						}
						else if(objAAP.Lumpsum_Action__c == 'Hold' )
						{
							objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = 0;
							
							objARPPDetail.Action_Plan_Trial_Comm_Amount__c = objPM != null && objComm != null 
																			 ? (objAAP.Action_Amount__c  != null ?
																			 	(objComm.Trail_Commission__c * objAAP.Action_Amount__c)/100 
																			 	: 0) 
																			 : 0;
						}
						else
						{
							objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = 0;
							objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
						}
						objARPPDetail.Action_Plan_Amount__c =  objAAP.Action_Amount__c;
						objARPPDetail.Product__c = objAAP.Product__c;
						objARPPDetail.Commission__c = objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0].Id : null;
						objARPPDetail.Remark__c = objPM.Commissions__r.size() == 0 ? Label.Expected_Commission_Remark : '';
					}
					else
					{
						objARPPDetail.Remark__c = Label.Expected_Product_Remark;
					}
					lstUpdateARPP.add(objARPPDetail);
				}
			}
		}
		
		for(Approve_Action_Plan__c objAAP: lstAAPforCurrentRunningSIP)
		{
			
			if(mapAPIdTolstARPPDetail.containskey(objAAP.Id))
			{
				ARPP_Detail__c objARPPDetail;
				for(ARPP_Detail__c objARPP : mapAPIdTolstARPPDetail.get(objAAP.Id))
				{
					if(objARPP.Type__c == 'SIP')
					{
						objARPPDetail = objARPP;
						break;
					}
				}
				
				if(objARPPDetail != null)
				{
					Product_Master__c objPM = mapIdToProductMaster.get(objAAP.Product__c);
					if(objPM != null)
					{
						Commission__c objComm = objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null;
						if(objAAP.SIP_Action__c == 'Existing SIP - COB' || objAAP.SIP_Action__c == 'Continue')
						{
							objARPPDetail.Action_Plan_Upfront_Comm_Amount__c =  objPM != null && objPM.Commissions__r.size() > 0
																			? (objAAP.Action_Amount__c  != null ?(objComm.Upfront_Commission__c * objAAP.SIP_Action_Amount__c * 12 )/100 : 0) 
																			: 0;
							Double trailComm = 0;
							Double amount = objAAP.SIP_Action_Amount__c;
							
							Integer installment = objAAP.Installments__c <= 12  ? Integer.valueOf(objAAP.Installments__c) : 12;
							
							if( objPM != null && objPM.Commissions__r.size() > 0 )
							{
								for(Integer i = 0; i < installment ; i++)
								{
									trailComm += (amount * objComm.Trail_Commission__c)/100;
									amount += objAAP.SIP_Action_Amount__c;
								}
							}
							objARPPDetail.Action_Plan_Trial_Comm_Amount__c = trailComm;
						}
						else
						{
							objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = 0;
							objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
						}
						
						objARPPDetail.Action_Plan_Amount__c =  objAAP.SIP_Action_Amount__c;
						objARPPDetail.Product__c = objAAP.Product__c;
						objARPPDetail.Commission__c = objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0].Id : null;
						objARPPDetail.Remark__c = objPM.Commissions__r.size() == 0 ? Label.Expected_Commission_Remark : '';
					}
					else
					{
						objARPPDetail.Remark__c = Label.Expected_Product_Remark;
					}
					lstUpdateARPP.add(objARPPDetail);
				}
			}
		}
		
		for(Approve_Action_Plan__c objAAP: lstAAPforSIP)
		{
			if(mapAPIdTolstARPPDetail.containskey(objAAP.Id))
			{
				ARPP_Detail__c objARPPDetail;
				for(ARPP_Detail__c objARPP : mapAPIdTolstARPPDetail.get(objAAP.Id))
					objARPPDetail = objARPP;
				
				Product_Master__c objPM = mapIdToProductMaster.get(objAAP.Product__c);
				if(objPM != null)
				{
					Commission__c objComm = objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null;
					objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objPM.Commissions__r.size() > 0 ? 
																		(objComm.Upfront_Commission__c * 12 * objAAP.Amount__c)/100 : 0;
					Double trailComm = 0;
					Double amount = objAAP.Amount__c;
					Integer installment = objAAP.Installments__c <= 12  ? Integer.valueOf(objAAP.Installments__c) : 12;
					if(objPM != null && objPM.Commissions__r.size() > 0)
						for(Integer i = 0; i < installment ; i++)
						{
							trailComm += (amount * objComm.Trail_Commission__c)/100;
							amount += objAAP.Amount__c;
						}
					objARPPDetail.Action_Plan_Trial_Comm_Amount__c = trailComm;
					
					objARPPDetail.Action_Plan_Amount__c =  objAAP.Amount__c;
					objARPPDetail.Product__c = objAAP.Product__c;
					objARPPDetail.Commission__c = objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0].Id : null;
					objARPPDetail.Remark__c = objPM.Commissions__r.size() == 0 ? Label.Expected_Commission_Remark : '';
				}
				else
				{
					objARPPDetail.Remark__c = Label.Expected_Product_Remark;
				}
				lstUpdateARPP.add(objARPPDetail);
			}
		}
		
		for(Approve_Action_Plan__c objAAP: lstAAPforLumpsum)
		{
			if(mapAPIdTolstARPPDetail.containskey(objAAP.Id))
			{
				ARPP_Detail__c objARPPDetail;
				for(ARPP_Detail__c objARPP : mapAPIdTolstARPPDetail.get(objAAP.Id))
					objARPPDetail = objARPP;
				Product_Master__c objPM = mapIdToProductMaster.get(objAAP.Product__c);	
				if(objPM != null)
				{
					Commission__c objComm = objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null;
					objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null ? (objComm.Upfront_Commission__c  * objAAP.Amount__c)/100 : 0;
					objARPPDetail.Action_Plan_Trial_Comm_Amount__c =  objPM != null && objComm != null ? (objComm.Trail_Commission__c  * objAAP.Amount__c)/100 : 0;
					
					objARPPDetail.Action_Plan_Amount__c =  objAAP.Amount__c;
					objARPPDetail.Product__c = objAAP.Product__c;
					objARPPDetail.Commission__c = objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0].Id : null;
					objARPPDetail.Remark__c = objPM.Commissions__r.size() == 0 ? Label.Expected_Commission_Remark : '';
				}
				else
				{
					objARPPDetail.Remark__c = Label.Expected_Product_Remark;
				}
				lstUpdateARPP.add(objARPPDetail);
			}
		}
		
		for(Approve_Action_Plan__c objAAP: lstAAPforGI)
		{
			if(mapAPIdTolstARPPDetail.containskey(objAAP.Id))
			{
				ARPP_Detail__c objARPPDetail;
				for(ARPP_Detail__c objARPP : mapAPIdTolstARPPDetail.get(objAAP.Id))
					objARPPDetail = objARPP;
				
				Product_Master__c objPM = mapIdToProductMaster.get(objAAP.Product__c);
				if(objPM != null)
				{
					Commission__c objComm = objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null;
					objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null ? (objAAP.Premium_Amount_Rs__c  != null ?(objComm.Upfront_Commission__c * objAAP.Premium_Amount_Rs__c )/100 : 0) : 0;
					objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
					
					objARPPDetail.Action_Plan_Amount__c =  objAAP.Premium_Amount_Rs__c;
					objARPPDetail.Product__c = objAAP.Product__c;
					objARPPDetail.Commission__c = objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0].Id : null;
					objARPPDetail.Remark__c = objPM.Commissions__r.size() == 0 ? Label.Expected_Commission_Remark : '';
				}
				else
				{
					objARPPDetail.Remark__c = Label.Expected_Product_Remark;
				}
				lstUpdateARPP.add(objARPPDetail);
			}
		}
		
		for(Approve_Action_Plan__c objAAP: lstAAPforLI)
		{
			if(mapAPIdTolstARPPDetail.containskey(objAAP.Id))
			{
				ARPP_Detail__c objARPPDetail;
				for(ARPP_Detail__c objARPP : mapAPIdTolstARPPDetail.get(objAAP.Id))
					objARPPDetail = objARPP;
					
				Product_Master__c objPM = mapIdToProductMaster.get(objAAP.Product__c);
				if(objPM != null)
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
					
					objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null ?(objAAP.Premium_Amount_Rs__c != null ?(objComm.Upfront_Commission__c * objAAP.Premium_Amount_Rs__c)/100 : 0) : 0;
					objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
					
					objARPPDetail.Action_Plan_Amount__c =  objAAP.Premium_Amount_Rs__c;
					objARPPDetail.Product__c = objAAP.Product__c;
					objARPPDetail.Commission__c = objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0].Id : null;
					objARPPDetail.Remark__c = objPM.Commissions__r.size() == 0 ? Label.Expected_Commission_Remark : '';
				}
				else
				{
					objARPPDetail.Remark__c = Label.Expected_Product_Remark;
				}
				lstUpdateARPP.add(objARPPDetail);
			}
		}
		
		if(!lstUpdateARPP.isEmpty())
			update lstUpdateARPP;
		System.debug('-----------------lstDeleteARPP 2------'+lstDeleteARPP.size());
		if(!lstDeleteARPP.isEmpty())
			delete lstDeleteARPP;
		
		if(!mapIdToAAPtoCreateNewARPP.isEmpty())
		{
			onAfterInsertForARPPCalculation(mapIdToAAPtoCreateNewARPP);
			System.debug('-------------------before call-------------------'+mapIdToAAPtoCreateNewARPP.size());
			onAfterInsertForARPPWithRunningSIPandLumpsum(mapIdToAAPtoCreateNewARPP);
		}
	}
	
	//Method call On After Insert of Approve Action plan object
	public void onAfterInsertForARPPCalculation(Map<Id, Approve_Action_Plan__c> mapNewIdToActionPlan)
	{
		//local variables
		List<ARPP_Detail__c> lstARPPDetail = new List<ARPP_Detail__c>();
		Map<String, List<Approve_Action_Plan__c>> mapItemTypeTolstAAP = new Map<String, List<Approve_Action_Plan__c>>();
		Map<String, Product_Master__c> mapProductNameToPM = new Map<String, Product_Master__c>();
		List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
		String strQuery = ' Select Insurance__r.Policy_Type__c, ';
		Map<String, Schema.SObjectField> mapAAPFieldNameToFieldDescribe = Approve_Action_Plan__c.sObjectType.getDescribe().fields.getMap();
		
		//Create Dynamic query
		for(String strField : mapAAPFieldNameToFieldDescribe.keySet())
		{
			strQuery += strField +',';
		}
		strQuery = strQuery.substring(0, strQuery.length() - 1);
		Set<Id>  setAAPId = new Set<Id>();
		system.debug('*********mapNewIdToActionPlan*****'+mapNewIdToActionPlan);
		setAAPId.addAll(mapNewIdToActionPlan.keySet());
		strQuery += ' from Approve_Action_Plan__c where Id IN: setAAPId  ';	
		
		Set<String> setProductName = new Set<String>();
		Set<Id> setEntityId = new Set<Id>();
		//Execute query and create map of Item type to Action Plan .
 		for(Approve_Action_Plan__c objAAP : Database.query(strQuery))
		{
			//Check ET is opened or Not.
			Boolean isET = objAAP.isSIPexecutionTracker__c || objAAP.isLumpsumExecTracker__c || objAAP.isInsuranceExecutionTracker__c;
			if(isET && objAAP.Item_Type__c != '' && objAAP.Item_Type__c != 'Recmmended Insurance' && objAAP.Investment_Asset__c == null)
			{
				if(!mapItemTypeTolstAAP.containsKey(objAAP.Item_Type__c))
					mapItemTypeTolstAAP.put(objAAP.Item_Type__c, new List<Approve_Action_Plan__c>{objAAP});
				else
					mapItemTypeTolstAAP.get(objAAP.Item_Type__c).add(objAAP);
				setEntityId.add(objAAP.Account__c);
				//Collect all SIP and Lumpsum product Name.	
				if(objAAP.Item_Type__c == 'SIP' || objAAP.Item_Type__c == 'Lumpsum')
				{
					System.debug('---------------Liumpsum rec--------------------------'+objAAP);
					setProductName.add(objAAP.Product_Name__c);
				}
			}
		}
		Map<Id, Account> mapIdToEntity = new Map<Id, Account>([Select Id, Parent_Entity__c from Account where Id IN : setEntityId]);		
		
		//retrieve all Products where Investment type either SIP or Lumpsum 
		List<Product_Master__c> lstSIPorLumpsumPM = [Select (Select Upfront_Commission__c, Trail_Commission__c from Commissions__r where Active__c = true limit 1), 
														Product_Name__c, ProductType__c, Investment_Type__c 
												   	From Product_Master__c 
												   	where Product_Name__c IN: setProductName and ProductType__c = 'Mutual Fund' and Is_Active__c = true];
		//ARPP record on SIP product 
		if(mapItemTypeTolstAAP.containsKey('SIP'))
		{
			mapProductNameToPM = new Map<String, Product_Master__c>();
			
			//Collect SIP product from commen list.
			for(Product_Master__c objPM : lstSIPorLumpsumPM)
				mapProductNameToPM.put(objPM.Product_Name__c, objPM);
					
			//Execute SIP Action Plan and create ARPP detail record for each.
			for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('SIP'))	
			{
				Product_Master__c objPM = mapProductNameToPM.get(objAAP.Product_Name__c);
				Commission__c objComm = objPM != null && objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null ;
				//ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
				ARPP_Detail__c objARPPDetail = new ARPP_Detail__c() ;
				if(objARPPDetail != null)
				{
					//Calcualte Action Plan Trail & Upfront Commission for SIP
					objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
					objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
					objARPPDetail.Commission__c = objComm != null? objComm.Id : null;
					
					Account objAcc = mapIdToEntity.get(objAAP.Account__c);
					objARPPDetail.Entity__c = objAcc.Parent_Entity__c != null? objAcc.Parent_Entity__c : objAcc.Id;
					
					objARPPDetail.Action_Plan_Amount__c = objAAP.Amount__c;
					objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null ? (objComm.Upfront_Commission__c * 12 * objAAP.Amount__c)/100 : 0;
					Double trailComm = 0;
					Double amount = objAAP.Amount__c;
					Integer installment = objAAP.Installments__c <= 12  ? Integer.valueOf(objAAP.Installments__c) : 12;
					system.debug('*************objPM******************'+objPM+'********objComm*****'+objComm);
					if(objPM != null && objComm != null )
						for(Integer i = 0; i < installment ; i++)
						{
							trailComm += (amount * objComm.Trail_Commission__c)/100;
							amount += objAAP.Amount__c;
						}
					objARPPDetail.Action_Plan_Trial_Comm_Amount__c = trailComm;
					
					objARPPDetail.Type__c = objAAP.Item_Type__c;
					objARPPDetail.Remark__c = (objPM == null ? Label.Expected_Product_Remark : (objComm == null ? Label.Expected_Commission_Remark : ''));
					
					lstARPPDetail.add(objARPPDetail);
					
					objAAP.Product__c = objPM != null ? objPM.Id : null;
					lstApproveActionPlan.add(objAAP);
				}
			}
		}
		
		//Lumpsum Product
		if(mapItemTypeTolstAAP.containsKey('Lumpsum'))
		{									
			mapProductNameToPM = new Map<String, Product_Master__c>();
			for(Product_Master__c objPM : lstSIPorLumpsumPM)
				mapProductNameToPM.put(objPM.Product_Name__c, objPM);
			
			for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('Lumpsum'))	
			{
				Product_Master__c objPM = mapProductNameToPM.get(objAAP.Product_Name__c);
				Commission__c objComm =  objPM != null && objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null ;
				//ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
				ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
				if(objARPPDetail != null)
				{
					//Calcualte Action Plan Trail & Upfront Commission for Lumpsum
					objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
					objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
					
					Account objAcc = mapIdToEntity.get(objAAP.Account__c);
					objARPPDetail.Entity__c = objAcc.Parent_Entity__c != null? objAcc.Parent_Entity__c : objAcc.Id;
							
					objARPPDetail.Commission__c = objComm != null? objComm.Id : null;
					
					objARPPDetail.Action_Plan_Amount__c = objAAP.Amount__c;
					objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null ? (objComm.Upfront_Commission__c  * objAAP.Amount__c)/100 : 0;
					objARPPDetail.Action_Plan_Trial_Comm_Amount__c =  objPM != null && objComm != null ? (objComm.Trail_Commission__c  * objAAP.Amount__c)/100 : 0;
					
					objARPPDetail.Type__c = objAAP.Item_Type__c;
					objARPPDetail.Remark__c = (objPM == null ? Label.Expected_Product_Remark : (objComm == null ? Label.Expected_Commission_Remark : ''));
					
					lstARPPDetail.add(objARPPDetail);
					
					objAAP.Product__c = objPM != null ? objPM.Id : null;
					lstApproveActionPlan.add(objAAP);
				}
			}
		}
		
		List<Product_Master__c> lstPM = [Select Product_Name__c, ProductType__c, Investment_Type__c, Policy_Type__c,
												(Select Upfront_Commission__c, Trail_Commission__c, Min_Year_Value__c, Max_Year_Value__c from Commissions__r where Active__c = true )
												From Product_Master__c 
												where (ProductType__c = 'General Insurance' OR ProductType__c = 'Life Insurance' ) and Is_Active__c = true];
		
		
		//Life Insurance Product
		if(mapItemTypeTolstAAP.containsKey('Life Insurance'))
		{		
			mapProductNameToPM = new Map<String, Product_Master__c>();
			for(Product_Master__c objPM : lstPM)
			{
				if(objPM.ProductType__c == 'Life Insurance')
				{
					System.debug('------------LI------------'+objPM.Product_Name__c + '~' + objPM.Policy_Type__c);
					//mapProductNameToPM.put(objPM.Product_Name__c + '~' + objPM.Policy_Type__c, objPM);
					mapProductNameToPM.put(objPM.Product_Name__c, objPM);
				}
			}
			for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('Life Insurance'))	
			{	
				//Product_Master__c objPM = mapProductNameToPM.get(objAAP.Policy_Name__c + '~' + objAAP.Insurance__r.Policy_Type__c);
				Product_Master__c objPM = mapProductNameToPM.get(objAAP.Policy_Name__c);
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
				
				//Calcualte Action Plan Trail & Upfront Commission for Life Insurance
				//ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
				ARPP_Detail__c objARPPDetail = new ARPP_Detail__c() ;
				if(objARPPDetail != null)
				{
					objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
					objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
					objARPPDetail.Commission__c = objComm != null? objComm.Id : null;
					
					Account objAcc = mapIdToEntity.get(objAAP.Account__c);
					objARPPDetail.Entity__c = objAcc.Parent_Entity__c != null? objAcc.Parent_Entity__c : objAcc.Id;
					
					objARPPDetail.Action_Plan_Amount__c = objAAP.Premium_Amount_Rs__c;
					objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null ?(objAAP.Premium_Amount_Rs__c != null ?(objComm.Upfront_Commission__c * objAAP.Premium_Amount_Rs__c)/100 : 0) : 0;
					objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
					
					objARPPDetail.Type__c = objAAP.Item_Type__c;
					objARPPDetail.Remark__c = (objPM == null ? Label.Expected_Product_Remark : (objComm == null ? Label.Expected_Commission_Remark : ''));
					
					lstARPPDetail.add(objARPPDetail);
					
					objAAP.Product__c = objPM != null ? objPM.Id : null;
					lstApproveActionPlan.add(objAAP);
				}
			}
		}
		
		//General Insurance Product
		if(mapItemTypeTolstAAP.containsKey('General Insurance'))
		{									
			mapProductNameToPM = new Map<String, Product_Master__c>();
			for(Product_Master__c objPM : lstPM)
			{
				if(objPM.ProductType__c == 'General Insurance')
					mapProductNameToPM.put(objPM.Product_Name__c, objPM);
			}
			
			//Calcualte Action Plan Trail & Upfront Commission
			for(Approve_Action_Plan__c objAAP : mapItemTypeTolstAAP.get('General Insurance'))	
			{
				Product_Master__c objPM = mapProductNameToPM.get(objAAP.Product_Name__c);
				Commission__c objComm =  objPM != null && objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null ;
				//ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
				ARPP_Detail__c objARPPDetail = new ARPP_Detail__c() ;
				if(objARPPDetail != null)
				{
					objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
					objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
					
					Account objAcc = mapIdToEntity.get(objAAP.Account__c);
					objARPPDetail.Entity__c = objAcc.Parent_Entity__c != null? objAcc.Parent_Entity__c : objAcc.Id;
					
					objARPPDetail.Commission__c = objComm != null? objComm.Id : null;
					
					objARPPDetail.Action_Plan_Amount__c = objAAP.Premium_Amount_Rs__c ;
					objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null ? (objAAP.Premium_Amount_Rs__c  != null ?(objComm.Upfront_Commission__c * objAAP.Premium_Amount_Rs__c )/100 : 0) : 0;
					objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
					
					objARPPDetail.Type__c = objAAP.Item_Type__c;
					objARPPDetail.Remark__c = (objPM == null ? Label.Expected_Product_Remark : (objComm == null ? Label.Expected_Commission_Remark : ''));
					
					lstARPPDetail.add(objARPPDetail);
					
					objAAP.Product__c = objPM != null ? objPM.Id : null;
					lstApproveActionPlan.add(objAAP);
				}
			}
		}
		
		//Insert Arpp Detail Record
		if(!lstARPPDetail.isEmpty())
			insert lstARPPDetail;
		
		//Update Action Plan Record	
		/*if(!lstApproveActionPlan.isEmpty()) 
		{
		    isRecursive = true;
			update lstApproveActionPlan;
			isRecursive = false;
	    }*/
			
	}
	
	//Create ARPP for Running SIP and Lumpsum Action Plan 
	public void onAfterInsertForARPPWithRunningSIPandLumpsum(Map<Id, Approve_Action_Plan__c> mapNewIdToActionPlan)
	{
		
		List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
		Set<Id> setAAPId = new Set<Id>();
		Set<Id> setEntityId = new Set<Id>();
		Map<Id, List<ARPP_Detail__c>> mapAPIdTolstARPPDetail = new Map<Id, List<ARPP_Detail__c>>();
		List<ARPP_Detail__c> lstARPP = [select Id, Action_Amount_Revenue__c, Entity__c, Type__c, Execution_Tracker_Total_Revenue__c,Approve_Action_Plan__c,
											Action_Plan_Amount__c,  Action_Plan_Upfront_Comm_Amount__c, Action_Plan_Trial_Comm_Amount__c,
											Execution_Tracker_Amount__c, Execution_Tracker_upfront_Comm_Amount__c, Execution_Tracker_Trial_Comm_Amount__c from ARPP_Detail__c
											where Approve_Action_Plan__c IN : mapNewIdToActionPlan.keySet()];
			
		for(ARPP_Detail__c objARPP : lstARPP)
		{
			if(!mapAPIdTolstARPPDetail.containsKey(objARPP.Approve_Action_Plan__c))
				mapAPIdTolstARPPDetail.put(objARPP.Approve_Action_Plan__c , new List<ARPP_Detail__c>{objARPP});
			else
				mapAPIdTolstARPPDetail.get(objARPP.Approve_Action_Plan__c).add(objARPP);
		}
		
		for(Approve_Action_Plan__c objAAP : mapNewIdToActionPlan.values())
		{
			/*if((objAAP.Investment_Asset__c != null && objAAP.Lumpsum_Action__c != null && objAAP.Lumpsum_Action__c != 'Switch Out' && objAAP.Lumpsum_Action__c != 'Hold - Change of Broker'
						&& objAAP.Lumpsum_Action__c != 'Redeem' && objAAP.Lumpsum_Action__c != 'Hold - Existing Fund' && objAAP.isExecutionTracker__c) 
						|| (objAAP.Investment_Asset__c != null && objAAP.SIP_Action__c != 'Stop' && objAAP.SIP_Action__c !='Continue - Existing SIP' && objAAP.isSIPexecutionTracker__c) )*/
			
			if((objAAP.Asset_Name__c == null || objAAP.Asset_Name__c == '') && ((objAAP.Investment_Asset__c != null  && objAAP.isExecutionTracker__c) 
						|| (objAAP.Investment_Asset__c != null  && objAAP.isSIPexecutionTracker__c)) )
			{
				lstApproveActionPlan.add(objAAP);
				setAAPId.add(objAAP.Id);
				setEntityId.add(objAAP.Account__c);
			}
		}
		Map<Id, Account> mapIdToEntity = new Map<Id, Account>([Select Id, Parent_Entity__c from Account where Id IN : setEntityId]);
		Set<String> setAllProductName = new Set<String>();
		
		for(Product_Master__c objPM : [Select Product_Name__c from Product_Master__c where ProductType__c = 'Mutual Fund'])
		{
			setAllProductName.add(objPM.Product_Name__c);
		}
		
		//local variables
		List<ARPP_Detail__c> lstARPPDetail = new List<ARPP_Detail__c>();
		Map<String, Product_Master__c> mapProductNameToPM = new Map<String, Product_Master__c>();
		List<Approve_Action_Plan__c> lstUpdateApproveActionPlan = new List<Approve_Action_Plan__c>();
		List<Approve_Action_Plan__c> lstAAP = new List<Approve_Action_Plan__c>();
		
		String strQuery = ' Select Insurance__r.Policy_Type__c, ';
		Map<String, Schema.SObjectField> mapAAPFieldNameToFieldDescribe = Approve_Action_Plan__c.sObjectType.getDescribe().fields.getMap();
		
		//Create Dynamic query
		for(String strField : mapAAPFieldNameToFieldDescribe.keySet())
		{
			strQuery += strField +',';
		}
		strQuery = strQuery.substring(0, strQuery.length() - 1);
		strQuery += ' from Approve_Action_Plan__c where Id IN: setAAPId  ';	
		
		Set<String> setProductName = new Set<String>();
		
		//Execute query and create map of Item type to Action Plan .
		lstAAP =  Database.query(strQuery);
 		for(Approve_Action_Plan__c objAAP : lstAAP)
		{
			setProductName.add(objAAP.Scheme_Name__c);
		}
		
		//retrieve all Products where Investment type either SIP or Lumpsum 
		List<Product_Master__c> lstMutualFundPM = [Select (Select Upfront_Commission__c, Trail_Commission__c from Commissions__r where Active__c = true limit 1), 
														Product_Name__c, ProductType__c, Investment_Type__c 
												   	From Product_Master__c 
												   	where Product_Name__c IN: setProductName and ProductType__c = 'Mutual Fund' and Is_Active__c = true];
		//Collect SIP product from commen list.
		for(Product_Master__c objPM : lstMutualFundPM)
			mapProductNameToPM.put(objPM.Product_Name__c, objPM);
		System.debug('------------------lstAAP-------'+lstAAP);
		for(Approve_Action_Plan__c objAAP : lstAAP)	
		{
			if((objAAP.Investment_Asset__c != null && objAAP.isExecutionTracker__c)  && objAAP.isExecutionTracker__c && setAllProductName.contains(objAAP.Scheme_Name__c))
			{
				Boolean isAvailable = false;
				if(mapAPIdTolstARPPDetail.containsKey(objAAP.Id) )
					for(ARPP_Detail__c objARPP : mapAPIdTolstARPPDetail.get(objAAP.Id))
						if(objARPP.Type__c == 'Lumpsum')
						{
							isAvailable = true;
							break;
						}
				if(isAvailable)
					continue;
				Product_Master__c objPM = mapProductNameToPM.get(objAAP.Scheme_Name__c);
				Commission__c objComm =  objPM != null && objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null ;
			    ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
			    
			    objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
				objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
				
				Account objAcc = mapIdToEntity.get(objAAP.Account__c);
				objARPPDetail.Entity__c = objAcc.Parent_Entity__c != null? objAcc.Parent_Entity__c : objAcc.Id;
				
				objARPPDetail.Commission__c = objComm != null? objComm.Id : null;
				objARPPDetail.Type__c = 'Lumpsum';
				objARPPDetail.Action_Plan_Amount__c = objAAP.Action_Amount__c ;
				objARPPDetail.Remark__c = (objPM == null ? Label.Expected_Product_Remark : (objComm == null ? Label.Expected_Commission_Remark : ''));
				
				objAAP.Product__c = objPM != null ? objPM.Id : null;
				lstUpdateApproveActionPlan.add(objAAP);
				
				if(objAAP.Lumpsum_Action__c == 'STP From')
				{
					objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null  
																		? (objAAP.Action_Amount__c  != null ?(objComm.Upfront_Commission__c * objAAP.Action_Amount__c )/100 : 0) 
																		: 0;
					objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
				}
				else if(objAAP.Lumpsum_Action__c == 'STP To' || objAAP.Lumpsum_Action__c ==  'Switch In')
				{
					objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null  
																		? (objAAP.Action_Amount__c  != null ?(objComm.Upfront_Commission__c * objAAP.Action_Amount__c  )/100 : 0) 
																		: 0;
					
					objARPPDetail.Action_Plan_Trial_Comm_Amount__c = objPM != null && objComm != null  
																	 ? (objAAP.Action_Amount__c  != null ?(objComm.Trail_Commission__c * objAAP.Action_Amount__c  )/100 : 0) 
																	 : 0;
				}
				else if(objAAP.Lumpsum_Action__c == 'Hold' )
				{
					objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = 0;
					
					objARPPDetail.Action_Plan_Trial_Comm_Amount__c = objPM != null && objComm != null  
																	 ? (objAAP.Action_Amount__c  != null ?(objComm.Trail_Commission__c * objAAP.Action_Amount__c  )/100 : 0) 
																	 : 0;
				}
				else
				{
					objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = 0;
					objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
				}
				
				lstARPPDetail.add(objARPPDetail);
				System.debug('-------------lstARPPDetail---Lumpsum------------'+lstARPPDetail);
			}
		}
		
		//if(!lstUpdateApproveActionPlan.isEmpty())
			//update lstUpdateApproveActionPlan;
		
		lstUpdateApproveActionPlan = new List<Approve_Action_Plan__c>();	
		for(Approve_Action_Plan__c objAAP : lstAAP)	
		{
			if((objAAP.Investment_Asset__c != null 
					 && objAAP.isSIPexecutionTracker__c) && objAAP.isSIPexecutionTracker__c && setAllProductName.contains(objAAP.Scheme_Name__c) && !objAAP.isNewMutualFund__c)
			{
				Boolean isAvailable = false;
				if(mapAPIdTolstARPPDetail.containsKey(objAAP.Id) )
					for(ARPP_Detail__c objARPP : mapAPIdTolstARPPDetail.get(objAAP.Id))
						if(objARPP.Type__c == 'SIP')
						{
							isAvailable = true;
							break;
						}
				if(isAvailable)
					continue;
						
				System.debug('----------objAAP Sip----------------'+objAAP);
				Product_Master__c objPM = mapProductNameToPM.get(objAAP.Scheme_Name__c);
				Commission__c objComm =  objPM != null && objPM.Commissions__r.size() > 0 ? objPM.Commissions__r[0] : null ;
			    ARPP_Detail__c objARPPDetail = new ARPP_Detail__c();
			    
			    objARPPDetail.Approve_Action_Plan__c = objAAP.Id;
				objARPPDetail.Product__c = objPM != null ? objPM.Id : null;
				
				Account objAcc = mapIdToEntity.get(objAAP.Account__c);
				objARPPDetail.Entity__c = objAcc.Parent_Entity__c != null? objAcc.Parent_Entity__c : objAcc.Id;
				
				objARPPDetail.Commission__c = objComm != null? objComm.Id : null;
				objARPPDetail.Type__c = 'SIP';
				objARPPDetail.Action_Plan_Amount__c = objAAP.SIP_Action_Amount__c ;
				objARPPDetail.Remark__c = (objPM == null ? Label.Expected_Product_Remark : (objComm == null ? Label.Expected_Commission_Remark : ''));
				
				objAAP.Product__c = objPM != null ? objPM.Id : null;
				lstUpdateApproveActionPlan.add(objAAP);
				
				if(objAAP.SIP_Action__c == 'Existing SIP - COB' || objAAP.SIP_Action__c == 'Continue')
				{
					objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = objPM != null && objComm != null  
																	? (objAAP.Action_Amount__c  != null ?(objComm.Upfront_Commission__c * objAAP.SIP_Action_Amount__c * 12 )/100 : 0) 
																	: 0;
					Double trailComm = 0;
					Double amount = objAAP.SIP_Action_Amount__c;
					
					Integer installment = objAAP.Installments__c <= 12  ? Integer.valueOf(objAAP.Installments__c) : 12;
					system.debug('*************objPM1******************'+objPM+'********objComm1*****'+objComm);
					if(objPM != null && objComm != null )
					{
						for(Integer i = 0; i < installment ; i++)
						{
							trailComm += (amount * objComm.Trail_Commission__c)/100;
							amount += objAAP.SIP_Action_Amount__c;
						}
					}
					objARPPDetail.Action_Plan_Trial_Comm_Amount__c = trailComm;
				}
				else
				{
					objARPPDetail.Action_Plan_Upfront_Comm_Amount__c = 0;
					objARPPDetail.Action_Plan_Trial_Comm_Amount__c = 0;
				}
				lstARPPDetail.add(objARPPDetail);
			}
		} 
		System.debug('--------lstARPPDetail-----before insert---------------------'+lstARPPDetail);
		if(!lstARPPDetail.isEmpty())
			insert lstARPPDetail;
			
		//if(!lstUpdateApproveActionPlan.isEmpty())
			//update lstUpdateApproveActionPlan;
	}
	//Delete ARPP Detail record related to Approve Action Plan 
	public void onBeforeDeleteForARPPCalculation(Map<Id, Approve_Action_Plan__c> mapOldIdToActionPlan)
	{
		List<ARPP_Detail__c> lstARPPDetail = [Select Id from ARPP_Detail__c where Approve_Action_Plan__c IN : mapOldIdToActionPlan.keySet()];
		if(!lstARPPDetail.isEmpty())
			delete lstARPPDetail;
	}
	
	//Method call from Execution tracker Trigger to calculate ARPP for Executed Amount.
	public void onAfterInsertAndUpdateForARPPCalculation(Map<Id, Execution_Tracker__c> mapNewIdToET, Map<Id, Execution_Tracker__c> mapOldIdToET)
	{
		List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
		Set<Id> setAPId = new Set<Id>();
		Map<Id,ARPP_Detail__c>mapAPIdToARPPDetailNew = new Map<Id,ARPP_Detail__c>();
		
		List<ARPP_Detail__c> lstUpdateARPPDetail = new List<ARPP_Detail__c>();
		
		//Collect Approve Action plan Id and Execution Tracker record
		if(mapOldIdToET != null)
			for(Execution_Tracker__c objET : mapNewIdToET.values())
			{
				if(objET.Application_Status__c == 'Closed' || (objET.Application_Status__c == '' || objET.Application_Status__c == null))
				{
					lstET.add(objET);
					setAPId.add(objET.Approve_Action_Plan__c);
				}
			}
		else
			for(Execution_Tracker__c objET : mapNewIdToET.values())
			{
				if(objET.ParentExecutionTracker__c == null)
				{
					lstET.add(objET);
					setAPId.add(objET.Approve_Action_Plan__c);
				}
			}
		
		Map<Id, List<ARPP_Detail__c>> mapAPIdTolstARPPDetail = new Map<Id, List<ARPP_Detail__c>>();
		List<ARPP_Detail__c> lstARPPDetail = [Select Id,Name,
													Actual_Commission__c,
													Actual_Commission__r.Upfront_Commission__c,
													Actual_Commission__r.Trail_Commission__c,
													Product__r.Policy_Type__c, 
											        Product__r.ProductType__c, 
											        Product__r.Product_Name__c, Product__c,
											        Execution_Tracker_Actual_Product__c,
											        Execution_Tracker_upfront_Comm_Amount__c, 
											        Approve_Action_Plan__c,Approve_Action_Plan__r.Installments__c,
											        Approve_Action_Plan__r.Investment_Asset__c, 
											        Approve_Action_Plan__r.SIP_Action__c,
											        Approve_Action_Plan__r.Lumpsum_Action__c,
											        Approve_Action_Plan__r.Item_Type__c, 
											        Action_Plan_Upfront_Comm_Amount__c, 
											        Action_Plan_Trial_Comm_Amount__c, 
											        Action_Plan_Amount__c, Type__c,
											        Execution_Tracker_Amount__c
	      											From ARPP_Detail__c Where Approve_Action_Plan__c IN: setAPId];	
      											
      	//Create Map Approve Action Plan to ARPP Detail											
		for(ARPP_Detail__c objAD : lstARPPDetail )
		{
			 //mapAPIdToARPPDetail.put(objAD.Approve_Action_Plan__c , objAD);
			
			if(!mapAPIdTolstARPPDetail.containsKey(objAD.Approve_Action_Plan__c))
				mapAPIdTolstARPPDetail.put(objAD.Approve_Action_Plan__c , new List<ARPP_Detail__c>{objAD});
			else
				mapAPIdTolstARPPDetail.get(objAD.Approve_Action_Plan__c).add(objAD);
		} 
		
		for(Execution_Tracker__c objET : lstET)
		{
			//Calcualte Execution Tracker trail Commission
			if(mapAPIdTolstARPPDetail.containsKey(objET.Approve_Action_Plan__c))
			{
				system.debug('**********objET.Type__c*******'+objET.Type__c);
				system.debug('*********RPP*******'+mapAPIdTolstARPPDetail.get(objET.Approve_Action_Plan__c));
				for(ARPP_Detail__c objARPPDetail : mapAPIdTolstARPPDetail.get(objET.Approve_Action_Plan__c))
				{
					if(objARPPDetail.Type__c == objET.Type__c)
					{
						objARPPDetail.Execution_Tracker_Amount__c += (objET.Executed_Amount__c != null ? objET.Executed_Amount__c : 0);
						if(objARPPDetail != null)
						{
							if(objARPPDetail.Type__c == 'SIP')
							{
								
								objARPPDetail.Execution_Tracker_upfront_Comm_Amount__c = objARPPDetail.Execution_Tracker_Actual_Product__c != null && objARPPDetail.Actual_Commission__c != null
																						 ? (objARPPDetail.Actual_Commission__r.Upfront_Commission__c * 12 * objARPPDetail.Execution_Tracker_Amount__c)/100 
																						 : 0;
								Double trailComm = 0;
								Double amount = objARPPDetail.Execution_Tracker_Amount__c;
								Integer installment = objARPPDetail.Approve_Action_Plan__r.Installments__c <= 12  
														? Integer.valueOf(objARPPDetail.Approve_Action_Plan__r.Installments__c) 
														: 12;
								
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
								system.debug('**********Investment_Asset__c*******'+objARPPDetail.Approve_Action_Plan__r.Investment_Asset__c);
								system.debug('**********Investment_Asset__c*******'+objARPPDetail.Approve_Action_Plan__r.Lumpsum_Action__c);
								if(objARPPDetail.Approve_Action_Plan__r.Investment_Asset__c != null)
								{
									if(objARPPDetail.Approve_Action_Plan__r.Lumpsum_Action__c == 'STP From')
									{
										objARPPDetail.Execution_Tracker_upfront_Comm_Amount__c = objARPPDetail.Execution_Tracker_Actual_Product__c != null  && objARPPDetail.Actual_Commission__c != null 
																								 ? (objARPPDetail.Actual_Commission__r.Upfront_Commission__c  * objARPPDetail.Execution_Tracker_Amount__c)/100 
																								 : 0;
										objARPPDetail.Execution_Tracker_Trial_Comm_Amount__c = 0;
									}
									else if(objARPPDetail.Approve_Action_Plan__r.Lumpsum_Action__c == 'STP To' || objARPPDetail.Approve_Action_Plan__r.Lumpsum_Action__c ==  'Switch In')
									{
										objARPPDetail.Execution_Tracker_upfront_Comm_Amount__c = objARPPDetail.Execution_Tracker_Actual_Product__c != null  && objARPPDetail.Actual_Commission__c != null 
																								 ? (objARPPDetail.Actual_Commission__r.Upfront_Commission__c * objARPPDetail.Execution_Tracker_Amount__c)/100 
																								 : 0;
										objARPPDetail.Execution_Tracker_Trial_Comm_Amount__c = objARPPDetail.Execution_Tracker_Actual_Product__c != null  && objARPPDetail.Actual_Commission__c != null 
																							? (objARPPDetail.Actual_Commission__r.Trail_Commission__c  * objARPPDetail.Execution_Tracker_Amount__c)/100 
																							: 0;
									}
									else if(objARPPDetail.Approve_Action_Plan__r.Lumpsum_Action__c == 'Hold')
									{
										objARPPDetail.Execution_Tracker_upfront_Comm_Amount__c = 0;
										objARPPDetail.Execution_Tracker_Trial_Comm_Amount__c = objARPPDetail.Execution_Tracker_Actual_Product__c != null  && objARPPDetail.Actual_Commission__c != null 
																							? (objARPPDetail.Actual_Commission__r.Trail_Commission__c * objARPPDetail.Execution_Tracker_Amount__c)/100 
																							: 0;
									}
								}
								else
								{
									objARPPDetail.Execution_Tracker_upfront_Comm_Amount__c = objARPPDetail.Execution_Tracker_Actual_Product__c != null  && objARPPDetail.Actual_Commission__c != null 
																							 ? (objARPPDetail.Actual_Commission__r.Upfront_Commission__c * objARPPDetail.Execution_Tracker_Amount__c)/100 
																							 : 0;
									objARPPDetail.Execution_Tracker_Trial_Comm_Amount__c = objARPPDetail.Execution_Tracker_Actual_Product__c != null  && objARPPDetail.Actual_Commission__c != null 
																						? (objARPPDetail.Actual_Commission__r.Trail_Commission__c * objARPPDetail.Execution_Tracker_Amount__c)/100 
																						: 0;
								}
							}
							else if(objARPPDetail.Type__c == 'Life Insurance' || objARPPDetail.Type__c == 'General Insurance')
							{
								objARPPDetail.Execution_Tracker_upfront_Comm_Amount__c = objARPPDetail.Execution_Tracker_Actual_Product__c != null  && objARPPDetail.Actual_Commission__c != null 
																						  ? (objARPPDetail.Actual_Commission__r.Upfront_Commission__c * objARPPDetail.Execution_Tracker_Amount__c)/100 
																						  : 0;
								objARPPDetail.Execution_Tracker_Trial_Comm_Amount__c = 0;
							}
							
							if(objET.ParentExecutionTracker__c == null)
								objARPPDetail.Execution_Tracker__c = objET.Id;			
							//lstUpdateARPPDetail.add(objARPPDetail);
							mapAPIdToARPPDetailNew.put(objARPPDetail.Id, objARPPDetail);
						}
					}
				}
			}
		}
		
		//Update ARPP Detail Record
		//if(!lstUpdateARPPDetail.isEmpty())
		//	update lstUpdateARPPDetail;
		if(!mapAPIdToARPPDetailNew.isEmpty())
			update mapAPIdToARPPDetailNew.values();
	}
	
	
	//Method call On Before Insert of ET record and fetch Product from corresponding AP's ARPP record and assign into ET's field. 
	public void onBeforeInsertForAddProductWithET(List<Execution_Tracker__c> lstNewET)
	{
		List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>();
		List<ARPP_Detail__c> lstUpdateARPPDetail = new List<ARPP_Detail__c>();
		Map<Id,ARPP_Detail__c>mapAPIdToARPPDetail = new Map<Id,ARPP_Detail__c>();
		Set<Id> setAPId = new Set<Id>();
		//Collect Approve Action plan Id and Execution Tracker record
		for(Execution_Tracker__c objET : lstNewET)
		{
			if(objET.ParentExecutionTracker__c == null)
				setAPId.add(objET.Approve_Action_Plan__c);
		}
		Map<Id, List<ARPP_Detail__c>> mapAPIdTolstARPPDetail = new Map<Id, List<ARPP_Detail__c>>();
      											
      	//Create Map Approve Action Plan to ARPP Detail											
		for(ARPP_Detail__c objAD : [Select  Name, Id, Product__r.Policy_Type__c, Product__r.Investment_Type__c, 
						          			Product__r.Product_Manufacturer__c,
									        Commission__r.Upfront_Commission__c, Commission__r.Trail_Commission__c, 
									        Product__r.ProductType__c, 
									        Product__r.Product_Name__c, Product__c, 
									        Actual_Commission__c,
									        Execution_Tracker_upfront_Comm_Amount__c, 
									        Entity__c, Entity__r.Name, Approve_Action_Plan__c, Approve_Action_Plan__r.Item_Type__c, Action_Plan_Upfront_Comm_Amount__c, 
									        Action_Plan_Trial_Comm_Amount__c, Action_Plan_Amount__c, Type__c,
									        Approve_Action_Plan__r.Installments__c,Execution_Tracker_Amount__c,
									        Execution_Tracker__r.Execution_Tracker_Product__c
  											From ARPP_Detail__c Where Approve_Action_Plan__c IN: setAPId] )
		{
			if(!mapAPIdTolstARPPDetail.containsKey(objAD.Approve_Action_Plan__c))
				mapAPIdTolstARPPDetail.put(objAD.Approve_Action_Plan__c , new List<ARPP_Detail__c>{objAD});
			else
				mapAPIdTolstARPPDetail.get(objAD.Approve_Action_Plan__c).add(objAD);
		} 
		
		for(Execution_Tracker__c objET : lstNewET)
		{
			if(mapAPIdTolstARPPDetail.containsKey(objET.Approve_Action_Plan__c))
			{
				for(ARPP_Detail__c objARPPDetail : mapAPIdTolstARPPDetail.get(objET.Approve_Action_Plan__c))
				{
					if(objARPPDetail.Type__c == objET.Type__c)
					{
						objET.Agreed_Product__c = objARPPDetail.Product__c;
						objET.Execution_Tracker_Product__c = objARPPDetail.Product__c;
						
						//Update ARPP Deatail fields with Actual product and commisson 
						objARPPDetail.Actual_Commission__c = objARPPDetail.Commission__c;
						if(objARPPDetail.Product__c == null )
							objARPPDetail.ET_Remark__c = objARPPDetail.Product__c == null ? Label.Actual_Product : '';
						else 
							objARPPDetail.ET_Remark__c = objARPPDetail.Commission__c == null ? Label.Actual_Commission : '';
						objARPPDetail.Execution_Tracker_Actual_Product__c = objARPPDetail.Product__c;
						//lstUpdateARPPDetail.add(objARPPDetail);
						mapAPIdToARPPDetail.put(objARPPDetail.Id, objARPPDetail);
					}
				}
			}
		}
		
		if(!mapAPIdToARPPDetail.isEmpty())
			update mapAPIdToARPPDetail.values();
	}
	
	//Delete ARPP Detail while deleting ET. ETs are deleting based on Clone and New button funtionality on Action Plan.
	public void onBeforeDeleteForARPPCalculation(Map<Id, Execution_Tracker__c> mapOldIdToET)
	{
		List<ARPP_Detail__c> lstARPPDetail = [Select Id from ARPP_Detail__c where Execution_Tracker__c IN : mapOldIdToET.keySet()];
		if(!lstARPPDetail.isEmpty())
			delete lstARPPDetail;
	}
}