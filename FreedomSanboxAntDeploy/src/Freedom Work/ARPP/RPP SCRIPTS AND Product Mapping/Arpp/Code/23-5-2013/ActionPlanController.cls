/*
    Revision History:
    
    Version     Version Author     Date           Comments
    1.0         Aditi Satpute     27/09/2012     New Action Plan Creation
    1.1         Aditi Satpute     27/12/2012     Add new method showExecutionTracker() to create ET records on click 
                                                 Executon Tracker button from Action Plan page.
*/
public with sharing class ActionPlanController extends FPsidebarDispalyLink
{ 
    public Boolean isPreview {get;set;}
    private ActionPlanServices serviceObj; 
    public Boolean isMailSent{get;set;} 
    public Boolean isSave{get;set;}
    public String address{get;set;}
  
    //Action Plan : Aditi Satpute=20-9-2012=
    public EstatePlanningBean bean {get; set;}
    private EstatePlanningServices service {get; set;}
    public boolean toDisplayFields {get;set;}
    public double SIPSummaryTotal{get;set;}
    public double LumpsumSummaryTotal{get;set;}
    public Integer counter {get;set;}
    public Goal_Profile__c objGoalProfile{get;set;}
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
    public Boolean isNewAP{get;set;}
    public string entity{get;set;}
    public string owner{get;set;}           //Prajakta
    public String emailBody {get; set;}
    public boolean isFPLimitedAccess{get;set;}
    public Map<String, ApprovedPlanBean.SIPFunds> mapStringToSIPFunds{get;set;} 
    
   	//Added on 5/8/2013 : Gaurav : Ap Chagnes : To display product name(Picklist) value of SIP,Limpsum and Insurance 
    public List<SelectOption> lstPolicyType{get;set;}
    
    public String strProductName{get;set;}
    public String strProductMedical{get;set;}
    public String strProductIllness{get;set;}
    public String strProductTopUp{get;set;}
    public String strProductDisabilty{get;set;}
    public String strProductAccident{get;set;}
    public String strPolicyType{get;set;}
    public String strProductVehicle{get;set;}
    public String strProductHouseHold{get;set;}
    public String strProductSIP{get;set;}
    public String strProductLumpsum{get;set;}
    public String strProductTermLife{get;set;}
    
    private ActionPlanUtility objActionPlanUtility;
    
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
    		system.debug('*******lstLumpsumApproveActionPlan********'+lstLumpsumApproveActionPlan);
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
            system.debug('*******mapLumpsumFundsAlreadyExists********'+mapLumpsumFundsAlreadyExists);
            return mapLumpsumFundsAlreadyExists;
            	
    	}
    	set;
    }
    
    
    //Added By : Aditi Satpute : to render Execution Tracker button
    public boolean isExecutionTrackerOpened{get;set;}
    //Added on : 11/2/2013 : Prajakta Sanap : Hide Save button for Business Partner Financial Plan //Sanat
    public Boolean isDisplaySaveButton{get;set;}
    
    //Added on : 20/2/2013 : Aditi Satpute : AP Changes : Add Remark for MF - Lumpsum
    public string mfLumpsumRemark{get;set;}
    public string mfSIPRemark{get;set;}
    public string generalInsuranceRemark{get;set;}
    
    public Boolean isNewGeneralInsurance{get;set;}
    public string openMutualFundPopup{get;set;}
    
    
    public DatabaseSOQL dbSOQLObj {get; set;}
    public List<Goal__c> lstGoal{get;set;}
    
     public List<Approve_Action_Plan__c> lstSIPApproveActionPlan
     {
        get
        {
            if(lstSIPApproveActionPlan == null)
            {
                SIPSummaryTotal = 0;
                //Added on 24/12/2012 : for Retrieving Family member
                Set<Id> setFamilyMemberId = new Set<Id>(); 
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
    public List<Approve_Action_Plan__c> lstLumpsumApproveActionPlan{get;set;}
   // public List<ApprovedPlanBean.SIPFunds> lstSummarySIPFunds{get;set;}
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

    public ActionPlanController()
    {
    	super(System.currentPageReference().getParameters().get('entityId')); //Changes by Gaurav   (15- -4 2013): To hide succesion palnning and Insurance disply on Action plan
    	
    	lstGoal = new List<Goal__c>();
        dbSOQLObj = new DatabaseSOQL();
        isPreview = false;
        isFPLimitedAccess = false;
        isMailSent = false;
        isSave = true;
        isSidebar = true;
        isNewAP = false;
        //Code Added on : 1/2/2013 : Prajakta Sanap : Hide Save button for Business Partner Financial Plan : by default true //Sanat
        isDisplaySaveButton = true;
       
       // isExecutionTrackerOpened = false;
        entity = System.currentPageReference().getParameters().get('entityId');
       
       toDisplayFields = true;
       counter = 0;
       serviceObj = new ActionPlanServices();
       beanObj = new  ApprovedPlanBean();
       beanObj.entityId = Apexpages.currentPage().getParameters().get('entityId');
       serviceObj.getRecType(beanObj);
       blnIsETAlreadyGenerated = false;
       serviceObj.getFamilyDetails(beanObj);
       if(beanObj.accList != null)
       {
           for(Account objAccout : beanObj.accList)
           {
                if(objAccout.Id == beanObj.entityId)
                {
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
                }
                else if (objAccout.Parent_Entity__c == beanObj.entityId)
                {
                	if(objAccout.Relationship_to_Entity__pc == 'Wife')
                	{
                		strSpouseName = objAccout.FirstName != null ? (objAccout.LastName != null ? objAccout.FirstName + ' '+ objAccout.LastName : objAccout.FirstName) 
                    											: (objAccout.LastName != null ? objAccout.LastName : '');
                	}
                }
           }    
       }
       
       serviceObj.getGoals(beanObj);
       //serviceObj.getAssetAllocation(beanObj);
       //beanObj.investment = serviceObj.getMFInvestmentAsset(beanObj.accList);
       beanObj.approvedPlanList = serviceObj.getdbApprovedPlans(beanObj.accList);
       serviceObj.getCurMFLumpSumApprovedPlans(beanObj);
       serviceObj.getCurMFSIPApprovedPlans(beanObj);
       serviceObj.getSuggMFSIPApprovedPlans(beanObj);
       serviceObj.getSuggMFLumpApprovedPlans(beanObj);
       
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
       
       serviceObj.getApprGenerelInsurance(beanObj);
       serviceObj.getApprLifeInsurance(beanObj);
       serviceObj.PrpeareSummary(beanObj);
       serviceObj.PrpeareSuggested(beanObj);
        //Code Added for Partner Portal related changes i.e Logo,Name etc.
        //Date :31/07/12  Code Added By :Aditi
        Contact con;
        Account acc;
        
        Map<Id,Account> mapIdToAccount = new Map<Id,Account>();
		Map<Id,User> mapIdToUser = new Map<Id,User>();
		Map<Id,Contact> mapIdContact = new Map<Id,Contact>();
	
		mapIdToAccount = new Map<Id,Account>([Select Id, Name,Related_To__c,Family_Picture__c,Channel_Manager__c, OwnerId, owner.name ,Virtual_Partner__c,Logo__c, Email_ID__c,
											Company_Address__c, Phone,BillingState,BillingCountry,BillingPostalCode,BillingStreet,BillingCity  
											from Account where (Id =:entity or RecordType.Name = 'General')]);
		mapIdToUser = new Map<Id,User>([select Id,Name,ContactId , ManagerId,Profile.Name,UserType, Email from User where isActive = true]);
		
		
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
		system.debug('*****mapIdToAccount******'+mapIdToAccount);
		if(mapIdToAccount.containsKey(entity))
		{
			objEntity = mapIdToAccount.get(entity);
			system.debug('*****objEntity******'+objEntity);
			if(objEntity.Related_To__c.equalsIgnoreCase('Business Partner') && objEntity.Related_To__c != null)
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
			else if (objEntity.Related_To__c.equalsIgnoreCase('Virtual Partner') && objEntity.Related_To__c != null)
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
			}
		}
		
		/*
        if(AccOwnerId != null)
        {
            User user=[select Id,Name,Email,ProfileId,ContactId,Profile.Name from User where Id=:AccOwnerId];
            
            if(user.ContactId==null)
            {
                isFreedomUser = true;
            }
            else //Else is for Partner Portal
            {
                Id contactId = user.ContactId;
                con=[select AccountId from Contact where id =: user.ContactId];
                acc=[select Id, Logo__c, Email_ID__c, Company_Address__c, Phone, Name, Channel_Manager__r.Email from account where id =: con.AccountId];
                Partnerlogo = acc;
                isFreedomUser = false;
            }
        }*/
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
        }   
          
        lstGoal = beanObj.goalList;
        if(beanObj.entityId != null && beanObj.entityId != '')
        {  
            lstRecommendedInsurancePDF = new List<List<ApprovedPlanBean.RecommendedInsurance>>();
            
            beanObj = serviceObj.fetchGoalDetails(beanObj);
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
        
        lstLumpsumApproveActionPlan = new List<Approve_Action_Plan__c>();
        getLumpsumApproveActionPlans();
        lstSummarySIPFunds = new List<ApprovedPlanBean.SIPFunds>();
        getSummarySIPFunds();
        List<Account> lstAcc = dbSOQLObj.getFamilyMembers(beanObj.entityId);
        set<Id> familyIdSet = new set<Id>(); 
        for(Account objAcc : lstAcc)
        {
            familyIdSet.add(objAcc.Id);
        }
        List<Approve_Action_Plan__c> lstApproveActionPlan = [select Id,AP_Status__c,Investment_Asset__c,MF_LumpsumRemark__c,MF_SIPRemark__c,Item_Type__c,InsuranceRemark__c     
        											from Approve_Action_Plan__c where Account__c =: familyIdSet and AP_Status__c = 'Opened'];
        Map<Id,Approve_Action_Plan__c> mapIdToApproveActionPlan = new  Map<Id,Approve_Action_Plan__c>();
        for(Approve_Action_Plan__c objApprove : lstApproveActionPlan)
        {
        	if(objApprove.Investment_Asset__c != null)
        	{
        		mfLumpsumRemark = objApprove.MF_LumpsumRemark__c;
        		mfSIPRemark = objApprove.MF_SIPRemark__c;
        	}
        	if(objApprove.Item_Type__c == 'General Insurance')
        	{
        		generalInsuranceRemark = objApprove.InsuranceRemark__c;
        	}
        	if(!mapIdToApproveActionPlan.containsKey(objApprove.Id))
        	{
        		mapIdToApproveActionPlan.put(objApprove.Id,objApprove);
        	}
        }
        system.debug('*********lstApproveActionPlan.size()*******'+lstApproveActionPlan.size());
        if(lstApproveActionPlan.size() == 0)
        {
            isSave = true;
            isNewAP = false;
            Remarks__c objRemarks = new Remarks__c();
            //objRemarks = [select Entity__c,Remark__c from Remarks__c where entity__c =: beanObj.entityId 
    		//						and recordtype.Name =: 'GeneralInsurancePlanning' limit 1];
            //generalInsuranceRemark = objRemarks.Remark__c;
            List<Remarks__c> lstRemarks = [select Entity__c,Remark__c from Remarks__c where entity__c =: beanObj.entityId 
    								and recordtype.Name =: 'GeneralInsurancePlanning' limit 1];
    		if(!lstRemarks.isEmpty())
    		{
    			objRemarks = lstRemarks[0];
    			generalInsuranceRemark = objRemarks.Remark__c;
    		}
    		else
    		{
    			generalInsuranceRemark = '';
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
         	system.debug('*****lstExecutionTracker.size()*******'+lstExecutionTracker.size());
            if(lstExecutionTracker.size() == 0)
            {
            	List<Execution_Tracker__c> lstET = [select Id,Approve_Action_Plan__c from Execution_Tracker__c where Entity_Name__c =: familyIdSet
            												and  Is_Floating__c = false
            												and (Application_Status__c = 'Processed' or Application_Status__c = 'Closed')];
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
       strProductSIP  = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('SIP'));
       strProductLumpsum = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Lumpsum'));
       strProductTermLife = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Term Life'));
       strProductMedical = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Medical'));
       strProductIllness = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Critical Illness'));
       strProductTopUp = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Top Up'));
       strProductDisabilty = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Disability'));	
       strProductAccident = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Personal Accident'));
       strProductVehicle = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Vehicle'));
       strProductHouseHold = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Householders'));											
       	
       lstPolicyType = objActionPlanUtility.getInsurancePolicyTypes();
       /*End changes */
    }
    
    /*Gaurav :(13-5-2013) To Display General Insurance Product Name  in Action Plan */
    public void getInsurance()
    {   
    	Integer index = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
    	strPolicyType = '';
    	strPolicyType = beanObj.lstNewGeneralInsurance[index].policyType; 
    	beanObj.lstNewGeneralInsurance[index].productName = '';  
    	if( strPolicyType.equalsIgnoreCase('Medical'))
    		strProductMedical = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Medical'));
    	else if (strPolicyType.equalsIgnoreCase('Critical Illness'))	
    		strProductIllness = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Critical Illness'));
    	else if (strPolicyType.equalsIgnoreCase('Top Up'))	
    		strProductTopUp = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Top Up'));	
    	else if (strPolicyType.equalsIgnoreCase('Disability'))	
    		strProductDisabilty = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Disability'));	
    	else if (strPolicyType.equalsIgnoreCase('Personal Accident'))	
    		strProductAccident = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Personal Accident'));
    	else if (strPolicyType.equalsIgnoreCase('Vehicle'))	
    		strProductVehicle = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Vehicle'));
    	else if (strPolicyType.equalsIgnoreCase('Householders'))	
    		strProductHouseHold = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Householders'));											
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
        for(Account objAcc : dbSOQLObj.getFamilyMembers(beanObj.entityId))
        {
            setFamilyMemberId.add(objAcc.Id);
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
    public pageReference upsertData()
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
   
   
    /**
    * @Description: save the record in the Approve plan Object
    * param: None 
    * return type: PageReference 
    */ 
    public void saveActionPlan()
    { 
    	system.debug('******hi*****'); 
        //Added on 24/12/2012 : for Retrieving Family member
        Set<Id> setFamilyMemberId = new Set<Id>(); 
        for(Account objAcc : dbSOQLObj.getFamilyMembers(beanObj.entityId))
        {
            setFamilyMemberId.add(objAcc.Id);
        }
        Map<String,String> mapTypeToProductNames = new Map<String,String>{'SIP' => strProductSIP , 'Lumpsum' =>strProductLumpsum ,
														'Medical' =>strProductMedical, 'Critical Illness' => strProductIllness ,
														'Top Up' => strProductTopUp, 'Disabiltity' => strProductDisabilty ,
														'Personal Accident' => strProductAccident, 'Vehicle' =>strProductVehicle ,
														'HouseHolders' => strProductHouseHold , 'Term Life' => strProductTermLife }; 
												       
	        
	    system.debug('**mapTypeToProductNames**'+mapTypeToProductNames);  
	    system.debug('**beanObj**'+beanObj);  
	     system.debug('**mapStringToSIPFunds**'+mapStringToSIPFunds);  
        serviceObj.saveActionPlan(beanObj,mapStringToSIPFunds,mapTypeToProductNames);
        isExecutionTrackerOpened = true;
        getLumpsumApproveActionPlans();
        getSummarySIPFunds();
        List<Approve_Action_Plan__c> lstApproveActionPlan = new List<Approve_Action_Plan__c>();
        List<Approve_Action_Plan__c> lstUpdateMFApproveActionPlan = new List<Approve_Action_Plan__c>();
       	List<Approve_Action_Plan__c> lstUpdateGIApproveActionPlan = new List<Approve_Action_Plan__c>();
        for(Approve_Action_Plan__c objApproveActionPlan : [select isNewMutualFund__c,isSIPexecutionTracker__c 
                                                                from Approve_Action_Plan__c where Account__c IN: setFamilyMemberId 
                                                                 and AP_Status__c = 'Opened'
                                                                 and isNewMutualFund__c = true])
        {
            objApproveActionPlan.isSIPexecutionTracker__c = false;
            lstApproveActionPlan.add(objApproveActionPlan);
        }
        if(!lstApproveActionPlan.isEmpty())
            update lstApproveActionPlan;
            
        for(Approve_Action_Plan__c objMFApproveActionPlan : [select isNewMutualFund__c,InsuranceRemark__c,isSIPexecutionTracker__c,Investment_Asset__c,
        														MF_LumpsumRemark__c,MF_SIPRemark__c,Item_Type__c from Approve_Action_Plan__c 
        														where Account__c IN: setFamilyMemberId 
                                                                and AP_Status__c = 'Opened'])
        {
        	if(objMFApproveActionPlan.Investment_Asset__c != null )
        	{
        		objMFApproveActionPlan.MF_LumpsumRemark__c = mfLumpsumRemark;
	        	objMFApproveActionPlan.MF_SIPRemark__c = mfSIPRemark;
	           	lstUpdateMFApproveActionPlan.add(objMFApproveActionPlan);
        	}
        	if(objMFApproveActionPlan.Item_Type__c == 'General Insurance')
        	{
        		objMFApproveActionPlan.InsuranceRemark__c = generalInsuranceRemark;
        		lstUpdateGIApproveActionPlan.add(objMFApproveActionPlan);
        	}
        	
        }
         if(!lstUpdateMFApproveActionPlan.isEmpty())
            update lstUpdateMFApproveActionPlan;
         if(!lstUpdateGIApproveActionPlan.isEmpty())
            update lstUpdateGIApproveActionPlan;
    } 
   
   
    /**
    * @Description: Add new record for suggested Lumpsum 
    * param: None 
    * return type: PageReference 
    */ 
    public pageReference addNewSuggLump()
    {
       ApprovedPlanBean.SuggestedMFLumpSum tmpObj = serviceObj.AddNewSuggMFLump(beanObj);
       beanObj.SuggestedMFLumpSumList.add(tmpObj);
       return null;
    } 
    
    /**
    * @Description: Add new record for sip FUNDS of New Action Plan
    * param: None 
    * return type: PageReference 
    */
    public pageReference addNewSIPFund()
    {
       
       addNewGoalId = apexPages.currentPage().getParameters().get('addNewGoalId');
       
       for(ApprovedPlanBean.GoalDetails obj : beanObj.lstGoalDetails)
       {
            if(addNewGoalId == obj.goalId)
            {
                for(Integer iCount = 0; iCount < 2 ;iCount ++)
                {
                    ApprovedPlanBean.SIPFunds objSIPFunds = serviceObj.AddNewSIPFunds(beanObj);
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
        for(ApprovedPlanBean.GoalDetails obj : beanObj.lstGoalDetails)
        {
            if(addNewLumpsumGoalId == obj.goalId)
            {
                for(Integer iCount = 0; iCount < 2 ;iCount ++)
                {
                    ApprovedPlanBean.LumpsumFunds objLumpsumFunds = serviceObj.AddNewLumpsumFunds(beanObj);
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
    public pageReference addNewSuggSIP()
    {
       ApprovedPlanBean.SuggestedMFSIP tmpObj = serviceObj.AddNewSuggMFSIP(beanObj);
       beanObj.suggestedMFSIPList.add(tmpObj);
       return null;
    } 
   
     
    /**
    * @Description: Remove record for suggested Lumsum
    * param: None 
    * return type: PageReference 
    */ 
   public pageReference RemoveRecordLump()
   {
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
        serviceObj.RemoveRecordSIPFunds(beanObj);
    }
    
    /**Added on : 19/2/2013 : Aditi Satpute
    * @Description: Remove record for suggested SIP
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
      
    /**
    * @Description: get scheme names from approved plan object
    * param: None 
    * return type: List<selectOption>
    */ 
   public List<selectOption> getSchemeNames()
   {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult field = Schema.sObjectType.Approved_Action_Plan__c.fields.Scheme_Name__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        for(Schema.PicklistEntry p : picklist) 
        {
            options.add(new selectOption(p.getLabel(), p.getLabel()));
        }
        
        return options;
    }
    
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
    public List<selectOption> getSugLumpActions()
    {
        List<selectOption> options = new List<selectOption>();
        Schema.DescribeFieldResult field = Schema.sObjectType.Approved_Action_Plan__c.fields.Suggested_LumpSum_Action__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
        
        for(Schema.PicklistEntry p : picklist) 
        {
            options.add(new selectOption(p.getLabel(), p.getLabel()));
        }
        
        return options;
    }
    
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
            options.add(new selectOption(acc.Id, acc.FirstName + ' '+ acc.LastName));
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
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Action Amount total should not be greater than Amount'));
                        return;
                    }
                    objlastRecordCurrentMutualFunds = lstCMF[lstCMF.size() - 1];
                    
                    objAddNewCurrentMutualFunds.amount = objlastRecordCurrentMutualFunds.amount - objlastRecordCurrentMutualFunds.actionAmount;
                    objAddNewCurrentMutualFunds.schemeName = objlastRecordCurrentMutualFunds.schemeName;
                    objAddNewCurrentMutualFunds.assetClass = objlastRecordCurrentMutualFunds.assetClass;
                    objAddNewCurrentMutualFunds.actionAmount = 0.0;
                    //objAddNewCurrentMutualFunds.SIPexecutionTracker = 'No';
                    //objAddNewCurrentMutualFunds.amount = objInvestment.TotalAsset__c;
                    //Commented on:18/02/2013 : Aditi Satpute : AP changes
                    objAddNewCurrentMutualFunds.lumpsumAction = 'Hold - Change of broker';
                      //Added on:18/02/2013 : Aditi Satpute : AP changes
                    objAddNewCurrentMutualFunds.lumpsumAction = '--None--';  
                    objAddNewCurrentMutualFunds.account = objlastRecordCurrentMutualFunds.account;
                    objAddNewCurrentMutualFunds.investmentId = investmentId;
                    objAddNewCurrentMutualFunds.owner = objlastRecordCurrentMutualFunds.owner;
                    objAddNewCurrentMutualFunds.newCount = countNewRecord++;
                    objAddNewCurrentMutualFunds.isNewMutualFund = true;
                    
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
                            lstAddNewCurrentMutualFunds.add(objAddNewCurrentMutualFunds);
                            beanObj.mapIdToCurrentFunds.put(investmentId,lstAddNewCurrentMutualFunds);
                        }
                    }
                    
                }
                break;
            }
       }
    }
     
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
            
            /* Attach content as pdf file*/ 
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
            

            /* Attach content as html file*/            
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
        return null ;
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
            Account objAccount = [Select Id, Name,PersonEmail,Email_Temp__c,OwnerId,owner.name from Account where Id =: entity];
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
                email.setSenderDisplayName(objAccount.Owner.Name);
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
     	isNewGeneralInsurance = true;
        for(Integer iCount = 0; iCount < 2 ;iCount ++)
        {
            ApprovedPlanBean.GeneralInsurance objGeneralInsurance = new ApprovedPlanBean.GeneralInsurance();
            objGeneralInsurance.index = beanObj.lstNewGeneralInsurance.size();
            beanObj.lstNewGeneralInsurance.add(objGeneralInsurance);
        }
        /*Gaurav: (13-5-2013) : Call to the RetrieveInsurance method to get the Medical Insurance Product Name*/
       	strProductMedical = objActionPlanUtility.retrieveInsurance(objActionPlanUtility.getProductType('Medical'));
     	return  null;
     }
     
     //Added by Aditi Satpute : To clone add new Action Plan for that particualr Entity
     public pageReference generateNewAP()
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
                                    from Execution_Tracker__c where Entity_Name__c =: familyIdSet and (Application_Status__c = 'Opened' OR Application_Status__c = '') and  Is_Floating__c = false];
          if(!lstFilledExecutionTrackerRecord.isEmpty())                        
            delete lstFilledExecutionTrackerRecord;     
        isSave = true;      
        saveActionPlanPDF();
        pageReference pageRef = new pageReference('/apex/ActionPlan?entityId='+beanObj.entityId+'&tabname=Financial Planning');
        pageRef.setRedirect(true);
        return pageRef ;
                        
     }
     //Added on : 28/2/2013 : Aditi Satpute : To clone the existing Action Plan
     public pageReference cloneActionPlan()
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
     }
     
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
         if(lstApproveActionPlan.isEmpty())
         {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'There is no Action Plan generated for this Entity'));
            isSidebar = false;
         }
         else
         {
             isSave = false;
             List<Execution_Tracker__c> lstExistingETrecords = [SELECT Id FROM Execution_Tracker__c where Entity_Name__c =: strEntityId  
                                                                and (Application_Status__c = 'Opened' or Application_Status__c = '') and  Is_Floating__c = false];
             if(lstExistingETrecords.size() == 0)
             {
                 isSidebar = true;
                 //Added on 24/12/2012 : for Retrieving Family member
                 Set<Id> familyIdSet = new Set<Id>(); 
                 Map<Id,Account> mapFamilyMambers = new Map<Id,Account>();
                 List<Account> lstAcc = dbSOQLObj.getFamilyMembers(beanObj.entityId);
                
                 for(Account objAcc : lstAcc)
                 {
                    familyIdSet.add(objAcc.Id);
                    mapFamilyMambers.put(objAcc.Id,objAcc);
                 }
                 
                 //Retieve all records from Action Plan whose ET to be opened is "Yes""
                 List<Approve_Action_Plan__c> lstActionPlanETrecords = [Select Transaction_Type__c, isExecutionTracker__c, isInsuranceExecutionTracker__c,Tenure_of_Insurance__c,
                                                                                Remarks__c, Goal__c , isLumpsumExecTracker__c, Action_Amount__c,Scheme_Name__c,
                                                                                Amount__c, Product_Name__c, Account__c , SIP_Action_Amount__c,Current_SIP__c ,Insured__c,
                                                                                Option__c, Installments__c, Item_Type__c , Insurance__r.Premium_Amount_Rs__c,
                                                                                CreatedDate, Category__c, isSIPexecutionTracker__c ,Investment_Asset__c,Sum_Assured_Rs__c,
                                                                                Account__r.FirstName, Account__r.LastName ,Account__r.PersonMobilePhone, Account__r.PersonEmail,
                                                                                Account__r.PersonBirthdate, Account__r.PAN_ID__pc, Policy_Name__c, Insurance__r.Policy_Name__c,
                                                                                Insurance__r.Sum_Assured_Rs__c, Insurance__r.Suggested_Cover_General_Insurance__c, Insurance__r.Policy_Number__c, 
                                                                                Account__r.Bank_Account_Number2__c,Insurance__r.Surrender_Cash_Value__c,Insurance__r.Insurance_Company__c,
                                                                                Account__r.Bank_Name__c, Account__r.Branch_details__c,Account__r.Bank_Account_Type__c,Account__r.MICR_Number__c,
                                                                                Account__r.IFSC_Number__c, Account__r.Renewal_Date__c, Insurance__r.Policy_Type__c,Policy_Type__c,
                                                                                Insurance__r.Entity__r.FirstName,Insurance__r.Entity__r.LastName,InsuranceRemark__c,Fund__c,
                                                                                Amount_Per_Installment__c,SIP_Action__c,Lumpsum_Action__c 
                                                                        From Approve_Action_Plan__c
                                                                        where Account__c IN : familyIdSet
                                                                                and AP_Status__c = 'Opened'
                                                                                and (isSIPexecutionTracker__c = true or isLumpsumExecTracker__c = true 
                                                                                or isInsuranceExecutionTracker__c = true or isExecutionTracker__c = true)];
                                            
                List<Execution_Tracker__c>  lstETrecords = new List<Execution_Tracker__c>();
                for(Approve_Action_Plan__c objActionPlan : lstActionPlanETrecords)  
                {
                    
                    String strAddress = '';
                    //Added on 31/1/2013 : for Fetching Mailing Address
                    if(mapFamilyMambers.containsKey(objActionPlan.Account__c))
                    {
                        Account objAcc = mapFamilyMambers.get(objActionPlan.Account__c);
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
                        
                    //Mutual Fund Lumpsum
                    if(objActionPlan.isExecutionTracker__c)
                    {
                        Execution_Tracker__c objActionPlanMF = new Execution_Tracker__c();
                        objActionPlanMF.Approve_Action_Plan__c = objActionPlan.Id;
                        objActionPlanMF.Entity_Name__c =    objActionPlan.Account__c;
                        objActionPlanMF.Goal__c = objActionPlan.Goal__c;
                        objActionPlanMF.ET_Status__c = 'Assigned to MET';
                        objActionPlanMF.Type__c = 'Lumpsum';
                        objActionPlanMF.Suggested_Amount__c = objActionPlan.Action_Amount__c;
                        objActionPlanMF.Actual_Action_Amount__c = objActionPlan.Action_Amount__c;
                        objActionPlanMF.Agreed_Amount_Base_Amount__c = objActionPlan.Action_Amount__c;
                        objActionPlanMF.Amount__c = objActionPlan.Amount__c;
                        objActionPlanMF.Investor_Name_as_in_PAN_card__c = objActionPlan.Account__r.FirstName +' '+ objActionPlan.Account__r.LastName;
                        objActionPlanMF.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
                        objActionPlanMF.Email__c = objActionPlan.Account__r.PersonEmail;
                        objActionPlanMF.DOB__c = objActionPlan.Account__r.PersonBirthdate;
                        objActionPlanMF.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
                        objActionPlanMF.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
                        objActionPlanMF.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
                        objActionPlanMF.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
                        objActionPlanMF.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
                        objActionPlanMF.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
                        objActionPlanMF.Scheme_Name_Policy_Name__c = objActionPlan.Scheme_Name__c;
                        objActionPlanMF.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c; 
                        objActionPlanMF.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
                        objActionPlanMF.Communication_Address__c = strAddress;
                        //Added on 22/3/13 : Aditi Satpute : To open different screens depending on Action for Ops Team
                        objActionPlanMF.Action__c = objActionPlan.Lumpsum_Action__c;
                        /*Below change done by Gaurav - 7/2/2013 
                              Changes in Scheme name = Schme name policy
                              Purpose: Execution Tracker changes 
                        */
                        objActionPlanMF.Agreed_Amount__c = objActionPlanMF.Suggested_Amount__c;
                       // objActionPlanMF.Actual_Action_Amount__c = 
                        objActionPlanMF.Executed_Product_Name__c = objActionPlan.Scheme_Name__c;
                        lstETrecords.add(objActionPlanMF); 
                    }
                    //Mutual Fund Running SIP & SIP Funds
                    if(objActionPlan.isSIPexecutionTracker__c)
                    {
                        Execution_Tracker__c objActionPlanMF = new Execution_Tracker__c();
                        objActionPlanMF.Approve_Action_Plan__c = objActionPlan.Id;
                        objActionPlanMF.Entity_Name__c =    objActionPlan.Account__c;
                        objActionPlanMF.Goal__c = objActionPlan.Goal__c;
                        objActionPlanMF.ET_Status__c = 'Assigned to MET';
                        objActionPlanMF.Type__c = 'SIP';
                        objActionPlanMF.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
                        objActionPlanMF.Email__c = objActionPlan.Account__r.PersonEmail;
                        objActionPlanMF.DOB__c = objActionPlan.Account__r.PersonBirthdate;
                        objActionPlanMF.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
                        objActionPlanMF.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
                        objActionPlanMF.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
                        objActionPlanMF.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
                        objActionPlanMF.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
                        objActionPlanMF.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
                        objActionPlanMF.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
                        objActionPlanMF.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
                        objActionPlanMF.Communication_Address__c = strAddress;
                        if(objActionPlan.Investment_Asset__c != null)
                        {
                            objActionPlanMF.Suggested_Amount__c = objActionPlan.SIP_Action_Amount__c;
                            objActionPlanMF.Actual_Action_Amount__c = objActionPlan.SIP_Action_Amount__c;
                            objActionPlanMF.Agreed_Amount_Base_Amount__c = objActionPlan.SIP_Action_Amount__c;
                            objActionPlanMF.Amount__c = objActionPlan.Current_SIP__c;
                            objActionPlanMF.Investor_Name_as_in_PAN_card__c = objActionPlan.Account__r.FirstName +' '+ objActionPlan.Account__r.LastName;
                            objActionPlanMF.Scheme_Name_Policy_Name__c = objActionPlan.Scheme_Name__c;
                            
                            /*Below change done by Gaurav - 7/2/2013 
                              Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
                              Purpose: Execution Tracker changes 
                            */
                            objActionPlanMF.Agreed_Amount__c = objActionPlanMF.Suggested_Amount__c;
                            objActionPlanMF.Executed_Product_Name__c =  objActionPlan.Scheme_Name__c;
                            //Added on 22/3/13 : Aditi Satpute : To open different screens depending on Action for Ops Team
                         	objActionPlanMF.Action__c = objActionPlan.SIP_Action__c;
                            
                        }
                        else//SIP Funds
                        {
                            objActionPlanMF.Suggested_Amount__c = objActionPlan.Amount__c;
                            objActionPlanMF.Actual_Action_Amount__c = objActionPlan.Amount__c;
                            objActionPlanMF.Agreed_Amount_Base_Amount__c = objActionPlan.Amount__c;
                            objActionPlanMF.Option__c = objActionPlan.Option__c;
                            objActionPlanMF.Transaction_Type__c = objActionPlan.Transaction_Type__c;
                            objActionPlanMF.SIP_Installments__c = objActionPlan.Installments__c;
                            objActionPlanMF.Scheme_Name_Policy_Name__c = objActionPlan.Product_Name__c;
                            
                            /*Below change done by Gaurav - 7/2/2013 
                              Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
                              Purpose: Execution Tracker changes 
                            */
                            objActionPlanMF.Executed_Product_Name__c = objActionPlan.Product_Name__c;
                            objActionPlanMF.Agreed_Amount__c = objActionPlanMF.Suggested_Amount__c;
                             //Added on : 20/3/13 : Aditi Satpute : ET Screen Changes
							objActionPlanMF.Agreed_Installments__c = objActionPlan.Installments__c;
	                    }
                        lstETrecords.add(objActionPlanMF);
                    } 
                    //Lumpsum Funds
                    if(objActionPlan.isLumpsumExecTracker__c)
                    {
                        Execution_Tracker__c objActionPlanMF = new Execution_Tracker__c();
                        objActionPlanMF.Approve_Action_Plan__c = objActionPlan.Id;
                        objActionPlanMF.Entity_Name__c =    objActionPlan.Account__c;
                        objActionPlanMF.Goal__c = objActionPlan.Goal__c;
                        objActionPlanMF.ET_Status__c = 'Assigned to MET';
                        objActionPlanMF.Type__c = 'Lumpsum';
                        objActionPlanMF.Suggested_Amount__c = objActionPlan.Amount__c;
                        objActionPlanMF.Actual_Action_Amount__c = objActionPlan.Amount__c;
                        objActionPlanMF.Agreed_Amount_Base_Amount__c = objActionPlan.Amount__c;
                        objActionPlanMF.Option__c = objActionPlan.Option__c;
                        objActionPlanMF.Transaction_Type__c = objActionPlan.Transaction_Type__c;
                        objActionPlanMF.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
                        objActionPlanMF.Email__c = objActionPlan.Account__r.PersonEmail;
                        objActionPlanMF.DOB__c = objActionPlan.Account__r.PersonBirthdate;
                        objActionPlanMF.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
                        objActionPlanMF.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
                        objActionPlanMF.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
                        objActionPlanMF.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
                        objActionPlanMF.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
                        objActionPlanMF.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
                        objActionPlanMF.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
                        objActionPlanMF.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
                        objActionPlanMF.Scheme_Name_Policy_Name__c = objActionPlan.Product_Name__c;
                        objActionPlanMF.Communication_Address__c = strAddress;
                        /*Below change done by Gaurav - 7/2/2013 
                          Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
                          Purpose: Execution Tracker changes 
                        */
                        objActionPlanMF.Executed_Product_Name__c =  objActionPlan.Product_Name__c;
                        objActionPlanMF.Agreed_Amount__c = objActionPlanMF.Suggested_Amount__c;
                        //Added on : 20/3/13 : Aditi Satpute : ET Screen Changes
                        objActionPlanMF.Agreed_Amount_Per_Installment__c = objActionPlan.Amount_Per_Installment__c;
						objActionPlanMF.Agreed_Installments__c = objActionPlan.Installments__c;
						objActionPlanMF.Agreed_Scheme_Name_to__c = objActionPlan.Fund__c;
						
                        lstETrecords.add(objActionPlanMF);
                    }
                    //Life Insurance, Recommended & General Insurance
                    if(objActionPlan.isInsuranceExecutionTracker__c)
                    {
                    	if(objActionPlan.Item_Type__c.equals('Life Insurance') || objActionPlan.Item_Type__c.equals('General Insurance'))
                    	{
	                        Execution_Tracker__c objActionPlanMF = new Execution_Tracker__c();
	                        objActionPlanMF.Approve_Action_Plan__c = objActionPlan.Id;
	                        objActionPlanMF.Entity_Name__c = objActionPlan.Account__c;
	                        objActionPlanMF.Goal__c = objActionPlan.Goal__c;
	                        objActionPlanMF.ET_Status__c = 'Assigned to MET';
	                        objActionPlanMF.Type__c = objActionPlan.Item_Type__c;
	                        objActionPlanMF.Asset_Class_Policy_Type__c = objActionPlan.Insurance__r.Policy_Type__c;
	                        if(objActionPlan.Item_Type__c.equals('Life Insurance'))
	                        {
	                            objActionPlanMF.Policy_Name__c = objActionPlan.Policy_Name__c;
	                            objActionPlanMF.Scheme_Name_Policy_Name__c = objActionPlan.Policy_Name__c;
	                            //Added on:18/03/2013 : Aditi Satpute : ET changes 
				   				objActionPlanMF.Term_No_Of_Years__c = objActionPlan.Tenure_of_Insurance__c;
				   				
				   				if(objActionPlan.Insurance__r.Entity__r.LastName == null)
				          		{
				          			objActionPlanMF.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.FirstName;
				          		}
				          		else if(objActionPlan.Insurance__r.Entity__r.FirstName == null )
				          		{
				          			objActionPlanMF.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.LastName;
				          		}
				          		else if(objActionPlan.Insurance__r.Entity__r.LastName != null && objActionPlan.Insurance__r.Entity__r.FirstName != null)
				          		{
				          			objActionPlanMF.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.FirstName +' '+ objActionPlan.Insurance__r.Entity__r.LastName;
				          		}
				          		else 
				          		{
				          			objActionPlanMF.Insured_Name__c = '';
				          		}
				          		//objActionPlanMF.Remarks__c = objActionPlan.InsuranceRemark__c;
	                            /*Below change done by Gaurav - 7/2/2013 
	                              Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
	                              Purpose: Execution Tracker changes 
	                            */
	                           	objActionPlanMF.Executed_Product_Name__c = objActionPlan.Policy_Name__c != null ? objActionPlan.Policy_Name__c : objActionPlan.Insurance__r.Policy_Type__c;
	                            /*Changed Suggested Amount from Suggested cover to SumAssured 
	                              Date : 18/3/13 : Aditi Satpute : ET changes : Suggested by Vinita*/
	                            //objActionPlanMF.Suggested_Amount__c = objActionPlan.Insurance__r.Suggested_Cover_General_Insurance__c;
	                            objActionPlanMF.Suggested_Amount__c = objActionPlan.Sum_Assured_Rs__c;
	                            objActionPlanMF.Actual_Action_Amount__c = objActionPlan.Sum_Assured_Rs__c;
	                            objActionPlanMF.Agreed_Amount_Base_Amount__c = objActionPlan.Sum_Assured_Rs__c;
	                            objActionPlanMF.Agreed_Amount__c = objActionPlanMF.Suggested_Amount__c;
	                            //Added on:18/02/2013 : Aditi Satpute : AP changes 
				   				objActionPlanMF.Sum_Assured__c = objActionPlan.Sum_Assured_Rs__c;
	                        }
	                        else
	                        {
	                            //Commented on:18/02/2013 : Aditi Satpute : AP changes : remove Policy Name
								//objActionPlanMF.Policy_Name__c = objActionPlan.Insurance__r.Policy_Name__c;
								
								//Added on:18/02/2013 : Aditi Satpute : AP changes : remove Policy Name
								objActionPlanMF.Policy_Name__c = objActionPlan.Product_Name__c;
								
								//Added on:18/02/2013 : Aditi Satpute : AP changes : remove Policy Name
								objActionPlanMF.Scheme_Name_Policy_Name__c = objActionPlan.Product_Name__c;
								
								//Added on:18/02/2013 : Aditi Satpute : AP changes : remove Policy Name
								objActionPlanMF.Executed_Product_Name__c = objActionPlan.Product_Name__c!=null ? objActionPlan.Product_Name__c:objActionPlan.Policy_Type__c;
								
								//Commented on:19/02/2013 : Aditi Satpute : AP changes : Added new GI records
								//objActionPlanMF.Sum_Assured__c = objActionPlan.Insurance__r.Sum_Assured_Rs__c;
								//Added on:19/02/2013 : Aditi Satpute : AP changes : Added new GI records
								objActionPlanMF.Sum_Assured__c = objActionPlan.Sum_Assured_Rs__c;
								objActionPlanMF.Asset_Class_Policy_Type__c = objActionPlan.Policy_Type__c;
								
								//Added on:19/03/2013 : Aditi Satpute : ET changes
								objActionPlanMF.Insured_Name__c = objActionPlan.Insured__c;
	                            /*Below change done by Gaurav - 7/2/2013 
	                              Changes in Scheme name = Schme name policy and suggested amount = suggested cover amount
	                              Purpose: Execution Tracker changes 
	                             Old :  //objActionPlanMF.Suggested_Amount__c = objActionPlan.Insurance__r.Premium_Amount_Rs__c;
	                            */
	                            objActionPlanMF.Suggested_Amount__c =  objActionPlanMF.Sum_Assured__c;
                             	objActionPlanMF.Actual_Action_Amount__c = objActionPlanMF.Sum_Assured__c;
                             	objActionPlanMF.Agreed_Amount_Base_Amount__c = objActionPlanMF.Sum_Assured__c;
	                            objActionPlanMF.Agreed_Amount__c = objActionPlanMF.Suggested_Amount__c;
	                        }
	                        //objActionPlanMF.Suggested_Amount__c = objActionPlan.Insurance__r.Premium_Amount_Rs__c;
	                        objActionPlanMF.Policy_Number__c = objActionPlan.Insurance__r.Policy_Number__c;
	                        objActionPlanMF.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
	                        objActionPlanMF.Email__c = objActionPlan.Account__r.PersonEmail;
	                        objActionPlanMF.DOB__c = objActionPlan.Account__r.PersonBirthdate;
	                        objActionPlanMF.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
	                        objActionPlanMF.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
	                        objActionPlanMF.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
	                        objActionPlanMF.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
	                        objActionPlanMF.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
	                        objActionPlanMF.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
	                        objActionPlanMF.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
	                        objActionPlanMF.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
	                        objActionPlanMF.Communication_Address__c = strAddress;
	                        lstETrecords.add(objActionPlanMF);
                        }
                        else if(objActionPlan.Item_Type__c.equals('Recommended Insurance'))
                        {
                        	Execution_Tracker__c objActionPlanMF = new Execution_Tracker__c();
	                        objActionPlanMF.Approve_Action_Plan__c = objActionPlan.Id;
	                        objActionPlanMF.Entity_Name__c = objActionPlan.Account__c;
	                        objActionPlanMF.Goal__c = objActionPlan.Goal__c;
	                        objActionPlanMF.ET_Status__c = 'Assigned to MET';
	                        objActionPlanMF.Type__c = objActionPlan.Item_Type__c;
	                        if(objActionPlan.Insurance__r.Entity__r.LastName == null)
			          		{
			          			objActionPlanMF.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.FirstName;
			          			objActionPlanMF.Nominee__c = objActionPlan.Insurance__r.Entity__r.FirstName;
			          			
			          		}
			          		else if(objActionPlan.Insurance__r.Entity__r.FirstName == null )
			          		{
			          			objActionPlanMF.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.LastName;
		          				objActionPlanMF.Nominee__c = objActionPlan.Insurance__r.Entity__r.LastName;
			          		}
			          		else if(objActionPlan.Insurance__r.Entity__r.LastName != null && objActionPlan.Insurance__r.Entity__r.FirstName != null)
			          		{
			          			objActionPlanMF.Insured_Name__c = objActionPlan.Insurance__r.Entity__r.FirstName +' '+ objActionPlan.Insurance__r.Entity__r.LastName;
		          				objActionPlanMF.Nominee__c = objActionPlan.Insurance__r.Entity__r.FirstName +' '+ objActionPlan.Insurance__r.Entity__r.LastName;
			          		}
			          		else 
			          		{
			          			objActionPlanMF.Insured_Name__c = '';
		          				objActionPlanMF.Nominee__c = '';
			          		}
			          		
			          		objActionPlanMF.Executed_Product_Name__c = objActionPlan.Insurance__r.Insurance_Company__c;
			          		objActionPlanMF.Policy_Name__c = objActionPlan.Insurance__r.Policy_Name__c;
                            objActionPlanMF.Scheme_Name_Policy_Name__c = objActionPlan.Insurance__r.Policy_Name__c;
                            objActionPlanMF.Asset_Class_Policy_Type__c = objActionPlan.Insurance__r.Policy_Type__c;
                            objActionPlanMF.Premium__c  = objActionPlan.Insurance__r.Premium_Amount_Rs__c;
                            objActionPlanMF.Suggested_Amount__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c;
                            objActionPlanMF.Actual_Action_Amount__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c;
                            objActionPlanMF.Agreed_Amount_Base_Amount__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c;
                            //Tracker is opened for this value : Surrender Cash Value
                            objActionPlanMF.Agreed_Amount__c = objActionPlan.Insurance__r.Surrender_Cash_Value__c;
                        	objActionPlanMF.Policy_Number__c = objActionPlan.Insurance__r.Policy_Number__c;
	                        objActionPlanMF.Mobile__c = objActionPlan.Account__r.PersonMobilePhone;
	                        objActionPlanMF.Email__c = objActionPlan.Account__r.PersonEmail;
	                        objActionPlanMF.DOB__c = objActionPlan.Account__r.PersonBirthdate;
	                        objActionPlanMF.PAN__c = objActionPlan.Account__r.PAN_ID__pc;
	                        objActionPlanMF.Account_Number__c = objActionPlan.Account__r.Bank_Account_Number2__c;
	                        objActionPlanMF.Bank_Name__c = objActionPlan.Account__r.Bank_Name__c;
	                        objActionPlanMF.Branch_Address__c = objActionPlan.Account__r.Branch_details__c;
	                        objActionPlanMF.Account_Type__c = objActionPlan.Account__r.Bank_Account_Type__c;
	                        objActionPlanMF.MICR_Code__c = objActionPlan.Account__r.MICR_Number__c;
	                        objActionPlanMF.IFSC_Code__c = objActionPlan.Account__r.IFSC_Number__c;
	                        objActionPlanMF.Renewal_Date__c = objActionPlan.Account__r.Renewal_Date__c;
	                        objActionPlanMF.Communication_Address__c = strAddress;
	                        lstETrecords.add(objActionPlanMF);
                        }
                    }
                }   
             
                Messaging.SingleEmailMessage emailToEntity = new Messaging.SingleEmailMessage();
                Messaging.SingleEmailMessage emailToMet = new Messaging.SingleEmailMessage();
                Account objBPAccount = new Account();
                Contact objContact = new Contact();
                List<String> lstToEntityOwnerAddresses = new List<String>();
                List<String> lstToMetAddresses = new List<String>();
                List<Execution_Tracker__c> lstETrecordsWithMETowner = new List<Execution_Tracker__c>();
                
                Account objAccount = [Select Id, Name,Related_To__c, OwnerId, owner.name from Account where Id =: beanObj.entityId];
                Map<Id,User> mapIdToUser = new Map<Id,User>([select Id,Name,ContactId , ManagerId, Email from User]);
                
                if(objAccount != null)
                {
                    //Send Email to Entity Owner & MET - If Entity is Business Partner Entity
                    if(objAccount.Related_To__c.equalsIgnoreCase('Business Partner'))
                    {
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
                            
                            if(objBPEntityOwnerUser.Email != null)
                                lstToEntityOwnerAddresses.add(objBPEntityOwnerUser.Email);
                            if(!lstToEntityOwnerAddresses.isEmpty())
                                emailToEntity.setToAddresses( lstToEntityOwnerAddresses );
                                
                            emailToEntity.setSubject( 'Execution Tracker Generated for ' + objAccount.Name);        
                            emailToEntity.setHtmlBody('Dear '+objAccount.Owner.Name+',<br/><br/>Action Plan is being generated and Execution Tracker records of "'
                                                        +objAccount.Name+'" are being created for the Member Engagement Team.<br/><br/>'
                                                        +'Thanks<br/>'+ objBPAccount.Channel_Manager__r.Name);
                            emailToEntity.setSenderDisplayName(objBPAccount.Channel_Manager__r.Name);
                            
                            // Sends the email to Entity Owner
                            Messaging.SendEmailResult [] arrBPEntityOwnerResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToEntity});
                            
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
                            
                            List<Workstation__c> lstBPWorkstation = [Select Member_Engagement__c, Member_Engagement__r.Name, Financial_Planner__c 
                                                                From Workstation__c 
                                                                where Financial_Planner__c = : objBPAccount.Channel_Manager__c];
                            if(lstBPWorkstation.isEmpty())
                            {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Please add Entity Owner as Financial Planner in Workstation'));
                                return null;
                            }                                   
                            if(mapIdToUser.containsKey(objBPAccount.Channel_Manager__c))    
                            {                               
                                User objChannelManagerUser = mapIdToUser.get(objBPAccount.Channel_Manager__c);
                                
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
                                
                                emailToMet.setSubject( 'Execution Tracker Generated for ' + objAccount.Name);       
                                String domain = URL.getSalesforceBaseUrl().toExternalForm();
                                String TargetLink = domain + '/' + objAccount.Id;
                                
                                emailToMet.setHtmlBody('Dear '+lstBPWorkstation[0].Member_Engagement__r.Name+',<br/><br/>Action Plan has been generated for "'
                                                              +objAccount.Name+'" and executions can be done. Please go through the related Execution Trackers.<br/>Click here : <a href=\''
                                                              +TargetLink+'\'>'+TargetLink+'</a> <br/><br/> Thanks,<br/>'+objChannelManagerUser.Name);
                                emailToMet.setSenderDisplayName(objChannelManagerUser.Name);
                                
                                for(Execution_Tracker__c objAssignMetOwner : lstETrecords)
                                {
                                    objAssignMetOwner.Owner__c = lstBPWorkstation[0].Member_Engagement__c;
                                    objAssignMetOwner.Send_Email__c = true;
                                    objAssignMetOwner.Send_Email_Datetime__c = System.now();
                                    objAssignMetOwner.Send_SMS__c = true;
                                    objAssignMetOwner.Send_SMS_Datetime__c = System.now();
                                    lstETrecordsWithMETowner.add(objAssignMetOwner);
                                    
                                }
                                
                                //insert ET records  into data base with Owner as MET
                                if(!lstETrecordsWithMETowner.isEmpty())         
                                    insert lstETrecordsWithMETowner;
                                    
                                //Sends the mail to MET
                                Messaging.SendEmailResult [] arrBusinessPartnerMetResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToMet});
                               
                                //Send Chatter Notification to MET
                                FeedItem post = new FeedItem();
                                post.ParentId = lstBPWorkstation[0].Member_Engagement__c;
                                post.Body = 'Action Plan has been generated for "' +objAccount.Name+ '" and executions can be done.'+
                                             'Please go through the related Execution Trackers.';
                                insert post;
                            }
                        }
                    }
                    //if Entity is Ffreedom Entity or Virtual PArtner Entity
                    else 
                    {
                        lstToMetAddresses = new List<String>();
                        lstToEntityOwnerAddresses = new List<String>();
                        emailToMet = new Messaging.SingleEmailMessage();
                        emailToEntity = new Messaging.SingleEmailMessage();
                        
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
                        List<Workstation__c> lstWorkstation = [Select Member_Engagement__c, Member_Engagement__r.Name, Financial_Planner__c 
                                                         From Workstation__c 
                                                         where Financial_Planner__c = : objAccount.Owner.Id];
                                                         
                        if(lstWorkstation.isEmpty())
                        {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'Please add Entity Owner as Financial Planner in Workstation'));
                            return null;
                        }
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
                        String domain = URL.getSalesforceBaseUrl().toExternalForm();
                        String TargetLink = domain + '/' + objAccount.Id;
                        
                        emailToMet.setHtmlBody('Dear '+lstWorkstation[0].Member_Engagement__r.Name+',<br/><br/>Action Plan has been generated for "'
                                                      +objAccount.Name+'" and executions can be done. Please go through the related Execution Trackers.<br/>Click here : <a href=\''
                                                      +TargetLink+'\'>'+TargetLink+'</a> <br/><br/> Thanks,<br/>'+objAccount.Owner.Name);
                        emailToMet.setSenderDisplayName(objAccount.Owner.Name);
                        
                        for(Execution_Tracker__c objAssignMetOwner : lstETrecords)
                        {
                            objAssignMetOwner.Send_Email__c = true;
                            objAssignMetOwner.Send_Email_Datetime__c = System.now();
                            objAssignMetOwner.Send_SMS__c = true;
                            objAssignMetOwner.Send_SMS_Datetime__c = System.now();
                            objAssignMetOwner.Owner__c = lstWorkstation[0].Member_Engagement__c;
                            lstETrecordsWithMETowner.add(objAssignMetOwner);
                        }
                        system.debug('*********lstETrecordsWithMETowner**********'+lstETrecordsWithMETowner);
                        //insert ET records  into data base with Owner as MET
                        if(!lstETrecordsWithMETowner.isEmpty())         
                            insert lstETrecordsWithMETowner;
                            
                        //Sends the email Notification to MET
                        Messaging.SendEmailResult [] arrMetResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailToMet});
                        
                        //Send Chatter Notification to MET
                        FeedItem post = new FeedItem();
                        post.ParentId = lstWorkstation[0].Member_Engagement__c;
                        post.Body = 'Action Plan has been generated for "' +objAccount.Name+ '" and executions can be done.'+
                                     'Please go through the related Execution Trackers.';
                        insert post;	
                        
                    }
                }
            }
            pageReference pageRef = new pageReference('/apex/ExecutionTracker?entityId='+beanObj.entityId+'&tabname=Financial Planning');
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
}