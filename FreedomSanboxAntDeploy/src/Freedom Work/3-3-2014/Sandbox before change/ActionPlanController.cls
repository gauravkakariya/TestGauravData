/*
    Revision History:
    
    Version     Version Author     Date           Comments
    1.0         Aditi Satpute     27/09/2012     New Action Plan Creation
    1.1         Aditi Satpute     27/12/2012     Add new method showExecutionTracker() to create ET records on click 
                                                 Executon Tracker button from Action Plan page.
*/
//public with sharing class ActionPlanController extends FPsidebarDispalyLink - Commented because Action Plan fails when Entity gets Locked
public class ActionPlanController extends FPsidebarDispalyLink
{ 
    public Boolean isPreview {get;set;}
    transient private ActionPlanServices serviceObj;
    transient private ActionPlanUtility objActionPlanUtility; 
    public Boolean isMailSent{get;set;}
    public Boolean isSave{get;set;}
    public String address{get;set;}
    public String strProductFD{get;set;}
  
    //Action Plan : Aditi Satpute=20-9-2012=
    public EstatePlanningBean bean {get; set;}
    private static EstatePlanningServices service;
    public boolean toDisplayFields {get;set;} 
    public double SIPSummaryTotal{get;set;}
    public double LumpsumSummaryTotal{get;set;}
    public Integer counter {get;set;}
    public Boolean blnIsETAlreadyGenerated{get;set;}
    public String strEntityName {get;set;}
 	public String strSpouseName {get;set;}
    
    public String strOwnerName {get;set;}
    public String strGeneratedDate {get;set;}
    public ApprovedPlanBean beanObj {get;set;}
    public Boolean isFreedomUser{get;set;}
    public Boolean isFreedomUserProp{get;set;}
    public Account Partnerlogo{get;set;}
    public Account Logo_partner{get;set;}
    public Id AccOwnerId{get;set;}
    public String addNewGoalId{get;set;}
    public String addNewLumpsumGoalId{get;set;}
    public String addNewInvestId{get;set;}
    //Added on : 25/2/2013 : Aditi Satpute : Add new Life Insurance
    public String addNewLifeInsuranceId{get;set;}
    public Account objEntity {get;set;}
    
    public List<List<ApprovedPlanBean.RecommendedInsurance>> lstRecommendedInsurancePDF{get;set;}
    public Boolean isSidebar{get;set;}
    public static Boolean isNewAP{get;set;}
    public string entity{get;set;}
    public string owner{get;set;}           //Prajakta
    public String emailBody {get; set;}
    public boolean isFPLimitedAccess{get;set;}
    public static Map<String, ApprovedPlanBean.SIPFunds> mapStringToSIPFunds;
    
   	//Added on 5/8/2013 : Gaurav : Ap Chagnes : To display product name(Picklist) value of SIP,Limpsum and Insurance 
    public List<SelectOption> lstPolicyType{get;set;}
    
    //Added on 24/10/2013 : Aditi satpute : LI Capping removal changes
    public List<SelectOption> lstLifeInsurancePolicyType{get;set;}
    //Added on 5/12/2013 : Aditi satpute : Add On Changes
    public List<SelectOption> lstLoanType{get;set;}
    public List<SelectOption> lstBondType{get;set;}
    
    public String strProductName{get;set;}
    public String strProductMedical{get;set;}
    public String strProductIllness{get;set;}
    public String strProductTopUp{get;set;}
    public String strProductDisabilty{get;set;}
    public String strProductAccident{get;set;}
    public String strPolicyType{get;set;}
    public String strProductVehicle{get;set;}
    public String strProductHouseHold{get;set;}
    //public String strProductSIP{get;set;}
    public String strProductLumpsum{get;set;}
    public String strProductBond{get;set;}
    public User objFfreedomUser {get;set;}
    
    //Added By : Aditi Satpute : to render Execution Tracker button
    public boolean isExecutionTrackerOpened{get;set;}
    //Added on : 11/2/2013 : Prajakta Sanap : Hide Save button for Business Partner Financial Plan //Sanat
    public Boolean isDisplaySaveButton{get;set;}
    
    //Added on : 20/2/2013 : Aditi Satpute : AP Changes : Add Remark for MF - Lumpsum
    public String mfLumpsumRemark {get;set;}
    public String mfSIPRemark {get;set;}
    public String gsLumpsumRemark {get;set;}
    public String gsSIPRemark {get;set;}
    public String generalInsuranceRemark {get;set;}
    //Aditi Satpute : Remark added for Unallocated Assests Updated on : 10/6/13 :
    public String unallocatedAssetRemark {get;set;}
    public String successionPlanningRemark {get;set;}
    
    //public Boolean isNewGeneralInsurance{get;set;}
    public string openMutualFundPopup{get;set;}
    transient public DatabaseSOQL dbSOQLObj;
    //public List<Goal__c> lstGoal{get;set;}
    
    /*Added on 23/5/2013 : Gaurav : Below is Life Insurance Varible :To display product name(Autocomplete) value */
    public String strProductGeneralInsurance{get;set;}
    public String strProductLifeInsurance{get;set;}
    public String strProductLoan{get;set;}
    
    public Boolean isDisplayETButton {get;set;} 
   	
   	/* Prajakta - 4/12/2013 - Added to get product default allocation records */
    public Id BizUnitId {get;set;}
    public Id PartnerId {get;set;}
    transient public  map<String, set<String>> mapLifeInsTosetProducts {get;set;}
	transient public map<String, set<String>> mapMutualFundTosetProducts {get;set;}
	
	
	
	
	public String strLI_GI_Type{get;set;}
	public Integer strLI_GI_index{get;set;}
	public String strLI_GI_insuranceId{get;set;}
	//private List<Product_Master__c> lstProductMaster;
	/** View State Issue : Commented this -->public Map<String,List<Product_Master__c>> mapProductTypeToLstProducts{get;set;}*/
   	//public Map<String,Set<String>> mapLoanTypeToLstProducts {get;set;}  	
    /* End changes*/
    //public Map<String,Map<String,Set<String>>> mapCompanyNameToProducts{get;set;}
   
    public List<Approve_Action_Plan__c> lstLumpsumApproveActionPlan{get;set;} 
  	//Added on : 21/2/2013 : Aditi Satpute : AP Changes : SIP Summary to be displayed with respect to Transaction Type
    public Map<String,List<ApprovedPlanBean.SIPFunds>> mapSIPFundsAlreadyExists
    {
    	get 
    	{
    		Map<String,List<ApprovedPlanBean.SIPFunds>> mapSIPFundsAlreadyExists = new Map<String,List<ApprovedPlanBean.SIPFunds>>();
            for(ApprovedPlanBean.SIPFunds objSIPFunds : lstSummarySIPFunds)
            {
            	List<ApprovedPlanBean.SIPFunds> lstSIPFundsAlreadyExists = new List<ApprovedPlanBean.SIPFunds>();
            	if(mapSIPFundsAlreadyExists.containsKey(objSIPFunds.transactionType))
		   		{
		   			lstSIPFundsAlreadyExists = mapSIPFundsAlreadyExists.get(objSIPFunds.transactionType);
		   			lstSIPFundsAlreadyExists.add(objSIPFunds);
		   		}
		   		else
		   			lstSIPFundsAlreadyExists.add(objSIPFunds);
		   		mapSIPFundsAlreadyExists.put(objSIPFunds.transactionType,lstSIPFundsAlreadyExists);
            }
            return mapSIPFundsAlreadyExists;
    	}
    	set;
    }
    
    //Added on : 21/2/2013 : Aditi Satpute : AP Changes : Lumpsum Summary to be displayed with respect to Transaction Type
    public Map<String,List<Approve_Action_Plan__c>> mapLumpsumFundsAlreadyExists
    {
    	get
    	{
    		Map<String,List<Approve_Action_Plan__c>> mapLumpsumFundsAlreadyExists = new Map<String,List<Approve_Action_Plan__c>>();
            for(Approve_Action_Plan__c objLumpsumFunds : lstLumpsumApproveActionPlan)
            {
            	List<Approve_Action_Plan__c> lstLumpsumFundsAlreadyExists = new List<Approve_Action_Plan__c>();
            	if(mapLumpsumFundsAlreadyExists.containsKey(objLumpsumFunds.Transaction_Type__c))
		   		{
		   			lstLumpsumFundsAlreadyExists = mapLumpsumFundsAlreadyExists.get(objLumpsumFunds.Transaction_Type__c);
		   			lstLumpsumFundsAlreadyExists.add(objLumpsumFunds);
		   		}
		   		else
		   			lstLumpsumFundsAlreadyExists.add(objLumpsumFunds);
		   		mapLumpsumFundsAlreadyExists.put(objLumpsumFunds.Transaction_Type__c,lstLumpsumFundsAlreadyExists);
            }
            return mapLumpsumFundsAlreadyExists;
    	}
    	set;
    }
    
    
    
    
     public List<Approve_Action_Plan__c> lstSIPApproveActionPlan
     {
        get
        {
            if(lstSIPApproveActionPlan == null)
            {
                SIPSummaryTotal = 0;
                //Added on 24/12/2012 : for Retrieving Family member
                Set<Id> setFamilyMemberId = new Set<Id>(); 
                dbSOQLObj = new DatabaseSOQL(); 
                for(Account objAcc : dbSOQLObj.getFamilyMembers(beanObj.entityId))
                {
                    setFamilyMemberId.add(objAcc.Id);
                }
                lstSIPApproveActionPlan = [Select Transaction_Type__c, Remarks__c, Goal__c ,isSIPexecutionTracker__c, Amount__c,
                                            Product_Name__c, Option__c, Installments__c, CreatedDate, Category__c 
                                            From Approve_Action_Plan__c where Item_Type__c = 'SIP' and Account__c IN: setFamilyMemberId
                                            and AP_Status__c = 'Opened'];
                for(Approve_Action_Plan__c obj : lstSIPApproveActionPlan)
                {
                    SIPSummaryTotal = SIPSummaryTotal + obj.Amount__c;
                }
            }
            return lstSIPApproveActionPlan;
        }
        set;
    }
     public List<ApprovedPlanBean.SIPFunds> lstSummarySIPFunds
    {
        get
        {
            lstSummarySIPFunds = new List<ApprovedPlanBean.SIPFunds>();
            
             mapStringToSIPFunds = new Map<String, ApprovedPlanBean.SIPFunds>();
            
            for(ApprovedPlanBean.SIPFunds objSF : beanObj.objEmergencyFundGoalDetails.lstSIPFunds)
            {
                String strKey = objSF.productName + '-' + objSF.transactionType + '-' + objSF.installments + '-' + objSF.option;
                if(!mapStringToSIPFunds.containsKey(strKey))
                {
                    ApprovedPlanBean.SIPFunds objNewSIPFunds = new ApprovedPlanBean.SIPFunds();
                    objNewSIPFunds.productName = objSF.productName;
                    objNewSIPFunds.transactionType = objSF.transactionType;
                    objNewSIPFunds.installments = objSF.installments;
                    objNewSIPFunds.option = objSF.option;
                    objNewSIPFunds.remarks = objSF.remarks; 
                    objNewSIPFunds.category = objSF.category ;
                    objNewSIPFunds.amount = objSF.amount;
                    // Date : 12/12/12 : Commented due to Removal of Execution Tacker from SIP Summary Table & Added to individual SIP Funds  
                  /*objNewSIPFunds.execTracker = objSF.execTracker;
                    if(objNewSIPFunds.execTracker)
                        objNewSIPFunds.executionTracker = 'Yes';
                    else
                        objNewSIPFunds.executionTracker = 'No';*/
                    mapStringToSIPFunds.put(strKey, objNewSIPFunds);        
                }
                else
                {
                    ApprovedPlanBean.SIPFunds objSIPFunds = mapStringToSIPFunds.get(strKey);
                    if(objSF.amount != null )
                    {
                        objSIPFunds.amount +=  objSF.amount;
                        mapStringToSIPFunds.put(strKey, objSIPFunds);
                    }
                } 
            }
            
            for(ApprovedPlanBean.GoalDetails objGoals: beanObj.lstGoalDetails)
            {
                for(ApprovedPlanBean.SIPFunds objSIPs: objGoals.lstSIPFunds)
                {    
                    String strKey = objSIPs.productName + '-' + objSIPs.transactionType + '-' + objSIPs.installments + '-' + objSIPs.option;
                    if(!mapStringToSIPFunds.containsKey(strKey))
                    {       
                        ApprovedPlanBean.SIPFunds objNewSIPFunds = new ApprovedPlanBean.SIPFunds();
                        objNewSIPFunds.productName = objSIPs.productName;
                        objNewSIPFunds.transactionType = objSIPs.transactionType;
                        objNewSIPFunds.installments = objSIPs.installments;
                        objNewSIPFunds.option = objSIPs.option;
                        objNewSIPFunds.remarks = objSIPs.remarks; 
                        objNewSIPFunds.category = objSIPs.category ;
                        objNewSIPFunds.amount = objSIPs.amount;
                       
                        objNewSIPFunds.execTracker = objSIPs.execTracker;
                        if(objNewSIPFunds.execTracker)
                            objNewSIPFunds.executionTracker = 'Yes';
                        else
                            objNewSIPFunds.executionTracker = 'No';
                        mapStringToSIPFunds.put(strKey, objNewSIPFunds);        
                    }
                    else
                    {
                        ApprovedPlanBean.SIPFunds objSIPFunds = mapStringToSIPFunds.get(strKey);
                        if(objSIPs.amount != null )
                        {
                            objSIPFunds.amount +=  objSIPs.amount;
                            mapStringToSIPFunds.put(strKey, objSIPFunds);
                        }
                    } 
                }
            }
            
            lstSummarySIPFunds.addAll(mapStringToSIPFunds.values());
            
         /* List<ApprovedPlanBean.SIPFunds> lstSIPFundsAlreadyExists = new List<ApprovedPlanBean.SIPFunds>();
            Map<String,List<ApprovedPlanBean.SIPFunds>> mapSIPFundsAlreadyExists = new Map<String,List<ApprovedPlanBean.SIPFunds>>();
            for(ApprovedPlanBean.SIPFunds objSIPFunds : lstSummarySIPFunds)
            {
            	if(mapSIPFundsAlreadyExists.containsKey(objSIPFunds.transactionType))
		   		{
		   			lstSIPFundsAlreadyExists = mapSIPFundsAlreadyExists.get(objSIPFunds.transactionType);
		   			lstSIPFundsAlreadyExists.add(objSIPFunds);
		   		}
		   		else
		   			lstSIPFundsAlreadyExists.add(objSIPFunds);
		   		mapSIPFundsAlreadyExists.put(objSIPFunds.transactionType,lstSIPFundsAlreadyExists);
            }*/
            
	   		/*system.debug('********mapSIPFundsAlreadyExists********'+mapSIPFundsAlreadyExists.values().size());
	   		for(String str : mapSIPFundsAlreadyExists.keySet())
	   		{
	   			system.debug('******str********'+str);
	   			List<ApprovedPlanBean.SIPFunds> lstSIP = mapSIPFundsAlreadyExists.get(str);
	   			system.debug('******lstSIP********'+lstSIP);
	   		}
            */
            return lstSummarySIPFunds;
        }
        set;
    }
	//private List<Account> lstAcc = new List<Account>();
	
