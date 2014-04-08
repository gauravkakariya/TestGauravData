/*
	Revision History:
	2.0         Niket              14/06/2011   Added the one property in AssetDetailBean Class
												String AssetType; 
												Summary : This property holds the Asset type for the portfolio 
												calculation.
	2.0         Mahesh             14/06/2011   1.  Added the one property in AssetDetailBean Class
													String Description; 
													Summary : This property holds the Description of all Asset Types to show on Asset Allocation Page
												2. Added new parameter named as Description to populateAssetDetailList()
												
*/

/*
	This bean is to provide single interface to handle  association  between asset and Goal on Asset Allocation.
	Possible combinations are
	Goal Asset Association
	Goal Insurance Association
	Goal Invesmtnet Asset Association	 
*/
public class AssetAllocationBean 
{ 
    public MAP<ID,Asset__c> assetMap 
    { 
        get {
            if(assetMap == null) {
                assetMap = new Map<ID, Asset__c>();                                              
            }
            return assetMap;
        }
        set;
    }                                       
    // We are using record Type here                                
    public Map<String, List<Investment_Asset__c>> investmentAssetMap {get;set;}
    public Map<ID, Insurance__c> insuranceMap { get;set;}    
    // ID will be Goal ID
    public Map<ID, List<GoalAssetAssociation__c>> goalAssetAssociationMap {get;set;}
    public Map<ID, List<GoalInvestmentAssetAssociation__c>> goalInvAssetAssociationMap {get;set;}
    public Map<ID, List<GoalInsuranceAssociation__c>> goalInsuranceAssociationMap {get;set;}
    
    
    public List<AssetRecordTypeBean> assetRecordTypeBeanList 
    { 
        get 
        {
            if(assetRecordTypeBeanList == null)
            {
                assetRecordTypeBeanList = new List<AssetRecordTypeBean>();
            }
            return assetRecordTypeBeanList;
        }   
        set;
   
	}
    public List<String> headerList 
    {
        get {
                if(headerList== null) {
                    headerList = new List<String>();
                   /* headerList.add('Assets');
                    headerList.add('Current Value');
                    headerList.add('Availaible');
                    headerList.add('Allocated');
                    headerList.add('Balance Remaining'); */                                                                                   
                }   
                return headerList;
        }
        set;
    }
    
    /*private void updateAssetRelatedData(AssetRecordTypeBean assetRecord , AssetTypeBean assetTypeBean , AssetDetailBean detailedBean) {
        InvestmentAsset__c assetObj;
        assetObj = assetMap.get(detailedBean.assetId);
        
        assetObj = assetMap.get(detailedBean.assetId);
        assetObj.Action__c = detailedBean.action;
                                                                                
        for(GoalAssetMapping goalAssetMapping :detailedBean.goalAssetMappingList) {

            goalAsetAssociationList =  goalAssetAssociationMap.get(goalAssetMapping.goalId);            
            recordInDbFlag = false;
            
            for(GoalAssetAssociation__c goalAssetAssociation : goalAsetAssociationList) {
                if(detailedBean.assetId.equals(goalAssetAssociation.Asset__c)){
                    goalAssetAssociation.Allocated__c = goalAssetMapping.assetallocated;
                    recordInDbFlag = true;
                }       
            }
            if((!recordInDbFlag) && (goalAssetMapping.assetAllocated >0)) {             
                GoalAssetAssociation__c goalAssetAssociation = new GoalAssetAssociation__c();
                goalAssetAssociation.Goal__c = goalAssetMapping.goalId;
                goalAssetAssociation.Asset__c = detailedBean.assetId;
                goalAssetAssociation.Allocated__c = goalAssetMapping.assetAllocated;                                                                                                            
            }               
        }               
    }           
    public void updateAllList()  {              
        for(AssetRecordTypeBean assetRecord : assetRecordTypeBeanList) {
            for(AssetTypeBean assetTypeBean : assetRecord.assetTypeList) {
                for(AssetDetailBean detailedBean : assetTypeBean.assetDetailList) {                 
                    if('Asset'.equals(assetRecord.parentType)) {
                        updateAssetRelatedData(assetRecord,assetTypeBean,detailedBean);
                    }                   
                }   
            }
        }                               
    } */
    // This method is to add a new RecordType Bean in list
    public AssetRecordTypeBean populateRecordTypeBeanList(String parentType,String recordType) 
    {
        AssetRecordTypeBean bean = new AssetRecordTypeBean();
        bean.parentType = parentType;
        bean.recordTypeName = recordType;
        bean.index = assetRecordTypeBeanList.size();
        assetRecordTypeBeanList.add(bean);
        return bean;
    }
    
    /*
    	This class is being used to show Asset ALlocation page based on record type. It is being used to separate Assets on record Type basis.
    */
    public class AssetRecordTypeBean 
    {
        public Integer index {get;set;}
        public String parentType;
        public String recordTypeName {get; set;}
        public List<AssetTypeBean>  assetTypeList 
        { 
        	get
        	{
	            if(assetTypeList == null)
	            {
	                assetTypeList = new List<AssetTypeBean>();
	            }
	            return assetTypeList;
	        }
	        set;
        }
        
