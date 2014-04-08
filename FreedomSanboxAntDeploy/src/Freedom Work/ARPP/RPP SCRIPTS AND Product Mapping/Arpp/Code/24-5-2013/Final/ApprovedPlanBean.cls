/*
  Revision History:
  
    Version     Version Author     Date         Comments
    1.0         Sandip C            --          Initial Draft:ApprovedPlanBean is used for Approved plan which populated the data on the ApprovedPlan.page
    2.0      Manasi         7/12/2011    Added property in SuggestedMFSIP class.It will be usefull in Action Plan PDF generation at the time of ET
    3.0      Aditi S         27/09/2012   New Action Plan Creation
*/

public class ApprovedPlanBean
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
    public boolean isApprovedGeneralInsExist{get;set;}
    public boolean isApprovedLifeInsExist{get;set;}
    public String isWillExecutionTracker{get;set;}
     public double SIPSummaryTotal{get;set;}
     
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
      lstGeneralInsurance = new List<GeneralInsurance>();
      objEmergencyFundGoalDetails = new GoalDetails();
      objEmergencyFundLumpsum = new  GoalDetails();
      mapIdToCurrentFunds = new Map<Id,List<CurrentMutualFunds>>();
      mapActionToCurrentMFlist = new Map<String,List<CurrentMutualFunds>>();
      mapActionToCurrentMFSIPlist = new Map<String,List<CurrentMutualFunds>>();
      mapIdToLifeInsuranceInnerClass = new Map<String,List<LifeInsurance>>();
      lstNewGeneralInsurance = new List<GeneralInsurance>();
      isWillExecutionTracker = '';
        isLifeInsExist = false;
        isGeneralInsExist = false;
        isApprovedGeneralInsExist = false;
        isApprovedLifeInsExist = false;
    }
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
    public List<LifeInsurance> lstLifeInsurance{get;set;}
    public List<LifeInsurance> lstLifeInsuranceRemark{get;set;}
    
    public Map<String,List<CurrentMutualFunds>> mapActionToCurrentMFlist
    {
      get;
      /*{
        if(mapActionToCurrentMFlist == null)
        {
          Map<String,List<ApprovedPlanBean.CurrentMutualFunds>> mapActionToMutualFundLumpsum = new Map<String,List<ApprovedPlanBean.CurrentMutualFunds>>();
            //Map<String,List<ApprovedPlanBean.CurrentMutualFunds>> mapActionToMutualFundSIP = new Map<String,List<ApprovedPlanBean.CurrentMutualFunds>>();
       
          for( Id idMF  : mapIdToCurrentFunds.keySet())
          {
            List<CurrentMutualFunds> lstMF = mapIdToCurrentFunds.get(idMF);
            for(CurrentMutualFunds objMF : lstMF)
            {  
              List<CurrentMutualFunds> lstCurrentMFalreadyExists = new List<CurrentMutualFunds>();
               if(mapActionToMutualFundLumpsum.containsKey(objMF.lumpsumAction))
               {
                 lstCurrentMFalreadyExists = mapActionToMutualFundLumpsum.get(objMF.lumpsumAction);
                 lstCurrentMFalreadyExists.add(objMF);
               }
               else
                 lstCurrentMFalreadyExists.add(objMF);
               mapActionToMutualFundLumpsum.put(objMF.lumpsumAction,lstCurrentMFalreadyExists);
              system.debug('******objMF********'+objMF);
            }
          }
          system.debug('******mapActionToMutualFundLumpsum********'+mapActionToMutualFundLumpsum.size());
        return mapActionToMutualFundLumpsum ;        
          }
          return null;
      }*/
    
       set;
     }    
    public Map<String,List<CurrentMutualFunds>> mapActionToCurrentMFSIPlist
    {
      get;
      /*{
        if(mapActionToCurrentMFSIPlist == null)
        {
          Map<String,List<ApprovedPlanBean.CurrentMutualFunds>> mapActionToMutualFundSIP = new Map<String,List<ApprovedPlanBean.CurrentMutualFunds>>();
          for(ApprovedPlanBean.CurrentMutualFunds objSIP : lstSIPCurrentFunds)
          {
            List<CurrentMutualFunds> lstCurrentMFSIPalreadyExists = new List<CurrentMutualFunds>();
             if(mapActionToMutualFundSIP.containsKey(objSIP.SIPaction))
             {
               lstCurrentMFSIPalreadyExists = mapActionToMutualFundSIP.get(objSIP.SIPaction);
               lstCurrentMFSIPalreadyExists.add(objSIP);
             }
             else
               lstCurrentMFSIPalreadyExists.add(objSIP);
             mapActionToMutualFundSIP.put(objSIP.SIPaction,lstCurrentMFSIPalreadyExists);
             
          }
          system.debug('******mapActionToMutualFundSIP********'+mapActionToMutualFundSIP.size());
          return mapActionToMutualFundSIP;
        }
        return null;
      }*/
      set;
    }
    
    public Map<String,List<LifeInsurance>> mapIdToLifeInsuranceInnerClass{get;set;}
  //=======@Description: inner class to show data of General Insurance==================================================================================
    public class GeneralInsurance
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
       public String strFormsProvided {get;set;}
       public Integer index {get;set;}
       public GeneralInsurance()
       {
         isRemove = false;
       }
     /*  public GeneralInsurance(Integer index)
        {
            isRemove = false;
            this.index= index;
        }*/
       
     } 
    
     public GeneralInsurance populateGeneralInsurance(String insured, String policyName, Long premiumAmount, String policyType
                        , Long sumAssured, boolean execTracker, String executionTracker, Id insuranceId
                        ,String productName,Boolean isETCreated)
  {
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
    lstGeneralInsurance.add(objGeneralInsurance);
    return objGeneralInsurance;
  }
  //=======Date : 21/12/12 : Aditi======For General Insurance ET PopUp (added last parameter)======================
  public GeneralInsurance populateGeneralInsurance(String insured, String policyName, Long premiumAmount, String policyType
                        , Long sumAssured, boolean execTracker, String executionTracker, Id insuranceId
                        ,String productName,String actionPlanGeneralInsuranceID,String strAssignedToOps
                        ,String strFormsProvided)
  {
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
    objGeneralInsurance.strFormsProvided = strFormsProvided;
    lstGeneralInsurance.add(objGeneralInsurance);
    return objGeneralInsurance;
  }
  
  
  
  
    public GeneralInsurance populateNewGeneralInsurance(String insured, Long premiumAmount, String policyType
                        , Long sumAssured, boolean execTracker, String executionTracker, String productName
                        ,String actionPlanGeneralInsuranceID,Boolean isETCreated,String insuredName, Integer index)
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
    objGeneralInsurance.index = index;
    //objGeneralInsurance.insuranceId = insuranceId;
    lstNewGeneralInsurance.add(objGeneralInsurance);
    return objGeneralInsurance;
  }
  
  
  //=======Date : 1/3/13 : Aditi======For New General Insurance ET===================
   public GeneralInsurance populateNewGeneralInsurance(String insured, Long premiumAmount, String policyType
                        , Long sumAssured, boolean execTracker, String executionTracker, String productName
                        ,String actionPlanGeneralInsuranceID,String strAssignedToOps,String strFormsProvided)
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
    objGeneralInsurance.strFormsProvided = strFormsProvided;
    //objGeneralInsurance.insuranceId = insuranceId;
    lstNewGeneralInsurance.add(objGeneralInsurance);
    return objGeneralInsurance;
  }
   //===================================================================================================================================================== 
   
   
    public class LifeInsurance
     {
        public String insured{get;set;}
       public double suggestedCover {get;set;}
       public String strSuggestedCover{get;set;}
       public String policyName {get;set;}
       public Long premiumAmount {get;set;}
       public String policyType {get;set;}
       public double tenureOfInsurance {get;set;}
       public boolean execTracker{get;set;}
       public String executionTracker{get;set;}
       public Id insuranceId {get;set;} 
       //Added on:06/02/2013 : Aditi Satpute : AP changes
       public Long sumAssured {get;set;}
       public String insuranceRemark{get;set;}
       
       public String actionPlanLifeInsuranceID{get;set;}
       public Boolean isNewLI{get;set;}
       public Integer newCount{get;set;}
       public Boolean isLast{get;set;}
       public Boolean isETCreated{get;set;}
       public String strAssignedToOps {get;set;}
       public String strFormsProvided {get;set;}
     }
    
   public LifeInsurance populateLifeInsurance(String insured, double suggestedCover,String strSuggestedCover, String policyName, Long premiumAmount, String policyType
                        , double tenureOfInsurance, boolean execTracker, String executionTracker, Id insuranceId
                        , Long sumAssured,String insuranceRemark, Boolean isNewLI, Integer newCount,Boolean isETCreated)
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
    
       //objLifeInsurance.actionPlanLifeInsuranceID = actionPlanLifeInsuranceID;
       objLifeInsurance.isLast = false;
       objLifeInsurance.isNewLI = isNewLI;
       objLifeInsurance.newCount = newCount;
    objLifeInsurance.isETCreated = isETCreated;
    lstLifeInsurance.add(objLifeInsurance);
    
    if(!isNewLI)
      lstLifeInsuranceRemark.add(objLifeInsurance);
    /*List<LifeInsurance> lstInnerClassLifeInsurance = new List<LifeInsurance>();
    if(!mapIdToLifeInsuranceInnerClass.containsKey(insuranceId))
    {
      mapIdToLifeInsuranceInnerClass.put(insuranceId,lstLifeInsurance);
    }
    */
    return objLifeInsurance;
  }
    //=======Date : 21/12/12 : Aditi======For Life Insurance ET PopUp (added last parameter)======================
    public LifeInsurance populateLifeInsurance(String insured, double suggestedCover, String policyName, Long premiumAmount, String policyType
                        , double tenureOfInsurance, boolean execTracker, String executionTracker, Id insuranceId, Long sumAssured
                        , String actionPlanLifeInsuranceID,String insuranceRemark, Boolean isNewLI, Integer newCount
                        ,String strAssignedToOps,String strFormsProvided)
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
    //Added on:22/02/2013 : Aditi Satpute : AP changes
    objLifeInsurance.insuranceRemark = insuranceRemark;
    objLifeInsurance.insuranceId = insuranceId;
    objLifeInsurance.actionPlanLifeInsuranceID = actionPlanLifeInsuranceID;
    objLifeInsurance.isLast = false;
       objLifeInsurance.isNewLI = isNewLI;
       objLifeInsurance.newCount = newCount;
       objLifeInsurance.strAssignedToOps = strAssignedToOps;
       objLifeInsurance.strFormsProvided = strFormsProvided;
    lstLifeInsurance.add(objLifeInsurance);
    if(!isNewLI)
      lstLifeInsuranceRemark.add(objLifeInsurance);
    return objLifeInsurance;
  }
    
    //===============================================================================================================================
    
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
       //public String mfLumpsumRemark {get;set;} 
       //public String mfSIPRemark {get;set;} 
       
     }
   
    public CurrentMutualFunds populateCurrentMutualFunds(String schemeName, String assetClass, double amount, String owner, String account, String lumpsumAction
                              , double actionAmount, boolean execTracker, Id investmentId, String executionTracker, Boolean isNewMutualFund
                              , Integer newCount,Boolean isETCreated,Boolean isMFsipETCreated)//, String mfLumpsumRemark)
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
                              , Integer newCount, String actionPlanMFLumpsumId,String strAssignedToOps,String strFormsProvided)//, String mfLumpsumRemark)
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
       //Added on:18/02/2013 : Aditi Satpute : AP changes
       //objCurrentMutualFunds.mfLumpsumRemark = mfLumpsumRemark;
       
       lstCurrentFunds.add(objCurrentMutualFunds);
       return objCurrentMutualFunds;
   }
   
   public CurrentMutualFunds populateSIPCurrentMutualFunds(String schemeName, String assetClass, double amount, String owner, String account, String lumpsumAction
                              , double actionAmount, double SIPactionAmount, boolean execTracker, boolean SIPexecTracker, Id investmentId
                              , String executionTracker, String SIPexecutionTracker, double currentSIP, String SIPaction
                              , Boolean isNewMutualFund,Boolean isETCreated,Boolean isMFsipETCreated)//, String mfSIPRemark)
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
                              ,String actionPlanMFSipId,String strAssignedToOps,String strFormsProvided)//, String mfSIPRemark)
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
       //Added on:18/02/2013 : Aditi Satpute : AP changes
       //objCurrentMutualFunds.mfSIPRemark = mfSIPRemark;
       
       lstSIPCurrentFunds.add(objCurrentMutualFunds);
       return objCurrentMutualFunds;
   }
   
  
     public RecommendedInsurance populateRecommendedInsurance(String insured,String nominee, 
                                  String insuranceCompany,
                                  String policyType,
                                  String policyName,
                                  String policyNumber,
                                  Date commencementDate,
                                  Date nextPremiumDueDate,
                                  double deathBenefitRs,
                                  double premiumAmountRs,
                                  String premiumPaymentFrequency,
                                  double tenureofInsurance,
                                  double premiumPayingTerm, 
                                  double surrenderCashValue ,
                                  double currentAmount,
                                  double maturityAmount,
                                  String action,String recInsuranceExecutionTracker,
                                  Boolean execTracker,String insuranceId,Boolean isETCreated)
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
       lstRecommendedInsurance.add(objRecommendedInsurance);
       return objRecommendedInsurance;
     }
      //=======Date : 02/04/13 : Aditi======For Recommended Insurance ET PopUp (added last parameter)======================
     public RecommendedInsurance populateRecommendedInsurance(String insured,String nominee, 
                                  String insuranceCompany,
                                  String policyType,
                                  String policyName,
                                  String policyNumber,
                                  Date commencementDate,
                                  Date nextPremiumDueDate,
                                  double deathBenefitRs,
                                  double premiumAmountRs,
                                  String premiumPaymentFrequency,
                                  double tenureofInsurance,
                                  double premiumPayingTerm, 
                                  double surrenderCashValue ,
                                  double currentAmount,
                                  double maturityAmount,
                                  String action,String recInsuranceExecutionTracker,
                                  Boolean execTracker,String insuranceId,String approveActionPlanId,
                                  String strAssignedToOps,String strFormsProvided)
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
       objRecommendedInsurance.strFormsProvided = strFormsProvided;
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
       public String strFormsProvided {get;set;}
       public Boolean isETCreated{get;set;}
     }

    public UnAllocatedAssets populateUnAllocatedAssets(String Type
                              , String description
                              , double currentValue
                              , double balanceRemaining)
     {
       UnAllocatedAssets objUnAllocatedAssets = new UnAllocatedAssets();
       objUnAllocatedAssets.Type = Type;
       objUnAllocatedAssets.description = description;
       objUnAllocatedAssets.currentValue = currentValue;
       objUnAllocatedAssets.balanceRemaining = balanceRemaining;
       lstUnAllocatedAssets.add(objUnAllocatedAssets);
       return objUnAllocatedAssets;
     }
    
    public GoalDetails populateEmergencyLumpsumDetails(String goalId,double lumpsumEquityAmt,double lumpsumDebtAmt,double lumpsumGoldAmt
                      , double lumpsum,double lumpsumEquityPerc,double lumpsumDebtPerc,double lumpsumGoldPerc)
     {
         GoalDetails objGoalDetails = new GoalDetails();
         objGoalDetails.goalId = goalId;
         objGoalDetails.lumpsumDebtAmt = lumpsumDebtAmt;
      objGoalDetails.lumpsumEquityAmt =lumpsumEquityAmt;
      objGoalDetails.lumpsumGoldAmt = lumpsumGoldAmt;
      objGoalDetails.lumpsum = lumpsum;
      objGoalDetails.lumpsumEquityPerc = lumpsumEquityPerc;
        objGoalDetails.lumpsumDebtPerc = lumpsumDebtPerc;
        objGoalDetails.lumpsumGoldPerc = lumpsumGoldPerc;
        objEmergencyFundLumpsum = objGoalDetails;
        return objGoalDetails;
             
     }
    
    
    
    public GoalDetails populateGoalList(decimal IRR,String goalId
                      , String description
                      , String startYear
                      , String endYear
                      , double annualGoalCost
                      , String goalProfile
                      , String remark
                      , double equityAmt
                      , double debtAmt
                      , double goldAmt
                      , double SIP
                      , double equityPerc
                      , double debtPerc
                      , double goldPerc
                      , double lumpsumEquityAmt
                      , double lumpsumDebtAmt
                      , double lumpsumGoldAmt
                      , double lumpsum
                      , double lumpsumEquityPerc
                      , double lumpsumDebtPerc
                      , double lumpsumGoldPerc) 
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
      
      if(description != 'Emergency Fund')
        lstGoalDetails.add(objGoalDetails);
      else
        objEmergencyFundGoalDetails = objGoalDetails;
      return objGoalDetails; 
    }
    
    public class UnAllocatedAssets
    {
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

      ///Lumpsum
      public double lumpsum{get;set;}
        public double lumpsumEquityAmt{get;set;}
      public double lumpsumDebtAmt{get;set;}
      public double lumpsumGoldAmt{get;set;}
      
      public double lumpsumEquityPerc{get;set;}
      public double lumpsumDebtPerc{get;set;}
      public double lumpsumGoldPerc{get;set;}
      public boolean isRemove{get;set;}
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
                  , String executionTracker,Boolean isETCreated)
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
                  , String executionTracker,String SIPFundId,String strAssignedToOps,String strFormsProvided)
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
                    , String executionTracker,Boolean isETCreated)
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
                    , String executionTracker,String LumpsumFundId,String strAssignedToOps,String strFormsProvided)
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