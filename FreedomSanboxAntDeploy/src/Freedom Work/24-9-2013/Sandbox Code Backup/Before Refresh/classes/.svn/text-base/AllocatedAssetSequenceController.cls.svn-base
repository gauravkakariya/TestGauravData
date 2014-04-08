/**
	Version     Version Author     Date        Comments
    1.0			Anupam Agrawal     22/02/2013 	Controller provide Assets Allocation order functionality.
**/    	
										
public with sharing class AllocatedAssetSequenceController 
{
	//Public variables
	public List<AssetSelection> lstAssetSelection {get;set;}
	public List<SelectOption> optionsOrderList {get;set;}
	public String strOncomplete {get;set;}
	//Private variables
	private String goalId;
	private Map<String, List<GoalInvestmentAssetAssociation__c>> mapRecordTypeWithEntityNameToGoalInvestmentAssetAssociation = new Map<String, List<GoalInvestmentAssetAssociation__c>>();
	
	//Class stroe values to display on page
	public class AssetSelection
	{
		public String assetName{get;set;}
		public String allocationSequence {get;set;}
		public String assetId {get;set;}
		public String assetType {get;set;}
		public String entityName {get;set;}
		
		//Constructor
		public AssetSelection(String assetName, Decimal allocationSequence, String assetId, String assetType, String entityName)
		{
			this.assetName = assetName;
			this.allocationSequence = String.valueOf(allocationSequence);
			this.assetId = assetId;
			this.assetType = assetType;
			this.entityName = entityName;
		}
	}
	
	//Constructor
	public AllocatedAssetSequenceController()
	{
		lstAssetSelection = new List<AssetSelection>();
		strOncomplete = 'yes';
		//Fetch Url parameter.
		goalId = Apexpages.currentPage().getParameters().get('gid');
		
		//Create list of AssetSelection class with Asset Allocation records.
        for(GoalAssetAssociation__c objGAA : getGoalAssetAllocations(goalId))
		{
			//Record type == Real Estate Assets then use Asset_type__c field as Asset Name.
			System.debug('------------------------------------'+objGAA.Asset__r.RecordType.Name);
			System.debug('------------------------------------'+objGAA.Asset__r.Asset_Types__c);
			if(objGAA.Asset__r.RecordType.Name == 'Real Estate Assets' || objGAA.Asset__r.RecordType.Name == 'Personal Assets'
				|| objGAA.Asset__r.RecordType.Name == 'Business Assets')
				lstAssetSelection.add(new AssetSelection(objGAA.Asset__r.Asset_Types__c, objGAA.Allocation_Order__c, objGAA.Id, 'Asset', objGAA.Asset__r.Entity__r.Name));
			else
				lstAssetSelection.add(new AssetSelection(objGAA.Asset__r.Account_Type__c, objGAA.Allocation_Order__c, objGAA.Id, 'Asset', objGAA.Asset__r.Entity__r.Name));
		}
		
		//list of AssetSelection class with Investment Asset Allocation records.
		for(GoalInvestmentAssetAssociation__c objGIAA :  getGoalInvestmentAssociations(goalId))
		{
			//Create key value
			String strKey = objGIAA.Investment_Asset__r.RecordType.Name + '~~' + objGIAA.Investment_asset__r.entity__r.Name;
			System.debug('--------------------Record type------------------'+objGIAA.Investment_Asset__r.RecordType.Name);
			//Create Map using all record type (Stock, Mutual fund, Goal) except Fixed Income.
			if(objGIAA.Investment_Asset__r.RecordType.Name != 'Fixed Income')
			{
				if(!mapRecordTypeWithEntityNameToGoalInvestmentAssetAssociation.containsKey(strKey))
				{
					lstAssetSelection.add(new AssetSelection(objGIAA.Investment_Asset__r.RecordType.Name, objGIAA.Allocation_Order__c, objGIAA.Id, 'Investment Asset', objGIAA.Investment_asset__r.entity__r.Name));
					mapRecordTypeWithEntityNameToGoalInvestmentAssetAssociation.put(strKey, new List<GoalInvestmentAssetAssociation__c> {objGIAA});
				}
				else
				{
					mapRecordTypeWithEntityNameToGoalInvestmentAssetAssociation.get(strKey).add(objGIAA);
				}
			}
			else //If record type is Fixed Income.
				lstAssetSelection.add(new AssetSelection(objGIAA.Investment_Asset__r.RecordType.Name, objGIAA.Allocation_Order__c, objGIAA.Id, 'Investment Asset', objGIAA.Investment_asset__r.entity__r.Name));
		}
		
		//list of AssetSelection class with Insurance  records.
        for(GoalInsuranceAssociation__c objGInsuranceAA : getGoalInsuranceAllocations(goalId))
		{
			lstAssetSelection.add(new AssetSelection(objGInsuranceAA.Insurance__r.Policy_Type__c, objGInsuranceAA.Allocation_Order__c, objGInsuranceAA.Id, 'Insurance', objGInsuranceAA.Insurance__r.Entity__r.Name));
		}
		
		getOrderList();
	}
	
	//Return list of Allocated Assets
	private List<GoalAssetAssociation__c> getGoalAssetAllocations(String goalId)
	{
		List<GoalAssetAssociation__c> lstGoalAA =  [SELECT Goal__c, Asset__r.Entity__r.Name, Asset__r.action__c, Asset__r.RecordType.Name, Asset__r.Asset_Types__c, 
														   Asset__r.Account_Type__c, Allocation_Order__c 
                                                    FROM GoalAssetAssociation__c where Goal__c =: goalId and Asset__r.action__c != '---None----'];  
		return lstGoalAA;
	}
	
	//Return list of Investment Asset.
	private List<GoalInvestmentAssetAssociation__c> getGoalInvestmentAssociations(String goalId)
	{
		List<GoalInvestmentAssetAssociation__c> lstGIAA =  [SELECT Investment_Asset__c, Goal__c, Investment_Asset__r.RecordType.Name, 
                                                                   Investment_asset__r.entity__r.Name, Investment_asset__r.action__c, Investment_asset__r.TotalAsset__c,
                                                                   Investment_asset__r.Allocated_Amount__c, Allocation_Order__c FROM GoalInvestmentAssetAssociation__c 
                                                                  WHERE Allocated__c!=null and Goal__c =: goalId and Investment_asset__r.action__c != '---None----'];
        return lstGIAA;
	}
	
	//Return list of Insurance Allocation.
	private List<GoalInsuranceAssociation__c> getGoalInsuranceAllocations(String goalId)
	{
		List<GoalInsuranceAssociation__c> lstGoalIA =  [SELECT Insurance__c, Goal__c, Goal__r.Description__c,Insurance__r.RecordType.Name, Insurance__r.Entity__r.Name,
                                                               Insurance__r.action__c, Insurance__r.total_insurance__c, Insurance__r.Policy_Type__c, Allocation_Order__c
                                                    		   FROM  GoalInsuranceAssociation__c  where Goal__c =: goalId and Insurance__r.action__c != '---None----'];  
		return lstGoalIA;
	}
	
	
	//method returning list of Allocation order.
	public List<SelectOption> getOrderList()
	{
		optionsOrderList = new List<SelectOption>();      
        for(Integer i = 1 ; i <= lstAssetSelection.size() ; i++)
        	optionsOrderList.add(new SelectOption(String.valueOf(i) , String.valueOf(i))); 
		return optionsOrderList;
	}
	
	
	public void saveOrder()
	{
		strOncomplete = 'yes';
		List<GoalAssetAssociation__c> lstGoalAssetAssociation = new List<GoalAssetAssociation__c>();
		List<GoalInvestmentAssetAssociation__c> lstGoalInvestmentAssetAssociation = new List<GoalInvestmentAssetAssociation__c>();
		List<GoalInsuranceAssociation__c> lstGoalInsuranceAssociation = new List<GoalInsuranceAssociation__c>();
		Set<Integer> setAllocationOrder = new Set<Integer>();
		for(AssetSelection objAssetSelection : lstAssetSelection)
		{
			setAllocationOrder.add(Integer.valueOf(objAssetSelection.allocationSequence));
			if(objAssetSelection.assetType == 'Asset')
			{
				GoalAssetAssociation__c objGoalAssetAssociation = new GoalAssetAssociation__c(Id = objAssetSelection.assetId);
				objGoalAssetAssociation.Allocation_Order__c = Integer.valueOf(objAssetSelection.allocationSequence);
				lstGoalAssetAssociation.add(objGoalAssetAssociation);
			
			}
			else if(objAssetSelection.assetType == 'Investment Asset')
			{
				String strKey = objAssetSelection.assetName + '~~' + objAssetSelection.entityName;
				if(mapRecordTypeWithEntityNameToGoalInvestmentAssetAssociation.containsKey(strKey))
				{
					for(GoalInvestmentAssetAssociation__c objGIAA : mapRecordTypeWithEntityNameToGoalInvestmentAssetAssociation.get(strKey))
					{
						GoalInvestmentAssetAssociation__c objGoalInvestmentAssetAssociation = new GoalInvestmentAssetAssociation__c(Id = objGIAA.Id);
						objGoalInvestmentAssetAssociation.Allocation_Order__c = Integer.valueOf(objAssetSelection.allocationSequence);
						lstGoalInvestmentAssetAssociation.add(objGoalInvestmentAssetAssociation);
					}
				}
				else
				{
					GoalInvestmentAssetAssociation__c objGoalInvestmentAssetAssociation = new GoalInvestmentAssetAssociation__c(Id = objAssetSelection.assetId);
					objGoalInvestmentAssetAssociation.Allocation_Order__c = Integer.valueOf(objAssetSelection.allocationSequence);
					lstGoalInvestmentAssetAssociation.add(objGoalInvestmentAssetAssociation);
				}
					
			}
			else if(objAssetSelection.assetType == 'Insurance')
			{
				GoalInsuranceAssociation__c objGoalInsuranceAssociation = new GoalInsuranceAssociation__c(Id = objAssetSelection.assetId);
				objGoalInsuranceAssociation.Allocation_Order__c = Integer.valueOf(objAssetSelection.allocationSequence);
				lstGoalInsuranceAssociation.add(objGoalInsuranceAssociation);
			}
		}
		if(setAllocationOrder.size() != optionsOrderList.size())
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Allocation order should be unique.'));
			strOncomplete = 'no';
			return;
		}
		if(!lstGoalAssetAssociation.isEmpty())
			update lstGoalAssetAssociation;
			
		if(!lstGoalInvestmentAssetAssociation.isEmpty())
			update lstGoalInvestmentAssetAssociation;
			
		if(!lstGoalInsuranceAssociation.isEmpty())
			update lstGoalInsuranceAssociation;
	}
}