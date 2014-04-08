/*
  Revision History:
  
  -------------GAURAV
    Version     Version Author     Date           Comments
    1.0         Prajakta Sanap     27/09/2012     New Action Plan Creation : ActionPlanServices is class to prepare the data as per the business logic. 
                           This is acting as service class for the ActionPlanController
 
    1.0         Aditi Satpute     08/10/2012      Created fetchGoalDetails function & RemoveRecordSIPFunds for New Action Plan
    2.0      Prajakta Sanap    01/04/2013      Added Gold Growth Rate for the new record type Gold in Investment Asset  
*/


public class ActionPlanServices
{
    DatabaseSOQL dbSOQLObj {get; set;}
    DatabaseDML dbDMLObj {get; set;}
    String currentLump = Label.CurrentLumpSumRecordType;
    String currentSIP = Label.CurrentSIPRecordType;
    String suggestedLump = Label.SuggestedLumpSumRecordType;
    String suggestedSIP = Label.SuggestedSIPRecordType;
    public double SIPtotal{get;set;}
    public double Lumpsumtotal{get;set;}
    public double SIPSummaryTotal{get;set;} 
    public Boolean isNewSIP{get;set;}
    private Map<Id,Remarks__c> entityRemarkMap{get;set;}
    private  Account objAccount {get;set;}
    private void setInfoMessage(String str) 
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,str));                                                                                                                               
    }
    
    Public ActionPlanServices()
    {	
        dbSOQLObj = new DatabaseSOQL();
        dbDMLObj = new DatabaseDML();
        isNewSIP = false;
    }
    
    private Map<Id,Investment_Asset__c> mapIdToInvestmentAsset = new Map<Id,Investment_Asset__c>();
    private Map<Id,Insurance__c> MapIdToLifeInsurance = new Map<Id,Insurance__c>();
    private Integer newCount = 0; 
    private Integer newInsuranceCount = 0; 
    
    //Created By : Aditi for new Action Plan
    public ApprovedPlanBean fetchGoalDetails(ApprovedPlanBean approvedPlanBean) 
   {   
	    List<Goal__c> goalList = dbSOQLObj.getAllGoals(approvedPlanBean.entityId);
	    //Added on 24/12/2012 : for Retrieving Family member
	    Set<Id> familyIdSet = new Set<Id>(); 
	    List<Account> lstAcc = dbSOQLObj.getFamilyMembers(approvedPlanBean.entityId);
    
	    for(Account objAcc : lstAcc)
	    {
	      familyIdSet.add(objAcc.Id);
	    }
        getCurrentMutualFunds(approvedPlanBean,familyIdSet);
        
        //Access goal values;
        getGoalAssetAllocation(approvedPlanBean, goalList,familyIdSet);
        getLifeInsurances(approvedPlanBean,familyIdSet);
        getGeneralInsurances(approvedPlanBean,familyIdSet);
        getRecommendedInsurances(approvedPlanBean,familyIdSet);
        
        return approvedPlanBean;       
    }
    
    //getWillExecTrackerDetails
      /**
    * @Description: Retrieve Execution Tracker Details of New Action Plan
    * param: ApprovedPlanBean 
    * return type: None 
    */ 
    public void getWillExecTrackerDetails(ApprovedPlanBean approvedPlanBean)
    {
       List<Approve_Action_Plan__c> lstApproveActionPlan = [Select Account__c, isWillExecTracker__c From Approve_Action_Plan__c 
                                where  Account__c =: approvedPlanBean.entityId and  isWill__c = : true and AP_Status__c = 'Opened'];
     if(!lstApproveActionPlan.isEmpty())
       for(Approve_Action_Plan__c objActionPlan : lstApproveActionPlan)
       {
         approvedPlanBean.isWillExecutionTracker = objActionPlan.isWillExecTracker__c ? 'Yes' : 'No';
       }
    }
    
     /**
    * @Description: Retrieve General Insurance Details of New Action Plan
    * param: ApprovedPlanBean 
    * return type: None 
    */ 
    public void getGeneralInsurances(ApprovedPlanBean approvedPlanBean,Set<Id> familyIdSet)
    {
      
	  	ApprovedPlanBean.GeneralInsurance objGeneralInsurance = new ApprovedPlanBean.GeneralInsurance();
	  	ApprovedPlanBean.GeneralInsurance objNewGeneralInsurance = new ApprovedPlanBean.GeneralInsurance();
	  
	  	List<Insurance__c> lstGeneralInsurance = dbSOQLObj.getAnalysisInsurances(InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c, approvedPlanBean.accList);
	  	Map<Id,Insurance__c> MapIdToInsurance = new Map<Id,Insurance__c>();
	  	Map<Id,Approve_Action_Plan__c> mapIdToApprovePlan = new Map<Id,Approve_Action_Plan__c>();
	    Approve_Action_Plan__c objApprovePlan = new Approve_Action_Plan__c();
	    String insured = '';
	    String insuredName = '';
	    String policyName = '';
	    String productName = '';
	    Long premiumAmount = 0;
	    String policyType = '';
	    Long sumAssured = 0;
	    boolean execTracker = false;
	    String executionTracker = '';
	    Id insuranceId;			
	    Boolean isETCreated = false;
	    Integer index = 0;
	    String actionPlanGeneralInsuranceID = '';
	      for(Insurance__c objInsurance : lstGeneralInsurance)
	      {
	        if(!MapIdToInsurance.containsKey(objInsurance.Id))
	        {
	          MapIdToInsurance.put(objInsurance.Id,objInsurance);
	        }
	      }
      
	      List<Approve_Action_Plan__c> lstApproveActionPlan = [Select  Transaction_Type__c, Action_Amount__c, Insurance__c, Remarks__c, Scheme_Name__c, Goal__c , Asset_Class__c, 
	                                     isInsuranceExecutionTracker__c,Amount__c, Investment_Asset__c, isSIPexecutionTracker__c, isETcreated__c,
	                                     Fund__c, Lumpsum_Action__c,SIP_Action_Amount__c,Amount_Per_Installment__c, SIP_Action__c, Product_Name__c, 
	                                   Account__c, Option__c,  isExecutionTracker__c ,Installments__c,  Account__r.FirstName, CreatedDate, 
	                                   Account__r.LastName,Category__c,Insured__c, Policy_Type__c,Sum_Assured_Rs__c,Premium_Amount_Rs__c
	                                   From Approve_Action_Plan__c
	                                   where  Account__c IN: familyIdSet and  Item_Type__c = : 'General Insurance'
	                                   and AP_Status__c = 'Opened'];

     for(Approve_Action_Plan__c objApproveActionPlan : lstApproveActionPlan )
     {
        if(objApproveActionPlan.Insurance__c == null)
        {
	        execTracker = objApproveActionPlan.isInsuranceExecutionTracker__c;
	        productName = objApproveActionPlan.Product_Name__c;
	        system.debug('*****productName*********'+productName);
	        executionTracker = execTracker ? 'Yes' : 'No';
            insured = objApproveActionPlan.Insured__c; 
            system.debug('*****insured*********'+insured);
           //policyName = '';
           insuredName = objApproveActionPlan.Insured__c;
           policyType = objApproveActionPlan.Policy_Type__c; 
           if(objApproveActionPlan.Sum_Assured_Rs__c != null)
           		sumAssured = objApproveActionPlan.Sum_Assured_Rs__c.round();
           if(objApproveActionPlan.Premium_Amount_Rs__c != null)
           		premiumAmount = objApproveActionPlan.Premium_Amount_Rs__c.round();
           actionPlanGeneralInsuranceID = objApproveActionPlan.Id;
           isETCreated = objApproveActionPlan.isETcreated__c;
           objNewGeneralInsurance = approvedPlanBean.populateNewGeneralInsurance( insured,  premiumAmount,  policyType,  sumAssured
                                           ,  execTracker,  executionTracker , productName, actionPlanGeneralInsuranceID
                                           , isETCreated,insuredName,index++);
           system.debug('*****objNewGeneralInsurance*********'+objNewGeneralInsurance);
         }
         
        if(!mapIdToApprovePlan.containsKey(objApproveActionPlan.Insurance__c))
        {
          mapIdToApprovePlan.put(objApproveActionPlan.Insurance__c,objApproveActionPlan);
        }
     }
     Insurance__c objInsurance = new Insurance__c();
       for(Id idInsurance : MapIdToInsurance.keySet())
       {
            objInsurance = MapIdToInsurance.get(idInsurance);
            if(objInsurance.Entity__r.LastName == null)
            {
               insured = objInsurance.Entity__r.FirstName;
            }
            else if(objInsurance.Entity__r.FirstName == null )
            {
            	insured = objInsurance.Entity__r.LastName;
         	}
           else if(objInsurance.Entity__r.LastName != null && objInsurance.Entity__r.FirstName != null)
           {
             insured = objInsurance.Entity__r.FirstName +' '+ objInsurance.Entity__r.LastName;
           }
           else 
           {
             insured = '';
           }
	       policyName = objInsurance.Policy_Name__c;
           if(objInsurance.Premium_Amount_Rs__c != null)
          		premiumAmount = objInsurance.Premium_Amount_Rs__c.round();
           policyType = objInsurance.Policy_Type__c;
           if(objInsurance.Sum_Assured_Rs__c != null)
        	 sumAssured = objInsurance.Sum_Assured_Rs__c.round();
           insuranceId = objInsurance.Id;
           if(mapIdToApprovePlan.containsKey(idInsurance))
          {
            objApprovePlan = mapIdToApprovePlan.get(idInsurance);
            execTracker = objApprovePlan.isInsuranceExecutionTracker__c;
            productName = objApprovePlan.Product_Name__c;
            executionTracker = execTracker ? 'Yes' : 'No';
            if(objApprovePlan.Premium_Amount_Rs__c != null)
           		premiumAmount = objApprovePlan.Premium_Amount_Rs__c.round();
            isETCreated = objApprovePlan.isETcreated__c;
          }
          else
          { 
              isETCreated = false;
            execTracker = true;
            executionTracker = 'Yes';
          }
           objGeneralInsurance = approvedPlanBean.populateGeneralInsurance( insured,  policyName,  premiumAmount,  policyType,  sumAssured
                                              ,  execTracker,  executionTracker,  insuranceId, productName,isETCreated);
       }
    }
    
   /*public static String ToString(Double Value)
    {
      //string representation if a Double value 
       return Value.format();
    }*/
    
    /**
    * @Description: Retrieve Life Insurance Details of New Action Plan
    * param: ApprovedPlanBean 
    * return type: None 
    */ 
    public void getLifeInsurances(ApprovedPlanBean approvedPlanBean,Set<Id> familyIdSet)
    {
	    ApprovedPlanBean.LifeInsurance objLifeInsurance = new ApprovedPlanBean.LifeInsurance();
	    List<Insurance__c> lstInsurance = dbSOQLObj.getAnalysisInsurances(InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c, approvedPlanBean.accList);
	    Map<Id,List<Approve_Action_Plan__c>> mapIdToApprovePlan = new Map<Id,List<Approve_Action_Plan__c>>();
	    List<Approve_Action_Plan__c> lstApprovePlan = new  List<Approve_Action_Plan__c>();
	    //Approve_Action_Plan__c objApprovePlan = new Approve_Action_Plan__c();
	    String insured = '';
	    double suggestedCover = 0;
	    String strSuggestedCover = '';
	    String policyName = '';
	    Long premiumAmount = 0;
	    String policyType = '';
	    double tenureOfInsurance = 0;
	    boolean execTracker = false;
	    String executionTracker = '';
	    //Added on:22/02/2013 : Aditi Satpute : AP changes
	    String insuranceRemark = '';
	    //Added on:06/02/2013 : Aditi Satpute : AP changes
	    Long sumAssured = 0;
	    Id insuranceId;
	    String actionPlanLifeInsuranceID = '';
	    Boolean isNewLI = false;
	    Boolean isETCreated = false;
        entityRemarkMap = new Map<Id,Remarks__c>();
      	for(Insurance__c objInsurance : lstInsurance)
      	{
       	  if(!MapIdToLifeInsurance.containsKey(objInsurance.Id))
          {
          	MapIdToLifeInsurance.put(objInsurance.Id,objInsurance);
          }
        }
       //Added on:22/02/2013 : Aditi Satpute : AP changes : Life Insurance Remark
       for(Remarks__c objRemark : [select Entity__c,Remark__c from Remarks__c where entity__c 
                      IN : familyIdSet and recordtype.Name =: 'LifeInsurancePlanning'])
       {
     	 if(entityRemarkMap.get(objRemark.entity__c) == null)
         entityRemarkMap.put(objRemark.entity__c,objRemark);
       }
	   List<Approve_Action_Plan__c> lstApproveActionPlan = [Select  Transaction_Type__c, Action_Amount__c, Insurance__c,Remarks__c, Scheme_Name__c, Goal__c , InsuranceRemark__c,
                                     Asset_Class__c,  isInsuranceExecutionTracker__c,Amount__c, Investment_Asset__c, isSIPexecutionTracker__c,
                                   Fund__c, Lumpsum_Action__c,SIP_Action_Amount__c,Amount_Per_Installment__c, SIP_Action__c, Policy_Name__c,
                                   Product_Name__c,  Account__c, Option__c,  isExecutionTracker__c ,Installments__c,  Account__r.FirstName, 
                                   CreatedDate,  Account__r.LastName,Category__c, Sum_Assured_Rs__c,Premium_Amount_Rs__c, Tenure_of_Insurance__c,
                                   isNewLI__c,Suggested_Cover__c,isETCreated__c From Approve_Action_Plan__c  
                                   where  Account__c =: familyIdSet and  Item_Type__c = : 'Life Insurance'
                                   and AP_Status__c = 'Opened' order by isNewLI__c];
                                   
    
     /* for(Approve_Action_Plan__c objApproveActionPlan : lstApproveActionPlan )
       {
        if(!mapIdToApprovePlan.containsKey(objApproveActionPlan.Insurance__c))
        {
          mapIdToApprovePlan.put(objApproveActionPlan.Insurance__c,objApproveActionPlan);
        }
        
       }*/
       
       for(Approve_Action_Plan__c objApproveActionPLan : lstApproveActionPlan )
       {
          if(mapIdToApprovePlan.get(objApproveActionPLan.Insurance__c) == null)
          {
            lstApproveActionPlan = new List<Approve_Action_Plan__c>();
            lstApproveActionPlan.add(objApproveActionPLan);
            mapIdToApprovePlan.put(objApproveActionPLan.Insurance__c, lstApproveActionPlan);
          }
          else
          {
            mapIdToApprovePlan.get(objApproveActionPLan.Insurance__c).add(objApproveActionPLan);
          }
       }
       Map<String,List<ApprovedPlanBean.LifeInsurance>> mapIdToInnerClass = new Map<String,List<ApprovedPlanBean.LifeInsurance>>();
       
       Insurance__c objInsurance = new Insurance__c();
       Remarks__c objRemarks = new Remarks__c();
       for(Id idInsurance : MapIdToLifeInsurance.keySet())
       {
           List<ApprovedPlanBean.LifeInsurance> lstLifeInsurance = new List<ApprovedPlanBean.LifeInsurance>();
            objInsurance = MapIdToLifeInsurance.get(idInsurance);
            if(mapIdToApprovePlan.containsKey(idInsurance))
          {
            lstApprovePlan = mapIdToApprovePlan.get(idInsurance);
            system.debug('**lstApprovePlan*****'+lstApprovePlan);
            system.debug('**lstApprovePlan.size()*****'+lstApprovePlan.size());
            
            for(Approve_Action_Plan__c  objApprovePlan : lstApprovePlan)
            {
                if(objInsurance.Entity__r.LastName == null)
                  {
                    insured = objInsurance.Entity__r.FirstName;
                  }
                  else if(objInsurance.Entity__r.FirstName == null )
                  {
                    insured = objInsurance.Entity__r.LastName;
                  }
                  else if(objInsurance.Entity__r.LastName != null && objInsurance.Entity__r.FirstName != null)
                  {
                    insured = objInsurance.Entity__r.FirstName +' '+ objInsurance.Entity__r.LastName;
                  }
                  else
                  {
                    insured = '';
                  }
                   system.debug('**objApprovePlan.Suggested_Cover__c*****'+objApprovePlan.Suggested_Cover__c);
                   suggestedCover = objApprovePlan.Suggested_Cover__c;
                   if(objApprovePlan.Suggested_Cover__c != null && objApprovePlan.Suggested_Cover__c != 0)
                     strSuggestedCover = suggestedCover.format();
              //Commented on:18/02/2013 : Aditi Satpute : AP changes
              //premiumAmount = objInsurance.Premium_Amount_Rs__c;
              policyType = objInsurance.Policy_Type__c;
              isETCreated = objApprovePlan.isETCreated__c;
              //Commented on:18/02/2013 : Aditi Satpute : AP changes
              //tenureOfInsurance = objInsurance.Tenure_of_Insurance__c;
              insuranceId = objInsurance.Id;
        
              //objApprovePlan = mapIdToApprovePlan.get(idInsurance);
            execTracker = objApprovePlan.isInsuranceExecutionTracker__c;
            policyName = objApprovePlan.Policy_Name__c;
            executionTracker = execTracker ? 'Yes' : 'No';
            //Added on:06/02/2013 : Aditi Satpute : AP changes
            if(objApprovePlan.Sum_Assured_Rs__c != null)
            	sumAssured = objApprovePlan.Sum_Assured_Rs__c.round();
            //Added on:18/02/2013 : Aditi Satpute : AP changes
            if(objApprovePlan.Premium_Amount_Rs__c != null)
            	premiumAmount = objApprovePlan.Premium_Amount_Rs__c.round();
            tenureOfInsurance = objApprovePlan.Tenure_of_Insurance__c;
            insuranceRemark = objApprovePlan.InsuranceRemark__c;
            isNewLI = objApprovePlan.isNewLI__c;
            
            objLifeInsurance = approvedPlanBean.populateLifeInsurance( insured,  suggestedCover, strSuggestedCover, policyName,  premiumAmount,  policyType
                                      , tenureOfInsurance,  execTracker,  executionTracker,  insuranceId
                                      , sumAssured, insuranceRemark,isNewLI, --newInsuranceCount,isETCreated);
                lstLifeInsurance.add(objLifeInsurance);
            }
           // actionPlanLifeInsuranceID = objApprovePlan.Id;
          }
          else
          {
            if(objInsurance.Entity__r.LastName == null)
                {
                  insured = objInsurance.Entity__r.FirstName;
                }
                else if(objInsurance.Entity__r.FirstName == null )
                {
                  insured = objInsurance.Entity__r.LastName;
                }
                else if(objInsurance.Entity__r.LastName != null && objInsurance.Entity__r.FirstName != null)
                {
                  insured = objInsurance.Entity__r.FirstName +' '+ objInsurance.Entity__r.LastName;
                }
                else
                {
                  insured = '';
                }
            suggestedCover = objInsurance.Suggested_Cover_General_Insurance__c;
             if(suggestedCover != null ||  suggestedCover != 0)
              strSuggestedCover = suggestedCover.format();
            //Commented on:18/02/2013 : Aditi Satpute : AP changes
            //premiumAmount = objInsurance.Premium_Amount_Rs__c;
            policyType = objInsurance.Policy_Type__c;
            insuranceId = objInsurance.Id;
            execTracker = true;
            executionTracker = 'Yes';
            policyName = '';
            sumAssured = 0;
            //Added on:18/02/2013 : Aditi Satpute : AP changes
            if(objInsurance.Premium_Amount_Rs__c != null)
              premiumAmount = objInsurance.Premium_Amount_Rs__c.round();
            //Added on:18/02/2013 : Aditi Satpute : AP changes
            if(objInsurance.Tenure_of_Insurance__c != null)
              tenureOfInsurance = objInsurance.Tenure_of_Insurance__c;
              if(entityRemarkMap.containsKey(objInsurance.Entity__c))
                {
                 objRemarks = entityRemarkMap.get(objInsurance.Entity__c);
                  insuranceRemark = objRemarks.Remark__c;
                  system.debug('**********insuranceRemark***in if******'+insuranceRemark);
                }
          
             objLifeInsurance = approvedPlanBean.populateLifeInsurance( insured,  suggestedCover, strSuggestedCover, policyName,  premiumAmount,  policyType
                                    , tenureOfInsurance,  execTracker,  executionTracker,  insuranceId
                                    , sumAssured, insuranceRemark,false,0,false);
                lstLifeInsurance.add(objLifeInsurance);
          }
           if(!mapIdToInnerClass.containsKey(insuranceId))
          {
            mapIdToInnerClass.put(insuranceId,lstLifeInsurance);
          }
          approvedPlanBean.mapIdToLifeInsuranceInnerClass = mapIdToInnerClass;
         }
       
      
    }
    
    /**
    * @Description: Retrieve the Current Mutual Funds of New Action Plan
    * param: ApprovedPlanBean 
    * return type: None 
    */ 
    public void getCurrentMutualFunds(ApprovedPlanBean approvedPlanBean,Set<Id> familyIdSet)
    { 
       Map<Id,List<Approve_Action_Plan__c>> mapIdToApprovePlan = new Map<Id,List<Approve_Action_Plan__c>>();
       Investment_Asset__c objInvestmentAsset = new Investment_Asset__c();
       List<Approve_Action_Plan__c> lstApprovePlan = new  List<Approve_Action_Plan__c>();
       List<Approve_Action_Plan__c> upsertList = new List<Approve_Action_Plan__c>();
       ApprovedPlanBean.CurrentMutualFunds objCurrentMutualFunds = new ApprovedPlanBean.CurrentMutualFunds();
       ApprovedPlanBean.CurrentMutualFunds objCurrentMutualFundsSIP = new ApprovedPlanBean.CurrentMutualFunds();
        
        //mapIdToInnerClass map returns the InvestmentID vs list of CurrentMutualFunds inner class to store splitting of individual records together with same ID 
        Map<Id,List<ApprovedPlanBean.CurrentMutualFunds>> mapIdToInnerClass = new Map<Id,List<ApprovedPlanBean.CurrentMutualFunds>>();
       // Map<String,List<ApprovedPlanBean.CurrentMutualFunds>> mapActionToMutualFundLumpsum = new Map<String,List<ApprovedPlanBean.CurrentMutualFunds>>();
       // Map<String,List<ApprovedPlanBean.CurrentMutualFunds>> mapActionToMutualFundSIP = new Map<String,List<ApprovedPlanBean.CurrentMutualFunds>>();
       
       double actionAmount = 0;
     double amount = 0;
     String assetClass = '';
     String lumpsumAction = '';
     String account = '';
     String owner = '';
     String schemeName = '';
     boolean execTracker = false;
     boolean SIPexecTracker = false;
     String executionTracker = '';
     String SIPexecutionTracker = '';
     double currentSIP = 0;
     String SIPaction = '';
     double SIPactionAmount;
     Id investmentId ;
     Boolean isNewMutualFund = false;
     Boolean isETCreated = false;
     Boolean isMFsipETCreated = false;
     //Added on:18/02/2013 : Aditi Satpute : AP changes
     //String mfLumpsumRemark = '';
     //String mfSIPRemark = ''; 
     //=================================================================
    
     //mapIdToInvestmentAsset map returns all records from Investment Assets which are mutual fund 
       mapIdToInvestmentAsset = new  Map<Id,Investment_Asset__c>
                                  ([Select  Entity__c, Entity__r.FirstName, Entity__r.LastName, Scheme_Name_Text__c , TotalAsset__c ,
                                      RecordType.Name,  Asset_Type__c,  Allocated_Amount__c,  Action__c , Monthly_SIP_Amount__c 
                                      From Investment_Asset__c  
                                      where  Entity__c =: familyIdSet //Added on 30/11/2012
                                      and  RecordType.Name = 'Mutual Fund']);
                                      
       //lstApproveActionPlan list returns all the records for current mutual funds  
       List<Approve_Action_Plan__c> lstApproveActionPlan = [Select Transaction_Type__c,Action_Amount__c,Remarks__c,Scheme_Name__c, Goal__c , Asset_Class__c,
                                Amount__c, Investment_Asset__c, isSIPexecutionTracker__c,Fund__c, Lumpsum_Action__c,SIP_Action_Amount__c,
                                Amount_Per_Installment__c, SIP_Action__c, Product_Name__c,  Account__c, Option__c,  isExecutionTracker__c, 
                                isNewMutualFund__c,Installments__c,  Account__r.FirstName,CreatedDate,  Account__r.LastName,Category__c,
                                 isETCreated__c,isMFsipETCreated__c From Approve_Action_Plan__c 
                                //MF_LumpsumRemark__c, MF_SIPRemark__c 
                            //    where  Account__c =: approvedPlanBean.entityId and  Investment_Asset__c != null];
                                   where  Account__c =: familyIdSet //Added on 30/11/2012 
                                   and  Investment_Asset__c != null and AP_Status__c = 'Opened' order by isNewMutualFund__c]; 
       
       for(Approve_Action_Plan__c objApproveActionPLan : lstApproveActionPlan )
         {
          if(mapIdToApprovePlan.get(objApproveActionPLan.Investment_Asset__c) == null)
          {
            lstApproveActionPlan = new List<Approve_Action_Plan__c>();
            lstApproveActionPlan.add(objApproveActionPLan);
            mapIdToApprovePlan.put(objApproveActionPLan.Investment_Asset__c, lstApproveActionPlan);
          }
          else
          {
            mapIdToApprovePlan.get(objApproveActionPLan.Investment_Asset__c).add(objApproveActionPLan);
          }
         }
       
       
       for(Id idInvestment : mapIdToInvestmentAsset.keySet())
       {
         List<ApprovedPlanBean.CurrentMutualFunds> lstCurrentMutualFunds = new List<ApprovedPlanBean.CurrentMutualFunds>();
         List<ApprovedPlanBean.CurrentMutualFunds> lstMFsip = new List<ApprovedPlanBean.CurrentMutualFunds>();
        objInvestmentAsset = mapIdToInvestmentAsset.get(idInvestment);
        System.debug('----------------------mapIdToApprovePlan.containsKey(idInvestment)--------------------'+mapIdToApprovePlan.containsKey(idInvestment));
        if(mapIdToApprovePlan.containsKey(idInvestment))
        {
          lstApprovePlan = mapIdToApprovePlan.get(idInvestment);
          for(Approve_Action_Plan__c objApprovePlan : lstApprovePlan)
          {
            actionAmount = objApprovePlan.Action_Amount__c;
            SIPactionAmount = objApprovePlan.SIP_Action_Amount__c;
            lumpsumAction = objApprovePlan.Lumpsum_Action__c;
            amount = objApprovePlan.Amount__c;
            assetClass = objInvestmentAsset.Asset_Type__c;
            if(objApprovePlan.Account__r.LastName == null)
                {
                  owner = objApprovePlan.Account__r.FirstName;
                }
                else if(objApprovePlan.Account__r.FirstName == null )
                {
                  owner = objApprovePlan.Account__r.LastName;
                }
                else if(objApprovePlan.Account__r.LastName != null && objApprovePlan.Account__r.FirstName != null)
                {
                  owner = objApprovePlan.Account__r.FirstName +' '+ objApprovePlan.Account__r.LastName;
                }
                else
                {
                  owner = '';
                }
            account = objApprovePlan.Account__c;
            schemeName = objInvestmentAsset.Scheme_Name_Text__c;
            execTracker = objApprovePlan.isExecutionTracker__c;
            SIPexecTracker = objApprovePlan.isSIPexecutionTracker__c;
            currentSIP = objInvestmentAsset.Monthly_SIP_Amount__c;
            SIPaction = objApprovePlan.SIP_Action__c;
            isNewMutualFund = objApprovePlan.isNewMutualFund__c;
            executionTracker = execTracker ? 'Yes' : 'No';
            SIPexecutionTracker = SIPexecTracker ? 'Yes' : 'No';
            investmentId = idInvestment;
            
            isETCreated = objApprovePlan.isETCreated__c;
            isMFsipETCreated = objApprovePlan.isMFsipETCreated__c;
            //Added on:18/02/2013 : Aditi Satpute : AP changes
            //mfLumpsumRemark = objApprovePlan.MF_LumpsumRemark__c;
            //mfSIPRemark = objApprovePlan.MF_SIPRemark__c;
            system.debug('******isETCreated********'+isETCreated);
            system.debug('******isMFsipETCreated********'+isMFsipETCreated);
            
            objCurrentMutualFunds = approvedPlanBean.populateCurrentMutualFunds
                                (schemeName, assetClass, 
                                 amount,owner, account, 
                                 lumpsumAction, actionAmount,
                                 execTracker,investmentId,
                                 executionTracker,isNewMutualFund, --newCount,isETCreated,isMFsipETCreated);//, mfLumpsumRemark);
                                 
            if(currentSIP != null && !isNewMutualFund  && currentSIP > 0)
              objCurrentMutualFunds = approvedPlanBean.populateSIPCurrentMutualFunds
                                (schemeName, assetClass,
                                 amount,owner, account,
                                 lumpsumAction, actionAmount, SIPactionAmount,
                                 execTracker,SIPexecTracker,investmentId,
                                 executionTracker,SIPexecutionTracker,currentSIP,
                                 SIPaction, isNewMutualFund,isETCreated,isMFsipETCreated);//, mfSIPRemark);
                                 
            lstCurrentMutualFunds.add(objCurrentMutualFunds);
            //lstMFsip.add(objCurrentMutualFundsSIP);
            //lstCurrentMutualFunds.add(objCurrentMutualFundsSIP);
          }
        }
        else
        {
          actionAmount = 0;
          //Commented on:18/02/2013 : Aditi Satpute : AP changes
          //lumpsumAction = 'Hold - Change of broker';
          //Added on:18/02/2013 : Aditi Satpute : AP changes
          lumpsumAction = '';
          amount = objInvestmentAsset.TotalAsset__c;
          assetClass = objInvestmentAsset.Asset_Type__c;
          account = objInvestmentAsset.Entity__c;
          if(objInvestmentAsset.Entity__r.LastName == null)
              {
                owner = objInvestmentAsset.Entity__r.FirstName;
              }
              else if(objInvestmentAsset.Entity__r.FirstName == null )
              {
                owner = objInvestmentAsset.Entity__r.LastName;
              }
              else if(objInvestmentAsset.Entity__r.LastName != null && objInvestmentAsset.Entity__r.FirstName != null)
              {
                owner = objInvestmentAsset.Entity__r.FirstName +' '+ objInvestmentAsset.Entity__r.LastName;
              }
              else
              {
                owner = '';
              }
          schemeName = objInvestmentAsset.Scheme_Name_Text__c;
          SIPactionAmount = 0;
          currentSIP = objInvestmentAsset.Monthly_SIP_Amount__c;
          SIPaction = 'Continue';
          execTracker = true;
          executionTracker = 'Yes';
          SIPexecTracker = true;
          SIPexecutionTracker = 'Yes';
          investmentId = idInvestment;
          objCurrentMutualFunds = approvedPlanBean.populateCurrentMutualFunds
                              (schemeName, assetClass, 
                               amount,owner, account, 
                               lumpsumAction, actionAmount,
                               execTracker,investmentId,
                               executionTracker,false, 0,false,false);
                               
          if(currentSIP != null  && !isNewMutualFund  && currentSIP > 0)
            objCurrentMutualFunds = approvedPlanBean.populateSIPCurrentMutualFunds
                              (schemeName, assetClass,
                               amount,owner, account,
                               lumpsumAction, actionAmount, SIPactionAmount,
                               execTracker,SIPexecTracker,investmentId,
                               executionTracker,SIPexecutionTracker,currentSIP,
                               SIPaction,false,false,false);
          
          lstCurrentMutualFunds.add(objCurrentMutualFunds);
          //lstMFsip.add(objCurrentMutualFundsSIP);
          //lstCurrentMutualFunds.add(objCurrentMutualFundsSIP);
        }
        system.debug('*****lstMFsip*******'+lstMFsip);
        system.debug('*****lstMFsip.size()*******'+lstMFsip.size());
        
        if(!mapIdToInnerClass.containsKey(idInvestment))
        {
          mapIdToInnerClass.put(idInvestment,lstCurrentMutualFunds);
        }
        system.debug('******mapIdToInnerClass*******'+mapIdToInnerClass);
        system.debug('******mapIdToInnerClass.size()*******'+mapIdToInnerClass.size());
        approvedPlanBean.mapIdToCurrentFunds = mapIdToInnerClass ;
        
       }
    }
    
    /**
    * @Description: Retrieve the Recommended Insurances of New Action Plan
    * param: ApprovedPlanBean 
    * return type: None 
    */ 
    public void getRecommendedInsurances(ApprovedPlanBean approvedPlanBean,Set<Id> familyIdSet)
    {
        List<Insurance__c> insuranceList = dbSOQLObj.getInsuranceListByRecordType(approvedPlanBean.entityId);
        ApprovedPlanBean.RecommendedInsurance objRecommendedInsurance = new ApprovedPlanBean.RecommendedInsurance();
        Approve_Action_Plan__c objApprovePlan = new Approve_Action_Plan__c();
        Map<Id,Approve_Action_Plan__c> mapIdToApprovePlan = new Map<Id,Approve_Action_Plan__c>();
        Account objAcc = new Account();
        Map<Id,Account> mapIdToAccount = new Map<Id,Account>([select Id,Name,LastName,FirstName from Account]);
        //Added on : 02/04/13 : Aditi Satpute : Purpose - need to save execution tracker details for this section : ET Screen Changes
        List<Approve_Action_Plan__c> lstApproveActionPlan = [Select  Transaction_Type__c, Action_Amount__c, Insurance__c, Remarks__c, Scheme_Name__c, Goal__c , Asset_Class__c, 
                                     isInsuranceExecutionTracker__c,Amount__c, Investment_Asset__c, isSIPexecutionTracker__c, isETcreated__c,
                                     Fund__c, Lumpsum_Action__c,SIP_Action_Amount__c,Amount_Per_Installment__c, SIP_Action__c, Product_Name__c, 
                                      Account__c, Option__c,  isExecutionTracker__c ,Installments__c,  Account__r.FirstName, CreatedDate, 
                                     Account__r.LastName,Category__c,Insured__c, Policy_Type__c,Sum_Assured_Rs__c,Premium_Amount_Rs__c
                                   From Approve_Action_Plan__c
                                   where  Account__c IN: familyIdSet and  Item_Type__c = : 'Recommended Insurance'
                                   and AP_Status__c = 'Opened'];
        
         for(Approve_Action_Plan__c objApproveActionPlan : lstApproveActionPlan )
         {
             if(!mapIdToApprovePlan.containsKey(objApproveActionPlan.Insurance__c))
            {
              mapIdToApprovePlan.put(objApproveActionPlan.Insurance__c,objApproveActionPlan);
          }
         }
        
        
        for(Insurance__c objInsurance : insuranceList)
        {
            String insured = '';
            String nominee = '';
            String insuranceCompany = '';
            String policyType = '';
            String policyName = '';
            String policyNumber = ''; 
            Date commencementDate;
            Date nextPremiumDueDate; 
            double deathBenefitRs = 0;
            double premiumAmountRs = 0;
            String premiumPaymentFrequency = '';
            double tenureofInsurance = 0;
            double premiumPayingTerm = 0;
            double surrenderCashValue = 0;
            double currentAmount = 0;
            double maturityAmount = 0;
            String action = '';
            Boolean execTracker = false;
            String executionTracker = '';
            String insuranceId = '';
            Boolean isETCreated = false;
           if(mapIdToAccount.containsKey(objInsurance.Nominee__c))
           {
               objAcc = mapIdToAccount.get(objInsurance.Nominee__c);
               nominee = objAcc.Name;
           }
          
           insured = objInsurance.Entity__r.Name;
           insuranceCompany = objInsurance.Insurance_Company__c;
           policyType = objInsurance.Policy_Type__c;
           policyName = objInsurance.Policy_Name__c;
           policyNumber = objInsurance.Policy_Number__c;
           commencementDate = objInsurance.Commencement_Date__c;
           nextPremiumDueDate = objInsurance.Next_Premium_Due_Date__c;
           deathBenefitRs = objInsurance.Death_Benefit_Rs__c;
           premiumAmountRs = objInsurance.Premium_Amount_Rs__c;
           premiumPaymentFrequency = objInsurance.Premium_Frequency__c;
           tenureofInsurance = objInsurance.Tenure_of_Insurance__c;
           premiumPayingTerm = objInsurance.Premium_Paying_Term__c;
           surrenderCashValue = objInsurance.Surrender_Cash_Value__c;
           currentAmount = objInsurance.Current_Amount__c;
           maturityAmount = objInsurance.Maturity_Amount__c;
           /* Prajakta - FP changes - 13-03-2013 */ 
           if(objInsurance.Maturity_Amount__c != null && objInsurance.Revised_Maturity_Amount__c == 0)
               maturityAmount = objInsurance.Maturity_Amount__c;
           else
               maturityAmount = objInsurance.Revised_Maturity_Amount__c;
           action = objInsurance.Action__c;
           //Added on : 02/04/13 : Aditi Satpute : Purpose - need to save execution tracker details for this section : ET Screen Changes
           if(mapIdToApprovePlan.containsKey(objInsurance.Id))
           {
               objApprovePlan = mapIdToApprovePlan.get(objInsurance.Id);
             execTracker = objApprovePlan.isInsuranceExecutionTracker__c;
               executionTracker = execTracker ? 'Yes' : 'No';
               isETCreated = objApprovePlan.isETcreated__c;
           }
           else
           { 
        /*if((action == 'To be grown till maturity but stop saving more') || (action == 'Liquidate (Align to goal)')) 
        {
          execTracker = false;
                   executionTracker = 'Yes';
        }   
        else
        {    
           execTracker = true;
                 executionTracker = 'No';
        } */     
        execTracker = false;
                executionTracker = 'No';
        isETCreated = false;
           }
           insuranceId = objInsurance.Id;
           //Added 3 extra parameters
           objRecommendedInsurance = approvedPlanBean.populateRecommendedInsurance (insured,nominee,insuranceCompany,policyType,policyName,
                        policyNumber,commencementDate,nextPremiumDueDate,deathBenefitRs,premiumAmountRs,premiumPaymentFrequency,tenureofInsurance,
                        premiumPayingTerm,surrenderCashValue,currentAmount,maturityAmount,action,executionTracker,execTracker,insuranceId,isETCreated);
        }
    }
    /**
    * @Description: Retrieve all Goal Related Details of New Action Plan
    * param: ApprovedPlanBean & List<Goal__c>
    * return type: None 
    */ 
    public void getGoalAssetAllocation(ApprovedPlanBean approvedPlanBean, List<Goal__c> goalList, Set<Id> familyIdSet)
    {
            
        ApprovedPlanBean.GoalDetails objActionPlanGoalDetails = new ApprovedPlanBean.GoalDetails();
        ApprovedPlanBean.GoalDetails objEmergencyLumpsumActionPlanGoalDetails = new ApprovedPlanBean.GoalDetails();
        ApprovedPlanBean.AllocatedAssets objActionPlanAllocatedAssets = new ApprovedPlanBean.AllocatedAssets();
        ApprovedPlanBean.UnAllocatedAssets objUnAllocatedAssets = new ApprovedPlanBean.UnAllocatedAssets();
   
        List<Insurance__c> insuranceList = dbSOQLObj.getInsuranceListByRecordType(approvedPlanBean.entityId);
        List<Investment_asset__c> investmentList = dbSOQLObj.getInvestmentAsset(approvedPlanBean.entityId,true);
        List<Asset__c>assetList = dbSOQLObj.getAssets(approvedPlanBean.entityId);
        Entity_Global_Assumption__c globalAssumptions = dbSOQLObj.getEntityGlobalAssumption(approvedPlanBean.entityId);
      
        List<GoalAssetAssociation__c> goalAssetAssociationList;
        List<GoalAssetAssociation__c> lstGoalAssetAssociation;
     
        List<GoalInsuranceAssociation__c> goalInsuranceAssociationList; 
        List<GoalInsuranceAssociation__c> lstGoalInsuranceAssociation;
      
       List<GoalInvestmentAssetAssociation__c> goalInvestmentAssetAssociationList; 
        List<GoalInvestmentAssetAssociation__c> lstGoalInvestmentAssetAssociation;
        
       goalAssetAssociationList = new List<GoalAssetAssociation__c>();
         goalInsuranceAssociationList = new List<GoalInsuranceAssociation__c>(); 
         goalInvestmentAssetAssociationList = new  List<GoalInvestmentAssetAssociation__c>();
     //==============================================================================================
       
        
     //===========AssetAssociation============================================================================================================
        Map<ID,List<GoalAssetAssociation__c>> goalAssetMappingMap = new Map<ID,List<GoalAssetAssociation__c>>();
        String entityId = approvedPlanBean.entityId;
        objAccount = dbSOQLObj.getEntity(entityId);
        //Query which returns all Allocated Goal Assets (Only assets, Not investment and insurance) 
        goalAssetAssociationList = dbSOQLObj.getGoalAssetAllocationList(entityId);
        
        //Map to store all AssetId's and its allocations 
        Map<String,Double> Assetpercentage = new Map<String,Double>(); 
        
        for(GoalAssetAssociation__c gaObj: goalAssetAssociationList)
        {
          //Assetpercentage returns a map of AssetId to Sum of particular Asset allocated to different goals
            if(Assetpercentage.containsKey(gaObj.asset__c))
            {
              Double dblPercentage = 0;
              if(Assetpercentage.get(gaObj.asset__c) != null)
                dblPercentage = Assetpercentage.get(gaObj.asset__c);
              Assetpercentage.put(gaObj.asset__c,dblPercentage + gaObj.allocated__c);    //If same asset allocated for different goal, then it gets added to the first allocated percentage
            }
            else
            {
                Assetpercentage.put(gaObj.asset__c, gaObj.allocated__c);          //If asset allocated for some goal
            }
            
        }
        
      double allocatedAmountAsset = 0;
      string strType = '';
      String strAssetDescription = '';
      
      //goalAssetMappingMap returns map of GoalId to different assets allocated for particular goal
      for(GoalAssetAssociation__c goalAssetAssociation : goalAssetAssociationList)
      {
        List<GoalAssetAssociation__c> lstGoalAsset = new List<GoalAssetAssociation__c>(); 
          if(goalAssetMappingMap.containsKey(goalAssetAssociation.Goal__c))
          {
            lstGoalAsset = goalAssetMappingMap.get(goalAssetAssociation.Goal__c);
            lstGoalAsset.add(goalAssetAssociation);
          }
          else
            lstGoalAsset.add(goalAssetAssociation);
            
          goalAssetMappingMap.put(goalAssetAssociation.Goal__c,lstGoalAsset);
      }
      
      //For unallocated assets only
      for(Asset__c objAssets : assetList)
      {
        if(Assetpercentage.containsKey(objAssets.Id))
            {
              allocatedAmountAsset = Assetpercentage.get(objAssets.Id);
              if(objAssets.RecordType.Name == 'Govt. Saving Schemes' ||
               objAssets.RecordType.Name == 'Retirement Accounts'|| 
               objAssets.RecordType.Name == 'Deposits With Bank')
              {
                strAssetDescription = (objAssets.RecordType.Name == 'Deposits With Bank') ? 
                      ((objAssets.Bank_Name__c != null) ? (objAssets.Bank_Name__c + ' - ' + objAssets.Account_Number__c)
                       : (objAssets.Account_Number__c)) : (objAssets.Account_Number__c);
              }
              else
                strAssetDescription = (objAssets.Description__c);
                                
              if(objAssets.Asset_Types__c!=null && objAssets.Asset_Types__c!='')
              {
                  strType = objAssets.Asset_Types__c;
                }
                else
                {
                    strType = objAssets.Account_Type__c;
                }
              if(objAssets.Monthly_Asset__c != null && allocatedAmountAsset < 100)
              {
                double CurrentValue = 0.0;
                CurrentValue = objAssets.Monthly_Asset__c;
                double remainingBalance = 0;
                if(CurrentValue != null)
                {
                  allocatedAmountAsset = (CurrentValue * allocatedAmountAsset) / 100;
                  remainingBalance = CurrentValue - allocatedAmountAsset;
                }
                else
                  remainingBalance = 0;
                if(remainingBalance != 0)
                    objUnAllocatedAssets =  approvedPlanBean.populateUnAllocatedAssets(strType,strAssetDescription,CurrentValue,remainingBalance);
                  
              }
            }
      }
           
  //===========Insurance============================================================================================================
        
        Map<ID,List<GoalInsuranceAssociation__c>> goalInsuranceMappingMap = new Map<ID,List<GoalInsuranceAssociation__c>>();
        
      goalInsuranceAssociationList = dbSOQLObj.getGoalInsuranceAllocationList(entityId);
        double allocatedAmountInsurance = 0;
        double currentInsuranceValue = 0;
        double calculateAllocatedAmount = 0;
        double remainingInsuranceBalance = 0;
         string strInsuranceType = '';
         string strInsuranceDescription = '';
        
        //Assetpercentage map returns InsuranceId vs Particular insurance allocated for different goals
        for(GoalInsuranceAssociation__c ginObj: goalInsuranceAssociationList)
        {
            if(Assetpercentage.containsKey(ginObj.Insurance__c))
            {
              Double dblPercentage = 0;
              if(Assetpercentage.get(ginObj.Insurance__c) != null)
                dblPercentage = Assetpercentage.get(ginObj.Insurance__c);
              Assetpercentage.put(ginObj.Insurance__c,dblPercentage + ginObj.allocated__c);
            }
            else
            {
                Assetpercentage.put(ginObj.Insurance__c, ginObj.allocated__c);
            }
        }

    //goalInsuranceMappingMap map returns different insurances allocated for particular goal
    for(GoalInsuranceAssociation__c goalInsuranceAssociation : goalInsuranceAssociationList) 
    {
        List<GoalInsuranceAssociation__c> lstInsuranceAssociation = new List<GoalInsuranceAssociation__c>();
        if(goalInsuranceMappingMap.containsKey(goalInsuranceAssociation.Goal__c)) 
        {
            lstInsuranceAssociation = goalInsuranceMappingMap.get(goalInsuranceAssociation.Goal__c);
            lstInsuranceAssociation.add(goalInsuranceAssociation);
        }
        else
          lstInsuranceAssociation.add(goalInsuranceAssociation);
        goalInsuranceMappingMap.put(goalInsuranceAssociation.Goal__c,lstInsuranceAssociation);       
    } 
    AssetAllocationService objAssetAllocation = new AssetAllocationService();
      
    for(Insurance__c objInsurance : insuranceList)
    {
      if(Assetpercentage.containsKey(objInsurance.Id))
            {
              if(objInsurance.Insurance_Company__c != null)
        {
          if(objInsurance.Policy_Name__c != null)
          {
            strInsuranceDescription = objInsurance.Policy_Number__c != null ? 
                      (objInsurance.Insurance_Company__c + ' -- ' + objInsurance.Policy_Name__c + ' -- ' + objInsurance.Policy_Number__c)
                      :(objInsurance.Insurance_Company__c + ' -- ' + objInsurance.Policy_Name__c);
          }
          else
            strInsuranceDescription = objInsurance.Policy_Number__c != null ? 
                       (objInsurance.Insurance_Company__c + ' -- ' + objInsurance.Policy_Number__c) : (objInsurance.Insurance_Company__c);
        }
        else
        {
          if(objInsurance.Policy_Name__c != null)
            strInsuranceDescription = objInsurance.Policy_Number__c != null ? 
                        (objInsurance.Policy_Name__c + ' -- ' + objInsurance.Policy_Number__c) : objInsurance.Policy_Name__c;
          else if(objInsurance.Policy_Number__c != null)
            strInsuranceDescription = objInsurance.Policy_Number__c;
        }

                strInsuranceType = objInsurance.Policy_Type__c;
              allocatedAmountInsurance = Assetpercentage.get(objInsurance.Id);
              Double dblOneInstallmentAmount = 0;
            Integer iTenureOfInsurance = 0 ;
            Integer iMaturityYear = 0;
            //if(!objInsurance.Premium_Frequency__c.equals('One Time Premium'))
            if(objInsurance.Premium_Amount_Rs__c != null)
               dblOneInstallmentAmount = objInsurance.Premium_Amount_Rs__c;
           
         if(objInsurance.Tenure_of_Insurance__c != null)
             iTenureOfInsurance = Integer.valueOf(objInsurance.Tenure_of_Insurance__c);
         iMaturityYear = iTenureOfInsurance + objInsurance.Commencement_Date__c.year();
         Integer iCurrentYearForCalculation = 0;
         /* Aditi - FP changes - 04-03-2013 - Changed Date.Today() to Plan_Generation_Date__c*/
     	 Integer startYear = objAccount.Plan_Generation_Date__c != null ? objAccount.Plan_Generation_Date__c.year() : Date.today().year();
         if(startYear > iMaturityYear)
           iCurrentYearForCalculation = iMaturityYear;
         else
           iCurrentYearForCalculation = startYear;
         Integer totalPeriodInYears =  iCurrentYearForCalculation - objInsurance.Commencement_Date__c.year();
        
        if(objInsurance.Surrender_Cash_Value__c == null)
        {  
          currentInsuranceValue = objAssetAllocation.GetInsuranceAmountForPeriod(objInsurance,totalPeriodInYears, dblOneInstallmentAmount);
          
        }  
        else
          currentInsuranceValue = objInsurance.Surrender_Cash_Value__c;
          calculateAllocatedAmount = (allocatedAmountInsurance * currentInsuranceValue)/100 ; 
           
         if(currentInsuranceValue != null)
            remainingInsuranceBalance= currentInsuranceValue - calculateAllocatedAmount;
          else
            remainingInsuranceBalance = 0;
          if(Math.floor(remainingInsuranceBalance) > 0)
        {
              objUnAllocatedAssets =  approvedPlanBean.populateUnAllocatedAssets(strInsuranceType,strInsuranceDescription,currentInsuranceValue,remainingInsuranceBalance);
        }
      }
    }
    
       //======================================================================================================================================
       
         Map<Id,Insurance__c> goalInsuranceMap = new Map<Id,Insurance__c>();
       goalInsuranceMap = dbSOQLObj.getInsuranceDetails(entityId);           

    //===========InvestmentAssets============================================================================================================      
         String strInvestmentType = '';
        double CurrentTotalValue = 0;
       double amountAllocatedInvestment = 0;
       double allocatedAmt = 0;
       double CurrentValue;
       double allocatedAmountInvestment=0;
       string strInvestmentDescription = '';
    double availableAmount = 0; 
    double balanceRemaining = 0;

        Map<ID,List<GoalInvestmentAssetAssociation__c>> goalInvestmentAssetMappingMap = new Map<ID,List<GoalInvestmentAssetAssociation__c>>();
      goalInvestmentAssetAssociationList = dbSOQLObj.getGoalInvestmentAssociationList(entityId);
      Map<String,List<Investment_Asset__c>> mapNameToInvestment = new Map<String,List<Investment_Asset__c>>();
      Integer i = 0;
      List<Investment_Asset__c> lstInvestment = new List<Investment_Asset__c>();

    //Assetpercentage map returns Investment_assetId vs particular InvestmentAsset aalocated for diff goals 
      for(GoalInvestmentAssetAssociation__c giObj: goalInvestmentAssetAssociationList)
      {
            if(Assetpercentage.containsKey(giObj.Investment_asset__c))
             { 
               Double dblPercentage = 0;
               if(Assetpercentage.get(giObj.Investment_asset__c) != null)
                 dblPercentage = Assetpercentage.get(giObj.Investment_asset__c);        //IA : Investment Asset
               Assetpercentage.put(giObj.Investment_asset__c,dblPercentage + giObj.allocated__c);  //If IA id is already present in map then sum up all the percentage allocated for diff goals
             }
             else
             {
                 Assetpercentage.put(giObj.Investment_asset__c, giObj.allocated__c);    //If IA Id is not present in the map, put it in the map
             }
        }    
       
      //goalInvestmentAssetMappingMap map returns GoalId vs different IA allocated for the same goal
      for(GoalInvestmentAssetAssociation__c goalInvestmentAssetAssociation : goalInvestmentAssetAssociationList) 
      {
          List<GoalInvestmentAssetAssociation__c> lstInvestmentAssetAssociation = new List<GoalInvestmentAssetAssociation__c>();
          if(goalInvestmentAssetMappingMap.containsKey(goalInvestmentAssetAssociation.Goal__c)) 
          {
              lstInvestmentAssetAssociation = goalInvestmentAssetMappingMap.get(goalInvestmentAssetAssociation.Goal__c);
                  lstInvestmentAssetAssociation.add(goalInvestmentAssetAssociation);
          }
          else
            lstInvestmentAssetAssociation.add(goalInvestmentAssetAssociation);
          goalInvestmentAssetMappingMap.put(goalInvestmentAssetAssociation.Goal__c,lstInvestmentAssetAssociation);       
    } 
    
    //
        List<Investment_Asset__c>   lstInvestmentAsset = new List<Investment_Asset__c>();
         for(Investment_Asset__c objInvestment : investmentList)
         {
           //i++;
           if(objInvestment.Action__c != '---None----')
          {
            strInvestmentType = objInvestment.RecordType.Name;
            if(Assetpercentage.containsKey(objInvestment.Id))
              {
                  allocatedAmountInvestment = Assetpercentage.get(objInvestment.Id);
            if(strInvestmentType == 'Fixed Income')
              {
                    CurrentValue = objInvestment.TotalAsset__c ;
                    CurrentTotalValue = CurrentTotalValue + CurrentValue;
                    amountAllocatedInvestment = (CurrentValue *  allocatedAmountInvestment)/100;
                    
                    //Prajakta - FP changes - 25-02-2013
                    Datetime dtReport = objInvestment.Maturity_Date__c;
                    String strDate = '';
                    if(dtReport != null)
                  strDate = dtReport.day() + '-' + dtReport.month() + '-' + dtReport.year();
                    strInvestmentDescription = objInvestment.Description__c + ' -- ' + strDate; 
                    //strInvestmentDescription = '-';        
                       if(CurrentValue != null)
                      balanceRemaining = CurrentValue - amountAllocatedInvestment;
                else
                      balanceRemaining = 0;
                  if(balanceRemaining != 0 && allocatedAmountInvestment < 100)
                      objUnAllocatedAssets =  approvedPlanBean.populateUnAllocatedAssets(strInvestmentType,strInvestmentDescription,CurrentValue,balanceRemaining);       
                  }
                  else
              {
                //Key is created to uniquely identify stocks and mutual fund of entity and its family members
                  if(mapNameToInvestment.containsKey(objInvestment.Entity__r.FirstName + ' ' + objInvestment.Entity__r.LastName + objInvestment.RecordType.Name))
                  {
                     List<Investment_Asset__c> lstRelatedInvAsset = new List<Investment_Asset__c>(); 
                     lstRelatedInvAsset = mapNameToInvestment.get(objInvestment.Entity__r.FirstName +' '+ objInvestment.Entity__r.LastName + objInvestment.RecordType.Name);
                     lstRelatedInvAsset.add(objInvestment);
                     mapNameToInvestment.put(objInvestment.Entity__r.FirstName +' '+ objInvestment.Entity__r.LastName + objInvestment.RecordType.Name,lstRelatedInvAsset);
                  }
                  else
                  {
                     List<Investment_Asset__c> lstRelatedInvAsset = new List<Investment_Asset__c>();
                     lstRelatedInvAsset.add(objInvestment);
                     mapNameToInvestment.put(objInvestment.Entity__r.FirstName + ' ' + objInvestment.Entity__r.LastName + objInvestment.RecordType.Name,lstRelatedInvAsset);
                  }
              }
           
            }
            }  
                system.debug('*****objInvestment :  '+objInvestment);  
                //system.debug('*****mapNameToInvestment :  '+mapNameToInvestment.values());    
        }
         Integer temp = 0 ;
         for(String strEntityName : mapNameToInvestment.keySet())
         {      
           system.debug('*****strEntityName :  '+strEntityName);    
           CurrentValue = 0;
           CurrentTotalValue = 0;
        lstInvestmentAsset = mapNameToInvestment.get(strEntityName);
        
        for(Investment_Asset__c objInvest : lstInvestmentAsset)
        {
          system.debug('****objInvest*****'+objInvest);
          strInvestmentDescription = '-';      
          CurrentValue = objInvest.TotalAsset__c ;
          system.debug('****CurrentValue*****'+CurrentValue);
          allocatedAmountInvestment = Assetpercentage.get(objInvest.Id);
          CurrentTotalValue = CurrentTotalValue + CurrentValue;
          system.debug('****CurrentTotalValue*****'+CurrentTotalValue);
          system.debug('****allocatedAmountInvestment*in stock****'+allocatedAmountInvestment);
           strInvestmentDescription = '-';        
          strInvestmentType = objInvest.RecordType.Name;         
          }
              
          amountAllocatedInvestment = (CurrentTotalValue *  allocatedAmountInvestment)/100;
          if(CurrentTotalValue != null)
            balanceRemaining = CurrentTotalValue - amountAllocatedInvestment;
        else
            balanceRemaining = 0;
        system.debug('****balanceRemaining****Stock n Mutual**'+balanceRemaining);
          if(balanceRemaining != 0 && allocatedAmountInvestment < 100)
             objUnAllocatedAssets =  approvedPlanBean.populateUnAllocatedAssets(strInvestmentType,strInvestmentDescription,CurrentTotalValue,balanceRemaining);
         }  
       //============================================================================================   
       
       
      
       ///////////////SIP MANASI
       List<Id> golIds = new List<Id>();
        for(Goal__c golObj: goalList)
        {
            golIds.add(golObj.Id);
        }
        List<GoalSIPAmount__c> goalSips= [select Goal__c, Goal_Year__c, SIP_Debt__c, SIP_Equity__c, SIP_Gold__c, SIP_Total__c,
                          GoldCurrentYear__c,EquityCurrentYear__c,DebtCurrentYear__c
                                from GoalSIPAmount__c 
                                where SIP_Outflow__c = true AND
                                Goal_Year__c =: system.today().year() and
                                Goal__c In: golIds and isNewSIP__c = true];
       // List<GoalSIPAmount__c> goalSips = dbSOQLObj.getGoalSIP(system.today().year(), golIds);
        Map<Id,GoalSIPAmount__c> goalIdVsGoalSIPAmount = new Map<Id,GoalSIPAmount__c>();
         
        for(GoalSIPAmount__c objGoalSIPAmount : goalSips)
        {
          //
          if(!goalIdVsGoalSIPAmount.containsKey(objGoalSIPAmount.Goal__c))
            goalIdVsGoalSIPAmount.put(objGoalSIPAmount.Goal__c,objGoalSIPAmount);
            
        } 
        //////////////////////SIP Funds/
        
        List<Approve_Action_Plan__c> lstApprove_Action_Plan  = [Select  Transaction_Type__c, a.Remarks__c,a.Goal__c ,a.isSIPexecutionTracker__c ,a.Amount__c,a.Product_Name__c, 
                                    a.Option__c, a.Installments__c, a.CreatedDate, a.Category__c,isETcreated__c From Approve_Action_Plan__c a 
                                    where a.Account__c IN: familyIdSet and a.Item_Type__c = 'SIP' and AP_Status__c = 'Opened'];
       Map<Id,List<Approve_Action_Plan__c>> mapGoalIdToAppActionPlan = new Map<Id,List<Approve_Action_Plan__c>>();
        for(Approve_Action_Plan__c objApproveActionPLan :lstApprove_Action_Plan )
        {
          lstApprove_Action_Plan = mapGoalIdToAppActionPlan.get(objApproveActionPLan.Goal__c);
          if(lstApprove_Action_Plan == null)
          {
            lstApprove_Action_Plan = new List<Approve_Action_Plan__c>();
            mapGoalIdToAppActionPlan.put(objApproveActionPLan.Goal__c,lstApprove_Action_Plan);
          }
          lstApprove_Action_Plan.add(objApproveActionPLan);
        }
        //LumpsumFunds==================================
        List<Approve_Action_Plan__c> lstLumpsumApproveActionPlan  = [Select a.Transaction_Type__c, a.Remarks__c,a.Goal__c ,a.Goal__r.Description__c ,a.Lumpsum_Equity__c,
                                      a.Amount__c,a.Fund__c,a.Amount_Per_Installment__c,a.Product_Name__c,a.Lumpsum_Debt__c,a.isLumpsumExecTracker__c,
                                      a.Option__c, a.Installments__c, a.CreatedDate, a.Category__c ,a.Lumpsum_Gold__c,isETCreated__c 
                                      From Approve_Action_Plan__c a where a.Account__c IN: familyIdSet and a.Item_Type__c = 'Lumpsum'
                                      and AP_Status__c = 'Opened'];
         Map<Id,List<Approve_Action_Plan__c>> mapGoalIdToLumpsumAppActionPlan = new Map<Id,List<Approve_Action_Plan__c>>();
        Map<Id,List<Approve_Action_Plan__c>> mapGoalIdToEmergencyLumpsumAppActionPlan = new Map<Id,List<Approve_Action_Plan__c>>();
        for(Approve_Action_Plan__c objApproveActionPLan :lstLumpsumApproveActionPlan )
        {
          if(objApproveActionPLan.Goal__r.Description__c == 'Emergency Fund')
          {
            lstLumpsumApproveActionPlan = mapGoalIdToEmergencyLumpsumAppActionPlan.get(objApproveActionPLan.Goal__c);
            if(lstLumpsumApproveActionPlan == null)
            {
              lstLumpsumApproveActionPlan = new List<Approve_Action_Plan__c>();
              mapGoalIdToEmergencyLumpsumAppActionPlan.put(objApproveActionPLan.Goal__c,lstLumpsumApproveActionPlan);
            }
            lstLumpsumApproveActionPlan.add(objApproveActionPLan);
            
          }
          else
          {
            lstLumpsumApproveActionPlan = mapGoalIdToLumpsumAppActionPlan.get(objApproveActionPLan.Goal__c);
            if(lstLumpsumApproveActionPlan == null)
            {
              lstLumpsumApproveActionPlan = new List<Approve_Action_Plan__c>();
              mapGoalIdToLumpsumAppActionPlan.put(objApproveActionPLan.Goal__c,lstLumpsumApproveActionPlan);
            }
            lstLumpsumApproveActionPlan.add(objApproveActionPLan);
          }
        }
        
        ///Lumpsum===================================================
         Map<id,List<Double>> goalIdVsListDoubleMap = new Map<id,List<Double>>(); 
    For(Goal__c objGoal : approvedPlanBean.goalList)
    {
      if(!goalIdVsListDoubleMap.containsKey(objGoal.id))
      {
        goalIdVsListDoubleMap.put(objGoal.id,new List<Double>{0,0,0});
      }
    }
    for(ApprovedPlanBean.DoneClass objDone : approvedPlanBean.suggestedLumpSum)
    {
      String className = objDone.className;
      List<Double> dblLumsumVals = objDone.golListVals;
      
      for(Integer iCount = 0; iCount < dblLumsumVals.size(); iCount++)
      {
        List<Double> lstLumpsumVals;
        Goal__c objGoal = approvedPlanBean.goalList.get(iCount);
        if(goalIdVsListDoubleMap.containsKey(objGoal.id))
        {
          system.debug('****dblLumsumVals******'+dblLumsumVals);
          if(className == 'Equity')
          {
            lstLumpsumVals = goalIdVsListDoubleMap.get(objGoal.id);
            lstLumpsumVals[0] = dblLumsumVals[iCount];
            goalIdVsListDoubleMap.put(objGoal.id,lstLumpsumVals);
          }
          else if(className == 'Debt')
          {
            lstLumpsumVals = goalIdVsListDoubleMap.get(objGoal.id);
            lstLumpsumVals[1] = dblLumsumVals[iCount];
            goalIdVsListDoubleMap.put(objGoal.id,lstLumpsumVals);
          }
          else if(className == 'Gold')
          {
            lstLumpsumVals = goalIdVsListDoubleMap.get(objGoal.id);
            lstLumpsumVals[2] = dblLumsumVals[iCount];
            goalIdVsListDoubleMap.put(objGoal.id,lstLumpsumVals);
          }
        }
      }
      
      
    }
        
        //=======================================================
       Map<String,List<GoalInvestmentAssetAssociation__c>> mapNameToInvestmentAsset = new Map<String,List<GoalInvestmentAssetAssociation__c>>();
     SIPSummaryTotal = 0;
     List<Approve_Action_Plan__c> lstNewApproveActionPlan = [Select Id,AP_Status__c From Approve_Action_Plan__c  
                                          where Account__c IN: familyIdSet and AP_Status__c = 'Opened'];
         
         if(lstNewApproveActionPlan.isEmpty())
         {
           isNewSIP = true;
         }
         String strRemark = '';
         List<Remarks__c> lstRemark = [select Remark__c from Remarks__c where entity__c =:entityId and recordtype.Name=:'EmergencyPlanning' limit 1];
         if(!lstRemark.isEmpty())
         {
            for(Remarks__c obj : lstRemark)
       {
         strRemark = obj.Remark__c;
       }
         }
     
         for(Goal__c goal: goalList) 
         { 
           lstGoalAssetAssociation = new  List<GoalAssetAssociation__c>();
           mapNameToInvestmentAsset = new Map<String,List<GoalInvestmentAssetAssociation__c>>();
         GoalSIPAmount__c objGoalSIPAmount;
           lstGoalInsuranceAssociation = new List<GoalInsuranceAssociation__c>();
          lstGoalInvestmentAssetAssociation = new List<GoalInvestmentAssetAssociation__c>();
          List<Approve_Action_Plan__c> lstPlan = new List<Approve_Action_Plan__c>();
          List<Approve_Action_Plan__c> lstPlanForLumpsum = new List<Approve_Action_Plan__c>();
          Double installments=0;
          String option ='';
          String remarks = '';
          String productName='' ;
          String transactionType='';
          String category='';
          Double amount=0;
          Double AssetsTotal = 0;
        
            String description = goal.Description__c;
            String startYear = goal.Goal_Start_Year__c;
            String endYear = goal.Goal_End_Year__c;
            Double annualGoalCost = goal.Cost_of_Goal_Annual__c;
            String goalProfile = goal.Description__c == 'Emergency Fund'? 'Conservative' : goal.SelectedGoalProfile__r.Name;
            String remark = goal.Description__c == 'Emergency Fund'? strRemark : goal.Remark__c;
            
            //SIP declaration
            String strEquityAmt;
            Double debtAmt = 0;
            Double SIP = 0;
             Double equityAmt = 0;
          Double goldAmt = 0;
          Double equityPerc = 0;
          Double debtPerc = 0;
          Double goldPerc = 0;
          Boolean execTracker = false;
          String executionTracker = '';
          Boolean sipETCreated = false;
          
          //Lumpsum declaration
          Double lumpsumDebtAmt = 0;
            Double lumpsum = 0;
             Double lumpsumEquityAmt = 0;
          Double lumpsumGoldAmt = 0;
          Double lumpsumEquityPerc = 0;
          Double lumpsumDebtPerc = 0;
          Double lumpsumGoldPerc = 0;
          
          //Lumpsum Funds declaration
          Double lumpsumInstallments=0;
          String lumpsumOption ='';
          String lumpsumRemarks = '';
          String lumpsumProductName='' ;
          String lumpsumTransactionType='';
          String lumpsumCategory='';
          Double lumpsumAmount=0;
          String lumpsumFund='';
          Double lumpsumAmountPerInstall=0;
          String lumpsumExecutionTracker = '';
          Boolean lumpsumExecTracker = false;
          Boolean lumpsumETCreated = false;
          
        /*  if(isNewSIP)
          {
              SIP = 0;
                equityAmt = 0;
                debtAmt = 0;
                goldAmt = 0;
                
              equityPerc = 0;
              debtPerc = 0;
              goldPerc = 0;
                
          } 
          else
          {*/
              if(goalIdVsGoalSIPAmount.containsKey(goal.Id))
              {
                
                  objGoalSIPAmount = goalIdVsGoalSIPAmount.get(goal.Id);
                  if(objGoalSIPAmount != null)
                  {
                    //strDebtAmt = string.valueOf(objGoalSIPAmount.SIP_Debt__c);
                    SIP = objGoalSIPAmount.SIP_Total__c;
                    equityAmt = objGoalSIPAmount.SIP_Equity__c;
                    debtAmt = objGoalSIPAmount.SIP_Debt__c;
                    goldAmt = objGoalSIPAmount.SIP_Gold__c;
                    if(SIP !=0)
                    {
                      equityPerc = (equityAmt * 100)/SIP;
                      debtPerc = (debtAmt * 100)/SIP;
                      goldPerc = (goldAmt * 100)/SIP;
                    }
                  }
              }
          //}
           //=========================Emergency Funds Lumpsum=======================
         List<Approve_Action_Plan__c> lstLumpsum = new  List<Approve_Action_Plan__c>();
         if(goal.Description__c == 'Emergency Fund')
         {
             system.debug('**goal.Id : Emergency Fund ****'+goal.Id);
            if(mapGoalIdToEmergencyLumpsumAppActionPlan.containsKey(goal.Id))
            {
              lstLumpsum = mapGoalIdToEmergencyLumpsumAppActionPlan.get(goal.Id);
              for(Approve_Action_Plan__c objLumpsum : lstLumpsum)
              {
                if(objLumpsum.Lumpsum_Equity__c != null)
                {
                    lumpsumEquityAmt = objLumpsum.Lumpsum_Equity__c;
                    lumpsumDebtAmt = objLumpsum.Lumpsum_Debt__c;
                    lumpsumGoldAmt = objLumpsum.Lumpsum_Gold__c;
                    lumpsum = lumpsumEquityAmt+lumpsumDebtAmt+lumpsumGoldAmt;
                    if(lumpsum !=0)
                    {
                      lumpsumEquityPerc = (lumpsumEquityAmt * 100)/lumpsum;
                      lumpsumDebtPerc = (lumpsumDebtAmt * 100)/lumpsum;
                      lumpsumGoldPerc = (lumpsumGoldAmt * 100)/lumpsum;
                    }
                    objEmergencyLumpsumActionPlanGoalDetails = approvedPlanBean.populateEmergencyLumpsumDetails(goal.Id,lumpsumEquityAmt,
                                 lumpsumDebtAmt,lumpsumGoldAmt,lumpsum,lumpsumEquityPerc,lumpsumDebtPerc,lumpsumGoldPerc); 
                }
              }
            }
            else
            {
                  lumpsumEquityAmt = 0;
                  lumpsumDebtAmt = 0;
                  lumpsumGoldAmt = 0;
                  lumpsum = 0;
                  lumpsumEquityPerc = 0;
                  lumpsumDebtPerc = 0;
                  lumpsumGoldPerc = 0;
                  
                  objEmergencyLumpsumActionPlanGoalDetails = approvedPlanBean.populateEmergencyLumpsumDetails(goal.Id,lumpsumEquityAmt,
                             lumpsumDebtAmt,lumpsumGoldAmt,lumpsum,lumpsumEquityPerc,lumpsumDebtPerc,lumpsumGoldPerc); 
            }
           }
         
           //========================================================================
           //Lumpsum
           List<Double> objLumpsums = new List<Double>();
           if(goalIdVsListDoubleMap.containsKey(goal.Id))
           {
                objLumpsums = goalIdVsListDoubleMap.get(goal.Id);
                if(objLumpsums != null)
                {
                    lumpsumEquityAmt = objLumpsums[0];
                    lumpsumDebtAmt = objLumpsums[1];
                    lumpsumGoldAmt = objLumpsums[2];
                    lumpsum = lumpsumEquityAmt+lumpsumDebtAmt+lumpsumGoldAmt;
                    if(lumpsum !=0)
                    {
                      lumpsumEquityPerc = (lumpsumEquityAmt * 100)/lumpsum;
                      lumpsumDebtPerc = (lumpsumDebtAmt * 100)/lumpsum;
                      lumpsumGoldPerc = (lumpsumGoldAmt * 100)/lumpsum;
                    }
                }
            }
            
            objActionPlanGoalDetails = approvedPlanBean.populateGoalList (goal.IRR__c,goal.Id,description,startYear,endYear,
                                              annualGoalCost,goalProfile,remark,equityAmt,debtAmt,goldAmt,SIP,equityPerc,debtPerc,goldPerc,lumpsumEquityAmt,
                                              lumpsumDebtAmt,lumpsumGoldAmt,lumpsum,lumpsumEquityPerc,lumpsumDebtPerc,lumpsumGoldPerc); 
            
            //=============SIP Funds & Lumpsum Funds==========================================================   
            SIPtotal = 0;
             if(mapGoalIdToAppActionPlan.containsKey(goal.id))
            {
               lstPlan = mapGoalIdToAppActionPlan.get(goal.id);
               for(Approve_Action_Plan__c objPlan : lstPlan)
               {
                  installments = objPlan.Installments__c;
                 option = objPlan.Option__c;
                 remarks = objPlan.Remarks__c;
                 productName = objPlan.Product_Name__c;
                 transactionType = objPlan.Transaction_Type__c;
                 sipETCreated = objPlan.isETCreated__c;
                 category = objPlan.Category__c;
                 amount = objPlan.Amount__c;
                 execTracker = objPlan.isSIPexecutionTracker__c;
                 if(execTracker)
                executionTracker = 'Yes';
               else
                executionTracker = 'No';
                 SIPtotal = SIPtotal + amount;
                 SIPSummaryTotal = SIPSummaryTotal + amount;
                  objActionPlanGoalDetails.populateSIPFunds(productName,transactionType,amount,installments,category,option,remarks,execTracker,executionTracker,SipETCreated);
               }
            }
            
            approvedPlanBean.SIPSummaryTotal = SIPSummaryTotal;
            double Lumpsumtotal = 0;
            if(mapGoalIdToLumpsumAppActionPlan.containsKey(goal.id))
            {
               lstPlanForLumpsum = mapGoalIdToLumpsumAppActionPlan.get(goal.id);
               for(Approve_Action_Plan__c objPlan : lstPlanForLumpsum)
               {
                lumpsumInstallments = objPlan.Installments__c;
                 lumpsumOption = objPlan.Option__c;
                  lumpsumRemarks = objPlan.Remarks__c;
                 lumpsumProductName = objPlan.Product_Name__c;
                  lumpsumTransactionType = objPlan.Transaction_Type__c;
                 lumpsumCategory = objPlan.Category__c;
                 lumpsumAmount = objPlan.Amount__c;
                 lumpsumFund = objPlan.Fund__c;
                 lumpsumAmountPerInstall = objPlan.Amount_Per_Installment__c;
                 lumpsumExecTracker = objPlan.isLumpsumExecTracker__c;
                 lumpsumETCreated = objPlan.isETCreated__c;
                 if(lumpsumExecTracker)
                lumpsumExecutionTracker = 'Yes';
               else
                lumpsumExecutionTracker = 'No';
                 Lumpsumtotal = Lumpsumtotal + lumpsumAmount;
                objActionPlanGoalDetails.populateLumpsumFunds(lumpsumProductName,lumpsumTransactionType,lumpsumAmount,lumpsumInstallments,lumpsumCategory,lumpsumOption,lumpsumRemarks,lumpsumFund,lumpsumAmountPerInstall
                                        ,lumpsumExecTracker,lumpsumExecutionTracker,lumpsumETCreated);
                 }
           }
           else if(mapGoalIdToEmergencyLumpsumAppActionPlan.containsKey(goal.Id))
           {
             lstPlanForLumpsum = mapGoalIdToEmergencyLumpsumAppActionPlan.get(goal.id);
               for(Approve_Action_Plan__c objPlan : lstPlanForLumpsum)
               {
                 if(objPlan.Amount__c != null)
                 {
                    lumpsumInstallments = objPlan.Installments__c;
                     lumpsumOption = objPlan.Option__c;
                      lumpsumRemarks = objPlan.Remarks__c;
                     lumpsumProductName = objPlan.Product_Name__c;
                      lumpsumTransactionType = objPlan.Transaction_Type__c;
                     lumpsumCategory = objPlan.Category__c;
                     lumpsumAmount = objPlan.Amount__c;
                     lumpsumFund = objPlan.Fund__c;
                     lumpsumAmountPerInstall = objPlan.Amount_Per_Installment__c;
                     lumpsumExecTracker = objPlan.isLumpsumExecTracker__c;
                     lumpsumETCreated = objPlan.isETCreated__c;
                     if(lumpsumExecTracker)
                    lumpsumExecutionTracker = 'Yes';
                   else
                    lumpsumExecutionTracker = 'No';
                     Lumpsumtotal = Lumpsumtotal + lumpsumAmount;
                    objActionPlanGoalDetails.populateLumpsumFunds(lumpsumProductName,lumpsumTransactionType,lumpsumAmount,lumpsumInstallments,lumpsumCategory,lumpsumOption,lumpsumRemarks,lumpsumFund,lumpsumAmountPerInstall
                                             ,lumpsumExecTracker,lumpsumExecutionTracker,lumpsumETCreated);
                 }
                 }
           }
           objActionPlanGoalDetails.SIPTotal = SIPtotal;
          objActionPlanGoalDetails.LumpsumTotal = Lumpsumtotal;
          
            //=========================================================================================================================
          
            //AssetAssociation
            strAssetDescription = '';
            double dblAssetExpectedGrowthRate = 10.0d;
            double dblAssetInterestRate = 0;
            double dblAssetGoalYearValue = 0;
            String strAssetAction = '';
            String strAssetType = '';
            String strAssetOwner = '';
            
            //goalAssetMappingMap returns map of GoalId to different assets allocated for particular goal
            if(goalAssetMappingMap.containsKey(goal.id))
            {
                  Map<Id,Asset__c> mapIdToAsset = new Map<Id,Asset__c>();
                lstGoalAssetAssociation = goalAssetMappingMap.get(goal.id);
                if(lstGoalAssetAssociation != null)
                {
                  for(GoalAssetAssociation__c objGoalAssetAssociation : lstGoalAssetAssociation)
                  {
                    for(Asset__c asset : assetList) 
                     {      
                      if(!mapIdToAsset.containsKey(asset.Id))
                      {
                        mapIdToAsset.put(asset.Id,asset);
                      }
                     }

                    if(objGoalAssetAssociation.asset__r.Action__c != '---None----')
                    {
                      
                      if(mapIdToAsset.ContainsKey(objGoalAssetAssociation.Asset__r.Id))
                      {
                        
                        if(objGoalAssetAssociation.Asset__r.RecordType.Name == 'Govt. Saving Schemes' ||
                            objGoalAssetAssociation.Asset__r.RecordType.Name == 'Retirement Accounts'|| 
                            objGoalAssetAssociation.Asset__r.RecordType.Name == 'Deposits With Bank')
                        {
                          strAssetDescription = (objGoalAssetAssociation.Asset__r.RecordType.Name == 'Deposits With Bank') ? 
                                  ((objGoalAssetAssociation.Asset__r.Bank_Name__c != null) ? 
                                  (objGoalAssetAssociation.Asset__r.Bank_Name__c + ' - ' + objGoalAssetAssociation.Asset__r.Account_Number__c) 
                                  : (objGoalAssetAssociation.Asset__r.Account_Number__c))  
                                  : (objGoalAssetAssociation.Asset__r.Account_Number__c);
                        }
                        else
                          strAssetDescription = (objGoalAssetAssociation.Asset__r.Description__c);
                          
                        
                        if(objGoalAssetAssociation.Asset__r.Asset_Types__c!=null && objGoalAssetAssociation.Asset__r.Asset_Types__c!='')
                        {
                            strAssetType = objGoalAssetAssociation.Asset__r.Asset_Types__c;
                          }
                          else
                          {
                              strAssetType = objGoalAssetAssociation.Asset__r.Account_Type__c;
                          }
                          
                        if(objGoalAssetAssociation.asset__r.entity__r.LastName == null)
                        {
                          strAssetOwner = objGoalAssetAssociation.asset__r.entity__r.FirstName;
                        }
                        else if(objGoalAssetAssociation.asset__r.entity__r.FirstName == null )
                        {
                          strAssetOwner = objGoalAssetAssociation.asset__r.entity__r.LastName;
                        }
                        else if(objGoalAssetAssociation.asset__r.entity__r.LastName != null && objGoalAssetAssociation.asset__r.entity__r.FirstName != null)
                        {
                          strAssetOwner = objGoalAssetAssociation.asset__r.entity__r.FirstName +' '+objGoalAssetAssociation.asset__r.entity__r.LastName;
                        }
                        else
                        {
                          strAssetOwner = '';
                        }
                        double allocatedAmount = 0;
                        availableAmount = 0; 
                        double amountAllocated = 0;
                        
                        strAssetAction = objGoalAssetAssociation.asset__r.action__c;
                        dblAssetGoalYearValue = objGoalAssetAssociation.GoalYearValue__c;
                        amountAllocated =objGoalAssetAssociation.Allocation__c ;
                          AssetsTotal = AssetsTotal + amountAllocated;
                        dblAssetExpectedGrowthRate = (objGoalAssetAssociation.asset__r.Expected_Growth_Rate__c != null ? 
                                        objGoalAssetAssociation.asset__r.Expected_Growth_Rate__c : 0 );
                        
                    if(objGoalAssetAssociation.asset__r.RecordType.Name.equals('Deposits With Bank') || 
                      objGoalAssetAssociation.asset__r.RecordType.Name.equals('Retirement Accounts')||
                      objGoalAssetAssociation.asset__r.RecordType.Name.equals('Govt. Saving Schemes'))
                            {
                                   if(objGoalAssetAssociation.asset__r.Interest_Rate__c != null)
                                      dblAssetInterestRate = Double.valueOf(String.valueOf(objGoalAssetAssociation.asset__r.Interest_Rate__c));
                                else
                                  {
                                       dblAssetInterestRate = 0;
                                       setInfoMessage('Please fill the Interest rate for allocated asset: '+objGoalAssetAssociation.asset__r.RecordType.Name);
                                  }
                              }
                              else
                                     dblAssetInterestRate = Double.valueOf(String.valueOf(objGoalAssetAssociation.asset__r.CalculatedInterestRate__c));
                          if(dblAssetInterestRate == null) 
                            {
                                        setInfoMessage('Interest Rate is not valid for some assets.');
                                continue;
                          }
                             if(objGoalAssetAssociation.asset__r.RecordType.Name.equals('Real Estate Assets') || 
                             objGoalAssetAssociation.asset__r.RecordType.Name.equals('Business Assets') || 
                            objGoalAssetAssociation.asset__r.RecordType.Name.equals('Personal Assets'))
                             {
                                 dblAssetInterestRate = dblAssetExpectedGrowthRate;
                             }
                        objActionPlanAllocatedAssets = objActionPlanGoalDetails.populateAllocatedAssets(strAssetDescription,strAssetType,strAssetOwner,amountAllocated,availableAmount,dblAssetGoalYearValue,strAssetAction,dblAssetInterestRate);
                      }
                   }  
                    }
                }
            }  
           //End of Asset ============================================================================================================
           //Insurance =========================================================================================================================
             strInsuranceDescription = '';
           strInsuranceType = '';
           String strPolicyType = '';
           String strInsuranceOwner = '';
           double dblInsuranceExpectedGrowthRate = 0;
           double dblInsuranceGoalYearValue = 0;
           string strInsuranceAction = '';
           if(goalInsuranceMappingMap.containsKey(goal.id))
           {
               lstGoalInsuranceAssociation = goalInsuranceMappingMap.get(goal.id);
               if(lstGoalInsuranceAssociation != null)
               {
                  for(GoalInsuranceAssociation__c objGoalInsuranceAssociation : lstGoalInsuranceAssociation)
                  {
                  if(objGoalInsuranceAssociation.Insurance__r.Action__c != '---None----')
                  {
                      strInsuranceType = objGoalInsuranceAssociation.Insurance__r.Policy_Type__c;
                    String InsuranceDescription = null;
                    Map<Id,Insurance__c> MapIdToInsurance = new Map<Id,Insurance__c>();
                   for(Insurance__c insurance : insuranceList) 
                   {
                      
                      if(!MapIdToInsurance.ContainsKey(insurance.Id))
                      {
                        MapIdToInsurance.put(insurance.Id,insurance);
                      }
                   }
                   if(MapIdToInsurance.ContainsKey(objGoalInsuranceAssociation.Insurance__r.Id))
                   {  
                    if(objGoalInsuranceAssociation.Insurance__r.Insurance_Company__c != null)
                {
                  if(objGoalInsuranceAssociation.Insurance__r.Policy_Name__c != null)
                  {
                    strInsuranceDescription = objGoalInsuranceAssociation.Insurance__r.Policy_Number__c != null ? 
                                (objGoalInsuranceAssociation.Insurance__r.Insurance_Company__c + ' -- ' + objGoalInsuranceAssociation.Insurance__r.Policy_Name__c + ' -- ' + objGoalInsuranceAssociation.Insurance__r.Policy_Number__c)
                                :(objGoalInsuranceAssociation.Insurance__r.Insurance_Company__c + ' -- ' + objGoalInsuranceAssociation.Insurance__r.Policy_Name__c);
                  }
                  else
                  {
                    strInsuranceDescription = objGoalInsuranceAssociation.Insurance__r.Policy_Number__c != null ? 
                                (objGoalInsuranceAssociation.Insurance__r.Insurance_Company__c + ' -- ' + objGoalInsuranceAssociation.Insurance__r.Policy_Number__c) 
                                : (objGoalInsuranceAssociation.Insurance__r.Insurance_Company__c);
                  }              
                }
                else
                {
                  if(objGoalInsuranceAssociation.Insurance__r.Policy_Name__c != null)
                  {
                    strInsuranceDescription = objGoalInsuranceAssociation.Insurance__r.Policy_Number__c != null ? 
                                (objGoalInsuranceAssociation.Insurance__r.Policy_Name__c + ' -- ' + objGoalInsuranceAssociation.Insurance__r.Policy_Number__c) 
                                : objGoalInsuranceAssociation.Insurance__r.Policy_Name__c;
                  }
                  else if(objGoalInsuranceAssociation.Insurance__r.Policy_Number__c != null)
                  {
                    strInsuranceDescription = objGoalInsuranceAssociation.Insurance__r.Policy_Number__c;
                  }                      
                }
                    }
                    if(objGoalInsuranceAssociation.Insurance__r.entity__r.LastName == null)
                    {
                      strInsuranceOwner = objGoalInsuranceAssociation.Insurance__r.entity__r.FirstName;
                    }
                    else if(objGoalInsuranceAssociation.Insurance__r.entity__r.FirstName == null )
                    {
                      strInsuranceOwner = objGoalInsuranceAssociation.Insurance__r.entity__r.LastName;
                    }
                    else if(objGoalInsuranceAssociation.Insurance__r.entity__r.LastName != null && objGoalInsuranceAssociation.Insurance__r.entity__r.FirstName != null)
                    {
                      strInsuranceOwner = objGoalInsuranceAssociation.Insurance__r.entity__r.FirstName +' '+ objGoalInsuranceAssociation.Insurance__r.entity__r.LastName;
                    }
                    else
                    {
                      strInsuranceOwner = '';
                    }
                  
                    double allocatedAmount = 0;
                    availableAmount = 0; 
                    allocatedAmount = objGoalInsuranceAssociation.Allocated__c;
                    strInsuranceAction = objGoalInsuranceAssociation.Insurance__r.action__c;
                    dblInsuranceGoalYearValue = objGoalInsuranceAssociation.GoalYearValue__c;
                    
                    Double CurrentVal;
                    double amountAllocated = 0;
                    balanceRemaining = 0;
                    Integer iTenureOfInsurance = 0;
                    if(goalInsuranceMap.containsKey(objGoalInsuranceAssociation.Insurance__c))
                          {
                            AssetAllocationService objAssetAllocationService = new AssetAllocationService();
                        Insurance__c objInsurance =goalInsuranceMap.get(objGoalInsuranceAssociation.Insurance__c);
                        Double dblOneInstallmentPremiumAmount = 0;
                        
                    // if(!objInsurance.Premium_Frequency__c.equals('One Time Premium'))
                   //{
                   if(objInsurance.Premium_Amount_Rs__c != null)
                       dblOneInstallmentPremiumAmount = objInsurance.Premium_Amount_Rs__c;
                   //}
                   if(objInsurance.Tenure_of_Insurance__c != null)
                   {
                     iTenureOfInsurance = Integer.valueOf(objInsurance.Tenure_of_Insurance__c);
                   }
                   
                   Integer iMaturityYear = iTenureOfInsurance + objInsurance.Commencement_Date__c.year();
                   Integer iCurrentYearForCalculation = 0;
                   /* Aditi - FP changes - 04-03-2013 - Changed Date.Today() to Plan_Generation_Date__c*/
                   Integer currentYear = objAccount.Plan_Generation_Date__c != null ? objAccount.Plan_Generation_Date__c.year() : Date.today().year();
                   if(currentYear > iMaturityYear)
                   {
                     iCurrentYearForCalculation = iMaturityYear;
                   }
                   else
                   {
                     iCurrentYearForCalculation = currentYear;
                   }
                   Integer totalPeriodInYears =  iCurrentYearForCalculation - objInsurance.Commencement_Date__c.year();//
                   if(objInsurance.Surrender_Cash_Value__c == null)
                   {
                     system.debug('****objInsurance*********'+objInsurance);
                     system.debug('****totalPeriodInYears*********'+totalPeriodInYears);
                     system.debug('****dblOneInstallmentPremiumAmount*********'+dblOneInstallmentPremiumAmount);
                     
                     CurrentVal = objAssetAllocationService.GetInsuranceAmountForPeriod(objInsurance,totalPeriodInYears, dblOneInstallmentPremiumAmount);
                   }else
                   {
                     CurrentVal = objInsurance.Surrender_Cash_Value__c;
                   }
                   
                   Double dblAllocated = allocatedAmount;
                   amountAllocated = (dblAllocated * CurrentVal)/100 ; 
                   system.debug('****amountAllocated*********'+amountAllocated);
                   if(CurrentVal != null)
                        {
                          balanceRemaining = CurrentVal - amountAllocated;
                        }else
                        {
                          balanceRemaining = 0;
                        }
                        
                        strPolicyType = objInsurance.Policy_Type__c;
                  dblInsuranceExpectedGrowthRate  = LifeInsuranceInterest__c.getInstance(strPolicyType).Rate__c;  
                          }
                          else
                            CurrentVal = 0; 
                         
                    AssetsTotal = AssetsTotal + amountAllocated;
                    objActionPlanAllocatedAssets = objActionPlanGoalDetails.populateAllocatedAssets(strInsuranceDescription,strInsuranceType,strInsuranceOwner,amountAllocated,availableAmount,dblInsuranceGoalYearValue,strInsuranceAction,dblInsuranceExpectedGrowthRate);
                    
                   }
                
                 }
              
                }
          
             }
         //End of Insurance ===============================================================================================================          
        
         //InvestmentAsset===============================================================================================================          
            strInvestmentType = '';
            strInvestmentDescription = '';
            String strInvestmentOwner = '';
            String strInvestmentAction = '';
            double dblInvestmentExpectedGrowthRate = 0;
            double dblInvestmentGoalYearValue = 0;
               double dblAllocatedAmt = 0;    
               double dblAmountAllocated = 0;
               String strInvestmentRecordType = '';
               double dblInvestmentCurrentValue = 0;
               boolean isNotIncome = false;
            if(goalInvestmentAssetMappingMap.containsKey(goal.id))
            {
              
               lstGoalInvestmentAssetAssociation = goalInvestmentAssetMappingMap.get(goal.id);
               if(lstGoalInvestmentAssetAssociation != null)
               {
                 for(GoalInvestmentAssetAssociation__c objGoalInvestmentAssetAssociation : lstGoalInvestmentAssetAssociation)
                     {
                       if(objGoalInvestmentAssetAssociation.Investment_asset__r.RecordType.Name == 'Fixed Income')
                       {
                     if(objGoalInvestmentAssetAssociation.Investment_asset__r.Action__c != '---None----')
                      { 
                        strInvestmentType = objGoalInvestmentAssetAssociation.Investment_asset__r.RecordType.Name;
                        if(objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.LastName == null)
                          {
                            strInvestmentOwner = objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.FirstName;
                          }
                          else if(objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.FirstName == null )
                          {
                            strInvestmentOwner = objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.LastName;
                          }
                          else if(objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.LastName != null && objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.FirstName != null)
                          {
                            strInvestmentOwner = objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.FirstName +' '+ objGoalInvestmentAssetAssociation.Investment_asset__r.entity__r.LastName;
                          }
                          else
                          {
                            strInvestmentOwner = '';
                          }
                        
                        dblAllocatedAmt = objGoalInvestmentAssetAssociation.Allocated__c;
                        dblInvestmentCurrentValue = objGoalInvestmentAssetAssociation.Investment_asset__r.TotalAsset__c ;
                        dblAmountAllocated = (dblInvestmentCurrentValue *  dblAllocatedAmt)/100;
                        
                        //Prajakta - FP changes - 25-02-2013
                            Datetime dtReport = objGoalInvestmentAssetAssociation.Investment_asset__r.Maturity_Date__c;
                        String strDate = dtReport.day() + '-' + dtReport.month() + '-' + dtReport.year();
                            strInvestmentDescription = objGoalInvestmentAssetAssociation.Investment_asset__r.Description__c + ' -- ' + strDate; 
                        //strInvestmentDescription = '-';
                        
                        dblInvestmentGoalYearValue = objGoalInvestmentAssetAssociation.GoalYearValue__c;
                        strInvestmentAction = objGoalInvestmentAssetAssociation.Investment_asset__r.action__c;
                        strInvestmentRecordType =  objGoalInvestmentAssetAssociation.investment_Asset__r.recordType.Name;
                              if(strInvestmentRecordType.equals('Stocks'))
                              {   
                                     dblInvestmentExpectedGrowthRate =  globalAssumptions.Stock_Growth_Rate__c;
                              }
                              /* Prajakta - FP changes - 01-04-2013 */
                              else if(strInvestmentRecordType.equals('Gold'))    
                              {   
                                     dblInvestmentExpectedGrowthRate =  globalAssumptions.Gold_Growth_Rate__c;
                              }
                              else
                                    dblInvestmentExpectedGrowthRate = globalAssumptions.Income_Growth_Rate__c;
                      }
                      AssetsTotal = AssetsTotal + dblAmountAllocated;
                         objActionPlanAllocatedAssets = objActionPlanGoalDetails.populateAllocatedAssets(strInvestmentDescription,strInvestmentType,strInvestmentOwner,dblAmountAllocated,availableAmount,dblInvestmentGoalYearValue,strInvestmentAction,dblInvestmentExpectedGrowthRate);
             
                       }
                       else
                       {
                         if(objGoalInvestmentAssetAssociation.Investment_asset__r.Action__c != '---None----')
                      { 
                            if(mapNameToInvestmentAsset.containsKey(objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.FirstName+' '+objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.LastName+objGoalInvestmentAssetAssociation.Investment_asset__r.RecordType.Name))
                           {
                             List<GoalInvestmentAssetAssociation__c> lstRelatedInvAsset = new List<GoalInvestmentAssetAssociation__c>(); 
                             lstRelatedInvAsset = mapNameToInvestmentAsset.get(objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.FirstName+' '+objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.LastName+objGoalInvestmentAssetAssociation.Investment_asset__r.RecordType.Name);
                             lstRelatedInvAsset.add(objGoalInvestmentAssetAssociation);
                             mapNameToInvestmentAsset.put(objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.FirstName+' '+objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.LastName+objGoalInvestmentAssetAssociation.Investment_asset__r.RecordType.Name,lstRelatedInvAsset);
                           }
                           else
                           {
                             List<GoalInvestmentAssetAssociation__c> lstRelatedInvAsset = new List<GoalInvestmentAssetAssociation__c>();
                             lstRelatedInvAsset.add(objGoalInvestmentAssetAssociation);
                             mapNameToInvestmentAsset.put(objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.FirstName+' '+objGoalInvestmentAssetAssociation.Investment_asset__r.Entity__r.LastName+objGoalInvestmentAssetAssociation.Investment_asset__r.RecordType.Name,lstRelatedInvAsset);
                           }
                           
                      }
                       }
                       
                     }
               system.debug('***mapNameToInvestmentAsset****'+mapNameToInvestmentAsset.keySet());
                     List<GoalInvestmentAssetAssociation__c> lstGoalInvestmentAsset = new List<GoalInvestmentAssetAssociation__c>();
                     for(String strEntityName : mapNameToInvestmentAsset.keySet())
                  {
                     CurrentValue = 0;
                     CurrentTotalValue = 0;
                     dblAmountAllocated = 0;
                  lstGoalInvestmentAsset = mapNameToInvestmentAsset.get(strEntityName);
                  system.debug('***strEntityName****'+strEntityName);
                  system.debug('***lstGoalInvestmentAsset****'+lstGoalInvestmentAsset);
                  for(GoalInvestmentAssetAssociation__c objGoalInvest : lstGoalInvestmentAsset )
                  {
                    if(objGoalInvest.Goal__c == goal.id)
                    {
                      isNotIncome = true;
                      strInvestmentDescription = '-';      
                      if(objGoalInvest.Investment_asset__r.entity__r.LastName == null)
                          {
                            strInvestmentOwner = objGoalInvest.Investment_asset__r.entity__r.FirstName;
                          }
                          else if(objGoalInvest.Investment_asset__r.entity__r.FirstName == null )
                          {
                            strInvestmentOwner = objGoalInvest.Investment_asset__r.entity__r.LastName;
                          }
                          else if(objGoalInvest.Investment_asset__r.entity__r.LastName != null && objGoalInvest.Investment_asset__r.entity__r.FirstName != null)
                          {
                            strInvestmentOwner = objGoalInvest.Investment_asset__r.entity__r.FirstName +' '+ objGoalInvest.Investment_asset__r.entity__r.LastName;
                          }
                          else
                          {
                            strInvestmentOwner = '';
                          }
                        dblAllocatedAmt = objGoalInvest.Allocated__c;
                            strInvestmentDescription = '-';        
                          strInvestmentType = objGoalInvest.Investment_asset__r.RecordType.Name;      
                          strInvestmentAction = objGoalInvest.Investment_asset__r.action__c;
                        strInvestmentRecordType =  objGoalInvest.investment_Asset__r.recordType.Name;
                        dblInvestmentCurrentValue = objGoalInvest.Investment_asset__r.TotalAsset__c ;
                        dblAmountAllocated = dblAmountAllocated + (dblInvestmentCurrentValue *  dblAllocatedAmt)/100;
                              if(strInvestmentRecordType.equals('Stocks'))
                              {   
                                     dblInvestmentExpectedGrowthRate =  globalAssumptions.Stock_Growth_Rate__c;
                              }
                              /* Prajakta - FP changes - 01-04-2013 */
                              else if(strInvestmentRecordType.equals('Gold'))    
                              {   
                                     dblInvestmentExpectedGrowthRate =  globalAssumptions.Gold_Growth_Rate__c;
                              }
                              else
                                    dblInvestmentExpectedGrowthRate = globalAssumptions.Income_Growth_Rate__c;   
                        
                        dblInvestmentGoalYearValue = objGoalInvest.GoalYearValue__c;
                    }
                    }
                    if(isNotIncome)
                    {
                      system.debug('****in isNotIncome****');
                      AssetsTotal = AssetsTotal + dblAmountAllocated;
                         objActionPlanAllocatedAssets = objActionPlanGoalDetails.populateAllocatedAssets(strInvestmentDescription,strInvestmentType,strInvestmentOwner,dblAmountAllocated,availableAmount,dblInvestmentGoalYearValue,strInvestmentAction,dblInvestmentExpectedGrowthRate);
                    }
                  } 
                     
               }
          }
         //End of InvestmentAsset ===============================================================================================================          
             objActionPlanGoalDetails.AssetsTotal = AssetsTotal;
         }
    }
    
    
    /**
    * @Description: Get family details for parent entity
    * param: None 
    * return type: void
    */  
    public void getFamilyDetails(ApprovedPlanBean beanObj){
        beanObj.accList = dbSOQLObj.getFamilyDetails(beanObj.entityId);
    }
    
    /**
    * @Description: Get Asset Allocation Details
    * param: ApprovedPlanBean
    * return type: void
    */ 
  /* 	public void getAssetAllocation(ApprovedPlanBean beanObj)
    {
        List<GoalInvestmentAssetAssociation__c> giaList = dbSOQLObj.getGoalInvestmentAssociationList(beanObj.entityId);
        List<GoalAssetAssociation__c> gaaList = dbSOQLObj.getGoalAssetAllocationList(beanObj.entityId);
        List<GoalInsuranceAssociation__c> ginaList = dbSOQLObj.getGoalInsuranceAllocationList(beanObj.entityId);
        
        Set<Id> recIds = new Set<Id>();
        Map<String,Double> Assetperc = new Map<String,Double>();
        
        for(GoalAssetAssociation__c gaObj: gaaList){
            if(Assetperc.get(gaObj.asset__c)!=null){
                Assetperc.put(gaObj.asset__c, Assetperc.get(gaObj.asset__c)+gaObj.allocated__c);
            }else{
                Assetperc.put(gaObj.asset__c, gaObj.allocated__c);
            }
        }
        
        for(GoalInvestmentAssetAssociation__c giObj: giaList){
            if(Assetperc.get(giObj.Investment_asset__c)!=null){
                Assetperc.put(giObj.Investment_asset__c, Assetperc.get(giObj.Investment_asset__c)+giObj.allocated__c);
            }else{
                Assetperc.put(giObj.Investment_asset__c, giObj.allocated__c);
            }
        }
        
        for(GoalInsuranceAssociation__c ginObj: ginaList){
            if(Assetperc.get(ginObj.Insurance__c)!=null){
                Assetperc.put(ginObj.Insurance__c, Assetperc.get(ginObj.Insurance__c)+ginObj.allocated__c);
            }else{
                Assetperc.put(ginObj.Insurance__c, ginObj.allocated__c);
            }
        }
        
       /* List<RecordType> recList = dbSOQLObj.getRecordTypeNames(recIds);
        Map<Id,String> recMap = new Map<Id,String>();
        for(RecordType recObj: recList){
            recMap.put(recObj.Id, recObj.Name);
        }*/
  /*      Set<String> processedId = new Set<String>();
        if(gaaList.size()>0){
            Map<String, double> golVal1 = new Map<String, double>();
           for(GoalAssetAssociation__c gaaObj: gaaList){
               golVal1.put(''+gaaObj.asset__c+gaaObj.goal__c, gaaObj.Allocated__c); 
           }
            for(GoalAssetAssociation__c gaaObj: gaaList){
                if(gaaObj.asset__r.Action__c != '---None----'){
                    if(!processedId.contains(gaaObj.asset__c)){
                        processedId.add(gaaObj.asset__c);
                        ApprovedPlanBean.SAssetAllocationBean tmpObj = new ApprovedPlanBean.SAssetAllocationBean();
                        tmpObj.entityName = gaaObj.asset__r.entity__r.FirstName +' '+gaaObj.asset__r.entity__r.LastName;
                        tmpObj.action = gaaObj.asset__r.action__c;
                        if(gaaObj.Asset__r.Asset_Types__c!=null && gaaObj.Asset__r.Asset_Types__c!=''){
                            tmpObj.Assets = gaaObj.Asset__r.Asset_Types__c;
                        }else{
                            tmpObj.Assets = gaaObj.Asset__r.Account_Type__c;
                        }
                        if(Assetperc.get(gaaObj.asset__c)!=null){
                            tmpObj.available = 100 - Assetperc.get(gaaObj.asset__c);
                            tmpObj.allocated = Assetperc.get(gaaObj.asset__c);
                        }else{
                            tmpObj.available = 100;
                            tmpObj.allocated = 0;
                        }
                        /** Eternus Solutions       **/
            /** Author  : Manasi Ranade **/
            /** Issue Id: FS0267        **/
            /** Date    : 11/11/2011   **/
            /** Purpose : Commented original code. Displayed the Actual Current value 
            /****************************************************/
   /*                     tmpObj.currentVal = gaaObj.asset__r.Monthly_Asset__c; //- gaaObj.asset__r.Allocated_Amount__c;
                        for(Goal__c golObj:beanObj.goalList){
                            if(golVal1.get(''+gaaObj.asset__c+golObj.Id)!=null){
                                tmpObj.golListVals.add(golVal1.get(''+gaaObj.asset__c+golObj.Id));
                            }else{
                                tmpObj.golListVals.add(0);
                            }
                        }
                        beanObj.aaBeanList.add(tmpObj);
                    }
                }
            }
        }
        
       if(ginaList.size()>0){
         //Action Plan : Manasi
    /** Eternus Solutions       **/
    /** Author  : Manasi Ranade **/
    /** Issue Id: FS0229        **/
    /** Date    : 25/10/2011   **/
    /** Purpose : Map required in calculation of current value of insurance
    /****************************************************/         
