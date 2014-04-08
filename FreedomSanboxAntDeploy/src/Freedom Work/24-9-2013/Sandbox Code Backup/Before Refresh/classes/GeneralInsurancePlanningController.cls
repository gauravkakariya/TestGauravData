/*
	Revision History:
	
    Version     Version Author   Date        	Comments
    1.0         Samruddhi P 	 18/02/2011	  	Initial Draft : GeneralInsurancePlanningController is controller class for 
    											GeneralInsurancePlanningPage in Analysis Section
    2.0  		Manasi 			 28/11/2011     Issue Id: FS0309 : Code to Add Remark in the page
    2.0  		Manasi 			 16/01/2012     Issue Id: 00001449 : Added functions to add or remove Insurances
    3.0			Mahesh			 27/4/2012		Case No : 00001611 : Added the property : getPolicyType() : To show Policy Type picklist in under 
    											Suggested Medical Insurancne section on General Insurance Planning Page
    3.0			Mahesh			 07/05/2012		Case No : 00001613 : Commented Original Code
*/
public class GeneralInsurancePlanningController
{
	//FS0309 new property to show Remark
	public Remarks__c objRemark {get;set;}
	/** Eternus Solutions  **/
	/** Author  : Manasi Ranade	**/
	/** Issue Id: 00001613      **/
	/** Date    : 07/05/2012 	**/
	/** Purpose : Commented Original Code**/
	/****************************************************/
	//public String strRemark {get;set;}
    public String entityId {get; set;}
    public GeneralInsurancePlanningBean bean {get; set;}
    GeneralInsurancePlanningService service {get; set;}
    //Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
    /** Eternus Solutions  **/
	/** Author  : Manasi Ranade	**/
	/** Issue Id: 00001449      **/
	/** Date    : 16/01/2012 	**/
	/** Purpose : Code to add or remove Insurances**/
	/****************************************************/
    public InsuranceServices InsuranceServicesObj {get; set;}
    
    /**
    * @Description: Constructor to initialise the bean
    * @param: None
    */
    public Static String eId {get;set;}
    public GeneralInsurancePlanningController()
    {
    	//Code Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   		isDisplaySaveButton = true;
   		
        entityId = eId == null ? ApexPages.currentPage().getParameters().get('EntityId') : eId;
        //Error.debugLog('----------------- GI entityId---------------'+entityId);
        if(entityId!=null)
        {
        	//FS0309
        	list<Remarks__c> lstRemark = [select Remark__c from Remarks__c where entity__c =:entityId and recordtype.Name=:'GeneralInsurancePlanning' limit 1];
        	if(lstRemark != null && lstRemark.size() > 0)
        	{
        		objRemark = lstRemark[0];
        		/** Eternus Solutions  **/
				/** Author  : Manasi Ranade	**/
				/** Issue Id: 00001613      **/
				/** Date    : 07/05/2012 	**/
				/** Purpose : Commented Original Code**/
				/****************************************************/
        		//strRemark = objRemark.Remark__c;
        	}
        	else
        		objRemark = new Remarks__c();
            service=new GeneralInsurancePlanningService();
            bean=new GeneralInsurancePlanningBean();
            /** Eternus Solutions  **/
			/** Author  : Manasi Ranade	**/
			/** Issue Id: 00001449      **/
			/** Date    : 16/01/2012 	**/
			/** Purpose : Code to add or remove Insurances**/
			/****************************************************/
            InsuranceServicesObj = new InsuranceServices();
            bean.accountList=service.getFamilyDetails(entityId);
            getInsurances();
            
            //Added Code on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
		    User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
		    if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
		    {
		    	isDisplaySaveButton = false;
		    }	
        }
        //Error.debuglog('-----------------Limit GI--------'+Limits.getQueries());
    }
    
    /**
    * @getInsurances() function gets insurance records
    * @params:None
    * @Return Type:void
    */
    public void getInsurances()
    {
        bean = service.getdbRecords(entityId,bean);
        system.debug('===getdbRecords====='+bean.suggestedMedInsurance+bean.suggestedAssetInsurance+bean.accountList);

        if(bean.suggestedMedInsurance!=null && bean.suggestedMedInsurance.size() <  bean.accountList.size())
        {
            for(Integer i=bean.suggestedMedInsurance.size(); i<bean.accountList.size(); i++ )
                bean.suggestedMedInsurance.add(new Insurance__c());
        }

        if(bean.suggestedAssetInsurance!=null && bean.suggestedAssetInsurance.size() <  bean.accountList.size())
        {
            for(Integer i=bean.suggestedAssetInsurance.size(); i<bean.accountList.size(); i++ )
                bean.suggestedAssetInsurance.add(new Insurance__c());
        }
        System.Debug('====Insurances===='+bean.suggAssetList+bean.suggMedList);
    }
    
