/*
	Revision History:
	
  	Version     Version Author     Date        Comments
   	1.0         Persistent         NA  		  	Initial Draft
   	2.0			Eternus			   17/05/2011	Modified the fetchInvestmentAssetsRecords() method to update the logic for classfication
    											in Equity and Debt. Implemented logic is,
    											1. If invAsset.RecordType.Name = 'Fixed Income' then, 'Debt'
    											2. If invAsset.RecordType.Name = 'Stocks' then, 'Equity'
    											3. If invAsset.RecordType.Name = 'Mutual Fund' then, classify into Equity or Debt based on whether
    											   it exists in EquityList or DebtList or Gold 
	2.0			Manasi			   06/06/2011 	Added check for null values before using them in calculation in,getPortfolioSummary() function
	2.0         Niket              11/06/2011   Added the new two arrays in the "fetchInvestmentAssetsRecords" method.
												1] arrMutualFundEquity
												2] arrMutualFunddebt
												
												Created the new method ClassifyDebtEquity :
												Summary : This fundtion accepts the Array of asset class and check the 
					 									  provided AssetType is Equity or Debt.
	
	2.0        Niket Chandane     14/06/2011  : 
												1] Update the Funcion "fetchInvestmentAssetsRecords"
												Summary: Update the logic to Classify the AssetType for Debt and Equity.
												2] Update the Funcion "updatePortfolioBean"
												Summary : Update the logical conditions for the calculation for Debt 
														  and Equity.
    2.0        Manasi Ranade     19/1/2012  :  Change in functions : fetchInvestmentAssetsRecords , ClassifyDebtEquity
    										   Added Check for Null before using value
    2.0        Manasi Ranade     1/2/2012   :   Issue Id: 00001470  For Lumpsum calculation used Equity %, Debt %,Gold % from SIP of related Goal
    2.0        Manasi Ranade     28/3/2012   :   Issue Id: 00001556  As the getgoalSIPAmtMap function was called from Loop.So Commented the Original Code
				  								And Added One method to Fill Map of Goal VS GoalSIPAmount List.And return the required List
*/
public class NewPortfolioSummaryService 
{
	
	private DatabaseDML databaseAccess = new DatabaseDML();
    private DatabaseSOQL databaseObj = new DatabaseSOQL();
    private Map<Id,List<GoalSIPAmount__c>> goalSipAmountMap{get;set;}
	public Double totalAsset {get;set;}
	