/*         Map<Id,Insurance__c> insuranceMap = new Map<Id,Insurance__c>();
        insuranceMap = dbSOQLObj.getInsuranceDetails(beanObj.entityId);
           Map<String, double> golVal = new Map<String, double>();
           for(GoalInsuranceAssociation__c ginaObj: ginaList){
               golVal.put(''+ginaObj.Insurance__c+ginaObj.goal__c, ginaObj.Allocated__c); 
           }
               
            for(GoalInsuranceAssociation__c ginaObj: ginaList){
                if(ginaObj.Insurance__r.Action__c != '---None----'){
                    if(!processedId.contains(ginaObj.Insurance__c)){
                        processedId.add(ginaObj.Insurance__c);
                        ApprovedPlanBean.SAssetAllocationBean tmpObj = new ApprovedPlanBean.SAssetAllocationBean();
                        tmpObj.entityName = ginaObj.Insurance__r.entity__r.FirstName +' '+ginaObj.Insurance__r.entity__r.LastName;
                        tmpObj.action = ginaObj.Insurance__r.action__c;
                        tmpObj.Assets =ginaObj.Insurance__r.RecordType.Name;
                        
                        if(Assetperc.get(ginaObj.Insurance__c)!=null){
                            tmpObj.available = 100 - Assetperc.get(ginaObj.Insurance__c);
                            tmpObj.allocated = Assetperc.get(ginaObj.Insurance__c);
                        }else{
                            tmpObj.available = 100;
                            tmpObj.allocated = 0;
                        }
                        
                        //tmpObj.currentVal = ginaObj.Insurance__r.total_insurance__c - ginaObj.Insurance__r.Allocated_Amount__c;
                        //Previuos Code:
                        //tmpObj.currentVal = ginaObj.Insurance__r.Premium_Amount_Rs__c;
                        //Action Plan : Manasi
                        //FS0229
                        /** Eternus Solutions       **/
            /** Author  : Manasi Ranade **/
            /** Issue Id: FS0229        **/
            /** Date    : 25/10/2011   **/
            /** Purpose : Code to calculate current value of insurance
            /****************************************************/
 /*                        if(insuranceMap.containsKey(ginaObj.Insurance__c))
                       {
                          Integer iTenureOfInsurance = 0;
                          Integer iMaturityYear = 0;
                          Integer totalPeriodInYears = 0;
                          AssetAllocationService objAssetAllocationService = new AssetAllocationService();
                      Insurance__c objInsurance =insuranceMap.get(ginaObj.Insurance__c);
                      Double dblOneInstallmentPremiumAmount = 0;
                      //if(!objInsurance.Premium_Frequency__c.equals('One Time Premium'))
                       if(objInsurance.Premium_Amount_Rs__c != null)
                     dblOneInstallmentPremiumAmount = objInsurance.Premium_Amount_Rs__c;
               
               if(objInsurance.Tenure_of_Insurance__c != null)
               {
                 iTenureOfInsurance = Integer.valueOf(objInsurance.Tenure_of_Insurance__c);
                 iMaturityYear = iTenureOfInsurance + objInsurance.Commencement_Date__c.year();
               }
               Integer iCurrentYearForCalculation = 0;
               /* Aditi - FP changes - 04-03-2013 - Changed Date.Today() to Plan_Generation_Date__c*/
 /*              Integer startYear = objAccount.Plan_Generation_Date__c != null ? objAccount.Plan_Generation_Date__c.year() : Date.today().year();
               if(startYear > iMaturityYear)
                 iCurrentYearForCalculation = iMaturityYear;
               else
                 iCurrentYearForCalculation = startYear;
               if(objInsurance.Commencement_Date__c.year() > 0)  
                 totalPeriodInYears =  iCurrentYearForCalculation - objInsurance.Commencement_Date__c.year();//
               if(objInsurance.Surrender_Cash_Value__c == null)
                 tmpObj.currentVal = objAssetAllocationService.GetInsuranceAmountForPeriod(objInsurance,totalPeriodInYears, dblOneInstallmentPremiumAmount);
               else
                 tmpObj.currentVal = objInsurance.Surrender_Cash_Value__c;
               Double dblAllocated = tmpObj.allocated;
                          //Original Code
               //tmpObj.currentVal = tmpObj.currentVal * ((100- Decimal.valueof(dblAllocated)) / 100 );
                        }
                        else
                          tmpObj.currentVal = 0; 
                        
                        for(Goal__c golObj:beanObj.goalList){
                            if(golVal.get(''+ginaObj.Insurance__c+golObj.Id)!=null){
                                tmpObj.golListVals.add(golVal.get(''+ginaObj.Insurance__c+golObj.Id));
                            }else{
                                tmpObj.golListVals.add(0);
                            }
                        }
                        beanObj.aaBeanList.add(tmpObj);
                    }
                }
            }
        }
        
        if(giaList.size()>0){
           Map<String, double> golVal2 = new Map<String, double>();
           for(GoalInvestmentAssetAssociation__c giaObj: giaList){
               golVal2.put(''+giaObj.Investment_asset__c+giaObj.goal__c, giaObj.Allocated__c); 
           }
           
           Map<String, double> totCurrent = new Map<String, double>();
           for(GoalInvestmentAssetAssociation__c giaObj: giaList){
               if(totCurrent.get(''+giaObj.Investment_asset__r.RecordType.Name+giaObj.Investment_asset__r.Entity__c)!=null){
                   /** Eternus Solutions       **/
           /** Author  : Manasi Ranade **/
           /** Issue Id: FS0267        **/
           /** Date    : 11/11/2011   **/
           /** Purpose : Commented original code. Displayed the Actual Current value 
           /****************************************************/
                 //Original Code
                   //double tmpVal1 = giaObj.Investment_asset__r.TotalAsset__c - giaObj.Investment_asset__r.Allocated_Amount__c;