    /**
    * @getInsuredItems() function populates values of Insured picklist for Suggested Insurance Table
    * @params:None
    * @Return Type:List<SelectOption>
    */
    public List<SelectOption> getInsuredItems() 
    {
        return service.getInsuredItems(bean.accountList);    
    }
    
    /**
    * @getPolicyTypeItems() function populates values of Policy Type picklist for Asset Insurance Table
    * @params:None
    * @Return Type:List<SelectOption>
    */
    public List<SelectOption> getPolicyTypeItems() 
    {
        return service.getPolicyTypeItems();
    }

	/** Eternus Solutions       	**/
	/** Author  : Mahesh Hirugade	**/
	/** Case No : 00001611			**/
	/** Date    : 27/4/2012 		**/
	/** Purpose : Added the property : getPolicyType() : To show Policy Type picklist in under Suggested Medical Insurancne section on General Insurance Planning Page 
	/****************************************************/
    public List<SelectOption> getPolicyType()
    {
    	return service.getMedicalPolicyTypeItems();
    }
        
    /**
    * @save() function saves suggested insurances
    * @params:None
    * @Return Type:pageReference 
    */
    public pageReference save()
    {
        Boolean successFlag;
        //FS0309
        saveRemark();
        pageReference pageRef=new pageReference('/apex/GeneralInsurancePlanningPage?entityId='+entityId+'&tabname=Financial Planning');
        List<Insurance__c> mInsuranceList = new List<Insurance__c>();
        for(Insurance__c insurance: bean.suggestedMedInsurance)
        {
            if(!GeneralInsurancePlanningBean.isRowEmpty(insurance))
            {
                mInsuranceList.add(insurance);
            }
        }    
        List<Insurance__c> aInsuranceList = new List<Insurance__c>();
        
        for(Insurance__c insurance: bean.suggestedAssetInsurance)
        {
            if(!GeneralInsurancePlanningBean.isRowEmpty(insurance))
            {
                aInsuranceList.add(insurance);
            }
        }
        
        successFlag=service.saveRecords(entityId,mInsuranceList,aInsuranceList );
        if(successFlag)
        {
            pageRef.setRedirect(true);
            return pageRef; 
        }
        return null;
    }
    
    /**
    * @cancel() function clears suggested insurances
    * @params:None
    * @Return Type:pageReference 
    */ 
    public pageReference cancel()
    {
        pageReference pageRef=new pageReference('/apex/GeneralInsurancePlanningPage?entityId='+entityId+'&tabname=Financial Planning');
        pageRef.setRedirect(true);
        return pageRef;
    }
	//FS0309
    private void saveRemark()
	{
		ID RecTypeId = [select id from RecordType where Name= 'GeneralInsurancePlanning'][0].id;
    	objRemark.RecordTypeId = RecTypeId;
    	objRemark.Entity__c = entityId;
		objRemark.Remark__c = objRemark.Remark__c;
    	Database.Upsertresult Sr = Database.upsert(objRemark);
    	System.debug('Save Result if creating new ===>'+Sr);
	}
	/** Eternus Solutions  **/
	/** Author  : Manasi Ranade	**/
	/** Issue Id: 00001449      **/
	/** Date    : 16/01/2012 	**/
	/** Purpose : Added functions to add or remove Insurances **/
	/****************************************************/
	public void AddNewAssetInsuranceSuggestedRow()
    {
    	bean.suggestedAssetInsurance.add(new Insurance__c());
    }
    public void AddNewMedicalInsuranceSuggestedRow()
    {
    	bean.SuggestedMedInsurance.add(new Insurance__c());
    }
    public void RemoveSuggestedAssetInsurance()
    {
       InsuranceServicesObj.removeRecords(bean.suggestedAssetInsurance);
    }
    public void RemoveSuggestedMedInsurance()
    {
       InsuranceServicesObj.removeRecords(bean.SuggestedMedInsurance);
       system.debug('-------InsuranceServicesObj in remove---'+InsuranceServicesObj);
    }
}