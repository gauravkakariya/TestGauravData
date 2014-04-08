/**
 * @Author: Sandip C
 * @Description:ApprovedPlanController is controller class for ApprovedPlan.page w
 */
 
public class ApprovedPlanController
{
    ApprovedPlanServices serviceObj;
    //Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
    //FS0290
    /** Eternus Solutions       **/
	/** Author  : Manasi Ranade **/
	/** Issue Id: FS0290      	**/
	/** Date    : 24/11/2011,20/12/2011**/
	/** Purpose : 1. Check Whether ET is Generated or not.If it Exists for selected entity then hide 
				  'Approved' button.Use blnIsETAlreadyGenerated to check the same
				  2. Added Property to display EntityName,OwnerName,Date of Creation on Approved Action Plan PDF
	/****************************************************/
    public Boolean blnIsETAlreadyGenerated{get;set;}
    public String strEntityName {get;set;}
    public String strOwnerName {get;set;}
    public String strGeneratedDate {get;set;}
    public ApprovedPlanBean beanObj {get;set;}
	//==========Action-plan 20-9-2012========
	public Boolean isFreedomUser{get;set;}
	public Boolean isFreedomUserProp{get;set;}
	public Account Partnerlogo{get;set;}
	public Account Logo_partner{get;set;}
	public Id AccOwnerId{get;set;}
	//========================================
    public ApprovedPlanController()
    {
       //Code Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   	   isDisplaySaveButton = true;
       serviceObj = new ApprovedPlanServices();
       beanObj = new  ApprovedPlanBean();
       beanObj.entityId=Apexpages.currentPage().getParameters().get('entityId');
       
       
       //Added Code on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	   User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
	   if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
	   {
	   		isDisplaySaveButton = false;
	   }	
       /** Eternus Solutions       **/
	   /** Author  : Manasi Ranade **/
	   /** Issue Id: FS0290      	**/
	   /** Date    : 24/11/2011 	**/
	   /** Purpose : Fetch from Database and Check Whether ET is Generated or not.
	   /****************************************************/
       /*DatabaseSOQL objDbSOQL = new DatabaseSOQL();
      	 Account objAcc;
       */
       /*if(beanObj.entityId != null)
	       objAcc = objDbSOQL.beanObjgetEntity(beanObj.entityId);*/
	       
       serviceObj.getRecType(beanObj);
       //FS0290
       blnIsETAlreadyGenerated = false;
       serviceObj.getFamilyDetails(beanObj);
       if(beanObj.accList != null)
	   {
	   	   for(Account objAccout : beanObj.accList)
	   	   {
	   	   		if(objAccout.Id == beanObj.entityId)
	   	   		{
   	        		AccOwnerId = objAccout.OwnerId; //Added for Partner Portal implementation Use ,Date : 31/7/12
        			system.debug('***AccOwnerId : in if****'+AccOwnerId);
	   	   			blnIsETAlreadyGenerated = objAccout.IsExecutionTrackerGenerated__c;
	   	   			strEntityName = objAccout.FirstName + ''+ objAccout.LastName;
	   	   			strOwnerName = objAccout.Owner.Name;
	   	   			strGeneratedDate = system.NOW().format('dd-MM-yyyy');
	   	   		}
	   	   }	
	   	   //blnIsETAlreadyGenerated = objAcc.IsExecutionTrackerGenerated__c;
	   }
       system.debug('@@@@@@@@@@@ 4:');
       serviceObj.getGoals(beanObj);
       system.debug('@@@@@@@@@@@ 5:');
       serviceObj.getAssetAllocation(beanObj);
       system.debug('@@@@@@@@@@@ 6:');
       beanObj.investment = serviceObj.getMFInvestmentAsset(beanObj.accList);
       beanObj.approvedPlanList = serviceObj.getdbApprovedPlans(beanObj.accList);
       system.debug('@@@@@@@@@@@ 7:');
       serviceObj.getCurMFLumpSumApprovedPlans(beanObj);
       system.debug('@@@@@@@@@@@ 8:');
       serviceObj.getCurMFSIPApprovedPlans(beanObj);
       system.debug('@@@@@@@@@@@ 9:');
       serviceObj.getSuggMFSIPApprovedPlans(beanObj);
       system.debug('@@@@@@@@@@@ 10:');
       serviceObj.getSuggMFLumpApprovedPlans(beanObj);
       system.debug('@@@@@@@@@@@ 11:');
       
       beanObj.giList = serviceObj.getGenerelInsurance(beanObj.accList);
       system.debug('@@@@@@@@@@@ 12:');
       if(beanObj.giList != null && beanObj.giList.size()>0){
           beanObj.isGeneralInsExist = true;
       }
       system.debug('@@@@@@@@@@@ 13:');
       beanObj.liList = serviceObj.getLifeInsurance(beanObj.accList);
       system.debug('@@@@@@@@@@@ 14:');
       if(beanObj.liList != null && beanObj.liList.size()>0){
           beanObj.isLifeInsExist = true;
       }
       system.debug('@@@@@@@@@@@ 15:');
       serviceObj.getApprGenerelInsurance(beanObj);
       system.debug('@@@@@@@@@@@ 16:');
       serviceObj.getApprLifeInsurance(beanObj);
       system.debug('@@@@@@@@@@@ 17:');
       serviceObj.PrpeareSummary(beanObj);
       system.debug('@@@@@@@@@@@ 18:');
       serviceObj.PrpeareSuggested(beanObj);
       system.debug('@@@@@@@@@@@ 19:');
       
       //Code Added for Partner Portal related changes i.e Logo,Name etc.
       //Date :31/07/12  Code Added By :Aditi
       Contact con;
       Account acc;
       system.debug('******AccOwnerId : in Approved Paln*******'+AccOwnerId);
       if(AccOwnerId != null)
       {
       		User user=[select Id,Name,Email,ProfileId,ContactId,Profile.Name from User where Id=:AccOwnerId];
			if(user.ContactId==null)
			{
				isFreedomUser = true;
				system.debug('***********freedom');
			}
			else //Else is for Partner Portal
			{
				Id contactId = user.ContactId;
				con=[select AccountId from Contact where id =: user.ContactId];
				acc=[select Id, Logo__c, Email_ID__c, Company_Address__c, Phone, Name, Channel_Manager__r.Email from account where id =: con.AccountId];
				Partnerlogo = acc;
				isFreedomUser = false;
			}
        }
    }
    
