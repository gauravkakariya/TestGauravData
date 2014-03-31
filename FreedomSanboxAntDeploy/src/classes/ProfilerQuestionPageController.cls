/*
	Revision History:
    Version     Version Author    Date          Comments
	1.0			Prajakta Sanap	 01/01/2014   1. Modified Description controller class for ProfilerQuestionPage
	
*/


public class ProfilerQuestionPageController
{
	public String EntityId {get;set;}
	public Integer fScore {get;set;}
	public String riskProfile {get;set;}
	public List<Account> lstAccount{get;set;}
	public Account objAccount{get;set;}
	public Boolean isProfilerOutput {get;set;}
	public boolean displayPopup {get; set;}
	public boolean closePopup {get; set;}  
	public List<Goal__c> newGoalList {get; set;}
	public List<Goal__c> listGoal{get; set;}
	public set<String> setGoalProfile {get; set;}
	map<Id, String> mapGoalIdToGoalProfile = new map<Id, String>();
	
	//To get the remark of Risk Profiler
	//public String selectedType ='';
	public Remarks__c objSaveRemark {get;set;}
	public String strRemark {get;set;}
	public Remarks__c objRemark
	{
       get{
       		Remarks__c objRemarks;
       		if(entityId != null)
       		{
       			
    			for(Remarks__c objRemark : [select Remark__c, RichText_Remark__c  
    										from Remarks__c where entity__c =:EntityId and recordtype.Name=:'RiskProfiler' limit 1])
    			{
    				objRemarks = objRemark;	
    			}
       		}
            return objRemarks;
       }set;
    }
	
	//constructor 
    public ProfilerQuestionPageController()
    {
    	EntityId = System.currentPageReference().getParameters().get('EntityId');
    	closePopup = false;
    	displayPopup = false;
    	//selectedType = System.currentPageReference().getParameters().get('selectedType');
    	//system.debug('-----------selectedType------------'+selectedType);
    	
    	if(EntityId != null)
	    {
	    	for(Remarks__c obj:[select Remark__c, RichText_Remark__c  
	    						from Remarks__c where entity__c =:entityId and recordtype.Name=:'RiskProfiler' limit 1])
	    	{
	    		objSaveRemark = obj;
	    		strRemark = objSaveRemark.RichText_Remark__c;
	    	}
	    }
	    system.debug('-----------objSaveRemark------------'+objSaveRemark);
    	
    	if(EntityId != null)
    	{
	    	objAccount = [Select Id, Finametrica_Score__c, Risk_profile__c 
	    				  from Account where Id =: EntityId];
	    	system.debug('-------objAccount--------'+objAccount);
	    	
    	}
    	
    	if(objAccount != null)
    	{
    		fScore = Integer.valueOf(objAccount.Finametrica_Score__c);
    		system.debug('-------fScore--------'+fScore);
    	}
    	
    	if(objAccount != null && objAccount.Finametrica_Score__c != null)
    	{
    		//closePopup = true;
	       	if(objAccount.Finametrica_Score__c > 0 && objAccount.Finametrica_Score__c < 35)
	       	{
	       		objAccount.Risk_profile__c = 'Low';
	       		displayPopup = false;
	       		system.debug('-------isProfilerOutput---1-----'+displayPopup);
	       	}
	       	else if(objAccount.Finametrica_Score__c > 34 && objAccount.Finametrica_Score__c < 65)
	       	{
	       		objAccount.Risk_profile__c = 'Medium';
	       		displayPopup = false;
	       		system.debug('-------isProfilerOutput----2----'+displayPopup);
	       	}
	       	else if(objAccount.Finametrica_Score__c > 65 && objAccount.Finametrica_Score__c < 101)
	       	{
	       		objAccount.Risk_profile__c = 'High';
	       		displayPopup = false;
	       		system.debug('-------isProfilerOutput---3-----'+displayPopup);
	       	}
    	}
    	riskProfile = objAccount.Risk_profile__c;							
    }
	
