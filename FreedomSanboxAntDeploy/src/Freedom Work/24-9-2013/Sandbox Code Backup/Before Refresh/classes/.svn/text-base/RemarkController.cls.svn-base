//FS0309
public with sharing class RemarkController
{
	public Remarks__c objRemark {get;set;}
	public String strRemark {get;set;}
	public String entityId = '';
	public String selectedType ='';
	//Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
	public Boolean isDisplaySaveButton{get;set;}
	public RemarkController()
	{
		//Code Added on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan : by default true //Sanat
   		isDisplaySaveButton = true;
   		
		entityId = System.currentPageReference().getParameters().get('entityId');
		selectedType = System.currentPageReference().getParameters().get('selectedType');
		
        if(entityId != null && selectedType != null)
	    {
	    	for(Remarks__c obj:[select Remark__c from Remarks__c where entity__c =:entityId and recordtype.Name=:selectedType limit 1])
	    	{
	    		objRemark = obj;
	    		strRemark = objRemark.Remark__c;
	    	}
	    	//Added Code on : 1/2/2013 : Aditi Satpute : Hide Save button for Business Partner Financial Plan //Sanat
		    User objUser = [Select Profile.Name, ProfileId, UserType, Name, Id From User where Id =: UserInfo.getUserId() limit 1];
		    if(objUser.UserType.equalsIgnoreCase('PowerPartner'))
		    {
		    	isDisplaySaveButton = false;
		    }	
	    }
	}
	public void save()
	{
		if(objRemark == null)
    	{
    		objRemark =new Remarks__c();
    		ID RecTypeId = [select id from RecordType where Name=: selectedType][0].id;
    		objRemark.RecordTypeId = RecTypeId;
    		objRemark.Entity__c = entityId;
    		objRemark.Remark__c = strRemark;
    		insert objRemark;
    	}
    	else
    	{
    		objRemark.Remark__c = strRemark;
    		update objRemark;
    	}
	}
	
	//Prajakta Sanap
	//10/08/2012
	/*
Revision History:

	Version     Version Author     Date        Comments
	1.0         --           	   --	  	   Initial Draft
	2.0  		Prajakta Sanap     22/04/2013	Created TestData_Ffreedom which contains all the test data for this test class.				   				 					   
*/
	@IsTest
	static void testSave()
	{
		TestData_Ffreedom testData = new TestData_Ffreedom();
		Account act = testData.initializeAccount();
		//Id clientRecId=RecTypes__c.getInstance('AccountClient').Record_Type_Value__c;
	 	//Account act = new Account(FirstName='ABC',LastName='XYZ',RecordTypeId=clientRecId);
	 	insert act;
	 	
	 	List<RecordType> lstRerecordType =[Select SobjectType,Name,IsActive 
	 								 From RecordType
	 								 where SobjectType =:'Remarks__c' 
	 								 and Name =:'Networth' 
	 								 and IsActive =:True];
	 	if(!lstRerecordType.IsEmpty())
	 	{							 
		 	Remarks__c objRemark = testData.init_Remark(act, lstRerecordType[0].Id);
		 	//Remarks__c objRemark = new Remarks__c (Remark__c = 'Test Remark for Networth',Entity__c = act.Id,RecordTypeId = lstRerecordType[0].Id);
		 	insert  objRemark;
		 	
		 	ApexPages.currentPage().getParameters().put('entityId',act.id);
		 	ApexPages.currentPage().getParameters().put('selectedType','Networth');
		 	RemarkController objRemarkController = new RemarkController();
		 	objRemarkController.save();
	 	}
	 	List<RecordType> lstRerecordTypeCashflow =[Select SobjectType,Name,IsActive 
	 								 From RecordType
	 								 where SobjectType =:'Remarks__c' 
	 								 and Name =:'CashFlow' 
	 								 and IsActive =:True];
	 	if(!lstRerecordTypeCashflow.IsEmpty())
	 	{							 
		 	ApexPages.currentPage().getParameters().put('entityId',act.id);
		 	ApexPages.currentPage().getParameters().put('selectedType','CashFlow');
		 	RemarkController objRemarkController = new RemarkController();
		 	objRemarkController.save();
	 	}
	}
}