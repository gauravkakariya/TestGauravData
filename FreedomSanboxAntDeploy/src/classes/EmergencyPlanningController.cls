/*

	Revision History:
	
    Version     Version Author   Date        	Comments
    1.0         Samruddhi P 	 17/02/2011	  	Initial Draft : EmergencyPlanningController is controller class for 
    											EmergencyPlanningPage in Analysis Section
    2.0  		Manasi 			 28/11/2011     Issue Id: FS0309 : Code to Add Remark in the page
    2.0  		Manasi 			 3/1/2012       Issue Id: FS0395 :  Assigned entityId to strEntity
    2.0  		Manasi 			 7/5/2012       Issue Id: 00001613 : Commented Original COde And ceated new Property ORemark
*/
public class EmergencyPlanningController
{
	//FS0309 new property to show Remark
	public Remarks__c objRemark {get;set;}
	public String strRemark {get;set;}
	public Account objAccount;
	DatabaseSOQL dbQuery;
	//Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
	/** Eternus Solutions       **/
	/** Author  : Manasi Ranade **/
	/** Issue Id: 00001613     	**/
	/** Date    : 7/5/2012 	    **/
	/** Purpose : Commented Original COde
	/****************************************************/
	/*public String Remark
	{
       get{
       		String strSelectedRemarks = '';
       		if(entityId != null)
       		{
    			for(Remarks__c obj : [select Remark__c from Remarks__c where entity__c =:entityId and recordtype.Name=:'EmergencyPlanning' limit 1])
    			{
    				objRemark = obj;
    				strSelectedRemarks = strRemark = obj.Remark__c;
    			}
       		}
       		
            return strSelectedRemarks;
       }set;
   }*/
   /** Eternus Solutions       **/
	/** Author  : Manasi Ranade **/
	/** Issue Id: 00001613     	**/
	/** Date    : 7/5/2012 	    **/
	/** Purpose : Created new Property
	/****************************************************/
    public Remarks__c ORemark
	{
       get{
       		Remarks__c objSelectedRemark;
       		if(entityId != null)
       		{
    			for(Remarks__c obj : [select Remark__c,RichText_Remark__c from Remarks__c where entity__c =:entityId and recordtype.Name=:'EmergencyPlanning' limit 1])
    			{
    				objSelectedRemark = objRemark = obj;
    				//strRemark = obj.Remark__c;
    				obj.RichText_Remark__c =objRemark.RichText_Remark__c;
    			}
       		}
            return objSelectedRemark;
       }set;
    }
    public String entityId {get; set;}
    public EmergencyPlanningBean bean {get; set;}
    EmergencyPlanningServices service;
    
    /**
    * Constructor to initialise the bean class,service class and fetch existing data
    */
    public EmergencyPlanningController()
    {
        entityId = ApexPages.currentPage().getParameters().get('EntityId');
        //objAccount = dbQuery.getEntity(entityId);
        //Code Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   		isDisplaySaveButton = true;
        if(entityId!=null)
        {
            bean= new EmergencyPlanningBean();
            service=new EmergencyPlanningServices(); 
            getAnalysisValues();
            service.getAssetAllocation(entityId,bean.apBeanList);
            service.getInvestmentAssetAllocation(entityId,bean.apBeanList);
            service.getInsuranceAllocation(entityId,bean.apBeanList);
            system.debug('total'+bean.total);
            /** Eternus Solutions       **/
			/** Author  : Manasi Ranade **/
			/** Issue Id: FS0395      	**/
			/** Date    : 3/1/2012 	    **/
			/** Purpose : Assigned entityId to strEntity
			/****************************************************/
            bean.strEntity = entityId;
            //Added Code on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
		    User objBPUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
		    if(objBPUser.UserType.equalsIgnoreCase('PowerPartner'))
		    {
		    	isDisplaySaveButton = false;
		    }	
		    System.debug('=============emergency =====>'+Limits.getQueries());
        }
    }
    
    /**
    * getAnalysisValues() fetches totalMonthlyExpense and noOfMonths
    * param: None 
    * returns:void
    */
    public void getAnalysisValues()
    {
        bean.totalMonthlyExpense=service.getTotalExpenses(entityId);
        if(bean.totalMonthlyExpense==null)
            bean.totalMonthlyExpense=0;
        bean.noOfMonths=(Double)service.getNoOfMonths(entityId);
        if(bean.noOfMonths==null)
            bean.noOfMonths=0;
        system.debug('emergencyFundAmount'+bean.emergencyFundAmount);
    }
    /**
    * save() function saves the action to be taken
    * param: None 
    * returns:pageReference
    */
    public pageReference save()
    {
        system.debug('==page save=='+bean.apBeanList);
        service.save(entityId,bean.apBeanList);
        //FS0309
        saveRemark();
        return null;
    }
	//FS0309
	private void saveRemark()
	{
		system.debug('!!!!!!!!!!! 1');
		if(objRemark == null)
    	{
    		system.debug('!!!!!!!!!!! 1.1');
    		objRemark =new Remarks__c();
    		ID RecTypeId = [select id from RecordType where Name= 'EmergencyPlanning'][0].id;
    		system.debug('!!!!!!!!!!! 1.2 selectedType:'+RecTypeId);
    		objRemark.RecordTypeId = RecTypeId;
    		system.debug('!!!!!!!!!!! 1.3');
    		objRemark.Entity__c = entityId;
			system.debug('!!!!!!!!!!! 1.4');
    		//objRemark.Remark__c = strRemark;
    		objRemark.RichText_Remark__c =objRemark.RichText_Remark__c;
    		system.debug('!!!!!!!!!!! 1.5');
    		insert objRemark;
    		system.debug('!!!!!!!!!!! 1.6');
    	}
    	else
    	{
    		system.debug('!!!!!!!!!!! 2 :Remark:'+strRemark);
    		//objRemark.Remark__c = strRemark;
    		objRemark.RichText_Remark__c =objRemark.RichText_Remark__c;
    		update objRemark;
    	}
    	system.debug('!!!!!!!!!!! 3');
	}
}