	public PageReference save()
    {
       	if(objAccount != null)
    	{
	       	objAccount.Finametrica_Score__c = (fScore != null) ? Decimal.valueOf(fScore) : null;
	       	
	       	if(objAccount.Finametrica_Score__c > 0 && objAccount.Finametrica_Score__c < 35)
	       	{
	       		objAccount.Risk_profile__c = 'Low';
	       		displayPopup = true;
	       		system.debug('-------isProfilerOutput---5-----'+isProfilerOutput);
	       	}
	       	else if(objAccount.Finametrica_Score__c > 34 && objAccount.Finametrica_Score__c < 65)
	       	{
	       		objAccount.Risk_profile__c = 'Medium';
	       		displayPopup = true;
	       		system.debug('-------isProfilerOutput---6----'+displayPopup);
	       	}
	       	else if(objAccount.Finametrica_Score__c > 65 && objAccount.Finametrica_Score__c < 101)
	       	{
	       		objAccount.Risk_profile__c = 'High';
	       		displayPopup = true;
	       		system.debug('-------isProfilerOutput--7-----'+displayPopup);
	       	}
	       	else if(objAccount.Finametrica_Score__c == null || objAccount.Finametrica_Score__c == 0)
	       	{
	       		objAccount.Risk_profile__c = '';
	       		displayPopup = true;
	       		system.debug('-------isProfilerOutput--8-----'+displayPopup);
	       	}
	       	else if(objAccount.Finametrica_Score__c < 0 || objAccount.Finametrica_Score__c > 100)
	       	{
	       		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter valid score between 0 to 100.'));
	       		//error.debugLog('-----0 to 100-------'+objAccount.Finametrica_Score__c);
            	return null;
	       	}
	       	system.debug('-------objAccount.Finametrica_Score__c--------'+objAccount.Finametrica_Score__c);
	       	
	       	update objAccount;
	       		       	
    	}
    	
    	if(objSaveRemark == null)
    	{
    		objSaveRemark = new Remarks__c();
    		ID RecTypeId = [select id from RecordType where Name=: 'RiskProfiler'][0].id;
    		system.debug('-----------RecTypeId-----rrrrr-------'+RecTypeId);
    		objSaveRemark.Entity__c = entityId;
    		objSaveRemark.RichText_Remark__c = strRemark;
    		system.debug('-----------objSaveRemark-----yyy-------'+objSaveRemark);
    		if(RecTypeId != null)
    			objSaveRemark.RecordTypeId = RecTypeId;
    		insert objSaveRemark;
    		
    	}
    	else
    	{
    		objSaveRemark.RichText_Remark__c = strRemark;
    		system.debug('-----------objSaveRemark------else------'+objSaveRemark);
    		update objSaveRemark;
    	}
    	
    	listGoal = [Select Id, Entity__c, Risk_Profile__c, Description__c, SelectedGoalProfile__c,
									SelectedGoalProfile__r.Name, Goal_Type__c, Cost_of_Goal_Annual__c
									from Goal__c 
        						 	where Entity__c =: EntityId and Goal_Type__c != 'Emergency Fund'];
        system.debug('--------listGoal------1----'+listGoal);
        riskProfile = objAccount.Risk_profile__c;
        for(Goal__c objGoal : listGoal)
        {
        	mapGoalIdToGoalProfile.put(objGoal.Id, objGoal.SelectedGoalProfile__r.Name);
        }
        system.debug('--------mapGoalIdToGoalProfile---------'+mapGoalIdToGoalProfile);
        
    	if(!listGoal.isEmpty())
    		return null;
    	else
    	{
    		pageReference pageRef = new pageReference('/apex/ProfilerQuestionPage?entityId='+EntityId+'&tabname=Financial Planning');
			pageRef.setRedirect(true);
			return pageRef;
    	}
    }
    
