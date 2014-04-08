/**
 * @Author: Sandip C
 * @Description:SummaryActionPlanBean is used for Summary Action Plan which populated the data on the SummaryActionPlan.page. 
 * This is act as Bean class for the SummaryActionPlanController
 */

public class SummaryActionPlanBean
{
	public List<SAssetAllocationBean> aaBeanList{get;set;}
	public List<UnallocatedAssets> unallocatedList{get;set;}	/* Prajakta - FP changes - 22-05-2013 - For unallocated assets added this list */
    public List<AssetClass> asetList{get;set;}
    public List<SIPClass> sipList{get;set;}
    public String entityId {get;set;}
    public List<double> totLumpSumList{get;set;}
    public List<double> totSIPList{get;set;}
    /*public Integer equityTot{get;set;}
    public Integer debtTot{get;set;}
    public Integer goldTot{get;set;}
    
    public Map<String, Integer> mapTot = new Map<String, Integer>();*/
    Public List<Account> accList = new List<Account>();
    Public List<Goal__c> goalList {get;set;}
    public List<Insurance__c> giList{get;set;}
    public List<Insurance__c> liList{get;set;}
    public boolean isGeneralInsExist{get;set;}
    public boolean isLifeInsExist{get;set;}
 
   /**
   * @Description: Constructor to initialise the bean properties
   * param: None 
   * return type: 
   */   
    public SummaryActionPlanBean()
    {
       giList = new List<Insurance__c>();
       goalList = new List<Goal__c>();
       aaBeanList = new List<SAssetAllocationBean>();
       unallocatedList = new List<UnallocatedAssets>(); /* Prajakta - FP changes - 22-05-2013 */
       sipList = new List<SIPClass>();
       asetList= new List<AssetClass>();
       totLumpSumList = new List<double>();
       totSIPList = new List<double>();
       isGeneralInsExist = false;
       isLifeInsExist = false;
    }
  
    /**
    * @Description: inner class to show data of Asset Allocation
    * param: None 
    * return type: 
    */   
	public class SAssetAllocationBean 
   	{
   		public SAssetAllocationBean()
        {
        	//Do Nothing
        }
        public String entityName {get;set;}
        public String action {get;set;}
        public String goalName {get;set;}
        public String Assets {get;set;}
        public Double allocatedAmount {get;set;}
        public Double allocatedPercent {get;set;}   /* Prajakta - FP changes - 21-03-2013 */
    }  
    
    /** Prajakta - FP changes II - 22-05-2013 */ 
    /* @Description: inner class to show data of UnAllocated Assets  
    */   
	public class UnallocatedAssets 
   	{
   		public UnallocatedAssets()
        {
        	//Do Nothing
        }
        public String Assets {get;set;}
        public String entityName {get;set;}
        public String description {get;set;}
        public Double currentValue {get;set;}
        public Double balanceRemaining {get;set;}
    }
    
    /**
    * @Description: inner class to show data of Asset
    * param: None 
    * return type: 
    */ 
    public class AssetClass
    {
        public AssetClass(String classNameP, List<double> golListValsP)
        {
            className = classNameP;
            golListVals = golListValsP;
        }
        
        public String className {get;set;}
        public List<double> golListVals {get;set;}
    }
  
    /**
    * @Description: inner class to show data of SIP value
    * param: None 
    * return type: 
    */   
    public class SIPClass
    {
        public SIPClass(String classNameP, List<double> golListValsP)
        {
            className = classNameP;
            golListVals = golListValsP;
        }
        
        public String className {get;set;}
        public List<double> golListVals {get;set;}
    }
}