/*                   double tmpVal1 = giaObj.Investment_asset__r.TotalAsset__c;// - giaObj.Investment_asset__r.Allocated_Amount__c;
                   tmpVal1 = tmpVal1 + totCurrent.get(''+giaObj.Investment_asset__r.RecordType.Name+giaObj.Investment_asset__r.Entity__c);
                   totCurrent.put(''+giaObj.Investment_asset__r.RecordType.Name+giaObj.Investment_asset__r.Entity__c, tmpVal1);
               }else{
                   /** Eternus Solutions       **/
           /** Author  : Manasi Ranade **/
           /** Issue Id: FS0267        **/
           /** Date    : 11/11/2011   **/
           /** Purpose : Commented original code. Displayed the Actual Current value 
           /****************************************************/
                 //Original Code
                   //double tmpVal = giaObj.Investment_asset__r.TotalAsset__c - giaObj.Investment_asset__r.Allocated_Amount__c;
/*                   double tmpVal = giaObj.Investment_asset__r.TotalAsset__c;// - giaObj.Investment_asset__r.Allocated_Amount__c;
                   totCurrent.put(''+giaObj.Investment_asset__r.RecordType.Name+giaObj.Investment_asset__r.Entity__c, tmpVal);
               } 
           }
            
            for(GoalInvestmentAssetAssociation__c giaObj: giaList){
                if(giaObj.Investment_asset__r.Action__c != '---None----'){
                    if(!processedId.contains(''+giaObj.Investment_asset__r.RecordType.Name+giaObj.Investment_asset__r.Entity__c)){
                        processedId.add(''+giaObj.Investment_asset__r.RecordType.Name+giaObj.Investment_asset__r.Entity__c);
                        ApprovedPlanBean.SAssetAllocationBean tmpObj = new ApprovedPlanBean.SAssetAllocationBean();
                        tmpObj.entityName = giaObj.Investment_asset__r.entity__r.FirstName +' '+giaObj.Investment_asset__r.entity__r.LastName;
                        tmpObj.action = giaObj.Investment_asset__r.action__c;
                        
                        if(Assetperc.get(giaObj.Investment_asset__c)!=null){
                            tmpObj.available = 100 - Assetperc.get(giaObj.Investment_asset__c);
                            tmpObj.allocated = Assetperc.get(giaObj.Investment_asset__c);
                        }else{
                            tmpObj.available = 100;
                            tmpObj.allocated = 0;
                        }
                        tmpObj.Assets = giaObj.Investment_asset__r.RecordType.Name;
                        if(totCurrent.get(''+giaObj.Investment_asset__r.RecordType.Name +giaObj.Investment_asset__r.Entity__c)!=null){
                            tmpObj.currentVal = totCurrent.get(''+giaObj.Investment_asset__r.RecordType.Name+giaObj.Investment_asset__r.Entity__c);
                            
                        }else{
                            tmpObj.currentVal = 0;
                        }
                        
                        for(Goal__c golObj:beanObj.goalList){
                            if(golVal2.get(''+giaObj.Investment_asset__c+golObj.Id)!=null){
                                tmpObj.golListVals.add(golVal2.get(''+giaObj.Investment_asset__c+golObj.Id));
                            }else{
                                tmpObj.golListVals.add(0);
                            }
                        }
                        beanObj.aaBeanList.add(tmpObj);
                    }
                }
            }
        }
    }
    */
    /**
    * @Description: Get General Insurance records which are created during the Insurence planning
    * param: List<Account>
    * return type: List<Insurance__c>
    */ 
    public List<Insurance__c> getGenerelInsurance(List<Account> accList){
        return dbSOQLObj.getAnalysisInsurances(InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c, accList);
    }
    
     /**
    * @Description: Get Life Insurance records which are created during the Insurence planning
    * param: List<Account>
    * return type: List<Insurance__c>
    */ 
    public List<Insurance__c> getLifeInsurance(List<Account> accList){
        return dbSOQLObj.getAnalysisInsurances(InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c, accList);
    }
    
     /**
    * @Description: Get Approved Life insurance records which are created on Approved plan page
    * param: ApprovedPlanBean 
    * return type: void
    */ 
    public void getApprGenerelInsurance(ApprovedPlanBean beanObj){
        beanObj.giApprovedList = dbSOQLObj.getApprovedInsurances(InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c, beanObj.accList);
        if(beanObj.giApprovedList.size()<=0){
            for(Insurance__c insObj: beanObj.giList){
                Insurance__c insTmp = new Insurance__c();
                insTmp.Flag__c = 'Approved';
                insTmp.Suggested_Cover_General_Insurance__c = insObj.Suggested_Cover_General_Insurance__c;
                insTmp.Premium_Amount_Rs__c =insObj.Premium_Amount_Rs__c;
                insTmp.Policy_Type__c = insObj.Policy_Type__c;
                insTmp.Entity__c = insObj.Entity__c;
                insTmp.Entity_Name__c = insObj.Entity__r.FirstName + ' ' + insObj.Entity__r.LastName;
                insTmp.Insurance_Company__c = insObj.Insurance_Company__c;
                insTmp.RecordTypeId = InsuranceRecTypes__c.getInstance('General Insurance').RecordTypeId__c;
                beanObj.giApprovedList.add(insTmp);
                beanObj.isApprovedGeneralInsExist = true;
            }
        }else{
            beanObj.isApprovedGeneralInsExist = true;
        }
    }
    
    /**
    * @Description: Get Approved Life insurance records which are created on Approved plan page
    * param: ApprovedPlanBean 
    * return type: void
    */ 
    public void getApprLifeInsurance(ApprovedPlanBean beanObj){
        beanObj.liApprovedList = dbSOQLObj.getApprovedInsurances(InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c, beanObj.accList);
        system.debug('size***'+beanObj.liApprovedList.size());
        if(beanObj.liApprovedList.size()<=0){
            system.debug('size1***');
            for(Insurance__c insObj: beanObj.liList){
                Insurance__c insTmp = new Insurance__c();
                insTmp.Flag__c = 'Approved';
                insTmp.Suggested_Cover_General_Insurance__c = insObj.Suggested_Cover_General_Insurance__c;
                insTmp.Premium_Amount_Rs__c =insObj.Premium_Amount_Rs__c;
                insTmp.Policy_Type__c = insObj.Policy_Type__c;
                insTmp.Entity__c = insObj.Entity__c;
                insTmp.Entity_Name__c = insObj.Entity__r.FirstName + ' ' + insObj.Entity__r.LastName;
                insTmp.Insurance_Company__c = insObj.Insurance_Company__c;
                insTmp.RecordTypeId = InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c;
                beanObj.liApprovedList.add(insTmp);
                beanObj.isApprovedLifeInsExist = true;
                //system.debug('size2***');
            }
        }
        else
        {
            beanObj.isApprovedLifeInsExist = true;
        }
    }
    
    
    /**
    * @Description: Get goals for the parent entity
    * param: void
    * return type: void
    */ 
    public void getGoals(ApprovedPlanBean beanObj){
         beanObj.goalList = dbSOQLObj.getAllGoals(beanObj.entityId);
    }
    
     /**
    * @Description: Prepare current Lumpsum approved data
    * param: ApprovedPlanBean 
    * return type: void
    */ 
    public void getCurMFLumpSumApprovedPlans(ApprovedPlanBean beanObj){
         Map<Id, List<ApprovedPlanBean.Goals>> mapcurrMFLump = new Map<Id, List<ApprovedPlanBean.Goals>>();
         mapcurrMFLump = getGoalsAllocated(currentLump ,beanObj);         
         set<id> investId = new set<id>();
         for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList){
             if(apObj.RecordType.Name == currentLump ){
                if(mapcurrMFLump.get(apObj.Investment_Asset__c) != null){
                    investId.add(apObj.Investment_Asset__c);
                    ApprovedPlanBean.CurrentMFLumpSum tmpObj = new ApprovedPlanBean.CurrentMFLumpSum(); 
                    
                    tmpObj.entityId = apObj.Investment_Asset__r.Entity__c;
                    tmpObj.recordId = apObj;
                    tmpObj.assetId = apObj.Investment_Asset__c;
                    tmpObj.schemeName = apObj.Investment_Asset__r.Fund__r.Scheme_Name__c; //FS0235
                    tmpObj.schemeName = apObj.Investment_Asset__r.Scheme_Name_Text__c;//FS0235
                    tmpObj.assetsClass = apObj.Investment_Asset__r.Asset_Type__c;
                    tmpObj.assetAmount = apObj.Investment_Asset__r.TotalAsset__c;
                    tmpObj.entityName = apObj.Investment_Asset__r.Entity__r.FirstName +' '+apObj.Investment_Asset__r.Entity__r.LastName;
                    tmpObj.action = apObj.Lumpsum_Action__c;
                    tmpObj.actionAmount = apObj.Amount__c;
                    tmpObj.golCurrMFLumpSum = mapcurrMFLump.get(apObj.Investment_Asset__c);
                    mapcurrMFLump.remove(apObj.Investment_Asset__c);
                    beanObj.currentMFLumpSumList.add(tmpObj);
                }
             }
         }
         
         //if(beanObj.currentMFLumpSumList.size()<=0){
             for(Investment_Asset__c investObj: beanObj.investment){
                 if(!investId.contains(investObj.Id)){
                     ApprovedPlanBean.CurrentMFLumpSum tmpObj = new ApprovedPlanBean.CurrentMFLumpSum();
                     tmpObj.entityId = investObj.Entity__c;
                     tmpObj.assetId = investObj.Id;
                     //tmpObj.schemeName = investObj.Fund__r.Scheme_Name__c;//FS0235
                     tmpObj.schemeName = investObj.Scheme_Name_Text__c;//FS0235
                     tmpObj.assetsClass = investObj.Asset_Type__c;
                     tmpObj.assetAmount = investObj.TotalAsset__c;
                     tmpObj.entityName = investObj.Entity__r.FirstName +' '+investObj.Entity__r.LastName;
                     
                     for(Goal__c golObj:beanObj.goalList){
                         ApprovedPlanBean.Goals tmpInObj = new ApprovedPlanBean.Goals();
                         tmpInObj.goalId = golObj.Id;
                         tmpInObj.allocated = 0;
                         tmpObj.golCurrMFLumpSum.add(tmpInObj);
                     }
                     beanObj.currentMFLumpSumList.add(tmpObj);
                 }
             }
         //}
     }   
     
      /**
    * @Description: Prepare current SIP approved data
    * param: ApprovedPlanBean 
    * return type: void
    */ 
     public void getCurMFSIPApprovedPlans(ApprovedPlanBean beanObj)
     {
         Map<Id, List<ApprovedPlanBean.Goals>> mapcurrMFSIP = new Map<Id, List<ApprovedPlanBean.Goals>>();
         mapcurrMFSIP = getGoalsAllocated(currentSIP ,beanObj);         
         set<id> investId = new set<id>();       
         for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList)
         {
             if(apObj.RecordType.Name == currentSIP )
             {
                if(mapcurrMFSIP.get(apObj.Investment_Asset__c) != null)
                {
                    if(apObj.Investment_Asset__r.Monthly_SIP_Amount__c!= null && apObj.Investment_Asset__r.Monthly_SIP_Amount__c!=0)
                    {
                        ApprovedPlanBean.CurrentMFSIP tmpObj = new ApprovedPlanBean.CurrentMFSIP(); 
                        investId.add(apObj.Investment_Asset__c);
                        tmpObj.entityId = apObj.Investment_Asset__r.Entity__c;
                        tmpObj.recordId = apObj;
                        tmpObj.assetId = apObj.Investment_Asset__c;
                        //tmpObj.schemeName = apObj.Investment_Asset__r.Fund__r.Scheme_Name__c;//FS0235
                        tmpObj.schemeName = apObj.Investment_Asset__r.Scheme_Name_Text__c;//FS0235
                        tmpObj.assetsClass = apObj.Investment_Asset__r.Asset_Type__c;
                        tmpObj.currentSIP = apObj.Investment_Asset__r.Monthly_SIP_Amount__c;
                        tmpObj.entityName = apObj.Investment_Asset__r.Entity__r.FirstName +' '+apObj.Investment_Asset__r.Entity__r.LastName;
                        tmpObj.SIPAction = apObj.SIP_Action__c;
                        tmpObj.SIPChange = apObj.Amount__c;
                        //tmpObj.allocatedAmount = apObj.Allocated_Amount__c;
                        tmpObj.golCurrMFSIP = mapcurrMFSIP.get(apObj.Investment_Asset__c);
                        mapcurrMFSIP.remove(apObj.Investment_Asset__c);
                        beanObj.currentMFSIPList.add(tmpObj);
                    }
                }
             }
         }
         
         //if(beanObj.currentMFSIPList.size()<=0){
             for(Investment_Asset__c investObj: beanObj.investment){
                 if(!investId.contains(investObj.Id)){
                     if(investObj.Monthly_SIP_Amount__c!=null && investObj.Monthly_SIP_Amount__c != 0){
                         ApprovedPlanBean.CurrentMFSIP tmpObj = new ApprovedPlanBean.CurrentMFSIP();
                         tmpObj.entityId = investObj.Entity__c;
                         tmpObj.assetId = investObj.Id;
                         //tmpObj.schemeName = investObj.Fund__r.Scheme_Name__c;//FS0235
                         tmpObj.schemeName = investObj.Scheme_Name_Text__c;//FS0235
                         tmpObj.assetsClass = investObj.Asset_Type__c;
                         tmpObj.currentSIP = investObj.Monthly_SIP_Amount__c;
                         tmpObj.entityName = investObj.Entity__r.FirstName +' '+investObj.Entity__r.LastName;
                         
                         for(Goal__c golObj:beanObj.goalList){
                             ApprovedPlanBean.Goals tmpInObj = new ApprovedPlanBean.Goals();
                             tmpInObj.goalId = golObj.Id;
                             tmpInObj.allocated = 0;
                             tmpObj.golCurrMFSIP.add(tmpInObj);
                         }
                         beanObj.currentMFSIPList.add(tmpObj);
                     }
                 }
             }
         //}
     }
     
       /**
    * @Description: Prepare Suggested Lumpsum approved data
    * param: ApprovedPlanBean 
    * return type: void
    */ 
     public void getSuggMFLumpApprovedPlans(ApprovedPlanBean beanObj)
     {
         Map<String, List<ApprovedPlanBean.Goals>> mapSuggMFLump = new Map<String, List<ApprovedPlanBean.Goals>>();
         mapSuggMFLump = getSuggGoalsAllocated(suggestedLump,beanObj);
            
         for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList)
         {
           if(apObj.RecordType.Name == suggestedLump)
             {
                if(mapSuggMFLump.get(apObj.entity__c+apObj.Scheme_Name_Text__c) != null)
                {
                    ApprovedPlanBean.SuggestedMFLumpSum tmpObj = new ApprovedPlanBean.SuggestedMFLumpSum(); 
                    tmpObj.entityId = apObj.Entity__c;
                    tmpObj.recordId = apObj;
                    tmpObj.assetId = apObj.Investment_Asset__c;
                    //tmpObj.schemeName = apObj.Scheme_Name__c;//FS0235
                    tmpObj.schemeName = apObj.Scheme_Name_Text__c;//FS0235
                    tmpObj.assetsClass = apObj.Asset_Class__c;
                    tmpObj.entityName = apObj.Entity__r.FirstName +' '+apObj.Entity__r.LastName;
                    tmpObj.action = apObj.Suggested_LumpSum_Action__c;
                    tmpObj.amount = apObj.Amount__c;
                    tmpObj.notes = apObj.Notes__c;
                    //tmpObj.allocatedAmount = apObj.Allocated_Amount__c;
                    tmpObj.golsuggMFLump = mapSuggMFLump.get(apObj.entity__c+apObj.Scheme_Name_Text__c);
                    mapSuggMFLump.remove(apObj.entity__c+apObj.Scheme_Name_Text__c);
                    beanObj.suggestedMFLumpSumList.add(tmpObj);
                }
             }
         }
         
         if(beanObj.suggestedMFLumpSumList.size()<=0)
         {
             ApprovedPlanBean.SuggestedMFLumpSum tmpObj = AddNewSuggMFLump(beanObj);
             beanObj.SuggestedMFLumpSumList.add(tmpObj);
         }
     }
     
       /**
    * @Description: Prepare Suggested SIP approved data
    * param: ApprovedPlanBean 
    * return type: void
    */
    
   /** Eternus Solutions       **/
  /** Author  : Dipak Nikam **/
  /** Case Number 00001521        **/
  /** Date    : 24/02/2012   **/
  /** Purpose :Modified  the code Replace Scheme_Name__c to Scheme_Name_Text__c
  /****************************************************/
     public void getSuggMFSIPApprovedPlans(ApprovedPlanBean beanObj)
     {
         Map<String, List<ApprovedPlanBean.Goals>> mapSuggMFSIP = new Map<String, List<ApprovedPlanBean.Goals>>();
         mapSuggMFSIP = getSuggGoalsAllocated(suggestedSIP,beanObj);
         for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList)
      {
         if(apObj.RecordType.Name == suggestedSIP)
           {
              if(mapSuggMFSIP.get(apObj.entity__c+apObj.Scheme_Name_Text__c) != null)
              {
                  ApprovedPlanBean.SuggestedMFSIP tmpObj = new ApprovedPlanBean.SuggestedMFSIP(); 
                  tmpObj.entityId = apObj.Entity__c;
                  /** Eternus Solutions       **/
          /** Author  : Manasi Ranade **/
          /** Issue Id: FS0290        **/
          /** Date    : 7/12/2011   **/
          /** Purpose : Added property in SuggestedMFSIP class.It will be usefull in Action Plan PDF generation at the time of ET
          /****************************************************/
          tmpObj.entityName = apObj.Entity__r.FirstName +' ' +apObj.Entity__r.LastName;
                                      
                  tmpObj.recordId = apObj;
                  tmpObj.assetId = apObj.Investment_Asset__c;
                  //tmpObj.schemeName = apObj.Scheme_Name__c;//FS0235
                  tmpObj.schemeName = apObj.Scheme_Name_Text__c;//FS0235
                  tmpObj.assetsClass = apObj.Asset_Class__c;
                  tmpObj.SIPAmount= apObj.Amount__c;
                  //tmpObj.allocatedAmount = apObj.Allocated_Amount__c;
                  tmpObj.golSuggMFSIP = mapSuggMFSIP.get(apObj.entity__c+apObj.Scheme_Name_Text__c);
                  mapSuggMFSIP.remove(apObj.entity__c+apObj.Scheme_Name_Text__c);
                  beanObj.suggestedMFSIPList.add(tmpObj);
              }
           }
       }
         if(beanObj.suggestedMFSIPList.size()<=0){
             ApprovedPlanBean.SuggestedMFSIP tmpObj = AddNewSuggMFSIP(beanObj);
             beanObj.SuggestedMFSIPList.add(tmpObj);
         }
     }
     
      /**
    * @Description: Add new record for the suggested Lumpsum
    * param: ApprovedPlanBean
    * return type: ApprovedPlanBean.SuggestedMFLumpSum
    */ 
    public ApprovedPlanBean.SuggestedMFLumpSum AddNewSuggMFLump(ApprovedPlanBean beanObj){
        ApprovedPlanBean.SuggestedMFLumpSum tmpObj = new ApprovedPlanBean.SuggestedMFLumpSum();
        tmpObj.entityId = beanObj.entityId;
        for(Goal__c golObj:beanObj.goalList){
                     ApprovedPlanBean.Goals tmpInObj = new ApprovedPlanBean.Goals();
                     tmpInObj.goalId = golObj.Id;
                     tmpInObj.allocated = 0;
                     tmpInObj.allocatedAmount = 0;
                     tmpObj.golsuggMFLump.add(tmpInObj);
        }
        return tmpObj;
    } 
    
    /**
    * @Description: Add new record for the suggested SIP
    * param: ApprovedPlanBean
    * return type: ApprovedPlanBean.SuggestedMFSIP
    */ 
    public ApprovedPlanBean.SuggestedMFSIP AddNewSuggMFSIP(ApprovedPlanBean beanObj){
        ApprovedPlanBean.SuggestedMFSIP tmpObj = new ApprovedPlanBean.SuggestedMFSIP();
        tmpObj.entityId = beanObj.entityId; 
        for(Goal__c golObj:beanObj.goalList){
                     ApprovedPlanBean.Goals tmpInObj = new ApprovedPlanBean.Goals();
                     tmpInObj.goalId = golObj.Id;
                     tmpInObj.allocated = 0;
                     tmpInObj.allocatedAmount = 0;
                     tmpObj.golSuggMFSIP.add(tmpInObj);
        }
        return tmpObj;
    }                             
    
    
     /**
    * @Description: Add new record for the  SIP Funds
    * param: ApprovedPlanBean
    * return type: ApprovedPlanBean.SuggestedMFSIP
    */ 
    public ApprovedPlanBean.SIPFunds AddNewSIPFunds(ApprovedPlanBean beanObj){
       /* ApprovedPlanBean.SIPFunds objSIPFunds = new ApprovedPlanBean.SIPFunds();
       // objSIPFunds.entityId = beanObj.entityId; 
        objSIPFunds.productName = '';
        objSIPFunds.transactionType = '';
        objSIPFunds.amount = 0;
        objSIPFunds.installments = 0;
        objSIPFunds.category = '';
        objSIPFunds.option = '';
        objSIPFunds.remarks = '';
        //objSIPFunds.goalId = 
        insert objSIPFunds;*/
        Approve_Action_Plan__c obj = new Approve_Action_Plan__c();
         /*for(Goal__c goal: goalList) // we are using same list to populate mapping as well.
         { 
           
         }*/
         ApprovedPlanBean.SIPFunds objSIPFunds = new ApprovedPlanBean.SIPFunds();
         objSIPFunds.execTracker = false;
         return objSIPFunds;
    }          
     public ApprovedPlanBean.LumpsumFunds AddNewLumpsumFunds(ApprovedPlanBean beanObj){
         ApprovedPlanBean.LumpsumFunds objLumpsumFunds = new ApprovedPlanBean.LumpsumFunds();
         return objLumpsumFunds;
    }   
    
    
    
    
    
    
    
    
    /**
    * @Description: get allocated goals for the current approved data
    * param: Recordtype.Name, ApprovedPlanBean 
    * return type: Map<Id, List<ApprovedPlanBean.Goals>>
    */ 
    public Map<Id, List<ApprovedPlanBean.Goals>> getGoalsAllocated(String recType,ApprovedPlanBean beanObj)
    {
         Map<Id, List<ApprovedPlanBean.Goals>> mapAllocatedVal = new Map<Id, List<ApprovedPlanBean.Goals>>();
         Map<String, double> goalAllocatedMap = new Map<String, double>();
         Map<String, double> goalAmountMap = new Map<String, double>();
         set<string> proceesRec = new set<string>();
         for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList)
         {
             if(apObj.RecordType.Name == recType)
             {
                goalAllocatedMap.put(''+apObj.goal__c+apObj.Investment_Asset__c,apObj.Allocated__c);
                if(apObj.Allocated__c!=null && apObj.Allocated__c != 0 && apObj.Amount__c != null && apObj.Amount__c != 0)
                {
                    goalAmountMap.put (''+apObj.goal__c+apObj.Investment_Asset__c, (apObj.Amount__c * apObj.Allocated__c) / 100) ;
                }
                else
                {
                    goalAmountMap.put (''+apObj.goal__c+apObj.Investment_Asset__c, 0) ;
                }
             }
         }
         
         for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList){
             if(!proceesRec.contains(apObj.Investment_Asset__c)){
                 if(apObj.RecordType.Name == recType){
                     proceesRec.add(apObj.Investment_Asset__c);
                     for(Goal__c golObj:beanObj.goalList){
                       if(mapAllocatedVal.get(apObj.Investment_Asset__c)!=null){
                            List<ApprovedPlanBean.Goals> tmpList = mapAllocatedVal.get(apObj.Investment_Asset__c);
                            ApprovedPlanBean.Goals tmpGol = new ApprovedPlanBean.Goals();
                            tmpGol.goalId = golObj.Id;
                            if(goalAllocatedMap.get(''+golObj.Id+apObj.Investment_Asset__c)!=null){
                                tmpGol.allocated= goalAllocatedMap.get(''+golObj.Id+apObj.Investment_Asset__c);
                            }else{
                                tmpGol.allocated= 0;
                            }
                            
                            if(goalAmountMap.get(''+golObj.Id+apObj.Investment_Asset__c)!=null){
                                tmpGol.allocatedAmount = goalAmountMap.get(''+golObj.Id+apObj.Investment_Asset__c);
                            }else{
                                tmpGol.allocatedAmount = 0;
                            }
                            tmpList.add(tmpGol);
                            mapAllocatedVal.put(apObj.Investment_Asset__c, tmpList);
                       }else{
                            List<ApprovedPlanBean.Goals> tmpList1 = new List<ApprovedPlanBean.Goals>();
                            ApprovedPlanBean.Goals tmpGol1 = new ApprovedPlanBean.Goals();
                            tmpGol1.goalId = golObj.Id;
                            if(goalAllocatedMap.get(''+golObj.Id+apObj.Investment_Asset__c)!=null){
                                tmpGol1.allocated= goalAllocatedMap.get(''+golObj.Id+apObj.Investment_Asset__c);
                            }else{
                                tmpGol1.allocated= 0;
                            }
                            
                            if(goalAmountMap.get(''+golObj.Id+apObj.Investment_Asset__c)!=null){
                                tmpGol1.allocatedAmount = goalAmountMap.get(''+golObj.Id+apObj.Investment_Asset__c);
                            }else{
                                tmpGol1.allocatedAmount = 0;
                            }
                            tmpList1.add(tmpGol1);
                            mapAllocatedVal.put(apObj.Investment_Asset__c, tmpList1);
                           
                       }                      
                     }
                 }
             }
         }
         return mapAllocatedVal; 
     }
     
    /**
    * @Description: get allocated goals for the suggested approved data
    * param: Recordtype.Name, ApprovedPlanBean 
    * return type: Map<Id, List<ApprovedPlanBean.Goals>>
    */
    /** Eternus Solutions       **/
  /** Author  : Dipak Nikam **/
  /** Case Number 00001521        **/
  /** Date    : 24/02/2012   **/
  /** Purpose :Modified  the code :To Replace Scheme_Name__c to Scheme_Name_Text__c
  /****************************************************/
     public Map<String, List<ApprovedPlanBean.Goals>> getSuggGoalsAllocated(String recType,ApprovedPlanBean beanObj)
     {
         Map<String, List<ApprovedPlanBean.Goals>> mapAllocatedVal = new Map<String, List<ApprovedPlanBean.Goals>>();
         Map<String, double> goalAllocatedMap = new Map<String, double>();
         Map<String, double> goalAmountMap = new Map<String, double>();
         set<string> proceesRec = new set<string>();
         
         for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList)
         {
             if(apObj.RecordType.Name == recType)
             {
                goalAllocatedMap.put(''+apObj.goal__c+apObj.entity__c+apObj.Scheme_Name_Text__c,apObj.Allocated__c);
                if(apObj.Allocated__c!=null && apObj.Allocated__c != 0 && apObj.Amount__c != null && apObj.Amount__c != 0)
                {
                    goalAmountMap.put (''+apObj.Goal__c+apObj.entity__c+apObj.Scheme_Name_Text__c, (apObj.Amount__c * apObj.Allocated__c) / 100) ;
                }
                else
                {
                    goalAmountMap.put (''+apObj.Goal__c+apObj.entity__c+apObj.Scheme_Name_Text__c, 0) ;
                }
             }
         }
        
         for(Approved_Action_Plan__c apObj: beanObj.approvedPlanList)
         {
           if(!proceesRec.contains(apObj.entity__c+apObj.Scheme_Name_Text__c))
             {
                 if(apObj.RecordType.Name == recType)
                 {
                     proceesRec.add(apObj.entity__c+apObj.Scheme_Name_Text__c);
                     for(Goal__c golObj:beanObj.goalList)
                     {
                       if(mapAllocatedVal.get(apObj.entity__c+apObj.Scheme_Name_Text__c)!=null)
                       {
                            List<ApprovedPlanBean.Goals> tmpList = mapAllocatedVal.get(apObj.entity__c+apObj.Scheme_Name_Text__c);
                            ApprovedPlanBean.Goals tmpGol = new ApprovedPlanBean.Goals();
                            tmpGol.goalId = golObj.Id;
                            if(goalAllocatedMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c)!=null)
                            {
                                tmpGol.allocated= goalAllocatedMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c);
                            }
                            else
                            {
                                tmpGol.allocated= 0;
                            }
                            
                            if(goalAmountMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c)!=null)
                            {
                                tmpGol.allocatedAmount = goalAmountMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c);
                            }
                            else
                            {
                                tmpGol.allocatedAmount = 0;
                            }
                            tmpList.add(tmpGol);
                            mapAllocatedVal.put(apObj.entity__c+apObj.Scheme_Name_Text__c, tmpList);
                        }
                        else
                        {
                            List<ApprovedPlanBean.Goals> tmpList1 = new List<ApprovedPlanBean.Goals>();
                            ApprovedPlanBean.Goals tmpGol1 = new ApprovedPlanBean.Goals();
                            tmpGol1.goalId = golObj.Id;
                            if(goalAllocatedMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c)!=null)
                            {
                                tmpGol1.allocated= goalAllocatedMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c);
                            }else
                            {
                                tmpGol1.allocated= 0;
                            }
                            
                            if(goalAmountMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c)!=null)
                            {
                                tmpGol1.allocatedAmount = goalAmountMap.get(''+golObj.Id+apObj.entity__c+apObj.Scheme_Name_Text__c);
                            }else
                            {
                                tmpGol1.allocatedAmount = 0;
                            }
                            tmpList1.add(tmpGol1);
                            mapAllocatedVal.put(apObj.entity__c+apObj.Scheme_Name_Text__c, tmpList1); 
                        }                   
                     }
                 }
             }
         }
         return mapAllocatedVal; 
     }
    
    /**
    * @Description: Prepare summary table for original allocated assets 
    * param: ApprovedPlanBean 
    * return type: void
    */
    public void PrpeareSummary(ApprovedPlanBean beanObj){
        beanObj.doneLumpSum = new List<ApprovedPlanBean.DoneClass>();
        beanObj.doneSIP  = new List<ApprovedPlanBean.DoneClass>();
         Map<String, double> mapLumpDoneVals = new Map<String, double>();
         Map<String, double> mapSIPDoneVals = new Map<String, double>();
         //Following variables are only for internal calculations, please dont change the values. 
         //Its risk to save this in custom labels
         String debt = 'DEBT';
         String equity = 'EQUITY';
         String gold = 'GOLD';
         
         for(ApprovedPlanBean.CurrentMFLumpSum tmpObj: beanObj.currentMFLumpSumList){
             for(ApprovedPlanBean.Goals golObj: tmpObj.golCurrMFLumpSum){
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(debt)){
                     mapLumpDoneVals = calculateTotal(mapLumpDoneVals,debt,golObj.goalId,golObj.allocatedAmount);
                  }  
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(equity)){
                     mapLumpDoneVals = calculateTotal(mapLumpDoneVals,equity ,golObj.goalId,golObj.allocatedAmount);
                 }
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(gold)){
                     mapLumpDoneVals = calculateTotal(mapLumpDoneVals,gold ,golObj.goalId,golObj.allocatedAmount);
                 }
             }
         }
         for(ApprovedPlanBean.SuggestedMFLumpSum tmpObj: beanObj.suggestedMFLumpSumList){
             for(ApprovedPlanBean.Goals golObj: tmpObj.golsuggMFLump){
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(debt)){
                     mapLumpDoneVals = calculateTotal(mapLumpDoneVals,debt,golObj.goalId,golObj.allocatedAmount);
                  }  
                 
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(equity)){
                     mapLumpDoneVals = calculateTotal(mapLumpDoneVals,equity ,golObj.goalId,golObj.allocatedAmount);
                 }
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(gold)){
                     mapLumpDoneVals = calculateTotal(mapLumpDoneVals,gold,golObj.goalId,golObj.allocatedAmount);
                 }
             }
         }
         for(ApprovedPlanBean.CurrentMFSIP tmpObj: beanObj.currentMFSIPList){
             for(ApprovedPlanBean.Goals golObj: tmpObj.golCurrMFSIP){
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(debt)){
                     mapSIPDoneVals = calculateTotal(mapSIPDoneVals ,debt,golObj.goalId,golObj.allocatedAmount);
                  }  
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(equity)){
                     mapSIPDoneVals = calculateTotal(mapSIPDoneVals ,equity ,golObj.goalId,golObj.allocatedAmount);
                 }
                 if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(gold)){
                     mapSIPDoneVals = calculateTotal(mapSIPDoneVals ,gold ,golObj.goalId,golObj.allocatedAmount);
                 }
             }
         }
         
         if(beanObj.suggestedMFSIPList != null && beanObj.suggestedMFSIPList.size() > 0)
         {
           for(ApprovedPlanBean.SuggestedMFSIP tmpObj: beanObj.suggestedMFSIPList)
           {
               if(tmpObj.golSuggMFSIP != null &&  tmpObj.golSuggMFSIP.size() > 0)
                {
                 for(ApprovedPlanBean.Goals golObj: tmpObj.golSuggMFSIP){
                     if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(debt)){
                         mapSIPDoneVals = calculateTotal(mapSIPDoneVals ,debt,golObj.goalId,golObj.allocatedAmount);
                      }  
                     if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(equity)){
                         mapSIPDoneVals = calculateTotal(mapSIPDoneVals ,equity ,golObj.goalId,golObj.allocatedAmount);
                     }
                     if(tmpObj.assetsClass !=null && (tmpObj.assetsClass.toUpperCase()).contains(gold)){
                         mapSIPDoneVals = calculateTotal(mapSIPDoneVals ,gold ,golObj.goalId,golObj.allocatedAmount);
                     }
                 }
                }
           }
         }
                 
         List<double> debtLumpList = new List<double>();
         List<double> equityLumpList = new List<double>();
         List<double> goldLumpList = new List<double>();
         List<double> debtSIPList = new List<double>();
         List<double> equitySIPList = new List<double>();
         List<double> goldSIPList = new List<double>();
         for(Goal__c golObj:beanObj.goalList){
             if(mapLumpDoneVals.get(debt+golObj.Id)!=null){
                 debtLumpList.add(mapLumpDoneVals.get(debt+golObj.Id));
             }else{
                 debtLumpList.add(0);
             }
             if(mapLumpDoneVals.get(equity+golObj.Id)!=null){
                 equityLumpList.add(mapLumpDoneVals.get(equity+golObj.Id));
             }else{
                 equityLumpList.add(0);
             }
             if(mapLumpDoneVals.get(gold+golObj.Id)!=null){
                 goldLumpList.add(mapLumpDoneVals.get(gold+golObj.Id));
             }else{
                 goldLumpList.add(0);
             }
             
             if(mapSIPDoneVals.get(debt+golObj.Id)!=null){
                 debtSIPList.add(mapSIPDoneVals.get(debt+golObj.Id));
             }else{
                 debtSIPList.add(0);
             }
             if(mapSIPDoneVals.get(equity+golObj.Id)!=null){
                 equitySIPList.add(mapSIPDoneVals.get(equity+golObj.Id));
             }else{
                 equitySIPList.add(0);
             }
             if(mapSIPDoneVals.get(gold+golObj.Id)!=null){
                 goldSIPList.add(mapSIPDoneVals.get(gold+golObj.Id));
             }else{
                 goldSIPList.add(0);
             }
         }
         
        ApprovedPlanBean.DoneClass tmp1 = new ApprovedPlanBean.DoneClass('Debt',debtLumpList);
        ApprovedPlanBean.DoneClass tmp2 = new ApprovedPlanBean.DoneClass('Equity',equityLumpList);
        ApprovedPlanBean.DoneClass tmp3 = new ApprovedPlanBean.DoneClass('Gold',goldLumpList);
        ApprovedPlanBean.DoneClass tmp4 = new ApprovedPlanBean.DoneClass('Debt', debtSIPList);
        ApprovedPlanBean.DoneClass tmp5 = new ApprovedPlanBean.DoneClass('Equity', equitySIPList);
        ApprovedPlanBean.DoneClass tmp6 = new ApprovedPlanBean.DoneClass('Gold',goldSIPList);
        
        beanObj.doneLumpSum.add(tmp1);
        beanObj.doneLumpSum.add(tmp2);
        beanObj.doneLumpSum.add(tmp3);
        
        beanObj.doneSIP.add(tmp4);
        beanObj.doneSIP.add(tmp5);
        beanObj.doneSIP.add(tmp6);
    } 
    
    /**
    * @Description: calculate total amount as per asset type per each goal 
    * param: Map, String, Id , double
    * return type: Map<String, double>
    */
    public Map<String, double> calculateTotal(Map<String, double> tmpMap, String cType, Id goalId, double amt){
        if(amt==null){
            amt = 0;
        }
        if(tmpMap.get(cType+goalId)!=null){
             double val = tmpMap.get(cType+goalId);
             val = val + amt;
             tmpMap.put(cType+goalId, val);
         }else{
             double val = 0;
             val = val + amt;
             tmpMap.put(cType+goalId, val);
        }
        return tmpMap;
    }
    /*//FS0290
    private Boolean AmountValidation(double dblTotalAmount, Double dblAllocatedAmount)
    {
      Boolean blnIsValid = true;
      if(dblTotalAmount < dblAllocatedAmount)
      {
        blnIsValid = false
      }
      return blnIsValid;
    }*/
    
    
    
    /**
    * @Description: save SIP Funds data in approve plan object and insurance object 
    * param: ApprovedPlanBean 
    * return type: void
    */
    public Pagereference saveActionPlan(ApprovedPlanBean beanObj,Map<String, ApprovedPlanBean.SIPFunds> mapStringToSIPFunds, Map<String,String> mapTypeToProductNames)
    {
    	system.debug('***Hi***');
        List<Approve_Action_Plan__c> UpsertList = new List<Approve_Action_Plan__c>();
        List<Approve_Action_Plan__c> UpsertLumpsumList = new List<Approve_Action_Plan__c>();
        List<Approve_Action_Plan__c> UpsertEmergencySIPList = new List<Approve_Action_Plan__c>();
        List<Approve_Action_Plan__c> UpsertEmergencyLumpsumList = new List<Approve_Action_Plan__c>();
        EstatePlanningBean bean;
        EstatePlanningServices service;
        boolean isSIPAmountGreater = false;
        boolean isLumpsumAmountGreater = false;
        Boolean isMFAmountGreater = false;
	    //Added on 24/12/2012 : for Retrieving Family member
	    Set<Id> familyIdSet = new Set<Id>(); 
	    List<Account> lstAcc = dbSOQLObj.getFamilyMembers(beanObj.entityId);
	    system.debug('**lstAcc'+lstAcc);
	    for(Account objAcc : lstAcc)
	    {
	       familyIdSet.add(objAcc.Id);
	       system.debug('**familyIdSet'+familyIdSet);
	    }
       //==========Execution Tracker Will save============================================================================
        if(beanObj.entityId!=null)
        {
            bean = new EstatePlanningBean();
            service = new EstatePlanningServices();
            bean.entity = service.getEntityDetails(beanObj.entityId);
            if(bean.entity.Will__c==true)
            {
              List<Approve_Action_Plan__c> lstApproveActionPlan = [Select Account__c, isWillExecTracker__c From Approve_Action_Plan__c 
                                where  Account__c IN: familyIdSet and isWill__c = : true and AP_Status__c = 'Opened'];
		      if(lstApproveActionPlan != null)
		         delete lstApproveActionPlan;
              Approve_Action_Plan__c objActionWillExec = new Approve_Action_Plan__c();
              objActionWillExec.isWillExecTracker__c = true;
              objActionWillExec.Account__c = beanObj.entityId;
              objActionWillExec.isWill__c = true;
              //Added on : 07/02/13 : Aditi Satpute : Generate New AP
              objActionWillExec.AP_Status__c = Label.Opened;
              if(beanObj.isWillExecutionTracker == 'Yes')
             objActionWillExec.isWillExecTracker__c = true;
             else
               objActionWillExec.isWillExecTracker__c = false;
           	 insert objActionWillExec;
            }  
        }     
        double SIPSummaryTotal = 0;
       //=================================================================================================================
       Set<Id> ApprovePlanAccountId = new Set<Id>(); 
       system.debug('**beanObj.lstGoalDetails*'+beanObj.lstGoalDetails); 
       for(ApprovedPlanBean.GoalDetails objGoals : beanObj.lstGoalDetails)
       {
           system.debug('**objGoals*'+objGoals); 
           double lumpsumTotal  = 0;
           double SIPTotal  = 0;
           system.debug('**objGoals.lstSIPFunds*'+objGoals.lstSIPFunds);
           for(ApprovedPlanBean.SIPFunds objSIPs: objGoals.lstSIPFunds)
           {    
                String strKey = objSIPs.productName + '-' + objSIPs.transactionType + '-' + objSIPs.installments + '-' + objSIPs.option;
             ApprovedPlanBean.SIPFunds objSF;
             Approve_Action_Plan__c tmpInsObj = new Approve_Action_Plan__c();
             // Date : 12/12/12 : Commented due to Removal of Execution Tacker from SIP Summary Table & Added to individual SIP Funds
             /*if(mapStringToSIPFunds.containsKey(strKey))
             {
               objSF = mapStringToSIPFunds.get(strKey);
               if(objSF.executionTracker == 'Yes')
               {
               tmpInsObj.isSIPexecutionTracker__c = true;
               objSIPs.execTracker = true;
               }
             else
             {
               tmpInsObj.isSIPexecutionTracker__c = false;
               objSIPs.execTracker = false;
             }
             
             }
             else
             {
               if(objSIPs.executionTracker == 'Yes')
               {
               tmpInsObj.isSIPexecutionTracker__c = true;
               objSIPs.execTracker = true;
               }
             else
             {
               tmpInsObj.isSIPexecutionTracker__c = false;
               objSIPs.execTracker = false;
             }
             }
             */
              if(objSIPs.executionTracker == 'Yes')
                 tmpInsObj.isSIPexecutionTracker__c = true;
               else
                 tmpInsObj.isSIPexecutionTracker__c = false;
            
                tmpInsObj.Account__c = beanObj.entityId;
                tmpInsObj.Product_Name__c = objSIPs.productName;
                tmpInsObj.Installments__c = objSIPs.installments;
                tmpInsObj.Amount__c = objSIPs.amount;
                tmpInsObj.Option__c = objSIPs.option;
                tmpInsObj.Category__c = objSIPs.category;
                tmpInsObj.Transaction_Type__c = objSIPs.transactionType;
                tmpInsObj.Remarks__c = objSIPs.remarks;
                tmpInsObj.Goal__c = objGoals.goalId;
                if(objSIPs.isETCreated != null )
                {
	              if(objSIPs.isETCreated)
	              tmpInsObj.isETCReated__c = true;
           		}
                //Added on : 07/02/13 : Aditi Satpute : Generate New AP
                tmpInsObj.AP_Status__c = Label.Opened;
                tmpInsObj.Item_Type__c = 'SIP';
                ApprovePlanAccountId.add(beanObj.entityId);
                SIPTotal += objSIPs.amount;
                 //Date : 08/01/13 : Commented as per discussion with Vinita 
	            /*if(SIPTotal > (1.2*objGoals.SIP))
	            {
	              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'SIP Funds Total should not exceed more than 20% of SIP Total for "'+objGoals.description + '" Goal'));
	              return null;
	            }*/
            	
            	/*Changes by Gaurav (16-5-2013):  To validate product name from SIP or not*/  
            	if(!(mapTypeToProductNames.get('SIP').contains('"'+objSIPs.productName+'"')))
            	{
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please Enter proper SIP funds name of "'+objGoals.description + '" Goal'));
	                return null;
                }
                /*End Changes*/
                if(objSIPs.amount <= 0 || objSIPs.productName == '' || objSIPs.installments <= 0 )
                {
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill all SIP Funds Required fields of "'+objGoals.description + '" Goal'));
	                return null;
                }
                else
                {
	              isSIPAmountGreater = true;
	              UpsertList.add(tmpInsObj); 
                }
             
        
            }
       
             if(objGoals.lstSIPFunds.size() ==  0)
              isSIPAmountGreater = true;
             for(ApprovedPlanBean.LumpsumFunds objLumpsums: objGoals.lstLumpsumFunds)
            {    
                Approve_Action_Plan__c tmpInsObj = new Approve_Action_Plan__c();
                tmpInsObj.Account__c = beanObj.entityId;
                tmpInsObj.Product_Name__c = objLumpsums.lumpsumProductName;
                tmpInsObj.Installments__c = objLumpsums.lumpsumInstallments;
                tmpInsObj.Amount__c = objLumpsums.lumpsumAmount;
                tmpInsObj.Option__c = objLumpsums.lumpsumOption;
                tmpInsObj.Category__c = objLumpsums.lumpsumCategory;
                tmpInsObj.Transaction_Type__c = objLumpsums.lumpsumTransactionType;
                tmpInsObj.Remarks__c = objLumpsums.lumpsumRemarks;
                tmpInsObj.Goal__c = objGoals.goalId;
                tmpInsObj.Amount_Per_Installment__c = objLumpsums.lumpsumAmountPerInstall;
                tmpInsObj.Fund__c = objLumpsums.lumpsumFund;
                tmpInsObj.Item_Type__c = 'Lumpsum';
                if(objLumpsums.isETCreated != null )
	            {
	              if(objLumpsums.isETCreated)
	              tmpInsObj.isETCReated__c = true;
	            }
	             //Added on : 07/02/13 : Aditi Satpute : Generate New AP
                 tmpInsObj.AP_Status__c = Label.Opened;
                //Date : 12/12/12 : Added new column Execution Tracker in Lumpsum funds 
                if(objLumpsums.lumpsumExecutionTracker == 'Yes')
                 tmpInsObj.isLumpsumExecTracker__c = true;
                else
                 tmpInsObj.isLumpsumExecTracker__c = false;
            
                 lumpsumTotal +=  objLumpsums.lumpsumAmount;
                 
                /*Changes by Gaurav (16-5-2013):  To validate product name from lumpsum or not*/  
                if(!(mapTypeToProductNames.get('Lumpsum').contains('"'+objLumpsums.lumpsumProductName+'"')))
            	{
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please Enter proper Lumpsum funds product name "'+objGoals.description + '" Goal'));
	                return null;
                }  
                /*End Changes*/
                
                if( objLumpsums.lumpsumProductName == '' )
                {
                	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill Lumpsum Funds "Product Name" of "'+objGoals.description + '" Goal'));
	              	return null;
                }
                if(objLumpsums.lumpsumTransactionType == 'STP From' && (objLumpsums.lumpsumAmount <= 0 || objLumpsums.lumpsumProductName == '' || objLumpsums.lumpsumInstallments <= 0
                 || objLumpsums.lumpsumFund == '' || objLumpsums.lumpsumAmountPerInstall <= 0))
                {
	              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill all Lumpsum Funds Required fields of "'+objGoals.description + '" Goal'));
	              return null;
                }
              //else
              //{
                //Date : 08/01/13 : Commented as per discussion with Vinita 
                /*if(lumpsumTotal >( 1.2*objGoals.lumpsum))
                {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Lumpsum Funds Total should not exceed more than 20% of Lumpsum Total for "'+objGoals.description + '" Goal'));
                  return null;
                }*/
                if(objLumpsums.lumpsumAmount > 0)
	            {
	                isLumpsumAmountGreater = true;
	                UpsertLumpsumList.add(tmpInsObj); 
	            }
	            else
	            {
	              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Lumpsum Funds "Amount" should be greater than zero for "'+objGoals.description + '" Goal'));
	                return null;
	            }
              //}
              
            }
            objGoals.LumpsumTotal = lumpsumTotal;
            objGoals.SIPTotal = SIPTotal;
            SIPSummaryTotal += SIPTotal; 
            if(objGoals.lstLumpsumFunds.size() ==  0)
              isLumpsumAmountGreater = true;
       }
       
         //============================Save Emergency Fund's Sip ============================
           List<GoalSIPAmount__c> lstGoalSIPAmount = [Select SIP_Total__c, SIP_Gold__c, SIP_Equity__c, SIP_Debt__c, Goal__c 
                                  From GoalSIPAmount__c 
                                  where Goal__c = :beanObj.objEmergencyFundGoalDetails.goalId and isNewSIP__c = true];
           delete lstGoalSIPAmount;
          GoalSIPAmount__c objGoalSIPAmount = new GoalSIPAmount__c();
          objGoalSIPAmount.SIP_Gold__c = beanObj.objEmergencyFundGoalDetails.goldAmt;
          objGoalSIPAmount.SIP_Equity__c = beanObj.objEmergencyFundGoalDetails.equityAmt;
          objGoalSIPAmount.SIP_Debt__c = beanObj.objEmergencyFundGoalDetails.debtAmt;
          objGoalSIPAmount.Goal__c = beanObj.objEmergencyFundGoalDetails.goalId;
          objGoalSIPAmount.Goal_Year__c = Date.today().year();
          objGoalSIPAmount.SIP_Outflow__c = true;
          upsert objGoalSIPAmount;
          
          beanObj.objEmergencyFundGoalDetails.SIP = beanObj.objEmergencyFundGoalDetails.equityAmt + beanObj.objEmergencyFundGoalDetails.debtAmt + beanObj.objEmergencyFundGoalDetails.goldAmt;
          if(beanObj.objEmergencyFundGoalDetails.SIP != 0)
        {
            beanObj.objEmergencyFundGoalDetails.equityPerc = (beanObj.objEmergencyFundGoalDetails.equityAmt * 100)/beanObj.objEmergencyFundGoalDetails.SIP;
          beanObj.objEmergencyFundGoalDetails.debtPerc = (beanObj.objEmergencyFundGoalDetails.debtAmt * 100)/beanObj.objEmergencyFundGoalDetails.SIP;
          beanObj.objEmergencyFundGoalDetails.goldPerc = (beanObj.objEmergencyFundGoalDetails.goldAmt * 100)/beanObj.objEmergencyFundGoalDetails.SIP;
        }  
        else
        {
          beanObj.objEmergencyFundGoalDetails.equityPerc = 0;
          beanObj.objEmergencyFundGoalDetails.debtPerc = 0;
          beanObj.objEmergencyFundGoalDetails.goldPerc = 0;
        }            
          
          //============================Save Emergency Fund's Lumpsum ============================
           
          Approve_Action_Plan__c objLumpsumApproveActionPlan = new Approve_Action_Plan__c();
          objLumpsumApproveActionPlan.Lumpsum_Gold__c = beanObj.objEmergencyFundLumpsum.lumpsumGoldAmt;
          objLumpsumApproveActionPlan.Lumpsum_Debt__c = beanObj.objEmergencyFundLumpsum.lumpsumDebtAmt;
          objLumpsumApproveActionPlan.Lumpsum_Equity__c = beanObj.objEmergencyFundLumpsum.lumpsumEquityAmt;
          objLumpsumApproveActionPlan.Goal__c = beanObj.objEmergencyFundLumpsum.goalId;
          objLumpsumApproveActionPlan.Item_Type__c = 'Lumpsum';
          objLumpsumApproveActionPlan.Account__c = beanObj.entityId;
          //Added on : 07/02/13 : Aditi Satpute : Generate New AP
            objLumpsumApproveActionPlan.AP_Status__c = Label.Opened;
          UpsertEmergencyLumpsumList.add(objLumpsumApproveActionPlan);
          
          
        beanObj.objEmergencyFundLumpsum.lumpsum = beanObj.objEmergencyFundLumpsum.lumpsumEquityAmt + beanObj.objEmergencyFundLumpsum.lumpsumDebtAmt + beanObj.objEmergencyFundLumpsum.lumpsumGoldAmt;
        if(beanObj.objEmergencyFundLumpsum.lumpsum !=0)
        {
          beanObj.objEmergencyFundLumpsum.lumpsumEquityPerc = (beanObj.objEmergencyFundLumpsum.lumpsumEquityAmt * 100)/beanObj.objEmergencyFundLumpsum.lumpsum;
          beanObj.objEmergencyFundLumpsum.lumpsumDebtPerc = (beanObj.objEmergencyFundLumpsum.lumpsumDebtAmt * 100)/beanObj.objEmergencyFundLumpsum.lumpsum;
          beanObj.objEmergencyFundLumpsum.lumpsumGoldPerc = (beanObj.objEmergencyFundLumpsum.lumpsumGoldAmt * 100)/beanObj.objEmergencyFundLumpsum.lumpsum;
        }
        else
        {
          beanObj.objEmergencyFundLumpsum.lumpsumEquityPerc = 0;
          beanObj.objEmergencyFundLumpsum.lumpsumDebtPerc = 0;
          beanObj.objEmergencyFundLumpsum.lumpsumGoldPerc = 0;
        }
        //============================Save Emergency Fund's Sip Funds=============================
         double emergencySIPTotal = 0;
         double emergencyLumpsumTotal = 0;
         
         for(ApprovedPlanBean.SIPFunds objSIPs: beanObj.objEmergencyFundGoalDetails.lstSIPFunds)
         {    
           String strKey = objSIPs.productName + '-' + objSIPs.transactionType + '-' + objSIPs.installments + '-' + objSIPs.option;
           ApprovedPlanBean.SIPFunds objSF;
           Approve_Action_Plan__c tmpInsObj = new Approve_Action_Plan__c();
           // Date : 12/12/12 : Commented due to Removal of Execution Tacker from SIP Summary Table & Added to individual SIP Funds 
         /*  if(mapStringToSIPFunds.containsKey(strKey))
           {
             objSF = mapStringToSIPFunds.get(strKey);
             if(objSF.executionTracker == 'Yes')
             {
             tmpInsObj.isSIPexecutionTracker__c = true;
             objSIPs.execTracker = true;
             }
           else
           {
             tmpInsObj.isSIPexecutionTracker__c = false;
             objSIPs.execTracker = false;
           }
           }
           else
           {
             if(objSIPs.executionTracker == 'Yes')
             {
             tmpInsObj.isSIPexecutionTracker__c = true;
             objSIPs.execTracker = true;
             }
           else
           {
             tmpInsObj.isSIPexecutionTracker__c = false;
             objSIPs.execTracker = false;
           }
           }*/
            
            if(objSIPs.executionTracker == 'Yes')
                 tmpInsObj.isSIPexecutionTracker__c = true;
               else
                 tmpInsObj.isSIPexecutionTracker__c = false;
            
            tmpInsObj.Account__c = beanObj.entityId;
            tmpInsObj.Product_Name__c = objSIPs.productName;
            tmpInsObj.Installments__c = objSIPs.installments;
            tmpInsObj.Amount__c = objSIPs.amount;
            tmpInsObj.Option__c = objSIPs.option;
            tmpInsObj.Category__c = objSIPs.category;
            tmpInsObj.Transaction_Type__c = objSIPs.transactionType;
            tmpInsObj.Remarks__c = objSIPs.remarks;
            tmpInsObj.Goal__c = beanObj.objEmergencyFundGoalDetails.goalId;
            if(objSIPs.isETCreated != null )
            {
	          if(objSIPs.isETCreated)
	            tmpInsObj.isETCReated__c = true;
            }
            //Added on : 07/02/13 : Aditi Satpute : Generate New AP
            tmpInsObj.AP_Status__c = Label.Opened;
            
            tmpInsObj.Item_Type__c = 'SIP';
            ApprovePlanAccountId.add(beanObj.entityId);
            emergencySIPTotal += objSIPs.amount;
            
	        //Date : 08/01/13 : Commented as per discussion with Vinita 
	        /*if(emergencySIPTotal > (1.2*beanObj.objEmergencyFundGoalDetails.SIP) )
	           {
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'SIP Funds Total should not exceed more than 20% of SIP Total for "Emergency Funds" Goal'));
	            return null;
	          }
	        */	
	        
        	if(!(mapTypeToProductNames.get('SIP').contains('"'+objSIPs.productName+'"')))
        	{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please Enter proper SIP funds name '));
                return null;
            }
      
           
            if(objSIPs.amount <= 0 || objSIPs.productName == '' || objSIPs.installments <= 0)
            {
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill all SIP Funds Required fields of "Emergency Funds" Goal'));
            	return null;
            }
            else
            {
          		isSIPAmountGreater = true;
          		UpsertEmergencySIPList.add(tmpInsObj); 
          
            }
            
        }
         beanObj.objEmergencyFundGoalDetails.SIPTotal = emergencySIPTotal;
         if(beanObj.objEmergencyFundGoalDetails.lstSIPFunds.size() ==  0)
          isSIPAmountGreater = true;
         SIPSummaryTotal += emergencySIPTotal;   
          beanObj.SIPSummaryTotal = SIPSummaryTotal;
        //=================================================================================================================    
            
         //============================Save Emergency Fund's Lumpsum Funds=============================
            for(ApprovedPlanBean.LumpsumFunds objLumpsums: beanObj.objEmergencyFundGoalDetails.lstLumpsumFunds)
            {    
               Approve_Action_Plan__c tmpInsObj = new Approve_Action_Plan__c();
               tmpInsObj.Account__c = beanObj.entityId;
               tmpInsObj.Product_Name__c = objLumpsums.lumpsumProductName;
               tmpInsObj.Installments__c = objLumpsums.lumpsumInstallments;
               tmpInsObj.Amount__c = objLumpsums.lumpsumAmount;
               tmpInsObj.Option__c = objLumpsums.lumpsumOption;
               tmpInsObj.Category__c = objLumpsums.lumpsumCategory;
               tmpInsObj.Transaction_Type__c = objLumpsums.lumpsumTransactionType;
               tmpInsObj.Remarks__c = objLumpsums.lumpsumRemarks;
               tmpInsObj.Goal__c = beanObj.objEmergencyFundGoalDetails.goalId;
               tmpInsObj.Amount_Per_Installment__c = objLumpsums.lumpsumAmountPerInstall;
               if(objLumpsums.isETCreated != null )
               {
	              if(objLumpsums.isETCreated)
	               tmpInsObj.isETCReated__c = true;
               }
               tmpInsObj.Fund__c = objLumpsums.lumpsumFund;
               tmpInsObj.Item_Type__c = 'Lumpsum';
               //Added on : 07/02/13 : Aditi Satpute : Generate New AP
               tmpInsObj.AP_Status__c = Label.Opened;
               emergencyLumpsumTotal += objLumpsums.lumpsumAmount; 
               if(objLumpsums.lumpsumExecutionTracker == 'Yes')
                 tmpInsObj.isLumpsumExecTracker__c = true;
               else
                 tmpInsObj.isLumpsumExecTracker__c = false;
               //Date : 08/01/13 : Commented as per discussion with Vinita 
             /*if(emergencyLumpsumTotal >  (1.2*beanObj.objEmergencyFundLumpsum.lumpsum))
            {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Lumpsum Funds Total should not exceed more than 20% of Lumpsum Total for "Emergency Funds" Goal'));
              return null;
            }
            */
             /* Gaurav (15-5-2013) : To validate entered product name of Lumpsum is available in lumpsum product name list   */ 
              if(!(mapTypeToProductNames.get('Lumpsum').contains('"'+objLumpsums.lumpsumProductName+'"')))
              {
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please Enter proper Lumpsum funds product name '));
	                return null;
              }  
             /* Enf Changes */
             
              if( objLumpsums.lumpsumProductName == '' )
            	{
	            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill Lumpsum Funds "Product Name" of "Emergency Funds" Goal'));
	              	return null;
	            }
              if(objLumpsums.lumpsumTransactionType == 'STP From' && (objLumpsums.lumpsumAmount <= 0 || objLumpsums.lumpsumProductName == '' || objLumpsums.lumpsumInstallments <= 0
                 || objLumpsums.lumpsumFund == '' || objLumpsums.lumpsumAmountPerInstall <= 0))
              {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill all Lumpsum Funds Required fields of "Emergency Funds" Goal'));
              return null;
              }
              else
              {
	              if(objLumpsums.lumpsumAmount > 0)
	              {
		              isLumpsumAmountGreater = true;
		              UpsertEmergencyLumpsumList.add(tmpInsObj); 
	              }	  
	              else
	              {
	              	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Lumpsum Funds "Amount" should be greater than zero for "Emergency Funds" Goal'));
	                return null;
	              }
              }
              
            }
             beanObj.objEmergencyFundGoalDetails.LumpsumTotal =  emergencyLumpsumTotal;
            if(beanObj.objEmergencyFundGoalDetails.lstLumpsumFunds.size() ==  0)
              isLumpsumAmountGreater = true;
            
        //=================================================================================================================          
       
       
       
        if(isSIPAmountGreater)
      {
        List<Approve_Action_Plan__c> lstApprove_Action_Plan  = [Select a.Transaction_Type__c,
                                          a.Remarks__c,a.Goal__c ,
                                          a.Amount__c,a.Product_Name__c, 
                                          a.Option__c, a.Installments__c, 
                                          a.CreatedDate, a.Category__c,isSIPexecutionTracker__c 
                                          From Approve_Action_Plan__c a where Account__c IN: familyIdSet and Item_Type__c = 'SIP'
                                          and AP_Status__c = 'Opened'];
        delete lstApprove_Action_Plan;
        upsert UpsertList;
        upsert UpsertEmergencySIPList;
      }
       if(isLumpsumAmountGreater)
       {
          List<Approve_Action_Plan__c> lstApprove_Action_Plan  = [Select a.Transaction_Type__c,
                                            a.Remarks__c,a.Goal__c ,
                                            a.Amount__c,a.Product_Name__c, 
                                            a.Option__c, a.Installments__c, 
                                            a.CreatedDate, a.Category__c,isLumpsumExecTracker__c
                                            From Approve_Action_Plan__c a where Account__c IN: familyIdSet and Item_Type__c = 'Lumpsum'
                                            and AP_Status__c = 'Opened'];
           if(!lstApprove_Action_Plan.isEmpty())
             delete lstApprove_Action_Plan;
             
          upsert UpsertLumpsumList;
          upsert UpsertEmergencyLumpsumList;
        }
                  
            //============ADVICE ON EXISTIING MUTUAL FUND SCHEMES==============================================================
            List<Approve_Action_Plan__c> lstUpsertCurrentMutualFunds = new List<Approve_Action_Plan__c>();
            List<Approve_Action_Plan__c> lstUpsertSIPCurrentMutualFunds = new List<Approve_Action_Plan__c>();
           // Map<String,List<ApprovedPlanBean.CurrentMutualFunds>> mapActionToCurrentMFlist = new Map<String,List<ApprovedPlanBean.CurrentMutualFunds>>();
            //Map<String,List<ApprovedPlanBean.CurrentMutualFunds>> mapActionToCurrentMFSIPlist = new Map<String,List<ApprovedPlanBean.CurrentMutualFunds>>();
            Map<Id,ApprovedPlanBean.CurrentMutualFunds> mapIdToSIPMutualFunds = new Map<Id,ApprovedPlanBean.CurrentMutualFunds>();
            
            for(ApprovedPlanBean.CurrentMutualFunds objSIPCurrentMutualFunds: beanObj.lstSIPCurrentFunds)
            {
	            if(objSIPCurrentMutualFunds.currentSIP < objSIPCurrentMutualFunds.SIPactionAmount)
	            {
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Mutual Fund Action Amount of SIP should not be greater than Amount'));
	                return null;
	            }
                if(!mapIdToSIPMutualFunds.containsKey(objSIPCurrentMutualFunds.investmentId))
              	{
                	mapIdToSIPMutualFunds.put(objSIPCurrentMutualFunds.investmentId,objSIPCurrentMutualFunds);
              	}
	           //Added code for displaying Action wise in pdf
	           /*List<ApprovedPlanBean.CurrentMutualFunds> lstCurrentMFSIPalreadyExists = new List<ApprovedPlanBean.CurrentMutualFunds>();
	           if(beanObj.mapActionToCurrentMFSIPlist.containsKey(objSIPCurrentMutualFunds.SIPaction))
	           {
	             lstCurrentMFSIPalreadyExists = beanObj.mapActionToCurrentMFSIPlist.get(objSIPCurrentMutualFunds.SIPaction);
	             lstCurrentMFSIPalreadyExists.add(objSIPCurrentMutualFunds);
	           }
	           else
	             lstCurrentMFSIPalreadyExists.add(objSIPCurrentMutualFunds);
	           beanObj.mapActionToCurrentMFSIPlist.put(objSIPCurrentMutualFunds.SIPaction,lstCurrentMFSIPalreadyExists);*/
              
            }
            Boolean isCheck = false;
            List<ApprovedPlanBean.CurrentMutualFunds> lstCurrentMutualFunds = new List<ApprovedPlanBean.CurrentMutualFunds>();
            
            for(Id InvestmentId : beanObj.mapIdToCurrentFunds.keySet())
            { 
              Double totalActionAmount = 0;
              lstCurrentMutualFunds = beanObj.mapIdToCurrentFunds.get(InvestmentId);
              for(ApprovedPlanBean.CurrentMutualFunds objCurrentMutualFunds : lstCurrentMutualFunds)
              { 
                if(objCurrentMutualFunds.amount != null && objCurrentMutualFunds.actionAmount != null)
                {
                  if(Math.ceil(objCurrentMutualFunds.amount) < Math.ceil(objCurrentMutualFunds.actionAmount) )
                  {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Action amount must be less than Amount'));
                    return null;
                  }
                  totalActionAmount += objCurrentMutualFunds.actionAmount;
                  Approve_Action_Plan__c objApprovePlan = new Approve_Action_Plan__c();
               	  objApprovePlan.Scheme_Name__c = objCurrentMutualFunds.schemeName;
                  objApprovePlan.Action_Amount__c = objCurrentMutualFunds.actionAmount;
                  //Added on : 07/02/13 : Aditi Satpute : Generate New AP
                  objApprovePlan.AP_Status__c = Label.Opened;
            
	               objApprovePlan.Amount__c = objCurrentMutualFunds.amount;
	               objApprovePlan.Asset_Class__c = objCurrentMutualFunds.assetClass;
	               
	               objApprovePlan.Account__c = objCurrentMutualFunds.account;
	               
	               if(objCurrentMutualFunds.isNewMutualFund != null && objCurrentMutualFunds.isNewMutualFund)
	                 objApprovePlan.isNewMutualFund__c = true;
	                 
	               if(objCurrentMutualFunds.executionTracker == 'Yes')
	                 objApprovePlan.isExecutionTracker__c = true;
	               else
	                 objApprovePlan.isExecutionTracker__c = false;
                 
	               //Added on:18/02/2013 : Aditi Satpute : AP changes
	               //objApprovePlan.MF_LumpsumRemark__c = objCurrentMutualFunds.mfLumpsumRemark;
	               if(objCurrentMutualFunds.isETCreated != null )
	               {
	                 if(objCurrentMutualFunds.isETCreated)
	                   objApprovePlan.isETCReated__c = true;
	               }
	               //Added on : 02/04/13 : Aditi Satpute : As no ET should be created for Action None : ET Screen changes
	               if((objCurrentMutualFunds.lumpsumAction == '') || (objCurrentMutualFunds.lumpsumAction == '--None--') || (objCurrentMutualFunds.lumpsumAction == null))
	                   objApprovePlan.isExecutionTracker__c = false;
	                     
	               objApprovePlan.Current_SIP__c = objCurrentMutualFunds.currentSIP;
	               objApprovePlan.Lumpsum_Action__c = objCurrentMutualFunds.lumpsumAction;
	               objApprovePlan.Investment_Asset__c = objCurrentMutualFunds.investmentId;
               
	               if(mapIdToSIPMutualFunds.containsKey(objCurrentMutualFunds.investmentId))
	               {
		                 ApprovedPlanBean.CurrentMutualFunds objSIPMFunds = mapIdToSIPMutualFunds.get(objCurrentMutualFunds.investmentId);
		                 
		                 objApprovePlan.SIP_Action__c = objSIPMFunds.SIPaction;
		                 objApprovePlan.SIP_Action_Amount__c = objSIPMFunds.SIPactionAmount;
		                 //Added on:18/02/2013 : Aditi Satpute : AP changes
		                 //objApprovePlan.MF_SIPRemark__c = objCurrentMutualFunds.mfSIPRemark;
		                system.debug('*******objCurrentMutualFunds.isMFsipETCreated***in service**'+objCurrentMutualFunds.isMFsipETCreated);
		                if(objSIPMFunds.isMFsipETCreated != null)
		                {
		                   if(objSIPMFunds.isMFsipETCreated)
		                     objApprovePlan.isMFsipETCreated__c = true;
		                }
	               
		                if(objSIPMFunds.SIPexecutionTracker == 'Yes')
		                     objApprovePlan.isSIPexecutionTracker__c = true;
		                else
		                     objApprovePlan.isSIPexecutionTracker__c = false;
               		}
              
                  
                   if(lstCurrentMutualFunds.size() > 1 && objApprovePlan.Action_Amount__c <= 0)
                   {
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Mutual Fund Action Amount should be greater than Zero'));
                      return null;
                   }
            
                   else
                   {
                    isMFAmountGreater = true;
                    lstUpsertCurrentMutualFunds.add(objApprovePlan);
                   }
                }
                
                
              /*  List<ApprovedPlanBean.CurrentMutualFunds> lstCurrentMFalreadyExists = new List<ApprovedPlanBean.CurrentMutualFunds>();
             if(beanObj.mapActionToCurrentMFlist.containsKey(objCurrentMutualFunds.lumpsumAction))
             {
               lstCurrentMFalreadyExists = beanObj.mapActionToCurrentMFlist.get(objCurrentMutualFunds.lumpsumAction);
               lstCurrentMFalreadyExists.add(objCurrentMutualFunds);
             }
             else
               lstCurrentMFalreadyExists.add(objCurrentMutualFunds);
             beanObj.mapActionToCurrentMFlist.put(objCurrentMutualFunds.lumpsumAction,lstCurrentMFalreadyExists);*/
                
              }
              
              if(Math.ceil(mapIdToInvestmentAsset.get(InvestmentId).TotalAsset__c) < Math.ceil(totalActionAmount))
              {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Total Action Amount must not be greater than Amount'));
                  return null;
              }
            }
            //delete previous records. 
            //===========Added on 30/11/2012 : for Retrieving Family member
        //List<Account> lstAccount = dbSOQLObj.getFamilyMembers(beanObj.entityId);
      //set<Id> familyIdSet = new set<Id>(); 
      //for(Account objAcc : lstAccount)
      //{
      //  familyIdSet.add(objAcc.Id);
      //}
      //==============================================================
           // List<Approve_Action_Plan__c> lstApproveActionPlan = [Select Id from Approve_Action_Plan__c where Account__c =: beanObj.entityId and Investment_Asset__c != null];
             List<Approve_Action_Plan__c> lstApproveActionPlan = [Select Id from Approve_Action_Plan__c where Account__c =: familyIdSet and Investment_Asset__c != null
                                       and AP_Status__c = 'Opened']; 
            if(!lstApproveActionPlan.isEmpty())
               delete lstApproveActionPlan;
            
            if(!lstUpsertCurrentMutualFunds.isEmpty())
              insert lstUpsertCurrentMutualFunds;
          
           //=============================================================================================================================== 
            
           //===Life Insurance=============================================================================================================
            List<Approve_Action_Plan__c> lstUpsertLifeInsurance = new List<Approve_Action_Plan__c>();
            List<Approve_Action_Plan__c> lstDeleteApproveActionPlan = [Select Id From Approve_Action_Plan__c  
                                          where Account__c IN: familyIdSet and Item_Type__c = : 'Life Insurance'
                                          and AP_Status__c = 'Opened'];
      		delete lstDeleteApproveActionPlan;      
      		//for(ApprovedPlanBean.LifeInsurance objLifeInsurance: beanObj.lstLifeInsurance)
            //{            
            List<ApprovedPlanBean.LifeInsurance> lstLifeInsurance = new List<ApprovedPlanBean.LifeInsurance>();
            for(Id InsuracneID : beanObj.mapIdToLifeInsuranceInnerClass.keySet())
            { 
              Double totalSuggestedCover = 0;
              lstLifeInsurance = beanObj.mapIdToLifeInsuranceInnerClass.get(InsuracneID);
              for(ApprovedPlanBean.LifeInsurance objLifeInsurance : lstLifeInsurance)
              {
	                if(objLifeInsurance.suggestedCover != null && objLifeInsurance.sumAssured != null)
	                {
	                  if(Math.ceil(objLifeInsurance.suggestedCover) < Math.ceil(objLifeInsurance.sumAssured) )
	                  {
	                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Sum Assured value of Life Insurance cannot exceed Suggested Cover value'));
	                    return null;
	                  }
	                }
	                 totalSuggestedCover += objLifeInsurance.sumAssured;
	                 Approve_Action_Plan__c objApprovePlan = new Approve_Action_Plan__c();
	                 Remarks__c objRemark = new Remarks__c();
		             objApprovePlan.Insurance__c = objLifeInsurance.insuranceId;
		             objApprovePlan.Item_Type__c = 'Life Insurance';
		             objApprovePlan.Account__c = beanObj.entityId;
		             objApprovePlan.InsuranceRemark__c = objLifeInsurance.insuranceRemark;
		             objApprovePlan.Policy_Name__c = objLifeInsurance.policyName;
		             //Added on : 07/02/13 : Aditi Satpute : Generate New AP
		             objApprovePlan.AP_Status__c = Label.Opened;
		             //Added on:06/02/2013 : Aditi Satpute : AP changes
		             objApprovePlan.Sum_Assured_Rs__c = objLifeInsurance.sumAssured;
		             //Added on:18/02/2013 : Aditi Satpute : AP changes
		             objApprovePlan.Premium_Amount_Rs__c = objLifeInsurance.premiumAmount;
		             //Added on:18/02/2013 : Aditi Satpute : AP changes
		             objApprovePlan.Tenure_of_Insurance__c = objLifeInsurance.tenureOfInsurance;
		             if(objLifeInsurance.isETCreated != null )
		             {
		               if(objLifeInsurance.isETCreated)
		                 objApprovePlan.isETCReated__c = true;
		             }
		             objApprovePlan.Suggested_Cover__c = objLifeInsurance.suggestedCover;
		             if(objLifeInsurance.isNewLI != null && objLifeInsurance.isNewLI)
		                   objApprovePlan.isNewLI__c = true;
		             
		             if(objLifeInsurance.executionTracker == 'Yes')
		               objApprovePlan.isInsuranceExecutionTracker__c = true;
		             else
		               objApprovePlan.isInsuranceExecutionTracker__c = false;
		             
		             /*  if(objLifeInsurance.sumAssured > objLifeInsurance.suggestedCover)
		             {
		               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Sum Assured value of Life Insurance cannot exceed Suggested Cover value'));
		                    return null;
		             }*/
		             
		             /* Gaurav (15-5-2013) : To validate entered product name of Life Inusrance is available in Life Inusrance  product name list   */ 
		              if(objLifeInsurance.policyType.equalsIgnoreCase('Term Life') && !(mapTypeToProductNames.get('Term Life').contains('"'+objLifeInsurance.policyName+'"')))
		              {
			              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please Enter proper Life Insurance product name '));
			              return null;
		              }  
		             /* Enf Changes */
	             
		             if(lstUpsertLifeInsurance.size() > 1 && objLifeInsurance.sumAssured <= 0)
		             {
		                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Life Insurance Sum Assured value must be greater than Zero'));
		                  return null;
		             }
	             	lstUpsertLifeInsurance.add(objApprovePlan);
	           }
               if(Math.ceil(MapIdToLifeInsurance.get(InsuracneID).Suggested_Cover_General_Insurance__c) < Math.ceil(totalSuggestedCover))
              {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Life Insurance Total Sum Assured value must not be greater than Suggested Cover'));
                  return null;
              }
        
            }
            if(!lstUpsertLifeInsurance.isEmpty())
              insert lstUpsertLifeInsurance;
           //==End of Life Insurance==========================================================================================================
            
           //===General Insurance=============================================================================================================
            List<Approve_Action_Plan__c> lstUpsertGeneralInsurance = new List<Approve_Action_Plan__c>();
            List<Approve_Action_Plan__c> lstUpsertNewGeneralInsurance = new List<Approve_Action_Plan__c>();
            List<Approve_Action_Plan__c> lstDeleteGeneralApproveActionPlan = [Select Id From Approve_Action_Plan__c 
                                            where Account__c IN: familyIdSet and Item_Type__c = : 'General Insurance'
                                            and AP_Status__c = 'Opened'];
          delete lstDeleteGeneralApproveActionPlan;                   
          for(ApprovedPlanBean.GeneralInsurance objGeneralInsurance: beanObj.lstGeneralInsurance)
          { 
              system.debug('********objGeneralInsurance********'+objGeneralInsurance);
              Approve_Action_Plan__c objApprovePlan = new Approve_Action_Plan__c();
	          objApprovePlan.Insurance__c = objGeneralInsurance.insuranceId;
	          objApprovePlan.Item_Type__c = 'General Insurance';
	          objApprovePlan.Account__c = beanObj.entityId;
	          if(objGeneralInsurance.isETCreated != null )
	          {
	             if(objGeneralInsurance.isETCreated)
	               objApprovePlan.isETCReated__c = true;
	          }
	          
              //Added on : 19/02/13 : Aditi Satpute : AP Changes
	           objApprovePlan.Insured__c = objGeneralInsurance.insured;
	           objApprovePlan.Policy_Type__c = objGeneralInsurance.policyType;
	           objApprovePlan.Sum_Assured_Rs__c = objGeneralInsurance.sumAssured;
          	   objApprovePlan.Premium_Amount_Rs__c = objGeneralInsurance.premiumAmount;
	           if(objGeneralInsurance.isETCreated != null )
	           {
	             if(objGeneralInsurance.isETCreated)
	               objApprovePlan.isETCReated__c = true;
	           }
	           //Added on : 07/02/13 : Aditi Satpute : Generate New AP
	           objApprovePlan.AP_Status__c = Label.Opened;
	           objApprovePlan.Product_Name__c = objGeneralInsurance.productName;
	           if(objGeneralInsurance.executionTracker == 'Yes')
	             objApprovePlan.isInsuranceExecutionTracker__c = true;
	           else
	             objApprovePlan.isInsuranceExecutionTracker__c = false;
             
               /* Gaurav (15-5-2013) : To validate entered product name of General Insurance is available in General Insurance  product name list   */ 
              if((objGeneralInsurance.policyType == 'Medical') && 
              		!(mapTypeToProductNames.get('Medical').contains('"'+objGeneralInsurance.productName+'"'))
              	||(objGeneralInsurance.policyType == 'Top Up') && 
              		!(mapTypeToProductNames.get('Top Up').contains('"'+objGeneralInsurance.productName+'"'))
              	||(objGeneralInsurance.policyType == 'Critical Illness') && 
              		!(mapTypeToProductNames.get('Critical Illness').contains('"'+objGeneralInsurance.productName+'"'))
              	||(objGeneralInsurance.policyType == 'Disability')&& 
              		!(mapTypeToProductNames.get('Disability').contains('"'+objGeneralInsurance.productName+'"'))
              	||(objGeneralInsurance.policyType == 'Personal Accident')&& 
              		!(mapTypeToProductNames.get('Personal Accident').contains('"'+objGeneralInsurance.productName+'"'))
              	||(objGeneralInsurance.policyType == 'Vehicle')&& 
              		!(mapTypeToProductNames.get('Vehicle').contains('"'+objGeneralInsurance.productName+'"'))
              	||(objGeneralInsurance.policyType == 'Householders')&& 
              		!(mapTypeToProductNames.get('Householders').contains('"'+objGeneralInsurance.productName+'"')))
              {
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please Enter proper General Insurance product name '));
	                return null;
              }  
             /* Enf Changes */
             
        	 lstUpsertGeneralInsurance.add(objApprovePlan);
             
          }
            if(!lstUpsertGeneralInsurance.isEmpty())
              insert lstUpsertGeneralInsurance;
            Map<Id,Account> mapIdToAcc = new Map<Id,Account>([select Id,Name from Account where Id IN: familyIdSet]);
            
            //Added on:19/02/2013 : Aditi Satpute : AP changes   : Add new GI blank rows
        if(!beanObj.lstNewGeneralInsurance.isEmpty())
        {
          for(ApprovedPlanBean.GeneralInsurance objNewGeneralInsurance: beanObj.lstNewGeneralInsurance)
            { 
                Approve_Action_Plan__c objApprovePlan = new Approve_Action_Plan__c();
                //Added on : 19/02/13 : Aditi Satpute : AP Changes
                //objApprovePlan.Insured__c = objNewGeneralInsurance.insured;
               system.debug('objNewGeneralInsurance.insured***********'+objNewGeneralInsurance.insured);
               if(mapIdToAcc.containsKey(objNewGeneralInsurance.insured))
               {
                   Account objAccount = mapIdToAcc.get(objNewGeneralInsurance.insured);
                   objApprovePlan.Insured__c = objAccount.Name;
                   objNewGeneralInsurance.insuredName = objAccount.Name;
               }
               objApprovePlan.Policy_Type__c = objNewGeneralInsurance.policyType;
               objApprovePlan.Sum_Assured_Rs__c = objNewGeneralInsurance.sumAssured;
               objApprovePlan.Premium_Amount_Rs__c = objNewGeneralInsurance.premiumAmount;
                if(objNewGeneralInsurance.isETCreated != null )
                {
                  if(objNewGeneralInsurance.isETCreated)
                      objApprovePlan.isETCReated__c = true;
                }
               //objApprovePlan.Insurance__c = objGeneralInsurance.insuranceId;
               objApprovePlan.Item_Type__c = 'General Insurance';
               objApprovePlan.Account__c = beanObj.entityId;
               //Added on : 07/02/13 : Aditi Satpute : Generate New AP
               objApprovePlan.AP_Status__c = Label.Opened;
               objApprovePlan.Product_Name__c = objNewGeneralInsurance.productName;
               if(objNewGeneralInsurance.executionTracker == 'Yes')
                   objApprovePlan.isInsuranceExecutionTracker__c = true;
               else
                   objApprovePlan.isInsuranceExecutionTracker__c = false;
             
              /* Gaurav (15-5-2013) : To validate entered product name of General Insurance is available in General Insurance  product name list   */ 
              if((objNewGeneralInsurance.policyType == 'Medical') && 
              		!(mapTypeToProductNames.get('Medical').contains('"'+objNewGeneralInsurance.productName+'"'))
              	||(objNewGeneralInsurance.policyType == 'Top Up') && 
              		!(mapTypeToProductNames.get('Top Up').contains('"'+objNewGeneralInsurance.productName+'"'))
              	||(objNewGeneralInsurance.policyType == 'Critical Illness') && 
              		!(mapTypeToProductNames.get('Critical Illness').contains('"'+objNewGeneralInsurance.productName+'"'))
              	||(objNewGeneralInsurance.policyType == 'Disability')&& 
              		!(mapTypeToProductNames.get('Disability').contains('"'+objNewGeneralInsurance.productName+'"'))
              	||(objNewGeneralInsurance.policyType == 'Personal Accident')&& 
              		!(mapTypeToProductNames.get('Personal Accident').contains('"'+objNewGeneralInsurance.productName+'"'))
              	||(objNewGeneralInsurance.policyType == 'Vehicle')&& 
              		!(mapTypeToProductNames.get('Vehicle').contains('"'+objNewGeneralInsurance.productName+'"'))
              	||(objNewGeneralInsurance.policyType == 'Householders')&& 
              		!(mapTypeToProductNames.get('Householders').contains('"'+objNewGeneralInsurance.productName+'"')))
              {
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please Enter proper General Insurance product name '));
	                return null;
              }  
             /* Enf Changes */
             
             if(objApprovePlan.Sum_Assured_Rs__c <= 0 || objApprovePlan.Product_Name__c == null || objApprovePlan.Policy_Type__c == null 
               || objApprovePlan.Premium_Amount_Rs__c == null)
             {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please fill all General Insurance Required fields'));
                return null;
             }
             lstUpsertNewGeneralInsurance.add(objApprovePlan);
          }
      }
        if(!lstUpsertNewGeneralInsurance.isEmpty())
              insert lstUpsertNewGeneralInsurance;
              
        /*  if(lstUpsertGeneralInsurance.size() > 0 || lstUpsertLifeInsurance.size() > 0 
                || lstUpsertCurrentMutualFunds.size() > 0 || UpsertList.size() > 0 || UpsertEmergencySIPList.size() > 0
                || UpsertLumpsumList.size() > 0 || UpsertEmergencyLumpsumList.size() > 0)
        {
          return false;
        }
        return true;*/
        
        //===Recommended Insurance=============================================================================================================
        List<Approve_Action_Plan__c> lstUpsertRecommendedInsurance = new List<Approve_Action_Plan__c>();
        List<Approve_Action_Plan__c> lstDeleteRecommendedApproveActionPlan = [Select Id From Approve_Action_Plan__c 
                                        where Account__c IN: familyIdSet and Item_Type__c = : 'Recommended Insurance'
                                        and AP_Status__c = 'Opened'];
        if(!lstDeleteRecommendedApproveActionPlan.isEmpty())
        delete lstDeleteRecommendedApproveActionPlan;                   
        for(ApprovedPlanBean.RecommendedInsurance objRecommendedInsurance: beanObj.lstRecommendedInsurance)
        {  
            Approve_Action_Plan__c objApprovePlan = new Approve_Action_Plan__c();
            system.debug('********objRecommendedInsurance********'+objRecommendedInsurance);
            objApprovePlan.Item_Type__c = 'Recommended Insurance';
            objApprovePlan.Insurance__c = objRecommendedInsurance.insuranceId;
	        objApprovePlan.AP_Status__c = Label.Opened;
	        objApprovePlan.Account__c = beanObj.entityId;
	        if(objRecommendedInsurance.isETCreated != null )
	        {
	          if(objRecommendedInsurance.isETCreated)
	             objApprovePlan.isETCreated__c = true;
	        }
	        if(objRecommendedInsurance.recInsuranceExecutionTracker == 'Yes')
	           objApprovePlan.isInsuranceExecutionTracker__c = true;
	        else
	             objApprovePlan.isInsuranceExecutionTracker__c = false;
	             lstUpsertRecommendedInsurance.add(objApprovePlan);
        }
		  if(!lstUpsertRecommendedInsurance.isEmpty())
		    insert lstUpsertRecommendedInsurance;
        //=================================================
        
        Map<String,List<ApprovedPlanBean.CurrentMutualFunds>> mapActionToMutualFundLumpsum = new Map<String,List<ApprovedPlanBean.CurrentMutualFunds>>();
        Map<String,List<ApprovedPlanBean.CurrentMutualFunds>> mapActionToMutualFundSIP = new Map<String,List<ApprovedPlanBean.CurrentMutualFunds>>();
       
        for( Id idMF  : beanObj.mapIdToCurrentFunds.keySet())
        {
          List<ApprovedPlanBean.CurrentMutualFunds> lstMF = beanObj.mapIdToCurrentFunds.get(idMF);
          for(ApprovedPlanBean.CurrentMutualFunds objMF : lstMF)
          {  
            List<ApprovedPlanBean.CurrentMutualFunds> lstCurrentMFalreadyExists = new List<ApprovedPlanBean.CurrentMutualFunds>();
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
        beanObj.mapActionToCurrentMFlist = mapActionToMutualFundLumpsum ;        
      
      for(ApprovedPlanBean.CurrentMutualFunds objSIP : beanObj.lstSIPCurrentFunds)
      {
          List<ApprovedPlanBean.CurrentMutualFunds> lstCurrentMFSIPalreadyExists = new List<ApprovedPlanBean.CurrentMutualFunds>();
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
      beanObj.mapActionToCurrentMFSIPlist = mapActionToMutualFundSIP;
      return null;
   }
    
       
    /**
    * @Description: save data in approved plan object and insurence object 
    * param: ApprovedPlanBean 
    * return type: void
    */
    public Pagereference upsertData(ApprovedPlanBean beanObj)
    {
        List<Approved_Action_Plan__c> insList = new List<Approved_Action_Plan__c>();
        for(ApprovedPlanBean.CurrentMFLumpSum tmpObj: beanObj.currentMFLumpSumList)
        {
            for(ApprovedPlanBean.Goals golObj: tmpObj.golCurrMFLumpSum)
            {    
                Approved_Action_Plan__c tmpInsObj = new Approved_Action_Plan__c();
                tmpInsObj.RecordTypeId = beanObj.recTypeMap.get(currentLump);
                tmpInsObj.Entity__c = tmpObj.entityId;
                tmpInsObj.Amount__c = tmpObj.actionAmount;
                tmpInsObj.Asset_Class__c = tmpObj.assetsClass;
                tmpInsObj.Investment_Asset__c = tmpObj.assetId;
                tmpInsObj.Lumpsum_Action__c = tmpObj.action;
                //tmpInsObj.Scheme_Name__c = tmpObj.schemeName;//FS0235
                tmpInsObj.Scheme_Name_Text__c = tmpObj.schemeName;//FS0235
                tmpInsObj.Goal__c = golObj.goalId;
                tmpInsObj.Allocated__c = golObj.allocated;
                if(tmpInsObj.Lumpsum_Action__c == 'Hold - Change of broker' 
                    || tmpInsObj.Lumpsum_Action__c == 'Hold - No Change of broker'){
                    if(tmpInsObj.Allocated__c!=null && tmpInsObj.Allocated__c != 0
                        && tmpInsObj.Amount__c != null && tmpInsObj.Amount__c != 0){
                        tmpInsObj.Allocated_Amount__c = (tmpInsObj.Amount__c * tmpInsObj.Allocated__c) / 100 ;
                    }else{
                        tmpInsObj.Allocated_Amount__c = 0;
                    }
                }else{
                    tmpInsObj.Allocated_Amount__c = 0;
                }   
                insList.add(tmpInsObj); 
            }
        }
         for(ApprovedPlanBean.CurrentMFSIP tmpObj: beanObj.currentMFSIPList)
        {
            for(ApprovedPlanBean.Goals golObj: tmpObj.golCurrMFSIP)
            {    
                Approved_Action_Plan__c tmpInsObj = new Approved_Action_Plan__c();
                tmpInsObj.RecordTypeId = beanObj.recTypeMap.get(currentSIP);
                tmpInsObj.Entity__c = tmpObj.entityId;
                tmpInsObj.Amount__c = tmpObj.SIPChange;
                tmpInsObj.Asset_Class__c = tmpObj.assetsClass;
                tmpInsObj.Investment_Asset__c = tmpObj.assetId;
                tmpInsObj.SIP_Action__c = tmpObj.SIPAction;
                //tmpInsObj.Scheme_Name__c = tmpObj.schemeName;//FS0235
                tmpInsObj.Scheme_Name_Text__c = tmpObj.schemeName;//FS0235
                tmpInsObj.Goal__c = golObj.goalId;
                tmpInsObj.Allocated__c = golObj.allocated;
                
                if(tmpInsObj.SIP_Action__c == 'Stop')
                {
                    tmpInsObj.Allocated_Amount__c = 0;
                }
                else if (tmpInsObj.SIP_Action__c == 'Continue')
                {
                  tmpInsObj.Amount__c = tmpObj.currentSIP; 
                }
                if(tmpInsObj.Allocated__c!=null && tmpInsObj.Allocated__c != 0&& tmpInsObj.Amount__c != null && tmpInsObj.Amount__c != 0)
                {
                    tmpInsObj.Allocated_Amount__c = (tmpInsObj.Amount__c * tmpInsObj.Allocated__c) / 100 ;
                }
                else
                {
                    tmpInsObj.Allocated_Amount__c = 0;
                }
              insList.add(tmpInsObj); 
            }
        }
        Set<String> chkDuplicate = new  Set<String>();
        boolean isError = false;
        for(ApprovedPlanBean.SuggestedMFLumpSum tmpObj: beanObj.suggestedMFLumpSumList){
            for(ApprovedPlanBean.Goals golObj: tmpObj.golsuggMFLump){
                if(! chkDuplicate.contains(tmpObj.entityId+tmpObj.schemeName+golObj.goalId)){
                    Approved_Action_Plan__c tmpInsObj = new Approved_Action_Plan__c();
                    tmpInsObj.RecordTypeId = beanObj.recTypeMap.get(suggestedLump);
                    tmpInsObj.Entity__c = tmpObj.entityId;
                    tmpInsObj.Amount__c = tmpObj.amount;
                    tmpInsObj.Asset_Class__c = tmpObj.assetsClass;
                    tmpInsObj.Investment_Asset__c = tmpObj.assetId;
                    tmpInsObj.Suggested_LumpSum_Action__c  = tmpObj.Action;
                    //tmpInsObj.Scheme_Name__c = tmpObj.schemeName;//FS0235
                    tmpInsObj.Scheme_Name_Text__c = tmpObj.schemeName;//FS0235
                     tmpInsObj.Notes__c=tmpObj.notes;
                    tmpInsObj.Goal__c = golObj.goalId;
                    tmpInsObj.Allocated__c = golObj.allocated;
                    if(tmpInsObj.Allocated__c!=null && tmpInsObj.Allocated__c != 0
                        && tmpInsObj.Amount__c != null && tmpInsObj.Amount__c != 0){
                        tmpInsObj.Allocated_Amount__c = ( tmpInsObj.Amount__c * tmpInsObj.Allocated__c) / 100;
                    }else{
                        tmpInsObj.Allocated_Amount__c = 0;
                    }
                    insList.add(tmpInsObj); 
                    chkDuplicate.add(tmpObj.entityId+tmpObj.schemeName+golObj.goalId);
                }else{
                    isError = true;
                }
            }
        }
        
        Set<String> chkDuplicate1 = new  Set<String>();
        boolean isError1 = false;
        for(ApprovedPlanBean.SuggestedMFSIP tmpObj: beanObj.suggestedMFSIPList)
        {
          for(ApprovedPlanBean.Goals golObj: tmpObj.golSuggMFSIP)
            {  
              if(!chkDuplicate1.contains(tmpObj.entityId+tmpObj.schemeName+golObj.goalId))
                {
                    Approved_Action_Plan__c tmpInsObj = new Approved_Action_Plan__c();
                    tmpInsObj.RecordTypeId = beanObj.recTypeMap.get(suggestedSIP);
                    tmpInsObj.Entity__c = tmpObj.entityId;
                    tmpInsObj.Amount__c = tmpObj.SIPAmount;
                    tmpInsObj.Asset_Class__c = tmpObj.assetsClass;
                    tmpInsObj.Investment_Asset__c = tmpObj.assetId;
                    //tmpInsObj.Scheme_Name__c = tmpObj.schemeName;//FS0235
                    tmpInsObj.Scheme_Name_Text__c = tmpObj.schemeName;//FS0235
                    tmpInsObj.Goal__c = golObj.goalId;
                    tmpInsObj.Allocated__c = golObj.allocated;
                    if(tmpInsObj.Allocated__c!=null && tmpInsObj.Allocated__c != 0 && tmpInsObj.Amount__c != null && tmpInsObj.Amount__c != 0)
                    {
                        tmpInsObj.Allocated_Amount__c = ( tmpInsObj.Amount__c * tmpInsObj.Allocated__c) / 100;
                    }
                    else
                    {
                        tmpInsObj.Allocated_Amount__c = 0;
                    }
                    insList.add(tmpInsObj); 
                    chkDuplicate1.add(tmpObj.entityId+tmpObj.schemeName+golObj.goalId);
                }
                else
                {
                  isError1 = true;
                }    
            }
        }
        if(isError || isError1)
        {
            if(isError)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ApprovedPlanLumpSumMessage));
            }
            if(isError1)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ApprovedPlanSIPMessage));
            }
            return null;
        }
        
        if(beanObj.approvedPlanList.size()>0)
        {
            dbDMLObj.deleteRecords(beanObj.approvedPlanList);
        }
         if(insList.size() >0)
        {
            dbDMLObj.upsertObject(insList);
        }
        if(beanObj.giApprovedList.size()>0){
            dbDMLObj.upsertObject(beanObj.giApprovedList);
        }
        if(beanObj.liApprovedList.size()>0){
            dbDMLObj.upsertObject(beanObj.liApprovedList);
        }
        
        return null;
    }
    
     /**
    * @Description: remove record from list and approved plan object for suggested lumpsum
    * param: ApprovedPlanBean 
    * return type: void
    */
    public void RemoveRecordLump(ApprovedPlanBean beanObj){
        List<Approved_Action_Plan__c> delList = new List<Approved_Action_Plan__c>();
        List<Integer> removeList = new List<Integer>();
        Integer cnt = 0;
        
        for(ApprovedPlanBean.SuggestedMFLumpSum tmpObj: beanObj.suggestedMFLumpSumList){
            if(tmpObj.isRemove){
                removeList.add(cnt);
            }
            cnt++;
        }
        for(integer i=removeList.size();i>0;i--){
            beanObj.suggestedMFLumpSumList.remove(removeList.get(i-1));
        }
       
    }
    
    /**
    * @Description: remove record from list and approved plan object for suggested SIPFunds of New Action Plan
    * param: ApprovedPlanBean 
    * return type: void
    */
  public void RemoveRecordSIPFunds(ApprovedPlanBean beanObj)
  {
        List<Approve_Action_Plan__c> delList = new List<Approve_Action_Plan__c>();
        for(ApprovedPlanBean.GoalDetails objGoals: beanObj.lstGoalDetails)
        {
          List<Integer> removeList = new List<Integer>();
          Integer cnt = 0;
          for(ApprovedPlanBean.SIPFunds objSIPs: objGoals.lstSIPFunds)
            {   
            if(objSIPs.isRemove)
            {
                  removeList.add(cnt);
            }
                cnt++;
            }
            for(integer i=removeList.size();i>0;i--)
            {
              objGoals.lstSIPFunds.remove(removeList.get(i-1));
           }
        }
        //Lumpsum
        for(ApprovedPlanBean.GoalDetails objGoals: beanObj.lstGoalDetails)
        {
          List<Integer> removeList = new List<Integer>();
          Integer cnt = 0;
          for(ApprovedPlanBean.LumpsumFunds objLumpsums: objGoals.lstLumpsumFunds)
            {   
            if(objLumpsums.isRemove)
            {
                  removeList.add(cnt);
            }
                cnt++;
            }
            for(integer i=removeList.size();i>0;i--)
            {
              objGoals.lstLumpsumFunds.remove(removeList.get(i-1));
           }
           
        }
        
        //Code for emergency fund -- Lumpsum Funds Remove================================================
        Integer LumpsumCnt = 0;
        List<Integer> LumpsumRemoveList = new List<Integer>();
        for(ApprovedPlanBean.LumpsumFunds objLumpsums: beanObj.objEmergencyFundGoalDetails.lstLumpsumFunds)
            {   
            if(objLumpsums.isRemove)
            {
                  LumpsumRemoveList.add(LumpsumCnt);
            }
                LumpsumCnt++;
            }
            for(integer i=LumpsumRemoveList.size();i>0;i--)
            {
              beanObj.objEmergencyFundGoalDetails.lstLumpsumFunds.remove(LumpsumRemoveList.get(i-1));
           }
        //==========================================================================================================
        
         //Code for emergency fund -- SIP Funds Remove================================================
        Integer SIPcnt = 0;
        List<Integer> SIPRemoveList = new List<Integer>();
        for(ApprovedPlanBean.SIPFunds objSIPs: beanObj.objEmergencyFundGoalDetails.lstSIPFunds)
        {   
        if(objSIPs.isRemove)
        {
              SIPRemoveList.add(SIPcnt);
        }
           SIPcnt++;
        }
        for(integer i=SIPRemoveList.size();i>0;i--)
        {
          beanObj.objEmergencyFundGoalDetails.lstSIPFunds.remove(SIPRemoveList.get(i-1));
       }
     }
    
    /**
    * @Description: get record types for the approved plan object
    * param: ApprovedPlanBean 
    * return type: void
    */
    public void getRecType(ApprovedPlanBean beanObj)
    {
        List<RecordType> recTypeList = dbSOQLObj.getObjectRecordTypes('Approved_Action_Plan__c'); 
        for(RecordType recObj: recTypeList ){
            beanObj.recTypeMap.put(recObj.Name, recObj.Id);
        }
       
    }
    
    /**
    * @Description: get all approved plans for the entity
    * param: ApprovedPlanBean 
    * return type: void
    */
    
    public List<Approved_Action_Plan__c> getdbApprovedPlans(List<Account> accList){
         List<Approved_Action_Plan__c> approvedPlanList = dbSOQLObj.getdbApprovedPlans(accList);
         return approvedPlanList;
    }
    
    /**
    * @Description: get mutual fund record for the entity and familiy
    * param: ApprovedPlanBean 
    * return type: void
    */
    public List<Investment_Asset__c> getMFInvestmentAsset(List<Account> accList)
    {
        List<Investment_Asset__c> investment= dbSOQLObj.getMFInvestmentAsset(accList);    
        return investment; 
    } 
    
    
    /**
    * @Description: Prpeare Lumpsum total and SIP Total
    * param: ApprovedPlanBean 
    * return type: void
    */
    public void PrpeareSuggested(ApprovedPlanBean beanObj)
    {
        List<AggregateResult> goalInassetList = dbSOQLObj.getInvestAssociationSum(beanObj.accList);
        List<AggregateResult> goalAssetList = dbSOQLObj.getInsuranceAssociationSum(beanObj.accList);
        List<AggregateResult> goalInsurList = dbSOQLObj.getAssetAssociationSum(beanObj.accList);
        
        Set<Id> profileSet = new set<id>();
        List<String> strGoalNames = new List<String>();
        
        Map<Id,Id> golProfileMap = new Map<Id,Id>();
        Map<Id,double> golAmountMap = new Map<Id,double>();
        for(AggregateResult agObj: goalInassetList){
             if((Double)agObj.get('expr0')!=null){  
                 golAmountMap.put((Id)agObj.get('Goal__c'),(Double)agObj.get('expr0'));
                 
             }
        }
        for(AggregateResult agObj: goalAssetList){
             if((Double)agObj.get('expr0')!=null){      
                 if(golAmountMap.get((Id)agObj.get('Goal__c'))!=null){
                     golAmountMap.put((Id)agObj.get('Goal__c'),golAmountMap.get((Id)agObj.get('Goal__c'))+(Double)agObj.get('expr0'));  
                 }else{
                     golAmountMap.put((Id)agObj.get('Goal__c'),(Double)agObj.get('expr0'));  
                 }
             }
        }
        for(AggregateResult agObj: goalInsurList){
             if((Double)agObj.get('expr0')!=null){  
                 if(golAmountMap.get((Id)agObj.get('Goal__c'))!=null){
                     golAmountMap.put((Id)agObj.get('Goal__c'),golAmountMap.get((Id)agObj.get('Goal__c'))+(Double)agObj.get('expr0'));  
                 }else{
                     golAmountMap.put((Id)agObj.get('Goal__c'),(Double)agObj.get('expr0'));  
                 }
             }
        }
        for(Goal__c golObj: beanObj.goalList){
            profileSet.add(golObj.SelectedGoalProfile__c);
            golProfileMap.put(golObj.Id,golObj.SelectedGoalProfile__c); 
        }
        system.debug('**profileSet****'+profileSet);
        List<goal_Profile__c> lstProfile = dbSOQLObj.getProfileList(profileSet);
                                                 
        
        //beanObj.asetList 'expr0'
        Map<Id,Double> golProfileDebtMap = new Map<Id,Double>();
        Map<Id,Double> golProfileGoldMap = new Map<Id,Double>();
        Map<Id,Double> golProfileEquityMap = new Map<Id,Double>();
        
        for(goal_Profile__c prObj: lstProfile){
            golProfileDebtMap.put(prObj.Id, prObj.debt_Allocation__c);
            golProfileGoldMap.put(prObj.Id, prObj.Gold_allocation__c);
            golProfileEquityMap.put(prObj.Id, prObj.Equity_Allocation__c);
            
        }
        /** Eternus Solutions       **/
    /** Author  : Manasi Ranade **/
    /** Issue Id: 00001470       **/
    /** Date    : 1/2/2012    **/
    /** Purpose : Code to find out the Equity,Debt,Gold percentages
    /****************************************************/
        Datetime cDT = System.now();
        Integer currentYear = Integer.valueOf(cDT.format('yyyy'));
       
        List<Id> golIds = new List<Id>();
        for(Goal__c golObj: beanObj.goalList){
            golIds.add(golObj.Id);
        }
        /** Eternus Solutions       **/
    /** Author  : Manasi Ranade **/
    /** Issue Id: 00001470       **/
    /** Date    : 1/2/2012    **/
    /** Purpose : Code to find out the Equity,Debt,Gold percentages
    /****************************************************/
        Map<Id, double> debtValMap = new  Map<Id, double>();
        Map<Id, double> equityValMap = new  Map<Id, double>();
        Map<Id, double> goldValMap = new  Map<Id, double>();
        Map<Id, double> totValMap = new  Map<Id, double>();
        double dblTotalPerc = 0,dblDebtPerc = 0,dblEquityPerc = 0,dblGoldPerc = 0;
        List<GoalSIPAmount__c> goalSips = dbSOQLObj.getGoalSIP(currentYear, golIds);
        Double dblTotalSIP = 0; 
        double tempDebt = 0,tempEquity = 0,tempGold = 0;
        for(GoalSIPAmount__c sipObj: goalSips){
          tempEquity = (sipObj.EquityCurrentYear__c == null ? 0 : sipObj.EquityCurrentYear__c);
          tempDebt = (sipObj.DebtCurrentYear__c == null ? 0 : sipObj.DebtCurrentYear__c);
          tempGold = (sipObj.GoldCurrentYear__c == null ? 0 : sipObj.GoldCurrentYear__c);
          
          system.debug('******tempEquity******'+tempEquity);
          system.debug('******tempDebt******'+tempDebt);
          system.debug('******tempGold******'+tempGold);
          dblTotalSIP = tempEquity + tempDebt + tempGold;
          if(dblTotalSIP > 0)
          {
        dblDebtPerc = sipObj.DebtCurrentYear__c / dblTotalSIP * 100;
        dblEquityPerc = sipObj.EquityCurrentYear__c / dblTotalSIP * 100;
        dblGoldPerc = sipObj.GoldCurrentYear__c / dblTotalSIP * 100;
          }
          else
      {
        dblDebtPerc = 0;
        dblEquityPerc = 0;
        dblGoldPerc = 0;
      }
            debtValMap.put(sipObj.Goal__c, dblDebtPerc);
            equityValMap.put(sipObj.Goal__c, dblEquityPerc); 
            goldValMap.put(sipObj.Goal__c, dblGoldPerc);
            system.debug('******dblEquityPerc******'+tempEquity);
          system.debug('******dblDebtPerc******'+tempDebt);
          system.debug('******dblGoldPerc******'+tempGold);
            
        }
        
        List<double> debtVals = prepareProfileWiseData(beanObj.goalList,golProfileMap,golProfileDebtMap, golAmountMap,debtValMap);
        List<double> equityVals = prepareProfileWiseData(beanObj.goalList,golProfileMap,golProfileEquityMap, golAmountMap,equityValMap);
        List<double> goldVals = prepareProfileWiseData(beanObj.goalList,golProfileMap,golProfileGoldMap, golAmountMap,goldValMap);
        
        ApprovedPlanBean.DoneClass asetDebt = new ApprovedPlanBean.DoneClass('Debt', debtVals);
        ApprovedPlanBean.DoneClass asetEquity = new ApprovedPlanBean.DoneClass('Equity', equityVals);
        ApprovedPlanBean.DoneClass asetGold = new ApprovedPlanBean.DoneClass('Gold', goldVals);
        beanObj.suggestedLumpSum.add(asetDebt);
        beanObj.suggestedLumpSum.add(asetEquity);
        beanObj.suggestedLumpSum.add(asetGold);   
        prepareSIPData(beanObj);
    }
    
     /** Eternus Solutions       **/
   /** Author  : Manasi Ranade **/
   /** Issue Id: 00001470       **/
   /** Date    : 1/2/2012    **/
   /** Purpose : Code to find out the Equity,Debt,Gold percentages
   /****************************************************/
     private List<double> prepareProfileWiseData(List<Goal__c> goalListP, Map<Id, Id>golProfileMapP, Map<Id, double>golProfileClassMapP
                             , Map<Id, double>golAmountMapP, Map<Id, double> percentageAllocationMap)
     {
                               
       system.debug('******goalListP********'+goalListP);
       system.debug('******golProfileMapP********'+golProfileMapP);
       system.debug('******golProfileClassMapP********'+golProfileClassMapP);
       system.debug('******golAmountMapP********'+golAmountMapP);
       system.debug('******percentageAllocationMap********'+percentageAllocationMap);
                                                                                                                               
        //Original Code
        /*List<double> classVals = new List<double>();
        for(Goal__c golObj: goalListP){
            Id goalId = golObj.Id;
            double sumMF = golAmountMapP.get(goalId);
            
            double Perc = 0;
            double amount = 0;
            
            if(golProfileMapP.get(goalId)!=null && golProfileClassMapP.get(golProfileMapP.get(goalId))!=null){
                Perc = golProfileClassMapP.get(golProfileMapP.get(goalId));
                if(sumMF !=null && sumMF!=0){
                    amount = (sumMF * Perc)/100;
                }
            }
            classVals.add(amount);
            
         }
         return classVals;*/
         List<double> classVals = new List<double>();
         for(Goal__c golObj: goalListP)
         {
            Id goalId = golObj.Id;
            double sumMF = golAmountMapP.get(goalId);
            
            double Perc = 0;
            double amount = 0;
            
            if(percentageAllocationMap != null & percentageAllocationMap.get(goalId) != null)
            {
                Perc = percentageAllocationMap.get(goalId);
                if(sumMF !=null && sumMF!=0)
                {
                    amount = (sumMF * Perc)/100;
                }
            }
            classVals.add(amount);
            
         }
         return classVals;
         
    }
    
    public void prepareSIPData(ApprovedPlanBean beanObj)
    {
        Datetime cDT = System.now();
        Integer currentYear = Integer.valueOf(cDT.format('yyyy'));
       
        List<Id> golIds = new List<Id>();
        for(Goal__c golObj: beanObj.goalList)
        {
            golIds.add(golObj.Id);
        }
        Map<Id, double> debtValMap = new  Map<Id, double>();
        Map<Id, double> equityValMap = new  Map<Id, double>();
        Map<Id, double> goldValMap = new  Map<Id, double>();
        
        List<GoalSIPAmount__c> goalSips = dbSOQLObj.getGoalSIP(currentYear, golIds);
        for(GoalSIPAmount__c sipObj: goalSips)
        {
            debtValMap.put(sipObj.Goal__c, sipObj.SIP_Debt__c);
            equityValMap.put(sipObj.Goal__c, sipObj.SIP_Equity__c); 
            goldValMap.put(sipObj.Goal__c, sipObj.SIP_Gold__c);
        }
        List<double> debtVal = new List<double>();
        List<double> equityVal = new List<double>();
        List<double> goldVal = new List<double>();
        
        for(Goal__c golObj: beanObj.goalList)
        {
            if(debtValMap.get(golObj.Id)!=null){
                debtVal.add(debtValMap.get(golObj.Id));
            }else{
                debtVal.add(0);
            }
            if(equityValMap.get(golObj.Id)!=null){
                equityVal.add(equityValMap.get(golObj.Id));
            }else{
                equityVal.add(0);
            }
            if(goldValMap.get(golObj.Id)!=null)
            {
                goldVal.add(goldValMap.get(golObj.Id));
            }else{
                goldVal.add(0);
            }
        } 
        
        ApprovedPlanBean.DoneClass debtObj = new  ApprovedPlanBean.DoneClass('Debt', debtVal);
        beanObj.SuggestedSIP.add(debtObj);
        ApprovedPlanBean.DoneClass equityObj = new  ApprovedPlanBean.DoneClass('Equity', equityVal);
        beanObj.SuggestedSIP.add(equityObj);
        ApprovedPlanBean.DoneClass goldObj = new  ApprovedPlanBean.DoneClass('Gold', goldVal);
        beanObj.SuggestedSIP.add(goldObj);
    }
    
}