    /**
    * @Description: save the record in the Approved plan Object and Insurence object
    * param: None 
    * return type: PageReference 
    */ 
    public pageReference upsertData()
    {
        //original code
        //serviceObj.upsertData(beanObj);
        Double dblAssetAmount = 0,dblActionAmount = 0,dblSIPChange = 0,dblCurrentSIP = 0;
        Boolean blnIsActionAmountGreater = false,blnIsSIPChangeGreater = false;
        String strSIPScheme ='',strLumpsumScheme ='';
        /** Eternus Solutions       **/
		/** Author  : Manasi Ranade **/
		/** Issue Id: FS0290      	**/
		/** Date    : 21/12/2011 	**/
		/** Purpose : Added validation related to Amount and Action amount
		/****************************************************/
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
        		//break;
        	}
        }
        //Remove the SIP related check
        /*for(ApprovedPlanBean.CurrentMFSIP tmpObj: beanObj.currentMFSIPList)
        {
        	if(tmpObj.currentSIP != null)
	        	dblCurrentSIP = tmpObj.currentSIP;
        	if(tmpObj.SIPChange != null)
	        	dblSIPChange = tmpObj.SIPChange;
        	if(dblCurrentSIP < dblSIPChange)
        	{
        		blnIsSIPChangeGreater = true;
        		if(strSIPScheme == '')
        			strSIPScheme = tmpObj.schemeName;
        		else
        			strSIPScheme = strSIPScheme + ',' + tmpObj.schemeName;
        		//break;
        	}
        }*/
        //if(blnIsActionAmountGreater || blnIsSIPChangeGreater){
        if(blnIsActionAmountGreater)
        {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ActionAmountGreater+'. For the schemes: '+strLumpsumScheme));
            /*if(blnIsActionAmountGreater)
            {
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.ActionAmountGreater+'. For the schemes: '+strLumpsumScheme));
            }
            if(blnIsSIPChangeGreater)
            {
            	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.SIPChangeGreater+'. For the schemes: '+strSIPScheme));
            }*/
            return null;
        }
        //if(!blnIsActionAmountGreater && !blnIsSIPChangeGreater)
       	//{	
       		serviceObj.upsertData(beanObj);
       		pageReference pageRef = new pageReference('/apex/ApprovedPlan?entityId='+beanObj.entityId+'&tabname=Financial Planning');
       		return pageRef ;
       	//}
        //pageRef.setRedirect(true);
        //return null;    
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
   
   public pageReference Approved()
   {
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
   public pageReference RemoveRecordSIP()
   {
        serviceObj.RemoveRecordSIP(beanObj);
        return null;
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
        Schema.DescribeFieldResult field = Schema.sObjectType.Approved_Action_Plan__c.fields.SIP_Action__c;
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
        Schema.DescribeFieldResult field = Schema.sObjectType.Approved_Action_Plan__c.fields.Lumpsum_Action__c;
        List<Schema.PicklistEntry> picklist = field.getPicklistValues();
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
        options.add(new selectOption('Debt', 'Debt'));
        options.add(new selectOption('Equity', 'Equity'));
        options.add(new selectOption('Gold', 'Gold'));        
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
    * @Description: Redirect to Summary action plan
    * param: None 
    * return type: List<selectOption>
    */ 
     public pageReference SummaryActionPlan()
     {
        pageReference pageRef = new pageReference('/apex/SummaryActionPlan?entityId='+beanObj.entityId+'&tabname=Financial Planning');
        return pageRef ;
    }
}