    public pageReference saveRiskProfileForGoals()
	{
        newGoalList = new List<Goal__c>();
        
        List<Goal_Profile__c> lstGoalProfile = [Select Risk_Type__c, Name, Id, 
					        						Goal_Profile_Type__c, Account__c 
					        						From Goal_Profile__c
					        						where Risk_Type__c =: objAccount.Risk_profile__c];
        system.debug('--------lstGoalProfile---------'+lstGoalProfile);
        
        map<String, Id> mapGoalProfileNameToId = new map<String, Id>();
        
        for(Goal_Profile__c objGP : lstGoalProfile)
        {
        	mapGoalProfileNameToId.put(objGP.Name, objGP.Id);
        }
        
        for(Goal__c objGoal : listGoal)
        {
        	if(objAccount.Risk_Profile__c != null)
        	{
        		system.debug('--------objGoal.Risk_Profile__c----------'+objGoal.Risk_Profile__c);
        		objGoal.Risk_Profile__c = objAccount.Risk_profile__c;
        		if(mapGoalIdToGoalProfile.containsKey(objGoal.Id))
        		{
        			String GPName =  mapGoalIdToGoalProfile.get(objGoal.Id);
        			
        			if(mapGoalProfileNameToId.containsKey(GPName))
	        		{
	        			objGoal.SelectedGoalProfile__c = mapGoalProfileNameToId.get(GPName);
	        		}
        		}
        		newGoalList.add(objGoal);
        	}
        }
        system.debug('--------newGoalList----------'+newGoalList);
        
        if(!newGoalList.isEmpty())
        {
        	update newGoalList;
        }
        
        listGoal = [Select Id, Entity__c, Risk_Profile__c, Description__c,
									SelectedGoalProfile__r.Name, Goal_Type__c, Cost_of_Goal_Annual__c
									from Goal__c 
        						 	where Entity__c =: EntityId and Goal_Type__c != 'Emergency Fund'];
        system.debug('--------listGoal-----2-----'+listGoal);
        riskProfile = objAccount.Risk_profile__c;
        closePopup = true;
        return null;
	}
    
    public PageReference cancelPopup()
	{
	 	displayPopUp = false;
	 	pageReference pageRef = new pageReference('/apex/ProfilerQuestionPage?entityId='+EntityId+'&tabname=Financial Planning');
		pageRef.setRedirect(true);
		return pageRef;
	}
}



/*
    public profilerQuestionBean questionBean{get;set;}
    public ProfilerQuestionService questionService{get;set;}
    public FamilyMemberInfoBean fmBean{get;set;}
    public FamilyMemberInfoService fmInfoService{get;set;}
 	//Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
	
    //constructor 
    
    
    public ProfilerQuestionPageController()
    {
    	//Code Added on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   		isDisplaySaveButton = true;
       	questionBean=new profilerQuestionBean ();
       	questionService= new ProfilerQuestionService ();
       	questionBean.questionInstanceList=new  list<profilerQuestionBean.ProfileQuestionWrpper>();
       	questionBean.currentEntity=System.currentPageReference().getParameters().get('EntityId');
       	fmBean=new FamilyMemberInfoBean();
       	fmInfoService=new FamilyMemberInfoService();
       	fmInfoService.isCostomerProfile(fmBean);
       	questionService.initQuestionList(questionBean);
       	
       	//Added Code on : 31/1/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
        User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
        if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
        {
        	isDisplaySaveButton = false;
        }
    }
    
    
    //This method is used to save the answers of an entity in EntityProfilerQuestion object
    //and navigates  to the profilerOutputPage in salesforce
    
    public PageReference save()
    {
        //questionService.save(questionBean);
       	PageReference pr;
        if(fmBean.isCustomer)
        {
            pr=null;
        }
        else
        {
        	pr =new PageReference('/apex/ProfilerOutputPage?entityId='+questionBean.currentEntity+'&tabname=Financial Planning');
        }
        return pr;
    }
    
    public void cancel()
    {
       //questionService.resetAnswer(questionBean);
    }
	*/