	//13Feb2012
	public Double totalAssetSuggested {get;set;}
	private void setInfoMessage(String str) 
	{
		ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,str));																			
	}
	public NewPortfolioSummaryService()
	{
		Map<Id,List<GoalSIPAmount__c>> goalSipAmountMap = StaticMethodClass.getgoalSIPAmtMap;
	}
	
	private void fetchAssetsRecords(String entityId, AssetAllocationBean assetAllocationBean) 
	{
		
		AssetAllocationBean.AssetRecordTypeBean assetRecordTypeBean;
		AssetAllocationBean.AssetTypeBean assetTypeBean;
		AssetAllocationBean.AssetDetailBean assetDetailBean;
		AssetAllocationBean.GoalAssetMapping goalAssetMapping;
				
		List<GoalAssetAssociation__c> assetGoalAssociationInDB;
		List<Asset__c> assetList;
		ID recordTypeId;
		String assetType,tempAssetType;
		Double currentValue;
		Map<ID,List<GoalAssetAssociation__c>> goalAssetMappingMap = getAssetGoalAssociationMapping(entityId);
		assetList = databaseObj.getAssetsForPortfolio(entityId);
		for(Asset__c asset : assetList)
		{
			if(asset.recordTypeId != recordTypeId) 
			{
				assetRecordTypeBean = assetAllocationBean.populateRecordTypeBeanList('Asset',asset.RecordType.Name);
				recordTypeId = asset.recordTypeId;
				assetTypeBean = null;
			}
			
			if(AssetBean.assetTypeList[1].equals(asset.RecordType.Name) || AssetBean.assetTypeList[2].equals(asset.RecordType.Name)||
				AssetBean.assetTypeList[4].equals(asset.RecordType.Name) || AssetBean.assetTypeList[6].equals(asset.RecordType.Name))
			{
				tempAssetType = asset.Account_Type__c;
			}
			else
			{
				tempAssetType = asset.Asset_Types__c;
			}
			
			currentValue = asset.Monthly_Asset__c;		
			if((tempAssetType == null) ) 
			{
				setInfoMessage('Account/Asset Type is NULL for some assets');
				continue;
			}
			if(currentValue == null) 
			{
				setInfoMessage('Current Value/Balance is not valid for some assets');
				continue;
			}
			
			if(!tempAssetType.equals(assetType))
			{
				assetTypeBean = assetRecordTypeBean.populateAssetTypeBeanList(tempAssetType);
				assetType = tempAssetType;
			}
			
			assetDetailBean = assetTypeBean.populateAssetDetailList(asset.Entity__r.Name,'',currentValue,asset.action__c,asset.id);
			assetGoalAssociationInDB  = goalAssetMappingMap.get(asset.id);
			String goalId;
			if(assetGoalAssociationInDB != null)
			{
				/** Eternus Solutions       **/
				/** Author  : Manasi Ranade **/
				/** Issue Id: 00001470     	**/
				/** Date    : 1/2/2012  	**/
				/** Purpose : Code to fetch Goal Ids
				/****************************************************/
				Set<Id> idSet = new Set<Id>();
				for(GoalAssetAssociation__c objGoalAssetAssociation : assetGoalAssociationInDB )
				{
					idSet.add(objGoalAssetAssociation.Goal__c);
				}
				/*List<GoalSIPAmount__c> goalSIPAmountList = [Select GoldCurrentYear__c,EquityCurrentYear__c,DebtCurrentYear__c,goal__c From GoalSIPAmount__c 
											Where goal__c in : idSet
											and Goal_Year__c =: system.today().Year()];*/
				/** Eternus Solutions       **/
				/** Author  : Manasi Ranade **/
				/** Issue Id: 00001556     	**/
				/** Date    : 28/3/2012  	**/
				/** Purpose : Assign entity Id to the StaticMethodClass.entityId
				/****************************************************/
				StaticMethodClass.entityId = entityId;
				Map<id,GoalSIPAmount__c> goalSIPAmtMap = getgoalSIPAmtMap(idSet);//new Map<id,GoalSIPAmount__c>();
				/*for(GoalSIPAmount__c objGoalSIPAmount : [Select GoldCurrentYear__c,EquityCurrentYear__c,DebtCurrentYear__c,goal__c From GoalSIPAmount__c 
											Where goal__c in : idSet
											and Goal_Year__c =: system.today().Year()])
				{
					if(goalSIPAmtMap.get(objGoalSIPAmount.Goal__c) == null)
			        {
			            goalSIPAmtMap.put(objGoalSIPAmount.Goal__c, objGoalSIPAmount);
			        }
				}*/
				system.debug('****goalSIPAmtMap**in Asset func*'+goalSIPAmtMap);
				for(GoalAssetAssociation__c goalAssetAssociation : assetGoalAssociationInDB ) 
				{
					goalAssetMapping = new AssetAllocationBean.GoalAssetMapping();
                	goalAssetMapping.assetAllocated =''+ goalAssetAssociation.allocated__c;
                	goalAssetMapping.goalId = goalId;
                	goalAssetMapping.goalAssetAssociationId = goalAssetAssociation.Id;
                	/** Eternus Solutions       **/
					/** Author  : Manasi Ranade **/
					/** Issue Id: 00001470     	**/
					/** Date    : 1/2/2012  	**/
					/** Purpose : Commented the original Code and Fetched the Equity %, Debt %,Gold % from SIP Object
					/****************************************************/
                	/*goalAssetMapping.goldAllocatedPercent = goalAssetAssociation.goal__r.SelectedGoalProfile__r.gold_allocation__c;
                	goalAssetMapping.debtAllocatedPercent = goalAssetAssociation.goal__r.SelectedGoalProfile__r.debt_allocation__c;
                	goalAssetMapping.equityAllocatedPercent = goalAssetAssociation.goal__r.SelectedGoalProfile__r.equity_allocation__c;*/
                	if(goalSIPAmtMap != null && goalSIPAmtMap.size() > 0 && goalSIPAmtMap.get(goalAssetAssociation.goal__c) != null)
                	{
						GoalSIPAmount__c objSelectedGoalSIPAmounts = goalSIPAmtMap.get(goalAssetAssociation.goal__c);
						Double dblGoldValue = (objSelectedGoalSIPAmounts.GoldCurrentYear__c != null ? objSelectedGoalSIPAmounts.GoldCurrentYear__c : 0);
						Double dblDebtValue = (objSelectedGoalSIPAmounts.DebtCurrentYear__c != null ? objSelectedGoalSIPAmounts.DebtCurrentYear__c : 0);
						Double dblEquityValue = (objSelectedGoalSIPAmounts.EquityCurrentYear__c != null ? objSelectedGoalSIPAmounts.EquityCurrentYear__c : 0);
						
						double dblTotal = dblGoldValue + dblDebtValue + dblEquityValue;
	                	if(dblTotal > 0)
	                	{
	                		goalAssetMapping.goldAllocatedPercent = objSelectedGoalSIPAmounts.GoldCurrentYear__c / dblTotal * 100;
		                	goalAssetMapping.debtAllocatedPercent = objSelectedGoalSIPAmounts.DebtCurrentYear__c / dblTotal * 100;
		                	goalAssetMapping.equityAllocatedPercent = objSelectedGoalSIPAmounts.EquityCurrentYear__c / dblTotal * 100;
	                	}
	                	else
	                	{
		                	goalAssetMapping.goldAllocatedPercent = 0;
		                	goalAssetMapping.debtAllocatedPercent = 0;
		                	goalAssetMapping.equityAllocatedPercent = 0;
	                	}
                	}
                	else
                	{
                		goalAssetMapping.goldAllocatedPercent = 0;
	                	goalAssetMapping.debtAllocatedPercent = 0;
	                	goalAssetMapping.equityAllocatedPercent = 0;
                	}
                	if(goalAssetAssociation.Allocated__c != null) {
                		assetDetailBean.allocatedPercent =''+ (Decimal.valueOf(assetDetailBean.allocatedPercent) + goalAssetAssociation.Allocated__c);
                	}
            		assetDetailBean.populateGoalAssetMappingList(goalAssetMapping);
            	}
			}
		}
	}
	
	/** Eternus Solutions       **/
	/** Author  : Manasi Ranade **/
	/** Issue Id: 00001470     	**/
	/** Date    : 1/2/2012  	**/
	/** Purpose : Method to generate Goal SIP AMount MAP
	/****************************************************/
	/** Eternus Solutions       **/
	/** Author  : Manasi Ranade **/
	/** Issue Id: 00001556     	**/
	/** Date    : 28/3/2012  	**/
	/** Purpose : As the getgoalSIPAmtMap function was called from Loop.So Commented the Original Code
				  And Added One method to Fill Map of Goal VS GoalSIPAmount List.And return the required List
	/****************************************************/
	private Map<id, GoalSIPAmount__c> getgoalSIPAmtMap(Set<Id> idSet)
	{
		//00001556 Commented Original Code
		
		/*Map<id,GoalSIPAmount__c> goalSIPAmtMap = new Map<id,GoalSIPAmount__c>();
		for(GoalSIPAmount__c objGoalSIPAmount : [Select GoldCurrentYear__c,EquityCurrentYear__c,DebtCurrentYear__c,goal__c From GoalSIPAmount__c 
									Where goal__c in : idSet
									and Goal_Year__c =: system.today().Year()])
		{
			if(goalSIPAmtMap.get(objGoalSIPAmount.Goal__c) == null)
	        {
	            goalSIPAmtMap.put(objGoalSIPAmount.Goal__c, objGoalSIPAmount);
	        }
		}*/
		Map<id,GoalSIPAmount__c> goalSIPAmtMap = new Map<id,GoalSIPAmount__c>();
		//Map<Id,List<GoalSIPAmount__c>> goalSipAmountMap = StaticMethodClass.getgoalSIPAmtMap;
		if(goalSipAmountMap != null)
		{
			for(Id goalId : idSet)
			{
				if(goalSipAmountMap.ContainsKey(goalId))
				{
					List<GoalSIPAmount__c> goalSipList = goalSipAmountMap.get(goalId);
					if(goalSIPAmtMap.get(goalId) == null && goalSipList != null && goalSipList.size() > 0)
			        {
			            goalSIPAmtMap.put(goalId, goalSipList[0]);
			        }
				}
				
			}
		}
		return goalSIPAmtMap;
	}
	// ID is Asset ID
	public Map<ID,List<GoalAssetAssociation__c>> getAssetGoalAssociationMapping(String entityId) {
		List<GoalAssetAssociation__c> goalAssetAssociationList;
		Map<ID,List<GoalAssetAssociation__c>> goalAssetMappingMap = new Map<ID,List<GoalAssetAssociation__c>>();
 		try {
			goalAssetAssociationList = databaseObj.getGoalAssetAllocationList(entityId);
			
			for(GoalAssetAssociation__c goalAssetAssociation : goalAssetAssociationList) {
				goalAssetAssociationList = goalAssetMappingMap.get(goalAssetAssociation.asset__c);
				if(goalAssetAssociationList == null) 
				{
					goalAssetAssociationList = new List<GoalAssetAssociation__c>();
					goalAssetMappingMap.put(goalAssetAssociation.asset__c,goalAssetAssociationList);
				}
				goalAssetAssociationList.add(goalAssetAssociation);				
			}
 		}catch(Exception ex) {
 			throw new GeneralException('getAssetGoalAssociationMapping : encountering error condition while fetching AssetGoalAssociation' + ex.getMessage());
 		}
		return goalAssetMappingMap;	
	}
	
    //************************************************** Investment Asset code ****************************
    /*
    	Modified By : Niket Chandane
    	Modified At	: 14 June 2011
    	Issue		: F0002
    	Summary     : Update the logic for the classfication of Assets in to debt and Equity.
    */
	private void fetchInvestmentAssetsRecords(String entityId, AssetAllocationBean assetAllocationBean) 
	{
		system.debug('************fetchInvestmentAssetsRecords====1====  Inside NewPortfolioSummary >'+Limits.getQueries());
		AssetAllocationBean.AssetRecordTypeBean assetRecordTypeBean;
		AssetAllocationBean.AssetTypeBean assetTypeBean;
		AssetAllocationBean.AssetDetailBean assetDetailBean,tempAssetDetailBean;
		AssetAllocationBean.GoalAssetMapping goalAssetMapping;
		Map<ID, GoalInvestmentAssetAssociation__c> assetGoalAssociationInDbMap;
		List<Investment_Asset__c> invAssetList;
		ID recordTypeId;
		String assetType,tempAssetType,recordTypeName='';
		Double currentValue;
		String entityIdInMethod;
		
		
		/** Eternus Solutions       **/
		/** Author  : Jigar			**/
		/** Issue Id: F0002      	**/
		/** Date    : 13/05/2011 	**/
		/** Purpose : Used in the updated Equity/Debt classification Logic **/
			/****************************************************/  
		/*String strMutualFundDebtList = 'Debt - Long Term;Debt - Medium Term;Debt - Short Term;Debt - Ultra Short Term;' + 
									   'Hybrid - Arbitrage;Hybrid - Asset Allocation;Hybrid - Debt Oriented;Hybrid - Monthly Income';
		
		String strMutualFundEquityList = 'Equity - Index;Equity - Diversified;Equity - Large Cap;Equity - Mid Cap;' + 
										 'Equity - Small Cap;Equity - Sectoral;Hybrid - Equity Oriented';*/
									   
	/*Niket string Array of the Debt asset type currently there are 12 types*/ 
		string []arrMutualFundDebt = new string[]{'Corporate Bonds','RBI Bonds','Capital Gains Tax Saving Bonds','Non Convertible Debentures','Debt - Long Term','Debt - Medium Term','Debt - Short Term','Debt - Ultra Short Term','Hybrid - Arbitrage'
												,'Hybrid - Asset Allocation','Hybrid - Debt Oriented','Hybrid - Monthly Income','Others'};
		String []arrMutualFundEquity = New string[]{'Large Cap','Mid Cap','Small Cap','Equity - Index','Equity - Diversified','Equity - Large Cap','Equity - Mid Cap','Equity - Small Cap','Equity - Sectoral','Hybrid - Equity Oriented','Equity - International'};
		
		try 
		{ 
			Map<ID, Map<ID,GoalInvestmentAssetAssociation__c>> goalInvestmentAssetMappingMap = getInvAssetGoalAssociationMaps(entityId);
			invAssetList = databaseObj.getInvestmentAssetsForPortfolio(entityId);
			Integer iCount =0 ;
			for(Investment_Asset__c invAsset : invAssetList)
			{
				iCount ++;
				if(!recordTypeName.equalsIgnoreCase(invAsset.RecordType.name))
				{
					recordTypeName = invAsset.RecordType.name;
					assetRecordTypeBean = assetAllocationBean.populateRecordTypeBeanList('Investment Asset',invAsset.RecordType.name);
				}
				/** Eternus Solutions       **/
				/** Author  : Jigar			**/
				/** Issue Id: F0002      	**/
				/** Date    : 13/05/2011 	**/
				/** Purpose : New Logic for Equity/Debt classification **/
				/****************************************************/ 
				if(recordTypeName.contains('Fixed Income'))
				{
					tempAssetType = 'Debt';
				}
				else if(recordTypeName.contains('Stocks'))
				{
					tempAssetType = 'Equity';
				}
				/* Prajakta - FP changes - 26-02-2013 */
				else if(recordTypeName.contains('Gold and Silver'))/*Prajakta - 24-05-2013 */
				{
					tempAssetType = 'Gold';
				}
				
				else if(recordTypeName.contains('Mutual Fund'))
				{
					tempAssetType = ClassifyDebtEquity(arrMutualFundDebt, invAsset.Asset_Type__c, 'Debt');
					if(tempAssetType == '*')
						tempAssetType = ClassifyDebtEquity(arrMutualFundEquity,invAsset.Asset_Type__c,'Equity');
					/** Eternus Solutions       **/
					/** Author  : Manasi Ranade **/
					/** Issue Id: 00001461      **/
					/** Date    : 19/1/2012 	**/
					/** Purpose : Added Check for Null before using it
					/****************************************************/
					if(tempAssetType == '*')
					{
						if(invAsset != null && invAsset.Asset_Type__c != null  && invAsset.Asset_Type__c.toLowerCase().contains('Gold and Silver'))/*Prajakta - 24-05-2013 */
							tempAssetType = 'Gold';
					}
				}
				
				/** Eternus Solutions       **/
				/** Author  : Jigar			**/
				/** Issue Id: F0002      	**/
				/** Date    : 13/05/2011 	**/
				/** Purpose : Old Logic for Equity/Debt classification  **/
				/****************************************************/
				/*if(recordTypeName.contains('Mutual Fund')) {
					tempAssetType = (invAsset.Asset_Type__c.startsWith('Debt') ?'Debt' : 'Equity') ;
				} */
				
				else 
				{
					tempAssetType = invAsset.RecordType.name;
				}
				/*
					Modification By : Niket Chandane.
					Modification At : 14 June 2011.
				*/
				//if(!tempAssetType.equalsIgnoreCase(assetType)) // This code create the Classification For the Debt and equity
				if(tempAssetType != null)
				{
					assetTypeBean = assetRecordTypeBean.populateAssetTypeBeanList(tempAssetType);
					//assetType = tempAssetType;
				} // Up to this level code is stable
				/*Niket 
					Modification By : Niket Chandane.
					/* Old Logic
				
					if(!((String)invAsset.Entity__c).equals(entityIdInMethod))
					{
						assetDetailBean = assetTypeBean.populateAssetDetailList(invAsset.Entity__r.Name,'',0,invAsset.action__c,invAsset.Id);
						assetDetailBean.entityId = invAsset.Entity__c;
						tempAssetDetailBean = assetDetailBean;
						entityIdInMethod = 	invAsset.Entity__c;
					}
					assetDetailBean.assetCurrentValue = assetDetailBean.assetCurrentValue + invAsset.TotalAsset__c;
				*/
				if(!(tempAssetType).equals(assetType))
				{
					assetDetailBean = assetTypeBean.populateAssetDetailList(invAsset.Entity__r.Name,'',0,invAsset.action__c,invAsset.Id);
					assetDetailBean.entityId = invAsset.Entity__c;
					assetDetailBean.AssetType = tempAssetType;
					assetType = tempAssetType;
					tempAssetDetailBean = assetDetailBean;
				}
				/** Eternus Solutions       **/
				/** Author  : Manasi Ranade **/
				/** Issue Id: 00001470     	**/
				/** Date    : 1/2/2012  	**/
				/** Purpose : Commented original Code
				/****************************************************/
				//Original
				//assetDetailBean.assetCurrentValue = assetDetailBean.assetCurrentValue + invAsset.TotalAsset__c;
				Double dblAssetCurrentvalue = 0;
				Double dblTotalAsset = 0;
				if(assetDetailBean != null)
				{
					dblAssetCurrentvalue = (assetDetailBean.assetCurrentValue != null ? assetDetailBean.assetCurrentValue : 0);
				}
				
				dblTotalAsset = (invAsset.TotalAsset__c != null ? invAsset.TotalAsset__c : 0);
				if(assetDetailBean != null)
					assetDetailBean.assetCurrentValue = dblAssetCurrentvalue + dblTotalAsset;
				if(tempAssetDetailBean != null) 
				{ 
					// This logic is to have only one asset record in GUI for any given record type
					/** Eternus Solutions       **/
					/** Author  : Manasi Ranade **/
					/** Issue Id: 00001470     	**/
					/** Date    : 1/2/2012  	**/
					/** Purpose : Commented original code
					/****************************************************/
					tempAssetDetailBean = null;
					/* goalInvestmentAssetMappingMap this map contain the InvestmentAssetId, and it's  
					   GoalInvestmentAssetAssociation */
					assetGoalAssociationInDbMap = goalInvestmentAssetMappingMap.get(invAsset.id);
					String goalId;
					/** Eternus Solutions       **/
					/** Author  : Manasi Ranade **/
					/** Issue Id: 00001470     	**/
					/** Date    : 1/2/2012  	**/
					/** Purpose : Method to fetch Goal Ids
					/****************************************************/
					Set<Id> idSet = new Set<Id>();
					if(assetGoalAssociationInDbMap != null && assetGoalAssociationInDbMap.size() > 0)
					for(GoalInvestmentAssetAssociation__c objGoalInvAssetAssociation : assetGoalAssociationInDbMap.values() )
					{
						idSet.add(objGoalInvAssetAssociation.Goal__c);
					}
					/*List<GoalSIPAmount__c> goalSIPAmountList = [Select GoldCurrentYear__c,EquityCurrentYear__c,DebtCurrentYear__c,goal__c From GoalSIPAmount__c 
												Where goal__c in : idSet
												and Goal_Year__c =: system.today().Year()];*/
					/** Eternus Solutions       **/
					/** Author  : Manasi Ranade **/
					/** Issue Id: 00001556     	**/
					/** Date    : 28/3/2012  	**/
					/** Purpose : Assign entity Id to the StaticMethodClass.entityId
					/****************************************************/
					StaticMethodClass.entityId = entityId;
					Map<id,GoalSIPAmount__c> goalSIPAmtMap = getgoalSIPAmtMap(idSet);
							system.debug('****goalSIPAmtMap**in Inv Asset func*'+goalSIPAmtMap);
					if(assetGoalAssociationInDbMap != null && assetGoalAssociationInDbMap.size() > 0) 
					{
						for(GoalInvestmentAssetAssociation__c goalInvAssetAssociation : assetGoalAssociationInDbMap.values()) 
						{
							goalAssetMapping = new AssetAllocationBean.GoalAssetMapping();                	
                			goalAssetMapping.assetAllocated =''+ goalInvAssetAssociation.allocated__c;
                			goalAssetMapping.goalId = goalId;
                			goalAssetMapping.goalAssetAssociationId = goalInvAssetAssociation.Id;
                			/** Eternus Solutions       **/
							/** Author  : Manasi Ranade **/
							/** Issue Id: 00001470     	**/
							/** Date    : 1/2/2012  	**/
							/** Purpose : Commented the original Code and Fetched the Equity %, Debt %,Gold % from SIP Object
							/****************************************************/
                			/*goalAssetMapping.goldAllocatedPercent = goalInvAssetAssociation.goal__r.SelectedGoalProfile__r.gold_allocation__c;
                			goalAssetMapping.debtAllocatedPercent = goalInvAssetAssociation.goal__r.SelectedGoalProfile__r.debt_allocation__c;
                			goalAssetMapping.equityAllocatedPercent = goalInvAssetAssociation.goal__r.SelectedGoalProfile__r.equity_allocation__c;*/
                			if(goalSIPAmtMap != null && goalSIPAmtMap.size() > 0 && goalSIPAmtMap.get(goalInvAssetAssociation.goal__c) != null)
							{
								GoalSIPAmount__c objSelectedGoalSIPAmounts = goalSIPAmtMap.get(goalInvAssetAssociation.goal__c);
								Double dblGoldValue = (objSelectedGoalSIPAmounts.GoldCurrentYear__c != null ? objSelectedGoalSIPAmounts.GoldCurrentYear__c : 0);
								Double dblDebtValue = (objSelectedGoalSIPAmounts.DebtCurrentYear__c != null ? objSelectedGoalSIPAmounts.DebtCurrentYear__c : 0);
								Double dblEquityValue = (objSelectedGoalSIPAmounts.EquityCurrentYear__c != null ? objSelectedGoalSIPAmounts.EquityCurrentYear__c : 0);
								double dblTotal = dblGoldValue + dblDebtValue + dblEquityValue;
								if(dblTotal > 0)
								{
									goalAssetMapping.goldAllocatedPercent = objSelectedGoalSIPAmounts.GoldCurrentYear__c / dblTotal * 100;
									goalAssetMapping.debtAllocatedPercent = objSelectedGoalSIPAmounts.DebtCurrentYear__c / dblTotal * 100;
									goalAssetMapping.equityAllocatedPercent = objSelectedGoalSIPAmounts.EquityCurrentYear__c / dblTotal * 100;
								}
								else
								{
									goalAssetMapping.goldAllocatedPercent = 0;
									goalAssetMapping.debtAllocatedPercent = 0;
									goalAssetMapping.equityAllocatedPercent = 0;
								}
							}
							else
							{
								goalAssetMapping.goldAllocatedPercent = 0;
								goalAssetMapping.debtAllocatedPercent = 0;
								goalAssetMapping.equityAllocatedPercent = 0;
							}
	                		if(goalInvAssetAssociation.Allocated__c != null) {
	                			assetDetailBean.allocatedPercent =''+ (Decimal.valueOf(assetDetailBean.allocatedPercent) + goalInvAssetAssociation.Allocated__c);
	                		}
	                		system.debug('************fetchInvestmentAssetsRecords====in inner for loop 4====  Inside NewPortfolioSummary >'+Limits.getQueries());
	                		assetDetailBean.populateGoalAssetMappingList(goalAssetMapping);
	                		system.debug('************fetchInvestmentAssetsRecords====in inner for loop 5====  Inside NewPortfolioSummary >'+Limits.getQueries());
	            		}
					}
					else//00001470 Need testing to check Inv assets of same asset class type 
					{
						assetType = null;
					}
				}
			}
			system.debug('************fetchInvestmentAssetsRecords====End====  Inside NewPortfolioSummary >'+Limits.getQueries());
		} catch(Exception ex) {
			throw new GeneralException('AssetAllocationService.fetchInvestmentAssetsRecords Portfolio: Internal Error ' + ex.getMessage());	
     	}				    																							
	}
	
	/*
		Created By : Niket Chandane.
		Created at : 11 June 2011
		Method 	   : ClassifyDebtEquity(string []arrAssetClass , string strAssetType,string strClass)
		return Type: string
		Summary    : This fundtion accepts the Array of asset class and check the 
					 provided AssetType is Equity or Debt
	*/
	
	public string ClassifyDebtEquity(string []arrAssetClass , string strInvestAssetType,string strClass)
	{
		string strTempAssetType ='*';
		try
		{
			if(arrAssetClass != null && arrAssetClass.size() > 0)
			{
				for(String strAssetClass : arrAssetClass)
				{
					/** Eternus Solutions       **/
					/** Author  : Manasi Ranade **/
					/** Issue Id: 00001461      **/
					/** Date    : 19/1/2012 	**/
					/** Purpose : Added Check for Null before using value
					/****************************************************/
					if(strAssetClass != null && strAssetClass != '' && strInvestAssetType != null && strInvestAssetType != '' && strAssetClass.toLowerCase().contains(strInvestAssetType.toLowerCase()))
					{
						strTempAssetType = strClass;
					}
				}
			}
		}
		catch(Exception ex) {
     		throw new GeneralException('ClassifyDebtEquity : Internal Error ' + ex.getMessage());	
     	}
     	return strTempAssetType;
	}
	
	//First  ID is Asset ID and Second is Goal
	public Map<ID,Map<ID,GoalInvestmentAssetAssociation__c>> getInvAssetGoalAssociationMaps(String entityId) 
	{
		Map<ID, GoalInvestmentAssetAssociation__c> goalAssetAssociationByGoal = new Map<ID, GoalInvestmentAssetAssociation__c>();
		Map<ID, Map<ID,GoalInvestmentAssetAssociation__c>> goalAssetAssociationByAsset = new Map<ID, Map<ID,GoalInvestmentAssetAssociation__c>>();
 		
 		try 
 		{
			List<GoalInvestmentAssetAssociation__c> goalAssetAssociationList = databaseObj.getGoalInvestmentAssociationList(entityId);
			for(GoalInvestmentAssetAssociation__c goalAssetAssociation : goalAssetAssociationList) 
			{
				goalAssetAssociationByGoal = goalAssetAssociationByAsset.get(goalAssetAssociation.Investment_Asset__c);
				if(goalAssetAssociationByGoal == null) 
				{
					goalAssetAssociationByGoal = new Map<ID,GoalInvestmentAssetAssociation__c>();			
					goalAssetAssociationByAsset.put(goalAssetAssociation.Investment_Asset__c,goalAssetAssociationByGoal);
				}
				goalAssetAssociationByGoal.put(goalAssetAssociation.goal__c,goalAssetAssociation);							
			}
		}
		catch(Exception ex) 
		{
     		throw new GeneralException('AssetAllocationService.getInvAssetGoalAssociationMaps : Internal Error ' + ex.getMessage());	
     	}				    																												
		return goalAssetAssociationByAsset;
	}
	
	//*******************************************************  Insurance Code ***************************************	
	private void fetchInsuranceRecords(String entityId,AssetAllocationBean assetAllocationBean) {		
		AssetAllocationBean.AssetRecordTypeBean assetRecordTypeBean;
		AssetAllocationBean.AssetTypeBean assetTypeBean;
		AssetAllocationBean.AssetDetailBean assetDetailBean;
		AssetAllocationBean.GoalAssetMapping goalAssetMapping;
				
		List<GoalInsuranceAssociation__c> insuranceGoalAssociationInDB;
		List<Insurance__c> insuranceList;
		ID recordTypeId;
		String assetType,tempAssetType;
		Double currentValue;
		
		try {
			Map<ID,List<GoalInsuranceAssociation__c>> goalInsuranceMappingMap 
													= getInsuranceGoalAssociationMapping(entityId);																																	
			insuranceList = databaseObj.getInsuranceForPortfolio(entityId);												
			for(Insurance__c insurance : insuranceList) { 						
				if(insurance.recordTypeId != recordTypeId) {
					assetRecordTypeBean = assetAllocationBean.populateRecordTypeBeanList('Insurance',insurance.RecordType.Name);
					//Error.debugLog(' assetRecordTypeBean  : ' + assetRecordTypeBean);
					recordTypeId = insurance.recordTypeId;				
					assetTypeBean = null;				
				}	
				tempAssetType = insurance.Policy_Type__c;					
				//currentValue = insurance.totalAsset__c;		
				currentValue = insurance.current_amount__C;
				
				 
				if(currentValue == 0) {
					System.debug('Investment Asset total is zero. Ignore this record.');	
					continue;
				}								
				if(tempAssetType == null) {
					setInfoMessage('There are some insurance records with incorrect policy type.');													
					continue;
				}
				if(!tempAssetType.equals(assetType)) {
					assetTypeBean = assetRecordTypeBean.populateAssetTypeBeanList(tempAssetType);
					assetType = tempAssetType;
					//Error.DebugLog(' ** assetTypeBean : ' + assetTypeBean + ' * assetType --> ' + assetType);				
				}
				assetDetailBean = assetTypeBean.populateAssetDetailList(insurance.Entity__r.Name,'',currentValue,insurance.action__c,insurance.id);					
				insuranceGoalAssociationInDB  = goalInsuranceMappingMap.get(insurance.id);
				String goalId;
				if(insuranceGoalAssociationInDB != null)
				{
					/** Eternus Solutions       **/
					/** Author  : Manasi Ranade **/
					/** Issue Id: 00001470     	**/
					/** Date    : 1/2/2012  	**/
					/** Purpose : Method to fetch Goal Ids
					/****************************************************/
					Set<Id> idSet = new Set<Id>();
					for(GoalInsuranceAssociation__c objGoalInsuranceAssociation : insuranceGoalAssociationInDB )
					{
						idSet.add(objGoalInsuranceAssociation.Goal__c);
					}
					/*List<GoalSIPAmount__c> goalSIPAmountList = [Select GoldCurrentYear__c,EquityCurrentYear__c,DebtCurrentYear__c,goal__c From GoalSIPAmount__c 
												Where goal__c in : idSet
												and Goal_Year__c =: system.today().Year()];*/
					/** Eternus Solutions       **/
					/** Author  : Manasi Ranade **/
					/** Issue Id: 00001556     	**/
					/** Date    : 28/3/2012  	**/
					/** Purpose : Assign entity Id to the StaticMethodClass.entityId
					/****************************************************/
					StaticMethodClass.entityId = entityId;
					Map<id,GoalSIPAmount__c> goalSIPAmtMap = getgoalSIPAmtMap(idSet);
					for(GoalInsuranceAssociation__c goalInsuranceAssociation : insuranceGoalAssociationInDB ) {
						goalId = goalInsuranceAssociation.goal__c;
						//System.debug('Goal ID is ' + goalId);
						goalAssetMapping = new AssetAllocationBean.GoalAssetMapping();                	
                		goalAssetMapping.assetAllocated =''+ goalInsuranceAssociation.allocated__c;
                		goalAssetMapping.goalId = goalId;
                		goalAssetMapping.goalAssetAssociationId = goalInsuranceAssociation.Id;
                		/** Eternus Solutions       **/
						/** Author  : Manasi Ranade **/
						/** Issue Id: 00001470     	**/
						/** Date    : 1/2/2012  	**/
						/** Purpose : Commented the original Code and Fetched the Equity %, Debt %,Gold % from SIP Object
						/****************************************************/
                		/*goalAssetMapping.goldAllocatedPercent = goalInsuranceAssociation.goal__r.SelectedGoalProfile__r.gold_allocation__c;
                		goalAssetMapping.debtAllocatedPercent = goalInsuranceAssociation.goal__r.SelectedGoalProfile__r.debt_allocation__c;
                		goalAssetMapping.equityAllocatedPercent = goalInsuranceAssociation.goal__r.SelectedGoalProfile__r.equity_allocation__c;*/
                		if(goalSIPAmtMap != null && goalSIPAmtMap.size() > 0 && goalSIPAmtMap.get(goalInsuranceAssociation.goal__c) != null)
						{
							GoalSIPAmount__c objSelectedGoalSIPAmounts = goalSIPAmtMap.get(goalInsuranceAssociation.goal__c);
							Double dblGoldValue = (objSelectedGoalSIPAmounts.GoldCurrentYear__c != null ? objSelectedGoalSIPAmounts.GoldCurrentYear__c : 0);
							Double dblDebtValue = (objSelectedGoalSIPAmounts.DebtCurrentYear__c != null ? objSelectedGoalSIPAmounts.DebtCurrentYear__c : 0);
							Double dblEquityValue = (objSelectedGoalSIPAmounts.EquityCurrentYear__c != null ? objSelectedGoalSIPAmounts.EquityCurrentYear__c : 0);
							
							double dblTotal = dblGoldValue + dblDebtValue + dblEquityValue;
							if(dblTotal > 0)
							{
								goalAssetMapping.goldAllocatedPercent = objSelectedGoalSIPAmounts.GoldCurrentYear__c / dblTotal * 100;
								goalAssetMapping.debtAllocatedPercent = objSelectedGoalSIPAmounts.DebtCurrentYear__c / dblTotal * 100;
								goalAssetMapping.equityAllocatedPercent = objSelectedGoalSIPAmounts.EquityCurrentYear__c / dblTotal * 100;
							}
							else
							{
								goalAssetMapping.goldAllocatedPercent = 0;
								goalAssetMapping.debtAllocatedPercent = 0;
								goalAssetMapping.equityAllocatedPercent = 0;
							}
						}
						else
						{
							goalAssetMapping.goldAllocatedPercent = 0;
							goalAssetMapping.debtAllocatedPercent = 0;
							goalAssetMapping.equityAllocatedPercent = 0;
						}
		                if(goalInsuranceAssociation.Allocated__c != null) {
		                	assetDetailBean.allocatedPercent =''+ (Decimal.valueOf(assetDetailBean.allocatedPercent) + goalInsuranceAssociation.Allocated__c);
		                }		                         
		                assetDetailBean.populateGoalAssetMappingList(goalAssetMapping);
		            }
				}
			}
		} catch(Exception ex) {
     		throw new GeneralException('AssetAllocationService.fetchInsuranceRecords : Internal Error ' + ex.getMessage());	
     	}								
	}
	// ID is Asset ID
	public Map<ID,List<GoalInsuranceAssociation__c>> getInsuranceGoalAssociationMapping(String entityId) {
		List<GoalInsuranceAssociation__c> goalInsuranceAssociationList;
		Map<ID,List<GoalInsuranceAssociation__c>> goalInsuranceMappingMap = new Map<ID,List<GoalInsuranceAssociation__c>>();
 		
		try {
			goalInsuranceAssociationList = databaseObj.getGoalInsuranceAllocationList(entityId);
				
			for(GoalInsuranceAssociation__c goalInsuranceAssociation : goalInsuranceAssociationList) {
				goalInsuranceAssociationList = goalInsuranceMappingMap.get(goalInsuranceAssociation.insurance__c);
				if(goalInsuranceAssociationList == null) {
					goalInsuranceAssociationList = new List<GoalInsuranceAssociation__c>();
					goalInsuranceMappingMap.put(goalInsuranceAssociation.insurance__c,goalInsuranceAssociationList);
				}
				goalInsuranceAssociationList.add(goalInsuranceAssociation);				
			}
		}catch(Exception ex) {
     		throw new GeneralException('AssetAllocationService.getInsuranceGoalAssociationMapping : Internal Error ' + ex.getMessage());	
     	}
		return goalInsuranceMappingMap;	
	}
	/*
		This function is to set suggested and current assets for all actions except 'Liquidate align to Goal' action.
		It also sets suggested and current assets for 'Liquidate align to Goal' action if there are some remaining unallocated asset percent. 	
	*/
	 /*
    	Modified By : Niket Chandane
    	Modified At	: 14 June 2011
    	Issue		: F0002
    	Summary     : Update the logic for the classfication of Assets in to debt and Equity.
    */
	private void updatePortfolioBean(Map<String,PortfolioBean> portfolioBeanMap
										,AssetAllocationBean.AssetRecordTypeBean recordTypeBean
										,AssetAllocationBean.AssetTypeBean assetTypeBean
										,AssetAllocationBean.AssetDetailBean assetDetailBean ) 
	{
		PortfolioBean portfolioBean;
		system.debug('----recordTypeBean.recordTypeName--------'+recordTypeBean.recordTypeName);
		system.debug('----assetTypeBean.assetTypeName--------'+assetTypeBean.assetTypeName);
		/*Niket : This condition checks the assets value for the portfolio Summary Page for Gold Section*/
		if((recordTypeBean.recordTypeName.equalsIgnoreCase('Personal Assets') && ('Gold'.equals( assetTypeBean.assetTypeName))) 
			|| (recordTypeBean.recordTypeName.equalsIgnoreCase('Gold and Silver'))) 
		{
			system.debug('======recordTypeBean.recordTypeName==========='+recordTypeBean.recordTypeName);
			portfolioBean = portfolioBeanMap.get('Gold');
			if(!(Allocation_Action__c.getInstance('Action3').Action__c.equalsIgnoreCase(assetDetailBean.action))) 
			{
				portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + assetDetailBean.assetCurrentValue;
			} 
			else 
			{	
				portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + ( assetDetailBean.assetCurrentValue * 
																				((100 - Double.valueOf(assetDetailBean.allocatedPercent))))/100.0d;
			}
			portfolioBean.currentAsset = portfolioBean.currentAsset + assetDetailBean.assetCurrentValue;
		}
		 /*Niket : This condition checks the assets value for the portfolio Summary Page for Real Estate Assets Section*/
		 else if(recordTypeBean.recordTypeName.equalsIgnoreCase('Real Estate Assets')) 
		 {
			portfolioBean = portfolioBeanMap.get('Real Estate');
			if(!(Allocation_Action__c.getInstance('Action3').Action__c.equalsIgnoreCase(assetDetailBean.action))) 
			{
				portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + assetDetailBean.assetCurrentValue;
			} 
			else 
			{
				portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + ( assetDetailBean.assetCurrentValue * 
																				((100 - Double.valueOf(assetDetailBean.allocatedPercent))))/100.0d;
			}
			portfolioBean.currentAsset = portfolioBean.currentAsset + assetDetailBean.assetCurrentValue;
		}
		/*Niket : This condition checks the assets value for the portfolio Summary Page for Cash and Cash Equivalents Section*/
		else if(recordTypeBean.recordTypeName.equalsIgnoreCase('Cash and Cash Equivalents'))
		{								
			portfolioBean = portfolioBeanMap.get('Cash');
			if(!(Allocation_Action__c.getInstance('Action3').Action__c.equalsIgnoreCase(assetDetailBean.action)))
			{
				portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + assetDetailBean.assetCurrentValue;
			} else {
				portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + ( assetDetailBean.assetCurrentValue * 
																				((100 - Double.valueOf(assetDetailBean.allocatedPercent))))/100.0d;
			}
			portfolioBean.currentAsset = portfolioBean.currentAsset + assetDetailBean.assetCurrentValue;
		}
		/*Niket : This condition checks the assets value for the portfolio Summary Page for debt Section*/
		else if( recordTypeBean.parentType.equals('Asset') ||  recordTypeBean.recordTypeName.equals('Fixed Income') || (assetDetailBean.AssetType != null && assetDetailBean.AssetType.equals('Debt')) 
			|| ( recordTypeBean.parentType.equals('InvAsset') && ('Debt'.equals(assetTypeBean.assetTypeName ))))
		{
			portfolioBean = portfolioBeanMap.get('Debt');
			if(!(Allocation_Action__c.getInstance('Action3').Action__c.equalsIgnoreCase(assetDetailBean.action))) 
			{
				portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + assetDetailBean.assetCurrentValue;
			} 
			else 
			{
				portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + ( assetDetailBean.assetCurrentValue * 
																				((100 - Double.valueOf(assetDetailBean.allocatedPercent))))/100.0d;
			}
			portfolioBean.currentAsset = portfolioBean.currentAsset + assetDetailBean.assetCurrentValue;
		}
		/*
			Modified By : Niket Chandane.
			Modified on : 15 June 2011.
			Summary 	: Changes the Else If condition added the new filter as 
						  1] recordTypeBean.recordTypeName.equals('Business Assets')
						  2] assetDetailBean.AssetType.equals('Equity')
		*/
		else if(recordTypeBean.recordTypeName.equals('Stocks') || (assetDetailBean.AssetType != null && assetDetailBean.AssetType.equals('Equity')) || recordTypeBean.recordTypeName.equals('Business Assets'))
		{
			portfolioBean = portfolioBeanMap.get('Equity');
			if(!(Allocation_Action__c.getInstance('Action3').Action__c.equalsIgnoreCase(assetDetailBean.action))) 
			{
				portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + assetDetailBean.assetCurrentValue;
			}
			else
			{
				portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + ( assetDetailBean.assetCurrentValue * 
																				((100 - Double.valueOf(assetDetailBean.allocatedPercent))))/100.0d;
			}
			portfolioBean.currentAsset = portfolioBean.currentAsset + assetDetailBean.assetCurrentValue;
		}
		
		else if(recordTypeBean.recordTypeName.equals('Life Insurance'))
		{
			portfolioBean = portfolioBeanMap.get(Label.Portfolio_Life_Insurance);
			portfolioBean.currentAsset = portfolioBean.currentAsset + assetDetailBean.assetCurrentValue;
		}
		/*else if(recordTypeBean.recordTypeName.equals('Mutual Fund') || recordTypeBean.recordTypeName.equals('Stocks'))   
			{
				portfolioBean = portfolioBeanMap.get('Equity');
				if(!(Allocation_Action__c.getInstance('Action3').Action__c.equalsIgnoreCase(assetDetailBean.action))) 
				{
					portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + assetDetailBean.assetCurrentValue;
				}
				else
				{
					portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + ( assetDetailBean.assetCurrentValue * 
																					((100 - Double.valueOf(assetDetailBean.allocatedPercent))))/100.0d;
				}
				portfolioBean.currentAsset = portfolioBean.currentAsset + assetDetailBean.assetCurrentValue;
		}*/
	}
	
	/* 
	 	This is the main function/method which is being called from Controller to get portfolio details.
	*/
	public List<PortfolioBean> getPortfolioSummary(String entityId) 
	{
		AssetAllocationBean allocationBean = new AssetAllocationBean();
		/*It Collects all the assets which are shown at Assets tab*/
		fetchAssetsRecords(entityId , allocationBean);
		system.debug('************getPortfolioSummary========  Inside NewPortfolioSummary >'+Limits.getQueries());
		/*It Collects all the assets which are shown at Investment Assets tab*/
		fetchInvestmentAssetsRecords(entityId , allocationBean);
		
		/*Aditi Satpute : 14/10/13 - Need to include Insurance in Portfoilio Summary*/
		fetchInsuranceRecords(entityId,allocationBean);
		
		system.debug('************getPortfolioSummary==after fetch Investment Assets======  Inside NewPortfolioSummary >'+Limits.getQueries());
		Map<String,PortfolioBean> portfolioBeanMap = new Map<String,PortfolioBean>();
		PortfolioBean portfolioBean;
		
		portfolioBeanMap.put('Cash' , new PortfolioBean('Cash'));
		portfolioBeanMap.put('Equity' , new PortfolioBean('Equity'));
		portfolioBeanMap.put('Debt' , new PortfolioBean('Debt'));
		portfolioBeanMap.put('Gold' , new PortfolioBean('Gold'));
		portfolioBeanMap.put('Real Estate' , new PortfolioBean('Real Estate'));
		portfolioBeanMap.put(Label.Portfolio_Life_Insurance , new PortfolioBean(Label.Portfolio_Life_Insurance));
		totalAsset = 0;
		Double totalTest = 0;
		
		for(AssetAllocationBean.AssetRecordTypeBean recordTypeBean : allocationBean.assetRecordTypeBeanList ) 
		{
			for(AssetAllocationBean.AssetTypeBean assetTypeBean : recordTypeBean.assetTypeList) 
			{
				for(AssetAllocationBean.AssetDetailBean assetDetailBean : assetTypeBean.assetDetailList) {
					totalAsset = totalAsset + assetDetailBean.assetCurrentValue;
					//error.debugLog('--assetDetailBean-'+assetDetailBean);
					if(!assetDetailBean.goalAssetMappingList.isEmpty()) 
					{
						for(AssetAllocationBean.GoalAssetMapping goalAssetMapping : assetDetailBean.goalAssetMappingList) 
						{	
							//error.debugLog('--goalAssetMapping-'+goalAssetMapping);
							if((Allocation_Action__c.getInstance('Action3').Action__c.equalsIgnoreCase(assetDetailBean.action))) 
							{	
								portfolioBean = portfolioBeanMap.get('Equity');
								//Manasi
								/** Eternus Solutions       **/
								/** Author  : Manasi Ranade **/
								/** Issue Id: F0039      	**/
								/** Date    : 06/06/2011 	**/
								/** Purpose : Added check for null values before using them in calculation **/
								/****************************************************/  
								if( portfolioBean.suggestedAsset == null)
									portfolioBean.suggestedAsset = 0;
									 
								if( assetDetailBean.assetCurrentValue == null)
									assetDetailBean.assetCurrentValue = 0;
							
								if( goalAssetMapping.assetAllocated == null)
									goalAssetMapping.assetAllocated = '0';
									 
								if( goalAssetMapping.equityAllocatedPercent == null)
									goalAssetMapping.equityAllocatedPercent = 0;
								
								if( goalAssetMapping.debtAllocatedPercent == null)
									goalAssetMapping.debtAllocatedPercent = 0;
								
								if( goalAssetMapping.goldAllocatedPercent == null)
									goalAssetMapping.goldAllocatedPercent = 0;
								portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + ((
																((assetDetailBean.assetCurrentValue * (Double.valueOf(goalAssetMapping.assetAllocated) / 100.0d)))
																* (goalAssetMapping.equityAllocatedPercent))/100.0d);
								
								portfolioBean = portfolioBeanMap.get('Debt');
								portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + ((
																((assetDetailBean.assetCurrentValue * (Double.valueOf(goalAssetMapping.assetAllocated) / 100.0d)))
																* (goalAssetMapping.debtAllocatedPercent))/100.0d);
								portfolioBean = portfolioBeanMap.get('Gold');
								
								portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + ((
																((assetDetailBean.assetCurrentValue * (Double.valueOf(goalAssetMapping.assetAllocated) / 100.0d)))
																* (goalAssetMapping.goldAllocatedPercent))/100.0d); 
								/*Aditi Satpute : 14/10/13 - Need to include Insurance in Portfoilio Summary*/								
								/*portfolioBean = portfolioBeanMap.get('Insurance');
								portfolioBean.suggestedAsset = portfolioBean.suggestedAsset + ((
																((assetDetailBean.assetCurrentValue * (Double.valueOf(goalAssetMapping.assetAllocated) / 100.0d)))
																(goalAssetMapping.goldAllocatedPercent))/100.0d); 
								system.debug('-------portfolioBean--Insurance-->'+portfolioBean);	*/								
							}														
						}// This call is to add remaining percent asset value
						
						updatePortfolioBean(portfolioBeanMap ,recordTypeBean , assetTypeBean , assetDetailBean);
						//system.debug('********portfolioBeanMap:'+portfolioBeanMap.suggestedAsset);												
					} else {
						updatePortfolioBean(portfolioBeanMap ,recordTypeBean , assetTypeBean , assetDetailBean);	
					}
				}		
			}	
			
		}
		//13Feb2012
		Double dblCurrentPercent = 0;
		Double dblSuggestedPercent = 0;
		Double dblTotalCurrent = 0;
		Double dblTotalSuggested = 0;
		// Create list of Beans and return it to controller with asset percent populated.
		//Original Code
		/*List<PortfolioBean> portfolioBeanList = new List<PortfolioBean>();
	 	portfolioBean = portfolioBeanMap.get('Cash');
	 	portfolioBean.currentPercent = ( portfolioBean.currentAsset/totalAsset ) * 100;
	 	portfolioBean.suggestedPercent = ( portfolioBean.suggestedAsset/totalAsset ) * 100;
	 	dblCurrentPercent = dblCurrentPercent + portfolioBean.currentPercent;
	 	dblSuggestedPercent = dblSuggestedPercent + portfolioBean.suggestedPercent;
	 	portfolioBeanList.add(portfolioBean);
	 	
	 	portfolioBean = portfolioBeanMap.get('Equity');
	 	portfolioBean.currentPercent = ( portfolioBean.currentAsset/totalAsset ) * 100;
	 	portfolioBean.suggestedPercent = ( portfolioBean.suggestedAsset/totalAsset ) * 100;
	 	dblCurrentPercent = dblCurrentPercent + portfolioBean.currentPercent;
	 	dblSuggestedPercent = dblSuggestedPercent + portfolioBean.suggestedPercent;
	 	portfolioBeanList.add(portfolioBean);
	 	
	 	portfolioBean = portfolioBeanMap.get('Debt');
	 	portfolioBean.currentPercent = ( portfolioBean.currentAsset/totalAsset ) * 100;
	 	portfolioBean.suggestedPercent = ( portfolioBean.suggestedAsset/totalAsset ) * 100;
	 	dblCurrentPercent = dblCurrentPercent + portfolioBean.currentPercent;
	 	dblSuggestedPercent = dblSuggestedPercent + portfolioBean.suggestedPercent;
	 	portfolioBeanList.add(portfolioBean);
	 	
	 	portfolioBean = portfolioBeanMap.get('Gold');
	 	portfolioBean.currentPercent = ( portfolioBean.currentAsset/totalAsset ) * 100;
	 	portfolioBean.suggestedPercent = ( portfolioBean.suggestedAsset/totalAsset ) * 100;
	 	dblCurrentPercent = dblCurrentPercent + portfolioBean.currentPercent;
	 	dblSuggestedPercent = dblSuggestedPercent + portfolioBean.suggestedPercent;
	 	portfolioBeanList.add(portfolioBean);

	 	portfolioBean = portfolioBeanMap.get('Real Estate');
	 	portfolioBean.currentPercent = ( portfolioBean.currentAsset/totalAsset ) * 100;
	 	portfolioBean.suggestedPercent = ( portfolioBean.suggestedAsset/totalAsset ) * 100;
	 	dblCurrentPercent = dblCurrentPercent + portfolioBean.currentPercent;
	 	dblSuggestedPercent = dblSuggestedPercent + portfolioBean.suggestedPercent;
	 	portfolioBeanList.add(portfolioBean);*/
	 	portfolioBean = portfolioBeanMap.get('Cash');
	 	dblTotalCurrent += portfolioBean.currentAsset;
	 	dblTotalSuggested += portfolioBean.suggestedAsset;
	 	
	 	portfolioBean = portfolioBeanMap.get('Equity');
	 	dblTotalCurrent += portfolioBean.currentAsset;
	 	dblTotalSuggested += portfolioBean.suggestedAsset;
	 	
	 	portfolioBean = portfolioBeanMap.get('Debt');
	 	dblTotalCurrent += portfolioBean.currentAsset;
	 	dblTotalSuggested += portfolioBean.suggestedAsset;
	 	
	 	portfolioBean = portfolioBeanMap.get('Gold');
	 	dblTotalCurrent += portfolioBean.currentAsset;
	 	dblTotalSuggested += portfolioBean.suggestedAsset;
	 	
	 	portfolioBean = portfolioBeanMap.get('Real Estate');
	 	dblTotalCurrent += portfolioBean.currentAsset;
	 	dblTotalSuggested += portfolioBean.suggestedAsset;
	 	
	 	/*Aditi Satpute : 14/10/13 - Need to include Insurance in Portfoilio Summary*/
	 	portfolioBean = portfolioBeanMap.get(Label.Portfolio_Life_Insurance);
	 	dblTotalCurrent += portfolioBean.currentAsset;
	 	dblTotalSuggested += portfolioBean.suggestedAsset;
	 	
	 	//////////////////////////////////////////////////////
	 	List<PortfolioBean> portfolioBeanList = new List<PortfolioBean>();
	 	portfolioBean = portfolioBeanMap.get('Cash');
	 	portfolioBean.currentPercent =  (dblTotalCurrent != 0 ? ( portfolioBean.currentAsset/dblTotalCurrent ) * 100 : 0);
	 	portfolioBean.suggestedPercent = (dblTotalSuggested != 0 ? ( portfolioBean.suggestedAsset/dblTotalSuggested ) * 100 : 0);
	 	dblCurrentPercent = dblCurrentPercent + portfolioBean.currentPercent;
	 	dblSuggestedPercent = dblSuggestedPercent + portfolioBean.suggestedPercent;
	 	portfolioBeanList.add(portfolioBean);
	 	portfolioBean = portfolioBeanMap.get('Equity');
	 	portfolioBean.currentPercent =  (dblTotalCurrent != 0 ? ( portfolioBean.currentAsset/dblTotalCurrent ) * 100 : 0);
	 	portfolioBean.suggestedPercent = (dblTotalSuggested != 0 ? ( portfolioBean.suggestedAsset/dblTotalSuggested ) * 100 : 0);
	 	dblCurrentPercent = dblCurrentPercent + portfolioBean.currentPercent;
	 	dblSuggestedPercent = dblSuggestedPercent + portfolioBean.suggestedPercent;
	 	portfolioBeanList.add(portfolioBean);
	 	
	 	portfolioBean = portfolioBeanMap.get('Debt');
	 	portfolioBean.currentPercent =  (dblTotalCurrent != 0 ? ( portfolioBean.currentAsset/dblTotalCurrent ) * 100 : 0);
	 	portfolioBean.suggestedPercent = (dblTotalSuggested != 0 ? ( portfolioBean.suggestedAsset/dblTotalSuggested ) * 100 : 0);
	 	dblCurrentPercent = dblCurrentPercent + portfolioBean.currentPercent;
	 	dblSuggestedPercent = dblSuggestedPercent + portfolioBean.suggestedPercent;
	 	portfolioBeanList.add(portfolioBean);
	 	
	 	portfolioBean = portfolioBeanMap.get('Gold');
	 	portfolioBean.currentPercent =  (dblTotalCurrent != 0 ? ( portfolioBean.currentAsset/dblTotalCurrent ) * 100 : 0);
	 	portfolioBean.suggestedPercent = (dblTotalSuggested != 0 ? ( portfolioBean.suggestedAsset/dblTotalSuggested ) * 100 : 0);
	 	dblCurrentPercent = dblCurrentPercent + portfolioBean.currentPercent;
	 	dblSuggestedPercent = dblSuggestedPercent + portfolioBean.suggestedPercent;
	 	portfolioBeanList.add(portfolioBean);

	 	portfolioBean = portfolioBeanMap.get('Real Estate');
	 	portfolioBean.currentPercent =  (dblTotalCurrent != 0 ? ( portfolioBean.currentAsset/dblTotalCurrent ) * 100 : 0);
	 	portfolioBean.suggestedPercent = (dblTotalSuggested != 0 ? ( portfolioBean.suggestedAsset/dblTotalSuggested ) * 100 : 0);
	 	dblCurrentPercent = dblCurrentPercent + portfolioBean.currentPercent;
	 	dblSuggestedPercent = dblSuggestedPercent + portfolioBean.suggestedPercent;
	 	portfolioBeanList.add(portfolioBean);
	 	
	 	/*Aditi Satpute : 14/10/13 - Need to include Insurance in Portfoilio Summary*/
	 	portfolioBean = portfolioBeanMap.get(Label.Portfolio_Life_Insurance);
	 	portfolioBean.currentPercent =  (dblTotalCurrent != 0 ? ( portfolioBean.currentAsset/dblTotalCurrent ) * 100 : 0);
	 	portfolioBean.suggestedPercent = (dblTotalSuggested != 0 ? ( portfolioBean.suggestedAsset/dblTotalSuggested ) * 100 : 0);
	 	dblCurrentPercent = dblCurrentPercent + portfolioBean.currentPercent;
	 	dblSuggestedPercent = dblSuggestedPercent + portfolioBean.suggestedPercent;
	 	portfolioBeanList.add(portfolioBean);
	 	
	 	totalAsset = dblTotalCurrent;
	 	totalAssetSuggested = dblTotalSuggested;
	 	system.debug('************getPortfolioSummary=======end=  Inside NewPortfolioSummary >'+Limits.getQueries());
		return portfolioBeanList;
		
			
	}	
}