        public AssetTypeBean populateAssetTypeBeanList(String assetTypeName) 
        {
        	AssetTypeBean assetTypeBean = new AssetTypeBean();
            assetTypeBean.assetTypeName = assetTypeName;
            assetTypeBean.index = assetTypeList.size();
            assetTypeList.add(assetTypeBean);
            return  assetTypeBean;  
        }
    }
    
    /*
    	This class is to have one more layer of classification of assets.
    */
    public class AssetTypeBean 
    {
        public Integer index {get;set;}
        public String assetTypeName {get;set;}
        public List<AssetDetailBean>  assetDetailList 
        {
        	get 
        	{
                if(assetDetailList==null) 
                {
                    assetDetailList = new List<AssetDetailBean>();
                }
                return assetDetailList;
            }
            set;
        }
        
        public AssetDetailBean populateAssetDetailList(String entityName, String Description, Double assetCurrentValue,String action,ID assetId)
        {
        	AssetDetailBean bean = new AssetDetailBean();
            bean.entityName = entityName;
            bean.assetCurrentValue = assetCurrentValue;
            bean.action = action;
            bean.assetId = assetId; 
            bean.index  = assetDetailList.size();
            bean.Description = Description;
            assetDetailList.add(bean);
            return bean;
        }
    }
    /*
    	This class is holding current asset amount and entity details 
    */
    
    /*
    	Modified By : Niket Chandane.
    	Modified At : 14 June 2011
    	Summary     :  Added one property "AssetType" Which hold the Assetstype ie. 
    				   Equity or Debt and this property is used in the Portfolio summary.
    */
    public class AssetDetailBean 
    {
        public Integer index {get;set;}
        public Double assetCurrentValue { get;set;}
        public String entityName { get;set;}
        public String entityId 	{ get;set;}
        public String AssetType{get;set;} // Property Created By : Niket Chandane for the Portfolio calculation Isuue.
        public String Description{get;set;} // Property created by Mahesh to show Asset Description on New Asset Allocation Page
        public String allocatedPercent 
        {
			get 
			{
                if(allocatedPercent== null) 
                    allocatedPercent = '0';
                return allocatedPercent;
            }
            set;
       }
     /*   public List<SelectOption> actionList {get {                             
                                                    List<SelectOption> options = new List<SelectOption>();      
                                                    Schema.DescribeFieldResult fieldResult = Asset__c.Action__c.getDescribe();
                                                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                                                    options.add(new SelectOption('---None----','---None----'));                                                    
                                                    for(Schema.PicklistEntry f : ple) {
                                                        options.add(new SelectOption(f.getLabel(), f.getValue()));
                                                    }       
                                                    return options;                                             
                                            }
                                            set;
                                        }*/
        // To show Action list for each asset
        public List<SelectOption> actionList{get;set;}
        // It is for calculation purpose
        public Decimal availablePercent 
        {
            get 
            {
                if(allocatedPercent != null)
                    return  (100- Decimal.valueof(allocatedPercent));
                else 
                    return 100;
            }
            set;
        }
        
        // It is for calculation purpose
        public Double balance 
        {
                get 
                {
                    if(allocatedPercent != null) 
                        return ( assetCurrentValue * ((100- Decimal.valueof(allocatedPercent)) / 100 ));
                    else 
                        return  assetCurrentValue;
                }
                set;
        }
        public String action { get; set;}
        public ID assetId {get;set;}
        
        public List<GoalAssetMapping>  goalAssetMappingList 
        {
        	get {
                    if(goalAssetMappingList == null) 
                        goalAssetMappingList = new List<GoalAssetMapping>();
                    return goalAssetMappingList;
                } 
            set;
        }
        
        public GoalAssetMapping populateGoalAssetMappingList(ID goalId,String assetAllocated) 
        {
            GoalAssetMapping bean = new GoalAssetMapping();
            bean.index = goalAssetMappingList.size();
            bean.goalId = goalId;
            bean.assetAllocated = assetAllocated;
            goalAssetMappingList.add(bean);
            system.debug('*****goalAssetMappingList*****'+goalAssetMappingList);
            return bean;
        }
        
		public void populateGoalAssetMappingList(GoalAssetMapping mappingBean) 
		{            
            mappingBean.index = goalAssetMappingList.size();
            goalAssetMappingList.add(mappingBean);
    }   
    }   
    
    public class GoalAssetMapping 
    {
        public Integer index {get;set;}
        public ID goalId {get;set;} 
        public String goalAssetAssociationId;                    
        public Decimal goldAllocatedPercent { get;set;}
        public Decimal debtAllocatedPercent {get;set;}
        public Decimal equityAllocatedPercent {get;set;}
        public String assetAllocated 
        {
            get 
            {
                if(assetAllocated == null)
                    assetAllocated = '';                                                
                return assetAllocated;
            }
            set;
        }
    }
    
}