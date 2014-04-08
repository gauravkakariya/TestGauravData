/*
  Revision History:
  
    Version     Version Author     Date         Comments
    1.0         Sandip C            --          Initial Draft:ApprovedPlanBean is used for Approved plan which populated the data on the ApprovedPlan.page
    2.0      Manasi         7/12/2011    Added property in SuggestedMFSIP class.It will be usefull in Action Plan PDF generation at the time of ET
    3.0      Aditi S         27/09/2012   New Action Plan Creation
*/

global class ApprovedPlanBean 
{
    public List<SAssetAllocationBean> aaBeanList{get;set;}
    public List<DoneClass> doneLumpSum {get;set;}
    public List<DoneClass> doneSIP {get;set;}
    public List<DoneClass> suggestedLumpSum {get;set;}
    public List<DoneClass> SuggestedSIP {get;set;}
    public String entityId {get;set;}
    Public List<Account> accList = new List<Account>();
    Public List<Goal__c> goalList {get;set;}
    public List<Insurance__c> giList{get;set;}
    public List<Insurance__c> liList{get;set;}
    public List<Investment_Asset__c> investment = new List<Investment_Asset__c>();
    public List<CurrentMFLumpSum> currentMFLumpSumList {get;set;}
    public List<CurrentMFSIP> currentMFSIPList {get;set;}
    public List<SuggestedMFLumpSum> suggestedMFLumpSumList {get;set;}
    public List<SuggestedMFSIP> suggestedMFSIPList {get;set;}
    public Map<String, Id> recTypeMap = new Map<String, Id>();
    public List<Approved_Action_Plan__c> approvedPlanList = new List<Approved_Action_Plan__c>();
    
    public List<Insurance__c> giApprovedList{get;set;}
    public List<Insurance__c> liApprovedList{get;set;}
    public boolean isLifeInsExist{get;set;}
    public boolean isGeneralInsExist{get;set;}
    public boolean isLifeInsExist_in_Pdf_Html{get;set;}
    public boolean isGeneralInsExist_in_Pdf_Html{get;set;}
    
    //public List<Approve_Action_Plan__c> lstLifeInsuranceRecordCount{get;set;}
    //public static List<LifeInsurance> lstLifeInsuranceInnerclassRecordCount{get;set;}
    
   // public List<Approve_Action_Plan__c> lstGeneralInsuranceRecordCount{get;set;}
    //public List<GeneralInsurance> lstGeneralInsuranceInnerclassRecordCount{get;set;}
    
     public List<GeneralInsurance> lstGeneralInsuranceCombinedInnerclass{get;set;}
    
    public boolean isApprovedGeneralInsExist{get;set;}
    public boolean isApprovedLifeInsExist{get;set;}
    public String isWillExecutionTracker{get;set;}
    public double SIPSummaryTotal{get;set;}
    
    /*Prajakta - 7-8-2013*/
    public List<CurrentGoldSilver> lstCurrentGold{get;set;}
    public List<CurrentGoldSilver> lstSIPCurrentGold{get;set;}
    public Map<Id,List<CurrentGoldSilver>> mapIdToCurrentGold{get;set;}
    
    //=====Action Plan==============================================
    public List<GoalDetails> lstGoalDetails{get;set;}
    public GoalDetails objEmergencyFundGoalDetails{get;set;}
    public GoalDetails objEmergencyFundLumpsum{get;set;}
    public List<UnAllocatedAssets> lstUnAllocatedAssets{get;set;}
   
    public List<RecommendedInsurance> lstRecommendedInsurance{get;set;}
    
    public List<CurrentMutualFunds> lstCurrentFunds{get;set;}
    public List<CurrentMutualFunds> lstSIPCurrentFunds{get;set;}
    public Map<Id,List<CurrentMutualFunds>> mapIdToCurrentFunds{get;set;}
    
    public List<GeneralInsurance> lstGeneralInsurance{get;set;}
    public List<GeneralInsurance> lstNewGeneralInsurance{get;set;}
    public List<LifeInsurance> lstNewLifeInsurance{get;set;}
    
    public List<LifeInsurance> lstLifeInsurance{get;set;}
    public List<LifeInsurance> lstLifeInsuranceRemark{get;set;}
    public List<LifeInsurance> lstLifeInsurancePdfRemark{get;set;}
    
    public List<LifeInsurance> lstLifeInsuranceCombinedInnerclass{get;set;}
    
    public Map<String,List<CurrentGoldSilver>> mapActionToGoldSilverlist {get;set;}
    public Map<String,List<CurrentGoldSilver>> mapActionToGoldSilverSIPlist {get;set;}
	public Map<String,List<CurrentGoldSilver>> mapActionToCurrentGSlist {get;set;}
    public Map<String,List<CurrentGoldSilver>> mapActionToCurrentGSSIPlist {get;set;}
	
    public Map<String,List<CurrentMutualFunds>> mapActionToCurrentMFlist {get;set;}
    public Map<String,List<CurrentMutualFunds>> mapActionToCurrentMFSIPlist {get;set;}
    public Map<String,List<LifeInsurance>> mapIdToLifeInsuranceInnerClass{get;set;}
    //public Map<String,List<LifeInsurance>> mapIdToLifeInsuranceInnerClass_Html_Pdf{get;set;}
    
    public List<Loan> lstLoan{get;set;}
    public List<FixedDeposit> lstFixedDeposit{get;set;}
    public List<Bond> lstBond{get;set;}
    
    
    public map<String, map<String,List<String>>> mapIdToMapMFTolstProducts{get;set;}
     
  /**
  * @Description: Constructor to initialise the bean properties
  * param: None 
  * return type: 
  */
    public ApprovedPlanBean()
    {
        giList = new List<Insurance__c>();
        liList = new List<Insurance__c>();
        giApprovedList = new List<Insurance__c>();
        liApprovedList = new List<Insurance__c>();
        doneLumpSum = new List<DoneClass>();
        doneSIP  = new List<DoneClass>();
        goalList = new List<Goal__c>();
        aaBeanList = new List<SAssetAllocationBean>();
        suggestedLumpSum = new List<DoneClass>();
        SuggestedSIP = new List<DoneClass>();
       
        currentMFLumpSumList = new List<CurrentMFLumpSum>();
        currentMFSIPList = new List<CurrentMFSIP>();
        suggestedMFLumpSumList = new List<SuggestedMFLumpSum>();
        suggestedMFSIPList = new List<SuggestedMFSIP>();
        lstGoalDetails = new List<GoalDetails>();
        lstUnAllocatedAssets = new List<UnAllocatedAssets>();
      	lstRecommendedInsurance = new List<RecommendedInsurance>();
      	lstCurrentFunds = new List<CurrentMutualFunds>();
      	lstSIPCurrentFunds = new List<CurrentMutualFunds>();
      	lstLifeInsurance = new List<LifeInsurance>();
      	lstLifeInsuranceRemark = new List<LifeInsurance>();
      	lstLifeInsurancePdfRemark = new List<LifeInsurance>();
      	lstGeneralInsurance = new List<GeneralInsurance>();
      	objEmergencyFundGoalDetails = new GoalDetails();
      	objEmergencyFundLumpsum = new  GoalDetails();
      	mapIdToCurrentFunds = new Map<Id,List<CurrentMutualFunds>>();
      	
      	mapActionToCurrentGSlist = new Map<String,List<CurrentGoldSilver>>();
      	mapActionToCurrentGSSIPlist = new Map<String,List<CurrentGoldSilver>>();
      	mapActionToCurrentMFlist = new Map<String,List<CurrentMutualFunds>>();
      	mapActionToCurrentMFSIPlist = new Map<String,List<CurrentMutualFunds>>();
      	mapIdToLifeInsuranceInnerClass = new Map<String,List<LifeInsurance>>();
      	//mapIdToLifeInsuranceInnerClass_Html_Pdf = new Map<String,List<LifeInsurance>>();
      	lstNewGeneralInsurance = new List<GeneralInsurance>();
      	lstNewLifeInsurance = new List<LifeInsurance>();
      	isWillExecutionTracker = '';
        isLifeInsExist = false;
        isGeneralInsExist = false;
        isLifeInsExist_in_Pdf_Html = false;
        isGeneralInsExist_in_Pdf_Html = false;
        isApprovedGeneralInsExist = false;
        isApprovedLifeInsExist = false;
        
        /*Prajakta - 7-8-2013*/
        mapIdToCurrentGold = new Map<Id,List<CurrentGoldSilver>>();
        lstCurrentGold = new List<CurrentGoldSilver>();
        lstSIPCurrentGold = new List<CurrentGoldSilver>();
        mapIdToCurrentGold = new Map<Id,List<CurrentGoldSilver>>();
        
        //lstLifeInsuranceRecordCount = new List<Approve_Action_Plan__c>();
        //lstLifeInsuranceInnerclassRecordCount = new List<LifeInsurance>();
        lstLifeInsuranceCombinedInnerclass = new List<LifeInsurance>();
        
        //lstGeneralInsuranceRecordCount = new List<Approve_Action_Plan__c>();
        //lstGeneralInsuranceInnerclassRecordCount = new List<GeneralInsurance>();
        lstGeneralInsuranceCombinedInnerclass = new List<GeneralInsurance>();
        
        lstLoan = new List<Loan>();
        lstFixedDeposit = new List<FixedDeposit>();
        lstBond = new List<Bond>();
    }
	
	//=======@Description: inner class to show data of Other Products - Loan==================================================================================
	public class Loan //implements Comparable
  	{
    	public String applicant{get;set;}
        public String loanType{get;set;}
       	public String vendorName {get;set;}
       	public Long loanAmount {get;set;}
        public boolean isAddOnExecTracker{get;set;}
       	public String AddOnExecutionTracker{get;set;}
       	public String loanAPid{get;set;}
		public boolean isRemove{get;set;}
		public String ETStatus {get;set;}
		public String strAssignedToOps{get;set;}
		public Integer index {get;set;}
       	
       	public Loan()
       	{
         	isRemove = false;
       	}
 	} 
	
 	public Loan populateLoan(String applicant, String loanType, String vendorName, Long loanAmount,boolean isAddOnExecTracker,
                        String AddOnExecutionTracker, String loanAPid,String ETStatus, Integer index)
    {
    	Loan objLoan = new Loan();
	    objLoan.applicant = applicant;
	    objLoan.loanType = loanType;
	    objLoan.vendorName = vendorName;
	    objLoan.loanAmount = loanAmount;
	    objLoan.isAddOnExecTracker = isAddOnExecTracker;
	    objLoan.AddOnExecutionTracker = AddOnExecutionTracker;
	    objLoan.loanAPid = loanAPid;
	    objLoan.ETStatus = ETStatus;
	    objLoan.index= index;
	    lstLoan.add(objLoan);
	    return objLoan;
    }
    //Added on : 06/12/13 : Aditi Satpute - Function for Execution Tracker
    public Loan populateLoan(String applicant, String loanType, String vendorName, Long loanAmount,boolean isAddOnExecTracker,
                        String AddOnExecutionTracker, String loanAPid,String ETStatus,String strAssignedToOps)
    {
    	Loan objLoan = new Loan();
	    objLoan.applicant = applicant;
	    objLoan.loanType = loanType;
	    objLoan.vendorName = vendorName;
	    objLoan.loanAmount = loanAmount;
	    objLoan.isAddOnExecTracker = isAddOnExecTracker;
	    objLoan.AddOnExecutionTracker = AddOnExecutionTracker;
	    objLoan.loanAPid = loanAPid;
	    objLoan.ETStatus = ETStatus;
	    objLoan.strAssignedToOps = strAssignedToOps;
	    lstLoan.add(objLoan);
	    return objLoan;
    }
    
    
    //=======@Description: inner class to show data of Other Products - Fixed Deposit====Added on 11/12/13==============================================================================
	public class FixedDeposit //implements Comparable
  	{
    	/*public String applicant{get;set;}
        public String goalType{get;set;}
       	public Approve_Action_Plan__c actionPlanObj {get;set;}
       	public String schemeName {get;set;}
        public decimal periodInMonths{get;set;}
       	public Long investmentAmount{get;set;}
       	public boolean isAddOnExecTracker{get;set;}
       	public String AddOnExecutionTracker{get;set;}
       	public String loanFDid{get;set;}
		public boolean isRemove{get;set;}
		public String ETStatus {get;set;}
		public String strAssignedToOps{get;set;}
		public Integer index {get;set;}
       	*/
       	public Approve_Action_Plan__c actionPlanFDobj {get;set;}
       	public String companyName {get;set;}
       	public String AddOnExecutionTracker{get;set;}
		public boolean isRemove{get;set;}
		public String ETStatus {get;set;}
		public String strAssignedToOps{get;set;}
		public Integer index {get;set;}
       	public FixedDeposit()
       	{
         	isRemove = false;
       	}
 	} 
	
 	public FixedDeposit populateFixedDeposit(Approve_Action_Plan__c actionPlanFDobj,String companyName,String AddOnExecutionTracker, String ETStatus,Integer index)
    {
    	//error.debugLog('---populateFixedDeposit AP-');
    	FixedDeposit objFixedDeposit = new FixedDeposit();
	   /* objFixedDeposit.applicant = applicant;
	    objFixedDeposit.goalType = goalType;
	    objFixedDeposit.companyName = companyName;
	    objFixedDeposit.schemeName = schemeName;
	    objFixedDeposit.periodInMonths = periodInMonths;
	    objFixedDeposit.investmentAmount = investmentAmount;
	    objFixedDeposit.isAddOnExecTracker = isAddOnExecTracker;
	    objFixedDeposit.loanFDid = loanFDid;
	    */
	    objFixedDeposit.actionPlanFDobj = actionPlanFDobj;
	    objFixedDeposit.AddOnExecutionTracker = AddOnExecutionTracker;
	    objFixedDeposit.companyName = companyName;
	    objFixedDeposit.ETStatus = ETStatus;
	    objFixedDeposit.index= index;
	    lstFixedDeposit.add(objFixedDeposit);
	    return objFixedDeposit;
    }
    //Added on : 12/12/13 : Aditi Satpute - Function for Execution Tracker
    public FixedDeposit populateFixedDeposit(Approve_Action_Plan__c actionPlanFDobj,String companyName,String AddOnExecutionTracker, String ETStatus,String strAssignedToOps)
    {
    	//error.debugLog('---populateFixedDeposit ET--');
    	FixedDeposit objFixedDeposit = new FixedDeposit();
	    objFixedDeposit.actionPlanFDobj = actionPlanFDobj;
	    objFixedDeposit.companyName = companyName;
	    objFixedDeposit.AddOnExecutionTracker = AddOnExecutionTracker;
	    objFixedDeposit.ETStatus = ETStatus;
     	objFixedDeposit.strAssignedToOps = strAssignedToOps;
	    lstFixedDeposit.add(objFixedDeposit);
	    return objFixedDeposit;
    }
    
    
     //=======@Description: inner class to show data of Other Products - Bond====Added on 16/12/13==============================================================================
	public class Bond //implements Comparable
  	{
       	public Approve_Action_Plan__c actionPlanBondObj {get;set;}
       	public String companyName {get;set;}
       	public String AddOnExecutionTracker{get;set;}
		public boolean isRemove{get;set;}
		public String ETStatus {get;set;}
		public String strAssignedToOps{get;set;}
		public Integer index {get;set;}
       	public Bond()
       	{
         	isRemove = false;
       	}
 	} 
	
 	public Bond populateBond(Approve_Action_Plan__c actionPlanBondObj,String companyName,String AddOnExecutionTracker, String ETStatus,Integer index)
    {
    	Bond objBond = new Bond();
	    objBond.actionPlanBondObj = actionPlanBondObj;
	    objBond.AddOnExecutionTracker = AddOnExecutionTracker;
	    objBond.companyName = companyName;
	    objBond.ETStatus = ETStatus;
	    objBond.index= index;
	    lstBond.add(objBond);
	    return objBond;
    }
    //Added on : 16/12/13 : Aditi Satpute - Function for Execution Tracker
    public Bond populateBond(Approve_Action_Plan__c actionPlanBondObj,String companyName,String AddOnExecutionTracker, String ETStatus,String strAssignedToOps)
    {
    	Bond objBond = new Bond();
	    objBond.actionPlanBondObj = actionPlanBondObj;
	    objBond.companyName = companyName;
	    objBond.AddOnExecutionTracker = AddOnExecutionTracker;
	    objBond.ETStatus = ETStatus;
     	objBond.strAssignedToOps = strAssignedToOps;
	    lstBond.add(objBond);
	    return objBond;
    }
    
  //=======@Description: inner class to show data of General Insurance==================================================================================
    public class GeneralInsurance //implements Comparable
  	{
    	public String insured{get;set;}
        public String insuredName{get;set;}
       	public String policyName {get;set;}
       	public String productName {get;set;}
       	public String policyType {get;set;}
       	public Long sumAssured {get;set;}
       	public Long premiumAmount {get;set;}
       	public boolean execTracker{get;set;}
       	public String executionTracker{get;set;}
       	public Id insuranceId {get;set;} 
       	public String actionPlanGeneralInsuranceID {get;set;} 
       	public boolean isRemove{get;set;}
       	public Boolean isETCreated{get;set;}
       	public String strAssignedToOps {get;set;}
       	public String ETStatus {get;set;}
       	//public Boolean displayGIbutton {get;set;}
       	//public String strFormsProvided {get;set;}
       	public Integer index {get;set;}
       	public String GeneralInsuranceActionPlanId {get;set;}
       	public List<String> generalInsuranceList {get;set;}
       	
       	public GeneralInsurance()
       	{
         	isRemove = false;
       	}
      /* 	global Integer compareTo(Object compareTo) 
       	{
       		GeneralInsurance compareToEmp = (GeneralInsurance)compareTo;
    		if(this.insured > compareToEmp.insured) 
    			return 1;
    		if(this.insured == compareToEmp.insured) 
    			return 0;	
    			
    		return -1;	
		}
       	*/
 	} 
    
    public GeneralInsurance populateGeneralInsurance(String insured, String policyName, Long premiumAmount, String policyType
                        , Long sumAssured, boolean execTracker, String executionTracker, Id insuranceId
                        ,String productName,Boolean isETCreated,String GeneralInsuranceActionPlanId,String ETStatus)
                        //,List<String> generalInsuranceList,Boolean displayGIbutton)
  	{
  		system.debug('---------one----------');
	    GeneralInsurance objGeneralInsurance = new GeneralInsurance();
	    objGeneralInsurance.insured = insured;
	    objGeneralInsurance.policyName = policyName;
	    objGeneralInsurance.productName = productName;
	    objGeneralInsurance.premiumAmount = premiumAmount;
	    objGeneralInsurance.policyType = policyType;
	    objGeneralInsurance.sumAssured = sumAssured;
	    objGeneralInsurance.execTracker = execTracker;
	    objGeneralInsurance.executionTracker = executionTracker;
	    objGeneralInsurance.insuranceId = insuranceId;
	    objGeneralInsurance.isETCreated = isETCreated;
	    objGeneralInsurance.GeneralInsuranceActionPlanId = GeneralInsuranceActionPlanId;
	    objGeneralInsurance.ETStatus = ETStatus;
	    //objGeneralInsurance.generalInsuranceList = generalInsuranceList;
	    //objGeneralInsurance.displayGIbutton = displayGIbutton;
	    lstGeneralInsurance.add(objGeneralInsurance);
	    if(objGeneralInsurance.productName != null && objGeneralInsurance.productName != '')
	    {	
      		//lstGeneralInsuranceInnerclassRecordCount.add(objGeneralInsurance);
      		lstGeneralInsuranceCombinedInnerclass.add(objGeneralInsurance);
	    }	
      		
	    return objGeneralInsurance;
  	}
  	//=======Date : 21/12/12 : Aditi======For General Insurance ET PopUp (added last parameter)======================
  	public GeneralInsurance populateGeneralInsurance(String insured, String policyName, Long premiumAmount, String policyType
                        , Long sumAssured, boolean execTracker, String executionTracker, Id insuranceId
                        ,String productName,String actionPlanGeneralInsuranceID,String strAssignedToOps,String ETStatus)
                       // ,String strFormsProvided)
  	{
  		system.debug('---------two----------');
	    GeneralInsurance objGeneralInsurance = new GeneralInsurance();
	    objGeneralInsurance.insured = insured;
	    objGeneralInsurance.policyName = policyName;
	    objGeneralInsurance.productName = productName;
	    objGeneralInsurance.premiumAmount = premiumAmount;
	    objGeneralInsurance.policyType = policyType;
	    objGeneralInsurance.sumAssured = sumAssured;
	    objGeneralInsurance.execTracker = execTracker;
	    objGeneralInsurance.executionTracker = executionTracker;
	    objGeneralInsurance.insuranceId = insuranceId;
	    objGeneralInsurance.actionPlanGeneralInsuranceID = actionPlanGeneralInsuranceID;
	    objGeneralInsurance.strAssignedToOps = strAssignedToOps;
	   	objGeneralInsurance.ETStatus = ETStatus;
	    //objGeneralInsurance.strFormsProvided = strFormsProvided;
	    lstGeneralInsurance.add(objGeneralInsurance);
	   
	    return objGeneralInsurance;
  	}
  
  
   
  
    public GeneralInsurance populateNewGeneralInsurance(String insured, Long premiumAmount, String policyType
                        , Long sumAssured, boolean execTracker, String executionTracker, String productName
                        ,String actionPlanGeneralInsuranceID,Boolean isETCreated,String insuredName,String ETStatus,Integer index)
                        //,List<String> generalInsuranceList,Boolean displayGIbutton)
  	{
	    GeneralInsurance objGeneralInsurance = new GeneralInsurance();
	    objGeneralInsurance.insured = insured;
	    objGeneralInsurance.insuredName = insuredName;
	    //objGeneralInsurance.policyName = policyName;
	    objGeneralInsurance.productName = productName;
	    objGeneralInsurance.premiumAmount = premiumAmount;
	    objGeneralInsurance.policyType = policyType;
	    objGeneralInsurance.sumAssured = sumAssured;
	    objGeneralInsurance.execTracker = execTracker;
	    objGeneralInsurance.executionTracker = executionTracker;
	    objGeneralInsurance.actionPlanGeneralInsuranceID = actionPlanGeneralInsuranceID;
	    objGeneralInsurance.isETCreated = isETCreated;
	    objGeneralInsurance.ETStatus = ETStatus;
	    //objGeneralInsurance.displayGIbutton = displayGIbutton;
	    //objGeneralInsurance.generalInsuranceList = generalInsuranceList;	//Prajakta
	    objGeneralInsurance.index = index;
	    //objGeneralInsurance.insuranceId = insuranceId;
	    system.debug('****objGeneralInsurance in ApprovedPlan Bean*********'+objGeneralInsurance);
	    lstNewGeneralInsurance.add(objGeneralInsurance);
	    lstGeneralInsuranceCombinedInnerclass.add(objGeneralInsurance);
	    return objGeneralInsurance;
  	}
  
  
  	//=======Date : 1/3/13 : Aditi======For New General Insurance ET===================
   	public GeneralInsurance populateNewGeneralInsurance(String insured, Long premiumAmount, String policyType
                        , Long sumAssured, boolean execTracker, String executionTracker, String productName
                        ,String actionPlanGeneralInsuranceID,String strAssignedToOps,String ETStatus)//,String strFormsProvided)
  	{
	    GeneralInsurance objGeneralInsurance = new GeneralInsurance();
	    objGeneralInsurance.insured = insured;
	    //objGeneralInsurance.policyName = policyName;
	    objGeneralInsurance.productName = productName;
	    objGeneralInsurance.premiumAmount = premiumAmount;
	    objGeneralInsurance.policyType = policyType;
	    objGeneralInsurance.sumAssured = sumAssured;
	    objGeneralInsurance.execTracker = execTracker;
	    objGeneralInsurance.executionTracker = executionTracker;
	    objGeneralInsurance.actionPlanGeneralInsuranceID = actionPlanGeneralInsuranceID;
	    objGeneralInsurance.strAssignedToOps = strAssignedToOps;
	    objGeneralInsurance.ETStatus = ETStatus;
	    //objGeneralInsurance.strFormsProvided = strFormsProvided;
	    //objGeneralInsurance.insuranceId = insuranceId;
	    lstNewGeneralInsurance.add(objGeneralInsurance);
	    return objGeneralInsurance;
  	}
   	//===================================================================================================================================================== 
   
   
    public class LifeInsurance
    {
       public String insured{get;set;}
       //public double suggestedCover {get;set;}
       public Long suggestedCover {get;set;}
       public String strSuggestedCover{get;set;}
       public String policyName {get;set;}
       //public Long premiumAmount {get;set;}
       public Long premiumAmount {get;set;}
       public String policyType {get;set;}
       public double tenureOfInsurance {get;set;}
       public boolean execTracker{get;set;}
       public String executionTracker{get;set;}
       public Id insuranceId {get;set;} 
       //Added on:06/02/2013 : Aditi Satpute : AP changes
       public Long sumAssured {get;set;}
       public String insuranceRemark{get;set;}
       //public Boolean displayRemoveButton {get;set;}
       public String actionPlanLifeInsuranceID{get;set;}
       public Boolean isNewLI{get;set;}
       public Integer newCount{get;set;}
       public Boolean isLast{get;set;}
       public Boolean isETCreated{get;set;}
       public String strAssignedToOps {get;set;}
       public String ETStatus {get;set;}
       public String LifeInsuranceActionPlanId {get;set;}
       public boolean isRemove{get;set;}
       public Integer index {get;set;}
       //public List<String> lifeInsuranceList {get;set;}
       
   	   public LifeInsurance()
       {
           isRemove = false;
       }
       //public String strFormsProvided {get;set;}
    }
    
   	public LifeInsurance populateLifeInsurance(String insured, Long suggestedCover,String strSuggestedCover, String policyName, Long premiumAmount, String policyType
                        , double tenureOfInsurance, boolean execTracker, String executionTracker, Id insuranceId
                        , Long sumAssured,String insuranceRemark, Boolean isNewLI, Integer newCount,Boolean isETCreated
                        ,String LifeInsuranceActionPlanId,String ETStatus)
                        //, List<String> lifeInsuranceList, Boolean displayRemoveButton)
  	{
	    LifeInsurance objLifeInsurance = new LifeInsurance();
	   
	    objLifeInsurance.insured = insured;
	    objLifeInsurance.suggestedCover = suggestedCover;
	    objLifeInsurance.strSuggestedCover = strSuggestedCover;
	    objLifeInsurance.policyName = policyName;
	    objLifeInsurance.premiumAmount = premiumAmount;
	    objLifeInsurance.policyType = policyType;
	    objLifeInsurance.tenureOfInsurance = tenureOfInsurance;
	    objLifeInsurance.execTracker = execTracker;
	    objLifeInsurance.executionTracker = executionTracker;
	    objLifeInsurance.insuranceId = insuranceId;
	    //Added on:06/02/2013 : Aditi Satpute : AP changes
	    objLifeInsurance.sumAssured = sumAssured;
	    //Added on:22/02/2013 : Aditi Satpute : AP changes
	    objLifeInsurance.insuranceRemark = insuranceRemark;
    	objLifeInsurance.ETStatus = ETStatus;
    	//objLifeInsurance.displayRemoveButton = displayRemoveButton;
       	//objLifeInsurance.actionPlanLifeInsuranceID = actionPlanLifeInsuranceID;
       	objLifeInsurance.isLast = false;
      	objLifeInsurance.isNewLI = isNewLI;
       	objLifeInsurance.newCount = newCount;
    	objLifeInsurance.isETCreated = isETCreated;
    	//objLifeInsurance.lifeInsuranceList = lifeInsuranceList;
    	objLifeInsurance.LifeInsuranceActionPlanId = LifeInsuranceActionPlanId;
    	
    	lstLifeInsurance.add(objLifeInsurance);
    
    	if(!isNewLI)
      		lstLifeInsuranceRemark.add(objLifeInsurance);
      	
      	if(!isNewLI && (objLifeInsurance.insuranceRemark != null && objLifeInsurance.insuranceRemark != ''))
      		lstLifeInsurancePdfRemark.add(objLifeInsurance);
      		
      	if(objLifeInsurance.policyName != null && objLifeInsurance.policyName != '')	
      	{
      		//lstLifeInsuranceInnerclassRecordCount.add(objLifeInsurance);
      		lstLifeInsuranceCombinedInnerclass.add(objLifeInsurance);
      	}
	    /*List<LifeInsurance> lstInnerClassLifeInsurance = new List<LifeInsurance>();
	    if(!mapIdToLifeInsuranceInnerClass.containsKey(insuranceId))
	    {
	      mapIdToLifeInsuranceInnerClass.put(insuranceId,lstLifeInsurance);
	    }
	    */
    	return objLifeInsurance;
  	}
  	//Added on : 24/10/13 : Aditi Satpute : Capping Removal Changes
  	public LifeInsurance populateNewLifeInsurance(String insured, Long suggestedCover,String policyName, Long premiumAmount, String policyType
                        , double tenureOfInsurance, boolean execTracker, String executionTracker, Id insuranceId
                        , Long sumAssured,Boolean isETCreated,String LifeInsuranceActionPlanId,String ETStatus,Integer index)
                        //, List<String> lifeInsuranceList, Boolean displayRemoveButton)
  	{
	    LifeInsurance objLifeInsurance = new LifeInsurance();
	    objLifeInsurance.insured = insured;
	    objLifeInsurance.suggestedCover = suggestedCover;
	    objLifeInsurance.policyName = policyName;
	    objLifeInsurance.premiumAmount = premiumAmount;
	    objLifeInsurance.policyType = policyType;
	    objLifeInsurance.tenureOfInsurance = tenureOfInsurance; 
	    objLifeInsurance.execTracker = execTracker;
	    objLifeInsurance.executionTracker = executionTracker;
	    objLifeInsurance.insuranceId = insuranceId;
	    objLifeInsurance.sumAssured = sumAssured;
    	objLifeInsurance.ETStatus = ETStatus;
    	objLifeInsurance.isETCreated = isETCreated;
    	objLifeInsurance.index = index;
    	//objLifeInsurance.lifeInsuranceList = lifeInsuranceList;
    	//objLifeInsurance.displayRemoveButton = displayRemoveButton;
    	objLifeInsurance.LifeInsuranceActionPlanId = LifeInsuranceActionPlanId;
    	lstNewLifeInsurance.add(objLifeInsurance);
    	lstLifeInsuranceCombinedInnerclass.add(objLifeInsurance);
    	return objLifeInsurance;
  	}
  	
    //=======Date : 21/12/12 : Aditi======For Life Insurance ET PopUp (added last parameter)======================
    public LifeInsurance populateLifeInsurance(String insured, Long suggestedCover,  string strSuggestedCover //Praj
    					, String policyName, Long premiumAmount, String policyType
                        , double tenureOfInsurance, boolean execTracker, String executionTracker, Id insuranceId, Long sumAssured
                        , String actionPlanLifeInsuranceID,String insuranceRemark, Boolean isNewLI, Integer newCount
                        ,String strAssignedToOps,String ETStatus)//,String strFormsProvided)
  {
    	LifeInsurance objLifeInsurance = new LifeInsurance();
    	objLifeInsurance.insured = insured;
    	objLifeInsurance.suggestedCover = suggestedCover;
    	objLifeInsurance.strSuggestedCover = strSuggestedCover; //Praj
    	objLifeInsurance.policyName = policyName;
    	objLifeInsurance.premiumAmount = premiumAmount;
	    objLifeInsurance.policyType = policyType;
	    objLifeInsurance.tenureOfInsurance = tenureOfInsurance;
	    objLifeInsurance.execTracker = execTracker;
	    objLifeInsurance.executionTracker = executionTracker;
	    //Added on:06/02/2013 : Aditi Satpute : AP changes
	    objLifeInsurance.sumAssured = sumAssured;
	    //Added on:22/02/2013 : Aditi Satpute : AP changes
	    objLifeInsurance.insuranceRemark = insuranceRemark;
	    objLifeInsurance.insuranceId = insuranceId;
	    objLifeInsurance.actionPlanLifeInsuranceID = actionPlanLifeInsuranceID;
	    objLifeInsurance.isLast = false;
   		objLifeInsurance.isNewLI = isNewLI;
       	objLifeInsurance.newCount = newCount;
       	objLifeInsurance.strAssignedToOps = strAssignedToOps;
   	  	objLifeInsurance.ETStatus = ETStatus;
       	//objLifeInsurance.strFormsProvided = strFormsProvided;
	    lstLifeInsurance.add(objLifeInsurance);
	    if(!isNewLI)
	      lstLifeInsuranceRemark.add(objLifeInsurance);
	      
	    if(!isNewLI && (objLifeInsurance.insuranceRemark != null && objLifeInsurance.insuranceRemark != ''))
      		lstLifeInsurancePdfRemark.add(objLifeInsurance);   
	      
	    return objLifeInsurance;
  }
  	//Added on : 25/10/13 : Aditi Satpute : Capping Removal Changes
   public LifeInsurance populateLifeInsurance(String insured, Long suggestedCover
    					, String policyName, Long premiumAmount, String policyType
                        , double tenureOfInsurance, boolean execTracker, String executionTracker, Id insuranceId, Long sumAssured
                        , String actionPlanLifeInsuranceID,String strAssignedToOps,String ETStatus)
  {
    	LifeInsurance objLifeInsurance = new LifeInsurance();
    	objLifeInsurance.insured = insured;
    	objLifeInsurance.suggestedCover = suggestedCover;
    	objLifeInsurance.policyName = policyName;
    	objLifeInsurance.premiumAmount = premiumAmount;
	    objLifeInsurance.policyType = policyType;
	    objLifeInsurance.tenureOfInsurance = tenureOfInsurance;
	    objLifeInsurance.execTracker = execTracker;
	    objLifeInsurance.executionTracker = executionTracker;
	    //Added on:06/02/2013 : Aditi Satpute : AP changes
	    objLifeInsurance.sumAssured = sumAssured;
	    objLifeInsurance.insuranceId = insuranceId;
	    objLifeInsurance.actionPlanLifeInsuranceID = actionPlanLifeInsuranceID;
       	objLifeInsurance.strAssignedToOps = strAssignedToOps;
   	  	objLifeInsurance.ETStatus = ETStatus;
       	//objLifeInsurance.strFormsProvided = strFormsProvided;
	    lstNewLifeInsurance.add(objLifeInsurance);
	    return objLifeInsurance;
  }
    
    //===============================================================================================================================
    
    /*=====================================Prajakta 7-8-2013 - To add current Gold and Silver table in AP =============================================================*/
    
    public class CurrentGoldSilver
    {
    	public String schemeName{get;set;}
       	public String assetClass {get;set;}
       	public double amount {get;set;}
       	public String account {get;set;}
       	public String lumpsumAction {get;set;}
       	public double actionAmount {get;set;}
       	public double SIPactionAmount {get;set;}
       	public boolean execTracker {get;set;} 
       	public boolean SIPexecTracker {get;set;}
       	public Id investmentId {get;set;} 
       	public String owner {get;set;} 
       	public String executionTracker {get;set;}
       	public String SIPexecutionTracker {get;set;}
       	public String SIPaction {get;set;}
       	public double currentSIP {get;set;}
       	public Integer newCount {get;set;}
       	public Boolean isLast {get;set;}
       	public Boolean isNewGoldSilver{get;set;}
       	public String actionPlanGSLumpsumId {get;set;} 
       	public String actionPlanGSSipId {get;set;} 
       	public Boolean isGSETCreated{get;set;}
       	public Boolean isGSsipETCreated{get;set;}
       	public String strAssignedToOps {get;set;}
       	public String strFormsProvided {get;set;}
       	public String ETSTatus {get;set;}
       	public Boolean displayETtoBeOpened {get;set;}
       	public String GoldSilverActionPlanId {get;set;}
    }
    
    public CurrentGoldSilver populateCurrentGoldSilver(String schemeName, String assetClass, double amount, String owner, String account, String lumpsumAction
                              , double actionAmount, boolean execTracker, Id investmentId, String executionTracker, Boolean isNewGoldSilver
                              , Integer newCount,Boolean isGSETCreated,Boolean isGSsipETCreated,String GoldSilverActionPlanId,String ETSTatus)
    {
       	CurrentGoldSilver objCurrentGoldSilver = new CurrentGoldSilver();
       	objCurrentGoldSilver.schemeName = schemeName;
       	objCurrentGoldSilver.assetClass = assetClass;
       	objCurrentGoldSilver.amount = amount;
       	objCurrentGoldSilver.lumpsumAction = lumpsumAction;
       	objCurrentGoldSilver.account = account;
       	objCurrentGoldSilver.owner = owner;
       	objCurrentGoldSilver.actionAmount = actionAmount;
       	objCurrentGoldSilver.execTracker = execTracker;
       	objCurrentGoldSilver.investmentId = investmentId;
       	objCurrentGoldSilver.executionTracker = executionTracker;
       	objCurrentGoldSilver.isLast = false;
       	objCurrentGoldSilver.isNewGoldSilver = isNewGoldSilver;
       	objCurrentGoldSilver.newCount = newCount;
       	objCurrentGoldSilver.isGSETCreated = isGSETCreated;
       	objCurrentGoldSilver.isGSsipETCreated = isGSsipETCreated;
        objCurrentGoldSilver.GoldSilverActionPlanId = GoldSilverActionPlanId;
        objCurrentGoldSilver.ETSTatus = ETSTatus;
       	lstCurrentGold.add(objCurrentGoldSilver);
       	return objCurrentGoldSilver;
   	}
    //=============For Gold and Silver ET PopUp (added last parameter)
   	public CurrentGoldSilver populateCurrentGoldSilver(String schemeName, String assetClass, double amount, String owner, String account, String lumpsumAction
                              , double actionAmount, boolean execTracker, Id investmentId, String executionTracker, Boolean isNewGoldSilver
                              , Integer newCount, String actionPlanGSLumpsumId,String strAssignedToOps,String strFormsProvided,String ETSTatus)//, String mfLumpsumRemark)
    {
       	CurrentGoldSilver objCurrentGoldSilver = new CurrentGoldSilver();
       	objCurrentGoldSilver.schemeName = schemeName;
       	objCurrentGoldSilver.assetClass = assetClass;
       	objCurrentGoldSilver.amount = amount;
       	objCurrentGoldSilver.lumpsumAction = lumpsumAction;
       	objCurrentGoldSilver.account = account;
       	objCurrentGoldSilver.owner = owner;
       	objCurrentGoldSilver.actionAmount = actionAmount;
       	objCurrentGoldSilver.execTracker = execTracker;
       	objCurrentGoldSilver.investmentId = investmentId;
       	objCurrentGoldSilver.executionTracker = executionTracker;
       	objCurrentGoldSilver.isLast = false;
       	objCurrentGoldSilver.isNewGoldSilver = isNewGoldSilver;
       	objCurrentGoldSilver.newCount = newCount;
       	objCurrentGoldSilver.actionPlanGSLumpsumId = actionPlanGSLumpsumId;
       	objCurrentGoldSilver.strAssignedToOps = strAssignedToOps;
       	objCurrentGoldSilver.strFormsProvided = strFormsProvided;
       	objCurrentGoldSilver.ETSTatus = ETSTatus;
       
       	lstCurrentGold.add(objCurrentGoldSilver);
       	return objCurrentGoldSilver;
   	}	
   
   	public CurrentGoldSilver populateSIPCurrentGoldSilver(String schemeName, String assetClass, double amount, String owner, String account, String lumpsumAction
                              , double actionAmount, double SIPactionAmount, boolean execTracker, boolean SIPexecTracker, Id investmentId
                              , String executionTracker, String SIPexecutionTracker, double currentSIP, String SIPaction
                              , Boolean isNewGoldSilver,Boolean isGSETCreated,Boolean isGSsipETCreated,String ETSTatus)//, String mfSIPRemark)
    {
       	CurrentGoldSilver objCurrentGoldSilver = new CurrentGoldSilver();
       	objCurrentGoldSilver.schemeName = schemeName;
       	objCurrentGoldSilver.assetClass = assetClass;
       	objCurrentGoldSilver.amount = amount;
       	objCurrentGoldSilver.lumpsumAction = lumpsumAction;
       	objCurrentGoldSilver.account = account;
       	objCurrentGoldSilver.owner = owner;
       	objCurrentGoldSilver.actionAmount = actionAmount;
       	objCurrentGoldSilver.SIPactionAmount = SIPactionAmount;
       	objCurrentGoldSilver.execTracker = execTracker;
       	objCurrentGoldSilver.SIPexecTracker = SIPexecTracker;
       	objCurrentGoldSilver.SIPexecutionTracker = SIPexecutionTracker;
       	objCurrentGoldSilver.investmentId = investmentId;
       	objCurrentGoldSilver.executionTracker = executionTracker;
       	objCurrentGoldSilver.currentSIP = currentSIP;
       	objCurrentGoldSilver.isLast = false;
       	objCurrentGoldSilver.newCount = 0;
       	objCurrentGoldSilver.SIPaction = SIPaction;
       	objCurrentGoldSilver.isNewGoldSilver = isNewGoldSilver;
       	objCurrentGoldSilver.isGSsipETCreated = isGSsipETCreated;
       	system.debug('*******objCurrentGoldSilver.isGSsipETCreated****'+objCurrentGoldSilver.isGSsipETCreated);
       	objCurrentGoldSilver.isGSETCreated = isGSETCreated;
       	objCurrentGoldSilver.ETSTatus = ETSTatus;
       	lstSIPCurrentGold.add(objCurrentGoldSilver);
       
       	return objCurrentGoldSilver;
   	}
   
   	//=============For Gold and Silver SIP ET PopUp (added last parameter)======================
    public CurrentGoldSilver populateSIPCurrentGoldSilver(String schemeName, String assetClass, double amount, String owner, String account, String lumpsumAction
                              , double actionAmount, double SIPactionAmount, boolean execTracker, boolean SIPexecTracker, Id investmentId
                              , String executionTracker, String SIPexecutionTracker, double currentSIP, String SIPaction, Boolean isNewGoldSilver
                              ,String actionPlanGSSipId,String strAssignedToOps,String strFormsProvided,String ETSTatus)//, String mfSIPRemark)
    {
       	CurrentGoldSilver objCurrentGoldSilver = new CurrentGoldSilver();
       	objCurrentGoldSilver.schemeName = schemeName;
       	objCurrentGoldSilver.assetClass = assetClass;
       	objCurrentGoldSilver.amount = amount;
       	objCurrentGoldSilver.lumpsumAction = lumpsumAction;
       	objCurrentGoldSilver.account = account;
       	objCurrentGoldSilver.owner = owner;
       	objCurrentGoldSilver.actionAmount = actionAmount;
       	objCurrentGoldSilver.SIPactionAmount = SIPactionAmount;
       	objCurrentGoldSilver.execTracker = execTracker;
       	objCurrentGoldSilver.SIPexecTracker = SIPexecTracker;
       	objCurrentGoldSilver.SIPexecutionTracker = SIPexecutionTracker;
       	objCurrentGoldSilver.investmentId = investmentId;
       	objCurrentGoldSilver.executionTracker = executionTracker;
       	objCurrentGoldSilver.currentSIP = currentSIP;
       	objCurrentGoldSilver.isLast = false;
       	objCurrentGoldSilver.newCount = 0;
       	objCurrentGoldSilver.SIPaction = SIPaction;
       	objCurrentGoldSilver.actionPlanGSSipId = actionPlanGSSipId;
       	objCurrentGoldSilver.isNewGoldSilver = isNewGoldSilver;
       	objCurrentGoldSilver.strAssignedToOps = strAssignedToOps;
       	objCurrentGoldSilver.strFormsProvided = strFormsProvided;
       	objCurrentGoldSilver.ETSTatus = ETSTatus;
      	 
       	lstSIPCurrentGold.add(objCurrentGoldSilver);
       	return objCurrentGoldSilver;
   	}
   
   /*==================================================================================================================*/
    
   public class CurrentMutualFunds
   {
        public String schemeName{get;set;}
       public String assetClass {get;set;}
       public double amount {get;set;}
       public String account {get;set;}
       public String lumpsumAction {get;set;}
       public double actionAmount {get;set;}
       public double SIPactionAmount {get;set;}
       public boolean execTracker {get;set;} 
       public boolean SIPexecTracker {get;set;} 
       public Id investmentId {get;set;} 
       public String owner {get;set;} 
       public String executionTracker {get;set;}
       public String SIPexecutionTracker {get;set;}
       public String SIPaction {get;set;}
       public double currentSIP {get;set;}
       public Integer newCount {get;set;}
       public Boolean isLast {get;set;}
       public Boolean isNewMutualFund{get;set;}
       public String actionPlanMFLumpsumId {get;set;} 
       public String actionPlanMFSipId {get;set;} 
       public Boolean isETCreated{get;set;}
       public Boolean isMFsipETCreated{get;set;}
       public String strAssignedToOps {get;set;}
       public String strFormsProvided {get;set;}
       public String ETSTatus {get;set;}
       public Boolean displayETtoBeOpened {get;set;}
       public String MutualFundActionPlanId {get;set;}
       //public String mfLumpsumRemark {get;set;} 
       //public String mfSIPRemark {get;set;} 
       
     }
   
    public CurrentMutualFunds populateCurrentMutualFunds(String schemeName, String assetClass, double amount, String owner, String account, String lumpsumAction
                              , double actionAmount, boolean execTracker, Id investmentId, String executionTracker, Boolean isNewMutualFund
                              , Integer newCount,Boolean isETCreated,Boolean isMFsipETCreated,String MutualFundActionPlanId,String ETSTatus)//, String mfLumpsumRemark)
    {
       CurrentMutualFunds objCurrentMutualFunds = new CurrentMutualFunds();
       objCurrentMutualFunds.schemeName = schemeName;
       objCurrentMutualFunds.assetClass = assetClass;
       objCurrentMutualFunds.amount = amount;
       objCurrentMutualFunds.lumpsumAction = lumpsumAction;
       objCurrentMutualFunds.account = account;
       objCurrentMutualFunds.owner = owner;
       objCurrentMutualFunds.actionAmount = actionAmount;
       objCurrentMutualFunds.execTracker = execTracker;
       objCurrentMutualFunds.investmentId = investmentId;
       objCurrentMutualFunds.executionTracker = executionTracker;
       objCurrentMutualFunds.isLast = false;
       objCurrentMutualFunds.isNewMutualFund = isNewMutualFund;
       objCurrentMutualFunds.newCount = newCount;
       objCurrentMutualFunds.isETCreated = isETCreated;
       objCurrentMutualFunds.isMFsipETCreated = isMFsipETCreated;
       objCurrentMutualFunds.MutualFundActionPlanId = MutualFundActionPlanId;
       objCurrentMutualFunds.ETSTatus = ETSTatus;
       //Added on:18/02/2013 : Aditi Satpute : AP changes
       //objCurrentMutualFunds.mfLumpsumRemark = mfLumpsumRemark;
       
       lstCurrentFunds.add(objCurrentMutualFunds);
       /*List<CurrentMutualFunds> lstCurrentMFalreadyExists = new List<CurrentMutualFunds>();
       if(mapActionToCurrentMFlist.containsKey(objCurrentMutualFunds.lumpsumAction))
       {
         lstCurrentMFalreadyExists = mapActionToCurrentMFlist.get(objCurrentMutualFunds.lumpsumAction);
         lstCurrentMFalreadyExists.add(objCurrentMutualFunds);
       }
       else
         lstCurrentMFalreadyExists.add(objCurrentMutualFunds);
         
         
       mapActionToCurrentMFlist.put(objCurrentMutualFunds.lumpsumAction,lstCurrentMFalreadyExists);*/
       return objCurrentMutualFunds;
   }
    //=======Date : 21/12/12 : Aditi======For Mutual Fund ET PopUp (added last parameter)
   public CurrentMutualFunds populateCurrentMutualFunds(String schemeName, String assetClass, double amount, String owner, String account, String lumpsumAction
                              , double actionAmount, boolean execTracker, Id investmentId, String executionTracker, Boolean isNewMutualFund
                              , Integer newCount, String actionPlanMFLumpsumId,String strAssignedToOps,String strFormsProvided,String ETSTatus)//, String mfLumpsumRemark)
    {
       CurrentMutualFunds objCurrentMutualFunds = new CurrentMutualFunds();
       objCurrentMutualFunds.schemeName = schemeName;
       objCurrentMutualFunds.assetClass = assetClass;
       objCurrentMutualFunds.amount = amount;
       objCurrentMutualFunds.lumpsumAction = lumpsumAction;
       objCurrentMutualFunds.account = account;
       objCurrentMutualFunds.owner = owner;
       objCurrentMutualFunds.actionAmount = actionAmount;
       objCurrentMutualFunds.execTracker = execTracker;
       objCurrentMutualFunds.investmentId = investmentId;
       objCurrentMutualFunds.executionTracker = executionTracker;
       objCurrentMutualFunds.isLast = false;
       objCurrentMutualFunds.isNewMutualFund = isNewMutualFund;
       objCurrentMutualFunds.newCount = newCount;
       objCurrentMutualFunds.actionPlanMFLumpsumId = actionPlanMFLumpsumId;
       objCurrentMutualFunds.strAssignedToOps = strAssignedToOps;
       objCurrentMutualFunds.strFormsProvided = strFormsProvided;
       objCurrentMutualFunds.ETSTatus = ETSTatus;
       //Added on:18/02/2013 : Aditi Satpute : AP changes
       //objCurrentMutualFunds.mfLumpsumRemark = mfLumpsumRemark;
       
       lstCurrentFunds.add(objCurrentMutualFunds);
       return objCurrentMutualFunds;
   }
   
   public CurrentMutualFunds populateSIPCurrentMutualFunds(String schemeName, String assetClass, double amount, String owner, String account, String lumpsumAction
                              , double actionAmount, double SIPactionAmount, boolean execTracker, boolean SIPexecTracker, Id investmentId
                              , String executionTracker, String SIPexecutionTracker, double currentSIP, String SIPaction
                              , Boolean isNewMutualFund,Boolean isETCreated,Boolean isMFsipETCreated,String ETSTatus)//, String mfSIPRemark)
    {
       CurrentMutualFunds objCurrentMutualFunds = new CurrentMutualFunds();
       objCurrentMutualFunds.schemeName = schemeName;
       objCurrentMutualFunds.assetClass = assetClass;
       objCurrentMutualFunds.amount = amount;
       objCurrentMutualFunds.lumpsumAction = lumpsumAction;
       objCurrentMutualFunds.account = account;
       objCurrentMutualFunds.owner = owner;
       objCurrentMutualFunds.actionAmount = actionAmount;
       objCurrentMutualFunds.SIPactionAmount = SIPactionAmount;
       objCurrentMutualFunds.execTracker = execTracker;
       objCurrentMutualFunds.SIPexecTracker = SIPexecTracker;
       objCurrentMutualFunds.SIPexecutionTracker = SIPexecutionTracker;
       objCurrentMutualFunds.investmentId = investmentId;
       objCurrentMutualFunds.executionTracker = executionTracker;
       objCurrentMutualFunds.currentSIP = currentSIP;
       objCurrentMutualFunds.isLast = false;
       objCurrentMutualFunds.newCount = 0;
       objCurrentMutualFunds.SIPaction = SIPaction;
       objCurrentMutualFunds.isNewMutualFund = isNewMutualFund;
       objCurrentMutualFunds.ETSTatus = ETSTatus;
       //Added on:18/02/2013 : Aditi Satpute : AP changes
       //objCurrentMutualFunds.mfSIPRemark = mfSIPRemark;
       objCurrentMutualFunds.isMFsipETCreated = isMFsipETCreated;
       system.debug('*******objCurrentMutualFunds.isMFsipETCreated****'+objCurrentMutualFunds.isMFsipETCreated);
       objCurrentMutualFunds.isETCreated = isETCreated;
       
       lstSIPCurrentFunds.add(objCurrentMutualFunds);
       
     /*  List<CurrentMutualFunds> lstCurrentMFSIPalreadyExists = new List<CurrentMutualFunds>();
       if(mapActionToCurrentMFSIPlist.containsKey(objCurrentMutualFunds.SIPaction))
       {
         lstCurrentMFSIPalreadyExists = mapActionToCurrentMFSIPlist.get(objCurrentMutualFunds.SIPaction);
         lstCurrentMFSIPalreadyExists.add(objCurrentMutualFunds);
       }
       else
         lstCurrentMFSIPalreadyExists.add(objCurrentMutualFunds);
       mapActionToCurrentMFSIPlist.put(objCurrentMutualFunds.SIPaction,lstCurrentMFSIPalreadyExists);*/
       
       return objCurrentMutualFunds;
   }
   
   //=======Date : 21/12/12 : Aditi======For Mutual Fund SIP ET PopUp (added last parameter)======================
    public CurrentMutualFunds populateSIPCurrentMutualFunds(String schemeName, String assetClass, double amount, String owner, String account, String lumpsumAction
                              , double actionAmount, double SIPactionAmount, boolean execTracker, boolean SIPexecTracker, Id investmentId
                              , String executionTracker, String SIPexecutionTracker, double currentSIP, String SIPaction, Boolean isNewMutualFund
                              ,String actionPlanMFSipId,String strAssignedToOps,String strFormsProvided,String ETSTatus)//, String mfSIPRemark)
    {
       CurrentMutualFunds objCurrentMutualFunds = new CurrentMutualFunds();
       objCurrentMutualFunds.schemeName = schemeName;
       objCurrentMutualFunds.assetClass = assetClass;
       objCurrentMutualFunds.amount = amount;
       objCurrentMutualFunds.lumpsumAction = lumpsumAction;
       objCurrentMutualFunds.account = account;
       objCurrentMutualFunds.owner = owner;
       objCurrentMutualFunds.actionAmount = actionAmount;
       objCurrentMutualFunds.SIPactionAmount = SIPactionAmount;
       objCurrentMutualFunds.execTracker = execTracker;
       objCurrentMutualFunds.SIPexecTracker = SIPexecTracker;
       objCurrentMutualFunds.SIPexecutionTracker = SIPexecutionTracker;
       objCurrentMutualFunds.investmentId = investmentId;
       objCurrentMutualFunds.executionTracker = executionTracker;
       objCurrentMutualFunds.currentSIP = currentSIP;
       objCurrentMutualFunds.isLast = false;
       objCurrentMutualFunds.newCount = 0;
       objCurrentMutualFunds.SIPaction = SIPaction;
       objCurrentMutualFunds.actionPlanMFSipId = actionPlanMFSipId;
       objCurrentMutualFunds.isNewMutualFund = isNewMutualFund;
       objCurrentMutualFunds.strAssignedToOps = strAssignedToOps;
       objCurrentMutualFunds.strFormsProvided = strFormsProvided;
       objCurrentMutualFunds.ETSTatus = ETSTatus;
       //Added on:18/02/2013 : Aditi Satpute : AP changes
       //objCurrentMutualFunds.mfSIPRemark = mfSIPRemark;
       
       lstSIPCurrentFunds.add(objCurrentMutualFunds);
       return objCurrentMutualFunds;
   }
  /*========================================================================================================================*/ 
  
     public RecommendedInsurance populateRecommendedInsurance(String insured,String nominee, String insuranceCompany, String policyType,String policyName,
     								String policyNumber,Date commencementDate,Date nextPremiumDueDate,double deathBenefitRs,double premiumAmountRs,
     								String premiumPaymentFrequency,double tenureofInsurance,double premiumPayingTerm, double surrenderCashValue ,
                                  	double currentAmount,double maturityAmount,String action,String recInsuranceExecutionTracker,Boolean execTracker,
                                  	String insuranceId,Boolean isETCreated,String recommendedInsuranceActionPlanId,String ETStatus)
     {
       RecommendedInsurance objRecommendedInsurance = new RecommendedInsurance();
       objRecommendedInsurance.insured = insured;
       objRecommendedInsurance.nominee = nominee;
       objRecommendedInsurance.insuranceCompany = insuranceCompany;
       
       objRecommendedInsurance.policyType = policyType;
       objRecommendedInsurance.policyName = policyName;
       objRecommendedInsurance.policyNumber = policyNumber;
       objRecommendedInsurance.commencementDate = commencementDate;
       objRecommendedInsurance.nextPremiumDueDate = nextPremiumDueDate;
       objRecommendedInsurance.deathBenefitRs = deathBenefitRs;
       
       objRecommendedInsurance.premiumAmountRs = premiumAmountRs;
       objRecommendedInsurance.premiumPaymentFrequency = premiumPaymentFrequency;
       objRecommendedInsurance.tenureofInsurance = tenureofInsurance;
       objRecommendedInsurance.premiumPayingTerm = premiumPayingTerm;
       objRecommendedInsurance.surrenderCashValue = surrenderCashValue;
       objRecommendedInsurance.currentAmount = currentAmount;
       objRecommendedInsurance.maturityAmount = maturityAmount;
       objRecommendedInsurance.action = action;
       objRecommendedInsurance.recInsuranceExecutionTracker = recInsuranceExecutionTracker;
       objRecommendedInsurance.execTracker = execTracker;
       objRecommendedInsurance.insuranceId = insuranceId;
       objRecommendedInsurance.isETCreated = isETCreated;
       objRecommendedInsurance.recommendedInsuranceActionPlanId = recommendedInsuranceActionPlanId;
       objRecommendedInsurance.ETStatus = ETStatus;
       
       lstRecommendedInsurance.add(objRecommendedInsurance);
       return objRecommendedInsurance;
     }
      //=======Date : 02/04/13 : Aditi======For Recommended Insurance ET PopUp (added last parameter)======================
     public RecommendedInsurance populateRecommendedInsurance(String insured,String nominee,String insuranceCompany,String policyType,String policyName,String policyNumber,
                                  Date commencementDate,Date nextPremiumDueDate,double deathBenefitRs,double premiumAmountRs,String premiumPaymentFrequency,
                                  double tenureofInsurance,double premiumPayingTerm,double surrenderCashValue ,double currentAmount,double maturityAmount,
                                  String action,String recInsuranceExecutionTracker,Boolean execTracker,String insuranceId,String approveActionPlanId,
                                  String strAssignedToOps,String ETStatus)//,String strFormsProvided)
     {
       RecommendedInsurance objRecommendedInsurance = new RecommendedInsurance();
       objRecommendedInsurance.insured = insured;
       objRecommendedInsurance.nominee = nominee;
       objRecommendedInsurance.insuranceCompany = insuranceCompany;
       
       objRecommendedInsurance.policyType = policyType;
       objRecommendedInsurance.policyName = policyName;
       objRecommendedInsurance.policyNumber = policyNumber;
       objRecommendedInsurance.commencementDate = commencementDate;
       objRecommendedInsurance.nextPremiumDueDate = nextPremiumDueDate;
       objRecommendedInsurance.deathBenefitRs = deathBenefitRs;
       
       objRecommendedInsurance.premiumAmountRs = premiumAmountRs;
       objRecommendedInsurance.premiumPaymentFrequency = premiumPaymentFrequency;
       objRecommendedInsurance.tenureofInsurance = tenureofInsurance;
       objRecommendedInsurance.premiumPayingTerm = premiumPayingTerm;
       objRecommendedInsurance.surrenderCashValue = surrenderCashValue;
       objRecommendedInsurance.currentAmount = currentAmount;
       objRecommendedInsurance.maturityAmount = maturityAmount;
       objRecommendedInsurance.action = action;
       objRecommendedInsurance.recInsuranceExecutionTracker = recInsuranceExecutionTracker;
       objRecommendedInsurance.execTracker = execTracker;
       objRecommendedInsurance.insuranceId = insuranceId;
       objRecommendedInsurance.approveActionPlanId = approveActionPlanId;
       objRecommendedInsurance.strAssignedToOps = strAssignedToOps;
       objRecommendedInsurance.ETStatus = ETStatus;
       //objRecommendedInsurance.strFormsProvided = strFormsProvided;
       system.debug('*******objRecommendedInsurance.approveActionPlanId********'+objRecommendedInsurance.approveActionPlanId);
       
       lstRecommendedInsurance.add(objRecommendedInsurance);
       return objRecommendedInsurance;
     }
     
     public class RecommendedInsurance
     {
    	public String insured{get;set;}
       	public String nominee {get;set;}
       	public String insuranceCompany {get;set;}
       	public String policyType {get;set;}
       	public String policyName {get;set;}
       	public String policyNumber {get;set;}
       	public Date commencementDate {get;set;}
       	public Date nextPremiumDueDate {get;set;}
       	public double deathBenefitRs {get;set;}
       	public double premiumAmountRs {get;set;}
       	public String premiumPaymentFrequency {get;set;}
      	public double tenureofInsurance {get;set;}
       	public double premiumPayingTerm {get;set;}
       	public double surrenderCashValue {get;set;}
       	public double currentAmount {get;set;}
       	public double maturityAmount {get;set;}
       	public String action {get;set;}
       	//Added on : 02/04/13 : Aditi Satpute : Purpose - need to save execution tracker details for this section : ET Screen Changes
       	public boolean execTracker {get;set;} 
       	public String recInsuranceExecutionTracker {get;set;} 
       	public String insuranceId{get;set;}
       	public String approveActionPlanId{get;set;}
       	public String strAssignedToOps{get;set;}
       	//public String strFormsProvided {get;set;}
       	public String ETStatus {get;set;}
   		public String recommendedInsuranceActionPlanId {get;set;}
       	public Boolean isETCreated{get;set;}
       	
    }

    public UnAllocatedAssets populateUnAllocatedAssets(String entityName, String Type, String description, double currentValue, double balanceRemaining)
    {
       UnAllocatedAssets objUnAllocatedAssets = new UnAllocatedAssets();
       objUnAllocatedAssets.entityName = entityName;
       objUnAllocatedAssets.Type = Type;
       objUnAllocatedAssets.description = description;
       objUnAllocatedAssets.currentValue = currentValue;
       objUnAllocatedAssets.balanceRemaining = balanceRemaining;
       lstUnAllocatedAssets.add(objUnAllocatedAssets);
       return objUnAllocatedAssets;
     }
    
    //=======Date : 08/08/13 : Aditi======For AP Screen - added last parameter for AP Clone Removal======================
    public GoalDetails populateEmergencyLumpsumDetails(String goalId,double lumpsumEquityAmt,double lumpsumDebtAmt,double lumpsumGoldAmt
                      , double lumpsum,double lumpsumEquityPerc,double lumpsumDebtPerc,double lumpsumGoldPerc,String EmergencyLumpsumActionPlanId)
    {
        GoalDetails objGoalDetails = new GoalDetails();
        objGoalDetails.goalId = goalId;
        objGoalDetails.lumpsumDebtAmt = lumpsumDebtAmt;
  		objGoalDetails.lumpsumEquityAmt = lumpsumEquityAmt;
      	objGoalDetails.lumpsumGoldAmt = lumpsumGoldAmt;
      	objGoalDetails.lumpsum = lumpsum;
      	objGoalDetails.lumpsumEquityPerc = lumpsumEquityPerc;
        objGoalDetails.lumpsumDebtPerc = lumpsumDebtPerc;
        objGoalDetails.lumpsumGoldPerc = lumpsumGoldPerc;
        objGoalDetails.EmergencyLumpsumActionPlanId = EmergencyLumpsumActionPlanId;
        objEmergencyFundLumpsum = objGoalDetails;
        
        return objGoalDetails;
             
     }
    
    //=====For ET Screen ======================
   	public GoalDetails populateEmergencyLumpsumDetails(String goalId,double lumpsumEquityAmt,double lumpsumDebtAmt,double lumpsumGoldAmt
                      , double lumpsum,double lumpsumEquityPerc,double lumpsumDebtPerc,double lumpsumGoldPerc)
    {
        GoalDetails objGoalDetails = new GoalDetails();
        objGoalDetails.goalId = goalId;
        objGoalDetails.lumpsumDebtAmt = lumpsumDebtAmt;
  		objGoalDetails.lumpsumEquityAmt = lumpsumEquityAmt;
      	objGoalDetails.lumpsumGoldAmt = lumpsumGoldAmt;
      	objGoalDetails.lumpsum = lumpsum;
      	objGoalDetails.lumpsumEquityPerc = lumpsumEquityPerc;
        objGoalDetails.lumpsumDebtPerc = lumpsumDebtPerc;
        objGoalDetails.lumpsumGoldPerc = lumpsumGoldPerc;
       // objGoalDetails.EmergencyLumpsumActionPlanId = EmergencyLumpsumActionPlanId;
        objEmergencyFundLumpsum = objGoalDetails;
        
        return objGoalDetails;
             
    }
    //For Et
    public GoalDetails populateGoalList(decimal IRR,String goalId, String description, String startYear, String endYear, double annualGoalCost, String goalProfile
                      , String remark, double equityAmt, double debtAmt, double goldAmt, double SIP, double equityPerc, double debtPerc, double goldPerc
                      , double lumpsumEquityAmt, double lumpsumDebtAmt, double lumpsumGoldAmt, double lumpsum, double lumpsumEquityPerc, double lumpsumDebtPerc
                      , double lumpsumGoldPerc, String goalType) 
    {
      	GoalDetails objGoalDetails = new GoalDetails();
      	objGoalDetails.IRR = IRR;
      	objGoalDetails.goalId = goalId;
      	objGoalDetails.description = description;
     	objGoalDetails.startYear = startYear;
      	objGoalDetails.endYear = endYear;
      	objGoalDetails.annualGoalCost = annualGoalCost;
      	objGoalDetails.goalProfile = goalProfile;
      	objGoalDetails.remark = remark;
      	objGoalDetails.debtAmt = debtAmt;
      	objGoalDetails.equityAmt = equityAmt;
      	objGoalDetails.goldAmt = goldAmt;
      	objGoalDetails.SIP = SIP;
      	objGoalDetails.equityPerc = equityPerc;
      	objGoalDetails.debtPerc = debtPerc;
      	objGoalDetails.goldPerc = goldPerc;
	    
	    //lumpsum
      	objGoalDetails.lumpsumDebtAmt = lumpsumDebtAmt;
      	objGoalDetails.lumpsumEquityAmt =lumpsumEquityAmt;
      	objGoalDetails.lumpsumGoldAmt = lumpsumGoldAmt;
      	objGoalDetails.lumpsum = lumpsum;
      	objGoalDetails.lumpsumEquityPerc = lumpsumEquityPerc;
      	objGoalDetails.lumpsumDebtPerc = lumpsumDebtPerc;
      	objGoalDetails.lumpsumGoldPerc = lumpsumGoldPerc;
	      
      	objGoalDetails.goalType = goalType;
	     /* if(description != 'Emergency Fund')
	        lstGoalDetails.add(objGoalDetails);
	      else
	        objEmergencyFundGoalDetails = objGoalDetails;*/
      	if(goalType != 'Emergency Fund')
	        lstGoalDetails.add(objGoalDetails);
	    else
	       	objEmergencyFundGoalDetails = objGoalDetails;
	    return objGoalDetails; 
    }
	public GoalDetails populateGoalList(decimal IRR,String goalId, String description, String startYear, String endYear, double annualGoalCost, String goalProfile
                      , String remark, double equityAmt, double debtAmt, double goldAmt, double SIP, double equityPerc, double debtPerc, double goldPerc
                      , double lumpsumEquityAmt, double lumpsumDebtAmt, double lumpsumGoldAmt, double lumpsum, double lumpsumEquityPerc, double lumpsumDebtPerc
                      , double lumpsumGoldPerc, String goalType, Boolean dispDefaultProduct, Boolean displaySIPinAP, Boolean displayLumpsuminAP) 
    {
      	GoalDetails objGoalDetails = new GoalDetails();
      	objGoalDetails.IRR = IRR;
      	objGoalDetails.goalId = goalId;
      	objGoalDetails.description = description;
     	objGoalDetails.startYear = startYear;
      	objGoalDetails.endYear = endYear;
      	objGoalDetails.annualGoalCost = annualGoalCost;
      	objGoalDetails.goalProfile = goalProfile;
      	objGoalDetails.remark = remark;
      	objGoalDetails.debtAmt = debtAmt;
      	objGoalDetails.equityAmt = equityAmt;
      	objGoalDetails.goldAmt = goldAmt;
      	objGoalDetails.SIP = SIP;
      	objGoalDetails.equityPerc = equityPerc;
      	objGoalDetails.debtPerc = debtPerc;
      	objGoalDetails.goldPerc = goldPerc;
	    
	    //lumpsum
      	objGoalDetails.lumpsumDebtAmt = lumpsumDebtAmt;
      	objGoalDetails.lumpsumEquityAmt =lumpsumEquityAmt;
      	objGoalDetails.lumpsumGoldAmt = lumpsumGoldAmt;
      	objGoalDetails.lumpsum = lumpsum;
      	objGoalDetails.lumpsumEquityPerc = lumpsumEquityPerc;
      	objGoalDetails.lumpsumDebtPerc = lumpsumDebtPerc;
      	objGoalDetails.lumpsumGoldPerc = lumpsumGoldPerc;
	    objGoalDetails.dispDefaultProduct = dispDefaultProduct;
	    objGoalDetails.displaySIPinAP = displaySIPinAP;
	    objGoalDetails.displayLumpsuminAP = displayLumpsuminAP;
	      
      	objGoalDetails.goalType = goalType;
	     /* if(description != 'Emergency Fund')
	        lstGoalDetails.add(objGoalDetails);
	      else
	        objEmergencyFundGoalDetails = objGoalDetails;*/
      	if(goalType != 'Emergency Fund')
	        lstGoalDetails.add(objGoalDetails);
	    else
	       	objEmergencyFundGoalDetails = objGoalDetails;
	    return objGoalDetails; 
    }
    
    public class UnAllocatedAssets
    {
    	public String entityName {get;set;}
      	public String Type{get;set;}
      	public String description{get;set;}
      	public double currentValue{get;set;}
      	public double balanceRemaining{get;set;}
    }
   
    public class GoalDetails
    {
      	public decimal IRR{get;set;}
      	public String goalId{get;set;}
	    public String description {get;set;}
	    public String startYear {get;set;}
        public String endYear {get;set;}
        public double annualGoalCost {get;set;}
        public String goalProfile {get;set;}
        public String remark {get;set;}
        ///Sip Details
        public double SIP{get;set;}
        public double equityAmt{get;set;}
     	public double debtAmt{get;set;}
      	public double goldAmt{get;set;}
      
      	public double equityPerc{get;set;}
      	public double debtPerc{get;set;}
      	public double goldPerc{get;set;}
      
      	public double SIPTotal{get;set;}
      	public double LumpsumTotal{get;set;}
      	public double AssetsTotal{get;set;}
		
	  	public String goalType {get;set;}
      	///Lumpsum
      	public double lumpsum{get;set;}
        public double lumpsumEquityAmt{get;set;}
      	public double lumpsumDebtAmt{get;set;}
      	public double lumpsumGoldAmt{get;set;}
      
      	public double lumpsumEquityPerc{get;set;}
      	public double lumpsumDebtPerc{get;set;}
      	public double lumpsumGoldPerc{get;set;}
      	public boolean isRemove{get;set;}
        public Boolean dispDefaultProduct {get;set;}
        public Boolean displaySIPinAP {get;set;}
        public Boolean displayLumpsuminAP {get;set;}
      	public String EmergencyLumpsumActionPlanId {get;set;}
        ///
        public List<AllocatedAssets> lstAssests 
        {
          get
          {
            if(lstAssests == null)
	        {
	          lstAssests = new List<AllocatedAssets>();
	        }
        	return   lstAssests;
          }set;
        }
        
        public List<SIPFunds> lstSIPFunds
        {
          get
          {
            if(lstSIPFunds == null)
	        {
	          lstSIPFunds = new List<SIPFunds>();
	        }
        	return   lstSIPFunds;
          }
          set;
        }
       
       	public List<SIPFunds> lstETSIPFunds
        {
          get
          {
            if(lstETSIPFunds == null)
	        {
	          lstETSIPFunds = new List<SIPFunds>();
	        }
	        return   lstETSIPFunds;
          }
          set;
        }
       	public List<LumpsumFunds> lstLumpsumFunds
        {
          get
          {
            if(lstLumpsumFunds == null)
	        {
	          lstLumpsumFunds = new List<LumpsumFunds>();
	        }
	        return   lstLumpsumFunds;
          }
          set;
        }
    	public GoalDetails()
    	{
      		startYear = endYear = goalProfile = remark = description = '';
      		annualGoalCost = 0;
    	}

    	public AllocatedAssets populateAllocatedAssets(String InsuranceDescription 
                            , string Type
                            , string owner
                            , double allocatedAmount
                            , double availableAmount
                            , double goalYearValue
                            , string action
                            , double expectedGrowthRate)
    	{
      		AllocatedAssets objAllocatedAssets = new AllocatedAssets();
      		objAllocatedAssets.Description = InsuranceDescription;
      		objAllocatedAssets.Type = Type;
      		objAllocatedAssets.owner = owner;
	      	objAllocatedAssets.allocatedAmount = allocatedAmount;
	      	objAllocatedAssets.availableAmount = availableAmount;
	      	objAllocatedAssets.expectedGrowthRate =expectedGrowthRate;
	      	objAllocatedAssets.goalYearValue = goalYearValue;
	      	objAllocatedAssets.action = action;
	      	lstAssests.add(objAllocatedAssets);
	      	return objAllocatedAssets;
    	}
    
    	public void populateSIPFunds(String productName
                  , String transactionType
                  , double amount
                  , double installments
                  , String category
                  , String option
                  , String remarks
                  , boolean execTracker
                  , String executionTracker,Boolean isETCreated
                  , String SIPFundActionPlanId,String ETStatus)
	    {
	      	SIPFunds objSIPFunds = new SIPFunds();
	      	objSIPFunds.productName = productName;
	      	objSIPFunds.transactionType = transactionType;
	      	objSIPFunds.amount = amount;
	      	objSIPFunds.installments = installments;
	      	objSIPFunds.category = category;
	      	objSIPFunds.option = option;
	      	objSIPFunds.remarks =remarks;
	     	objSIPFunds.execTracker = execTracker;
	      	objSIPFunds.executionTracker = executionTracker;
	      	objSIPFunds.isETCreated = isETCreated;
	      	objSIPFunds.SIPFundActionPlanId = SIPFundActionPlanId;
	      	objSIPFunds.ETStatus = ETStatus;
	      	system.debug('-------objSIPFunds populate------'+objSIPFunds);
	      	lstSIPFunds.add(objSIPFunds);
	    }
    	//=======Date : 21/12/12 : Aditi======For SIP Funds ET PopUp (added last parameter)======================
    	public void populateSIPFunds(String productName
                  , String transactionType
                  , double amount
                  , double installments
                  , String category
                  , String option
                  , String remarks
                  , boolean execTracker
                  , String executionTracker,String SIPFundId,String strAssignedToOps
                  ,String strFormsProvided,String ETStatus)
    	{
      		SIPFunds objSIPFunds = new SIPFunds();
      		objSIPFunds.productName = productName;
      		objSIPFunds.transactionType = transactionType;
	      	objSIPFunds.amount = amount;
	      	objSIPFunds.installments = installments;
	      	objSIPFunds.category = category;
	      	objSIPFunds.option = option;
	      	objSIPFunds.remarks =remarks;
	      	objSIPFunds.execTracker = execTracker;
	      	objSIPFunds.executionTracker = executionTracker;
	      	objSIPFunds.SIPFundId= SIPFundId;
	      	objSIPFunds.strAssignedToOps = strAssignedToOps;
	      	objSIPFunds.strFormsProvided = strFormsProvided;
	      	objSIPFunds.ETStatus = ETStatus;
	      	lstSIPFunds.add(objSIPFunds);
	      	system.debug('*******lstSIPFunds******'+lstSIPFunds);
    	}
    	 
    	public void populateLumpsumFunds(String productName
                    , String transactionType
                    , double amount
                    , double installments
                    , String category
                    , String option
                    , String remarks
                    , String fund
                    , double amountPerInstallment
                    , boolean execTracker
                    , String executionTracker
                    , Boolean isETCreated
                    , String LumpsumFundActionPlanId
                    , String ETStatus)
	    {
		      LumpsumFunds objLumpsumFunds = new LumpsumFunds();
		      objLumpsumFunds.lumpsumProductName = productName;
		      objLumpsumFunds.lumpsumTransactionType = transactionType;
		      objLumpsumFunds.lumpsumAmount = amount;
		      objLumpsumFunds.lumpsumInstallments = installments;
		      objLumpsumFunds.lumpsumCategory = category;
		      objLumpsumFunds.lumpsumOption = option;
		      objLumpsumFunds.lumpsumRemarks =remarks;
		      objLumpsumFunds.lumpsumAmountPerInstall=amountPerInstallment;
		      objLumpsumFunds.lumpsumFund = fund;
		      objLumpsumFunds.lumpsumExecTracker = execTracker;
		      objLumpsumFunds.lumpsumExecutionTracker = executionTracker;
		      objLumpsumFunds.isETCreated = isETCreated;
		      objLumpsumFunds.LumpsumFundActionPlanId = LumpsumFundActionPlanId;
		      objLumpsumFunds.ETStatus = ETStatus;
		      lstLumpsumFunds.add(objLumpsumFunds);
		      
	    }
    
    	//=======Date : 21/12/12 : Aditi======For SIP Funds ET PopUp (added last parameter)======================
	    public void populateLumpsumFunds(String productName
	                    , String transactionType
	                    , double amount
	                    , double installments
	                    , String category
	                    , String option
	                    , String remarks
	                    , String fund
	                    , double amountPerInstallment
	                    , boolean execTracker
	                    , String executionTracker,String LumpsumFundId,String strAssignedToOps
	                    ,String strFormsProvided,String ETStatus)
	    {
	      LumpsumFunds objLumpsumFunds = new LumpsumFunds();
	      objLumpsumFunds.lumpsumProductName = productName;
	      objLumpsumFunds.lumpsumTransactionType = transactionType;
	      objLumpsumFunds.lumpsumAmount = amount;
	      objLumpsumFunds.lumpsumInstallments = installments;
	      objLumpsumFunds.lumpsumCategory = category;
	      objLumpsumFunds.lumpsumOption = option;
	      objLumpsumFunds.lumpsumRemarks =remarks;
	      objLumpsumFunds.lumpsumAmountPerInstall=amountPerInstallment;
	      objLumpsumFunds.lumpsumFund = fund;
	      objLumpsumFunds.lumpsumExecTracker = execTracker;
	      objLumpsumFunds.lumpsumExecutionTracker = executionTracker;
	      objLumpsumFunds.LumpsumFundId = LumpsumFundId;
	      objLumpsumFunds.strAssignedToOps = strAssignedToOps;
	      objLumpsumFunds.strFormsProvided = strFormsProvided;
	      objLumpsumFunds.ETStatus = ETStatus;
	      lstLumpsumFunds.add(objLumpsumFunds);
	      
	    }
	    
    }


    public class SIPFunds
    {
       public SIPFunds()
       {
            isRemove = false;
       }
       public boolean isRemove{get;set;}
       public String strSIPFunds {get;set;}
       public String productName {get;set;}
       public String transactionType {get;set;}
       public double amount {get;set;}
       public double installments {get;set;}
       public String category {get;set;}
       public String option {get;set;}
       public String remarks {get;set;}
       public boolean execTracker{get;set;}
       public String executionTracker {get;set;}
       public Boolean isTest{get { return false ;}set;}
       public String SIPFundId {get;set;}
       public Boolean isETCreated{get;set;}
       public String strAssignedToOps{get;set;}
       public String strFormsProvided {get;set;}
       public String ETSTatus {get;set;}
       public String SIPFundActionPlanId {get;set;}
       
     }
     
   //  LumpsumFunds
   public class LumpsumFunds
     {
       public LumpsumFunds(){
            isRemove = false;
        }
        public boolean isRemove{get;set;}
       public String lumpsumProductName {get;set;}
       public String lumpsumTransactionType {get;set;}
       public double lumpsumAmount {get;set;}
       public double lumpsumInstallments {get;set;}
       public String lumpsumCategory {get;set;}
       public String lumpsumOption {get;set;}
       public String lumpsumFund{get;set;}
       public double lumpsumAmountPerInstall{get;set;}
       public String lumpsumRemarks {get;set;}
       public boolean lumpsumExecTracker{get;set;}
       public String lumpsumExecutionTracker {get;set;}
       public String LumpsumFundId {get;set;}
       public Boolean isETCreated{get;set;}
       public String strAssignedToOps{get;set;}
       public String strFormsProvided {get;set;}
       public String ETSTatus {get;set;}
       public String LumpsumFundActionPlanId {get;set;}
     }
   
   
    public class AllocatedAssets 
    {
        public string Description{get;set;}
      public string Type{get;set;}
      public string owner{get;set;}
      public double allocatedAmount{get;set;}
      public double availableAmount{get;set;}
      public double expectedGrowthRate{get;set;}
      public double goalYearValue{get;set;}
      public string action{get;set;}
    
    }
    
    //===================================================
    public class SAssetAllocationBean {
        public SAssetAllocationBean(){
            golListVals = new List<double>();
        }
        public String entityName {get;set;}
        public String action {get;set;}
        public String Assets {get;set;}
        public double allocated {get;set;}
        public double available{get;set;}
        public double currentVal{get;set;}
        public List<double> golListVals {get;set;}
        
    }
    
   
    
  /**
  * @Description: inner class to show data current mutual lumpsum data of approved plan object
  * param: None 
  * return type: 
  */ 
    public class CurrentMFLumpSum{
        public CurrentMFLumpSum(){
            golCurrMFLumpSum = new List<Goals>();
            isRemove = false;
        }
        
        public Id entityId {get;set;}
        public Approved_Action_Plan__c recordId{get;set;}
        public Id assetId {get;set;}
        public boolean isRemove{get;set;}
        public String schemeName{get;set;}
        public String assetsClass {get;set;}
        public double assetAmount{get;set;}
        public String entityName {get;set;}
        public String action {get;set;}
        public double actionAmount{get;set;}
        public List<Goals> golCurrMFLumpSum {get;set;}
    }
    
   /**
  * @Description: inner class to show data current mutual SIP data of approved plan object
  * param: None 
  * return type: 
  */
    public class CurrentMFSIP{
        public CurrentMFSIP(){
            golCurrMFSIP = new List<Goals>();
            isRemove = false;
        }
        
        public Id entityId {get;set;}
        public Approved_Action_Plan__c recordId{get;set;}
        public Id assetId {get;set;}
        public boolean isRemove{get;set;}
        public String schemeName{get;set;}
        public String assetsClass {get;set;}
        public double currentSIP{get;set;}
        public String entityName {get;set;}
        public String SIPAction {get;set;}
        public double SIPChange{get;set;}
        public List<Goals> golCurrMFSIP {get;set;}
    }
    
     /**
  * @Description: inner class to show data suggested mutual lumpsum data of approved plan object
  * param: None 
  * return type: 
  */
    public class SuggestedMFLumpSum{
        public SuggestedMFLumpSum(){
            golsuggMFLump = new List<Goals>();
            isRemove = false;
        }
        
        public Id entityId {get;set;}
        public Approved_Action_Plan__c recordId{get;set;}
        public Id assetId {get;set;}
        public boolean isRemove{get;set;}
        public String schemeName{get;set;}
        public String assetsClass {get;set;}
        public String entityName {get;set;}
        public String Action {get;set;}
        public double amount {get;set;}
        public String notes {get;set;}
        public List<Goals> golsuggMFLump {get;set;}
    }
    
  /**
  * @Description: inner class to show data suggested mutual SIP data of approved plan object
  * param: None 
  * return type: 
  */
    public class SuggestedMFSIP{
        public SuggestedMFSIP(){
            golSuggMFSIP = new List<Goals>();
            isRemove = false;
        }
        public boolean isRemove{get;set;}
        public Id entityId {get;set;}
        public Approved_Action_Plan__c recordId{get;set;}
        public Id assetId {get;set;}
        /** Eternus Solutions       **/
    /** Author  : Manasi Ranade **/
    /** Issue Id: FS0290        **/
    /** Date    : 7/12/2011   **/
    /** Purpose : Added property in SuggestedMFSIP class.It will be usefull in Action Plan PDF generation at the time of ET
    /****************************************************/
    public String entityName {get;set;}
        public String schemeName{get;set;}
        public String assetsClass {get;set;}
        public double SIPAmount{get;set;}
        public List<Goals> golSuggMFSIP {get;set;}
    }
    
  /**
  * @Description: inner class to capture data for goals allocations on approved plan
  * param: None 
  * return type: 
  */
     public class Goals
     {
         public Goals(){
         }
         public Id goalId {get;set;}
         public double allocated  {get;set;}
         public double allocatedAmount{get;set;}
     }
   
  /**
  * @Description: inner class to Lumpsum and SIP amount on approved plan
  * param: None 
  * return type: 
  */  
    public class DoneClass
    {
        public DoneClass()
        {
        }
        
        public DoneClass(String classNameP , List<double> golListValsP){
            className = classNameP;
            golListVals = golListValsP;
        }
        
        public String className {get;set;}
        public List<double> golListVals {get;set;}
    }  
 
}