    public ActionPlanController()
    {
    	super(System.currentPageReference().getParameters().get('entityId')); //Changes by Gaurav   (15- -4 2013): To hide succesion palnning and Insurance disply on Action plan
    	List<Goal__c> lstGoal = new List<Goal__c>();
        dbSOQLObj = new DatabaseSOQL();
        isPreview = false;
        isFPLimitedAccess = false;
        isMailSent = false;
        isSave = true;
        isSidebar = true;
        isNewAP = false;
        isDisplayETButton = false;
        objActionPlanUtility =  new ActionPlanUtility();
        //Code Added on : 1/2/2013 : Prajakta Sanap : Hide Save button for Business Partner Financial Plan : by default true //Sanat
        isDisplaySaveButton = true;
       
       
       // isExecutionTrackerOpened = false;
        entity = System.currentPageReference().getParameters().get('entityId');
       	toDisplayFields = true;
       	counter = 0;
       	serviceObj = new ActionPlanServices();
       	beanObj = new  ApprovedPlanBean();
       	beanObj.entityId = entity;//Apexpages.currentPage().getParameters().get('entityId');
       	serviceObj.getRecType(beanObj);
       	blnIsETAlreadyGenerated = false;
       	serviceObj.getFamilyDetails(beanObj);
       // lstProductMaster = new List<Product_Master__c>();
        set<Id> familyIdSet = new set<Id>(); 
       	//mapCompanyNameToProducts = new Map<String,Map<String,Set<String>>>();
       	//mapProductType_PM_Comm = new Map<String,Map<String,Map<String,List<Commission__c>>>>();
       	//mapGoalIdToGoalDetails = new Map<Id,Goal__c>();
       	if(beanObj.accList != null)
       	{
           	for(Account objAccout : beanObj.accList)
           	{
            	if(objAccout.Id == beanObj.entityId)
                {
                	system.debug('-------objAccout---------'+objAccout);
                	AccOwnerId = objAccout.OwnerId; //Added for Partner Portal implementation Use ,Date : 31/7/12
                    blnIsETAlreadyGenerated = objAccout.IsExecutionTrackerGenerated__c;
                    /*if(objAccout.FirstName != null && objAccout.LastName != null)
                        strEntityName = objAccout.FirstName + ' '+ objAccout.LastName;
                    else if(objAccout.FirstName == null && objAccout.LastName != null)
                        strEntityName = objAccout.LastName;
                    else if(objAccout.FirstName != null && objAccout.LastName == null)
                        strEntityName = objAccout.FirstName;
                    else
                        strEntityName = '';*/
                    strEntityName = objAccout.FirstName != null ? (objAccout.LastName != null ? objAccout.FirstName + ' '+ objAccout.LastName : objAccout.FirstName) 
                    											: (objAccout.LastName != null ? objAccout.LastName : '');
                    strOwnerName = objAccout.Owner.Name;
                    strGeneratedDate = system.NOW().format('dd/MM/yyyy');
                    BizUnitId = objAccout.Business_Unit__c;
                    PartnerId = objAccout.Virtual_Partner__c;
                    system.debug('-------BizUnitId---------'+BizUnitId + ' - '+PartnerId);
                }
                else if (objAccout.Parent_Entity__c == beanObj.entityId)
                {
                	if(objAccout.Relationship_to_Entity__pc == 'Wife')
                	{
                		strSpouseName = objAccout.FirstName != null ? (objAccout.LastName != null ? objAccout.FirstName + ' '+ objAccout.LastName : objAccout.FirstName) 
                    											: (objAccout.LastName != null ? objAccout.LastName : '');
                	}
                }
                familyIdSet.add(objAccout.Id);
           	}
		}
        
        /*Prajakta - 4/12/2013 - Added to get map */
        mapLifeInsTosetProducts = new map<String, set<String>>();
        system.debug('-------mapLifeInsTosetProducts--1-------'+mapLifeInsTosetProducts+' - '+PartnerId +' - '+BizUnitId);
        mapLifeInsTosetProducts = objActionPlanUtility.mapLifeInsTosetProducts(PartnerId, BizUnitId);
        //error.debugLog('-------mapLifeInsTosetProducts---------'+mapLifeInsTosetProducts.size());
        
        mapMutualFundTosetProducts = new map<String, set<String>>();
        system.debug('-------mapMutualFundTosetProducts--1-------'+mapMutualFundTosetProducts+' - '+PartnerId +' - '+BizUnitId);
        mapMutualFundTosetProducts = objActionPlanUtility.mapMutualFundTosetProducts(PartnerId, BizUnitId);
        //mapMutualFundTosetProducts.put('.',lstSeqNo);
        //error.debugLog('-------mapMutualFundTosetProducts---------'+mapMutualFundTosetProducts);
        /*End Prajakta - 4/12/2013 - Added to get map */
        
         List<Product_Master__c> lstProductMaster;
        lstProductMaster = [Select Product_Name__c, Product_Manufacturer__c,Product_Manufacturer__r.Name, ProductType__c,Is_Active__c,
								   Policy_Type__c, Investment_Type__c, Asset_Class__c,
								   	(Select Min_Year_Value__c, Max_Year_Value__c, Min_Months__c, Max_Months__c, 
								   	Upfront_Commission__c, Trail_Commission__c from Commissions__r where Active__c = true)  
								From Product_Master__c Where Is_Active__c = true and Is_Recommended__c = true];
		//error.debugLog('--lstProductMaster---in controller-'+lstProductMaster);	
		//mapLoanTypeToLstProducts = new Map<String,Set<String>>();
        
        //lstProductMaster = objActionPlanUtility.lstProductMaster;					 					
        /** View State Issue : Commented this --> mapProductTypeToLstProducts = new Map<String,List<Product_Master__c>>();
        
        for(Product_Master__c objPM : lstProductMaster)
        {
        	List<Product_Master__c> lstPM  = new List<Product_Master__c>();
        	if(mapProductTypeToLstProducts.containskey(objPM.ProductType__c))
   			{
   				lstPM = mapProductTypeToLstProducts.get(objPM.ProductType__c);
   				lstPM.add(objPM);
	   			mapProductTypeToLstProducts.put(objPM.ProductType__c,lstPM);
   			}
   			else
   			{
   				lstPM.add(objPM);
   				mapProductTypeToLstProducts.put(objPM.ProductType__c,lstPM);
   			} 
        }
        **/
       	serviceObj.getGoals(beanObj); 
       	//serviceObj.getAssetAllocation(beanObj);
       	//beanObj.investment = serviceObj.getMFInvestmentAsset(beanObj.accList);
       	
       	//Commented on 19/12/13 : Aditi Satpute
       	/*beanObj.approvedPlanList = serviceObj.getdbApprovedPlans(beanObj.accList);
       	serviceObj.getCurMFLumpSumApprovedPlans(beanObj);
       	serviceObj.getCurMFSIPApprovedPlans(beanObj);
       	serviceObj.getSuggMFSIPApprovedPlans(beanObj);
       	serviceObj.getSuggMFLumpApprovedPlans(beanObj);
       	*/
       	beanObj.giList = serviceObj.getGenerelInsurance(beanObj.accList);
       	if(beanObj.giList != null && beanObj.giList.size()>0)
       	{
           	beanObj.isGeneralInsExist = true;
       	}
       	
       	beanObj.liList = serviceObj.getLifeInsurance(beanObj.accList);
       	if(beanObj.liList != null && beanObj.liList.size()>0)
       	{
           	beanObj.isLifeInsExist = true;
       	}
	    //Commented on 19/12/13 : Aditi Satpute
       	/*serviceObj.getApprGenerelInsurance(beanObj);
       	serviceObj.getApprLifeInsurance(beanObj);*/
       	serviceObj.PrpeareSummary(beanObj);
       	serviceObj.PrpeareSuggested(beanObj);
        //Code Added for Partner Portal related changes i.e Logo,Name etc.
        //Date :31/07/12  Code Added By :Aditi
        Contact con = new Contact();
        Account acc = new Account();
        
        Map<Id,Account> mapIdToAccount = new Map<Id,Account>();
		Map<Id,User> mapIdToUser = new Map<Id,User>();
		Map<Id,Contact> mapIdContact = new Map<Id,Contact>();
		objEntity = new  Account();
		
		mapIdToAccount = new Map<Id,Account>([Select Id, Name,Related_To__c,Family_Picture__c,Channel_Manager__c, OwnerId, owner.name ,Virtual_Partner__c,Logo__c, Email_ID__c,
											Company_Address__c, Phone,BillingState,BillingCountry,BillingPostalCode,BillingStreet,BillingCity,
											Alternate_E_Mail_Address__c,Website,Alternate_Mobile__c   
											from Account where (Id =:entity or RecordType.Name = 'General')]);
		mapIdToUser = new Map<Id,User>([select Id,Name,ContactId,Street,State,PostalCode,Phone,MobilePhone,Country,City,
													ManagerId,Profile.Name,UserType, Email from User where isActive = true]);
		
		
		if(mapIdToUser.containsKey(UserInfo.getUserId()))
		{
			//[Select Profile.Name, ProfileId, Name,UserType, Id From User where Id =: UserInfo.getUserId() limit 1];
			User objUser1 = mapIdToUser.get(UserInfo.getUserId());
	        if(objUser1.Profile.Name == 'Financial Planner(Limited Access)' || objUser1.Profile.Name == 'System Administrator')//Financial Planner(Limited Access) and System Administrator
	            isFPLimitedAccess = true;
	         //Added Code on : 11/2/2013 : Prajakta Sanap : Hide Save button for Business Partner Financial Plan 
	        //User objPartnerUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
	        if(objUser1.UserType.equalsIgnoreCase('PowerPartner'))
	        {
	            isDisplaySaveButton = false;
	        }
		}
		Set<Id> setContact = new Set<Id>();
		for(User objUser : mapIdToUser.values())
		{
			setContact.add(objUser.ContactId);
		}
		mapIdContact = new Map<Id,Contact>([select AccountId from Contact where Id IN: setContact]);
		if(mapIdToAccount.containsKey(entity))
		{
			objEntity = mapIdToAccount.get(entity);
			if(objEntity.Related_To__c != null && objEntity.Related_To__c.equalsIgnoreCase('Business Partner'))
			{
				if(mapIdToUser.containsKey(objEntity.OwnerId))
				{
					User objBPUSer = mapIdToUser.get(objEntity.OwnerId);
					if(objBPUSer.ContactId != null)
					{
						if(mapIdContact.containsKey(objBPUSer.ContactId))
						{
							con = mapIdContact.get(objBPUSer.ContactId);
							if(mapIdToAccount.containsKey(con.AccountId))
							{
								Partnerlogo = mapIdToAccount.get(con.AccountId);
               		 			isFreedomUser = false;
               		 			address = Partnerlogo.Company_Address__c;
							}
						}
					}
				}
			}
			else if(objEntity.Related_To__c != null && objEntity.Related_To__c.equalsIgnoreCase('Virtual Partner'))
			{
				if(mapIdToAccount.containsKey(objEntity.Virtual_Partner__c))
				{
					Partnerlogo = mapIdToAccount.get(objEntity.Virtual_Partner__c);
					isFreedomUser = false;
					address = Partnerlogo.Company_Address__c;
				}
			}
			else
			{
				isFreedomUser = true;
				if(mapIdToUser.containsKey(objEntity.OwnerId))
				{
					objFfreedomUser = mapIdToUser.get(objEntity.OwnerId);
				}
			}
		}
		
		//Action Plan : Aditi Satpute   
        //============================================================================    
        Id entityId = ApexPages.currentPage().getParameters().get('EntityId');
        
        if(entityId!=null)
        {
            bean = new EstatePlanningBean();
            service = new EstatePlanningServices();
            bean.entity = service.getEntityDetails(entityId);
            if(bean.entity.Will__c==false)
                bean.spouse = service.getSpouseDetails(entityId);
            else
                serviceObj.getWillExecTrackerDetails(beanObj); // for execution tracker
                
           //error.DebugLog(bean.entity.name);     
        }   
          
        lstGoal = beanObj.goalList;
        if(beanObj.entityId != null && beanObj.entityId != '')
        {   
            lstRecommendedInsurancePDF = new List<List<ApprovedPlanBean.RecommendedInsurance>>();
            
            beanObj = serviceObj.fetchGoalDetails(beanObj, mapMutualFundTosetProducts, mapLifeInsTosetProducts,bean.entity);
            List<ApprovedPlanBean.RecommendedInsurance> lstRIForPDF = new List<ApprovedPlanBean.RecommendedInsurance>();
            for(Integer i = 0;  i < beanObj.lstRecommendedInsurance.size() ; i++)
            {
                lstRIForPDF.add(beanObj.lstRecommendedInsurance[i]);
                if(Math.mod((i+1), 5) == 0)
                {
                    lstRecommendedInsurancePDF.add(lstRIForPDF);
                    lstRIForPDF = new List<ApprovedPlanBean.RecommendedInsurance>();
                }
            }
            
            if(Math.mod(beanObj.lstRecommendedInsurance.size(), 5) != 0)
            {
                lstRecommendedInsurancePDF.add(lstRIForPDF);
            }
        }
        
        blnIsETAlreadyGenerated = false;
        
        //if(beanObj.lstLifeInsuranceInnerclassRecordCount.size() > 0)
        
        beanObj.isLifeInsExist_in_Pdf_Html = beanObj.mapIdToLifeInsuranceInnerClass_Html_Pdf.size() > 0 ? true : false;
		system.debug('---lstGeneralInsuranceInnerclassRecordCount---'+beanObj.lstGeneralInsuranceInnerclassRecordCount.size());
        if(beanObj.lstGeneralInsuranceInnerclassRecordCount.size() > 0)
        	beanObj.isGeneralInsExist_in_Pdf_Html = true;	
        	
        lstLumpsumApproveActionPlan = new List<Approve_Action_Plan__c>();
        getLumpsumApproveActionPlans();
        lstSummarySIPFunds = new List<ApprovedPlanBean.SIPFunds>();
        getSummarySIPFunds();
        //lstAcc = dbSOQLObj.getFamilyMembers(beanObj.entityId);
        
       
       /* for(Account objAcc : beanObj.accList)//lstAcc)
        {
            familyIdSet.add(objAcc.Id);
        }*/
        List<Approve_Action_Plan__c> lstApproveActionPlan = [select Id,AP_Status__c,isUnallocatedRemark__c,UnAllocated_Assets_Remark__c,
        													Investment_Asset__c,MF_LumpsumRemark__c,MF_SIPRemark__c,Item_Type__c,InsuranceRemark__c,     
        													Investment_asset__r.RecordType.Name
        													from Approve_Action_Plan__c 
        													where Account__c =: familyIdSet and AP_Status__c = 'Opened'];
        system.debug('------lstApproveActionPlan-----------'+lstApproveActionPlan);										
        Map<Id,Approve_Action_Plan__c> mapIdToApproveActionPlan = new  Map<Id,Approve_Action_Plan__c>();
        for(Approve_Action_Plan__c objApprove : lstApproveActionPlan)
        {
        	if(objApprove.Investment_Asset__c != null)
        	{
        		if(objApprove.Investment_asset__r.RecordType.Name == 'Mutual Fund')
        		{
	        		mfLumpsumRemark = objApprove.MF_LumpsumRemark__c;
	        		mfSIPRemark = objApprove.MF_SIPRemark__c;
        		}
        		else if(objApprove.Investment_asset__r.RecordType.Name == 'Gold and Silver')
        		{
	        		gsLumpsumRemark = objApprove.MF_LumpsumRemark__c;
	        		gsSIPRemark = objApprove.MF_SIPRemark__c;
        		}
        	}
        	if(objApprove.Item_Type__c == 'General Insurance')
        	{
        		generalInsuranceRemark = objApprove.InsuranceRemark__c;
        	}
        	if(!mapIdToApproveActionPlan.containsKey(objApprove.Id))
        	{
        		mapIdToApproveActionPlan.put(objApprove.Id,objApprove);
        	}
        	if(objApprove.UnAllocated_Assets_Remark__c != null && objApprove.isUnallocatedRemark__c == true)
        		unallocatedAssetRemark = objApprove.UnAllocated_Assets_Remark__c;
        }
        
        List<Remarks__c> lstRemarks = [select Entity__c,Remark__c,recordtype.Name from Remarks__c where entity__c =: beanObj.entityId 
    								and (RecordType.Name =: 'GeneralInsurancePlanning' or RecordType.Name =: 'SummaryActionPlan'
    									or RecordType.Name =: 'SuccessionPlanning')];
    	system.debug('------lstRemarks-------inside----'+lstRemarks.size());							
    	if(!lstRemarks.isEmpty())
		{
			system.debug('------lstRemarks--------inside----');
    		for(Remarks__c obj : lstRemarks)
    		{
    			if(obj.recordtype.Name == 'SuccessionPlanning')
    			{
    				successionPlanningRemark = obj.Remark__c;
    				system.debug('------successionPlanningRemark-----------'+successionPlanningRemark);
    			}
    		}
		}
        
        if(lstApproveActionPlan.size() == 0)
        {
        	system.debug('------lstApproveActionPlan-------inside----');	
            //isSave = true;-Commented on 13/8/13 - Aditi Satpute - AP Clone Removal
            //isNewAP = false;-Commented on 13/8/13 - Aditi Satpute - AP Clone Removal
            
            //Remarks__c objRemarks = new Remarks__c();
            //objRemarks = [select Entity__c,Remark__c from Remarks__c where entity__c =: beanObj.entityId 
    		//						and recordtype.Name =: 'GeneralInsurancePlanning' limit 1];
            //generalInsuranceRemark = objRemarks.Remark__c;
            /**
            	Updated on : 10/6/13 : 
            	Aditi Satpute : Remark added for Unallocated Assests
            **/
            /*List<Remarks__c> lstRemarks = [select Entity__c,Remark__c,recordtype.Name from Remarks__c where entity__c =: beanObj.entityId 
    								and (RecordType.Name =: 'GeneralInsurancePlanning' or RecordType.Name =: 'SummaryActionPlan'
    									or RecordType.Name =: 'SuccessionPlanning')];
    		system.debug('------lstRemarks-------inside----'+lstRemarks.size());*/
    		if(!lstRemarks.isEmpty())
    		{
    			system.debug('------lstRemarks--------inside----');
	    		for(Remarks__c obj : lstRemarks)
	    		{
	    			/*if(obj.recordtype.Name == 'SuccessionPlanning')
	    			{
	    				successionPlanningRemark = obj.Remark__c;
	    				system.debug('------successionPlanningRemark-----------'+successionPlanningRemark);
	    			}*/
	    			if(obj.recordtype.Name == 'GeneralInsurancePlanning')
	    			{
	    				//objRemarks = lstRemarks[0];
    					generalInsuranceRemark = obj.Remark__c;
    					system.debug('------generalInsuranceRemark-----------'+generalInsuranceRemark);
	    			}
	    			else if (obj.RecordType.Name == 'SummaryActionPlan')
	    			{
	    				unallocatedAssetRemark = obj.Remark__c;
	    				system.debug('------unallocatedAssetRemark-----------'+unallocatedAssetRemark);
	    			}
	    		}
    		}
    		else
    		{
    			generalInsuranceRemark = '';
    			unallocatedAssetRemark = '';
    		}
        }
        else
        {
            for(Approve_Action_Plan__c objApproveActionPlan : lstApproveActionPlan)
            {
                if(objApproveActionPlan.AP_Status__c.equalsIgnoreCase(Label.Opened))
                {
                    isSave = true;
                    isNewAP = false;
                }
            }
            List<Execution_Tracker__c> lstExecutionTracker = [select Id from Execution_Tracker__c where Entity_Name__c =: familyIdSet 
            												and Is_Floating__c = false
            												and (Application_Status__c = 'Opened' or Application_Status__c = '')];
            if(lstExecutionTracker.size() == 0)
            {
            	List<Execution_Tracker__c> lstET = [select Id,Approve_Action_Plan__c from Execution_Tracker__c where Entity_Name__c =: familyIdSet
            												and  Is_Floating__c = false
            												and (Application_Status__c = 'Processed' or Application_Status__c = 'Closed'
            												or Application_Status__c = 'Rejected' or Application_Status__c =: Label.Forms_Provided
            												or Application_Status__c =: Label.Forms_Handed)];
            	for(Execution_Tracker__c objET : lstET)
            	{
            		if(mapIdToApproveActionPlan.containsKey(objET.Approve_Action_Plan__c))
            		{
            			if(Label.LockSave.equalsIgnoreCase('false'))
                		{
                    		isSave = true;
                    		isNewAP = false;
                		}
                		else
                		{
                    		isSave = false;
                    		isNewAP = true;
                		}
            		}
            		else
            		{
            			isSave = true;
                		isNewAP = false;
            		}
            	}
                
            }
            else
            {
            	
                if(Label.LockSave.equalsIgnoreCase('false'))
                {
                    isSave = true;
                    isNewAP = false;
                }
                else
                {
                    isSave = false;
                    isNewAP = true;
                }
            }
        }
         system.debug('---beanObj.entityId---'+beanObj.entityId);			
        List<EntityRelatedAttachment__c> lstRelatedAttachment = [Select e.Related_Entity__c, e.Name 
	    														From EntityRelatedAttachment__c e 
	    														where e.Related_Entity__c =: beanObj.entityId];
	   	 system.debug('---lstRelatedAttachment---'+lstRelatedAttachment);													
	    if(lstRelatedAttachment != null)
	    {
		    List<Attachment> lstAttachment = [Select a.ParentId, a.OwnerId, a.Name, a.Id, a.Description 
												from Attachment a where a.Name like 'Action_Plan_%' and a.ParentId IN: lstRelatedAttachment];
			system.debug('---lstAttachment---'+lstAttachment);											
		    if(!lstAttachment.isEmpty())
		    {
		    	isDisplayETButton = true;
		    	//isActionPlanVisible = accInstance.isFPGenerated__c;
		    	//system.debug('******isActionPlanVisible************'+isActionPlanVisible);
		    	//error.debugLog('******isActionPlanVisible************'+isActionPlanVisible);
		    }
	    }
        system.debug('---isDisplayETButton---'+isDisplayETButton);				
        
        /*====================================================================================================================
          Prajakta - 21-08-2013 - display Action wise on page load in Action Plan PDF for Gols and Silver
==================================================================================================================== */
        system.debug('--------------beanObj.mapIdToCurrentGold------------'+beanObj.mapIdToCurrentGold);
        if(beanObj.mapActionToCurrentGSlist.size() <= 0 )
        {
	        Map<String,List<ApprovedPlanBean.CurrentGoldSilver>> mapActionToGoldSilverLumpsum = new Map<String,List<ApprovedPlanBean.CurrentGoldSilver>>();
	        Map<String,List<ApprovedPlanBean.CurrentGoldSilver>> mapActionToGoldSilverSIP = new Map<String,List<ApprovedPlanBean.CurrentGoldSilver>>();
	        system.debug('--------------beanObj.mapIdToCurrentGold------------'+beanObj.mapIdToCurrentGold);
	        for( Id idGS  : beanObj.mapIdToCurrentGold.keySet())
	        {
	        	system.debug('--------------idGS------------'+idGS);
	        	List<ApprovedPlanBean.CurrentGoldSilver> lstGS = beanObj.mapIdToCurrentGold.get(idGS);
	          	for(ApprovedPlanBean.CurrentGoldSilver objGS : lstGS)
	          	{  
	          		system.debug('--------------objGS------------'+objGS);
	            	List<ApprovedPlanBean.CurrentGoldSilver> lstCurrentGSalreadyExists = new List<ApprovedPlanBean.CurrentGoldSilver>();
	             	if(mapActionToGoldSilverLumpsum.containsKey(objGS.lumpsumAction))
	             	{
	               		lstCurrentGSalreadyExists = mapActionToGoldSilverLumpsum.get(objGS.lumpsumAction);
	               		lstCurrentGSalreadyExists.add(objGS);
	             	}
	             	else
	             		lstCurrentGSalreadyExists.add(objGS);
	             	mapActionToGoldSilverLumpsum.put(objGS.lumpsumAction,lstCurrentGSalreadyExists);
	          	}
	        }
	        system.debug('--------------beanObj.mapActionToCurrentGSlist------------'+mapActionToGoldSilverLumpsum);
	        beanObj.mapActionToCurrentGSlist = mapActionToGoldSilverLumpsum ;        
	      
	      	for(ApprovedPlanBean.CurrentGoldSilver objSIP : beanObj.lstSIPCurrentGold)
	      	{
	        	List<ApprovedPlanBean.CurrentGoldSilver> lstCurrentGSSIPalreadyExists = new List<ApprovedPlanBean.CurrentGoldSilver>();
	           	if(mapActionToGoldSilverSIP.containsKey(objSIP.SIPaction))
	           	{
	             	lstCurrentGSSIPalreadyExists = mapActionToGoldSilverSIP.get(objSIP.SIPaction);
	             	lstCurrentGSSIPalreadyExists.add(objSIP);
	           	}
	           	else
	             	lstCurrentGSSIPalreadyExists.add(objSIP);
	           	mapActionToGoldSilverSIP.put(objSIP.SIPaction,lstCurrentGSSIPalreadyExists);
	      	}
	      	beanObj.mapActionToCurrentGSSIPlist = mapActionToGoldSilverSIP;
        }
 
  /*==================================================================================================================== */    
  /*====================================================================================================================
          Aditi - 19-11-2013 - display Insured wise on page load in Action Plan PDF for General Insurance
  ==================================================================================================================== */  
  		//beanObj.lstGeneralInsuranceCombinedInnerclass.sort();
        List<ApprovedPlanBean.GeneralInsurance> lstGeneralInsuranceCombinedInnerclass = beanObj.lstGeneralInsuranceCombinedInnerclass;
        beanObj.lstGeneralInsuranceCombinedInnerclass = new List<ApprovedPlanBean.GeneralInsurance>();
        beanObj.lstGeneralInsuranceCombinedInnerclass = serviceObj.getGICombinedListforPDF(lstGeneralInsuranceCombinedInnerclass);
 
   /*====================================================================================================================
          Aditi - 26-11-2013 - display Insured wise on page load in Action Plan PDF for Life Insurance
  ==================================================================================================================== */  
  		//beanObj.lstGeneralInsuranceCombinedInnerclass.sort();
        List<ApprovedPlanBean.LifeInsurance> lstLifeInsuranceCombinedInnerclass = beanObj.lstLifeInsuranceCombinedInnerclass;
        beanObj.lstLifeInsuranceCombinedInnerclass = new List<ApprovedPlanBean.LifeInsurance>();
        beanObj.lstLifeInsuranceCombinedInnerclass = serviceObj.getLICombinedListforPDF(lstLifeInsuranceCombinedInnerclass);
   
  /*==================================================================================================================== */    
     	
        //Added code on : 09/3/13 : Aditi Satpute : display Action wise on page load in Action Plan pdf
        if(beanObj.mapActionToCurrentMFlist.size() <= 0 )
        {
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
    			}
    		}
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
    		beanObj.mapActionToCurrentMFSIPlist = mapActionToMutualFundSIP;
        }
       
		/*Gaurav :(13-5-2013) To Display SIP,LUMPSUM And Insurance Name picklist in Action Plan  */
       	objActionPlanUtility =  new ActionPlanUtility();
       	//strProductSIP  = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Mutual Fund',lstProductMaster));
       	strProductLumpsum = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Mutual Fund',lstProductMaster));
       	strProductGeneralInsurance = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('General Insurance',lstProductMaster));
       	strProductLifeInsurance = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Life Insurance',lstProductMaster));
       	lstPolicyType = objActionPlanUtility.getInsurancePolicyTypes();
       	lstLifeInsurancePolicyType = objActionPlanUtility.getLifeInsurancePolicyTypes();
       	
       	//strProductLoan = objActionPlanUtility.getLoanProductName('Loan', 'Mortgage Loan');
       	//strProductCarLoan = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Loan', 'Car Loan'));
       	//strProductLoan = objActionPlanUtility.getLoanProductName('Loan',strPolicyType);
       	//getLoanVendorsName();
       	//Aditi: 5/12/13
       	lstLoanType = objActionPlanUtility.getLoanType(lstProductMaster);
       	lstBondType = objActionPlanUtility.getBondType();
       
       	/*End changes */
       	 
		/*
			Updated By : Kiran Patil
		  	Updated At : 3-Jun-2013
		  	Summary    : FP changes-part2 - issue 6 
		*/
        if(!(beanObj.lstGoalDetails).isEmpty()) {
	        list<ApprovedPlanBean.GoalDetails> tempaddNewListView = new list<ApprovedPlanBean.GoalDetails>();
        	list<ApprovedPlanBean.GoalDetails> tempaddNewListViewRetirement = new list<ApprovedPlanBean.GoalDetails>();
        	for (ApprovedPlanBean.GoalDetails goal : beanObj.lstGoalDetails) 
        	{  
        		system.debug('*****goal.goalType******'+goal.goalType);
        		if ((goal.description).containsIgnoreCase('Retirement') || (goal.goalType == 'Retirement'))
        		    tempaddNewListViewRetirement.add(goal);
        		else     
        		    tempaddNewListView.add(goal);
        	}
        	beanObj.lstGoalDetails = new list<ApprovedPlanBean.GoalDetails>();
        	beanObj.lstGoalDetails.addall(tempaddNewListView);
        	beanObj.lstGoalDetails.addall(tempaddNewListViewRetirement);
        }
    }
    
    private  List<Product_Master__c> returnActiveProductMasterList(){
    
    
        return new list<Product_Master__c>([Select Product_Name__c, Product_Manufacturer__c,Product_Manufacturer__r.Name, ProductType__c,Is_Active__c,
								   Policy_Type__c, Investment_Type__c, Asset_Class__c,
								   	(Select Min_Year_Value__c, Max_Year_Value__c, Min_Months__c, Max_Months__c, 
								   	Upfront_Commission__c, Trail_Commission__c from Commissions__r where Active__c = true)  
								From Product_Master__c Where Is_Active__c = true and Is_Recommended__c = true]);
    
    
    }
     /**
    * @Description: Calculates SIP Summary Total
    * param: None 
    * return type: None 
    */ 
    public void getSummarySIPFunds()
    {
        lstSummarySIPFunds = new List<ApprovedPlanBean.SIPFunds>();
        mapStringToSIPFunds = new Map<String, ApprovedPlanBean.SIPFunds>();
        //beanObj = serviceObj.fetchGoalDetails(beanObj);
        for(ApprovedPlanBean.SIPFunds objSF : beanObj.objEmergencyFundGoalDetails.lstSIPFunds)
        {
            String strKey = objSF.productName + '-' + objSF.transactionType + '-' + objSF.installments + '-' + objSF.option;
            if(!mapStringToSIPFunds.containsKey(strKey))
            {       
                ApprovedPlanBean.SIPFunds objNewSIPFunds = new ApprovedPlanBean.SIPFunds();
                objNewSIPFunds.productName = objSF.productName;
                objNewSIPFunds.transactionType = objSF.transactionType;
                objNewSIPFunds.installments = objSF.installments;
                objNewSIPFunds.option = objSF.option;
                objNewSIPFunds.remarks = objSF.remarks; 
                objNewSIPFunds.category = objSF.category ;
                objNewSIPFunds.amount = objSF.amount;
                // Date : 12/12/12 : Commented due to Removal of Execution Tacker from SIP Summary Table & Added to individual SIP Funds   
            /*    objNewSIPFunds.execTracker = objSF.execTracker;
                if(objNewSIPFunds.execTracker)
                    objNewSIPFunds.executionTracker = 'Yes';
                else
                    objNewSIPFunds.executionTracker = 'No';*/
                mapStringToSIPFunds.put(strKey, objNewSIPFunds);        
            }
            else
            {
                ApprovedPlanBean.SIPFunds objSIPFunds = mapStringToSIPFunds.get(strKey);
                if(objSF.amount != null )
                {
                    objSIPFunds.amount +=  objSF.amount;
                    mapStringToSIPFunds.put(strKey, objSIPFunds);
                }
            }
        }
        
        for(ApprovedPlanBean.GoalDetails objGoals: beanObj.lstGoalDetails)
        {
            for(ApprovedPlanBean.SIPFunds objSIPs: objGoals.lstSIPFunds)
            {    
                String strKey = objSIPs.productName + '-' + objSIPs.transactionType + '-' + objSIPs.installments + '-' + objSIPs.option;
                if(!mapStringToSIPFunds.containsKey(strKey))
                {       
                    ApprovedPlanBean.SIPFunds objNewSIPFunds = new ApprovedPlanBean.SIPFunds();
                    objNewSIPFunds.productName = objSIPs.productName;
                    objNewSIPFunds.transactionType = objSIPs.transactionType;
                    objNewSIPFunds.installments = objSIPs.installments;
                    objNewSIPFunds.option = objSIPs.option;
                    objNewSIPFunds.remarks = objSIPs.remarks; 
                    objNewSIPFunds.category = objSIPs.category ;
                    objNewSIPFunds.amount = objSIPs.amount;
                 // Date : 12/12/12 : Commented due to Removal of Execution Tacker from SIP Summary Table & Added to individual SIP Funds 
                /*    objNewSIPFunds.execTracker = objSIPs.execTracker;
                    if(objNewSIPFunds.execTracker)
                        objNewSIPFunds.executionTracker = 'Yes';
                    else
                        objNewSIPFunds.executionTracker = 'No';*/
                    mapStringToSIPFunds.put(strKey, objNewSIPFunds);        
                }
                else
                {
                    ApprovedPlanBean.SIPFunds objSIPFunds = mapStringToSIPFunds.get(strKey);
                    if(objSIPs.amount != null )
                    {       
                        objSIPFunds.amount +=  objSIPs.amount;
                        mapStringToSIPFunds.put(strKey, objSIPFunds);
                    }
                } 
            }
        }
        lstSummarySIPFunds = new List<ApprovedPlanBean.SIPFunds>();
        lstSummarySIPFunds.addAll(mapStringToSIPFunds.values());
 /*       List<ApprovedPlanBean.SIPFunds> lstSIPFundsAlreadyExists = new List<ApprovedPlanBean.SIPFunds>();
            Map<String,List<ApprovedPlanBean.SIPFunds>> mapSIPFundsAlreadyExists = new Map<String,List<ApprovedPlanBean.SIPFunds>>();
            for(ApprovedPlanBean.SIPFunds objSIPFunds : lstSummarySIPFunds)
            {
            	if(mapSIPFundsAlreadyExists.containsKey(objSIPFunds.transactionType))
		   		{
		   			lstSIPFundsAlreadyExists = mapSIPFundsAlreadyExists.get(objSIPFunds.transactionType);
		   			lstSIPFundsAlreadyExists.add(objSIPFunds);
		   		}
		   		else
		   			lstSIPFundsAlreadyExists.add(objSIPFunds);
		   		mapSIPFundsAlreadyExists.put(objSIPFunds.transactionType,lstSIPFundsAlreadyExists);
            }*/
    }
    
    
     /**
    * @Description: Calculates Lumpsum Summary Total
    * param: None 
    * return type: None 
    */ 
    public void getLumpsumApproveActionPlans()
    {
        //Added on 24/12/2012 : for Retrieving Family member
        Set<Id> setFamilyMemberId = new Set<Id>(); 
        dbSOQLObj = new DatabaseSOQL(); 
        for(Account objAcc : dbSOQLObj.getFamilyMembers(beanObj.entityId))
        {
            setFamilyMemberId.add(objAcc.Id);
            //error.debugLog(objAcc.name);
        }
        Map<String, Approve_Action_Plan__c> mapStringToActionPlan = new Map<String, Approve_Action_Plan__c>();
        lstLumpsumApproveActionPlan = [Select Transaction_Type__c, Remarks__c, Goal__c , Amount__c, Fund__c, Amount_Per_Installment__c,
                                                         Product_Name__c, Option__c, Installments__c, CreatedDate, Category__c From Approve_Action_Plan__c 
                                                         where Item_Type__c = 'Lumpsum' and Account__c IN: setFamilyMemberId and Amount__c != null
                                                         and AP_Status__c = 'Opened'];
        LumpsumSummaryTotal = 0;
        
        for(Approve_Action_Plan__c objApprovedActionPlan : lstLumpsumApproveActionPlan)
        {
            String strKey = objApprovedActionPlan.Product_Name__c + '-' + objApprovedActionPlan.Transaction_Type__c + '-' + 
                            objApprovedActionPlan.Amount_Per_Installment__c + '-' + objApprovedActionPlan.Installments__c + '-' + objApprovedActionPlan.Option__c;
            if(!mapStringToActionPlan.containsKey(strKey))
            {
                mapStringToActionPlan.put(strKey, objApprovedActionPlan);       
            }
            else
            {
                Approve_Action_Plan__c objAAP = mapStringToActionPlan.get(strKey);
                objAAP.Amount__c +=  objApprovedActionPlan.Amount__c;
                mapStringToActionPlan.put(strKey, objAAP);
            }
            if(objApprovedActionPlan.Amount__c != null )
            {
                LumpsumSummaryTotal = LumpsumSummaryTotal + objApprovedActionPlan.Amount__c;
            }
        }
        lstLumpsumApproveActionPlan = new List<Approve_Action_Plan__c>();
        lstLumpsumApproveActionPlan.addAll(mapStringToActionPlan.values());
    }
    
    /**
    * @Description: save the record in the Approved plan Object and Insurence object
    * param: None 
    * return type: PageReference 
    */ 
    //Commented on 19/12/13 : Aditi Satpute
    /*public pageReference upsertData()
    {
        Double dblAssetAmount = 0,dblActionAmount = 0,dblSIPChange = 0,dblCurrentSIP = 0;
        Boolean blnIsActionAmountGreater = false,blnIsSIPChangeGreater = false;
        String strSIPScheme ='',strLumpsumScheme ='';
      
        for(ApprovedPlanBean.CurrentMFLumpSum tmpObj: beanObj.currentMFLumpSumList)
        {
            if(tmpObj.assetAmount != null)
                dblAssetAmount = tmpObj.assetAmount;
                
            if(tmpObj.actionAmount != null)
                dblActionAmount = tmpObj.actionAmount;
                
            if(dblAssetAmount < dblActionAmount)
            {
                blnIsActionAmountGreater = true;
                
                if(strLumpsumScheme == '')
                    strLumpsumScheme = tmpObj.schemeName;
                else
                    strLumpsumScheme = strLumpsumScheme + ',' + tmpObj.schemeName;
            }
        }
    
        if(blnIsActionAmountGreater)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ActionAmountGreater+'. For the schemes: '+strLumpsumScheme));
            return null;
        }
        
        serviceObj.upsertData(beanObj);
        pageReference pageRef = new pageReference('/apex/ApprovedPlan?entityId='+beanObj.entityId+'&tabname=Financial Planning');
        return pageRef ;
    } 
    */
   
    /**
    * @Description: save the record in the Approve plan Object
    * param: None 
    * return type: PageReference 
    */ 
    public void saveActionPlan() 
    { 
        //Added on 24/12/2012 : for Retrieving Family member
        Set<Id> setFamilyMemberId = new Set<Id>(); 
        list<Product_Master__c> lstProductMaster = returnActiveProductMasterList();
    	Map<Id,Goal__c> mapGoalIdToGoalDetails = new Map<Id,Goal__c>(); 
    	/*
    	Map<String,Map<String,Map<String,List<Commission__c>>>> mapProductType_PM_Comm = new Map<String,Map<String,Map<String,List<Commission__c>>>>();
    	Map <String,Map<String,List<Commission__c>>> mapPM_ProductToComm;
    	Map<String,List<Commission__c>> mapProductToComm;*/
     	//Map<String,Set<String>> mapLoanTypeToLstProducts = new Map<String,Set<String>>();
     	Map<String,Map<String,Set<String>>> mapCompanyNameToProducts = new Map<String,Map<String,Set<String>>>();
     	//error.debugLog('--lstAcc--1--'+lstAcc);
     	List<Account> lstAcc = beanObj.accList;
     	//error.debugLog('--lstAcc--2--'+lstAcc);
        for(Account objAcc : lstAcc)
        {
            setFamilyMemberId.add(objAcc.Id);
        }
        Boolean isnewUnallocatedRemark = false;
        List<Goal__c> lstGoal = beanObj.goalList;
        for(Goal__c objGoal : lstGoal)
        {
        	mapGoalIdToGoalDetails.put(objGoal.Id,objGoal);
        }
        Map<String,String> mapTypeToProductNames = new Map<String,String>{'SIP' => strProductLumpsum , 
        																  'Lumpsum' =>strProductLumpsum ,
																		  'General Insurance' =>strProductGeneralInsurance , 
												 						  'Life Insurance' =>strProductLifeInsurance
						 												 }; 
		//error.debugLog('----lstProductMaster----'+lstProductMaster);				 												 
        for(Product_Master__c objPM : lstProductMaster)
        {
        	List<Product_Master__c> lstPM  = new List<Product_Master__c>();
        	Set<String> lstLoanPM  = new Set<String>();
        	Set<String> setFD_Bond_Products = new Set<String>();
        	
   			/*if(objPM.ProductType__c == 'Loan')
   			{
   				if(mapLoanTypeToLstProducts.containskey(objPM.Investment_Type__c))
	   			{
	   				lstLoanPM = mapLoanTypeToLstProducts.get(objPM.Investment_Type__c);
	   				lstLoanPM.add(objPM.Product_Name__c);
		   			mapLoanTypeToLstProducts.put(objPM.Investment_Type__c,lstLoanPM);
	   			}
	   			else
	   			{
	   				lstLoanPM.add(objPM.Product_Name__c);
	   				mapLoanTypeToLstProducts.put(objPM.Investment_Type__c,lstLoanPM);
	   			}
   			}
   			if(objPM.ProductType__c == 'Fixed Deposit')
   			{
	   			if(mapCompanyNameToProducts.containskey(objPM.Product_Manufacturer__c))
   				{
   					lstFixedDepositPM = mapCompanyNameToProducts.get(objPM.Product_Manufacturer__c);
   					lstFixedDepositPM.add(objPM.Product_Name__c);
	   				mapCompanyNameToProducts.put(objPM.Product_Manufacturer__c,lstFixedDepositPM);
   				}
   				else
   				{
   					lstFixedDepositPM.add(objPM.Product_Name__c);
   					mapCompanyNameToProducts.put(objPM.Product_Manufacturer__c,lstFixedDepositPM);
   				}
   			}
   			if(objPM.ProductType__c == 'Bond')
   			{
	   			if(mapCompanyNameToProducts.containskey(objPM.Product_Manufacturer__c))
   				{
   					lstFixedDepositPM = mapCompanyNameToProducts.get(objPM.Product_Manufacturer__c);
   					lstFixedDepositPM.add(objPM.Product_Name__c);
	   				mapCompanyNameToProducts.put(objPM.Product_Manufacturer__c,lstFixedDepositPM);
   				}
   				else
   				{
   					lstFixedDepositPM.add(objPM.Product_Name__c);
   					mapCompanyNameToProducts.put(objPM.Product_Manufacturer__c,lstFixedDepositPM);
   				}
   			}*/
   			
   			Map <String,Set<String>> innerMapCompanyNameToProducts = new Map <String,Set<String>>();
	   		if(mapCompanyNameToProducts.containsKey(objPM.ProductType__c))
	   		{
	   			innerMapCompanyNameToProducts = mapCompanyNameToProducts.get(objPM.ProductType__c);
	   			if(objPM.ProductType__c == 'Loan')
	   			{
	   				if(innerMapCompanyNameToProducts.containskey(objPM.Investment_Type__c))
		   			{
		   				lstLoanPM = innerMapCompanyNameToProducts.get(objPM.Investment_Type__c);
		   				lstLoanPM.add(objPM.Product_Name__c);
			   			innerMapCompanyNameToProducts.put(objPM.Investment_Type__c,lstLoanPM);
		   			}
		   			else
		   			{
		   				lstLoanPM.add(objPM.Product_Name__c);
		   				innerMapCompanyNameToProducts.put(objPM.Investment_Type__c,lstLoanPM);
		   			}
	   			}
	   			else
	   			{
		   			if(innerMapCompanyNameToProducts.containskey(objPM.Product_Manufacturer__c))
		   			{
		   				setFD_Bond_Products = innerMapCompanyNameToProducts.get(objPM.Product_Manufacturer__c);
		   				setFD_Bond_Products.add(objPM.Product_Name__c);
			   			innerMapCompanyNameToProducts.put(objPM.Product_Manufacturer__c,setFD_Bond_Products);
		   			}
		   			else
		   			{
		   				setFD_Bond_Products.add(objPM.Product_Name__c);
		   				innerMapCompanyNameToProducts.put(objPM.Product_Manufacturer__c,setFD_Bond_Products);
		   			}
	   			}
	   		}
	   		else
	   		{
	   			if(objPM.ProductType__c == 'Loan')
	   			{
		   			lstLoanPM = new Set<String>();
		   			lstLoanPM.add(objPM.Product_Name__c);
		   			innerMapCompanyNameToProducts.put(objPM.Investment_Type__c,lstLoanPM);
	   			}
	   			else
	   			{
	   				setFD_Bond_Products = new Set<String>();
		   			setFD_Bond_Products.add(objPM.Product_Name__c);
		   			innerMapCompanyNameToProducts.put(objPM.Product_Manufacturer__c,setFD_Bond_Products);
	   			}
	   		}
	   		mapCompanyNameToProducts.put(objPM.ProductType__c,innerMapCompanyNameToProducts);
   			
   			 
   			//==========================================
   			/*mapPM_ProductToComm = new Map <String,Map<String,List<Commission__c>>>();
   			mapProductToComm = new Map<String,List<Commission__c>>();
   			List<Commission__c> lstComm = new List<Commission__c>();
	   		if(mapProductType_PM_Comm.containsKey(objPM.ProductType__c))
	   		{
	   			mapPM_ProductToComm = mapProductType_PM_Comm.get(objPM.ProductType__c);
	   			if(mapPM_ProductToComm.containskey(objPM.Product_Manufacturer__c))
	   			{
	   				mapProductToComm = mapPM_ProductToComm.get(objPM.Product_Manufacturer__c);
   					lstComm = objPM.Commissions__r;
	   				mapProductToComm.put(objPM.Product_Name__c,lstComm);
	   			}
	   			else 
	   			{
	   				lstComm = objPM.Commissions__r;
	   				mapProductToComm.put(objPM.Product_Name__c,lstComm);
	   			}
	   			mapPM_ProductToComm.put(objPM.Product_Manufacturer__c,mapProductToComm);
	   		}
	   		else
	   		{
	   			lstComm = objPM.Commissions__r;
   				mapProductToComm.put(objPM.Product_Name__c,lstComm);
	   			mapPM_ProductToComm.put(objPM.Product_Manufacturer__c,mapProductToComm);
	   		}
	   		mapProductType_PM_Comm.put(objPM.ProductType__c,mapPM_ProductToComm);*/
   			
   			
        }
        //error.debugLog('-mapProductType_PM_Comm.keySey---'+mapProductType_PM_Comm.keySet());
        //error.debugLog('-mapPM_ProductToComm.keySey---'+mapPM_ProductToComm.keySet());
        //serviceObj.saveActionPlan(beanObj,mapStringToSIPFunds, lstAcc, mapTypeToProductNames,mapLoanTypeToLstProducts,lstProductMaster,
        //														mapCompanyNameToProducts,mapGoalIdToGoalDetails);
        //serviceObj.saveActionPlan(beanObj,mapStringToSIPFunds, lstAcc, mapTypeToProductNames,mapLoanTypeToLstProducts,lstProductMaster,mapCompanyNameToProducts,mapGoalIdToGoalDetails);
        														//mapProductType_PM_Comm,mapGoalIdToGoalDetails);	
        serviceObj = new ActionPlanServices(); 																											
        serviceObj.saveActionPlan(beanObj,mapStringToSIPFunds, lstAcc, mapTypeToProductNames,lstProductMaster,mapCompanyNameToProducts,mapGoalIdToGoalDetails);														
        isExecutionTrackerOpened = true;
        
        getLumpsumApproveActionPlans();
       
        getSummarySIPFunds();
        List<Approve_Action_Plan__c> lstApproveActionPlanUpdateAll = new List<Approve_Action_Plan__c>();
       // List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
       // List<Approve_Action_Plan__c> lstUpdateMFApproveActionPlan = new List<Approve_Action_Plan__c>();
       	//List<Approve_Action_Plan__c> lstUpdateGIApproveActionPlan = new List<Approve_Action_Plan__c>();
       /* for(Approve_Action_Plan__c objApproveActionPlan : [select isNewMutualFund__c,isSIPexecutionTracker__c 
                                                                from Approve_Action_Plan__c where Account__c IN: setFamilyMemberId 
                                                                 and AP_Status__c = 'Opened'
                                                                 and (isNewMutualFund__c = true OR isNewGoldSilver__c = true)])
        {
        	if(objApproveActionPlan.isNewMutualFund__c)
            	objApproveActionPlan.isSIPexecutionTracker__c = false;
            else
            	objApproveActionPlan.isGSsip_ExecutionTracker__c = false;
            lstApproveActionPlan.add(objApproveActionPlan);
        }
        if(!lstApproveActionPlan.isEmpty())
            update lstApproveActionPlan;*/
        List<Approve_Action_Plan__c> lstAP = new List<Approve_Action_Plan__c>();
        for(Approve_Action_Plan__c objMFApproveActionPlan : [select isNewMutualFund__c,isUnallocatedRemark__c,InsuranceRemark__c,isSIPexecutionTracker__c,
        														Investment_Asset__c,Investment_asset__r.RecordType.Name, isNewGoldSilver__c, 
        														MF_LumpsumRemark__c,UnAllocated_Assets_Remark__c,MF_SIPRemark__c,Item_Type__c 
        														from Approve_Action_Plan__c 
        														where Account__c IN: setFamilyMemberId 
                                                                and AP_Status__c = 'Opened'])
        {
        	isnewUnallocatedRemark = false;
        	if(objMFApproveActionPlan.Investment_Asset__c != null )
        	{
        		if(objMFApproveActionPlan.Investment_asset__r.RecordType.Name == 'Mutual Fund')
        		{
	        		objMFApproveActionPlan.MF_LumpsumRemark__c = mfLumpsumRemark;
		        	objMFApproveActionPlan.MF_SIPRemark__c = mfSIPRemark;
        		}
        		else if(objMFApproveActionPlan.Investment_asset__r.RecordType.Name == 'Gold and Silver')
        		{
		        	objMFApproveActionPlan.MF_LumpsumRemark__c = gsLumpsumRemark;
		        	objMFApproveActionPlan.MF_SIPRemark__c = gsSIPRemark;
        		}
	           	//lstUpdateMFApproveActionPlan.add(objMFApproveActionPlan);
        	}
        	if(objMFApproveActionPlan.Item_Type__c == 'General Insurance')
        	{
        		objMFApproveActionPlan.InsuranceRemark__c = generalInsuranceRemark;
        		//lstUpdateMFApproveActionPlan.add(objMFApproveActionPlan);
        	}
        	if(unallocatedAssetRemark != null && objMFApproveActionPlan.isUnallocatedRemark__c == true)
        	{
        		objMFApproveActionPlan.UnAllocated_Assets_Remark__c = unallocatedAssetRemark;
        		lstAP.add(objMFApproveActionPlan);
        		//objMFApproveActionPlan.isUnallocatedRemark__c = true;
        	} 
        	if(objMFApproveActionPlan.isNewMutualFund__c)
        	{
            	objMFApproveActionPlan.isSIPexecutionTracker__c = false;
            	//lstApproveActionPlan.add(objMFApproveActionPlan);
        	}
            else if(objMFApproveActionPlan.isNewGoldSilver__c)
            {
            	objMFApproveActionPlan.isGSsip_ExecutionTracker__c = false;
           	 	//lstApproveActionPlan.add(objMFApproveActionPlan);
            }
        	/*else
        	{
        		if(!isnewUnallocatedRemark)
        		{
        			isnewUnallocatedRemark = true;
        			system.debug('************isnewUnallocatedRemark*******')
        		}
        	}*/
        	//lstUpdateGIApproveActionPlan.add(objMFApproveActionPlan);
        	lstApproveActionPlanUpdateAll.add(objMFApproveActionPlan);
        }
      	if(lstAP.size() == 0)
        {
        	Approve_Action_Plan__c objUnallocatedAssetsRemark = new Approve_Action_Plan__c();
        	objUnallocatedAssetsRemark.UnAllocated_Assets_Remark__c = unallocatedAssetRemark;
			objUnallocatedAssetsRemark.isUnallocatedRemark__c = true;
			objUnallocatedAssetsRemark.AP_Status__c = 'Opened';
			objUnallocatedAssetsRemark.Account__c = beanObj.entityId;
			insert objUnallocatedAssetsRemark;
        }
       
        //if(!lstApproveActionPlan.isEmpty())
         	//lstApproveActionPlanUpdateAll.addAll(lstApproveActionPlan);
            //update lstApproveActionPlan;
         //if(!lstUpdateMFApproveActionPlan.isEmpty())
         	//lstApproveActionPlanUpdateAll.addAll(lstUpdateMFApproveActionPlan);
            //update lstUpdateMFApproveActionPlan;
         //if(!lstUpdateGIApproveActionPlan.isEmpty())
         	//lstApproveActionPlanUpdateAll.addAll(lstUpdateGIApproveActionPlan);
            //update lstUpdateGIApproveActionPlan;
            
          if(!lstApproveActionPlanUpdateAll.isEmpty())  
          	update lstApproveActionPlanUpdateAll;
    } 
   
   
    /**
    * @Description: Add new record for suggested Lumpsum 
    * param: None 
    * return type: PageReference 
    */ 
    //Commented on 19/12/13 : Aditi Satpute
    /*public pageReference addNewSuggLump()
    {
       ApprovedPlanBean.SuggestedMFLumpSum tmpObj = serviceObj.AddNewSuggMFLump(beanObj);
       beanObj.SuggestedMFLumpSumList.add(tmpObj);
       return null;
    }*/ 
    
    /**
    * @Description: Add new record for sip FUNDS of New Action Plan
    * param: None 
    * return type: PageReference 
    */
    public pageReference addNewSIPFund()
    {
       
       addNewGoalId = apexPages.currentPage().getParameters().get('addNewGoalId');
       
       serviceObj = new ActionPlanServices();
       
       for(ApprovedPlanBean.GoalDetails obj : beanObj.lstGoalDetails)
       {
            if(addNewGoalId == obj.goalId)
            {
                for(Integer iCount = 0; iCount < 2 ;iCount ++)
                {
                    ApprovedPlanBean.SIPFunds objSIPFunds = serviceObj.AddNewSIPFunds(beanObj);
                    objSIPFunds.execTracker = false;
            		objSIPFunds.executionTracker = 'No';
                    obj.lstSIPFunds.add(objSIPFunds);
                }
                break;
            }
       }
       
       if(addNewGoalId == beanObj.objEmergencyFundGoalDetails.goalId)
       {
            for(Integer iCount = 0; iCount < 2 ;iCount ++)
            {
                ApprovedPlanBean.SIPFunds objAddNewSIPFunds = serviceObj.AddNewSIPFunds(beanObj);
                objAddNewSIPFunds.execTracker = false;
        		objAddNewSIPFunds.executionTracker = 'No';
                beanObj.objEmergencyFundGoalDetails.lstSIPFunds.add(objAddNewSIPFunds);
            }
       }
       return null;
    } 
   
   
    /**
    * @Description: Add new record for Lumpsum FUNDS of New Action Plan
    * param: None 
    * return type: PageReference 
    */
    public pageReference addNewLumpsumFund()
    {
        
        addNewLumpsumGoalId = apexPages.currentPage().getParameters().get('addNewLumpsumGoalId');
        serviceObj = new ActionPlanServices();
        for(ApprovedPlanBean.GoalDetails obj : beanObj.lstGoalDetails)
        {
            if(addNewLumpsumGoalId == obj.goalId)
            {
                for(Integer iCount = 0; iCount < 2 ;iCount ++)
                {
                    ApprovedPlanBean.LumpsumFunds objLumpsumFunds = serviceObj.AddNewLumpsumFunds(beanObj);
                    objLumpsumFunds.lumpsumExecTracker = false;
        			objLumpsumFunds.lumpsumExecutionTracker = 'No';
                    obj.lstLumpsumFunds.add(objLumpsumFunds);
                }
                break;
            }
        }
       
        if(addNewLumpsumGoalId == beanObj.objEmergencyFundGoalDetails.goalId)
        {
            for(Integer iCount = 0; iCount < 2 ;iCount ++)
            {
                ApprovedPlanBean.LumpsumFunds objLumpsumFunds = serviceObj.AddNewLumpsumFunds(beanObj);
                objLumpsumFunds.lumpsumExecTracker = false;
        		objLumpsumFunds.lumpsumExecutionTracker = 'No';
                beanObj.objEmergencyFundGoalDetails.lstLumpsumFunds.add(objLumpsumFunds);
            }
        }
       return null;
    } 
   
   
    /**
    * @Description: Add new record for suggested SIP
    * param: None 
    * return type: PageReference 
    */ 
    //Commented on 19/12/13 : Aditi Satpute
    /*public pageReference addNewSuggSIP()
    {
       ApprovedPlanBean.SuggestedMFSIP tmpObj = serviceObj.AddNewSuggMFSIP(beanObj);
       beanObj.suggestedMFSIPList.add(tmpObj);
       return null;
    } */
   
     
    /**
    * @Description: Remove record for suggested Lumsum
    * param: None 
    * return type: PageReference 
    */ 
   public pageReference RemoveRecordLump()
   {
   		serviceObj = new ActionPlanServices();
        serviceObj.RemoveRecordLump(beanObj);
        return null;
   }
   
      
    /**
    * @Description: Remove record for suggested SIP
    * param: None 
    * return type: PageReference 
    */ 
    
    public void RemoveRecordSIP()
    {
    	serviceObj = new ActionPlanServices();
        serviceObj.RemoveRecordSIPFunds(beanObj);
    }
    
    /**Added on : 19/2/2013 : Aditi Satpute
    * @Description: Remove record for Life Insurance
    * param: None 
    * return type: PageReference 
    */ 
    public void removeNewGIrecords()
    { 
   		Integer generalInsuranceCount = 0;
        List<Integer> GIRemoveList = new List<Integer>();
        
        for(ApprovedPlanBean.GeneralInsurance objNewGeneralInsurance: beanObj.lstNewGeneralInsurance)
        {
        	if(objNewGeneralInsurance.isRemove)
    		{
            	GIRemoveList.add(generalInsuranceCount);
    		}
   		 	generalInsuranceCount++;
        }
        for(integer i=GIRemoveList.size();i>0;i--)
        {
        	beanObj.lstNewGeneralInsurance.remove(GIRemoveList.get(i-1));
     	}
        
    }
    
      
    /**Added on : 25/10/2013 : Aditi Satpute
    * @Description: Remove record for Life Insurance
    * param: None 
    * return type: PageReference 
    */ 
    public void removeNewLIrecords()
    { 
   		 Integer lifeInsuranceCount = 0;
        List<Integer> LIRemoveList = new List<Integer>();
        
        for(ApprovedPlanBean.LifeInsurance objNewLifeInsurance: beanObj.lstNewLifeInsurance)
        {
        	if(objNewLifeInsurance.isRemove)
    		{
            	LIRemoveList.add(lifeInsuranceCount);
    		}
   		 	lifeInsuranceCount++;
        }
        for(integer i=LIRemoveList.size();i>0;i--)
        {
        	beanObj.lstNewLifeInsurance.remove(LIRemoveList.get(i-1));
     	}
        
    }  
      
    /**
    * @Description: get scheme names from approved plan object
    * param: None 
    * return type: List<selectOption>
    */ 
     //Commented on 19/12/13 : Aditi Satpute
   	/*public List<selectOption> getSchemeNames()
   	{
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult field = Schema.sObjectType.Approved_Action_Plan__c.fields.Scheme_Name__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        for(Schema.PicklistEntry p : picklist) 
        {
            options.add(new selectOption(p.getLabel(), p.getLabel()));
        }
        
        return options;
    }*/
    
    /**
    * @Description: get SIP Actions from approved plan object
    * param: None 
    * return type: List<selectOption>
    */ 
    public List<selectOption> getSipActions()
    {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult field = Schema.sObjectType.Approve_Action_Plan__c.fields.SIP_Action__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        for(Schema.PicklistEntry p : picklist) 
        {
            options.add(new selectOption(p.getLabel(), p.getLabel()));
        }
        
        return options;
    }
    
    /**
    * @Description: get Suggested Lumpsum Actions from approved plan object
    * param: None 
    * return type: List<selectOption>
    */ 
    //Commented on 19/12/13 : Aditi Satpute
    /*public List<selectOption> getSugLumpActions()
    {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult field = Schema.sObjectType.Approved_Action_Plan__c.fields.Suggested_LumpSum_Action__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        
        for(Schema.PicklistEntry p : picklist) 
        {
            options.add(new selectOption(p.getLabel(), p.getLabel()));
        }
        
        return options;
    }*/
    
    /**
    * @Description: get Current Lumpsum Actions from approved plan object
    * param: None 
    * return type: List<selectOption>
    */
    public List<selectOption> getLumpActions()
    {
       List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult field = Schema.sObjectType.Approve_Action_Plan__c.fields.Lumpsum_Action__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        //Added on:18/02/2013 : Aditi Satpute : AP changes
        options.add(new selectOption('', '--None--'));
        for(Schema.PicklistEntry p : picklist) 
        {
            options.add(new selectOption(p.getLabel(), p.getLabel()));
        }
        
        return options;
    }
    
    /**
    * @Description: Prepare asset class
    * param: None 
    * return type: List<selectOption>
    */ 
    public List<selectOption> getAssetClass()
    {
         List<selectOption> options = new List<selectOption>();
         options.add(new selectOption('Gold', 'Gold'));        
         options.add(new selectOption('Equity', 'Equity'));
         options.add(new selectOption('Debt', 'Debt'));
         options.add(new selectOption('Hybrid', 'Hybrid'));
         return options;
    }
    
    /**
    * @Description: Get family details for parent entity
    * param: None 
    * return type: List<selectOption>
    */ 
    public List<selectOption> getEntities()
    {
        List<selectOption> options = new List<selectOption>();
        for(Account acc: beanObj.accList) 
        {
            options.add(new selectOption(acc.FirstName + ' '+ acc.LastName, acc.FirstName + ' '+ acc.LastName));
        }
        
        return options;
        
    }
    
     /**
    * @Description: to get transaction type of SIP Funds
    * param: None 
    * return type: List<selectOption>
    */ 
    public List<selectOption> getSIPTransactionType()
    {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('Existing SIP- COB', 'Existing SIP- COB'));
        options.add(new selectOption('New SIP', 'New SIP'));
        options.add(new selectOption('Existing SIP', 'Existing SIP'));  
        return options;
    }
    
     /**
    * @Description: to get transaction type of Lumpsum Funds
    * param: None 
    * return type: List<selectOption>
    */ 
    public List<selectOption> getLumpsumTransactionType()
    {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('Lumpsum', 'Lumpsum'));
        options.add(new selectOption('STP From', 'STP From'));
        options.add(new selectOption('STP To', 'STP To'));  
        options.add(new selectOption('Hold - COB', 'Hold - COB'));  
        options.add(new selectOption('Switch From', 'Switch From'));  
        options.add(new selectOption('Switch To', 'Switch To'));  
        options.add(new selectOption('Hold', 'Hold'));  
        return options;
    }
    
    /**
    * @Description: Prepare ExecutionTacker class
    * param: None 
    * return type: List<selectOption>
    */ 
    public List<selectOption> getExecutionTracker()
    {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('Yes', 'Yes'));
        options.add(new selectOption('No', 'No'));
        
        return options;
    }
    
    /**
    * @Description: to get options of SIP Funds
    * param: None 
    * return type: List<selectOption>
    */ 
    public List<selectOption> getOptions()
    {
        List<selectOption> options = new List<selectOption>();
        options.add(new selectOption('Growth', 'Growth'));
        options.add(new selectOption('Dividend Reinvestment', 'Dividend Reinvestment'));
         options.add(new selectOption('Dividend Payout', 'Dividend Payout'));
        return options;
    }
    
    /**
    * @Description: Redirect to Summary action plan
    * param: None 
    * return type: pageReference
    */ 
     public pageReference SummaryActionPlanPage()
     {
        pageReference pageRef = new pageReference('/apex/SummaryActionPlanPage?entityId='+beanObj.entityId+'&tabname=Financial Planning');
        return pageRef ;
     }
    
     public pageReference actionPlanPDF()
     {
        pageReference pageRef = new pageReference('/apex/ActionPlanPDF?entityId='+beanObj.entityId+'&tabname=Financial Planning');
        return pageRef ;
     }
    
    /*
      Adding new blank Row in current mutual fund
    */
     private Integer countNewRecord = 1;
     public void addCurrentMutualFundRow()
     {
        toDisplayFields = false;
        ApprovedPlanBean.CurrentMutualFunds objAddNewCurrentMutualFunds = new ApprovedPlanBean.CurrentMutualFunds();
        
        ApprovedPlanBean.CurrentMutualFunds objlastRecordCurrentMutualFunds = new ApprovedPlanBean.CurrentMutualFunds();
        
        List<ApprovedPlanBean.CurrentMutualFunds> lstAddNewCurrentMutualFunds = new List<ApprovedPlanBean.CurrentMutualFunds>();
        
        //===========Added on 30/11/2012 : for Retrieving Family member
        dbSOQLObj = new DatabaseSOQL(); 
        List<Account> lstAcc = dbSOQLObj.getFamilyMembers(beanObj.entityId);
        set<Id> familyIdSet = new set<Id>(); 
        for(Account objAcc : lstAcc)
        {
            familyIdSet.add(objAcc.Id);
        }
        //==============================================================
        Map<Id,Investment_Asset__c> mapIdToInvestmentAsset = new  Map<Id,Investment_Asset__c>
                                                             ([Select Entity__c, Entity__r.FirstName, Entity__r.LastName, Scheme_Name_Text__c , TotalAsset__c,
                                                               RecordType.Name, Asset_Type__c, Allocated_Amount__c, Action__c , Monthly_SIP_Amount__c 
                                                               From Investment_Asset__c  
                                                               where Entity__c =: familyIdSet //Added on 30/11/2012
                                                               //where Entity__c =: beanObj.entityId 
                                                               and RecordType.Name = 'Mutual Fund' ]);
      
        Investment_Asset__c objInvestment = new Investment_Asset__c();
        
        Integer lastRecord = 0;
        List<ApprovedPlanBean.CurrentMutualFunds> lstCMF = new List<ApprovedPlanBean.CurrentMutualFunds>();
        Double totalAmount = 0.0;
        for(Id investmentId : beanObj.mapIdToCurrentFunds.keySet())
        {
            
            if(investmentId == addNewInvestId)
            {
                
                if(mapIdToInvestmentAsset.containsKey(investmentId))
                {
                    lstCMF = beanObj.mapIdToCurrentFunds.get(investmentId);
                    objInvestment = mapIdToInvestmentAsset.get(investmentId);
                    for(ApprovedPlanBean.CurrentMutualFunds objMF : lstCMF)
                    {
                        totalAmount += objMF.actionAmount;
                    }
                    if(Math.ceil(objInvestment.TotalAsset__c) <= Math.ceil(totalAmount))
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Total Action Amount "'
                        	+Math.ceil(totalAmount)+'" of Mutual Fund-Lumpsum scheme "'+objInvestment.Scheme_Name_Text__c+'" cannot be greater than Amount "'+Math.ceil(objInvestment.TotalAsset__c)+'".'));
                        return;
                    }
                    objlastRecordCurrentMutualFunds = lstCMF[lstCMF.size() - 1];
                    system.debug('-------objlastRecordCurrentMutualFunds.amount-----'+objlastRecordCurrentMutualFunds.amount);
                    system.debug('-------objlastRecordCurrentMutualFunds.actionAmount-----'+objlastRecordCurrentMutualFunds.actionAmount);
                    objAddNewCurrentMutualFunds.amount = objlastRecordCurrentMutualFunds.amount - objlastRecordCurrentMutualFunds.actionAmount;
                    objAddNewCurrentMutualFunds.schemeName = objlastRecordCurrentMutualFunds.schemeName;
                    objAddNewCurrentMutualFunds.assetClass = objlastRecordCurrentMutualFunds.assetClass;
                    objAddNewCurrentMutualFunds.actionAmount = 0.0;
                    //objAddNewCurrentMutualFunds.SIPexecutionTracker = 'No';
                    //objAddNewCurrentMutualFunds.amount = objInvestment.TotalAsset__c;
                    //Commented on:18/02/2013 : Aditi Satpute : AP changes
                    //objAddNewCurrentMutualFunds.lumpsumAction = 'Hold - Change of broker';
                      //Added on:18/02/2013 : Aditi Satpute : AP changes
                    objAddNewCurrentMutualFunds.lumpsumAction = '--None--';  
                    objAddNewCurrentMutualFunds.account = objlastRecordCurrentMutualFunds.account;
                    objAddNewCurrentMutualFunds.investmentId = investmentId;
                    objAddNewCurrentMutualFunds.owner = objlastRecordCurrentMutualFunds.owner;
                    objAddNewCurrentMutualFunds.newCount = countNewRecord++;
                    objAddNewCurrentMutualFunds.isNewMutualFund = true;
                    objAddNewCurrentMutualFunds.ETSTatus = Label.ET_NotCreated;
                    if(objlastRecordCurrentMutualFunds.actionAmount <= 0.0)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Mutual Fund Action Amount should be greater than Zero'));
                        return;
                    }
                    
                    else
                    {
                        if(beanObj.mapIdToCurrentFunds.containsKey(investmentId))
                        {
                        	
                            lstAddNewCurrentMutualFunds = beanObj.mapIdToCurrentFunds.get(investmentId);
                            system.debug('--------in if------lstAddNewCurrentMutualFunds--'+lstAddNewCurrentMutualFunds);
                            lstAddNewCurrentMutualFunds.add(objAddNewCurrentMutualFunds);
                            beanObj.mapIdToCurrentFunds.put(investmentId,lstAddNewCurrentMutualFunds);
                        }
                    }
                    
                }
                break;
            }
       }
    }
     
   /*-------------------------Prajakta - 19-8-2013---------------------------------------------------------------------------
      Adding new blank Row in current Gold Silver
    */
     private Integer countNewGoldRecord = 1;
     public void addCurrentGoldSilverRow()
     {
        toDisplayFields = false;
        ApprovedPlanBean.CurrentGoldSilver objAddNewCurrentGoldSilver = new ApprovedPlanBean.CurrentGoldSilver();
        
        ApprovedPlanBean.CurrentGoldSilver objlastRecordCurrentGoldSilver = new ApprovedPlanBean.CurrentGoldSilver();
        
        List<ApprovedPlanBean.CurrentGoldSilver> lstAddNewCurrentGoldSilver = new List<ApprovedPlanBean.CurrentGoldSilver>();
        
        //===========Added on 30/11/2012 : for Retrieving Family member
        dbSOQLObj = new DatabaseSOQL(); 
        List<Account> lstAcc = dbSOQLObj.getFamilyMembers(beanObj.entityId);
        set<Id> familyIdSet = new set<Id>(); 
        for(Account objAcc : lstAcc)
        {
            familyIdSet.add(objAcc.Id);
        }
        //==============================================================
        Map<Id,Investment_Asset__c> mapIdToInvestmentAsset = new  Map<Id,Investment_Asset__c>
                                                           ([Select Monthly_SIP_Amount__c, Entity__c, Asset_Type__c, 
																	Entity__r.FirstName, Entity__r.LastName, Asset_Name__c, TotalAsset__c ,
																	RecordType.Name, Allocated_Amount__c,  Action__c 
															From Investment_Asset__c  
															where  Entity__c =: familyIdSet
															and  RecordType.Name = 'Gold and Silver']);
      
        Investment_Asset__c objInvestment = new Investment_Asset__c();
        
        Integer lastRecord = 0;
        List<ApprovedPlanBean.CurrentGoldSilver> lstCMF = new List<ApprovedPlanBean.CurrentGoldSilver>();
        Double totalAmount = 0.0;
        for(Id investmentId : beanObj.mapIdToCurrentGold.keySet())
        {
            
            if(investmentId == addNewInvestId)
            {
                
                if(mapIdToInvestmentAsset.containsKey(investmentId))
                {
                    lstCMF = beanObj.mapIdToCurrentGold.get(investmentId);
                    objInvestment = mapIdToInvestmentAsset.get(investmentId);
                    for(ApprovedPlanBean.CurrentGoldSilver objMF : lstCMF)
                    {
                        totalAmount += objMF.actionAmount;
                    }
                    if(Math.ceil(objInvestment.TotalAsset__c) <= Math.ceil(totalAmount))
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Total Action Amount "'
                        	+Math.ceil(totalAmount)+'" of Gold and Silver-Lumpsum scheme "'+objInvestment.Scheme_Name_Text__c+'" cannot be greater than Amount "'+Math.ceil(objInvestment.TotalAsset__c)+'".'));
                        return;
                    }
                    objlastRecordCurrentGoldSilver = lstCMF[lstCMF.size() - 1];
                    
                    objAddNewCurrentGoldSilver.amount = objlastRecordCurrentGoldSilver.amount - objlastRecordCurrentGoldSilver.actionAmount;
                    objAddNewCurrentGoldSilver.schemeName = objlastRecordCurrentGoldSilver.schemeName;
                    objAddNewCurrentGoldSilver.assetClass = objlastRecordCurrentGoldSilver.assetClass;
                    objAddNewCurrentGoldSilver.actionAmount = 0.0;
                    objAddNewCurrentGoldSilver.lumpsumAction = '--None--';  
                    objAddNewCurrentGoldSilver.account = objlastRecordCurrentGoldSilver.account;
                    objAddNewCurrentGoldSilver.investmentId = investmentId;
                    objAddNewCurrentGoldSilver.owner = objlastRecordCurrentGoldSilver.owner;
                    objAddNewCurrentGoldSilver.newCount = countNewGoldRecord++;
                    objAddNewCurrentGoldSilver.isNewGoldSilver = true;
                    objAddNewCurrentGoldSilver.ETSTatus = Label.ET_NotCreated;
                    
                    if(objlastRecordCurrentGoldSilver.actionAmount <= 0.0)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Gold and Silver Action Amount should be greater than Zero'));
                        return;
                    }
                    
                    else
                    {
                        if(beanObj.mapIdToCurrentGold.containsKey(investmentId))
                        {
                            lstAddNewCurrentGoldSilver = beanObj.mapIdToCurrentGold.get(investmentId);
                            lstAddNewCurrentGoldSilver.add(objAddNewCurrentGoldSilver);
                            beanObj.mapIdToCurrentGold.put(investmentId,lstAddNewCurrentGoldSilver);
                        }
                    }
                }
                break;
            }
       }
    }
     
    /*--------------------------------------------------------------------------
        Remove the newly added row of current gold & silver
    */
    public String removeInvestmentGoldId {get;set;}
    public Integer recordNumberGold {get;set;}
    
    public void removeCurrentGoldSilverRow()
    {
        List<ApprovedPlanBean.CurrentGoldSilver> lstAddNewCurrentGoldSilver = new List<ApprovedPlanBean.CurrentGoldSilver>();
        lstAddNewCurrentGoldSilver = beanObj.mapIdToCurrentGold.get(removeInvestmentGoldId);
        Integer index = 0;
        for(ApprovedPlanBean.CurrentGoldSilver objCMF: lstAddNewCurrentGoldSilver)
        {
            if(objCMF.newCount == recordNumberGold && objCMF.isNewGoldSilver)
            {
                break;
            }
            index++;
        }
        
        ApprovedPlanBean.CurrentGoldSilver objCurrentGoldSilver = new ApprovedPlanBean.CurrentGoldSilver();
        objCurrentGoldSilver = lstAddNewCurrentGoldSilver[index];
        
        for(Integer i = index +1 ; i < lstAddNewCurrentGoldSilver.size() ; i++)
        {
            lstAddNewCurrentGoldSilver[i].amount += objCurrentGoldSilver.actionAmount;
        }
        
        lstAddNewCurrentGoldSilver.remove(index);
        beanObj.mapIdToCurrentGold.put(removeInvestmentGoldId, lstAddNewCurrentGoldSilver);
    }
    /*---------------------------------------------End - Prajakta-----------------------------------------------*/
     
     /* 
         //Added on : 25/2/2013 : Aditi Satpute : Add new button for Life Insurance
    */
     private Integer countNewLIRecord = 1;
     public void addNewLifeInsuranceRow()
     {
     	toDisplayFields = false;
     	ApprovedPlanBean.LifeInsurance objnewLifeInsurance = new ApprovedPlanBean.LifeInsurance();
     	ApprovedPlanBean.LifeInsurance objLastRecordLifeInsurance = new ApprovedPlanBean.LifeInsurance();
     	//: beanObj.lstLifeInsurance
        List<ApprovedPlanBean.LifeInsurance> lstAddNewLifeInsuracne = new List<ApprovedPlanBean.LifeInsurance>();
        Insurance__c objInsurance = new Insurance__c();
        //===========Added on 30/11/2012 : for Retrieving Family member
        dbSOQLObj = new DatabaseSOQL(); 
        List<Account> lstAcc = dbSOQLObj.getFamilyMembers(beanObj.entityId);
        set<Id> familyIdSet = new set<Id>(); 
        for(Account objAcc : lstAcc)
        {
            familyIdSet.add(objAcc.Id);
        }
        //==============================================================
        List<Insurance__c> lstInsurance = dbSOQLObj.getAnalysisInsurances(InsuranceRecTypes__c.getInstance('Life Insurance').RecordTypeId__c, beanObj.accList);
    	Map<Id,Insurance__c> MapIdToInsurance = new Map<Id,Insurance__c>();
    
   	 	for(Insurance__c objLifeInsurance : lstInsurance)
    	{
    		if(!MapIdToInsurance.containsKey(objLifeInsurance.Id))
    		{
    			MapIdToInsurance.put(objLifeInsurance.Id,objLifeInsurance);
    		}
    	}
	    Integer lastRecord = 0;
	    Long totalSumAssuredAmount = 0;
        List<ApprovedPlanBean.LifeInsurance> lstLastLifeInsuracne = new List<ApprovedPlanBean.LifeInsurance>();
          
       	for(Id idInsurance : MapIdToInsurance.keySet())
    	{
            if(idInsurance == addNewLifeInsuranceId)
            {
                if(MapIdToInsurance.containsKey(idInsurance))
                {
                    lstLastLifeInsuracne = beanObj.mapIdToLifeInsuranceInnerClass.get(idInsurance);
                    objInsurance = MapIdToInsurance.get(idInsurance);
                    for(ApprovedPlanBean.LifeInsurance objLI : lstLastLifeInsuracne)
                    {
                        totalSumAssuredAmount += objLI.sumAssured;
                    }
                    if(Math.ceil(objInsurance.Suggested_Cover_General_Insurance__c) <= Math.ceil(totalSumAssuredAmount))
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Sum Assured value of Life Insurance cannot exceed Suggested Cover value'));
                        return;
                    }	
                    objLastRecordLifeInsurance = lstLastLifeInsuracne[lstLastLifeInsuracne.size() - 1];
                    system.debug('***objLastRecordLifeInsurance******'+objLastRecordLifeInsurance);
                    objnewLifeInsurance.suggestedCover = objLastRecordLifeInsurance.suggestedCover - objLastRecordLifeInsurance.sumAssured;
                    if(objnewLifeInsurance.suggestedCover != null && objnewLifeInsurance.suggestedCover != 0)
                   	objnewLifeInsurance.strSuggestedCover = objnewLifeInsurance.suggestedCover.format();
                    objnewLifeInsurance.insured = objLastRecordLifeInsurance.insured;
                    objnewLifeInsurance.policyType = objLastRecordLifeInsurance.policyType;
                    objnewLifeInsurance.sumAssured = 0;
                    objnewLifeInsurance.policyName = '';
                    objnewLifeInsurance.premiumAmount = 0;
                 	objnewLifeInsurance.tenureOfInsurance = 0.0;
                 	objnewLifeInsurance.insuranceRemark = '';
                    objnewLifeInsurance.insuranceId = idInsurance;
                    objnewLifeInsurance.newCount = countNewRecord++;
                    objnewLifeInsurance.isNewLI = true;
                    objnewLifeInsurance.ETSTatus = Label.ET_NotCreated;
                    
                    if(objLastRecordLifeInsurance.sumAssured <= 0)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Life Insurance Sum Assured value should be greater than Zero'));
                        return;
                    }
                    else
                    {
                        if(beanObj.mapIdToLifeInsuranceInnerClass.containsKey(idInsurance))
                        {
                            lstAddNewLifeInsuracne = beanObj.mapIdToLifeInsuranceInnerClass.get(idInsurance);
                            lstAddNewLifeInsuracne.add(objnewLifeInsurance);
                            beanObj.mapIdToLifeInsuranceInnerClass.put(idInsurance,lstAddNewLifeInsuracne);
                        }
                    }
                    
                }
                  system.debug('****beanObj.mapIdToLifeInsuranceInnerClass**'+beanObj.mapIdToLifeInsuranceInnerClass);
                break;
            }
       }
     } 
    public String removeInsuranceId {get;set;}
    public Integer insuranceRecordNumber {get;set;}
    /*
       Added on : 25/2/2013 : Aditi Satpute : Remove the new add row of Life insurance 
    */
    public void removeLifeInsuracneRow()
    {
        List<ApprovedPlanBean.LifeInsurance> lstAddNewLifeInsurance = new List<ApprovedPlanBean.LifeInsurance>();
        system.debug('*****removeInsuranceId****'+removeInsuranceId);
        system.debug('*****insuranceRecordNumber****'+insuranceRecordNumber);
        lstAddNewLifeInsurance = beanObj.mapIdToLifeInsuranceInnerClass.get(removeInsuranceId);
        Integer index = 0;
        for(ApprovedPlanBean.LifeInsurance objLI: lstAddNewLifeInsurance)
        {
            if(objLI.newCount == insuranceRecordNumber && objLI.isNewLI)
            {
        	  	system.debug('*****in if****');
                break;
            }
            index++;
        }
        system.debug('*index****'+index);
        ApprovedPlanBean.LifeInsurance objLifeInsurance = new ApprovedPlanBean.LifeInsurance();
        objLifeInsurance = lstAddNewLifeInsurance[index];
        
           for(Integer i = index +1 ; i < lstAddNewLifeInsurance.size() ; i++)
        {
            lstAddNewLifeInsurance[i].suggestedCover += objLifeInsurance.sumAssured;
        }
        
        lstAddNewLifeInsurance.remove(index);
        beanObj.mapIdToLifeInsuranceInnerClass.put(removeInsuranceId, lstAddNewLifeInsurance);
    }
     
    public String removeInvestmentId {get;set;}
    public Integer recordNumber {get;set;}
    /*
        Remove the new add row of current mutual fund
    */
    public void removeCurrentMutualFundRow()
    {
        List<ApprovedPlanBean.CurrentMutualFunds> lstAddNewCurrentMutualFunds = new List<ApprovedPlanBean.CurrentMutualFunds>();
        lstAddNewCurrentMutualFunds = beanObj.mapIdToCurrentFunds.get(removeInvestmentId);
        Integer index = 0;
        for(ApprovedPlanBean.CurrentMutualFunds objCMF: lstAddNewCurrentMutualFunds)
        {
            if(objCMF.newCount == recordNumber && objCMF.isNewMutualFund)
            {
                break;
            }
            index++;
        }
        
        ApprovedPlanBean.CurrentMutualFunds objCurrentMutualFunds = new ApprovedPlanBean.CurrentMutualFunds();
        objCurrentMutualFunds = lstAddNewCurrentMutualFunds[index];
        
        for(Integer i = index +1 ; i < lstAddNewCurrentMutualFunds.size() ; i++)
        {
            lstAddNewCurrentMutualFunds[i].amount += objCurrentMutualFunds.actionAmount;
        }
        
        lstAddNewCurrentMutualFunds.remove(index);
        beanObj.mapIdToCurrentFunds.put(removeInvestmentId, lstAddNewCurrentMutualFunds);
    }
    
    /*
    	Prajakta - 10-12-2013
        Remove the new add row of current mutual fund
    */
  /*  public void removeGIdefaultProductRow()
    {
    	Integer index = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
    	system.debug('-------index--------'+index);
    	Integer mainIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('mainIndex'));
    	system.debug('-------mainIndex--------'+mainIndex + ' - '+beanObj);
    	system.debug('-------mainIndex---##-----'+beanObj.lstGeneralInsurance.size());
    	system.debug('-------mainIndex-**-------'+beanObj.lstGeneralInsurance[mainIndex].generalInsuranceList);
        if(mainIndex < beanObj.lstGeneralInsurance.size() && index < beanObj.lstGeneralInsurance[mainIndex].generalInsuranceList.size()) {
            beanObj.lstGeneralInsurance[mainIndex].generalInsuranceList.remove(index);
        }
    }
    
    public void removeNewGIdefaultProductRow()
    {
    	Integer index = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
    	Integer mainIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('mainIndex'));
        if(mainIndex < beanObj.lstNewGeneralInsurance.size() && index < beanObj.lstNewGeneralInsurance[mainIndex].generalInsuranceList.size()) {
            beanObj.lstNewGeneralInsurance[mainIndex].generalInsuranceList.remove(index);
        }
    }
    
    public void removeLIdefaultProductRow()
    {
    	Integer index = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
    	system.debug('-------index--------'+index);
    	Integer mainIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('mainIndex'));
    	system.debug('---LI---mainIndex--------'+mainIndex + ' - '+beanObj);
    	system.debug('---LI----mainIndex---##-----'+beanObj.lstLifeInsurance.size());
    	system.debug('----LI---mainIndex-**-------'+beanObj.lstLifeInsurance[mainIndex].lifeInsuranceList);
        if(mainIndex < beanObj.lstLifeInsurance.size() && index < beanObj.lstLifeInsurance[mainIndex].lifeInsuranceList.size()) 
        {
            beanObj.lstLifeInsurance[mainIndex].lifeInsuranceList.remove(index);
            system.debug('---after remove----mainIndex-**-------'+beanObj.lstLifeInsurance[mainIndex].lifeInsuranceList);
            system.debug('---after remove----mainIndex-**size-------'+beanObj.lstLifeInsurance.size());
        }
    }
    
    public void removeNewLIdefaultProductRow()
    {
    	Integer index = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
    	system.debug('-------index--------'+index);
    	Integer mainIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('mainIndex'));
    	system.debug('--newLI-----mainIndex--------'+mainIndex + ' - '+beanObj);
    	system.debug('--newLI-----mainIndex---##-----'+beanObj.lstNewLifeInsurance.size());
    	system.debug('---newLI----mainIndex-**-------'+beanObj.lstNewLifeInsurance[mainIndex].lifeInsuranceList);
        if(mainIndex < beanObj.lstNewLifeInsurance.size() && index < beanObj.lstNewLifeInsurance[mainIndex].lifeInsuranceList.size())
        {
            beanObj.lstNewLifeInsurance[mainIndex].lifeInsuranceList.remove(index);
            system.debug('---after remove----mainIndex-**-------'+beanObj.lstNewLifeInsurance[mainIndex].lifeInsuranceList);
            system.debug('---after remove----mainIndex-**size-------'+beanObj.lstNewLifeInsurance.size());
        }
    }*/
     
    /** Purpose : Created Function and added FistName and LastName in the select statement. **/
    public Account selectAccount()
    {
        Account objSelectedAcc = [select id,PlanGenerationDateFromSystem__c,LastName,FirstName from Account where Id =: beanObj.entityId];
        return objSelectedAcc;
    }
    
    public Map<ID,EntityRelatedAttachment__c>  getRelatedAttachmentMap(String idEntity)
    {
        Map<ID,EntityRelatedAttachment__c> MapofIdRelatedAttachment = new Map<ID,EntityRelatedAttachment__c>();
        for(EntityRelatedAttachment__c objRelatedAttachment :[select Id,Related_Entity__c from EntityRelatedAttachment__c where Related_Entity__c = : idEntity])
        {
            MapofIdRelatedAttachment.put(objRelatedAttachment.Related_Entity__c,objRelatedAttachment); 
        }
        return MapofIdRelatedAttachment; 
    }
    
    public pageReference saveActionPlanPDF()
    {
        Blob htmlBody;
        Blob pdfBody;
        PageReference AttachmentPlan;
        Attachment PlanAttachment;
        Account objSelectedAcc;
        String strEntityName;
        String strRelatedId;
        EntityRelatedAttachment__c objRelatedAttachment;
        
        if(beanObj.entityId != null)
        {   
            objSelectedAcc = selectAccount();
            Map<ID,EntityRelatedAttachment__c> MapofIdRelatedAttachment  = getRelatedAttachmentMap(beanObj.entityId);
            
            if(!MapofIdRelatedAttachment.isEmpty() && MapofIdRelatedAttachment.containsKey(beanObj.entityId))
                objRelatedAttachment =  MapofIdRelatedAttachment.get(beanObj.entityId);
                
            strEntityName = objSelectedAcc.FirstName; 
            
            if(objSelectedAcc.LastName != null)
                strEntityName  +=  '_' + objSelectedAcc.LastName;
        }
        try
        {
            AttachmentPlan = Page.ActionPlanPDF; //Page name
            AttachmentPlan.getParameters().put('entityId',beanObj.entityId);
            AttachmentPlan.getParameters().put('displayButtons','0');
            AttachmentPlan.getParameters().put('isSendEmail','true');
                
            String strPlanName = 'Action_Plan_' + strEntityName + '_'+ system.NOW().format('dd-MM-yyyy hh:mm:ss');
            if(!Test.isRunningTest())
                pdfBody = AttachmentPlan.getContentAsPDF(); //get content in pdf format
            
            // Attach content as pdf file 
            PlanAttachment = new Attachment();
            if(objRelatedAttachment != null)
            PlanAttachment.ParentId = objRelatedAttachment.Id;
            PlanAttachment.Name = strPlanName + '.pdf'; //Name format of the PDF: Plan_EntityName_Date.pdf  
            PlanAttachment.Body = pdfBody;
            PlanAttachment.ContentType = '';
            insert PlanAttachment;
            
            PageReference pr = Page.ActionPlanHtml; //Page name
            pr.getParameters().put('entityId',entity);
            pr.getParameters().put('displayButtons','2');
            pr.getParameters().put('attachmentId',PlanAttachment.Id);
            
            htmlBody = pr.getContent(); //get content in html format
            

            // Attach content as html file          
            PlanAttachment = new Attachment();
            if(objRelatedAttachment != null)
            PlanAttachment.ParentId = objRelatedAttachment.Id;
            PlanAttachment.Name = strPlanName + '.htm'; //Name format of the HTML: Plan_EntityName_Date.htm  
            PlanAttachment.Body = htmlBody;
            PlanAttachment.ContentType = '';
            insert PlanAttachment;
            if(objSelectedAcc != null)
            {
                objSelectedAcc.PlanGenerationDateFromSystem__c = Date.today();
                update objSelectedAcc;     
            }
        }
        catch(System.Exception e)
        {
            error.DebugLog('==Error=='+e.getMessage());
        }
        isPreview = false;
      	pageReference pageRef = new pageReference('/apex/ActionPlan?entityId='+beanObj.entityId+'&tabname=Financial Planning');
       	pageRef.setRedirect(true);
        return pageRef ;
        return null;
        
    }
    
    public void makeRequiredOnSTPFrom()
    {
        //do nothing
    }
    
    public void showPreview()
    {
        isPreview = true;
    }
    
    public void showActionPlan()
    {
        isPreview = false;
        isSidebar = true;
    }
    public Pagereference sendEmail()
    {
        try
        {
            PageReference AttachmentPlan;
            Blob pdfBody;
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            AttachmentPlan = Page.ActionPlanPDF; //Page name
            AttachmentPlan.getParameters().put('entityId',entity);
            AttachmentPlan.getParameters().put('displayButtons','0');
            AttachmentPlan.getParameters().put('isSendEmail','true');
            pdfBody = AttachmentPlan.getContentAsPDF();
            efa.setFileName('Plan_'+system.NOW().format('dd-MM-yyyy hh:mm:ss')+'.pdf');
            efa.setBody(pdfBody);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            // Create the email attachment 
           
            List<String> toAddresses = new List<String>();
            //toAddresses.add('');
            //00001598 Add sender display name as entity owner
            Account objAccount = [Select Id, Name,PersonEmail,Email_Temp__c,OwnerId,owner.name,
            						FPA_Team_Member__r.Name,FPA_Team_Member__c 
            						from Account where Id =: entity];
            // Sets the paramaters of the email
             if(objAccount.PersonEmail != null)
                toAddresses.add(objAccount.PersonEmail);
             else
                toAddresses.add(objAccount.Email_Temp__c);
            
            //For toCcAddresses
       /*     List<String> toCcAddresses = new List<String>();
            List<String> toBccAddresses = new List<String>();
            Contact con;
            Account acc;
            String ppEmail;
            String BccEmail;
            Id AccOwnerId = objAccount.OwnerId;
            User user=[select Id,Email,Name,ProfileId,ContactId,Profile.Name from User where Id=:AccOwnerId];
            if(user.ContactId != null)
            {
                con = [select AccountId from Contact where id =: user.ContactId];
                acc = [select Id, Channel_Manager__r.Email, Name from account where id =: con.AccountId];
                BccEmail = acc.Channel_Manager__r.Email;
                System.debug('===BccEmail===='+BccEmail);   
                 if(BccEmail != null)
                toBccAddresses.add(BccEmail);
                email.setBccAddresses ( toBccAddresses );
                ppEmail = user.Email;
                if(ppEmail != null)
                toCcAddresses.add(ppEmail);
                email.setCcAddresses( toCcAddresses);
                
            }
           */
            email.setSubject( 'Plan for ' + objAccount.Name);       
            email.setToAddresses( toAddresses );
          
           
            if(emailBody != null && emailBody != '')
                email.setHtmlBody(emailBody.replaceAll('\n','<br/>'));
            else
                email.setHtmlBody('Dear '+objAccount.Name+'<br/><br/>Kindly find the attached pdf.');
                //email.setSenderDisplayName(objAccount.Owner.Name);
                if(objAccount.FPA_Team_Member__c != null)
		      		email.setSenderDisplayName(objAccount.FPA_Team_Member__r.Name);
		      	else
		      		email.setSenderDisplayName(UserInfo.getName());
		      		
                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            
            // Sends the email 
            Messaging.SendEmailResult [] arrResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            isMailSent = true;
        }
        catch(Exception e)
        {
            //strMessage = e.getMessage();
        }
        return null;
    }
    
    
    //Product Master
    /**
    * @Description: Get General Insurance details from Product 
    * param: None 
    * return type: List<selectOption>
    */ 
    /*public List<selectOption> getGeneralInsuranceProduct()
    {
        List<selectOption> options = new List<selectOption>();
        List<Product_Master__c> lstProduct = [select Id,Product_Name__c,ProductType__c,Is_Active__c 
                                                from Product_Master__c where ProductType__c = 'General Insurance' and Is_Active__c = true];
        for(Product_Master__c objProd: lstProduct) 
        {
            options.add(new selectOption(objProd.Id, objProd.Product_Name__c));
        }
        
        return options;
        
    }
    */
    
     public pageReference addNewGeneralInsurance()
     {
     	//isNewGeneralInsurance = true;
     	ActionPlanUtility objActionPlanUtility =  new ActionPlanUtility();
     	/*List<String> generalInsuranceList = new List<String>();
     	if(mapLifeInsTosetProducts.containsKey('General Insurance'))
		{
			generalInsuranceList = mapLifeInsTosetProducts.get('General Insurance');
		}*/
     	
        for(Integer iCount = 0; iCount < 1 ;iCount ++)
        {
            ApprovedPlanBean.GeneralInsurance objGeneralInsurance = new ApprovedPlanBean.GeneralInsurance();
            objGeneralInsurance.index = beanObj.lstNewGeneralInsurance.size();
            objGeneralInsurance.ETStatus = Label.ET_NotCreated;
            objGeneralInsurance.execTracker = false;
            objGeneralInsurance.executionTracker = 'No';
            //objGeneralInsurance.generalInsuranceList = generalInsuranceList;
            beanObj.lstNewGeneralInsurance.add(objGeneralInsurance);
        }
        /*Gaurav: (13-5-2013) : Call to the RetrieveInsurance method to get the Medical Insurance Product Name*/
       	strProductGeneralInsurance = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('General Insurance',returnActiveProductMasterList()));
     	return  null;
     }
     
     
     //Added on : 24/10/13 : Aditi Satpute : Capping Removal Changes
     public pageReference addNewLifeInsurance()
     {
     	/*List<String> lifeInsuranceList = new List<String>();
		
		if(mapLifeInsTosetProducts.containsKey('Life Insurance'))
		{
			lifeInsuranceList = mapLifeInsTosetProducts.get('Life Insurance');
		}*/
     	//isNewGeneralInsurance = true;
        for(Integer iCount = 0; iCount < 1 ;iCount ++)
        {
            ApprovedPlanBean.LifeInsurance objLifeInsurance = new ApprovedPlanBean.LifeInsurance();
            //objGeneralInsurance.index = beanObj.lstNewGeneralInsurance.size();
            objLifeInsurance.ETStatus = Label.ET_NotCreated;
            objLifeInsurance.execTracker = false;
            objLifeInsurance.executionTracker = 'No';
            objLifeInsurance.index = beanObj.lstNewLifeInsurance.size();
            //objLifeInsurance.lifeInsuranceList = lifeInsuranceList;
            beanObj.lstNewLifeInsurance.add(objLifeInsurance);
        }
        objActionPlanUtility = new ActionPlanUtility();
        /*Gaurav: (13-5-2013) : Call to the RetrieveInsurance method to get the Medical Insurance Product Name*/
       	strProductLifeInsurance = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Life Insurance',returnActiveProductMasterList()));
     	return  null;
     }
     
     
     public void calculatePremium()
     {
     	Account objAccount = new Account();
     	List<Account> spouseEntityList = new List<Account>();
     	List<Account> childEntityList = new List<Account>();
     	Decimal customerAge = 0;
        Decimal noOfSpouse = 0;
        Decimal noOfChild = 0; 
         
        objActionPlanUtility = new ActionPlanUtility();
     	for(Account objAcc : beanObj.accList)
     	{
     		if(objAcc.Id == beanObj.entityId)
            {
                objAccount = objAcc;
                customerAge = objAcc.Age__pc;
            }
            else if(objAcc.Relationship_to_Entity__pc == 'Wife' ||  objAcc.Relationship_to_Entity__pc == 'Husband')
            { 
            	spouseEntityList.add(objAcc);
            }
            else if(objAcc.Relationship_to_Entity__pc == 'Daughter' ||  objAcc.Relationship_to_Entity__pc == 'Son')
            {
            	childEntityList.add(objAcc); 
            }
     	}
                
        if(!spouseEntityList.isEmpty())
        	noOfSpouse =  spouseEntityList.size();
        if(!childEntityList.isEmpty())
        	noOfChild =  childEntityList.size();	
        /*String  strLIPolicyName = ApexPages.currentPage().getParameters().get('strLIPolicyName');	
        String  strGIPolicyName = ApexPages.currentPage().getParameters().get('strGIPolicyName');	
        String  index = ApexPages.currentPage().getParameters().get('index');	
        String insuranceId = ApexPages.currentPage().getParameters().get('insuranceId');	*/
         system.debug('---strLI_GI_index---'+strLI_GI_index);
        system.debug('------strLI_GI_insuranceId--------'+strLI_GI_insuranceId);
        system.debug('------ApexPages.currentPage().getParameters().get(strLI_GI_index) != null--------'+ApexPages.currentPage().getParameters().get('strLI_GI_index'));
        
        strLI_GI_Type = ApexPages.currentPage().getParameters().get('strLI_GI_Type') != null ? ApexPages.currentPage().getParameters().get('strLI_GI_Type') : strLI_GI_Type;
        strLI_GI_index = (ApexPages.currentPage().getParameters().get('strLI_GI_index') != null && ApexPages.currentPage().getParameters().get('strLI_GI_index') != '') ?
        	 Integer.valueOf(ApexPages.currentPage().getParameters().get('strLI_GI_index')) : strLI_GI_index; 
        strLI_GI_insuranceId = (ApexPages.currentPage().getParameters().get('strLI_GI_insuranceId') != null && ApexPages.currentPage().getParameters().get('strLI_GI_insuranceId') != '') ? 
        	 ApexPages.currentPage().getParameters().get('strLI_GI_insuranceId') : strLI_GI_insuranceId; 
        system.debug('---strLI_GI_index---'+strLI_GI_index);
        system.debug('------strLI_GI_insuranceId--------'+strLI_GI_insuranceId);
        if(strLI_GI_Type == 'LI')
        {
        	if(strLI_GI_insuranceId != null && strLI_GI_insuranceId != '')
        	{
		    	for(ApprovedPlanBean.LifeInsurance objLifeInsurance :  beanObj.lstLifeInsurance)
		        {
		        	if(objLifeInsurance.insuranceId == strLI_GI_insuranceId)
		        	{
		    			objLifeInsurance.premiumAmount = objActionPlanUtility.getProductPremiumAmount(objLifeInsurance.policyName,
		    					objLifeInsurance.sumAssured,customerAge,noOfSpouse,noOfChild); 
		        	}
		        	system.debug('-objLifeInsurance.premiumAmount--'+objLifeInsurance.premiumAmount);
		        }
        	}
        	else if(strLI_GI_index != null)
        	{
        		for(ApprovedPlanBean.LifeInsurance objnewLifeInsurance :  beanObj.lstNewLifeInsurance)
		        {
		        	if(objnewLifeInsurance.index == strLI_GI_index)
		        	{
		    			objnewLifeInsurance.premiumAmount = objActionPlanUtility.getProductPremiumAmount(objnewLifeInsurance.policyName,
		    					objnewLifeInsurance.sumAssured,customerAge,noOfSpouse,noOfChild);
		        	}
		        	system.debug('-objnewLifeInsurance.premiumAmount-'+objnewLifeInsurance.premiumAmount);
		        }
        	}
        }
        else if(strLI_GI_Type == 'GI')
        {
        	if(strLI_GI_insuranceId != null && strLI_GI_insuranceId != '')
        	{
        		for(ApprovedPlanBean.GeneralInsurance objGeneralInsurance :  beanObj.lstGeneralInsurance)
		        {
		        	if(objGeneralInsurance.insuranceId == strLI_GI_insuranceId)
		        	{
		        		
	 	    			objGeneralInsurance.premiumAmount = objActionPlanUtility.getProductPremiumAmount(objGeneralInsurance.productName,
		    					objGeneralInsurance.sumAssured,customerAge,noOfSpouse,noOfChild);
						system.debug('-objGeneralInsurance.premiumAmount--'+objGeneralInsurance.premiumAmount);
		        	}
		        }
        	}
        	else if(strLI_GI_index != null)
        	{
		        for(ApprovedPlanBean.GeneralInsurance objnewGeneralInsurance :  beanObj.lstNewGeneralInsurance)
		        {
		        	if(objnewGeneralInsurance.index == strLI_GI_index)
		        	{
		        		
		    			objnewGeneralInsurance.premiumAmount = objActionPlanUtility.getProductPremiumAmount(objnewGeneralInsurance.productName,
		    				objnewGeneralInsurance.sumAssured,customerAge,noOfSpouse,noOfChild);
		    				system.debug('-objnewGeneralInsurance.premiumAmount--'+objnewGeneralInsurance.premiumAmount);
		        	}
		        }
        	}
        }
        /*if(strLI_GI_index != null)
        {
        	for(ApprovedPlanBean.LifeInsurance objnewLifeInsurance :  beanObj.lstNewLifeInsurance)
	        {
	        	if(objnewLifeInsurance.index == strLI_GI_index)
	        	{
	    			objnewLifeInsurance.premiumAmount = objActionPlanUtility.getProductPremiumAmount(objnewLifeInsurance.policyName,
	    					objnewLifeInsurance.sumAssured,customerAge,noOfSpouse,noOfChild);
	        	}
	        }
	        for(ApprovedPlanBean.GeneralInsurance objnewGeneralInsurance :  beanObj.lstNewGeneralInsurance)
	        {
	        
	        	if(objnewGeneralInsurance.index == strLI_GI_index)
	        	{
	    			objnewGeneralInsurance.premiumAmount = objActionPlanUtility.getProductPremiumAmount(objnewGeneralInsurance.productName,
	    				objnewGeneralInsurance.sumAssured,customerAge,noOfSpouse,noOfChild);
	    				system.debug('-objnewGeneralInsurance.premiumAmount--'+objnewGeneralInsurance.premiumAmount);
	        	}
	        }
        }
        else if(strLI_GI_insuranceId != null && strLI_GI_insuranceId != '')
        {
        	for(ApprovedPlanBean.LifeInsurance objLifeInsurance :  beanObj.lstLifeInsurance)
	        {
	        	if(objLifeInsurance.insuranceId == strLI_GI_insuranceId)
	        	{
	    			objLifeInsurance.premiumAmount = objActionPlanUtility.getProductPremiumAmount(objLifeInsurance.policyName,
	    					objLifeInsurance.sumAssured,customerAge,noOfSpouse,noOfChild); 
	        	}
	        }
	        for(ApprovedPlanBean.GeneralInsurance objGeneralInsurance :  beanObj.lstGeneralInsurance)
		    {
		        if(objGeneralInsurance.insuranceId == strLI_GI_insuranceId)
		        {
	 	    		objGeneralInsurance.premiumAmount = objActionPlanUtility.getProductPremiumAmount(objGeneralInsurance.productName,
		    				objGeneralInsurance.sumAssured,customerAge,noOfSpouse,noOfChild);
					system.debug('-objGeneralInsurance.premiumAmount--'+objGeneralInsurance.premiumAmount);
		        }
		    }
        }*/
        //return null;
	 }
     
     //Added on : 5/12/13 : Aditi Satpute : Add On - Loan Related Changes
     public pageReference addNewLoan()
     {
        for(Integer iCount = 0; iCount < 1 ;iCount ++)
        {
            ApprovedPlanBean.Loan objLoan = new ApprovedPlanBean.Loan();
            objLoan.ETStatus = Label.ET_NotCreated; 
            objLoan.isAddOnExecTracker = false;
            objLoan.AddOnExecutionTracker = 'No';
            objLoan.index = beanObj.lstLoan.size();
            beanObj.lstLoan.add(objLoan);
        }
       	ActionPlanUtility objActionPlanUtility =  new ActionPlanUtility();
    	strProductLoan = objActionPlanUtility.getLoanProductName('Loan','Mortgage Loan',returnActiveProductMasterList());//objActionPlanUtility.lstProductMaster);
     	return  null;
     }
     
     
     /**Added on : 5/12/2013 : Aditi Satpute
    * @Description: Remove record for Loan
    * param: None 
    * return type: PageReference 
    */ 
    public void removeNewLoan()
    { 
   		Integer loanCount = 0;
        List<Integer> LoanRemoveList = new List<Integer>();
        
        for(ApprovedPlanBean.Loan objNewLoan: beanObj.lstLoan)
        {
        	if(objNewLoan.isRemove)
    		{
            	LoanRemoveList.add(loanCount);
    		}
   		 	loanCount++;
        }
        for(integer i=LoanRemoveList.size();i>0;i--)
        {
        	beanObj.lstLoan.remove(LoanRemoveList.get(i-1));
     	}
        
    }
    
     //Added on : 11/12/13 : Aditi Satpute : Add On - Fixed Deposit Related Changes
     public pageReference addNewFD()
     {
        for(Integer iCount = 0; iCount < 1 ;iCount ++)
        {
            ApprovedPlanBean.FixedDeposit objFixedDeposit = new ApprovedPlanBean.FixedDeposit();
            Approve_Action_Plan__c actionPlanFDobj = new Approve_Action_Plan__c();
            objFixedDeposit.ETStatus = Label.ET_NotCreated; 
            objFixedDeposit.actionPlanFDobj = actionPlanFDobj;	
            objFixedDeposit.actionPlanFDobj.isAddOnExecutionTracker__c = false;
            objFixedDeposit.AddOnExecutionTracker = 'No';
            objFixedDeposit.index = beanObj.lstFixedDeposit.size();
            beanObj.lstFixedDeposit.add(objFixedDeposit);
        }
    	
     	return  null;
     }
     /**Added on : 5/12/2013 : Aditi Satpute
    * @Description: Remove record for Fixed Deposit
    * param: None 
    * return type: PageReference 
    */ 
    public void removeNewFD()
    { 
   		Integer fixedDepositCount = 0;
        List<Integer> FixedDepositRemoveList = new List<Integer>();
        
        for(ApprovedPlanBean.FixedDeposit objNewFixedDeposit: beanObj.lstFixedDeposit)
        {
        	if(objNewFixedDeposit.isRemove)
    		{
            	FixedDepositRemoveList.add(fixedDepositCount);
    		}
   		 	fixedDepositCount++;
        }
        for(integer i=FixedDepositRemoveList.size();i>0;i--)
        {
        	beanObj.lstFixedDeposit.remove(FixedDepositRemoveList.get(i-1));
     	}
        
    }
     
     //Added on : 16/12/13 : Aditi Satpute : Add On - Bond Related Changes
     public pageReference addNewBond()
     {
        for(Integer iCount = 0; iCount < 1 ;iCount ++)
        {
            ApprovedPlanBean.Bond objBond = new ApprovedPlanBean.Bond();
            Approve_Action_Plan__c actionPlanBondObj = new Approve_Action_Plan__c();
            objBond.ETStatus = Label.ET_NotCreated; 
            objBond.actionPlanBondObj = actionPlanBondObj;	
            objBond.actionPlanBondObj.isAddOnExecutionTracker__c = false;
            objBond.AddOnExecutionTracker = 'No';
            objBond.index = beanObj.lstBond.size();
            beanObj.lstBond.add(objBond);
        }
       	//ActionPlanUtility objActionPlanUtility =  new ActionPlanUtility();
    	//strProductLoan = objActionPlanUtility.getLoanProductName('Loan','Mortgage Loan');
     	return  null;
     }
     
     /**Added on : 16/12/2013 : Aditi Satpute
    * @Description: Remove record for Bond
    * param: None 
    * return type: PageReference 
    */ 
    public void removeNewBond()
    { 
   		Integer bondCount = 0;
        List<Integer> bondRemoveList = new List<Integer>();
        
        for(ApprovedPlanBean.Bond objNewBond: beanObj.lstBond)
        {
        	if(objNewBond.isRemove)
    		{
            	bondRemoveList.add(bondCount);
    		}
   		 	bondCount++;
        }
        for(integer i=bondRemoveList.size();i>0;i--)
        {
        	beanObj.lstBond.remove(bondRemoveList.get(i-1));
     	}
        
    }
    /**
    * @Description: Prepare ExecutionTacker class
    * param: None 
    * return type: List<selectOption>
    */ 
  /*  public List<selectOption> getLoanType()
    {
    	List<Product_Master__c> PMLoanType = [select Id,Asset_Class__c,Investment_Type__c from Product_Master__c where Asset_Class__c = 'Loans'];
    	system.debug('---PMLoanType---'+PMLoanType);
    	Set<String> setLoanType = new Set<String>();
    	
    	for(Product_Master__c objPMLoan : PMLoanType)
    	{
    		setLoanType.add(objPMLoan.Investment_Type__c);
    	}
        List<selectOption> options = new List<selectOption>();
        for(String strLoanType: setLoanType) 
        {
            options.add(new selectOption(strLoanType,strLoanType));
        }
        return options;
    }
     */
     /**
    * @Description: Prepare ExecutionTacker class
    * param: None 
    * return type: List<selectOption>
    */ 
    public List<selectOption> getGoalType()
    {
        List<selectOption> options = new List<selectOption>();
        List<Goal__c> lstGoal = beanObj.goalList;
        for(Goal__c objGoal : lstGoal)
        {
            options.add(new selectOption(objGoal.Description__c,objGoal.Description__c));
        }
        options.add(new selectOption('Others','Others'));
        return options;
    }
    
     
     //Added by Aditi Satpute : To  add new Action Plan for that particualr Entity
    /*public pageReference generateNewAP()
     {
        List<Account> lstAcc = dbSOQLObj.getFamilyMembers(beanObj.entityId);
        set<Id> familyIdSet = new set<Id>(); 
        for(Account objAcc : lstAcc)
        {
            familyIdSet.add(objAcc.Id);
        }
        
        List<GoalSIPAmount__c> lstGoalSIPAmount = [Select SIP_Total__c, SIP_Gold__c, SIP_Equity__c, SIP_Debt__c, Goal__c 
                                                     From GoalSIPAmount__c 
                                                     where Goal__c = :beanObj.objEmergencyFundGoalDetails.goalId and isNewSIP__c = true];
        List<GoalSIPAmount__c> lstUpdateGoalSIPAmount = new List<GoalSIPAmount__c>();
        for(GoalSIPAmount__c objGoalSIP : lstGoalSIPAmount)
        {
            objGoalSIP.isNewSIP__c = false;
            lstUpdateGoalSIPAmount.add(objGoalSIP);
        }
        if(!lstUpdateGoalSIPAmount.isEmpty())        
        	update lstUpdateGoalSIPAmount;
        
        List<Approve_Action_Plan__c> lstApproveActionPlan = [Select Id,AP_Status__c From Approve_Action_Plan__c  
                                                                        where Account__c IN: familyIdSet and AP_Status__c = 'Opened'];
        List<Approve_Action_Plan__c> lstUpdateApprovePlan = new List<Approve_Action_Plan__c>();
        for(Approve_Action_Plan__c objApproveActionPlan : lstApproveActionPlan)     
        {
            objApproveActionPlan.AP_Status__c = 'Closed';
            lstUpdateApprovePlan.add(objApproveActionPlan);
        }                           
        if(!lstUpdateApprovePlan.isEmpty())                     
            update lstUpdateApprovePlan;
        List<Execution_Tracker__c> lstFilledExecutionTrackerRecord = [select Id, Agreed_Amount__c,Approve_Action_Plan__c,Approve_Action_Plan__r.Insurance__r.Policy_Type__c,
                                    Approve_Action_Plan__r.Insurance__r.Policy_Name__c,Approve_Action_Plan__r.Product_Name__c,ET_Status__c,Type__c,Application_Status__c,
                                    Approve_Action_Plan__r.Insurance__r.Sum_Assured_Rs__c,Approve_Action_Plan__r.Insurance__r.Premium_Amount_Rs__c  
                                    from Execution_Tracker__c where Entity_Name__c =: familyIdSet 
                                    and (Application_Status__c = 'Opened' OR Application_Status__c = '' OR Application_Status__c =: Label.Forms_Provided) 
                                    and  Is_Floating__c = false];
        if(!lstFilledExecutionTrackerRecord.isEmpty())                        
            delete lstFilledExecutionTrackerRecord;     
        isSave = true;      
        saveActionPlanPDF();
        pageReference pageRef = new pageReference('/apex/ActionPlan?entityId='+beanObj.entityId+'&tabname=Financial Planning');
        pageRef.setRedirect(true);
        return pageRef ;
                        
     }*/
     //Added on : 28/2/2013 : Aditi Satpute : To clone the existing Action Plan
    /*public pageReference cloneActionPlan()
     {
        List<Account> lstAcc = dbSOQLObj.getFamilyMembers(beanObj.entityId);
        set<Id> familyIdSet = new set<Id>(); 
        for(Account objAcc : lstAcc)
        {
            familyIdSet.add(objAcc.Id);
        }
        
        List<Execution_Tracker__c> lstProcessedAndClosedET = [select Id, Agreed_Amount__c,Approve_Action_Plan__c,Approve_Action_Plan__r.Insurance__r.Policy_Type__c,
                                    Approve_Action_Plan__r.Insurance__r.Policy_Name__c,Approve_Action_Plan__r.Product_Name__c,ET_Status__c,Type__c,Application_Status__c,
                                    Approve_Action_Plan__r.Insurance__r.Sum_Assured_Rs__c,Approve_Action_Plan__r.Insurance__r.Premium_Amount_Rs__c  
                                    from Execution_Tracker__c where Entity_Name__c =: familyIdSet and (Application_Status__c = 'Processed' OR Application_Status__c = 'Closed') and  Is_Floating__c = false];
   
        List<GoalSIPAmount__c> lstGoalSIPAmount = [Select SIP_Total__c, SIP_Gold__c, SIP_Equity__c, SIP_Debt__c, Goal__c 
                                                     From GoalSIPAmount__c 
                                                     where Goal__c = :beanObj.objEmergencyFundGoalDetails.goalId and isNewSIP__c = true];
                                                     
        List<GoalSIPAmount__c> lstUpdateGoalSIPAmount = new List<GoalSIPAmount__c>();
     	List<GoalSIPAmount__c> lstCloneGoalSIPAmount = new List<GoalSIPAmount__c>();
        for(GoalSIPAmount__c objGoalSIP : lstGoalSIPAmount)
        {
        	GoalSIPAmount__c objCloneGoalSIP = objGoalSIP.clone();
            lstCloneGoalSIPAmount.add(objCloneGoalSIP);
        }
        
        for(GoalSIPAmount__c objGoalSIP : lstGoalSIPAmount)
        {
            objGoalSIP.isNewSIP__c = false;
            lstUpdateGoalSIPAmount.add(objGoalSIP);
        }
      	if(!lstUpdateGoalSIPAmount.isEmpty())  
        	update lstUpdateGoalSIPAmount;
      	if(!lstCloneGoalSIPAmount.isEmpty())  
      		insert lstCloneGoalSIPAmount;
      	
      	
      	String strApprovePlanQuery = 'select ';
		Map<String, Schema.SObjectField> mapApprovePlanFieldNameToFieldDescribe = Approve_Action_Plan__c.sObjectType.getDescribe().fields.getMap();
		for(String strField : mapApprovePlanFieldNameToFieldDescribe.keySet())
		{
			strApprovePlanQuery += strField +',';
		}

		strApprovePlanQuery += 'Account__r.Name from  Approve_Action_Plan__c where Account__c IN: familyIdSet and AP_Status__c = \'Opened\'';
      	
      	
      		
     	List<Approve_Action_Plan__c> lstApproveActionPlan = Database.query(strApprovePlanQuery);
     	Map<Id,Approve_Action_Plan__c> mapIDToApproveActionPlan = new Map<Id,Approve_Action_Plan__c>();
     	for(Approve_Action_Plan__c objAP : lstApproveActionPlan)
     	{
     		if(!mapIDToApproveActionPlan.containsKey(objAP.Id))
     		{
     			mapIDToApproveActionPlan.put(objAP.Id,objAP);
     		}
     	}
     	List<Approve_Action_Plan__c> lstUpdateActionPlanWithETrecords = new List<Approve_Action_Plan__c>();
     	Map<Id,Approve_Action_Plan__c> mapIdToAP = new Map<Id,Approve_Action_Plan__c>();
     	for(Execution_Tracker__c objET : lstProcessedAndClosedET)
     	{
     		
     		system.debug('*****in clone objET******'+objET);
     		if(mapIDToApproveActionPlan.containsKey(objET.Approve_Action_Plan__c))
     		{
     			Approve_Action_Plan__c objUpdateAPwithET = mapIDToApproveActionPlan.get(objET.Approve_Action_Plan__c);
     			
     			if(mapIdToAP.containsKey(objUpdateAPwithET.Id))
     			{
     				Approve_Action_Plan__c objAP =  mapIdToAP.get(objUpdateAPwithET.Id);
     				if(objET.Type__c == 'SIP')
	     			{
	     				system.debug('*****in if******');
	 				 	if(objAP.Investment_Asset__c != null)
	                 	{
	 						objAP.isMFsipETCreated__c = true;
	                 	}
	                 	else
	                 	{
	                 		objAP.isETcreated__c = true;
	                 	}
	     			}
	     			else
	     			{
	     				system.debug('*****in else******');
	     				objAP.isETcreated__c = true;
	     			}
	     			mapIdToAP.put(objUpdateAPwithET.Id,objAP);
     			}
     			else
     			{
     				if(objET.Type__c == 'SIP')
	     			{
	     				system.debug('*****in if******');
	 				 	if(objUpdateAPwithET.Investment_Asset__c != null)
	                 	{
	 						objUpdateAPwithET.isMFsipETCreated__c = true;
	                 	}
	                 	else
	                 	{
	                 		objUpdateAPwithET.isETcreated__c = true;
	                 	}
	     			}
	     			else
	     			{
	     				system.debug('*****in else******');
	     				objUpdateAPwithET.isETcreated__c = true;
	     			}
	     			mapIdToAP.put(objUpdateAPwithET.Id,objUpdateAPwithET);
     			}
     			
 				//lstUpdateActionPlanWithETrecords.add(objUpdateAPwithET);
     		} 
     	}
     	system.debug('*********lstUpdateActionPlanWithETrecords************'+lstUpdateActionPlanWithETrecords);
     	for(Approve_Action_Plan__c obj : mapIdToAP.values())
     	{
     		system.debug('*********obj************'+obj); 
     		lstUpdateActionPlanWithETrecords.add(obj);
     	}
     	
     	
     	if(!lstUpdateActionPlanWithETrecords.isEmpty())
     		update lstUpdateActionPlanWithETrecords;
     										
        List<Approve_Action_Plan__c> lstUpdateApprovePlan = new List<Approve_Action_Plan__c>();
        List<Approve_Action_Plan__c> lstCloneApprovePlan = new List<Approve_Action_Plan__c>();
        for(Approve_Action_Plan__c objApproveActionPlan : lstApproveActionPlan)     
        {
           	Approve_Action_Plan__c objCloneApproveActionPlan = objApproveActionPlan.clone();	
           	if(objCloneApproveActionPlan.isExecutionTracker__c)
 				objCloneApproveActionPlan.isExecutionTracker__c = false;
 			if(objCloneApproveActionPlan.isInsuranceExecutionTracker__c)
 				objCloneApproveActionPlan.isInsuranceExecutionTracker__c = false;
 			if(objCloneApproveActionPlan.isLumpsumExecTracker__c)
 				objCloneApproveActionPlan.isLumpsumExecTracker__c = false;
 			if(objCloneApproveActionPlan.isSIPexecutionTracker__c)
 				objCloneApproveActionPlan.isSIPexecutionTracker__c = false;
            lstCloneApprovePlan.add(objCloneApproveActionPlan);
        }                           
        system.debug('*********lstApproveActionPlan************'+lstApproveActionPlan);
        if(!lstCloneApprovePlan.isEmpty())
        	insert lstCloneApprovePlan;
        
        	system.debug('*********lstCloneApprovePlan************'+lstCloneApprovePlan);
        
        for(Approve_Action_Plan__c objApproveActionPlan : lstApproveActionPlan)     
        {
            objApproveActionPlan.AP_Status__c = 'Closed';
            lstUpdateApprovePlan.add(objApproveActionPlan);
        }                           
        if(!lstUpdateApprovePlan.isEmpty())                     
            update lstUpdateApprovePlan;
            
            
        List<Execution_Tracker__c> lstFilledExecutionTrackerRecord = [select Id, Agreed_Amount__c,Approve_Action_Plan__c,Approve_Action_Plan__r.Insurance__r.Policy_Type__c,
                                    Approve_Action_Plan__r.Insurance__r.Policy_Name__c,Approve_Action_Plan__r.Product_Name__c,ET_Status__c,Type__c,Application_Status__c,
                                    Approve_Action_Plan__r.Insurance__r.Sum_Assured_Rs__c,Approve_Action_Plan__r.Insurance__r.Premium_Amount_Rs__c  
                                    from Execution_Tracker__c where Entity_Name__c =: familyIdSet and (Application_Status__c = 'Opened' OR Application_Status__c = '') and  Is_Floating__c = false];
          if(!lstFilledExecutionTrackerRecord.isEmpty())       
            delete lstFilledExecutionTrackerRecord; 
                
        isSave = true;      
     	
 	  	pageReference pageRef = new pageReference('/apex/ActionPlan?entityId='+beanObj.entityId+'&tabname=Financial Planning');
        pageRef.setRedirect(true);
        return pageRef ;
     }*/
     
    /**************** Code Changes for Execution Tracker ****************************/
    /*
     * Added By : Aditi Satpute
     * @Description: Redirect to Execution Tracker Page
     * param: None 
     * return type: None
     * Date : 24/12/12
     */
     public pageReference showExecutionTracker()
     {
         String strEntityId = Apexpages.currentPage().getParameters().get('entityId');
         
         List<Approve_Action_Plan__c> lstApproveActionPlan = [select Id from Approve_Action_Plan__c where Account__c =: strEntityId 
                                                                 and AP_Status__c = 'Opened'];
         dbSOQLObj = new DatabaseSOQL();                                                         
         if(lstApproveActionPlan.isEmpty())
         {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'There is no Action Plan generated for this Entity'));
            isSidebar = false;
         }
         else
         {
             //isSave = false;
             Set<Id> familyIdSet = new Set<Id>(); 
             Map<Id,Account> mapFamilyMambers = new Map<Id,Account>();
             List<Account> lstAcc = dbSOQLObj.getFamilyMembers(beanObj.entityId);
            
             for(Account objAcc : lstAcc)
             {
                familyIdSet.add(objAcc.Id);
                mapFamilyMambers.put(objAcc.Id,objAcc);
             }
                 
             List<Execution_Tracker__c> lstExistingETrecords = [SELECT Id,Approve_Action_Plan__c,Type__c,Approve_Action_Plan__r.Investment_Asset__c,Rejected_Tracker__c,
             													Application_Status__c,Executed_Amount__c,Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name,ParentExecutionTracker__c  
             	 												FROM Execution_Tracker__c where Entity_Name__c IN: familyIdSet// and ParentExecutionTracker__c = null
                                                                /*and ((Application_Status__c = 'Opened' or Application_Status__c = '') 
                                                                and ParentExecutionTracker__c = null)*/
                                                              	and Is_Floating__c = false];
             Map<String,List<Execution_Tracker__c>> mapApIdToET = new Map<String,List<Execution_Tracker__c>>();
             Map<String,Decimal> mapETidToParentChildExecutedAmount = new Map<String,Decimal>();
             for(Execution_Tracker__c objET : lstExistingETrecords)
             {
             	/*String strKey = objET.Approve_Action_Plan__c+'';
         		if(objET.Type__c != null && objET.Type__c.equalsIgnoreCase('Lumpsum') && objET.Approve_Action_Plan__r.Investment_Asset__c != null)
         		{
         			if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Mutual Fund')
         				mapApIdToET.put(objET.Approve_Action_Plan__c+'MF_Lumpsum',objET);
         			else if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Gold and Silver')
         				mapApIdToET.put(objET.Approve_Action_Plan__c+'GS_Lumpsum',objET);
         		}
         		else if(objET.Type__c != null && objET.Type__c.equalsIgnoreCase('SIP') && objET.Approve_Action_Plan__r.Investment_Asset__c != null)
         		{
         			if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Mutual Fund')
         				mapApIdToET.put(objET.Approve_Action_Plan__c+'MF_SIP',objET);
         			else if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Gold and Silver')
         				mapApIdToET.put(objET.Approve_Action_Plan__c+'GS_SIP',objET);
         		}
         		else
         		{
         			mapApIdToET.put(objET.Approve_Action_Plan__c,objET);
         		}*/
         		if(objET.Application_Status__c != 'Rejected')
         		{
	         		if((!mapETidToParentChildExecutedAmount.containsKey(objET.Id) && objET.ParentExecutionTracker__c == null) || 
					(objET.ParentExecutionTracker__c != null && !mapETidToParentChildExecutedAmount.containsKey(objET.ParentExecutionTracker__c)) )
					{
						if(objET.ParentExecutionTracker__c == null)
							mapETidToParentChildExecutedAmount.put(objET.Id,objET.Executed_Amount__c);
						else
							mapETidToParentChildExecutedAmount.put(objET.ParentExecutionTracker__c,objET.Executed_Amount__c);
					}
					else
					{
						if(objET.ParentExecutionTracker__c == null)
						{
							
							Decimal totalExecutedAmount = mapETidToParentChildExecutedAmount.get(objET.Id);
							mapETidToParentChildExecutedAmount.put(objET.Id,totalExecutedAmount+objET.Executed_Amount__c);
						}
						else 
						{
							Decimal totalExecutedAmount = mapETidToParentChildExecutedAmount.get(objET.ParentExecutionTracker__c);
							mapETidToParentChildExecutedAmount.put(objET.ParentExecutionTracker__c,totalExecutedAmount+objET.Executed_Amount__c);
						 	//mapETidToParentChildExecutedAmount.get(objET.ParentExecutionTracker__c).add(objIncome);
						}
					}
         		}
				system.debug('-----map ------'+mapETidToParentChildExecutedAmount);//+'---Value-'+mapETidToParentChildExecutedAmount.Values())
	         	String strKey = objET.Approve_Action_Plan__c+'';
	         	List<Execution_Tracker__c> lstET = new List<Execution_Tracker__c>(); 
	     		if(objET.Type__c != null && objET.Type__c.equalsIgnoreCase('Lumpsum') && objET.Approve_Action_Plan__r.Investment_Asset__c != null)
	     		{
	     			if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Mutual Fund')
	     			{
		     			if(mapApIdToET.containsKey(objET.Approve_Action_Plan__c+'MF_Lumpsum'))
			          	{
				            lstET = mapApIdToET.get(objET.Approve_Action_Plan__c+'MF_Lumpsum');
				            lstET.add(objET);
			          	}
			          	else
			            	lstET.add(objET);
		     			mapApIdToET.put(objET.Approve_Action_Plan__c+'MF_Lumpsum',lstET);
	     			}
	     			else if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Gold and Silver')
	     			{
	     				if(mapApIdToET.containsKey(objET.Approve_Action_Plan__c+'GS_Lumpsum'))
			          	{
				            lstET = mapApIdToET.get(objET.Approve_Action_Plan__c+'GS_Lumpsum');
				            lstET.add(objET);
			          	}
			          	else
			            	lstET.add(objET);
		     			mapApIdToET.put(objET.Approve_Action_Plan__c+'GS_Lumpsum',lstET);
	     			}
	     		}
	     		else if(objET.Type__c != null && objET.Type__c.equalsIgnoreCase('SIP') && objET.Approve_Action_Plan__r.Investment_Asset__c != null)
	     		{
	     			if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Mutual Fund')
	     			{
		     			if(mapApIdToET.containsKey(objET.Approve_Action_Plan__c+'MF_SIP'))
			          	{
				            lstET = mapApIdToET.get(objET.Approve_Action_Plan__c+'MF_SIP');
				            lstET.add(objET);
			          	}
			          	else
			            	lstET.add(objET);
		     			mapApIdToET.put(objET.Approve_Action_Plan__c+'MF_SIP',lstET);
	     			}
	     			else if(objET.Approve_Action_Plan__r.Investment_Asset__r.RecordType.Name == 'Gold and Silver')
	     			{
	     				if(mapApIdToET.containsKey(objET.Approve_Action_Plan__c+'GS_SIP'))
			          	{
				            lstET = mapApIdToET.get(objET.Approve_Action_Plan__c+'GS_SIP');
				            lstET.add(objET);
			          	}
			          	else
			            	lstET.add(objET);
		     			mapApIdToET.put(objET.Approve_Action_Plan__c+'GS_SIP',lstET);
	     			}
	     		}
	     		else
	     		{
	     			if(mapApIdToET.containsKey(objET.Approve_Action_Plan__c))
		          	{
			            lstET = mapApIdToET.get(objET.Approve_Action_Plan__c);
			            lstET.add(objET);
		          	}
		          	else
		            	lstET.add(objET);
	     			mapApIdToET.put(objET.Approve_Action_Plan__c,lstET);
	     		}
	         
             
             }
             system.debug('-------mapApIdToET.keySet()------'+mapApIdToET.keySet());
             //if(lstExistingETrecords.size() == 0)
             {
                 isSidebar = true;
                 //Added on 24/12/2012 : for Retrieving Family member
                
                 //Retieve all records from Action Plan whose ET to be opened is "Yes""
                 List<Approve_Action_Plan__c> lstActionPlanETrecords = [Select Transaction_Type__c, isExecutionTracker__c, isInsuranceExecutionTracker__c,Tenure_of_Insurance__c,
                                                                                Remarks__c, Goal__c , isLumpsumExecTracker__c, Action_Amount__c,Scheme_Name__c,isAddOnExecutionTracker__c,
                                                                                Amount__c, Product_Name__c, Account__c , SIP_Action_Amount__c,Current_SIP__c ,Insured__c,
                                                                                Option__c, Installments__c, Item_Type__c , Insurance__r.Premium_Amount_Rs__c,Asset_Name__c,
                                                                                CreatedDate, Category__c, isSIPexecutionTracker__c ,Investment_Asset__c,Sum_Assured_Rs__c,
                                                                                Account__r.FirstName, Account__r.LastName ,Account__r.PersonMobilePhone, Account__r.PersonEmail,
                                                                                Account__r.PersonBirthdate, Account__r.PAN_ID__pc, Policy_Name__c, Insurance__r.Policy_Name__c,
                                                                                Insurance__r.Sum_Assured_Rs__c, Insurance__r.Suggested_Cover_General_Insurance__c, Insurance__r.Policy_Number__c, 
                                                                                Account__r.Bank_Account_Number2__c,Insurance__r.Surrender_Cash_Value__c,Insurance__r.Insurance_Company__c,
                                                                                Account__r.Bank_Name__c, Account__r.Branch_details__c,Account__r.Bank_Account_Type__c,Account__r.MICR_Number__c,
                                                                                Account__r.IFSC_Number__c, Account__r.Renewal_Date__c, Insurance__r.Policy_Type__c,Policy_Type__c,
                                                                                Insurance__r.Entity__r.FirstName,Insurance__r.Entity__r.LastName,InsuranceRemark__c,Fund__c,Premium_Amount_Rs__c,
                                                                                Amount_Per_Installment__c,SIP_Action__c,Lumpsum_Action__c,isGSsip_ExecutionTracker__c,isGS_ExecutionTracker__c,
                                                                                Period_in_Months__c,Company_Name__c,Loan_Type__c,Bond_Type__c     
                                                                        From Approve_Action_Plan__c
                                                                        where Account__c IN : familyIdSet
                                                                                and AP_Status__c = 'Opened'
                                                                                and (isSIPexecutionTracker__c = true or isLumpsumExecTracker__c = true 
                                                                                or isInsuranceExecutionTracker__c = true or isExecutionTracker__c = true
                                                                                or isGS_ExecutionTracker__c = true or isGSsip_ExecutionTracker__c = true
                                                                                or isAddOnExecutionTracker__c = true)];
                
                String strAddress = '';
                //Added on 31/1/2013 : for Fetching Mailing Address
                if(mapFamilyMambers.containsKey(beanObj.entityId))
                {
                    Account objAcc = mapFamilyMambers.get(beanObj.entityId);
                    system.debug('---------objAcc------'+objAcc);
                    objAcc.PersonMailingStreet = objAcc.PersonMailingStreet != null ? objAcc.PersonMailingStreet : ''; 
                    objAcc.PersonMailingCity= objAcc.PersonMailingCity != null ? objAcc.PersonMailingCity: '';
                    objAcc.PersonMailingState = objAcc.PersonMailingState!= null ? objAcc.PersonMailingState : '';
                    objAcc.PersonMailingCountry = objAcc.PersonMailingCountry != null? objAcc.PersonMailingCountry :'';
                    objAcc.PersonMailingPostalCode = objAcc.PersonMailingPostalCode != null? objAcc.PersonMailingPostalCode:'';
                    
                    if(objAcc.PersonMailingStreet != null && objAcc.PersonMailingCity != null && objAcc.PersonMailingState != null || 
                                    objAcc.PersonMailingCountry != null && objAcc.PersonMailingPostalCode != null )
                                    if(objAcc.PersonMailingStreet.compareTo('') ==  0 &&
                                       objAcc.PersonMailingState.compareTo('') ==  0 &&
                                       objAcc.PersonMailingCountry.compareTo('') == 0 &&
                                       objAcc.PersonMailingPostalCode.compareTo('') == 0)
                                            strAddress = '';
                                     
                    if(objAcc.PersonMailingStreet != null && objAcc.PersonMailingCity != null && objAcc.PersonMailingState != null || 
                                    objAcc.PersonMailingCountry != null && objAcc.PersonMailingPostalCode != null )
                                    
                                    if(objAcc.PersonMailingStreet.compareTo('') ==  0 &&
                                       objAcc.PersonMailingState.compareTo('') ==  0 &&
                                       objAcc.PersonMailingCity.compareTo('') ==  0 &&
                                       objAcc.PersonMailingCountry.compareTo('') == 0 &&
                                       objAcc.PersonMailingPostalCode.compareTo('') == 0)
                                            strAddress = '';
                                            
                                    else if(objAcc.PersonMailingStreet.compareTo('') ==  0 &&
                                       objAcc.PersonMailingState.compareTo('') !=  0 &&
                                       objAcc.PersonMailingCity.compareTo('') !=  0 &&
                                       objAcc.PersonMailingCountry.compareTo('') != 0 &&
                                       objAcc.PersonMailingPostalCode.compareTo('') != 0)   
                                       strAddress =  objAcc.PersonMailingCity+',\n'+
                                                            objAcc.PersonMailingState+', '+objAcc.PersonMailingCountry+',\n'+
                                                            objAcc.PersonMailingPostalCode+'.';
                                     
                                    else if(objAcc.PersonMailingStreet.compareTo('') !=  0 &&
                                       objAcc.PersonMailingState.compareTo('') ==  0 &&
                                       objAcc.PersonMailingCity.compareTo('') !=  0 &&
                                       objAcc.PersonMailingCountry.compareTo('') != 0 &&
                                       objAcc.PersonMailingPostalCode.compareTo('') != 0)   
                                       strAddress =  objAcc.PersonMailingStreet+',\n'+
                                                            objAcc.PersonMailingCity+', '+objAcc.PersonMailingCountry+',\n'+
                                                            objAcc.PersonMailingPostalCode+'.';
                                                            
                                    else if(objAcc.PersonMailingStreet.compareTo('') !=  0 &&
                                       objAcc.PersonMailingState.compareTo('') !=  0 &&
                                       objAcc.PersonMailingCity.compareTo('') ==  0 &&
                                       objAcc.PersonMailingCountry.compareTo('') != 0 &&
                                       objAcc.PersonMailingPostalCode.compareTo('') != 0)   
                                       strAddress =  objAcc.PersonMailingStreet+', '+objAcc.PersonMailingState+',\n'+
                                                            +objAcc.PersonMailingCountry+',\n'+
                                                            objAcc.PersonMailingPostalCode+'.'; 
                                                            
                                    else if(objAcc.PersonMailingStreet.compareTo('') !=  0 &&
                                       objAcc.PersonMailingState.compareTo('') !=  0 &&
                                       objAcc.PersonMailingCity.compareTo('') !=  0 &&
                                       objAcc.PersonMailingCountry.compareTo('') == 0 &&
                                       objAcc.PersonMailingPostalCode.compareTo('') != 0)   
                                       strAddress =  objAcc.PersonMailingStreet+', '+objAcc.PersonMailingState+',\n'+objAcc.PersonMailingCity+
                                                            ',\n'+objAcc.PersonMailingPostalCode+'.';   
                                                            
                                    else if(objAcc.PersonMailingStreet.compareTo('') !=  0 &&
                                       objAcc.PersonMailingState.compareTo('') !=  0 &&
                                       objAcc.PersonMailingCity.compareTo('') !=  0 &&
                                       objAcc.PersonMailingCountry.compareTo('') != 0 &&
                                       objAcc.PersonMailingPostalCode.compareTo('') == 0)   
                                       strAddress =  objAcc.PersonMailingStreet+', '+objAcc.PersonMailingState+',\n'+objAcc.PersonMailingCity+
                                                            ',\n'+objAcc.PersonMailingCountry+'.';                                              
                                    else    
                                    {
                                        strAddress = objAcc.PersonMailingStreet+', '+objAcc.PersonMailingCity+',\n'+
                                                            objAcc.PersonMailingState+', '+objAcc.PersonMailingCountry+',\n'+
                                                            objAcc.PersonMailingPostalCode+'.';
                                        system.debug('******strAddress******'+strAddress);
                                    }
                    else
                    {
                        strAddress = '';
                    }
                    
                }
                                            
                List<Execution_Tracker__c>  lstETrecords = new List<Execution_Tracker__c>();
                for(Approve_Action_Plan__c objActionPlan : lstActionPlanETrecords)  
                {
                	//Gold & Silver Lumpsum
                	if(objActionPlan.isGS_ExecutionTracker__c)
                	{
                		Execution_Tracker__c objET_GS = new Execution_Tracker__c();
                		List<Execution_Tracker__c>  lstET_GS = new List<Execution_Tracker__c>();
                    	if(mapApIdToET.containsKey(objActionPlan.Id+'GS_Lumpsum'))
                        {
                        	lstET_GS = mapApIdToET.get(objActionPlan.Id+'GS_Lumpsum');
                        	
                        	for(Execution_Tracker__c obj : lstET_GS)
                        	{
	                        	system.debug('---------obj.Application_Status__c-------'+obj.Application_Status__c);
	                        	system.debug('---------obj.ParentExecutionTracker__c-------'+obj.ParentExecutionTracker__c);
	                        	system.debug('---------obj------'+obj);
	                        	/*if((obj.Application_Status__c == 'Processed' || obj.Application_Status__c == 'Closed'  || obj.ParentExecutionTracker__c != null))
	                        	{
	                        		system.debug('------in if---obj--'+obj);
	                        	}*/
	                        	if((obj.Application_Status__c != 'Processed' && obj.Application_Status__c != 'Closed' && obj.Application_Status__c != 'Rejected'))
	                        	{
	                        		if(obj.ParentExecutionTracker__c == null)
	                        		{
		                        		obj.Action__c = objActionPlan.Lumpsum_Action__c;
				                        //objET_GS.Suggested_Amount__c = objActionPlan.Action_Amount__c;
				                        //objET_GS.Agreed_Amount__c = objET_GS.Suggested_Amount__c;
				                        //obj.Actual_Action_Amount__c = objActionPlan.Action_Amount__c;
				                        //objET_GS.Agreed_Amount_Base_Amount__c = objActionPlan.Action_Amount__c;
				                        obj.Total_Remaining_Balance__c = objActionPlan.Action_Amount__c;
				                        
				                        obj.Amount__c = objActionPlan.Amount__c;
				                        //objET_GS.Scheme_Name_Policy_Name__c = objActionPlan.Asset_Name__c;
				                        //objET_GS.Executed_Product_Name__c = objActionPlan.Asset_name__c;
	                        		}
	                        		else //if(obj.Rejected_Tracker__c != null)
	                        		{
	                        			obj.Total_Remaining_Balance__c = objActionPlan.Action_Amount__c - mapETidToParentChildExecutedAmount.get(obj.ParentExecutionTracker__c); //- Addition of All Closed Executed Amount
	                        			//obj.Agreed_Amount__c = objActionPlan.Action_Amount__c;
	                        		}
	                        		
	                        		//===========================Common Data
			                        system.debug('***obj*****'+obj);
			                        
			                        obj.Suggested_Amount__c = objActionPlan.Action_Amount__c;
			                       /*
			                       	obj.Approve_Action_Plan__c = objActionPlan.Id;
			                        obj.Goal__c = objActionPlan.Goal__c;
			                        obj.Type__c = 'Lumpsum';
			                        obj.Investor_Name_as_in_PAN_card__c = objActionPlan.Account__r.FirstName +' '+ objActionPlan.Account__r.LastName;
			                        obj.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
			                        obj.Email__c = objActionPlan.Account__r.PersonEmail;
			                        obj.DOB__c = objActionPlan.Account__r.PersonBirthdate;
			                        obj.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
			                        obj.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
			                        obj.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
			                        obj.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
			                        obj.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
			                        obj.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
			                       	
			                        obj.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c; 
			                        obj.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
			                        obj.Communication_Address__c = strAddress;
			                        */
			                        lstETrecords.add(obj); 
	                        	}
	                        	
                        	}
                        }
                        else
                        {
                        	objET_GS.Entity_Name__c = objActionPlan.Account__c;
                        	objET_GS.ET_Status__c = 'Assigned to MET';
                        	objET_GS.Action__c = objActionPlan.Lumpsum_Action__c;
	                        objET_GS.Suggested_Amount__c = objActionPlan.Action_Amount__c;
	                        objET_GS.Agreed_Amount__c = objET_GS.Suggested_Amount__c;
	                        
	                        //objET_GS.Actual_Action_Amount__c = objActionPlan.Action_Amount__c;
	                        //objET_GS.Agreed_Amount_Base_Amount__c = objActionPlan.Action_Amount__c;
	                        objET_GS.Total_Remaining_Balance__c = objActionPlan.Action_Amount__c;
	                        
	                        objET_GS.Amount__c = objActionPlan.Amount__c;
	                        objET_GS.Executed_Product_Name__c = objActionPlan.Asset_name__c;
	                        objET_GS.Scheme_Name_Policy_Name__c = objActionPlan.Asset_Name__c;
	                        
	                        //===========================Common Data
	                        system.debug('***objET_GS*****'+objET_GS);
	                        objET_GS.Approve_Action_Plan__c = objActionPlan.Id;
	                        objET_GS.Goal__c = objActionPlan.Goal__c;
	                        objET_GS.Type__c = 'Lumpsum';
	                        objET_GS.Investor_Name_as_in_PAN_card__c = objActionPlan.Account__r.FirstName +' '+ objActionPlan.Account__r.LastName;
	                        objET_GS.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
	                        objET_GS.Email__c = objActionPlan.Account__r.PersonEmail;
	                        objET_GS.DOB__c = objActionPlan.Account__r.PersonBirthdate;
	                        objET_GS.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
	                        objET_GS.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
	                        objET_GS.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
	                        objET_GS.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
	                        objET_GS.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
	                        objET_GS.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
	                       	
	                        objET_GS.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c; 
	                        objET_GS.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
	                        objET_GS.Communication_Address__c = strAddress;
	                       
	                        lstETrecords.add(objET_GS); 
                        }
                        //objET_GS.Actual_Action_Amount__c = objActionPlan.Action_Amount__c;
                        //objET_GS.Agreed_Amount_Base_Amount__c = objActionPlan.Action_Amount__c;
                        //objET_GS.Total_Remaining_Balance__c = objActionPlan.Action_Amount__c;
                        
                        
                	}
                	//Gold & Silver Running SIP
                	if(objActionPlan.isGSsip_ExecutionTracker__c)
                	{
                		Execution_Tracker__c objET_GS_SIP = new Execution_Tracker__c();
                		List<Execution_Tracker__c>  lstET_GS_SIP = new List<Execution_Tracker__c>();
                		if(mapApIdToET.containsKey(objActionPlan.Id+'GS_SIP'))
                        {
                        	lstET_GS_SIP = mapApIdToET.get(objActionPlan.Id+'GS_SIP');
                        	for(Execution_Tracker__c objET_GS_SIP_1 : lstET_GS_SIP)
                        	{
	                        	system.debug('---------objET_GS_SIP_1.Application_Status__c-------'+objET_GS_SIP_1.Application_Status__c);
	                        	system.debug('---------objET_GS_SIP_1.ParentExecutionTracker__c-------'+objET_GS_SIP_1.ParentExecutionTracker__c);
	                        	system.debug('---------objET_GS_SIP_1------'+objET_GS_SIP_1);
	                        	/*if((objET_GS_SIP.Application_Status__c == 'Processed' || objET_GS_SIP.Application_Status__c == 'Closed'  || objET_GS_SIP.ParentExecutionTracker__c != null))
	                    	   	{
	                        		//continue;
	                        	}*/
	                        	if((objET_GS_SIP_1.Application_Status__c != 'Processed' && objET_GS_SIP_1.Application_Status__c != 'Closed' && objET_GS_SIP_1.Application_Status__c != 'Rejected'))
	                        	{
	                        		if(objET_GS_SIP_1.ParentExecutionTracker__c == null)
	                        		{
		                        		//objET_GS_SIP_1.Suggested_Amount__c = objActionPlan.SIP_Action_Amount__c;
			                            //objET_GS_SIP_1.Actual_Action_Amount__c = objActionPlan.SIP_Action_Amount__c;
			                            //objET_GS_SIP_1.Agreed_Amount_Base_Amount__c = objActionPlan.SIP_Action_Amount__c;
			                            objET_GS_SIP_1.Total_Remaining_Balance__c = objActionPlan.SIP_Action_Amount__c;
			                            
			                            objET_GS_SIP_1.Amount__c = objActionPlan.Current_SIP__c;
			                            //objET_GS_SIP_1.Scheme_Name_Policy_Name__c = objActionPlan.Asset_name__c;
			                            //objET_GS_SIP_1.Agreed_Amount__c = objET_GS_SIP.Suggested_Amount__c;
			                            //objET_GS_SIP_1.Executed_Product_Name__c =  objActionPlan.Asset_name__c;
			                         	objET_GS_SIP_1.Action__c = objActionPlan.SIP_Action__c;
	                        		}
	                        		else //if(objET_GS_SIP_1.Rejected_Tracker__c != null)
	                        		{
	                        			objET_GS_SIP_1.Total_Remaining_Balance__c = objActionPlan.SIP_Action_Amount__c - mapETidToParentChildExecutedAmount.get(objET_GS_SIP_1.ParentExecutionTracker__c); //- Addition of All Closed Executed Amount
	                        		}
	                        	
	                        	
		                        	//===========================Common Data 
		                        	objET_GS_SIP_1.Suggested_Amount__c = objActionPlan.SIP_Action_Amount__c;
			                        /*objET_GS_SIP_1.Approve_Action_Plan__c = objActionPlan.Id;
			                        objET_GS_SIP_1.Goal__c = objActionPlan.Goal__c;
			                        objET_GS_SIP_1.Type__c = 'SIP';
			                        objET_GS_SIP_1.Investor_Name_as_in_PAN_card__c = objActionPlan.Account__r.FirstName +' '+ objActionPlan.Account__r.LastName;
			                        objET_GS_SIP_1.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
			                        objET_GS_SIP_1.Email__c = objActionPlan.Account__r.PersonEmail;
			                        objET_GS_SIP_1.DOB__c = objActionPlan.Account__r.PersonBirthdate;
			                        objET_GS_SIP_1.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
			                        objET_GS_SIP_1.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
			                        objET_GS_SIP_1.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
			                        objET_GS_SIP_1.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
			                        objET_GS_SIP_1.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
			                        objET_GS_SIP_1.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
			                        objET_GS_SIP_1.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
			                        objET_GS_SIP_1.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
			                       	objET_GS_SIP_1.Communication_Address__c = strAddress;*/
			                        lstETrecords.add(objET_GS_SIP_1);
	                        	}
                    	   	}
                        }
                        else
                        {
                        	objET_GS_SIP.Entity_Name__c = objActionPlan.Account__c;
                        	objET_GS_SIP.ET_Status__c = 'Assigned to MET';
                        	objET_GS_SIP.Suggested_Amount__c = objActionPlan.SIP_Action_Amount__c;
                            //objET_GS_SIP.Actual_Action_Amount__c = objActionPlan.SIP_Action_Amount__c;
                            //objET_GS_SIP.Agreed_Amount_Base_Amount__c = objActionPlan.SIP_Action_Amount__c;
                            objET_GS_SIP.Total_Remaining_Balance__c = objActionPlan.SIP_Action_Amount__c;
                            
                            objET_GS_SIP.Amount__c = objActionPlan.Current_SIP__c;
                            objET_GS_SIP.Investor_Name_as_in_PAN_card__c = objActionPlan.Account__r.FirstName +' '+ objActionPlan.Account__r.LastName;
                            objET_GS_SIP.Scheme_Name_Policy_Name__c = objActionPlan.Asset_name__c;
                            objET_GS_SIP.Agreed_Amount__c = objET_GS_SIP.Suggested_Amount__c;
                            objET_GS_SIP.Executed_Product_Name__c =  objActionPlan.Asset_name__c;
                         	objET_GS_SIP.Action__c = objActionPlan.SIP_Action__c;
                         	
                         	//===========================Common Data 
	                        objET_GS_SIP.Approve_Action_Plan__c = objActionPlan.Id;
	                        objET_GS_SIP.Goal__c = objActionPlan.Goal__c;
	                        objET_GS_SIP.Type__c = 'SIP';
	                        objET_GS_SIP.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
	                        objET_GS_SIP.Email__c = objActionPlan.Account__r.PersonEmail;
	                        objET_GS_SIP.DOB__c = objActionPlan.Account__r.PersonBirthdate;
	                        objET_GS_SIP.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
	                        objET_GS_SIP.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
	                        objET_GS_SIP.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
	                        objET_GS_SIP.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
	                        objET_GS_SIP.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
	                        objET_GS_SIP.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
	                        objET_GS_SIP.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
	                        objET_GS_SIP.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
	                       	objET_GS_SIP.Communication_Address__c = strAddress;
	                        lstETrecords.add(objET_GS_SIP);
                        }
                        //objET_GS_SIP.Actual_Action_Amount__c = objActionPlan.SIP_Action_Amount__c;
	                    //objET_GS_SIP.Agreed_Amount_Base_Amount__c = objActionPlan.SIP_Action_Amount__c;
	                   	//objET_GS_SIP.Total_Remaining_Balance__c = objActionPlan.SIP_Action_Amount__c;
	                    
                	}
                    //Mutual Fund Lumpsum
                    if(objActionPlan.isExecutionTracker__c)
                    {
                        Execution_Tracker__c objET_MF = new Execution_Tracker__c();
                        List<Execution_Tracker__c>  lstET_MF = new List<Execution_Tracker__c>();
                    	if(mapApIdToET.containsKey(objActionPlan.Id+'MF_Lumpsum'))
                        {
                        	lstET_MF = mapApIdToET.get(objActionPlan.Id+'MF_Lumpsum');
                        	for(Execution_Tracker__c objET_MF_1 : lstET_MF)
                        	{
	                        	system.debug('---------objET_MF_1.Application_Status__c-------'+objET_MF_1.Application_Status__c);
	                        	system.debug('---------objET_MF_1.ParentExecutionTracker__c-------'+objET_MF_1.ParentExecutionTracker__c);
	                        	system.debug('---------objET_MF_1------'+objET_MF_1);
	                        	//if(objET_MF.Application_Status__c != 'Opened' && objET_MF.Application_Status__c != null  && objET_MF.Application_Status__c != '')
	                        	/*if((objET_MF_1.Application_Status__c == 'Processed' || objET_MF_1.Application_Status__c == 'Closed'  || objET_MF_1.ParentExecutionTracker__c != null))
	                        	{
	                        		system.debug('------in if ---objET_MF.Application_Status__c--'+objET_MF.Application_Status__c);
	                        		//continue;
	                        	}*/
	                        	if((objET_MF_1.Application_Status__c != 'Processed' && objET_MF_1.Application_Status__c != 'Closed' && objET_MF_1.Application_Status__c != 'Rejected'))
	                        	{
	                        		if(objET_MF_1.ParentExecutionTracker__c == null)
	                        		{
		                        		objET_MF_1.Action__c = objActionPlan.Lumpsum_Action__c;
				                        //Below change done by Gaurav - 7/2/2013 
				                        //      Changes in Scheme name = Schme name policy
				                        //      Purpose: Execution Tracker changes 
				                        
				                        //objET_MF_1.Suggested_Amount__c = objActionPlan.Action_Amount__c;
				                        //objET_MF_1.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
				                        //objET_MF_1.Agreed_Amount_Base_Amount__c = objActionPlan.Action_Amount__c;
				                        objET_MF_1.Total_Remaining_Balance__c = objActionPlan.Action_Amount__c;
				                        objET_MF_1.Amount__c = objActionPlan.Amount__c;
				                        //objET_MF_1.Scheme_Name_Policy_Name__c = objActionPlan.Scheme_Name__c;
				                        //objET_MF_1.Executed_Product_Name__c = objActionPlan.Scheme_Name__c;
	                        		}
	                        		else //if(objET_MF_1.Rejected_Tracker__c != null)
	                        		{
	                        			objET_MF_1.Total_Remaining_Balance__c = objActionPlan.Action_Amount__c - mapETidToParentChildExecutedAmount.get(objET_MF_1.ParentExecutionTracker__c); //- Addition of All Closed Executed Amount
	                        		}
	                        		
	                        		//===========================Common Data 
			                        system.debug('***objET_MF*****'+objET_MF);
			                        objET_MF_1.Suggested_Amount__c = objActionPlan.Action_Amount__c;
			                       	/*
			                        objET_MF_1.Approve_Action_Plan__c = objActionPlan.Id;
			                        objET_MF_1.Goal__c = objActionPlan.Goal__c;
			                        objET_MF_1.Type__c = 'Lumpsum';
			                        objET_MF_1.Investor_Name_as_in_PAN_card__c = objActionPlan.Account__r.FirstName +' '+ objActionPlan.Account__r.LastName;
			                        objET_MF_1.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
			                        objET_MF_1.Email__c = objActionPlan.Account__r.PersonEmail;
			                        objET_MF_1.DOB__c = objActionPlan.Account__r.PersonBirthdate;
			                        objET_MF_1.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
			                        objET_MF_1.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
			                        objET_MF_1.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
			                        objET_MF_1.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
			                        objET_MF_1.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
			                        objET_MF_1.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
			                        //objET_MF_1.Scheme_Name_Policy_Name__c = objActionPlan.Scheme_Name__c;
			                        objET_MF_1.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c; 
			                        objET_MF_1.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
			                        objET_MF_1.Communication_Address__c = strAddress;
			                        //Added on 22/3/13 : Aditi Satpute : To open different screens depending on Action for Ops Team
			                        */
			                       	//objET_MF_1.Actual_Action_Amount__c = 
			                        //objET_MF_1.Executed_Product_Name__c = objActionPlan.Scheme_Name__c;
			                        lstETrecords.add(objET_MF_1); 
	                        	}
                        	}
                        }
                        else
                        {
                        	objET_MF.Entity_Name__c = objActionPlan.Account__c;
                        	objET_MF.ET_Status__c = 'Assigned to MET';
                        	objET_MF.Action__c = objActionPlan.Lumpsum_Action__c;
	                        //Below change done by Gaurav - 7/2/2013 
	                         //     Changes in Scheme name = Schme name policy
	                         //     Purpose: Execution Tracker changes 
	                        
	                        objET_MF.Suggested_Amount__c = objActionPlan.Action_Amount__c;
	                        objET_MF.Agreed_Amount__c = objActionPlan.Action_Amount__c;
	                        //objET_MF.Actual_Action_Amount__c = objActionPlan.Action_Amount__c;
	                        //objET_MF.Agreed_Amount_Base_Amount__c = objActionPlan.Action_Amount__c;
	                        objET_MF.Total_Remaining_Balance__c = objActionPlan.Action_Amount__c;
	                        
	                        objET_MF.Amount__c = objActionPlan.Amount__c;
	                        objET_MF.Scheme_Name_Policy_Name__c = objActionPlan.Scheme_Name__c;
	                        objET_MF.Executed_Product_Name__c = objActionPlan.Scheme_Name__c;
	                        
	                        //===========================Common Data 
	                        system.debug('***objET_MF*****'+objET_MF);
	                        objET_MF.Approve_Action_Plan__c = objActionPlan.Id;
	                        objET_MF.Goal__c = objActionPlan.Goal__c;
	                        objET_MF.Type__c = 'Lumpsum';
	                        objET_MF.Investor_Name_as_in_PAN_card__c = objActionPlan.Account__r.FirstName +' '+ objActionPlan.Account__r.LastName;
	                        objET_MF.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
	                        objET_MF.Email__c = objActionPlan.Account__r.PersonEmail;
	                        objET_MF.DOB__c = objActionPlan.Account__r.PersonBirthdate;
	                        objET_MF.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
	                        objET_MF.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
	                        objET_MF.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
	                        objET_MF.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
	                        objET_MF.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
	                        objET_MF.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
	                        //objET_MF.Scheme_Name_Policy_Name__c = objActionPlan.Scheme_Name__c;
	                        objET_MF.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c; 
	                        objET_MF.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
	                        objET_MF.Communication_Address__c = strAddress;
	                        //Added on 22/3/13 : Aditi Satpute : To open different screens depending on Action for Ops Team
	                       
	                       	//objET_MF.Actual_Action_Amount__c = 
	                        //objET_MF.Executed_Product_Name__c = objActionPlan.Scheme_Name__c;
	                        lstETrecords.add(objET_MF); 
                        }
                        //objET_MF.Actual_Action_Amount__c = objActionPlan.Action_Amount__c;
                        //objET_MF.Agreed_Amount_Base_Amount__c = objActionPlan.Action_Amount__c;
 						//objET_MF.Total_Remaining_Balance__c = objActionPlan.Action_Amount__c;
 						
                    }
                    //Mutual Fund Running SIP & SIP Funds
                    if(objActionPlan.isSIPexecutionTracker__c)
                    {
                        Execution_Tracker__c objET_MF = new Execution_Tracker__c();
                        List<Execution_Tracker__c>  lstET_MF = new List<Execution_Tracker__c>();
                        if(objActionPlan.Investment_Asset__c != null)
                        {
                        	if(mapApIdToET.containsKey(objActionPlan.Id+'MF_SIP'))
	                        {
	                        	lstET_MF = mapApIdToET.get(objActionPlan.Id+'MF_SIP');
	                        	for(Execution_Tracker__c objET_MF_1 : lstET_MF)
                        		{
                        			if((objET_MF_1.Application_Status__c != 'Processed' && objET_MF_1.Application_Status__c != 'Closed' && objET_MF_1.Application_Status__c != 'Rejected'))
	                        		{
		                        		system.debug('---------objET_MF_1.Application_Status__c-------'+objET_MF_1.Application_Status__c);
		                        		system.debug('---------objET_MF_1.ParentExecutionTracker__c-------'+objET_MF_1.ParentExecutionTracker__c);
		                        		system.debug('---------objET_MF_1------'+objET_MF_1);
			                        	//if(objET_MF.Application_Status__c != 'Opened' && objET_MF.Application_Status__c != '' && objET_MF.Application_Status__c != null)
			                        	/*if((objET_MF_1.Application_Status__c == 'Processed' || objET_MF_1.Application_Status__c == 'Closed'  || objET_MF_1.ParentExecutionTracker__c != null))
		                        	   	{
			                        		//continue;
			                        	}*/
			                        	if(objET_MF_1.ParentExecutionTracker__c == null)
	                        			{	
	                        				//objET_MF_1.Suggested_Amount__c = objActionPlan.SIP_Action_Amount__c;
				                            //objET_MF_1.Actual_Action_Amount__c = objActionPlan.SIP_Action_Amount__c;
				                            //objET_MF_1.Agreed_Amount_Base_Amount__c = objActionPlan.SIP_Action_Amount__c;
				                            objET_MF_1.Total_Remaining_Balance__c = objActionPlan.SIP_Action_Amount__c;
				                            
				                            objET_MF_1.Amount__c = objActionPlan.Current_SIP__c;
				                            objET_MF_1.Scheme_Name_Policy_Name__c = objActionPlan.Scheme_Name__c;
				                            
				                            //Below change done by Gaurav - 7/2/2013 
				                            //  Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
				                            //  Purpose: Execution Tracker changes 
				                            
				                            //objET_MF.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
				                            //objET_MF_1.Executed_Product_Name__c =  objActionPlan.Scheme_Name__c;
				                            //Added on 22/3/13 : Aditi Satpute : To open different screens depending on Action for Ops Team
				                         	objET_MF_1.Action__c = objActionPlan.SIP_Action__c;
	                        			}
			                        	else //if(objET_MF_1.Rejected_Tracker__c != null)
			                        	{
			                        		objET_MF_1.Total_Remaining_Balance__c = objActionPlan.SIP_Action_Amount__c - mapETidToParentChildExecutedAmount.get(objET_MF_1.ParentExecutionTracker__c); //- Addition of All Closed Executed Amount
			                        	}
			                        	
			                        	//===========================Common Data 
			                        	objET_MF_1.Suggested_Amount__c = objActionPlan.SIP_Action_Amount__c;
			                        	
			                        	/*
			                        	objET_MF_1.Approve_Action_Plan__c = objActionPlan.Id;
					                    objET_MF_1.Investor_Name_as_in_PAN_card__c = objActionPlan.Account__r.FirstName +' '+ objActionPlan.Account__r.LastName;
				                        objET_MF_1.Goal__c = objActionPlan.Goal__c;
				                        objET_MF_1.Type__c = 'SIP';
				                        objET_MF_1.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
				                        objET_MF_1.Email__c = objActionPlan.Account__r.PersonEmail;
				                        objET_MF_1.DOB__c = objActionPlan.Account__r.PersonBirthdate;
				                        objET_MF_1.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
				                        objET_MF_1.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
				                        objET_MF_1.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
				                        objET_MF_1.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
				                        objET_MF_1.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
				                        objET_MF_1.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
				                        objET_MF_1.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
				                        objET_MF_1.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
				                        objET_MF_1.Communication_Address__c = strAddress;
				                        */
				                        lstETrecords.add(objET_MF_1);
	                        		}
                        		}
	                        }
	                        else
	                        {
	                        	objET_MF.Entity_Name__c = objActionPlan.Account__c;
	                        	objET_MF.ET_Status__c = 'Assigned to MET';
	                        	objET_MF.Suggested_Amount__c = objActionPlan.SIP_Action_Amount__c;
	                            //objET_MF.Actual_Action_Amount__c = objActionPlan.SIP_Action_Amount__c;
	                            //objET_MF.Agreed_Amount_Base_Amount__c = objActionPlan.SIP_Action_Amount__c;
	                            objET_MF.Total_Remaining_Balance__c = objActionPlan.SIP_Action_Amount__c;
	                            
	                            objET_MF.Amount__c = objActionPlan.Current_SIP__c;
	                            objET_MF.Investor_Name_as_in_PAN_card__c = objActionPlan.Account__r.FirstName +' '+ objActionPlan.Account__r.LastName;
	                            objET_MF.Scheme_Name_Policy_Name__c = objActionPlan.Scheme_Name__c;
	                            
	                            //Below change done by Gaurav - 7/2/2013 
	                             // Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
	                             // Purpose: Execution Tracker changes 
	                            
	                            objET_MF.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
	                            objET_MF.Executed_Product_Name__c =  objActionPlan.Scheme_Name__c;
	                            //Added on 22/3/13 : Aditi Satpute : To open different screens depending on Action for Ops Team
	                         	objET_MF.Action__c = objActionPlan.SIP_Action__c;
	                         	
	                         	//===========================Common Data 
	                        	objET_MF.Approve_Action_Plan__c = objActionPlan.Id;
			                    objET_MF.Investor_Name_as_in_PAN_card__c = objActionPlan.Account__r.FirstName +' '+ objActionPlan.Account__r.LastName;
		                        objET_MF.Goal__c = objActionPlan.Goal__c;
		                        objET_MF.Type__c = 'SIP';
		                        objET_MF.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
		                        objET_MF.Email__c = objActionPlan.Account__r.PersonEmail;
		                        objET_MF.DOB__c = objActionPlan.Account__r.PersonBirthdate;
		                        objET_MF.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
		                        objET_MF.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
		                        objET_MF.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
		                        objET_MF.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
		                        objET_MF.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
		                        objET_MF.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
		                        objET_MF.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
		                        objET_MF.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
		                        objET_MF.Communication_Address__c = strAddress;
		                        lstETrecords.add(objET_MF);
	                        }
                        }
                        else//SIP Funds
                        {
                        	if(mapApIdToET.containsKey(objActionPlan.Id))
	                        {
	                        	lstET_MF = mapApIdToET.get(objActionPlan.Id);
	                        	for(Execution_Tracker__c objET_MF_1 : lstET_MF)
                        		{
                        			
		                        	system.debug('---------objET_MF.Application_Status__c-------'+objET_MF.Application_Status__c);
	                        		system.debug('---------objET_MF.ParentExecutionTracker__c-------'+objET_MF.ParentExecutionTracker__c);
	                        		system.debug('---------objET_MF------'+objET_MF);
		                        	//if(objET_MF.Application_Status__c != 'Opened' && objET_MF.Application_Status__c != null && objET_MF.Application_Status__c != '')
		                        	/*if((objET_MF.Application_Status__c == 'Processed' || objET_MF.Application_Status__c == 'Closed'  || objET_MF.ParentExecutionTracker__c != null))
		                        	{
		                        		//continue;
		                        	}*/
		                        	if((objET_MF_1.Application_Status__c != 'Processed' && objET_MF_1.Application_Status__c != 'Closed' && objET_MF_1.Application_Status__c != 'Rejected'))
		                        	{
		                        		if(objET_MF_1.ParentExecutionTracker__c == null)
	                        			{
			                        		objET_MF_1.Suggested_Amount__c = objActionPlan.Amount__c;
				                            //objET_MF_1.Actual_Action_Amount__c = objActionPlan.Amount__c;
				                            //objET_MF_1.Agreed_Amount_Base_Amount__c = objActionPlan.Amount__c;
				                            objET_MF_1.Total_Remaining_Balance__c = objActionPlan.Amount__c;
				                            
				                            objET_MF_1.Option__c = objActionPlan.Option__c;
				                            objET_MF_1.Transaction_Type__c = objActionPlan.Transaction_Type__c;
				                            objET_MF_1.SIP_Installments__c = objActionPlan.Installments__c;
				                            //objET_MF_1.Scheme_Name_Policy_Name__c = objActionPlan.Product_Name__c;
				                            
				                            //Below change done by Gaurav - 7/2/2013 
				                            //  Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
				                            //  Purpose: Execution Tracker changes 
				                           
				                            //objET_MF_1.Executed_Product_Name__c = objActionPlan.Product_Name__c;
				                            //objET_MF_1.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
				                             //Added on : 20/3/13 : Aditi Satpute : ET Screen Changes
											objET_MF_1.Agreed_Installments__c = objActionPlan.Installments__c;
		                        		}
			                        	else //if(objET_MF_1.Rejected_Tracker__c != null)
			                        	{
			                        		objET_MF_1.Total_Remaining_Balance__c = objActionPlan.Amount__c - mapETidToParentChildExecutedAmount.get(objET_MF_1.ParentExecutionTracker__c); //- Addition of All Closed Executed Amount
			                        	}
			                        	//===========================Common Data 
			                        	objET_MF_1.Suggested_Amount__c = objActionPlan.Amount__c;
			                        	/*
			                        	objET_MF_1.Approve_Action_Plan__c = objActionPlan.Id;
					                    objET_MF_1.Investor_Name_as_in_PAN_card__c = objActionPlan.Account__r.FirstName +' '+ objActionPlan.Account__r.LastName;
				                        objET_MF_1.Goal__c = objActionPlan.Goal__c;
				                        objET_MF_1.Type__c = 'SIP';
				                        objET_MF_1.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
				                        objET_MF_1.Email__c = objActionPlan.Account__r.PersonEmail;
				                        objET_MF_1.DOB__c = objActionPlan.Account__r.PersonBirthdate;
				                        objET_MF_1.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
				                        objET_MF_1.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
				                        objET_MF_1.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
				                        objET_MF_1.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
				                        objET_MF_1.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
				                        objET_MF_1.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
				                        objET_MF_1.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
				                        objET_MF_1.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
				                        objET_MF_1.Communication_Address__c = strAddress;
				                        */
				                        lstETrecords.add(objET_MF_1);
		                        	}
                        		}
	                        }
	                        else
	                        {
	                        	objET_MF.Entity_Name__c = objActionPlan.Account__c;
	                        	objET_MF.ET_Status__c = 'Assigned to MET';
	                        	objET_MF.Suggested_Amount__c = objActionPlan.Amount__c;
	                            //objET_MF.Actual_Action_Amount__c = objActionPlan.Amount__c;
	                            //objET_MF.Agreed_Amount_Base_Amount__c = objActionPlan.Amount__c;
	                            objET_MF.Total_Remaining_Balance__c = objActionPlan.Amount__c;
	                             
	                            objET_MF.Option__c = objActionPlan.Option__c;
	                            objET_MF.Transaction_Type__c = objActionPlan.Transaction_Type__c;
	                            objET_MF.SIP_Installments__c = objActionPlan.Installments__c;
	                            objET_MF.Scheme_Name_Policy_Name__c = objActionPlan.Product_Name__c;
	                            
	                            //Below change done by Gaurav - 7/2/2013 
	                            //  Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
	                             // Purpose: Execution Tracker changes 
	                            
	                            objET_MF.Executed_Product_Name__c = objActionPlan.Product_Name__c;
	                            objET_MF.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
	                             //Added on : 20/3/13 : Aditi Satpute : ET Screen Changes
								objET_MF.Agreed_Installments__c = objActionPlan.Installments__c;
								
								//===========================Common Data 
	                        	objET_MF.Approve_Action_Plan__c = objActionPlan.Id;
			                    objET_MF.Investor_Name_as_in_PAN_card__c = objActionPlan.Account__r.FirstName +' '+ objActionPlan.Account__r.LastName;
		                        objET_MF.Goal__c = objActionPlan.Goal__c;
		                        objET_MF.Type__c = 'SIP';
		                        objET_MF.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
		                        objET_MF.Email__c = objActionPlan.Account__r.PersonEmail;
		                        objET_MF.DOB__c = objActionPlan.Account__r.PersonBirthdate;
		                        objET_MF.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
		                        objET_MF.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
		                        objET_MF.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
		                        objET_MF.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
		                        objET_MF.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
		                        objET_MF.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
		                        objET_MF.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
		                        objET_MF.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
		                        objET_MF.Communication_Address__c = strAddress;
		                        lstETrecords.add(objET_MF);
	                        }
                            
	                    }
	                    
                    } 
                    //Lumpsum Funds
                    if(objActionPlan.isLumpsumExecTracker__c)
                    {
                        Execution_Tracker__c objET_MF = new Execution_Tracker__c();
                        List<Execution_Tracker__c>  lstET_MF = new List<Execution_Tracker__c>();
                        if(mapApIdToET.containsKey(objActionPlan.Id))
                        {
                        	lstET_MF = mapApIdToET.get(objActionPlan.Id);
                        	for(Execution_Tracker__c objET_MF_1 : lstET_MF)
                    		{
	                    		system.debug('---------objET_MF_1.Application_Status__c-------'+objET_MF_1.Application_Status__c);
	                        	system.debug('---------objET_MF_1.ParentExecutionTracker__c-------'+objET_MF_1.ParentExecutionTracker__c);
	                        	system.debug('---------objET_MF_1------'+objET_MF_1);
	                        	/*if((objET_MF.Application_Status__c == 'Processed' || objET_MF.Application_Status__c == 'Closed'  || objET_MF.ParentExecutionTracker__c != null))
	                        	{
	                        		//continue;
	                        	}*/
	                        	if((objET_MF_1.Application_Status__c != 'Processed' && objET_MF_1.Application_Status__c != 'Closed' && objET_MF_1.Application_Status__c != 'Rejected'))
	                        	{
	                        		
	                        		if(objET_MF_1.ParentExecutionTracker__c == null)
                        			{
                        				system.debug('--------in if-----'+objET_MF_1);
				                        //objET_MF_1.Actual_Action_Amount__c = objActionPlan.Amount__c;
				                       	//objET_MF_1.Agreed_Amount_Base_Amount__c = objActionPlan.Amount__c;
				                        objET_MF_1.Total_Remaining_Balance__c = objActionPlan.Amount__c;
				                        
				                        objET_MF_1.Option__c = objActionPlan.Option__c;
				                        objET_MF_1.Transaction_Type__c = objActionPlan.Transaction_Type__c;
				                        //Below change done by Gaurav - 7/2/2013 
				                        //Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
				                        //Purpose: Execution Tracker changes 
				                        
				                       	//objET_MF_1.Executed_Product_Name__c =  objActionPlan.Product_Name__c;
				                        //objET_MF_1.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
				                        //Added on : 20/3/13 : Aditi Satpute : ET Screen Changes
				                        objET_MF_1.Agreed_Amount_Per_Installment__c = objActionPlan.Amount_Per_Installment__c;
										objET_MF_1.Agreed_Installments__c = objActionPlan.Installments__c;
										objET_MF_1.Agreed_Scheme_Name_to__c = objActionPlan.Fund__c;
	                        		}
		                        	else //if(objET_MF_1.Rejected_Tracker__c != null)
		                        	{
		                        		system.debug('--------in else-----'+objET_MF_1);
		                        		objET_MF_1.Total_Remaining_Balance__c = objActionPlan.Amount__c - mapETidToParentChildExecutedAmount.get(objET_MF_1.ParentExecutionTracker__c); //- Addition of All Closed Executed Amount
		                        	}
		                        	//===========================Common Data 
			                        objET_MF_1.Suggested_Amount__c = objActionPlan.Amount__c;
			                        /*
			                        objET_MF_1.Approve_Action_Plan__c = objActionPlan.Id;
			                        objET_MF_1.Goal__c = objActionPlan.Goal__c;
			                        objET_MF_1.Type__c = 'Lumpsum';
			                        objET_MF_1.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
			                        objET_MF_1.Email__c = objActionPlan.Account__r.PersonEmail;
			                        objET_MF_1.DOB__c = objActionPlan.Account__r.PersonBirthdate;
			                        objET_MF_1.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
			                        objET_MF_1.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
			                        objET_MF_1.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
			                        objET_MF_1.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
			                        objET_MF_1.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
			                        objET_MF_1.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
			                        objET_MF_1.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
			                        objET_MF_1.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
			                        objET_MF_1.Scheme_Name_Policy_Name__c = objActionPlan.Product_Name__c;
			                        objET_MF_1.Communication_Address__c = strAddress;
		                        	system.debug('-------objET_MF_1-----'+objET_MF_1);*/
		                        	lstETrecords.add(objET_MF_1);
	                        	}
                    		}
                        }
                        else
                        {
                        	objET_MF.Entity_Name__c = objActionPlan.Account__c;
                        	objET_MF.ET_Status__c = 'Assigned to MET';
                        	objET_MF.Suggested_Amount__c = objActionPlan.Amount__c;
	                        //objET_MF.Actual_Action_Amount__c = objActionPlan.Amount__c;
	                        //objET_MF.Agreed_Amount_Base_Amount__c = objActionPlan.Amount__c;
	                        objET_MF.Total_Remaining_Balance__c = objActionPlan.Amount__c;
	                        
	                        objET_MF.Option__c = objActionPlan.Option__c;
	                        objET_MF.Transaction_Type__c = objActionPlan.Transaction_Type__c;
	                        //Below change done by Gaurav - 7/2/2013 
	                        //  Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
	                        //  Purpose: Execution Tracker changes 
	                        
	                        objET_MF.Executed_Product_Name__c =  objActionPlan.Product_Name__c;
	                        objET_MF.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
	                        //Added on : 20/3/13 : Aditi Satpute : ET Screen Changes
	                        objET_MF.Agreed_Amount_Per_Installment__c = objActionPlan.Amount_Per_Installment__c;
							objET_MF.Agreed_Installments__c = objActionPlan.Installments__c;
							objET_MF.Agreed_Scheme_Name_to__c = objActionPlan.Fund__c;
							
							//===========================Common Data 
                        	objET_MF.Approve_Action_Plan__c = objActionPlan.Id;
	                        objET_MF.Goal__c = objActionPlan.Goal__c;
	                        objET_MF.Type__c = 'Lumpsum';
	                        
	                        objET_MF.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
	                        objET_MF.Email__c = objActionPlan.Account__r.PersonEmail;
	                        objET_MF.DOB__c = objActionPlan.Account__r.PersonBirthdate;
	                        objET_MF.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
	                        objET_MF.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
	                        objET_MF.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
	                        objET_MF.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
	                        objET_MF.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
	                        objET_MF.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
	                        objET_MF.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
	                        objET_MF.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
	                        objET_MF.Scheme_Name_Policy_Name__c = objActionPlan.Product_Name__c;
	                        objET_MF.Communication_Address__c = strAddress;
	                        
	                        lstETrecords.add(objET_MF);
                        }
                        
                    }
                    //Life Insurance, Recommended & General Insurance
                     if(objActionPlan.isInsuranceExecutionTracker__c)
                    {
                    	if(objActionPlan.Item_Type__c.equals('Life Insurance') || objActionPlan.Item_Type__c.equals('General Insurance'))
                    	{
	                        Execution_Tracker__c objET_MF = new Execution_Tracker__c();
	                        List<Execution_Tracker__c>  lstET_MF = new List<Execution_Tracker__c>();
	                        if(mapApIdToET.containsKey(objActionPlan.Id))
	                        {
	                        	lstET_MF = mapApIdToET.get(objActionPlan.Id);
	                        	for(Execution_Tracker__c objET_MF_1 : lstET_MF)
                    			{
	                        		system.debug('---------objET_MF.Application_Status__c-------'+objET_MF.Application_Status__c);
		                        	system.debug('---------objET_MF.ParentExecutionTracker__c-------'+objET_MF.ParentExecutionTracker__c);
		                        	system.debug('---------objET_MF------'+objET_MF);
		                        	//if(objET_MF.Application_Status__c != 'Opened' && objET_MF.Application_Status__c != '')
		                        	/*if((objET_MF.Application_Status__c == 'Processed' || objET_MF.Application_Status__c == 'Closed'  || objET_MF.ParentExecutionTracker__c != null))
	                        	   	{
		                        		//continue;
		                        	}*/
		                        	if((objET_MF_1.Application_Status__c != 'Processed' && objET_MF_1.Application_Status__c != 'Closed' && objET_MF_1.Application_Status__c != 'Rejected'))
		                        	{
		                        		if(objET_MF_1.ParentExecutionTracker__c == null)
                        				{
			                        		if(objActionPlan.Item_Type__c.equals('Life Insurance'))
					                        {
					                            objET_MF_1.Policy_Name__c = objActionPlan.Policy_Name__c;
					                            //objET_MF_1.Scheme_Name_Policy_Name__c = objActionPlan.Policy_Name__c;
					                            //Added on:18/03/2013 : Aditi Satpute : ET changes 
								   				objET_MF_1.Term_No_Of_Years__c = objActionPlan.Tenure_of_Insurance__c;
								   				
								   				/*if(objActionPlan.Insurance__r.Entity__r.LastName == null)
								          		{
								          			objET_MF_1.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.FirstName;
								          		}
								          		else if(objActionPlan.Insurance__r.Entity__r.FirstName == null )
								          		{
								          			objET_MF_1.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.LastName;
								          		}
								          		else if(objActionPlan.Insurance__r.Entity__r.LastName != null && objActionPlan.Insurance__r.Entity__r.FirstName != null)
								          		{
								          			objET_MF_1.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.FirstName +' '+ objActionPlan.Insurance__r.Entity__r.LastName;
								          		}
								          		else 
								          		{
								          			objET_MF_1.Insured_Name__c = '';
								          		}*/
								          		//objET_MF_1.Remarks__c = objActionPlan.InsuranceRemark__c;
					                            //Below change done by Gaurav - 7/2/2013 
					                            //  Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
					                            //  Purpose: Execution Tracker changes 
					                           
					                           	//objET_MF_1.Executed_Product_Name__c = objActionPlan.Policy_Name__c != null ? objActionPlan.Policy_Name__c : objActionPlan.Insurance__r.Policy_Type__c;
					                            //Changed Suggested Amount from Suggested cover to SumAssured 
					                            //  Date : 18/3/13 : Aditi Satpute : ET changes : Suggested by Vinita
					                            //objET_MF_1.Suggested_Amount__c = objActionPlan.Insurance__r.Suggested_Cover_General_Insurance__c;
					                           // objET_MF_1.Suggested_Amount__c = objActionPlan.Sum_Assured_Rs__c;
					                           // objET_MF_1.Actual_Action_Amount__c = objActionPlan.Sum_Assured_Rs__c;
					                            //objET_MF_1.Agreed_Amount_Base_Amount__c = objActionPlan.Sum_Assured_Rs__c;
					                            objET_MF_1.Total_Remaining_Balance__c = objActionPlan.Sum_Assured_Rs__c;
					                            //objET_MF_1.Asset_Class_Policy_Type__c = objActionPlan.Policy_Type__c;
					                            //objET_MF_1.Agreed_Amount__c = objET_MF_1.Suggested_Amount__c;
					                            //Added on:18/02/2013 : Aditi Satpute : AP changes 
								   				objET_MF_1.Sum_Assured__c = objActionPlan.Sum_Assured_Rs__c;
					                        }
					                        else
					                        {
					                            //Commented on:18/02/2013 : Aditi Satpute : AP changes : remove Policy Name
												//objET_MF.Policy_Name__c = objActionPlan.Insurance__r.Policy_Name__c;
												
												//Added on:18/02/2013 : Aditi Satpute : AP changes : remove Policy Name
												objET_MF_1.Policy_Name__c = objActionPlan.Product_Name__c;
												
												//Added on:18/02/2013 : Aditi Satpute : AP changes : remove Policy Name
												//objET_MF.Scheme_Name_Policy_Name__c = objActionPlan.Product_Name__c;
												
												//Added on:18/02/2013 : Aditi Satpute : AP changes : remove Policy Name
												//objET_MF.Executed_Product_Name__c = objActionPlan.Product_Name__c!=null ? objActionPlan.Product_Name__c:objActionPlan.Policy_Type__c;
												
												//Commented on:19/02/2013 : Aditi Satpute : AP changes : Added new GI records
												//objET_MF.Sum_Assured__c = objActionPlan.Insurance__r.Sum_Assured_Rs__c;
												//Added on:19/02/2013 : Aditi Satpute : AP changes : Added new GI records
												objET_MF_1.Sum_Assured__c = objActionPlan.Sum_Assured_Rs__c;
												objET_MF_1.Asset_Class_Policy_Type__c = objActionPlan.Policy_Type__c;
												
												//Added on:19/03/2013 : Aditi Satpute : ET changes
												objET_MF_1.Insured_Name__c = objActionPlan.Insured__c;
					                            //Below change done by Gaurav - 7/2/2013 
					                            //  Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
					                            //  Purpose: Execution Tracker changes 
					                           //  Old :  //objET_MF.Suggested_Amount__c = objActionPlan.Insurance__r.Premium_Amount_Rs__c;
					                            
					                            
				                             	//objET_MF.Actual_Action_Amount__c = objET_MF.Sum_Assured__c;
				                             	//objET_MF.Agreed_Amount_Base_Amount__c = objET_MF.Sum_Assured__c;
				                             	objET_MF_1.Total_Remaining_Balance__c = objET_MF_1.Sum_Assured__c;
				                             	
					                            //objET_MF.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
					                        }
                        				}
			                        	else //if(objET_MF_1.Rejected_Tracker__c != null)
			                        	{ 
			                        		objET_MF_1.Total_Remaining_Balance__c = objActionPlan.Sum_Assured_Rs__c - mapETidToParentChildExecutedAmount.get(objET_MF_1.ParentExecutionTracker__c); //- Addition of All Closed Executed Amount
			                        	}
		                        	
			                        	//===========================Common Data 
			                        	objET_MF_1.Suggested_Amount__c =  objActionPlan.Sum_Assured_Rs__c;
			                        	//objET_MF_1.Premium__c = objActionPlan.Premium_Amount_Rs__c;
			                        	/*
			                        	objET_MF_1.Policy_Number__c = objActionPlan.Insurance__r.Policy_Number__c;
			                        	objET_MF_1.Approve_Action_Plan__c = objActionPlan.Id;
				                        objET_MF_1.Goal__c = objActionPlan.Goal__c;
				                        objET_MF_1.Type__c = objActionPlan.Item_Type__c;
				                        //objET_MF_1.Asset_Class_Policy_Type__c = objActionPlan.Insurance__r.Policy_Type__c;
				                       
				                        //objET_MF_1.Suggested_Amount__c = objActionPlan.Insurance__r.Premium_Amount_Rs__c;
				                        objET_MF_1.Policy_Number__c = objActionPlan.Insurance__r.Policy_Number__c;
				                        objET_MF_1.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
				                        objET_MF_1.Email__c = objActionPlan.Account__r.PersonEmail;
				                        objET_MF_1.DOB__c = objActionPlan.Account__r.PersonBirthdate;
				                        objET_MF_1.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
				                        objET_MF_1.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
				                        objET_MF_1.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
				                        objET_MF_1.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
				                        objET_MF_1.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
				                        objET_MF_1.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
				                        objET_MF_1.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
				                        objET_MF_1.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
				                        objET_MF_1.Communication_Address__c = strAddress;*/
				                        
				                        lstETrecords.add(objET_MF_1);
		                        	}
		                        }
                			}
	                        else
	                        {
	                        	objET_MF.Entity_Name__c = objActionPlan.Account__c;
	                        	objET_MF.ET_Status__c = 'Assigned to MET';
	                        	if(objActionPlan.Item_Type__c.equals('Life Insurance'))
		                        {
		                            objET_MF.Policy_Name__c = objActionPlan.Policy_Name__c;
		                            objET_MF.Scheme_Name_Policy_Name__c = objActionPlan.Policy_Name__c;
		                            //Added on:18/03/2013 : Aditi Satpute : ET changes 
					   				objET_MF.Term_No_Of_Years__c = objActionPlan.Tenure_of_Insurance__c;
					   				
					   				/*if(objActionPlan.Insurance__r.Entity__r.LastName == null)
					          		{
					          			objET_MF.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.FirstName;
					          		}
					          		else if(objActionPlan.Insurance__r.Entity__r.FirstName == null )
					          		{
					          			objET_MF.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.LastName;
					          		}
					          		else if(objActionPlan.Insurance__r.Entity__r.LastName != null && objActionPlan.Insurance__r.Entity__r.FirstName != null)
					          		{
					          			objET_MF.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.FirstName +' '+ objActionPlan.Insurance__r.Entity__r.LastName;
					          		}
					          		else 
					          		{
					          			objET_MF.Insured_Name__c = '';
					          		}*/
					          		
					          		objET_MF.Insured_Name__c = objActionPlan.Insured__c;
					          		//objET_MF.Remarks__c = objActionPlan.InsuranceRemark__c;
		                           //Below change done by Gaurav - 7/2/2013 
		                            //  Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
		                            //  Purpose: Execution Tracker changes 
		                           
		                           	objET_MF.Executed_Product_Name__c = objActionPlan.Policy_Name__c != null ? objActionPlan.Policy_Name__c : objActionPlan.Policy_Type__c;
		                            //Changed Suggested Amount from Suggested cover to SumAssured 
		                            //  Date : 18/3/13 : Aditi Satpute : ET changes : Suggested by Vinita
		                            //objET_MF.Suggested_Amount__c = objActionPlan.Insurance__r.Suggested_Cover_General_Insurance__c;
		                            objET_MF.Suggested_Amount__c = objActionPlan.Sum_Assured_Rs__c;
		                            //objET_MF.Actual_Action_Amount__c = objActionPlan.Sum_Assured_Rs__c;
		                            //objET_MF.Agreed_Amount_Base_Amount__c = objActionPlan.Sum_Assured_Rs__c;
		                            objET_MF.Total_Remaining_Balance__c = objActionPlan.Sum_Assured_Rs__c;
		                            objET_MF.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
		                            //Added on:18/02/2013 : Aditi Satpute : AP changes 
					   				objET_MF.Sum_Assured__c = objActionPlan.Sum_Assured_Rs__c;
		                        }
		                        else
		                        {
		                            //Commented on:18/02/2013 : Aditi Satpute : AP changes : remove Policy Name
									//objET_MF.Policy_Name__c = objActionPlan.Insurance__r.Policy_Name__c;
									
									//Added on:18/02/2013 : Aditi Satpute : AP changes : remove Policy Name
									objET_MF.Policy_Name__c = objActionPlan.Product_Name__c;
									
									//Added on:18/02/2013 : Aditi Satpute : AP changes : remove Policy Name
									objET_MF.Scheme_Name_Policy_Name__c = objActionPlan.Product_Name__c;
									
									//Added on:18/02/2013 : Aditi Satpute : AP changes : remove Policy Name
									objET_MF.Executed_Product_Name__c = objActionPlan.Product_Name__c!=null ? objActionPlan.Product_Name__c:objActionPlan.Policy_Type__c;
									
									//Commented on:19/02/2013 : Aditi Satpute : AP changes : Added new GI records
									//objET_MF.Sum_Assured__c = objActionPlan.Insurance__r.Sum_Assured_Rs__c;
									//Added on:19/02/2013 : Aditi Satpute : AP changes : Added new GI records
									objET_MF.Sum_Assured__c = objActionPlan.Sum_Assured_Rs__c;
									objET_MF.Asset_Class_Policy_Type__c = objActionPlan.Policy_Type__c;
									
									//Added on:19/03/2013 : Aditi Satpute : ET changes
									objET_MF.Insured_Name__c = objActionPlan.Insured__c;
		                            //Below change done by Gaurav - 7/2/2013 
		                            //  Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
		                            //  Purpose: Execution Tracker changes 
		                            // Old :  //objET_MF.Suggested_Amount__c = objActionPlan.Insurance__r.Premium_Amount_Rs__c;
		                            
		                            objET_MF.Suggested_Amount__c =  objET_MF.Sum_Assured__c;
	                             	//objET_MF.Actual_Action_Amount__c = objET_MF.Sum_Assured__c;
	                             	//objET_MF.Agreed_Amount_Base_Amount__c = objET_MF.Sum_Assured__c;
	                             	objET_MF.Total_Remaining_Balance__c = objET_MF.Sum_Assured__c;
	                             	
		                            objET_MF.Agreed_Amount__c = objET_MF.Suggested_Amount__c;
		                        }
		                        //===========================Common Data 
	                        	objET_MF.Approve_Action_Plan__c = objActionPlan.Id;
		                        objET_MF.Goal__c = objActionPlan.Goal__c;
		                        objET_MF.Type__c = objActionPlan.Item_Type__c;
		                        objET_MF.Asset_Class_Policy_Type__c = objActionPlan.Policy_Type__c;
		                       	objET_MF.Premium__c = objActionPlan.Premium_Amount_Rs__c;
		                        //objET_MF.Suggested_Amount__c = objActionPlan.Insurance__r.Premium_Amount_Rs__c;
		                        objET_MF.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
		                        objET_MF.Email__c = objActionPlan.Account__r.PersonEmail;
		                        objET_MF.DOB__c = objActionPlan.Account__r.PersonBirthdate;
		                        objET_MF.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
		                        objET_MF.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
		                        objET_MF.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
		                        objET_MF.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
		                        objET_MF.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
		                        objET_MF.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
		                        objET_MF.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
		                        objET_MF.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
		                        objET_MF.Communication_Address__c = strAddress;
		                        lstETrecords.add(objET_MF);
	                        }
	                        
                        }
                        else if(objActionPlan.Item_Type__c.equals(Label.Surrender_Insurance))
                        {
                        	Execution_Tracker__c objET_MF = new Execution_Tracker__c();
                        	List<Execution_Tracker__c>  lstET_MF = new List<Execution_Tracker__c>();
                        	if(mapApIdToET.containsKey(objActionPlan.Id))
	                        {
	                        	lstET_MF = mapApIdToET.get(objActionPlan.Id);
	                        	for(Execution_Tracker__c objET_MF_1 : lstET_MF)
                    			{
	                        		system.debug('---------objET_MF.Application_Status__c-------'+objET_MF.Application_Status__c);
		                        	system.debug('---------objET_MF.ParentExecutionTracker__c-------'+objET_MF.ParentExecutionTracker__c);
		                        	system.debug('---------objET_MF------'+objET_MF);
		                        	//if(objET_MF.Application_Status__c != 'Opened' && (objET_MF.Application_Status__c != '' || objET_MF.Application_Status__c != null))
		                        	/*if((objET_MF.Application_Status__c == 'Processed' || objET_MF.Application_Status__c == 'Closed'  || objET_MF.ParentExecutionTracker__c != null))
		                        	{
		                        		//continue;
		                        	}*/
		                        	if((objET_MF_1.Application_Status__c != 'Processed' && objET_MF_1.Application_Status__c != 'Closed' && objET_MF_1.Application_Status__c != 'Rejected'))
		                        	{
			                        	if(objET_MF_1.ParentExecutionTracker__c == null)
	                        			{
	                        				//objET_MF.Executed_Product_Name__c = objActionPlan.Insurance__r.Insurance_Company__c;
							          		objET_MF_1.Policy_Name__c = objActionPlan.Insurance__r.Policy_Name__c;
				                            objET_MF_1.Scheme_Name_Policy_Name__c = objActionPlan.Insurance__r.Policy_Name__c;
				                            objET_MF_1.Asset_Class_Policy_Type__c = objActionPlan.Insurance__r.Policy_Type__c;
				                            objET_MF_1.Premium__c  = objActionPlan.Insurance__r.Premium_Amount_Rs__c;
				                            //objET_MF.Suggested_Amount__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c;
				                            //objET_MF.Actual_Action_Amount__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c;
				                            //objET_MF.Agreed_Amount_Base_Amount__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c;
				                            
				                            /*Commented on :26/9/13:Aditi: No need to save Amount for Surrender Insurance as Per cal with Kiran: 
				                            objET_MF_1.Total_Remaining_Balance__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c;*/
				                            
				                            //Tracker is opened for this value : Surrender Cash Value
				                            //objET_MF.Agreed_Amount__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c;
	                        			}
			                        	else //if(objET_MF_1.Rejected_Tracker__c != null)
			                        	{
			                        		objET_MF_1.Total_Remaining_Balance__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c - mapETidToParentChildExecutedAmount.get(objET_MF_1.ParentExecutionTracker__c); //- Addition of All Closed Executed Amount
			                        	}
			                        	//===========================Common Data 
				                        objET_MF_1.Approve_Action_Plan__c = objActionPlan.Id;
				                        objET_MF_1.Goal__c = objActionPlan.Goal__c;
				                        
				                        objET_MF_1.Type__c = objActionPlan.Item_Type__c;
				                        if(objActionPlan.Insurance__r.Entity__r.LastName == null)
						          		{
						          			objET_MF_1.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.FirstName;
						          			objET_MF_1.Nominee__c = objActionPlan.Insurance__r.Entity__r.FirstName;
						          			
						          		}
						          		else if(objActionPlan.Insurance__r.Entity__r.FirstName == null )
						          		{
						          			objET_MF_1.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.LastName;
					          				objET_MF_1.Nominee__c = objActionPlan.Insurance__r.Entity__r.LastName;
						          		}
						          		else if(objActionPlan.Insurance__r.Entity__r.LastName != null && objActionPlan.Insurance__r.Entity__r.FirstName != null)
						          		{
						          			objET_MF_1.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.FirstName +' '+ objActionPlan.Insurance__r.Entity__r.LastName;
					          				objET_MF_1.Nominee__c = objActionPlan.Insurance__r.Entity__r.FirstName +' '+ objActionPlan.Insurance__r.Entity__r.LastName;
						          		}
						          		else 
						          		{
						          			objET_MF_1.Insured_Name__c = '';
					          				objET_MF_1.Nominee__c = '';
						          		}
						          		
						          		objET_MF_1.Suggested_Amount__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c;
			                        	objET_MF_1.Policy_Number__c = objActionPlan.Insurance__r.Policy_Number__c;
			                        	/*
				                        objET_MF_1.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
				                        objET_MF_1.Email__c = objActionPlan.Account__r.PersonEmail;
				                        objET_MF_1.DOB__c = objActionPlan.Account__r.PersonBirthdate;
				                        objET_MF_1.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
				                        objET_MF_1.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
				                        objET_MF_1.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
				                        objET_MF_1.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
				                        objET_MF_1.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
				                        objET_MF_1.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
				                        objET_MF_1.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
				                        objET_MF_1.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
				                        objET_MF_1.Communication_Address__c = strAddress;*/
				                        lstETrecords.add(objET_MF_1);
		                        	}
                    			}
	                        }
	                        else
	                        {
	                        	objET_MF.Entity_Name__c = objActionPlan.Account__c;
	                        	objET_MF.ET_Status__c = 'Assigned to MET';
	                        	objET_MF.Executed_Product_Name__c = objActionPlan.Insurance__r.Insurance_Company__c;
				          		objET_MF.Policy_Name__c = objActionPlan.Insurance__r.Policy_Name__c;
	                            objET_MF.Scheme_Name_Policy_Name__c = objActionPlan.Insurance__r.Policy_Name__c;
	                            objET_MF.Asset_Class_Policy_Type__c = objActionPlan.Insurance__r.Policy_Type__c;
	                            objET_MF.Premium__c  = objActionPlan.Insurance__r.Premium_Amount_Rs__c;
	                             /*Commented on :26/9/13:Aditi: No need to save Amount for Surrender Insurance as Per cal with Kiran: 
	                            objET_MF.Suggested_Amount__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c;
	                            objET_MF.Total_Remaining_Balance__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c;
	                            //Tracker is opened for this value : Surrender Cash Value
	                            objET_MF.Agreed_Amount__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c;*/

	                            //objET_MF.Actual_Action_Amount__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c;
	                            //objET_MF.Agreed_Amount_Base_Amount__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c;
	                            
	                            
	                            
	                            
	                            //===========================Common Data 
		                        objET_MF.Approve_Action_Plan__c = objActionPlan.Id;
		                        objET_MF.Goal__c = objActionPlan.Goal__c;
		                        
		                        objET_MF.Type__c = objActionPlan.Item_Type__c;
		                        if(objActionPlan.Insurance__r.Entity__r.LastName == null)
				          		{
				          			objET_MF.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.FirstName;
				          			objET_MF.Nominee__c = objActionPlan.Insurance__r.Entity__r.FirstName;
				          			
				          		}
				          		else if(objActionPlan.Insurance__r.Entity__r.FirstName == null )
				          		{
				          			objET_MF.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.LastName;
			          				objET_MF.Nominee__c = objActionPlan.Insurance__r.Entity__r.LastName;
				          		}
				          		else if(objActionPlan.Insurance__r.Entity__r.LastName != null && objActionPlan.Insurance__r.Entity__r.FirstName != null)
				          		{
				          			objET_MF.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.FirstName +' '+ objActionPlan.Insurance__r.Entity__r.LastName;
			          				objET_MF.Nominee__c = objActionPlan.Insurance__r.Entity__r.FirstName +' '+ objActionPlan.Insurance__r.Entity__r.LastName;
				          		}
				          		else 
				          		{
				          			objET_MF.Insured_Name__c = '';
			          				objET_MF.Nominee__c = '';
				          		}
				          		
				          		 
	                        	objET_MF.Policy_Number__c = objActionPlan.Insurance__r.Policy_Number__c;
		                        objET_MF.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
		                        objET_MF.Email__c = objActionPlan.Account__r.PersonEmail;
		                        objET_MF.DOB__c = objActionPlan.Account__r.PersonBirthdate;
		                        objET_MF.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
		                        objET_MF.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
		                        objET_MF.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
		                        objET_MF.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
		                        objET_MF.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
		                        objET_MF.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
		                        objET_MF.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
		                        objET_MF.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
		                        objET_MF.Communication_Address__c = strAddress;
		                        lstETrecords.add(objET_MF);
	                        }
	                        
                        }
                    }
                    if(objActionPlan.isAddOnExecutionTracker__c)
                    {
                    	//if(objActionPlan.Item_Type__c.equals('Loan'))
                    	{
	                    	Execution_Tracker__c objET_OtherProducts = new Execution_Tracker__c();
	                        List<Execution_Tracker__c>  lstET_OtherProducts = new List<Execution_Tracker__c>();
	                        if(mapApIdToET.containsKey(objActionPlan.Id))
	                        {
	                        	lstET_OtherProducts = mapApIdToET.get(objActionPlan.Id);
	                        	for(Execution_Tracker__c objET_OtherProducts_1 : lstET_OtherProducts)
	                    		{
		                        	if((objET_OtherProducts_1.Application_Status__c != 'Processed' && objET_OtherProducts_1.Application_Status__c != 'Closed' && objET_OtherProducts_1.Application_Status__c != 'Rejected'))
		                        	{
				                        objET_OtherProducts_1.Suggested_Amount__c = objActionPlan.Amount__c;
			                        	lstETrecords.add(objET_OtherProducts_1);
		                        	}
	                    		}
	                        }
	                        else
	                        {
	                        	objET_OtherProducts.Entity_Name__c = objActionPlan.Account__c;
	                        	objET_OtherProducts.ET_Status__c = 'Assigned to MET';
	                        	objET_OtherProducts.Suggested_Amount__c = objActionPlan.Amount__c;
		                        objET_OtherProducts.Executed_Product_Name__c =  objActionPlan.Product_Name__c;
		                        objET_OtherProducts.Agreed_Amount__c = objActionPlan.Amount__c;
	                        	objET_OtherProducts.Approve_Action_Plan__c = objActionPlan.Id;
		                        objET_OtherProducts.Type__c = objActionPlan.Item_Type__c;
		                        objET_OtherProducts.Insured_Name__c = objActionPlan.Insured__c;
		                        if(objActionPlan.Item_Type__c == 'Loan')
		                        {
		                        	objET_OtherProducts.Loan_Type__c = objActionPlan.Loan_Type__c;
		                        }
		                        if(objActionPlan.Item_Type__c == 'Fixed Deposit')
		                        {
		                        	objET_OtherProducts.Company_Name__c =  objActionPlan.Company_Name__c;
		                        	objET_OtherProducts.Period_in_Months__c =  objActionPlan.Period_in_Months__c;
		                        }
		                        else if (objActionPlan.Item_Type__c == 'Bond')
		                        {
		                        	objET_OtherProducts.Company_Name__c =  objActionPlan.Company_Name__c;
		                        	objET_OtherProducts.Bond_Type__c = objActionPlan.Bond_Type__c;
		                        }
		                        objET_OtherProducts.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
		                        objET_OtherProducts.Email__c = objActionPlan.Account__r.PersonEmail;
		                        objET_OtherProducts.DOB__c = objActionPlan.Account__r.PersonBirthdate;
		                        objET_OtherProducts.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
		                        objET_OtherProducts.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
		                        objET_OtherProducts.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
		                        objET_OtherProducts.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
		                        objET_OtherProducts.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
		                        objET_OtherProducts.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
		                        objET_OtherProducts.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
		                        objET_OtherProducts.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
		                        objET_OtherProducts.Scheme_Name_Policy_Name__c = objActionPlan.Product_Name__c;
		                        objET_OtherProducts.Communication_Address__c = strAddress;
		                        lstETrecords.add(objET_OtherProducts);
	                        }
	                    }
	                    /*if(objActionPlan.Item_Type__c.equals('Fixed Deposit'))
                    	{
	                    	Execution_Tracker__c objET_FixedDeposit = new Execution_Tracker__c();
	                        List<Execution_Tracker__c>  lstET_FixedDeposit = new List<Execution_Tracker__c>();
	                        if(mapApIdToET.containsKey(objActionPlan.Id))
	                        {
	                        	lstET_FixedDeposit = mapApIdToET.get(objActionPlan.Id);
	                        	for(Execution_Tracker__c objET_FixedDeposit_1 : lstET_FixedDeposit)
	                    		{
		                        	if((objET_FixedDeposit_1.Application_Status__c != 'Processed' && objET_FixedDeposit_1.Application_Status__c != 'Closed' && objET_FixedDeposit_1.Application_Status__c != 'Rejected'))
		                        	{
			                        	//===========================Common Data 
				                        objET_FixedDeposit_1.Suggested_Amount__c = objActionPlan.Amount__c;
				                        //objET_Loan_1.Agreed_Amount__c = objActionPlan.Amount__c;
			                        	lstETrecords.add(objET_FixedDeposit_1);
		                        	}
	                    		}
	                        }
	                        else
	                        {
	                        	objET_FixedDeposit.Entity_Name__c = objActionPlan.Account__c;
	                        	objET_FixedDeposit.ET_Status__c = 'Assigned to MET';
	                        	objET_FixedDeposit.Suggested_Amount__c = objActionPlan.Amount__c;
		                        objET_FixedDeposit.Executed_Product_Name__c =  objActionPlan.Product_Name__c;
		                        objET_FixedDeposit.Company_Name__c =  objActionPlan.Company_Name__c;
		                        objET_FixedDeposit.Period_in_Months__c =  objActionPlan.Period_in_Months__c;
		                        objET_FixedDeposit.Agreed_Amount__c = objActionPlan.Amount__c;
	                        	objET_FixedDeposit.Approve_Action_Plan__c = objActionPlan.Id;
		                        objET_FixedDeposit.Type__c = objActionPlan.Item_Type__c;
		                        objET_FixedDeposit.Insured_Name__c = objActionPlan.Insured__c;
		                        
		                        objET_FixedDeposit.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
		                        objET_FixedDeposit.Email__c = objActionPlan.Account__r.PersonEmail;
		                        objET_FixedDeposit.DOB__c = objActionPlan.Account__r.PersonBirthdate;
		                        objET_FixedDeposit.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
		                        objET_FixedDeposit.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
		                        objET_FixedDeposit.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
		                        objET_FixedDeposit.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
		                        objET_FixedDeposit.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
		                        objET_FixedDeposit.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
		                        objET_FixedDeposit.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
		                        objET_FixedDeposit.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
		                        objET_FixedDeposit.Scheme_Name_Policy_Name__c = objActionPlan.Product_Name__c;
		                        objET_FixedDeposit.Communication_Address__c = strAddress;
		                        lstETrecords.add(objET_FixedDeposit);
	                        }
	                    }
	                    if(objActionPlan.Item_Type__c.equals('Bond'))
                    	{
	                    	Execution_Tracker__c objET_Bond = new Execution_Tracker__c();
	                        List<Execution_Tracker__c>  lstET_Bond = new List<Execution_Tracker__c>();
	                        if(mapApIdToET.containsKey(objActionPlan.Id))
	                        {
	                        	lstET_Bond = mapApIdToET.get(objActionPlan.Id);
	                        	for(Execution_Tracker__c objET_Bond_1 : lstET_Bond)
	                    		{
		                        	if((objET_Bond_1.Application_Status__c != 'Processed' && objET_Bond_1.Application_Status__c != 'Closed' && objET_Bond_1.Application_Status__c != 'Rejected'))
		                        	{
		                        		
			                        	//===========================Common Data 
				                        objET_Bond_1.Suggested_Amount__c = objActionPlan.Amount__c;
				                        //objET_Loan_1.Agreed_Amount__c = objActionPlan.Amount__c;
			                        	lstETrecords.add(objET_Bond_1);
		                        	}
	                    		}
	                        }
	                        else
	                        {
	                        	objET_Bond.Entity_Name__c = objActionPlan.Account__c;
	                        	objET_Bond.ET_Status__c = 'Assigned to MET';
	                        	objET_Bond.Suggested_Amount__c = objActionPlan.Amount__c;
		                        objET_Bond.Executed_Product_Name__c =  objActionPlan.Product_Name__c;
		                        objET_Bond.Company_Name__c =  objActionPlan.Company_Name__c;
		                        objET_Bond.Period_in_Months__c =  objActionPlan.Period_in_Months__c;
		                        objET_Bond.Agreed_Amount__c = objActionPlan.Amount__c;
	                        	objET_Bond.Approve_Action_Plan__c = objActionPlan.Id;
		                        objET_Bond.Type__c = objActionPlan.Item_Type__c;
		                        objET_Bond.Insured_Name__c = objActionPlan.Insured__c;
		                        
		                        objET_Bond.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
		                        objET_Bond.Email__c = objActionPlan.Account__r.PersonEmail;
		                        objET_Bond.DOB__c = objActionPlan.Account__r.PersonBirthdate;
		                        objET_Bond.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
		                        objET_Bond.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
		                        objET_Bond.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
		                        objET_Bond.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
		                        objET_Bond.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
		                        objET_Bond.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
		                        objET_Bond.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
		                        objET_Bond.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
		                        objET_Bond.Scheme_Name_Policy_Name__c = objActionPlan.Product_Name__c;
		                        objET_Bond.Communication_Address__c = strAddress;
		                        lstETrecords.add(objET_Bond);
	                        }
	                    }*/
                    }
                }   
             
                Messaging.SingleEmailMessage emailToEntity = new Messaging.SingleEmailMessage();
                Messaging.SingleEmailMessage emailToMet = new Messaging.SingleEmailMessage();
                Account objBPAccount = new Account();
                Contact objContact = new Contact();
                List<String> lstToEntityOwnerAddresses = new List<String>();
                List<String> lstToMetAddresses = new List<String>();
                List<Execution_Tracker__c> lstETrecordsWithMETowner = new List<Execution_Tracker__c>();
                
                Account objAccount = [Select Id, Name,Related_To__c,OwnerId, owner.name,owner.Email,MST_Team_Member__r.Team_Member__c,
                						Virtual_Partner__c,Business_Unit__c  
                						 from Account where Id =: beanObj.entityId];
                List<Event_Master__c> lstEM = [Select e.Task_Event_Master__c, e.Name, e.Event_Id__c, e.Escalation_Event_Master__c 
        									From Event_Master__c e
        									where isActive__c = true 
        									and (Name =: Label.ET_Creation_Event)];
        									
        									
		        map<String,Event_Master__c> mapNameToEventMaster = new map<String,Event_Master__c>();
		        for(Event_Master__c objEM : lstEM)
		        {
		        	if(!mapNameToEventMaster.containsKey(objEM.Name))
		        		mapNameToEventMaster.put(objEM.Name,objEM);
		        }
		        system.debug('----mapNameToEventMaster.keySet()----'+mapNameToEventMaster.keySet());
		        
                List<Notification_Queue__c> lstInsertNotificationQueue = new List<Notification_Queue__c>();
                
                if(objAccount != null)
                {
                	if(objAccount.MST_Team_Member__c == null)
                	{
         				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO ,'Please add MST Member for Client "'+objAccount.Name+'".'));
                		return null;
         			}
                    //Send Email to Entity Owner & MET - If Entity is Business Partner Entity
                    if(objAccount.Related_To__c.equalsIgnoreCase('Business Partner'))
                    {
                    	Map<Id,User> mapIdToUser = new Map<Id,User>([select Id,Name,ContactId , ManagerId, Email from User]);
                        lstToMetAddresses = new List<String>();
                        lstToEntityOwnerAddresses = new List<String>();
                        lstETrecordsWithMETowner = new List<Execution_Tracker__c>();
                        
                        emailToMet = new Messaging.SingleEmailMessage();
                        emailToEntity = new Messaging.SingleEmailMessage();
                        //Send Email to Entity Owner
                        if(mapIdToUser.containsKey(objAccount.OwnerId))
                        {
                            User objBPEntityOwnerUser = mapIdToUser.get(objAccount.OwnerId);
                            
                            if(objBPEntityOwnerUser.ContactId != null)
                            {
                                //To fetch Contact of that particular BP User
                                objContact = [select AccountId from Contact where id =: objBPEntityOwnerUser.ContactId];
                                //To fetch Account with previously fetched Contact
                                objBPAccount = [select Id, Email_ID__c, OwnerId, Channel_Manager__c , Channel_Manager__r.Name , IsCreatedByPartner__c, Phone, Name from Account where id =: objContact.AccountId];    
                            }
                            //User objBPAccountUser = mapIdToUser.get(objBPAccount.OwnerId);
                            
                           /*if(objBPEntityOwnerUser.Email != null)
                                lstToEntityOwnerAddresses.add(objBPEntityOwnerUser.Email);
                            if(!lstToEntityOwnerAddresses.isEmpty())
                                emailToEntity.setToAddresses( lstToEntityOwnerAddresses );
                                
                            emailToEntity.setSubject( 'Execution Tracker Generated for ' + objAccount.Name);        
                            emailToEntity.setHtmlBody('Dear '+objAccount.Owner.Name+',<br/><br/>Action Plan is being generated and Execution Tracker records of "'
                                                        +objAccount.Name+'" are being created for the Member Engagement Team.<br/><br/>'
                                                        +'Thanks<br/>'+ objBPAccount.Channel_Manager__r.Name);
                            emailToEntity.setSenderDisplayName(objBPAccount.Channel_Manager__r.Name);
                            
                            // Sends the email to Entity Owner
                            if(mapApIdToET.size() == 0)
                            Messaging.SendEmailResult [] arrBPEntityOwnerResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToEntity});
                            */
                            
                            
                            
                            String domain = URL.getSalesforceBaseUrl().toExternalForm();
			                String TargetLink = domain + '/' + objAccount.Id;

			                map<String, String> mapOldTOActual = new map<String, String>();
					        mapOldTOActual.put('TargetLink', TargetLink); 
					        mapOldTOActual.put('MemberOwnerName', objBPAccount.Channel_Manager__r.Name);   
					                
					        String getOldPSTName = FreedomUtils.returnPayLoad(mapOldTOActual); 
					                
							if(mapNameToEventMaster.containsKey(Label.ET_Creation_Event))
							{
					              Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
					              objNotificationQueue.Partner_Id__c = objAccount.Virtual_Partner__c;
					              objNotificationQueue.Biz_Unit__c = objAccount.Business_Unit__c;
					              objNotificationQueue.Member_Id__c = objAccount.Id;
					              objNotificationQueue.Event__c = mapNameToEventMaster.get(Label.ET_Creation_Event).Id;
					              objNotificationQueue.Channel_Type__c = 'Email';
					              objNotificationQueue.PayloadXML__c = getOldPSTName;
					              lstInsertNotificationQueue.add(objNotificationQueue);
							}    
                            
                            //Send Chatter Notification to Entity Owner
                            /*FeedItem entityPost = new FeedItem();
                            entityPost.ParentId = objAccount.OwnerId;
                            entityPost.Body = 'Action Plan is being generated and Execution Tracker records of "'
                                                +objAccount.Name+'" are being created for the Member Engagement Team.';
                            insert entityPost;*/
                        }
                        
                        //Send Email to Bussiness Partner's MET
                        if(mapIdToUser.containsKey(objAccount.OwnerId))
                        {
                            User objBusinessEntityUser = mapIdToUser.get(objAccount.OwnerId);
                            if(mapIdToUser.containsKey(objBPAccount.Channel_Manager__c))    
                            {                               
                                User objChannelManagerUser = mapIdToUser.get(objBPAccount.Channel_Manager__c);
                          /*  List<Workstation__c> lstBPWorkstation = [Select Member_Engagement__c, Member_Engagement__r.Name, Financial_Planner__c 
                                                                From Workstation__c 
                                                                where Financial_Planner__c = : objBPAccount.Channel_Manager__c];
                            if(lstBPWorkstation.isEmpty())
                            {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Please add Entity Owner as Financial Planner in Workstation'));
                                return null;
                            }                                   
                            
                                
                                if(lstBPWorkstation[0].Member_Engagement__c != null)
                                {
                                    if(mapIdToUser.containsKey(lstBPWorkstation[0].Member_Engagement__c))
                                    {
                                        User objBusinessPartnerMetUser = mapIdToUser.get(lstBPWorkstation[0].Member_Engagement__c);
                                        if(objBusinessPartnerMetUser.Email != null)
                                            lstToMetAddresses.add(objBusinessPartnerMetUser.Email);
                                        if(!lstToMetAddresses.isEmpty())
                                         emailToMet.setToAddresses( lstToMetAddresses );
                                    }
                                }
                                if(mapApIdToET.size() == 0)
                                {
	                                //Sends the mail to MET
	                                emailToMet.setSubject( 'Execution Tracker Generated for ' + objAccount.Name);       
	                                String domain = URL.getSalesforceBaseUrl().toExternalForm();
	                                String TargetLink = domain + '/' + objAccount.Id;
	                                
	                                emailToMet.setHtmlBody('Dear '+lstBPWorkstation[0].Member_Engagement__r.Name+',<br/><br/>Action Plan has been generated for "'
	                                                              +objAccount.Name+'" and executions can be done. Please go through the related Execution Trackers.<br/>Click here : <a href=\''
	                                                              +TargetLink+'\'>'+TargetLink+'</a> <br/><br/> Thanks,<br/>'+objChannelManagerUser.Name);
	                                emailToMet.setSenderDisplayName(objChannelManagerUser.Name);
	                                Messaging.SendEmailResult [] arrBusinessPartnerMetResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToMet});
	                               
	                                //Send Chatter Notification to MET
	                                FeedItem post = new FeedItem();
	                                post.ParentId = lstBPWorkstation[0].Member_Engagement__c;
	                                post.Body = 'Action Plan has been generated for "' +objAccount.Name+ '" and executions can be done.'+
	                                             'Please go through the related Execution Trackers.';
	                                insert post;
                                }
                                */
                                List<Execution_Tracker__c> lstAlreadyPresentAssignMetOwner = new List<Execution_Tracker__c>();
                                for(Execution_Tracker__c objAssignMetOwner : lstETrecords)
                                {
                                	Execution_Tracker__c objAlreadyPresentAssignMetOwner = new Execution_Tracker__c();
                                	if(objAssignMetOwner.Type__c != null && objAssignMetOwner.Type__c.equalsIgnoreCase('Lumpsum') && objAssignMetOwner.Approve_Action_Plan__r.Investment_Asset__c != null)
					         		{
					         			lstAlreadyPresentAssignMetOwner = mapApIdToET.get(objAssignMetOwner.Approve_Action_Plan__c+'Lumpsum');
					         		}
					         		else if(objAssignMetOwner.Type__c != null && objAssignMetOwner.Type__c.equalsIgnoreCase('SIP') && objAssignMetOwner.Approve_Action_Plan__r.Investment_Asset__c != null)
					         		{
					         			lstAlreadyPresentAssignMetOwner = mapApIdToET.get(objAssignMetOwner.Approve_Action_Plan__c+'SIP');
					         		}
					         		else
					         		{
					         			lstAlreadyPresentAssignMetOwner = mapApIdToET.get(objAssignMetOwner.Approve_Action_Plan__c);
					         		}
					         		if(lstAlreadyPresentAssignMetOwner == null)
					         		{
					         			//if(!lstBPWorkstation.isEmpty())
					         			if(objAccount.MST_Team_Member__c != null)
					         			{
		                        			objAssignMetOwner.Owner__c = objAccount.MST_Team_Member__r.Team_Member__c;//lstBPWorkstation[0].Member_Engagement__c;
			                           		// objAssignMetOwner.Send_Email__c = true;
			                           		// objAssignMetOwner.Send_Email_Datetime__c = System.now();
			                          		//  objAssignMetOwner.Send_SMS__c = true;
			                          		//  objAssignMetOwner.Send_SMS_Datetime__c = System.now();
					         			}
					         		}
					         		lstETrecordsWithMETowner.add(objAssignMetOwner);
                                    
                                }
                                if(mapApIdToET.size() == 0)
                                {
	                                String domain = URL.getSalesforceBaseUrl().toExternalForm();
			                    	String TargetLink = domain + '/' + objAccount.Id;

			                        map<String, String> mapOldTOActual = new map<String, String>();
					                mapOldTOActual.put('TargetLink', TargetLink); 
					                mapOldTOActual.put('MemberOwnerName', objChannelManagerUser.Name);   
					                
					                String getOldPSTName = FreedomUtils.returnPayLoad(mapOldTOActual); 
					                
									if(mapNameToEventMaster.containsKey(Label.ET_Creation_Event))
									{
					                    Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
					                    objNotificationQueue.Partner_Id__c = objAccount.Virtual_Partner__c;
					                    objNotificationQueue.Biz_Unit__c = objAccount.Business_Unit__c;
					                    objNotificationQueue.Member_Id__c = objAccount.Id;
					                    objNotificationQueue.Event__c = mapNameToEventMaster.get(Label.ET_Creation_Event).Id;
					                    objNotificationQueue.Channel_Type__c = 'Email';
					                    objNotificationQueue.PayloadXML__c = getOldPSTName;
					                    lstInsertNotificationQueue.add(objNotificationQueue);
									}    
	                                if(objAccount.MST_Team_Member__c != null)
					         		{
	                                	//Send Chatter Notification to MET
	                                	FeedItem post = new FeedItem();
	                                	post.ParentId = objAccount.MST_Team_Member__r.Team_Member__c;//lstBPWorkstation[0].Member_Engagement__c;
	                                	post.Body = 'Action Plan has been generated for "' +objAccount.Name+ '" and executions can be done.'+
	                                             'Please go through the related Execution Trackers.';
	                                	insert post;
					         		}
                                }
                                //insert ET records  into data base with Owner as MET
		                        if(!lstETrecordsWithMETowner.isEmpty())         
		                           	upsert lstETrecordsWithMETowner;
                              	if(!lstInsertNotificationQueue.isEmpty())
		            				insert lstInsertNotificationQueue;
                            }
                        }
                    }
                    //if Entity is Ffreedom Entity or Virtual PArtner Entity
                    else 
                    {
                        //Send Email to Entity Owner
                        /*if(mapIdToUser.containsKey(objAccount.OwnerId))
                        {
                            User objEntityOwnerUser = mapIdToUser.get(objAccount.OwnerId);
                            if(objEntityOwnerUser.Email != null)
                                lstToEntityOwnerAddresses.add(objEntityOwnerUser.Email);
                            if(!lstToEntityOwnerAddresses.isEmpty())
                                emailToEntity.setToAddresses( lstToEntityOwnerAddresses );
                            
                            emailToEntity.setSubject( 'Execution Tracker Generated for ' + objAccount.Name);        
                            emailToEntity.setHtmlBody('Dear '+objAccount.Owner.Name+',<br/><br/>Action Plan is being generated and Execution Tracker records of "'
                                                    +objAccount.Name+'" are being created for the Member Engagement Team.<br/><br/> Thanks');
                            emailToEntity.setSenderDisplayName(objAccount.Owner.Name);
                            
                            // Sends the email Notification to Entity Owner
                            Messaging.SendEmailResult [] arrEntityOwnerResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToEntity});
                            
                            //Send Chatter Notification to Entity Owner
                            FeedItem entityPost = new FeedItem();
                            entityPost.ParentId = objAccount.OwnerId;
                            entityPost.Body = 'Action Plan is being generated and Execution Tracker records of "'
                                                +objAccount.Name+'" are being created for the Member Engagement Team.';
                            insert entityPost;
            
                        }*/
                        
                        //Send Email to Ffreedom/Virtual Partner Entity's MET 
                        //Query to fetch MET record from workstation
                       /*
                       lstToMetAddresses = new List<String>();
                       lstToEntityOwnerAddresses = new List<String>();
                       emailToMet = new Messaging.SingleEmailMessage();
                       emailToEntity = new Messaging.SingleEmailMessage(); 
                       List<Workstation__c> lstWorkstation = [Select Member_Engagement__c, Member_Engagement__r.Name, Financial_Planner__c 
                                                         From Workstation__c 
                                                         where Financial_Planner__c = : objAccount.Owner.Id or Member_Engagement__c =: objAccount.Owner.Id];
                                             
                        if(lstWorkstation.isEmpty())
                        {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO ,Label.ET_Workstation_Exception));
                            return null;
                        }
                        else
                        {
                        	if(lstWorkstation[0].Member_Engagement__c != null)
	                        {
	                            if(mapIdToUser.containsKey(lstWorkstation[0].Member_Engagement__c))
	                            {
	                                User objMetUser = mapIdToUser.get(lstWorkstation[0].Member_Engagement__c);
	                                if(objMetUser.Email != null)
	                                    lstToMetAddresses.add(objMetUser.Email);
	                                if(!lstToMetAddresses.isEmpty())
	                                    emailToMet.setToAddresses( lstToMetAddresses );
	                            }
	                        }
	                        
	                        emailToMet.setSubject( 'Execution Tracker Generated for ' + objAccount.Name);       
	                        
	                        
	                        emailToMet.setHtmlBody('Dear '+lstWorkstation[0].Member_Engagement__r.Name+',<br/><br/>Action Plan has been generated for "'
	                                                      +objAccount.Name+'" and executions can be done. Please go through the related Execution Trackers.<br/>Click here : <a href=\''
	                                                      +TargetLink+'\'>'+TargetLink+'</a> <br/><br/> Thanks,<br/>'+objAccount.Owner.Name);
	                        emailToMet.setSenderDisplayName(objAccount.Owner.Name);
	                        if(mapApIdToET.size() == 0)
	                        {
	                        	//Send Chatter Notification to MET
	                        	FeedItem post = new FeedItem();
	                    		post.ParentId = lstWorkstation[0].Member_Engagement__c;
	                        	post.Body = 'Action Plan has been generated for "' +objAccount.Name+ '" and executions can be done.'+
	                                     'Please go through the related Execution Trackers.';
	                        	insert post;
	                        
	                        	//Sends the email Notification to MET
                        		Messaging.SendEmailResult [] arrMetResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToMet});
	                        }
                        }*/
                        /**Added on : 27/11/13 : Aditi Satpute**/
                        
                        if(mapApIdToET.size() == 0)
                        {
                        	if(objAccount.MST_Team_Member__c != null)
		         			{
	                        	//Send Chatter Notification to MET
	                        	FeedItem post = new FeedItem();
	                    		post.ParentId = objAccount.MST_Team_Member__r.Team_Member__c;//lstWorkstation[0].Member_Engagement__c;
	                        	post.Body = 'Action Plan has been generated for "' +objAccount.Name+ '" and executions can be done.'+
	                                     'Please go through the related Execution Trackers.';
	                        	insert post;
		         			}
                        	String domain = URL.getSalesforceBaseUrl().toExternalForm();
	                    	String TargetLink = domain + '/' + objAccount.Id;
                        	//Sends the email Notification to MET
                    		//Messaging.SendEmailResult [] arrMetResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToMet});
	                        map<String, String> mapOldTOActual = new map<String, String>();
			                mapOldTOActual.put('TargetLink', TargetLink); 
			                mapOldTOActual.put('MemberOwnerName', objAccount.Owner.Name);   
			                String getOldPSTName = FreedomUtils.returnPayLoad(mapOldTOActual); 
			                
							if(mapNameToEventMaster.containsKey(Label.ET_Creation_Event))
							{
			                    Notification_Queue__c objNotificationQueue = new Notification_Queue__c();
			                    objNotificationQueue.Partner_Id__c = objAccount.Virtual_Partner__c;
			                    objNotificationQueue.Biz_Unit__c = objAccount.Business_Unit__c;
			                    objNotificationQueue.Member_Id__c = objAccount.Id;
			                    objNotificationQueue.Event__c = mapNameToEventMaster.get(Label.ET_Creation_Event).Id;
			                    objNotificationQueue.Channel_Type__c = 'Email';
			                    objNotificationQueue.PayloadXML__c = getOldPSTName;
			                    lstInsertNotificationQueue.add(objNotificationQueue);
							}    
                        }
                        
                        List<Execution_Tracker__c> lstAlreadyPresentAssignMetOwner = new List<Execution_Tracker__c>();
                        for(Execution_Tracker__c objAssignMetOwner : lstETrecords)
                        {
                        	
                        	if(objAssignMetOwner.Type__c != null && objAssignMetOwner.Type__c.equalsIgnoreCase('Lumpsum') && objAssignMetOwner.Approve_Action_Plan__r.Investment_Asset__c != null)
			         		{
			         			//objAlreadyPresentAssignMetOwner = mapApIdToET.get(objAssignMetOwner.Approve_Action_Plan__c+'Lumpsum');
			         			lstAlreadyPresentAssignMetOwner = mapApIdToET.get(objAssignMetOwner.Approve_Action_Plan__c+'Lumpsum');
			         		}
			         		else if(objAssignMetOwner.Type__c != null && objAssignMetOwner.Type__c.equalsIgnoreCase('SIP') && objAssignMetOwner.Approve_Action_Plan__r.Investment_Asset__c != null)
			         		{
			         			//objAlreadyPresentAssignMetOwner = mapApIdToET.get(objAssignMetOwner.Approve_Action_Plan__c+'SIP');
			         			lstAlreadyPresentAssignMetOwner = mapApIdToET.get(objAssignMetOwner.Approve_Action_Plan__c+'SIP');
			         		}
			         		else
			         		{
			         			//objAlreadyPresentAssignMetOwner = mapApIdToET.get(objAssignMetOwner.Approve_Action_Plan__c);
			         			lstAlreadyPresentAssignMetOwner = mapApIdToET.get(objAssignMetOwner.Approve_Action_Plan__c);
			         		}
			         		
			         		if(lstAlreadyPresentAssignMetOwner == null)
			         		{
			         			//if(!lstWorkstation.isEmpty())
			         			if(objAccount.MST_Team_Member__c != null)
			         			{
                        			objAssignMetOwner.Owner__c = objAccount.MST_Team_Member__r.Team_Member__c;//lstWorkstation[0].Member_Engagement__c;
	                           		// objAssignMetOwner.Send_Email__c = true;
	                           		// objAssignMetOwner.Send_Email_Datetime__c = System.now();
	                          		//  objAssignMetOwner.Send_SMS__c = true;
	                          		//  objAssignMetOwner.Send_SMS_Datetime__c = System.now();
			         			}
			         		}
			         		lstETrecordsWithMETowner.add(objAssignMetOwner);
                      		system.debug('*********lstETrecordsWithMETowner**********'+lstETrecordsWithMETowner);
                        }
                        
                        //insert ET records  into data base with Owner as MET
                        if(!lstETrecordsWithMETowner.isEmpty())         
                           upsert lstETrecordsWithMETowner;    
                        if(!lstInsertNotificationQueue.isEmpty())
            				insert lstInsertNotificationQueue;
                       
                    }
                }
            }
            pageReference pageRef = new pageReference('/apex/ExecTracker?entityId='+beanObj.entityId+'&tabname=Financial Planning');
            return pageRef ;
        }
        return null;
    }
    
 	public List<String> lstAddwithComma 
	{
		get
		{
			if(address != null && address != '')
			{
				double counter=0;
				lstAddwithComma = new List<String>();
				List<String> lstAdd = new List<String>();
				system.debug('********address*********'+address);
				lstAdd = address.split(',');
				system.debug('********lstAdd*********'+lstAdd);
				double lengthAdd=lstAdd.size();
				system.debug('********lengthAdd*********'+lengthAdd);
					
				for(String str:lstAdd)
				{
					if(counter<lengthAdd-1)
					{
						counter++;
						lstAddwithComma.add(str+',');
					}
					else
					{
						lstAddwithComma.add(str);
					}
				}
				//error.debugLog('*******lstAddwithComma*********'+lstAddwithComma);
				return lstAddwithComma;
			}
			else
				return null;
			//return lstAdd;
		}
		set;
	}

	/*Gaurav :(09-12-2013) To Display Loan Type Product Name  in Action Plan */
    public void getLoanVendorsName()
    {   
    	system.debug('*********strPolicyType***'+ApexPages.currentPage().getParameters().get('strPolicyType'));
    	ActionPlanUtility objActionPlanUtility =  new ActionPlanUtility();
    	Integer index = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
    	strPolicyType = '';
    	strPolicyType = beanObj.lstLoan[index].loanType; 
    	beanObj.lstLoan[index].vendorName = '';  
    
    	system.debug('*********strPolicyType***'+strPolicyType);
    	system.debug('*********index***'+index);
    	
    	
    	/*View State Issue : Commented this
    	if(mapProductTypeToLstProducts.containsKey('Loan'))
    	{
    		List<Product_Master__c> lstPM = mapProductTypeToLstProducts.get('Loan');
    		strProductLoan = objActionPlanUtility.getLoanProductName('Loan',strPolicyType,lstPM);
    		system.debug('*********strProductLoan***'+strProductLoan);
    	}*/
    	strProductLoan = objActionPlanUtility.getLoanProductName('Loan',strPolicyType,returnActiveProductMasterList());
		system.debug('*********strProductLoan***'+strProductLoan);
    	//strProductMedical = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getInsuranceProductTypesList(strPolicyType));
    }
    
    
    /*Gaurav :(09-12-2013) To Display Loan Type Product Name  in Action Plan */
    public void getFDVendorsName()
    {   
    	system.debug('*********HIIIIIIIIIIIIIIIII***');
    	system.debug('*********strPolicyType***'+ApexPages.currentPage().getParameters().get('strPolicyType'));
    	ActionPlanUtility objActionPlanUtility =  new ActionPlanUtility();
    	Integer index = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
    	strPolicyType = '';
    	
    	/*View State Issue : Commented this
    	if(mapProductTypeToLstProducts.containsKey('Fixed Deposit'))
    	{
    		system.debug('*********beanObj***'+beanObj.lstFixedDeposit[index].actionPlanFDobj.Company_Name__c);
    		strPolicyType = beanObj.lstFixedDeposit[index].actionPlanFDobj.Company_Name__c; 
	    	//beanObj.lstFixedDeposit[index].actionPlanFDobj.Company_Name__c = '';  
	    
	    	system.debug('*********strPolicyType***'+strPolicyType);
	    	system.debug('*********index***'+index);
	    	
	    	List<Product_Master__c> lstFixedDepositPM;
	    	
	    		lstFixedDepositPM = mapProductTypeToLstProducts.get('Fixed Deposit');
		    	strProductFD = objActionPlanUtility.getFixedDepositProductName('Fixed Deposit',strPolicyType,lstFixedDepositPM);
		    	system.debug('*********strProductLoan***'+strProductFD);
    	}*/
		strPolicyType = beanObj.lstFixedDeposit[index].actionPlanFDobj.Company_Name__c; 
	    
    	system.debug('*********strPolicyType***'+strPolicyType);
    	system.debug('*********index***'+index);
	    	
    	strProductFD = objActionPlanUtility.getFixedDepositProductName('Fixed Deposit',strPolicyType,returnActiveProductMasterList());
    	system.debug('*********strProductLoan***'+strProductFD);
    	
    	//strProductMedical = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getInsuranceProductTypesList(strPolicyType));
    }
    
    public void getBondVendorsName()
    {
    	system.debug('*********HIIIIIIIIIIIIIIIII***');
    	system.debug('*********strPolicyType***'+ApexPages.currentPage().getParameters().get('strPolicyType'));
    	ActionPlanUtility objActionPlanUtility =  new ActionPlanUtility();
    	Integer index = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
    	strPolicyType = '';
    	
    	/*
    	View State Issue : Commented this
    	if(mapProductTypeToLstProducts.containsKey('Bond'))
    	{
    		List<Product_Master__c> lstBondPM;
    		
    		system.debug('*********beanObj***'+beanObj.lstBond[index].actionPlanBondObj.Company_Name__c);
    		strPolicyType = beanObj.lstBond[index].actionPlanBondObj.Company_Name__c; 
	    	//beanObj.lstFixedDeposit[index].actionPlanFDobj.Company_Name__c = '';  
	    
	    	system.debug('*********strPolicyType***'+strPolicyType);
	    	system.debug('*********index***'+index);
    		
    		lstBondPM = mapProductTypeToLstProducts.get('Bond');
	    	strProductBond = objActionPlanUtility.getFixedDepositProductName('Bond',strPolicyType,lstBondPM);
	    	//strProductFD = objActionPlanUtility.getFixedDepositProductName('Fixed Deposit', strPolicyType);
	    	
	    	system.debug('*********strProductLoan***'+strProductBond);
    	}*/
    	
		strPolicyType = beanObj.lstBond[index].actionPlanBondObj.Company_Name__c; 
    
    	system.debug('*********strPolicyType***'+strPolicyType);
    	system.debug('*********index***'+index);
		
    	strProductBond = objActionPlanUtility.getFixedDepositProductName('Bond',strPolicyType,returnActiveProductMasterList());
    	system.debug('*********strProductLoan***'+strProductBond);
    	
    	
    }
    
}